Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340D51EEB8B
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 22:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbgFDUI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 16:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728590AbgFDUI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 16:08:57 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8F6C08C5C6
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 13:08:57 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p30so3985715pgl.11
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 13:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AFF1riO+rvi+JtGxWF5qzVLPXHH0Nzh8aZcDxBuji4s=;
        b=M0mkpsLd7B3310QKl3SLGg22ik2mXjNx5FY1vzJopMffJnCw8jRcmo9fV9LTIHikFp
         RUv7WnBJ6K5VaUslDx62awUaItJ+YKUKSU3/LS3bQT0QPBOUmH8h7pgLYyxlBLfTzZPU
         CwkTICvo+M0GUh+egz/pFlCv8tR424B81CNZ9aQO8/k4dMiV20ohQx7N7YX7tjfxxqqp
         JKfbJIsE+MYGNYLFN8gpzmr0Avp6j5x4qED0RF7A5OiE4WLh5w8/DvLwZz8GAkmSlO6c
         QbXytbk3xKeeMX1S4Xa0zICtEJbZ60RM6KlvqWwsKz3NAMy2eeUR9b8nqFf/OpAnG9F0
         SQHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AFF1riO+rvi+JtGxWF5qzVLPXHH0Nzh8aZcDxBuji4s=;
        b=IRbx0EKlO2tI2WausEIqxgY/0rtEKlQ91yLiq684c0YJAXU3AZjnCJUQMd4dYp/zoX
         bCMAsz2vRYrWtAO9qwE4cSc5mqPNZFAHcu6vaIglZRJev16UsyFfMwkWqDlz29t1Jq6l
         CtLNAkdBlVCT4xgjie4exO4Mkn09Uvc1xsmeVv08rL6YooywJQKQcwYiyAR42FwlYQug
         MS2ENNdLpoCk2GXBqBlXrt+2n7FLsjhp724LbRTUVZD7Gd0jvLNAW75nviUhGUXWPKRf
         2UDmEpTQnc0QfqCwwRtdGXxWwA02KDFxgbU0bkh9Ri2vKhPgbcAVLLrZB1nxvidQYsDe
         Fv0A==
X-Gm-Message-State: AOAM530Q4++QDegIzYzGYr24ulClDhkET7ux+9c2rT7JOn9prQ1r/Og2
        /OqXekQ1tc3q/0YA7QzCKrfTk1/gerGrrTpzKEiRGw==
X-Google-Smtp-Source: ABdhPJxLMcvCCgSkDUjAgCX71OWizViN7uenmXgd4TZP4zed6Dsn/5qWQdcJBcIITrWPyVLL/7sbTfhjLEhVY3eJVkA=
X-Received: by 2002:a63:5644:: with SMTP id g4mr5811569pgm.381.1591301336363;
 Thu, 04 Jun 2020 13:08:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200603233203.1695403-1-keescook@chromium.org> <20200603233203.1695403-4-keescook@chromium.org>
In-Reply-To: <20200603233203.1695403-4-keescook@chromium.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 4 Jun 2020 13:08:44 -0700
Message-ID: <CAKwvOdnNuFySqAMk7s_cXqFM=dPX4JfvqNVLCuj90Gn4tzciAw@mail.gmail.com>
Subject: Re: [PATCH 03/10] b43: Remove uninitialized_var() usage
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
> and make the (unreachable!) code do a conditional test.
>
> [1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.com/
> [2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com/
> [3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com/
> [4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/net/wireless/broadcom/b43/phy_n.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
> index d3c001fa8eb4..88cdcea10d61 100644
> --- a/drivers/net/wireless/broadcom/b43/phy_n.c
> +++ b/drivers/net/wireless/broadcom/b43/phy_n.c
> @@ -4222,7 +4222,7 @@ static void b43_nphy_tx_gain_table_upload(struct b43_wldev *dev)

The TODOs and `#if 0` in this function are concerning.  It looks like
`rf_pwr_offset_table` is only used when `phy->rev` is >=7 && < 19.

Further, the loop has a case for `phy->rev >= 19` but we would have
returned earlier if that was the case.

>         u32 rfpwr_offset;
>         u8 pga_gain, pad_gain;
>         int i;
> -       const s16 *uninitialized_var(rf_pwr_offset_table);
> +       const s16 *rf_pwr_offset_table = NULL;
>
>         table = b43_nphy_get_tx_gain_table(dev);
>         if (!table)
> @@ -4256,9 +4256,13 @@ static void b43_nphy_tx_gain_table_upload(struct b43_wldev *dev)
>                         pga_gain = (table[i] >> 24) & 0xf;
>                         pad_gain = (table[i] >> 19) & 0x1f;
>                         if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
> -                               rfpwr_offset = rf_pwr_offset_table[pad_gain];
> +                               rfpwr_offset = rf_pwr_offset_table
> +                                               ? rf_pwr_offset_table[pad_gain]
> +                                               : 0;
>                         else
> -                               rfpwr_offset = rf_pwr_offset_table[pga_gain];
> +                               rfpwr_offset = rf_pwr_offset_table
> +                                               ? rf_pwr_offset_table[pga_gain]
> +                                               : 0;


The code is trying to check `phy->rev >= 7 && phy->rev < 19` once
before the loop, then set `rf_pwr_offset_table`, so having another
conditional on `rf_pwr_offset_table` in the loop is unnecessary. I'm
ok with initializing it to `NULL`, but I'm not sure the conditional
check is necessary.  Do you get a compiler warning otherwise?

>                 } else {
>                         pga_gain = (table[i] >> 24) & 0xF;
>                         if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
> --
> 2.25.1
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200603233203.1695403-4-keescook%40chromium.org.



-- 
Thanks,
~Nick Desaulniers
