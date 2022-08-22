Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5646E59C6E2
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 20:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236344AbiHVSpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 14:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237668AbiHVSot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 14:44:49 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F4713D69
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 11:42:47 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id h204-20020a1c21d5000000b003a5b467c3abso8274894wmh.5
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 11:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=skzCG58l+HqXhjJKQO4lGgqfYIra8NXlt0XqK+Dm+co=;
        b=dx3NiSAtEGzJGfO8Eei9gt+WPU+TFmsqSP8lo8aUcEY9SRecb90LQhJLHXFxWBkz+K
         uebpZQ4QXAOzd1RmygSNSxE23ik1uofISPNpbwlPoZfs2hMc6aQoCuRVi5AbfJAoR59q
         F9SOivk2DtOGDfzREl9zsRfm5Tuy1D9SB/efL3oVI/bLQ8MkeFByzi7UT7PF/VBZs+QD
         pIsOBvF1hgJtGo1jIay6ibiSM5JR1GeaGaqKUtL2+5Ir51iBZ47BTHpdQgE4G94u03k+
         z6brz9tx8VhuGIVUNGCckUNXmMco6QjXmzOJgpqYy8s/KbM3hDDipepQjHuerXJqjGSQ
         6AWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=skzCG58l+HqXhjJKQO4lGgqfYIra8NXlt0XqK+Dm+co=;
        b=wWoHWLb4fLq3TFb4qGKj7SyqxmNv0wDibiQtFulw4+vQpRsHKTu6hbx274cECJj/QB
         +JHafXYFVz03z3xUvlvQzEdUgkmyoVVAgsLCU3bgiDfrux36+mSWCLpwwu87B8kahQy4
         qOIKJnF2eY4/1fWN6LBl5QyukLjj4djDSLz1RULPNiKpEnudaHC+fIz7rxka84iR5+cT
         cSTqbievm6j/hcm4uN9HmkqU4wz0HIdP8f47VD9mtLtQmZzmDQqZOQc7awc1f2dLPs+j
         nWf+93Lo9JEpqtxe3Zpem0JE0JZgXZP20eCx4/lQuSku1ytSIncTVgTGzlQupAFGvIvx
         cSwg==
X-Gm-Message-State: ACgBeo1LQmL+P04Jd1dMYmuN5cxIcziXnXuXpcYCSLyrlT+2RGzlJaO9
        m1gX1CK3ZUy/rH9jaStCziFhcnEBaGbpkbwPor8RTg==
X-Google-Smtp-Source: AA6agR7AX0ck8HLTb7YMThG6aIE5+jGjKGhb7ts1QaiBVNTTBDpQ9FwDjv0asC2/z8+2U+UoH0eswifRgbTRzwQFffA=
X-Received: by 2002:a7b:c8d3:0:b0:3a6:2e:d4a8 with SMTP id f19-20020a7bc8d3000000b003a6002ed4a8mr16289164wml.135.1661193765556;
 Mon, 22 Aug 2022 11:42:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220818170005.747015-1-dima@arista.com> <fc05893d-7733-1426-3b12-7ba60ef2698f@gmail.com>
In-Reply-To: <fc05893d-7733-1426-3b12-7ba60ef2698f@gmail.com>
From:   Salam Noureddine <noureddine@arista.com>
Date:   Mon, 22 Aug 2022 11:42:34 -0700
Message-ID: <CAO7SqHBZMu1vX_a58ujOcNHaau19UtVbauB37Q0zRL-k3wqRXg@mail.gmail.com>
Subject: Re: [PATCH 00/31] net/tcp: Add TCP-AO support
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 21, 2022 at 1:34 PM Leonard Crestez <cdleonard@gmail.com> wrote=
:
>
> On 8/18/22 19:59, Dmitry Safonov wrote:
> > This patchset implements the TCP-AO option as described in RFC5925. The=
re
> > is a request from industry to move away from TCP-MD5SIG and it seems th=
e time
> > is right to have a TCP-AO upstreamed. This TCP option is meant to repla=
ce
> > the TCP MD5 option and address its shortcomings.
...
> >
> > The patch set was written as a collaboration of three authors (in alpha=
betical
> > order): Dmitry Safonov, Francesco Ruggeri and Salam Noureddine. Additio=
nal
> > credits should be given to Prasad Koya, who was involved in early proto=
typing
> > a few years back. There is also a separate submission done by Leonard C=
restez
> > whom we thank for his efforts getting an implementation of RFC5925 subm=
itted
> > for review upstream [2]. This is an independent implementation that mak=
es
> > different design decisions.
>
> Is this based on something that Arista has had running for a while now
> or is a recent new development?
>

This is based on prototype code we had worked on internally three years
ago. The implementation effort was restarted to get it over the finish
line. For business reasons we had to have our own implementation ready
and not tied to unmerged upstream code. Please also note that our
implementation is based on linux-4.19 and was only ported forward to
mainline recently. So it wasn=E2=80=99t ready to be submitted upstream.

> > For example, we chose a similar design to the TCP-MD5SIG implementation=
 and
> > used setsockopt()s to program per-socket keys, avoiding the extra compl=
exity
> > of managing a centralized key database in the kernel. A centralized dat=
abase
> > in the kernel has dubious benefits since it doesn=E2=80=99t eliminate p=
er-socket
> > setsockopts needed to specify which sockets need TCP-AO and what are th=
e
> > currently preferred keys. It also complicates traffic key caching and
> > preventing deletion of in-use keys.
>
> My implementation started with per-socket lists but switched to a global
> list because this way is much easier to manage from userspace. In
> practice userspace apps will want to ensure that all sockets use the
> same set of keys anyway.
>

We did consider a global list early on but we didn=E2=80=99t find it
beneficial. We still believe that per-socket lists reduce complexity
of the implementation, are more scalable and ensure predictable
behavior. Our expectation is that TCP-AO will be only useful for a
limited set of routing applications, rather than used transparently
like IPSEC for non-routing apps. We would be happy to discuss this in
more detail.

> > In this implementation, a centralized database of keys can be thought o=
f
> > as living in user space and user applications would have to program tho=
se
> > keys on matching sockets. On the server side, the user application prog=
rams
> > keys (MKTS in TCP-AO nomenclature) on the listening socket for all peer=
s that
> > are expected to connect. Prefix matching on the peer address is support=
ed.
...
>
> My series doesn't try to prevent inconsistencies inside the key lists
> because it's not clear that the kernel should prevent userspace from
> shooting itself in the foot. Worst case is connection failure on
> misconfiguration which seems fine.
>
> The RFC doesn't specify in detail how key management is to be performed,
> for example if two valid keys are available it doesn't mention which one
> should be used. Some guidance is found in RFC8177 but again not very much=
.
>
> I implemented an ABI that can be used by userspace for RFC8177-style key
> management and asked for feedback but received very little. If you had
> come with a clear ABI proposal I would have tried to implement it.
>
> Here's a link to our older discussion:
>
> https://lore.kernel.org/netdev/e7f0449a-2bad-99ad-4737-016a0e6b8b84@gmail=
.com/
>
> Seeing an entirely distinct unrelated implementation is very unexpected.
> What made you do this?
>
> --
> Regards,
> Leonard

Our goal was not to have a competing TCP-AO upstream submission but
to implement the RFC for our customers to use. Had there been an
already upstreamed implementation we would have used it and
implemented customer requirements on top of it. Just like we do with
all other kernel features. This is not a bad situation, we believe it
is good for the upstream community to have two fully functioning
implementations to consider. Possibly a third collaborative
submission might emerge that takes the best of both. A year ago, there
wasn=E2=80=99t much available online about TCP-AO besides the RFC. We are
excited with the current interest in TCP-AO and hope to see it
upstreamed soon.

Best,

Salam
