Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51D29E1735
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 12:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403860AbfJWKAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 06:00:18 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:33321 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390489AbfJWKAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 06:00:18 -0400
Received: by mail-ed1-f66.google.com with SMTP id c4so15294758edl.0
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 03:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=B28U5Zj7r3ci+PNtQlBksa/ao1V7QZJ9ISM4QcS/zic=;
        b=uyyQcdowTrr6u4dqYe62AnlaVURxistahNUAb5cWLq5F42hGJDUWzd8jfVZZNxKwjF
         sIes1Fp0q6EPmNWe3cGFXzAKlNWEKu9XsGn/UxUhOvXm4b2NsqKhEdbfdfMC+nS0tj8p
         /wGjT4bcsarZyjKYTfP0YLv6uti8eNFBX3wwBOLRW7ZEkzMVaKvUbLZ4PZTH3hZnC++7
         gJVqmMSqGmXvFWJxPsaOxOO8uuyCxxsOaAtMS0Epf2q45q3wjXKgBM/XRNOis6CgXQI4
         HCX0Rwt2mq8zgYg6POSjdlXEeuP0Y6i70QtZkkl+15ct6C5C0vxypTC2NCxTETtYNQzp
         aljQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=B28U5Zj7r3ci+PNtQlBksa/ao1V7QZJ9ISM4QcS/zic=;
        b=RO9gRiFqQRjKsW/o9XgG2DxNFxrYqeEyou0P5A6yFXP7RlfZZ8SxYK9xyhvuqwyzM7
         n8VBqKyXp/s0cKcQ2c5Qt9IUEuiNaaVN+DK40umQbO4vTjo8r6KllFOZuUDFXhk8VqF7
         fAYrBDNj+IxNbb8OcYlS5SxItO48xAeP+86RvLEvWh/zMia4YR4k2vqbpLgRkrKp8X5u
         Re2nPtXzdOEpwmcVpJ1mk+4pxGnSHX7g/g3RA1/VMsg0d+5UeD5kc+jgy3W7RsvLJ4hF
         9j7kC+Z1HichS9UE6zbFI8R1sy1sGp8tCo8oSErJKC6HGBllfepxjIPkbGCYGmiCVJcP
         CWvg==
X-Gm-Message-State: APjAAAVrGqKm/4/0E8DIFpug6I7K6011WModbi/qqhDSXqNaaH7jk1IG
        zS1yJjJ1ZYfnmniZKlcJdMn38Q==
X-Google-Smtp-Source: APXvYqweeAjCV/EKg+ZoKmNiULCvm3CkiUEsOTwXPBRGvvtnMuXDQwy3LoDJs0WgZ7K52DbUtg+7vg==
X-Received: by 2002:a17:906:5601:: with SMTP id f1mr4724791ejq.151.1571824816380;
        Wed, 23 Oct 2019 03:00:16 -0700 (PDT)
Received: from netronome.com ([62.119.166.9])
        by smtp.gmail.com with ESMTPSA id a13sm274078eds.10.2019.10.23.03.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 03:00:15 -0700 (PDT)
Date:   Wed, 23 Oct 2019 12:00:11 +0200
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
Subject: Re: [PATCH net-next 3/4] flow_dissector: extract more ICMP
 information
Message-ID: <20191023100009.GC8732@netronome.com>
References: <20191021200948.23775-1-mcroce@redhat.com>
 <20191021200948.23775-4-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021200948.23775-4-mcroce@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 10:09:47PM +0200, Matteo Croce wrote:
> The ICMP flow dissector currently parses only the Type and Code fields.
> Some ICMP packets (echo, timestamp) have a 16 bit Identifier field which
> is used to correlate packets.
> Add such field in flow_dissector_key_icmp and replace skb_flow_get_be16()
> with a more complex function which populate this field.
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> ---
>  include/net/flow_dissector.h | 10 +++++-
>  net/core/flow_dissector.c    | 64 ++++++++++++++++++++++--------------
>  2 files changed, 49 insertions(+), 25 deletions(-)
> 
> diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> index 7747af3cc500..86c6bf5eab31 100644
> --- a/include/net/flow_dissector.h
> +++ b/include/net/flow_dissector.h
> @@ -6,6 +6,8 @@
>  #include <linux/in6.h>
>  #include <uapi/linux/if_ether.h>
>  
> +struct sk_buff;
> +
>  /**
>   * struct flow_dissector_key_control:
>   * @thoff: Transport header offset
> @@ -160,6 +162,7 @@ struct flow_dissector_key_ports {
>   *		icmp: ICMP type (high) and code (low)
>   *		type: ICMP type
>   *		code: ICMP code
> + *		id:   session identifier
>   */
>  struct flow_dissector_key_icmp {
>  	union {
> @@ -169,6 +172,7 @@ struct flow_dissector_key_icmp {
>  			u8 code;
>  		};
>  	};
> +	u16 id;
>  };
>  
>  /**
> @@ -282,6 +286,7 @@ struct flow_keys {
>  	struct flow_dissector_key_vlan cvlan;
>  	struct flow_dissector_key_keyid keyid;
>  	struct flow_dissector_key_ports ports;
> +	struct flow_dissector_key_icmp icmp;
>  	/* 'addrs' must be the last member */
>  	struct flow_dissector_key_addrs addrs;
>  };
> @@ -312,10 +317,13 @@ void make_flow_keys_digest(struct flow_keys_digest *digest,
>  
>  static inline bool flow_keys_have_l4(const struct flow_keys *keys)
>  {
> -	return (keys->ports.ports || keys->tags.flow_label);
> +	return keys->ports.ports || keys->tags.flow_label || keys->icmp.id;
>  }
>  
>  u32 flow_hash_from_keys(struct flow_keys *keys);
> +void skb_flow_get_icmp_tci(const struct sk_buff *skb,
> +			   struct flow_dissector_key_icmp *key_icmp,
> +			   void *data, int thoff, int hlen);
>  
>  static inline bool dissector_uses_key(const struct flow_dissector *flow_dissector,
>  				      enum flow_dissector_key_id key_id)
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 6443fac65ce8..90dcf6f2ef19 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -147,27 +147,6 @@ int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr)
>  	mutex_unlock(&flow_dissector_mutex);
>  	return 0;
>  }
> -/**
> - * skb_flow_get_be16 - extract be16 entity
> - * @skb: sk_buff to extract from
> - * @poff: offset to extract at
> - * @data: raw buffer pointer to the packet
> - * @hlen: packet header length
> - *
> - * The function will try to retrieve a be32 entity at
> - * offset poff
> - */
> -static __be16 skb_flow_get_be16(const struct sk_buff *skb, int poff,
> -				void *data, int hlen)
> -{
> -	__be16 *u, _u;
> -
> -	u = __skb_header_pointer(skb, poff, sizeof(_u), data, hlen, &_u);
> -	if (u)
> -		return *u;
> -
> -	return 0;
> -}
>  
>  /**
>   * __skb_flow_get_ports - extract the upper layer ports and return them
> @@ -203,8 +182,44 @@ __be32 __skb_flow_get_ports(const struct sk_buff *skb, int thoff, u8 ip_proto,
>  }
>  EXPORT_SYMBOL(__skb_flow_get_ports);
>  
> -/* If FLOW_DISSECTOR_KEY_ICMP is set, get the Type and Code from an ICMP packet
> - * using skb_flow_get_be16().
> +/**
> + * skb_flow_get_icmp_tci - extract ICMP(6) Type, Code and Identifier fields
> + * @skb: sk_buff to extract from
> + * @key_icmp: struct flow_dissector_key_icmp to fill
> + * @data: raw buffer pointer to the packet
> + * @toff: offset to extract at
> + * @hlen: packet header length
> + */
> +void skb_flow_get_icmp_tci(const struct sk_buff *skb,
> +			   struct flow_dissector_key_icmp *key_icmp,
> +			   void *data, int thoff, int hlen)
> +{
> +	struct icmphdr *ih, _ih;
> +
> +	ih = __skb_header_pointer(skb, thoff, sizeof(_ih), data, hlen, &_ih);
> +	if (!ih)
> +		return;
> +
> +	key_icmp->type = ih->type;
> +	key_icmp->code = ih->code;
> +	key_icmp->id = 0;
> +	switch (ih->type) {
> +	case ICMP_ECHO:
> +	case ICMP_ECHOREPLY:
> +	case ICMP_TIMESTAMP:
> +	case ICMP_TIMESTAMPREPLY:
> +	case ICMPV6_ECHO_REQUEST:
> +	case ICMPV6_ECHO_REPLY:
> +		/* As we use 0 to signal that the Id field is not present,
> +		 * avoid confusion with packets without such field
> +		 */
> +		key_icmp->id = ih->un.echo.id ? : 1;

Its not obvious to me why the kernel should treat id-zero as a special
value if it is not special on the wire.

Perhaps a caller who needs to know if the id is present can
check the ICMP type as this code does, say using a helper.

> +	}
> +}
> +EXPORT_SYMBOL(skb_flow_get_icmp_tci);
> +
> +/* If FLOW_DISSECTOR_KEY_ICMP is set, dissect an ICMP packet
> + * using skb_flow_get_icmp_tci().
>   */
>  static void __skb_flow_dissect_icmp(const struct sk_buff *skb,
>  				    struct flow_dissector *flow_dissector,
> @@ -219,7 +234,8 @@ static void __skb_flow_dissect_icmp(const struct sk_buff *skb,
>  	key_icmp = skb_flow_dissector_target(flow_dissector,
>  					     FLOW_DISSECTOR_KEY_ICMP,
>  					     target_container);
> -	key_icmp->icmp = skb_flow_get_be16(skb, thoff, data, hlen);
> +
> +	skb_flow_get_icmp_tci(skb, key_icmp, data, thoff, hlen);
>  }
>  
>  void skb_flow_dissect_meta(const struct sk_buff *skb,
> -- 
> 2.21.0
> 
