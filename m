Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED89B57CBA0
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbiGUNP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234150AbiGUNPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:15:13 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2067.outbound.protection.outlook.com [40.107.20.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D131F63;
        Thu, 21 Jul 2022 06:15:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLZbjqHprtqZzJWAhHD5vVWzlILHih6NiMnyztB1hY0c7HXJWZ5G8au3np0QNLafy/+hRzH19A5OYj9JmKx0Q1FTKHxc3lTSSK2pQWVFFGLRCq0Bvji5Cm6oHcipmWp3lQjUBcU98Z3pWvN61Obckg2oUsKaHMuiOES6tsYAd7yAujiw3SrESuHhTaFmkRBuvO8ehrpZ2YF1rSh6NNkE8qL4VzdQAxeVJ5aSZu60zW6jjOgtmf97QWvwB369GhaVEjl3LEuxX8kT917Hh1EB7A7aFE2bFaTkCsov3O7GvtC0DzJwit0wo9RH0qDUNQm+DATjml4cl5bO2KwhKVZd5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IfGzaYm38GwfJ7r799I7xZ7bupz5x4DZ4CLNlDqKdik=;
 b=OCDjH0JYARhhjyKUsgyVrOIvBk/YyLD+IuKKT8116QG88/vcNYAqNg1RqWay237bt5sLn/uEN79SUG8Vc2ZaNVOhobab6BT2SaZ6npxrIaIDftvg5+u0+HyEdiT1akU8AJYAm6zRFQ5rCEBXwzgRsc1UuPCWCC6Iql5TCs0E0CJpFeChRtUzAUt+eNnQGRo89DC04GTIHrIpQVRe844ztLSwa0pIsKrKQ+TTuDOaBXPCm4mrJB06N3iWv7JVLLXLVHnGs9K/8xppD4cLqy/7izOKs5i+l2i/LJMr6fAktWVc1+4Ty/m3sYfeF2Tiqq1zP9l8pLGZWuJKmQxbAZJ99g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IfGzaYm38GwfJ7r799I7xZ7bupz5x4DZ4CLNlDqKdik=;
 b=gkwL43P8gQVBgRtV3XCliR2ta7tbCCD7g2H5X5W3uGGWGi4zuU+dq4Tu4Vg/laWQlsKiupSi2xdt2zWYlPqnRnT/ohOGTsSi82Br/qg0LeX3TkkF1aGi+q0K8i4dX6ghQux27emsqIe1fOPSQ7ihYj9nxZmxqxN6eUjdT91jl1Y=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB6191.eurprd04.prod.outlook.com (2603:10a6:803:f8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 13:15:07 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 13:15:07 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: RE: [PATCH net-next v3 35/47] net: dpaa: Use mac_dev variable in
 dpaa_netdev_init
Thread-Topic: [PATCH net-next v3 35/47] net: dpaa: Use mac_dev variable in
 dpaa_netdev_init
Thread-Index: AQHYmJcb9FPszthP+E2JU9KVFqcVmq2I1Mcg
Date:   Thu, 21 Jul 2022 13:15:07 +0000
Message-ID: <VI1PR04MB5807DD62C1A2E733CC7CC129F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-36-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-36-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22cbe5fe-1032-4b4b-47e9-08da6b1b0870
x-ms-traffictypediagnostic: VI1PR04MB6191:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dHjQIXACm3e7hSIhRBIPz7HStulAVwPy6CzcOgIneeQ5m6xDmXou0c+/mwykwzrp6BKiEQ08WkhiIqQKZFuEkraGREygzz2slBaSmJL9xODqa3HfPPQXVZVB0JyId8CtNU6bKincle0YzlL6oEAi9Oo2Oz19vEMre/SXNvKhvsAcKcrsJINua7Q4NjYcphi+Alcuyok4W8zbajLSptX/glmgSV+kMvi1WO9xjOLlMF+05LMzksusufPT8XN3VuQBr/4B1VNYLZQdfr+81OayfRySfN1/0I8FURT5cv4vt0ri3zBY+kBig4heTUiOQnHuKTyQawBmfK87L7AErG0ESnfdwHNzmEFvmi/dS/fYbE7MhzcsQ8VfyP/hNx1BBDVgwEO6ZE2c1+U52NDhh3w2xjPHosG2fX61YNqKvRvHHisOiShLe3R8RrITwmD7GIwSSZ781Xu67sx+pn3qfYVwVKvHiPGpqFja93DBWjdWsvrVSasObwzffHn/7j93MWc3gxCpu+Tk5+eKUjIrqY9v+NiaJu+MAgFuQ9ZWLE7WbijPGAEs4Xk/nJBGTCyCc73NRYNNoYpTgVXrj0eeq6X4W330ew+E0g5YiipVJDmMK7/Q1ycS287tyJD8JOT+ISxMtNteeNa0yKpUuEbTcvPFUHtTsH3I92Ls2Um+YWxgmXhm29TsTWB1Eo1vpC4LRvmHMEy4Ml7kDCCVwCgIlzZ4i0Ti6AA4nuniA6/3wBJtIKsLAcuqu1rCB7e2YRt2BTEvhy68x/9Kb5BJgUgOf0Xy+PiTczwJtsouniwecWCO1JjB2pSKt/JTqLJ+luRqnGgJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(186003)(76116006)(38100700002)(55016003)(66476007)(86362001)(316002)(8676002)(54906003)(122000001)(71200400001)(66446008)(110136005)(66556008)(38070700005)(64756008)(66946007)(4326008)(52536014)(33656002)(53546011)(55236004)(7696005)(6506007)(8936002)(26005)(83380400001)(41300700001)(2906002)(9686003)(478600001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/mppQfPK2u93gUT1tVfb3B/t7DmpD1qQOF26zg6U7tmFQW3VGBUqFh7ws/Wy?=
 =?us-ascii?Q?+RgsuyF642ze8JeO5Y+k+PDcVJ0XSfHI3CFuuDZWESNtb5zS19rxKUZ2IiAd?=
 =?us-ascii?Q?/pNh78BtsaxYn34i3u/Bncv7oHKcmvkX2oTo/AbPLarpJN9z+5IacnS1boI7?=
 =?us-ascii?Q?KbXtni/WQH+BPeaTpTpYcf4kpwAZ64+Nboco2TzQdQzyZJkXu5y4feIPzeI8?=
 =?us-ascii?Q?U2XLOh+E8B/KjowWwO5CuNJyA/fnTlZHA+da3+k4OW3gLf16P/72CufBONbv?=
 =?us-ascii?Q?Avo1aAP3PSBckrurYhUgH1xLuNQe/GoJbAylZT1iW0r1cCYTuEynr0xZkWvt?=
 =?us-ascii?Q?r7tLdDCK7K1uCK49PzP/afrGDW0oGHapeYj6SyYvgRi3/gIni2MlP6ifJY1u?=
 =?us-ascii?Q?r73PxRoE2B5Txm9lrDePfbMS7xZKD8oSEAetnFzP9zKNblZGGICO01B3lQSl?=
 =?us-ascii?Q?+kHPzDUUmEAFEcMg3+EZ+5yknsFqzeyV+qWKbBWf2EEm/3NvMc/dZNArkNSR?=
 =?us-ascii?Q?l7kpcWuC0YH6wMOU9s7Cf3ysPRoubdy3fBPoiTRWrA9MuFaIuTs2fen4pvia?=
 =?us-ascii?Q?gv0dGlaS6rkhtnnNEcJ8+SLLKO8/YhI1SKm/FvcMJ2y1V+zOjTvtZrSgeM2G?=
 =?us-ascii?Q?+rfOhDOd/Bv1yDJopAAgtJ4ZmjELs6DDKKoPsosJXlqTuTO65h+qpg5DsZhp?=
 =?us-ascii?Q?x6E1nB5b2llldatq17CoF2Zc5o8iINLgRJFmJ0gGhqyd6vlRrz4Zg+8EvLWA?=
 =?us-ascii?Q?SBfjHHbHTpyKSw36kzVjVDb5ajEQncOLR1qVpf/X8QJztNdRpo1vwA9wuAmc?=
 =?us-ascii?Q?I6bF5zwehGoaizkVctx40CEFJKtb1rCLxScW0DKb0z8MRJ58KlFYwZEZ8fhu?=
 =?us-ascii?Q?0dvPabRYbC3qW0Z1JT+5l4dQiYLJD1ea++TTXZ//doWtVZhciWLr70T0dNOI?=
 =?us-ascii?Q?cdoklbihkx4wevSfwo14nywgvMDlFr2yp5XLByPOnhmF2Br1r9Zse0fEdtsb?=
 =?us-ascii?Q?ngRjFfPmH4RhpiflHb1Zb46fByE8h3bhqR/7P6mBldQ7es+s0MKNaw4UaNCv?=
 =?us-ascii?Q?1SP96YdrePwZyRn95H3sTsfvMtbRJQwvNLnZ4TWOfoaP/4H3vzjbOg29khYt?=
 =?us-ascii?Q?hrqEypVE6MG1VFgWevrVbWJ8/0ySPwcZgEGEdSLFJUQf6gvXs3eRzrBoe3JF?=
 =?us-ascii?Q?HYuvGeEEOCScfaKL1aG9ko4VTG5g2lbaLnvv8rpDUWRLM6HdtpNNRdqWfDtC?=
 =?us-ascii?Q?EzOU5OWXZwk07o75wFzRSksIu4wRa8hOgjTls42WBCCgpFSzwTXoIqgEPUDg?=
 =?us-ascii?Q?BddorvnspXzvx/7L2pQjyWY6blhYa+xyQ0G9tUe0hOsXJnzGdoZdZd2xIQKL?=
 =?us-ascii?Q?B6dPQGyHpn+oTN3MkrJKRp9ceDoAP8cyOJVDQPlQ9cl/EfEhR2blJDNl8PjK?=
 =?us-ascii?Q?m4MZ4SfSTlL3l+vtsC813NUD/IsW/5IBqr8up9+w/6r7wBPAqICHTwWV25QY?=
 =?us-ascii?Q?vjrMUVUfTyllXI9wM6rYflkwiEC8/l2opn4gWtXCZQ+jpZUXczkEA/QXtZIf?=
 =?us-ascii?Q?IBnh6CIOEA+81op3sW6w1+21xlMwE6EyE+P9CDDU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22cbe5fe-1032-4b4b-47e9-08da6b1b0870
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 13:15:07.5742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ykR7WCmLFrZGuGCpa+uwoCLrZRkncPirhuMz7poIamU2IMcYzbZljpQdwqhDNytNZkEyzUIOqHJCjFcVwyIrLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6191
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sean Anderson <sean.anderson@seco.com>
> Sent: Saturday, July 16, 2022 1:00
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
> netdev@vger.kernel.org
> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean Anderson
> <sean.anderson@seco.com>
> Subject: [PATCH net-next v3 35/47] net: dpaa: Use mac_dev variable in
> dpaa_netdev_init
>=20
> There are several references to mac_dev in dpaa_netdev_init. Make things =
a
> bit more concise by adding a local variable for it.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
>=20
> (no changes since v1)
>=20
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index d378247a6d0c..377e5513a414 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -203,6 +203,7 @@ static int dpaa_netdev_init(struct net_device
> *net_dev,
>  {
>  	struct dpaa_priv *priv =3D netdev_priv(net_dev);
>  	struct device *dev =3D net_dev->dev.parent;
> +	struct mac_device *mac_dev =3D priv->mac_dev;
>  	struct dpaa_percpu_priv *percpu_priv;
>  	const u8 *mac_addr;
>  	int i, err;
> @@ -216,10 +217,10 @@ static int dpaa_netdev_init(struct net_device
> *net_dev,
>  	}
>=20
>  	net_dev->netdev_ops =3D dpaa_ops;
> -	mac_addr =3D priv->mac_dev->addr;
> +	mac_addr =3D mac_dev->addr;
>=20
> -	net_dev->mem_start =3D (unsigned long)priv->mac_dev->vaddr;
> -	net_dev->mem_end =3D (unsigned long)priv->mac_dev->vaddr_end;
> +	net_dev->mem_start =3D (unsigned long)mac_dev->vaddr;
> +	net_dev->mem_end =3D (unsigned long)mac_dev->vaddr_end;
>=20
>  	net_dev->min_mtu =3D ETH_MIN_MTU;
>  	net_dev->max_mtu =3D dpaa_get_max_mtu();
> @@ -246,7 +247,7 @@ static int dpaa_netdev_init(struct net_device
> *net_dev,
>  		eth_hw_addr_set(net_dev, mac_addr);
>  	} else {
>  		eth_hw_addr_random(net_dev);
> -		err =3D priv->mac_dev->change_addr(priv->mac_dev-
> >fman_mac,
> +		err =3D priv->mac_dev->change_addr(mac_dev->fman_mac,
>  			(const enet_addr_t *)net_dev->dev_addr);

You can replace priv->mac_dev->change_addr with mac_dev->change_addr as wel=
l.

>  		if (err) {
>  			dev_err(dev, "Failed to set random MAC address\n");
> --
> 2.35.1.1320.gc452695387.dirty

