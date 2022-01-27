Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACDBE49E64B
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 16:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242616AbiA0Pjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 10:39:45 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:34005 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237455AbiA0Pjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 10:39:44 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 26A1A580EB6;
        Thu, 27 Jan 2022 10:39:44 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 27 Jan 2022 10:39:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; bh=WaIfKB6L73BlPeNtlmOZwTQbsqShiIjBr2J2vT
        exb+o=; b=kjxYAXUPvgtxdi3q7a5Uu7t9LhZ1vnb6czWe6Cr4hHD5TegHDG1Gor
        GrspqmoX3jRcFlFZwBfcbh/Gp7I29ACZWMweu+DHoT2klDGURHr5gdLcUGwrTfQB
        Ih5kmBc+DDWRbHO4ANUxga1LbAkU1xYTF/xc1632sgCrCj5qKafP1+wPp6gC6dSq
        9f3R8z+enlhWkpe3ibSjZzyWo6vRzrQZdg/AeBefZ20quHUH+jyO+qWl9oBj4SwZ
        qGbBCc4KCswhs/uBw+YX65lwFm7sxYFDF33hHu1SK06lsBK7ekKv7aFi8HTGdCF+
        chVPF+n+ti/6OkGByQtr99T/sC/aQs2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=WaIfKB6L73BlPeNtl
        mOZwTQbsqShiIjBr2J2vTexb+o=; b=iOhqajQZ1Rche6XXQ1tGBzf2007JAojWc
        3dO+f+Vpj8zAxhPM0r63LPqNXs5DKV5XG9NJFe2xM+R8cJltbHSDpIxiD7OMvXL+
        PDk3Taykm2iIOAdu4Qgtoo88myMUNShlh/vLBjpQ9QsCw2vsdrcQtXdjnF9YAhJs
        gacSk9PaWUfhvWofnU7FjXWhJCA59T+JG1U4E2/wI587ad+BGkLU3u2xmcGmirqD
        mtowlkNdDypNvogW2y07LyjD5icANqBw0tRJ6zrsEDBSMq9+2hZdUFZBQvxc49Ke
        EWdrO6QiWiCj1Ot7mzNz41wEZ6EaoSVtmqRLwm7UDiLpaXXqiHJJw==
X-ME-Sender: <xms:v7zyYaI0l6pPq49-jvD7f4HAEPt5dR_ChUF2wv3JR4uzmRDP41oaUQ>
    <xme:v7zyYSIR-cSmV9GufidZ-ocu-lrlFI9D5q_NonMx76JHDbiT1nfAylCUoDoDgqHaP
    KLiWAma593TLA>
X-ME-Received: <xmr:v7zyYasvKeIpWrMBvOnx4NBQc-NFgxt62UFSL_9ilv6uSyAZuVxqp0tlSKJoO1fuvsh58XaRsdn3WLb3837PdhD7m7fDL-9H>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrfeefgdejlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:v7zyYfZZ5MwGeKIFoJMnVuF4fcBdWjwMzTXkq-KmpSd19B-Fg_Wgvg>
    <xmx:v7zyYRYWGeXNO0j0fCM5nDWbuxNQV-RQxbKPwkVKoS1Vj9T5dxlI0w>
    <xmx:v7zyYbDHtAbGSZFfn1fY-e8AE1pIJUfamHz9pQlF4WTcYeN4eiddwA>
    <xmx:wLzyYVSBf8TmN9c2eWwPwCJlUY0KcIFZ-e1cOVutDJbu_Zjj2548iA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Jan 2022 10:39:42 -0500 (EST)
Date:   Thu, 27 Jan 2022 16:39:41 +0100
From:   Greg KH <greg@kroah.com>
To:     Huang Guobin <huangguobin4@huawei.com>
Cc:     nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 1/1] net: bridge: clear bridge's private skb space
 on xmit
Message-ID: <YfK8vTvSJAT8i6F4@kroah.com>
References: <20220126033639.909340-1-huangguobin4@huawei.com>
 <20220126033639.909340-2-huangguobin4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126033639.909340-2-huangguobin4@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 11:36:39AM +0800, Huang Guobin wrote:
> From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> 
> [ Upstream commit fd65e5a95d08389444e8591a20538b3edece0e15 ]
> 
> We need to clear all of the bridge private skb variables as they can be
> stale due to the packet being recirculated through the stack and then
> transmitted through the bridge device. Similar memset is already done on
> bridge's input. We've seen cases where proxyarp_replied was 1 on routed
> multicast packets transmitted through the bridge to ports with neigh
> suppress which were getting dropped. Same thing can in theory happen with
> the port isolation bit as well.
> 
> Fixes: 821f1b21cabb ("bridge: add new BR_NEIGH_SUPPRESS port flag to suppress arp and nd flood")
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Huang Guobin <huangguobin4@huawei.com>
> ---
>  net/bridge/br_device.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
> index a350c05b7ff5..7c6b1024dd4b 100644
> --- a/net/bridge/br_device.c
> +++ b/net/bridge/br_device.c
> @@ -42,6 +42,8 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
>  	struct ethhdr *eth;
>  	u16 vid = 0;
>  
> +	memset(skb->cb, 0, sizeof(struct br_input_skb_cb));
> +
>  	rcu_read_lock();
>  	nf_ops = rcu_dereference(nf_br_ops);
>  	if (nf_ops && nf_ops->br_dev_xmit_hook(skb)) {
> -- 
> 2.25.1
> 

Now queued up, thanks.

greg k-h
