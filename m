Return-Path: <netdev+bounces-8380-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35201723D82
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:31:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D2591C20F14
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:31:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFE99125AB;
	Tue,  6 Jun 2023 09:31:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5514294C5
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:31:03 +0000 (UTC)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E15AE64;
	Tue,  6 Jun 2023 02:31:01 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-bacf9edc87bso6760212276.1;
        Tue, 06 Jun 2023 02:31:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686043860; x=1688635860;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=df7YhrQ8BP3E4zkFEMrRKwE0BeL6leEPeFTGUzFOtT0=;
        b=adjzNRCvemVhg4ibWiZ+eCbC6rnDFF7MlbPcMUCnXOiM9fQJpEffVJVDUeB5koIff2
         GjPTiD3Czs5i+Vb3shKLeVhB84Q1E60VcezTNie5pStqWWVDJRQ0Wyaw+ofVBod5zkvM
         MBtWB0Epb3km1CurT4JqimsYrYRbUpb2g+XBOTscMpX4O8zd6X0h2gq/xrL67Q4ULW83
         awjYSAwhcPv9Jscq6+2iECM9aQEhVDa+AZn0HhNs/RQCvOXof40hVkzb+GkPvG+Bmr+U
         tzvNUQHO8x4dDOxR84SRmq670Lc6XahgMLizXihJuWKd5migkPHrRaoKwgJ4n0vuqfbM
         Z7LQ==
X-Gm-Message-State: AC+VfDwIig0iRm55oE4GEPtM3g7lsxiq6mqKGN4cCU5eaeZLlI9Fd9O5
	a0h2oKRQRe8JgwrgRw8b03BK5XWJEZWwHw==
X-Google-Smtp-Source: ACHHUZ5SavJiuwkNAzEnBjois+20vL/bw/qjscX8DnVy0PGGGhP9n2cGwtZVb9sdx0ssXh/ELEUsRw==
X-Received: by 2002:a0d:ea03:0:b0:559:d3a0:4270 with SMTP id t3-20020a0dea03000000b00559d3a04270mr1471902ywe.34.1686043860279;
        Tue, 06 Jun 2023 02:31:00 -0700 (PDT)
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com. [209.85.128.178])
        by smtp.gmail.com with ESMTPSA id d69-20020a814f48000000b00568bc0bbf8esm3921333ywb.71.2023.06.06.02.30.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 02:30:59 -0700 (PDT)
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-5689335d2b6so59939197b3.3;
        Tue, 06 Jun 2023 02:30:59 -0700 (PDT)
X-Received: by 2002:a81:5c03:0:b0:561:baee:ee8 with SMTP id
 q3-20020a815c03000000b00561baee0ee8mr1474317ywb.32.1686043858984; Tue, 06 Jun
 2023 02:30:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <7b36ac43778b41831debd5c30b5b37d268512195.1686039915.git.geert+renesas@glider.be>
In-Reply-To: <7b36ac43778b41831debd5c30b5b37d268512195.1686039915.git.geert+renesas@glider.be>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 6 Jun 2023 11:30:47 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXnMd=b1q+hmv1GsrugG7PhHXLznV5A0UKmoezaQY4oog@mail.gmail.com>
Message-ID: <CAMuHMdXnMd=b1q+hmv1GsrugG7PhHXLznV5A0UKmoezaQY4oog@mail.gmail.com>
Subject: Re: [PATCH] net: stmmac: Fix build without PCS_LYNX
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Jose Abreu <joabreu@synopsys.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Simon Horman <simon.horman@corigine.com>, 
	netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-renesas-soc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 6, 2023 at 10:27=E2=80=AFAM Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> If STMMAC_ETH=3Dy, but PCS_LYNX=3Dn (e.g. shmobile_defconfig):
>
>     arm-linux-gnueabihf-ld: drivers/net/ethernet/stmicro/stmmac/stmmac_md=
io.o: in function `stmmac_mdio_unregister':
>     stmmac_mdio.c:(.text+0xfbc): undefined reference to `lynx_pcs_destroy=
'
>
> As pcs_lynx is used only on dwmac_socfpga, fix this by adding a check
> for PCS_LYNX to the cleanup path in the generic driver.
>
> Fixes: 5d1f3fe7d2d54d04 ("net: stmmac: dwmac-sogfpga: use the lynx pcs dr=
iver")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/=
net/ethernet/stmicro/stmmac/stmmac_mdio.c
> index c784a6731f08e108..53ed59d732210814 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> @@ -665,7 +665,7 @@ int stmmac_mdio_unregister(struct net_device *ndev)
>         if (priv->hw->xpcs)
>                 xpcs_destroy(priv->hw->xpcs);
>
> -       if (priv->hw->lynx_pcs)
> +       if (IS_ENABLED(CONFIG_PCS_LYNX) && priv->hw->lynx_pcs)
>                 lynx_pcs_destroy(priv->hw->lynx_pcs);
>
>         mdiobus_unregister(priv->mii);

As pointed out by Arnd, this doesn't work when PCS_LYNX is a loadable
module and STMMAC is built-in:
https://lore.kernel.org/r/11bd37e9-c62e-46ba-9456-8e3b353df28f@app.fastmail=
.com

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

