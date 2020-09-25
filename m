Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3BF2789C8
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 15:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbgIYNjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 09:39:53 -0400
Received: from mail-eopbgr80047.outbound.protection.outlook.com ([40.107.8.47]:43129
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727982AbgIYNjw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 09:39:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVtBas8mSZe2iCjM1xWYLfJ/tqCFJswkuDof+eB9oiA=;
 b=SqvFi5o+NB235xcjMvCeZPWgWIFjj7x2Vm1Bn+hOEqAOuQkpwi5IHM/zEPbr2+pGhmOou2Jidw7g6BD6EJfOJOYarkxd70FK+2KDJ9z9Qd2Zxus5dAkb7O87c/XOoZJZSp54HyEPYmAxDDQKv577ll1ubMb8EwiMMYkk1w8f75Y=
Received: from DB6PR0301CA0070.eurprd03.prod.outlook.com (2603:10a6:6:30::17)
 by DB8PR08MB5113.eurprd08.prod.outlook.com (2603:10a6:10:e1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Fri, 25 Sep
 2020 13:39:47 +0000
Received: from DB5EUR03FT050.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:6:30:cafe::44) by DB6PR0301CA0070.outlook.office365.com
 (2603:10a6:6:30::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend
 Transport; Fri, 25 Sep 2020 13:39:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT050.mail.protection.outlook.com (10.152.21.128) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.21 via Frontend Transport; Fri, 25 Sep 2020 13:39:47 +0000
Received: ("Tessian outbound a0bffebca527:v64"); Fri, 25 Sep 2020 13:39:47 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: d6ae85a50d3a67a9
X-CR-MTA-TID: 64aa7808
Received: from adf3257a317e.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id C685E10C-3691-47DE-9B9D-354B26F3CA93.1;
        Fri, 25 Sep 2020 13:39:27 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id adf3257a317e.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 25 Sep 2020 13:39:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XNzFXOwpSXwblNVwMrG7VFSoNCXWvW+rn1nW5sEgvOqieB5DyYO3/AXVdUU2FkLb/9NmUjLA/jyyPybvQsi4MkNU1bC3kIHzy3pmwEIM6oHfC1fSoO9FwkQmOx454u7XCeitZC6/bJ/6p/ONG3AuA3vPxzAfYq+l6ofcNS+PyR9KxwOPyd61+BKf+vsIiJZeU4PJXkXXFqBkWERr5b59Y4OoF8MCwQsiwnArLS20HMP9bLJdJvZJWFpFTsWEAhAgVUqFdTx8bK7TYQwcgHnP5pUQU6FxqrC7F5vdVubYqZJ04pWnJSNXBr7CmPQ0Z3og+kiHgISUvBPq0q4FlY5LtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVtBas8mSZe2iCjM1xWYLfJ/tqCFJswkuDof+eB9oiA=;
 b=Bd73NOMXOx6Qm41lbvXhLR3XNe4ZlQ53GYBkg4Pcwiax/ltkFUMfs8FNN65yuji1VdTQc6oOGZmxkPBakFpAF/AORdml1+ElEgUb5M8BH+EApBr9FbQDD0o3JEqlcreqD+kbyWEmigmPS6tcErDQWWk0JTPUaUJbt74Bsi70tUdls+bZ0iy3NwnkrrdB3o6nNDYOIDPvQVlrSIPjqPay9WEp9xMWuGuN94DAw7IN7ku8wdmIADzp9fX6S3QvJn4CBFugVXxQApru1UcTCOvR4T5c//8nO1PBjKDxWq47gMvB8l/FnSlRi6rpxe7NYjs7Y3n7AgG//H418umINPQLqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVtBas8mSZe2iCjM1xWYLfJ/tqCFJswkuDof+eB9oiA=;
 b=SqvFi5o+NB235xcjMvCeZPWgWIFjj7x2Vm1Bn+hOEqAOuQkpwi5IHM/zEPbr2+pGhmOou2Jidw7g6BD6EJfOJOYarkxd70FK+2KDJ9z9Qd2Zxus5dAkb7O87c/XOoZJZSp54HyEPYmAxDDQKv577ll1ubMb8EwiMMYkk1w8f75Y=
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
Received: from AM6PR08MB4007.eurprd08.prod.outlook.com (2603:10a6:20b:a1::29)
 by AM6PR08MB4568.eurprd08.prod.outlook.com (2603:10a6:20b:ac::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Fri, 25 Sep
 2020 13:39:25 +0000
Received: from AM6PR08MB4007.eurprd08.prod.outlook.com
 ([fe80::9904:4b6c:dfa2:e49f]) by AM6PR08MB4007.eurprd08.prod.outlook.com
 ([fe80::9904:4b6c:dfa2:e49f%6]) with mapi id 15.20.3412.022; Fri, 25 Sep 2020
 13:39:25 +0000
Subject: Re: [net-next PATCH v7 0/6] ACPI support for dpaa2 MAC driver.
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
From:   Grant Likely <grant.likely@arm.com>
Message-ID: <cb465245-8691-c051-3d04-0eaa97532a27@arm.com>
Date:   Fri, 25 Sep 2020 14:39:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0205.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::25) To AM6PR08MB4007.eurprd08.prod.outlook.com
 (2603:10a6:20b:a1::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.16.147] (188.28.154.24) by LO2P265CA0205.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:9e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 13:39:22 +0000
X-Originating-IP: [188.28.154.24]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 568099b6-4e8a-48c2-759c-08d861587868
X-MS-TrafficTypeDiagnostic: AM6PR08MB4568:|DB8PR08MB5113:
X-LD-Processed: f34e5979-57d9-4aaa-ad4d-b122a662184d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR08MB5113A055D8840AC2033BF1EF95360@DB8PR08MB5113.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: Dum2pcCSgnL7ZRmTCfbwSqdlToUXHMgSRjTuSeqey0tcvuLRPe8lnCXHzCZFWtUSEDTXTV/3iHnmx3cLku9fzw/O9Wsm12jnbzX6Mo5YK1XN7q1vsH/H2p7fkEPkUYdHk/aPDnrukZKUZlPc1D/6x+eivXfrigj6Ywuh37WMvJ7Ik/ZF6qOiihRM+ZryJx5mXyqw2nfnGI39MVSHEh8A+1+/o+564NTmkr8P51jjImqZ+HxTknaQ0iO4Rt0U+EjUXE/x5BhaTI8Kzvhrbi7aOrngYdoQSF5te80IDTGLVrOayZIBnsp12tT8yWnSpFG/RJua29GuJvmWpuqiBprUoW3+henGwE7nkJrrI4z9u7b8XmWzKwHwLT30htnZYFoIwPuVkGJ4ouCwa/eXWSqr1SbMGBsRVMlYk+5a5osE9Z95Z/xFUBVgEPEDMZRmjPkBTIrISt04yF+l/BIP5ey6PmRfnFA/kvVOD2aeGM6Kgn0=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4007.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(16526019)(478600001)(956004)(31696002)(2616005)(7416002)(31686004)(966005)(44832011)(110136005)(4326008)(6486002)(16576012)(53546011)(316002)(86362001)(5660300002)(8936002)(8676002)(186003)(66476007)(36756003)(83380400001)(2906002)(52116002)(55236004)(66556008)(66946007)(26005)(921003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8O7EIQGGZoyQFVJopifdUHW6JDETG12T1XadWvJBzwQkDZkaRZJRFUi5fSOdFL7YOtJiINJsc3a8Thuc1dVokuGRnqFyZTrEIfYAKS6hF5CBjGl6EuVlINwb/CO8yhpndY34K9SyJ4P1o/wTffm2q9SdCmZHJZc8QBQXn7HLksUblX6Z7MIaH9vuEuWFT0aDmr4IWtKwyqMGgp3lrgLkE6jaoVQHdrv2iU7KN6g4ptr1FnAMwrl2B0Lsylb0B94tPKgaDpoxDj+I1NKipvSjcywSKu1oazcbz5pMhccIhcX3eJ19Fu0bnO5Fzo4A08t6Lcq5J0XKI45uOYBGfj0zHRdMe298UQc73LvtxOqLaXn20/Miihq0ddNHMA1YZb/Rp7lMRh1smeyGaFW+KHtLaD+9sBbjQCznWli51rl7nc3BgDUXdxXz9wGuy05T/L8MroksXxdIuogQXieQr/HHrlaQ7o3mrtsEcT5zdWFqVaL4B3ALMcDW1FPHLDQxcJplP3c+IyziAbg6R0WKmbZby8BXI6CSa87TPln2MkrCSsPl1TRnJnEUb97B0TFilPtrfTKlXEFD/9Jknrcd4VUGXkRZr1oz8RpB0GMhpPCVg1XkvEvvNsDmL8bfEWoaQW+xcYiwprbZWJCeN8j7G+TOwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4568
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT050.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 030d89ab-91ee-4f6b-32ef-08d861586b2f
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ehp/O8EKb933UaYfGtP9Srzb9DSmk6A6QymS00XGsd8Dh1dYI/46yzUrzj04mNmhIoeLPs/FmksN0PhHtsIjfbNuwmFQIglHHbKzsxCSFSJPxR06cKVezo4pB1yu5nldUWO5sh3cQYBjKTUE7wAtZoEQSASSlo06RFxcmjSf7gxe5SvPf2nuMwh7EePSIqmTvAjuFz6d/v9Wz0xCb/Uuhffe+Oia9tTtmF3FlEDioR2TjVJgfGmmEbvhmrFY89R+v9qSbA1LC2Rn14DKgVed3PlkGkywwRwIKsAI8Ksb5P0vcfKaZi2/c3E05x7Qm6DgsBNumpygFKTkMBHI68wMuBlgOa1eIJ7aLOfCK1Sr6lZ7wFtyDMBvurqz+8H/AwhCMpVZxsKATk75tafvJXjO7uU1JOT//265s0kxE4I8gl8tn6cA9xrN1L4ns3XfgNnIDvCoQWMx9Q3bdcL8CL/F1pQMLNQoeG51479ygZ3JFXeC59ZDl3DGz6bKGtf1thEn040/eJ540ZyqRevptWtEjmCk77snboz3MGhxFCJuXrlvH7BosXGhgDoyYaaxyS26X/W80f6zqVtpHbJzbZKwoA==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(39860400002)(46966005)(966005)(86362001)(5660300002)(8676002)(36756003)(82740400003)(81166007)(356005)(47076004)(82310400003)(83380400001)(31696002)(2616005)(110136005)(31686004)(316002)(16576012)(956004)(70206006)(336012)(70586007)(6486002)(8936002)(450100002)(478600001)(4326008)(44832011)(186003)(53546011)(16526019)(2906002)(55236004)(26005)(921003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 13:39:47.7733
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 568099b6-4e8a-48c2-759c-08d861587868
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT050.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5113
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/07/2020 10:03, Calvin Johnson wrote:
>   This patch series provides ACPI support for dpaa2 MAC driver.
>   This also introduces ACPI mechanism to get PHYs registered on a
>   MDIO bus and provide them to be connected to MAC.
> 
>   Patch "net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver" depends on
>   https://git.kernel.org/pub/scm/linux/kernel/git/lpieralisi/linux.git/commit/?h=acpi/for-next&id=c279c4cf5bcd3c55b4fb9709d9036cd1bfe3beb8
>   Remaining patches are independent of the above patch and can be applied without
>   any issues.
> 
>   Device Tree can be tested on LX2160A-RDB with the below change which is also
> available in the above referenced patches:

Hi Calvin,

In principle, I agree with adding PHY linkage to ACPI, and I sent a 
comment about how the PHYs should be referenced. Unfortunately changing 
that details requires pretty much the entire series to be rewritten 
(sorry!). I won't do any detailed review on patches 2-6 until I see the 
next version.

g.


> 
> --- a/drivers/bus/fsl-mc/fsl-mc-bus.c
> +++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
> @@ -931,6 +931,7 @@ static int fsl_mc_bus_probe(struct platform_device *pdev)
>          if (error < 0)
>                  goto error_cleanup_mc_io;
> 
> +       mc_bus_dev->dev.fwnode = pdev->dev.fwnode;
>          mc->root_mc_bus_dev = mc_bus_dev;
>          return 0;
> 
> 
> Changes in v7:
> - remove unnecessary -ve check for u32 var
> - assign flags to phy_dev
> 
> Changes in v6:
> - change device_mdiobus_register() parameter position
> - improve documentation
> - change device_mdiobus_register() parameter position
> - clean up phylink_fwnode_phy_connect()
> 
> Changes in v5:
> - add description
> - clean up if else
> - rename phy_find_by_fwnode() to phy_find_by_mdio_handle()
> - add docment for phy_find_by_mdio_handle()
> - error out DT in phy_find_by_mdio_handle()
> - clean up err return
> - return -EINVAL for invalid fwnode
> 
> Changes in v4:
> - release fwnode_mdio after use
> - return ERR_PTR instead of NULL
> - introduce device_mdiobus_register()
> 
> Changes in v3:
> - cleanup based on v2 comments
> - Added description for more properties
> - Added MDIO node DSDT entry
> - introduce fwnode_mdio_find_bus()
> - renamed and improved phy_find_by_fwnode()
> - cleanup based on v2 comments
> - move code into phylink_fwnode_phy_connect()
> 
> Changes in v2:
> - clean up dpaa2_mac_get_node()
> - introduce find_phy_device()
> - use acpi_find_child_device()
> 
> Calvin Johnson (6):
>    Documentation: ACPI: DSD: Document MDIO PHY
>    net: phy: introduce device_mdiobus_register()
>    net/fsl: use device_mdiobus_register()
>    net: phy: introduce phy_find_by_mdio_handle()
>    phylink: introduce phylink_fwnode_phy_connect()
>    net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver
> 
>   Documentation/firmware-guide/acpi/dsd/phy.rst | 90 +++++++++++++++++++
>   .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 70 ++++++++-------
>   drivers/net/ethernet/freescale/xgmac_mdio.c   |  3 +-
>   drivers/net/phy/mdio_bus.c                    | 51 +++++++++++
>   drivers/net/phy/phy_device.c                  | 40 +++++++++
>   drivers/net/phy/phylink.c                     | 32 +++++++
>   include/linux/mdio.h                          |  1 +
>   include/linux/phy.h                           |  2 +
>   include/linux/phylink.h                       |  3 +
>   9 files changed, 260 insertions(+), 32 deletions(-)
>   create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
> 
