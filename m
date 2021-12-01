Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1530C464549
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 04:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241616AbhLADOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 22:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241421AbhLADOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 22:14:09 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCEFC061574;
        Tue, 30 Nov 2021 19:10:49 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id s139so45496356oie.13;
        Tue, 30 Nov 2021 19:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zMoUi0+uejRQqW/6fzcBT9/YNPDb50tYTZFrptThgGw=;
        b=edb900FqkmW4y+bKDcUuVHkuACFkRW2bogZ+KHehBjv0HrJM8GP9wyXCtqzYsRaLfL
         DN4vgpFfBa0g2wmgGBWAXkqp1Y7gw4ygnjoCvAz2BpOROMasZuC1IOsAJ0c3zktIEYqo
         HkMiFg9e1qkQ4Q5WO2FEjDXTOr6evm5G8HMEJdnAPA2lOg+C2Tvo47VYCwzBsQggt0DN
         nthjVRVDA0IL1dOIFwA5iMPhiTNgug2DoG2J/QC/jppjfL0gHON8Zm2sXZvw91eyOp6z
         EBeH+/GO5jdh2ZbeaEoHvWM0wdvtH2feGxxGSejSd1r6+nTktp5Kgp3qzmtZ0jmfuVNl
         m1GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zMoUi0+uejRQqW/6fzcBT9/YNPDb50tYTZFrptThgGw=;
        b=WXX/T3PCs+OQHG5e9QUm4wInz224ij88d2oDTwMk5NtmN3QtTsgbSClhEGMGWWBqLR
         87pVFL6QlqLtAYREK4H70im/0hAWfy/dY8zAdNqRY3T4xhY70MBU/79u2q6OGZ0S+oVG
         hjoMIpWxdU+fzofsVBCbkOzRNblME2Zk/tfN/S6sWouCqKcehaN8XVUj+1b4/TXxZbRd
         GzpTY9LT9KizbWO3jV9uH16o0t1nL2seuGSKmnslUkI2aOC2S9oIwnFBHhJOm1LQKCbj
         oTvmAXrAO5xBO03eqWqV6czE6EUryRyesZHIv8h6CjGmCMEnqeqyK83zixrNk0umF6gD
         1zyg==
X-Gm-Message-State: AOAM531pmT9fkD+ZeidnF+yNlZIRrIf7RutQqpxYsXdKLpZUMqXpfiL8
        L8xvFL6Zey/Snhiedhr6b7E=
X-Google-Smtp-Source: ABdhPJw4ZtgyVd1xKnTWaP/McV3auLpFHSPMCajHauJ8PhR5gDve3BtR0j9RPcY9ZEjTSigWp0r0oQ==
X-Received: by 2002:a05:6808:1914:: with SMTP id bf20mr3423560oib.149.1638328249363;
        Tue, 30 Nov 2021 19:10:49 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id h14sm3337273ots.22.2021.11.30.19.10.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 19:10:48 -0800 (PST)
Message-ID: <ae2d2dab-6f42-403a-f167-1ba3db3fd07f@gmail.com>
Date:   Tue, 30 Nov 2021 20:10:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [RFC 00/12] io_uring zerocopy send
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <cover.1638282789.git.asml.silence@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <cover.1638282789.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/30/21 8:18 AM, Pavel Begunkov wrote:
> Early proof of concept for zerocopy send via io_uring. This is just
> an RFC, there are details yet to be figured out, but hope to gather
> some feedback.
> 
> Benchmarking udp (65435 bytes) with a dummy net device (mtu=0xffff):
> The best case io_uring=116079 MB/s vs msg_zerocopy=47421 MB/s,
> or 2.44 times faster.
> 
> № | test:                                | BW (MB/s)  | speedup
> 1 | msg_zerocopy (non-zc)                |  18281     | 0.38
> 2 | msg_zerocopy -z (baseline)           |  47421     | 1
> 3 | io_uring (@flush=false, nr_reqs=1)   |  96534     | 2.03
> 4 | io_uring (@flush=true,  nr_reqs=1)   |  89310     | 1.88
> 5 | io_uring (@flush=false, nr_reqs=8)   | 116079     | 2.44
> 6 | io_uring (@flush=true,  nr_reqs=8)   | 109722     | 2.31
> 
> Based on selftests/.../msg_zerocopy but more limited. You can use
> msg_zerocopy -r as usual for receive side.
> 
...

Can you state the exact command lines you are running for all of the
commands? I tried this set (and commands referenced below) and my
mileage varies quite a bit.

Also, have you run this proposed change (and with TCP) across nodes
(ie., not just local process to local process via dummy interface)?

> Benchmark:
> https://github.com/isilence/liburing.git zc_v1
> 
> or this file in particular:
> https://github.com/isilence/liburing/blob/zc_v1/test/send-zc.c
> 
> To run the benchmark:
> ```
> cd <liburing_dir> && make && cd test
> # ./send-zc -4 [-p <port>] [-s <payload_size>] -D <destination> udp
> ./send-zc -4 -D 127.0.0.1 udp
> ```
> 
> msg_zerocopy can be used for the server side, e.g.
> ```
> cd <linux-kernel>/tools/testing/selftests/net && make
> ./msg_zerocopy -4 -r [-p <port>] [-t <sec>] udp
> ```
> 



