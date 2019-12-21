Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 701F1128ADD
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 19:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfLUSnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 13:43:31 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59833 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726107AbfLUSnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 13:43:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576953809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/IKMfNlBgm1uhuVWquo/hRU8+66mSpgvhMX1puHSh7k=;
        b=WRJDSlXk7PSnFv3iuMaHHQYkH+Jsw+T/QCnHtRWg9xlCeKu2zcxtP5/OuQrc8hFQYXiWid
        /N8p8/jd3l4Ag4QPJnmJZgn7cBctl1SAMYXfAuqaep8bU+dbkVayBF/0OnTjcIqtccA2nf
        x+NAOx0c7QRRqVlGb9I1ujZQoHMl/I0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-d319J2ZvPF2YOftoo-Vz5w-1; Sat, 21 Dec 2019 13:43:26 -0500
X-MC-Unique: d319J2ZvPF2YOftoo-Vz5w-1
Received: by mail-wr1-f70.google.com with SMTP id d8so5489399wrq.12
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 10:43:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/IKMfNlBgm1uhuVWquo/hRU8+66mSpgvhMX1puHSh7k=;
        b=NDEH9j12YM3vPUMqATzbN68wHpnyWoaINj3+Mht9A7hCb3XBDerQlkZ2jl9T2+3hRr
         K0Kj9fnifflOIbBWLvBy3wfYXUrv93jlcZ6rhIWW/UM8QPjhAHyTVZ4gQAFPCXttGvsL
         nhEX8mQNCDtuHuGDBrn5Xoq1zzZ/fbuVMRFktOkf1WTF9GTc1gQZaZ1c0ikJDFY5Ergx
         Z5WlGmjHuxtncHB7QRUM4dnpaa2GaYr0oX+Q6Mi7JeAxj05w3rZ8mbkXQeUDkORDs5fq
         nC9pVymaduCytJaAyAb1Wt5D9vSR6k5Tr4usklQX9uX8OBBPF/Zsomjgr6k//NZEJbt0
         Cg1Q==
X-Gm-Message-State: APjAAAWcuX9TxLsdT/kAMeNYS7/3zcC3gJaIswuw9Q++SkEiHZCFk1IW
        DtKDxPGifnEQ0LCxM2vopYKsYy1u6TL96d8XRMN33r112spKT7K67WXKBLcgIMaKwZ/PqvNkghK
        8PMCeKndgJGU4Ht5r
X-Received: by 2002:a1c:6585:: with SMTP id z127mr22932920wmb.113.1576953805017;
        Sat, 21 Dec 2019 10:43:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqyO6D43LKv5/xa8kBoDmA/eKxFl6Wj6tjFQFAT44c1UO2p2QYI2LZtbe/Ic6vmWNlWLCk1xbA==
X-Received: by 2002:a1c:6585:: with SMTP id z127mr22932907wmb.113.1576953804819;
        Sat, 21 Dec 2019 10:43:24 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id z3sm14026519wrs.94.2019.12.21.10.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 10:43:24 -0800 (PST)
Date:   Sat, 21 Dec 2019 19:43:22 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Pablo Neira <pablo@netfilter.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kodanev <alexey.kodanev@oracle.com>
Subject: Re: [PATCHv4 net 5/8] tunnel: do not confirm neighbor when do pmtu
 update
Message-ID: <20191221184322.GD7352@linux.home>
References: <20191218115313.19352-1-liuhangbin@gmail.com>
 <20191220032525.26909-1-liuhangbin@gmail.com>
 <20191220032525.26909-6-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220032525.26909-6-liuhangbin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 11:25:22AM +0800, Hangbin Liu wrote:
> When do tunnel PMTU update and calls __ip6_rt_update_pmtu() in the end,
> we should not call dst_confirm_neigh() as there is no two-way communication.
> 
> v4: Update commit description
> v3: Do not remove dst_confirm_neigh, but add a new bool parameter in
>     dst_ops.update_pmtu to control whether we should do neighbor confirm.
>     Also split the big patch to small ones for each area.
> v2: Remove dst_confirm_neigh in __ip6_rt_update_pmtu.
> 
> Fixes: 0dec879f636f ("net: use dst_confirm_neigh for UDP, RAW, ICMP, L2TP")
> Reviewed-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  net/ipv4/ip_tunnel.c  | 2 +-
>  net/ipv6/ip6_tunnel.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
> index 38c02bb62e2c..0fe2a5d3e258 100644
> --- a/net/ipv4/ip_tunnel.c
> +++ b/net/ipv4/ip_tunnel.c
> @@ -505,7 +505,7 @@ static int tnl_update_pmtu(struct net_device *dev, struct sk_buff *skb,
>  		mtu = skb_valid_dst(skb) ? dst_mtu(skb_dst(skb)) : dev->mtu;
>  
>  	if (skb_valid_dst(skb))
> -		skb_dst_update_pmtu(skb, mtu);
> +		skb_dst_update_pmtu_no_confirm(skb, mtu);
>  
>  	if (skb->protocol == htons(ETH_P_IP)) {
>  		if (!skb_is_gso(skb) &&
> diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> index 754a484d35df..2f376dbc37d5 100644
> --- a/net/ipv6/ip6_tunnel.c
> +++ b/net/ipv6/ip6_tunnel.c
> @@ -640,7 +640,7 @@ ip4ip6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
>  		if (rel_info > dst_mtu(skb_dst(skb2)))
>  			goto out;
>  
> -		skb_dst_update_pmtu(skb2, rel_info);
> +		skb_dst_update_pmtu_no_confirm(skb2, rel_info);
>  	}
>  
>  	icmp_send(skb2, rel_type, rel_code, htonl(rel_info));
> @@ -1132,7 +1132,7 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
>  	mtu = max(mtu, skb->protocol == htons(ETH_P_IPV6) ?
>  		       IPV6_MIN_MTU : IPV4_MIN_MTU);
>  
> -	skb_dst_update_pmtu(skb, mtu);
> +	skb_dst_update_pmtu_no_confirm(skb, mtu);
>  	if (skb->len - t->tun_hlen - eth_hlen > mtu && !skb_is_gso(skb)) {
>  		*pmtu = mtu;
>  		err = -EMSGSIZE;

Tested-by: Guillaume Nault <gnault@redhat.com>

Note that ip6gretap devices seem to accept frames regardless of their
destination MAC address. That's wrong, but makes this bug invisible
in practice.

