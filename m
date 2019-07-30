Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23EE97A8D6
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 14:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730594AbfG3Ml2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 08:41:28 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45770 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729651AbfG3Ml1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 08:41:27 -0400
Received: by mail-wr1-f66.google.com with SMTP id f9so65590126wre.12
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 05:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BlP4513unQUdet+MKvQ2g15uNq4TvoNSOCqk6BEJf7o=;
        b=gJ1Zv7I1MINBx3xVNBcaEWYgqiAI2Hxdpv8UWLgZ1l+KCYj74JMQWldehUfc6SIkAz
         6wAw9qlPZq6SQKIeNsAhxvcBfOZEMvPvAc5Q0LHyJdD4gVZgojW4m+qLNz4GfrBixnVY
         AKPWBhhHasuwPOKwO/HteYm4dTpfSYy2+WL0w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BlP4513unQUdet+MKvQ2g15uNq4TvoNSOCqk6BEJf7o=;
        b=DxMLjH/3C9HPjRL+Ssk83KfxoAj8iI2AUjHtPhvO0s+cz3LxnpQRehdXcn7EHNvJ/o
         4JnYasazPivGOfe7hTP4mvmZduiVi8kwJba/JcMap9vtVB3NRejGa5+Q16xDXih1Xo9G
         TJLK8Wr2gzPlfohgr5XHqkTdTAfyakiFsBuUif7xZZYxjgwSG+trE+hJ+EIlCy1rwyBD
         1IL6PNby3aLFof5A4DKVOj/52BqlxQJuFmow15Np2lGWqZZrLco7YzR9CurGBhcsT9If
         UlEQw6zvkGKtUO4KEUPmkOPw960SCjlLTONq5Bzn6/bL/DUFNWoY8aZx2TCU3Rnzz1OA
         KtFg==
X-Gm-Message-State: APjAAAWOWWo1zuXQC44pDSZPFMko2P2EPsE88pNj4Kk9yZ4BJvb4cjrM
        Wgx+XX6yiZxAw+2Nre+HosXe+Fw/JZU=
X-Google-Smtp-Source: APXvYqymLpYKBAlscHzFKItEq4jYCoeLBstlJUeaMgXHLDywH09H+q/A04KfrqhOZLQGA6w7A4n4MQ==
X-Received: by 2002:a5d:5507:: with SMTP id b7mr12759586wrv.35.1564490485822;
        Tue, 30 Jul 2019 05:41:25 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id g12sm94634989wrv.9.2019.07.30.05.41.24
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 05:41:25 -0700 (PDT)
Subject: Re: [PATCH] bridge:fragmented packets dropped by bridge
To:     Rundong Ge <rdong.ge@gmail.com>, davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, roopa@cumulusnetworks.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20190730122534.30687-1-rdong.ge@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <1dc87e69-628b-fd04-619a-8dbe5bdfa108@cumulusnetworks.com>
Date:   Tue, 30 Jul 2019 15:41:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190730122534.30687-1-rdong.ge@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/07/2019 15:25, Rundong Ge wrote:
> Given following setup:
> -modprobe br_netfilter
> -echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
> -brctl addbr br0
> -brctl addif br0 enp2s0
> -brctl addif br0 enp3s0
> -brctl addif br0 enp6s0
> -ifconfig enp2s0 mtu 1300
> -ifconfig enp3s0 mtu 1500
> -ifconfig enp6s0 mtu 1500
> -ifconfig br0 up
> 
>                  multi-port
> mtu1500 - mtu1500|bridge|1500 - mtu1500
>   A                  |            B
>                    mtu1300
> 
> With netfilter defragmentation/conntrack enabled, fragmented
> packets from A will be defragmented in prerouting, and refragmented
> at postrouting.
> But in this scenario the bridge found the frag_max_size(1500) is
> larger than the dst mtu stored in the fake_rtable whitch is
> always equal to the bridge's mtu 1300, then packets will be dopped.
> 
> This modifies ip_skb_dst_mtu to use the out dev's mtu instead
> of bridge's mtu in bridge refragment.
> 
> Signed-off-by: Rundong Ge <rdong.ge@gmail.com>
> ---
>  include/net/ip.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/net/ip.h b/include/net/ip.h
> index 29d89de..0512de3 100644
> --- a/include/net/ip.h
> +++ b/include/net/ip.h
> @@ -450,6 +450,8 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
>  static inline unsigned int ip_skb_dst_mtu(struct sock *sk,
>  					  const struct sk_buff *skb)
>  {
> +	if ((skb_dst(skb)->flags & DST_FAKE_RTABLE) && skb->dev)
> +		return min(skb->dev->mtu, IP_MAX_MTU);
>  	if (!sk || !sk_fullsock(sk) || ip_sk_use_pmtu(sk)) {
>  		bool forwarding = IPCB(skb)->flags & IPSKB_FORWARDED;
>  
> 

I don't think this is correct, there's a reason why the bridge chooses the smallest
possible MTU out of its members and this is simply a hack to circumvent it.
If you really like to do so just set the bridge MTU manually, we've added support
so it won't change automatically to the smallest, but then how do you pass packets
1500 -> 1300 in this setup ?

You're talking about the frag_size check in br_nf_ip_fragment(), right ?

