Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0566443CA
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235167AbiLFNAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235099AbiLFNAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:00:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333582B62C;
        Tue,  6 Dec 2022 04:59:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C392B616F9;
        Tue,  6 Dec 2022 12:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF22C433C1;
        Tue,  6 Dec 2022 12:59:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="WzIqeR0x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1670331584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZNUzYjUW6V3f6PQmilZnZflLBsJyR+1UzQ8srN624zM=;
        b=WzIqeR0x3SP/rDucMSwPkfclZ+IrtFSGEkcT7IYMUQLS/dJnTsPjU9cSqXp4SdHjy5+vZe
        PJm3aZGqMl1btR//EPVqf972fnDpKyJOzEntU8Cg+sHrNHUeYzTJwoygLJW+iS8zzf/yAq
        MxKEEv9+aNgGU0mB2/Z87gKmO72+QmI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 948cecd0 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 6 Dec 2022 12:59:43 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id 189so18439769ybe.8;
        Tue, 06 Dec 2022 04:59:43 -0800 (PST)
X-Gm-Message-State: ANoB5pnAzmcEJdODEEfYf2+Ud8Krrm2GQB98ClEN9wrslKR4ApFbGvTm
        MyoZZcPsDQqV8Wsib97BtfU+S19NxcuBgcVelbw=
X-Google-Smtp-Source: AA0mqf5PgdyHvYKtmLmiy3GxoC+5azt9FTkeTfLeiK3M263s02W0opjgv+CiZzTuRFuYZS931Vca8NSiF6HxoBwggVs=
X-Received: by 2002:a25:d4f:0:b0:703:8a9c:fd with SMTP id 76-20020a250d4f000000b007038a9c00fdmr1846744ybn.231.1670331582891;
 Tue, 06 Dec 2022 04:59:42 -0800 (PST)
MIME-Version: 1.0
References: <20221205181534.612702-1-Jason@zx2c4.com> <730fd355-ad86-a8fa-6583-df23d39e0c23@iogearbox.net>
 <Y451ENAK7BQQDJc/@zx2c4.com> <87lenku265.fsf@toke.dk>
In-Reply-To: <87lenku265.fsf@toke.dk>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 6 Dec 2022 13:59:31 +0100
X-Gmail-Original-Message-ID: <CAHmME9poicgpHhXJ1ieWbDTFBu=ApSFaQKShhHezDmA0A5ajKQ@mail.gmail.com>
Message-ID: <CAHmME9poicgpHhXJ1ieWbDTFBu=ApSFaQKShhHezDmA0A5ajKQ@mail.gmail.com>
Subject: Re: [PATCH] bpf: call get_random_u32() for random integers
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Toke,

On Tue, Dec 6, 2022 at 1:50 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@kerne=
l.org> wrote:
>
> "Jason A. Donenfeld" <Jason@zx2c4.com> writes:
>
> > On Mon, Dec 05, 2022 at 11:21:51PM +0100, Daniel Borkmann wrote:
> >> On 12/5/22 7:15 PM, Jason A. Donenfeld wrote:
> >> > Since BPF's bpf_user_rnd_u32() was introduced, there have been three
> >> > significant developments in the RNG: 1) get_random_u32() returns the
> >> > same types of bytes as /dev/urandom, eliminating the distinction bet=
ween
> >> > "kernel random bytes" and "userspace random bytes", 2) get_random_u3=
2()
> >> > operates mostly locklessly over percpu state, 3) get_random_u32() ha=
s
> >> > become quite fast.
> >>
> >> Wrt "quite fast", do you have a comparison between the two? Asking as =
its
> >> often used in networking worst case on per packet basis (e.g. via XDP)=
, would
> >> be useful to state concrete numbers for the two on a given machine.
> >
> > Median of 25 cycles vs median of 38, on my Tiger Lake machine. So a
> > little slower, but too small of a difference to matter.
>
> Assuming a 3Ghz CPU clock (so 3 cycles per nanosecond), that's an
> additional overhead of ~4.3 ns. When processing 10 Gbps at line rate
> with small packets, the per-packet processing budget is 67.2 ns, so
> those extra 4.3 ns will eat up ~6.4% of the budget.
>
> So in other words, "too small a difference to matter" is definitely not
> true in general. It really depends on the use case; if someone is using
> this to, say, draw per-packet random numbers to compute a drop frequency
> on ingress, that extra processing time will most likely result in a
> quite measurable drop in performance.

Huh, neat calculation, I'll keep that method in mind.

Alright, sorry for the noise here. I'll check back in if I ever manage
to eliminate that performance gap.

Jason
