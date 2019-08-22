Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF0BA992C4
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 14:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387411AbfHVL7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 07:59:52 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60439 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730980AbfHVL7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 07:59:52 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0558B22012;
        Thu, 22 Aug 2019 07:59:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 22 Aug 2019 07:59:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=JUxf2p
        9QAs62WymeaynGKXlsDwy3pURXQdedJAwY+e0=; b=TYp4Ncw6CqhB5yzEgs70RO
        fq6HENl1LgB9i+Ai8q/5220RnAzweUFTHmj90+4UT2Ja90IASRUWtwyuFLZEL0B8
        HuM0L5yFxZMefLfU6NKc8dU67dXk6pN8F3zDDbjOOKZenJTUsjbMlIfZa1kvDH7G
        lX7g3BJ69unMO6mApDYhwJWdKIuyfaPvJThJH1EBqra/czli4jo4plhxRH8wlLoR
        qwnXMdhojrTZHTOQOHRnPSRR1UQwst8/YoRbjwwFhHLf7NoLzbl7MTIeYKASaqL8
        gGpwup7NK+bGONJJ89YhXX1kSJQDePAvsxV0XCmENWqWrSN8pKCn9LKmgg5FjMlQ
        ==
X-ME-Sender: <xms:toNeXVBaGEeOdJQnTr-24jWyOb77rKEH9TYx7Axc3WaJTMB5ewV-wg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudegiedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:toNeXQL3g2GlvgKge0HTTlfbOLCF26qyb_HpqHniwLtJHNAjJRGJwA>
    <xmx:toNeXcXl7nVhemWeQfRsPFJlwULd1_5NH5-0bm56PHkkn8ra0pFTGA>
    <xmx:toNeXTmJYfuNl1dub1gSI-YCcgHQflima_iqb4Adr0gEUEaDZ4IukQ>
    <xmx:toNeXRPqJhoUxS16RaJnOR5RGpgZTFNXc_kvtPcpdZ37muZAPDvokw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 95209D6005B;
        Thu, 22 Aug 2019 07:59:49 -0400 (EDT)
Date:   Thu, 22 Aug 2019 14:59:46 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     netdev@vger.kernel.org, idosch@mellanox.com
Subject: Re: [PATCH][net-next] net: drop_monitor: change the stats variable
 to u64 in net_dm_stats_put
Message-ID: <20190822115946.GA25090@splinter>
References: <1566454953-29321-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566454953-29321-1-git-send-email-lirongqing@baidu.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 02:22:33PM +0800, Li RongQing wrote:
> only the element drop of struct net_dm_stats is used, so simplify it to u64

Thanks for the patch, but I don't really see the value here. The struct
allows for easy extensions in the future. What do you gain from this
change? We merely read stats and report them to user space, so I guess
it's not about performance either.

> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  net/core/drop_monitor.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
> index bfc024024aa3..ed10a40cf629 100644
> --- a/net/core/drop_monitor.c
> +++ b/net/core/drop_monitor.c
> @@ -1329,11 +1329,11 @@ static int net_dm_cmd_config_get(struct sk_buff *skb, struct genl_info *info)
>  	return rc;
>  }
>  
> -static void net_dm_stats_read(struct net_dm_stats *stats)
> +static void net_dm_stats_read(u64 *stats)
>  {
>  	int cpu;
>  
> -	memset(stats, 0, sizeof(*stats));
> +	*stats = 0;
>  	for_each_possible_cpu(cpu) {
>  		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
>  		struct net_dm_stats *cpu_stats = &data->stats;
> @@ -1345,14 +1345,14 @@ static void net_dm_stats_read(struct net_dm_stats *stats)
>  			dropped = cpu_stats->dropped;
>  		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
>  
> -		stats->dropped += dropped;
> +		*stats += dropped;
>  	}
>  }
>  
>  static int net_dm_stats_put(struct sk_buff *msg)
>  {
> -	struct net_dm_stats stats;
>  	struct nlattr *attr;
> +	u64 stats;
>  
>  	net_dm_stats_read(&stats);
>  
> @@ -1361,7 +1361,7 @@ static int net_dm_stats_put(struct sk_buff *msg)
>  		return -EMSGSIZE;
>  
>  	if (nla_put_u64_64bit(msg, NET_DM_ATTR_STATS_DROPPED,
> -			      stats.dropped, NET_DM_ATTR_PAD))
> +			      stats, NET_DM_ATTR_PAD))
>  		goto nla_put_failure;
>  
>  	nla_nest_end(msg, attr);
> -- 
> 2.16.2
> 
