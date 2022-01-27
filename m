Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8517249D759
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 02:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbiA0BOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 20:14:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiA0BOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 20:14:16 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BDAC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 17:14:16 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id m4so2210823ejb.9
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 17:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VjG+amPjglu3CCuKLkMwrZ41qAxOMEdYO/NYF8KkI0U=;
        b=JprZJEbYJGpzfkxLeRG3ie9iuLzlBottAL/UPPauXACgFbDB7UWTPS+/1OuyBiUbtx
         jTNAlLohpTDNvK0bxCpZcDJVsx5eMKSlEOU9Ba2jlyhLR4/TtQZ69PWJ+zVZJg0c+gNS
         MZzfyiD5bOfVRKpLI8t+VwqdGFr6qIvhOfQFd7rrt/IA/yQN36X1x4IUD1TGm65li45b
         EBEBKgMHGAtO7rz59ckMCtKQdUPuyI4qkWkDpsj9E8N0EwINW24GQzJgVjtRc97ZtpIO
         Q9uq4srXm6rtpYyKFxNO/8/BnC7iTW8GJXBSvd8pJlNlXdayONzuQaP46Ti/Up5Gzuoy
         JTww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VjG+amPjglu3CCuKLkMwrZ41qAxOMEdYO/NYF8KkI0U=;
        b=626lHPW2DA0OcyovPAZ0oMc2qET02C6upL2lVbqtgvuho7Dhxln2kzi169HX9i9Clh
         0WymGTI/Eq77OyfYbHPnJpEHcLKuq4aNx8k68NM1d0eyEHxsbqgtNWw32Oa40fmimTkH
         2dImdxND8l7925XDoqIei7Z0kKKx0KMAgRawu5g7q5QD+crDG4EfKLVJTevT0Y9m4D1i
         BL1PMaX3u3CwrV3t3yDW/ezpw9Cm6nYuAQrLy2EycGVhxjMdCl4lMz8Po0/IyVO+QGO3
         hOf7Qsu1KHGrY+DO9ZOdo7BhfBGHkW1akrasKNlWrBjxP3jlsbc6IFdpoLLr3Sl4ZrUc
         RAbw==
X-Gm-Message-State: AOAM533sO6AjE3veIwQY+x1aTJcmmY4R3eqyN54TvFfmCh6jp2vlcLJQ
        hoIGNMcs+NVB7AhsrP8XrLw5V6/zzbupoCmRrbA=
X-Google-Smtp-Source: ABdhPJwlwem5RDI4HzZBkFHdzuCoAXqxDW0qKisqDXwGKFwN4M7dErW2+bCyecPXc6LccpAf7z0zuA06ayl+zF74bFQ=
X-Received: by 2002:a17:907:948a:: with SMTP id dm10mr1087798ejc.61.1643246054806;
 Wed, 26 Jan 2022 17:14:14 -0800 (PST)
MIME-Version: 1.0
References: <20211224164926.80733-1-xiangxia.m.yue@gmail.com>
 <20211224164926.80733-3-xiangxia.m.yue@gmail.com> <CAM_iQpUhNmmxyPXjyRBKzjVkreu0WXvoyOTdxT0pdjUBsFkx6A@mail.gmail.com>
 <20211224144441.534559e8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net> <CAM_iQpVF_sHRFzyKEHAbyi7RJH-4cLGvisFEKRjvMXvEMAHEWw@mail.gmail.com>
In-Reply-To: <CAM_iQpVF_sHRFzyKEHAbyi7RJH-4cLGvisFEKRjvMXvEMAHEWw@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 27 Jan 2022 09:13:38 +0800
Message-ID: <CAMDZJNUsYjQYM5LpoDm1P60-n5+y_dDi7CuRw8PYZrAw3aGdxA@mail.gmail.com>
Subject: Re: [net-next v7 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 3:49 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Fri, Dec 24, 2021 at 2:44 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Fri, 24 Dec 2021 11:28:45 -0800 Cong Wang wrote:
> > > On Fri, Dec 24, 2021 at 8:49 AM <xiangxia.m.yue@gmail.com> wrote:
> > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > >
> > > > This patch allows user to select queue_mapping, range
> > > > from A to B. And user can use skbhash, cgroup classid
> > > > and cpuid to select Tx queues. Then we can load balance
> > > > packets from A to B queue. The range is an unsigned 16bit
> > > > value in decimal format.
> > > >
> > > > $ tc filter ... action skbedit queue_mapping skbhash A B
> > > >
> > > > "skbedit queue_mapping QUEUE_MAPPING" (from "man 8 tc-skbedit")
> > > > is enhanced with flags:
> > > > * SKBEDIT_F_TXQ_SKBHASH
> > > > * SKBEDIT_F_TXQ_CLASSID
> > > > * SKBEDIT_F_TXQ_CPUID
> > >
> > > NACK.
> > >
> > > These values can either obtained from user-space, or is nonsense
> > > at all.
> >
> > Can you elaborate? What values can be obtained from user space?
> > What is nonsense?
>
> Of course.
>
> 1. SKBHASH is nonsense, because from a user's point of view, it really
> has no meaning at all, skb hash itself is not visible to user and setting
> an invisible value to as an skb queue mapping is pretty much like setting
> a random value here.
Yes, use the skb hash as a random value, so different flows from same
pod can be balanced to different tx queues.
we can't pass a userspace value to do the balance, maybe we only match
the src ip of k8s pod.
> 2. CLASSID is obviously easy to obtain from user-space, as it is passed
> from user-space.
How about the case, multi pods share the same tx queue range, we use
the CLASSID to do balance, not as match filter.
> 3. CPUID is nonsense, because a process can be migrated easily from
> one CPU to another. Putting OOO packets side, users can't figure out
> which CPU the process is running *in general*. (Of course you can bind
> CPU but clearly you can't bind every process)
this is used for k8s pod, not for every applications on host. when the
pod share the tx queues range, so them can use
the tx queue according which cpu used.
> >
> > > Sorry, we don't accept enforcing such bad policies in kernel. Please
> > > drop this patch.
> >
> > Again, unclear what your objection is. There's plenty similar
> > functionality in TC. Please be more specific.
>
> What exact TC functionality are you talking about? Please be specific.
> If you mean Qdisc's, it is virtually just impossible to have a programmable
> Qdisc, even my eBPF Qdisc only provides very limited programmablities.
>
> If you mean TC filter or action, we already have eBPF filter and eBPF
> action.
>
> Thanks.



-- 
Best regards, Tonghao
