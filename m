Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42F3C5A139D
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 16:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240474AbiHYOao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 10:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241762AbiHYOag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 10:30:36 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927C972FD2
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 07:30:33 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id u15so31241400ejt.6
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 07:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=KB4lH6zxCHN6AWhQM/OhgWGM5OSx/FTdwiC//vMCZjA=;
        b=pW/BekEhBDoi9jELBPu4TuVXO/kGpPtgbK5VH58uNKtIfsFZoSt08IgBSUVoubP3cP
         Dve0n2e3iX6FzoXDmH+gii0LXill8wkguwJw/8uiubiKmQbE2jsRb9E9X3MKigi0bktu
         GmGnipnKJzLm4CoVgtyynrQFYk2WsHydI/88VIiW9kLJ1dpgCzHUnjNGSLJlLIXKBfIj
         HSckBvE/5tXbXPk9qbVO2fnnRXgnMDIlwnxYK1Dz3OuROcWFFpqvtxB/HE5oif5mIlR4
         uHxMp8w4eySSlBpHFXqmg9HiBS8ZEPUiKp2cew3PMQ1pGhxygyA/xFjbmZ0o9M6XhxR8
         agwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=KB4lH6zxCHN6AWhQM/OhgWGM5OSx/FTdwiC//vMCZjA=;
        b=wgDAkPUpvRoy9gEcBzqH7uBTTtgV1T8qqJo90d1rQ4+Vitz9tVMcMviquKJaJ7roAp
         KBoLrI+fzvNVS333YeKgftblTReTO4u/AYpR4HAOy8zlXWBnc9QFADOoEiXTqsJUz/M+
         ElzeS8gUITZ3/FwFQPQ1BTvZAmR+JYbiW4/maxGd2JzOP3XKRRSM+s/avJxfaTNNbKzy
         T80Hbg/aztzg2AseWqA8l2kNMH9IM5ryBLmPrO+KDdpLNRfQHh8TpmNguNDmJhZVTSKU
         OjNWVfK6aRKEzjiG08aC5/mmO0ph3Qc2VuCpg27bFprD4P1IRNfmdDsweSYhrVTLVRn+
         q0dw==
X-Gm-Message-State: ACgBeo3TLH9hQtj5PcJNoQmpVy+kNb8Q8AGDC3tzvSK6NSjvGopZ4wny
        K7DCXUORrO+4WEbgtF1ZmLbTCQ==
X-Google-Smtp-Source: AA6agR7Mw3jji1poKJN0sQz6vFMgj0gmG2FUA6zECNMFzweFDfozMT0GytTPfk0DrWFfbWBuRfVB6w==
X-Received: by 2002:a17:906:cc14:b0:73d:d230:2aa8 with SMTP id ml20-20020a170906cc1400b0073dd2302aa8mr1997876ejb.218.1661437832065;
        Thu, 25 Aug 2022 07:30:32 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id f14-20020a056402194e00b0044783338e85sm2821895edz.28.2022.08.25.07.30.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 07:30:31 -0700 (PDT)
Message-ID: <1f8d37f0-a454-8a25-7670-eb8b42658b4f@blackwall.org>
Date:   Thu, 25 Aug 2022 17:30:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH ipsec-next,v2 3/3] xfrm: lwtunnel: add lwtunnel support
 for xfrm interfaces in collect_md mode
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        dsahern@kernel.org, contact@proelbtn.com, pablo@netfilter.org,
        nicolas.dichtel@6wind.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20220825134636.2101222-1-eyal.birger@gmail.com>
 <20220825134636.2101222-4-eyal.birger@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220825134636.2101222-4-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/08/2022 16:46, Eyal Birger wrote:
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
> ip route add <SUBNET> dev ipsec1 encap xfrm if_id 1 dev eth15
> 
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> 
> ----
> 
> v2:
>  - move lwt_xfrm_info() helper to dst_metadata.h
>  - add "link" property as suggested by Nicolas Dichtel
> ---
>  include/net/dst_metadata.h    |  11 ++++
>  include/uapi/linux/lwtunnel.h |  10 ++++
>  net/core/lwtunnel.c           |   1 +
>  net/xfrm/xfrm_interface.c     | 100 ++++++++++++++++++++++++++++++++++
>  4 files changed, 122 insertions(+)
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
> index 389d8be12801..604de1ee3772 100644
> --- a/net/xfrm/xfrm_interface.c
> +++ b/net/xfrm/xfrm_interface.c
> @@ -60,6 +60,103 @@ struct xfrmi_net {
>  	struct xfrm_if __rcu *collect_md_xfrmi;
>  };
>  
> +static const struct nla_policy xfrm_lwt_policy[LWT_XFRM_MAX + 1] = {
> +	[LWT_XFRM_UNSPEC]	= { .type = NLA_REJECT },

IIRC this is automatically rejected (NL_VALIDATE_STRICT used by nla_parse_nested())

> +	[LWT_XFRM_IF_ID]	= { .type = NLA_U32 },

I think you can use NLA_POLICY_MIN() and simplify xfrmi_build_state() below

> +	[LWT_XFRM_LINK]		= { .type = NLA_U32 },

link is an int, so s32 and you can add validation via NLA_POLICY_MIN() so you
can remove the check for !info->link below

> +};
> +
> +static void xfrmi_destroy_state(struct lwtunnel_state *lwt)
> +{
> +}
> +
> +static int xfrmi_build_state(struct net *net, struct nlattr *nla,
> +			     unsigned int family, const void *cfg,
> +			     struct lwtunnel_state **ts,
> +			     struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[LWT_XFRM_MAX + 1];
> +	struct lwtunnel_state *new_state;
> +	struct xfrm_md_info *info;
> +	int ret;
> +
> +	ret = nla_parse_nested(tb, LWT_XFRM_MAX, nla, xfrm_lwt_policy, extack);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!tb[LWT_XFRM_IF_ID])
> +		return -EINVAL;
> +
> +	new_state = lwtunnel_state_alloc(sizeof(*info));
> +	if (!new_state)
> +		return -ENOMEM;
> +
> +	new_state->type = LWTUNNEL_ENCAP_XFRM;
> +
> +	info = lwt_xfrm_info(new_state);
> +
> +	info->if_id = nla_get_u32(tb[LWT_XFRM_IF_ID]);
> +	if (!info->if_id) {
> +		ret = -EINVAL;
> +		goto errout;
> +	}
> +
> +	if (tb[LWT_XFRM_LINK]) {
> +		info->link = nla_get_u32(tb[LWT_XFRM_LINK]);

same, s32

> +		if (!info->link) {
> +			ret = -EINVAL;
> +			goto errout;
> +		}
> +	}
> +
> +	*ts = new_state;
> +	return 0;
> +
> +errout:
> +	xfrmi_destroy_state(new_state);
> +	kfree(new_state);
> +	return ret;
> +}
> +
> +static int xfrmi_fill_encap_info(struct sk_buff *skb,
> +				 struct lwtunnel_state *lwt)
> +{
> +	struct xfrm_md_info *info = lwt_xfrm_info(lwt);
> +
> +	if (nla_put_u32(skb, LWT_XFRM_IF_ID, info->if_id))
> +		return -EMSGSIZE;
> +
> +	if (info->link) {
> +		if (nla_put_u32(skb, LWT_XFRM_LINK, info->link))

same and also minor nit: these can be combined

> +			return -EMSGSIZE;
> +	}
> +
> +	return 0;
> +}
> +
> +static int xfrmi_encap_nlsize(struct lwtunnel_state *lwtstate)
> +{
> +	return nla_total_size(4) + /* LWT_XFRM_IF_ID */
> +		nla_total_size(4); /* LWT_XFRM_LINK */

nit: nla_total_size(sizeof(u32))

> +}
> +
> +static int xfrmi_encap_cmp(struct lwtunnel_state *a, struct lwtunnel_state *b)
> +{
> +	struct xfrm_md_info *a_info = lwt_xfrm_info(a);
> +	struct xfrm_md_info *b_info = lwt_xfrm_info(b);
> +
> +	return memcmp(a_info, b_info, sizeof(*a_info));
> +}
> +
> +static const struct lwtunnel_encap_ops xfrmi_encap_ops = {
> +	.build_state	= xfrmi_build_state,
> +	.destroy_state	= xfrmi_destroy_state,
> +	.fill_encap	= xfrmi_fill_encap_info,
> +	.get_encap_size = xfrmi_encap_nlsize,
> +	.cmp_encap	= xfrmi_encap_cmp,
> +	.owner		= THIS_MODULE,
> +};
> +
>  #define for_each_xfrmi_rcu(start, xi) \
>  	for (xi = rcu_dereference(start); xi; xi = rcu_dereference(xi->next))
>  
> @@ -1081,6 +1178,8 @@ static int __init xfrmi_init(void)
>  	if (err < 0)
>  		goto rtnl_link_failed;
>  
> +	lwtunnel_encap_add_ops(&xfrmi_encap_ops, LWTUNNEL_ENCAP_XFRM);
> +
>  	xfrm_if_register_cb(&xfrm_if_cb);
>  
>  	return err;
> @@ -1099,6 +1198,7 @@ static int __init xfrmi_init(void)
>  static void __exit xfrmi_fini(void)
>  {
>  	xfrm_if_unregister_cb();
> +	lwtunnel_encap_del_ops(&xfrmi_encap_ops, LWTUNNEL_ENCAP_XFRM);
>  	rtnl_link_unregister(&xfrmi_link_ops);
>  	xfrmi4_fini();
>  	xfrmi6_fini();

