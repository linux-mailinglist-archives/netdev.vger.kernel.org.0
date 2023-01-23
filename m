Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF79677DD0
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 15:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbjAWOU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 09:20:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjAWOU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 09:20:28 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1832A18B29
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 06:20:28 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id DE9E6320093B;
        Mon, 23 Jan 2023 09:20:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 23 Jan 2023 09:20:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1674483626; x=1674570026; bh=A2he74zsU0VQVsh5NOaPldZgAjYp
        pdUvm5v0H9GxMaQ=; b=p5v1hD62stgiijSHAXjH2Sodn5k6gkTlJtkryti4hfP2
        hA03yxJVSgwd3UZC40YPvD3PyBPzrTqgJ8sL80yUlUFTrEY8zQETqa+fNZQ2v0wF
        z91eStDSvSDORiZHJGPHDU0RqvE213OoG1dif2Q5cm/Jrp8PJ19RMNnPV2KbzMKp
        8B4ze1OdZnnWsNwhkisQZShVXWic9ciQY6fgpP2zYSvVlxS75ZIPFriw2o4fhZNR
        HpYQWzAhGvj6As8TlQ6O3WiibjtMD/KXZJ/ti6/ztWkwyJWqdBPQdLVpsLT6WX9E
        ruXtTCvg/RBXGn0RPCnvWUyvSkHwNoO04RhezGrAtA==
X-ME-Sender: <xms:qpfOY5zdyZvCF9-L8pB3mknyJGf6gk2z4rcD326QO7MzlfNXDh9j4A>
    <xme:qpfOY5Sf042Csz-1j1P23C2kwwZ_TCkbLbjoyLygxNGRDC15eF_vdzVRjZsj-smJz
    F5trrF0vugCnS0>
X-ME-Received: <xmr:qpfOYzVCSvBLoaq2zuyf3BnQotHF19KwMjEzCvb2AXNeqMEsvDAOA1_S0u1u>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddukedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:qpfOY7g62Up5ZGFdlqZwR9n2a9al53SgPVheez2L__5tblTx4uobYA>
    <xmx:qpfOY7AUI_ebDi4QJ3hiRXzWObYj8zdcrxcMJ1rZIhbnmMVlC4kp_w>
    <xmx:qpfOY0KLrPFfyaqBA8NO8QH-XKq1FT0AgH8jKi6yfn_LsbjGu5jn-Q>
    <xmx:qpfOY24uIeUnFms3xs_Se4e1v4I_ZQ7UgPluJ8UTHqpCrRR-wjpOQw>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 Jan 2023 09:20:25 -0500 (EST)
Date:   Mon, 23 Jan 2023 16:20:21 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, jiri@resnulli.us,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v2 05/15] netlink: add macro for checking dump
 ctx size
Message-ID: <Y86XpbLnEpiNZzTL@shredder>
References: <20230105040531.353563-1-kuba@kernel.org>
 <20230105040531.353563-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105040531.353563-6-kuba@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 08:05:21PM -0800, Jakub Kicinski wrote:
> We encourage casting struct netlink_callback::ctx to a local
> struct (in a comment above the field). Provide a convenience
> macro for checking if the local struct fits into the ctx.
> 
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/linux/netlink.h              | 4 ++++
>  net/netfilter/nf_conntrack_netlink.c | 2 +-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/netlink.h b/include/linux/netlink.h
> index d81bde5a5844..38f6334f408c 100644
> --- a/include/linux/netlink.h
> +++ b/include/linux/netlink.h
> @@ -263,6 +263,10 @@ struct netlink_callback {
>  	};
>  };
>  
> +#define NL_ASSET_DUMP_CTX_FITS(type_name)				\

Wanted to use this macro, but the name doesn't make sense to me. Should
it be NL_ASSERT_DUMP_CTX_FITS() ?

> +	BUILD_BUG_ON(sizeof(type_name) >				\
> +		     sizeof_field(struct netlink_callback, ctx))
> +
>  struct netlink_notify {
>  	struct net *net;
>  	u32 portid;
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 1286ae7d4609..90672e293e57 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -3866,7 +3866,7 @@ static int __init ctnetlink_init(void)
>  {
>  	int ret;
>  
> -	BUILD_BUG_ON(sizeof(struct ctnetlink_list_dump_ctx) > sizeof_field(struct netlink_callback, ctx));
> +	NL_ASSET_DUMP_CTX_FITS(struct ctnetlink_list_dump_ctx);
>  
>  	ret = nfnetlink_subsys_register(&ctnl_subsys);
>  	if (ret < 0) {
> -- 
> 2.38.1
> 
