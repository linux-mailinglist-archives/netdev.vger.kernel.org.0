Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774672F2A15
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 09:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405574AbhALIba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 03:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733047AbhALIb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 03:31:29 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDC7C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 00:30:49 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id u17so2339506iow.1
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 00:30:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kd2c+YvvXv+KaWLmotZfTGxQ72eF3ig1UcWVbi1v/qM=;
        b=enHN0Sc1mwQ5iGeQSyfwWgvAVypkJ4MPAh7VASXd3tsKm1dGsRx7HW9SNVw6pG/msj
         ODtHGO1w0WWDILOPbtXZI7WgmE1ZnXltnzLdD5CC/BdxwNFu5/rziOmXTv4xoJp92CY6
         VDXMl1/nRpt6gvB1oFAEAVvIA67RaCTCn0aKqt3m/02lvW7KeFPaaPTP4WJDPA/1Pc+R
         uhciMXjzWC8DL0Sf/k9auLk1BLp2F0Z6YzYeeqo7lLKUf3gUwAAuFJagnRkRCktLJjXU
         I5pyd7jxCVxhaEpj8AigdCxv2mdUyD4OxaUPh6P0uSj0YJRsGT1mN+BFJD7ju6LaH+8j
         lZwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kd2c+YvvXv+KaWLmotZfTGxQ72eF3ig1UcWVbi1v/qM=;
        b=QAr4laij7xKHe4dxABptoZC+XiKIfANLI2HbU3Qdc2C/0ir5GkONfeGoP0yvc2TOSm
         5laZ2gwNIPxJAb/e3L8A+pkI6KumeCOiCv+niG7bVRRQ2I9qkDT/VfKayvhMk1W0gw5v
         9eKGKsoDGJauXKabskzAv6pM2dxFT9Lc13BQ9qGpsmFjjzXpTCsjhDETzcN/CynKrO0H
         uR6MTq2WsYILZcOO1YNkRDY98MUDBC01P4RFiFICvoEdDmXG4bG7M3/VawWesJ7zZD8V
         PDtArHEILtS/Btn5LMN9LoWtfb/HZrusfqXH0QxqnqkUJpVriMoi896ns/lX14uwUWVU
         ZuFA==
X-Gm-Message-State: AOAM533VQ9GhRQ0OPBlx+2so8Yo5mQQW1od0WTkyVAsXPWp7v6jpofvA
        EVZdzxs2gRGupEpIkQ1SLZetJiYg/tLdjoPy9GS6tQ==
X-Google-Smtp-Source: ABdhPJxmtb0m+uKiunUZ5MBRGubEhWt1aZmxwep9+XYUrf5eaRwPw5N9gaAaozqBU3tfj54S0qh8VNWdUsl0nlVXbhk=
X-Received: by 2002:a92:ce09:: with SMTP id b9mr2821444ilo.69.1610440248307;
 Tue, 12 Jan 2021 00:30:48 -0800 (PST)
MIME-Version: 1.0
References: <20210111222411.232916-1-hcaldwel@akamai.com> <20210111222411.232916-5-hcaldwel@akamai.com>
In-Reply-To: <20210111222411.232916-5-hcaldwel@akamai.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 12 Jan 2021 09:30:37 +0100
Message-ID: <CANn89iLheJ+a0AZ_JZyitsZK5RCVsadzgsBK=DeHs-7ko5OMuQ@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] tcp: remove limit on initial receive window
To:     Heath Caldwell <hcaldwel@akamai.com>
Cc:     netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Josh Hunt <johunt@akamai.com>, Ji Li <jli@akamai.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 11:24 PM Heath Caldwell <hcaldwel@akamai.com> wrote:
>
> Remove the 64KB limit imposed on the initial receive window.
>
> The limit was added by commit a337531b942b ("tcp: up initial rmem to 128KB
> and SYN rwin to around 64KB").
>
> This change removes that limit so that the initial receive window can be
> arbitrarily large (within existing limits and depending on the current
> configuration).
>
> The arbitrary, internal limit can interfere with research because it
> irremediably restricts the receive window at the beginning of a connection
> below what would be expected when explicitly configuring the receive buffer
> size.
>
> -
>
> Here is a scenario to illustrate how the limit might cause undesirable
> behavior:
>
> Consider an installation where all parts of a network are either controlled
> or sufficiently monitored and there is a desired use case where a 1MB
> object is transmitted over a newly created TCP connection in a single
> initial burst.
>
> Let MSS be 1460 bytes.
>
> The initial cwnd would need to be at least:
>
>                 |-  1048576 bytes  -|
>     cwnd_init = |  ---------------  | = 719 packets
>                 |   1460 bytes/pkt  |
>
> Let us say that it was determined that the network could handle bursts of
> 800 full sized packets at the frequency which the connections under
> consideration would be expected to occur, so the sending host is configured
> to use an initial cwnd of 800 for these connections.
>
> In order for the receiver to be able to receive a 1MB burst, it needs to
> have a sufficiently large receive buffer for the connection.  Considering
> overhead, let us say that the receiver is configured to initially use a
> receive buffer of 2148K for TCP connections:
>
>     net.ipv4.tcp_rmem = 4096 2199552 6291456
>
> Let rtt be 50 milliseconds.
>
> If the entire object is sent in a single burst, then the theoretically
> highest achievable throughput (discounting handshake and request) should
> be:
>
>                    bits   1048576 bytes   8 bits
>     T_upperbound = ---- = ------------- * ------ =~ 168 Mbit/s
>                    rtt       0.05 s       1 byte
>
> But, if flow control limits throughput because the receive window is
> initially limited to 64KB and grows at a rate of quadrupling every
> rtt (maybe not accurate but seems to be optimistic from observation), we
> should expect the highest achievable throughput to be limited to:
>
>     bytes_sent = 65536 * (1 + 4)^(t / rtt)
>
>     When bytes_sent = object size = 1048576:
>
>     1048576 = 65536 * (1 + 4)^(t / rtt)
>           t = rtt * log_5(16)
>
>                             1048576 bytes              8 bits
>     T_limited = ------------------------------------ * ------
>                        /    |- rtt * log_5(16) -| \    1 byte
>                 rtt * ( 1 + |  ---------------- |  )
>                        \    |        rtt        | /
>
>                  1048576 bytes     8 bits
>               = ---------------- * ------
>                 0.05 s * (1 + 2)   1 byte
>
>               =~ 55.9 Mbit/s
>
> In short: for this scenario, the 64KB limit on the initial receive window
> increases the achievable acknowledged delivery time from 1 rtt
> to (optimistically) 3 rtts, reducing the achievable throughput from
> 168 Mbit/s to 55.9 Mbit/s.
>
> Here is an experimental illustration:
>
> A time sequence chart of a packet capture taken on the sender for a
> scenario similar to what is described above, where the receiver had the
> 64KB limit in place:
>
> Symbols:
> .:' - Data packets
> _-  - Window advertised by receiver
>
> y-axis - Relative sequence number
> x-axis - Time from sending of first data packet, in seconds
>
> 3212891                                                                   _
> 3089318                                                                   -
> 2965745                                                                   -
> 2842172                                                                   -
> 2718600                                                           ________-
> 2595027                                                           -
> 2471454                                                           -
> 2347881                                                    --------
> 2224309                                                    _
> 2100736                                                    -
> 1977163                                                   --
> 1853590                                                   _
> 1730018                                                   -
> 1606445                                                   -
> 1482872                                                   -
> 1359300                                                   -
> 1235727                                                   -
> 1112154                                                   -
>  988581                                                  _:
>  865009                                   _______--------.:
>  741436                                   .      :       '
>  617863                                  -:
>  494290                                  -:
>  370718                                  .:
>  247145                  --------.-------:
>  123572 _________________:       '
>       0 .:               '
>       0.000    0.028    0.056    0.084    0.112    0.140    0.168    0.195
>
> Note that the sender was not able to send the object in a single initial
> burst and that it took around 4 rtts for the object to be fully
> acknowledged.
>
>
> A time sequence chart of a packet capture taken for the same scenario, but
> with the limit removed:
>
> 2147035                                                                  __
> 2064456                                                                 _-
> 1981878                                                                _-
> 1899300                                                                -
> 1816721                                                               --
> 1734143                                                              _-
> 1651565                                                             _-
> 1568987                                                             -
> 1486408                                                            --
> 1403830                                                           _-
> 1321252                                                          _-
> 1238674                                                          -
> 1156095 ________________________________________________________--
> 1073517
>  990939           :
>  908360          :'
>  825782         :'
>  743204        .:
>  660626        :
>  578047       :'
>  495469      :'
>  412891     .:
>  330313    .:
>  247734    :
>  165156   :'
>   82578  :'
>       0 .:
>       0.000    0.008    0.016    0.025    0.033    0.041    0.049    0.057
>
> Note that the sender was able to send the entire object in a single burst
> and that it was fully acknowledged after a little over 1 rtt.
>
> Signed-off-by: Heath Caldwell <hcaldwel@akamai.com>
> ---
>  net/ipv4/tcp_output.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 1d2773cd02c8..d7ab1f5f071e 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -232,7 +232,7 @@ void tcp_select_initial_window(const struct sock *sk, int __space, __u32 mss,
>         if (sock_net(sk)->ipv4.sysctl_tcp_workaround_signed_windows)
>                 (*rcv_wnd) = min(space, MAX_TCP_WINDOW);
>         else
> -               (*rcv_wnd) = min_t(u32, space, U16_MAX);
> +               (*rcv_wnd) = space;
>
>         if (init_rcv_wnd)
>                 *rcv_wnd = min(*rcv_wnd, init_rcv_wnd * mss);
> --
> 2.28.0
>


I think the whole patch series is an attempt to badly break TCP stack.

Hint : 64K is really the max allowed by TCP standards. Yes, this is
sad, but this is it.

I will not spend hours of work running  packetdrill tests over your
changes, but I am sure they are now quite broken.

If you believe auto tuning is broken, fix it properly, without trying
to change all the code so that you can understand it.

I strongly advise you read RFC 7323 before doing any changes in TCP
stack, and asking us to spend time reviewing your patches.

If you want to do research, this is fine, but please do not break
production TCP stack.

Thank you.
