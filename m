Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815292EE774
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 22:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbhAGVJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 16:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbhAGVJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 16:09:11 -0500
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61AB6C0612FA
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 13:08:31 -0800 (PST)
Received: by mail-ua1-x92d.google.com with SMTP id p2so2739092uac.3
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 13:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9fYan1yzqxVguL0ZQY0BTwdyUMx5dFzjZBmr/vD5tRY=;
        b=k7t5Q/9M+TUvwdmswWS/rvtjs9qDhmvTiyszvvNXDsiTTlK7iB6M75IDdY0nIKnm6o
         GYgVSYkz+jKHpbNAvuoI2PnlSbdVKN9N8tYY9oDVdPAJLz3Qh0r961/AZyx9ijfzjpgJ
         ukj0XTlvL+oBbgW9V7gFwDCroxhJAPHYplQxxdUck0GFKbevY5xd6LlUDYmLfrh2CZFG
         t9e7IoqPMQ1m2bAiehuDjT3IJJ/WVoT2VKCRUFvLh2ff4ikDY85hN1+fFyduNyKX2Lwq
         1IADMWi+19HunLHNAHcaQpdX6aEEOEuWryDSKQhxLwPtwfBTH2uENWi3N2YKSrHla3YG
         w4Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9fYan1yzqxVguL0ZQY0BTwdyUMx5dFzjZBmr/vD5tRY=;
        b=LC/heeGi0mVip14VsZCCjopiGyjkkLLiF8/B+3hQeloJpaORSKRtHmc8XxXegGxKfV
         w8GwwnJ1VHg2B/sJzfND8M5ANMlPf0WGgx3saY/Ln8/cmoQ30/7rcTSgrdm70UC/t5Rx
         V4x+I+h9Bre64BGqD+YaGmzBz8pP574fvvsFUqVThNfPGQ+w/FJshAVCjgkiXtHf+7Jz
         7o6abgsSc+xL0mrxA6aYOfuSFUnQCeIrlkn0+150Br2nwLw0SMuVe8StuW4rRln3U4qm
         m5epKwFKW3RxFBhoJ1J3Fi0ss79N79b08RflE6gS0NGeH5gXPOgVzLNbpGHjgLY/Xv9z
         Y0CQ==
X-Gm-Message-State: AOAM533DznClS5an11WbDhwBZK5nOXLEb7VR+UyKCqS1Q5fauBsbsFHh
        UlInKNoHK3kKwd+DyLUY/BQZamRNoUs0d53SNDmuMw==
X-Google-Smtp-Source: ABdhPJxHnJvsbDwyF4bx6K6BhV313BR8eONthkFk/er2XbRI7zrOtNCXhB8Pf0IMiO7/77tD+fvpJVhr9OCB4d8PTk0=
X-Received: by 2002:ab0:7386:: with SMTP id l6mr642880uap.141.1610053710484;
 Thu, 07 Jan 2021 13:08:30 -0800 (PST)
MIME-Version: 1.0
References: <20201118194838.753436396@linutronix.de> <20201118204007.169209557@linutronix.de>
 <20210106180132.41dc249d@gandalf.local.home> <CAHk-=wh2895wXEXYtb70CTgW+UR7jfh6VFhJB_bOrF0L7UKoEg@mail.gmail.com>
 <20210106174917.3f8ad0d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CA+FuTSevLSxZkNLdJPHqRRksxZmnPc1qFBYJeBx26WsA4A1M7A@mail.gmail.com>
 <CA+FuTScQ9afdnQ3E1mqdeyJ-sOq=2Dm9c1XDN8mnzbEig8iMXA@mail.gmail.com>
 <CAHk-=wh+KfbJ4Wrz4A+hFRRj7ZYWysz9L8s-BosC3bhV6vN-nQ@mail.gmail.com> <20210107155256.7af2505e@gandalf.local.home>
In-Reply-To: <20210107155256.7af2505e@gandalf.local.home>
From:   Willem de Bruijn <willemb@google.com>
Date:   Thu, 7 Jan 2021 16:07:54 -0500
Message-ID: <CA+FuTSdsTFHY5Yx8y5UHGYqsz=FGevjYn_Kzy-p3kwx-vUxdDw@mail.gmail.com>
Subject: Re: [BUG] from x86: Support kmap_local() forced debugging
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 7, 2021 at 3:53 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 7 Jan 2021 11:47:02 -0800
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> > On Wed, Jan 6, 2021 at 8:45 PM Willem de Bruijn <willemb@google.com> wrote:
> > >
> > > But there are three other kmap_atomic callers under net/ that do not
> > > loop at all, so assume non-compound pages. In esp_output_head,
> > > esp6_output_head and skb_seq_read. The first two directly use
> > > skb_page_frag_refill, which can allocate compound (but not
> > > __GFP_HIGHMEM) pages, and the third can be inserted with
> > > netfilter xt_string in the path of tcp transmit skbs, which can also
> > > have compound pages. I think that these could similarly access
> > > data beyond the end of the kmap_atomic mapped page. I'll take
> > > a closer look.
> >
> > Thanks.
> >
> > Note that I have flushed my random one-liner patch from my system, and
> > expect to get a proper fix through the normal networking pulls.
> >
> > And _if_ the networking people feel that my one-liner was the proper
> > fix, you can use it and add my sign-off if you want to, but it really
> > was more of a "this is the quick ugly fix for testing" rather than
> > anything else.

I do think it is the proper fix as is. If no one else has comments, I
can submit it through the net tree.

It won't address the other issues that became apparent only as a
result of this. I'm preparing separate patches for those.

> Please add:
>
>   Link: https://lore.kernel.org/linux-mm/20210106180132.41dc249d@gandalf.local.home/
>   Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
>
> And if you take Linus's patch, please add my:
>
>   Tested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
>
> and if you come up with another patch, please send it to me for testing.
>
> Thanks!

Will do, thanks.
