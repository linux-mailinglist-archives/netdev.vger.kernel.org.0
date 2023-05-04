Return-Path: <netdev+bounces-281-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1C946F6C90
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 15:05:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C9EC280D4B
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 13:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDFBDFBF9;
	Thu,  4 May 2023 13:05:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD127E
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 13:05:20 +0000 (UTC)
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170A56A7D;
	Thu,  4 May 2023 06:05:19 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id E00B95C0081;
	Thu,  4 May 2023 09:05:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 04 May 2023 09:05:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1683205515; x=1683291915; bh=b5t4Lj5P4gNB4
	TdYYetVeWaz/HM1eEfQ5Gqh5JYxkgg=; b=UyVc/GFn6tty0rCNpLX8UBJEaD32h
	eEOlPsE1VjenHec7fsfbvP0pRDvFFs5yDAzT6j0BbcX41meVHj9sP8hgREsTMFXQ
	fBDQ0Ie9c0cf7wz4e4Pv0Soi3bwH/ktOTdd8r/HZJzApHAmEhSS6UzvyXZUyIuY9
	YtEdrZ7sGU0qPuaAVGUYgiFFtKHz+1pPuwFw9pvUdrLs0gAYB6or1X7PW+RGQ+mW
	Bgme2L5jTHcbk+MmKfyjJioutaDrrbLMQKPnKVn6SveHTbyl2lwvo2QMCNcNag/1
	vX53M6h/AF42c1ksw9+F6W/hhakUOzgZFYv/m+NDsQWQy+Swb2jZ46frw==
X-ME-Sender: <xms:iq1TZOa92aeGWtQL8O9OlHc-KvfDaCqLsN0PK8Lm6fNqxi7_s0km2Q>
    <xme:iq1TZBabUOTM_DlfHXsEXSH3tyrRzRdZUQJO-S93T4yxfRt9J3RIEsspATzKTKdaz
    dcxQkaZdiwrLGQ>
X-ME-Received: <xmr:iq1TZI8kUKXB8SmEK0AStwLXzAOBqmkpc91pmhHwChQSghrx-gXYqlVJWsGAzVSdbiIoXssbw8Yr_JR4kFIqE3stmBM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeftddgheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:i61TZAp3r16Ml-TG92stYkCWk7JInSvVaKVGy5uR7Z4DO9Evq2JJvg>
    <xmx:i61TZJpvJJv7DKIHfKFQIRZDB4gU0i6N1-f-LFkicDgbdApIzVS4ow>
    <xmx:i61TZOR8prljr5Yv17cUuOWjZYtwOurvXyeZoYVPkU-GeJt5EigdEA>
    <xmx:i61TZHhx7JXZruPQw1uK3d5uyWl5dQiTqkxoi5wkloezTmzZipI3Pg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 4 May 2023 09:05:13 -0400 (EDT)
Date: Thu, 4 May 2023 16:05:10 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
	razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
	eyal.birger@gmail.com, jtoppins@redhat.com, shuah@kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v7 1/2] Add nolocalbypass option to vxlan.
Message-ID: <ZFOthnnqvElorCM8@shredder>
References: <20230501162530.26414-1-vladimir@nikishkin.pw>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230501162530.26414-1-vladimir@nikishkin.pw>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 02, 2023 at 12:25:29AM +0800, Vladimir Nikishkin wrote:
> diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
> index 561fe1b314f5..ede98b879257 100644
> --- a/drivers/net/vxlan/vxlan_core.c
> +++ b/drivers/net/vxlan/vxlan_core.c
> @@ -2355,11 +2355,13 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
>  	    !(rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))) {
>  		struct vxlan_dev *dst_vxlan;
>  
> -		dst_release(dst);
>  		dst_vxlan = vxlan_find_vni(vxlan->net, dst_ifindex, vni,
>  					   daddr->sa.sa_family, dst_port,
>  					   vxlan->cfg.flags);
>  		if (!dst_vxlan) {
> +			if (!(vxlan->cfg.flags & VXLAN_F_LOCALBYPASS))
> +				return 0;
> +			dst_release(dst);

Thinking about it again, now that we have a new flag to signal the
desired behavior, why do we care if there is a local VXLAN device
listening or not? If 'VXLAN_F_LOCALBYPASS' is not set we don't want to
deliver the packet to a local VXLAN device even if one exists.

IOW, can't the diff simply be:

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 561fe1b314f5..1a1dfe6be92d 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2352,7 +2352,8 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
 #endif
        /* Bypass encapsulation if the destination is local */
        if (rt_flags & RTCF_LOCAL &&
-           !(rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))) {
+           !(rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST)) &&
+           vxlan->cfg.flags & VXLAN_F_LOCALBYPASS) {
                struct vxlan_dev *dst_vxlan;
 
                dst_release(dst);

?

>  			dev->stats.tx_errors++;
>  			vxlan_vnifilter_count(vxlan, vni, NULL,
>  					      VXLAN_VNI_STATS_TX_ERRORS, 0);
> @@ -2367,6 +2369,7 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
>  
>  			return -ENOENT;
>  		}
> +		dst_release(dst);
>  		vxlan_encap_bypass(skb, vxlan, dst_vxlan, vni, true);
>  		return 1;
>  	}
> @@ -2568,7 +2571,6 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
>  
>  		if (!info) {
>  			u32 rt6i_flags = ((struct rt6_info *)ndst)->rt6i_flags;
> -

Unnecessary change. Please remove. Probably a leftover from previous
versions

>  			err = encap_bypass_if_local(skb, dev, vxlan, dst,
>  						    dst_port, ifindex, vni,
>  						    ndst, rt6i_flags);

> @@ -3172,6 +3174,7 @@ static void vxlan_raw_setup(struct net_device *dev)
>  }
>  
>  static const struct nla_policy vxlan_policy[IFLA_VXLAN_MAX + 1] = {
> +	[IFLA_VXLAN_UNSPEC]     = { .strict_start_type = IFLA_VXLAN_LOCALBYPASS },
>  	[IFLA_VXLAN_ID]		= { .type = NLA_U32 },
>  	[IFLA_VXLAN_GROUP]	= { .len = sizeof_field(struct iphdr, daddr) },
>  	[IFLA_VXLAN_GROUP6]	= { .len = sizeof(struct in6_addr) },
> @@ -3202,6 +3205,7 @@ static const struct nla_policy vxlan_policy[IFLA_VXLAN_MAX + 1] = {
>  	[IFLA_VXLAN_TTL_INHERIT]	= { .type = NLA_FLAG },
>  	[IFLA_VXLAN_DF]		= { .type = NLA_U8 },
>  	[IFLA_VXLAN_VNIFILTER]	= { .type = NLA_U8 },
> +	[IFLA_VXLAN_LOCALBYPASS]	= NLA_POLICY_MAX(NLA_U8, 1),
>  };

The rest looks fine to me

