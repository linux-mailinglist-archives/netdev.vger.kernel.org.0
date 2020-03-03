Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA24F177D97
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 18:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730480AbgCCRfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 12:35:33 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42873 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgCCRfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 12:35:33 -0500
Received: by mail-pf1-f196.google.com with SMTP id f5so1798918pfk.9;
        Tue, 03 Mar 2020 09:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=WkVh/k4rL3AX2FwgznjQ7+FIXTpn8tc0ju3LZfBvJzE=;
        b=C0CwqxMgPLO0t7LTxrAOMa27mMm7psOycH49YjymNlK8XTM7XP87IwiEO6Xx15MT6Y
         54xJkgXE6eeBrzDn1nudf0b74+IMfEs1qZeotkEhr4yqcDyNOx4UXDBaw+zCgmhOXk+d
         BbgYkqghrhPhhIkVeD+RhU9M/5zsipev2qWRr1zHHLQEPnIpc142oDSKbAx1KQd0ZG+b
         FCkiGNKfdhBhiMb/ok8hNMlPY1V37Bi8fb8DMm9yxE02CA9LZ9AHQw4+fYS5ae9HeQ0C
         GZInhJCdvntiq6QgA9XrOM5KI4MbQkceXY8MgLkCT+7jE2+WHpsk04z878EJA2xJLYC8
         uOTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=WkVh/k4rL3AX2FwgznjQ7+FIXTpn8tc0ju3LZfBvJzE=;
        b=HSt+H+e3C/VtcLbTXZU4Wbhuik77KkO0Xo4wOFfWEg7ULYzZXTKBqcUP6O1qgAAA/3
         gHZoxZHBGhAompEm/q9B+ds4EI8mVOIeDov+iQkuz+ut/4A1Toxtm38g3sEB37Hu6uEl
         fiV5bzofAhsMhuhsg6/DlbMPXdiOHA1yUV04/WNtSYmDPSLSFAycYY1e48SKvml3baLv
         Iwr24iY7GTikVszJua34idNyNBemZXxsMn8RxJsd+JFxrhjl/m2AeCZoYWQzxmal+Dfy
         /wN7lf1Jjzae9damwlHxl1VAlQyeT96fJcgcTOQzF5grpz232TtvHhdMFv5cb2bHZTE+
         4u4Q==
X-Gm-Message-State: ANhLgQ2qZX/9GkNrRlYGh55wUTvJsgljG+kWHPXqHj9IjWtCgIgjjjWW
        hlG5kTEnR0z3cZrZ4pKWNtM=
X-Google-Smtp-Source: ADFU+vvvqd3vmlVlsDufe2JJfg3YSdlTz7lAbXvviZbOmybYyAEswHgziCWsVBzZBQ9j9KCyehM5lQ==
X-Received: by 2002:aa7:9815:: with SMTP id e21mr5375233pfl.174.1583256930511;
        Tue, 03 Mar 2020 09:35:30 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id f1sm3045463pjq.31.2020.03.03.09.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 09:35:29 -0800 (PST)
Date:   Tue, 03 Mar 2020 09:35:22 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, john.fastabend@gmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5e5e955a27139_60e72b06ba14c5bc67@john-XPS-13-9370.notmuch>
In-Reply-To: <20200228115344.17742-2-lmb@cloudflare.com>
References: <20200228115344.17742-1-lmb@cloudflare.com>
 <20200228115344.17742-2-lmb@cloudflare.com>
Subject: RE: [PATCH bpf-next v2 1/9] bpf: sockmap: only check ULP for TCP
 sockets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> The sock map code checks that a socket does not have an active upper
> layer protocol before inserting it into the map. This requires casting
> via inet_csk, which isn't valid for UDP sockets.
> 
> Guard checks for ULP by checking inet_sk(sk)->is_icsk first.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  include/linux/skmsg.h |  8 +++++++-
>  net/core/sock_map.c   | 11 +++++++----
>  2 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index 112765bd146d..54a9a3e36b29 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -360,7 +360,13 @@ static inline void sk_psock_restore_proto(struct sock *sk,
>  					  struct sk_psock *psock)
>  {
>  	sk->sk_prot->unhash = psock->saved_unhash;
> -	tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
> +	if (inet_sk(sk)->is_icsk) {

use sock_map_sk_has_ulp() here as well and then drop the !icsk->icsk_ulp_ops
case in tcp_update_ulp()?

> +		tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
> +	} else {
> +		sk->sk_write_space = psock->saved_write_space;
> +		/* Pairs with lockless read in sk_clone_lock() */
> +		WRITE_ONCE(sk->sk_prot, psock->sk_proto);
> +	}
>  }
>  
>  static inline void sk_psock_set_state(struct sk_psock *psock,
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index 2e0f465295c3..695ecacc7afa 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -94,6 +94,11 @@ static void sock_map_sk_release(struct sock *sk)
>  	release_sock(sk);
>  }
>  
> +static bool sock_map_sk_has_ulp(struct sock *sk)
> +{
> +	return inet_sk(sk)->is_icsk && !!inet_csk(sk)->icsk_ulp_ops;
> +}
> +
>  static void sock_map_add_link(struct sk_psock *psock,
>  			      struct sk_psock_link *link,
>  			      struct bpf_map *map, void *link_raw)
> @@ -384,7 +389,6 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
>  				  struct sock *sk, u64 flags)
>  {
>  	struct bpf_stab *stab = container_of(map, struct bpf_stab, map);
> -	struct inet_connection_sock *icsk = inet_csk(sk);
>  	struct sk_psock_link *link;
>  	struct sk_psock *psock;
>  	struct sock *osk;
> @@ -395,7 +399,7 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
>  		return -EINVAL;
>  	if (unlikely(idx >= map->max_entries))
>  		return -E2BIG;
> -	if (unlikely(rcu_access_pointer(icsk->icsk_ulp_data)))
> +	if (sock_map_sk_has_ulp(sk))
>  		return -EINVAL;
>  
>  	link = sk_psock_init_link();
> @@ -738,7 +742,6 @@ static int sock_hash_update_common(struct bpf_map *map, void *key,
>  				   struct sock *sk, u64 flags)
>  {
>  	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
> -	struct inet_connection_sock *icsk = inet_csk(sk);
>  	u32 key_size = map->key_size, hash;
>  	struct bpf_htab_elem *elem, *elem_new;
>  	struct bpf_htab_bucket *bucket;
> @@ -749,7 +752,7 @@ static int sock_hash_update_common(struct bpf_map *map, void *key,
>  	WARN_ON_ONCE(!rcu_read_lock_held());
>  	if (unlikely(flags > BPF_EXIST))
>  		return -EINVAL;
> -	if (unlikely(icsk->icsk_ulp_data))
> +	if (sock_map_sk_has_ulp(sk))
>  		return -EINVAL;
>  
>  	link = sk_psock_init_link();
> -- 
> 2.20.1
> 
