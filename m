Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E1A470792
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242330AbhLJRru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:47:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240884AbhLJRru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 12:47:50 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF546C0617A1
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:44:14 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id r11so31675767edd.9
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NxPxJyZawfrnZBMiRlqw1rETnKz3/ZdqmH3r9+FILxQ=;
        b=j605hwarRrFsDpVW4VHk878pZcn/NVoEAqJD88DInE3+bhhTsb1mVkdPtZqtKvNy1F
         sQDAIyPQps1MMsUNGE5ZzMV71vObGdGkDrkfEVHNMZ2u8iiz8OAQmp/Wc8jNzIUQKE6D
         b8yrDYUPEMvfd2Y0g8Tw4vEAR2QDVHBC2GxZriLcDY7UF9RVifFlLCdKA+r3pZMvo4ON
         Hzk6WSLjIsitN7LrxMwYG78lpiTrXd48OmvVS5pvuVETiBXg/Z52Cc6RsSvVqXseC6E+
         3JomW7qaS5jsMuk6N3gRWQMDXlA8o1KR58RVuhqeV+s3HCnOgIuh1SLNNRZ5zCuofz3d
         9fSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NxPxJyZawfrnZBMiRlqw1rETnKz3/ZdqmH3r9+FILxQ=;
        b=1OCOPXaJVAXEE+vPRxvFsMW6pZVYecXaHnVpK8i+54dMPDVARAX8ZqrA7zsMEVv2MN
         O/5oRolrfvFb6Nqc3hJw7gcvnKLOUOjMP3pdefvqI2UCp5IzJLqvJG/ywJdFpvmz4Ig3
         esxgw/TddViSA+xKOQLzKhZmlaTxXbzakt+qpZbqgm2ZvxhEgu8hRMG07JlQvZ/k/jWE
         /46U35DRTFy2fcveew/rNU6qybA0N8IC6Y2ucqy/pEw1zhkQOrygPuOTEP88B0WCQUMR
         dWYRiVzOFDBs5CjIZFEOjDXHGDpUBwxoNaZ2tBlghc+1uin+6NhpK0AU+DLMy3CONoqe
         /muQ==
X-Gm-Message-State: AOAM5301tmiMOwyhD6uBpicMqjqySTj3xYduZjTIJlSBv55uxJOJEUme
        +DJHjCPenfACaDfbiveP6yoLANejTIEDEll+HHc=
X-Google-Smtp-Source: ABdhPJz92j1m966zdNGaUj9clabUdoZanSLACG64zTW0jcWw/48D3utyUHk9w/qThmm0xP0YJMsUej8Pzwo3NSqSmnE=
X-Received: by 2002:a05:6402:4407:: with SMTP id y7mr40521247eda.140.1639158252635;
 Fri, 10 Dec 2021 09:44:12 -0800 (PST)
MIME-Version: 1.0
References: <20211208145459.9590-1-xiangxia.m.yue@gmail.com>
 <20211208145459.9590-3-xiangxia.m.yue@gmail.com> <61b383c6373ca_1f50e20816@john.notmuch>
 <61b385c5c21c3_203252085a@john.notmuch>
In-Reply-To: <61b385c5c21c3_203252085a@john.notmuch>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Sat, 11 Dec 2021 01:43:36 +0800
Message-ID: <CAMDZJNUpnA2Ayq6vNLQ4_JYY2Z6vDhFd5riUeVFGwMK492+L4g@mail.gmail.com>
Subject: Re: [net v5 2/3] net: sched: add check tc_skip_classify in sch egress
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 11, 2021 at 12:52 AM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> John Fastabend wrote:
> > xiangxia.m.yue@ wrote:
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > Try to resolve the issues as below:
> > > * We look up and then check tc_skip_classify flag in net
> > >   sched layer, even though skb don't want to be classified.
> > >   That case may consume a lot of cpu cycles. This patch
> > >   is useful when there are a lot of filters with different
> > >   prio. There is ~5 prio in in production, ~1% improvement.
> > >
> > >   Rules as below:
> > >   $ for id in $(seq 1 5); do
> > >   $       tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
> > >   $ done
> > >
> > > * bpf_redirect may be invoked in egress path. If we don't
> > >   check the flags and then return immediately, the packets
> > >   will loopback.
> >
> > This would be the naive case right? Meaning the BPF program is
> > doing a redirect without any logic or is buggy?
> >
> > Can you map out how this happens for me, I'm not fully sure I
> > understand the exact concern. Is it possible for BPF programs
> > that used to see packets no longer see the packet as expected?
> >
> > Is this the path you are talking about?
> >
> >  rx ethx  ->
> >    execute BPF program on ethx with bpf_redirect(ifb0) ->
> >      __skb_dequeue @ifb tc_skip_classify = 1 ->
> >        dev_queue_xmit() ->
> >           sch_handle_egress() ->
> >             execute BPF program again
> >
> > I can't see why you want to skip that second tc BPF program,
> > or for that matter any tc filter there. In general how do you
> > know that is the correct/expected behavior? Before the above
> > change it would have been called, what if its doing useful
> > work.
> >
> > Also its not clear how your ifb setup is built or used. That
> > might help understand your use case. I would just remove the
> > IFB altogether and the above discussion is mute.
> >
> > Thanks,
> > John
>
> After a bit further thought (and coffee) I think this will
> break some programs that exist today. Consider the case
> where I pop a header off and resubmit to the same device
> intentionally to reprocess the pkt without the header. I've
> used this pattern in BPF a few times.
No, ifb netdev sets the skb->tc_skip_classify = 1, that means we
should not process the skb again, no matter on egress or ingress.
if the bpf programs don't set the skb->tc_skip_classify = 1, then we
can process them again.

-- 
Best regards, Tonghao
