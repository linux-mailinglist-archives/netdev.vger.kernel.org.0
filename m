Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFDB3C59E7
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 13:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348561AbhGLJL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 05:11:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40085 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1385268AbhGLJKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 05:10:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626080843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZkXKb2qzdKIDldnhlEcH6K5EKaNpCNY88P0hdfI/UNE=;
        b=Sn8bbVsJbGwxKxJMn8KxnXHBanDcYwkagaLbEbno/L82aRdCtXYZp1o6dbd3AusF2sWsHC
        J1UUsiiz8iTkPBckQGB5ZB0wHRWUXPUGeSfFip9dC9q7WKDVvWs5Kdw1rOWzvY5onA4gLs
        LYMYKIArE0BbvIDT+HBNJwXHJTEbmzc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-mUMgKCCFOT-DRCWvMYR7tw-1; Mon, 12 Jul 2021 05:07:20 -0400
X-MC-Unique: mUMgKCCFOT-DRCWvMYR7tw-1
Received: by mail-wm1-f72.google.com with SMTP id k5-20020a7bc3050000b02901e081f69d80so2738257wmj.8
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 02:07:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ZkXKb2qzdKIDldnhlEcH6K5EKaNpCNY88P0hdfI/UNE=;
        b=GigOY4zBLUi+7zU7dbsbaOIHdcWDyCaPpxqiDmvofPspdYruQ+LWGYlXYbXT/xZMht
         Mz8lJ55yTXa5IWSl52VXhv27IRxEkYvLlP3hRtnYOyy6mQrspiB0Z8iQyfJJa4x5IOLm
         XbUE2LYxjdu0XQf7eGRw8ePAyqHEauipxv03Nma1eNqD0y3918rCMxDma7XvyfC6qzFC
         jA61fIHupsjFT7tIVldIb9KSovfECCJMfRS95+LOf30hYWAFQecpTH41vPiZmNv/fiKp
         0VOnDbl96tIht//CQ91X4P/GNnMgTXk0ZmPjRyKGO+koBuY8dFR8qC0Qu0YEALuCCIVu
         +99g==
X-Gm-Message-State: AOAM530POvD6z3kYYUNYqWn0eCvHofX4g+roOM0RZ6MDz3mgyv/Oy0nP
        AJuqnBfZ7K+lL2m9lhqs/+90GGYkpqiKfH3roKAT3DMCEEYK2fmDZroQL0++IEu/vJMdg3Ik+7g
        2ggNWBKMViTsB2hXj
X-Received: by 2002:a1c:f30a:: with SMTP id q10mr54180821wmq.138.1626080838843;
        Mon, 12 Jul 2021 02:07:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyInH8bK7AMUkRMfqTrCNVA6p06eEoPsG2pWdLrN9jMFsb9o2XIexdWcIvKJMXQDhZsESxspg==
X-Received: by 2002:a1c:f30a:: with SMTP id q10mr54180792wmq.138.1626080838525;
        Mon, 12 Jul 2021 02:07:18 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-171.dyn.eolo.it. [146.241.112.171])
        by smtp.gmail.com with ESMTPSA id t22sm12573005wmi.22.2021.07.12.02.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 02:07:18 -0700 (PDT)
Message-ID: <4cf247328ea397c28c9c404094fb0f952a41f3c6.camel@redhat.com>
Subject: Re: [PATCH net 2/3] udp: check encap socket in __udp_lib_err
From:   Paolo Abeni <pabeni@redhat.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date:   Mon, 12 Jul 2021 11:07:16 +0200
In-Reply-To: <20210712005554.26948-3-vfedorenko@novek.ru>
References: <20210712005554.26948-1-vfedorenko@novek.ru>
         <20210712005554.26948-3-vfedorenko@novek.ru>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2021-07-12 at 03:55 +0300, Vadim Fedorenko wrote:
> Commit d26796ae5894 ("udp: check udp sock encap_type in __udp_lib_err")
> added checks for encapsulated sockets but it broke cases when there is
> no implementation of encap_err_lookup for encapsulation, i.e. ESP in
> UDP encapsulation. Fix it by calling encap_err_lookup only if socket
> implements this method otherwise treat it as legal socket.
> 
> Fixes: d26796ae5894 ("udp: check udp sock encap_type in __udp_lib_err")
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> ---
>  net/ipv4/udp.c | 24 +++++++++++++++++++++++-
>  net/ipv6/udp.c | 22 ++++++++++++++++++++++
>  2 files changed, 45 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index e5cb7fedfbcd..4980e0f19990 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -707,7 +707,29 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
>  	sk = __udp4_lib_lookup(net, iph->daddr, uh->dest,
>  			       iph->saddr, uh->source, skb->dev->ifindex,
>  			       inet_sdif(skb), udptable, NULL);
> -	if (!sk || udp_sk(sk)->encap_enabled) {
> +	if (sk && udp_sk(sk)->encap_enabled) {
> +		int (*lookup)(struct sock *sk, struct sk_buff *skb);
> +
> +		lookup = READ_ONCE(udp_sk(sk)->encap_err_lookup);
> +		if (lookup) {
> +			int network_offset, transport_offset;
> +
> +			network_offset = skb_network_offset(skb);
> +			transport_offset = skb_transport_offset(skb);
> +
> +			/* Network header needs to point to the outer IPv4 header inside ICMP */
> +			skb_reset_network_header(skb);
> +
> +			/* Transport header needs to point to the UDP header */
> +			skb_set_transport_header(skb, iph->ihl << 2);
> +			if (lookup(sk, skb))
> +				sk = NULL;
> +			skb_set_transport_header(skb, transport_offset);
> +			skb_set_network_header(skb, network_offset);
> +		}
> +	}
> +
> +	if (!sk) {
>  		/* No socket for error: try tunnels before discarding */
>  		sk = ERR_PTR(-ENOENT);
>  		if (static_branch_unlikely(&udp_encap_needed_key)) {
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 798916d2e722..ed49a8589d9f 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -558,6 +558,28 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
>  
>  	sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
>  			       inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
> +	if (sk && udp_sk(sk)->encap_enabled) {
> +		int (*lookup)(struct sock *sk, struct sk_buff *skb);
> +
> +		lookup = READ_ONCE(udp_sk(sk)->encap_err_lookup);
> +		if (lookup) {
> +			int network_offset, transport_offset;
> +
> +			network_offset = skb_network_offset(skb);
> +			transport_offset = skb_transport_offset(skb);
> +
> +			/* Network header needs to point to the outer IPv6 header inside ICMP */
> +			skb_reset_network_header(skb);
> +
> +			/* Transport header needs to point to the UDP header */
> +			skb_set_transport_header(skb, offset);
> +			if (lookup(sk, skb))
> +				sk = NULL;
> +			skb_set_transport_header(skb, transport_offset);
> +			skb_set_network_header(skb, network_offset);
> +		}
> +	}

I can't follow this code. I guess that before d26796ae5894,
__udp6_lib_err() used to invoke ICMP processing on the ESP in UDP
socket, and after d26796ae5894 'sk' was cleared
by __udp4_lib_err_encap(), is that correct?

After this patch, the above chunk will not clear 'sk' for packets
targeting ESP in UDP sockets, but AFAICS we will still enter the
following conditional, preserving the current behavior - no ICMP
processing. 

Can you please clarify?

Why can't you use something alike the following instead?

---
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index c0f9f3260051..96a3b640e4da 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -707,7 +707,7 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
        sk = __udp4_lib_lookup(net, iph->daddr, uh->dest,
                               iph->saddr, uh->source, skb->dev->ifindex,
                               inet_sdif(skb), udptable, NULL);
-       if (!sk || udp_sk(sk)->encap_type) {
+       if (!sk || READ_ONCE(udp_sk(sk)->encap_err_lookup)) {
                /* No socket for error: try tunnels before discarding */
                sk = ERR_PTR(-ENOENT);
                if (static_branch_unlikely(&udp_encap_needed_key)) {

---

Thanks!

/P

