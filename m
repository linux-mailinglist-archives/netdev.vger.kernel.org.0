Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F436485E1D
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 02:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344366AbiAFB2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 20:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344334AbiAFB2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 20:28:41 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73A5C061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 17:28:40 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id j6so3347519edw.12
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 17:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GiCPg54ntiKpwYtVlEf/p85oDYqh05/xTTbJIjVZH+8=;
        b=jXLSXP81c32kiYn/MlQeTLxjeD0fA2of3r4DzBFAQysrY43paHxG66AZ9bEonMNG1L
         GlUnkok84x9hEv7kv0ORR5Imys7zUnJSwQ8txQDBdXUEyh6HxhE2d/wI89Y/OijXIZKm
         Jde1z2sVdK6yMn1Klnam9uypIaGEPbhEVVlzFNM5tclzwB8pyhFkDEjQMxp4h2aExZqQ
         blMVzDFvEABQrj6itKGeDJhjhNKfIQ3QJLkamF5So4xokcGw4QNIQDzFMGK66524mLqm
         v/9+ztivxDirsrcI/Qjrhjozp0nm0HeD3LB8F6ubcejEJeOqO2ya1rPO48/sy6/UVU9P
         W7Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GiCPg54ntiKpwYtVlEf/p85oDYqh05/xTTbJIjVZH+8=;
        b=B7amXs5gyHNzolnSy8bGcxlJCqsVKELulKmderpYpPr2DF58PITJXUHSrpNxWWwfAd
         G6LSC1TniqpchqoiC3/eZ9k5iSvEhqaBYMRU/vRDOjVZKJba0HJy9EJiwkDdW537521W
         z1rBKaJEMmIgNfGPdZZwiV1doQhGVWB/8Y52MlXQtY2yBESaQGvcReb2SAWYYtfId7jf
         SOYiV3jtZprk+dfdKPGeqCpFMRdtyEECUkrRhcsGsU48wXn2bExFNqQbDtjePrroweTs
         luWETIQ+sa7BRMUhaGr5qiuM7znrNPhND1rDeXKuUyB1vLQAW6WAzQEBmlGdjjOZOAyx
         M7sg==
X-Gm-Message-State: AOAM531nZXrdV9g0yx9ChUzePi9Qjp/mOio5pS20FCp1P40qGzS/7vnz
        IFZ8tt5ZaHg2FyxTBcw8TtY14v8PhrLF4xUEIxalP0icKs0=
X-Google-Smtp-Source: ABdhPJy+Bu6RytqR1pXnL06hIk4H+OPFErWYbKdihdVDXeMAWNnOnAYbHfCZBRsQXL58qHq9yUF8W9Mm2v1M/wgPLpc=
X-Received: by 2002:a05:6402:3490:: with SMTP id v16mr55790869edc.398.1641432519478;
 Wed, 05 Jan 2022 17:28:39 -0800 (PST)
MIME-Version: 1.0
References: <20211220123839.54664-1-xiangxia.m.yue@gmail.com>
 <20211220123839.54664-3-xiangxia.m.yue@gmail.com> <CAM_iQpXfZq--ZCUQvggtqE7bEpZFRVcLTqN_R5kLiZj4Y75VAA@mail.gmail.com>
 <CAMDZJNVNKP1cgHJKUtPwWUdPR5cZ=v8+t9X6AgHw9FPLi4CmYg@mail.gmail.com>
 <CAM_iQpULb_+whVGsEv+BD09MBOdvpT-3C8WmiuBSSCbT9Yrw3Q@mail.gmail.com>
 <CAMDZJNVo1ZxdcLuEBiGtn9j96akSV96oTUyMSh902q5MrKPUTA@mail.gmail.com> <CAMDZJNXuj7CL=0n=nL31zuZ5+_fzOQjX8Ftk2n6TQVgd75UnLA@mail.gmail.com>
In-Reply-To: <CAMDZJNXuj7CL=0n=nL31zuZ5+_fzOQjX8Ftk2n6TQVgd75UnLA@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 6 Jan 2022 09:28:03 +0800
Message-ID: <CAMDZJNU+wu9NbMyNJtn-d1RRQ=7PFpV+vUfwf6EN55SEp-fnaw@mail.gmail.com>
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

On Wed, Dec 29, 2021 at 8:50 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Sat, Dec 25, 2021 at 9:41 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >
> > On Sat, Dec 25, 2021 at 3:26 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Tue, Dec 21, 2021 at 5:24 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > >
> > > > On Tue, Dec 21, 2021 at 1:57 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > >
> > > > > On Mon, Dec 20, 2021 at 4:39 AM <xiangxia.m.yue@gmail.com> wrote:
> > > > > >
> > > > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > > >
> > > > > > This patch allows user to select queue_mapping, range
> > > > > > from A to B. And user can use skbhash, cgroup classid
> > > > > > and cpuid to select Tx queues. Then we can load balance
> > > > > > packets from A to B queue. The range is an unsigned 16bit
> > > > > > value in decimal format.
> > > > > >
> > > > > > $ tc filter ... action skbedit queue_mapping skbhash A B
> > > > > >
> > > > > > "skbedit queue_mapping QUEUE_MAPPING" (from "man 8 tc-skbedit")
> > > > > > is enhanced with flags:
> > > > > > * SKBEDIT_F_TXQ_SKBHASH
> > > > > > * SKBEDIT_F_TXQ_CLASSID
> > > > > > * SKBEDIT_F_TXQ_CPUID
> > > > >
> > > > > Once again, you are enforcing policies in kernel, which is not good.
> > > > > Kernel should just set whatever you give to it, not selecting policies
> > > > > like a menu.
> > > > I agree that, but for tc/net-sched layer, there are a lot of
> > >
> > > If you agree, why still move on with this patch? Apparently
> > > you don't. ;)
> > >
> > > > networking policies, for example , cls_A, act_B, sch_C.
> > >
> > > You are justifying your logic by shifting the topics here.
> > Hi Cong,
> > I mean that if the "policies" are networking policies, I don't agree
> > with you, because
> > the TC(or net sched layer), are networking policies, right ? and this
> > patch enhances the original feature of TC.
> >
> >
> > > The qdisc algorithm is very different from your case, it is essentially
> > > hard, if not impossible, to completely move to user-space. Even if we
> > > had eBPF based Qdisc, its programmablility is still very limited.
> > > Your code is much much much easier, which is essentially one-line,
> > > hence you have to reason to compare it with this, nor you can even
> > > justify it.
> > I think we have talked about this in another thread. And other
> > maintainers comment on this.
> > > > > Any reason why you can't obtain these values in user-space?
> > > > Did you mean that we add this flags to iproute2 tools? This patch for
> > > > iproute2, is not post. If the kerenl patches are accepted, I will send
> > > > them.
> > >
> > > Nope, I mean you can for example, obtain the CPU ID in user-space
> > > and pass it directly to _current_ act_skbedit as it is.
> > This flag is passed from userspace. Do you mean the cpuid value should
> > be passed from userspace?
> > If so, this is not what we need. because we don't know which one cpu
> > the pod(containers) will use. and for skb-hash/classid
> > this helps us to pick the tx queue from a range. I don't understand
> > why this value should be passed from userspace. How ?
> > can you give me examples ?
> friendly ping
still waiting for your reply, and Jakub's questions in other thread.
If possible, I plan to resend the patchset.
> > BTW, this patch is the core of patchset.
> > > Thanks.
> >
> >
> >
> > --
> > Best regards, Tonghao
>
>
>
> --
> Best regards, Tonghao



-- 
Best regards, Tonghao
