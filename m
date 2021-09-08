Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0502B403CCF
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 17:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349730AbhIHPuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 11:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235630AbhIHPuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 11:50:08 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF03C061575
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 08:49:00 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id h1so4275718ljl.9
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 08:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PcF296h2+jiTZRH7itaWnGkrpPXNXdTwX29k3fuQ+jc=;
        b=ZwCRqKII+z7vKEvFb10WpEzrknavJ+xY91cakvNMvB12ilS1ZXGEroVoZGRbTsMeHX
         r2zn5SfzXpbQBiUmBwz5flemzUgkqkyaVzmRA0zAl11PDMt+Eapr9rFmLWA3oZAESpPQ
         tpmQ6lADbmqWjIXc3iG+eXb+QhwWpsNLgETq0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PcF296h2+jiTZRH7itaWnGkrpPXNXdTwX29k3fuQ+jc=;
        b=adJFpdKrkl1qHWn36fCF+iiTjWZHqcPQdT4Hk/XX7chNW0cbrb3GzsNQBCzF0/rKGt
         IqkGJYv7LCU55j7bJrfM9gdvlH1jzoZ/PVq2WXNp+sXO14oAd6u1gAfzVWFP4frtFcsx
         F/TTRIhwLbxWDjYV4K8/IFr5+41S5GVFuO/VUDe03aUIrQaOxjV3OSsCpEcuOyXzkyoq
         u3iZf+QG3w/fyu/GOIGzV3rBr1uqviUzjyBoEaKmbBCU5kfY0AACwqejw0umduC2ayot
         B1dXauUMA2eswL+F6aQ21sfNb7JxOsQQ8q3tczdCTyE2OR5s/5/OzZXPJhiZpQng3X+2
         QuNw==
X-Gm-Message-State: AOAM531V2m8VdZV4B3AAXXRz9eYKq7K291Ip0qUGmhj8K0IOzRE+iFn5
        wMb7zZzAln6NlW6dLezIexgmYs4M9FPRupbJbZM=
X-Google-Smtp-Source: ABdhPJw8VP/xqij/qSTs/zU7B1iR5Yu+7AzN07yNMFMeeoa/ePjWWWL3VGTMU94y+6JE7CoPdoHm0Q==
X-Received: by 2002:a2e:b88a:: with SMTP id r10mr3341649ljp.362.1631116138651;
        Wed, 08 Sep 2021 08:48:58 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id c17sm220634lfb.257.2021.09.08.08.48.58
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 08:48:58 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id n2so5889251lfk.0
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 08:48:58 -0700 (PDT)
X-Received: by 2002:a05:6512:114c:: with SMTP id m12mr3186957lfg.150.1631116138014;
 Wed, 08 Sep 2021 08:48:58 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
 <53ce8db-3372-b5e2-cee7-c0ebe9c45a9@tarent.de> <CANn89iJzyPbR-fS8S_oAMSJzUGTHAfx49CXVc6ZSckUk91Opvg@mail.gmail.com>
In-Reply-To: <CANn89iJzyPbR-fS8S_oAMSJzUGTHAfx49CXVc6ZSckUk91Opvg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 8 Sep 2021 08:48:41 -0700
X-Gmail-Original-Message-ID: <CAHk-=whkOK2DTHMt1rQ7wCBCqW=itkihpQBcZ=T6vrciEE4ycA@mail.gmail.com>
Message-ID: <CAHk-=whkOK2DTHMt1rQ7wCBCqW=itkihpQBcZ=T6vrciEE4ycA@mail.gmail.com>
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
To:     Eric Dumazet <edumazet@google.com>
Cc:     Thorsten Glaser <t.glaser@tarent.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
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
        Nathan Chancellor <nathan@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 8, 2021 at 7:50 AM Eric Dumazet <edumazet@google.com> wrote:
>
> At least on my builds,  do_tcp_getsockopt() uses less than 512 bytes of stack.
>
> Probably because tcp_zerocopy_receive() is _not_ inlined, by pure luck
> I suppose.
>
> Perhaps we should use noinline_for_stack here.

I agree that that is likely a good idea, but I also suspect that the
stack growth may be related to other issues. So it being less than 512
bytes for you may be related to other random noise than inlining.

In the past I've seen at least two patterns

 (a) not merging stack slots at all

 (b) some odd "pattern allocator" problems, where I think gcc ended up
re-using previous stack slots if they were the right size, but failing
when previous allocations were fragmented

that (a) thing is what -fconserve-stack is all about, and we also used
to have (iirc) -fno-defer-pop to avoid having function call argument
stacks stick around.

And (b) is one of those "random allocation pattern" things, which
depends on the phase of the moon, where gcc ends up treating the stack
frame as a series of fixed-size allocations, but isn't very smart
about it. Even if some allocations got free'd, they might be
surrounded by oithers that didn't, and then gcc wouldn't re-use them
if there's a bigger allocation afterwards. And similarly, I don't
think gcc ever even joins together two free'd stack frame allocations.

I also wouldn't be surprised at all if some of our hardening flags
ended up causing the stack frame reuse to entirely fail. IOW, I could
easily see things like INIT_STACK_ALL_ZERO might cause the compiler to
initialize all the stack frame allocations "early", so that their
lifetimes all overlap.

So it could easily be about very subtle and random code generation
choices that just change the order of allocation. A spill in the wrong
place, things like that.

Or it could be about not-so-subtle big config option things.

          Linus
