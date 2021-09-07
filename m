Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCBF4031A5
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 01:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245758AbhIGX4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 19:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbhIGX4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 19:56:24 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8155C061575
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 16:55:17 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id g14so415298ljk.5
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 16:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FECPoa1g9+9dsqYv+iSJV+4ByXKkIUfIRQm65q5XJsw=;
        b=Ao7WGPwitXn5c2MO++qjMMxGjpAW4tTnL7npoHAF64WOVVCHhaM4k6teVfuN4ScyVZ
         DPFDpWA0mMTLjTVQ5fC0lNRLA0OsawTGUn8vrhyPxXJ4s8mfA40FAyw4QDmZSav7D8UH
         kba8D7ntoNzi/CZ/5UkXctqbluhNzpNIYeTS8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FECPoa1g9+9dsqYv+iSJV+4ByXKkIUfIRQm65q5XJsw=;
        b=CPUVEjCiL+3jx/N/WWcJ13n8yL1jRLVI543RUGTvbrB1+gKgoEx6d6vpiY5VrfJ0rQ
         OdCwESDjqQf6iyB3n4KsxV4ZyADe5rJA6gZXXdKd4WcH/mavkvZsu+O9/LdACwpbqCf3
         YijXrHs+xwNg9/rphLcIt0muxveT9LGbfmJdrB1W24/eZG4RFjD4ZyHWR0eZKYaRACMj
         ToGBcS5S90cC+iK51ytxmta3yDmj6iPKRnkYzyzO/cFdOa26nwymJs3VtvVb7aEakuL/
         D5M6M03qkyQcL34FfVpg2ddk2WZlrie527T6lWwqAgtwM71TlnIE4+ewGGC19Rwvr5X4
         YgHA==
X-Gm-Message-State: AOAM530zXmuMqast4eTLmiWTfZLeoVIYNJKy2MuTpig4OpV9VCzz7YXO
        M2SXpofp5BNehmSHkeuijYgConH04FOR2FgY8vI=
X-Google-Smtp-Source: ABdhPJzucCxw/iVetC+H+wcqnbMNHy7wRlRY4DwHbv3bNWpzCscuN/6WcCeTbWLsZw+QDCqgBnj9kg==
X-Received: by 2002:a2e:a4d1:: with SMTP id p17mr588705ljm.82.1631058915607;
        Tue, 07 Sep 2021 16:55:15 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id v10sm33751lfo.216.2021.09.07.16.55.15
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 16:55:15 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id t19so641528lfe.13
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 16:55:15 -0700 (PDT)
X-Received: by 2002:a05:6512:2611:: with SMTP id bt17mr662435lfb.141.1631058590780;
 Tue, 07 Sep 2021 16:49:50 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com> <92c20b62-c4a7-8e63-4a94-76bdf6d9481e@kernel.org>
In-Reply-To: <92c20b62-c4a7-8e63-4a94-76bdf6d9481e@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 7 Sep 2021 16:49:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiynwuneR4EbUNtd2_yNT_DR0VQhUF1QOZ352D-NOncjQ@mail.gmail.com>
Message-ID: <CAHk-=wiynwuneR4EbUNtd2_yNT_DR0VQhUF1QOZ352D-NOncjQ@mail.gmail.com>
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

On Tue, Sep 7, 2021 at 4:35 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Won't your example only fix the issue with CONFIG_CPUMASK_OFFSTACK=y

Yes, but..

> or am I misreading the gigantic comment in include/linux/cpumask.h?

you're not misreading the comment, but you are missing this important fact:

  config NR_CPUS_RANGE_END
        int
        depends on X86_64
        default 8192 if  SMP && CPUMASK_OFFSTACK
        default  512 if  SMP && !CPUMASK_OFFSTACK
        default    1 if !SMP

so basically you can't choose more than 512 CPU's unless
CPUMASK_OFFSTACK is set.

Of course, we may have some bug in the Kconfig elsewhere, and I didn't
check other architectures. So maybe there's some way to work around
it.

But basically the rule is that CPUMASK_OFFSTACK and NR_CPUS are linked.

That linkage is admittedly a bit hidden and much too subtle. I think
the only real reason why it's done that way is because people wanted
to do test builds with CPUMASK_OFFSTACK even without having to have
some ludicrous number of NR_CPUS.

You'll notice that the question "CPUMASK_OFFSTACK" is only enabled if
DEBUG_PER_CPU_MAPS is true.

That whole "for debugging" reason made more sense a decade ago when
this was all new and fancy.

It might make more sense to do that very explicitly, and make
CPUMASK_OFFSTACK be just something like

  config NR_CPUS_RANGE_END
        def_bool NR_CPUS <= 512

and get rid of the subtlety and choice in the matter.

             Linus
