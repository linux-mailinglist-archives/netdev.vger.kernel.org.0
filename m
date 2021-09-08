Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB75403267
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 03:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347051AbhIHBxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 21:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346972AbhIHBxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 21:53:03 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFACC061575
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 18:51:56 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id s25so698765edw.0
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 18:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LxLbN5oXo3pkASZMt7+BOQU43HJcJssxtcghQNdRrVo=;
        b=AvxEqZUbI6FOu7pL8djSL10B3yrzx6C1ITuJnwmqc68sRjbZt0UZcqj4OOhM/IN1fR
         mQG32bTk85V1KzAyt6/UfkczGxInrsiK0SxFntGyw21Fx6X9gUZPDg0Vkw6nUon4YkgN
         GbxPU6vAxh7JV7pXhTlUM8mduw1Pz4ptY22hI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LxLbN5oXo3pkASZMt7+BOQU43HJcJssxtcghQNdRrVo=;
        b=H5ONqLQTl+JmZMcyqnQaPiGujcPmYV5FcRo1w302+0KtFXPk7Modb7ROTNgYWaZ2iT
         bluwwJziAj1Fj0R1/g0/0rkuVB044k7thP+1tiIFJnT4hLFogLaMW01tVfqyem0pxSBa
         WWidfI4fVQEGQt/yJsSwLfUVWeILJpYHkRIfIhWVoGghQwwkfqmqM2mKAAOZu5dFROMx
         J5YgeTqq8xeaUaK1TDZVPGeRyTj2RBwm2lz1Wjl5DH+3UkExQMaSpJIB5hROU2AnExmQ
         oLy5T4/PrLUxOjrBFE0JGxliq5m1Mos67Dn9+W3E1eZcnFhCqOlNR/PxszLb2gbjw/F8
         9hfg==
X-Gm-Message-State: AOAM531n/d3qgQJc2Wwp6QzeAvkQc4pj3q6pAaNpI/rVTlz2WHxRY18B
        4OuObKMk6aaTGFJNGzSIyV49adOWj3h2ZA9fKfg=
X-Google-Smtp-Source: ABdhPJxnVgzgA3XXwqa4EFlL8d7umhpYJlwy6xIaq03K038qo+htUAlqbwCrnXE5YaLnhN/a7zpsRA==
X-Received: by 2002:a05:6402:1455:: with SMTP id d21mr1312413edx.161.1631065915149;
        Tue, 07 Sep 2021 18:51:55 -0700 (PDT)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com. [209.85.221.47])
        by smtp.gmail.com with ESMTPSA id u10sm296001eds.83.2021.09.07.18.51.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 18:51:55 -0700 (PDT)
Received: by mail-wr1-f47.google.com with SMTP id q26so750768wrc.7
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 18:51:55 -0700 (PDT)
X-Received: by 2002:a05:6512:3987:: with SMTP id j7mr946864lfu.280.1631065441904;
 Tue, 07 Sep 2021 18:44:01 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
 <92c20b62-c4a7-8e63-4a94-76bdf6d9481e@kernel.org> <CAHk-=wiynwuneR4EbUNtd2_yNT_DR0VQhUF1QOZ352D-NOncjQ@mail.gmail.com>
 <a2c18c6b-ff13-a887-dd52-4f0aeeb25c27@kernel.org> <CAHk-=whcFKGyJOgmwJtWwDCP7VFPydnTtsvjPL6ZP6d6gTyPDQ@mail.gmail.com>
In-Reply-To: <CAHk-=whcFKGyJOgmwJtWwDCP7VFPydnTtsvjPL6ZP6d6gTyPDQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 7 Sep 2021 18:43:46 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi+O66NwiiAYBeS6kiix6YGuDvPf-MPddtycE_D4fWV=g@mail.gmail.com>
Message-ID: <CAHk-=wi+O66NwiiAYBeS6kiix6YGuDvPf-MPddtycE_D4fWV=g@mail.gmail.com>
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com, Wei Liu <wei.liu@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 7, 2021 at 6:35 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I think a lot of them have just copied the x86 code (it was 4k long
> ago), without actually understanding all the details.

Just to put the x86 number in perspective: it was raised to 8192 back
in 2013, with the comment

    x86/cpu: Increase max CPU count to 8192

    The MAXSMP option is intended to enable silly large numbers of
    CPUs for testing purposes.  The current value of 4096 isn't very
    silly any longer as there are actual SGI machines that approach
    6096 CPUs when taking HT into account.

    Increase the value to a nice round 8192 to account for this and
    allow for short term future increases.

so on the x86 side, people have actually done these things.

Other architectures? I think some IBM power9 machines can hit 192
cores (with SMT4 - so NR_CPUS of 768), but I don't think there's been
an equivalent of an SGI for anything but x86.

But admittedly I haven't checked or followed those things. I could
easily imagine some boutique super-beefy setup.

               Linus
