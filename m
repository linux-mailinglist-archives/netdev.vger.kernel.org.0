Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D4A2D8ED1
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 17:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437478AbgLMQeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 11:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437022AbgLMQda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 11:33:30 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81457C0613D3;
        Sun, 13 Dec 2020 08:32:50 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id t13so13079331ybq.7;
        Sun, 13 Dec 2020 08:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OOly9loxLYTvtE1Njo5WCf0TNy0xF1kl9c/YUhN9Ldg=;
        b=CQnFeP/qKJ1PIVVbcikxlOyY0crNPCzCLu36oBQIVFV74Qm25kpqcvPED0RU69ffXH
         uD6MhZB+lq4W+AwP/iSR1y65ptVYtL2M9m/31Fq2JJPuJWN6yPuvek6A5N6ax9r5UCRw
         v0A7+nXAqDoI6u2QDgJS/P0XsGWZQKRj7ErAjJubTAV4bU8mufhSSkpu98ZVvUCjUmKH
         m8l5+M1F6sAbrcTb0c9JMjQIhq3a3okT8zVEj/9CKQSUV3R07tDspVdX2gGqJCSVv6xy
         7W5JptzuBD1Rtp0cr87thNuZ5gZd+z6n4BrWRFemSfSqlGvEaVbpoSKchAuRye9qKD9Z
         moJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OOly9loxLYTvtE1Njo5WCf0TNy0xF1kl9c/YUhN9Ldg=;
        b=AIYSGmlfBWA3irA0NOc3iIS0v/cmJEJiSwOETpMqkK1mEnb+WblO9NijPDP8nmVsW+
         vx1wd2iyARDDW06IchgdjBN6Q73YTYOtvaVR0g7EFeCm9DrvlBhSKytUV9f0ssGyAjCP
         td10z4hBmOwU/ZpWMVScyI18oUahmrt9dUo2J1HyPfZzxTnlz3cxiso0549w5toJBgVL
         0oksyKChiJnVQis/inMdC9PDWncuubZpUmAKQ2uqBDgBQjCaLTxSQrU69Q8TigDAwp3i
         KPZY6SHtqrTp4sfFIYwI4nY4sxybGvHWQms3p11Qxu0DkPeLnOlWExBuhaFmIBh6+Zhv
         jjJg==
X-Gm-Message-State: AOAM531WQd28SJvN9Y4xpxoOdDP/G/gzi486s+WPDdmTbklRLxg+xPVk
        QsKkbpliiVF9k74x1bVxnLdjIk+XCPhiXH3fWAiPCCTpzFQ=
X-Google-Smtp-Source: ABdhPJzYbmOg9ijb/AZ8TKkK+fOnNQR1Y5LH6RzvAMw7yylGfsj/NGzlkqPYBT43q2CZBUVma+fLSh0qufHXXvXT9TQ=
X-Received: by 2002:a25:40d:: with SMTP id 13mr32470818ybe.422.1607877169805;
 Sun, 13 Dec 2020 08:32:49 -0800 (PST)
MIME-Version: 1.0
References: <20201128193335.219395-1-masahiroy@kernel.org> <20201212161831.GA28098@roeck-us.net>
 <CANiq72=e9Csgpcu3MdLGB77dL_QBn6PpqoG215YUHZLNCUGP0w@mail.gmail.com>
 <8f645b94-80e5-529c-7b6a-d9b8d8c9685e@roeck-us.net> <f5c2d237-1cc7-5a78-c87c-29b7db825f68@urlichs.de>
In-Reply-To: <f5c2d237-1cc7-5a78-c87c-29b7db825f68@urlichs.de>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Sun, 13 Dec 2020 17:32:38 +0100
Message-ID: <CANiq72kajFSgKmYW0tXUXNEQpMwBW7BsFSeqbMVDmXqBXDLh_A@mail.gmail.com>
Subject: Re: [PATCH v3] Compiler Attributes: remove CONFIG_ENABLE_MUST_CHECK
To:     Matthias Urlichs <matthias@urlichs.de>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Shuah Khan <shuah@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 4:38 PM 'Matthias Urlichs' via Clang Built
Linux <clang-built-linux@googlegroups.com> wrote:
>
> If your change to a function breaks its callers, it's your job to fix

No function has changed. This patch enables a warning (that for some
reason is an error in the case of Guenter).

Even if this was a hard error, the same applies: the function hasn't
changed. It just means callers never tested with
`CONFIG_ENABLE_MUST_CHECK` for *years*.

> the callers proactively instead of waiting for "as they come" bug
> reports. (Assuming, of course, that you know about the breakage. Which
> you do when you tell us that the bad pattern can simply be grepped for.)

No, *we don't know about the breakage*. The grep was for the
particular function Guenter reported, and done to validate his
concern.

If you want to manually inspect every caller of every `__must_check`
function, or to write a cocci patch or a clang-tidy check or similar
(that would be obsolete as soon as `__must_check` is enabled), you are
welcome to do so. But a much better usage of our time would be letting
machines do their job.

> If nothing else, that's far more efficient than [number_of_callers]
> separate patches by other people who each need to find the offending
> change, figure out what to change and/or who to report the problem to,
> and so on until the fix lands in the kernel.

This change is not in Linus' tree, it is on -next.

> Moreover, this wouldn't leave the kernel sources in a non-bisect-able
> state during that time.

Again, the change is in -next. That is the point: to do integration
testing and let the bots run against it.

Cheers,
Miguel
