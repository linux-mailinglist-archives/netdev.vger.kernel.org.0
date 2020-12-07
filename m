Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38ACB2D0D0D
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 10:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgLGJcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 04:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgLGJcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 04:32:35 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE10FC0613D1
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 01:31:49 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id c198so10906903wmd.0
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 01:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:message-id
         :date:mime-version;
        bh=GLuU4c9odSxFrnOuGet4+6CjpgyrMIWPZsUZq/PreGk=;
        b=i0Yc5QA90bEFBhwG6hH1g28TISmrUpKKqy2tRuXZIKguMBG/kBKv49AJWqGmNlgWXK
         uUk2WVKjmEgACcqYUvwAdPy7RY+jUaZeSbx5AeFS0JMNUwURxkbW+Kfi+olqbWTFqZnO
         D2uPXUc2baCQ2KMw//MjQL/+BZ6osDZlgQzE03l/aCcTikXeX9BWQp786HvpJ3N9Vgww
         S+ImKyqgUny8XZiooKdMpc9pk6opwrdQux/WAQiHKa3ZsvUjBz0bhHJxAkRgzQXZDORw
         4d8LduMwaP8LaT2vgNQGVSGIn7spsXDHE5r5YwmXJRhq1wCLQjTOjbKgabX3l7wXkeVi
         ahkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:message-id:date:mime-version;
        bh=GLuU4c9odSxFrnOuGet4+6CjpgyrMIWPZsUZq/PreGk=;
        b=nibK5QGqEiFR7AkNvBJRFF+UllbUkIv3u7WUHOHPFE8vUbvtuGmUHiMEvwWPmfFMje
         9XBnD9zKAGVydutQClw3WNEAHX13Hnns4b+jEaz3qrtM9btJh3n7z6rPN8aNJdowSPXo
         l/iQcAQhoYgoXqN0mTKGDlpLrcMgTekvYjhS3SBXzGFehmBAH6xxd9f3l2N8RY/E53W7
         JXrtq9DBPmrfNu6ZhN87ZoWD5O6WVb4sQ4Odell1vajKnAU/clxo6Qs/m1zBU3bbC6XZ
         6DlzWFPQVcPdRJSB7a5JQR07izjva39qKEDbvrSwChRFWTSaz6aJwGWlfbJap0vBr//P
         Shkg==
X-Gm-Message-State: AOAM532BvCdu3RGBEkhvv7c2G5rfdzta3a2xvpBYvZun2j5sG2QCVnhY
        moxcNtMB+66FPsjyM2xWHnLtNQ==
X-Google-Smtp-Source: ABdhPJw4vyyf2WIkP9E5DrBKTOacvbXpy3jjxOnALxt8z3HsQ49xyCYXLUlrFZfzyjlszQINDzHQYg==
X-Received: by 2002:a1c:9949:: with SMTP id b70mr17600666wme.85.1607333508343;
        Mon, 07 Dec 2020 01:31:48 -0800 (PST)
Received: from localhost (82-65-169-74.subs.proxad.net. [82.65.169.74])
        by smtp.gmail.com with ESMTPSA id k64sm12889681wmb.11.2020.12.07.01.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 01:31:47 -0800 (PST)
References: <20201205213207.519341-1-martin.blumenstingl@googlemail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: stmmac: dwmac-meson8b: fix mask definition of the
 m250_sel mux
In-reply-to: <20201205213207.519341-1-martin.blumenstingl@googlemail.com>
Message-ID: <1jo8j62c8t.fsf@starbuckisacylon.baylibre.com>
Date:   Mon, 07 Dec 2020 10:31:46 +0100
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sat 05 Dec 2020 at 22:32, Martin Blumenstingl <martin.blumenstingl@googlemail.com> wrote:

> The m250_sel mux clock uses bit 4 in the PRG_ETH0 register. Fix this by
> shifting the PRG_ETH0_CLK_M250_SEL_MASK accordingly as the "mask" in
> struct clk_mux expects the mask relative to the "shift" field in the
> same struct.
>
> While here, get rid of the PRG_ETH0_CLK_M250_SEL_SHIFT macro and use
> __ffs() to determine it from the existing PRG_ETH0_CLK_M250_SEL_MASK
> macro.
>
> Fixes: 566e8251625304 ("net: stmmac: add a glue driver for the Amlogic Meson 8b / GXBB DWMAC")
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>

> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
> index dc0b8b6d180d..459ae715b33d 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
> @@ -30,7 +30,6 @@
>  #define PRG_ETH0_EXT_RMII_MODE		4
>  
>  /* mux to choose between fclk_div2 (bit unset) and mpll2 (bit set) */
> -#define PRG_ETH0_CLK_M250_SEL_SHIFT	4
>  #define PRG_ETH0_CLK_M250_SEL_MASK	GENMASK(4, 4)
>  
>  /* TX clock delay in ns = "8ns / 4 * tx_dly_val" (where 8ns are exactly one
> @@ -155,8 +154,9 @@ static int meson8b_init_rgmii_tx_clk(struct meson8b_dwmac *dwmac)
>  		return -ENOMEM;
>  
>  	clk_configs->m250_mux.reg = dwmac->regs + PRG_ETH0;
> -	clk_configs->m250_mux.shift = PRG_ETH0_CLK_M250_SEL_SHIFT;
> -	clk_configs->m250_mux.mask = PRG_ETH0_CLK_M250_SEL_MASK;
> +	clk_configs->m250_mux.shift = __ffs(PRG_ETH0_CLK_M250_SEL_MASK);
> +	clk_configs->m250_mux.mask = PRG_ETH0_CLK_M250_SEL_MASK >>
> +				     clk_configs->m250_mux.shift;
>  	clk = meson8b_dwmac_register_clk(dwmac, "m250_sel", mux_parents,
>  					 ARRAY_SIZE(mux_parents), &clk_mux_ops,
>  					 &clk_configs->m250_mux.hw);

