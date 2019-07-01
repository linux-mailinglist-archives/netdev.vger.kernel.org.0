Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2775C4C4
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 23:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfGAVED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 17:04:03 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51156 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfGAVED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 17:04:03 -0400
Received: by mail-wm1-f66.google.com with SMTP id n9so871776wmi.0
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 14:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m7g/Dtye8fNnmt4ZetsK+1jSDaLtAM8RMUVdLZaMuaI=;
        b=jUMpQGnUtM6AyD0cqQp0onXdXcMRhHbYhnNIzrWWCz0rr9Go2YiWr0up+yNDFIeSHv
         vdr6zbn9MP+xmEG8joKTqQw8E0B7JXXqSNEOZElb6ygI3CTdZ3XeBKKisU6jdoE7L9JV
         f41UzPF9Jeo5g+yNHARAcsmyPbRHXOU4LkDDjvEuZLkHpbpw9G3qQq540Adm3l8MBlNw
         /HgR3vNxO04QnsaBvUcbGG7sZGk7/GPngoafQlnqGncjSNxNJENAhKW81LLBsWnzTcJw
         gsNTGwPvNg+Hb/ZPsftOtUiw8dhnWDvkbcS1T3VaqrWw/i40uG5SZynAlvsJ0Pry90Cu
         3nig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m7g/Dtye8fNnmt4ZetsK+1jSDaLtAM8RMUVdLZaMuaI=;
        b=BZX5SdjbwyL8ifLGSfNA+ffdy57+AyDz55i1r/on9JbF4BVy2esFt04skqLAPpCcC5
         rM1sT4WHnX/m1XyYD0S614CTTWwoCKYHXvLP/nBUjVlv8aDaxMUw/dN2EEh0Dj93sqi3
         Fkj6tQirNGvA5J8uNjc8UYCm+uPONzi178QuL6mwCedJSRN3jkqzjDoBIq/3KwxAOURH
         gcZyS+sX6SI0JILoN3oPyaPr+vnLCHlSL0RrFHCzxMAtNXsOv++HxRH1vw8WVQVE9DDd
         bMwWnzGvvJYiyhTR4rlHD+jR6nXsAvOS2y3rQCkHm5Z+d7sA255DvsLKt0eMfABqwFcz
         DxAQ==
X-Gm-Message-State: APjAAAXXLJs6mri2U0KT+qzNqk5KvHTagkcm6IRfIGi8c6po9ORjYOhd
        5YInAndZy1oF2qwBcBc7tdWGQa8jiHBn+5RSiih+EJJ1LKjkBA==
X-Google-Smtp-Source: APXvYqwGLJbJrFZ0W2+FIb0PxdMx8+tntMLc4EGdjvZOL3sFHTjVNCN2PQF8V26njVbt0+EUH31CxoFhw2qcF7L+lFg=
X-Received: by 2002:a05:600c:2205:: with SMTP id z5mr665485wml.175.1562015040340;
 Mon, 01 Jul 2019 14:04:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190701204821.44230-1-sdf@google.com>
In-Reply-To: <20190701204821.44230-1-sdf@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Mon, 1 Jul 2019 17:03:24 -0400
Message-ID: <CACSApvaq+_dqQOHUSxHd+5r0FtL2duOOOP+GFKCDdVzpvUWaiw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/8] bpf: TCP RTT sock_ops bpf callback
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 4:48 PM Stanislav Fomichev <sdf@google.com> wrote:
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
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Priyaranjan Jha <priyarjha@google.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Thank you for the nice patch series!


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
>  samples/bpf/tcp_dumpstats_kern.c            |  65 +++++
>  tools/include/uapi/linux/bpf.h              |  12 +-
>  tools/testing/selftests/bpf/Makefile        |   3 +-
>  tools/testing/selftests/bpf/progs/tcp_rtt.c |  61 +++++
>  tools/testing/selftests/bpf/test_tcp_rtt.c  | 253 ++++++++++++++++++++
>  11 files changed, 570 insertions(+), 58 deletions(-)
>  create mode 100644 samples/bpf/tcp_dumpstats_kern.c
>  create mode 100644 tools/testing/selftests/bpf/progs/tcp_rtt.c
>  create mode 100644 tools/testing/selftests/bpf/test_tcp_rtt.c
>
> --
> 2.22.0.410.gd8fdbe21b5-goog
