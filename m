Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964216C594F
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 23:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjCVWJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 18:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjCVWJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 18:09:55 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065AFEC70
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 15:09:54 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id h15so6223271vsh.0
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 15:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679522993;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sg5mpAHq/rFYa+zFwI5qQzsFKzPsGeTwSo3V+9tI9dc=;
        b=ABCr0Bi7568+Oxd5wl6dRHlPuN2pPEMGg7rVTETva1wi++kkvIeHB+QoyAh0mmvi7Q
         QeTGWAg+uqmbifWT6C7G8o+Uf77cOBbfzdLPzILg3HWommuOnVXF2Zlggr0uUOQ+dXyH
         gIwgsTxNuQfb/CI8Im6+8kdKmvR17WA0pgNRBpzHVTr5YSlN3l7PgZR99va2INYsDZLX
         kIaNCGwV+Vc6z9ojXo/4buLWQPSvZyFORg8CLuLcizg5UVgOQEd+ikDqsrsdofxYgF5e
         VuBFkHcw6pSgv1Us95MUe4pg6nacnoXwzjORz4B6RgCctZqo249lRUhCTKm3zeyNW0GU
         W39Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679522993;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sg5mpAHq/rFYa+zFwI5qQzsFKzPsGeTwSo3V+9tI9dc=;
        b=x3oMX6mIRyoVqaWcQs5TJwk4IKQBf84YQ80DLg5bZrJkRo8Bt/SgZP4w8OuWsxvhGm
         5hLxWknNGIuKo0JLAXHnK1MUb726YEpzD/Kgd61cYJRy9J3LcHyOfyvLY6mK/6j1uYr3
         WaeUYT8mt33LtFJyQpIHcjJnCnKFMT0PtCFbg1yuwQLjRmdlk4yYk0/4gw42cYWt4G2O
         WL5eHJHOVNJwTD4UrVA4ywnkIHjfzwL7o2E/Te2oR/3tZy9b+v0whPPYPfPQBsoCYCSu
         U0P1B2TCKp9HU4KETSxg8T8A81jUhhYVVMtvrQrh7H9eO13oKsPvzZQXAVDUchJstafv
         EqTQ==
X-Gm-Message-State: AO0yUKVbJBWWkJu6lLVbeN1DrWxvSM9Z6dqgE4PsiDSaJPgGOn1IQXIL
        Wz7z5nd/V2ANexwg30zTwJ2O/3ScEV5eojEy2ttkiw==
X-Google-Smtp-Source: AK7set+SPRJoDvaYGb+bDz9NnRPR4B/Vn/oeK5zzlNg8tYV5mZPvsukWdsSJ4QOpgDcByfw21tSlGthmLrLKfmfmza0=
X-Received: by 2002:a67:d812:0:b0:414:4ef3:839 with SMTP id
 e18-20020a67d812000000b004144ef30839mr550827vsj.7.1679522992957; Wed, 22 Mar
 2023 15:09:52 -0700 (PDT)
MIME-Version: 1.0
References: <CALrw=nHWdZA=nGizO4hd1xineoNuhN7hh5nGrHFiint1m72afQ@mail.gmail.com>
In-Reply-To: <CALrw=nHWdZA=nGizO4hd1xineoNuhN7hh5nGrHFiint1m72afQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 22 Mar 2023 15:09:41 -0700
Message-ID: <CANn89iLU+OJR4pvFxM0akOLLSV2yCbR9Kb8ap3u3UOxh2Xy1Bw@mail.gmail.com>
Subject: Re: Increased UDP socket memory on Linux 6.1
To:     Ignat Korchagin <ignat@cloudflare.com>
Cc:     netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 2:57=E2=80=AFPM Ignat Korchagin <ignat@cloudflare.c=
om> wrote:
>
> Hello,
>
> We were investigating unusual packet drops on our systems potentially
> related to our recent migration to the 6.1 kernel. We have noticed a
> substantial increase in UDP socket memory for the same workload. Below
> are two servers in the same datacentre doing the same workload.
>
> On 5.15.90 (our previous kernel):
> $ cat /proc/net/sockstat
> sockets: used 174831
> TCP: inuse 112301 orphan 145 tw 23829 alloc 135086 mem 313582
> UDP: inuse 7613 mem 1667
> UDPLITE: inuse 0
> RAW: inuse 7
> FRAG: inuse 0 memory 0
>
> But on 6.1.20:
> $ cat /proc/net/sockstat
> sockets: used 168911
> TCP: inuse 108857 orphan 124 tw 23674 alloc 130096 mem 235530
> UDP: inuse 7555 mem 10514

10514 pages 'forward allocated' for 7555 UDP sockets seems ok to me.

UDP sockets have their own notion of 'forward_deficit'  and
forward_threshold based on SO_RCVBUF values.

Do you have the following commit yet in your kernel ?

commit 8a3854c7b8e4532063b14bed34115079b7d0cb36
Author: Paolo Abeni <pabeni@redhat.com>
Date:   Thu Oct 20 19:48:52 2022 +0200

    udp: track the forward memory release threshold in an hot cacheline

    When the receiver process and the BH runs on different cores,
    udp_rmem_release() experience a cache miss while accessing sk_rcvbuf,
    as the latter shares the same cacheline with sk_forward_alloc, written
    by the BH.

    With this patch, UDP tracks the rcvbuf value and its update via custom
    SOL_SOCKET socket options, and copies the forward memory threshold valu=
e
    used by udp_rmem_release() in a different cacheline, already accessed b=
y
    the above function and uncontended.

    Since the UDP socket init operation grown a bit, factor out the common
    code between v4 and v6 in a shared helper.

    Overall the above give a 10% peek throughput increase under UDP flood.

    Signed-off-by: Paolo Abeni <pabeni@redhat.com>
    Reviewed-by: Eric Dumazet <edumazet@google.com>
    Acked-by: Kuniyuki Iwashima <kuniyu@amazon.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>


> UDPLITE: inuse 0
> RAW: inuse 7
> FRAG: inuse 0 memory 0
>
> For roughly the same amount of UDP sockets the UDP memory is much
> higher. TCP memory looks different above as well, but according to our
> longer-term metrics overall it is the same, but UDP is substantially
> bigger.
>
> Here's the snapshot of the same metric from the same servers in
> graphical form [1]. The server indicated by a blue line was rebooted
> into 6.1.20 and you can see the UDP memory jumped compared to the
> green server (on 5.15.90). We're not sure yet, but perhaps it is an
> artifact of [2], namely commit 4890b686f4088c90 ("net: keep
> sk->sk_forward_alloc as small as possible") and commit
> 3cd3399dd7a84ada ("net: implement per-cpu reserves for
> memory_allocated")
>
> We don't know at this point if it is related to our unusual rate of
> packet drops, but just wanted to point this out and see if the UDP
> memory increase is expected.

>
> Thanks,
> Ignat
>
> [1]: https://pub-ddb0f42c43e74ce4a1424bc33f965f9a.r2.dev/udp-mem.jpg
> [2]: https://lore.kernel.org/netdev/20220609063412.2205738-1-eric.dumazet=
@gmail.com/
