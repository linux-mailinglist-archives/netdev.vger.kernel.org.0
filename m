Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1562C6E7964
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 14:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbjDSMJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 08:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbjDSMJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 08:09:34 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A860F1563D
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 05:09:32 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-760f8ffb27fso68756939f.2
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 05:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681906172; x=1684498172;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ckZBqBNPcwiApkuDGy++lBTpdqH0T8qE8BpS9xSvzE=;
        b=SlT8Dh7vH2OWYjB2Xeg0YKs3ZixdVUECcSdkThnFtzQKjXIdsaRd9tzPSu+iHpcL6m
         d5ZipcAcGArqlLTPIeWY7YMl87QSt+vJF3pq1lHZJNz06h+fH5BSSFt8zKsi7oZayP9n
         h4g0OKNPRPIG63o0TGbWpi6oMgHbo9TFJbcPTvxqWn5+UyAOAow6lKILJY6YVUp8EbiD
         W/DBcnP3Wt0suN4CcJsjRkR0uVqg7xR2KO6wJmv6CkKpZQ7QDZUokh6numiuhncwm85R
         gjqj3B903m1crGyGkAGLhF4xGhiqyfjDXCXv17R4kwhW6EC/WmXqb9gmT7dTt5eqx4gV
         hKxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681906172; x=1684498172;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8ckZBqBNPcwiApkuDGy++lBTpdqH0T8qE8BpS9xSvzE=;
        b=XzyjCKb1KEPck2GFKA8yOeknuLRco4ikFMActQDeWNe9Ma1BfVs5VQv1fu0vqL1bfP
         arm5E+dZZbkKVCFah+odG3ss7mf9CBtyCV+pAuvPW43f3OpoAtTyQfuRuvEZUhKKsMsq
         lHdbW2e0PMz+Ozw12w9M/HZ6X/0aNFQ47gbZGw3YAZB++JBMvP+MCNAxOuteYNGm/obU
         BcYaNvAb37I4u/O0ZodpNv+7b76crJyUUT3kJvBNxQPysOmd0pV8+XkrE2hDbQ8qsdnG
         5lFINQVFzxhrcQHnxMH6XUDbHrzu44d1iHD5sq61bytH6/d1f9QZVkURNPPjwHZgBL8+
         YIZA==
X-Gm-Message-State: AAQBX9c4SSXBg80goJjtrYE20/KJZhYpKQqwfCRQMdRTocDvdsxZEzPU
        g4NQIg566AJuPliy4tXT4c01pd32kknpO6Oy+W4IBg==
X-Google-Smtp-Source: AKy350YQVqB1aBzXqR4YZcUJjMUghAu+Vvd8MhYV+ubnQm2Qq0RhbILtHV1KCGIrjxxez6iwhFwqmUQJePT7GAx/L4w=
X-Received: by 2002:a6b:6519:0:b0:760:e308:1070 with SMTP id
 z25-20020a6b6519000000b00760e3081070mr3591853iob.0.1681906171752; Wed, 19 Apr
 2023 05:09:31 -0700 (PDT)
MIME-Version: 1.0
References: <ZD2HjZZSOjtsnQaf@lore-desk> <CANn89iK7P2aONo0EB9o+YiRG+9VfqqVVra4cd14m_Vo4hcGVnQ@mail.gmail.com>
 <ZD2NSSYFzNeN68NO@lore-desk> <20230417112346.546dbe57@kernel.org>
 <ZD2TH4PsmSNayhfs@lore-desk> <20230417120837.6f1e0ef6@kernel.org>
 <ZD26lb2qdsdX16qa@lore-desk> <20230417163210.2433ae40@kernel.org>
 <ZD5IcgN5s9lCqIgl@lore-desk> <3449df3e-1133-3971-06bb-62dd0357de40@redhat.com>
In-Reply-To: <3449df3e-1133-3971-06bb-62dd0357de40@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 19 Apr 2023 14:09:20 +0200
Message-ID: <CANn89iKAVERmJjTyscwjRTjTeWBUgA9COz+8HVH09Q0ehHL9Gw@mail.gmail.com>
Subject: Re: issue with inflight pages from page_pool
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, brouer@redhat.com,
        netdev@vger.kernel.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net,
        pabeni@redhat.com, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, nbd@nbd.name
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 1:08=E2=80=AFPM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 18/04/2023 09.36, Lorenzo Bianconi wrote:
> >> On Mon, 17 Apr 2023 23:31:01 +0200 Lorenzo Bianconi wrote:
> >>>> If it's that then I'm with Eric. There are many ways to keep the pag=
es
> >>>> in use, no point working around one of them and not the rest :(
> >>>
> >>> I was not clear here, my fault. What I mean is I can see the returned
> >>> pages counter increasing from time to time, but during most of tests,
> >>> even after 2h the tcp traffic has stopped, page_pool_release_retry()
> >>> still complains not all the pages are returned to the pool and so the
> >>> pool has not been deallocated yet.
> >>> The chunk of code in my first email is just to demonstrate the issue
> >>> and I am completely fine to get a better solution :)
> >>
> >> Your problem is perhaps made worse by threaded NAPI, you have
> >> defer-free skbs sprayed across all cores and no NAPI there to
> >> flush them :(
> >
> > yes, exactly :)
> >
> >>
> >>> I guess we just need a way to free the pool in a reasonable amount
> >>> of time. Agree?
> >>
> >> Whether we need to guarantee the release is the real question.
> >
> > yes, this is the main goal of my email. The defer-free skbs behaviour s=
eems in
> > contrast with the page_pool pending pages monitor mechanism or at least=
 they
> > do not work well together.
> >
> > @Jesper, Ilias: any input on it?
> >
> >> Maybe it's more of a false-positive warning.
> >>
> >> Flushing the defer list is probably fine as a hack, but it's not
> >> a full fix as Eric explained. False positive can still happen.
> >
> > agree, it was just a way to give an idea of the issue, not a proper sol=
ution.
> >
> > Regards,
> > Lorenzo
> >
> >>
> >> I'm ambivalent. My only real request wold be to make the flushing
> >> a helper in net/core/dev.c rather than open coded in page_pool.c.
>
> I agree. We need a central defer_list flushing helper
>
> It is too easy to say this is a false-positive warning.
> IHMO this expose an issue with the sd->defer_list system.
>
> Lorenzo's test is adding+removing veth devices, which creates and runs
> NAPI processing on random CPUs.  After veth netdevices (+NAPI) are
> removed, nothing will naturally invoking net_rx_softirq on this CPU.
> Thus, we have SKBs waiting on CPUs sd->defer_list.  Further more we will
> not create new SKB with this skb->alloc_cpu, to trigger RX softirq IPI
> call (trigger_rx_softirq), even if this CPU process and frees SKBs.
>
> I see two solutions:
>
>   (1) When netdevice/NAPI unregister happens call defer_list flushing
> helper.
>
>   (2) Use napi_watchdog to detect if defer_list is (many jiffies) old,
> and then call defer_list flushing helper.
>
>
> >>
> >> Somewhat related - Eric, do we need to handle defer_list in dev_cpu_de=
ad()?
>
> Looks to me like dev_cpu_dead() also need this flushing helper for
> sd->defer_list, or at least moving the sd->defer_list to an sd that will
> run eventually.

I think I just considered having a few skbs in per-cpu list would not
be an issue,
especially considering skbs can sit hours in tcp receive queues.

Do we expect hacing some kind of callback/shrinker to instruct TCP or
pipes to release all pages that prevent
a page_pool to be freed ?

Here, we are talking of hundreds of thousands of skbs, compared to at
most 32 skbs per cpu.

Perhaps sets sysctl_skb_defer_max to zero by default, so that admins can op=
t-in
