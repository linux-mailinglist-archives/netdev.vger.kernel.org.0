Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F7F5626C9
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 01:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbiF3XKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 19:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbiF3XKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 19:10:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3212C5927D
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 16:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656630622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EnyaAXgd8G1Jiycor/ytC2X3rf2YRxyQ760krhEkaYo=;
        b=TWUfgsKJ5QYpiURR3NRpUcJ8IFXzTQMuC9qpykG09Q4Oqu6cCBshiTRrdHM5kbDfLokTmz
        tP2ofo3qNg44syCWwrWThVKESNkIsUB0f4evfJ4sVAj1do2qyJAIYjj8yh4aWtpv85DfO4
        HF1q/jTHlg+edgk5/mbvPbgEbWSHqaA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-9CJv3Am4N5CJpUURrBIjKQ-1; Thu, 30 Jun 2022 19:10:20 -0400
X-MC-Unique: 9CJv3Am4N5CJpUURrBIjKQ-1
Received: by mail-wm1-f69.google.com with SMTP id be8-20020a05600c1e8800b003a069fe18ffso2099348wmb.9
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 16:10:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EnyaAXgd8G1Jiycor/ytC2X3rf2YRxyQ760krhEkaYo=;
        b=hxSbhDZ209G49K4esOTCYoBR2tapk/V2rn99BARHAoBO80zB4vS8P1ofBoYrXTg3EA
         YYVnvHj5gNaOOjclW/j7kpSo6I4t56pE71m8/BtaD31MalpwMXaK5NFR4vovqrrtk1kg
         x6RtzToJ/16mv8SMkA/L//x3dCf6MMfZ5y5UOZBMbyhqcQCK637O1PukCGL5ezMbjSTY
         gUVCFQgVEhVQ7Q9VbqElVdr7zy7+OvZYEGVs7wUP2oDXO6GOgTMJ53/wy0MTQzM9+iEP
         Rn6FWg8QCK1Sr69dst8YEQqOrfwPXw3WxWm2NCASsPtnFS6plGiPBrFEYEwlBWvHEavB
         SfXQ==
X-Gm-Message-State: AJIora+tYWss/ciMHz7hoZr3LMiQVRdYIXiC/cjBOCu/wqZXChLlQCDa
        0rfv6W2a/T7Wbe6HZj37EwLI9IEbVbQudc00f6kd0nn5BZF/A7Z5Yj9c0tzyHsp4evUjJX6MKuW
        lAiTfwRA4+tkThU8x
X-Received: by 2002:a05:600c:3492:b0:3a1:70dd:9a14 with SMTP id a18-20020a05600c349200b003a170dd9a14mr10651005wmq.177.1656630619479;
        Thu, 30 Jun 2022 16:10:19 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uk01pkc2nbFZ14+mldws4wiQLdxtDiJBxBf4NkJYbqJDFCSCJHdEErYcIXwQJBlFN8hjSvCg==
X-Received: by 2002:a05:600c:3492:b0:3a1:70dd:9a14 with SMTP id a18-20020a05600c349200b003a170dd9a14mr10650975wmq.177.1656630619248;
        Thu, 30 Jun 2022 16:10:19 -0700 (PDT)
Received: from debian.home (2a01cb058d1194004161f17a6a9ad508.ipv6.abo.wanadoo.fr. [2a01:cb05:8d11:9400:4161:f17a:6a9a:d508])
        by smtp.gmail.com with ESMTPSA id r16-20020a05600c35d000b003a0375c4f73sm8495461wmq.44.2022.06.30.16.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 16:10:18 -0700 (PDT)
Date:   Fri, 1 Jul 2022 01:10:16 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Marcin Szycik <marcin.szycik@linux.intel.com>
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        davem@davemloft.net, xiyou.wangcong@gmail.com,
        jesse.brandeburg@intel.com, gustavoars@kernel.org,
        baowen.zheng@corigine.com, boris.sukholitko@broadcom.com,
        edumazet@google.com, kuba@kernel.org, jhs@mojatatu.com,
        jiri@resnulli.us, kurt@linutronix.de, pablo@netfilter.org,
        pabeni@redhat.com, paulb@nvidia.com, simon.horman@corigine.com,
        komachi.yoshiki@gmail.com, zhangkaiheb@126.com,
        intel-wired-lan@lists.osuosl.org,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        alexandr.lobakin@intel.com, mostrows@earthlink.net,
        paulus@samba.org
Subject: Re: [RFC PATCH net-next v3 1/4] flow_dissector: Add PPPoE dissectors
Message-ID: <20220630231016.GA392@debian.home>
References: <20220629143859.209028-1-marcin.szycik@linux.intel.com>
 <20220629143859.209028-2-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629143859.209028-2-marcin.szycik@linux.intel.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 04:38:56PM +0200, Marcin Szycik wrote:
> From: Wojciech Drewek <wojciech.drewek@intel.com>
> 
> Allow to dissect PPPoE specific fields which are:
> - session ID (16 bits)
> - ppp protocol (16 bits)
> 
> The goal is to make the following TC command possible:
> 
>   # tc filter add dev ens6f0 ingress prio 1 protocol ppp_ses \
>       flower \
>         pppoe_sid 12 \
>         ppp_proto ip \
>       action drop
> 
> Note that only PPPoE Session is supported.
> 
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
> v3: revert byte order changes in is_ppp_proto_supported from previous 
>     version, add kernel-doc for is_ppp_proto_supported
> v2: use ntohs instead of htons in is_ppp_proto_supported
> 
>  include/net/flow_dissector.h | 11 ++++++++
>  net/core/flow_dissector.c    | 55 ++++++++++++++++++++++++++++++++----
>  2 files changed, 60 insertions(+), 6 deletions(-)
> 
> diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> index a4c6057c7097..8ff40c7c3f1c 100644
> --- a/include/net/flow_dissector.h
> +++ b/include/net/flow_dissector.h
> @@ -261,6 +261,16 @@ struct flow_dissector_key_num_of_vlans {
>  	u8 num_of_vlans;
>  };
>  
> +/**
> + * struct flow_dissector_key_pppoe:
> + * @session_id: pppoe session id
> + * @ppp_proto: ppp protocol
> + */
> +struct flow_dissector_key_pppoe {
> +	u16 session_id;
> +	__be16 ppp_proto;
> +};

Why isn't session_id __be16 too?

Also, I'm not sure I like mixing the PPPoE session ID and PPP protocol
fields in the same structure: they're part of two different protocols.
However, I can't anticipate any technical problem in doing so, and I
guess there's no easy way to let the flow dissector parse the PPP
header independently. So well, maybe we don't have choice...

>  enum flow_dissector_key_id {
>  	FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
>  	FLOW_DISSECTOR_KEY_BASIC, /* struct flow_dissector_key_basic */
> @@ -291,6 +301,7 @@ enum flow_dissector_key_id {
>  	FLOW_DISSECTOR_KEY_CT, /* struct flow_dissector_key_ct */
>  	FLOW_DISSECTOR_KEY_HASH, /* struct flow_dissector_key_hash */
>  	FLOW_DISSECTOR_KEY_NUM_OF_VLANS, /* struct flow_dissector_key_num_of_vlans */
> +	FLOW_DISSECTOR_KEY_PPPOE,  /* struct flow_dissector_key_pppoe */
>  
>  	FLOW_DISSECTOR_KEY_MAX,
>  };
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 6aee04f75e3e..42393af477a2 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -895,6 +895,39 @@ bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
>  	return result == BPF_OK;
>  }
>  
> +/**
> + * is_ppp_proto_supported - checks if inner PPP protocol should be dissected
> + * @proto: protocol type (PPP proto field)
> + */
> +static bool is_ppp_proto_supported(__be16 proto)
> +{
> +	switch (proto) {
> +	case htons(PPP_AT):
> +	case htons(PPP_IPX):
> +	case htons(PPP_VJC_COMP):
> +	case htons(PPP_VJC_UNCOMP):
> +	case htons(PPP_MP):
> +	case htons(PPP_COMPFRAG):
> +	case htons(PPP_COMP):
> +	case htons(PPP_MPLS_UC):
> +	case htons(PPP_MPLS_MC):
> +	case htons(PPP_IPCP):
> +	case htons(PPP_ATCP):
> +	case htons(PPP_IPXCP):
> +	case htons(PPP_IPV6CP):
> +	case htons(PPP_CCPFRAG):
> +	case htons(PPP_MPLSCP):
> +	case htons(PPP_LCP):
> +	case htons(PPP_PAP):
> +	case htons(PPP_LQR):
> +	case htons(PPP_CHAP):
> +	case htons(PPP_CBCP):
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
>  /**
>   * __skb_flow_dissect - extract the flow_keys struct and return it
>   * @net: associated network namespace, derived from @skb if NULL
> @@ -1221,19 +1254,29 @@ bool __skb_flow_dissect(const struct net *net,
>  		}
>  
>  		nhoff += PPPOE_SES_HLEN;
> -		switch (hdr->proto) {
> -		case htons(PPP_IP):
> +		if (hdr->proto == htons(PPP_IP)) {
>  			proto = htons(ETH_P_IP);
>  			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
> -			break;
> -		case htons(PPP_IPV6):
> +		} else if (hdr->proto == htons(PPP_IPV6)) {
>  			proto = htons(ETH_P_IPV6);
>  			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
> -			break;

1)
Looks like you could easily handle MPLS too. Did you skip it on
purpose? (not enough users to justify writing and maintaining
the code?).

I don't mean MPLS has to be supported; I'd just like to know if it was
considered.

2)
Also this whole test is a bit weak: the version, type and code fields
must have precise values for the PPPoE Session packet to be valid.
If either version or type is different than 1, then the packet
advertises a new version of the protocol that we don't know how to parse
(or most probably the packet was forged or corrupted). A non-zero code
is also invalid.

I know the code was already like this before your patch, but it's
probably better to fix it before implementing hardware offload.

3)
Finally, the PPP protocol could be compressed and stored in 1 byte
instead of 2. This case wasn't handled before your patch, but I think
that should be fixed too before implementing hardware offload.

> -		default:
> +		} else if (is_ppp_proto_supported(hdr->proto)) {
> +			fdret = FLOW_DISSECT_RET_OUT_GOOD;
> +		} else {
>  			fdret = FLOW_DISSECT_RET_OUT_BAD;
>  			break;
>  		}
> +
> +		if (dissector_uses_key(flow_dissector,
> +				       FLOW_DISSECTOR_KEY_PPPOE)) {
> +			struct flow_dissector_key_pppoe *key_pppoe;
> +
> +			key_pppoe = skb_flow_dissector_target(flow_dissector,
> +							      FLOW_DISSECTOR_KEY_PPPOE,
> +							      target_container);
> +			key_pppoe->session_id = ntohs(hdr->hdr.sid);
> +			key_pppoe->ppp_proto = hdr->proto;
> +		}
>  		break;
>  	}
>  	case htons(ETH_P_TIPC): {
> -- 
> 2.35.1
> 

