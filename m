Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6AB9453CCA
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 00:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhKPXrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 18:47:13 -0500
Received: from mail-sn1anam02on2104.outbound.protection.outlook.com ([40.107.96.104]:52693
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229532AbhKPXrN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 18:47:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ThrDGOESejn+zGkcvdF8GHeE/Y9XcNJl3tj+/BQ8bDp4zly6KhabyDmuk07+xvDXNTiYXqtrXTG3k4VjIGoOAO+4VHXQRA5iBqPIdYA8gkAKoFVM3HbsRKaPNtxvo6jFf17HH6p4gBKqr3ezC2LmmVCNJv1xHOO8yx7pgkQhnV7iQgtTiO9hb+vzTHDo2vkTMYGWgLChddu9sEJITcCej5/JrV727l6U8SkvS4Uj6KlYZ+JiCB+NbL3NRnBTuzB9yDujPs3O9ZNY/HcmwxfM2Rr1juEK1DS+vo+kTV3T9/UrC3OgR9/C2HeUhokSbtUDEZQGoqzYve+UrsWP/GFE+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2NDczfA6+KlJpuRUgBQOb+QNu42v2BnsgMANx13wLtU=;
 b=LfQJbCxD72QQiaj1icIfL+JaSFI2Qf7qChYMQJ09Xift2l4rA0784f6Ub8WRDCa+4neqzg9+of7MpmYmqrovEzwreRr93bzdCYJtvNM3XDYPG0FZBSkYzAfMXGOD48sF6fZcKHWl7cQO9XQSp6fPmIyjsP2XJz6AU42bsz9JVj6yuFGf3nKRNxlgAmO8Omjv1o92ApQ5+vZDRIBaY03ANrS4xTy2nBV3/MEG6ll4ZAI475NCIElWy+y0eLYLgsMoboQhn+15tldGXhbgUHQNYs4dioMg6doCSeeI0gt/mdSnfPwcfWpmsXjhp7zLKt1LjJG3J9YceZwmIeUg6lE2cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2NDczfA6+KlJpuRUgBQOb+QNu42v2BnsgMANx13wLtU=;
 b=yFdFP+loRTP0YmcMqcRu5WJhCbopd3MYyAGHsOA31IV81fvGFH8qe/nJJE2sNuXFJqY5CrRNRx+mmS00L/jk6jrKfLKV4QBpnM+31hichaVPGNSz8mz2lEAcvEyk/OlQjORHQ+o3w29AojF+AMINvNm7G7lEOM9ukDsL9VFPegM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5393.namprd10.prod.outlook.com
 (2603:10b6:5:35e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Tue, 16 Nov
 2021 23:44:12 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4713.019; Tue, 16 Nov 2021
 23:44:12 +0000
Date:   Tue, 16 Nov 2021 15:44:13 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [RFC PATCH v4 net-next 00/23] add support for VSC75XX control
 over SPI
Message-ID: <20211116234413.GA14085@DESKTOP-LAINLKC.localdomain>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
 <20211116225652.nlw3wkktc5c572bv@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116225652.nlw3wkktc5c572bv@skbuf>
X-ClientProxiedBy: MWHPR04CA0066.namprd04.prod.outlook.com
 (2603:10b6:300:6c::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from DESKTOP-LAINLKC.localdomain (96.93.101.165) by MWHPR04CA0066.namprd04.prod.outlook.com (2603:10b6:300:6c::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 23:44:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b71c443b-0269-462c-6a9d-08d9a95afdbb
X-MS-TrafficTypeDiagnostic: CO6PR10MB5393:
X-Microsoft-Antispam-PRVS: <CO6PR10MB5393D4F13EC017DBBFFA3CE7A4999@CO6PR10MB5393.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mHYJ2pujDXX7+fvQ3odEl4OdEx60ah5eQW07u6ZTFfjdv+k2bDzmYmr1gZ1+gs5xIE7ZpfOXPGIWT8qnhVhVs4/NMOAWM07qKbU/XJqJSfJzCD4WAYf338M3ZHOppAL1Gasi6b3IWVxWaxwl0emiHW16IINXSnAfQNB08/YppOEKePNkjzx8jkyQXuwAgiodjmNfbWodfvCDBJrCdhjbgePCof13bVzyiNUMwdw5MH9jKmSB/Ll8HpBGa41WZPZe5xYuIF0Yeqt5PQAVKkIoS++wgT+eDVJqciicMku35H3KYs/3UlOM549Y1tueh/zWIGZqJ4n3fGlByIwtu0Fa+K2gHZdnQHR/MS6jnR77Yz7cH10RE3lOwyveFcWjzjRSweLJo0uGe+KAVxnL/HKDNdDVhkfR2HQm/HPNV6vRpS13HHI8kWsWmG/XrHngUP7JiXhUP6Q5YUsVAQBFbrTItFXRZvSi+m+hbZryzvHyOB34rYJuKwPFcydN9giECMeczbjpODiRp5zA2jD++e5OVEw0mdBbmfhxMJJsJJ0upMNULsoqA57np5PxOWmNLbQGBQiaa+B/sPOaUZH8iDBS4pmXC5yWuB7yP/Qc9pYQ6FHyQf48iJbpmksUNxphDtE5lLVnlMRdGjIw7tgXFeRXaQ6pNznfE4S/JokA1jxRmng8bscyo3Jtc8mKDbtNYvrHGOsYsh2jf3vWq/Fx6K8dtfs7HMagDCqQ76hWQhsn0E0RDAukahbP4RaBE0jABz5jeznq00/zq9Yqf/2jmNWzhAE4j/tpUVkZ+DDkI54XrTs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39830400003)(376002)(396003)(136003)(366004)(55016002)(316002)(66476007)(186003)(4326008)(66946007)(66556008)(44832011)(966005)(83380400001)(8936002)(1076003)(26005)(7416002)(86362001)(508600001)(6506007)(38100700002)(5660300002)(38350700002)(2906002)(52116002)(54906003)(8676002)(6916009)(7696005)(956004)(33656002)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+iv2uuxR1PYPlwp2e0IqzNQm73L5t9Do2OL7AR6CO2h0w9O/CM+v44qBbQZM?=
 =?us-ascii?Q?7Z89PAhkFySNgRsBRdqI1PPvB0aOyYdDeTALUXN6PrvB77FAX3axjt9MhWCV?=
 =?us-ascii?Q?DoEXbOhLBrKDBhCFplIaoCgIdLZGntYDvhEpEoyiRpZiN1zhmz7Zb21wm/zb?=
 =?us-ascii?Q?8AehqCXZ86LKePdc6R62HdkHJcIn0/f/qizE0GnTNky3GLmMN5bzWb3cjYtb?=
 =?us-ascii?Q?+wCPnQsphNhePF1OrYX6U/U5pUWVWvFPaEG61OM7qWsGq0kPJsVAhzsOA7KE?=
 =?us-ascii?Q?h59ZXS+p/fJde9qIjnESS3oA5pxA923IDEpyycrlX18DFC2sd+vziZWE/vuh?=
 =?us-ascii?Q?i4zq7E4GYTCQjlK/rbaVs3gJn2RiVDHX5WXqMhXthFY8aM+jQ5x1JBAfpmq4?=
 =?us-ascii?Q?kkgSFq4u2QyLAX28X2+JXb31niXzAx/x+T6M+zTu9TEtjOqoT8oMMlYjp287?=
 =?us-ascii?Q?GjwtV3CQH0K216sIEQrhOwZ7j91ngaLux94ubjRngXr5vBBQXCEOLVziSdxU?=
 =?us-ascii?Q?1jsCQXurKhzJVbH/F3n4OAa0/B0bdib/638sH31TekVLwDumr9Aak9grFFp0?=
 =?us-ascii?Q?0Nev/jKzWKWPJeuvQEaLq7R6IesfUoKw8X3j3H+xCnBKcCcZ1znb6w3G/1Fq?=
 =?us-ascii?Q?U0qw9MQPETW/hIhMPfGvS04xA9gLqCpH0Y3EQBH08vW0VReT2JsyXRdrfJpg?=
 =?us-ascii?Q?ErMsDE9CSEEIMgI7YHyOhFSBj/rkSEHXJZLTkh+JnOrXwjUrxr42D7zA2Prc?=
 =?us-ascii?Q?kxvCAWiK5ReJ1JFtYPgh7WJpySigxk5XT9PznMG4F27ip1aCGVo2QQ1K0Yb3?=
 =?us-ascii?Q?S7DldacBlbR2vdZIULyCMFREON65Y/LrHRa3tjj49rwMD6SdxGfua3s4gSiC?=
 =?us-ascii?Q?kN7wG3dt0t/DsMoPT5MQT/gldiNlA5t58xLEyCdCVTj7HtiCG/UMAjEM0nwe?=
 =?us-ascii?Q?le+bF32tP9g/HHSOAmCZmBY7x2HMNdwlHaGCqI6bggGJ+Iknl+ljVT/TKdxW?=
 =?us-ascii?Q?CXgQR6PeYKYNdpxH1RV4IvyByngKYvt/bHa/k/Nhq5cbjMMHoEaPGgdudjMe?=
 =?us-ascii?Q?0vhLg75RdqkR9wEBNeApluXNr3prw9k/3UcUlgqUKt01hymP9lQLdxeffQc3?=
 =?us-ascii?Q?n/ayxAN2VxsPcKcLudDdl4eSKhWzuCosbbNuoo4IwxWIgiaHszJ3uRxLVofZ?=
 =?us-ascii?Q?mKVFJ+K8bofWXeqQQXSce2sToKMbvaByUzva0eUM3EjsjzVys2fSfnTcD7iI?=
 =?us-ascii?Q?gx5J112c1a0eulUjaazPpsr+kQ1sfvodZDrMwzwWpCS3DqsQnz+Ddk81zjlp?=
 =?us-ascii?Q?crkM6i9ychg9hbNhJrVnNQA7CR21/mmsev2oyXXVcogtHaNs6j3Jym+xKwT4?=
 =?us-ascii?Q?Yr/0P8uRklMvmTcKZC05MfjNnxSMqcBuOYMASzzfCbNYONxbnzc5YQ2zTjoP?=
 =?us-ascii?Q?1W0/YtV57AQ4GhlmOUvLeMrFL1ccJWXw5N/JCdJgyKemknmFNgceNgpDRS2j?=
 =?us-ascii?Q?qDdGSrJC3l1tRVbcbBVPsGIxPeJvsRNu9UVZvUtcu5d+LvooOAB8r8d7qraw?=
 =?us-ascii?Q?vIR2jgpYUPyeINzUdBsEnYc+bRI1ACoUKxCeT0tU5lZm30VBLRrE3Jg2ws8m?=
 =?us-ascii?Q?Z8Flv6+Fq6tXrucia5CH+kW+1KUh7+/iv5REcOUXNWXDV7qAoOivyWtpPFL+?=
 =?us-ascii?Q?AP7zLG1SnTWAjeBMqKhmLqhHYEU=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b71c443b-0269-462c-6a9d-08d9a95afdbb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 23:44:12.4881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q4ofsnKkDydpWm4IxLyWLNshrHQCIvglOIR6JlGt7eqFpE1iFmzdj3oh0E2SP63PI3/TrvvPmZan6eIzYBXiBfD7pCppEjc680IY7ax9LDA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5393
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 10:56:54PM +0000, Vladimir Oltean wrote:
> On Mon, Nov 15, 2021 at 10:23:05PM -0800, Colin Foster wrote:
> > My apologies for this next RFC taking so long. Life got in the way.
> > 
> > 
> > The patch set in general is to add support for the VSC7511, VSC7512,
> > VSC7513 and VSC7514 devices controlled over SPI. The driver is
> > relatively functional for the internal phy ports (0-3) on the VSC7512.
> > As I'll discuss, it is not yet functional for other ports yet.
> > 
> > 
> > I still think there are enough updates to bounce by the community
> > in case I'm terribly off base or doomed to chase my tail.
> 
> I wanted to do some regression-testing with this patch set on the
> Seville switch, but up until now I've been trying to actually make it
> compile. See the changes required for that. Note that "can compile"
> doesn't mean "can compile without warnings". Please check the build
> reports on each individual patch on Patchwork and make sure the next
> submission is warning-free. Note that there's a considerable amount of
> drivers to build-test in both on and off configurations.
> https://patchwork.kernel.org/project/netdevbpf/patch/20211116062328.1949151-21-colin.foster@in-advantage.com/

I'm very embarrassed. I scrambled at the end to try to clean things up
and didn't run enough tests. Sorry about that!

> 
> -- >8 -------------------------------------------------------------------------
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index b1032b7abaea..fbe78357ca94 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -1127,11 +1127,13 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
>  
>  	for (port = 0; port < ocelot->num_phys_ports; port++) {
>  		struct phylink_pcs *phylink_pcs = felix->pcs[port];
> +		struct mdio_device *mdio_device;
>  
>  		if (!phylink_pcs)
>  			continue;
>  
> -		mdio_device_free(phylink_pcs->mdio);
> +		mdio_device = lynx_get_mdio_device(phylink_pcs);
> +		mdio_device_free(mdio_device);
>  		lynx_pcs_destroy(phylink_pcs);
>  	}
>  	mdiobus_unregister(felix->imdio);
> diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
> index 268c09042824..12a87d8f977d 100644
> --- a/drivers/net/dsa/ocelot/seville_vsc9953.c
> +++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
> @@ -1037,7 +1037,7 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
>  			continue;
>  
>  		mdio_device = mdio_device_create(felix->imdio, addr);
> -		if (IS_ERR(pcs))
> +		if (IS_ERR(mdio_device))
>  			continue;
>  
>  		phylink_pcs = lynx_pcs_create(mdio_device);
> @@ -1066,7 +1066,7 @@ static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
>  		if (!phylink_pcs)
>  			continue;
>  
> -		mdio_device = lynx_pcs_get_mdio(phylink_pcs);
> +		mdio_device = lynx_get_mdio_device(phylink_pcs);
>  		mdio_device_free(mdio_device);
>  		lynx_pcs_destroy(phylink_pcs);
>  	}
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> index 3d93ac1376c6..3ab581b777eb 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> @@ -8,6 +8,7 @@
>  #include <linux/of_platform.h>
>  #include <linux/of_mdio.h>
>  #include <linux/of_net.h>
> +#include <linux/pcs-lynx.h>
>  #include "enetc_ierb.h"
>  #include "enetc_pf.h"
>  
> @@ -983,7 +984,7 @@ static void enetc_pl_mac_config(struct phylink_config *config,
>  
>  	priv = netdev_priv(pf->si->ndev);
>  	if (pf->pcs)
> -		phylink_set_pcs(priv->phylink, &pf->pcs);
> +		phylink_set_pcs(priv->phylink, pf->pcs);
>  }
>  
>  static void enetc_force_rgmii_mac(struct enetc_hw *hw, int speed, int duplex)
> diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
> index f8d2494b335c..5f9fc9252c79 100644
> --- a/drivers/pinctrl/pinctrl-ocelot.c
> +++ b/drivers/pinctrl/pinctrl-ocelot.c
> @@ -20,6 +20,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/regmap.h>
>  #include <linux/slab.h>
> +#include <soc/mscc/ocelot.h>
>  
>  #include "core.h"
>  #include "pinconf.h"
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 6aeb7eac73f5..7571becba545 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -946,11 +946,12 @@ int ocelot_pinctrl_core_probe(struct device *dev,
>  			      struct regmap *pincfg_base, u32 pincfg_offset,
>  			      struct device_node *device_node);
>  #else
> -int ocelot_pinctrl_core_probe(struct device *dev,
> -			      struct pinctrl_desc *pinctrl_desc,
> -			      struct regmap *regmap_base, u32 regmap_offset,
> -			      struct regmap *pincfg_base, u32 pincfg_offset,
> -			      struct device_node *device_node)
> +static inline int
> +ocelot_pinctrl_core_probe(struct device *dev,
> +			  struct pinctrl_desc *pinctrl_desc,
> +			  struct regmap *regmap_base, u32 regmap_offset,
> +			  struct regmap *pincfg_base, u32 pincfg_offset,
> +			  struct device_node *device_node)
>  {
>  	return -EOPNOTSUPP;
>  }
> @@ -960,8 +961,9 @@ int ocelot_pinctrl_core_probe(struct device *dev,
>  int microchip_sgpio_core_probe(struct device *dev, struct device_node *node,
>  			       struct regmap *regmap, u32 offset);
>  #else
> -int microchip_sgpio_core_probe(struct device *dev, struct device_node *node,
> -			       struct regmap *regmap, u32 offset)
> +static inline int
> +microchip_sgpio_core_probe(struct device *dev, struct device_node *node,
> +			   struct regmap *regmap, u32 offset)
>  {
>  	return -EOPNOTSUPP;
>  }
> -- >8 -------------------------------------------------------------------------
