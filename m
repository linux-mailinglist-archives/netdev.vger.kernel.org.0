Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD06331B77
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 01:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbhCIALA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 19:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbhCIAKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 19:10:54 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E287C06174A;
        Mon,  8 Mar 2021 16:10:54 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id o11so12038327iob.1;
        Mon, 08 Mar 2021 16:10:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=KtmbRd40eBGqKoolEIw082Sh0x88iIK3TLOTUIpOVGU=;
        b=GsTbc5yiogLC9wFVksY/jk7PHNQlI3hoHRhwUh1VKy4TR3MhuaRuAYyixCBR/K0gPd
         CaBV503wvdtS04771e7D4k0WAHcp/84ruyh6AcmomB/T2dkJA2WBfqtN7C1XBQUGaavl
         DMLI8uzntVIvouKfajnA5EvZlLx5syjPCJXGkIzn3abDALio3IzpvmGv5Kds3WOFobSk
         y75eEowpILUwcbGcHeLI/fc9XkWPMT2vNyI3z3Vs7yMhQSTdDyf8wvBfKML13bWr640B
         1DA4gRIu3uSJw+mBLvVFU7rIqFiWBQnQ8FHf4L/ZVNp5/mdzmCn04KrR+65eKUxYhDnd
         ZvYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=KtmbRd40eBGqKoolEIw082Sh0x88iIK3TLOTUIpOVGU=;
        b=G1VsuKDBlmlrBf84oGjWg+mxELyl49LYFhM+pTrczBYmcJ80FTwVLvLOfHErsoBFKJ
         OAzq+7JuU/3ZBtFkTcZeWtf2rEH4q2ITDjU78/uICqJGdKRslWw1FVDLkaiIyVsbR0A4
         Y8OkO4qpysuVskgY8xv5HmA9zOgHSld9MaaIULw1MSn6sMSaasaNV34ZbwC+2aTPg82B
         9sSaKmGclrAAdSgWsu1LeeshPvbN1tbprZ1aQcpsGnwwOJ9IhuHpzCEk6YQ/ACa72g4X
         kv9FJFyYFr4sXTHuCWrRfsuTdU4N43SFh6JFcyiWEdnNc/cN/FLvaZqa80+jyOCN2Q1t
         TQcA==
X-Gm-Message-State: AOAM532pQkyRs8DVk6quoY4ImWrtHa9EUXRIAY/5NpIim2HRiLYrw6Lu
        +ndZf4lOysFKil9ctWMaNO0=
X-Google-Smtp-Source: ABdhPJwmC6iCcP6QP+xuekILnr3/YsMEEcs0CEJlHf2h1Y34TwTVLUUMLh6zpKRs02fOAqMiA3C+HQ==
X-Received: by 2002:a6b:103:: with SMTP id 3mr21592853iob.98.1615248653839;
        Mon, 08 Mar 2021 16:10:53 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id q14sm6647079ilv.63.2021.03.08.16.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 16:10:53 -0800 (PST)
Date:   Mon, 08 Mar 2021 16:10:45 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <6046bd054922d_15c75208ad@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpWbcrBCguHXh0NhyOrCfP3N2x7LzM=pYqKHT6=NCN_JAw@mail.gmail.com>
References: <20210305015655.14249-1-xiyou.wangcong@gmail.com>
 <20210305015655.14249-4-xiyou.wangcong@gmail.com>
 <6042d8fa32b92_135da20871@john-XPS-13-9370.notmuch>
 <CAM_iQpWbcrBCguHXh0NhyOrCfP3N2x7LzM=pYqKHT6=NCN_JAw@mail.gmail.com>
Subject: Re: [Patch bpf-next v3 3/9] udp: implement ->sendmsg_locked()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Fri, Mar 5, 2021 at 5:21 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > UDP already has udp_sendmsg() which takes lock_sock() inside.
> > > We have to build ->sendmsg_locked() on top of it, by adding
> > > a new parameter for whether the sock has been locked.
> > >
> > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > ---
> > >  include/net/udp.h  |  1 +
> > >  net/ipv4/af_inet.c |  1 +
> > >  net/ipv4/udp.c     | 30 +++++++++++++++++++++++-------
> > >  3 files changed, 25 insertions(+), 7 deletions(-)
> >
> > [...]
> >
> > > -int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
> > > +static int __udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len, bool locked)
> > >  {
> >
> > The lock_sock is also taken by BPF_CGROUP_RUN_PROG_UDP4_SENDMSG_LOCK() in
> > udp_sendmsg(),
> >
> >  if (cgroup_bpf_enabled(BPF_CGROUP_UDP4_SENDMSG) && !connected) {
> >     err = BPF_CGROUP_RUN_PROG_UDP4_SENDMSG_LOCK(sk,
> >                                     (struct sockaddr *)usin, &ipc.addr);
> >
> > so that will also need to be handled.
> 
> Indeed, good catch!

This is going to get tricky though because we can't exactly drop the
lock and try to reclaim it. We would have no guarentee some other
core didn't grab the lock from the backlog side.

> 
> >
> > It also looks like sk_dst_set() wants the sock lock to be held, but I'm not
> > seeing how its covered in the current code,
> >
> >  static inline void
> >  __sk_dst_set(struct sock *sk, struct dst_entry *dst)
> >  {
> >         struct dst_entry *old_dst;
> >
> >         sk_tx_queue_clear(sk);
> >         sk->sk_dst_pending_confirm = 0;
> >         old_dst = rcu_dereference_protected(sk->sk_dst_cache,
> >                                             lockdep_sock_is_held(sk));
> >         rcu_assign_pointer(sk->sk_dst_cache, dst);
> >         dst_release(old_dst);
> >  }
> 
> I do not see how __sk_dst_set() is called in udp_sendmsg().

The path I was probably looking at is,

  udp_sendmsg()
    sk_dst_check()
      sk_dst_reset()
        sk_dst_set(sk, NULL)

but that does a cmpxchg only __sk_dst_set() actually has the
lockdep_sock_is_held(sk) check. So should be OK.

> 
> >
> > I guess this could trip lockdep now, I'll dig a bit more Monday and see
> > if its actually the case.
> >
> > In general I don't really like code that wraps locks in 'if' branches
> > like this. It seem fragile to me. I didn't walk every path in the code
> 
> I do not like it either, actually I spent quite some time trying to
> get rid of this lock_sock, it is definitely not easy. The comment in
> sk_psock_backlog() is clearly wrong, we do not lock_sock to keep
> sk_socket, we lock it to protect other structures like
> ingress_{skb,msg}.

The comment comes from early days before psock was ref counted and
can be removed.

> 
> > to see if a lock is taken in any of the called functions but it looks
> > like ip_send_skb() can call into netfilter code and may try to take
> > the sock lock.
> 
> Are you saying skb_send_sock_locked() is buggy? If so, clearly not
> my fault.

Except this path only exists on the UDP I think.

  udp_sendmsg()
   udp_send_skb()
     ip_send_skb()
     ...

TCP has some extra queuing logic in there that makes this work.

> 
> >
> > Do we need this locked send at all? We use it in sk_psock_backlog
> > but that routine needs an optimization rewrite for TCP anyways.
> > Its dropping a lot of performance on the floor for no good reason.
> 
> At least for ingress_msg. It is not as easy as adding a queue lock here,
> because we probably want to retrieve atomically with the receive queue
> together.

Agree. I'll try a bit harder tomorrow and see if I can come up with
anything, intended to do this today, but got busy with some other things.
Best case is we find some way to drop that sock_lock altogether here.

> 
> Thanks.
