Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74C71CD171
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 07:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgEKFwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 01:52:50 -0400
Received: from mail-vi1eur05on2045.outbound.protection.outlook.com ([40.107.21.45]:6223
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726161AbgEKFwt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 01:52:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hyr7gA3Pu35uZ/6ow7spBhCwbyRK97Lo7v9U7oc1qH+FwTpUYwHnEaS2RqDLGDLcAZ1Pws88nLrhTLjClGBbe7kIK3mfnKynlal7wQN3lJYyqIvCXrC7mh9mgXMuuZvdZj3WqkaMcxlXREgZOSeLT7mNGeWHraeCTbdcy/EVWrCrqcbabz8wmdedSbE/V2X0R3ndPfbLKV7AJuFSIMm89dX74ue37xZCTCiW8hlFz8qNOJ7mU+8mgem9dAEAxijN/MruJMhhmx/aaLKcnSrwODjg8zqNQb1Gr7HvM/bnOWtNbbEXkJ5zUy4uuaQidPfhoMgRlp+Mg4vOMb9AFkbyOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qKkDV8O1wdwaV/ZGIQZ0tsSsw3q5sgK2U7+Hx8vDFnM=;
 b=gzdsLmUZW85s236JbZbWnfLbvGOzLuHDAnpM7aBGTW9rMLsYJKa8Sn2qhN9NUUJGPg7aEK+h8J3lcGWjMsaFboim0U07x52C56n0P2j6qBBpPJrogLhfxzzNort7nTYUykyhOogNSmuQ9hcrYXspWMvNQHXSf9Lg8YAlbdtAQKdXTanZWey+vlOAo8wXUrjzydsuTqBOTpm6rjlPhDL1Ux6fkdO/wbDH1J+laPWgpZAmV6hMuY9NtPlTxGD0NkFjY0zoJKDJhrYR3AS1WE+jLjRjm8PPAwtYFJEuwfhiC/mqxEI/g2cKVSNpbsG3d9/JSsOH2qsJOVCz6eRddkF+QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qKkDV8O1wdwaV/ZGIQZ0tsSsw3q5sgK2U7+Hx8vDFnM=;
 b=TsNxkBZ1PvlpaSg60/+xHMdcfzS8VxGLgntlcmHEN/tIjPWOl8/ZYRn4SFrUoLN0JLcNTOgbWXIMwXVe67WStVQC3mCl+q08sT7OGxVgZKzzKJieCKhzOSRT/+8znQBzpQ7sLRKZ9TNjSQC8SQhnhOH3ZxQx9Hyd8e7eegifccU=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB7092.eurprd04.prod.outlook.com (2603:10a6:208:19c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Mon, 11 May
 2020 05:52:45 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b%4]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 05:52:44 +0000
Date:   Mon, 11 May 2020 11:22:31 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        linux.cj@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev <netdev@vger.kernel.org>, Marcin Wojtas <mw@semihalf.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [net-next PATCH v3 4/5] net: phy: Introduce fwnode_get_phy_id()
Message-ID: <20200511055231.GA12725@lsv03152.swis.in-blr01.nxp.com>
References: <20200505132905.10276-1-calvin.johnson@oss.nxp.com>
 <20200505132905.10276-5-calvin.johnson@oss.nxp.com>
 <67e263cf-5cd7-98d1-56ff-ebd9ac2265b6@arm.com>
 <CAHp75Vew8Fh6HEoOACk+J9KCpw+AE2t2+oFnXteK1eShopfYAA@mail.gmail.com>
 <83ab4ca4-9c34-4cdd-4413-3b4cdf96727d@arm.com>
 <20200508160755.GB10296@lsv03152.swis.in-blr01.nxp.com>
 <20200508181301.GF298574@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508181301.GF298574@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR02CA0024.apcprd02.prod.outlook.com
 (2603:1096:3:17::36) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0024.apcprd02.prod.outlook.com (2603:1096:3:17::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Mon, 11 May 2020 05:52:38 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ebbe73b6-c677-4aed-ba4a-08d7f56f868f
X-MS-TrafficTypeDiagnostic: AM0PR04MB7092:|AM0PR04MB7092:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB709211C4269698C34DE03EB0D2A10@AM0PR04MB7092.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tT1xngBvVhC1hq/Jn98Loprx9Vaki0sHnflTKtOo5uaTrXnYtokZOU8PFeA6uJXW/Hla+SS04qkCTH6BXl5C0MhlyeC89hE+7kzoO8SB6yvj7SCkS5d+Su0NAl5oixlPeAb1caEAWKSGXCgWX395EGnGLUOaXgeLaYI65e61LpfL6V274k3tgmSqeMtN6TAqNWWOmRvQHr+6/JJ7HHkHsTiEf/L4uEYDvgOKZhpKxLJI6xaLz8DDlEUuxOiCTpDORI9ROMr7Hc5qIxXElfulcruPPszV3jVkRpp8SnVKvFqzDIZb7+ifLSvuX173WM6y2CVIabcnRS6jcPL26MtllGKQbdK0FkSTC5PefVzxd3F6uKD1xrdocgcq0KsxvdQv0aOL24ndhRbpWsY7Lpg0SpyFyGs4Rtnv2jefSKkS1L+MLkndGackG4QxvNfqHqhfsHf5UcNGFfY/qZTlWDCMiMXLJrlGUpMJw+lDlPIElYPGYJhyUcFdKlKMIjcQg2MVZvK5baBc+v8XMJLROqKkUKz95n7fwNq/pKGeuv7jv8I1ZcfaIdJajsoWRkvMH4eO2xVZWW6HoUqhKS6qKd85gEDO67BU2OIwHlwdpepxh8F49O8HDGrr+v80Qt/7+5uJXtcTq33qsqUj1v8FIr8ehA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(33430700001)(52116002)(7696005)(186003)(6506007)(8676002)(1076003)(55236004)(26005)(5660300002)(54906003)(6916009)(316002)(478600001)(16526019)(6666004)(1006002)(7416002)(33440700001)(956004)(9686003)(55016002)(4326008)(8936002)(2906002)(86362001)(66946007)(66476007)(66556008)(33656002)(44832011)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9olgPWxzcgIiPW7+zZNopXx7i3DH9Xlra+1K+3LLpg5sKUPw8NrQjdEiNQ7uFG5Itdw+sOEKBtja+8RJaQqVHMtHjE0m420RjF4+5/PkW/6ljBoPWOSM4Wg+FOK8b3de07UkoSURoV4AWiFU4HCJ12mnGXJPabMYHtTKGk1z+DzOqD41G92Fxrpz3UVWKYJHhhO2cjcxeALVCnv6KWQDUhjwidDSxFSZH80xyKHFA9w8iFxSLqwdjyYLxcJMOnUmXtOPdF0f89PsXx9lWlxP+vkvP7pfRova/h+VIt/KtsdGWCQx9FprvDk/949pH+VBKYqt+RpRz9IlUOkLZVidAGgF7asAYeoK7udOcdmQyBtvYBGk1eKN3HOHdHg32QgkL8GuFNsQlttyVLL1R3PwJqbnE7pmKrjAVWcduuQNJZAT4N0LS5ZTbZm/Y/PcrSraOiPzb9g7ohUdaeCObUwX5HX4EN13FffG13ozPYWkTqk=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebbe73b6-c677-4aed-ba4a-08d7f56f868f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 05:52:44.7823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SHcjI5csWW4vhgRhFHhlutmYVvbIbXA/zKxFun/bGMBXtZfx8fELGz5dk6F43/sS1yMOkqAHcKoEBF1kUeSOwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7092
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Andrew and Jeremy for the detailed discussion!

On Fri, May 08, 2020 at 08:13:01PM +0200, Andrew Lunn wrote:
> > > It does have a numeric version defined for EISA types. OTOH I suspect that
> > > your right. If there were a "PHY\VEN_IDvvvv&ID_DDDD" definition, it may not
> > > be ideal to parse it. Instead the normal ACPI model of exactly matching the
> > > complete string in the phy driver might be more appropriate.
> > 
> > IMO, it should be fine to parse the string to extract the phy_id. Is there any
> > reason why we cannot do this?
> 
> Some background here, about what the PHY core does.
> 
> PHYs have two ID registers. This contains vendor, device, and often
> revision of the PHY. Only the vendor part is standardised, vendors can
> decide how to use the device part, but it is common for the lowest
> nibble to be revision. The core will read these ID registers, and then
> go through all the PHY drivers registered and ask them if they support
> this ID. The drivers provide a table of IDs and masks. The mask is
> applied, and then if the ID matches, the driver is used. The mask
> allows the revision to be ignored, etc.
> 
> There is a very small number of devices where the vendor messed up,
> and did not put valid contents in the ID registers. In such cases, we
> can read the IDs from device tree. These are then used in exactly the
> same way as if they were read from the device.
> 
> If you want the ACPI model to be used, an exact match on the string,
> you are going to have to modify the core and the drivers. They
> currently don't have any string, and have no idea about different
> revisions which are out in the wild.

I don't think ACPI mandates that OS driver use exact string match and not parse
the string.

First of all, I would suggest that we use "compatible" property instead of _CID.
Not sure of a reason why we cannot. This will simplify implementation of fwnode
APIs.

Already I've pointed out couple of ASL files in tianocore where they are already
used.
one eg:https://github.com/tianocore/edk2-platforms/blob/master/Silicon/Marvell/Armada7k8k/AcpiTables/Armada80x0McBin/Dsdt.asl#L280

Even if we use _CID, I'm not sure we are prohibited from extracting characters
(phy_id) from it.
If we decide to use _CID, then we need to define somewhere and standardize
exactly how we are going to use it. I'm not sure where we can do this.

> 
> > > Similarly to how I suspect the next patch's use of "compatible" isn't ideal
> > > either, because whether a device is c45 or not, should tend to be fixed to a
> > > particular vendor/device implementation and not a firmware provided
> > > property.
> 
> Not exactly true. It is the combination of can the bus master do C45
> and can the device do C45. Unfortunately, we have no knowledge of the
> bus masters capabilities, if it can do C45. And many MDIO drivers will
> do a C22 transaction when asked to perform a C45 transaction. All new
> submissions for MDIO drivers i ask for EOPNOTSUPP to be returned if
> C45 is not supported. But we cannot rely on that. Too much history.

Makes sense to me.

> > 
> > I tend to agree with you on this. Even for DT, ideal case, IMO should be:
> > 
> > 1) mdiobus_scan scans the mdiobus for c22 devices by reading phy id from
> > registers 2 and 3
> > 2) if not found scan for c45 devices <= looks like this is missing in Linux
> > 3) look for phy_id from compatible string.
> 
> It is somewhat more complex, in that there are a small number of
> devices which will respond to both C22 and C45. Generally, you want to
> use C45 if supported. So you would want to do the C45 scan first. But
> then the earlier problem comes to play, you have no idea if the bus
> master actually correctly supports C45.
> 
> Given the issues, we assume all bus masters and PHY devices are C22
> unless DT says the bus master and PHY combination is compatible with
> C45.

Makes sense to me.
