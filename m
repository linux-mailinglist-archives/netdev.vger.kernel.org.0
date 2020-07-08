Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE61217E84
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 06:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgGHEnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 00:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbgGHEnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 00:43:39 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F335CC061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 21:43:38 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id a30so6284115ybj.5
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 21:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c4nSWJY1ljw9cm6id+RxBGsTZV9P8UTCeVR1bx+15AA=;
        b=DsB0ZZVwGoRVRF9dt/6tsWxIgrJne7c3Bv7Dg1zp4AM++PUHomNJAjUPXt7pWIdy6L
         aoQqodklWittz2s8pbF42hGsJL5XlST9C2ktwX36nnnwFBMUylJU1LU8OIOJTp5Dc8mY
         8XO6HloVmJYos+I8r5BI3rRllNsp9Ma1rwKhegM1KKY07o1KHuXPBMxFzL8mmnb2M9m/
         vMHK7nLUoWVs3X3Os5ZbANmDglfSqB6DGbc4pYHdDa8ltWP/g7C1w/gEPir8ZP/aLv5X
         6t61HPklw5jFH5NqWBp2TtwiGlUlPK8bDe15D4SpO1PJp3PHECxPPKA3GleFt0tiEAr4
         5bRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c4nSWJY1ljw9cm6id+RxBGsTZV9P8UTCeVR1bx+15AA=;
        b=mjRL3mGotm2i7egftGugea6S2xlTHpiWbOpz47rkTLhfQDZe/1HNvZJFmggTpWk9Yo
         +8GUhTwmycIu3bejrX1eSEwZbWR1utrNKxAE1pwjP+cIajK8H89j9KhGXOIyiVKAHx9h
         0f3Rv/pIEOr4g8o4+mGE7cZ/dJzSgK7+zbzaY+jK67tOYocyXmKG76CoZeEsNqzfnqSL
         b5IBv0yblIn9Z7N6CwuOrEX1IIa1SZ1k4FYnhqtCXJIKXo2/jkYdRpG+ULgZQHUQPBWM
         rOOOUbiXGwooHx3nOjfPBJ/Vbk2mWhS7ADBA8mZgnktZLdzA/i+LmwBV7RhrvGJEMtaY
         E9BA==
X-Gm-Message-State: AOAM533jk7y8oEW/7KLNPYPNlLD+Sc0vw/eZWtKJrkOOc/qkemLZiBi3
        y+r4++QidaKccFkx0zEwDCEvfGgfVHLjl4vHzifHRKAm
X-Google-Smtp-Source: ABdhPJzUgWwP45PYWf8sJDTpyiRyczGeMbEKvvo28GuJZYIVwRfwzyxEaPRsUIbaoRlr6qP6UF/16W/3Qwi1A5SOhd8=
X-Received: by 2002:a25:81c2:: with SMTP id n2mr69714321ybm.520.1594183417699;
 Tue, 07 Jul 2020 21:43:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200708041030.24375-1-cpaasch@apple.com>
In-Reply-To: <20200708041030.24375-1-cpaasch@apple.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 7 Jul 2020 21:43:26 -0700
Message-ID: <CANn89iLZ1kDbpm81ftXkrtKBNx-NVHSYzP++_Jd0-xwy2J2Mpg@mail.gmail.com>
Subject: Re: [PATCH net] tcp: Initialize ca_priv when inheriting from listener
To:     Christoph Paasch <cpaasch@apple.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 9:11 PM Christoph Paasch <cpaasch@apple.com> wrote:
>
> syzkaller found its way into setsockopt with TCP_CONGESTION "cdg".
> tcp_cdg_init() does a kcalloc to store the gradients. As sk_clone_lock
> just copies all the memory, the allocated pointer will be copied as
> well, if the app called setsockopt(..., TCP_CONGESTION) on the listener.
> If now the socket will be destroyed before the congestion-control
> has properly been initialized (through a call to tcp_init_transfer), we
> will end up freeing memory that does not belong to that particular
> socket, opening the door to a double-free:
>
> Wei Wang fixed a part of these CDG-malloc issues with commit c12014440750
> ("tcp: memset ca_priv data to 0 properly").
>
> This patch here fixes the listener-scenario by memsetting ca_priv to 0
> after its content has been inherited by the listener.
>
> (The issue can be reproduced at least down to v4.4.x.)
>
> Cc: Wei Wang <weiwan@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Fixes: 2b0a8c9ee ("tcp: add CDG congestion control")
> Signed-off-by: Christoph Paasch <cpaasch@apple.com>
> ---
>  net/ipv4/inet_connection_sock.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index afaf582a5aa9..dc9432f9248a 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -850,6 +850,8 @@ struct sock *inet_csk_clone_lock(const struct sock *sk,
>                 newicsk->icsk_backoff     = 0;
>                 newicsk->icsk_probes_out  = 0;
>
> +               memset(newicsk->icsk_ca_priv, 0, sizeof(newicsk->icsk_ca_priv));
> +

Could this be done instead in tcp_disconnect() ?

Thanks !
