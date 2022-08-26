Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 087C25A228C
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 10:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244912AbiHZIFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 04:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237371AbiHZIFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 04:05:13 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295DB8689C
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:05:09 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id h5so856016wru.7
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc;
        bh=ED7g6fNeSeCTR/jLw3rybZ8N6LujPjusVSBkx6nXT9s=;
        b=OfNV7ZxF97T4QWiF31Htys78WBKkBVWDKwCCG/5rtA4Rtx4c/5JohrbwtkPth+u0e1
         am3HiU9zymT6an2Elp+6NWS8mvf1ZAAQ8m5EoxlXiKmVivaGC675mPUc3cxyEykQnN25
         NwyQFGIYmNJepnQ0ySEzjaZ71SyVXxoHmTRK6AmOTHxMdUIfQ4VHFLw6ItXjp36cS6g1
         IxPARyXmG23UmGyFQ+V/IQNBC2SuWfVDMZuq6DjIE6uu+pNgVQdlPM5mj10xtwOh0ek1
         AyM3B6eUcgbC7gpBYl0f6uA1REMlkaLyiE6gQgc+2wpN4nkKbAf5qLOZxOtskeaUd7ma
         cu8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc;
        bh=ED7g6fNeSeCTR/jLw3rybZ8N6LujPjusVSBkx6nXT9s=;
        b=eTG+Ia+K/YCbfZd/MEtxofcrAC/v9thl+H5lG+kT++IIrL10YRX5nsr2ELzSg8Q5OJ
         /7IoKubnXLEuxepXoKtnEPwWPJ64xsXwXW10jdLS1m160Nu2ETwAMt94xwuqL9jyMNnn
         7OaFKCsJyZC8V3vC7GCP0MzGjVRP2mXuREtV7kXoiuCOdYy+2CtffLrbXFKvgPvhZNS5
         b1ZsjKNBijC/0/IW16zpAkfVrVegi7ZCpLEC/hMnMc3Yhrl6b3vJVMuOa6Juq+SXfk6C
         UtVe/9WEdhv0w7ar/Cd+0V0MrjKB396OP1a3Dn7jU/U7XyT6l+RmHKuYRKWtocY/Y+UU
         vxLA==
X-Gm-Message-State: ACgBeo2YJ53ejSYKp6vBZCcDw3Xwx7X1FQeeNDg5mxzQss2Aql0lGMl9
        7pzHiKFZwYum2BgIu/O5STveIA==
X-Google-Smtp-Source: AA6agR6GeX41tIWppV7E9wVs6YrQ6AlPOhdtiIijkACA/Z3xgQmCAnM6r5EitNGQjzNGoZlJ6Ey4fg==
X-Received: by 2002:a5d:52d0:0:b0:21e:4923:fa09 with SMTP id r16-20020a5d52d0000000b0021e4923fa09mr4282567wrv.244.1661501107637;
        Fri, 26 Aug 2022 01:05:07 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:5d94:b816:24d3:cd91? ([2a01:e0a:b41:c160:5d94:b816:24d3:cd91])
        by smtp.gmail.com with ESMTPSA id b3-20020a5d40c3000000b0022533c4fa48sm1246133wrq.55.2022.08.26.01.05.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 01:05:07 -0700 (PDT)
Message-ID: <d2836dfb-6666-52cc-0d9c-17cb1542893c@6wind.com>
Date:   Fri, 26 Aug 2022 10:05:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec-next,v3 3/3] xfrm: lwtunnel: add lwtunnel support
 for xfrm interfaces in collect_md mode
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        dsahern@kernel.org, contact@proelbtn.com, pablo@netfilter.org,
        razor@blackwall.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20220825154630.2174742-1-eyal.birger@gmail.com>
 <20220825154630.2174742-4-eyal.birger@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220825154630.2174742-4-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 25/08/2022 à 17:46, Eyal Birger a écrit :
> Allow specifying the xfrm interface if_id and link as part of a route
> metadata using the lwtunnel infrastructure.
> 
> This allows for example using a single xfrm interface in collect_md
> mode as the target of multiple routes each specifying a different if_id.
> 
> With the appropriate changes to iproute2, considering an xfrm device
> ipsec1 in collect_md mode one can for example add a route specifying
> an if_id like so:
> 
> ip route add <SUBNET> dev ipsec1 encap xfrm if_id 1
> 
> In which case traffic routed to the device via this route would use
> if_id in the xfrm interface policy lookup.
> 
> Or in the context of vrf, one can also specify the "link" property:
> 
> ip route add <SUBNET> dev ipsec1 encap xfrm if_id 1 link_dev eth15
> 
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> 
> ----
> 
> v3: netlink improvements as suggested by Nikolay Aleksandrov and
>     Nicolas Dichtel
> 
> v2:
>   - move lwt_xfrm_info() helper to dst_metadata.h
>   - add "link" property as suggested by Nicolas Dichtel
> ---
>  include/net/dst_metadata.h    | 11 +++++
>  include/uapi/linux/lwtunnel.h | 10 +++++
>  net/core/lwtunnel.c           |  1 +
>  net/xfrm/xfrm_interface.c     | 85 +++++++++++++++++++++++++++++++++++
>  4 files changed, 107 insertions(+)
> 
> diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
> index e4b059908cc7..57f75960fa28 100644
> --- a/include/net/dst_metadata.h
> +++ b/include/net/dst_metadata.h
> @@ -60,13 +60,24 @@ skb_tunnel_info(const struct sk_buff *skb)
>  	return NULL;
>  }
>  
> +static inline struct xfrm_md_info *lwt_xfrm_info(struct lwtunnel_state *lwt)
> +{
> +	return (struct xfrm_md_info *)lwt->data;
> +}
> +
>  static inline struct xfrm_md_info *skb_xfrm_md_info(const struct sk_buff *skb)
>  {
>  	struct metadata_dst *md_dst = skb_metadata_dst(skb);
> +	struct dst_entry *dst;
>  
>  	if (md_dst && md_dst->type == METADATA_XFRM)
>  		return &md_dst->u.xfrm_info;
>  
> +	dst = skb_dst(skb);
> +	if (dst && dst->lwtstate &&
> +	    dst->lwtstate->type == LWTUNNEL_ENCAP_XFRM)
> +		return lwt_xfrm_info(dst->lwtstate);
> +
>  	return NULL;
>  }
>  
> diff --git a/include/uapi/linux/lwtunnel.h b/include/uapi/linux/lwtunnel.h
> index 2e206919125c..229655ef792f 100644
> --- a/include/uapi/linux/lwtunnel.h
> +++ b/include/uapi/linux/lwtunnel.h
> @@ -15,6 +15,7 @@ enum lwtunnel_encap_types {
>  	LWTUNNEL_ENCAP_SEG6_LOCAL,
>  	LWTUNNEL_ENCAP_RPL,
>  	LWTUNNEL_ENCAP_IOAM6,
> +	LWTUNNEL_ENCAP_XFRM,
>  	__LWTUNNEL_ENCAP_MAX,
>  };
>  
> @@ -111,4 +112,13 @@ enum {
>  
>  #define LWT_BPF_MAX_HEADROOM 256
>  
> +enum {
> +	LWT_XFRM_UNSPEC,
> +	LWT_XFRM_IF_ID,
> +	LWT_XFRM_LINK,
> +	__LWT_XFRM_MAX,
> +};
> +
> +#define LWT_XFRM_MAX (__LWT_XFRM_MAX - 1)
> +
>  #endif /* _UAPI_LWTUNNEL_H_ */
> diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
> index 9ccd64e8a666..6fac2f0ef074 100644
> --- a/net/core/lwtunnel.c
> +++ b/net/core/lwtunnel.c
> @@ -50,6 +50,7 @@ static const char *lwtunnel_encap_str(enum lwtunnel_encap_types encap_type)
>  		return "IOAM6";
>  	case LWTUNNEL_ENCAP_IP6:
>  	case LWTUNNEL_ENCAP_IP:
> +	case LWTUNNEL_ENCAP_XFRM:
>  	case LWTUNNEL_ENCAP_NONE:
>  	case __LWTUNNEL_ENCAP_MAX:
>  		/* should not have got here */
> diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
> index e9a355047468..495dee8b0764 100644
> --- a/net/xfrm/xfrm_interface.c
> +++ b/net/xfrm/xfrm_interface.c
> @@ -60,6 +60,88 @@ struct xfrmi_net {
>  	struct xfrm_if __rcu *collect_md_xfrmi;
>  };
>  
> +static const struct nla_policy xfrm_lwt_policy[LWT_XFRM_MAX + 1] = {
> +	[LWT_XFRM_IF_ID]	= NLA_POLICY_MIN(NLA_U32, 1),
> +	[LWT_XFRM_LINK]		= NLA_POLICY_MIN(NLA_S32, 1),
IMHO, it would be better to keep consistency with IFLA_XFRM_LINK.

$ git grep _LINK.*NLA_U32 net/ drivers/net/
drivers/net/gtp.c:      [GTPA_LINK]             = { .type = NLA_U32, },
drivers/net/vxlan/vxlan_core.c: [IFLA_VXLAN_LINK]       = { .type = NLA_U32 },
...
net/core/rtnetlink.c:   [IFLA_LINK]             = { .type = NLA_U32 },
...
net/ipv4/ip_gre.c:      [IFLA_GRE_LINK]         = { .type = NLA_U32 },
net/ipv4/ip_vti.c:      [IFLA_VTI_LINK]         = { .type = NLA_U32 },
net/ipv4/ipip.c:        [IFLA_IPTUN_LINK]               = { .type = NLA_U32 },
net/ipv6/ip6_gre.c:     [IFLA_GRE_LINK]        = { .type = NLA_U32 },
net/ipv6/ip6_tunnel.c:  [IFLA_IPTUN_LINK]               = { .type = NLA_U32 },
net/ipv6/ip6_vti.c:     [IFLA_VTI_LINK]         = { .type = NLA_U32 },
net/ipv6/sit.c: [IFLA_IPTUN_LINK]               = { .type = NLA_U32 },
net/sched/cls_u32.c:    [TCA_U32_LINK]          = { .type = NLA_U32 },
...
net/xfrm/xfrm_interface.c:      [IFLA_XFRM_LINK]        = { .type = NLA_U32 },
$ git grep _LINK.*NLA_S32 net/ drivers/net/
net/core/rtnetlink.c:   [IFLA_LINK_NETNSID]     = { .type = NLA_S32 },
$

They all are U32. Adding one S32 would just add confusion.
