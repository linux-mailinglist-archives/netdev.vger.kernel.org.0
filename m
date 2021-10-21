Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CEB436897
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 19:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbhJUREn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 13:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhJUREk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 13:04:40 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D99C061764
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 10:02:23 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id y12so1385876eda.4
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 10:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P9TML8RCTVS1bODiQOo82vEEFgc7UObiX07Uyq0dB3A=;
        b=DqspBffcRtkVsovvxdVq9ktgX8Q3dRmPgJbKU/B2oQFi+BHmSjOVabP8MzIDHYeDoz
         MKO8+7/8sP7m0AnvNN5kB9kC/tDm3feoLsBvAQpLt/fIzg8xD6CdLD6Sv8JhPW7j6+zw
         xg1nKfMv1LW9nszd7Ah/dy9L9PGyGawWckE/aXybmfLlmCBHnShQ1qUL23MGR37NkW9N
         cD37pE+Dvb2P5ct+8bEspIqKluoChCr7bTbKvms1frr7EwyxpGwlRT9sPLWgFUOo5VBq
         Oa1/qTt0dTwtm3RlbVghplmiiCWLSnPvZvGFVUT9J2HVDqysOKHM+GcOr2mvVQMxRlIn
         i/Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P9TML8RCTVS1bODiQOo82vEEFgc7UObiX07Uyq0dB3A=;
        b=DUAkl0hJ21RF0QVRQYmFY+pQXrDMOTUIJkNZYKdx3tVWRmH+LhySP8FuHr276WzpDP
         Exzw2MfO2EKsj0MlpMMiJ2qM/1Ywj9uA42s7x6CVePVBD03mq3X82ugrfqxyBcaSXyVL
         FyHRjgPGgL1MjByC55Ew7adpPL45fpckdbQqmVdsQYOp90eR7G/d1nATGydMf4UoXGIQ
         I+uodAhXyNs2J1eOzFJPWwvqQKBgaBKKhbw2uFu3LdCLREJexMiMpN/iEyejb98v9NyU
         Z6iLzHDoA2ldIyFqApXCtGZ0pzs9pcB9dSVlL9DBBfbEvRFiQfDfiv4cgT+KXBn70uka
         sSgQ==
X-Gm-Message-State: AOAM5322oseqM9SxMfb3GM8Mec6qq2QIA72TGo6OyrQPDkygNE3M6BX1
        /erHaalzxk8TUMEdMNkqfeb1rEv2roV+HSAuXSX7tg==
X-Google-Smtp-Source: ABdhPJzAzXnw5mqEKXX6CewYAmxgkAPeweZpgKYy74iu9CNcSJdlcxpE9QxrQwAR5Aq+CUVt5+jCthXi505vDv7w7KY=
X-Received: by 2002:a05:6402:229a:: with SMTP id cw26mr9039136edb.273.1634835742054;
 Thu, 21 Oct 2021 10:02:22 -0700 (PDT)
MIME-Version: 1.0
References: <20211021162253.333616-1-eric.dumazet@gmail.com>
In-Reply-To: <20211021162253.333616-1-eric.dumazet@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Thu, 21 Oct 2021 13:01:45 -0400
Message-ID: <CACSApvaMpim0Wk3pK8aaSdd-cp+=PcD64v9fFPXrxWp5_39nBg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/9] tcp: receive path optimizations
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 12:23 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> This series aims to reduce cache line misses in RX path.
>
> I am still working on better cache locality in tcp_sock but
> this will wait few more weeks.
>
> Eric Dumazet (9):
>   tcp: move inet->rx_dst_ifindex to sk->sk_rx_dst_ifindex
>   ipv6: move inet6_sk(sk)->rx_dst_cookie to sk->sk_rx_dst_cookie
>   net: avoid dirtying sk->sk_napi_id
>   net: avoid dirtying sk->sk_rx_queue_mapping
>   ipv6: annotate data races around np->min_hopcount
>   ipv6: guard IPV6_MINHOPCOUNT with a static key
>   ipv4: annotate data races arount inet->min_ttl
>   ipv4: guard IP_MINTTL with a static key
>   ipv6/tcp: small drop monitor changes

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Very nice patch series!  The IP_MINTTL patch is an excellent find. I
wonder how many more of these we have. Thank you, Eric!

>  include/linux/ipv6.h     |  1 -
>  include/net/busy_poll.h  |  3 ++-
>  include/net/inet_sock.h  |  3 +--
>  include/net/ip.h         |  2 ++
>  include/net/ipv6.h       |  1 +
>  include/net/sock.h       | 11 +++++++----
>  net/ipv4/ip_sockglue.c   | 11 ++++++++++-
>  net/ipv4/tcp_ipv4.c      | 25 ++++++++++++++++---------
>  net/ipv6/ipv6_sockglue.c | 11 ++++++++++-
>  net/ipv6/tcp_ipv6.c      | 35 +++++++++++++++++++++--------------
>  net/ipv6/udp.c           |  4 ++--
>  11 files changed, 72 insertions(+), 35 deletions(-)
>
> --
> 2.33.0.1079.g6e70778dc9-goog
>
