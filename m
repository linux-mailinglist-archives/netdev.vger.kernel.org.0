Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97319380004
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 00:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbhEMWY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 18:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbhEMWYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 18:24:25 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D29C061574;
        Thu, 13 May 2021 15:23:13 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id j12so24310693ils.4;
        Thu, 13 May 2021 15:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=a1/spq4uI0k6MIPthdxxFIzhMjuNtV0uMm+J4M3X7Y4=;
        b=YinjmZHzanp9yudlIedX/Fc+o2GfVpnv7dK8SaANLe6Y0yRpALeGGNcI60sPJsERWU
         MMx0QPEirwzLgABwNPXythHOmH+0+jeRAEjpQmb8EzFMmG5Ei6j83uKF0VV7dvwDRoDg
         lXAp7tzM49EX7l2NC61TeAG1cMKdH10vPzAqoMUleiCkn6I0mYUIc5BvFAyHPyXPodFY
         0UE3ipQeTEw6UgY740KhruHduLIKpZtw+jX531wCJoFlN61Vf/N+srDRYQGJnDiTMu4/
         8BNRf/5n34TNm/nA1XRSic64P0m2KEiIUOZ6rFwKodU1EpWv0jeVFwG9dxyR+HTa8HbP
         KV3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=a1/spq4uI0k6MIPthdxxFIzhMjuNtV0uMm+J4M3X7Y4=;
        b=TEucsuhHSllTQNyUdDD8ZNViQ0ixd0T/JZSFyi0ODoVXqsnTrvL+Y6O9gfi9yqdshR
         Vx9Hfm147UletIA+6c2cD4bFOnUgG3HBISeZQEQ4jGtAxe2SMKEq0iwn8yDTMupCkvhO
         25tGcneOiK3W2g9Xoy8SBFrE9wubAdbydkBxhsEwmHxYZ+N0JBXb38DWMT4FGI5yvQ+D
         2lFnAZdEbO+Gh+LB2oONWpCCpxYFcN3IzCC3MzAx4q/usgw/coWRVVmwRxpTnl9Iyezz
         evMraogRy8y9k5nVPfkXqBmYg/TjDbl8fHAkz/T6/QctE/tDppNbA0GYwO54I0qmEtHX
         jMsw==
X-Gm-Message-State: AOAM532AoGtHqBwWWBn086Q850OnDqhWpDfIRhAUUzdWY+PYihoL/Saw
        or/k66z2VOtxzkF6wq0T2Kk=
X-Google-Smtp-Source: ABdhPJyOgFFDNjeIu7Z6lk630MVEH4QfthOJyYpfbFx/Mq1DnRurwevCbpQ69W5zomDAXjC2kTrs8w==
X-Received: by 2002:a92:130a:: with SMTP id 10mr37436059ilt.159.1620944593283;
        Thu, 13 May 2021 15:23:13 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id b10sm1693025ioz.35.2021.05.13.15.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 15:23:12 -0700 (PDT)
Date:   Thu, 13 May 2021 15:23:05 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Message-ID: <609da6c95d01a_155f5d20837@john-XPS-13-9370.notmuch>
In-Reply-To: <20210513070447.1878448-2-liuhangbin@gmail.com>
References: <20210513070447.1878448-1-liuhangbin@gmail.com>
 <20210513070447.1878448-2-liuhangbin@gmail.com>
Subject: RE: [PATCH RESEND v11 1/4] bpf: run devmap xdp_prog on flush instead
 of bulk enqueue
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu wrote:
> From: Jesper Dangaard Brouer <brouer@redhat.com>
> =

> This changes the devmap XDP program support to run the program when the=

> bulk queue is flushed instead of before the frame is enqueued. This has=

> a couple of benefits:
> =

> - It "sorts" the packets by destination devmap entry, and then runs the=

>   same BPF program on all the packets in sequence. This ensures that we=

>   keep the XDP program and destination device properties hot in I-cache=
.
> =

> - It makes the multicast implementation simpler because it can just
>   enqueue packets using bq_enqueue() without having to deal with the
>   devmap program at all.
> =

> The drawback is that if the devmap program drops the packet, the enqueu=
e
> step is redundant. However, arguably this is mostly visible in a
> micro-benchmark, and with more mixed traffic the I-cache benefit should=

> win out. The performance impact of just this patch is as follows:
> =

> Using 2 10Gb i40e NIC, redirecting one to another, or into a veth inter=
face,
> which do XDP_DROP on veth peer. With xdp_redirect_map in sample/bpf, se=
nd
> pkts via pktgen cmd:
> ./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -=
t 10 -s 64
> =

> There are about +/- 0.1M deviation for native testing, the performance
> improved for the base-case, but some drop back with xdp devmap prog att=
ached.
> =

> Version          | Test                           | Generic | Native | =
Native + 2nd xdp_prog
> 5.12 rc4         | xdp_redirect_map   i40e->i40e  |    1.9M |   9.6M | =
 8.4M
> 5.12 rc4         | xdp_redirect_map   i40e->veth  |    1.7M |  11.7M | =
 9.8M
> 5.12 rc4 + patch | xdp_redirect_map   i40e->i40e  |    1.9M |   9.8M | =
 8.0M
> 5.12 rc4 + patch | xdp_redirect_map   i40e->veth  |    1.7M |  12.0M | =
 9.4M
> =

> When bq_xmit_all() is called from bq_enqueue(), another packet will
> always be enqueued immediately after, so clearing dev_rx, xdp_prog and
> flush_node in bq_xmit_all() is redundant. Move the clear to __dev_flush=
(),
> and only check them once in bq_enqueue() since they are all modified
> together.
> =

> This change also has the side effect of extending the lifetime of the
> RCU-protected xdp_prog that lives inside the devmap entries: Instead of=

> just living for the duration of the XDP program invocation, the
> reference now lives all the way until the bq is flushed. This is safe
> because the bq flush happens at the end of the NAPI poll loop, so
> everything happens between a local_bh_disable()/local_bh_enable() pair.=

> However, this is by no means obvious from looking at the call sites; in=

> particular, some drivers have an additional rcu_read_lock() around only=

> the XDP program invocation, which only confuses matters further.
> Cleaning this up will be done in a separate patch series.
> =

> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> =


Acked-by: John Fastabend <john.fastabend@gmail.com>=
