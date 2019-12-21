Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF86C128AD0
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 19:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfLUSad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 13:30:33 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53929 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726107AbfLUSac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 13:30:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576953030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LB8m3iWkUtLz/PlBZFVImUXu9V+7qz7Xx2g60a0njl0=;
        b=StV0j3KwUW34jvzi4lanVpk5asqiR7IkbuA4FD5wl9rO0OyhOp3FAoaUrzA9jdzLjtft5S
        QqSjfiW/h2hB5J/lPxF/evLd5euNtF9CVMscdP3oug3SdluoV5gcag6hOQTAYNQkB5skK8
        6GiJcXJeXBcWFfjfeSQKkuh0rYoxy/g=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-O5WegrkvNsi5jY-NaLW4Yg-1; Sat, 21 Dec 2019 13:30:29 -0500
X-MC-Unique: O5WegrkvNsi5jY-NaLW4Yg-1
Received: by mail-wr1-f71.google.com with SMTP id d8so5477028wrq.12
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 10:30:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LB8m3iWkUtLz/PlBZFVImUXu9V+7qz7Xx2g60a0njl0=;
        b=YBto4Kz7mLLSdjx3KRRlsRn38tUsAlhXJmlMDpnVw1F8dHaMZqLNqN+SnY8BGRR2fQ
         j7tCuLXyLTwqailIiIItm92qArtsSSDu9iXhHE39xvVk6yypX2bYUX/lsd0RDJ/N9laW
         0sDd8h2NmAwEJb7WCQVGvkZwJOrh6isuPovYl0bvoHNqYCb4LrZHJ2BQreTK0FJdc6LC
         wFJElM8uGOfUwkpzKNqVQszG6wRUadRrHHO28acJx7PtYnGgZID6ACJKPRfHdextxEwp
         qdwtVCRsjw1W7Zk3tgwlzRQxkpd+ipm60r66cSKQbIbEA/8lzY8PLIhlv9RMnMwinhRk
         do/g==
X-Gm-Message-State: APjAAAWEipo8gXYxdXWC1H9g+VHXF81gcK6/t29YJsIb7q65kWM7zpW9
        0tw+yP6B2XS+mzt4jc8Ewv3ql+/29Cnj1Hf/wPqvCGM0X5NsnBaISsSYsVja4EqjOZ5bEAhHl5V
        LvBOyxKvVILbLvgpy
X-Received: by 2002:a5d:4e0a:: with SMTP id p10mr21341446wrt.229.1576953027552;
        Sat, 21 Dec 2019 10:30:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqzGlLM9f31hiLSCx0N98WyORMC0Vzoi16RohIYz2q7mo1sXxDmyhBVFjNvacB56DbGgcOu04Q==
X-Received: by 2002:a5d:4e0a:: with SMTP id p10mr21341430wrt.229.1576953027310;
        Sat, 21 Dec 2019 10:30:27 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id x18sm14241160wrr.75.2019.12.21.10.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 10:30:26 -0800 (PST)
Date:   Sat, 21 Dec 2019 19:30:24 +0100
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
Subject: Re: [PATCHv4 net 6/8] vti: do not confirm neighbor when do pmtu
 update
Message-ID: <20191221183024.GA7352@linux.home>
References: <20191218115313.19352-1-liuhangbin@gmail.com>
 <20191220032525.26909-1-liuhangbin@gmail.com>
 <20191220032525.26909-7-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220032525.26909-7-liuhangbin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 11:25:23AM +0800, Hangbin Liu wrote:
> Although ip vti is not affected as __ip_rt_update_pmtu() does not call
> dst_confirm_neigh(), we still not do neigh confirm to keep consistency with
> IPv6 code.
> 
As with the GRE case, the problem is not the IP version used on the
underlay. The problem happens when the tunnel transports IPv6 packets
(which vti can do).

However, it's true that vti is immune to this problem, but that's for
another reason: it's an IFF_NOARP interface (which means vti6 is immune
too).

Patch is good (we really have no reason to confirm neighbour here), but
let's not have a misleading commit message.

> v4: No change.
> v3: Do not remove dst_confirm_neigh, but add a new bool parameter in
>     dst_ops.update_pmtu to control whether we should do neighbor confirm.
>     Also split the big patch to small ones for each area.
> v2: Remove dst_confirm_neigh in __ip6_rt_update_pmtu.
> 
> Reviewed-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  net/ipv4/ip_vti.c  | 2 +-
>  net/ipv6/ip6_vti.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
> index cfb025606793..fb9f6d60c27c 100644
> --- a/net/ipv4/ip_vti.c
> +++ b/net/ipv4/ip_vti.c
> @@ -214,7 +214,7 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
>  
>  	mtu = dst_mtu(dst);
>  	if (skb->len > mtu) {
> -		skb_dst_update_pmtu(skb, mtu);
> +		skb_dst_update_pmtu_no_confirm(skb, mtu);
>  		if (skb->protocol == htons(ETH_P_IP)) {
>  			icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
>  				  htonl(mtu));
> diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
> index 024db17386d2..6f08b760c2a7 100644
> --- a/net/ipv6/ip6_vti.c
> +++ b/net/ipv6/ip6_vti.c
> @@ -479,7 +479,7 @@ vti6_xmit(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
>  
>  	mtu = dst_mtu(dst);
>  	if (skb->len > mtu) {
> -		skb_dst_update_pmtu(skb, mtu);
> +		skb_dst_update_pmtu_no_confirm(skb, mtu);
>  
>  		if (skb->protocol == htons(ETH_P_IPV6)) {
>  			if (mtu < IPV6_MIN_MTU)
> -- 
> 2.19.2
> 

