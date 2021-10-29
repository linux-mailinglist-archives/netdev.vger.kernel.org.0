Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E10843F3AE
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 02:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhJ2AHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 20:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbhJ2AHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 20:07:19 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3B9C061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 17:04:51 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z20so32004069edc.13
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 17:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oxvvthHisq5dqwJ0+yyDs6IpU7vxN4BlvH6tMRe3vx4=;
        b=ZdkC77Ay136SOV1x7RdADQF0GxlyFiAYZWLdl12cc2sE9lD5J7pmzT7I9T3Z1svCKa
         Kq+F/RFghQt0KjVnPtczw8KGUsZ7bRgDVlg3x9rNziIZ9vs5LiCBGVe7KV52iW6SH3Nb
         oikxDe6dVy2oFjNeRf5Is3kCCGNKRhQ/6p8QeLRvE/g+wwOMl5a9fy6NpZw4I8BYYQ1O
         VFwQultaxkkcXWRBZw0FR5JQvPDupqf4zApYZMEgG2TKVFcTtV2e5SRmWjs1exKOBTnB
         DPg1ZeW8KXTUOygzu/P7Qf4RunvvEeclbMdSb3IUVAxW/qRGtGPqaCp35oOMoqGav7sp
         3sqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oxvvthHisq5dqwJ0+yyDs6IpU7vxN4BlvH6tMRe3vx4=;
        b=BuO9DCQDk5O0XjCcUP/FPSgQGlhiQy9JhXpgA8yAx9ekJGl53f/8CkL9HpHwpIZNm7
         o7jVbk9wjJnFeCEo4SPzj1FldIIVEryNXGTcQTyzM7WIQdOqNGufQQIfOdMl8AYz1DS8
         xq5oS1NS6zcW35k8oMV7aBzal2DwvlHKxzk4BVB2bLAJcvMfnMOBfd14i2Ov2W6bMsHG
         LEcTKiFUfsElc1eUETPOIUIoKUis9FsBPpXRvaa8dRnHH/sC/HV9JpGwsIDm7G/Av2XE
         Il77abMY/mcmVsw6/6TULkmaTst3qvasg4MC86QeqeZCXRqTgYhoW+Jp9SHYnn9ayNRM
         3QzQ==
X-Gm-Message-State: AOAM530RD1ldUR7/NpUgHT0zN2/bBTsNkuw8XnNwRVwugabf5rBTBzPN
        wSa+1PWw67yfpur3dqAdv1UMGH56PLNeGa8H9oQ=
X-Google-Smtp-Source: ABdhPJzCZNlGTZG9I2MGhNgotEoIaIbZPC/kimw5eghAvPGKG+6JwnK9RZGVXGLNLr3sWbUFtiIgmRIAkNsxRyqmsn8=
X-Received: by 2002:a17:907:96a3:: with SMTP id hd35mr9182792ejc.222.1635465889994;
 Thu, 28 Oct 2021 17:04:49 -0700 (PDT)
MIME-Version: 1.0
References: <20211028135644.2258-1-xiangxia.m.yue@gmail.com> <3b8386fe-b3ff-1ed1-a02b-713b71c8a8d8@iogearbox.net>
In-Reply-To: <3b8386fe-b3ff-1ed1-a02b-713b71c8a8d8@iogearbox.net>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Fri, 29 Oct 2021 08:04:13 +0800
Message-ID: <CAMDZJNWhZjMe1MSfZYuOWcstzkhjTutxizdzq6S1M9=M_x_VMA@mail.gmail.com>
Subject: Re: [PATCH] net: sched: check tc_skip_classify as far as possible
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 10:28 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 10/28/21 3:56 PM, xiangxia.m.yue@gmail.com wrote:
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > We look up and then check tc_skip_classify flag in net
> > sched layer, even though skb don't want to be classified.
> > That case may consume a lot of cpu cycles.
> >
> > Install the rules as below:
> > $ for id in $(seq 1 100); do
> > $     tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
> > $ done
>
> Do you actually have such a case in practice or is this just hypothetical?
Hi Daniel, I did some research about this for k8s in production. There
are not so many tc prio(~5 different prio).
butg in this test, I use the 100 prio.

I reviewed the code, for the tx path, I think we check the
tc_skip_classify too later. In the rx path, we check it
in __netif_receive_skb_core.

> Asking as this feels rather broken to begin with.
> > netperf:
> > $ taskset -c 1 netperf -t TCP_RR -H ip -- -r 32,32
> > $ taskset -c 1 netperf -t TCP_STREAM -H ip -- -m 32
> >
> > Without this patch:
> > 10662.33 tps
> > 108.95 Mbit/s
> >
> > With this patch:
> > 12434.48 tps
> > 145.89 Mbit/s
> >
> > For TCP_RR, there are 16.6% improvement, TCP_STREAM 33.9%.
> >
> > Cc: Willem de Bruijn <willemb@google.com>
> > Cc: Cong Wang <xiyou.wangcong@gmail.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > ---
> >   net/core/dev.c      | 3 ++-
> >   net/sched/act_api.c | 3 ---
> >   2 files changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index eb61a8821b3a..856ac1fb75b4 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -4155,7 +4155,8 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> >   #ifdef CONFIG_NET_CLS_ACT
> >       skb->tc_at_ingress = 0;
> >   # ifdef CONFIG_NET_EGRESS
> > -     if (static_branch_unlikely(&egress_needed_key)) {
> > +     if (static_branch_unlikely(&egress_needed_key) &&
> > +         !skb_skip_tc_classify(skb)) {
> >               skb = sch_handle_egress(skb, &rc, dev);
> >               if (!skb)
> >                       goto out;
> > diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> > index 7dd3a2dc5fa4..bd66f27178be 100644
> > --- a/net/sched/act_api.c
> > +++ b/net/sched/act_api.c
> > @@ -722,9 +722,6 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
> >       int i;
> >       int ret = TC_ACT_OK;
> >
> > -     if (skb_skip_tc_classify(skb))
> > -             return TC_ACT_OK;
> > -
>
> I think this might imply a change in behavior which could have the potential
> to break setups in the wild.
we may not change this code, i will send v2, if not comment.
> >   restart_act_graph:
> >       for (i = 0; i < nr_actions; i++) {
> >               const struct tc_action *a = actions[i];
> >
>


-- 
Best regards, Tonghao
