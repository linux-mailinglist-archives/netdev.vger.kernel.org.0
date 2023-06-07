Return-Path: <netdev+bounces-8716-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10715725520
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 09:12:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD34D2811A2
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 07:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD8F463D7;
	Wed,  7 Jun 2023 07:12:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C261A17DB
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:12:35 +0000 (UTC)
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BB9E62
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 00:12:34 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.west.internal (Postfix) with ESMTP id E96F432004AE;
	Wed,  7 Jun 2023 03:12:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 07 Jun 2023 03:12:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1686121950; x=1686208350; bh=uNCJyJiCZjUM1
	q3KpH0kCrz18eRq5AMD/8VkfLCyD5I=; b=S423v0LQUV/BAbVUyEV7RWe7teM9D
	wbWEE95icte5EXtTLjw66+IL/3ZdzWCirSbtS4d7WKZT+jFrO4opAKOgQ+ITRFZv
	CrMrJJsd3PSZ+8Ffa/tb+JTTO547CoMISirfJeloUB+kS9MsTQWz0W5IYw0/VwYV
	KqFU9vZ975srHrJ550Zrn4scwoGFHnG1FBv2p5bOI6rz5bJseg+sQadLK04oVicE
	Mhwb7DrVt/seFiLlEC3bKA/DTLbMNFPW/JjpM1fBD1C3E6P5jR1agPhf/tixFKVy
	HUjt0S6PRo2BZpb9uQc7wl4rByaa2Bsr+ZjDnIb7kgyTWn4UuHxDOTQ3w==
X-ME-Sender: <xms:3i2AZOssVZ9tZtfel0Vcu5g7oG2ebFfodKR3SGVjLnKgh6WlEfQ4Ng>
    <xme:3i2AZDdeOdgMyz3achzUcdS7yM5Mm4d2oCxwo9RJ1-KbO8FCYwq_KO9Cko0MbTF28
    WWBVHpalIBa7_c>
X-ME-Received: <xmr:3i2AZJzfJh_cxC4oIeEdfPfPD-mWx6Jyr7TECE-oEQBntwxNb3FUPqXznFxQLaH6ojanE9hjJTVQTgdxIFXND-7u_eQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedtfedgjeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:3i2AZJPJJuFzjDjhBHClvVWK8i99Oo5pAcB6IwAsmcWDkOiUwpxjQA>
    <xmx:3i2AZO-pZUD_ZIdpE3NjUgyGDc6rDS8uX37JmcDjYVBO6anRCgK1zA>
    <xmx:3i2AZBWxMC0QQMgHcRCP4M8ae7v9RIvhIWZH37Bj2ubpHWueHrAzdg>
    <xmx:3i2AZP2V1lUugTDQlpKjRI_slh7bipI5tRgzgCXQEUNHq34HF3eiHQ>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Jun 2023 03:12:29 -0400 (EDT)
Date: Wed, 7 Jun 2023 10:12:26 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Zahari Doychev <zahari.doychev@linux.com>
Cc: netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
	jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
	aleksander.lobakin@intel.com, simon.horman@corigine.com,
	Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v6 2/3] net: flower: add support for matching
 cfm fields
Message-ID: <ZIAt2gCBOBn8sfOj@shredder>
References: <20230606205935.570850-1-zahari.doychev@linux.com>
 <20230606205935.570850-3-zahari.doychev@linux.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606205935.570850-3-zahari.doychev@linux.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 10:59:34PM +0200, Zahari Doychev wrote:
> From: Zahari Doychev <zdoychev@maxlinear.com>
> 
> Add support to the tc flower classifier to match based on fields in CFM
> information elements like level and opcode.
> 
> tc filter add dev ens6 ingress protocol 802.1q \
> 	flower vlan_id 698 vlan_ethtype 0x8902 cfm mdl 5 op 46 \
> 	action drop

Looks good overall. One minor comment below.

[...]

> +static int fl_set_key_cfm_md_level(struct nlattr **tb,
> +				   struct fl_flow_key *key,
> +				   struct fl_flow_key *mask,
> +				   struct netlink_ext_ack *extack)
> +{
> +	u8 level;
> +
> +	if (!tb[TCA_FLOWER_KEY_CFM_MD_LEVEL])
> +		return 0;
> +
> +	level = nla_get_u8(tb[TCA_FLOWER_KEY_CFM_MD_LEVEL]);
> +	key->cfm.mdl_ver = FIELD_PREP(FLOW_DIS_CFM_MDL_MASK, level);
> +	mask->cfm.mdl_ver = FLOW_DIS_CFM_MDL_MASK;
> +
> +	return 0;
> +}

This function always returns '0' so it can be changed to return 'void'
instead of 'int' like fl_set_key_cfm_opcode().

> +
> +static void fl_set_key_cfm_opcode(struct nlattr **tb,
> +				  struct fl_flow_key *key,
> +				  struct fl_flow_key *mask,
> +				  struct netlink_ext_ack *extack)
> +{
> +	fl_set_key_val(tb, &key->cfm.opcode, TCA_FLOWER_KEY_CFM_OPCODE,
> +		       &mask->cfm.opcode, TCA_FLOWER_UNSPEC,
> +		       sizeof(key->cfm.opcode));
> +}
> +
> +static int fl_set_key_cfm(struct nlattr **tb,
> +			  struct fl_flow_key *key,
> +			  struct fl_flow_key *mask,
> +			  struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *nla_cfm_opt[TCA_FLOWER_KEY_CFM_OPT_MAX];
> +	int err;
> +
> +	if (!tb[TCA_FLOWER_KEY_CFM])
> +		return 0;
> +
> +	err = nla_parse_nested(nla_cfm_opt, TCA_FLOWER_KEY_CFM_OPT_MAX,
> +			       tb[TCA_FLOWER_KEY_CFM], cfm_opt_policy, extack);
> +	if (err < 0)
> +		return err;
> +
> +	fl_set_key_cfm_opcode(nla_cfm_opt, key, mask, extack);
> +
> +	return fl_set_key_cfm_md_level(nla_cfm_opt, key, mask, extack);

And here simply do 'return 0;'.

> +}

