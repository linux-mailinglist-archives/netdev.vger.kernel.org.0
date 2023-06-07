Return-Path: <netdev+bounces-8963-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F39B726693
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:57:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BA6B281432
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:57:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E0B8370CC;
	Wed,  7 Jun 2023 16:57:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9232F63B5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:57:32 +0000 (UTC)
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D27710D7
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 09:57:30 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id 5614622812f47-39ab96e6aefso3608685b6e.1
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 09:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686157049; x=1688749049;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vW6kvtJArlsck7NEBq4oMiHwlZV5V9TRPkzi6sWdhI0=;
        b=lUtpuW3Km4qMQtLxQqx72eevCj9/620qmahBNDLB2W6F9LC+EsjxO5xC49ldXUJPei
         mdeOTSnPUKwm6SgmQ+cruXwTxVCOOyCnxjYOBqlUCUTpXbNEIwJ8gOmUQNZlPAywB4T1
         FTgNwhvZbu9E5mo3S3iLbX5E62WVgQVgn/oUMZUJpQHole7LyqH2IE0u8bfLAJk3wqvB
         jim4kSM7v9Rz1frLMk/UbvrCPO0Mf33XNRv+PaHHImO29f9TN9Aa8+FOiEeMfGN6+/qX
         oKGyx/3ZjwxRvnwiOtijM0HBt9aHhneI63WvxgJ1aqeZOTqU2q03tkah/SCaXndhNI3A
         2fdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686157049; x=1688749049;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vW6kvtJArlsck7NEBq4oMiHwlZV5V9TRPkzi6sWdhI0=;
        b=HL+uTPYGHdRr9VRSpSsVBsqQrWKYbGWxLNkYORw597uLLuro/ZKBrHnTC33JAbappu
         5sZ/kX11YKbFuPbwOmDlk5zfQr4F339LuxbcPtuZs7Nnb2oB7JkyzkquWymCHbOiVfv+
         n5GKAMcIppZ9z5xLzq+bjxPbQ1Ti/loxcVF8t6uQCyEeBemjtCFIuQq8WGZz5T1PBJxu
         GJa63b/REzCWJ6BBdBKnqI/CjqfEqTqn4p0HMU3CaP+APkGINBFHxzuwtbnQgKdddRwC
         znE7AtWkwkhs+jqgYPqPbhN5M3ld+FVLhdFivs1SeM5W3Hp0n20Kng6TMOETxtEIkNdA
         GwsA==
X-Gm-Message-State: AC+VfDyZz7Kui8wBpZjVerB65iw6lTG27pvBJlV5yn54PPDFLYUUJ4Ge
	Ul96YLVc/R5g2Yi9k+/fKk7mkQ==
X-Google-Smtp-Source: ACHHUZ6sI+ErYmajx2Egh3FtZH4lAWt/kK07HnEdfLxUKGtUX6MAHGAQ+r+xU9Pnd4pG1/KPnH39WQ==
X-Received: by 2002:a05:6808:a96:b0:399:de83:96f2 with SMTP id q22-20020a0568080a9600b00399de8396f2mr6279772oij.8.1686157049095;
        Wed, 07 Jun 2023 09:57:29 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:5828:8d4f:202b:264c? ([2804:14d:5c5e:44fb:5828:8d4f:202b:264c])
        by smtp.gmail.com with ESMTPSA id k17-20020a544691000000b0039a531d9b92sm5587507oic.56.2023.06.07.09.57.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 09:57:28 -0700 (PDT)
Message-ID: <89169da7-779e-57a8-831d-81707e1b500d@mojatatu.com>
Date: Wed, 7 Jun 2023 13:57:24 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v3] net/sched: act_pedit: Parse L3 Header for L4 offset
To: Max Tottenham <mtottenh@akamai.com>, netdev@vger.kernel.org
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang
 <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
 Amir Vadai <amir@vadai.me>, Josh Hunt <johunt@akamai.com>,
 kernel test robot <lkp@intel.com>
References: <20230607162353.3631199-1-mtottenh@akamai.com>
Content-Language: en-US
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230607162353.3631199-1-mtottenh@akamai.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 07/06/2023 13:23, Max Tottenham wrote:
> Instead of relying on skb->transport_header being set correctly, opt
> instead to parse the L3 header length out of the L3 headers for both
> IPv4/IPv6 when the Extended Layer Op for tcp/udp is used. This fixes a
> bug if GRO is disabled, when GRO is disabled skb->transport_header is
> set by __netif_receive_skb_core() to point to the L3 header, it's later
> fixed by the upper protocol layers, but act_pedit will receive the SKB
> before the fixups are completed. The existing behavior causes the
> following to edit the L3 header if GRO is disabled instead of the UDP
> header:
> 
>      tc filter add dev eth0 ingress protocol ip flower ip_proto udp \
>   dst_ip 192.168.1.3 action pedit ex munge udp set dport 18053
> 
> Also re-introduce a rate-limited warning if we were unable to extract
> the header offset when using the 'ex' interface.
> 
> Fixes: 71d0ed7079df ("net/act_pedit: Support using offset relative to
> the conventional network headers")
> Signed-off-by: Max Tottenham <mtottenh@akamai.com>
> Reviewed-by: Josh Hunt <johunt@akamai.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202305261541.N165u9TZ-lkp@intel.com/

LGTM,

Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>

> ---
> V2 -> V3:
>    * Address review feedback.
> V1 -> V2:
>    * Fix minor bug reported by kernel test bot.
> 
> ---
>   net/sched/act_pedit.c | 48 ++++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 43 insertions(+), 5 deletions(-)
> 
> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> index fc945c7e4123..c819b812a899 100644
> --- a/net/sched/act_pedit.c
> +++ b/net/sched/act_pedit.c
> @@ -13,7 +13,10 @@
>   #include <linux/rtnetlink.h>
>   #include <linux/module.h>
>   #include <linux/init.h>
> +#include <linux/ip.h>
> +#include <linux/ipv6.h>
>   #include <linux/slab.h>
> +#include <net/ipv6.h>
>   #include <net/netlink.h>
>   #include <net/pkt_sched.h>
>   #include <linux/tc_act/tc_pedit.h>
> @@ -327,28 +330,58 @@ static bool offset_valid(struct sk_buff *skb, int offset)
>   	return true;
>   }
>   
> -static void pedit_skb_hdr_offset(struct sk_buff *skb,
> +static int pedit_l4_skb_offset(struct sk_buff *skb, int *hoffset, const int header_type)
> +{
> +	const int noff = skb_network_offset(skb);
> +	int ret = -EINVAL;
> +	struct iphdr _iph;
> +
> +	switch (skb->protocol) {
> +	case htons(ETH_P_IP): {
> +		const struct iphdr *iph = skb_header_pointer(skb, noff, sizeof(_iph), &_iph);
> +
> +		if (!iph)
> +			goto out;
> +		*hoffset = noff + iph->ihl * 4;
> +		ret = 0;
> +		break;
> +	}
> +	case htons(ETH_P_IPV6):
> +		ret = ipv6_find_hdr(skb, hoffset, header_type, NULL, NULL) == header_type ? 0 : -EINVAL;
> +		break;
> +	}
> +out:
> +	return ret;
> +}
> +
> +static int pedit_skb_hdr_offset(struct sk_buff *skb,
>   				 enum pedit_header_type htype, int *hoffset)
>   {
> +	int ret = -EINVAL;
>   	/* 'htype' is validated in the netlink parsing */
>   	switch (htype) {
>   	case TCA_PEDIT_KEY_EX_HDR_TYPE_ETH:
> -		if (skb_mac_header_was_set(skb))
> +		if (skb_mac_header_was_set(skb)) {
>   			*hoffset = skb_mac_offset(skb);
> +			ret = 0;
> +		}
>   		break;
>   	case TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK:
>   	case TCA_PEDIT_KEY_EX_HDR_TYPE_IP4:
>   	case TCA_PEDIT_KEY_EX_HDR_TYPE_IP6:
>   		*hoffset = skb_network_offset(skb);
> +		ret = 0;
>   		break;
>   	case TCA_PEDIT_KEY_EX_HDR_TYPE_TCP:
> +		ret = pedit_l4_skb_offset(skb, hoffset, IPPROTO_TCP);
> +		break;
>   	case TCA_PEDIT_KEY_EX_HDR_TYPE_UDP:
> -		if (skb_transport_header_was_set(skb))
> -			*hoffset = skb_transport_offset(skb);
> +		ret = pedit_l4_skb_offset(skb, hoffset, IPPROTO_UDP);
>   		break;
>   	default:
>   		break;
>   	}
> +	return ret;
>   }
>   
>   TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
> @@ -384,6 +417,7 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
>   		int hoffset = 0;
>   		u32 *ptr, hdata;
>   		u32 val;
> +		int rc;
>   
>   		if (tkey_ex) {
>   			htype = tkey_ex->htype;
> @@ -392,7 +426,11 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
>   			tkey_ex++;
>   		}
>   
> -		pedit_skb_hdr_offset(skb, htype, &hoffset);
> +		rc = pedit_skb_hdr_offset(skb, htype, &hoffset);
> +		if (rc) {
> +			pr_info_ratelimited("tc action pedit unable to extract header offset for header type (0x%x)\n", htype);
> +			goto bad;
> +		}
>   
>   		if (tkey->offmask) {
>   			u8 *d, _d;


