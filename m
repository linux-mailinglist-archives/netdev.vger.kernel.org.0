Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE42E1728
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 11:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404154AbfJWJ7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 05:59:04 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38852 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404146AbfJWJ6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 05:58:06 -0400
Received: by mail-ed1-f67.google.com with SMTP id y8so2994430edu.5
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 02:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BmDPouxVk6it30/vik+XTYalvYPYU+sttbaOcqxWe8k=;
        b=lkmMltuZ/rmrh6wByUf6P17He3TtFKb+/zDEG9266MdGz2dHwPgA/DDUkgeKcajNVD
         1jYbawnxYxl5gGPFgMNDRE3UHgL9KIGEvsgOZjH+XhMQAJbXkvSm3neB6NBb4S//dH4O
         RVlHi8ZkXVljLJer3klnOVzJUu3Pqd75x95dQZPN+jt5xpja68wBTbt9gBnEt2fp06mO
         8dEPzhqD6OqVglmlVRIG4J4r5WjGPWq7DUUVBtv2++9S7pkFRLZCEnjPkHMnHMLfRuF1
         adPmRE8yUH26nGzfQgboNLycesY/6rFNKdpePKoWLg5WXLlrUnZUzTRJ5b2hHi6e6W0/
         odDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BmDPouxVk6it30/vik+XTYalvYPYU+sttbaOcqxWe8k=;
        b=r7ihfWbRdYKDDfgV01G5egABZkRfk7oBtTzy2apTWXXtjz/pGzY0ea7dmTcLd+G9fA
         hgEDgRXwzkNooTR2H5jdJEvdKPNEC4B8iJf9CQ6+91Qr8W4ZvyiOg7JdBbO1XMccjWHy
         8dTTbIN0l6yRfjo1COq2WoKxSy/Mff5xVT2yuNz8Jun12SllfyHoTqSU7/6dmAglJYgW
         otRzBO+oJUdSIlKFrQa2xv7EBkJg4kiNK3HO6vhiTGmfbnVOflwR89TddGQFB7l6ImmQ
         B2v+zGsEMgCurcLAXienmYFNPBSQrdXt3AFx5MfxBrCN8ly88gRvg+04ZFuUPZp2IyUg
         XTOw==
X-Gm-Message-State: APjAAAUUCaW5CD1mHa/bPRv+Z8iTqj/d4IfrPnAD7cftWewP0tUh7k+Y
        +1/nD+UBLNuAHpDfJ8ubZfZ6Pw==
X-Google-Smtp-Source: APXvYqwwnJNkyjrhmSVe5LFXgH4GcnEmaTCDcRouJZWqVhNsj0iP0tU/IIwYvhapTTOZfxFlH/84TA==
X-Received: by 2002:a17:906:3b4e:: with SMTP id h14mr12796863ejf.111.1571824684170;
        Wed, 23 Oct 2019 02:58:04 -0700 (PDT)
Received: from netronome.com ([62.119.166.9])
        by smtp.gmail.com with ESMTPSA id s26sm880294eds.80.2019.10.23.02.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 02:58:03 -0700 (PDT)
Date:   Wed, 23 Oct 2019 11:57:59 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller " <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] flow_dissector: skip the ICMP dissector for
 non ICMP packets
Message-ID: <20191023095758.GB8732@netronome.com>
References: <20191021200948.23775-1-mcroce@redhat.com>
 <20191021200948.23775-3-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021200948.23775-3-mcroce@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 10:09:46PM +0200, Matteo Croce wrote:
> FLOW_DISSECTOR_KEY_ICMP is checked for every packet, not only ICMP ones.
> Even if the test overhead is probably negligible, move the
> ICMP dissector code under the big 'switch(ip_proto)' so it gets called
> only for ICMP packets.
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

> ---
>  net/core/flow_dissector.c | 34 +++++++++++++++++++++++++---------
>  1 file changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index affde70dad47..6443fac65ce8 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -203,6 +203,25 @@ __be32 __skb_flow_get_ports(const struct sk_buff *skb, int thoff, u8 ip_proto,
>  }
>  EXPORT_SYMBOL(__skb_flow_get_ports);
>  
> +/* If FLOW_DISSECTOR_KEY_ICMP is set, get the Type and Code from an ICMP packet
> + * using skb_flow_get_be16().
> + */
> +static void __skb_flow_dissect_icmp(const struct sk_buff *skb,
> +				    struct flow_dissector *flow_dissector,
> +				    void *target_container,
> +				    void *data, int thoff, int hlen)
> +{
> +	struct flow_dissector_key_icmp *key_icmp;
> +
> +	if (!dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_ICMP))
> +		return;
> +
> +	key_icmp = skb_flow_dissector_target(flow_dissector,
> +					     FLOW_DISSECTOR_KEY_ICMP,
> +					     target_container);
> +	key_icmp->icmp = skb_flow_get_be16(skb, thoff, data, hlen);
> +}
> +
>  void skb_flow_dissect_meta(const struct sk_buff *skb,
>  			   struct flow_dissector *flow_dissector,
>  			   void *target_container)
> @@ -853,7 +872,6 @@ bool __skb_flow_dissect(const struct net *net,
>  	struct flow_dissector_key_basic *key_basic;
>  	struct flow_dissector_key_addrs *key_addrs;
>  	struct flow_dissector_key_ports *key_ports;
> -	struct flow_dissector_key_icmp *key_icmp;
>  	struct flow_dissector_key_tags *key_tags;
>  	struct flow_dissector_key_vlan *key_vlan;
>  	struct bpf_prog *attached = NULL;
> @@ -1295,6 +1313,12 @@ bool __skb_flow_dissect(const struct net *net,
>  				       data, nhoff, hlen);
>  		break;
>  
> +	case IPPROTO_ICMP:
> +	case IPPROTO_ICMPV6:
> +		__skb_flow_dissect_icmp(skb, flow_dissector, target_container,
> +					data, nhoff, hlen);
> +		break;
> +
>  	default:
>  		break;
>  	}
> @@ -1308,14 +1332,6 @@ bool __skb_flow_dissect(const struct net *net,
>  							data, hlen);
>  	}
>  
> -	if (dissector_uses_key(flow_dissector,
> -			       FLOW_DISSECTOR_KEY_ICMP)) {
> -		key_icmp = skb_flow_dissector_target(flow_dissector,
> -						     FLOW_DISSECTOR_KEY_ICMP,
> -						     target_container);
> -		key_icmp->icmp = skb_flow_get_be16(skb, nhoff, data, hlen);
> -	}
> -
>  	/* Process result of IP proto processing */
>  	switch (fdret) {
>  	case FLOW_DISSECT_RET_PROTO_AGAIN:
> -- 
> 2.21.0
> 
