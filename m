Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEDF16E7E23
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbjDSPXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232396AbjDSPXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:23:18 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB7B2133
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:22:43 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B66FA5C011B;
        Wed, 19 Apr 2023 11:21:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 19 Apr 2023 11:21:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1681917662; x=1682004062; bh=aBEEnjTsnlxt0
        N7TjIKvsUlR/6qEU2BqnWGB0AhW/7E=; b=fohj7c0GVtKl4XANj0A+X1dBS9DQK
        Hllrrw3spI4ZDS6y5F7h0RFy0ft3d3eJk0fjfDEAcdP6sJDU2na/GCfxoysjCuMj
        M7IEdCrbxO/z+bGgvJSGTXCpR+XzXZNrTyG55sIt5psWVRQ65Uag0HXtV62BstTx
        PXSracAArdp/3ihJgqquF83nfg3pgQyptizC+asoplqOzdwD8Al9ynCQqCJ+Sws6
        ioiZZ6qy9BC1Z0zhrgDbmP00D8rCJsrfUvBrHv5+jqlDQ9kHwvJty3Vwyqv700be
        zZELFNTMxSFV5kybcPR+Ije8p4EqNRR4C43vkQ21iAeXN+Mi3QPcffnwA==
X-ME-Sender: <xms:3gZAZH2Bk13vHWS5W1VBm_ZJLJ5BZQU8S4ZUL0qr0qg2YAWn7FY9Yg>
    <xme:3gZAZGGMVmtZe5IeTI9TeSfpwXLz3KA-NTgqYxbrm8fmeENX7kPrgTcThNOb2vJtD
    tXqSCPKpqVadx4>
X-ME-Received: <xmr:3gZAZH5DxfQmpdHJVaCBbG-Ki13rgqxU95lBWDcIY5gqamFPRE2Zk4IeIxm4_GUfoVGJbTLj3e51zvQCaTDqpCm5nPc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedttddgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:3gZAZM1crDO1gT3Lys5TomiuyD5A4Z4PCYOQ4Ml9ElFaN-hAm9HTjQ>
    <xmx:3gZAZKF1A2s3dgzXmD3_KH_Cae3eJ7XG-a97UyUGhaYc0w2aeCchaQ>
    <xmx:3gZAZN9XejtESFgPgrR4F09E9uQV47fYniVRPHqVTAmsXjeyeKvgjQ>
    <xmx:3gZAZC-yJnDiPjAFiO8WLd9qGtEwEkO_jSTB54TK5t3BSzpFbX3Q2A>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 19 Apr 2023 11:21:01 -0400 (EDT)
Date:   Wed, 19 Apr 2023 18:20:57 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Zahari Doychev <zahari.doychev@linux.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com, simon.horman@corigine.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v3 2/3] net: flower: add support for matching
 cfm fields
Message-ID: <ZEAG2aW78qbGHj//@shredder>
References: <20230417213233.525380-1-zahari.doychev@linux.com>
 <20230417213233.525380-3-zahari.doychev@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417213233.525380-3-zahari.doychev@linux.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 11:32:32PM +0200, Zahari Doychev wrote:
> +static const struct nla_policy cfm_opt_policy[TCA_FLOWER_KEY_CFM_OPT_MAX] = {
> +	[TCA_FLOWER_KEY_CFM_MD_LEVEL]		= { .type = NLA_U8 },
> +	[TCA_FLOWER_KEY_CFM_OPCODE]		= { .type = NLA_U8 },
> +};

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
> +	if (level & ~FIELD_MAX(FLOW_DIS_CFM_MDL_MASK)) {
> +		NL_SET_ERR_MSG_ATTR(extack, tb[TCA_FLOWER_KEY_CFM_MD_LEVEL],
> +				    "cfm md level must be in [0, 7]");
> +		return -EINVAL;
> +	}

You should be able to replace this with NLA_POLICY_MAX()

> +
> +	key->cfm.mdl_ver = FIELD_PREP(FLOW_DIS_CFM_MDL_MASK, level);
> +	mask->cfm.mdl_ver = FLOW_DIS_CFM_MDL_MASK;
> +
> +	return 0;
> +}
