Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74B5286298
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 17:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbgJGPuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 11:50:50 -0400
Received: from mail-eopbgr140070.outbound.protection.outlook.com ([40.107.14.70]:16673
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727005AbgJGPut (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 11:50:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jCaqn7da06DasA0cyvi6e/D37BlEMwxeqITjVGC4o9ECam/B9KppB/tA1Coe8umyOXY/ekOqPFarxC/wUHv7cKeLZ1SBpAgfrTBYN71mrVsRO7VNH/MxN7OxB9+d8A5FzNotjLvw+zkI1GEMD2DWqsbnoKqfDZt4OlMrc7qpdlmYtigrT0lLtkHwV8QZoaFfbEm/0cd1BP5NiOr8uNPzXGZJigBaJ1MWsXXfOzFbcY6IxYlNkDusjYshtn1ZXAOLKHhAM8UARrrjQ1FBQW28nTBfdvT3yPilzF/uu5XSrj9AKRN+cpcqcHQvmZUGR0zdIopxEJOTCeXCxzMNrwdXNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jAWaZM2qvBc7l8N5xPr9kV8WvhQkT+CCR2Clg3EazBA=;
 b=hhtWc6LlgzP/N+kY9JkaB7R6ytc8kPsXpDoSoEhG+R7nwNp7Uj44vRbt8E/r04NQ8AypamuzLbZQGkUCTu2q+z7n5o/2beLKH7K/xaDHfViKNi4rLHCb/74pB5kG2uLbmmTCuoUNcP+MIZlH7O/Rl1iiC4LI3Jvg6kc1ApTZ876M8+l6qLL2ttpqtEP1ZqEK6H+HmErMkLq3aOhXlE7WsgQNi07YzVBswFTJkh005xq2IN9mcjaPumhuFouboNdVPF/bgGE76jHMt1ptNKHHZISFotFqxKSNIU/kdbOaWf0+q+ZJFPkOjEQthomF47XpNrV049sU0F0UqHbgBESUNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jAWaZM2qvBc7l8N5xPr9kV8WvhQkT+CCR2Clg3EazBA=;
 b=UeXFfN9eSNJNKqDfvuhMbghuDOUP7qsECP+/bEfBXhGXtJ/u23PMLZvnxfC/N4NZZFf/jNXkq2h7KEtI8OnEA9i6NZIvb9OPzSyR7ESsITZ1IYEeVIKoaSzlF0HmqfS6z960s/wGLYX5AOC/iw1nuzE0tXi6Z6lQdEOzAbTZhEk=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4929.eurprd04.prod.outlook.com (2603:10a6:208:c8::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Wed, 7 Oct
 2020 15:50:44 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef%7]) with mapi id 15.20.3433.044; Wed, 7 Oct 2020
 15:50:44 +0000
Date:   Wed, 7 Oct 2020 21:20:11 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Grant Likely <grant.likely@arm.com>
Cc:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
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
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v1 6/7] net: dpaa2-mac: Add ACPI support for
 DPAA2 MAC driver
Message-ID: <20201007155011.GA27347@lsv03152.swis.in-blr01.nxp.com>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
 <20200930160430.7908-7-calvin.johnson@oss.nxp.com>
 <0e433de7-f569-0373-59a7-16f2999902d4@arm.com>
 <20201003173949.GB28093@lsv03152.swis.in-blr01.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201003173949.GB28093@lsv03152.swis.in-blr01.nxp.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR03CA0104.apcprd03.prod.outlook.com
 (2603:1096:4:7c::32) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR03CA0104.apcprd03.prod.outlook.com (2603:1096:4:7c::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.15 via Frontend Transport; Wed, 7 Oct 2020 15:50:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 79800f69-7d2f-4617-fe62-08d86ad8ba9e
X-MS-TrafficTypeDiagnostic: AM0PR04MB4929:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4929EFD971805508030E08E3D20A0@AM0PR04MB4929.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JSD+Mc2dTK5eAUBmebs662meR8GFbMesF4gft57a/gJBKhDqjNKx0twNVVfuTMnd2tMVpJWpdRBUwmG0TwPY2++dNaJMW/9jSLvFRro44myXHzPV3nhk40Uq+ioCr5PH7NaoNaJENJpsuYYJTo1BBSL0JyCyT/mgXVuXHDfr2VRUciCLLj0Ob72DALbaF3BJ2n2BUX+uqst0gJGrC7B40eBuEQrlfX1xsKDYzRmtvosI+zyKGaU2cqcIGXJSFMH96AW6ApFRetxHNAWWqMTepmxKnpxFz2peONjki0KlzS1EZXvsrXIgiLpButdXQzbP2yOjpDI33ACZU4h/5k/vk1DYRxGU5NcqZS7xu1Th07Q7kG5fcUmaFAjncgg4sjdV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(1076003)(2906002)(8676002)(8936002)(7416002)(956004)(33656002)(55016002)(4326008)(66556008)(316002)(66946007)(66476007)(52116002)(7696005)(478600001)(186003)(9686003)(26005)(55236004)(5660300002)(6666004)(1006002)(44832011)(6506007)(54906003)(6916009)(86362001)(16526019)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: pkvKo5j/1zW9czBezLnsupE80dkMGafL0XqNQt0ImG03QIlEmN4xewLQifj22G0g+PwpLJM/7VdIvnc9cmQaa9N9tOq2BpyKtug23mddLUIhNRsYISdgFhEU297N8KPXzoyeHAMAyIAe4Jn0r4eONImacY8drmn00CCcoixAbXDEGFGxa92DbiNWwwbgvZVKJm794BrxskafhfPX+0HGGe/9YTOHnawwK9dYC66eCgykyOD3rMAko6Vtv3SZrdcqXFMlRfjAWRvbTVNOzwyciRS8Ji1/EhZTBm52qH9JMdKAab3kw7tGeyKrzjYZMLk8KMgeRO8SQZ55dJAmcWC6j6asmrMTlRRpC3kY8a7ygv50aYQhPFOJlB6sE4CvjopliCLajPgl+DwkFXVLLbIRes/S6EXMGNDYEXDIUTiRi/oAg39fNDnAnndRqrh2ejNd9GYOyommj6WAVibz03hiSNOgsqIvBXuMca2kYRps0ZqIuA2t20+qzFIsNiIve2a0OKacAlmGPg6Tz43faMoKrb62v8Oj1xFyE9UrvmXjjh+XxWQw5ayy3GT6ZyKkr5iTJi5JV0IwOG96RSV4nBqOU6xoi/LLeSPNt7LpeaWnfOzMsJgOWJbGAmFosWjooQz4B0057DblhV1ZVncIwJigwg==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79800f69-7d2f-4617-fe62-08d86ad8ba9e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 15:50:44.5752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nFq70i+iWYdvtHEuiAWpmQGyWdLL4TfWzND03RGF4Y7RFrUYHqtp6BUfLHITjqtU44FzPuZhUhEkuONxJe/j0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4929
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 03, 2020 at 11:09:49PM +0530, Calvin Johnson wrote:
> Hi Grant,
> 
> On Fri, Oct 02, 2020 at 12:22:37PM +0100, Grant Likely wrote:
> > 
> > 

<snip>

> > > -static int dpaa2_mac_get_if_mode(struct device_node *node,
> > > +static int dpaa2_mac_get_if_mode(struct fwnode_handle *dpmac_node,
> > >   				 struct dpmac_attr attr)
> > >   {
> > >   	phy_interface_t if_mode;
> > >   	int err;
> > > -	err = of_get_phy_mode(node, &if_mode);
> > > -	if (!err)
> > > -		return if_mode;
> > > +	err = fwnode_get_phy_mode(dpmac_node);
> > > +	if (err > 0)
> > > +		return err;
> > 
> > Is this correct? The function prototype from patch 2 is:
> > 
> > struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
> > 
> > It returns struct fwnode_handle *. Does this compile?
> 
> Will correct this.

Sorry, this change looks correct to me. Actully, the function prototype is:
int fwnode_get_phy_mode(struct fwnode_handle *fwnode);
It is from drivers/base/property.c.

fwnode_get_phy_node() defined in patch-2 is used in phylink_fwnode_phy_connect()

The confusion maybe due to one letter difference in the fn names.

Thanks
Calvin
