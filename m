Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7C74FECB5
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 04:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbiDMCIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 22:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiDMCIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 22:08:04 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D9AE0C6
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 19:05:45 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id g34so1282679ybj.1
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 19:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NV+QfS8y28XOc4f2xed2muSYcMoR55shLORVP+GA49o=;
        b=E48TrOp3HUTMTF01OWlHOl6FRhypm++Y4dMOdYb+GT7lkmqALmx5hwtDTxK3LgCsIo
         MQOjj/cCn6bLAW4ZxFgS7dftBQq3eFR2usoPc5+oTu7NWvFQ6GdXqOZv9VK8y1RsHGJP
         ZgLBC91YP4AAhyeR0TWIjfym6i9PerTvjm6NW3KyhLAzxP6CzEVF9i94BOmWUO5iQ+jA
         MsoEkhCVwuuljL5ujHsmWAZ91a4KdrzS355QbCywLNUYECeKZqDsLvXgsYk9G9dBWfzk
         spCtHCfrBUkT+Vp/l/BT8HfyxL1Uqt1sK/AeVBsPcnGVptMsTHF/42eEBqXuviuFRIzT
         gRKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NV+QfS8y28XOc4f2xed2muSYcMoR55shLORVP+GA49o=;
        b=ps00TGfVlypEF55gKDAGmi8ytL/mxxICJDJUvY3fcVOssNHoJdm1coCC/Z8x3CQ4Px
         RK2S9RCJJk9ARUAL/gCSj8EzZI350Ui5FJ4qc3yRLg0gVgFJcouBTkjmT2bRp67oZwN/
         zTlMMD8lsx2a6yoOeGlKpgn0DD1s34NXxR0Aa8a3qcbQWVD1F9pf/PdNgSMCOmhD6L9F
         vvtfkqrz2U2Q4NdFYTEUWt4yErDUwwZ2ZlZO0Ity3K/DMV8qWilYJKOljDtn8RG8royO
         SrLrHvXa29AhjE7dKGUktpv5G1+MlIeVamU9ZRdy4MLx9GU1Hs4jPbcqyeHiY4lCDlp/
         wxoQ==
X-Gm-Message-State: AOAM533z+LoTV2udcTzNWJHWmkcZtfQaISgZ7yG39GiyNAwWVOvSteDf
        5g7xgH+HF5k1rm/uOmZV7JlYrX5Hmrg+/2/B009QtA==
X-Google-Smtp-Source: ABdhPJxHwU7/gOq+CaGoMDhJLQLFU6kopbIOxaR0tSDXpjIN9U2HNDzoCix/aXghoKHrCV8pPoeT7C4JU2u2m+RM5zo=
X-Received: by 2002:a05:6902:708:b0:63d:dcb0:c73e with SMTP id
 k8-20020a056902070800b0063ddcb0c73emr32601146ybt.231.1649815544067; Tue, 12
 Apr 2022 19:05:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220412202613.234896-1-axboe@kernel.dk> <e7631a6f-b614-da4c-4f47-571a7b0149fc@gmail.com>
 <80ba97f9-3705-8fd6-8e7d-a934512d7ec0@kernel.dk> <CANn89iJRCeB2HZyy49J60KReZKwrLysffy9cmLSw6+Wd4qJy-g@mail.gmail.com>
 <d772ae66-6c0f-4083-8530-400546743ef6@kernel.dk>
In-Reply-To: <d772ae66-6c0f-4083-8530-400546743ef6@kernel.dk>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 12 Apr 2022 19:05:33 -0700
Message-ID: <CANn89i+1UJHYwDocWuaxzHoiPrJwi0WR0mELMidYBXYuPcLumg@mail.gmail.com>
Subject: Re: [PATCHSET 0/4] Add support for no-lock sockets
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, io-uring@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 7:01 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 4/12/22 7:54 PM, Eric Dumazet wrote:
> > On Tue, Apr 12, 2022 at 6:26 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 4/12/22 6:40 PM, Eric Dumazet wrote:
> >>>
> >>> On 4/12/22 13:26, Jens Axboe wrote:
> >>>> Hi,
> >>>>
> >>>> If we accept a connection directly, eg without installing a file
> >>>> descriptor for it, or if we use IORING_OP_SOCKET in direct mode, then
> >>>> we have a socket for recv/send that we can fully serialize access to.
> >>>>
> >>>> With that in mind, we can feasibly skip locking on the socket for TCP
> >>>> in that case. Some of the testing I've done has shown as much as 15%
> >>>> of overhead in the lock_sock/release_sock part, with this change then
> >>>> we see none.
> >>>>
> >>>> Comments welcome!
> >>>>
> >>> How BH handlers (including TCP timers) and io_uring are going to run
> >>> safely ? Even if a tcp socket had one user, (private fd opened by a
> >>> non multi-threaded program), we would still to use the spinlock.
> >>
> >> But we don't even hold the spinlock over lock_sock() and release_sock(),
> >> just the mutex. And we do check for running eg the backlog on release,
> >> which I believe is done safely and similarly in other places too.
> >
> > So lets say TCP stack receives a packet in BH handler... it proceeds
> > using many tcp sock fields.
> >
> > Then io_uring wants to read/write stuff from another cpu, while BH
> > handler(s) is(are) not done yet,
> > and will happily read/change many of the same fields
>
> But how is that currently protected?

It is protected by current code.

What you wrote would break TCP stack quite badly.

I suggest you setup/run a syzbot server/farm, then you will have a
hundred reports quite easily.


 The bh spinlock is only held
> briefly while locking the socket, and ditto on the relase.

The 'briefly' is exactly what is needed to ensure exclusion between BH
and the user thread.

Yes, this is unfortunate but this is what it is.

 Outside of
> that, the owner field is used. At least as far as I can tell. I'm
> assuming the mutex exists solely to serialize acess to eg send/recv on
> the system call side.
>
> Hence if we can just make the owner check/set sane, then it would seem
> to be that it'd work just fine. Unless I'm still missing something here.
>
> > Writing a 1 and a 0 in a bit field to ensure mutual exclusion is not
> > going to work,
> > even with the smp_rmb() and smp_wmb() you added (adding more costs for
> > non io_uring users
> > which already pay a high lock tax)
>
> Right, that's what the set was supposed to improve :-)
>
> In all fairness, the rmb/wmb doesn't even measure compared to the
> current socket locking, so I highly doubt that any high frequency TCP
> would notice _any_ difference there. It's dwarfed by fiddling the mutex
> and spinlock already.
>
> But I agree, it may not be 100% bullet proof. May need actual bitops to
> be totally safe. Outside of that, I'm still failing to see what kind of
> mutual exclusion exists between BH handlers and a system call doing a
> send or receive on the socket.
>
> > If we want to optimize the lock_sock()/release_sock() for common cases
> > (a single user thread per TCP socket),
> > then maybe we can play games with some kind of cmpxchg() games, but
> > that would be a generic change.
>
> Sure, not disagreeing on that, but you'd supposedly still need the mutex
> to serialize send or receives on the socket for those cases.
>
> --
> Jens Axboe
>
