Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3301F451647
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 22:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346475AbhKOVSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 16:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353233AbhKOUza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 15:55:30 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F40C028C35
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 12:37:47 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id b15so77094169edd.7
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 12:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UcRAOtSXPgqZi5vLAUvi/WYjlM16VpPNspIfN4MbJzQ=;
        b=Q6iE8oqBDM7+3yCZv26pmtzuZpavST0kSvbqBfP6QLC+WcjVREFJXHlfDcqsp7pbrc
         iN2EuWMzl4kgDVnkoWrB/GGviirreCzfcePuxUOGQVvgJ/tMoYNGGlaAu+6rrjJZopLr
         kU4PF2QC5pJWfgmtsWKq78b/mJWvAYWekeXpemgv8sDyjm35dwQ8RZ8XwH1eFd+fkUVf
         xuIaeEDvU/ehS9CSeVFwn14q4aoJRZaRqsL4MtZXnGRmUHBF+y2v5Fo7XhtBz/kvoepL
         zrlNKQyupUSZagQ09zYfbjtG8zqvpzty37aRZrAwG8C4AB5zGtZ2tlzbmIzOvn7jt01m
         7moA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UcRAOtSXPgqZi5vLAUvi/WYjlM16VpPNspIfN4MbJzQ=;
        b=bYlmoEC+HgkL3QFTV8rWZlN4NZdaWEZC8CfUPMrekNs410WIUxutFTkzz9czdStKT7
         TM5RI3XFjd5+WOaN44yPOOqczh3QTu1jIDBbX35LSfyi9a5lVorjSVg/VqCVrKbkvN8h
         9cjqYaSc1ObDImHewMw23mWOj2h4x7hCoJnPldEu3VOB0X6GItX1FQ/eNSqfASsqGB+7
         zRN6FSO/ZqD/NudalGENyuzRSMLW3IOrtSuJwYeZqEjFzSUbyHcdaYV09wBOvWYUVqMM
         SmM0Dvsl9QPDU77So/kxv7s7ckhUSju9tyVZw9CaWwA/sdaRwusPY9cxpKur3BDGXu/m
         s/EA==
X-Gm-Message-State: AOAM531eaIvND1J9eHBs6pXZ8G78eUK227Njjni4R87/Pqy7OxSWHGGx
        1pJdI0WIMJ5pJugbEKh2Xb1gvUBKmJnAshoNeyhZYw==
X-Google-Smtp-Source: ABdhPJwf+95nvqDDTAU9nVXtgg7CTWNCJqerO7lmzoA/4FEBsMpuLnZfaHq+xT82t+og0M8vr7Zfb9W9kzaGrNn3gLs=
X-Received: by 2002:aa7:ca4f:: with SMTP id j15mr2342884edt.178.1637008665630;
 Mon, 15 Nov 2021 12:37:45 -0800 (PST)
MIME-Version: 1.0
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
In-Reply-To: <20211115190249.3936899-1-eric.dumazet@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Mon, 15 Nov 2021 15:37:09 -0500
Message-ID: <CACSApvZ47Z9pKGxH_UU=yY+bQqdNt=jc2kpxP-VfZkCXLVSbCg@mail.gmail.com>
Subject: Re: [PATCH net-next 00/20] tcp: optimizations for linux-5.17
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 2:02 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Mostly small improvements in this series.
>
> The notable change is in "defer skb freeing after
> socket lock is released" in recvmsg() (and RX zerocopy)
>
> The idea is to try to let skb freeing to BH handler,
> whenever possible, or at least perform the freeing
> outside of the socket lock section, for much improved
> performance. This idea can probably be extended
> to other protocols.
>
>  Tests on a 100Gbit NIC
>  Max throughput for one TCP_STREAM flow, over 10 runs.
>
>  MTU : 1500  (1428 bytes of TCP payload per MSS)
>  Before: 55 Gbit
>  After:  66 Gbit
>
>  MTU : 4096+ (4096 bytes of TCP payload, plus TCP/IPv6 headers)
>  Before: 82 Gbit
>  After:  95 Gbit

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Wow, this is really impressive. I reviewed all the patches and I can't
point out any issues other than the typo that Arjun has pointed out.
Thank you Eric!

> Eric Dumazet (20):
>   tcp: minor optimization in tcp_add_backlog()
>   tcp: remove dead code in __tcp_v6_send_check()
>   tcp: small optimization in tcp_v6_send_check()
>   net: use sk_is_tcp() in more places
>   net: remove sk_route_forced_caps
>   net: remove sk_route_nocaps
>   ipv6: shrink struct ipcm6_cookie
>   net: shrink struct sock by 8 bytes
>   net: forward_alloc_get depends on CONFIG_MPTCP
>   net: cache align tcp_memory_allocated, tcp_sockets_allocated
>   tcp: small optimization in tcp recvmsg()
>   tcp: add RETPOLINE mitigation to sk_backlog_rcv
>   tcp: annotate data-races on tp->segs_in and tp->data_segs_in
>   tcp: annotate races around tp->urg_data
>   tcp: tp->urg_data is unlikely to be set
>   tcp: avoid indirect calls to sock_rfree
>   tcp: defer skb freeing after socket lock is released
>   tcp: check local var (timeo) before socket fields in one test
>   tcp: do not call tcp_cleanup_rbuf() if we have a backlog
>   net: move early demux fields close to sk_refcnt
>
>  include/linux/skbuff.h     |  2 +
>  include/linux/skmsg.h      |  6 ---
>  include/net/ip6_checksum.h | 12 ++---
>  include/net/ipv6.h         |  4 +-
>  include/net/sock.h         | 51 +++++++++++++--------
>  include/net/tcp.h          | 18 +++++++-
>  net/core/skbuff.c          |  6 +--
>  net/core/sock.c            | 18 +++++---
>  net/ipv4/tcp.c             | 91 ++++++++++++++++++++++++++------------
>  net/ipv4/tcp_input.c       |  8 ++--
>  net/ipv4/tcp_ipv4.c        | 10 ++---
>  net/ipv4/tcp_output.c      |  2 +-
>  net/ipv4/udp.c             |  2 +-
>  net/ipv6/ip6_output.c      |  2 +-
>  net/ipv6/tcp_ipv6.c        | 10 ++---
>  net/mptcp/protocol.c       |  2 +-
>  16 files changed, 149 insertions(+), 95 deletions(-)
>
> --
> 2.34.0.rc1.387.gb447b232ab-goog
>
