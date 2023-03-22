Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154076C5964
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 23:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjCVWX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 18:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjCVWX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 18:23:58 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6EB234ED
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 15:23:57 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id fb38so7137764pfb.7
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 15:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1679523837;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K5UyVUsLWeB9KXhLCSROkmyQxaPg1vMo5DxptegTbXA=;
        b=VfIU6ecdNMnySfR0LqWvhUbl+F/H/WeKX6lIL68MRGgRFiIsqlQjw0MUkJXBx4aM3P
         TY5BooNEbYOmtNopxCKzhD0uwQTlGtVK29DGUdCpBjegIJyY2tFTS0npYTKwEYpoL9Vp
         DjNcX0mYBY5DtXVrCg2jJRBxRq5MRPwUlk918=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679523837;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K5UyVUsLWeB9KXhLCSROkmyQxaPg1vMo5DxptegTbXA=;
        b=uivmmFCJKSg922bPO8MOghtPjAVyzgZMOslD5i5u6G8B1u6tczf9smGt8u9F1CqKnu
         fz5XnV/xrkIWtxVIhenaQcKv+xpmi7uoYPzTie6gqZLMdrbVc3UsYiCIP5t+GE9fQoLK
         rh+3FoV7qpxuT25d1ytS//FWBKp0meZMceKeCg76AVHa4zqajdipw8pP+JsyuPGijQhF
         +Hk4GCClcuVP1dxrboVW/8xrAqDxyrQBHQ7JeLUILe+OqjdLN2Oppsad/KVPhzmQ3/UJ
         H/lsuX3s62EYb3AmuwQ/VhXebseufy5SuaXXWWoa5SF+aGrwfiMz6EmKFyX1aLDunKIe
         0ZuQ==
X-Gm-Message-State: AO0yUKVIWD14q6lserA8HqR7YKp/FCud7IHBi16z9RgtGCg0Bv6fBCBa
        ahOHFOCxhNzwzfl9oKjLBtjLFxefrYy3nNx9HoN1PQ==
X-Google-Smtp-Source: AK7set9YHsREOpzJCxa7JgGIGEndJcZXYmbd4TWdQneHFTm+SqkSZ8k37l7ZfhSR6/yyIPNgegBz0p9W9PZ8bts2nHQ=
X-Received: by 2002:a65:5ccc:0:b0:502:f20a:6e0a with SMTP id
 b12-20020a655ccc000000b00502f20a6e0amr1201886pgt.0.1679523836699; Wed, 22 Mar
 2023 15:23:56 -0700 (PDT)
MIME-Version: 1.0
References: <CALrw=nHWdZA=nGizO4hd1xineoNuhN7hh5nGrHFiint1m72afQ@mail.gmail.com>
 <CANn89iLU+OJR4pvFxM0akOLLSV2yCbR9Kb8ap3u3UOxh2Xy1Bw@mail.gmail.com>
In-Reply-To: <CANn89iLU+OJR4pvFxM0akOLLSV2yCbR9Kb8ap3u3UOxh2Xy1Bw@mail.gmail.com>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Wed, 22 Mar 2023 22:23:45 +0000
Message-ID: <CALrw=nGt88SnOaQ-7fHWfwEaVaaYxK6on98vSY2vrv2zErcLCw@mail.gmail.com>
Subject: Re: Increased UDP socket memory on Linux 6.1
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 10:09=E2=80=AFPM Eric Dumazet <edumazet@google.com>=
 wrote:
>
> On Wed, Mar 22, 2023 at 2:57=E2=80=AFPM Ignat Korchagin <ignat@cloudflare=
.com> wrote:
> >
> > Hello,
> >
> > We were investigating unusual packet drops on our systems potentially
> > related to our recent migration to the 6.1 kernel. We have noticed a
> > substantial increase in UDP socket memory for the same workload. Below
> > are two servers in the same datacentre doing the same workload.
> >
> > On 5.15.90 (our previous kernel):
> > $ cat /proc/net/sockstat
> > sockets: used 174831
> > TCP: inuse 112301 orphan 145 tw 23829 alloc 135086 mem 313582
> > UDP: inuse 7613 mem 1667
> > UDPLITE: inuse 0
> > RAW: inuse 7
> > FRAG: inuse 0 memory 0
> >
> > But on 6.1.20:
> > $ cat /proc/net/sockstat
> > sockets: used 168911
> > TCP: inuse 108857 orphan 124 tw 23674 alloc 130096 mem 235530
> > UDP: inuse 7555 mem 10514
>
> 10514 pages 'forward allocated' for 7555 UDP sockets seems ok to me.
>
> UDP sockets have their own notion of 'forward_deficit'  and
> forward_threshold based on SO_RCVBUF values.
>
> Do you have the following commit yet in your kernel ?
> commit 8a3854c7b8e4532063b14bed34115079b7d0cb36

No (because we're on 6.1.20 and this seems to went into 6.2), but we
can probably backport it if it helps.

> Author: Paolo Abeni <pabeni@redhat.com>
> Date:   Thu Oct 20 19:48:52 2022 +0200
>
>     udp: track the forward memory release threshold in an hot cacheline
>
>     When the receiver process and the BH runs on different cores,
>     udp_rmem_release() experience a cache miss while accessing sk_rcvbuf,
>     as the latter shares the same cacheline with sk_forward_alloc, writte=
n
>     by the BH.
>
>     With this patch, UDP tracks the rcvbuf value and its update via custo=
m
>     SOL_SOCKET socket options, and copies the forward memory threshold va=
lue
>     used by udp_rmem_release() in a different cacheline, already accessed=
 by
>     the above function and uncontended.
>
>     Since the UDP socket init operation grown a bit, factor out the commo=
n
>     code between v4 and v6 in a shared helper.
>
>     Overall the above give a 10% peek throughput increase under UDP flood=
.
>
>     Signed-off-by: Paolo Abeni <pabeni@redhat.com>
>     Reviewed-by: Eric Dumazet <edumazet@google.com>
>     Acked-by: Kuniyuki Iwashima <kuniyu@amazon.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
>
>
> > UDPLITE: inuse 0
> > RAW: inuse 7
> > FRAG: inuse 0 memory 0
> >
> > For roughly the same amount of UDP sockets the UDP memory is much
> > higher. TCP memory looks different above as well, but according to our
> > longer-term metrics overall it is the same, but UDP is substantially
> > bigger.
> >
> > Here's the snapshot of the same metric from the same servers in
> > graphical form [1]. The server indicated by a blue line was rebooted
> > into 6.1.20 and you can see the UDP memory jumped compared to the
> > green server (on 5.15.90). We're not sure yet, but perhaps it is an
> > artifact of [2], namely commit 4890b686f4088c90 ("net: keep
> > sk->sk_forward_alloc as small as possible") and commit
> > 3cd3399dd7a84ada ("net: implement per-cpu reserves for
> > memory_allocated")
> >
> > We don't know at this point if it is related to our unusual rate of
> > packet drops, but just wanted to point this out and see if the UDP
> > memory increase is expected.
>
> >
> > Thanks,
> > Ignat
> >
> > [1]: https://pub-ddb0f42c43e74ce4a1424bc33f965f9a.r2.dev/udp-mem.jpg
> > [2]: https://lore.kernel.org/netdev/20220609063412.2205738-1-eric.dumaz=
et@gmail.com/
