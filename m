Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891442789B0
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 15:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgIYNeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 09:34:44 -0400
Received: from mail-vi1eur05on2050.outbound.protection.outlook.com ([40.107.21.50]:64832
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728121AbgIYNel (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 09:34:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVAIF5rCdsmH2FMAOqSGNkN8EyoG7N8LAhBQ5/OXUgY=;
 b=eCApkGV20jPycZgzG5gBz6rlMRfcroh9og5Yxv4RGK/8MPYBaKZjKA5wkXp70iwz6Ku1Fdx3yy87mNq2kyajxASr5nMtKCAxJxX77TnWzE7IEl1kCW/1A3LB/cyMrYVtDbit2I3QphjijMLNOBRmLGNhAtuAsuMquBCk/elWUVw=
Received: from MR2P264CA0014.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:1::26) by
 DB8PR08MB4076.eurprd08.prod.outlook.com (2603:10a6:10:b0::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3391.14; Fri, 25 Sep 2020 13:34:36 +0000
Received: from VE1EUR03FT029.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:500:1:cafe::3a) by MR2P264CA0014.outlook.office365.com
 (2603:10a6:500:1::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend
 Transport; Fri, 25 Sep 2020 13:34:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT029.mail.protection.outlook.com (10.152.18.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.21 via Frontend Transport; Fri, 25 Sep 2020 13:34:35 +0000
Received: ("Tessian outbound 7fc8f57bdedc:v64"); Fri, 25 Sep 2020 13:34:35 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: d5dbce251bde2da2
X-CR-MTA-TID: 64aa7808
Received: from 0adaff684361.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id EFDAB44F-DD2F-4BCB-B494-37A612348CB0.1;
        Fri, 25 Sep 2020 13:34:29 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 0adaff684361.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 25 Sep 2020 13:34:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ea8JLgV3CNyPTy4LU7qO8xZysA8hKtpJbKbSpqNrRc6INiNHCe0gVPaWJcwfdaR3K0wVB/RMz7MmGdgN3oPl2Wsd7oUTqYSE01Mj8sKXml+SBtdFMHnNJV1ipyHT9tAf/IWFz8VfEcwZomEPd14AoDQSLZiLFua8Z3koL3xTMFYpfUjPhJIc/qnOMZtmeu3CQAPOhWjUtnCva6UYlQ/hJVLS6KUuGtDlug8IlbXPC5QMIduLATXicO6s/nhgz+gS0eeL6q0nTxOUrhkmKj/Cf67BU8RwxIkijWPlf6r8yZlgsO8yDRegwoNc6XtPwibSW/AHpPVERMgjQHLprLj6Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVAIF5rCdsmH2FMAOqSGNkN8EyoG7N8LAhBQ5/OXUgY=;
 b=C/Zx0dXQj6h1AtTW39fOCwG8K4Havgv2Wv4kt6ffPxSh7nypL7lM75v+r/AUUEWjzdweYxViO5kehKzC3U0H/g69Ck6E1L1tIPGlQcoqDET3Pgzmh8Awon26Gwfr1HCkm4r2dV92Nt+7XDmwP1Ng9fxPGg1aXknHq20+pEUdSi743dfoB+miUCmufvXAWBtDzhQ2YSo+313UOcwvKDQwn5bht//JWwaVNEdxkvlk+Ml4YBTGnWe7yHSg/qrbBm6+Apt+/KptwDsdeVMzoL/1LkR/7DicWNZVgu9TIrz4JY70ucvywmPUpIvv6fmO9hcls9KsGbsxpBrw3xMc5WVsgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVAIF5rCdsmH2FMAOqSGNkN8EyoG7N8LAhBQ5/OXUgY=;
 b=eCApkGV20jPycZgzG5gBz6rlMRfcroh9og5Yxv4RGK/8MPYBaKZjKA5wkXp70iwz6Ku1Fdx3yy87mNq2kyajxASr5nMtKCAxJxX77TnWzE7IEl1kCW/1A3LB/cyMrYVtDbit2I3QphjijMLNOBRmLGNhAtuAsuMquBCk/elWUVw=
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
Received: from AM6PR08MB4007.eurprd08.prod.outlook.com (2603:10a6:20b:a1::29)
 by AM5PR0801MB2052.eurprd08.prod.outlook.com (2603:10a6:203:4b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Fri, 25 Sep
 2020 13:34:27 +0000
Received: from AM6PR08MB4007.eurprd08.prod.outlook.com
 ([fe80::9904:4b6c:dfa2:e49f]) by AM6PR08MB4007.eurprd08.prod.outlook.com
 ([fe80::9904:4b6c:dfa2:e49f%6]) with mapi id 15.20.3412.022; Fri, 25 Sep 2020
 13:34:27 +0000
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org, nd <nd@arm.com>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
From:   Grant Likely <grant.likely@arm.com>
Message-ID: <f7d2de9c-a679-1ad2-d6ba-ca7e2f823343@arm.com>
Date:   Fri, 25 Sep 2020 14:34:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0162.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::30) To AM6PR08MB4007.eurprd08.prod.outlook.com
 (2603:10a6:20b:a1::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.16.147] (188.28.154.24) by LO2P265CA0162.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:9::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21 via Frontend Transport; Fri, 25 Sep 2020 13:34:24 +0000
X-Originating-IP: [188.28.154.24]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4933e418-f3e9-461f-93a5-08d86157be9e
X-MS-TrafficTypeDiagnostic: AM5PR0801MB2052:|DB8PR08MB4076:
X-LD-Processed: f34e5979-57d9-4aaa-ad4d-b122a662184d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR08MB407626FD875341C51C211E0C95360@DB8PR08MB4076.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: mILYGDaQOasOdl7HFQsOCrn7F/gFvdX83EFwCuuJA+V72RSo5fP/xXeqVbc5WxfMnTCt7QDOWrDFNKShxrL++ovRxJrJSWpD209S5mDc2/Iv9UeLURC6uEL74O1rqHLVX/i3I2ftInKJtIsICVXezrfOksSz0zHSS4xaReos4D2skCO1PS8yCOvnry4naQ4a9JwJ0eKhUG8iK7j3cMaOchsUZoRF226bMUIi8KCtBWyMoOzJ3ncpXGYhe4xERdIfyv085xqSYOOdGyIC3vVvxtGuiHSG4caDvf6hswU1QV3CrF8JTeza3ADQse0Ho+S34fdbbwyjD+Hg3cFxNci2/kC06OmbmG5zJ17dF0TpLbzNElblroGpU6DMxTAjqEOH+ud4ZYT+9ePif3tU5ie1KVFiqEYD/hOy6s1SIggjYxXfv+qWcAkFLAKJ5MYO5C9V
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4007.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(53546011)(16576012)(36756003)(110136005)(4326008)(478600001)(52116002)(6666004)(31686004)(44832011)(86362001)(55236004)(8676002)(16526019)(31696002)(2906002)(186003)(26005)(8936002)(5660300002)(2616005)(7416002)(66946007)(6486002)(956004)(66556008)(316002)(66476007)(921003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1mNVBt5eYV59tXDUIObggu2vD9rMScycouqmE0j0NLO0zC7xxdmlfvqs6/KWs9lkOJc/SBV/RYqEJXm3mn96YLhNBGdxsyzyGyqY57xUpOd855d2jJ+MDWJUE+dVQEQ43trx5xjBhr1Rc1IWH5SwvNRYTHHhndbcsLHA/WO8ieWiL5GosIwuBkSZf/LZ0OFoFjl75kW2FARd1Cs19JqXKF5IdSBnOrZdplVJJHZDBDVnJ+02k0Kmvx0c4YjRnYrEzbKS7o7WqW4ktqTUrvU380ZVzzUjj8s/GTVwjiZAfHPgrpjdYvc1EoKv/jm/ANYUlkyEWVW7Qupo6swwSHKwY8jfpTwoqZNRQz7fUXRBpvWu7wx+IrnpecjWpAf0VUXYBzvN9bFfd6QSYm2rl6gKfsZhREjgumPB3tSvArtRxE+M4CCrHdeKKZrJHa4XKiyGWz7pOs6yJzKW4yvg4MOV0wxzTR0xDwKAoTFzTBQb35C1jKwGFkFkrojax0/2BRKGxSJATiKob205QwYsAKqXIn+XBi2vzsFq2EPWhpGGh2XA6VPy1gkak+/16rAgAdIPB/tUZOC/qpxfvkkBKU+rGbOVfYTfm8p4HSAXODJCs5KEZsy4mEDx0yjbjCPj6UToh2xqFnEBRMIq9TNGspeW9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0801MB2052
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT029.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: a74fa1ff-404c-43b3-bd58-08d86157b8f5
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RjP3of4pEDll9aeoqTP5F+9ObosJwwIxtsDSEPyp+IYrM3KMCvwba6PNU0fnvv6PFldp/aiRrgRVOYkchdLCLF7I2qDknkWC0iJTjfWjRZZP5oYa8415fwJfMs/thNbrNZ2DKEj5gKEb5mEEI5fogvjsmLJcvzZACsy25Nc9OUQXS5/uDaPoXI7UKwtl5XuTwIQy45q4RD0V255lBoilApkgAo9ZiK0EVeiwPrtUkqw5l2CcYTWX5DajSpjwSOgkLpIMdSPK57LxER2lOfHXobpFtqLpf/2ebt9+SYORZ4Wh8LozOIxfoT21xjGulXxQrdwwsaxq95TfrOyAQVfyEEUPeeA84m3GFDSIWQh3dJU4jacI/PTBcvKM2wRi030PnYOBMsuPq1UgRFWRHX5+IDP7EWUa+jS9gfu8b+zYzpKy2yeXxvDJa1Yp6dZYtanE
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(376002)(396003)(46966005)(2906002)(44832011)(81166007)(47076004)(55236004)(8936002)(356005)(4326008)(53546011)(2616005)(16526019)(316002)(450100002)(6486002)(82740400003)(110136005)(956004)(36906005)(86362001)(70206006)(5660300002)(6666004)(336012)(36756003)(186003)(82310400003)(70586007)(478600001)(31686004)(26005)(16576012)(8676002)(31696002)(921003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 13:34:35.9558
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4933e418-f3e9-461f-93a5-08d86157be9e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT029.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB4076
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/07/2020 10:03, Calvin Johnson wrote:
> Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> provide them to be connected to MAC.
> 
> An ACPI node property "mdio-handle" is introduced to reference the
> MDIO bus on which PHYs are registered with autoprobing method used
> by mdiobus_register().
> 
> Describe properties "phy-channel" and "phy-mode"
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> 
> ---
> 
> Changes in v7: None
> Changes in v6: None
> Changes in v5: None
> Changes in v4: None
> Changes in v3:
> - cleanup based on v2 comments
> - Added description for more properties
> - Added MDIO node DSDT entry
> 
> Changes in v2: None
> 
>   Documentation/firmware-guide/acpi/dsd/phy.rst | 90 +++++++++++++++++++
>   1 file changed, 90 insertions(+)
>   create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
> 
> diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
> new file mode 100644
> index 000000000000..0132fee10b45
> --- /dev/null
> +++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
> @@ -0,0 +1,90 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=========================
> +MDIO bus and PHYs in ACPI
> +=========================
> +
> +The PHYs on an mdiobus are probed and registered using mdiobus_register().
> +Later, for connecting these PHYs to MAC, the PHYs registered on the
> +mdiobus have to be referenced.
> +
> +mdio-handle
> +-----------
> +For each MAC node, a property "mdio-handle" is used to reference the
> +MDIO bus on which the PHYs are registered. On getting hold of the MDIO
> +bus, use find_phy_device() to get the PHY connected to the MAC.
> +
> +phy-channel
> +-----------
> +Property "phy-channel" defines the address of the PHY on the mdiobus.

Hi Calvin,

As we discussed offline, using 'mdio-handle'+'phy-channel' doesn't make 
a lot of sense. The MAC should be referencing the PHY it is attached to, 
not the MDIO bus. Referencing the PHY makes assumptions about how the 
PHY is wired into the system, which may not be via a traditional MDIO 
bus. These two properties should be dropped, and replaced with a single 
property reference to the PHY node.

e.g.,
     Package () {"phy-handle", Package (){\_SB.MDI0.PHY1}}
​
This is also future proof against any changes to how MDIO busses may get 
modeled in the future. They can be modeled as normal devices now, but if 
a future version of the ACPI spec adds an MDIO bus type, then the 
reference to the PHY from the MAC doesn't need to change.

> +
> +phy-mode
> +--------
> +Property "phy-mode" defines the type of PHY interface.
> +
> +An example of this is shown below::
> +
> +DSDT entry for MAC where MDIO node is referenced
> +------------------------------------------------
> +	Scope(\_SB.MCE0.PR17) // 1G
> +	{
> +	  Name (_DSD, Package () {
> +	     ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +		 Package () {
> +		     Package () {"phy-channel", 1},
> +		     Package () {"phy-mode", "rgmii-id"},
> +		     Package () {"mdio-handle", Package (){\_SB.MDI0}}
> +	      }
> +	   })
> +	}
> +
> +	Scope(\_SB.MCE0.PR18) // 1G
> +	{
> +	  Name (_DSD, Package () {
> +	    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +		Package () {
> +		    Package () {"phy-channel", 2},
> +		    Package () {"phy-mode", "rgmii-id"},
> +		    Package () {"mdio-handle", Package (){\_SB.MDI0}}
> +	    }
> +	  })
> +	}
> +
> +DSDT entry for MDIO node
> +------------------------
> +a) Silicon Component
> +--------------------
> +	Scope(_SB)
> +	{
> +	  Device(MDI0) {
> +	    Name(_HID, "NXP0006")
> +	    Name(_CCA, 1)
> +	    Name(_UID, 0)
> +	    Name(_CRS, ResourceTemplate() {
> +	      Memory32Fixed(ReadWrite, MDI0_BASE, MDI_LEN)
> +	      Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
> +	       {
> +		 MDI0_IT
> +	       }
> +	    }) // end of _CRS for MDI0
> +	    Name (_DSD, Package () {
> +	      ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +	      Package () {
> +		 Package () {"little-endian", 1},
> +	      }

Adopting the 'little-endian' property here makes little sense. This 
looks like legacy from old PowerPC DT platforms that doesn't belong 
here. I would drop this bit.

> +	    })
> +	  } // end of MDI0
> +	}
> +
> +b) Platform Component
> +---------------------
> +	Scope(\_SB.MDI0)
> +	{
> +	  Device(PHY1) {
> +	    Name (_ADR, 0x1)
> +	  } // end of PHY1
> +
> +	  Device(PHY2) {
> +	    Name (_ADR, 0x2)
> +	  } // end of PHY2
> +	}
> 
