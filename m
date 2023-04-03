Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7392C6D52A5
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbjDCUjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233424AbjDCUjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:39:25 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242D235AB
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 13:39:16 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id ek18so122364323edb.6
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 13:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680554354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ANuyucjG7+IOsm6+PTXTUkVZpuE117uxor/udrQsrHI=;
        b=QBtct7OF544g4KW8FmyicOGj93ZjWlg8zuQv1bJbp8jcg7kZlaoTEPE+ZjM8qK1FvF
         ySiNTF5dDqmcX7CK3V3nXjfCtZyZUPhXWS0tiyg1h2mmI68eIuECf75r+pVgglVEKCkU
         kHoMUTP0p53HT7ROKBpLFzTXIvLXbS7upHKKFV+6T4zuNMqbtyJ5qYvrMPN/aHFSnads
         mcQglHoBkCSFBXGMXHZCZrQSWHcr75YnbjUa66Tunz0FV33dyy00oLs71tZiNRBidtW4
         jtGUBV/KHY62/FaxcVx0/bdUCldUHFYapDx3Da/E+rJH3/2oHbH6x+g4Go250AzETWuH
         eyhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680554354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ANuyucjG7+IOsm6+PTXTUkVZpuE117uxor/udrQsrHI=;
        b=O3vpCOinyCnTRHoBP3ficfBCKsG7K0wXB4ibj2nsXKuJkKLEkyk5PCqmXqDORBf4/g
         PiOAObo/XjaBpJgDv6zEYokbkvfhz59E5KFuyXr66+X6L+uvIYYyB7e7jbDX813nrJbL
         aaJz17YXcSF2dvo8W7ukZd/CGPhVH6/b3pIOY2LhDi6MZfCJ5I1RjrxKBCai9kAomfEA
         htwY2Z2yIvEHW6MgY/48fjVg1BaUVP3AwMGFQIJn8iZX7IgpYMuXxecuOk8Se3+k5hIR
         IS2+8Wy7DUyYdzUV88NOea2fQD/DadIh7IaStO3AkLlVwT4cG+j4xuQl89G3325BIPnV
         PJwA==
X-Gm-Message-State: AAQBX9cR+zIRxvL2cS0b65TUsirsS2K+s/ei2Bc2cbilfO57J360B09n
        IcTqUL85rCRkuxo3jCo34V9EXnOjeOGapev3nv8=
X-Google-Smtp-Source: AKy350Yxps2lCxD4+gSI3XRR+EKyXbQm+2ZcypH1MgOjQt3rpacSMedZmkVztU2IZX24o5jZNqKukzBRTVyKq2STkzU=
X-Received: by 2002:a05:6402:a47:b0:502:3e65:44f7 with SMTP id
 bt7-20020a0564020a4700b005023e6544f7mr10506548edb.3.1680554354318; Mon, 03
 Apr 2023 13:39:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de> <20230402143025.2524443-2-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20230402143025.2524443-2-u.kleine-koenig@pengutronix.de>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 3 Apr 2023 22:39:03 +0200
Message-ID: <CAFBinCBX8dQo9898KkXaMaanQ9-LcFA7HHFf+XBM2-f+g8WY7Q@mail.gmail.com>
Subject: Re: [PATCH net-next 01/11] net: stmmac: Make stmmac_pltfr_remove()
 return void
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        linux-amlogic@lists.infradead.org, linux-oxnas@groups.io,
        linux-sunxi@lists.linux.dev, linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 2, 2023 at 4:31=E2=80=AFPM Uwe Kleine-K=C3=B6nig
<u.kleine-koenig@pengutronix.de> wrote:
>
> The function returns zero unconditionally. Change it to return void inste=
ad
> which simplifies some callers as error handing becomes unnecessary.
>
> The function is also used for some drivers as remove callback. Switch the=
se
> to the .remove_new() callback. For some others no error can happen in the
> remove callback now, convert them to .remove_new(), too.
>
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c     | 2 +-
>  drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c     | 2 +-
>  drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c         | 2 +-
>  drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c     | 2 +-
>  drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c  | 9 +++------
>  drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c     | 2 +-
>  drivers/net/ethernet/stmicro/stmmac/dwmac-lpc18xx.c     | 2 +-
>  drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c    | 9 +++------
>  drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c       | 2 +-
>  drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c     | 2 +-
for dwmac-meson and dwmac-meson8b:
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
