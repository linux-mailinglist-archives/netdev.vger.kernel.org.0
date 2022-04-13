Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16804FEC9E
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 03:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbiDMB5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 21:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiDMB5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 21:57:13 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DCB19C3D
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 18:54:53 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-2ec04a2ebadso6820557b3.12
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 18:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gyK+tGWNxOJuJzppEib2DQHvN0JkXZ8FD8J9aYbMf6I=;
        b=UllgAn666o261DEV7ZgNwRIT4RqRabRgXD+G9A8tnjP4qOrcBzuvTBOT19nJbxjvcz
         5LELUkx7zC6VbmlOeZGaG+GaCQAIaRllZGmUNzkGqi7Uu9L9aj6ONyFGquG+9FMpBi5u
         XnWwtzYpxHAIpByEWlYTLwPjmXI4d6DJ/5l4UYgTs/GxHDZKvFL5Sep95bHR/6crAmKU
         AM6BKyD9wn8FkiQ4xgo1d11hMXE9IC+sP8kc/lieJtzAfy96PQTXl+Fub4ZjemXNjGaD
         vxFuDZF0m+uCIxTHXQppRQ96eHJbgxObn9hTFjv7ejYbzkpyWz0gDLWnpaIKLZPaQKnL
         RzmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gyK+tGWNxOJuJzppEib2DQHvN0JkXZ8FD8J9aYbMf6I=;
        b=Eb+4ZcxXFkq28Tj7YgNpdocUlymLMLNOhATjLM7UYdDdETjnhEKGxAJZfraWcSYq78
         cuIPi5CcameFs+fGS/PU0gHjdCRFCw6zwlXPPAt+yCgFUFMRrZwYxTQoX/X6XbhG+wj3
         +alc8btuiFE0myztRvEEqmsG4N5RrLYP6aTCFIyCpEsKp76ziqx/LYQEu4Z5Hv2bf6XZ
         wInnnUhMZKYP+XiqMw3WBqIHPKBKQBJKsEso3p9DNIIN38ieabHSyKv/aPBqccADKXkZ
         Own08lwPzVVwRg5P1X+STMUXCaLH2CkZ9C7NuwfBEmwEr2mV/Wm6NNDYbUcQgxIM0yP5
         S8zA==
X-Gm-Message-State: AOAM533iiu7CqlQ8+ee9uVK6dN6NoX2hXIurUp+2eP2+EFZC73Cot1HJ
        9BrL2Qw6ogX023r4ZZ+GWjlXO1/A4cXaC9qcISn9yLZy5GrA8A==
X-Google-Smtp-Source: ABdhPJwjuO0c397jUWUr68aKPwjqIlAgQjuQBYGyxfSeqE/B6EkoJoZ3dioG0f9MiDkXtG+kCgX83UYw26twuHZiR3s=
X-Received: by 2002:a81:5409:0:b0:2eb:fea4:a240 with SMTP id
 i9-20020a815409000000b002ebfea4a240mr13795146ywb.47.1649814892486; Tue, 12
 Apr 2022 18:54:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220412202613.234896-1-axboe@kernel.dk> <e7631a6f-b614-da4c-4f47-571a7b0149fc@gmail.com>
 <80ba97f9-3705-8fd6-8e7d-a934512d7ec0@kernel.dk>
In-Reply-To: <80ba97f9-3705-8fd6-8e7d-a934512d7ec0@kernel.dk>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 12 Apr 2022 18:54:41 -0700
Message-ID: <CANn89iJRCeB2HZyy49J60KReZKwrLysffy9cmLSw6+Wd4qJy-g@mail.gmail.com>
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

On Tue, Apr 12, 2022 at 6:26 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 4/12/22 6:40 PM, Eric Dumazet wrote:
> >
> > On 4/12/22 13:26, Jens Axboe wrote:
> >> Hi,
> >>
> >> If we accept a connection directly, eg without installing a file
> >> descriptor for it, or if we use IORING_OP_SOCKET in direct mode, then
> >> we have a socket for recv/send that we can fully serialize access to.
> >>
> >> With that in mind, we can feasibly skip locking on the socket for TCP
> >> in that case. Some of the testing I've done has shown as much as 15%
> >> of overhead in the lock_sock/release_sock part, with this change then
> >> we see none.
> >>
> >> Comments welcome!
> >>
> > How BH handlers (including TCP timers) and io_uring are going to run
> > safely ? Even if a tcp socket had one user, (private fd opened by a
> > non multi-threaded program), we would still to use the spinlock.
>
> But we don't even hold the spinlock over lock_sock() and release_sock(),
> just the mutex. And we do check for running eg the backlog on release,
> which I believe is done safely and similarly in other places too.

So lets say TCP stack receives a packet in BH handler... it proceeds
using many tcp sock fields.

Then io_uring wants to read/write stuff from another cpu, while BH
handler(s) is(are) not done yet,
and will happily read/change many of the same fields

Writing a 1 and a 0 in a bit field to ensure mutual exclusion is not
going to work,
even with the smp_rmb() and smp_wmb() you added (adding more costs for
non io_uring users
which already pay a high lock tax)

If we want to optimize the lock_sock()/release_sock() for common cases
(a single user thread per TCP socket),
then maybe we can play games with some kind of cmpxchg() games, but
that would be a generic change.
