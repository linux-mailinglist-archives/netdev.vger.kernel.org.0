Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86CE92DFB43
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 11:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgLUK7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 05:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgLUK7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 05:59:07 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6E2C0613D3
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 02:58:26 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id r17so8448771ilo.11
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 02:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QIp+mV/WJgMEgWWJXAkSTYZSjnAI022WVk6Ekdiuuc0=;
        b=DLzGVLzqvfpdLSsOzP+ocYP7J1REDIoYR+agUQYUo3716c45gEPqI6imjb5v6JegZZ
         6x4bxYmVRLrXgs5qUethDf0knCZfKA8IWTyBhJhNUVlWUnYk4MAOPOgzaSFPRGLCq4ol
         WHVyJ6h9ZIifn7mSh7lytmQZAlvgOmHZc+qr6inm60NI9tq0LU0bVrXChLKcbrsnlhge
         iQwZv/Wz7/r2ug+hqvL1FIRxYhbl4LC+WN/qG51W20N889H8h+pyWeq06l2ZrIDR64IP
         prUbSiFL3rcYKOVB0xx5QP50wELVwYPSds4g5BGVNgNCUsGR/v4yF/O4BuNsKSoCIK5o
         l/dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QIp+mV/WJgMEgWWJXAkSTYZSjnAI022WVk6Ekdiuuc0=;
        b=PfejnxA4kP4etqMr0cxAjd5gUe27VPOUf46xx10fAiLr9kvEz4nKq+qGAMC+O6RH30
         kDB9j+U/XPbsInp25YQEEudC3b+byesA0gx2pasH6nzYUUNXm4bLObXnnbmBh2yGY7Aj
         0Epd7NzmeN/0ZoVpjUzpCZg7c3vDm/5SclCd1Rtz85U0M3yM8V2q1B+X3aW4BDdsF3MY
         irrUibp1iMoAnMWGpNZJvENwGTxTTaJTf5ErTR6XJqAYtmSNWuJC/BJmCi6ld9IvK6iU
         /v6JWft+Bh0lnYzfxlW7BaMgmAYpC/AYPba/BtbjaKhDElO7SBQlK3YtSQJrdM9GZYRc
         p8TA==
X-Gm-Message-State: AOAM533nOV9I6bhd1jEmEkAosQSQ4hFiLF1T5cbZOcLx1P4KHyjSxnA6
        7KG04jyhavnGZ8UM2dUStxFa8VVC5gDSBx26zpwp9g==
X-Google-Smtp-Source: ABdhPJzqGQNAs+QVgEnMAgUtfn/kbbIxuArfU+fnHto5EaAEMGOfVwhaVW7Hx6eTQXangqzJ3+M2quiiUSmFKZ0Cpqw=
X-Received: by 2002:a92:d0ca:: with SMTP id y10mr15785390ila.68.1608548306175;
 Mon, 21 Dec 2020 02:58:26 -0800 (PST)
MIME-Version: 1.0
References: <c885eca1-1563-f0a6-bf21-a8fc8762a68e@posteo.de>
In-Reply-To: <c885eca1-1563-f0a6-bf21-a8fc8762a68e@posteo.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 21 Dec 2020 11:58:14 +0100
Message-ID: <CANn89iKtG7i7Q3V=s-5+vx08+iYXPbEB6HUz0+VBfF0g-Bfodw@mail.gmail.com>
Subject: Re: PROBLEM: Poor wlan performance with lots of retries since kernel 5.9
To:     Rainer Suhm <automat@posteo.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 12:19 AM Rainer Suhm <automat@posteo.de> wrote:
>
> Since kernel 5.9 I do have very poor wlan performance with one of my machines.
> The transmission rate is only about a tenth of normal speed (~60MB/s -> 6 MB/s).
> iperf3 -c <server> shows hundreds of retries per second
> --- snip ---
> [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> [  5]   0.00-1.00   sec  8.55 MBytes  71.7 Mbits/sec  649   1.41 KBytes
> [  5]   1.00-2.00   sec  5.78 MBytes  48.5 Mbits/sec  366   17.0 KBytes
> [  5]   2.00-3.00   sec  5.97 MBytes  50.0 Mbits/sec  371   19.8 KBytes
> [  5]   3.00-4.00   sec  5.84 MBytes  49.0 Mbits/sec  390   17.0 KBytes
> [  5]   4.00-5.00   sec  6.21 MBytes  52.1 Mbits/sec  380   19.8 KBytes
> [  5]   5.00-6.00   sec  4.54 MBytes  38.1 Mbits/sec  299   1.41 KBytes
> [  5]   6.00-7.00   sec  6.34 MBytes  53.2 Mbits/sec  367   26.9 KBytes
> [  5]   7.00-8.00   sec  6.15 MBytes  51.6 Mbits/sec  390   19.8 KBytes
> [  5]   8.00-9.00   sec  5.65 MBytes  47.4 Mbits/sec  370   2.83 KBytes
> [  5]   9.00-10.00  sec  5.78 MBytes  48.5 Mbits/sec  377   21.2 KBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  60.8 MBytes  51.0 Mbits/sec  3959             sender
> [  5]   0.00-10.00  sec  60.1 MBytes  50.4 Mbits/sec                  receiver
> --- snap ---
> (this measurement was taken after booting from the current official arch iso)
>
> The problem is only when transmitting data. Receiving (iperf3 -c <server> -R) works ok.
> No related errors/warnings in dmesg.
> The problem exists since kernel v5.9 up to 10.0.2-rc1
> Using other (older) WiFi firmware doesn't help.
> Hardware: TUXEDO InfinityBook S 14 v5/L140CU,
> with Intel(R) Wi-Fi 6 AX200 160MHz, REV=0x340
> The machine runs Arch Linux, all updates installed.
> On all my other laptops this problem doesn't show up.
>
>
> Bisecting leads to:
> --- snip ---
> 3d5b459ba0e3788ab471e8cb98eee89964a9c5e8 is the first bad commit
> commit 3d5b459ba0e3788ab471e8cb98eee89964a9c5e8
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Wed Jun 17 20:53:26 2020 -0700
>
>       net: tso: add UDP segmentation support
>
>       Note that like TCP, we do not support additional encapsulations,
>       and that checksums must be offloaded to the NIC.
>
>       Signed-off-by: Eric Dumazet <edumazet@google.com>
>       Signed-off-by: David S. Miller <davem@davemloft.net>
>
>    net/core/tso.c | 29 ++++++++++++++++++-----------
>    1 file changed, 18 insertions(+), 11 deletions(-)
> --- snap ---
>
> After reverting e89964a9c5e8, everything seems ok. WLan works with expected speed, and iperf3 doesn't show retries any more.
> I confirm this for kernels 5.10.1 and 5.10.2-rc1 (00017-gc96cfd687a3f).
>
> If I should provide more information, let me know.
> Please note: I'm not on any list. So please make sure to address me explicitly if replying to this mail.
>
>
Thanks for the report.

A similar report has been sent a few days ago by Ben Greear, let's
keep the discussion there please.
