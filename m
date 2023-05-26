Return-Path: <netdev+bounces-5699-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 386737127C0
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:47:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3FBC1C2105B
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:47:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0E761E534;
	Fri, 26 May 2023 13:47:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A7618B1C
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 13:47:53 +0000 (UTC)
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7C4F3
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:47:52 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 46e09a7af769-6b085e425ffso711277a34.1
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685108871; x=1687700871;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RBlNS/fDYG7NvO4kqLWg3Z4kU8ronoZ4JV6LhqVvDK4=;
        b=DAJCRLy57iyqGFtIMPgYs00sZ/oFVByWEbhARdwT8kW1J7L/BnGT+g25aTcShPJjrP
         YXrq67whn9HuBTchRghSuti8WZgYMk0345WWMgRCAX49NF6DOEvPx9mhPacnSdBSoPnk
         hWR48xtEmTiA++8gWQYYNLGN8P4HTdY4RCmNgXWK8LnT1KQ1nO6Yt4rj7MIGdFXVH1Xo
         eXW73Q1zKiDGRFYRCZ8FgyZanLrZVX2AlgO3Mba6DdD0ZN1nd8TBAPbwGpqWNI6ygV2B
         /A/QPuLpM4W3a72C4DSj/e7TjSNtlKDzScqt3bF9UALczabT0yC7mDIWaYTDbu0PXRG7
         sI5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685108871; x=1687700871;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RBlNS/fDYG7NvO4kqLWg3Z4kU8ronoZ4JV6LhqVvDK4=;
        b=X0Vn2SGyka80cAM9jx0kjQXVpW1mXkT8Aphs5+E47dTR1UshqyvL5PdvLhPY5TEfyO
         SRRL8qJAzEhMb+57XlT/CrciZAGN/jgTjbdspV98CwVD+VUCWYLlcj+EzOb4p6cIhwTD
         Qz4JkdZ3Z4vEQK5c3U55zn+e/pcQuJnw4FayrUKj4DEwnekG40ADgHW5xnjguRN9f3vV
         dFtYfo8HLEtaVVWlcc9EMRA8Jclzr8seMANwHC+Yh5jf2MMLj5KcnDpORG4ATgZ1xWy3
         An4PkFYC0LeAICPu+IETHnvZi78MCA/bBg229g/gA9JgfGdJAnDZ/4w2+vKkWs2FVZzb
         pzJA==
X-Gm-Message-State: AC+VfDyCTWtc/NI90kP6Ra5FPKdDa4jzKo1nQiswrDB8JIuPsyVa97ji
	LA8kknJxxUuNyU7R6oTRFcPTtF/D015R70Uff3Q=
X-Google-Smtp-Source: ACHHUZ52ztmGSjWaawB5DK7e3ToorFY0t/Bvodp4OqBEURf/jcr7kUNtPuSyD/CsgRQmqcRRMx7m1Q==
X-Received: by 2002:a05:6808:13d5:b0:398:fc3:2115 with SMTP id d21-20020a05680813d500b003980fc32115mr1239405oiw.34.1685108871270;
        Fri, 26 May 2023 06:47:51 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:2f26:80da:f713:69d3? ([2804:14d:5c5e:44fb:2f26:80da:f713:69d3])
        by smtp.gmail.com with ESMTPSA id t8-20020a0568301e2800b006ab241d8c42sm1714102otr.17.2023.05.26.06.47.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 May 2023 06:47:50 -0700 (PDT)
Message-ID: <5587e78a-acfe-edfa-6b6b-c35bea34f5a3@mojatatu.com>
Date: Fri, 26 May 2023 10:47:46 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2] net/sched: act_pedit: Parse L3 Header for L4 offset
To: Max Tottenham <mtottenh@akamai.com>, netdev@vger.kernel.org
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang
 <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
 Amir Vadai <amir@vadai.me>, Josh Hunt <johunt@akamai.com>,
 kernel test robot <lkp@intel.com>
References: <20230526095810.280474-1-mtottenh@akamai.com>
Content-Language: en-US
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230526095810.280474-1-mtottenh@akamai.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 26/05/2023 06:58, Max Tottenham wrote:
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

Just a FYI: the automatic back port will probably fail because of a 
recent cleanup in this code

> Signed-off-by: Max Tottenham <mtottenh@akamai.com>
> Reviewed-by: Josh Hunt <johunt@akamai.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202305261541.N165u9TZ-lkp@intel.com/
> ---
> V1 -> V2:
>    * Fix minor bug reported by kernel test bot.
> 
> ---
>   net/sched/act_pedit.c | 48 ++++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 43 insertions(+), 5 deletions(-)
> 
> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> index fc945c7e4123..d28335519459 100644
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
> +	int noff = skb_network_offset(skb);
> +	struct iphdr *iph = NULL;
> +	int ret = -EINVAL;

nit: Should be in reverse Christmas tree

> +
> +	switch (skb->protocol) {
> +	case htons(ETH_P_IP):
> +		if (!pskb_may_pull(skb, sizeof(*iph) + noff))
> +			goto out;

I might have missed something but is this really needed?
https://elixir.bootlin.com/linux/latest/source/net/ipv4/ip_input.c#L456

> +		iph = ip_hdr(skb);
> +		*hoffset = noff + iph->ihl *  > +		ret = 0;
> +		break;
> +	case htons(ETH_P_IPV6):
> +		*hoffset = 0;
nit: Not needed

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
> +		ret = -EINVAL;

nit: Not needed

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


