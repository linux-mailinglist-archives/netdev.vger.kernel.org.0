Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46856CEF2A
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjC2QVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjC2QVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 12:21:42 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86EF91
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 09:21:40 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id er13so24608705edb.9
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 09:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680106899; x=1682698899;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YXUlnFECGnz2pfhyhhvxrr4SFAXn5z4wN3+z5RJ9udM=;
        b=g+FN2NYjNhCHO7Mxha1uwSY1lE1eOVY31ln5CwYdI/DqSdcluaXFdWZSGDn8BBRuRc
         2lstlX3yUdqVCIIMC9bwQEMzDXKzwrtfzU/xR6JwOTG/29nraUAAqff7KNXd9MNkeYYP
         11kNSE2tEsCno0evDBtT4Un1flB0w4eHQ2mNrzgVyvFpvSDx5XgtocdIj4unM2B9QHr6
         35p1tw6VJQEOt+fjQhC47DLbXFljUKyp+vgxWQVVKQ0WN7ZKesHidvkj+LNH+yN9rvPN
         lZETEju4CSXnE18AOoa7RO37l1ExWkAz5TZ5v5C2tBhth0L3p2qgJRIljtbT7++hdH0t
         IsuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680106899; x=1682698899;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YXUlnFECGnz2pfhyhhvxrr4SFAXn5z4wN3+z5RJ9udM=;
        b=7rr4Kkgo4hOj6NoPUeWw6ejwtxZR3U1a1GLvq4TKHzAZyJTQUmPbJEhRMKdhkzSW6y
         Y4/7vm/C5WaQfJIL73eR53of+wzbfxt2qN/yg1hWYaTfmJrhaXprhd0TKGg0vXNcABVp
         u+apjJWiurLmjzo4zRFHdc9CQ967Pjt+ZOmpBlkN9vyi62zoOEJR6YrOPkn1Z+ArtnXb
         E8IZ++s7/ROP6A5izyTRuk7dv2KWnPTCZ6v0Blpbim0zsNsskA1p348w2Uj9hGwYx/SE
         kixCqqcw774FrHYzbMbjUjvaE/6zz6vwW4M2LypEknsewm1+tFTbGVYA+m9KmClzWwbx
         O+Vg==
X-Gm-Message-State: AAQBX9dlyDRjmyUh6JP8MslARoYDVMFoZuwQdLVBjq0Fw7I9AU/Teh1X
        uyIHlfyc7RsqA4tfDr3CxdSE9IYOnwg3hsfSd0Y=
X-Google-Smtp-Source: AKy350aRLqEEFIJ7DOzJvaonFgvp3Ni6b3ZEkP6sYZ4Rwmud5HpAB/wkqa8E2/Lptk8KYWYUSYjckGt1PYvLCPQUTG8=
X-Received: by 2002:a17:907:cb86:b0:930:42bd:ef1d with SMTP id
 un6-20020a170907cb8600b0093042bdef1dmr10216249ejc.11.1680106899110; Wed, 29
 Mar 2023 09:21:39 -0700 (PDT)
MIME-Version: 1.0
References: <16988771.uLZWGnKmhe@eq59> <6984423.44csPzL39Z@eq59> <CANn89iJsYLrvjms-uT0mLPiiLG-MtHMSm3dSy6QDqP0d46mSJg@mail.gmail.com>
In-Reply-To: <CANn89iJsYLrvjms-uT0mLPiiLG-MtHMSm3dSy6QDqP0d46mSJg@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Thu, 30 Mar 2023 00:21:02 +0800
Message-ID: <CAL+tcoBhNUjWTF1uLnEE3j9mM5T5WAam0CoSuQC69fntb0u7dw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] net: rps/rfs improvements
To:     Eric Dumazet <edumazet@google.com>
Cc:     Aiden Leong <aiden.leong@aibsd.com>, davem@davemloft.net,
        eric.dumazet@gmail.com, kernelxing@tencent.com, kuba@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 11:36=E2=80=AFPM Eric Dumazet <edumazet@google.com>=
 wrote:
>
> On Wed, Mar 29, 2023 at 3:18=E2=80=AFPM Aiden Leong <aiden.leong@aibsd.co=
m> wrote:
> >
> > On Wednesday, March 29, 2023 9:17:06 PM CST Aiden Leong wrote:
> > > Hi Eric,
> > >
> > > I hope my email is not too off-topic but I have some confusion on how
> > > maintainers and should react to other people's work.
> > >
> > > In short, you are stealing Jason's idea&&work by rewriting your
> > > implementation which not that ethical. Since your patch is based on h=
is
> > > work, but you only sign-off it by your name, it's possible to raise l=
awsuit
> > > between Tencent and Linux community or Google.
>
> Seriously ?
>
> I really gave enough credit to Jason's work, it seems you missed it.
>
> I am quite tired of reviewing patches, and giving ideas of how to
> improve things,
> then having no credits for my work.
>
> After my feedback on v1, seeing a quite silly v2, obviously not tested,
> and with no numbers shown, I wanted to see how hard the complete
> implementation would be.

At first glance, I really don't have any interest in commenting on this.

However, those words 'silly' 'not tested' 'no numbers' make me feel
very uncomfortable. Actually I did all of them. What you said makes
others think I'm like a fool who just does not have any knowledge
about this and proposed one idea with no foundation (out of thin air).
You know that it's not real but I don't know why you're using these
terrible words in public?
In fact, last night in our private email exchange, you said "I need to
be convinced" to me and then it was me who listed nearly every step to
prove how it can have impacts on latency with high load at 3:00 AM.

Well, I wouldn't like to see any further conflicts because of this.
Let's stop here and focus on this patch series and then move on, shall
we?

>
> This needed full understanding of RPS and RFS, not only an "idea" and
> wrong claims about fixing
> a "bug" in the initial implementation which was just fine.
>
> Also, results are theoretical at this stage,I added numbers in the cover =
letter
> showing the impact was tiny or not even mesurable.
>
> I sent a series of 4 patches, Jason work on the 3rd one has been
> completely documented.
>
> If Jason managers are not able to see the credit in the patch series
> (and cover letter),
> this is their problem, not mine.
>
> Also, my contributions to linux do not represent views of my employer,
> this should be obvious.
>
>
>
> > >
> > > I'm here to provoke a conflict because we know your name in this area=
 and
> > > I'd to show my respect to you but I do have this kind of confusion in=
 my
> > > mind and wish you could explain about it.
> > >
> > Typo: I'm here NOT to provoke a conflict
> > > There's another story you or Tom Herbert may be interested in: I was =
working
> > > on Foo Over UDP and have implemented the missing features in the prev=
ious
> > > company I worked for. The proposal to contribute to the upstream comm=
unity
> > > was rejected later by our boss for unhappy events very similar to thi=
s one.
> > >
> > > Aiden Leong
> > >
> > > > Jason Xing attempted to optimize napi_schedule_rps() by avoiding
> > > > unneeded NET_RX_SOFTIRQ raises: [1], [2]
> > > >
> > > > This is quite complex to implement properly. I chose to implement
> > > > the idea, and added a similar optimization in ____napi_schedule()
> > > >
> > > > Overall, in an intensive RPC workload, with 32 TX/RX queues with RF=
S
> > > > I was able to observe a ~10% reduction of NET_RX_SOFTIRQ
> > > > invocations.
> > > >
> > > > While this had no impact on throughput or cpu costs on this synthet=
ic
> > > > benchmark, we know that firing NET_RX_SOFTIRQ from softirq handler
> > > > can force __do_softirq() to wakeup ksoftirqd when need_resched() is=
 true.
> > > > This can have a latency impact on stressed hosts.
> > > >
> > > > [1] https://lore.kernel.org/lkml/20230325152417.5403-1->
> > >
> > > kerneljasonxing@gmail.com/
> > >
> > > > [2]
> > > > https://lore.kernel.org/netdev/20230328142112.12493-1-kerneljasonxi=
ng@gma
> > > > il.com/>
> > > > Eric Dumazet (4):
> > > >   net: napi_schedule_rps() cleanup
> > > >   net: add softnet_data.in_net_rx_action
> > > >   net: optimize napi_schedule_rps()
> > > >   net: optimize ____napi_schedule() to avoid extra NET_RX_SOFTIRQ
> > > >
> > > >  include/linux/netdevice.h |  1 +
> > > >  net/core/dev.c            | 46 ++++++++++++++++++++++++++++++-----=
----
> > > >  2 files changed, 37 insertions(+), 10 deletions(-)
> >
