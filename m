Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB3D4FECD0
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 04:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiDMCV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 22:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiDMCV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 22:21:57 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518FE5FDC
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 19:19:37 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id p65so1254139ybp.9
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 19:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iEt50WnvqMyX2PpmT+XvhskoDCDXavnY0nAp+IM1GVA=;
        b=HCVaZPXJaLyJIRFC1svanROxtbkAsnRthsA00Uc2Mj30j4zSwLwQfPZtyO/danaREz
         QWIBp9rAoOxZMiQWiLz63MhxX0e5bISDkzdHTrN0t8Mox2LEdj0TEfKWVHFpMmUv10BB
         MC20cTHtVYpv6YqQwIkwKRbMjtM0j6GxONm/qHM6rnAonxfR3k8K/4oupcv5ehJWrg/s
         tHt5zw8SyOv79axITpLKb5JjUg1sKetyUF/PL84/E7brNe8C81jKdRaYQde3KyLtmQkq
         smA8hTLkLxqDxYs+Jjl15xmivbS9osztUF+8/wE5Fc6nV9uxGqgcxUtRPjm1/V9Nd0KB
         RMYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iEt50WnvqMyX2PpmT+XvhskoDCDXavnY0nAp+IM1GVA=;
        b=0zzM2p7j3Qa1VjDw3pceGeEYMM59tqN1QgOfeYwGhz2BOUDnCxltDa6UtYqySVtmnK
         Z9laFVB8IyLEWeWqKMMgPEFuECTz4ZyjvtpAAX7FYfS10fRlFs3WwZ/AHmDrvzkWK4iz
         so/ithjamPVryy5z/PZIfoZZH5nJHpB6N7lQFnqJg3Wcmwlio21ILOTCJX3lkf719RfF
         hJgJwxAe41WxePRGEfGZaywDwT11B8fBxokWP9ROaxEGyVsXoHm6kzKHH2N9sPF9lfKb
         JXRPzaB3fQgeu8zGmSKaFnTuZWZ0LYIGeR5SPsDpl5/cxF0Fm7XyU7tmvwrUgOeI07Zb
         McMw==
X-Gm-Message-State: AOAM5307SRDOREuCJIJ2Cnu/ck0/PTjXygvQirZJVHIhQBAC9DK4EcTD
        10Jkk33pQ11gbO5cqGbi1UBlw1tUGAX5+4T28YR65v53Xg6E7w==
X-Google-Smtp-Source: ABdhPJxu2Z9ze+PGLuIKvITdHz65Mb6k6D7wNuw7AvUgouLyaX1qN2772hqkwNOyLzinShAITdFehZ8WpPSp5wyGn4I=
X-Received: by 2002:a25:f441:0:b0:611:4f60:aab1 with SMTP id
 p1-20020a25f441000000b006114f60aab1mr28963883ybe.598.1649816376199; Tue, 12
 Apr 2022 19:19:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220412202613.234896-1-axboe@kernel.dk> <e7631a6f-b614-da4c-4f47-571a7b0149fc@gmail.com>
 <80ba97f9-3705-8fd6-8e7d-a934512d7ec0@kernel.dk> <CANn89iJRCeB2HZyy49J60KReZKwrLysffy9cmLSw6+Wd4qJy-g@mail.gmail.com>
 <d772ae66-6c0f-4083-8530-400546743ef6@kernel.dk> <CANn89i+1UJHYwDocWuaxzHoiPrJwi0WR0mELMidYBXYuPcLumg@mail.gmail.com>
 <22271a21-2999-2f2f-9270-c7233aa79c6d@kernel.dk>
In-Reply-To: <22271a21-2999-2f2f-9270-c7233aa79c6d@kernel.dk>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 12 Apr 2022 19:19:25 -0700
Message-ID: <CANn89iKXTbDJ594KN5K8u4eowpTWKdxXJ4hBQOqkuiZGcS7x0A@mail.gmail.com>
Subject: Re: [PATCHSET 0/4] Add support for no-lock sockets
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, io-uring@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Apr 12, 2022 at 7:12 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 4/12/22 8:05 PM, Eric Dumazet wrote:
> > On Tue, Apr 12, 2022 at 7:01 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 4/12/22 7:54 PM, Eric Dumazet wrote:
> >>> On Tue, Apr 12, 2022 at 6:26 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> On 4/12/22 6:40 PM, Eric Dumazet wrote:
> >>>>>
> >>>>> On 4/12/22 13:26, Jens Axboe wrote:
> >>>>>> Hi,
> >>>>>>
> >>>>>> If we accept a connection directly, eg without installing a file
> >>>>>> descriptor for it, or if we use IORING_OP_SOCKET in direct mode, then
> >>>>>> we have a socket for recv/send that we can fully serialize access to.
> >>>>>>
> >>>>>> With that in mind, we can feasibly skip locking on the socket for TCP
> >>>>>> in that case. Some of the testing I've done has shown as much as 15%
> >>>>>> of overhead in the lock_sock/release_sock part, with this change then
> >>>>>> we see none.
> >>>>>>
> >>>>>> Comments welcome!
> >>>>>>
> >>>>> How BH handlers (including TCP timers) and io_uring are going to run
> >>>>> safely ? Even if a tcp socket had one user, (private fd opened by a
> >>>>> non multi-threaded program), we would still to use the spinlock.
> >>>>
> >>>> But we don't even hold the spinlock over lock_sock() and release_sock(),
> >>>> just the mutex. And we do check for running eg the backlog on release,
> >>>> which I believe is done safely and similarly in other places too.
> >>>
> >>> So lets say TCP stack receives a packet in BH handler... it proceeds
> >>> using many tcp sock fields.
> >>>
> >>> Then io_uring wants to read/write stuff from another cpu, while BH
> >>> handler(s) is(are) not done yet,
> >>> and will happily read/change many of the same fields
> >>
> >> But how is that currently protected?
> >
> > It is protected by current code.
> >
> > What you wrote would break TCP stack quite badly.
>
> No offense, but your explanations are severely lacking. By "current
> code"? So what you're saying is that it's protected by how the code
> currently works? From how that it currently is? Yeah, that surely
> explains it.
>
> > I suggest you setup/run a syzbot server/farm, then you will have a
> > hundred reports quite easily.
>
> Nowhere am I claiming this is currently perfect, and it should have had
> an RFC on it. Was hoping for some constructive criticism on how to move
> this forward, as high frequency TCP currently _sucks_ in the stack.
> Instead I get useless replies, not very encouraging.
>
> I've run this quite extensively on just basic send/receive over sockets,
> so it's not like it hasn't been run at all. And it's been fine so far,
> no ill effects observed. If we need to tighten down the locking, perhaps
> a valid use would be to simply skip the mutex and retain the bh lock for
> setting owner. As far as I can tell, should still be safe to skip on
> release, except if we need to process the backlog. And it'd serialize
> the owner setting with the BH, which seems to be your main objection in.
> Mostly guessing here, based on the in-depth replies.
>
> But it'd be nice if we could have a more constructive dialogue about
> this, rather than the weird dismisiveness.
>
>

Sure. It would be nice that I have not received such a patch series
the day I am sick.

Jakub, David, Paolo, please provide details to Jens, thanks.
