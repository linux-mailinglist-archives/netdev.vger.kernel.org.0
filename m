Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5181EEBAB
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 22:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgFDUQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 16:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729125AbgFDUQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 16:16:21 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039F9C08C5C3
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 13:16:21 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id u5so4021638pgn.5
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 13:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pCXmYsl76J0CAlxoPdk8mPZO/WOJwZ5J1IK/xTYSvtY=;
        b=Ul9IqQ41ZiXh1TA37NXxQoP1MYWZkk1ImeHfZoGz6a6IPTQKCTgkI4vMbYvxIt8wpE
         ElHA9RWwTvFCaySEtclTRP/dyePJtOWdEk29ahiOH2gLk0aIx7jxMqS8sHpI0dAD9/eD
         v2pQeh6hmu6BRKkCyhh5mYDGk/czBtEllytZVgQeNFhavoEfrbFwLLVfzZ/2XW9eqAuC
         T6PPxSNZdkIUyyCpj3L+bHh3A58HE+YTCCyomOaAjuPFYAu7WNLA0VPJGgc8Oy3KvimW
         enSRBgfNysV+6XPIzSx1E3hPpfiQZPkCEErtaeB8Ewgc+PLJOHksAeBzo6J1PIYEAlTL
         B91g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pCXmYsl76J0CAlxoPdk8mPZO/WOJwZ5J1IK/xTYSvtY=;
        b=gmygQzMnsfChKfE4aGmYo6LEaSc3wsOF1GHG4gMGgfxBamqe9N5jK8oa2D+FtcCKJY
         uPcWAJWCcl3lg9gp7syLf/W89DStMfMQW4+dFcZs3R0+/T12J7C3e3doDuLGaiD9Lot/
         MLZStyIGHAN3gLMw1oVPoGFloXCNSibt3uP2GnCc6dfq2HHfAJ6al4uxoh3VMaVZXAbH
         mOs1J6T2s/4FGVqfNTC9F9rRuRa9FiKD2d8q3nJL7NdwkygBpyEeRP5N7HUp3NTc9faC
         RqqKzwKrkLX5gx7jKzPmMljV2OSlnSaRRv/omajhJkNNOXnf2y0Q98wOejHBTzoYhxDo
         3Y1g==
X-Gm-Message-State: AOAM533wR9TmaiICQvkHbQL528DRY/uEvhCIZ16nRY0dFVNAHcq8BVto
        Z76R3ZaqjrRcylvrOab3It4gWQXW6R6EEL8sQqcQ+A==
X-Google-Smtp-Source: ABdhPJye6FZH70P5vXHcitY46EI4rxFnZqJif4KZJI8zWDppq3cq3MmDJfiH17IwjHHvUarffuS8hk7FOMV62ymzGuM=
X-Received: by 2002:a63:4f09:: with SMTP id d9mr5970154pgb.10.1591301780211;
 Thu, 04 Jun 2020 13:16:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200603233203.1695403-1-keescook@chromium.org> <20200603233203.1695403-5-keescook@chromium.org>
In-Reply-To: <20200603233203.1695403-5-keescook@chromium.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 4 Jun 2020 13:16:08 -0700
Message-ID: <CAKwvOdnd30bcqoNXF1ugadU=KbW3aXu07+T-891amO2_b7kQdg@mail.gmail.com>
Subject: Re: [PATCH 04/10] rtlwifi: rtl8192cu: Remove uninitialized_var() usage
To:     Kees Cook <keescook@chromium.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-ide@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-spi@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 3, 2020 at 4:32 PM Kees Cook <keescook@chromium.org> wrote:
>
> Using uninitialized_var() is dangerous as it papers over real bugs[1]
> (or can in the future), and suppresses unrelated compiler warnings (e.g.
> "unused variable"). If the compiler thinks it is uninitialized, either
> simply initialize the variable or make compiler changes. As a precursor
> to removing[2] this[3] macro[4], just initialize this variable to NULL,
> and avoid sending garbage by returning.
>
> [1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.com/
> [2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com/
> [3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com/
> [4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Fixes: dc0313f46664 ("rtlwifi: rtl8192cu: Add routine hw")

> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
> index f070f25bb735..5b071b70bc08 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
> @@ -592,7 +592,7 @@ static void _rtl92cu_init_chipn_one_out_ep_priority(struct ieee80211_hw *hw,
>                                                     bool wmm_enable,
>                                                     u8 queue_sel)
>  {
> -       u16 uninitialized_var(value);
> +       u16 value;
>
>         switch (queue_sel) {
>         case TX_SELE_HQ:
> @@ -606,7 +606,7 @@ static void _rtl92cu_init_chipn_one_out_ep_priority(struct ieee80211_hw *hw,
>                 break;
>         default:
>                 WARN_ON(1); /* Shall not reach here! */
> -               break;
> +               return;
>         }
>         _rtl92c_init_chipn_reg_priority(hw, value, value, value, value,
>                                         value, value);

Whew! Nothing like passing the same value 6 times! (Other callers do
use distinct values though, just curious seeing this instance.)

-- 
Thanks,
~Nick Desaulniers
