Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D210957B452
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 12:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbiGTKNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 06:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiGTKNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 06:13:52 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F17257216;
        Wed, 20 Jul 2022 03:13:51 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id n12so12582752wrc.8;
        Wed, 20 Jul 2022 03:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=MfV6mgLjqSvYm2RRUtM49X5eL3j9597vYOropcPDVEA=;
        b=WkZIlskWl6p5tANC0a09cCEttR42hf+Rnrdw2IveT64Xn6r1hoMHKy2Eg5et3crkGl
         TChUPNsR7Kj9Kfas3O8Kqkb9YQ4gtmtGbdI0pdi9vpBKp05L8fJOf9y6G1m/LHLk/fLO
         +t2wlLVS/62S2CMt+qagVwC+rXl2a3Ceb/yn/Q6QaYt2d6cJ4ckYVeduimBVfijJBbxJ
         KbDBGF3QT0qmej3iOPG1aGFK+P6mz1TaAz1gY/BKGAfbVWJYoCw0+6GOu7sfocfUVNc8
         Q/dUQ5vPXBuYX1BZC+/RGsm1UbOGvUCAkxnBzVUAPQ4dBr54H5vmSe+CbqP9p4rQeUXG
         SFZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MfV6mgLjqSvYm2RRUtM49X5eL3j9597vYOropcPDVEA=;
        b=jNiizv3y0WwpbkshqKZYIpCgDrQqEsq14NZPCBdM7DuHnBnMPIPFRoEgx4s3QEV8it
         VN0H1Z0rSWRQ2iLMFKhwSyuOT2dSmRW0Sx9fhvtNX/U3OhsNrn8SSiVH+6eHuaYHAqrF
         i2SdGbOrhJTXjv/B3BUu66BGhDqLORdaG4qI65aaCtrvNEr6SOpPU6BX4SkgG3pGQFuj
         hKK9FYJE4WcfjosrFg/Bg+GPfy6gbnKFcBQHNNDntPG/eGY5nCLi7XtPA9TmhNyBgucy
         y81ZrWno1JOxEf5XwREyLnPw4ziyE+hoJW8/RsULskSJFoNl4hGJ0vrUbgJ3QlhUA8QB
         by6Q==
X-Gm-Message-State: AJIora+nZMGLniKHy3jtTkYE3JQZVLmlnznoiau4WjAN6US1TSvYdGVc
        LBZ/yjOqLCppVctIUphf74g=
X-Google-Smtp-Source: AGRyM1tVv+YUrulb0SJtCvBQSt9xHX2vLAJnb60QwEUpL6HLktYZVe+oykrtaZwZbg8zO/2NA2szQQ==
X-Received: by 2002:a5d:598e:0:b0:21d:86b2:f35 with SMTP id n14-20020a5d598e000000b0021d86b20f35mr31220916wri.54.1658312030079;
        Wed, 20 Jul 2022 03:13:50 -0700 (PDT)
Received: from [10.0.0.4] ([37.170.95.122])
        by smtp.gmail.com with ESMTPSA id z14-20020a05600c220e00b003a2e7c13a3asm1842632wml.42.2022.07.20.03.13.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 03:13:49 -0700 (PDT)
Message-ID: <b2473419-c7e4-48e2-e6ab-ab3ef8f88800@gmail.com>
Date:   Wed, 20 Jul 2022 12:13:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] net-next: improve handling of ICMP_EXT_ECHO icmp type
Content-Language: en-US
To:     Mathias Lark <mathiaslark@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20220720082435.GA31932@debian>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220720082435.GA31932@debian>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/20/22 10:28, Mathias Lark wrote:
> Introduce a helper for icmp type checking - icmp_is_valid_type.
>
> There is a number of code paths handling ICMP packets. To check
> icmp type validity, some of those code paths perform the check
> `type <= NR_ICMP_TYPES`. Since the introduction of ICMP_EXT_ECHO
> and ICMP_EXT_ECHOREPLY (RFC 8335), this check is no longer correct.
>
> To fix this inconsistency and avoid further problems with future
> ICMP types, the patch inserts the icmp_is_valid type helper
> wherever it is required. The helper checks if the type is less than
> NR_ICMP_TYPES or is equal to ICMP_EXT_ECHO/REPLY.


It is not clear what is the nature of the inconsistency,

and if this patch needs to be backported to versions

after 5.13 (commit d329ea5bd884)

What happens if we do not backport this patch (if it is ever applied after

being reviewed)


>
> NR_ICMP_TYPES could theoretically be increased to ICMP_EXT_ECHOREPLY
> (43), but that would not make sense as types 19-41 are not used.
>
> Signed-off-by: Mathias Lark <mathias.lark@gmail.com>
> ---
>   include/linux/icmp.h                    | 4 ++++
>   net/ipv4/icmp.c                         | 8 +++-----
>   net/netfilter/nf_conntrack_proto_icmp.c | 4 +---
>   3 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/icmp.h b/include/linux/icmp.h
> index 0af4d210ee31..e979c80696b0 100644
> --- a/include/linux/icmp.h
> +++ b/include/linux/icmp.h
> @@ -36,6 +36,11 @@ static inline bool icmp_is_err(int type)
>   	return false;
>   }
>   
> +static inline bool icmp_is_valid_type(int type)
> +{
> +	return type <= NR_ICMP_TYPES || type == ICMP_EXT_ECHO || type == ICMP_EXT_ECHOREPLY;
> +}
> +
>   void ip_icmp_error_rfc4884(const struct sk_buff *skb,
>   			   struct sock_ee_data_rfc4884 *out,
>   			   int thlen, int off);
> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 236debd9fded..686f3133370f 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -273,7 +273,7 @@ EXPORT_SYMBOL(icmp_global_allow);
>   
>   static bool icmpv4_mask_allow(struct net *net, int type, int code)
>   {
> -	if (type > NR_ICMP_TYPES)
> +	if (!icmp_is_valid_type(type))
>   		return true;
>   

And later this function will trigger an overflow after your patch is 
applied,

because (1 << 42) is undefined, and sysctl_icmp_ratemask is 32 bit anyway...

if (!((1 << type) & net->ipv4.sysctl_icmp_ratemask))



>   	/* Don't limit PMTU discovery. */
> @@ -661,7 +661,7 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
>   			 *	Assume any unknown ICMP type is an error. This
>   			 *	isn't specified by the RFC, but think about it..
>   			 */
> -			if (*itp > NR_ICMP_TYPES ||
> +			if (!icmp_is_valid_type(*itp) ||
>   			    icmp_pointers[*itp].error)
>   				goto out;
>   		}
> @@ -1225,12 +1225,10 @@ int icmp_rcv(struct sk_buff *skb)
>   	}
>   
>   	/*
> -	 *	18 is the highest 'known' ICMP type. Anything else is a mystery
> -	 *
>   	 *	RFC 1122: 3.2.2  Unknown ICMP messages types MUST be silently
>   	 *		  discarded.
>   	 */
> -	if (icmph->type > NR_ICMP_TYPES) {
> +	if (!icmp_is_valid_type(icmph->type)) {
>   		reason = SKB_DROP_REASON_UNHANDLED_PROTO;
>   		goto error;
>   	}
> diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
> index b38b7164acd5..ba4462c393be 100644
> --- a/net/netfilter/nf_conntrack_proto_icmp.c
> +++ b/net/netfilter/nf_conntrack_proto_icmp.c
> @@ -225,12 +225,10 @@ int nf_conntrack_icmpv4_error(struct nf_conn *tmpl,
>   	}
>   
>   	/*
> -	 *	18 is the highest 'known' ICMP type. Anything else is a mystery
> -	 *
>   	 *	RFC 1122: 3.2.2  Unknown ICMP messages types MUST be silently
>   	 *		  discarded.
>   	 */
> -	if (icmph->type > NR_ICMP_TYPES) {
> +	if (!icmp_is_valid_type(icmph->type)) {
>   		icmp_error_log(skb, state, "invalid icmp type");
>   		return -NF_ACCEPT;
>   	}
