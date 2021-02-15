Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5582E31B557
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 07:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhBOGCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 01:02:55 -0500
Received: from mail-eopbgr80049.outbound.protection.outlook.com ([40.107.8.49]:64580
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229569AbhBOGCx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 01:02:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3aQ9GKOyCOxAKKaePrFUjkLnUo2FAOoIEsU1LiPwyb0bGBsQ2Iqpjpgl7gUAv7CQM3gY1pmrx+/Np0xB/tIBFYZVhZqqn88O5yEIOIn2gPD3bdwROKeUN1eopjWURVeQ7EwHVKE2SqJaieCcMWJ23SBROyL/rdy6yUo0NVXBsn96LIfYNBAYygVND31jExA84lVozlWUXwkYdP/o8QhFcQIaNntVKyewNf2VeiVePGpLwHv1r5Im5qP89upgFqjatgeFYyfFjhmsVvttrG3aAZ+S98AZA+GDkc+NC3T94hYbM673kXBjyDRcT+RREUWSsodhr0sKssxJRe+oosayQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gt0ZHm4qI06up/RdJ9rfzS2K5ODNGkSd6b2kj90ZkTU=;
 b=nQbh9BnCSUD4xS9mrRbOw4OzWf35Bxy/Ee0YesQ7B3wc8+Md/1v6Se4ZXUGHNrM/SimFIlxBuoLO9heq+yDosf9ZEnO8QUdn4MunvryXoc031pOxgqm/vd54mtz4PfSmS/oCWCo4UrxNKDnjHqaUiD76Wj9Hmn3aYAU2tr7rLq61fwozQd9CRoO06h7+9QEYItXBzfMzEkJmuUxlaNE75ZPBJ/I2Lb6CaJZTKu24SLiSQZtoycpJIMyObWc+amQcwLJewqEPVYzVTgP+o1erndRhnblv1k33gXqlQ5M6IRsgIddXxleZCAy02jLMWE7B28KZkOEtu4QDCMwB4gMF4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gt0ZHm4qI06up/RdJ9rfzS2K5ODNGkSd6b2kj90ZkTU=;
 b=T+YBvb2U9yzW+GVb/2ZM84aSsP+aOrWrV/RMyJAMXlwF6rA8PC+lXJG9ueCXA412ascmrrv4HnAMFxrmBTPrtGWzaVFYVqeqECoraO4L7jTJ5pnlS9j6rYHZZlBctQDIAutH/VN9ulM7LdUR5iXA34Rnyqto0xwOdngbFcKLA6c=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB3953.eurprd04.prod.outlook.com (2603:10a6:208:5b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Mon, 15 Feb
 2021 06:02:03 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3846.042; Mon, 15 Feb 2021
 06:02:03 +0000
Date:   Mon, 15 Feb 2021 11:31:42 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v5 13/15] phylink: introduce
 phylink_fwnode_phy_connect()
Message-ID: <20210215060142.GA21977@lsv03152.swis.in-blr01.nxp.com>
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
 <20210208151244.16338-14-calvin.johnson@oss.nxp.com>
 <20210208153111.GK1463@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208153111.GK1463@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR01CA0132.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::36) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0132.apcprd01.prod.exchangelabs.com (2603:1096:4:40::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Mon, 15 Feb 2021 06:01:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6fd2010a-b121-4446-3074-08d8d177377f
X-MS-TrafficTypeDiagnostic: AM0PR04MB3953:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB3953445F863A3055FA8AE8FED2889@AM0PR04MB3953.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GVvqvKKqVywAN1sbXTB2uhbhZWEGdpXHeTwVZ8uQbBBJATGNSSY0UbWoY/fjo3HvkODHMTZ6WkgLTsPJCqwpCV7bVLBWmnBgdpiYw1Wdw03k7jOD47rd94m8LBNK3j4roti+QCzcTz+r4GWvf+p3jWPGIz4GFk6sPy3ejj4mKQW/YbV3KmbX5orv72VXb5WZ1ZPVNJgy1+Qdx4XKjBFRRiLE+nFh8xVm5u9qT1xOBf9BuNXKrEZoMB5EXvz1tZq+alUuUGwoIPHPbd19arV6rmjz/3g19wzo4P4vBJ5ekdJTTXbJ26JZP8bNTTJ6RmtrKIngA7lH117fVG4kmcAQkmBnghs+WqiXrXxyFVaBWNH9sBHT+tjPORTJh4Cw15Q34xNywndXYKhvqZoBoA5F42ywXAbJ+44iHZsFY3go8ZsrugH3DFe6Sh24jz8oOj3XYR2afcftyGEYk1XtneGuVBLcx+ifFujDnp90QPuK2doHkzaiFi7XV4TSiZgWchj9C8ShRkAYW5ZW+sERNN+rfLMLAayINUNZixtnnxFjjhFP9vseoAaE9LBe9LAe4N9l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(33656002)(83380400001)(4326008)(54906003)(2906002)(55236004)(8936002)(55016002)(956004)(86362001)(6506007)(9686003)(316002)(16526019)(26005)(186003)(66476007)(66946007)(6916009)(7416002)(478600001)(66556008)(7696005)(6666004)(52116002)(44832011)(1006002)(1076003)(8676002)(5660300002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?iVW0A35bTumNExxwm5qtZeA5MBqxLA0NGjBBRgoQu3rd68HqSARSOMV40eMq?=
 =?us-ascii?Q?TPyzwg7sca0b3Yxkgk6JLjFDhG4QrCdohLg2ZK/uYpwLqtYUHpDyGq0POebd?=
 =?us-ascii?Q?783djvtE7rrUL//F2bHEiejS9/fTtJUUoHnoUCb76R11CjeQ5D7njcDU9ken?=
 =?us-ascii?Q?Z5Wp39lUaWwG+PnDR4pTKWAJNyCB6HUfZYKj2WgiFSHUhyLU17z4KF+gmUZP?=
 =?us-ascii?Q?IkcwyMK08/NIX+8lkz7HPVx3+H9n4IromyLNXf5bPrDZMb924QPL/yELzicJ?=
 =?us-ascii?Q?7PsNAnIKOOZXKv5pu5/KyRgSNNQ6v15zO/9yrK6fQfgxfntKHWcdBJwBAPnu?=
 =?us-ascii?Q?B/XcXgZ6iQL9IdmIOxlZP1XwTM9jIu+Cjy1hHUrCD+hFsdGfNU+kbTGpCEl3?=
 =?us-ascii?Q?SyCtvEFSTUVKZwhMdN8YWFp7AUFW9C1E4wTdvu/4giSp/aKzTBLUwqUu1nAj?=
 =?us-ascii?Q?BPdWTJTHTwnksmCfxBtxHA+cHpG3nk2uc3Zz8ga0y2RZYpd7qV8TxFwrFM7c?=
 =?us-ascii?Q?7esvdoPS7wNhhgoGp/OxGmueOHgwDeuRTNXCjcfIgtUU9VPTA7nm+QzdJafY?=
 =?us-ascii?Q?223WCJXNd0HoPkcSOD0rFI9EfbLUIWtALKRONbhPXeEZWHcFE7sKzjMafU4P?=
 =?us-ascii?Q?grziIijiwY0TBMLX6/Argk0dL30IliyBAteY8Dsj3GiRriGLSU+idGqYCzN4?=
 =?us-ascii?Q?ueC+Xt2nJ/AE+P6FAt74p6+AuVFpkvneEggkDCNeE3xzaNAELclbnxQXf56R?=
 =?us-ascii?Q?MSiui9oq6/NuYVZrmOr6q8iuKnyRtmHyVyHBzKS7HHSh3eR+Hn4icq9ed1xs?=
 =?us-ascii?Q?ULZcoHi2of5uhi7vvwQtvoLIEws0PEWhuP4+/frhVFUw623SxcXp8pd74ffY?=
 =?us-ascii?Q?W3K1W7/q6zEBmZvgUwTt4txALgVRV4m8YYeA5FMPDUoC2HPLi4tPKc3MpxQO?=
 =?us-ascii?Q?YkfBI7z4yb1Mevnot3dOow06ZxTX6zmRKVmICTa2DViqsbEAwFdJMYNy+vE+?=
 =?us-ascii?Q?P8KTMQwYCKJ8b+/l0w/T1x2RUmdWm7qSZsPq2hdDdkrTyZ/R6y4ro3lPWUoP?=
 =?us-ascii?Q?Fx+ZtEkiC5zbjciX33wr4hse+pEMXY3Xhca6CsunEDLemnTr72Oy+y+iePA7?=
 =?us-ascii?Q?S/7f6UP3OedNlh47yhI63Z+QdXXKWYlJRe+idDej47BKGggxM9sTo7edMGZL?=
 =?us-ascii?Q?4jii1YTM7SiDHwtxsQcwagRXybPYEoxQT/p1KSVNl35XhE2WcWJufQsE37K7?=
 =?us-ascii?Q?7gA/QnhorUtSz09jNU2q8s+Z1gTW/SMW0Tdd8wDBn+cfXAQSnz+TnbFn+3BB?=
 =?us-ascii?Q?zptVyc5/ZDrLxG8UiORGt82OqF+0cGuRW0gGar197Ky9sQ=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fd2010a-b121-4446-3074-08d8d177377f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2021 06:02:03.7829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A0X/i7LfB4i7qu0WS/NcrUQRlEvSAfWzWYYtj4o/bDNWLOvAPex9P6bxsfFpoNBB4cWOVEkS6dLinE4soR/gbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB3953
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 03:31:11PM +0000, Russell King - ARM Linux admin wrote:
> On Mon, Feb 08, 2021 at 08:42:42PM +0530, Calvin Johnson wrote:
> > +int phylink_fwnode_phy_connect(struct phylink *pl,
> > +			       struct fwnode_handle *fwnode,
> > +			       u32 flags)
> > +{
> > +	struct fwnode_handle *phy_fwnode;
> > +	struct phy_device *phy_dev;
> > +	int ret;
> > +
> > +	if (is_of_node(fwnode)) {
> > +		/* Fixed links and 802.3z are handled without needing a PHY */
> > +		if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
> > +		    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
> > +		     phy_interface_mode_is_8023z(pl->link_interface)))
> > +			return 0;
> 
> This difference between ACPI and DT really needs to be described in the
> commit description.
> 
> For example, why is it acceptable to have a PHY in fixed-link mode if
> we're using ACPI, and not DT?
> 
> If we look at the phylink code, accepting a PHY when in fixed-link mode
> is basically not supported... so why should ACPI allow this?

DT and ACPI should handle fixed-link in similar manner. I'll remove the OF
check.

Thanks
Calvin
