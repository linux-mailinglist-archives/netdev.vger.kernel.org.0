Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334CE2825C3
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 20:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgJCSDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 14:03:19 -0400
Received: from mail-eopbgr150044.outbound.protection.outlook.com ([40.107.15.44]:63303
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725804AbgJCSDS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Oct 2020 14:03:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lttuwH97RUPHor9xp8d2rCyOSzYi4VPE1nhN2yuPAo/AlV18uSJG+jew1IaIvIZEMY3+aNo62TdvLblxumQIl/kmW57XCW0Ob3XtX5oOA3ilmuJro327wWYoQ3nkH7jlUJayXl9LkaZkTkHgs9Yd1pLez8JoasVLfKtafgF/a1/Xwm+rSYbt+brI58k0Aq7Y/DtSrKsx6y5uAR8ZO4X+DQcmk31eLgcE0wBuT9c/ttIBVJxM24dCnBYQYrsjGd7/g5AROatIpYp4VlDgGQ88qAgiakidGC6Cr5MDMJVjplCrJSO+rAe7U2bo3y+lwgYqdKBOD6vEFs/iYO7cqeo2AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c6pPx1AFkSx5t2xv1d5l/6aytetjogUd19I8PYE82k4=;
 b=BRhMMd7jSNkq2TkRdzLMTawtt6VaPzYaSs20p1EaxeovIKbo1wBCe/an1+3AC6yWn18CBXjoiLqRwBzkRTEYIiWwyD929xsHQa5EISTANiZ1W5ZpINdJ0h5wQTwZxGGql44CKK5A/urqEdzywjtfO0sOTErzfz0EbCtzGrQekyAMYvsTJhg23kT64KcfEmSz6Fo1uDXFLc8Mmo2x2zcuogUszTkSvzMwIchWkZFTBn1qRRRAg1sODOnErJEUMABk9akASw7x9UVwPw2MCixGdiJBFssYMw8XGm//W5lnCIhQicodfcYc+SwxWQuz6U3DSl/DVqlXJwUagFzjSvhPuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c6pPx1AFkSx5t2xv1d5l/6aytetjogUd19I8PYE82k4=;
 b=Cq7E13rw3xiVxWTW2/5M1Syss1HWWt6u7PprLlOxe1IfTyEOwtuph3tQ2s3kaPNv1ehWAGMPo+fEogwZ4wu2m0GKKa7htZvebLl4sq+ejwgqpZSDaXkBVa7OLzdz6dmT/dke/vOrQhOfEMAdmk50QHqRds+tQUEfBoJrP9PDS0E=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB3955.eurprd04.prod.outlook.com (2603:10a6:208:56::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34; Sat, 3 Oct
 2020 18:03:14 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef%7]) with mapi id 15.20.3433.042; Sat, 3 Oct 2020
 18:03:14 +0000
Date:   Sat, 3 Oct 2020 23:33:01 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
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
Message-ID: <20201003180301.GD28093@lsv03152.swis.in-blr01.nxp.com>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
 <20200930160430.7908-4-calvin.johnson@oss.nxp.com>
 <11e6b553-675f-8f3d-f9d5-316dae381457@arm.com>
 <679fab8f-d33a-9ce8-1982-788d5f90185e@gmail.com>
 <20201002155026.GG1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201002155026.GG1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR01CA0112.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::16) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0112.apcprd01.prod.exchangelabs.com (2603:1096:4:40::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Sat, 3 Oct 2020 18:03:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 661a2880-16a4-4658-031a-08d867c698f8
X-MS-TrafficTypeDiagnostic: AM0PR04MB3955:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB395506583EDCD196B4E72045D20E0@AM0PR04MB3955.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P7I4mDm8KJhPS2zJVEclc64geXzT1j4QMHyW62reIfEEwv2PzMf2YkNSvqmmjrPXPYQp97pRbycbwrwJi3GGFnYTIsXFvegxbQkr+B10wLBa11+qYkI7ie1Qp7GPs35/LCks3m9pO5QxWZfzC8MvgY4Ooyotk00tLKM6KHG11TxVcaa10SUaO+Hgq2Rpsht/RxMM/M/pvPlrQCRg4IerBdsAG2vxMoZavpnE+1w210G0XljyLK436TJv8e8Mz1grRTv1bs5TzR4qRhvoIRAFBwLIBlMpS+T1YBELzQCFvobhj5Ysz4xN4Glwv9NrbQNx2VZfnff8pYzS/CCBcfB9xN5RZB2V6C4ZTor9Yt2by3InPeyOJB4+p279hOBzCKYF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(39850400004)(136003)(66946007)(66476007)(54906003)(316002)(55236004)(9686003)(16526019)(26005)(5660300002)(86362001)(4326008)(186003)(66556008)(956004)(7696005)(55016002)(83380400001)(2906002)(7416002)(53546011)(8676002)(6916009)(8936002)(1076003)(6666004)(6506007)(52116002)(1006002)(33656002)(478600001)(44832011)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HeQorAorL7kfS7nsFDZSaDP/doLRnKBDjIIlOvdDrERjv4+bttwtqqceLpUZ5QMcHq/uA3fO4743FK2Fhy2iY3D6zLLmNGIUIQ2hxwuAheuRz28pSAnz012RZVWS1OO9ghfyOyON2mwDuitukjm/7O3efjFNfW5cpGwiP4xTzJyCqJe8wILsJrBdORLcyYsWrgN8k2HydY5PTN7/9iWqZ41usfIzmh4eH1Rn+jTLf0tTFdNS8BZlrdP65Xoabcvj6umRa/Jox3D0WGMR4djfLll/WPpiY2THlldyO1u4N/I/FlwIzh6HbD8IOfCDtWewDEs5myrWASlYlZ2GOFDqvUcwCpsV255L4cU6o4cADGVJL/SelxSL99lpnpPZPmz3Bat6O8Q1NwmXVe488mlTpqVO3VrhQv7i4NkxCLzE7E/WASGfLxZ571LJwweUh66KcY9NtAIM4Tq4ttXC4k4aznmWVDLJnRUKkC/8Fe1Bf7/TvD57h65H4jLUfmjBcK2nnax4E+gGmHw+FQD5oB8/1rwcK0l5FPKfSoyy4r5Q4vkxWNXAKLx8mHXTM/oJtGR1fXlKs/78+se70jhz+7ts2NaIuBiUvEUVklnlscKC4aQ5L43WCQ5g7J7AJVei6K2JkGsQdaoYpHDBm5t8POqa7Q==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 661a2880-16a4-4658-031a-08d867c698f8
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2020 18:03:14.4049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f7c7VtR2yGzdIzWhsTVhBdI8RO4eBMQctU+kW9auL1NRj82sWy1kEjpdPx5YbsCGfgsjCDDcq3vjEdTmWaGf9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB3955
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell and Florian,

On Fri, Oct 02, 2020 at 04:50:26PM +0100, Russell King - ARM Linux admin wrote:
> On Fri, Oct 02, 2020 at 08:14:07AM -0700, Florian Fainelli wrote:
> > On 10/2/2020 4:05 AM, Grant Likely wrote:
> > > On 30/09/2020 17:04, Calvin Johnson wrote:
> > > > Extract phy_id from compatible string. This will be used by
> > > > fwnode_mdiobus_register_phy() to create phy device using the
> > > > phy_id.
> > > > 
> > > > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > > > ---
> > > > 
> > > >   drivers/net/phy/phy_device.c | 32 +++++++++++++++++++++++++++++++-
> > > >   include/linux/phy.h          |  5 +++++
> > > >   2 files changed, 36 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > > > index c4aec56d0a95..162abde6223d 100644
> > > > --- a/drivers/net/phy/phy_device.c
> > > > +++ b/drivers/net/phy/phy_device.c
> > > > @@ -9,6 +9,7 @@
> > > >   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > > > +#include <linux/acpi.h>
> > > >   #include <linux/bitmap.h>
> > > >   #include <linux/delay.h>
> > > >   #include <linux/errno.h>
> > > > @@ -845,6 +846,27 @@ static int get_phy_c22_id(struct mii_bus *bus,
> > > > int addr, u32 *phy_id)
> > > >       return 0;
> > > >   }
> > > > +/* Extract the phy ID from the compatible string of the form
> > > > + * ethernet-phy-idAAAA.BBBB.
> > > > + */
> > > > +int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
> > > > +{
> > > > +    unsigned int upper, lower;
> > > > +    const char *cp;
> > > > +    int ret;
> > > > +
> > > > +    ret = fwnode_property_read_string(fwnode, "compatible", &cp);
> > > > +    if (ret)
> > > > +        return ret;
> > > > +
> > > > +    if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) == 2) {
> > > > +        *phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
> > > > +        return 0;
> > > > +    }
> > > > +    return -EINVAL;
> > > > +}
> > > > +EXPORT_SYMBOL(fwnode_get_phy_id);
> > > 
> > > This block, and the changes in patch 4 duplicate functions from
> > > drivers/of/of_mdio.c, but it doesn't refactor anything in
> > > drivers/of/of_mdio.c to use the new path. Is your intent to bring all of
> > > the parsing in these functions of "compatible" into the ACPI code path?
> > > 
> > > If so, then the existing code path needs to be refactored to work with
> > > fwnode_handle instead of device_node.
> > > 
> > > If not, then the DT path in these functions should call out to of_mdio,
> > > while the ACPI path only does what is necessary.
> > 
> > Rob has been asking before to have drivers/of/of_mdio.c be merged or at
> > least relocated within drivers/net/phy where it would naturally belong. As a
> > preliminary step towards ACPI support that would seem reasonable to do.
> 
> I think even I have commented on specific functions while reviewing
> patches from NXP that the DT/ACPI code should use common bases...
> 
> I have been planning that if that doesn't get done, then I'd do it,
> but really NXP should do it being the ones adding this infrastructure;
> they should do the job properly and not take advantage of volunteers
> in the community cleaning up their resulting submissions.

I'll work on it.

Thanks
Calvin
