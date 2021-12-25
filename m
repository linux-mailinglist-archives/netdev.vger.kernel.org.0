Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE64447F1A4
	for <lists+netdev@lfdr.de>; Sat, 25 Dec 2021 02:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhLYBlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 20:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhLYBlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 20:41:50 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E14C061401
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 17:41:50 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id m21so39813779edc.0
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 17:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vo4j50tEnJAx8/3BFHsknwBXx9GTJcFh2lCfaX8+WeU=;
        b=fH1vog3chZD2SeliGCVVmgCazR//ftP1UU3y7FUcjgpPTxoP7ygDVlc+/YX4PERVDJ
         roUCYJjDfNWcsrFPdZRPxHnPFOtzF8lPpGFLMnJ5xllGPnvU/X1f/zAqimqnrZZu5GAq
         hEhivkXj57qkVTKFRjdgoZNI6sEa8kgsz3Z2RCPGn2dPBY4KeLcW1BciX7IZkhjSE8TC
         8vAvs4H+gtKD8qShp7ZTQ40LNfcy4vT6Uu7ARmjdsnYLsusI3Lis92Mxkcen0iPpqTTn
         AcmqcJp80eJNzyWTdnG0otHT6GQFg0VSlrcoGJ0b8jNZNVnNS0M/oA1r9myQwm1QUOGG
         tfOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vo4j50tEnJAx8/3BFHsknwBXx9GTJcFh2lCfaX8+WeU=;
        b=YIa+LNTDhUMldNurdJaXWwiV1LsqZbQ06FfY8Oi/W62xclq1DiMprXIqyUlKt0eByV
         8NDWIBB6VizIVfQeXFZAmbECvwnfRLg2DLOcyvngPcv2C+SCCSFwMgNs8ahe5K/EquyC
         xd9lvi46ot+vjiVOukWqTk36iWc0y1qBdjPgyZP2cwbc+wQXvOHKpVLFh46Q+e3NVyb2
         70KaoPhekuGztWRHEW9LIDs2shLMYQt7jaZkCId8a7eh/XU06iaNr8BxXczgQWCwBIED
         ggYnjpmAlscLXohJXPXVTmcjqp7E4dodDGrRKSJZLFHqQsTswGlxEbWz8D+ywshlS1tc
         Ro7A==
X-Gm-Message-State: AOAM532nxofp21fEqQFkIxTRqhyx/eoqMhoR0fhQoek4zLuMe1B2s0a3
        Anum8HHm1cnYOWCsjFkHEfkJPYK2YXAxncOL/QU=
X-Google-Smtp-Source: ABdhPJyQ4TzBcxKDhJJaD92fV8wiBKoWRP38J4AfX1p3nTer+G/A+nB686YP+Fw0uTb5jFZuqxOXUbNnV3JoKFQUllY=
X-Received: by 2002:a50:d543:: with SMTP id f3mr7558001edj.56.1640396508820;
 Fri, 24 Dec 2021 17:41:48 -0800 (PST)
MIME-Version: 1.0
References: <20211220123839.54664-1-xiangxia.m.yue@gmail.com>
 <20211220123839.54664-3-xiangxia.m.yue@gmail.com> <CAM_iQpXfZq--ZCUQvggtqE7bEpZFRVcLTqN_R5kLiZj4Y75VAA@mail.gmail.com>
 <CAMDZJNVNKP1cgHJKUtPwWUdPR5cZ=v8+t9X6AgHw9FPLi4CmYg@mail.gmail.com> <CAM_iQpULb_+whVGsEv+BD09MBOdvpT-3C8WmiuBSSCbT9Yrw3Q@mail.gmail.com>
In-Reply-To: <CAM_iQpULb_+whVGsEv+BD09MBOdvpT-3C8WmiuBSSCbT9Yrw3Q@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Sat, 25 Dec 2021 09:41:12 +0800
Message-ID: <CAMDZJNVo1ZxdcLuEBiGtn9j96akSV96oTUyMSh902q5MrKPUTA@mail.gmail.com>
Subject: Re: [net-next v5 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
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

On Sat, Dec 25, 2021 at 3:26 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Tue, Dec 21, 2021 at 5:24 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >
> > On Tue, Dec 21, 2021 at 1:57 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Mon, Dec 20, 2021 at 4:39 AM <xiangxia.m.yue@gmail.com> wrote:
> > > >
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
> > > Once again, you are enforcing policies in kernel, which is not good.
> > > Kernel should just set whatever you give to it, not selecting policies
> > > like a menu.
> > I agree that, but for tc/net-sched layer, there are a lot of
>
> If you agree, why still move on with this patch? Apparently
> you don't. ;)
>
> > networking policies, for example , cls_A, act_B, sch_C.
>
> You are justifying your logic by shifting the topics here.
Hi Cong,
I mean that if the "policies" are networking policies, I don't agree
with you, because
the TC(or net sched layer), are networking policies, right ? and this
patch enhances the original feature of TC.


> The qdisc algorithm is very different from your case, it is essentially
> hard, if not impossible, to completely move to user-space. Even if we
> had eBPF based Qdisc, its programmablility is still very limited.
> Your code is much much much easier, which is essentially one-line,
> hence you have to reason to compare it with this, nor you can even
> justify it.
I think we have talked about this in another thread. And other
maintainers comment on this.
> > > Any reason why you can't obtain these values in user-space?
> > Did you mean that we add this flags to iproute2 tools? This patch for
> > iproute2, is not post. If the kerenl patches are accepted, I will send
> > them.
>
> Nope, I mean you can for example, obtain the CPU ID in user-space
> and pass it directly to _current_ act_skbedit as it is.
This flag is passed from userspace. Do you mean the cpuid value should
be passed from userspace?
If so, this is not what we need. because we don't know which one cpu
the pod(containers) will use. and for skb-hash/classid
this helps us to pick the tx queue from a range. I don't understand
why this value should be passed from userspace. How ?
can you give me examples ?

BTW, this patch is the core of patchset.
> Thanks.



--
Best regards, Tonghao
