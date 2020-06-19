Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7D62009B0
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 15:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732608AbgFSNOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 09:14:25 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:58641 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730977AbgFSNOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 09:14:25 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5622B5802C9;
        Fri, 19 Jun 2020 09:14:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 19 Jun 2020 09:14:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=SQB6Hq
        PSKWMtbqH8ub7Su1qazZT0SQN2ie5BqJq4EkY=; b=t7/RCjUopWB7zOP8E29XSY
        3UKt3A43qPSE9k+7jtz5sDCGAX/vsLjtPWv9YXNgJumSPdUk0ncu2rFLMtyNe5/W
        kCvanqQHMxzVUHl3eU2HC4i2eSLTbCYzJFGrRXzTeUAdreARHfuM/YGXCATpyyhb
        bm3ysW8ZSVk7WerJQHbjHQ8j1teQhVVLcvu7MnFdAPuE07m2m9IhtUTNh1dCB8L1
        60g1yrzagFGZ1PE6wit0pPy0wpwJgYl1j5ENVmyPLGb5A0v4xxEAYRoH7bGTiLGK
        RXYDruhzYYKw5jl6sWOLptIon0AXpoMXHZ3au7tFi//gIpwBacFb4BE4lJEws/rA
        ==
X-ME-Sender: <xms:LbrsXiXELscSI7xciCEZydaQjUqPGUbb2JK_qIT1y5aSt8wby8MNtQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepleehtdffhedvffejvdduteelhfekue
    eghfekleetveeugefhveetkedtgfdtgefhnecuffhomhgrihhnpegtrghprggsihhlihht
    ihgvshdrhhhofidpghhithhhuhgsrdgtohhmnecukfhppedutdelrdeijedrkedruddvle
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiugho
    shgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:LbrsXundNANNrmHDfN3MaryYo8Z30z-j1wYFBeWLDzujO68olJDYow>
    <xmx:LbrsXmYqDnVOWlNL3D8FdNB2fWvdVJy62xbaHcNKzQ_rL9bchXGBfA>
    <xmx:LbrsXpUdC2C0vNHLUEpP5LAFiW5sqUAi_IKLY8wYGT3Ciy0wUhbSLA>
    <xmx:LrrsXmW0JRqpWKFTArxYr_BITP9eedelxmK1RQj3UF16gJcV22rmZw>
Received: from localhost (bzq-109-67-8-129.red.bezeqint.net [109.67.8.129])
        by mail.messagingengine.com (Postfix) with ESMTPA id 00A4730618C1;
        Fri, 19 Jun 2020 09:14:19 -0400 (EDT)
Date:   Fri, 19 Jun 2020 16:14:17 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     dsatish <satish.d@oneconvergence.com>
Cc:     davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuba@kernel.org, netdev@vger.kernel.org,
        simon.horman@netronome.com, kesavac@gmail.com,
        prathibha.nagooru@oneconvergence.com,
        intiyaz.basha@oneconvergence.com, jai.rana@oneconvergence.com
Subject: Re: [PATCH net-next 2/3] cls_flower: Pass the unmasked key to hw
Message-ID: <20200619131417.GA400561@splinter>
References: <20200619094156.31184-1-satish.d@oneconvergence.com>
 <20200619094156.31184-3-satish.d@oneconvergence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619094156.31184-3-satish.d@oneconvergence.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 03:11:55PM +0530, dsatish wrote:
> Pass the unmasked key along with the masked key to the hardware.
> This enables hardware to manage its own tables better based on the
> hardware features/capabilities.

How? Which hardware? You did not patch a single driver...

Are you familiar with chain templates? I think it might help:
https://github.com/Mellanox/mlxsw/wiki/ACLs#chain-templates

> 
> Signed-off-by: Chandra Kesava <kesavac@gmail.com>
> Signed-off-by: Prathibha Nagooru <prathibha.nagooru@oneconvergence.com>
> Signed-off-by: Satish Dhote <satish.d@oneconvergence.com>
> ---
>  include/net/flow_offload.h |  45 ++++++++++
>  net/core/flow_offload.c    | 171 +++++++++++++++++++++++++++++++++++++
>  net/sched/cls_flower.c     |  43 ++++++++++
>  3 files changed, 259 insertions(+)
> 
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index f2c8311a0433..26c6bd6bdb98 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -11,6 +11,8 @@ struct flow_match {
>  	struct flow_dissector	*dissector;
>  	void			*mask;
>  	void			*key;
> +	void			*unmasked_key;
> +	struct flow_dissector	*unmasked_key_dissector;
>  };
>  
>  struct flow_match_meta {
> @@ -118,6 +120,49 @@ void flow_rule_match_enc_opts(const struct flow_rule *rule,
>  void flow_rule_match_ct(const struct flow_rule *rule,
>  			struct flow_match_ct *out);
>  
> +void flow_rule_match_unmasked_key_meta(const struct flow_rule *rule,
> +				       struct flow_match_meta *out);
> +void flow_rule_match_unmasked_key_basic(const struct flow_rule *rule,
> +					struct flow_match_basic *out);
> +void flow_rule_match_unmasked_key_control(const struct flow_rule *rule,
> +					  struct flow_match_control *out);
> +void flow_rule_match_unmasked_key_eth_addrs(const struct flow_rule *rule,
> +					    struct flow_match_eth_addrs *out);
> +void flow_rule_match_unmasked_key_vlan(const struct flow_rule *rule,
> +				       struct flow_match_vlan *out);
> +void flow_rule_match_unmasked_key_cvlan(const struct flow_rule *rule,
> +					struct flow_match_vlan *out);
> +void flow_rule_match_unmasked_key_ipv4_addrs(const struct flow_rule *rule,
> +					     struct flow_match_ipv4_addrs *out);
> +void flow_rule_match_unmasked_key_ipv6_addrs(const struct flow_rule *rule,
> +					     struct flow_match_ipv6_addrs *out);
> +void flow_rule_match_unmasked_key_ip(const struct flow_rule *rule,
> +				     struct flow_match_ip *out);
> +void flow_rule_match_unmasked_key_ports(const struct flow_rule *rule,
> +					struct flow_match_ports *out);
> +void flow_rule_match_unmasked_key_tcp(const struct flow_rule *rule,
> +				      struct flow_match_tcp *out);
> +void flow_rule_match_unmasked_key_icmp(const struct flow_rule *rule,
> +				       struct flow_match_icmp *out);
> +void flow_rule_match_unmasked_key_mpls(const struct flow_rule *rule,
> +				       struct flow_match_mpls *out);
> +void flow_rule_match_unmasked_key_enc_control(const struct flow_rule *rule,
> +					      struct flow_match_control *out);
> +void flow_rule_match_unmasked_key_enc_ipv4_addrs(const struct flow_rule *rule,
> +					    struct flow_match_ipv4_addrs *out);
> +void flow_rule_match_unmasked_key_enc_ipv6_addrs(const struct flow_rule *rule,
> +					    struct flow_match_ipv6_addrs *out);
> +void flow_rule_match_unmasked_key_enc_ip(const struct flow_rule *rule,
> +					 struct flow_match_ip *out);
> +void flow_rule_match_unmasked_key_enc_ports(const struct flow_rule *rule,
> +					    struct flow_match_ports *out);
> +void flow_rule_match_unmasked_key_enc_keyid(const struct flow_rule *rule,
> +					    struct flow_match_enc_keyid *out);
> +void flow_rule_match_unmasked_key_enc_opts(const struct flow_rule *rule,
> +					   struct flow_match_enc_opts *out);
> +void flow_rule_match_unmasked_key_ct(const struct flow_rule *rule,
> +				     struct flow_match_ct *out);
> +
>  enum flow_action_id {
>  	FLOW_ACTION_ACCEPT		= 0,
>  	FLOW_ACTION_DROP,
> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> index 0cfc35e6be28..a98c31e864b1 100644
> --- a/net/core/flow_offload.c
> +++ b/net/core/flow_offload.c
> @@ -173,6 +173,177 @@ void flow_rule_match_enc_opts(const struct flow_rule *rule,
>  }
>  EXPORT_SYMBOL(flow_rule_match_enc_opts);
>  
> +#define FLOW_UNMASKED_KEY_DISSECTOR_MATCH(__rule, __type, __out)	\
> +	const struct flow_match *__m = &(__rule)->match;		\
> +	struct flow_dissector *__d = (__m)->unmasked_key_dissector;	\
> +									\
> +	(__out)->key = skb_flow_dissector_target(__d, __type,		\
> +						 (__m)->unmasked_key);	\
> +	(__out)->mask = skb_flow_dissector_target(__d, __type,		\
> +						  (__m)->mask)		\
> +
> +void flow_rule_match_unmasked_key_meta(const struct flow_rule *rule,
> +				       struct flow_match_meta *out)
> +{
> +	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_META, out);
> +}
> +EXPORT_SYMBOL(flow_rule_match_unmasked_key_meta);
> +
> +void
> +flow_rule_match_unmasked_key_basic(const struct flow_rule *rule,
> +				   struct flow_match_basic *out)
> +{
> +	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_BASIC, out);
> +}
> +EXPORT_SYMBOL(flow_rule_match_unmasked_key_basic);
> +
> +void flow_rule_match_unmasked_key_control(const struct flow_rule *rule,
> +					  struct flow_match_control *out)
> +{
> +	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_CONTROL,
> +					  out);
> +}
> +EXPORT_SYMBOL(flow_rule_match_unmasked_key_control);
> +
> +void flow_rule_match_unmasked_key_eth_addrs(const struct flow_rule *rule,
> +					    struct flow_match_eth_addrs *out)
> +{
> +	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS,
> +					  out);
> +}
> +EXPORT_SYMBOL(flow_rule_match_unmasked_key_eth_addrs);
> +
> +void flow_rule_match_unmasked_key_vlan(const struct flow_rule *rule,
> +				       struct flow_match_vlan *out)
> +{
> +	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_VLAN, out);
> +}
> +EXPORT_SYMBOL(flow_rule_match_unmasked_key_vlan);
> +
> +void flow_rule_match_unmasked_key_cvlan(const struct flow_rule *rule,
> +					struct flow_match_vlan *out)
> +{
> +	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_CVLAN, out);
> +}
> +EXPORT_SYMBOL(flow_rule_match_unmasked_key_cvlan);
> +
> +void flow_rule_match_unmasked_key_ipv4_addrs(const struct flow_rule *rule,
> +					     struct flow_match_ipv4_addrs *out)
> +{
> +	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS,
> +					  out);
> +}
> +EXPORT_SYMBOL(flow_rule_match_unmasked_key_ipv4_addrs);
> +
> +void flow_rule_match_unmasked_key_ipv6_addrs(const struct flow_rule *rule,
> +					     struct flow_match_ipv6_addrs *out)
> +{
> +	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_IPV6_ADDRS,
> +					  out);
> +}
> +EXPORT_SYMBOL(flow_rule_match_unmasked_key_ipv6_addrs);
> +
> +void flow_rule_match_unmasked_key_ip(const struct flow_rule *rule,
> +				     struct flow_match_ip *out)
> +{
> +	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_IP, out);
> +}
> +EXPORT_SYMBOL(flow_rule_match_unmasked_key_ip);
> +
> +void flow_rule_match_unmasked_key_ports(const struct flow_rule *rule,
> +					struct flow_match_ports *out)
> +{
> +	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_PORTS, out);
> +}
> +EXPORT_SYMBOL(flow_rule_match_unmasked_key_ports);
> +
> +void flow_rule_match_unmasked_key_tcp(const struct flow_rule *rule,
> +				      struct flow_match_tcp *out)
> +{
> +	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_TCP, out);
> +}
> +EXPORT_SYMBOL(flow_rule_match_unmasked_key_tcp);
> +
> +void flow_rule_match_unmasked_key_icmp(const struct flow_rule *rule,
> +				       struct flow_match_icmp *out)
> +{
> +	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ICMP, out);
> +}
> +EXPORT_SYMBOL(flow_rule_match_unmasked_key_icmp);
> +
> +void flow_rule_match_unmasked_key_mpls(const struct flow_rule *rule,
> +				       struct flow_match_mpls *out)
> +{
> +	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_MPLS, out);
> +}
> +EXPORT_SYMBOL(flow_rule_match_unmasked_key_mpls);
> +
> +void flow_rule_match_unmasked_key_enc_control(const struct flow_rule *rule,
> +					      struct flow_match_control *out)
> +{
> +	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL,
> +					  out);
> +}
> +EXPORT_SYMBOL(flow_rule_match_unmasked_key_enc_control);
> +
> +void
> +flow_rule_match_unmasked_key_enc_ipv4_addrs(const struct flow_rule *rule,
> +					    struct flow_match_ipv4_addrs *out)
> +{
> +	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule,
> +					  FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS,
> +					  out);
> +}
> +EXPORT_SYMBOL(flow_rule_match_unmasked_key_enc_ipv4_addrs);
> +
> +void
> +flow_rule_match_unmasked_key_enc_ipv6_addrs(const struct flow_rule *rule,
> +					    struct flow_match_ipv6_addrs *out)
> +{
> +	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule,
> +					  FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS,
> +					  out);
> +}
> +EXPORT_SYMBOL(flow_rule_match_unmasked_key_enc_ipv6_addrs);
> +
> +void flow_rule_match_unmasked_key_enc_ip(const struct flow_rule *rule,
> +					 struct flow_match_ip *out)
> +{
> +	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ENC_IP, out);
> +}
> +EXPORT_SYMBOL(flow_rule_match_unmasked_key_enc_ip);
> +
> +void flow_rule_match_unmasked_key_enc_ports(const struct flow_rule *rule,
> +					    struct flow_match_ports *out)
> +{
> +	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ENC_PORTS,
> +					  out);
> +}
> +EXPORT_SYMBOL(flow_rule_match_unmasked_key_enc_ports);
> +
> +void flow_rule_match_unmasked_key_enc_keyid(const struct flow_rule *rule,
> +					    struct flow_match_enc_keyid *out)
> +{
> +	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ENC_KEYID,
> +					  out);
> +}
> +EXPORT_SYMBOL(flow_rule_match_unmasked_key_enc_keyid);
> +
> +void flow_rule_match_unmasked_key_enc_opts(const struct flow_rule *rule,
> +					   struct flow_match_enc_opts *out)
> +{
> +	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ENC_OPTS,
> +					  out);
> +}
> +EXPORT_SYMBOL(flow_rule_match_unmasked_key_enc_opts);
> +
> +void flow_rule_match_unmasked_key_ct(const struct flow_rule *rule,
> +				     struct flow_match_ct *out)
> +{
> +	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_CT, out);
> +}
> +EXPORT_SYMBOL(flow_rule_match_unmasked_key_ct);
> +
>  struct flow_action_cookie *flow_action_cookie_create(void *data,
>  						     unsigned int len,
>  						     gfp_t gfp)
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index 64b70d396397..f1a5352cbb04 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -121,6 +121,7 @@ struct cls_fl_filter {
>  	 */
>  	refcount_t refcnt;
>  	bool deleted;
> +	struct flow_dissector unmasked_key_dissector;
>  };
>  
>  static const struct rhashtable_params mask_ht_params = {
> @@ -449,6 +450,13 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
>  	cls_flower.rule->match.key = &f->mkey;
>  	cls_flower.classid = f->res.classid;
>  
> +	/* Pass unmasked key and corresponding dissector also to the driver,
> +	 * hardware may optimize its flow table based on its capabilities.
> +	 */
> +	cls_flower.rule->match.unmasked_key = &f->key;
> +	cls_flower.rule->match.unmasked_key_dissector =
> +						&f->unmasked_key_dissector;
> +
>  	err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts);
>  	if (err) {
>  		kfree(cls_flower.rule);
> @@ -1753,6 +1761,39 @@ static void fl_init_dissector(struct flow_dissector *dissector,
>  	skb_flow_dissector_init(dissector, keys, cnt);
>  }
>  
> +/* Initialize dissector for unmasked key. */
> +static void fl_init_unmasked_key_dissector(struct flow_dissector *dissector)
> +{
> +	struct flow_dissector_key keys[FLOW_DISSECTOR_KEY_MAX];
> +	size_t cnt = 0;
> +
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_META, meta);
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_CONTROL, control);
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_BASIC, basic);
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_ETH_ADDRS, eth);
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4);
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6);
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_PORTS, tp);
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_PORTS_RANGE, tp_range);
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_IP, ip);
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_TCP, tcp);
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_ICMP, icmp);
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_ARP, arp);
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_MPLS, mpls);
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_VLAN, vlan);
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_CVLAN, cvlan);
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_ENC_KEYID, enc_key_id);
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS, enc_ipv4);
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS, enc_ipv6);
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_ENC_CONTROL, enc_control);
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_ENC_PORTS, enc_tp);
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_ENC_IP, enc_ip);
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_ENC_OPTS, enc_opts);
> +	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_CT, ct);
> +
> +	skb_flow_dissector_init(dissector, keys, cnt);
> +}
> +
>  static struct fl_flow_mask *fl_create_new_mask(struct cls_fl_head *head,
>  					       struct fl_flow_mask *mask)
>  {
> @@ -1980,6 +2021,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
>  	if (err)
>  		goto errout;
>  
> +	fl_init_unmasked_key_dissector(&fnew->unmasked_key_dissector);
> +
>  	err = fl_ht_insert_unique(fnew, fold, &in_ht);
>  	if (err)
>  		goto errout_mask;
> -- 
> 2.17.1
> 
