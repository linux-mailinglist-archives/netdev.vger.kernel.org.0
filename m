Return-Path: <netdev+bounces-9708-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF69272A4E6
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 22:44:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C8A21C20CC5
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:44:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF0491DDEC;
	Fri,  9 Jun 2023 20:44:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36A6408CC
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 20:44:27 +0000 (UTC)
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A472D7C;
	Fri,  9 Jun 2023 13:44:25 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-3090d3e9c92so2113570f8f.2;
        Fri, 09 Jun 2023 13:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686343464; x=1688935464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vH0nkJICH5SoZihWGavJs2/Bnil9QT2kDyKVokHxQ+Y=;
        b=D8L/H1llciKeg2OaECls2piv/ZlGcZPz1fARREAdEPOEgkCvtZ4CHK8PsxWjTgI/TX
         y9Nu22Sltg+JSRzvMTud6VPlG83KpTpsUOfMFPO1PJBTbKtLNLWkq7ELwZXTHVnjklgL
         O6QZWHUygZx5p42j/aRcsEdTeTz718PEH/5OcjBj76Wd5Ziop5BwcMKLo9NyByVb/Mpq
         vTpbzle6IUbyvgB88Pwi3ySHYCy34bCFZAHwaeSAzyrbtYpNq1KepLKlEKqiaR6O7qwE
         jCUZkS84f3vPv3B+YjMzB9p6tIMFc3JA3y/wArk6FmTvMesQM7+YAeZDBjXRUuZUi8XM
         NUYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686343464; x=1688935464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vH0nkJICH5SoZihWGavJs2/Bnil9QT2kDyKVokHxQ+Y=;
        b=f/6WxDQGfOtPKKwGSIMRsbfc18bO2pnwCBOZG2EDh9GkaCM/EaeUqwFjIyHnbg8K2s
         zedev8ryv0d9vOOLHh7/GDAeNhV1wV2qQZvDe09Nh179vkE2WHZ0FniVOOMaAy+kFoBT
         Hwn+IOa6yS64Iidp94seL2Krc7GS4mLi+/wkpVnvPbO7JkIIXu1egp4y/gQAV37NGzLz
         eUV2VPAxfEra4MJr+BbO76edHWRXIbgG587UgHhkNCqBdSVnU65VQ2Z6tSkmU8ytTEJ6
         bBXhQGTUqlFrwKaTqNXIYjt2Xjum8xffkl6GhPdBtP5IgTqXkqveJ2ejniVU8wKVhNZ8
         Kpuw==
X-Gm-Message-State: AC+VfDw05hJqtBD0deFx1heGhpWYAkXWiRNJAJJy5lmuCzO2WOTOa/l8
	FEh6UTbabq1vNtGgb2Zw+iM=
X-Google-Smtp-Source: ACHHUZ7zNI1VWszzFX6QGR4B6hdYDGcU3iIOW4+UBNrHCJzvjNIhjWN7Qei9tDrm/d/2h6PBBSYKMw==
X-Received: by 2002:a5d:63ce:0:b0:306:4031:63c5 with SMTP id c14-20020a5d63ce000000b00306403163c5mr1948735wrw.51.1686343464260;
        Fri, 09 Jun 2023 13:44:24 -0700 (PDT)
Received: from jernej-laptop.localnet (89-212-118-115.static.t-2.net. [89.212.118.115])
        by smtp.gmail.com with ESMTPSA id z10-20020a05600c220a00b003f42ceb3bf4sm3652865wml.32.2023.06.09.13.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 13:44:23 -0700 (PDT)
From: Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
 Samuel Holland <samuel@sholland.org>,
 Neil Armstrong <neil.armstrong@linaro.org>,
 Kevin Hilman <khilman@baylibre.com>, Jerome Brunet <jbrunet@baylibre.com>,
 Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
 Doug Berger <opendmb@gmail.com>,
 Florian Fainelli <florian.fainelli@broadcom.com>,
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
 Shawn Guo <shawnguo@kernel.org>, Sascha Hauer <s.hauer@pengutronix.de>,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 Fabio Estevam <festevam@gmail.com>, NXP Linux Team <linux-imx@nxp.com>,
 Heiko Stuebner <heiko@sntech.de>,
 Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Maxime Ripard <mripard@kernel.org>,
 "G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>,
 Biao Huang <biao.huang@mediatek.com>, Clark Wang <xiaoning.wang@nxp.com>,
 David Wu <david.wu@rock-chips.com>,
 Grygorii Strashko <grygorii.strashko@ti.com>, Sekhar Nori <nsekhar@ti.com>,
 netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-amlogic@lists.infradead.org,
 linux-rockchip@lists.infradead.org, linux-mediatek@lists.infradead.org,
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH] dt-bindings: net: drop unneeded quotes
Date: Fri, 09 Jun 2023 22:44:22 +0200
Message-ID: <3169693.5fSG56mABF@jernej-laptop>
In-Reply-To: <20230609140713.64701-1-krzysztof.kozlowski@linaro.org>
References: <20230609140713.64701-1-krzysztof.kozlowski@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Dne petek, 09. junij 2023 ob 16:07:12 CEST je Krzysztof Kozlowski napisal(a):
> Cleanup bindings dropping unneeded quotes. Once all these are fixed,
> checking for this can be enabled in yamllint.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  .../devicetree/bindings/net/allwinner,sun7i-a20-gmac.yaml     | 2 +-
>  .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml    | 2 +-

For Allwinner:
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>

Best regards,
Jernej

>  .../devicetree/bindings/net/amlogic,meson-dwmac.yaml          | 2 +-
>  Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml      | 2 +-
>  Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml   | 2 +-
>  Documentation/devicetree/bindings/net/mediatek-dwmac.yaml     | 2 +-
>  Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml      | 2 +-
>  Documentation/devicetree/bindings/net/rockchip-dwmac.yaml     | 2 +-
>  .../devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml        | 4 ++--
>  .../devicetree/bindings/net/toshiba,visconti-dwmac.yaml       | 2 +-
>  10 files changed, 11 insertions(+), 11 deletions(-)




