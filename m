Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4324BA6FC
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 18:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243645AbiBQRTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 12:19:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242759AbiBQRTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 12:19:02 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D9C18555F
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 09:18:46 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id 124so14394357ybn.11
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 09:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4D9BYkb+B9VWduw7MRayrV7vgbkTMuHw+Tpw1tHce/Y=;
        b=IkkyccPpXJkr5bTXrXA4clBEyQs0gqmFo2GV9lD1q83DNHYZaQ8akgkVqlAcrYeuWh
         kG44P+33cKfDVR5aNaZ5R+aXZaIJhPLpLmxkSduLBnGCU3A6qnPdEyyhOjE15xj8o0LD
         +fowtM4ntthcqk/s+AykenwjemyHj1lDCq69Q57+XeL+6N5Sq/xDA+y4rYYFWHHQHjEn
         2y/Zb6hPXlPiSsqf5vcN+B/TuYLlcQq/3F1PFpwMeg6wKpBsuxBy/G4S5s/yByqNbIAK
         bKnPE2xfRcKto51RtFKsjEYqVLl09ZpkL2cBYbLMbQ5hWxHfmx221sn0sLNDlZ1KwWjR
         FA4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4D9BYkb+B9VWduw7MRayrV7vgbkTMuHw+Tpw1tHce/Y=;
        b=sxCMZoWd/Y4HsrDgHT249KMnr3eNZLACMTAlghotgimgcMgkuwThyvRtjPoSHof0Fd
         FZh2xr+bbA5liEW0kFId9DCz7z0UyAAuLBazH8d+m9RQanV3gCdlD4uLGWyQ4RtfMA73
         U2tKppy5W9DBreaVXAKpLhB5IxgmuX8k2ATRSBtBNSkS7945EBje6QEkuIdr3gQZuvJ8
         8VUS4GmAqn1DLhiHrkkjdvI9BNykEqmA0DlsclR7gcdNdID43Ls1KdTMTb1z/NBHxx5v
         ItG85JDyQJ7ANK1KLs60x7AR7SCrFqV+5Khh9Ak4CoqR30L8NWqsCCU7dElKeeOKXwM6
         5s7w==
X-Gm-Message-State: AOAM5331Tg63bRrwjKil5YPgNo/aBNSv/ArDpRWhmPTs1zhlKcKLiuil
        vn0Fh2l4qkbMvw4xCNA0buQEm6I/Lyj4QXAjB91qJA==
X-Google-Smtp-Source: ABdhPJx0951rzmeVFDs/I3F9GX26b6J25dMaMog+pENQdT17H2+FzQd9pWZW3wBRT9h37vA0adKDa8N9/Zqvasyrczg=
X-Received: by 2002:a25:a4e8:0:b0:61e:1eb6:19bd with SMTP id
 g95-20020a25a4e8000000b0061e1eb619bdmr3463355ybi.168.1645118325949; Thu, 17
 Feb 2022 09:18:45 -0800 (PST)
MIME-Version: 1.0
References: <20220217170502.641160-1-eric.dumazet@gmail.com>
In-Reply-To: <20220217170502.641160-1-eric.dumazet@gmail.com>
From:   Marco Elver <elver@google.com>
Date:   Thu, 17 Feb 2022 18:18:34 +0100
Message-ID: <CANpmjNMR_3Z9BfB9hYzHvjqwJV4AetHAm+ZPAOPFJhZin=jD_A@mail.gmail.com>
Subject: Re: [PATCH net] net-timestamp: convert sk->sk_tskey to atomic_t
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Feb 2022 at 18:05, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> UDP sendmsg() can be lockless, this is causing all kinds
> of data races.
>
> This patch converts sk->sk_tskey to remove one of these races.
>
> BUG: KCSAN: data-race in __ip_append_data / __ip_append_data
>
> read to 0xffff8881035d4b6c of 4 bytes by task 8877 on cpu 1:
>  __ip_append_data+0x1c1/0x1de0 net/ipv4/ip_output.c:994
>  ip_make_skb+0x13f/0x2d0 net/ipv4/ip_output.c:1636
>  udp_sendmsg+0x12bd/0x14c0 net/ipv4/udp.c:1249
>  inet_sendmsg+0x5f/0x80 net/ipv4/af_inet.c:819
>  sock_sendmsg_nosec net/socket.c:705 [inline]
>  sock_sendmsg net/socket.c:725 [inline]
>  ____sys_sendmsg+0x39a/0x510 net/socket.c:2413
>  ___sys_sendmsg net/socket.c:2467 [inline]
>  __sys_sendmmsg+0x267/0x4c0 net/socket.c:2553
>  __do_sys_sendmmsg net/socket.c:2582 [inline]
>  __se_sys_sendmmsg net/socket.c:2579 [inline]
>  __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2579
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> write to 0xffff8881035d4b6c of 4 bytes by task 8880 on cpu 0:
>  __ip_append_data+0x1d8/0x1de0 net/ipv4/ip_output.c:994
>  ip_make_skb+0x13f/0x2d0 net/ipv4/ip_output.c:1636
>  udp_sendmsg+0x12bd/0x14c0 net/ipv4/udp.c:1249
>  inet_sendmsg+0x5f/0x80 net/ipv4/af_inet.c:819
>  sock_sendmsg_nosec net/socket.c:705 [inline]
>  sock_sendmsg net/socket.c:725 [inline]
>  ____sys_sendmsg+0x39a/0x510 net/socket.c:2413
>  ___sys_sendmsg net/socket.c:2467 [inline]
>  __sys_sendmmsg+0x267/0x4c0 net/socket.c:2553
>  __do_sys_sendmmsg net/socket.c:2582 [inline]
>  __se_sys_sendmmsg net/socket.c:2579 [inline]
>  __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2579
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> value changed: 0x0000054d -> 0x0000054e
>
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 0 PID: 8880 Comm: syz-executor.5 Not tainted 5.17.0-rc2-syzkaller-00167-gdcb85f85fa6f-dirty #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>
> Fixes: 09c2d251b707 ("net-timestamp: add key to disambiguate concurrent datagrams")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> ---
>  include/net/sock.h        | 4 ++--
>  net/can/j1939/transport.c | 2 +-
>  net/core/skbuff.c         | 2 +-
>  net/core/sock.c           | 4 ++--
>  net/ipv4/ip_output.c      | 2 +-
>  net/ipv6/ip6_output.c     | 2 +-
>  6 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index ff9b508d9c5ffcb9a30deb730b27046e463bda37..50aecd28b355082bce495a89a8a871b15e3e7e2c 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -507,7 +507,7 @@ struct sock {
>  #endif
>         u16                     sk_tsflags;
>         u8                      sk_shutdown;
> -       u32                     sk_tskey;
> +       atomic_t                sk_tskey;
>         atomic_t                sk_zckey;
>
>         u8                      sk_clockid;
> @@ -2667,7 +2667,7 @@ static inline void _sock_tx_timestamp(struct sock *sk, __u16 tsflags,
>                 __sock_tx_timestamp(tsflags, tx_flags);
>                 if (tsflags & SOF_TIMESTAMPING_OPT_ID && tskey &&
>                     tsflags & SOF_TIMESTAMPING_TX_RECORD_MASK)
> -                       *tskey = sk->sk_tskey++;
> +                       *tskey = atomic_inc_return(&sk->sk_tskey) - 1;
>         }
>         if (unlikely(sock_flag(sk, SOCK_WIFI_STATUS)))
>                 *tx_flags |= SKBTX_WIFI_STATUS;
> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> index a271688780a2c1a3bff6c2578502f972da34a30b..307ee1174a6e2e3d8cb9edd2c7485ddd22014ce6 100644
> --- a/net/can/j1939/transport.c
> +++ b/net/can/j1939/transport.c
> @@ -2006,7 +2006,7 @@ struct j1939_session *j1939_tp_send(struct j1939_priv *priv,
>                 /* set the end-packet for broadcast */
>                 session->pkt.last = session->pkt.total;
>
> -       skcb->tskey = session->sk->sk_tskey++;
> +       skcb->tskey = atomic_inc_return(&session->sk->sk_tskey) - 1;

We also have atomic_fetch_inc() in case it'd make this simpler.

Thanks,
-- Marco
