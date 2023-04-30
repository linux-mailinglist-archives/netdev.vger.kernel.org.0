Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D866F2951
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 16:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjD3OuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 10:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjD3OuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 10:50:04 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50393173E
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 07:50:02 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id B189A5C0040;
        Sun, 30 Apr 2023 10:50:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 30 Apr 2023 10:50:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682866201; x=1682952601; bh=fAKAjWlXuxK4k
        fzntySUeuV0bQWXeB7KZQC7kXQQwQk=; b=exDP0nvPKTDHGzMY7eJgf1Y7PKE7j
        IsUuSbXktrv5XnyKPfDA4OzvtSCNd5t0fVLZlFcaflJKCzh112yOQ4U+HJknFb8N
        /2Scx0Lauzu2GVW4S9YW0gNyqAvplGaqd6sHi9BJz7nmkXYvMWft7VO1J06Kq5Xs
        kPSP4ImH6h8RCb34RuZ6+h+ZAUxWNu1VNDEqSovLeowFQ8cGdiEghDS/r4FcQIH9
        2XfpFlXZw7ovQ2G6otcW8SgmrgjA4s+ykdxtx8WGDicWa4FiDwFwpX8JDITGU2Hx
        CEv0wi2hcNnZVdYhWvncw75RKnN+Grj1JOpI5hqAMvrMj98tBgzFxEUjA==
X-ME-Sender: <xms:GYBOZBPiwlc8bdlic2yqChPt6yDKIkhzmf7j4zzTj6AFvl3tidGMEw>
    <xme:GYBOZD9wkaB8qioKJ-how0Rr1bJ0M4hIfCRMs_70TNQxPgfcc1kUQxojFrnZom2In
    RmGJ4WN9s-mWR0>
X-ME-Received: <xmr:GYBOZAS9ORyrTilA5uJEAV8nXgQ8G3IpBi4bxjjPWZyAFo8Vei4RVdZ4kQvX>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedvvddgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:GYBOZNt--uBq1YIQXFvXpFWu7O2RDdz8fyp_D1MFFYYZODRgOIyVeg>
    <xmx:GYBOZJeJyPBiJq2AdsmgZWcbvrxlfOHFWboFBkptlt2FNc7_6cr5pg>
    <xmx:GYBOZJ3bGvv0uzDZNWtdvMwsv3eCux8bSXKkwmc_WtEs-CptgAT13g>
    <xmx:GYBOZKWv0DzgWnACz3NFmKtEdK_lQl2XUzb9iKtPzGh0dkKr_gEV9g>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 30 Apr 2023 10:50:00 -0400 (EDT)
Date:   Sun, 30 Apr 2023 17:49:57 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Zahari Doychev <zahari.doychev@linux.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com, simon.horman@corigine.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v4 2/3] net: flower: add support for matching
 cfm fields
Message-ID: <ZE6AFQuv+yi7RxUL@shredder>
References: <20230425211630.698373-1-zahari.doychev@linux.com>
 <20230425211630.698373-3-zahari.doychev@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425211630.698373-3-zahari.doychev@linux.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 11:16:29PM +0200, Zahari Doychev wrote:
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index cc49256d5318..5d77da484a88 100644
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
> @@ -720,7 +722,7 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
>  	[TCA_FLOWER_KEY_PPPOE_SID]	= { .type = NLA_U16 },
>  	[TCA_FLOWER_KEY_PPP_PROTO]	= { .type = NLA_U16 },
>  	[TCA_FLOWER_KEY_L2TPV3_SID]	= { .type = NLA_U32 },
> -
> +	[TCA_FLOWER_KEY_CFM]		= { .type = NLA_NESTED },

"fl_policy" is used with nla_parse_nested_deprecated(). You can enable
strict validation for new attributes using the following diff:

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index fc9037685458..6bccfc1722ad 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -615,7 +615,8 @@ static void *fl_get(struct tcf_proto *tp, u32 handle)
 }
 
 static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
-       [TCA_FLOWER_UNSPEC]             = { .type = NLA_UNSPEC },
+       [TCA_FLOWER_UNSPEC]             = { .strict_start_type =
+                                               TCA_FLOWER_KEY_CFM },
        [TCA_FLOWER_CLASSID]            = { .type = NLA_U32 },
        [TCA_FLOWER_INDEV]              = { .type = NLA_STRING,
                                            .len = IFNAMSIZ },

>  };
>  
>  static const struct nla_policy
> @@ -769,6 +771,11 @@ mpls_stack_entry_policy[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1] = {
>  	[TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL]    = { .type = NLA_U32 },
>  };
>  
> +static const struct nla_policy cfm_opt_policy[TCA_FLOWER_KEY_CFM_OPT_MAX] = {
> +	[TCA_FLOWER_KEY_CFM_MD_LEVEL]	= NLA_POLICY_MAX(NLA_U8, 7),

Instead of 7, can you use FIELD_MAX(FLOW_DIS_CFM_MDL_MASK) like you did
in the previous version?

> +	[TCA_FLOWER_KEY_CFM_OPCODE]	= { .type = NLA_U8 },
> +};
