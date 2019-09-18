Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3BA1B673C
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 17:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731686AbfIRPgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 11:36:17 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:46510 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731031AbfIRPgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 11:36:16 -0400
Received: by mail-yb1-f195.google.com with SMTP id t2so151112ybo.13
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 08:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zd3nsnTHdLth2JkAShLfNLris+aBYyaQr1Y14HuBHbw=;
        b=p7yUw7Xh1ghVHX2jqsJ6PfjtlD3IRYSc9TkPHIHUHK6Om9EXbCdjfLfAnqFdHe1cD4
         JgGE4hqiA+DAaogjAWkBSHtuU0PV2P7TlfEIfwfuvQbPnLCCC4R2gdNO+AN/9ZTPtdXf
         TDhbByiLjNq82Ufqwb9ykPU8g/Li3YBJfOjEawbyuoetaT/h+zkd8T92nNUdejEF5lFr
         bFhpvsxgkAiuYExhHglXthsx+9Lle/TfDz4M6o/ahdSVQ/8O2AoKE2vIaJ/hBu1wQmyF
         nbRnpRI/ayAX0ac1tvFyCzhifGNePFhnAFJfLzvt7pTs1kRVW4HJUNUn0H76J3E0IzhS
         0vTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zd3nsnTHdLth2JkAShLfNLris+aBYyaQr1Y14HuBHbw=;
        b=QB63lUDwOIS0ier242fbA6W9HQlqsV9GhvRxAASAiNwyWE/Df05hspf/Z5O3zwl9Iw
         En/n/enlRpfFECgpaaLSY4sZI/WeGJfEFROFtwHo0uuJx1kyZ0mO3+2GiRjuNNESPkgs
         G2C9Kg/tMJPhVd+Lx2sdfLimYRrMw4vXqxSg4D4lHrqQQUN+3pTxbAKlBDH/fbJptZ1X
         4lrHS9fSe93Rqzkmwost+pQYr3aKWe76h4tpznxXG9M2ZFjIceqQbPxozFZs7E4r6a1z
         aKZkkgH3vfFarBMtvMwC2oKgrDjcY3pDq9nydhtIy8F0y6z3Jsn8zbe/YCx04AjhxZ05
         vJzw==
X-Gm-Message-State: APjAAAWFB/IEl1bSbCRwu4G/6StKd6IKrSKTabejEOBq5d2nvJs/1Ozf
        T0Qb20Sscxz4fCZv3BRaV0JW5FaC
X-Google-Smtp-Source: APXvYqxwKmcXEZ+deQrps9UwWaD6PJcMPX+gWPk+efqIK1Qt4VA3OZEL73tTvF87LiUCiRsfyY/Qqw==
X-Received: by 2002:a25:df91:: with SMTP id w139mr3003589ybg.161.1568820974881;
        Wed, 18 Sep 2019 08:36:14 -0700 (PDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id o11sm1206312ywc.42.2019.09.18.08.36.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2019 08:36:13 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id t15so164967ybg.7
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 08:36:12 -0700 (PDT)
X-Received: by 2002:a25:774d:: with SMTP id s74mr3313586ybc.473.1568820972393;
 Wed, 18 Sep 2019 08:36:12 -0700 (PDT)
MIME-Version: 1.0
References: <ce01f024-268d-a44e-8093-91be97f1e8b0@akamai.com>
In-Reply-To: <ce01f024-268d-a44e-8093-91be97f1e8b0@akamai.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 18 Sep 2019 11:35:35 -0400
X-Gmail-Original-Message-ID: <CA+FuTSc3O4XQAmtyY5Fwy96nL17ewdCouvwAJ=6DeMUcQUiz8A@mail.gmail.com>
Message-ID: <CA+FuTSc3O4XQAmtyY5Fwy96nL17ewdCouvwAJ=6DeMUcQUiz8A@mail.gmail.com>
Subject: Re: udp sendmsg ENOBUFS clarification
To:     Josh Hunt <johunt@akamai.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 17, 2019 at 4:20 PM Josh Hunt <johunt@akamai.com> wrote:
>
> I was running some tests recently with the udpgso_bench_tx benchmark in
> selftests and noticed that in some configurations it reported sending
> more than line rate! Looking into it more I found that I was overflowing
> the qdisc queue and so it was sending back NET_XMIT_DROP however this
> error did not propagate back up to the application and so it assumed
> whatever it sent was done successfully. That's when I learned about
> IP_RECVERR and saw that the benchmark isn't using that socket option.
>
> That's all fairly straightforward, but what I was hoping to get
> clarification on is where is the line drawn on when or when not to send
> ENOBUFS back to the application if IP_RECVERR is *not* set? My guess
> based on going through the code is that as long as the packet leaves the
> stack (in this case sent to the qdisc) that's where we stop reporting
> ENOBUFS back to the application, but can someone confirm?

Once a packet is queued the system call may return, so any subsequent
drops after dequeue are not propagated back. The relevant rc is set in
__dev_xmit_skb on q->enqueue. On setups with multiple devices, such as
a tunnel or bonding path, enqueue on the lower device is similar not
propagated.

> For example, we sanitize the error in udp_send_skb():
> send:
>          err = ip_send_skb(sock_net(sk), skb);
>          if (err) {
>                  if (err == -ENOBUFS && !inet->recverr) {
>                          UDP_INC_STATS(sock_net(sk),
>                                        UDP_MIB_SNDBUFERRORS, is_udplite);
>                          err = 0;
>                  }
>          } else
>
>
> but in udp_sendmsg() we don't:
>
>          if (err == -ENOBUFS || test_bit(SOCK_NOSPACE,
> &sk->sk_socket->flags)) {
>                  UDP_INC_STATS(sock_net(sk),
>                                UDP_MIB_SNDBUFERRORS, is_udplite);
>          }
>          return err;

That's interesting. My --incorrect-- understanding until now had been
that IP_RECVERR does nothing but enable optional extra detailed error
reporting on top of system call error codes.

But indeed it enables backpressure being reported as a system call
error that is suppressed otherwise. I don't know why. The behavior
precedes git history.

> In the case above it looks like we may only get ENOBUFS for allocation
> failures inside of the stack in udp_sendmsg() and so that's why we
> propagate the error back up to the application?

Both the udp lockless fast path and the slow corked path go through
udp_send_skb, so the backpressure is suppressed consistently across
both cases.

Indeed the error handling in udp_sendmsg then is not related to
backpressure, but to other causes of ENOBUF, i.e., allocation failure.
