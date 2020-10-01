Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C221827F84B
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 06:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgJAEAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 00:00:31 -0400
Received: from mail-eopbgr140083.outbound.protection.outlook.com ([40.107.14.83]:61600
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725800AbgJAEAb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 00:00:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=noLCTy4MksICJVtQTy4lA8i6bFqF2qlNiqLlB9su/Xa4nfuWqY3gOf8Va/TeyQvMAkVgOTyVDEPIrMFiau16a6ylbgyE4zsSJIqL+3vd12CipklGdiV8vKL/6zNxf1dqQf30lswB+ZULT3suEkV84KTjWwiuoEvDGr1BXLF1P5ln5V+1jMkynZbgw64trbf8/Eu/AutOCxYi52lcC9zmbSvblL+BisVUUSV668y3C6W/S6JoH145Y3ni7q4irYiYA/w/JkjjP3DepjNXtJRWigumZ6tOuQBOn9NmLfpwTzlBc5g1tPOUOw6GUbC//xIkPbfqU1nFJ+/pSMuT8GMIVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mniY/2SBo3Dk+MPb3i3uo8k/QHtqhV6Ejk4jZT4vD6k=;
 b=jgmJqNQhTdvu04cLYom3zI0m8166xV87e28V+oa8zInZFRbmrRPMFV46yKgeyuk4gmvFMJIEquroaf/hX6pCWvQoDe3fHoYSjcQH6/S0qSjYoMkZAnuq/31SZftSrdSPAfNYt6pywolXSOqQ5Aa97DkhuFmd8u80unJ+YH+b2efr9psU2wEXQX6bH+F9BrozoJ7LJj211LzsD4Qhgew9gxelS6FMVGhSgf58HSyrm7xnmDlxrcQXTloAGXUqonsmYloETpYWJkFE59G0hoX0Dj1qJ157tY81+h8Bl5QeAACjc2vlhJg+a4e2WsjSnKbmTvu/xwN+ux1iBUbipcJA2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mniY/2SBo3Dk+MPb3i3uo8k/QHtqhV6Ejk4jZT4vD6k=;
 b=iwegsnW4o3axApTVrNk3LZ2p6tiwPoG1omWEMCbnXTWR/9gP40T1TDPDjLYXS8SDNI6DkkHNMnHpJFxcaG0WuTsfv0LcGcqooSnVPDi5n4xxJx4cDNT3GJdF9WSGBANQBeErlwaps+d1xA88fDvrYa8rMiEDIt7KB0M0yGQoJaA=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM8PR04MB7394.eurprd04.prod.outlook.com (2603:10a6:20b:1d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Thu, 1 Oct
 2020 04:00:27 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef%7]) with mapi id 15.20.3433.032; Thu, 1 Oct 2020
 04:00:27 +0000
Date:   Thu, 1 Oct 2020 09:30:16 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v1 3/7] net: phy: Introduce fwnode_get_phy_id()
Message-ID: <20201001040016.GC9110@lsv03152.swis.in-blr01.nxp.com>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
 <20200930160430.7908-4-calvin.johnson@oss.nxp.com>
 <20200930163440.GR3996795@lunn.ch>
 <20200930180725.GE1551@shell.armlinux.org.uk>
 <20200930181902.GT3996795@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930181902.GT3996795@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR01CA0085.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::11) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0085.apcprd01.prod.exchangelabs.com (2603:1096:3:15::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.36 via Frontend Transport; Thu, 1 Oct 2020 04:00:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 80023a5c-239e-492a-3dbc-08d865be87c2
X-MS-TrafficTypeDiagnostic: AM8PR04MB7394:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB73941E0CEE0EE0E9F9001963D2300@AM8PR04MB7394.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CGa3RCV4YFRif9VDKLjih2W3UXRoC40Y+jasx1sWck5mNSxYEHu+cVmzSO4iuPx2MLqXlG2wToWhTBZFi/WBCXiGRz8LhJtEGGpaguPyxXwJ93Z0a0s8AEHHOI3xzgojAboTh/h/aQvz10h9iB+sahuxixg1b3Y65PcFXp4HCe1K8xN4WsqAFHPg1zGUM8uYdolP9mwG38AMaxR4CtZEBSiptu+iNe6f1uJPNVySQ/BIyay8xkr7f0xn0nr0RE9NK7Gndj5SFDsW1T/AhABkti4EVjfojAcwH+6AILUK4Oiik6DsH7AzAwpl0VT1HpfqJMXppZMjIy2UWw1DTaCYAcAnCXdbDFzf9ShHpOWFZ1pOapoE/sqJznpSe3pGnxlI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(366004)(39860400002)(316002)(66476007)(7416002)(55016002)(86362001)(6916009)(5660300002)(66946007)(66556008)(4326008)(8676002)(8936002)(9686003)(26005)(55236004)(54906003)(186003)(16526019)(44832011)(1006002)(6666004)(33656002)(478600001)(956004)(1076003)(7696005)(83380400001)(52116002)(6506007)(2906002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BHuZ7Lh4Bb7n+YeJOVeYMl1Yn/+w++6jEaxOrQSt4jBhqSaZfbH+c6PmqREcCc5+qRnF0A/eNxlpZglKtqAR4GDJT1UwzJtB6zWh2p96RSzAROUaUInVBBHDPly4+0513NhEM6/m2SHeuObrEXlppj7vO0vS69xj5a5IJDrmpAtq2mmlN+Mzq4EFa7CDqVElLy2wSd1VkTrPJDNhtZrS4nhtvsO6kAZnsCcpvFf+hAorza6Fuk7YJjMcxoxzXTLX4R8OP5YxkXo8r6Q5GZ3rQROR0jqTPJKAHUoYHoFdVPhQYzMQGdf5mqtAGNatAIHo+pBj9QIbr0v7v0t/AUPYuprtDfMv/mSDKOUHpy6N+NcDeUj06xWMOQcclK1G9nokeVYbeBTYbW1LAbgPqTUOB5hoevwMg9MQCjAZ7YfVheKzkrRuRCWAFLpidCZ6ZmKPVDKPrYSUsvOT1WHutIWP4dXvfN9HdR4/ZMSOciWSSbd1RtsY2Ab/WorWFyk/uN7dyFGg2c7uenD/9OIc9qTeQVoj6W6hEG5mM+Ym7dHLz1f7kjqOXtBohvNkIBDmeYZUqEaJpyDxRAZUJzH8hrfWA1ydy03kYi4mJToKzG5oykx3h9qDOK93TDjc19o7+YzBhdnnukcDpTHOFmE+Iqp88A==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80023a5c-239e-492a-3dbc-08d865be87c2
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2020 04:00:27.2258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K+p5L2wtX5GeN+16JFoSgCtL7v9IaVCYq07nPZe/ImaxUB0TEFRRq57Yvw8Pnlz6bK6tGkPugAReSIYpiYbKaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7394
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 08:19:02PM +0200, Andrew Lunn wrote:
> On Wed, Sep 30, 2020 at 07:07:25PM +0100, Russell King - ARM Linux admin wrote:
> > On Wed, Sep 30, 2020 at 06:34:40PM +0200, Andrew Lunn wrote:
> > > > @@ -2866,7 +2888,15 @@ EXPORT_SYMBOL_GPL(device_phy_find_device);
> > > >   */
> > > >  struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
> > > >  {
> > > > -	return fwnode_find_reference(fwnode, "phy-handle", 0);
> > > > +	struct fwnode_handle *phy_node;
> > > > +
> > > > +	phy_node = fwnode_find_reference(fwnode, "phy-handle", 0);
> > > > +	if (is_acpi_node(fwnode) || !IS_ERR(phy_node))
> > > > +		return phy_node;
> > > > +	phy_node = fwnode_find_reference(fwnode, "phy", 0);
> > > > +	if (IS_ERR(phy_node))
> > > > +		phy_node = fwnode_find_reference(fwnode, "phy-device", 0);
> > > > +	return phy_node;
> > > 
> > > Why do you have three different ways to reference a PHY?
> > 
> > Compatibility with the DT version - note that "phy" and "phy-device"
> > are only used for non-ACPI fwnodes. This should allow us to convert
> > drivers where necessary without fear of causing DT regressions.
> 
> Ah.
> 
> A comment would be good here.

Sure. Will add comment.

Thanks
Calvin
