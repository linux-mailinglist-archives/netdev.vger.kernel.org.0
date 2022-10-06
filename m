Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD4B5F63EF
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 11:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbiJFJ55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 05:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbiJFJ5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 05:57:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDA382765
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 02:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665050273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RvpLbY8cytTinw52C7yEAlAPenNp96tVAEdyi+I4+rc=;
        b=HzPXmh3IWA3v18naH7Gkx5cVA+yOcMF6Zc3ub+kvaFPmrrEjCdTOqsAe+naR9+/Nq4x1GY
        VxqpEyBos1IPuokUOMixJzPtzJF2AA1QC3pqrWSnV8bG6HcXZvOeYQTp/c2BnEdztLdaKY
        RGeSafYe7krosGgvDcvq4mrq4kmNsLY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-607-DHWjD88QNMOemZPd_-qr9A-1; Thu, 06 Oct 2022 05:57:52 -0400
X-MC-Unique: DHWjD88QNMOemZPd_-qr9A-1
Received: by mail-qv1-f72.google.com with SMTP id q17-20020a056214019100b004b1d3c9f3acso795132qvr.0
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 02:57:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=RvpLbY8cytTinw52C7yEAlAPenNp96tVAEdyi+I4+rc=;
        b=x5oUEpFGzjcqAol24/vIl9Ys4cdREL0L3/9FiMN4dyQbvAug/1PaEaWVHoN0QAA0tK
         FAySS0HJyWtcHv/KnGnN9tKByXM8lnv68zt216jVhVF4jVGaEE4HqQdYPe0OjqN0McBo
         6B9nv8ZFKgatqUSQju5YU11bTkQC47NTRroTE5r/6tp522TLFiCSbVSJdhF3Ry0QFgaV
         GSvucdDaX+DcxWHwnPCyWJN93PykWmmVy8X2timjT/YOvZO5C4q/sr7vR2GDHLLFiKpA
         UgnX+1zKw+5gh0VDDkEPzdZ8zKhdzwm4qOoWOdQGmCgYjvLcLtdDIuMhNcBB+xHLZDWT
         ez0Q==
X-Gm-Message-State: ACrzQf1Gj5DjMhsg3h7HgxE0qbauOTiUX1/vE3Fi7bFTV+IRJsMCDFkg
        z9R/WCrdtQQmtXETbP39giz4TxcMVHt/2sojLkHy/kc90mGkWnQ79S7SEUea9Mo5gXLfifHo1Wx
        CtHWOE2KOcVs6D3PS
X-Received: by 2002:ac8:44d5:0:b0:35b:aff2:96b1 with SMTP id b21-20020ac844d5000000b0035baff296b1mr2658919qto.32.1665050271708;
        Thu, 06 Oct 2022 02:57:51 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4M63xf0nlKvmJnxBz8mLEbElnRi00ykNG8nEDEGUFSBl1b8Mb+uJQB5bV6I4MgE64OH0D2AA==
X-Received: by 2002:ac8:44d5:0:b0:35b:aff2:96b1 with SMTP id b21-20020ac844d5000000b0035baff296b1mr2658908qto.32.1665050271429;
        Thu, 06 Oct 2022 02:57:51 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id bm8-20020a05620a198800b006cfc7f9eea0sm19053248qkb.122.2022.10.06.02.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 02:57:50 -0700 (PDT)
Message-ID: <394a97ff1f8adddbab794e0f61221fefddfe9d3f.camel@redhat.com>
Subject: Re: [PATCH net-next 3/3] net: sched: add helper support in act_ct
From:   Paolo Abeni <pabeni@redhat.com>
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>
Date:   Thu, 06 Oct 2022 11:57:45 +0200
In-Reply-To: <bc53ffac4d6be2616d053684fb6670f478b4324b.1664932669.git.lucien.xin@gmail.com>
References: <cover.1664932669.git.lucien.xin@gmail.com>
         <bc53ffac4d6be2616d053684fb6670f478b4324b.1664932669.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-10-04 at 21:19 -0400, Xin Long wrote:
> This patch is to add helper support in act_ct for OVS actions=ct(alg=xxx)
> offloading, which is corresponding to Commit cae3a2627520 ("openvswitch:
> Allow attaching helpers to ct action") in OVS kernel part.
> 
> The difference is when adding TC actions family and proto cannot be got
> from the filter/match, other than helper name in tb[TCA_CT_HELPER_NAME],
> we also need to send the family in tb[TCA_CT_HELPER_FAMILY] and the
> proto in tb[TCA_CT_HELPER_PROTO] to kernel.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/net/tc_act/tc_ct.h        |   1 +
>  include/uapi/linux/tc_act/tc_ct.h |   3 +
>  net/sched/act_ct.c                | 113 ++++++++++++++++++++++++++++--
>  3 files changed, 112 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/tc_act/tc_ct.h b/include/net/tc_act/tc_ct.h
> index 8250d6f0a462..b24ea2d9400b 100644
> --- a/include/net/tc_act/tc_ct.h
> +++ b/include/net/tc_act/tc_ct.h
> @@ -10,6 +10,7 @@
>  #include <net/netfilter/nf_conntrack_labels.h>
>  
>  struct tcf_ct_params {
> +	struct nf_conntrack_helper *helper;
>  	struct nf_conn *tmpl;
>  	u16 zone;
>  
> diff --git a/include/uapi/linux/tc_act/tc_ct.h b/include/uapi/linux/tc_act/tc_ct.h
> index 5fb1d7ac1027..6c5200f0ed38 100644
> --- a/include/uapi/linux/tc_act/tc_ct.h
> +++ b/include/uapi/linux/tc_act/tc_ct.h
> @@ -22,6 +22,9 @@ enum {
>  	TCA_CT_NAT_PORT_MIN,	/* be16 */
>  	TCA_CT_NAT_PORT_MAX,	/* be16 */
>  	TCA_CT_PAD,
> +	TCA_CT_HELPER_NAME,	/* string */
> +	TCA_CT_HELPER_FAMILY,	/* u8 */
> +	TCA_CT_HELPER_PROTO,	/* u8 */
>  	__TCA_CT_MAX
>  };
>  
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index 193a460a9d7f..f237c27079db 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -33,6 +33,7 @@
>  #include <net/netfilter/nf_conntrack_acct.h>
>  #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
>  #include <net/netfilter/nf_conntrack_act_ct.h>
> +#include <net/netfilter/nf_conntrack_seqadj.h>
>  #include <uapi/linux/netfilter/nf_nat.h>
>  
>  static struct workqueue_struct *act_ct_wq;
> @@ -655,7 +656,7 @@ struct tc_ct_action_net {
>  
>  /* Determine whether skb->_nfct is equal to the result of conntrack lookup. */
>  static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
> -				   u16 zone_id, bool force)
> +				   struct tcf_ct_params *p, bool force)
>  {
>  	enum ip_conntrack_info ctinfo;
>  	struct nf_conn *ct;
> @@ -665,8 +666,15 @@ static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
>  		return false;
>  	if (!net_eq(net, read_pnet(&ct->ct_net)))
>  		goto drop_ct;
> -	if (nf_ct_zone(ct)->id != zone_id)
> +	if (nf_ct_zone(ct)->id != p->zone)
>  		goto drop_ct;
> +	if (p->helper) {
> +		struct nf_conn_help *help;
> +
> +		help = nf_ct_ext_find(ct, NF_CT_EXT_HELPER);
> +		if (help && rcu_access_pointer(help->helper) != p->helper)
> +			goto drop_ct;
> +	}
>  
>  	/* Force conntrack entry direction. */
>  	if (force && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
> @@ -832,6 +840,13 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
>  
>  static void tcf_ct_params_free(struct tcf_ct_params *params)
>  {
> +	if (params->helper) {
> +#if IS_ENABLED(CONFIG_NF_NAT)
> +		if (params->ct_action & TCA_CT_ACT_NAT)
> +			nf_nat_helper_put(params->helper);
> +#endif
> +		nf_conntrack_helper_put(params->helper);
> +	}

There is exactly the same code chunk in __ovs_ct_free_action(), I guess
you can extract a common helper here, too.

>  	if (params->ct_ft)
>  		tcf_ct_flow_table_put(params->ct_ft);
>  	if (params->tmpl)
> @@ -1033,6 +1048,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  	struct nf_hook_state state;
>  	int nh_ofs, err, retval;
>  	struct tcf_ct_params *p;
> +	bool add_helper = false;
>  	bool skip_add = false;
>  	bool defrag = false;
>  	struct nf_conn *ct;
> @@ -1086,7 +1102,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  	 * actually run the packet through conntrack twice unless it's for a
>  	 * different zone.
>  	 */
> -	cached = tcf_ct_skb_nfct_cached(net, skb, p->zone, force);
> +	cached = tcf_ct_skb_nfct_cached(net, skb, p, force);
>  	if (!cached) {
>  		if (tcf_ct_flow_table_lookup(p, skb, family)) {
>  			skip_add = true;
> @@ -1119,6 +1135,22 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  	if (err != NF_ACCEPT)
>  		goto drop;
>  
> +	if (commit && p->helper && !nfct_help(ct)) {
> +		err = __nf_ct_try_assign_helper(ct, p->tmpl, GFP_ATOMIC);
> +		if (err)
> +			goto drop;
> +		add_helper = true;
> +		if (p->ct_action & TCA_CT_ACT_NAT && !nfct_seqadj(ct)) {
> +			if (!nfct_seqadj_ext_add(ct))
> +				return -EINVAL;

This return looks suspect/wrong. It will confuse the tc action
mechanism. I guess you shold do
				goto drop;

even here. 

> +		}
> +	}
> +
> +	if (nf_ct_is_confirmed(ct) ? ((!cached && !skip_add) || add_helper) : commit) {
> +		if (nf_ct_helper(skb, family) != NF_ACCEPT)
> +			goto drop;

With the above change, this chunk closely resamble

https://elixir.bootlin.com/linux/latest/source/net/openvswitch/conntrack.c#L1018
...
https://elixir.bootlin.com/linux/latest/source/net/openvswitch/conntrack.c#L1042

opening to an additional common helper;) Not strictly necessary, just
nice to have :)


Thanks!

Paolo

