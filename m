Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCD45626D7
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 01:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbiF3XMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 19:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbiF3XMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 19:12:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F2F358FF5
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 16:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656630712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qbPBUmvK6wYEp85KbixKxSh0oKKcf09knZROWjKJDO4=;
        b=iW+SSYB4s/9YvWYc6aCTK55p+BDqZr2QkVG0eWIfPL0daLrzKSR9wNg1TcY1IZ/aV6KYm5
        nk7OGqgqQ+0zttMWeThJGI9c3YK4M3D6PNAlxG2Oj2LLmhsCY1rpyVETLLZkQQ1awk4z9Q
        FhNTZV5Shify2bWMpXJ1ZDSOuRY9C1A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-b9GpAznXOZaCR84YcODdZA-1; Thu, 30 Jun 2022 19:11:51 -0400
X-MC-Unique: b9GpAznXOZaCR84YcODdZA-1
Received: by mail-wr1-f71.google.com with SMTP id r15-20020adff10f000000b0021bcc217e15so59521wro.19
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 16:11:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qbPBUmvK6wYEp85KbixKxSh0oKKcf09knZROWjKJDO4=;
        b=wfgn8PbJUYAWrywuztazT/PsiD8b+XA5mWreVOXiBdLAtEtcUftPXcJ+qaJR5ye/DS
         KkvAeFq5eG3eyPDAlgD22g4ZRVyWCLofCR8iIMaHgM0rMr1ndn5LwB1bY7OQvdcnFyoN
         lHBfwwdLmxiwe5flmnMTgoO36WaK9vuYT7qNgzSDSfJj1rC+4n03fxTCd+FrsI6tt/wj
         Sjp7YOl9oR7t3Hj1z6rE2RpGum13SSAY8WzN7DG+QKSU7Xi/OEnegwGT7Xdx4QEfKUIM
         GWAMefBqwxtaxsK305eRobivRqLXwSD/n3ZnuHZXaGGIYJtjb6hFVqye4nHUv9+xR88L
         lSgA==
X-Gm-Message-State: AJIora9wEEPR1GkKVY2dJ72rkLb8MScR1mihzba8dh4LOvS8T3foHOTJ
        5ODXrJkv5AvMJZFsrvqGMacPq84VmxCdiBI6YZyz5F6ph9hLgV/g5yk88AU5yzCEzXdj69iMY+U
        9FCi+GvfvfnRrW96w
X-Received: by 2002:a05:600c:4304:b0:3a1:7673:636c with SMTP id p4-20020a05600c430400b003a17673636cmr9899089wme.131.1656630709981;
        Thu, 30 Jun 2022 16:11:49 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uAvzLb9OXq14FxhjbPZ/lOdlJyKaLlURWehvY0gsK9XPoGU+Yr6ldzNwBJ+o4g672O8TY7Gg==
X-Received: by 2002:a05:600c:4304:b0:3a1:7673:636c with SMTP id p4-20020a05600c430400b003a17673636cmr9899074wme.131.1656630709789;
        Thu, 30 Jun 2022 16:11:49 -0700 (PDT)
Received: from debian.home (2a01cb058d1194004161f17a6a9ad508.ipv6.abo.wanadoo.fr. [2a01:cb05:8d11:9400:4161:f17a:6a9a:d508])
        by smtp.gmail.com with ESMTPSA id r185-20020a1c2bc2000000b003a0484c069bsm9005514wmr.41.2022.06.30.16.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 16:11:49 -0700 (PDT)
Date:   Fri, 1 Jul 2022 01:11:47 +0200
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
Subject: Re: [RFC PATCH net-next v3 2/4] net/sched: flower: Add PPPoE filter
Message-ID: <20220630231147.GB392@debian.home>
References: <20220629143859.209028-1-marcin.szycik@linux.intel.com>
 <20220629143859.209028-3-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629143859.209028-3-marcin.szycik@linux.intel.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 04:38:57PM +0200, Marcin Szycik wrote:
> From: Wojciech Drewek <wojciech.drewek@intel.com>
> 
> Add support for PPPoE specific fields for tc-flower.
> Those fields can be provided only when protocol was set
> to ETH_P_PPP_SES. Defines, dump, load and set are being done here.
> 
> Overwrite basic.n_proto only in case of PPP_IP and PPP_IPV6,
> otherwise leave it as ETH_P_PPP_SES.
> 
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
>  include/uapi/linux/pkt_cls.h |  3 +++
>  net/sched/cls_flower.c       | 46 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 49 insertions(+)
> 
> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> index 9a2ee1e39fad..a67dcd8294c9 100644
> --- a/include/uapi/linux/pkt_cls.h
> +++ b/include/uapi/linux/pkt_cls.h
> @@ -589,6 +589,9 @@ enum {
>  
>  	TCA_FLOWER_KEY_NUM_OF_VLANS,    /* u8 */
>  
> +	TCA_FLOWER_KEY_PPPOE_SID,	/* u16 */
> +	TCA_FLOWER_KEY_PPP_PROTO,	/* be16 */

Same as for patch 1, should PPPOE_SID be a be16?

>  	__TCA_FLOWER_MAX,
>  };
>  
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index dcca70144dff..f6a0bb87f869 100644
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
> @@ -1041,6 +1045,32 @@ static void fl_set_key_vlan(struct nlattr **tb,
>  	}
>  }
>  
> +static void fl_set_key_pppoe(struct nlattr **tb,
> +			     struct flow_dissector_key_pppoe *key_val,
> +			     struct flow_dissector_key_pppoe *key_mask,
> +			     struct fl_flow_key *key,
> +			     struct fl_flow_key *mask)
> +{
> +	if (tb[TCA_FLOWER_KEY_PPPOE_SID]) {
> +		key_val->session_id =
> +			nla_get_u16(tb[TCA_FLOWER_KEY_PPPOE_SID]);
> +		key_mask->session_id = 0xffff;
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
> +		}

Again, is the lack of MPLS support voluntary?

> +	}
> +}
> +
>  static void fl_set_key_flag(u32 flower_key, u32 flower_mask,
>  			    u32 *dissector_key, u32 *dissector_mask,
>  			    u32 flower_flag_bit, u32 dissector_flag_bit)
> @@ -1651,6 +1681,9 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
>  		}
>  	}
>  
> +	if (key->basic.n_proto == htons(ETH_P_PPP_SES))
> +		fl_set_key_pppoe(tb, &key->pppoe, &mask->pppoe, key, mask);
> +
>  	if (key->basic.n_proto == htons(ETH_P_IP) ||
>  	    key->basic.n_proto == htons(ETH_P_IPV6)) {
>  		fl_set_key_val(tb, &key->basic.ip_proto, TCA_FLOWER_KEY_IP_PROTO,
> @@ -1923,6 +1956,8 @@ static void fl_init_dissector(struct flow_dissector *dissector,
>  			     FLOW_DISSECTOR_KEY_HASH, hash);
>  	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
>  			     FLOW_DISSECTOR_KEY_NUM_OF_VLANS, num_of_vlans);
> +	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
> +			     FLOW_DISSECTOR_KEY_PPPOE, pppoe);
>  
>  	skb_flow_dissector_init(dissector, keys, cnt);
>  }
> @@ -3051,6 +3086,17 @@ static int fl_dump_key(struct sk_buff *skb, struct net *net,
>  	    fl_dump_key_ip(skb, false, &key->ip, &mask->ip)))
>  		goto nla_put_failure;
>  
> +	if (mask->pppoe.session_id) {
> +		if (nla_put_u16(skb, TCA_FLOWER_KEY_PPPOE_SID,
> +				key->pppoe.session_id))
> +			goto nla_put_failure;
> +	}
> +	if (mask->basic.n_proto && mask->pppoe.ppp_proto) {
> +		if (nla_put_be16(skb, TCA_FLOWER_KEY_PPP_PROTO,
> +				 key->pppoe.ppp_proto))
> +			goto nla_put_failure;
> +	}
> +
>  	if (key->control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS &&
>  	    (fl_dump_key_val(skb, &key->ipv4.src, TCA_FLOWER_KEY_IPV4_SRC,
>  			     &mask->ipv4.src, TCA_FLOWER_KEY_IPV4_SRC_MASK,
> -- 
> 2.35.1
> 

