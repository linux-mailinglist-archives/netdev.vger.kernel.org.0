Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F14F6CECFB
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 17:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjC2Pdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 11:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjC2Pd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 11:33:29 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DB2423A
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:33:23 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id j2so1267480ila.8
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680104002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XPEKTf+V0wi8uK6Lvpod96aibMeyM/47YFti/raUe10=;
        b=R/emlb4sukSPr9lZWVamF3+I/ie3z6ZusXdBrclJT8wUjPNuSDR8XSu7dBrqxbILF0
         rrfe9MYV8UBohrsufyf6vsPPgstKU8LWIlkBo0lXe8jJ0+L0mot28kYtRNS7SbXBK2CB
         rXU2Z1AOKRd7hPoU2GZ7tQPRobNU1Mxh1h2ngkrFpKngAAKYtJsJmeSX2++SxVEuoDPg
         LNn/G3oAv3Vpi9ix6ypMJFTchcg5ZO435gkom5qehOnmktAFWUVsgZPj0fqT5QVcUE38
         f4IY0wOvL3K0W/Zz+kFKXzozstr+dsg5B6/n/uemx/oC2+cnCGXxnvg19oq61DCpJcQX
         87CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680104002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XPEKTf+V0wi8uK6Lvpod96aibMeyM/47YFti/raUe10=;
        b=enbd+4mdl2bJdw3NtbtuCrn5RHrSdwOfbBhrSxtraI5ctrB2B1XMiLyR59qeyADblv
         yMSCCOlNjD590xZXf/Qqr62Bitsa7hvONbEgd0fJ6QpTufI78nb+LD8GNNUb/hcGwidf
         tyPhMeZpglAfHPS73c+7wzQw52Hh7WmHmjqRynX6izUZrh/hikQBZJLVJR9ME+btEqyh
         sTgM+e4s6oqlaJO2J23Zt2F6oQL+y/t1NlwGZCqdRADWM1W4FsEh2lfJ54ZZShYgHxW8
         30hAsz/DPijtdsHcZugDgfrteiC/5xAiXIXKT9gVluf6rwDkGU8U5OcqwHeMktM4OCYd
         Qv1g==
X-Gm-Message-State: AAQBX9cGbI2BEixwN9BsPbemgKhplOMrHEc25BqcVGsJWX2i3kKDeoQY
        WSxQiCvTJxZuKJABlDClzwL8TSPGGnSv7VOs/A5Cwg==
X-Google-Smtp-Source: AKy350bx2MKF+tGkbm4hrDjKR7xREHR0eW5POfmYSfetoCyV8WFeupZIAdSdrNoOA1U4gSiaK9RrQmhFiMkHakJFOgQ=
X-Received: by 2002:a05:6e02:1be1:b0:325:e0bd:d1c7 with SMTP id
 y1-20020a056e021be100b00325e0bdd1c7mr9309365ilv.2.1680104001919; Wed, 29 Mar
 2023 08:33:21 -0700 (PDT)
MIME-Version: 1.0
References: <16988771.uLZWGnKmhe@eq59> <6984423.44csPzL39Z@eq59>
In-Reply-To: <6984423.44csPzL39Z@eq59>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 29 Mar 2023 17:33:10 +0200
Message-ID: <CANn89iJsYLrvjms-uT0mLPiiLG-MtHMSm3dSy6QDqP0d46mSJg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] net: rps/rfs improvements
To:     Aiden Leong <aiden.leong@aibsd.com>
Cc:     davem@davemloft.net, eric.dumazet@gmail.com,
        kernelxing@tencent.com, kuba@kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-13.2 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 3:18=E2=80=AFPM Aiden Leong <aiden.leong@aibsd.com>=
 wrote:
>
> On Wednesday, March 29, 2023 9:17:06 PM CST Aiden Leong wrote:
> > Hi Eric,
> >
> > I hope my email is not too off-topic but I have some confusion on how
> > maintainers and should react to other people's work.
> >
> > In short, you are stealing Jason's idea&&work by rewriting your
> > implementation which not that ethical. Since your patch is based on his
> > work, but you only sign-off it by your name, it's possible to raise law=
suit
> > between Tencent and Linux community or Google.

Seriously ?

I really gave enough credit to Jason's work, it seems you missed it.

I am quite tired of reviewing patches, and giving ideas of how to
improve things,
then having no credits for my work.

After my feedback on v1, seeing a quite silly v2, obviously not tested,
and with no numbers shown, I wanted to see how hard the complete
implementation would be.

This needed full understanding of RPS and RFS, not only an "idea" and
wrong claims about fixing
a "bug" in the initial implementation which was just fine.

Also, results are theoretical at this stage,I added numbers in the cover le=
tter
showing the impact was tiny or not even mesurable.

I sent a series of 4 patches, Jason work on the 3rd one has been
completely documented.

If Jason managers are not able to see the credit in the patch series
(and cover letter),
this is their problem, not mine.

Also, my contributions to linux do not represent views of my employer,
this should be obvious.



> >
> > I'm here to provoke a conflict because we know your name in this area a=
nd
> > I'd to show my respect to you but I do have this kind of confusion in m=
y
> > mind and wish you could explain about it.
> >
> Typo: I'm here NOT to provoke a conflict
> > There's another story you or Tom Herbert may be interested in: I was wo=
rking
> > on Foo Over UDP and have implemented the missing features in the previo=
us
> > company I worked for. The proposal to contribute to the upstream commun=
ity
> > was rejected later by our boss for unhappy events very similar to this =
one.
> >
> > Aiden Leong
> >
> > > Jason Xing attempted to optimize napi_schedule_rps() by avoiding
> > > unneeded NET_RX_SOFTIRQ raises: [1], [2]
> > >
> > > This is quite complex to implement properly. I chose to implement
> > > the idea, and added a similar optimization in ____napi_schedule()
> > >
> > > Overall, in an intensive RPC workload, with 32 TX/RX queues with RFS
> > > I was able to observe a ~10% reduction of NET_RX_SOFTIRQ
> > > invocations.
> > >
> > > While this had no impact on throughput or cpu costs on this synthetic
> > > benchmark, we know that firing NET_RX_SOFTIRQ from softirq handler
> > > can force __do_softirq() to wakeup ksoftirqd when need_resched() is t=
rue.
> > > This can have a latency impact on stressed hosts.
> > >
> > > [1] https://lore.kernel.org/lkml/20230325152417.5403-1->
> >
> > kerneljasonxing@gmail.com/
> >
> > > [2]
> > > https://lore.kernel.org/netdev/20230328142112.12493-1-kerneljasonxing=
@gma
> > > il.com/>
> > > Eric Dumazet (4):
> > >   net: napi_schedule_rps() cleanup
> > >   net: add softnet_data.in_net_rx_action
> > >   net: optimize napi_schedule_rps()
> > >   net: optimize ____napi_schedule() to avoid extra NET_RX_SOFTIRQ
> > >
> > >  include/linux/netdevice.h |  1 +
> > >  net/core/dev.c            | 46 ++++++++++++++++++++++++++++++-------=
--
> > >  2 files changed, 37 insertions(+), 10 deletions(-)
>
