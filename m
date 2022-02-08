Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6224ADBCC
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 15:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379054AbiBHO6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 09:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348499AbiBHO6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 09:58:47 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594B4C061577;
        Tue,  8 Feb 2022 06:58:46 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8C6265C0130;
        Tue,  8 Feb 2022 09:58:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 08 Feb 2022 09:58:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=FZq4ssWYMzF04ugzd
        U6+K23uZ05YdN5l+VMujCkRgRE=; b=Bqp07LPgsRAyzl+TYa3JiHKhBiEsDjSRb
        mQYRMEGrYieX1NiRgGpCL5g0nYgx8R12ffhpdOAB+CheUOJGlqO9OSF7Od5opNRJ
        5t0sd1FMDR/ql/52am+9dBlCKWfZKjwk7/tZ8fL2b8UNTrKwRUEIx5CIA5nBeuUP
        kTFSH79WGJmrr8N1+v7OD+NzrW8no2UNUPQ7Ypg7WnYpKg5l0USZ646+OBzNrMdY
        efquFiDlPofLiXQ/dCi2CTW1tkr5NmjXjlaq+y7ktIB1yUUDA7MVSIQ/BTNagUP9
        J2mSyoctrgWEhSivUlvkKHE6SVyA9HdjNpfY6NyqW9WUDzSoj86wg==
X-ME-Sender: <xms:JIUCYik-3y23dLZm0pm-KTnSeUphdjfIg3ZUIlbSzjS2ZduT0Eo-Sg>
    <xme:JIUCYp1pqD32pHbcwcRkNkJl3ivjGyFmQsSUfj-6ncHm2B_Kbl1_iu_zUjgc1EHZw
    lCvV57UYdkm9vk>
X-ME-Received: <xmr:JIUCYgpetAlwpDA2JSi91BCyQkQb7Dxe_xnhZ7548_FLGuHmadbrs4ZZoggFqNzXVLrsN-jrL-GLo_pG-ZsXoFXiaNFbfg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheejgdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttdortd
    dttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpefgjeevhfdvgeeiudekteduveegueejfe
    fffeefteekkeeuueehjeduledtjeeuudenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:JIUCYmlyZNDi2_wwfKMpjUNBsjV5OyJ_xHIUNX28kfP2YiSr-tB5HA>
    <xmx:JIUCYg3RnrwEewoye8jaJTKVi7ak8RH_2u_ZOaebfzsHdPqKbD85Fw>
    <xmx:JIUCYttMU35hvy5pnwYjPVei1khtRXVN0pys3BPbkqmzxo8ELFOYWA>
    <xmx:JYUCYhmVI6ZU5xQMrqa9Ef8ZJ7Yzvh2UpTW0CByt6-2S-cqYM4QaqA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Feb 2022 09:58:44 -0500 (EST)
Date:   Tue, 8 Feb 2022 16:58:39 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     menglong8.dong@gmail.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, nhorman@tuxdriver.com,
        davem@davemloft.net, kuba@kernel.org, imagedong@tencent.com,
        dsahern@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v7 net-next 2/2] net: drop_monitor: support drop reason
Message-ID: <YgKFHyQphAwMgsEY@shredder>
References: <20220208072836.3540192-1-imagedong@tencent.com>
 <20220208072836.3540192-3-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208072836.3540192-3-imagedong@tencent.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 03:28:36PM +0800, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()")
> drop reason is introduced to the tracepoint of kfree_skb. Therefore,
> drop_monitor is able to report the drop reason to users by netlink.
> 
> The drop reasons are reported as string to users, which is exactly
> the same as what we do when reporting it to ftrace.
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
> v7:
> - take the size of NET_DM_ATTR_REASON into accounting in
>   net_dm_packet_report_size()
> - let compiler define the size of drop_reasons
> 
> v6:
> - check the range of drop reason in net_dm_packet_report_fill()
> 
> v5:
> - check if drop reason larger than SKB_DROP_REASON_MAX
> 
> v4:
> - report drop reasons as string
> 
> v3:
> - referring to cb->reason and cb->pc directly in
>   net_dm_packet_report_fill()
> 
> v2:
> - get a pointer to struct net_dm_skb_cb instead of local var for
>   each field
> ---
>  include/uapi/linux/net_dropmon.h |  1 +
>  net/core/drop_monitor.c          | 34 ++++++++++++++++++++++++++++----
>  2 files changed, 31 insertions(+), 4 deletions(-)
> 
> diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
> index 66048cc5d7b3..1bbea8f0681e 100644
> --- a/include/uapi/linux/net_dropmon.h
> +++ b/include/uapi/linux/net_dropmon.h
> @@ -93,6 +93,7 @@ enum net_dm_attr {
>  	NET_DM_ATTR_SW_DROPS,			/* flag */
>  	NET_DM_ATTR_HW_DROPS,			/* flag */
>  	NET_DM_ATTR_FLOW_ACTION_COOKIE,		/* binary */
> +	NET_DM_ATTR_REASON,			/* string */
>  
>  	__NET_DM_ATTR_MAX,
>  	NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
> diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
> index 7b288a121a41..28c55d605566 100644
> --- a/net/core/drop_monitor.c
> +++ b/net/core/drop_monitor.c
> @@ -48,6 +48,19 @@
>  static int trace_state = TRACE_OFF;
>  static bool monitor_hw;
>  
> +#undef EM
> +#undef EMe
> +
> +#define EM(a, b)	[a] = #b,
> +#define EMe(a, b)	[a] = #b
> +
> +/* drop_reasons is used to translate 'enum skb_drop_reason' to string,
> + * which is reported to user space.
> + */
> +static const char * const drop_reasons[] = {
> +	TRACE_SKB_DROP_REASON
> +};
> +
>  /* net_dm_mutex
>   *
>   * An overall lock guarding every operation coming from userspace.
> @@ -126,6 +139,7 @@ struct net_dm_skb_cb {
>  		struct devlink_trap_metadata *hw_metadata;
>  		void *pc;
>  	};
> +	enum skb_drop_reason reason;
>  };
>  
>  #define NET_DM_SKB_CB(__skb) ((struct net_dm_skb_cb *)&((__skb)->cb[0]))
> @@ -498,6 +512,7 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
>  {
>  	ktime_t tstamp = ktime_get_real();
>  	struct per_cpu_dm_data *data;
> +	struct net_dm_skb_cb *cb;
>  	struct sk_buff *nskb;
>  	unsigned long flags;
>  
> @@ -508,7 +523,9 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
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
> @@ -574,6 +591,8 @@ static size_t net_dm_packet_report_size(size_t payload_len)
>  	       nla_total_size(sizeof(u32)) +
>  	       /* NET_DM_ATTR_PROTO */
>  	       nla_total_size(sizeof(u16)) +
> +	       /* NET_DM_ATTR_REASON */
> +	       nla_total_size(SKB_DR_MAX_LEN + 1) +

Nothing ensures that the reason is not longer than this length and
nothing ensures that this assumption remains valid as more reasons are
added.

I think "SKB_DR_MAX_LEN" can be removed completely. Pass "reason" to
this function and do "strlen(drop_reasons[reason]) + 1". Any reason it
can't work?

>  	       /* NET_DM_ATTR_PAYLOAD */
>  	       nla_total_size(payload_len);
>  }
> @@ -606,8 +625,9 @@ static int net_dm_packet_report_in_port_put(struct sk_buff *msg, int ifindex,
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
> @@ -620,10 +640,16 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
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

In which cases can this happen? Might be better to perform this
validation in net_dm_packet_trace_kfree_skb_hit() and set "cb->reason"
to "SKB_DROP_REASON_NOT_SPECIFIED" in this case. That way we don't need
to perform the validation in later code paths

> +	    nla_put_string(msg, NET_DM_ATTR_REASON, drop_reasons[reason]))
>  		goto nla_put_failure;
>  
> -	snprintf(buf, sizeof(buf), "%pS", NET_DM_SKB_CB(skb)->pc);
> +	snprintf(buf, sizeof(buf), "%pS", cb->pc);
>  	if (nla_put_string(msg, NET_DM_ATTR_SYMBOL, buf))
>  		goto nla_put_failure;
>  
> -- 
> 2.34.1
> 
