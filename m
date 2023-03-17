Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E646BE00C
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 05:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjCQEMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 00:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjCQEMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 00:12:34 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF3CB53D1;
        Thu, 16 Mar 2023 21:12:24 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id y4so15722996edo.2;
        Thu, 16 Mar 2023 21:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679026343;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=giozrppmQGvIJnqKlf1V3xQulc9ozu7sh9Rg2MJQqLg=;
        b=Ohj1y9psHnR6QV7+n59LaOcN62gVh3auSOJyJbdCYbRwye0x1diEn7e2ytsTaVr92b
         mmMVARfZD+9usQCo+jSZ2F1g7qzG3tvhuGqzkipCsCa9PA+kqwl6wIBvabqfKLqodkGT
         B88Vr8fFdC2CYtAFXg6ErQ+bN664nj5uNIsQ693icn4IEaLVEhXyu4qbaFQ1Ct6t3AR3
         LJcaL5Qj1J5YYAbHS/skjSpvUPOln4bUYn/myU3R9mcropESGmmwHYxHbC4fWOUXX/hi
         GfQXwCinml+/jppbYpI6zhuE/sfqkPtHzm0VqXnKeBaM702/Y1krZwz4DLQFCrc/guBR
         /GSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679026343;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=giozrppmQGvIJnqKlf1V3xQulc9ozu7sh9Rg2MJQqLg=;
        b=qez8A1pLhZzX++t3rGq4zx5rxl1PRhgjThXorwp3Sdd9fHlOmHyapKHOWg33GSsFEJ
         uFC5U2fQcHeiFEq0VbPYBvyWKZFs2Kwlgh8oJARFBwLA4wVOPeXKJsrn31esYOwwj5FS
         6z2MbUV8HtCvjIAZwdqlw/zkmeDoOajQpQsdzxYEdXid1f5UTBnogAshllUyKw8HRuaT
         4FFvt4fZ9fS3s61tDa+SyhH/OGpUBvzZ3hs5zyIWqKx2MK2TEZMfRaQnFpx616u8hdhX
         lBE0k5gUK+aayJxdZFSOfqh6SHATfrEadMXaZOYXSWS33CJ+nnuGKTeSt7/pkQ4/FduS
         uV2A==
X-Gm-Message-State: AO0yUKVr6DgAj3RuJUgi1LxJKAFne/yVaKyZ2mCYXg+bJonxjECt5YF0
        y0aTMiXKwmVuGnkgD9mrftN5XPieacZE3/RrFBU=
X-Google-Smtp-Source: AK7set/Fb92trBMPfzVcZu4Bdv3SiIJo8Ews5QR4uY4wx+9gMqOQoN7+a7PZAhKKJsA0ybqqNqk6lT99ZzzzpF5IOAI=
X-Received: by 2002:a17:906:3e4f:b0:92a:a75e:6b9 with SMTP id
 t15-20020a1709063e4f00b0092aa75e06b9mr5773109eji.11.1679026343097; Thu, 16
 Mar 2023 21:12:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230315092041.35482-1-kerneljasonxing@gmail.com>
 <20230315092041.35482-3-kerneljasonxing@gmail.com> <20230316172020.5af40fe8@kernel.org>
 <CAL+tcoDNvMUenwNEH2QByEY7cS1qycTSw1TLFSnNKt4Q0dCJUw@mail.gmail.com> <20230316202648.1f8c2f80@kernel.org>
In-Reply-To: <20230316202648.1f8c2f80@kernel.org>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Fri, 17 Mar 2023 12:11:46 +0800
Message-ID: <CAL+tcoD+BoXsEBS5T_kvuUzDTuF3N7kO1eLqwNP3Wy6hps+BBA@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 2/2] net: introduce budget_squeeze to help us
 tune rx behavior
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jbrouer@redhat.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 11:26=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> On Fri, 17 Mar 2023 10:27:11 +0800 Jason Xing wrote:
> > > That is the common case, and can be understood from the napi trace
> >
> > Thanks for your reply. It is commonly happening every day on many serve=
rs.
>
> Right but the common issue is the time squeeze, not budget squeeze,

Most of them are about time, so yes.

> and either way the budget squeeze doesn't really matter because
> the softirq loop will call us again soon, if softirq itself is
> not scheduled out.
>
> So if you want to monitor a meaningful event in your fleet, I think
> a better event to monitor is the number of times ksoftirqd was woken
> up and latency of it getting onto the CPU.

It's a good point. Thanks for your advice.

>
> Did you try to measure that?
>
> (Please do *not* send patches to touch softirq code right now, just
> measure first. We are trying to improve the situation but the core
> kernel maintainers are weary of changes:
> https://lwn.net/Articles/925540/
> so if both of us start sending code they will probably take neither
> patches :()

I understand. One more thing I would like to know is about the state
of 1/2 patch.

Thanks,
Jason

>
> > > point and probing the kernel with bpftrace. We should only add
> >
> > We probably can deduce (or guess) which one causes the latency because
> > trace_napi_poll() only counts the budget consumed per poll.
> >
> > Besides, tracing napi poll is totally ok with the testbed but not ok
> > with those servers with heavy load which bpftrace related tools
> > capturing the data from the hot path may cause some bad impact,
> > especially with special cards equipped, say, 100G nic card. Resorting
> > to legacy file softnet_stat is relatively feasible based on my limited
> > knowledge.
>
> Right, but we're still measuring something relatively irrelevant.
> As I said the softirq loop will call us again. In my experience
> network queues get long when ksoftirqd is woken up but not scheduled
> for a long time. That is the source of latency. You may have the same
> problem (high latency) without consuming the entire budget.
>
> I think if we wanna make new stats we should try to come up with a way
> of capturing the problem rather than one of the symptoms.
>
> > Paolo also added backlog queues into this file in 2020 (see commit:
> > 7d58e6555870d). I believe that after this patch, there are few or no
> > more new data that is needed to print for the next few years.
> >
> > > uAPI for statistics which must be maintained contiguously. For
> >
> > In this patch, I didn't touch the old data as suggested in the
> > previous emails and only separated the old way of counting
> > @time_squeeze into two parts (time_squeeze and budget_squeeze). Using
> > budget_squeeze can help us profile the server and tune it more
> > usefully.
> >
> > > investigations tracing will always be orders of magnitude more
> > > powerful :(
> >
> > > On the time squeeze BTW, have you found out what the problem was?
> > > In workloads I've seen the time problems are often because of noise
> > > in how jiffies are accounted (cgroup code disables interrupts
> > > for long periods of time, for example, making jiffies increment
> > > by 2, 3 or 4 rather than by 1).
> >
> > Yes ! The issue of jiffies increment troubles those servers more often
> > than not. For a small group of servers, budget limit is also a
> > problem. Sometimes we might treat guest OS differently.
