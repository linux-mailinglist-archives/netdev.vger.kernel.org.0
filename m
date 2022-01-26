Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47C449D2B0
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiAZTtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbiAZTtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:49:17 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0E0C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 11:49:16 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id m6so1910790ybc.9
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 11:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sdMVHRf2IrT9f8QWnms4/Mk2kr8xPAYAVug2mP2Oizo=;
        b=DLWrOFPw4saMO662YBG5ktqxBvQ5aidEm3AFaO08RlXS2xRgPBB5d6gADEA4um0s2Q
         IlDZVk0oR878ZBxxjLfkLJZmx8+kzV4uvcrZrlWfI/aplYNF6UHLZGKRmZpAnKcEwBkf
         CMzs9wrGSbckKzceJGUW1dRCXAJCp34kgJFpjmz+5T4jyO+RAY10lhWejLnkZd2ELj9t
         1yPgPWnWfwMd/v47zLA2/tKQ3rMZHs+8YND7obAFNEWUILUWe/uRj4svTarfsbZoOf/b
         9GhJ3avCQM4Q+BT2RfvEvXAxEQYavuPOK4OjhE2oio06Gf9GaY3phzNuPt4OMHLYKBwa
         QKkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sdMVHRf2IrT9f8QWnms4/Mk2kr8xPAYAVug2mP2Oizo=;
        b=eVxMvThSFlpfsF+chWAmvDpjWF8/Hj1s5N0g8e0Lfx3YMnOpt18annHA6QxGZulOmP
         wLULk6ORfYq6dbvnt76NDtFcpMq+v5ZTjLL+59N3NSoqW4VhnoDKu1faXIo7pJGq5fyV
         giUU6qKjNO2mvYabPZIMLPRwgF4U2oY+fL2AW0FGCHWznYk1Lts1WxN/QD/OGC0X2BxN
         GMs92a7Xre6KBatMYI3MQbEAPBFtUshV5QuVsgsmTu2y5kV4KvfVxFeu8uDBBECR9ddG
         lnGPJr1PCj0L+MyRuewzkKH9jCibTKLvlaZIJMoVyoApOawvm6VQyaG3EWPl4i7u762l
         pyPQ==
X-Gm-Message-State: AOAM531/iE7boj5Bvf+8LwzM9Fc5LwrPgQfn9G7WImfoWa5HINEiQLNj
        +69Hr5h8cdabL6QAJVw4toXIx2qjNHagp92iDWM=
X-Google-Smtp-Source: ABdhPJxHEwE2hk4TlWzyApFiFvUU0DKPmsGvk/VjCpUl9f9yt4ZxulrHsslzegcst15ZbS4EYf7nJRqz1tEAkMgmGSQ=
X-Received: by 2002:a25:3d81:: with SMTP id k123mr711827yba.740.1643226555755;
 Wed, 26 Jan 2022 11:49:15 -0800 (PST)
MIME-Version: 1.0
References: <20211224164926.80733-1-xiangxia.m.yue@gmail.com>
 <20211224164926.80733-3-xiangxia.m.yue@gmail.com> <CAM_iQpUhNmmxyPXjyRBKzjVkreu0WXvoyOTdxT0pdjUBsFkx6A@mail.gmail.com>
 <20211224144441.534559e8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211224144441.534559e8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 26 Jan 2022 11:49:05 -0800
Message-ID: <CAM_iQpVF_sHRFzyKEHAbyi7RJH-4cLGvisFEKRjvMXvEMAHEWw@mail.gmail.com>
Subject: Re: [net-next v7 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
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

On Fri, Dec 24, 2021 at 2:44 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 24 Dec 2021 11:28:45 -0800 Cong Wang wrote:
> > On Fri, Dec 24, 2021 at 8:49 AM <xiangxia.m.yue@gmail.com> wrote:
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > This patch allows user to select queue_mapping, range
> > > from A to B. And user can use skbhash, cgroup classid
> > > and cpuid to select Tx queues. Then we can load balance
> > > packets from A to B queue. The range is an unsigned 16bit
> > > value in decimal format.
> > >
> > > $ tc filter ... action skbedit queue_mapping skbhash A B
> > >
> > > "skbedit queue_mapping QUEUE_MAPPING" (from "man 8 tc-skbedit")
> > > is enhanced with flags:
> > > * SKBEDIT_F_TXQ_SKBHASH
> > > * SKBEDIT_F_TXQ_CLASSID
> > > * SKBEDIT_F_TXQ_CPUID
> >
> > NACK.
> >
> > These values can either obtained from user-space, or is nonsense
> > at all.
>
> Can you elaborate? What values can be obtained from user space?
> What is nonsense?

Of course.

1. SKBHASH is nonsense, because from a user's point of view, it really
has no meaning at all, skb hash itself is not visible to user and setting
an invisible value to as an skb queue mapping is pretty much like setting
a random value here.

2. CLASSID is obviously easy to obtain from user-space, as it is passed
from user-space.

3. CPUID is nonsense, because a process can be migrated easily from
one CPU to another. Putting OOO packets side, users can't figure out
which CPU the process is running *in general*. (Of course you can bind
CPU but clearly you can't bind every process)

>
> > Sorry, we don't accept enforcing such bad policies in kernel. Please
> > drop this patch.
>
> Again, unclear what your objection is. There's plenty similar
> functionality in TC. Please be more specific.

What exact TC functionality are you talking about? Please be specific.

If you mean Qdisc's, it is virtually just impossible to have a programmable
Qdisc, even my eBPF Qdisc only provides very limited programmablities.

If you mean TC filter or action, we already have eBPF filter and eBPF
action.

Thanks.
