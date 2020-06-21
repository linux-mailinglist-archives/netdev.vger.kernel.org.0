Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32ED72029F6
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 12:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbgFUKEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 06:04:11 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:49637 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729628AbgFUKEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 06:04:11 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 74B39580593;
        Sun, 21 Jun 2020 06:04:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 21 Jun 2020 06:04:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=enaKZ3
        P0o6Ph93CXxGqso4eTkC9mjZncv8RRs2hdv58=; b=qSVkPh5f68sJYg9Kbd4/0O
        1IXyxTdX4yBpIBWQvYcvzxKJPqI22Xi9CckdmoDKcTGC6KTOqJfOVi0VyE3/R6fv
        7kq63p960rUJTwQpJpt7/RlHCk2OYMqVjDUmSVcnn0lBOOH9dO4fKcOssYx1BoLW
        +egUCtkskJCxqDNlxxTbn4dNk1+/GJMJvreRPCXsKqhSAhCO7GuZwPxHdUANZubz
        9hniGX5jUxkjX5caN3RsQ25Udponx1xJcZJhNyojShpkEZyhkLyAxx3GWfWIWTyH
        K2324JzdzpUFWi8PwU23t6QbhQ9sI8qGc1N/DltoE1W0xKIfTGZSEISOufFDSYFA
        ==
X-ME-Sender: <xms:mDDvXsUoZ9oTsEWKrWWduMnaEWUScQuwOJixmaffYrXeJTCbUA_Qhg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudektddgvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepuddtledrieejrdekrdduvdelnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:mDDvXgl2H2DT7daXmHEABvoj7vGB-nMTpeiLGuI8IWJszMT-JNcAIA>
    <xmx:mDDvXgawHccHnB8ljj-Y4bC76cvIipUOQbYrtKnXCUhTBr2NUVF92Q>
    <xmx:mDDvXrXCNDLj2USRLPsRsF-Ntsy9O0iOnFmL1CTQqm6MF9vJ1ac9Cg>
    <xmx:mjDvXizA7mjpE3t009Hy4SDiVA-76ILEmev7ASOGVDoeB_b9qTcpjQ>
Received: from localhost (bzq-109-67-8-129.red.bezeqint.net [109.67.8.129])
        by mail.messagingengine.com (Postfix) with ESMTPA id 330BC3280060;
        Sun, 21 Jun 2020 06:04:08 -0400 (EDT)
Date:   Sun, 21 Jun 2020 13:04:06 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Po Liu <Po.Liu@nxp.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vinicius.gomes@intel.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        roy.zang@nxp.com, mingkai.hu@nxp.com, jerry.huang@nxp.com,
        leoyang.li@nxp.com, michael.chan@broadcom.com, vishal@chelsio.com,
        saeedm@mellanox.com, leon@kernel.org, jiri@mellanox.com,
        idosch@mellanox.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, john.hurley@netronome.com,
        simon.horman@netronome.com, pieter.jansenvanvuuren@netronome.com,
        pablo@netfilter.org, moshe@mellanox.com,
        ivan.khoronzhuk@linaro.org, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, jakub.kicinski@netronome.com
Subject: Re: [RFC,net-next  8/9] net: qos: police action add index for tc
 flower offloading
Message-ID: <20200621100406.GA481939@splinter>
References: <20200306125608.11717-1-Po.Liu@nxp.com>
 <20200306125608.11717-9-Po.Liu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306125608.11717-9-Po.Liu@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 06, 2020 at 08:56:06PM +0800, Po Liu wrote:
> Hardware may own many entries for police flow. So that make one(or
>  multi) flow to be policed by one hardware entry. This patch add the
> police action index provide to the driver side make it mapping the
> driver hardware entry index.
> 
> Signed-off-by: Po Liu <Po.Liu@nxp.com>

Hi,

I started looking into tc-police offload in mlxsw and remembered your
patch. Are you planning to formally submit it? I'm asking because in
mlxsw it is also possible to share the same policer between multiple
filters.

Thanks

> ---
>  include/net/flow_offload.h | 1 +
>  net/sched/cls_api.c        | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 54df87328edc..3b78b15ed20b 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -201,6 +201,7 @@ struct flow_action_entry {
>  			bool			truncate;
>  		} sample;
>  		struct {				/* FLOW_ACTION_POLICE */
> +			u32			index;
>  			s64			burst;
>  			u64			rate_bytes_ps;
>  			u32			mtu;
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 363d3991793d..ce846a9dadc1 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3584,6 +3584,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>  			entry->police.rate_bytes_ps =
>  				tcf_police_rate_bytes_ps(act);
>  			entry->police.mtu = tcf_police_mtu(act);
> +			entry->police.index = act->tcfa_index;
>  		} else if (is_tcf_ct(act)) {
>  			entry->id = FLOW_ACTION_CT;
>  			entry->ct.action = tcf_ct_action(act);
> -- 
> 2.17.1
> 
