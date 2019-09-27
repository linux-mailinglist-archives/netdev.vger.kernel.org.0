Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61095C0D15
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 23:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbfI0VMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 17:12:35 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42522 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfI0VMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 17:12:35 -0400
Received: by mail-pg1-f196.google.com with SMTP id z12so4096133pgp.9
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 14:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MT3rEIfaJgpzvHmFM2pWeqN2XOEfjsN3Ht7YF+hthq8=;
        b=HWrjXwmyGQrWIktNn2lCfS/WWNp3jM0GJkqLaICHIq/FPWxfdSodtSpyQmZZZSqYKl
         gLWJ5uiWHrbfp7XRrlbm5tcLBi0mF8wxUQGVBvHdC+YrHRlTUWjnN/4obhqljgrPTG3A
         RZtBAyLun1kMIfwj+XzanCaE7pfz5X+1U1DEEWl4a0HFqU4UC+8fia7u1zVDsy87zqmM
         aCnZO4WYMlXyBvwTDY5YzycIIMk8vbQav6mKwEUaLZN6qC6Wase6y5kT8waFE/KYHjR2
         sI+xNuy9ZVIQOG/d3gqTWFx/1AYoGsrnH4KQyKPBRTWgKQPqX7caUSWi/ZiuXFXkwHDR
         u2xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MT3rEIfaJgpzvHmFM2pWeqN2XOEfjsN3Ht7YF+hthq8=;
        b=A3rBVhMHv4W4Q2e2quHVg8XAt16+sao9H3YUogioeoWKrctiLk0ZduZvoQBPpsFFWD
         33APmN2IsAvD1BFs1AanV/V1jKDJtD3GaJXpIWmXeLnimeoD0v6+8nlKm84RkRYFXT8H
         qp524CYYNUt4DEFwwr8pS6uPNUo/Y72wtLObVGqw5pEE11FTwWAIWHx/1albMRVqj9wj
         fL6DjxBnFhxejtr19DzPSBbNjV99G1frEJrXL72FzZ91whkxQpX8DP00MBMpuum2Vojn
         A2r0EsyUEGPljzm+RJ9YRY9dbY9ttXcXFVyN+a5zhqgvdRRoXN1GoTvQ/UtbxeNoAOzw
         hqEw==
X-Gm-Message-State: APjAAAWjj/2G4CEPaikKmj9lnLN1tCsp3ek72G/Ljt0Q0dSPD/hgao2H
        tXBBvX/2q1qzjVxCdP8mtqxQ8IdE3iln1ZoMnBGG4w==
X-Google-Smtp-Source: APXvYqy8O3KoXcSTxHqiytQM1iXWb+WWT9oKskcwqzyLQpgWA96K2vO/7MEIdTwZ75zGDyeYqjyajaWRaH5XxPonWcc=
X-Received: by 2002:a62:798e:: with SMTP id u136mr6912504pfc.3.1569618754157;
 Fri, 27 Sep 2019 14:12:34 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1569569778.git.Jose.Abreu@synopsys.com> <80dd26ecf7fc82c88dc378d78210df5dd4138812.1569569778.git.Jose.Abreu@synopsys.com>
In-Reply-To: <80dd26ecf7fc82c88dc378d78210df5dd4138812.1569569778.git.Jose.Abreu@synopsys.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 27 Sep 2019 14:12:23 -0700
Message-ID: <CAKwvOdntD5HNb4Gg04YN7iZwvK3CB4enq4ZPhUM-Bd3huvR2pw@mail.gmail.com>
Subject: Re: [PATCH net 8/8] net: stmmac: xgmac: Fix RSS not writing all Keys
 to HW
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 12:49 AM Jose Abreu <Jose.Abreu@synopsys.com> wrote:
>
> The sizeof(cfg->key) is != ARRAY_SIZE(cfg->key). Fix it.

I think the warning was from -Wsizeof-array-div.

>
> Reported-by: kbuild test robot <lkp@intel.com>
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>

I may have reported the kbuild link, but scanning my email, there's
also a report from
Reported-by: Nathan Chancellor <natechancellor@gmail.com>

> Fixes: 76067459c686 ("net: stmmac: Implement RSS and enable it in XGMAC core")
> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
>
> ---
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> Cc: Jose Abreu <joabreu@synopsys.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-stm32@st-md-mailman.stormreply.com
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
> index 6d8ac2ef4fc2..4a1f52474dbc 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
> @@ -533,7 +533,7 @@ static int dwxgmac2_rss_configure(struct mac_device_info *hw,
>                 return 0;
>         }
>
> -       for (i = 0; i < (sizeof(cfg->key) / sizeof(u32)); i++) {
> +       for (i = 0; i < (ARRAY_SIZE(cfg->key) / sizeof(u32)); i++) {

cfg is an instance of struct stmmac_rss, which looks like:
125 struct stmmac_rss {
126   int enable;
127   u8 key[STMMAC_RSS_HASH_KEY_SIZE];
128   u32 table[STMMAC_RSS_MAX_TABLE_SIZE];
129 };

yep, LGTM. Thanks for the patch.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>


>                 ret = dwxgmac2_rss_write_reg(ioaddr, true, i, cfg->key[i]);
>                 if (ret)
>                         return ret;
> --
> 2.7.4
>


--
Thanks,
~Nick Desaulniers
