Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0148C4EE
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 01:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfHMXzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 19:55:48 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41354 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfHMXzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 19:55:48 -0400
Received: by mail-lf1-f68.google.com with SMTP id 62so73120231lfa.8
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 16:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4iXU/C6pf33HCDPo5fhQcIUwnsXXu+ebTLB7mLl7XAU=;
        b=capqvQSQUWEFarfxrjzUrvlZ3naU8oioqXJFwhmOKaDTouKRjwxZVeQf74qzhHAcxd
         PJmQ6DRoCG+e5SpDr+lh6TtLegRb5WhRYyR+/yVwzHCSbONDkfJ1cIjQtpeeJwKX69KU
         Egp1aTZu9Olp5pivKcnvO29OGARppJkibzMX4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4iXU/C6pf33HCDPo5fhQcIUwnsXXu+ebTLB7mLl7XAU=;
        b=qnk2U7UWeDPB/Wh2pX7bBRezhk+EsmMVRyTxMUqPlOuf7UHyWc8N9VJuJ3237C697R
         7oTP89+geNobU/Cb+8tbrEj03/rHXjQEsurWWhgtcb63srn7AAfMI7CUoP6402NDPi1t
         6uZBbqRCSzSfHb17nq0wCgCLeHMd5m4R4pED8qrmlFU+vZt0fClc4sLN//ozNFjWcXXh
         211adbiPgEIXH8Otik2oEuhZNVAIg8ROCEW407/qN4YJUteO7Gq1zt4HGGKMhflJAGoN
         4+npl0h/EWTohrtVfqsxM0XxyPx1Cz4PDAp2+cNLnDn2ee0q4d5NdbS6Xf5KsQA0lvFd
         dsbg==
X-Gm-Message-State: APjAAAVd+gV1Iiq60n3SkFjoezLYxGyj8mBxNQq7e8YCirY6yThPghZo
        ASQMCEkbIl6w2SY9tuUks3glsw==
X-Google-Smtp-Source: APXvYqx/IFiDpfI6aidJrTW/pTh+u8hjepBLmdTTDNTDv1YxJ3zQA/eqND2jDJ5H1A4igOFJ9vXPKA==
X-Received: by 2002:ac2:5314:: with SMTP id c20mr23748162lfh.1.1565740545844;
        Tue, 13 Aug 2019 16:55:45 -0700 (PDT)
Received: from [192.168.0.104] ([79.134.174.40])
        by smtp.googlemail.com with ESMTPSA id j17sm3054469lfh.9.2019.08.13.16.55.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2019 16:55:45 -0700 (PDT)
Subject: Re: [PATCH net-next] mcast: ensure L-L IPv6 packets are accepted by
 bridge
To:     Ido Schimmel <idosch@idosch.org>,
        Patrick Ruddy <pruddy@vyatta.att-mail.com>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        linus.luessing@c0d3.blue
References: <20190813141804.20515-1-pruddy@vyatta.att-mail.com>
 <20190813195341.GA27005@splinter>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <43ed59db-9228-9132-b9a5-31c8d1e8e9e9@cumulusnetworks.com>
Date:   Wed, 14 Aug 2019 02:55:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190813195341.GA27005@splinter>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/13/19 10:53 PM, Ido Schimmel wrote:
> + Bridge maintainers, Linus
> 

Good catch Ido, thanks!
First I'd say the subject needs to reflect that this is a bridge change
better, please rearrange it like so - bridge: mcast: ...
More below,

> On Tue, Aug 13, 2019 at 03:18:04PM +0100, Patrick Ruddy wrote:
>> At present only all-nodes IPv6 multicast packets are accepted by
>> a bridge interface that is not in multicast router mode. Since
>> other protocols can be running in the absense of multicast
>> forwarding e.g. OSPFv3 IPv6 ND. Change the test to allow
>> all of the FFx2::/16 range to be accepted when not in multicast
>> router mode. This aligns the code with IPv4 link-local reception
>> and RFC4291
> 
> Can you please quote the relevant part from RFC 4291?
>
>>
>> Signed-off-by: Patrick Ruddy <pruddy@vyatta.att-mail.com>
>> ---
>>  include/net/addrconf.h    | 15 +++++++++++++++
>>  net/bridge/br_multicast.c |  2 +-
>>  2 files changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/net/addrconf.h b/include/net/addrconf.h
>> index becdad576859..05b42867e969 100644
>> --- a/include/net/addrconf.h
>> +++ b/include/net/addrconf.h
>> @@ -434,6 +434,21 @@ static inline void addrconf_addr_solict_mult(const struct in6_addr *addr,
>>  		      htonl(0xFF000000) | addr->s6_addr32[3]);
>>  }
>>  
>> +/*
>> + *      link local multicast address range ffx2::/16 rfc4291
>> + */
>> +static inline bool ipv6_addr_is_ll_mcast(const struct in6_addr *addr)
>> +{
>> +#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
>> +	__be64 *p = (__be64 *)addr;
>> +	return ((p[0] & cpu_to_be64(0xff0f000000000000UL))
>> +		^ cpu_to_be64(0xff02000000000000UL)) == 0UL;
>> +#else
>> +	return ((addr->s6_addr32[0] & htonl(0xff0f0000)) ^
>> +		htonl(0xff020000)) == 0;
>> +#endif
>> +}
>> +
>>  static inline bool ipv6_addr_is_ll_all_nodes(const struct in6_addr *addr)
>>  {
>>  #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
>> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
>> index 9b379e110129..ed3957381fa2 100644
>> --- a/net/bridge/br_multicast.c
>> +++ b/net/bridge/br_multicast.c
>> @@ -1664,7 +1664,7 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
>>  	err = ipv6_mc_check_mld(skb);
>>  
>>  	if (err == -ENOMSG) {
>> -		if (!ipv6_addr_is_ll_all_nodes(&ipv6_hdr(skb)->daddr))
>> +		if (!ipv6_addr_is_ll_mcast(&ipv6_hdr(skb)->daddr))
>>  			BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
> 
> IIUC, you want IPv6 link-local packets to be locally received, but this
> also changes how these packets are flooded. RFC 4541 says that packets

Indeed, we'll start flooding them all, not just the all hosts address.
If that is at all required it'll definitely have to be optional.

> addressed to the all hosts address are a special case and should be
> forwarded to all ports:
> 
> "In IPv6, the data forwarding rules are more straight forward because MLD is
> mandated for addresses with scope 2 (link-scope) or greater. The only exception
> is the address FF02::1 which is the all hosts link-scope address for which MLD
> messages are never sent. Packets with the all hosts link-scope address should
> be forwarded on all ports."
>

I wonder what is the problem for the host to join such group on behalf of the bridge ?
Then you'll receive the traffic at least locally and the RFC says it itself - MLD is mandated
for the other link-local addresses.
It's very late here and maybe I'm missing something.. :)
 
> Maybe you want something like:
> 

I think we can do without the new field, either pass local_rcv into br_multicast_rcv() or
set it based on return value. The extra test will have to remain unfortunately, but we
can reduce the tests by one if carefully done.

> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index 09b1dd8cd853..9f312a73f61c 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -132,7 +132,8 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  		if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
>  		    br_multicast_querier_exists(br, eth_hdr(skb))) {
>  			if ((mdst && mdst->host_joined) ||
> -			    br_multicast_is_router(br)) {
> +			    br_multicast_is_router(br) ||
> +			    BR_INPUT_SKB_CB_LOCAL_RECEIVE(skb)) {
>  				local_rcv = true;
>  				br->dev->stats.multicast++;
>  			}
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 9b379e110129..f03cecf6174e 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -1667,6 +1667,9 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
>  		if (!ipv6_addr_is_ll_all_nodes(&ipv6_hdr(skb)->daddr))
>  			BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
>  
> +		if (ipv6_addr_is_ll_mcast(&ipv6_hdr(skb)->daddr))
> +			BR_INPUT_SKB_CB(skb)->local_receive = 1;
> +
>  		if (ipv6_addr_is_all_snoopers(&ipv6_hdr(skb)->daddr)) {
>  			err = br_ip6_multicast_mrd_rcv(br, port, skb);
>  
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index b7a4942ff1b3..d76394ca4059 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -426,6 +426,7 @@ struct br_input_skb_cb {
>  #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
>  	u8 igmp;
>  	u8 mrouters_only:1;
> +	u8 local_receive:1;
>  #endif
>  	u8 proxyarp_replied:1;
>  	u8 src_port_isolated:1;
> @@ -445,8 +446,10 @@ struct br_input_skb_cb {
>  
>  #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
>  # define BR_INPUT_SKB_CB_MROUTERS_ONLY(__skb)	(BR_INPUT_SKB_CB(__skb)->mrouters_only)
> +# define BR_INPUT_SKB_CB_LOCAL_RECEIVE(__skb)	(BR_INPUT_SKB_CB(__skb)->local_receive)
>  #else
>  # define BR_INPUT_SKB_CB_MROUTERS_ONLY(__skb)	(0)
> +# define BR_INPUT_SKB_CB_LOCAL_RECEIVE(__skb)	(0)
>  #endif
>  
>  #define br_printk(level, br, format, args...)	\
> 

