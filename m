Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 656C756C541
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 02:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiGHXsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 19:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGHXsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 19:48:15 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3513EA79F8
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 16:48:13 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id f39so187826lfv.3
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 16:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pv/kMkRXLTmjNlh49xKQLUzHkabn6pqCOnhb5uu/n7E=;
        b=Iqd/944B5JiBG7p6ksdmO0GUZ4qrnQMi/cOZtevlIaX7we0yVtFSiQV6u/gVu87PVu
         iSdor1XOrotUAnhOBPJnkHwpepagsDEG7xfH1y7+7UwJnJHrhiBpn0rqcXVAv/btO3ko
         t/fEV8xFM8pDS3IaDHC5dcc6c4kMMjBwu8a7Pk4HB0XtW03UwVqZ0acr6lq97X7/9MSn
         OMtrHoVJgmuF8/yNZnpIA9Ko+0UDIRksYUoZE0w5bgsaI68L0hszdNPHfh2zTm+Ll9Vi
         ycVv4QI8zAXSdOBrYxfw3A5x3VjJnvrw49gQM+Eh+dFXuNmCY8NK0u5F5M3HFGYNuyT9
         eTbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pv/kMkRXLTmjNlh49xKQLUzHkabn6pqCOnhb5uu/n7E=;
        b=DC/qWSpsSriFQiSMOba5sAKOnzGL8WaduizJMSKchG7fHIXWA8Ep6y7aqbpYqeSDlv
         658FzDDwoRmw9XOaKlxgg6FVF8u3ikhGCtdd80zK/b1Yrwg7JL2qH6QtaRxe5p5G+mqD
         T9bXaeurpHp4ludlmsLQd5i/SVQSiDj6i+Ddkk8Cgf2VUmU3LUQyr/od9CL3UHhm3fyy
         mzI9jns9OcbD06xN3FiDu50K5ifYpXLz9UTavOBO3IT9aRbArEUNRLvwrn5AyA3/32nc
         foOz2yHMRa0bfV/YwMoJTkV81ifTX5eEiO8vfUevhabFfCcQbuOdcAS2mS1c/s1BfE2+
         mP1A==
X-Gm-Message-State: AJIora+DARvSUlQTQsVV6O1GaEbHJDjEeGyiS+yXgRvIpL0DIEVQ247z
        uAukk3JpISYgeNLlOHoI7tf54cHNQAalIz9cbdni5A==
X-Google-Smtp-Source: AGRyM1uoxri5xBzbkCOkKoBGRKW38ISN7unT41Wp5JJBP9Qk62V89Vj/Xf1lfVnuMPdipiZkscI6YtbzhbxPPQIRiaA=
X-Received: by 2002:a05:6512:2623:b0:47d:ace7:c804 with SMTP id
 bt35-20020a056512262300b0047dace7c804mr3937905lfb.647.1657324091178; Fri, 08
 Jul 2022 16:48:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220708232653.556488-1-justinstitt@google.com>
In-Reply-To: <20220708232653.556488-1-justinstitt@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 8 Jul 2022 16:47:59 -0700
Message-ID: <CAKwvOdnhzwg0OswLc+RwgX0=Z4beF6EEO09w8Ezdhg-YyXQeJg@mail.gmail.com>
Subject: Re: [PATCH] amd-xgbe: fix clang -Wformat warnings
To:     Justin Stitt <justinstitt@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 8, 2022 at 4:27 PM Justin Stitt <justinstitt@google.com> wrote:
>
> When building with Clang we encounter the following warning:
> | drivers/net/ethernet/amd/xgbe/xgbe-dcb.c:234:42: error: format specifies
> | type 'unsigned char' but the argument has type '__u16' (aka 'unsigned
> | short') [-Werror,-Wformat] pfc->pfc_cap, pfc->pfc_en, pfc->mbc,
> | pfc->delay);
>
> pfc->pfc_cap , pfc->pfc_cn, pfc->mbc are all of type `u8` while pfc->delay is
> of type `u16`. The correct format specifiers `%hh[u|x]` were used for
> the first three but not for pfc->delay, which is causing the warning
> above.
>
> Variadic functions (printf-like) undergo default argument promotion.
> Documentation/core-api/printk-formats.rst specifically recommends using
> the promoted-to-type's format flag. In this case `%d` (or `%x` to
> maintain hex representation) should be used since both u8's and u16's
> are fully representable by an int.
>
> Moreover, C11 6.3.1.1 states:
> (https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1548.pdf) `If an int
> can represent all values of the original type ..., the value is
> converted to an int; otherwise, it is converted to an unsigned int.
> These are called the integer promotions.`
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/378
> Signed-off-by: Justin Stitt <justinstitt@google.com>

Thanks for the patch, this fixes an instance of -Wformat I observe for
x86_64 allmodconfig.  I thought you had already fixed this file up?
https://lore.kernel.org/llvm/20220607191119.20686-1-jstitt007@gmail.com/
which was merged. I'm guessing that was from a defconfig, while this
was from an allmodconfig?
Seems like there's a bunch of config ifdef'ery around the definition
of netif_dbg.

Either way, thanks for the patches and

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
> For clarification, the first three parameters given to netif_dbg did NOT
> cause a -Wformat warning. I changed them simply to follow what the
> standard and documentation recommend.
>
>  drivers/net/ethernet/amd/xgbe/xgbe-dcb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-dcb.c b/drivers/net/ethernet/amd/xgbe/xgbe-dcb.c
> index 895d35639129..c68ace804e37 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-dcb.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-dcb.c
> @@ -230,7 +230,7 @@ static int xgbe_dcb_ieee_setpfc(struct net_device *netdev,
>         struct xgbe_prv_data *pdata = netdev_priv(netdev);
>
>         netif_dbg(pdata, drv, netdev,
> -                 "cap=%hhu, en=%#hhx, mbc=%hhu, delay=%hhu\n",
> +                 "cap=%d, en=%#x, mbc=%d, delay=%d\n",
>                   pfc->pfc_cap, pfc->pfc_en, pfc->mbc, pfc->delay);
>
>         /* Check PFC for supported number of traffic classes */
> --
> 2.37.0.rc0.161.g10f37bed90-goog
>


-- 
Thanks,
~Nick Desaulniers
