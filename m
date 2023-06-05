Return-Path: <netdev+bounces-7890-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D98D721FAD
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:36:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAE042811DE
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F64E111A1;
	Mon,  5 Jun 2023 07:36:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349FCAD42
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:36:31 +0000 (UTC)
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B345ACA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 00:36:29 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.west.internal (Postfix) with ESMTP id 5B40532004CE;
	Mon,  5 Jun 2023 03:36:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 05 Jun 2023 03:36:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1685950587; x=1686036987; bh=GmwxWQPNop4NK
	+yFMcaVgbmsRvzE2tNJthnP6wRUOtk=; b=R63L97b7Jj7PeBSiCwXUO1v4sUIa+
	u21GYBUZvfybRaXaCisB3RZd7Ui1L2FK95OAHdr0vYD2GRiPIod4ph4mcv13JKrn
	wSuEw5/pNHS0/hryKwc2Ki2akuWQW7gJrOBSis2APL4J+vO/UTjiTFaXo4SU6+oK
	+8JlEGZVGae7ODO9v9diR9oGcH2yZJwvvdH8KaJK3srHPEvmr1hbOZ4592R0O22I
	UY2lMsFsYaKXLKFYZ6bN6MHColJwnAON6NiBLFbGueWp40SnpJlIDeyLcnnRtaie
	rQ8x/6IKuZbL6ofiouNG08Kzn3v4Gwu1QDh2kmVSb90ziUZdCo6TAPkxA==
X-ME-Sender: <xms:e5B9ZALfsmzAjSktRSlK993yz42vlgsiv97Q5a-ENZbmVeAMoNeuiw>
    <xme:e5B9ZALcUpb5w3_aHt64YMOBqBhkPVYEVtZ9_TP7YoDRb9ZVQ9DNJjTBJ4uiGBlOz
    yB0BrR6UvDpBpg>
X-ME-Received: <xmr:e5B9ZAvRKfiO5osrg6ndy2v_HOG5IdJ2ACbwX2Znf3wDuDrxXi8Xc_e618NU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeelkedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeej
    geeghfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:e5B9ZNZPpcC4vW7ynzm3hYpYAEkpxxOqFeGoFpA9Aef9TWGUDfHvBQ>
    <xmx:e5B9ZHYGqfXTq714tsxHJyJ6shbqbXRGoCrBN1qJmQN-oCJdIf2kyA>
    <xmx:e5B9ZJBgdD4dv-TzVGWNriA09jsaGKsAYjLRxhUysXah8jt09NtDVw>
    <xmx:e5B9ZEQi1m8_V405nXss6NmflMgaDG4hT31tF7pieo77ivNqXbRqyQ>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Jun 2023 03:36:26 -0400 (EDT)
Date: Mon, 5 Jun 2023 10:36:23 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Zahari Doychev <zahari.doychev@linux.com>
Cc: netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
	jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
	aleksander.lobakin@intel.com, simon.horman@corigine.com,
	Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v5 2/3] net: flower: add support for matching
 cfm fields
Message-ID: <ZH2Qd0UwIUTPBSWc@shredder>
References: <20230604115825.2739031-1-zahari.doychev@linux.com>
 <20230604115825.2739031-3-zahari.doychev@linux.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230604115825.2739031-3-zahari.doychev@linux.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 01:58:24PM +0200, Zahari Doychev wrote:
> From: Zahari Doychev <zdoychev@maxlinear.com>
> 
> Add support to the tc flower classifier to match based on fields in CFM
> information elements like level and opcode.
> 
> tc filter add dev ens6 ingress protocol 802.1q \
> 	flower vlan_id 698 vlan_ethtype 0x8902 cfm mdl 5 op 46 \
> 	action drop
> 
> Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> ---
>  include/uapi/linux/pkt_cls.h |   9 ++
>  net/sched/cls_flower.c       | 195 ++++++++++++++++++++++++++---------
>  2 files changed, 158 insertions(+), 46 deletions(-)
> 
> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> index 00933dda7b10..7865f5a9885b 100644
> --- a/include/uapi/linux/pkt_cls.h
> +++ b/include/uapi/linux/pkt_cls.h
> @@ -596,6 +596,8 @@ enum {
>  
>  	TCA_FLOWER_L2_MISS,		/* u8 */
>  
> +	TCA_FLOWER_KEY_CFM,		/* nested */
> +
>  	__TCA_FLOWER_MAX,
>  };
>  
> @@ -704,6 +706,13 @@ enum {
>  	TCA_FLOWER_KEY_FLAGS_FRAG_IS_FIRST = (1 << 1),
>  };
>  
> +enum {
> +	TCA_FLOWER_KEY_CFM_OPT_UNSPEC,
> +	TCA_FLOWER_KEY_CFM_MD_LEVEL,
> +	TCA_FLOWER_KEY_CFM_OPCODE,
> +	TCA_FLOWER_KEY_CFM_OPT_MAX,
> +};
> +
>  #define TCA_FLOWER_MASK_FLAGS_RANGE	(1 << 0) /* Range-based match */
>  
>  /* Match-all classifier */
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index e02ecabbb75c..b32f5423721b 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -11,6 +11,7 @@
>  #include <linux/rhashtable.h>
>  #include <linux/workqueue.h>
>  #include <linux/refcount.h>
> +#include <linux/bitfield.h>
>  
>  #include <linux/if_ether.h>
>  #include <linux/in6.h>
> @@ -71,6 +72,7 @@ struct fl_flow_key {
>  	struct flow_dissector_key_num_of_vlans num_of_vlans;
>  	struct flow_dissector_key_pppoe pppoe;
>  	struct flow_dissector_key_l2tpv3 l2tpv3;
> +	struct flow_dissector_key_cfm cfm;
>  } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
>  
>  struct fl_flow_mask_range {
> @@ -617,6 +619,58 @@ static void *fl_get(struct tcf_proto *tp, u32 handle)
>  	return __fl_get(head, handle);
>  }
>  
> +static const struct nla_policy
> +enc_opts_policy[TCA_FLOWER_KEY_ENC_OPTS_MAX + 1] = {
> +	[TCA_FLOWER_KEY_ENC_OPTS_UNSPEC]        = {
> +		.strict_start_type = TCA_FLOWER_KEY_ENC_OPTS_VXLAN },
> +	[TCA_FLOWER_KEY_ENC_OPTS_GENEVE]        = { .type = NLA_NESTED },
> +	[TCA_FLOWER_KEY_ENC_OPTS_VXLAN]         = { .type = NLA_NESTED },
> +	[TCA_FLOWER_KEY_ENC_OPTS_ERSPAN]        = { .type = NLA_NESTED },
> +	[TCA_FLOWER_KEY_ENC_OPTS_GTP]		= { .type = NLA_NESTED },
> +};
> +
> +static const struct nla_policy
> +geneve_opt_policy[TCA_FLOWER_KEY_ENC_OPT_GENEVE_MAX + 1] = {
> +	[TCA_FLOWER_KEY_ENC_OPT_GENEVE_CLASS]      = { .type = NLA_U16 },
> +	[TCA_FLOWER_KEY_ENC_OPT_GENEVE_TYPE]       = { .type = NLA_U8 },
> +	[TCA_FLOWER_KEY_ENC_OPT_GENEVE_DATA]       = { .type = NLA_BINARY,
> +						       .len = 128 },
> +};
> +
> +static const struct nla_policy
> +vxlan_opt_policy[TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX + 1] = {
> +	[TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP]         = { .type = NLA_U32 },
> +};
> +
> +static const struct nla_policy
> +erspan_opt_policy[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX + 1] = {
> +	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_VER]        = { .type = NLA_U8 },
> +	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX]      = { .type = NLA_U32 },
> +	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_DIR]        = { .type = NLA_U8 },
> +	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID]       = { .type = NLA_U8 },
> +};
> +
> +static const struct nla_policy
> +gtp_opt_policy[TCA_FLOWER_KEY_ENC_OPT_GTP_MAX + 1] = {
> +	[TCA_FLOWER_KEY_ENC_OPT_GTP_PDU_TYPE]	   = { .type = NLA_U8 },
> +	[TCA_FLOWER_KEY_ENC_OPT_GTP_QFI]	   = { .type = NLA_U8 },
> +};
> +
> +static const struct nla_policy
> +mpls_stack_entry_policy[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1] = {
> +	[TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH]    = { .type = NLA_U8 },
> +	[TCA_FLOWER_KEY_MPLS_OPT_LSE_TTL]      = { .type = NLA_U8 },
> +	[TCA_FLOWER_KEY_MPLS_OPT_LSE_BOS]      = { .type = NLA_U8 },
> +	[TCA_FLOWER_KEY_MPLS_OPT_LSE_TC]       = { .type = NLA_U8 },
> +	[TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL]    = { .type = NLA_U32 },
> +};
> +
> +static const struct nla_policy cfm_opt_policy[TCA_FLOWER_KEY_CFM_OPT_MAX] = {
> +	[TCA_FLOWER_KEY_CFM_MD_LEVEL]	= NLA_POLICY_MAX(NLA_U8,
> +						FLOW_DIS_CFM_MDL_MAX),
> +	[TCA_FLOWER_KEY_CFM_OPCODE]	= { .type = NLA_U8 },
> +};
> +
>  static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
>  	[TCA_FLOWER_UNSPEC]		= { .strict_start_type =
>  						TCA_FLOWER_L2_MISS },
> @@ -725,52 +779,7 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
>  	[TCA_FLOWER_KEY_PPP_PROTO]	= { .type = NLA_U16 },
>  	[TCA_FLOWER_KEY_L2TPV3_SID]	= { .type = NLA_U32 },
>  	[TCA_FLOWER_L2_MISS]		= NLA_POLICY_MAX(NLA_U8, 1),
> -};
> -
> -static const struct nla_policy
> -enc_opts_policy[TCA_FLOWER_KEY_ENC_OPTS_MAX + 1] = {
> -	[TCA_FLOWER_KEY_ENC_OPTS_UNSPEC]        = {
> -		.strict_start_type = TCA_FLOWER_KEY_ENC_OPTS_VXLAN },
> -	[TCA_FLOWER_KEY_ENC_OPTS_GENEVE]        = { .type = NLA_NESTED },
> -	[TCA_FLOWER_KEY_ENC_OPTS_VXLAN]         = { .type = NLA_NESTED },
> -	[TCA_FLOWER_KEY_ENC_OPTS_ERSPAN]        = { .type = NLA_NESTED },
> -	[TCA_FLOWER_KEY_ENC_OPTS_GTP]		= { .type = NLA_NESTED },
> -};
> -
> -static const struct nla_policy
> -geneve_opt_policy[TCA_FLOWER_KEY_ENC_OPT_GENEVE_MAX + 1] = {
> -	[TCA_FLOWER_KEY_ENC_OPT_GENEVE_CLASS]      = { .type = NLA_U16 },
> -	[TCA_FLOWER_KEY_ENC_OPT_GENEVE_TYPE]       = { .type = NLA_U8 },
> -	[TCA_FLOWER_KEY_ENC_OPT_GENEVE_DATA]       = { .type = NLA_BINARY,
> -						       .len = 128 },
> -};
> -
> -static const struct nla_policy
> -vxlan_opt_policy[TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX + 1] = {
> -	[TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP]         = { .type = NLA_U32 },
> -};
> -
> -static const struct nla_policy
> -erspan_opt_policy[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX + 1] = {
> -	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_VER]        = { .type = NLA_U8 },
> -	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX]      = { .type = NLA_U32 },
> -	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_DIR]        = { .type = NLA_U8 },
> -	[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID]       = { .type = NLA_U8 },
> -};
> -
> -static const struct nla_policy
> -gtp_opt_policy[TCA_FLOWER_KEY_ENC_OPT_GTP_MAX + 1] = {
> -	[TCA_FLOWER_KEY_ENC_OPT_GTP_PDU_TYPE]	   = { .type = NLA_U8 },
> -	[TCA_FLOWER_KEY_ENC_OPT_GTP_QFI]	   = { .type = NLA_U8 },
> -};
> -
> -static const struct nla_policy
> -mpls_stack_entry_policy[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1] = {
> -	[TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH]    = { .type = NLA_U8 },
> -	[TCA_FLOWER_KEY_MPLS_OPT_LSE_TTL]      = { .type = NLA_U8 },
> -	[TCA_FLOWER_KEY_MPLS_OPT_LSE_BOS]      = { .type = NLA_U8 },
> -	[TCA_FLOWER_KEY_MPLS_OPT_LSE_TC]       = { .type = NLA_U8 },
> -	[TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL]    = { .type = NLA_U32 },
> +	[TCA_FLOWER_KEY_CFM]		= NLA_POLICY_NESTED(cfm_opt_policy),

I didn't suggest NLA_POLICY_NESTED() in previous versions because:

1. The code churn in this patch where different policies need to be
relocated.

2. AFAIK, rtnetlink does not support policy dump (unlike genl) which
makes this change quite meaningless.

No strong preference whether to keep it or drop it, but the purely
mechanical change of relocating policies need to be split into a patch
of its own.

And I'm sorry about the conflict with the "TCA_FLOWER_L2_MISS" stuff. I
assumed you would send v5 earlier.

>  };

