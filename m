Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627E8403237
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 03:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346180AbhIHBhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 21:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239561AbhIHBhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 21:37:17 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA9DC061575
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 18:36:10 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id k4so1538979lfj.7
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 18:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cmtZIOS9Ve5xG2iMzkU1sWtv+qTK9kG1NPN7g5hyzNo=;
        b=Avp2QNon6oXLwlm91DcxXo2K8Ngk0nif54gPFAF8gSN1i8UGU3RnS5zbBTY4njddzE
         kRimZCEAjTDErRvXr9NzGnDj9ERJN9NqfNGni7tfa8fg8ZRHueouEt6GdIwj0aLgB6gt
         6fk+gKUyYscFIVOTodXPJQY4t8lVrFzEU6fng=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cmtZIOS9Ve5xG2iMzkU1sWtv+qTK9kG1NPN7g5hyzNo=;
        b=kb41HAxPj5Eiqv0pLcMJil7jaGQO7BJ3k2X/Br8opfy/WEOPzTZztcm/Qyja0w1TLp
         p2TlWIvlyGTw70JzVUgU9KNxu6S9sqfsJZf5+4W+1GPoRxwS2wtRw5fZ6JyfQP0ZvSm3
         6z7FYaWFq6qcQEMhKVbpr1MjzkewoOceCR/SuJTXnIShdDnKAZjewnmI3pJa2seHBVDb
         kojvSgFa6kYSMQKjJBNBMits8Ta5l9rqwec0FDtWqZQIOHxEQjmSSer/WWgSsBZsi1H1
         vsGNB/QeNcZHzPwXMdfmvaZRSxAX9/yJ63wJcg2ITc+2n3OCD09ZI6vb8zFScC6e0AFx
         h6yg==
X-Gm-Message-State: AOAM532VjfkPxKRAV4qBul3nuHMvbqoc21S3w5yM2A8IF+TpFfUMpPge
        +SMe/L1oUHq0oTnG9fVgs1d5vCAJiTy6lNkfZ2Y=
X-Google-Smtp-Source: ABdhPJx1C99QWWmTvABKmaNLuaLy7uZe+qh/2RVOv0hDklL3ZIzO/UOJc6LXQpcX9T4mj+/aQ+HlLA==
X-Received: by 2002:a05:6512:1056:: with SMTP id c22mr861737lfb.586.1631064968077;
        Tue, 07 Sep 2021 18:36:08 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id v1sm58775lja.134.2021.09.07.18.36.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 18:36:07 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id s12so794828ljg.0
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 18:36:06 -0700 (PDT)
X-Received: by 2002:a2e:b53a:: with SMTP id z26mr781467ljm.95.1631064966392;
 Tue, 07 Sep 2021 18:36:06 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
 <92c20b62-c4a7-8e63-4a94-76bdf6d9481e@kernel.org> <CAHk-=wiynwuneR4EbUNtd2_yNT_DR0VQhUF1QOZ352D-NOncjQ@mail.gmail.com>
 <a2c18c6b-ff13-a887-dd52-4f0aeeb25c27@kernel.org>
In-Reply-To: <a2c18c6b-ff13-a887-dd52-4f0aeeb25c27@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 7 Sep 2021 18:35:50 -0700
X-Gmail-Original-Message-ID: <CAHk-=whcFKGyJOgmwJtWwDCP7VFPydnTtsvjPL6ZP6d6gTyPDQ@mail.gmail.com>
Message-ID: <CAHk-=whcFKGyJOgmwJtWwDCP7VFPydnTtsvjPL6ZP6d6gTyPDQ@mail.gmail.com>
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

On Tue, Sep 7, 2021 at 5:15 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Ah, okay, that is an x86-only limitation so I missed it. I do not think
> there is any bug with that Kconfig logic but it is only used on x86.

Yeah. I think other architectures are basically just buggy, but nobody
has ever cared or noticed, because the hardware basically doesn't
exist.

People hopefully don't actually configure for the kernel theoretical
maximum outside of x86. Even there it's a bit ridiculous, but the
hardware with lots and lots of cores at least _has_ existed.

> Indeed. Grepping around the tree, I see that arc, arm64, ia64, powerpc,
> and sparc64 all support NR_CPUS up to 4096 (8192 for PPC) but none of
> them select CPUMASK_OFFSTACK

I think this one says it all:

   arch/arc/Kconfig: range 2 4096

yeah. ARC allows you to configure 4k CPU's.

I think a lot of them have just copied the x86 code (it was 4k long
ago), without actually understanding all the details.

That is indeed a strong argument for getting rid of the current
much-too-subtle CPUMASK_OFFSTACK situation.

But as the hyperv code shows, even on x86 the "we never allocate a
full cpumask on the stack" has gotten lost a bit since the days that
Rusty and others actually implemented this all.

           Linus
