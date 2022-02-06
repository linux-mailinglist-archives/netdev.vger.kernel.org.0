Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E1A4AAF05
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 12:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbiBFLf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 06:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234155AbiBFLf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 06:35:57 -0500
X-Greylist: delayed 546 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 03:35:56 PST
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729BCC06173B;
        Sun,  6 Feb 2022 03:35:56 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 0B7473201D7C;
        Sun,  6 Feb 2022 06:26:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 06 Feb 2022 06:26:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=qciHEBrtufsFgTJmS
        CoqEjSJb7jQh8MaOov+ID8TdGg=; b=ExvBl4UuI0iIsGA2LIUN7nQvTTn602OQr
        pKKbiF+Vh5e4nhEmRQYsQmco/KY7CY9KFzW2Kq56aACJukwEu0RfzpQDwBFGVAE7
        ucPlSDSDPljQ34KWjXvV/2LReXcWINuo9VSpYji1WKxQcVo2l27wlZlKZisABUam
        Yv1g9wk9EZTbqg2371rmxOLUNr2sFj0hgEiENYUm9UnnYhGdCLJR8BxtDZ1uKzew
        gqe0jhtxqqv8K1GcVEBg2cdFGQo/ir/w49hsMTSP5RDDIINufifRbccQsI3sjpyE
        QaVLlKKGPrSr0HuXDxrlhaLF9bZHegesOA66USFjdd9rkDuGFSC1w==
X-ME-Sender: <xms:drD_YaZE7v5IzpdmMlU95T2ZYIh4-oXec4b2rnAWDM3K6yKKo2sk8g>
    <xme:drD_YdZ6HiIgy-dq4dgIqEYV4RCulxyW5w2ItNjn9zQX29yMmb-DZY5nhJb8pkzKf
    Tia7kfQjHCXHP4>
X-ME-Received: <xmr:drD_YU_p_rHXy4jk80eqbjDqv4X3BwQ9lTjLGHR8vp2SHoDk_zmfN2bEDnaJEmTrXW5ycddsHi_5CuD-ndyNJkNJr_EfUA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheefgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:d7D_Ycq83ap47MsxsSU8L67VpT-UvH6-qQ-Ed-gcDhwrcF1oLHCePw>
    <xmx:d7D_YVqigmrbgH39eRHYqU4P8DDIp7AeUN6W6fric6BGZc1mJbeoUQ>
    <xmx:d7D_YaSYWu-vXcbbY_-OAsyRGGNWi7Dp0xmMkthChEFROq98Wynk0g>
    <xmx:d7D_YWcfrp0ZAv7c_6Qkl9NcInvTP-UKQB4GAz_B0mVunoVzPpXM9Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 6 Feb 2022 06:26:46 -0500 (EST)
Date:   Sun, 6 Feb 2022 13:26:41 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     menglong8.dong@gmail.com
Cc:     kuba@kernel.org, dsahern@kernel.org, nhorman@tuxdriver.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        Menglong Dong <imagedong@tencent.com>
Subject: Re: [PATCH v6 net-next] net: drop_monitor: support drop reason
Message-ID: <Yf+wcVAAWzmSz93n@shredder>
References: <20220205081738.565394-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220205081738.565394-1-imagedong@tencent.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 05, 2022 at 04:17:38PM +0800, menglong8.dong@gmail.com wrote:
> diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
> index 7b288a121a41..1180f1a28599 100644
> --- a/net/core/drop_monitor.c
> +++ b/net/core/drop_monitor.c
> @@ -48,6 +48,16 @@
>  static int trace_state = TRACE_OFF;
>  static bool monitor_hw;
>  
> +#undef EM
> +#undef EMe
> +
> +#define EM(a, b)	[a] = #b,
> +#define EMe(a, b)	[a] = #b
> +
> +static const char *drop_reasons[SKB_DROP_REASON_MAX + 1] = {
> +	TRACE_SKB_DROP_REASON
> +};
> +
>  /* net_dm_mutex
>   *
>   * An overall lock guarding every operation coming from userspace.
> @@ -126,6 +136,7 @@ struct net_dm_skb_cb {
>  		struct devlink_trap_metadata *hw_metadata;
>  		void *pc;
>  	};
> +	enum skb_drop_reason reason;
>  };
>  
>  #define NET_DM_SKB_CB(__skb) ((struct net_dm_skb_cb *)&((__skb)->cb[0]))
> @@ -498,6 +509,7 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
>  {
>  	ktime_t tstamp = ktime_get_real();
>  	struct per_cpu_dm_data *data;
> +	struct net_dm_skb_cb *cb;
>  	struct sk_buff *nskb;
>  	unsigned long flags;
>  
> @@ -508,7 +520,9 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
>  	if (!nskb)
>  		return;
>  
> -	NET_DM_SKB_CB(nskb)->pc = location;
> +	cb = NET_DM_SKB_CB(nskb);
> +	cb->reason = reason;
> +	cb->pc = location;
>  	/* Override the timestamp because we care about the time when the
>  	 * packet was dropped.
>  	 */
> @@ -606,8 +620,9 @@ static int net_dm_packet_report_in_port_put(struct sk_buff *msg, int ifindex,
>  static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
>  				     size_t payload_len)
>  {
> -	u64 pc = (u64)(uintptr_t) NET_DM_SKB_CB(skb)->pc;
> +	struct net_dm_skb_cb *cb = NET_DM_SKB_CB(skb);
>  	char buf[NET_DM_MAX_SYMBOL_LEN];
> +	unsigned int reason;
>  	struct nlattr *attr;
>  	void *hdr;
>  	int rc;
> @@ -620,10 +635,16 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
>  	if (nla_put_u16(msg, NET_DM_ATTR_ORIGIN, NET_DM_ORIGIN_SW))
>  		goto nla_put_failure;
>  
> -	if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, pc, NET_DM_ATTR_PAD))
> +	if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, (u64)(uintptr_t)cb->pc,
> +			      NET_DM_ATTR_PAD))
> +		goto nla_put_failure;
> +
> +	reason = (unsigned int)cb->reason;
> +	if (reason < SKB_DROP_REASON_MAX &&
> +	    nla_put_string(msg, NET_DM_ATTR_REASON, drop_reasons[reason]))

You need to make sure 'msg' has enough room for this attribute. Account
for it in net_dm_packet_report_size()

>  		goto nla_put_failure;
>  
> -	snprintf(buf, sizeof(buf), "%pS", NET_DM_SKB_CB(skb)->pc);
> +	snprintf(buf, sizeof(buf), "%pS", cb->pc);
>  	if (nla_put_string(msg, NET_DM_ATTR_SYMBOL, buf))
>  		goto nla_put_failure;
>  
> -- 
> 2.27.0
> 
