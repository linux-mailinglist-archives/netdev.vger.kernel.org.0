Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 328F139FB0
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 14:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfFHMqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 08:46:03 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39627 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfFHMqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 08:46:03 -0400
Received: by mail-ed1-f68.google.com with SMTP id m10so6638945edv.6
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 05:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p4LzBQWh2Yv5PsBcZFcAs0QoIkEzAuc+ZT1Kp2iKMGI=;
        b=U6gjOg6abqM75I/eiil71J7X3DbmUpshuNCUJYl6v/bW/hdhfl1+11m/pPmd9SWwvv
         yBoy5aSQ7wsYNgMRoxYyx0pmIht272pMz7Nm1A/dc6Fy5ImRGVKH64f4FQTLJxJgesvp
         J1FsOovuEELMcavcrq3podTaEQWhMayLyhFL3WnOWphM8fsswRFAKtTg5UY+8Uwo76sQ
         KGqtYgkGwsM3wtOuVhIiXB9Ftej1nfRM/dTvFoXGilnfnVi9fPX8KCc7mahisG2TU/0d
         z3+DKVmYNy5DtjzlGjIcNLSD0YhUKGnZIM66/+Wvl62Srjx88oL4+z8y4SELWXhgdhox
         U95g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p4LzBQWh2Yv5PsBcZFcAs0QoIkEzAuc+ZT1Kp2iKMGI=;
        b=FU6aq59eDpS2utBZvvzTCZP90hQGUlACqQI6qlkIWOrvvl2JN7MchFFib6pABZTHft
         h7whL/X6sbpeQFwT18kMmdQwCcI36Apv1gIk2HPDsB0+gD6JcL4tywMRV8Rl8mwzuFEC
         zgAMKfyWHNmGLR0woYHgbYRiI4caOpl7QwAVKJW9i483haq16uhMjI+KRyZYj4/sgUPX
         CtoPJXjFP34l2gNe9OtjYe8ov7s3fuzbZ7w7S5kLv5diMWRJ7jb8GOjdtoBsPZ8aWoMX
         nKmMW+hY9rw90ifQtx47qTYKt02cGszw5G3wlyQBjo1271xFZ0xY3mmcllOCw/8Yj4yO
         VxWA==
X-Gm-Message-State: APjAAAWKnOD0Y7B+LDaAj+2ct4G69JcbeZCew4RL+LjUWz6yZWNtrDXh
        HKh77OsDNyKOQPibSpggIls=
X-Google-Smtp-Source: APXvYqwiZWspBS93NH28Mx0cbTVxYSMxPfyheC4e16MGZZyCPjDFSj6iKFCsRUaNK57X+8+dkDL2Fg==
X-Received: by 2002:a50:85c4:: with SMTP id q4mr58653417edh.125.1559997961074;
        Sat, 08 Jun 2019 05:46:01 -0700 (PDT)
Received: from ?IPv6:2a02:8084:601c:ef00:991d:267c:9ed8:7bbb? ([2a02:8084:601c:ef00:991d:267c:9ed8:7bbb])
        by smtp.gmail.com with ESMTPSA id k51sm164969edb.7.2019.06.08.05.45.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 05:46:00 -0700 (PDT)
Subject: Re: [RFC v2 PATCH 5/5] seg6: Leverage ip6_parse_tlv
To:     Tom Herbert <tom@herbertland.com>, davem@davemloft.net,
        netdev@vger.kernel.org, dlebrun@google.com
Cc:     Tom Herbert <tom@quantonium.net>
References: <1559933708-13947-1-git-send-email-tom@quantonium.net>
 <1559933708-13947-6-git-send-email-tom@quantonium.net>
From:   David Lebrun <dav.lebrun@gmail.com>
Message-ID: <4ae893a9-4540-caf6-7746-553029f53a8c@gmail.com>
Date:   Sat, 8 Jun 2019 13:45:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1559933708-13947-6-git-send-email-tom@quantonium.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/06/2019 19:55, Tom Herbert wrote:
>   

...

> @@ -387,8 +416,24 @@ static int ipv6_srh_rcv(struct sk_buff *skb)
>   		return -1;
>   	}
>   
> +	tlvoff = seg6_tlv_offset(hdr);
> +	tlvlen = ipv6_optlen((struct ipv6_opt_hdr *)hdr) - tlvoff;
> +
> +	if (tlvlen) {
> +		if (tlvlen > net->ipv6.sysctl.max_srh_opts_len) {
> +			kfree_skb(skb);
> +			return -1;
> +		}
> +
> +		if (!ip6_parse_tlv(tlvprocsrhopt_lst, skb,
> +				   init_net.ipv6.sysctl.max_srh_opts_cnt,

Why init_net ? I assume you mean 'net->ipv6.sysctl' instead.

> +				   tlvoff, tlvlen, seg6_srhopt_unknown))
> +			return -1;
> +	}
> +
>   #ifdef CONFIG_IPV6_SEG6_HMAC
> -	if (!seg6_hmac_validate_skb(skb)) {
> +	if (idev->cnf.seg6_require_hmac > 0 && !sr_has_hmac(hdr)) {
> +		/* mandatory check but no HMAC tlv */
>   		kfree_skb(skb);
>   		return -1;
>   	}
> diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
> index 8546f94..18f82f2 100644
> --- a/net/ipv6/seg6_hmac.c
> +++ b/net/ipv6/seg6_hmac.c
> @@ -240,7 +240,7 @@ EXPORT_SYMBOL(seg6_hmac_compute);
>    *
>    * called with rcu_read_lock()
>    */
> -bool seg6_hmac_validate_skb(struct sk_buff *skb)
> +bool seg6_hmac_validate_skb(struct sk_buff *skb, int optoff)
>   {
>   	u8 hmac_output[SEG6_HMAC_FIELD_LEN];
>   	struct net *net = dev_net(skb->dev);
> @@ -251,23 +251,13 @@ bool seg6_hmac_validate_skb(struct sk_buff *skb)
>   
>   	idev = __in6_dev_get(skb->dev);
>   
> -	srh = (struct ipv6_sr_hdr *)skb_transport_header(skb);
> -
> -	tlv = seg6_get_tlv_hmac(srh);
> -
> -	/* mandatory check but no tlv */
> -	if (idev->cnf.seg6_require_hmac > 0 && !tlv)
> -		return false;
> -
>   	/* no check */
>   	if (idev->cnf.seg6_require_hmac < 0)
>   		return true;
>   
> -	/* check only if present */
> -	if (idev->cnf.seg6_require_hmac == 0 && !tlv)
> -		return true;
> +	srh = (struct ipv6_sr_hdr *)skb_transport_header(skb);
>   
> -	/* now, seg6_require_hmac >= 0 && tlv */
> +	tlv = (struct sr6_tlv_hmac *)(skb_network_header(skb) + optoff);
>   
>   	hinfo = seg6_hmac_info_lookup(net, be32_to_cpu(tlv->hmackeyid));
>   	if (!hinfo)
> diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
> index 78155fd..d486ed8 100644
> --- a/net/ipv6/seg6_local.c
> +++ b/net/ipv6/seg6_local.c
> @@ -92,6 +92,19 @@ static struct ipv6_sr_hdr *get_srh(struct sk_buff *skb)
>   	return srh;
>   }
>   
> +static bool seg6_local_hmac_validate_skb(struct sk_buff *skb,
> +					 struct ipv6_sr_hdr *srh)
> +{
> +#ifdef CONFIG_IPV6_SEG6_HMAC
> +	int off = sr_hmac_offset(srh);
> +
> +	return off ? seg6_hmac_validate_skb(skb, off) :
> +		     (__in6_dev_get(skb->dev)->cnf.seg6_require_hmac <= 0);

If I read sr_hmac_offset() correctly, it returns an offset relative to 
the start of the SRH, while seg_hmac_validate_skb() now expects an 
offset relative to the network header (and rightly so as it receives 
such an offset from ip6_parse_tlv). A solution might be:

seg6_hmac_validate_skb(skb, skb_network_header_len(skb) + off)

But this also assumes that the SRH is present immediately after the IPv6 
header, which might not be true when HBH or Destination Options are also 
present. So I'd suggest something like:

int nhoff = (unsigned char *)srh - skb_network_header(skb);
int off = sr_hmac_offset(srh);

return off ? seg6_hmac_validate_skb(skb, off + nhoff) ...

> +#else
> +	return true;
> +#endif
> +}
> +
>   static struct ipv6_sr_hdr *get_and_validate_srh(struct sk_buff *skb)
>   {
>   	struct ipv6_sr_hdr *srh;
> @@ -103,10 +116,8 @@ static struct ipv6_sr_hdr *get_and_validate_srh(struct sk_buff *skb)
>   	if (srh->segments_left == 0)
>   		return NULL;
>   
> -#ifdef CONFIG_IPV6_SEG6_HMAC
> -	if (!seg6_hmac_validate_skb(skb))
> +	if (!seg6_local_hmac_validate_skb(skb, srh))
>   		return NULL;
> -#endif
>   
>   	return srh;
>   }
> @@ -120,10 +131,8 @@ static bool decap_and_validate(struct sk_buff *skb, int proto)
>   	if (srh && srh->segments_left > 0)
>   		return false;
>   
> -#ifdef CONFIG_IPV6_SEG6_HMAC
> -	if (srh && !seg6_hmac_validate_skb(skb))
> +	if (srh && !seg6_local_hmac_validate_skb(skb, srh))
>   		return false;
> -#endif
>   
>   	if (ipv6_find_hdr(skb, &off, proto, NULL, NULL) < 0)
>   		return false;
> 

