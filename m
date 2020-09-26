Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40EEC2796E8
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 06:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbgIZEay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 00:30:54 -0400
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:38241
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728069AbgIZEay (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 00:30:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ReIYgtdILRh2TSVxu5CDvM8BNlJzE1YJ+wm7W/TKz2T6b0LWL4mf4IjZn/yUXX5PsiiF5OQMA16iA/lXeelpE8Pyk4bTa+c7rKjk5YevZdc5VrPvt92AU3F10TBQVZ7/YC3xndQxETEMPvKNFZo2fW1uSvBTWqhJiyPyFnkPwlaJ0+tk2NH7zqJ95rQVqCOsSdHAZiH4i5+hvMI6Y0xHCMpUa3pgDDFtT0QOFos0zl43pxOEq4gLfR5p6pwvQI/txBCLHYVLt3dSnweHFmnWugAQPufGLUR192B1Slv8fFFYavAEZhvBd2w7YcwPONxl9kMzgj7Sb+T+BZfBxlxl0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lmYXZZWJoqBGmZ1NXXBASMSsekkmPEsZw7kG1qCS2JY=;
 b=P6S9EwymhANq8fY9tY1KonLRY6ZuCL2RlmF5JCd+Vu3TGLJbymZSUEOcg4NwUp5x0M/gXgumATxih38Y5uTF9S9GidBzwfRoUBe70y9Ycrz/ahGoClkqAkPzyRfCOXV3RZmCClmm3j8Jbgm+aXWo7XbWy0bfPGt9itK0Ipy3ToG7rs/JTj50WI9NhJ6dqqyqu0+1Nzq940Bs/BjeDqWUjHwOBSU8hXMHFnl8lvufAwAR6LtwwTWdmHIWVFoA5z41q57E5pwSrS+GLAcyJB7jXP4xg6NzwWNUIGeGZ/zB/Nkfw+XIsqvLq8VIGWoJ3Hthzc1QJw7hJPGv4LzPv3/mSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lmYXZZWJoqBGmZ1NXXBASMSsekkmPEsZw7kG1qCS2JY=;
 b=mKbens0GF7Dooo+3bE39JU/xT5UX73dMRGVBOlVeX/Aki/589Kdr+9mQNpBJ86+QOmM6MhaYmnp9isHu8Q4gDU140NW7ThASXFZhvCV/7i27tMoxxxR/yQ/wwKKAcaBhyywn+5xmCJxs/hI/HC12nTxuKvR+PpAZRCMUidUU30U=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4227.eurprd04.prod.outlook.com (2603:10a6:208:5e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24; Sat, 26 Sep
 2020 04:30:48 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef%7]) with mapi id 15.20.3412.021; Sat, 26 Sep 2020
 04:30:48 +0000
Date:   Sat, 26 Sep 2020 10:00:25 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Grant Likely <grant.likely@arm.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org, nd <nd@arm.com>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
Message-ID: <20200926043025.GA20686@lsv03152.swis.in-blr01.nxp.com>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <f7d2de9c-a679-1ad2-d6ba-ca7e2f823343@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f7d2de9c-a679-1ad2-d6ba-ca7e2f823343@arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR01CA0175.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::31) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0175.apcprd01.prod.exchangelabs.com (2603:1096:4:28::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Sat, 26 Sep 2020 04:30:44 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4f89a9db-e31d-447b-eb6c-08d861d4f101
X-MS-TrafficTypeDiagnostic: AM0PR04MB4227:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB42275FFC48C8EBE8065EBE1DD2370@AM0PR04MB4227.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NPJ9QcFxr9hLna4/qqcOfNjI6GQ4T8zlm9VjWkOqbIQWOrgSYLORFPNTwT+GaRtUSdazVvNrFZAQBbGr4aIVHkblmGnQjeBfS7FNDalsHCOsC0+PgC4hlTa1UZiUCOlx6tjNo2aw3ceWcYviU/eZ1hr0CceRcrm+UHaz4/e+huU+861D/NnnCGjvZOdxVV5a0W2cAhsrcAr3UMtbfRM2kFL/98al4XGAzOECsJ13ljz6eOwI8vJBLP6339YCL/ZI3Tuv2z8ZmJHwCR231Uk4eRVvXJCCh+WqxQ7+11vflzQ0dqDEwGeP4vCf+rbA7mRDQZw5xra28wo6KRN2WeHofiu/919RpCtraHSF1lZOPbA0hMm/5virQCh5uBX1cs7fdbHXWjJnLw+ntcV/oEu2rvn/TunvNzVuNak0yJkTnMQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(396003)(376002)(39850400004)(6506007)(44832011)(52116002)(6916009)(7696005)(186003)(55236004)(33656002)(316002)(54906003)(956004)(9686003)(86362001)(478600001)(55016002)(4326008)(16526019)(26005)(5660300002)(1076003)(2906002)(53546011)(1006002)(6666004)(66476007)(66556008)(7416002)(8936002)(8676002)(66946007)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JKzngad6cOZ3vfrrxarIAzBXaa0DOcVeWXL2ebhSXAO6Hd4ERHev8YlSs1vtuGVi+wNCxC6bVFpVBrJ4vPzO3DMyOqbTgylXjI3Z6d8Z5Hxklgg0X1zplMrhE+Aqtriq9I3hpp9wPOEdwhtFhlx4gRVKDVx+ZNIt2kmCdVItMX3XY8VAAuJpQ4cOkiU5aMhl6HZ37DnIsv0kZ1Tk2INSZnKCDDTay0fsfGBrNhUsH6imv7FTgwujs8jW9JT6GcFSEphNSpnBlnAWrw9ywl4IpWrh7pDUaCii5hgf66XFLnR+KjBJ+oFm99byGENZeWrdNy70ynKjquXpOmOwsg26epLHrTDmG6wCqyd66cFAosprGh2y2CLf4DykieAtR7D/eKXzMAq1KJlHG/1DQMg/UsDCJ7IO/730f0W8pZjG84vShrHgxgwOtlf9ApoZMfZQqx+SVcpPIQQ4ihliwzctof1bwClBHaUN1LxoZRel6m1CSXIUx47P36azCvRQ4AWKht9kxYf5cNwSlnJ+9vBBccglxqgf0iqkxdQGq3iIupX1i7HzXJJmyyfjLTdc2qVxlzIsY+Dgpe0NrRJNcNBR2xIksJeMtBcIYg0Ie543rqdt3Gn98nk6Vw7ePFSDBTM1tRriHVuhvZPf5wKRiQ+N0A==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f89a9db-e31d-447b-eb6c-08d861d4f101
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 04:30:48.3097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 36vGZzOXsAyan8oFCihPSSjGlZkbDLXnSjjgQsmNg3GX6JyUBZ16stXiwPXNi51FUAPOYEMduglKYVNbaEjilQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4227
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 02:34:21PM +0100, Grant Likely wrote:
> On 15/07/2020 10:03, Calvin Johnson wrote:
> > Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> > provide them to be connected to MAC.
> > 
> > An ACPI node property "mdio-handle" is introduced to reference the
> > MDIO bus on which PHYs are registered with autoprobing method used
> > by mdiobus_register().
> > 
> > Describe properties "phy-channel" and "phy-mode"
> > 
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > 
> > ---
> > 
> > Changes in v7: None
> > Changes in v6: None
> > Changes in v5: None
> > Changes in v4: None
> > Changes in v3:
> > - cleanup based on v2 comments
> > - Added description for more properties
> > - Added MDIO node DSDT entry
> > 
> > Changes in v2: None
> > 
> >   Documentation/firmware-guide/acpi/dsd/phy.rst | 90 +++++++++++++++++++
> >   1 file changed, 90 insertions(+)
> >   create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
> > 
> > diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
> > new file mode 100644
> > index 000000000000..0132fee10b45
> > --- /dev/null
> > +++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
> > @@ -0,0 +1,90 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +=========================
> > +MDIO bus and PHYs in ACPI
> > +=========================
> > +
> > +The PHYs on an mdiobus are probed and registered using mdiobus_register().
> > +Later, for connecting these PHYs to MAC, the PHYs registered on the
> > +mdiobus have to be referenced.
> > +
> > +mdio-handle
> > +-----------
> > +For each MAC node, a property "mdio-handle" is used to reference the
> > +MDIO bus on which the PHYs are registered. On getting hold of the MDIO
> > +bus, use find_phy_device() to get the PHY connected to the MAC.
> > +
> > +phy-channel
> > +-----------
> > +Property "phy-channel" defines the address of the PHY on the mdiobus.
> 
> Hi Calvin,
> 
> As we discussed offline, using 'mdio-handle'+'phy-channel' doesn't make a
> lot of sense. The MAC should be referencing the PHY it is attached to, not
> the MDIO bus. Referencing the PHY makes assumptions about how the PHY is
> wired into the system, which may not be via a traditional MDIO bus. These
> two properties should be dropped, and replaced with a single property
> reference to the PHY node.
> 
> e.g.,
>     Package () {"phy-handle", Package (){\_SB.MDI0.PHY1}}
> ​
> This is also future proof against any changes to how MDIO busses may get
> modeled in the future. They can be modeled as normal devices now, but if a
> future version of the ACPI spec adds an MDIO bus type, then the reference to
> the PHY from the MAC doesn't need to change.
> 

Hi Grant,

Understood. I'll make the changes.
> > +
> > +phy-mode
> > +--------
> > +Property "phy-mode" defines the type of PHY interface.
> > +
> > +An example of this is shown below::
> > +
> > +DSDT entry for MAC where MDIO node is referenced
> > +------------------------------------------------
> > +	Scope(\_SB.MCE0.PR17) // 1G
> > +	{
> > +	  Name (_DSD, Package () {
> > +	     ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > +		 Package () {
> > +		     Package () {"phy-channel", 1},
> > +		     Package () {"phy-mode", "rgmii-id"},
> > +		     Package () {"mdio-handle", Package (){\_SB.MDI0}}
> > +	      }
> > +	   })
> > +	}
> > +
> > +	Scope(\_SB.MCE0.PR18) // 1G
> > +	{
> > +	  Name (_DSD, Package () {
> > +	    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > +		Package () {
> > +		    Package () {"phy-channel", 2},
> > +		    Package () {"phy-mode", "rgmii-id"},
> > +		    Package () {"mdio-handle", Package (){\_SB.MDI0}}
> > +	    }
> > +	  })
> > +	}
> > +
> > +DSDT entry for MDIO node
> > +------------------------
> > +a) Silicon Component
> > +--------------------
> > +	Scope(_SB)
> > +	{
> > +	  Device(MDI0) {
> > +	    Name(_HID, "NXP0006")
> > +	    Name(_CCA, 1)
> > +	    Name(_UID, 0)
> > +	    Name(_CRS, ResourceTemplate() {
> > +	      Memory32Fixed(ReadWrite, MDI0_BASE, MDI_LEN)
> > +	      Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
> > +	       {
> > +		 MDI0_IT
> > +	       }
> > +	    }) // end of _CRS for MDI0
> > +	    Name (_DSD, Package () {
> > +	      ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > +	      Package () {
> > +		 Package () {"little-endian", 1},
> > +	      }
> 
> Adopting the 'little-endian' property here makes little sense. This looks
> like legacy from old PowerPC DT platforms that doesn't belong here. I would
> drop this bit.

Ok. Will drop it.

Thanks
Calvin
