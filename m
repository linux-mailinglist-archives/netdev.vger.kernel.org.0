Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673A53898EF
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 23:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhESV4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 17:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhESVz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 17:55:57 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDA1C061574;
        Wed, 19 May 2021 14:54:37 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id h11so13480624ili.9;
        Wed, 19 May 2021 14:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=MwSVZiRfW96LTESPv/Lx6p2DSwYMHGNReB80Gg/XoCs=;
        b=Jvh7NU4Hsp36HhGhaz3Zvu26RmqCuyT76ylX3JFyeb96DIQsIWAfi9Fu6k3SImryDS
         QZ4rZBkg+wlPeZrWI/9jeO0/fuyQa+NVo6kgXJ9htGgTyaIVosEFgpcc+ptzr+oHa3E9
         obUdCgD4ZDNoBKH4Yke77r2wKYcwVhwEdS9eY3a5rIwfOhJg5StZ44eDJl/l3hjTJt7i
         LJrgLBaLjXRD1rqgrp0D4rSbt0868hgpC76nuf8dGwhvNV4m6csnR9gJ6HTQAgL/6if2
         39hG6xila6lRJJhz4MCpyJJn1OVm3GhU4bgIXdbQg7EHwdX9WiqiavwcHZf58VBIIAE2
         J4tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=MwSVZiRfW96LTESPv/Lx6p2DSwYMHGNReB80Gg/XoCs=;
        b=FunXSOZyV1rRAZ5gkwky1AgvIaeMH2srrFhoRLb9983I4SbdYtMWf9mPx5i+gSAw4m
         hs1P0+bXyFt4G3PrW2OOvodnVI6V0g7LQeLr/lk+JbbG0d1gO8HtJcruKKRvuHdfH/RU
         7p+fu4OVsW1GFUhPMGx/YlPZFVQ1w7n7+FW1tQ2B2Z3/JA6dkt199r77GxsDNvRw1QA/
         EMJzi7jo6c2UsWkqwks6BM6tCaCHfd8hIzU7UpheebBRqKwr4CfDagDang5hJi8GjnQH
         tzxyYTGsKg/dMf02W87gOELrKISn1yje/pAso/meiC8WeH1LzVpEbt4sFRgq6uWEFub9
         oW1Q==
X-Gm-Message-State: AOAM533hC4oRcSqW/TEpseFZJdXWTIwRh2Qmijgvq7uPKAVAqUHvtLgy
        KeP8pXk+dYAdQ+p/WyvxMdk=
X-Google-Smtp-Source: ABdhPJx+hMUT9qCM9VlI52SXwMC3aJb7ha6AWEeBC5Y77eKnrskt8pajC4HvpEIgUvIlixSmz2g50g==
X-Received: by 2002:a92:cc43:: with SMTP id t3mr1559713ilq.250.1621461276708;
        Wed, 19 May 2021 14:54:36 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id h16sm690420ilr.56.2021.05.19.14.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 14:54:36 -0700 (PDT)
Date:   Wed, 19 May 2021 14:54:27 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <60a58913d51e2_2aaa72084c@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpV=XPW08hS3UyakLxPZrujS_HV-BB9bRbnZ1m+vWQytcQ@mail.gmail.com>
References: <20210517022322.50501-1-xiyou.wangcong@gmail.com>
 <60a3525d188d9_18a5f208f5@john-XPS-13-9370.notmuch>
 <CAM_iQpVCfGEA+TOfWvXYxJ1kk9z_thdbvRmZHxhWpuBMx9x2zg@mail.gmail.com>
 <60a41be5629ab_10e7720815@john-XPS-13-9370.notmuch>
 <CAM_iQpXkYsf=LF=g4aKLmas_9jHNqXGy-P2gi3R4eb65+ktz4A@mail.gmail.com>
 <60a561b63598a_22c462082f@john-XPS-13-9370.notmuch>
 <CAM_iQpV=XPW08hS3UyakLxPZrujS_HV-BB9bRbnZ1m+vWQytcQ@mail.gmail.com>
Subject: Re: [Patch bpf] udp: fix a memory leak in udp_read_sock()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Wed, May 19, 2021 at 12:06 PM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > On Tue, May 18, 2021 at 12:56 PM John Fastabend
> > > <john.fastabend@gmail.com> wrote:
> > > >
> > > > Cong Wang wrote:
> > > > > On Mon, May 17, 2021 at 10:36 PM John Fastabend
> > > > > <john.fastabend@gmail.com> wrote:
> > > > > >
> > > > > > Cong Wang wrote:
> > > > > > > From: Cong Wang <cong.wang@bytedance.com>
> > > > > > >
> > > > > > > sk_psock_verdict_recv() clones the skb and uses the clone
> > > > > > > afterward, so udp_read_sock() should free the original skb after
> > > > > > > done using it.
> > > > > >
> > > > > > The clone only happens if sk_psock_verdict_recv() returns >0.
> > > > >
> > > > > Sure, in case of error, no one uses the original skb either,
> > > > > so still need to free it.
> > > >
> > > > But the data is going to be dropped then. I'm questioning if this
> > > > is the best we can do or not. Its simplest sure, but could we
> > > > do a bit more work and peek those skbs or requeue them? Otherwise
> > > > if you cross memory limits for a bit your likely to drop these
> > > > unnecessarily.
> > >
> > > What are the benefits of not dropping it? When sockmap takes
> > > over sk->sk_data_ready() it should have total control over the skb's
> > > in the receive queue. Otherwise user-space recvmsg() would race
> > > with sockmap when they try to read the first skb at the same time,
> > > therefore potentially user-space could get duplicated data (one via
> > > recvmsg(), one via sockmap). I don't see any benefits but races here.
> >
> > The benefit of _not_ dropping it is the packet gets to the receiver
> > side. We've spent a bit of effort to get a packet across the network,
> > received on the stack, and then we drop it at the last point is not
> > so friendly.
> 
> Well, at least udp_recvmsg() could drop packets too in various
> scenarios, for example, a copy error. So, I do not think sockmap
> is special.

OK I am at least convinced now that dropping packets is OK and likely
a useful performance/complexity compromise.

But, at this point we wont have any visibility into these drops correct?
Looks like the pattern in UDP stack to handle this is to increment
sk_drops and UDP_MIB_INERRORS. How about we do that here as well?
