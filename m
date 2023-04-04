Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5AE6D59C0
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 09:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233910AbjDDHfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 03:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233796AbjDDHfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 03:35:30 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C281BC
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 00:35:29 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id i5so126987828eda.0
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 00:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680593727; x=1683185727;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+LioPFJpGbs106bNlWQtVdD4erRUaQg3z5G4cIjZtDc=;
        b=Xaa8eFxJda1EdUEKIoCPjRZOxBKkaj4ELiZVgiI2xxHEss8EmZtmNZgpAry8Jm/MYV
         g1DQ4owOEE3kcrGcNhLhy4ZgLMCwBwlaZny+Rrl0wFoINMG5LWzsoHzpfcz+SG7OpUvT
         w+KZaC193Tw+DuGBCuo8oziXhsd7/7Nr8ow/Zq94/9FCTMk9Hs9x/68X2sfBmeCm5wtg
         guylJ3u4Eco1t9qp/54pKMQQi41CzqY9WUhd+CfLIGpDCU0xOTxR6h708dJl4mUAganY
         wtz4wYdACwLtN8fZWV5Wzxpw2dNQT0k+1S+BAiO3gKRkpnzi9Ofh6nCE2aG/HohHakfM
         rjXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680593727; x=1683185727;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+LioPFJpGbs106bNlWQtVdD4erRUaQg3z5G4cIjZtDc=;
        b=hrAQSAUrBViiWOZc4UPCCAOZ6T5ZgGhANmTRSXd6qkTfzm7yqcVoEwfLb+osxlr4/J
         i/aR0OANZOftdmm6j+5KdVdh+6VFBh+ule0u7VP16Nn+rDcoLv0iL3Qse80swUd9e5Sw
         Qt9fCqKwQ9KFI2RxcTsmDXjSUSf9sol/ETvSRkBRPaRSvMSnLJ7+tm6FO/aQ8RIhjB8o
         xnH9UcNea0vUoQX3aL8Kex4BFY+TfktszGEOy5/svf8ZpxyZMxtkMCXM509RUnb3LR8S
         5MBkWOlxhnWDHCVhbbYTU3R/Vn5wM7fIiiJnozE4s6mMzaRivfMO1ms2WqZrP26yEgf0
         /eVQ==
X-Gm-Message-State: AAQBX9fVMLZ60V5hAUoxKuBV3UUORTgnc8vNqmQACuGBhcja93l3VMNA
        qCenlFwhiWZG6vuo2wHVab54oipQRZFm1uGfoDU=
X-Google-Smtp-Source: AKy350abnWxn+AsS2Pq9tnNZNNTW6amC0t6J/5dq3cNHMdzsi/td7Ua9d6jJzwc4oC/7l2mdzx0i12mQ2tUZaqdKOzQ=
X-Received: by 2002:a17:906:1858:b0:932:39bf:d36e with SMTP id
 w24-20020a170906185800b0093239bfd36emr702104eje.11.1680593727557; Tue, 04 Apr
 2023 00:35:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230403194959.48928-1-kuniyu@amazon.com> <20230403194959.48928-2-kuniyu@amazon.com>
 <CAL+tcoB911=NZYiiAHV8vRv+=GdWmXqNv0YWd9mc4vLaTgjN1g@mail.gmail.com>
 <CANn89iKO9xtHoa39815OyAbTQ_mYr8DMBYu4QX6bs_uDBaT9Tg@mail.gmail.com>
 <CAL+tcoC-PNJqhZhDbtJ3O5kTJov5HoxSoy9K30o_HW5fSbVg4Q@mail.gmail.com> <CANn89iJqGZyk6QCG46PpUs9L0HUMQL425vx3ETPwXy7xUjGu9Q@mail.gmail.com>
In-Reply-To: <CANn89iJqGZyk6QCG46PpUs9L0HUMQL425vx3ETPwXy7xUjGu9Q@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 4 Apr 2023 15:34:51 +0800
Message-ID: <CAL+tcoBUeTzRPjiAcR7s0ysEWTCR7bpMvGUd1kU4mX-M_vsuhQ@mail.gmail.com>
Subject: Re: [PATCH v1 net 1/2] raw: Fix NULL deref in raw_get_next().
To:     Eric Dumazet <edumazet@google.com>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>,
        "Dae R . Jeong" <threeearcat@gmail.com>
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

On Tue, Apr 4, 2023 at 3:23=E2=80=AFPM Eric Dumazet <edumazet@google.com> w=
rote:
>
> On Tue, Apr 4, 2023 at 8:56=E2=80=AFAM Jason Xing <kerneljasonxing@gmail.=
com> wrote:
> >
> > On Tue, Apr 4, 2023 at 12:07=E2=80=AFPM Eric Dumazet <edumazet@google.c=
om> wrote:
> > >
> > > On Tue, Apr 4, 2023 at 4:46=E2=80=AFAM Jason Xing <kerneljasonxing@gm=
ail.com> wrote:
> > > >
> > > > I would like to ask two questions which make me confused:
> > > > 1) Why would we use spin_lock to protect the socket in a raw hashta=
ble
> > > > for reader's safety under the rcu protection? Normally, if we use t=
he
> > > > RCU protection, we only make sure that we need to destroy the socke=
t
> > > > by calling call_rcu() which would prevent the READER of the socket
> > > > from getting a NULL pointer.
> > >
> > > Yes, but then we can not sleep or yield the cpu.
> >
> > Indeed. We also cannot sleep/yield under the protection of the spin
> > lock. And I checked the caller in fs/seq_file.c and noticed that we
> > have no chance to sleep/yield between ->start and ->stop.
> >
>
> You missed my point.
> The spinlock can trivially be replaced by a mutex, now the fast path
> has been RCU converted.
> This would allow raw_get_idx()/raw_get_first() to use cond_resched(),
> if some hosts try to use 10,000 raw sockets :/

Thanks for the clarification. I agreed. The patch for now itself is good :)

> Is it a real problem to solve right now ?  I do not think so.
>
> > So I wonder why we couldn't use RCU directly like the patch[1] you
> > proposed before and choose deliberately to switch to spin lock? Spin
> > lock for the whole hashinfo to protect the reader side is heavy, and
> > RCU outperforms spin lock in this case, I think.
>
> spinlock is just fine enough, most hosts have less than 10 raw sockets,
> because raw sockets make things _much_ slower.

Sure.

Thanks,
Jason

>
> RCU 'just because' does not make sense, it would suggest that RAW sockets
> scale, while they do not.
