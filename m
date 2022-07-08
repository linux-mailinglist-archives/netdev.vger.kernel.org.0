Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9314356C4A8
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239533AbiGHTXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 15:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239565AbiGHTXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 15:23:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42AD61EAE0
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 12:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657308186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SAGmHIi9d4MTiTBpkqka/Yr866bAJGlVWmHa5DziQ4A=;
        b=C9SC4mmbQ/AVuNX7PE1Z9vQrK7EwV69gysQzYQontziHb5nLWsi/FJWFIR70UUKMnOt+DV
        bBrDA+mG1NqbsIbf/I9iTvfH3z/glFPysd6uYJpZFp3X5fwIQ/IwbaE8QwmKK540K/6Y77
        w95nSzAPYjOXEIE9OgXo5mlrjU/NM6U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-VtRIciNfPneJl0eIg9nRHA-1; Fri, 08 Jul 2022 15:22:57 -0400
X-MC-Unique: VtRIciNfPneJl0eIg9nRHA-1
Received: by mail-wm1-f71.google.com with SMTP id r187-20020a1c44c4000000b003a2cfab0839so1715689wma.5
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 12:22:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SAGmHIi9d4MTiTBpkqka/Yr866bAJGlVWmHa5DziQ4A=;
        b=vaCdKooWhE6nXV9oZAp1ElvxaUcgWpKSCAd1gPV8sstjYhOHHCRydWq05ZwxEwwqah
         BpePfXgjMquYOrSuGzrQ+JspFK6uDJtDJco3DRVHOxlYWNkriMCBHLVc1YHhPY+PdC3v
         0tawB3HXz1Pm+mVJSuyWD0UfMdvRIq8fSMn7M67aNAxlqx9XG7pGokE7NMua9ruT1UYA
         2Q/jqW4goE/J1d+p36R+pG5pI0JKPRmneuh/zeY3DyasUpC5tSarbxJ3kMzGlV4m9QK1
         BwFFvzOEuSPyoTwAJsHNDba7/Bb7PS2ChCdUJ1tx5QT2TVFRGY5PJouHGGyJnvS69gkE
         sx3w==
X-Gm-Message-State: AJIora/XlpI5Av5OnTZFmdI7h8+HGIR37am4nGZ7pfa5HECBjrzVn/RH
        7XKiXJSQbVEYJbsL35zjstCG49OreF+z0x9IsXj2yIkrWozXGA7cfK7q7Ya0gjLC8X57064A2Kc
        jy8QW0eVcTYIi8UHa
X-Received: by 2002:adf:eec9:0:b0:21d:7ab0:340 with SMTP id a9-20020adfeec9000000b0021d7ab00340mr5187954wrp.673.1657308176388;
        Fri, 08 Jul 2022 12:22:56 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tH3PyDOHhcBHMdJ1QveLMP3RrTXah9ejTWQ+o8iIMow54AaqW81EGSGfCEzlevUsZo++ZTug==
X-Received: by 2002:adf:eec9:0:b0:21d:7ab0:340 with SMTP id a9-20020adfeec9000000b0021d7ab00340mr5187937wrp.673.1657308176181;
        Fri, 08 Jul 2022 12:22:56 -0700 (PDT)
Received: from debian.home (2a01cb058d1194004161f17a6a9ad508.ipv6.abo.wanadoo.fr. [2a01:cb05:8d11:9400:4161:f17a:6a9a:d508])
        by smtp.gmail.com with ESMTPSA id k1-20020a5d6281000000b0021b9e360523sm42693934wru.8.2022.07.08.12.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 12:22:55 -0700 (PDT)
Date:   Fri, 8 Jul 2022 21:22:53 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Marcin Szycik <marcin.szycik@linux.intel.com>
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        davem@davemloft.net, xiyou.wangcong@gmail.com,
        jesse.brandeburg@intel.com, gustavoars@kernel.org,
        baowen.zheng@corigine.com, boris.sukholitko@broadcom.com,
        edumazet@google.com, kuba@kernel.org, jhs@mojatatu.com,
        jiri@resnulli.us, kurt@linutronix.de, pablo@netfilter.org,
        pabeni@redhat.com, paulb@nvidia.com, simon.horman@corigine.com,
        komachi.yoshiki@gmail.com, zhangkaiheb@126.com,
        intel-wired-lan@lists.osuosl.org,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        alexandr.lobakin@intel.com, mostrows@earthlink.net,
        paulus@samba.org
Subject: Re: [RFC PATCH net-next v4 2/4] net/sched: flower: Add PPPoE filter
Message-ID: <20220708192253.GC3166@debian.home>
References: <20220708122421.19309-1-marcin.szycik@linux.intel.com>
 <20220708122421.19309-3-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708122421.19309-3-marcin.szycik@linux.intel.com>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 08, 2022 at 02:24:19PM +0200, Marcin Szycik wrote:
> From: Wojciech Drewek <wojciech.drewek@intel.com>
> 
> Add support for PPPoE specific fields for tc-flower.
> Those fields can be provided only when protocol was set
> to ETH_P_PPP_SES. Defines, dump, load and set are being done here.
> 
> Overwrite basic.n_proto only in case of PPP_IP and PPP_IPV6,

... and PPP_MPLS_UC/PPP_MPLS_MC in this new patch version.

> otherwise leave it as ETH_P_PPP_SES.
> 
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
> v4:
>   * support of MPLS inner fields
>   * session_id stored in __be16
> 
>  include/uapi/linux/pkt_cls.h |  3 ++
>  net/sched/cls_flower.c       | 61 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 64 insertions(+)
> 
> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> index 9a2ee1e39fad..c142c0f8ed8a 100644
> --- a/include/uapi/linux/pkt_cls.h
> +++ b/include/uapi/linux/pkt_cls.h
> @@ -589,6 +589,9 @@ enum {
>  
>  	TCA_FLOWER_KEY_NUM_OF_VLANS,    /* u8 */
>  
> +	TCA_FLOWER_KEY_PPPOE_SID,	/* be16 */
> +	TCA_FLOWER_KEY_PPP_PROTO,	/* be16 */
> +
>  	__TCA_FLOWER_MAX,
>  };
>  
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index dcca70144dff..2a0ebad0e61c 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -16,6 +16,7 @@
>  #include <linux/in6.h>
>  #include <linux/ip.h>
>  #include <linux/mpls.h>
> +#include <linux/ppp_defs.h>
>  
>  #include <net/sch_generic.h>
>  #include <net/pkt_cls.h>
> @@ -73,6 +74,7 @@ struct fl_flow_key {
>  	struct flow_dissector_key_ct ct;
>  	struct flow_dissector_key_hash hash;
>  	struct flow_dissector_key_num_of_vlans num_of_vlans;
> +	struct flow_dissector_key_pppoe pppoe;
>  } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
>  
>  struct fl_flow_mask_range {
> @@ -714,6 +716,8 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
>  	[TCA_FLOWER_KEY_HASH]		= { .type = NLA_U32 },
>  	[TCA_FLOWER_KEY_HASH_MASK]	= { .type = NLA_U32 },
>  	[TCA_FLOWER_KEY_NUM_OF_VLANS]	= { .type = NLA_U8 },
> +	[TCA_FLOWER_KEY_PPPOE_SID]	= { .type = NLA_U16 },
> +	[TCA_FLOWER_KEY_PPP_PROTO]	= { .type = NLA_U16 },
>  
>  };
>  
> @@ -1041,6 +1045,50 @@ static void fl_set_key_vlan(struct nlattr **tb,
>  	}
>  }
>  
> +static void fl_set_key_pppoe(struct nlattr **tb,
> +			     struct flow_dissector_key_pppoe *key_val,
> +			     struct flow_dissector_key_pppoe *key_mask,
> +			     struct fl_flow_key *key,
> +			     struct fl_flow_key *mask)
> +{
> +	/* key_val::type must be set to ETH_P_PPP_SES
> +	 * because ETH_P_PPP_SES was stored in basic.n_proto
> +	 * which might get overwritten by ppp_proto
> +	 * or might be set to 0, the role of key_val::type
> +	 * is simmilar to vlan_key::tpid

Didn't you mean "vlan_tpid"?

> +	 */
> +	key_val->type = htons(ETH_P_PPP_SES);
> +	key_mask->type = cpu_to_be16(~0);
> +
> +	if (tb[TCA_FLOWER_KEY_PPPOE_SID]) {
> +		key_val->session_id =
> +			nla_get_be16(tb[TCA_FLOWER_KEY_PPPOE_SID]);
> +		key_mask->session_id = cpu_to_be16(~0);
> +	}
> +	if (tb[TCA_FLOWER_KEY_PPP_PROTO]) {
> +		key_val->ppp_proto =
> +			nla_get_be16(tb[TCA_FLOWER_KEY_PPP_PROTO]);
> +		key_mask->ppp_proto = cpu_to_be16(~0);
> +
> +		if (key_val->ppp_proto == htons(PPP_IP)) {
> +			key->basic.n_proto = htons(ETH_P_IP);
> +			mask->basic.n_proto = cpu_to_be16(~0);
> +		} else if (key_val->ppp_proto == htons(PPP_IPV6)) {
> +			key->basic.n_proto = htons(ETH_P_IPV6);
> +			mask->basic.n_proto = cpu_to_be16(~0);
> +		} else if (key_val->ppp_proto == htons(PPP_MPLS_UC)) {
> +			key->basic.n_proto = htons(ETH_P_MPLS_UC);
> +			mask->basic.n_proto = cpu_to_be16(~0);
> +		} else if (key_val->ppp_proto == htons(PPP_MPLS_MC)) {
> +			key->basic.n_proto = htons(ETH_P_MPLS_MC);
> +			mask->basic.n_proto = cpu_to_be16(~0);
> +		}
> +	} else {
> +		key->basic.n_proto = 0;
> +		mask->basic.n_proto = cpu_to_be16(0);
> +	}
> +}
> +
>  static void fl_set_key_flag(u32 flower_key, u32 flower_mask,
>  			    u32 *dissector_key, u32 *dissector_mask,
>  			    u32 flower_flag_bit, u32 dissector_flag_bit)
> @@ -1651,6 +1699,9 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
>  		}
>  	}
>  
> +	if (key->basic.n_proto == htons(ETH_P_PPP_SES))
> +		fl_set_key_pppoe(tb, &key->pppoe, &mask->pppoe, key, mask);
> +
>  	if (key->basic.n_proto == htons(ETH_P_IP) ||
>  	    key->basic.n_proto == htons(ETH_P_IPV6)) {
>  		fl_set_key_val(tb, &key->basic.ip_proto, TCA_FLOWER_KEY_IP_PROTO,
> @@ -1923,6 +1974,8 @@ static void fl_init_dissector(struct flow_dissector *dissector,
>  			     FLOW_DISSECTOR_KEY_HASH, hash);
>  	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
>  			     FLOW_DISSECTOR_KEY_NUM_OF_VLANS, num_of_vlans);
> +	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
> +			     FLOW_DISSECTOR_KEY_PPPOE, pppoe);
>  
>  	skb_flow_dissector_init(dissector, keys, cnt);
>  }
> @@ -3051,6 +3104,14 @@ static int fl_dump_key(struct sk_buff *skb, struct net *net,
>  	    fl_dump_key_ip(skb, false, &key->ip, &mask->ip)))
>  		goto nla_put_failure;
>  
> +	if (mask->pppoe.session_id &&
> +	    nla_put_be16(skb, TCA_FLOWER_KEY_PPPOE_SID, key->pppoe.session_id))
> +		goto nla_put_failure;
> +
> +	if (mask->basic.n_proto && mask->pppoe.ppp_proto &&
> +	    nla_put_be16(skb, TCA_FLOWER_KEY_PPP_PROTO, key->pppoe.ppp_proto))
> +		goto nla_put_failure;
> +
>  	if (key->control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS &&
>  	    (fl_dump_key_val(skb, &key->ipv4.src, TCA_FLOWER_KEY_IPV4_SRC,
>  			     &mask->ipv4.src, TCA_FLOWER_KEY_IPV4_SRC_MASK,
> -- 
> 2.35.1
> 

