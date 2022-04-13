Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58DD74FECFA
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 04:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbiDMCfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 22:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbiDMCfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 22:35:09 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6B52C679
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 19:32:41 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2eafabbc80aso7468467b3.11
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 19:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ma77ylQKCizZljJ1CvV82Vgnc28vN2dV/+jsya+gHq0=;
        b=Z+3UwCGBNfj67xq3r1fwemmU+CiLF2vEQ5Zfx20jjo5cTCAoTnXSbBoc+sIpWYCHG3
         dLJrkR0nPfKhryKDm3F/YkjmI/1m45ZmqP4FY9IWqE2SOZMKjpRZ55t65Ak9GqoAikSK
         fKNcnPoECc28yr9UWU3NgfWXd1y4+Y3atVKtQG00oagfT07kQ2jc3leKl2uqfujWRs9N
         4F8pd3wToxvB7EHm9l312bDdM4pANoXJd0U1DanN0+8nfaKwePFOaUB6jnkDtdkqIi6+
         RzKsjp1ZaIAnRr8F+owYurxaucgxhivjJG3CeNnGf9Ro/OTioiZGZyWj2OQNjvT/huJM
         AoDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ma77ylQKCizZljJ1CvV82Vgnc28vN2dV/+jsya+gHq0=;
        b=U6dhAE2IW2ttps7Aw33CFbva18mgo/gnBTLDop5oxeuTIloGbS2GWqIAKuSY25Wstc
         agGz3Lbfpwi0eJQExykqYsnpsDebX/DpfzYpsWPNQ7ZM8O63D+/UngIw0FjqBW7oOSZp
         JBrBmJc/W6qZJx+oKsEZXskz5AvleOS64x4jKSh53TPiKmCWer+6lPHv79ogcZVmLDoM
         vtr3XH5LhoFYaUt7qg0ihWOxAhmCQ2CAcRRwDpWbh8hV80f1aczUm+o/vslRI4q1CE1T
         aJHKbS6EdyVA7qHh+QJXVfoDYvqm6basaezyd/9gGwRXotql05XQitUh3FOiyQBm4ZUq
         I5Kg==
X-Gm-Message-State: AOAM532jVeB2hbnLbH6bst58jGD5T8KQ1KSz68xvfoxPgQ8cpTdpzZks
        4wP4DNMCg6ctOOs/7TNfgkBYLnkmL9b2QZQAvf1WCA==
X-Google-Smtp-Source: ABdhPJxYCmAInlyWgTWXdVR6mOlcf6O+EVCm22ceBgCNafMWHsKzyBqVpQJOmd4kBoJlPrzlFtWuktWPTLSd47786x8=
X-Received: by 2002:a0d:cb86:0:b0:2ec:894:aa51 with SMTP id
 n128-20020a0dcb86000000b002ec0894aa51mr12013846ywd.467.1649817160016; Tue, 12
 Apr 2022 19:32:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220412202613.234896-1-axboe@kernel.dk> <e7631a6f-b614-da4c-4f47-571a7b0149fc@gmail.com>
 <80ba97f9-3705-8fd6-8e7d-a934512d7ec0@kernel.dk> <CANn89iJRCeB2HZyy49J60KReZKwrLysffy9cmLSw6+Wd4qJy-g@mail.gmail.com>
 <d772ae66-6c0f-4083-8530-400546743ef6@kernel.dk> <CANn89i+1UJHYwDocWuaxzHoiPrJwi0WR0mELMidYBXYuPcLumg@mail.gmail.com>
 <22271a21-2999-2f2f-9270-c7233aa79c6d@kernel.dk> <CANn89iKXTbDJ594KN5K8u4eowpTWKdxXJ4hBQOqkuiZGcS7x0A@mail.gmail.com>
 <d39a2713-9172-3dd6-4a37-dad178a5bb57@kernel.dk>
In-Reply-To: <d39a2713-9172-3dd6-4a37-dad178a5bb57@kernel.dk>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 12 Apr 2022 19:32:29 -0700
Message-ID: <CANn89iKVtHLNUMRPP276-w31usKwWnFhQp04W1CbD-TqOnRAiw@mail.gmail.com>
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

On Tue, Apr 12, 2022 at 7:27 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 4/12/22 8:19 PM, Eric Dumazet wrote:
> > On Tue, Apr 12, 2022 at 7:12 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 4/12/22 8:05 PM, Eric Dumazet wrote:
> >>> On Tue, Apr 12, 2022 at 7:01 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> On 4/12/22 7:54 PM, Eric Dumazet wrote:
> >>>>> On Tue, Apr 12, 2022 at 6:26 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>>
> >>>>>> On 4/12/22 6:40 PM, Eric Dumazet wrote:
> >>>>>>>
> >>>>>>> On 4/12/22 13:26, Jens Axboe wrote:
> >>>>>>>> Hi,
> >>>>>>>>
> >>>>>>>> If we accept a connection directly, eg without installing a file
> >>>>>>>> descriptor for it, or if we use IORING_OP_SOCKET in direct mode, then
> >>>>>>>> we have a socket for recv/send that we can fully serialize access to.
> >>>>>>>>
> >>>>>>>> With that in mind, we can feasibly skip locking on the socket for TCP
> >>>>>>>> in that case. Some of the testing I've done has shown as much as 15%
> >>>>>>>> of overhead in the lock_sock/release_sock part, with this change then
> >>>>>>>> we see none.
> >>>>>>>>
> >>>>>>>> Comments welcome!
> >>>>>>>>
> >>>>>>> How BH handlers (including TCP timers) and io_uring are going to run
> >>>>>>> safely ? Even if a tcp socket had one user, (private fd opened by a
> >>>>>>> non multi-threaded program), we would still to use the spinlock.
> >>>>>>
> >>>>>> But we don't even hold the spinlock over lock_sock() and release_sock(),
> >>>>>> just the mutex. And we do check for running eg the backlog on release,
> >>>>>> which I believe is done safely and similarly in other places too.
> >>>>>
> >>>>> So lets say TCP stack receives a packet in BH handler... it proceeds
> >>>>> using many tcp sock fields.
> >>>>>
> >>>>> Then io_uring wants to read/write stuff from another cpu, while BH
> >>>>> handler(s) is(are) not done yet,
> >>>>> and will happily read/change many of the same fields
> >>>>
> >>>> But how is that currently protected?
> >>>
> >>> It is protected by current code.
> >>>
> >>> What you wrote would break TCP stack quite badly.
> >>
> >> No offense, but your explanations are severely lacking. By "current
> >> code"? So what you're saying is that it's protected by how the code
> >> currently works? From how that it currently is? Yeah, that surely
> >> explains it.
> >>
> >>> I suggest you setup/run a syzbot server/farm, then you will have a
> >>> hundred reports quite easily.
> >>
> >> Nowhere am I claiming this is currently perfect, and it should have had
> >> an RFC on it. Was hoping for some constructive criticism on how to move
> >> this forward, as high frequency TCP currently _sucks_ in the stack.
> >> Instead I get useless replies, not very encouraging.
> >>
> >> I've run this quite extensively on just basic send/receive over sockets,
> >> so it's not like it hasn't been run at all. And it's been fine so far,
> >> no ill effects observed. If we need to tighten down the locking, perhaps
> >> a valid use would be to simply skip the mutex and retain the bh lock for
> >> setting owner. As far as I can tell, should still be safe to skip on
> >> release, except if we need to process the backlog. And it'd serialize
> >> the owner setting with the BH, which seems to be your main objection in.
> >> Mostly guessing here, based on the in-depth replies.
> >>
> >> But it'd be nice if we could have a more constructive dialogue about
> >> this, rather than the weird dismisiveness.
> >>
> >>
> >
> > Sure. It would be nice that I have not received such a patch series
> > the day I am sick.
>
> I'm sorry that you are sick - but if you are not in a state to reply,
> then please just don't. It sets a bad example. It was sent to the list,
> not to you personally.

I tried to be as constructive as possible, and Jakub pinged me about
this series,
so I really thought Jakub was okay with it.

So I am a bit concerned.

>
> Don't check email then, putting the blame on ME for posting a patchset
> while you are sick is uncalled for and rude. If I had a crystal ball, I
> would not be spending my time working on the kernel. You know what
> would've been a better idea? Replying that you are sick and that you are
> sorry for being an ass on the mailing list.

Wow.


>
> > Jakub, David, Paolo, please provide details to Jens, thanks.
>
> There's no rush here fwiw - I'm heading out on PTO rest of the week,
> so we can pick this back up when I get back. I'll check in on emails,
> but activity will be sparse.
>
> --
> Jens Axboe
>
