Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98A1204A5C
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 09:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731009AbgFWHB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 03:01:26 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:39167 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730793AbgFWHB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 03:01:26 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4D1BE5801D6;
        Tue, 23 Jun 2020 03:01:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 23 Jun 2020 03:01:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=gtgSWm
        egIoHm4MX/HCP2VF63Hd3Bi8InPjB0B+c///M=; b=lrLgsUA0jtkFm0nLTJhas4
        dFEYDhiJ3RV1CbXLowxXiN6TL91b6rxo5umHI57dphwOeb8022Eqf5wO5p5M1fnN
        9u2g3/sg5kOowthBbvK7JxDcgn4o/i/YcVRR5qWza0AX4NP/NI2dIsDCw5y4zAjc
        hT9fwLcAxmd9+9O0qA7SThpCE8AgdBWstZqR1mDdrd6Mlrg1ootSSSzeOeTB0iFs
        qPDvZF3CdgL662qlxEfunTxMLD30iC7hhpqlM0Pg2CXSL9+N4/vfELyENXocRKBx
        o3/iix3XZ4qnOS92m/vzS9jlI7JcFUaFj4Zymvq1IyP+bRkEbdk6zzCdd7/vI/0Q
        ==
X-ME-Sender: <xms:w6jxXoE0nOZF4ElLyccN8SthLiecTOASEAL4Am6jpkASr0sVrQqMsg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekfedgudduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepgfevgfevueduueffieffheeifffgjeelvedtteeuteeuffekvefggfdtudfg
    keevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepjeelrddukeefrdeihe
    drkeejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:w6jxXhVdkBRO08vtYPzV-YsnAgfUQKZ20nbRoosX1zEMBzXg_4vwDA>
    <xmx:w6jxXiLY1HFzQ38yWlwweOioeqCbV2p1NFizeQyaHhTJ2DNiI28Bug>
    <xmx:w6jxXqH-CbIWL8noXEEupH8ycyO-x7DHw-MOCgbuFvgH_sMSusfvqQ>
    <xmx:xajxXkGjMlq0LrCHpnowH5-s3lMjo3vxyBlDqD51IcJ7nl_GPMLKGA>
Received: from localhost (bzq-79-183-65-87.red.bezeqint.net [79.183.65.87])
        by mail.messagingengine.com (Postfix) with ESMTPA id 11D0230674A2;
        Tue, 23 Jun 2020 03:01:23 -0400 (EDT)
Date:   Tue, 23 Jun 2020 10:01:20 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Po Liu <po.liu@nxp.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jiri@resnulli.us, vinicius.gomes@intel.com,
        vlad@buslov.dev, claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org
Subject: Re: [v1,net-next 1/4] net: qos: add tc police offloading action with
 max frame size limit
Message-ID: <20200623070120.GA575172@splinter>
References: <20200306125608.11717-7-Po.Liu@nxp.com>
 <20200623063412.19180-1-po.liu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623063412.19180-1-po.liu@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 02:34:09PM +0800, Po Liu wrote:
> From: Po Liu <Po.Liu@nxp.com>
> 
> Current police offloading support the 'burst'' and 'rate_bytes_ps'. Some

s/support/supports/
s/'burst''/'burst'/

> hardware own the capability to limit the frame size. If the frame size
> larger than the setting, the frame would be dropped. For the police
> action itself already accept the 'mtu' parameter in tc command. But not

s/accept/accepts/

> extend to tc flower offloading. So extend 'mtu' to tc flower offloading.

Throughout the submission you are always using the term 'flower
offloading', but this has nothing to do with flower. Flower is the
classifier, whereas you are extending police action which can be tied to
any classifier.

> 
> Signed-off-by: Po Liu <Po.Liu@nxp.com>
> ---
> continue the thread 20200306125608.11717-7-Po.Liu@nxp.com for the police
> action offloading.

For a patch set you need a cover letter (patch 0). It should include
necessary background, motivation and overview of the patches. You can
mention there that some of the patches were sent as RFC back in March
and provide a link:

https://lore.kernel.org/netdev/20200306125608.11717-1-Po.Liu@nxp.com/

The code itself looks good to me.

> 
>  include/net/flow_offload.h     |  1 +
>  include/net/tc_act/tc_police.h | 10 ++++++++++
>  net/sched/cls_api.c            |  1 +
>  3 files changed, 12 insertions(+)
> 
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 00c15f14c434..c2ef19c6b27d 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -234,6 +234,7 @@ struct flow_action_entry {
>  		struct {				/* FLOW_ACTION_POLICE */
>  			s64			burst;
>  			u64			rate_bytes_ps;
> +			u32			mtu;
>  		} police;
>  		struct {				/* FLOW_ACTION_CT */
>  			int action;
> diff --git a/include/net/tc_act/tc_police.h b/include/net/tc_act/tc_police.h
> index f098ad4424be..cd973b10ae8c 100644
> --- a/include/net/tc_act/tc_police.h
> +++ b/include/net/tc_act/tc_police.h
> @@ -69,4 +69,14 @@ static inline s64 tcf_police_tcfp_burst(const struct tc_action *act)
>  	return params->tcfp_burst;
>  }
>  
> +static inline u32 tcf_police_tcfp_mtu(const struct tc_action *act)
> +{
> +	struct tcf_police *police = to_police(act);
> +	struct tcf_police_params *params;
> +
> +	params = rcu_dereference_protected(police->params,
> +					   lockdep_is_held(&police->tcf_lock));
> +	return params->tcfp_mtu;
> +}
> +
>  #endif /* __NET_TC_POLICE_H */
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index a00a203b2ef5..6aba7d5ba1ec 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3658,6 +3658,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>  			entry->police.burst = tcf_police_tcfp_burst(act);
>  			entry->police.rate_bytes_ps =
>  				tcf_police_rate_bytes_ps(act);
> +			entry->police.mtu = tcf_police_tcfp_mtu(act);
>  		} else if (is_tcf_ct(act)) {
>  			entry->id = FLOW_ACTION_CT;
>  			entry->ct.action = tcf_ct_action(act);
> -- 
> 2.17.1
> 
