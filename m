Return-Path: <netdev+bounces-2711-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F38D57032B0
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:18:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEC8C281418
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:18:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5880EE57C;
	Mon, 15 May 2023 16:17:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46794C8ED
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 16:17:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E643E2105
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684167427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y2n8nonK1QjGxCr0VUr93GpzjyMzxVkptj6zYuPWAuE=;
	b=Qd8WNMtV9wwf4KSPSWrL4pAJKCyENXhaLIAgMRv8fHgjRHA++hKhpGcOFkn9ZANOJrUAwT
	6QdTAI25rJOfdSV52fWpKD9/ghxIodp2Oiv4UBZ0ORk/mbWsw4gN5KAV68bqMZ5vCmrtRg
	blf3hEv6OJNf9CoifL5AA5MqAOWrYlk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-490-0sT8FPqQONuQRJ98FQFRig-1; Mon, 15 May 2023 12:17:06 -0400
X-MC-Unique: 0sT8FPqQONuQRJ98FQFRig-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-510526d2a5fso8456539a12.0
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:17:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684167425; x=1686759425;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y2n8nonK1QjGxCr0VUr93GpzjyMzxVkptj6zYuPWAuE=;
        b=Bn+CAHTFtir8e8MJE0RvPDhbKQG0AfOcSDT9RA+sZXvOjKOiVrjDS517xCuzEpgKsZ
         OKkRuLC96oE29Sa+E4r8s7Hn8uRkrUpJ3EkvviiNITHv2bkQuqzXVtFmFblcGvAGvpfT
         j9zGPGHRKo+DPmYhYmFW18wkcGgABJX2Hoqfwcol2uYgAh8WxqZeqcQjksRfUSfnv9NG
         UnBhrUadmrbxhurd5sOVRKOySmiG1PuV8qW/lYcFdbG7nl2tWmedfMTXfUWMhzeM6JsC
         xoWCKfpxxLa0SEcdkvgs/wZ7Q7278opD8k/PaHoiVjMhkDrJdVvCHaCgdutXvLfaLeeq
         A1fA==
X-Gm-Message-State: AC+VfDxTOS7aoIM4kVsMKLAe0tn/aB/q2C5v1EwDR9lkE4wrJz/NvV0P
	ViUC4qDvJ1fa8H0Z24rysdIhFaFQ2honbILN54u6V0jMcSgoLX3FQYvwfSZF4d7Y9Nmc3v1v1ib
	5Nf2gKRfuGoii1kUH
X-Received: by 2002:a17:907:8a08:b0:969:2df9:a0dd with SMTP id sc8-20020a1709078a0800b009692df9a0ddmr24600322ejc.25.1684167425419;
        Mon, 15 May 2023 09:17:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6RQlKd2/JfsFteQEmuUPf/8L4dZ5P2zo1ST2B53RtXrhApGfHpCM2SRHnGguT14dpugsCwvw==
X-Received: by 2002:a17:907:8a08:b0:969:2df9:a0dd with SMTP id sc8-20020a1709078a0800b009692df9a0ddmr24600277ejc.25.1684167425043;
        Mon, 15 May 2023 09:17:05 -0700 (PDT)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id rq12-20020a17090788cc00b0094f0f0de1bcsm9444386ejc.200.2023.05.15.09.17.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 09:17:04 -0700 (PDT)
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <ee1ad4f2-34ab-4377-14d5-532cb0687180@redhat.com>
Date: Mon, 15 May 2023 18:17:02 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Cc: brouer@redhat.com, Stanislav Fomichev <sdf@google.com>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>,
 KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
 Jesse Brandeburg <jesse.brandeburg@intel.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>,
 Anatoly Burakov <anatoly.burakov@intel.com>,
 Alexander Lobakin <alexandr.lobakin@intel.com>,
 Magnus Karlsson <magnus.karlsson@gmail.com>,
 Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
 netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
 linux-kernel@vger.kernel.org,
 Aleksander Lobakin <aleksander.lobakin@intel.com>
Subject: Re: [PATCH RESEND bpf-next 14/15] net, xdp: allow metadata > 32
Content-Language: en-US
To: Larysa Zaremba <larysa.zaremba@intel.com>, bpf@vger.kernel.org
References: <20230512152607.992209-1-larysa.zaremba@intel.com>
 <20230512152607.992209-15-larysa.zaremba@intel.com>
In-Reply-To: <20230512152607.992209-15-larysa.zaremba@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 12/05/2023 17.26, Larysa Zaremba wrote:
> From: Aleksander Lobakin <aleksander.lobakin@intel.com>
> 
> When using XDP hints, metadata sometimes has to be much bigger
> than 32 bytes. Relax the restriction, allow metadata larger than 32 bytes
> and make __skb_metadata_differs() work with bigger lengths.
> 
> Now size of metadata is only limited by the fact it is stored as u8
> in skb_shared_info, so maximum possible value is 255. 

I'm confused, IIRC the metadata area isn't stored "in skb_shared_info".
The maximum possible size is limited by the XDP headroom, which is also
shared/limited with/by xdp_frame.  I must be reading the sentence wrong,
somehow.

> Other important
> conditions, such as having enough space for xdp_frame building, are already
> checked in bpf_xdp_adjust_meta().
> 
> The requirement of having its length aligned to 4 bytes is still
> valid.
> 
> Signed-off-by: Aleksander Lobakin <aleksander.lobakin@intel.com>
> Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
> ---
>   include/linux/skbuff.h | 13 ++++++++-----
>   include/net/xdp.h      |  7 ++++++-
>   2 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 8ddb4af1a501..afcd372aecdf 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -4219,10 +4219,13 @@ static inline bool __skb_metadata_differs(const struct sk_buff *skb_a,
>   {
>   	const void *a = skb_metadata_end(skb_a);
>   	const void *b = skb_metadata_end(skb_b);
> -	/* Using more efficient varaiant than plain call to memcmp(). */
> -#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
>   	u64 diffs = 0;
>   
> +	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
> +	    BITS_PER_LONG != 64)
> +		goto slow;
> +
> +	/* Using more efficient variant than plain call to memcmp(). */
>   	switch (meta_len) {
>   #define __it(x, op) (x -= sizeof(u##op))
>   #define __it_diff(a, b, op) (*(u##op *)__it(a, op)) ^ (*(u##op *)__it(b, op))
> @@ -4242,11 +4245,11 @@ static inline bool __skb_metadata_differs(const struct sk_buff *skb_a,
>   		fallthrough;
>   	case  4: diffs |= __it_diff(a, b, 32);
>   		break;
> +	default:
> +slow:
> +		return memcmp(a - meta_len, b - meta_len, meta_len);
>   	}
>   	return diffs;
> -#else
> -	return memcmp(a - meta_len, b - meta_len, meta_len);
> -#endif
>   }
>   
>   static inline bool skb_metadata_differs(const struct sk_buff *skb_a,
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 0fbd25616241..f48723250c7c 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -370,7 +370,12 @@ xdp_data_meta_unsupported(const struct xdp_buff *xdp)
>   
>   static inline bool xdp_metalen_invalid(unsigned long metalen)
>   {
> -	return (metalen & (sizeof(__u32) - 1)) || (metalen > 32);
> +	typeof(metalen) meta_max;
> +
> +	meta_max = type_max(typeof_member(struct skb_shared_info, meta_len));
> +	BUILD_BUG_ON(!__builtin_constant_p(meta_max));
> +
> +	return !IS_ALIGNED(metalen, sizeof(u32)) || metalen > meta_max;
>   }
>   
>   struct xdp_attachment_info {


