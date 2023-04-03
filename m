Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B586D5010
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbjDCSLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbjDCSLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:11:48 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684A82134
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 11:11:47 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so31480562pjb.0
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 11:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680545507;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XllxF9AlovEFEotpyDtvs4Gp0knyp3ybwSFzbFvACPI=;
        b=dO5efg4s5FUwVRvYU1y/YZsZxPc5VGE/qmvl6H0kFQZCfK+1UFMWW0QEdMp8xjrWfg
         uodZDCF5Wu2FyM/oIX7FthK7wRqaPa55xrpvIt87/6IX1asOnlqUwrDea0/Lm/e0kBpP
         IJUZoLruxhsA1BlFs1uDj09ceX1XQgpgOSF8J1Xjd+4ErsvtJfC29LlHFWcNQdizoIP9
         YfnAqjjbmMDeHkJyu/osw45hpJsnp0nkQ1JD/GDjT2Lo0e12hoy3vp30U4FPjq0CuWsA
         S++FjrCh2VkuiuuD75fUNEkF5JjKUlVwMpWufKgki94a2iIikKSgDSvt1pj2bL8Jf2fg
         hX7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680545507;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XllxF9AlovEFEotpyDtvs4Gp0knyp3ybwSFzbFvACPI=;
        b=A2PCcV146b7U3BIeL9DZiOqhUe1jhOxEnB4FQ70LF1kbCgyPrTh/pjiNZxJiyyGY6j
         vs0zgGb9UUUUwB/+qHmSa10n2CY/0IlR339F3trgoj46I8NrXqOBHj6sccZLFzVYx8t8
         Xerf8ac8SnL2QEDkmhv3tafF4KCE9YWi7VIvwfNi0JcEbCfDY3j08lkLnrQwvi5c5AIe
         vQn1xKDVwz/sK3chB2Qnc6GIYOP8kjtsZUsYnaoy+eQqkIPkyYv1Tz9O6doFPRMq9Q5+
         PAK8mCdKE9mTY7ySHFtkm76rqqAmkGN4sHEt7FINA8BLbeHel/ZkCGYb4FC3DSNz3/8o
         +g5w==
X-Gm-Message-State: AAQBX9d4qUQUBIhLPUDYoAHNxXZEfqpa4qmBtU3w5OIJuxr+TibgxrPQ
        I1vFC0sizK0wJSTdhgod2o+sHxBZiISwswYzavSEqPCxHoE=
X-Google-Smtp-Source: AKy350bKrn/ycM8j+wn62QlTwWGOHdPRGb/574XgCQDah1rcXJcTJdrEk53SFBlRXLCdtjZna7FQvAz8ttbtCStdd50=
X-Received: by 2002:a17:903:32c3:b0:1a1:b3bb:cd5e with SMTP id
 i3-20020a17090332c300b001a1b3bbcd5emr12919071plr.9.1680545506669; Mon, 03 Apr
 2023 11:11:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230401051221.3160913-1-kuba@kernel.org> <20230401051221.3160913-2-kuba@kernel.org>
 <c39312a2-4537-14b4-270c-9fe1fbb91e89@gmail.com> <20230401115854.371a5b4c@kernel.org>
 <CAKgT0UeDy6B0QJt126tykUfu+cB2VK0YOoMOYcL1JQFmxtgG0A@mail.gmail.com> <20230403085601.44f04cd2@kernel.org>
In-Reply-To: <20230403085601.44f04cd2@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 3 Apr 2023 11:11:35 -0700
Message-ID: <CAKgT0UcsOwspt0TEashpWZ2_gFDR878NskBhquhEyCaN=uYnDQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Paul E. McKenney" <paulmck@kernel.org>
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

On Mon, Apr 3, 2023 at 8:56=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Mon, 3 Apr 2023 08:18:04 -0700 Alexander Duyck wrote:
> > On Sat, Apr 1, 2023 at 11:58=E2=80=AFAM Jakub Kicinski <kuba@kernel.org=
> wrote:
> > > > One more question: Don't we need a read memory barrier here to ensu=
re
> > > > get_desc is up-to-date?
> > >
> > > CC: Alex, maybe I should not be posting after 10pm, with the missing =
v2
> > > and sparse CC list.. :|
> > >
> > > I was thinking about this too yesterday. AFAICT this implementation
> > > could indeed result in waking even tho the queue is full on non-x86.
> > > That's why the drivers have an extra check at the start of .xmit? :(
> >
> > The extra check at the start is more historical than anything else.
> > Logic like that has been there since the e1000 days. I think it
> > addressed items like pktgen which I think didn't make use of the
> > stop/wake flags way back when. I'll add in Herbet who was the original
> > author for this code so he can add some additional history if needed.
>
> Thanks for the pointer, you weren't kidding with the 2.6.19, that seems
> to be when to code was added to e1000 :) Looks fairly similar to the
> current code minus the BQL.
>
> > > I *think* that the right ordering would be:
> > >
> > > c1. WRITE cons
> > > c2. mb()  # A
> > > c3. READ stopped
> > > c4. rmb() # C
> > > c5. READ prod, cons
> >
> > What would the extra rmb() get you? The mb() will have already flushed
> > out any writes and if stopped is set the tail should have already been
> > written before setting it.
>
> I don't think in terms of flushes. Let me add line numbers to the
> producer and the consumer.
>
>  c1. WRITE cons
>  c2. mb()  # A
>  c3. READ stopped
>  c4. rmb() # C
>  c5. READ prod, cons
>
>  p1. WRITE prod
>  p2. READ prod, cons
>  p3. mb()  # B
>  p4. WRITE stopped
>  p5. READ prod, cons
>
> The way I think the mb() orders c1 and c3 vs p2 and p4. The rmb()
> orders c3 and c5 vs p1 and p4. Let me impenitently add Paul..

So which function is supposed to be consumer vs producer here? I think
your write stopped is on the wrong side of the memory barrier. It
should be writing prod and stopped both before the barrier.

The maybe/try stop should essentially be:
1. write tail
2. read prod/cons
3. if unused >=3D 1x packet
3.a return

4. set stop
5. mb()
6. Re-read prod/cons
7. if unused >=3D 1x packet
7.a. test_and_clear stop

The maybe/try wake would be:
1. write head
2. read prod/cons
3. if consumed =3D=3D 0 || unused < 2x packet
3.a. return

4. mb()
5. test_and_clear stop

> > One other thing to keep in mind is that the wake gives itself a pretty
> > good runway. We are talking about enough to transmit at least 2
> > frames. So if another consumer is stopping it we aren't waking it
> > unless there is enough space for yet another frame after the current
> > consumer.
>
> Ack, the race is very unlikely, basically the completing CPU would have
> to take an expensive IRQ between checking the descriptor count and
> checking if stopped -- to let the sending CPU queue multiple frames.
>
> But in theory the race is there, right?

I don't think this is so much a race as a skid. Specifically when we
wake the queue it will only run for one more packet in such a
scenario. I think it is being run more like a flow control threshold
rather than some sort of lock.

I think I see what you are getting at though. Basically if the xmit
function were to cycle several times between steps 3.a and 4 in the
maybe/try wake it could fill the queue and then trigger the wake even
though the queue is full and the unused space was already consumed.
