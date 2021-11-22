Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CEE4592E6
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240207AbhKVQXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:23:25 -0500
Received: from mail-bn8nam11on2127.outbound.protection.outlook.com ([40.107.236.127]:5473
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240217AbhKVQXU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 11:23:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cuzJOEDy5U3fr8r/JQj9XhGUDIye1U/DnVdz1kq41ACYhf2wUCA/uu3zeT/QM1QqCiIN7prgYq5XdW4Vb1jHvuEXbPf9YfH3OIUg3jPOWvzamzj5FHMX8++F7dG681zMjHI4sBNIJGjqItgGoAEBqSf24iTGEg2fxd2rUGmXCFIcQ4neKJGfzM+WrUK75DLcdtLjrugwssMQonMdt0eiJgev8GW003Xf5kOfWzdNFRwrECeLsDHFjvxCP7xcta21VycdIZqnl8gFM4bnpaXYf7/iLyweHiYPPOKXTeCVhKy+ArzH+6GpzbOWqWybgB9kd1nR9CVDiKLAlNmXyS8HCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=92MB8lrFdHCS1rHgf/zIfLU+noz7/4Epo//bLB/RwZc=;
 b=lxZf+oLi8F4wJw2/g7N4YPaLE/GIFA9qXmEv7AiYJMXTI0g0Mne0nF4GSZCOGPtKlT8ue/uSrDKezM5WMYJwFKwf7Wzrp9vGeOyn+sti/b3inEOfJb2qLWztco9gxq45egSL7WiCvLmsMoH3qJhBanZkKwjsVm3XoyHDhSbevUOqtnZyXLA64kv5JaG/RobXV3oiph/U/48NyYSO5HbMrGGwWg7/R8MmY4HkqQurZy1sePpnkfJ6gke4hcIdqU+/rO7Z7V6ruBDl8WcZhFKvmIgiBuKLmXb5rxM86cQodoVzeSkNKD8u1AYYlNo68nMFzHApDrtE0sRTUgcYxvFZyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=92MB8lrFdHCS1rHgf/zIfLU+noz7/4Epo//bLB/RwZc=;
 b=LOKwScyrBJSeRdxyN9/5G/4LxS61PrOikJyEvyhwoZKP0L0/vFGvowHOfh/2NHx+fZrxqaXPYZaKkswbWgWfQR/YLTWD+tqNpS3eiMQEV5OPWOqup7gj+zPwgQ2kHdk2OOfk+7U/cM10ZNxqfYsB8EDatJG2xWcgTy8WCCVygfs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5458.namprd10.prod.outlook.com
 (2603:10b6:303:138::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Mon, 22 Nov
 2021 16:20:10 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 16:20:10 +0000
Date:   Mon, 22 Nov 2021 08:20:12 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v1 net-next 4/6] net: dsa: ocelot: felix: add
 per-device-per-port quirks
Message-ID: <20211122162012.GB29931@DESKTOP-LAINLKC.localdomain>
References: <20211119224313.2803941-1-colin.foster@in-advantage.com>
 <20211119224313.2803941-5-colin.foster@in-advantage.com>
 <20211121171324.j6kxclyhaheihpja@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211121171324.j6kxclyhaheihpja@skbuf>
X-ClientProxiedBy: MWHPR20CA0023.namprd20.prod.outlook.com
 (2603:10b6:300:13d::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from DESKTOP-LAINLKC.localdomain (96.93.101.165) by MWHPR20CA0023.namprd20.prod.outlook.com (2603:10b6:300:13d::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Mon, 22 Nov 2021 16:20:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81608159-7cd0-4fbe-f9ca-08d9add3f43b
X-MS-TrafficTypeDiagnostic: CO6PR10MB5458:
X-Microsoft-Antispam-PRVS: <CO6PR10MB545875583BCBB8C8351031C3A49F9@CO6PR10MB5458.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JTZNo5h22ie4BtJKYZIETLB8WEDe6BJOX3tX1ffwvqHKrYEE92TgIxXzyG4Ay9ZTow12HBciZKIp+FEFNIf8JBtub1Ocq1nPDACXYH+CXqpnTfdy41/Y8P3cBETzNZI9rQ7NHRZMSvpGWWyyuBj8WT3q2C+13jRx8jcSzUi9P/JZwMFNeY40x7UDs/+RE6cxfeyG5dnfzy0TJMe2kTtzrMHo0HHfTD8lius3FdYWoNj1/HwD+L45iiWCdC3OsNv2W6d7M30toAjAHOsqlzSrfSrGUhpsVSnDKug7bjd1RjEWymvzV6bIyCGL34pKHpqrznqa0Ix77fEJcoXBctTwRIzn8uurOMMu/SYayNSSDLk+TqbiYl+xsP3joyJuDIvVx9v6APJ3RvOrb5JOUmsOgglUz7P9IPiA5b1BECFdb3tltxnxrhIc/b2ktQtDU1y02F4FkwQlOJv9kGbhndsYHI8o+ko1yJDO/9i4bQR7yO0dIcowFhJWLws4JOvrfbgEk4gD7FYiV2tC+sZY7i+VmSWzLpIuuZaSaAkd0du6ZsfEac+DsdLe4UxrB4N/YOtsSq+YRjtgiN4Dz4zPyQ7eV3WAX67aVFzwOr2AIa12QQjjrco0UpvMSbVcQX1EJqcyZzmQwo6wIIJxbJVBKd0eLl5aczskVft+AqEBSA2XixC7n/T9NFNppSk81326navK8pg5dBUY5A/MlI1hSs1ozQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39830400003)(396003)(136003)(376002)(26005)(6916009)(33656002)(508600001)(38100700002)(38350700002)(316002)(66476007)(8676002)(86362001)(186003)(66946007)(6506007)(1076003)(8936002)(9686003)(4326008)(7696005)(66556008)(52116002)(54906003)(956004)(55016002)(44832011)(83380400001)(6666004)(2906002)(7416002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tSD29ZfTXVQAtMG7l3nT3WZZ1Ve+PkyOF77p2XEFLNVuL307rhwPZ57Q23x/?=
 =?us-ascii?Q?GdZH83Cq0DqGk+g02CfCu1P0/+ErkORYljm+echOl0J1kjOOWc7eItywsRim?=
 =?us-ascii?Q?2IjHRh94n6aVc/ekxJqy9VBYwz7rjHScXgL5G4BFQcvDo4492545em5IdVas?=
 =?us-ascii?Q?zDl4y0rVJfP8hvoTJXZI0L+DFRZS2Bdr1nfKT0IBC2+7rRHW5wnsCuAVWWl+?=
 =?us-ascii?Q?sm6LSrVw7UrRTqw5mDG+Ee4ACS075fTO+26IXN5hU2aDX2k82Am1IHHkF4T5?=
 =?us-ascii?Q?3o1BzaklWUsq8R5wLRW3mB6yKyoL2nJjF5e5lnhDKg7Ydhf6pT4HcVyOKfYO?=
 =?us-ascii?Q?sOtMD5BmtMfSUSysUL+CpIn7Rwqo2rDuIe96obI6F8CRsywLdPGc4TLlQ8M3?=
 =?us-ascii?Q?UfPDGLNQUpaC9bnrYNXsdjcAIDi4RMbdS2RwOuYqTV8TECgOnNT8NBakWXWc?=
 =?us-ascii?Q?82szXIb/9Z5+0uIfGbtiTvgbacNaZYVwfn+YNX5V20yjwAC8O7ixIOP+fUu4?=
 =?us-ascii?Q?ncenPnLPebamEiMXKC6lnJ+1DGMgfmRIZKwdIyoZls5iFr2wrR2CfsujAfgn?=
 =?us-ascii?Q?c2Ci3BSIb9pTLw9ErmWHG5sQdztXsSCDTMWjf27ozItig49z7lQcHioXCNCO?=
 =?us-ascii?Q?Q4MzASpZgYQaNcWK0lHvxSMYdV7xiobWoso0Zdj7jYw9A/Jn8NhNUQxso5p7?=
 =?us-ascii?Q?YgHbaia+eeeh6Hyg2BC3cJe6oAGR1vL5INOh5NOAJ1BoBsW0iRo0Pao0iEkP?=
 =?us-ascii?Q?eTU/kRdqGIUj0aVc1+MNrNhAsD5JQ4Je+KzSi3/DK0XDD+EyiruYumZCS6iF?=
 =?us-ascii?Q?/JT/T1k1li0mR0iBkS8SGSCER1EAj/Iw0ckjLH3Flkn/p+EPW60Io6VKdM04?=
 =?us-ascii?Q?NFnT2Cv2JgVd6RDqPuQVUbaDDOo3QsPWmr1qIek7jQjWJsGD/mPGI08+nn/8?=
 =?us-ascii?Q?ik0uQPjLJmTIKrf+r9ny0Fprd2+wlvZXaoBt8PW+aS0Im3ibZzOvh7q7wFue?=
 =?us-ascii?Q?I9c8t5Rcb0KTuDooT++suFO5njOWYPJe+kIzW6BG5iN6UOnIoRnrXEQ4tGEg?=
 =?us-ascii?Q?9oTOyFLqXuj7X/0mDi7WJJUygcID6FXxOZRGuCZETmfW1tPMZuhEMm9Lkt4u?=
 =?us-ascii?Q?qv6fEa0+YEULGAbVC/rQgVOCZcNytZURKmhdMKd1zt0TSQi0uBGD7xoucYEz?=
 =?us-ascii?Q?GdyGOwThkj3dZlWlqIP7xrtjeTbBGEUE8y5+F5z5/2ceFVz1/wvoYFjLlzCJ?=
 =?us-ascii?Q?cb2NBaTtc0xtW8PU6Hykn1K6L4pBy8IQoXC7NZdNSq3XwxEkp+z3R/6vJ729?=
 =?us-ascii?Q?SW502bDppsXLM2O8o1mg2icz1MOr8Sdse8DeL2KA3wUNnM+CmDlogrhCdFkP?=
 =?us-ascii?Q?i2iw4bMUJ7L+NK38DcHQbWbJR9JelsK/LFDHe3VaXYiaSg7K6CrGvGtp2xGg?=
 =?us-ascii?Q?od/N4wxT0hYnV5hM5lbpKJ9N3MjXxqm7CJp2qBqklDpFk2k7FCsuFYzvZ0D4?=
 =?us-ascii?Q?hKFIxQcUmHB8HiVR/+TZnh8emjOuhBOhJl+brCgzMqqLr0HlUUbX2J6YVReJ?=
 =?us-ascii?Q?AAGiJFAzZbMDnNhSSb78HkO5w4dn0lpft4sWovLCiTgtWxK5Nz+9u3nCzkpR?=
 =?us-ascii?Q?gH89U+c2cWJXkJsVy3wJPf33blTZG6uGXZcrJuQx164thDfBlh+PJe66/rmB?=
 =?us-ascii?Q?rGiao64d3b4fppsnclUHiRgW8Go=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81608159-7cd0-4fbe-f9ca-08d9add3f43b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 16:20:09.8800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CeMihAa5V66ILh1lJCGfRtxx53kb38EEV40DaBOSOQ4iqfnHZrw5YhPVdyRTXfBZIlvjgk5C2qluhi7dKRs1NuRPfJNkLRE12PRHFCtjqe4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5458
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 21, 2021 at 05:13:25PM +0000, Vladimir Oltean wrote:
> On Fri, Nov 19, 2021 at 02:43:11PM -0800, Colin Foster wrote:
> > Initial Felix-driver products (VSC9959 and VSC9953) both had quirks
> > where the PCS was in charge of rate adaptation. In the case of the
> > VSC7512 there is a differnce in that some ports (ports 0-3) don't have
> > a PCS and others might have different quirks based on how they are
> > configured.
> > 
> > This adds a generic method by which any port can have any quirks that
> > are handled by each device's driver.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  drivers/net/dsa/ocelot/felix.c           | 20 +++++++++++++++++---
> >  drivers/net/dsa/ocelot/felix.h           |  4 ++++
> >  drivers/net/dsa/ocelot/felix_vsc9959.c   |  1 +
> >  drivers/net/dsa/ocelot/seville_vsc9953.c |  1 +
> >  4 files changed, 23 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> > index 2a90a703162d..5be2baa83bd8 100644
> > --- a/drivers/net/dsa/ocelot/felix.c
> > +++ b/drivers/net/dsa/ocelot/felix.c
> > @@ -824,14 +824,25 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
> >  		phylink_set_pcs(dp->pl, &felix->pcs[port]->pcs);
> >  }
> >  
> > +unsigned long felix_quirks_have_rate_adaptation(struct ocelot *ocelot,
> > +						int port)
> > +{
> > +	return FELIX_MAC_QUIRKS;
> > +}
> > +EXPORT_SYMBOL(felix_quirks_have_rate_adaptation);
> > +
> 
> I would prefer if you don't introduce an actual virtual function for
> this. An unsigned long bitmask constant per device family should be
> enough. Even if we end up in a situation where internal PHY ports have
> one set of quirks and SERDES ports another, I would rather keep all
> quirks in a global namespace from 0 to 31, or whatever. So the quirks
> can be per device, instead or per port, and they can still say "this
> device's internal PHY ports need this", or "this device's SERDES ports
> need that". Does that make sense?

That makes sense. I'll be able to get that into v2. Hopefully I'm not
too far from getting the additional ports working, which is when I'll
finish the PCS logic.

> 
> >  static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
> >  					unsigned int link_an_mode,
> >  					phy_interface_t interface)
> >  {
> >  	struct ocelot *ocelot = ds->priv;
> > +	unsigned long quirks;
> > +	struct felix *felix;
> >  
> > +	felix = ocelot_to_felix(ocelot);
> > +	quirks = felix->info->get_quirks_for_port(ocelot, port);
> >  	ocelot_phylink_mac_link_down(ocelot, port, link_an_mode, interface,
> > -				     FELIX_MAC_QUIRKS);
> > +				     quirks);
> >  }
> >  
> >  static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
> > @@ -842,11 +853,14 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
> >  				      bool tx_pause, bool rx_pause)
> >  {
> >  	struct ocelot *ocelot = ds->priv;
> > -	struct felix *felix = ocelot_to_felix(ocelot);
> > +	unsigned long quirks;
> > +	struct felix *felix;
> >  
> > +	felix = ocelot_to_felix(ocelot);
> > +	quirks = felix->info->get_quirks_for_port(ocelot, port);
> >  	ocelot_phylink_mac_link_up(ocelot, port, phydev, link_an_mode,
> >  				   interface, speed, duplex, tx_pause, rx_pause,
> > -				   FELIX_MAC_QUIRKS);
> > +				   quirks);
> >  
> >  	if (felix->info->port_sched_speed_set)
> >  		felix->info->port_sched_speed_set(ocelot, port, speed);
> > diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
> > index 515bddc012c0..251463f7e882 100644
> > --- a/drivers/net/dsa/ocelot/felix.h
> > +++ b/drivers/net/dsa/ocelot/felix.h
> > @@ -52,6 +52,7 @@ struct felix_info {
> >  					u32 speed);
> >  	struct regmap *(*init_regmap)(struct ocelot *ocelot,
> >  				      struct resource *res);
> > +	unsigned long (*get_quirks_for_port)(struct ocelot *ocelot, int port);
> >  };
> >  
> >  extern const struct dsa_switch_ops felix_switch_ops;
> > @@ -72,4 +73,7 @@ struct felix {
> >  struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port);
> >  int felix_netdev_to_port(struct net_device *dev);
> >  
> > +unsigned long felix_quirks_have_rate_adaptation(struct ocelot *ocelot,
> > +						int port);
> > +
> >  #endif
> > diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> > index 4ddec3325f61..7fc5cf28b7d9 100644
> > --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> > +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> > @@ -2166,6 +2166,7 @@ static const struct felix_info felix_info_vsc9959 = {
> >  	.port_setup_tc		= vsc9959_port_setup_tc,
> >  	.port_sched_speed_set	= vsc9959_sched_speed_set,
> >  	.init_regmap		= ocelot_regmap_init,
> > +	.get_quirks_for_port	= felix_quirks_have_rate_adaptation,
> >  };
> >  
> >  static irqreturn_t felix_irq_handler(int irq, void *data)
> > diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
> > index ce30464371e2..c996fc45dc5e 100644
> > --- a/drivers/net/dsa/ocelot/seville_vsc9953.c
> > +++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
> > @@ -1188,6 +1188,7 @@ static const struct felix_info seville_info_vsc9953 = {
> >  	.phylink_validate	= vsc9953_phylink_validate,
> >  	.prevalidate_phy_mode	= vsc9953_prevalidate_phy_mode,
> >  	.init_regmap		= ocelot_regmap_init,
> > +	.get_quirks_for_port	= felix_quirks_have_rate_adaptation,
> >  };
> >  
> >  static int seville_probe(struct platform_device *pdev)
> > -- 
> > 2.25.1
> >
