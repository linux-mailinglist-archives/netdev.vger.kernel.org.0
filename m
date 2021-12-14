Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96C8473A82
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 02:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbhLNB5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 20:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244756AbhLNB5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 20:57:01 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B586CC061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 17:57:00 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id v1so58490029edx.2
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 17:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q/TXU09QroQCETt/2IDIbRR+B+YKBF9UYaU8z5fJcFs=;
        b=PuLhJ+4weZTqPfV2yHBhqycFChu1CiRbp1Dul35vVucxBbEuLaOIZWO9ietot/kmjA
         Np+gD4tE5kmlRx/lEmUHv0kJTCG3olMWiKWNCGRyRD5Q5/br8a6xaLm9Gux09RK21RBR
         Mr4BxgCjp60cvdsJg8zO7TKI6FEf/S0lhS1wHY4AO8X2Tl59HFIWNiNEb0IpGh2z2YJ5
         oxVmN1IFifcHEBYt/Z2vMgAHqkQz9Ynk5BZzKjknFiNRKZOsvWrdEIee7cG4qosgo3st
         +ePUaiwfJqlaA55jKTm/9ZknGDgYLe/11FKkmUM869MX7QvxCyXBSKfJMNy0jWrs8P+5
         7Q2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q/TXU09QroQCETt/2IDIbRR+B+YKBF9UYaU8z5fJcFs=;
        b=2pf1X3W2W5v0aEaRoyXjYsJuQsJ3XA2f9cOTX6vlOVVWCrVhxEpWNbyh6EyS7Tc6D4
         cVwJDIMIxokB61+AVn3kjXviUc9bD50cHHN972N8aLT7HOHtJWMflUrba3StxSHNr0Xy
         cbbSH50yJZTQiLi8wnNt0yICWtq/TgURt9ektB5hhPUjIdDaG4tshykFP//CYoI+H0BD
         Y39Nyxp1vHSUFZ/IobZ5m/iEdOL2meA7E9XuyWOIOICnW/o8ps9WDyLgXYJLQR5ZA0Ew
         DY4c+CNe75YONrVpywVohcbG7t31wDm622T0W5B7KGDnFbrdpLIfUcywETSz4PHg5xCK
         sY2w==
X-Gm-Message-State: AOAM532EubAlIz5dIcusQau5epcV11V916uiSmyibS9q8q9T3iGY3c09
        ghkWdcIXpiXghsVq93CtJ2i23Ba/I2tvR1JMsb8=
X-Google-Smtp-Source: ABdhPJyD34dGzYy7oBHIKuoPlWps22jzskBHInwSnFEcUyEskZQCdeS8B+V8mYj8oAPcMpD/a8wNn8NwFveq6DEC9N0=
X-Received: by 2002:a05:6402:2152:: with SMTP id bq18mr3501359edb.105.1639447019307;
 Mon, 13 Dec 2021 17:56:59 -0800 (PST)
MIME-Version: 1.0
References: <20211210023626.20905-1-xiangxia.m.yue@gmail.com>
 <20211210023626.20905-2-xiangxia.m.yue@gmail.com> <CAM_iQpW=tWKkrFpZR9tqNYRNA82SaHUFvy5OFpPv0AKRgzS4VQ@mail.gmail.com>
In-Reply-To: <CAM_iQpW=tWKkrFpZR9tqNYRNA82SaHUFvy5OFpPv0AKRgzS4VQ@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 14 Dec 2021 09:56:23 +0800
Message-ID: <CAMDZJNXOn_mhmGJ4QsLY_aJEEQ8a1DEMnB8smpq6rZiW+HQfBw@mail.gmail.com>
Subject: Re: [net-next v3 1/2] net: sched: use queue_mapping to pick tx queue
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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

On Tue, Dec 14, 2021 at 6:58 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Thu, Dec 9, 2021 at 6:36 PM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > This patch fix issue:
> > * If we install tc filters with act_skbedit in clsact hook.
> >   It doesn't work, because netdev_core_pick_tx() overwrites
> >   queue_mapping.
> >
> >   $ tc filter ... action skbedit queue_mapping 1
>
> Interesting, but bpf offers a helper (bpf_set_hash()) to overwrite
> skb->hash which could _indirectly_ be used to change queue_mapping.
> Does it not work?
No
The root cause is that queue_mapping is overwritten by netdev_core_pick_tx.
Tx queues are picked by xps, ndo_select_queue of netdev driver, or skb hash
in netdev_core_pick_tx(). We can't only change the skb-hash. BTW, this patch
fix the issue, more importantly, this is useful (more details, see my
commit message):
* We can use FQ + EDT to implement efficient policies. Tx queues
  are picked by xps, ndo_select_queue of netdev driver, or skb hash
  in netdev_core_pick_tx(). In fact, the netdev driver, and skb
  hash are _not_ under control. xps uses the CPUs map to select Tx
  queues, but we can't figure out which task_struct of pod/containter
  running on this cpu in most case. We can use clsact filters to classify
  one pod/container traffic to one Tx queue. Why ?

  In containter networking environment, there are two kinds of pod/
  containter/net-namespace. One kind (e.g. P1, P2), the high throughput
  is key in these applications. But avoid running out of network resource,
  the outbound traffic of these pods is limited, using or sharing one
  dedicated Tx queues assigned HTB/TBF/FQ Qdisc. Other kind of pods
  (e.g. Pn), the low latency of data access is key. And the traffic is not
  limited. Pods use or share other dedicated Tx queues assigned FIFO Qdisc.
  This choice provides two benefits. First, contention on the HTB/FQ Qdisc
  lock is significantly reduced since fewer CPUs contend for the same queue.
  More importantly, Qdisc contention can be eliminated completely if each
  CPU has its own FIFO Qdisc for the second kind of pods.

  There must be a mechanism in place to support classifying traffic based on
  pods/container to different Tx queues. Note that clsact is outside of Qdisc
  while Qdisc can run a classifier to select a sub-queue under the lock.

  In general recording the decision in the skb seems a little heavy handed.
  This patch introduces a per-CPU variable, suggested by Eric.

>
> BTW, for this skbedit action, I guess it is probably because skbedit was
> introduced much earlier than clsact.
Yes
> Thanks.



-- 
Best regards, Tonghao
