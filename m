Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47249403D30
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 17:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352298AbhIHQBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 12:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349719AbhIHQBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 12:01:03 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66600C061575
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 08:59:55 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id e23so5833538lfj.9
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 08:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F4infFLVixS1zGDFn3Ppp1mthbrjmBNRT6/Rci2kJg8=;
        b=H8ZMch42HiybhAm4Ner+rjzqPv+vf/l5o8J/kw1HS5STE/87Uu67cqIKV7XOttIzH6
         Fr/yJ3v1JspZbfGvuL5igjanpDAyvA/Yy598WQlVH1jVhZa0SPwMaVtG0sJiHxnuShdx
         4vioibFKRKMO6AdS+qLyXRlpX18FbIq4PUiRk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F4infFLVixS1zGDFn3Ppp1mthbrjmBNRT6/Rci2kJg8=;
        b=VAxdSIr+bGR94qg10TYrT1INHBt1n5byGH2lSgQ2n40+leo2a4Ce+ETKXXysdeBusT
         BiydoAZLgJFC+UWtMbmi9br8Lbt9KsTWCz73RNB0Re6eYhtSIXrqDhR+nBWzuwU7J4Ak
         cqaYGnmtSr+OdejphMA9f1Aq6RrLAPMPLqMywi/wq91JulOrxItlfV+H/hgo2IYPBugl
         s5HAEYx2GXG9HUkIXWX8B8wiBaEryktT9oanNG1DkLiaPviCnj5ZEfMaeH1pDnC05Kgh
         maJYtLhObH/iGg1zlrpO3KIRY5MSTKY8FiLs78FCUvagzcAM/NqLh1TVONIateHlLEEO
         q3Ig==
X-Gm-Message-State: AOAM531O0y5PqVuKmA9BNLSTFSTJlDPvC3AE18N1ZJlDGIRwt1gdvrie
        Hu1/0KKSkbBj9AMMaU3nSu4wIAyPDSY1PFZH8KY=
X-Google-Smtp-Source: ABdhPJwzcDuYUwL/ChEF3kcd8IC1C1Txyq/Wq4HPYnG8k6RTmol5V8yhXeB2yhc9r3up+ALe+Si8mg==
X-Received: by 2002:a05:6512:3341:: with SMTP id y1mr3209102lfd.6.1631116793759;
        Wed, 08 Sep 2021 08:59:53 -0700 (PDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id u4sm226316lfo.209.2021.09.08.08.59.52
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 08:59:53 -0700 (PDT)
Received: by mail-lj1-f180.google.com with SMTP id h1so4328945ljl.9
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 08:59:52 -0700 (PDT)
X-Received: by 2002:a05:651c:158f:: with SMTP id h15mr3559594ljq.249.1631116792643;
 Wed, 08 Sep 2021 08:59:52 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com> <20210908100304.oknxj4v436sbg3nb@liuwe-devbox-debian-v2>
In-Reply-To: <20210908100304.oknxj4v436sbg3nb@liuwe-devbox-debian-v2>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 8 Sep 2021 08:59:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgMyCaFMybdQRJYJLbbbv5S2UHsU3oQ+CBRyYkvjmR=hA@mail.gmail.com>
Message-ID: <CAHk-=wgMyCaFMybdQRJYJLbbbv5S2UHsU3oQ+CBRyYkvjmR=hA@mail.gmail.com>
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
To:     Wei Liu <wei.liu@kernel.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 8, 2021 at 3:03 AM Wei Liu <wei.liu@kernel.org> wrote:
>
> Thanks for the heads-up. I found one instance of this bad practice in
> hv_apic.c. Presumably that's the one you were referring to.

Yeah, that must have been the one I saw.

> However calling into the allocator from that IPI path seems very heavy
> weight. I will discuss with fellow engineers on how to fix it properly.

In other places, the options have been fairly straightforward:

 (a) avoid the allocation entirely.

I think the main reason hyperv does it is because it wants to clear
the "current cpu" from the cpumask for the ALL_BUT_SELF case, and if
you can just instead keep track of that "all but self" bit separately
and pass it down the call chain, you may not need that allocation at
all.

 (b) use a static percpu allocation

The IPI code generally wants interrupts disabled anyway, or it
certainly can just do the required preemption disable to make sure
that it has exclusive access to a percpu allocation.

 (c) take advantage of any hypervisor limitations

If hyperv is limited to some smaller number of CPU's - google seems to
imply 240 - maybe you can keep such a smaller allocation on the stack,
but just verify that the incoming cpumask is less than whatever the
hyperv limit is.

That (c) is obviously the worst choice in some sense, but in some
cases limiting yourself to simplify things isn't wrong.

I suspect the percpu allocation model is the easiest one. It's what
other IPI code does. See for example

  arch/x86/kernel/apic/x2apic_cluster.c:
      __x2apic_send_IPI_mask()

and that percpu 'ipi_mask' thing.

That said, if you are already just iterating over the mask, doing (a)
may be trivial. No allocation at all is even better than a percpu one.

I'm sure there are other options. The above is just the obvious ones
that come to mind.

           Linus
