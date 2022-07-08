Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBA6F56C3AD
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239382AbiGHTFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 15:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiGHTFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 15:05:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9EA96252B2
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 12:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657307133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/LtUZ1p7iDStBuk6eZV+7te3JF5akZlDsTLYGSAakjo=;
        b=Hxn33yJsx+zv8cQ04eCOQvhNUBFLvAsPFzAGBARhEIgNZk32XAlEiQxYSWpeyzwiItNMJG
        /YXbRRYGTq3OFFkcIWVpImWGFaZNe9Le4Ni7pjQprkLO8NlvXymHNHZbs893pseFObuPJs
        FAtPgN5H8JZ+DEY1nwShks+r/yDyP54=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-113-aMPwdOFEN9WPfoVFQO-Mgg-1; Fri, 08 Jul 2022 15:05:32 -0400
X-MC-Unique: aMPwdOFEN9WPfoVFQO-Mgg-1
Received: by mail-wr1-f69.google.com with SMTP id q12-20020adfab0c000000b0021d6dcb51e8so2993104wrc.13
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 12:05:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/LtUZ1p7iDStBuk6eZV+7te3JF5akZlDsTLYGSAakjo=;
        b=i5h+ecDE09Tt5tn273ecrRPC+81hVj39lFri5zBc85Ka2oNHeKOLyAb1R/D4FmYu3O
         rbUndyTdNyz1wKS25IYuNInBGzuG/EL7JkhkjfrUZMSb5iOds4fyt6cLFTFu/OuBQ5SF
         xDUjdA9fD72Jr0QrQVbwzH2CyYfO3VN4dtbyVGMLQYVetSf+rJCZ8532n3NTxmMxWPpY
         asmb4IEutxxm6gZuWDgMyCejiZZqfT1QuTs9zNp74CT/+fiAxRK6L7cEJ3anelDbmdNg
         7sXKPGg4F4aLbdXuapr/b5R7C4do0vv7X/n5+9h+pERfF8Ivh+dw4lx55INBQCN8DUJ5
         LQTQ==
X-Gm-Message-State: AJIora8AY6uNQAb/fBrNieX7LZ8JPpOJYprikEA954SRWop9v8dcrTo6
        Wl4jbGqf4mbhOcSFK8pQ31Sk0gZRQnVgbg6D6dyXnigbHTPRCRgtURRH6nwJW3Sbjd21wJraUNE
        lDZpZgCYioPzjgJ/n
X-Received: by 2002:a05:600c:3505:b0:3a1:9fbb:4d59 with SMTP id h5-20020a05600c350500b003a19fbb4d59mr1363135wmq.165.1657307131320;
        Fri, 08 Jul 2022 12:05:31 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vkVsZBVD+BagsA8GvwTezhU7Tl9GrK9TwhOHHD1nXvIkwIe1fTwWJdE5d3QaektCCcP6hopg==
X-Received: by 2002:a05:600c:3505:b0:3a1:9fbb:4d59 with SMTP id h5-20020a05600c350500b003a19fbb4d59mr1363115wmq.165.1657307131065;
        Fri, 08 Jul 2022 12:05:31 -0700 (PDT)
Received: from debian.home (2a01cb058d1194004161f17a6a9ad508.ipv6.abo.wanadoo.fr. [2a01:cb05:8d11:9400:4161:f17a:6a9a:d508])
        by smtp.gmail.com with ESMTPSA id q8-20020adff508000000b0021d6d9c0bd9sm13191345wro.82.2022.07.08.12.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 12:05:30 -0700 (PDT)
Date:   Fri, 8 Jul 2022 21:05:28 +0200
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
Subject: Re: [RFC PATCH net-next v4 1/4] flow_dissector: Add PPPoE dissectors
Message-ID: <20220708190528.GB3166@debian.home>
References: <20220708122421.19309-1-marcin.szycik@linux.intel.com>
 <20220708122421.19309-2-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708122421.19309-2-marcin.szycik@linux.intel.com>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 08, 2022 at 02:24:18PM +0200, Marcin Szycik wrote:
> From: Wojciech Drewek <wojciech.drewek@intel.com>
> 
> Allow to dissect PPPoE specific fields which are:
> - session ID (16 bits)
> - ppp protocol (16 bits)
> - type (16 bits) - this is PPPoE ethertype, for now only
>   ETH_P_PPP_SES is supported, possible ETH_P_PPP_DISC
>   in the future
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
> v4:
>   * pppoe header validation
>   * added MPLS dissection
>   * added support for compressed ppp protocol field
>   * flow_dissector_key_pppoe::session_id stored in __be16
>   * new field: flow_dissector_key_pppoe::type
> v3: revert byte order changes in is_ppp_proto_supported from
>     previous version
> v2: ntohs instead of htons in is_ppp_proto_supported
> 
>  include/net/flow_dissector.h | 13 ++++++
>  net/core/flow_dissector.c    | 84 +++++++++++++++++++++++++++++++++---
>  2 files changed, 90 insertions(+), 7 deletions(-)
> 
> diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> index a4c6057c7097..af0d429b9a26 100644
> --- a/include/net/flow_dissector.h
> +++ b/include/net/flow_dissector.h
> @@ -261,6 +261,18 @@ struct flow_dissector_key_num_of_vlans {
>  	u8 num_of_vlans;
>  };
>  
> +/**
> + * struct flow_dissector_key_pppoe:
> + * @session_id: pppoe session id
> + * @ppp_proto: ppp protocol
> + * @type: pppoe eth type
> + */
> +struct flow_dissector_key_pppoe {
> +	__be16 session_id;
> +	__be16 ppp_proto;
> +	__be16 type;

I don't understand the need for the new 'type' field.

> +};
> +
>  enum flow_dissector_key_id {
>  	FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
>  	FLOW_DISSECTOR_KEY_BASIC, /* struct flow_dissector_key_basic */
> @@ -291,6 +303,7 @@ enum flow_dissector_key_id {
>  	FLOW_DISSECTOR_KEY_CT, /* struct flow_dissector_key_ct */
>  	FLOW_DISSECTOR_KEY_HASH, /* struct flow_dissector_key_hash */
>  	FLOW_DISSECTOR_KEY_NUM_OF_VLANS, /* struct flow_dissector_key_num_of_vlans */
> +	FLOW_DISSECTOR_KEY_PPPOE, /* struct flow_dissector_key_pppoe */
>  
>  	FLOW_DISSECTOR_KEY_MAX,
>  };
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 6aee04f75e3e..3a90219d2354 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -895,6 +895,42 @@ bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
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
> +static bool is_pppoe_ses_hdr_valid(struct pppoe_hdr hdr)
> +{
> +	return hdr.ver == 1 && hdr.type == 1 && hdr.code == 0;
> +}
> +
>  /**
>   * __skb_flow_dissect - extract the flow_keys struct and return it
>   * @net: associated network namespace, derived from @skb if NULL
> @@ -1214,26 +1250,60 @@ bool __skb_flow_dissect(const struct net *net,
>  			struct pppoe_hdr hdr;
>  			__be16 proto;
>  		} *hdr, _hdr;
> +		__be16 ppp_proto;
> +
>  		hdr = __skb_header_pointer(skb, nhoff, sizeof(_hdr), data, hlen, &_hdr);
>  		if (!hdr) {
>  			fdret = FLOW_DISSECT_RET_OUT_BAD;
>  			break;
>  		}
>  
> -		nhoff += PPPOE_SES_HLEN;
> -		switch (hdr->proto) {
> -		case htons(PPP_IP):
> +		if (!is_pppoe_ses_hdr_valid(hdr->hdr)) {
> +			fdret = FLOW_DISSECT_RET_OUT_BAD;
> +			break;
> +		}
> +
> +		/* least significant bit of the first byte
> +		 * indicates if protocol field was compressed
> +		 */
> +		if (hdr->proto & 1) {
> +			ppp_proto = hdr->proto << 8;

This is little endian specific code. We can't make such assumptions.

> +			nhoff += PPPOE_SES_HLEN - 1;
> +		} else {
> +			ppp_proto = hdr->proto;
> +			nhoff += PPPOE_SES_HLEN;
> +		}
> +
> +		if (ppp_proto == htons(PPP_IP)) {
>  			proto = htons(ETH_P_IP);
>  			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
> -			break;
> -		case htons(PPP_IPV6):
> +		} else if (ppp_proto == htons(PPP_IPV6)) {
>  			proto = htons(ETH_P_IPV6);
>  			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
> -			break;
> -		default:
> +		} else if (ppp_proto == htons(PPP_MPLS_UC)) {
> +			proto = htons(ETH_P_MPLS_UC);
> +			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
> +		} else if (ppp_proto == htons(PPP_MPLS_MC)) {
> +			proto = htons(ETH_P_MPLS_MC);
> +			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
> +		} else if (is_ppp_proto_supported(ppp_proto)) {
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
> +			key_pppoe->session_id = hdr->hdr.sid;
> +			key_pppoe->ppp_proto = ppp_proto;
> +			key_pppoe->type = htons(ETH_P_PPP_SES);
> +		}
>  		break;
>  	}
>  	case htons(ETH_P_TIPC): {
> -- 
> 2.35.1
> 

