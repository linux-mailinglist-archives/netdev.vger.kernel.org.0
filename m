Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF75E54A9E7
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 09:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352626AbiFNG4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 02:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351660AbiFNGz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 02:55:59 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146D739BB2;
        Mon, 13 Jun 2022 23:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655189759; x=1686725759;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IOXK7SMgWOcClEU80d0VIYj8RRF08+IaKtwkGIFpWFs=;
  b=Xi5pRLdpZbasrfp6fA9Ub2eq7Mdn6hKIFpZ8PGK72244Vc/kAbwD2lsH
   hWI+pYPNOGXS447jP/+Ncni6czxBbCjLj37CuOTG/e5h/U3ZVsiZVTLFl
   Gml+Pj0g70K0cLklIY5FBeyQqjmE/OnhLrEqnsJodCBD5fxY3dR/GKM9h
   fpGbYBySQG1/vv98iXcS79kjDzPdeec/O2r8KBoa92CiUTWRgPGtYZ3Or
   Tz2u+jHfyvnB+VpXph5dXLNNW2UPIUr9EWatBvW9azFleRpYAKLlkciyb
   GyhdWhWAIYKJwAvXlrlOMg/IKDfixwZ1CDo40P7g36H1Dkt78VHbznNLf
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="364862724"
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="364862724"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 23:55:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="569784993"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga002.jf.intel.com with ESMTP; 13 Jun 2022 23:55:37 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 13 Jun 2022 23:55:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 13 Jun 2022 23:55:37 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 13 Jun 2022 23:55:37 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 13 Jun 2022 23:55:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i0lgzlasyxfkQGTurUeuDTNp1O1jb+l2CVtjNBba3S44evQ6b6FkCvymDCTqrjLpr816ylkhVes2xv6VJ25Cqv5Ky+Ip0+lGthqzmynLYf6quYsUU+oKvY7fmqSLMSWVIcAmbCF+e4I5+akwoySN1iiTZK3nmE8+xv3mynFsNXkwfR/zLqgfAGTplkqrU2GcEdvuqSe5Gve3ku/H7MQvyTNqB+NlBYoV5eZQL6IGrbZtaak+IJE7ercxdFrXhGO5Nq9sIXF4iDu2nE9Salmu/PhGi2HxSNzlOeq6BFFBrbQ2jVi9m9sppfhqbel9NELKUHsTeQTI13JUaTQXuDNSyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vnsHZtwZrMfWDNoybGikO1qSSMST8SjePjkNzKShK90=;
 b=WWhKYi6FL17bLfaTHdylo8pdyWSg6mZJVFp+KJfNT0ITCixvWZUg8hgBp2nVay6H27JSi0j//XpDS/wVwt2sOUGybmDUPDcPnSJAinczRnmiGGCECstx3bQNbYMRkLDSeABfLZn0zgDVjJhrBz3iqRF3ZZBZeK+cYWSX4K3fzqvl2LALh6TISe2rYmWnbQG3b90NAbdq5H45KyHQUPyerCIyUJdBv3QSAdyNVPjA77XDuJLc0N9kERsBya5pbCOwCXXFhrIFH2IAh6bkHEKXM1HHLZWO0uxR8R6caRe1fesqmZE+T0mmL0RRk2Wq9z2f9hxhNk5TgLwR/h8IJdXqiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB6095.namprd11.prod.outlook.com (2603:10b6:8:aa::14) by
 CY4PR1101MB2072.namprd11.prod.outlook.com (2603:10b6:910:1d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.17; Tue, 14 Jun
 2022 06:55:34 +0000
Received: from DM4PR11MB6095.namprd11.prod.outlook.com
 ([fe80::40e5:e77a:f307:cbb3]) by DM4PR11MB6095.namprd11.prod.outlook.com
 ([fe80::40e5:e77a:f307:cbb3%4]) with mapi id 15.20.5314.019; Tue, 14 Jun 2022
 06:55:34 +0000
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Riva, Emilio" <emilio.riva@ericsson.com>
Subject: RE: [PATCH net-next v4 5/5] net: stmmac: make mdio register skips PHY
 scanning for fixed-link
Thread-Topic: [PATCH net-next v4 5/5] net: stmmac: make mdio register skips
 PHY scanning for fixed-link
Thread-Index: AQHYf5ugFwi0SKzv4ES7W3EzAJ0m/q1Od63g
Date:   Tue, 14 Jun 2022 06:55:34 +0000
Message-ID: <DM4PR11MB6095E66B71484D942DFDB5EDCAAA9@DM4PR11MB6095.namprd11.prod.outlook.com>
References: <20220614030030.1249850-1-boon.leong.ong@intel.com>
 <20220614030030.1249850-6-boon.leong.ong@intel.com>
In-Reply-To: <20220614030030.1249850-6-boon.leong.ong@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78f65091-e1b0-4a82-c8c7-08da4dd2e157
x-ms-traffictypediagnostic: CY4PR1101MB2072:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <CY4PR1101MB20729E879EF16F80F70DFA1CCAAA9@CY4PR1101MB2072.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wVJSrRHdI7WPwUXBUjpsRyXJxneRXMW1KV2c1gRJCJtuYTtEcSNRQjshg8il0S4OQpyvV7wBHU7MQ3mz7LEYoq5v0RW4O4xJJ61euBjC4gDCW3hKsOeIslvHlu9oGs3XClUj7qfqOf+FCq73hKgD0h9d/Sms+yAs36znI8pRrnmSROyskTPnCPcCpL+htFxtKg1dFpvpafVyhGCfM6uPKCkAeeHEX96soKZgV8Sfs6l/HCcJ76RfJGxzqCQqbm7lw16vlu43/rF5pS1KAIsi+ATZ6lih51MtknhcQFZh6+3HC+MNIuDPX6QVGPKYwLFyX6VRgp/k+SMIQ4enk/Yh+yL12hKsnuTmi4lR9UHTp440KfTKkas4tp8uwUe3DjCy4wy2xj9xiRQaJb+MYPcVJ5tJ0ImTLaB7x0E66oA4LF8GP+yAsfv4bbLpeRKC0Ox/mtsx96RdEv7tX+Q2VMZ4KduQq82v+vQ56ZkQF2AS2mm+X8xVYjSqOXrWQIsFcsXvf0MBKUkiD14GoTyWwtCtp1YiRkriesuj7u93eMXwLvxLlNMmsPZI8rOHl7X6ahIw5tYGyFKIb0xUSmJNUiFMJPve5kU9cIg5NrTalqImEfrrkyh57ocnPCSBd57xV9agDVpohvk5ypTc4Apoh3LP+niGusJtKqmNW5a8RulbpHAsHje1hKcKK7b8etSN4/yWMX88AOU57qyKN58EeaGS76Y8Gf4uIaJS5LonqpMeLd4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(186003)(38100700002)(76116006)(38070700005)(7416002)(82960400001)(122000001)(921005)(66556008)(8936002)(52536014)(5660300002)(64756008)(66476007)(66946007)(66446008)(55016003)(8676002)(2906002)(6506007)(7696005)(26005)(9686003)(54906003)(110136005)(508600001)(4326008)(316002)(33656002)(71200400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XQVvWtqavegZLVWgOvtAk74svTDPHxu+aWeQMygSlyV8M/XMU6anPrDRqgbz?=
 =?us-ascii?Q?2L40nf4/mBnzBND9IujwyGHbkibiNFJnMB3tgVjXMtrP6gqygIIbDcRR4pO1?=
 =?us-ascii?Q?YvjkpMgRi6M3630U7ZdRnQr4jcjvkmF5qGD1v+jRWOCXZMLpTHiw7We108Zf?=
 =?us-ascii?Q?njWDadtU5H+z2QlUXZtNZpuxxNdn1Zm4ArSVyGJk3mfXKMof0T03szG75AaC?=
 =?us-ascii?Q?aSz78ZmfrY7DbPcX7/asMiLYnFk4grbZMNaxv46pZ7H3go1t5ni3dtfUKUUL?=
 =?us-ascii?Q?lO49ird5OWFt6K9x9DBvQbOjc/GtzruKrlmmZROFb1mB8gT75TuQ11OJEeua?=
 =?us-ascii?Q?KRgicy8cYtjsSD2IGCxjS201enhKPMEOVjbm5gR0evJVvm3LHoOxILzDGfkT?=
 =?us-ascii?Q?rvHvojJ4mn6FUdCmwJE0auKh1g3nFUV7mt+lPE7xmCOJJ4sPxRq1Nhyvp69L?=
 =?us-ascii?Q?uS1i6IxVNtVsS0yijZTo1YCXBC5GNM8CN9gVdHDhfhRGYMFGV+BTT8e5pZ3A?=
 =?us-ascii?Q?X9lCHpBwunw5uDcY9IIJSlj5yp3ogwlA0e3ygzk8amTGCQKPbgnlxx84ejdb?=
 =?us-ascii?Q?gvUBWBNJuRlVX8Tbt5FKUTDPPbpKut5Qd4nYenlK1uYxtcVj/9FNDmS6Kz/H?=
 =?us-ascii?Q?AuGIQDsoCAwhALcGv4hLkGLebQMEYvopjkdHVEVIL4Go8BCej4I4q6lPu+4x?=
 =?us-ascii?Q?tBTvR8bag8nDLrh9DHYeM2Dqiu71y7MrB9+7DaF13MgD/ojdieIPPRbzk2bh?=
 =?us-ascii?Q?mVsBaz4eULlUbo6QxCeyEeuFEpcIT6fhqQURf2leKwZsYK89kC4E53Et/oov?=
 =?us-ascii?Q?QHH5SSPcH4Egau+6yExf14pM0ARKyC1RNFiEfGXov1gaHABiLxlZByaPOT0r?=
 =?us-ascii?Q?zdulL0k0CwGHqg6h22RcAQVuU352Y2fWiFOX4C8dC6WLsWoWsacwVE+AVXs/?=
 =?us-ascii?Q?LSO1ne2qvh881/y0xLtSsehtdlJskUtvii90wVsB1nbekAI32mMFQC9MPLrr?=
 =?us-ascii?Q?i5pOOLPUV7xCKxmaVKmemLf+ZqAASijdNu8H2PVxu/x/RnbSVFAj0jkACpr1?=
 =?us-ascii?Q?4CXCaYAdH7EfA60PSW5UY61NBBE2+6gmHK28f42WYI6uOdG0PE8c7VAb+ba8?=
 =?us-ascii?Q?dtZJ5+rthAi0K5+koUY1Y/3En+iXkrcmmb7vZuT56+sOR43lhAMjOLw5eewA?=
 =?us-ascii?Q?ObHuHj5FcSrJJQe11F71YBjbeo/d2aVr9+/VwyGhNbqx6PvD1ZY4oBw8C5ea?=
 =?us-ascii?Q?qf9j68jcIHDJM00Fk869cQJF3jFXHXukgm5we7pU7MhDESJBxwPq4VP50fm0?=
 =?us-ascii?Q?Oxb6Bdwd4z7XASJkR9ZwYWC1/ZitxOiETAsYuc5FZ7QCc3KLBAwP7sCwZPqy?=
 =?us-ascii?Q?OgO3So6XBj8HgD47QG+1NThED/G3e+lxp8e5MZ/NOs6Cqz3w8KF//BYJp1jz?=
 =?us-ascii?Q?JW7rKSqdMZQv4zWk32DaTmOJpgWzqJuY/lVluCu1iudNeeT2GhDSWdYRL0VU?=
 =?us-ascii?Q?YAiNQbG53ZqS6L7zA0RgF47i5E1uknqZIJSUpEJ5hPbUlGjMU8RyPKLIsbpD?=
 =?us-ascii?Q?XA8UEwPxj33BmhQvolFwHIyHieAIe2vxyb+YjfTDEykC8CV0A1tIX8bj+3Rq?=
 =?us-ascii?Q?ZvP5fiQV3HZ8eiTgwIMk1VK844gXwwZM9nXxXUXR9lUg1i5P+/ip8Mh1BHg6?=
 =?us-ascii?Q?ieUpvgbOJDccqHn2IAp92VU7N3tZDGP9vUxZRy0UEQzr+IOp843YF6x+Ft0F?=
 =?us-ascii?Q?ocQ1KPWzwW1H1vMswIaOnnHeW5Z1pqE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78f65091-e1b0-4a82-c8c7-08da4dd2e157
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 06:55:34.5131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mlp5Ok1JYNAXatzJeoR5JitVf2JcWaQJHajp0UojCt+4NQMb3kEbTH4COM54s8f8w+SKp53i5exRJfy303QQKReEaO/B0UbBmC3qGADr8t8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2072
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>index 73cae2938f6..bc8edd88175 100644
>--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>@@ -1141,19 +1141,20 @@ static void stmmac_check_pcs_mode(struct
>stmmac_priv *priv)
>  */
> static int stmmac_init_phy(struct net_device *dev)
> {
>+	struct fwnode_handle *fwnode =3D of_fwnode_handle(priv->plat-
>>phylink_node);

This is an obvious mistake and will be fixed in next revision.=20

> 	struct stmmac_priv *priv =3D netdev_priv(dev);
>-	struct device_node *node;
> 	int ret;
>
>-	node =3D priv->plat->phylink_node;
>+	if (!fwnode)
>+		fwnode =3D dev_fwnode(priv->device);
>
>-	if (node)
>-		ret =3D phylink_of_phy_connect(priv->phylink, node, 0);
>+	if (fwnode)
>+		ret =3D phylink_fwnode_phy_connect(priv->phylink, fwnode, 0);
>
> 	/* Some DT bindings do not set-up the PHY handle. Let's try to
> 	 * manually parse it
> 	 */
>-	if (!node || ret) {
>+	if (!fwnode || ret) {
> 		int addr =3D priv->plat->phy_addr;
> 		struct phy_device *phydev;
>
>diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
>b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
>index 03d3d1f7aa4..5f177ea8072 100644
>--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
>+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
>@@ -434,9 +434,11 @@ int stmmac_mdio_register(struct net_device *ndev)
> 	int err =3D 0;
> 	struct mii_bus *new_bus;
> 	struct stmmac_priv *priv =3D netdev_priv(ndev);
>+	struct fwnode_handle *fwnode =3D of_fwnode_handle(priv->plat-
>>phylink_node);
> 	struct stmmac_mdio_bus_data *mdio_bus_data =3D priv->plat-
>>mdio_bus_data;
> 	struct device_node *mdio_node =3D priv->plat->mdio_node;
> 	struct device *dev =3D ndev->dev.parent;
>+	struct fwnode_handle *fixed_node;
> 	int addr, found, max_addr;
>
> 	if (!mdio_bus_data)
>@@ -490,6 +492,18 @@ int stmmac_mdio_register(struct net_device *ndev)
> 	if (priv->plat->has_xgmac)
> 		stmmac_xgmac2_mdio_read(new_bus, 0, MII_ADDR_C45);
>
>+	/* If fixed-link is set, skip PHY scanning */
>+	if (!fwnode)
>+		fwnode =3D dev_fwnode(priv->device);
>+
>+	if (fwnode) {
>+		fixed_node =3D fwnode_get_named_child_node(fwnode, "fixed-
>link");
>+		if (fixed_node) {
>+			fwnode_handle_put(fixed_node);
>+			goto bus_register_done;
>+		}
>+	}
>+
> 	if (priv->plat->phy_node || mdio_node)
> 		goto bus_register_done;
>
>--
>2.25.1

