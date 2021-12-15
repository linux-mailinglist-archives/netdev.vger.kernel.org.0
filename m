Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E04476567
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 23:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhLOWHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 17:07:51 -0500
Received: from mg.ssi.bg ([193.238.174.37]:40264 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231207AbhLOWHu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 17:07:50 -0500
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 97F7AA3D1;
        Thu, 16 Dec 2021 00:07:49 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 1E581A363;
        Thu, 16 Dec 2021 00:07:48 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 554E23C0332;
        Thu, 16 Dec 2021 00:07:45 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.16.1/8.16.1) with ESMTP id 1BFM7d6l104799;
        Thu, 16 Dec 2021 00:07:42 +0200
Date:   Thu, 16 Dec 2021 00:07:39 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Martin KaFai Lau <kafai@fb.com>
cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [RFC PATCH v2 net-next] net: Preserve skb delivery time during
 forward
In-Reply-To: <20211215201158.271976-1-kafai@fb.com>
Message-ID: <7567da39-cf7c-ce8e-e2b1-34f517ca74e9@ssi.bg>
References: <20211215201158.271976-1-kafai@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Wed, 15 Dec 2021, Martin KaFai Lau wrote:

> diff --git a/net/ipv4/ip_forward.c b/net/ipv4/ip_forward.c
> index 00ec819f949b..f216fc97c6ce 100644
> --- a/net/ipv4/ip_forward.c
> +++ b/net/ipv4/ip_forward.c
> @@ -79,7 +79,7 @@ static int ip_forward_finish(struct net *net, struct sock *sk, struct sk_buff *s
>  	if (unlikely(opt->optlen))
>  		ip_forward_options(skb);
>  
> -	skb->tstamp = 0;
> +	skb_scrub_tstamp(skb);

	Just to let you know, you can consider all places in
net/netfilter/ipvs/ip_vs_xmit.c that reset tstamp as a forwarding path
like this one.

>  	return dst_output(net, sk, skb);
>  }

Regards

--
Julian Anastasov <ja@ssi.bg>

