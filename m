Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294082825BF
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 20:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbgJCSAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 14:00:52 -0400
Received: from mail-eopbgr150077.outbound.protection.outlook.com ([40.107.15.77]:36250
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725804AbgJCSAw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Oct 2020 14:00:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NVslCIWmG+IznKDe0CpsX856RLOUq2XmWkp+ItzArg4psijLMQ4boEmyIBMvVwEi3LHZksP7CiHze6IPiVuYnrTwPmsW8iyKkNp4qYKrLUNnFrO5Kxc58c/hqCekrIFBoO2cTfvHo2O4iGkJ+ZyqDGqhdawJCobaqqrEZlp/m5sE6LLYBYI10iF7RH9piu6Lvso3KDJJB8qBzuZHil1QKsI3elHTEdVgfBkhhiljDpYudcG9aL30v3/6CMPYB2F48Gkhiuidj84UGEXIWl+7HxVMWj/HZu+yE2QLKHmf84l5nvTSP4g9d3DRd4olMWAbew92/7PBHNn0MKOlPb0cJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rdYDxbmdkqYfvLRr6al7T4kKPusqT4+fqk4AUJPEA18=;
 b=Bvas6DdShj/C8bIVVnqAfef9i0CuCD/Z5JuGYbxt0sJDuWSwmcbNOLMX6VvMQTHZpnWuyXjFJmsKoPidNaeETDjLIYRpRbGkDuP0f6XIvJpzP68sBta1PWEmsgSMhgtBIleCro9NbkEvYNLeSfZpR1XOmlX8T6CpbT1thfmyYmedy5b2kMeHULyheoJ4bKdjqg3AWQrEUFO4/sz2H3TEWQm82JyJEAMW4bZkDJRM4sr6E/D/BqiPdf6YTI64ZVdkfIEUzzAOyEXHdovNjNivrPxgP0Q/RAuQzIiLoWHVhOpumJfMkpXJV1+ppbnOC17l+X8JOjYK3baweXXIuvKJxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rdYDxbmdkqYfvLRr6al7T4kKPusqT4+fqk4AUJPEA18=;
 b=arzCMJx/28OJM+3R5VIGelhw8i8OiCJpgTdH76DlmnryeAvMj+dftBWbfGCfki0tnnmGMr8YYBj2wnWBTQw/bow+9tGubAXjjRWKE3ryjRcGwLGy5zVIbi9Z4vMXsVOtgEJvGxRSiMMtKQI8cQax3knZXa6c8N7tDTjyu56EX+E=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB3955.eurprd04.prod.outlook.com (2603:10a6:208:56::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34; Sat, 3 Oct
 2020 18:00:47 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef%7]) with mapi id 15.20.3433.042; Sat, 3 Oct 2020
 18:00:47 +0000
Date:   Sat, 3 Oct 2020 23:30:34 +0530
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
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, nd <nd@arm.com>
Subject: Re: [net-next PATCH v1 3/7] net: phy: Introduce fwnode_get_phy_id()
Message-ID: <20201003180034.GC28093@lsv03152.swis.in-blr01.nxp.com>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
 <20200930160430.7908-4-calvin.johnson@oss.nxp.com>
 <11e6b553-675f-8f3d-f9d5-316dae381457@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11e6b553-675f-8f3d-f9d5-316dae381457@arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0191.apcprd06.prod.outlook.com (2603:1096:4:1::23)
 To AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0191.apcprd06.prod.outlook.com (2603:1096:4:1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38 via Frontend Transport; Sat, 3 Oct 2020 18:00:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 96a0f883-ba0f-4f67-eb78-08d867c6410a
X-MS-TrafficTypeDiagnostic: AM0PR04MB3955:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB395523DD1E2610E9932A41DDD20E0@AM0PR04MB3955.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wFECbsmTjk1SRFIqDwN0DD0nKzMyT9dcRvHCHyfTuXIolRqDM31cgNnaYhSS2thwP7jGxGNCpGu2H7Wdv2yFCcFMafatCJz0AHFtEBqjhT13gStHKvDkgKXfEVmB2rQUjiCksEsQd4ibrTcJNLA7cPjhbjBUi/Nm16ZQoHd7uLY9NTTEqvvTnc6WOHuJajmosLFS9G+VKIpmelH1b9QN+V/tZ0Qd72+f6MdWyUmWtAHqHCgzDN+HcaFsWOt7hXTSWH7Lu2xNQA8SoGWAKmSxhzEh5+xhIc4Xlp9H36McDlbmwYoWUyBK9WGxg09ukuSBpz1vjfQTnttht7C3g+QAiSkgMIqbRecHLfqmqbvx7HeyoCI7wSq9HUD2hheLvm6O
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(39850400004)(136003)(66946007)(66476007)(54906003)(316002)(55236004)(9686003)(16526019)(26005)(5660300002)(86362001)(4326008)(186003)(66556008)(956004)(7696005)(55016002)(83380400001)(2906002)(7416002)(53546011)(8676002)(6916009)(8936002)(1076003)(6666004)(6506007)(52116002)(1006002)(33656002)(478600001)(44832011)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +ejWv0W7W9mhLrFdw4YzI2Xm3vqLmhbtJpQjw73Bo8AICqyRLE2JX47q06GouLgqDNdXTLy3HX2IKXnm4WHCC9DCzENQ/wU6YT5gUn9C5q4rGrhIfiYeW6VGJwxNZX359I37/SfRzDjnS7qIXs3g3WAac0FdOwJlmYZH3pMAltjvh80EYx981zMsy1xCaE7S4EGXVNaOnMVQPTbKRBwHJ6+DhdEto0l2OnxDk6g9k6iP7fHcwAv6EO+rqcy8T0Uu2UxyPlPJ5fq5rNAOIVfiAw/0IOHASlrjix3GmnrutxoHdUAKDZ+YXna1V7LMAyLnLoaZdEi6F7aro8asSj1uOZyY/hUtInlfzwLJxB4l/OZQ4Ci0hNpXYxY4yDZNJmbN1gULQBe5uTb5mV2GO0baxwuQNSKha1/XO1+MEh+dKIr1FLl809e9xfXGFD2Y7bXCep1QvvAK4abO4javwCltHC0XDl4aTjf5UJxoxJGPdqVIpE8YupFTqia4ivF4igvZeVO3Tgp23jr22zcC5DFPXnXOjnHmgv7N1BZSP00/H5u0XO72EZzFiPCgLmshRyJQV9IvjI9XliTeyHf0NBw//NSw5jqLLITEinDTcqOL6UysrsaW71ITKB4unq3PfYb0/PGPjy6jnSc1dipPYW+TOQ==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96a0f883-ba0f-4f67-eb78-08d867c6410a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2020 18:00:47.2821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 03nIpjG04HlXJtrmsxCflBY09UC0/jFKc0/jOllUbgAM37+wqh+5lQwHaTYPY/UKw8SzmGVcdEj/jEPpxvgpWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB3955
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 12:05:14PM +0100, Grant Likely wrote:
> 
> 
> On 30/09/2020 17:04, Calvin Johnson wrote:
> > Extract phy_id from compatible string. This will be used by
> > fwnode_mdiobus_register_phy() to create phy device using the
> > phy_id.
> > 
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > ---
> > 
> >   drivers/net/phy/phy_device.c | 32 +++++++++++++++++++++++++++++++-
> >   include/linux/phy.h          |  5 +++++
> >   2 files changed, 36 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index c4aec56d0a95..162abde6223d 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -9,6 +9,7 @@
> >   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +#include <linux/acpi.h>
> >   #include <linux/bitmap.h>
> >   #include <linux/delay.h>
> >   #include <linux/errno.h>
> > @@ -845,6 +846,27 @@ static int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
> >   	return 0;
> >   }
> > +/* Extract the phy ID from the compatible string of the form
> > + * ethernet-phy-idAAAA.BBBB.
> > + */
> > +int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
> > +{
> > +	unsigned int upper, lower;
> > +	const char *cp;
> > +	int ret;
> > +
> > +	ret = fwnode_property_read_string(fwnode, "compatible", &cp);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) == 2) {
> > +		*phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
> > +		return 0;
> > +	}
> > +	return -EINVAL;
> > +}
> > +EXPORT_SYMBOL(fwnode_get_phy_id);
> 
> This block, and the changes in patch 4 duplicate functions from
> drivers/of/of_mdio.c, but it doesn't refactor anything in
> drivers/of/of_mdio.c to use the new path. Is your intent to bring all of the
> parsing in these functions of "compatible" into the ACPI code path?
> 
> If so, then the existing code path needs to be refactored to work with
> fwnode_handle instead of device_node.
> 
> If not, then the DT path in these functions should call out to of_mdio,
> while the ACPI path only does what is necessary.

I'll work on refactoring as Florian and Rob are also suggesting the same.

Thanks
Calvin
