Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0167551FA19
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 12:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbiEIKmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 06:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiEIKmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 06:42:51 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on062f.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1f::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023742C07E6;
        Mon,  9 May 2022 03:38:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1Gr8LOIGgyNzl/Y5bnTdZUP5AcDExUrAb18g8z8BJnlYr9PofNrEw0/KZuZ4lM/0pdquCRBr81iZE1phuJqtv5c7bf42EHjrL+dsc+fVyigdKex1FQAvIcvigjlB2uCqvuFpp5yI36xAb0b7iFsssQYQmog8KfxVyqKPYIodCKPC8sxF9MYabAlxpV097VSlIO81ZBainGjkCOPQo7zp7DczDI41OeaLiehGfc5qt/fX1ilQu/edhUw7uZHN39C4u8hR9uH/CLfE32Dutfa0BUgckzKHhPgSmNSBbnRkG5YkZIKwN2FDqQ0o+ngIR+3YRefKe8KE7NwWpumS64U8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L03YMi+ElqX/zXF/E/ZDJQIRGpKarPnTrl61ygBtXmY=;
 b=O0wzuPTP9Eb/KvoK85tKtNmcajpxyWJjuDulXEWS/mmP86e/TNnlTjRUhS8MatxHYNczlzdtk0G6ADJmvsuTOQ7XJ1ljYZlIzjNrjyq3ntBPMKbqt1NwZfrOfb5YHD2yeCN/tWbxVYTvWnyznIrpHm9vDKG/I2AAGLqrZS+x70VgGWmQMF03cjV+iEmQvFDjZxPTuUlpDxJ3H9+Ss+4rmQWr484cGVafbpdHi6bOWKXKqyv3zpCg7y5j5lDAWf+MtuTJb+00qBZT6LO8oC7kpKVEeFdzf2Bi3SGTfjhiRGR+oiSbU2mEk2B/lwIYvXpyOcyLcP8t2mm+l28OpPXJ9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L03YMi+ElqX/zXF/E/ZDJQIRGpKarPnTrl61ygBtXmY=;
 b=JwoMJqdzqxOAQrhPe9dfyswdYgOFBd0+bffgE4D42wCT5Ip3OSIVBcgJEui+5DeDeHeloz9fyoIcusbD0A95SwRcTVQZi1tt13HknV4d17zLBZAy0phOVvzxoBy8zITlJ6oHq9frypGaxf/WAcVeJCBk1WBVaA+5ehNdhvfchZ4=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DB7PR04MB4972.eurprd04.prod.outlook.com (2603:10a6:10:1c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.27; Mon, 9 May
 2022 10:34:45 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5227.022; Mon, 9 May 2022
 10:34:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [RFC v8 net-next 15/16] net: dsa: felix: add phylink_get_caps
 capability
Thread-Topic: [RFC v8 net-next 15/16] net: dsa: felix: add phylink_get_caps
 capability
Thread-Index: AQHYYwz+Nv3GsOP+t02gQrIoyWAlJK0WWrEA
Date:   Mon, 9 May 2022 10:34:45 +0000
Message-ID: <20220509103444.bg6g6wt6mxohi2vm@skbuf>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-16-colin.foster@in-advantage.com>
In-Reply-To: <20220508185313.2222956-16-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d94a41d0-ad90-4dfc-947c-08da31a78924
x-ms-traffictypediagnostic: DB7PR04MB4972:EE_
x-microsoft-antispam-prvs: <DB7PR04MB4972E744C46836E720CD1D0FE0C69@DB7PR04MB4972.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5Tsk0p47dDXs6HH8H8/E1fztyWE03DB12cyslbiVVWelXsx6V81LXlfLGy/yLB/+gYQy2vdDNcPeLX7bRot8mpvFvNF65T4slppF04TGX6ixtpcr6lVHIwwYic14YGsxQDf4cXIEPkPUPLOPOa/mXgWJ4OhViAuT0rfiqsB+nt3zXBCo1iKAlyvyeCkgry8T2/GfjwGJU+tl+ZvIvcYtQxkR4Cg1ZOIaXMge8KNU9UGeBF/NVGHkngLJDp4s2MfhRFPJRf13RVZIf18jfjPR70w47KwJljrkhLsnKU9B6tc9YjAXcN8RvTtw2qBjdWRjtQ8TywYLP/fsaD2/uyB7f71TOPaMw4Jcc8RaGC8fHIXXgWArm9Xmoh/HnmgyonhWqFm5inUDdlB84FZ3/HBsctaLJyEigh0wc6uuDYRq0OmUPQdsY312E9r/WPaGKzyed9mJO6yXXjTbtCtgV/v4PAbtzx0/8KyeF84nZ1amcMxM3PvpU+5oPfz6f2pVTvp6Ohpjl9UQgGOIo0DGrnmNrSEXJHfrMDoOIKwnzYnHPaK90JvLdlTQjgjFZeYiXYEG6SUVE+lSTjEcborQ3pVcmrvDV+SDPOxtm0pCz6aMYmZLmZeXRmxs6zxbu9o82uqp1pR5LSiTRpuLDh+QWjxYi5iPeMp0mEoPJp5Tni3PJO3BTXF9NgZrU/JMmop8Os/NkwP3BUUR4LXMZBcEXM8jqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(8936002)(316002)(66556008)(2906002)(66476007)(44832011)(9686003)(66446008)(8676002)(64756008)(4326008)(66946007)(76116006)(7416002)(38100700002)(38070700005)(5660300002)(122000001)(83380400001)(6506007)(26005)(54906003)(186003)(6512007)(1076003)(508600001)(71200400001)(33716001)(86362001)(6486002)(91956017)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?H6dd8j0gCNMdcuOpJ+MP5gC7tyelNJ8n5ID9sy5pKcpPfrZQGixuUvdliWIN?=
 =?us-ascii?Q?A7rr1GTFo8zaIDMu2uQTcV2WNUYu2Zb/NnmJSKsTrX9pie9SPBuxkpmOO81e?=
 =?us-ascii?Q?qMeyZRD9jbo7th7uICUNbTG/C0qJmGIpOeOimNzi3KfZSaR1/As/YUm6ForD?=
 =?us-ascii?Q?cudQJFP2j/5dYigXCezlq29RUHMaWMvXskZYnMu13UNqu9JtwM2cgDPs+t+0?=
 =?us-ascii?Q?sdzy7QLyDob7g1TZKk7tIvaxKwMEC2eVyY33C3dFb+GXRLlcqMlhzSvOx8U6?=
 =?us-ascii?Q?GrrWQWJYvlTVbrPBlXv9tVX/T3kZRVAejEjW4XStXOcKvZ+dRIT+kdSF1jG6?=
 =?us-ascii?Q?GALoKmaGGMV7dUIJbAAioH/viKmAkz1NeKY0t+OMcF4mlQwGlYvqmAoiQTqV?=
 =?us-ascii?Q?E7X2oFYhVy6ItOiCIsYmLok8XRoSJrfUuXU4AN3tgBQX/84N42Mdv6tEAN2F?=
 =?us-ascii?Q?J50mnytVr9eo58rZh1zuTJLOwyX1wQKm5e7GNU1zbVOWHTagNursN6AGf5eY?=
 =?us-ascii?Q?tt9zLq+/vhTJ7DZBfgG9QxF8Ose58waYUGp0Bc9iOE4hiY6RNR3YSSL3H7yS?=
 =?us-ascii?Q?EdYWCPMr73K+lNdGIcIaleez8iFjO6+xjNpkDbsbOr+MJkVb3RuEbQMa8z60?=
 =?us-ascii?Q?RhGBRgjSFvd6757oRWwK3CeTkjRUWMGTTCH/2uZY50EWBMpVLmaIdpRDtf8e?=
 =?us-ascii?Q?gYYujr/b6bUNi9w/2/C32vs0yHtSsyEQ3KS9VzN2s80CnUEnYqXGxYt+5hWY?=
 =?us-ascii?Q?xNTLfEmGPRFp7nTEKxaH/nGxNl9ZqrzvaHw1en6hJ9yNDR5DQBdJPDjWdAEJ?=
 =?us-ascii?Q?BiTEG7nGQPdAeO3K042TrXpCIrbP426jVaqOGsWuZn3jRxvjZtLGL8Lt2ubE?=
 =?us-ascii?Q?Tx/HZplRVgpaTs54ozqllL6geH/HgRyPK6pQbEIaNR/yAAnVDu70a3o5TDwm?=
 =?us-ascii?Q?gJYiLw9DEwjZdeP9p6gLoRk8TI3n54w3hNsKiE+JNnS6BRkADjr319nlLD8l?=
 =?us-ascii?Q?IYf9+M5lL2TqLjOWO40tt3i9vLNsqxTfhPlHL+ymMHeCr675gR1JVzrMsCoX?=
 =?us-ascii?Q?dKvqZ5jtV7mLwMqKpAnduzeSOvYSoDU2qq4tW4ZF8byq2PiP6a4Okyaq+RK1?=
 =?us-ascii?Q?yjt0fL9BtFoXsRzDNXTwAeAKBIGTOpyVmTKVbieBhZYfrui1yUNgMpCdK3kX?=
 =?us-ascii?Q?pzMzloY0lvBlYp//GqeiiUMZsdDIhEJpGglZqTyXxZb0s64VnS4CGYEhQK+W?=
 =?us-ascii?Q?ODPaMn+h5zhwKI4jjq7Y2fKGYj7MiGerI0n3MIm/QAujAw1DkaIs91TVoL5X?=
 =?us-ascii?Q?sWnb1S+z7rrt1R6edv1S1iM2Rw6sPlQaW/r9pVtSNoQI1zMC9mJX6T6j22ZR?=
 =?us-ascii?Q?VZxzDhDKkKZmDvp4nIY46/fCi4JQrD9Ey6CZ24r64Uv4xBLk8zKpo5faHlYJ?=
 =?us-ascii?Q?iwChriEU0RMKyB2kBAWFEFmnQDN6oXbjbMvqzh3o36X4raryFzB09Cug4Uf+?=
 =?us-ascii?Q?vr8qaRgeI4msrcvh06A3fKFq26T6iUPBTQuLlwkPL4f7XxiybIXu+ahGKoBr?=
 =?us-ascii?Q?8ZHJeI0unySK9JNR8MY7JhFoFYrLJTvE2iah/K83aj979BUFaFXqSgROSCNq?=
 =?us-ascii?Q?flDLczVSCM8hpYxndTM0TFIhvmIOvbp2TRRSkO6fI5VWXb4o4Vf/yuOYjyT6?=
 =?us-ascii?Q?GqWziPCBRuzdsg/kpZv1qre/gh9lrlw2Q23wt9nypRcJ829Fij1NG6FMzMtB?=
 =?us-ascii?Q?atlvVD81Jl7UrtQdGVl2NNSKEkj4pOc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <00CCED0A6A4D1E4A9C6DD12A8757A383@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d94a41d0-ad90-4dfc-947c-08da31a78924
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 10:34:45.6053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CtK3YeuipeolNfIBU1cVvhWaoqDaviB2VtD77zkcEaaF+lzEN4XUfYkPTRRJD9ko82+01MtPT3ft5Xw9zgfeOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4972
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 08, 2022 at 11:53:12AM -0700, Colin Foster wrote:
> Add the ability for felix users to announce their capabilities to DSA
> switches by way of phylink_get_caps. This will allow those users the
> ability to use phylink_generic_validate, which otherwise wouldn't be
> possible.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  drivers/net/dsa/ocelot/felix.c | 22 +++++++++++++++-------
>  drivers/net/dsa/ocelot/felix.h |  2 ++
>  2 files changed, 17 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/feli=
x.c
> index d09408baaab7..32ed093f47c6 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -982,15 +982,23 @@ static void felix_phylink_get_caps(struct dsa_switc=
h *ds, int port,
>  				   struct phylink_config *config)
>  {
>  	struct ocelot *ocelot =3D ds->priv;
> +	struct felix *felix;
> =20
> -	/* This driver does not make use of the speed, duplex, pause or the
> -	 * advertisement in its mac_config, so it is safe to mark this driver
> -	 * as non-legacy.
> -	 */
> -	config->legacy_pre_march2020 =3D false;
> +	felix =3D ocelot_to_felix(ocelot);
> +
> +	if (felix->info->phylink_get_caps) {
> +		felix->info->phylink_get_caps(ocelot, port, config);
> +	} else {
> =20
> -	__set_bit(ocelot->ports[port]->phy_mode,
> -		  config->supported_interfaces);
> +		/* This driver does not make use of the speed, duplex, pause or
> +		 * the advertisement in its mac_config, so it is safe to mark
> +		 * this driver as non-legacy.
> +		 */
> +		config->legacy_pre_march2020 =3D false;

I don't think you mean to set legacy_pre_march2020 to true only
felix->info->phylink_get_caps is absent, do you?

Also, I'm thinking maybe we could provide an implementation of this
function for all switches, not just for vsc7512.

> +
> +		__set_bit(ocelot->ports[port]->phy_mode,
> +			  config->supported_interfaces);
> +	}
>  }
> =20
>  static void felix_phylink_validate(struct dsa_switch *ds, int port,
> diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/feli=
x.h
> index 3ecac79bbf09..33281370f415 100644
> --- a/drivers/net/dsa/ocelot/felix.h
> +++ b/drivers/net/dsa/ocelot/felix.h
> @@ -57,6 +57,8 @@ struct felix_info {
>  					u32 speed);
>  	struct regmap *(*init_regmap)(struct ocelot *ocelot,
>  				      struct resource *res);
> +	void	(*phylink_get_caps)(struct ocelot *ocelot, int port,
> +				    struct phylink_config *pl_config);
>  };
> =20
>  extern const struct dsa_switch_ops felix_switch_ops;
> --=20
> 2.25.1
>=
