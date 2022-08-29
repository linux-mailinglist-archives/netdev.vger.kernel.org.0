Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082B45A45CE
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 11:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiH2JO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 05:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiH2JO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 05:14:26 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263395A888;
        Mon, 29 Aug 2022 02:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661764463; x=1693300463;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=SkoUiCpoaLtos4E0x642lOYDy66PcPTByQrF05aPtKw=;
  b=Hq6j4yBUoW5re95Oy4CzPcpTQ26RwbaAN99ZAf368XHSraEQBjc82fQW
   5z2+tXlOshDZY1YXJqJ4U4h8dqaFoucL2Hvecno9LZ9lXV6Xk1Y2agrkI
   Djn3uVDyi6KAQsNl9lBjsqxb83myxbr6PeNTV2yzgBjAA30hG0E3qWWUc
   sG7VdFa3saONO7495pbbGjqqsb91V8WzivM5NVLA03b8B7rtnfrefXliO
   PUEfEyyNHHzf4ZkNLTj7MxM9xfPvIvdisjRMc4UprBMpXxRiAxUjpZTj9
   FLipomQBqa+EYvK7QAjdLX76QNKjdODrAFWB7jRhnmoe/5FVkRWa3BjMh
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,272,1654585200"; 
   d="scan'208";a="174590204"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Aug 2022 02:14:22 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 29 Aug 2022 02:14:22 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 29 Aug 2022 02:14:19 -0700
Message-ID: <578bdccee9a92dd74bb6a1b87fb5011bf7279e57.camel@microchip.com>
Subject: Re: [PATCH 1/3] reset: microchip-sparx5: issue a reset on startup
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Michael Walle <michael@walle.cc>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
CC:     <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Date:   Mon, 29 Aug 2022 11:14:18 +0200
In-Reply-To: <20220826115607.1148489-2-michael@walle.cc>
References: <20220826115607.1148489-1-michael@walle.cc>
         <20220826115607.1148489-2-michael@walle.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Fri, 2022-08-26 at 13:56 +0200, Michael Walle wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e content is safe
>=20
> Originally this was used in by the switch core driver to issue a reset.
> But it turns out, this isn't just a switch core reset but instead it
> will reset almost the complete SoC.
>=20
> Instead of adding almost all devices of the SoC a shared reset line,
> issue the reset once early on startup. Keep the reset controller for
> backwards compatibility, but make the actual reset a noop.
>=20
> Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
> =C2=A0drivers/reset/reset-microchip-sparx5.c | 22 +++++++++++++++++-----
> =C2=A01 file changed, 17 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/reset/reset-microchip-sparx5.c b/drivers/reset/reset=
-microchip-sparx5.c
> index 00b612a0effa..f3528dd1d084 100644
> --- a/drivers/reset/reset-microchip-sparx5.c
> +++ b/drivers/reset/reset-microchip-sparx5.c
> @@ -33,11 +33,8 @@ static struct regmap_config sparx5_reset_regmap_config=
 =3D {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .reg_stride=C2=A0=C2=A0=C2=A0=
=C2=A0 =3D 4,
> =C2=A0};
>=20
> -static int sparx5_switch_reset(struct reset_controller_dev *rcdev,
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long id)
> +static int sparx5_switch_reset(struct mchp_reset_context *ctx)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct mchp_reset_context *ctx =3D
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 container_of(rcdev, struct mchp_reset_context, rcdev);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 val;
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Make sure the core is PROTE=
CTED from reset */
> @@ -54,8 +51,14 @@ static int sparx5_switch_reset(struct reset_controller=
_dev *rcdev,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 1, 100);
> =C2=A0}
>=20
> +static int sparx5_reset_noop(struct reset_controller_dev *rcdev,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 unsigned long id)
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> +}
> +
> =C2=A0static const struct reset_control_ops sparx5_reset_ops =3D {
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .reset =3D sparx5_switch_reset,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .reset =3D sparx5_reset_noop,
> =C2=A0};
>=20
> =C2=A0static int mchp_sparx5_map_syscon(struct platform_device *pdev, cha=
r *name,
> @@ -122,6 +125,11 @@ static int mchp_sparx5_reset_probe(struct platform_d=
evice *pdev)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ctx->rcdev.of_node =3D dn;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ctx->props =3D device_get_matc=
h_data(&pdev->dev);
>=20
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Issue the reset very early, our =
actual reset callback is a noop. */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D sparx5_switch_reset(ctx);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (err)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 return err;
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return devm_reset_controller_r=
egister(&pdev->dev, &ctx->rcdev);
> =C2=A0}
>=20
> @@ -163,6 +171,10 @@ static int __init mchp_sparx5_reset_init(void)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return platform_driver_registe=
r(&mchp_sparx5_reset_driver);
> =C2=A0}
>=20
> +/*
> + * Because this is a global reset, keep this postcore_initcall() to issu=
e the
> + * reset as early as possible during the kernel startup.
> + */
> =C2=A0postcore_initcall(mchp_sparx5_reset_init);
>=20
> =C2=A0MODULE_DESCRIPTION("Microchip Sparx5 switch reset driver");
> --
> 2.30.2
>=20

Tested-by: Steen Hegelund <Steen.Hegelund@microchip.com> on Sparx5

BR
Steen
