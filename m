Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D227441BECD
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 07:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244295AbhI2FmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 01:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244263AbhI2FmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 01:42:01 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919D8C06161C;
        Tue, 28 Sep 2021 22:40:20 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id w19so2812948ybs.3;
        Tue, 28 Sep 2021 22:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3wns5iqUmSbJ3GD+j4tRGlb5E0jFYqf2nMkL/XJB/GA=;
        b=aMrbi5MvdvCDitx0MgGxfoRPUjjCYZc5vnh9Kym0z8T6XXJJP01Kbpst81ce1nQAWE
         5dOAwR+8BRJ3e6nL0Eg2jlKa7KeWCPKa0MIVAE+tvCuIKsJc7Ol9x1DoCMXJOpeZN4p7
         hpVraZpNR9CUl8qkTMHJhCnYn+vhLSYOzmJGrky6eSb8ewTFQHS8WSppAdEb/iEwzDYP
         QRZLrmw0Megt5c1pf8LS9aOCXucxmaJGLq4JjxktKs/dichhtOO1mZ4FKtUy7AEA0BKE
         z4FmHD3A7wj/kxxCcuc4MgV3BapKoTU7BzXoU1QN3w/lRendbcyxeeYS9GB+EgUJic25
         9N+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3wns5iqUmSbJ3GD+j4tRGlb5E0jFYqf2nMkL/XJB/GA=;
        b=ebQ5DSwNlREivxYpmXq2W2IJKMnxy+uF+rqe7jjwTAiIpO8emsE3xSO0A005Fi18/U
         i9LeFdqnfNp9S8VVzz+Gv+27bSVHNo8ZzmvpzRxnZy8NaXFtnA7ULTZUnmXy9hS68NeN
         lysj+vo4vEc/zAFZfNpk8X1qW+KM3B7I3PBqKnukzQ7wK97MhXErW0d6WCvBF6fxbUNg
         Q/UUnL204AU+ajHKyAtGv0N07K3eRWIvW0Y7Akwn3abOmOBwY0rvIYDG9WCMUrsBzIe6
         D1+lyS+bmrzPv513l76uOfVkizk/GqUYV/eNJk9yjwBb8gKrKZE35akA3XFi/Lo70PSN
         pWDQ==
X-Gm-Message-State: AOAM5337Ir4WHqOAB+yOoIpNl7CuIJmMqZKPysf7XMV1en/gNNVZVN+d
        7tyoIYNwikkRAE2cXxUSRO9IkAnYFUP97nbmzmQOw7p/
X-Google-Smtp-Source: ABdhPJyhla2VXgZ9jEKO8rCEz8m0vtCbtZBTW0qwkQLuC+20HfcQEaB4ZLt1H9p+TBuM/lvHzC1ULqr6C0Hin7WODxA=
X-Received: by 2002:a5b:507:: with SMTP id o7mr10428266ybp.491.1632894019880;
 Tue, 28 Sep 2021 22:40:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210913231108.19762-1-xiyou.wangcong@gmail.com>
 <CAADnVQJFbCmzoFM8GGHyLWULSmX75=67Tu0EnTOOoVfH4gE+HA@mail.gmail.com>
 <CAM_iQpX2prCpPDmO1U0A_wyJi_LS4wmd9MQiFKiqQT8NfGNNnw@mail.gmail.com>
 <CAADnVQJJHLuaymMEdDowharvyJr+6ta2Tg9XAR3aM+4=ysu+bg@mail.gmail.com>
 <CAM_iQpUCtXRWhMqSaoymZ6OqOywb-k4R1_mLYsLCTm7ABJ5k_A@mail.gmail.com> <CAADnVQJcUspoBzk9Tt3Rx_OH7-MB+m1xw+vq2k2SozYZMmpurg@mail.gmail.com>
In-Reply-To: <CAADnVQJcUspoBzk9Tt3Rx_OH7-MB+m1xw+vq2k2SozYZMmpurg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 28 Sep 2021 22:40:08 -0700
Message-ID: <CAM_iQpVaVvaEn2ORfyZQ-FN56pCdE4YPa0r2E+VgyZzvEP31cQ@mail.gmail.com>
Subject: Re: [RFC Patch net-next v2] net_sched: introduce eBPF based Qdisc
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 6:49 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Sep 21, 2021 at 9:13 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > "This *incomplete* patch introduces a programmable Qdisc with
> > eBPF.  The goal is to make this Qdisc as programmable as possible,
> > that is, to replace as many existing Qdisc's as we can, no matter
> > in tree or out of tree. And we want to make programmer's and researcher's
> > life as easy as possible, so that they don't have to write a complete
> > Qdisc kernel module just to experiment some queuing theory."
>
> The inspiration was clear and obvious.
> Folks in the thread had the same idea long before your patches came out.
> But it doesn't matter who came up with an idea to implement qdisc in bpf first.
> Everyone in the thread agreed that such a feature would be great to have.
> The point people explicitly highlighted is that qdisc is not only about skbs.
> The queuing concepts (fq, codel, etc) are useful in xdp and non networking
> contexts too.
> That's why approaching the goal with more generic ambitions was requested.

This goal has nothing to do with my goal, I am pretty sure we have
a lot of queues in networking, here I am only interested in Qdisc for
sure. If you need queues in any other place, it is your job, not mine.

More importantly, what's the conflict between these two goals here?
I see none, from your response, it implies we could only have one.

>
> > If you compare it with V1, V2 explains the use case in more details,
> > which is to target Qdisc writers, not any other. Therefore, the argument
> > of making it out of Qdisc is non-sense, anything outside of Qdisc is
> > not even my target. Of course you can do anything in XDP, but it has
> > absolutely nothing with my goal here: Qdisc.
>
> Applying queuing discipline to non-skb context may be not your target
> but it's a reasonable and practical request to have. The kernel is not

Your request has nothing to do with TC or Qdisc, nor it has any
conflict at all.

> about solving one person's itch. The kernel has to be optimized for
> all use cases.

What are you talking about? Are you saying we can't add any new
Qdisc simply because you want to a queue in XDP and it is more
generic??

>
> >
> > I also addressed the skb map concern:
> >
> > " 2b) Kernel would lose the visibility of the "queues", as maps are only
> >    shared between eBPF programs and user-space. These queues still have to
> >    interact with the kernel, for example, kernel wants to reset all queues
> >    when we reset the network interface, kernel wants to adjust number of
> >    queues if they are mapped to hardware queues."
> >
> > More than writing, I even tried to write a skb map by myself,
>
> Cool and it sounds that you've failed to do so?

Sure, the above precisely explains why it fails to fit in Qdisc context.
Thanks for repeating it.

> At the same time Toke mentioned that he has a prototype of suck skb map.
> What addition data can open your mind that skb/packet map is more
> universal building block for queuing discipline in different layers?

You can add queue at any place you want, what's your problem of
repeating it? What can open your mind to just look at Qdisc?

Thanks
