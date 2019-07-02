Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C50395D5C2
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 19:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfGBRzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 13:55:39 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40149 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfGBRzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 13:55:38 -0400
Received: by mail-io1-f68.google.com with SMTP id n5so39089595ioc.7;
        Tue, 02 Jul 2019 10:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3T5EysXS4+ylwMPKQI/Jl/hs5CUHoOyJkrz2X2C8PnQ=;
        b=CV1OGf9sDtpAuDJ7X3upD8Rs3kldx7Rdmhnwb2VnAay24jra1YJhzyHgMB4HvRYe45
         rZGMxpah47P9wdvgmAgZhscezAoH3duKuPpzNTGKV2NFq/54yp2XzzkiAEueJhSZSr/V
         4PMrNecE3moAzjs6QlpLl4r1p/2MvN8OE25WCejxqhqMUkuplffp2WGBwussPNe2eJVv
         gin9adMPsxZ84+WIPeMB8DurpbtLvFpBg4an56i8OXbO8O28CLv/DxRWOrb+07gEw9Be
         hbN3h88HzZp6pWfTFvUgcgh36vewN/h8m6OWGiWe6D5tBPT7tjkWrfW4vJ477VrFUVE7
         CVeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3T5EysXS4+ylwMPKQI/Jl/hs5CUHoOyJkrz2X2C8PnQ=;
        b=LaHKYsQuXRWIe3girmbZpcnKc8I9uV2GVoKVbTGLknmeifHUBbPM8z480IJ+20bmNa
         qDD3z8OtK9bl4vzCHymu0MdjfwJ6+cTm8bE2D9CDl7i7tmmObha0r3+HEFYpYAdkWJsh
         mIjXuLZk063WGTihgkZEz/sC8XHJtfO8AmGnkpDmYMPdXWhiGO8Shg8OYcKgIkybjPUm
         VZbvPCXwzGm+cXiteYXC7/lKauBXCcy/kQjwtrcx6XWoN2TkyT4ZHbIoMTZN0M2NhP0e
         ufjc4uTdB+NudVq2v15Ls51a3fUa+YBibxBxn2eIK05NFr5QhsKwj3Mtn7+sCwx2H7Nd
         Rp3w==
X-Gm-Message-State: APjAAAWBr5eR2rFc8/dQg/u+xZCB7vwL+xRcQL4kFzqhjXKQRbd0lH8v
        QBSchbcNAjcVwHm3RZXnYdbRw8G9X3EHAUPRoZQ=
X-Google-Smtp-Source: APXvYqw1Sn8fUPQHt6IeGCA6PVv3wZ9SOwJ/5V6EPzacF2q5ZRivawkxxDkqbqVPHOAqLIApCDPozrco/71KCiWHpXg=
X-Received: by 2002:a5e:aa15:: with SMTP id s21mr32062256ioe.221.1562090137753;
 Tue, 02 Jul 2019 10:55:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190702161403.191066-1-sdf@google.com>
In-Reply-To: <20190702161403.191066-1-sdf@google.com>
From:   Y Song <ys114321@gmail.com>
Date:   Tue, 2 Jul 2019 10:55:01 -0700
Message-ID: <CAH3MdRXz-AHMuNQNWhnrxCrZhD9xKi44HiQdMh99R1FGaFYnhA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/8] bpf: TCP RTT sock_ops bpf callback
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 9:14 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Congestion control team would like to have a periodic callback to
> track some TCP statistics. Let's add a sock_ops callback that can be
> selectively enabled on a socket by socket basis and is executed for
> every RTT. BPF program frequency can be further controlled by calling
> bpf_ktime_get_ns and bailing out early.
>
> I run neper tcp_stream and tcp_rr tests with the sample program
> from the last patch and didn't observe any noticeable performance
> difference.
>
> v2:
> * add a comment about second accept() in selftest (Yonghong Song)
> * refer to tcp_bpf.readme in sample program (Yonghong Song)
>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Priyaranjan Jha <priyarjha@google.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>

Ack for the whole series.
Acked-by: Yonghong Song <yhs@fb.com>

>
> Stanislav Fomichev (8):
>   bpf: add BPF_CGROUP_SOCK_OPS callback that is executed on every RTT
>   bpf: split shared bpf_tcp_sock and bpf_sock_ops implementation
>   bpf: add dsack_dups/delivered{,_ce} to bpf_tcp_sock
>   bpf: add icsk_retransmits to bpf_tcp_sock
>   bpf/tools: sync bpf.h
>   selftests/bpf: test BPF_SOCK_OPS_RTT_CB
>   samples/bpf: add sample program that periodically dumps TCP stats
>   samples/bpf: fix tcp_bpf.readme detach command
>
>  include/net/tcp.h                           |   8 +
>  include/uapi/linux/bpf.h                    |  12 +-
>  net/core/filter.c                           | 207 +++++++++++-----
>  net/ipv4/tcp_input.c                        |   4 +
>  samples/bpf/Makefile                        |   1 +
>  samples/bpf/tcp_bpf.readme                  |   2 +-
>  samples/bpf/tcp_dumpstats_kern.c            |  68 ++++++
>  tools/include/uapi/linux/bpf.h              |  12 +-
>  tools/testing/selftests/bpf/Makefile        |   3 +-
>  tools/testing/selftests/bpf/progs/tcp_rtt.c |  61 +++++
>  tools/testing/selftests/bpf/test_tcp_rtt.c  | 254 ++++++++++++++++++++
>  11 files changed, 574 insertions(+), 58 deletions(-)
>  create mode 100644 samples/bpf/tcp_dumpstats_kern.c
>  create mode 100644 tools/testing/selftests/bpf/progs/tcp_rtt.c
>  create mode 100644 tools/testing/selftests/bpf/test_tcp_rtt.c
>
> --
> 2.22.0.410.gd8fdbe21b5-goog
