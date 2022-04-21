Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8D150A5C3
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 18:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiDUQdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 12:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390544AbiDUQdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 12:33:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B27B4BFF3
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 09:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650558472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TOtejBcNLZ5DcaXPXYAL05tigOBHQkfjxArCAlT0UcQ=;
        b=SqoKMMu2Fp/15qnFf10uxZeHYRx4GIOsKvGkkQ5GVZhlYBvlBFe+KnOvzfKahy6wqMBHPp
        iDVika23WxOgMUaQOsJ5TnhkAnLK8vDGIGPqMPC+qo0/wpuPUZ5eA9Bu7z53ZB6w7FVlSY
        8NQpFaoLHEViqo+oswN7sCzxaaTBTNg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-uNjqjcZrMcWIwrn28ZcBOA-1; Thu, 21 Apr 2022 12:27:51 -0400
X-MC-Unique: uNjqjcZrMcWIwrn28ZcBOA-1
Received: by mail-ej1-f71.google.com with SMTP id qa31-20020a170907869f00b006ef7a20fdc6so2766775ejc.5
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 09:27:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=TOtejBcNLZ5DcaXPXYAL05tigOBHQkfjxArCAlT0UcQ=;
        b=qXfv6eULm8uXCB4QalCBhIlXgxmMWEAH++6GG8afrVgY/RHRI7+ntsPp96SOs8kAZY
         DfE18yZII+sqWwt/qKzdtgcqOFVHqXe/9uOJ/2XMDGu6AdRQb873w2xJIqzbgjerpSk0
         mU4ROaf18IV5hhszhBWDzlOvc37l39UHcnd5oFUU+xg/3fRzCgcUE5OY3m0P0VfvFAiz
         eQSot0Hk2xCEaYd1NqDSDSlpq8x3bfxnYpf54iGAAccYaEIQrM5jUf9eXcd3GRInntYu
         ylFibfrdQTuA7wPwRBYLMGpCizAtLqXcGMItpVWt+x33R3cXM6/+1JoxCVUkUQGJ69tW
         jblw==
X-Gm-Message-State: AOAM530wStZSH7f4UNhZDCPOjplrsC/08TBGIA3/Q681s3G/8S7KQ72F
        6iuzBL3XbAY2w9KrFYIv6PSSA4WFXuSgSc3Md/3kKR6yBgoLjVJtnuAa7lSyTMWUkqMDJpitmlj
        3fQ2wNMY/dA/26808
X-Received: by 2002:a17:906:5cb:b0:6cf:954:d84d with SMTP id t11-20020a17090605cb00b006cf0954d84dmr330072ejt.560.1650558469831;
        Thu, 21 Apr 2022 09:27:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVXdHGccv+gnrvFUjA5eq0cPv81/PWP6CCf7Wg6ao1loaIbrfFS/VNN4FhXEhpiPKT4AxYPg==
X-Received: by 2002:a17:906:5cb:b0:6cf:954:d84d with SMTP id t11-20020a17090605cb00b006cf0954d84dmr330042ejt.560.1650558469574;
        Thu, 21 Apr 2022 09:27:49 -0700 (PDT)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id r3-20020aa7cb83000000b0041b573e2654sm11582246edt.94.2022.04.21.09.27.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 09:27:49 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <f1417959-4b0d-7c33-4b2b-08989bb86b23@redhat.com>
Date:   Thu, 21 Apr 2022 18:27:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, netdev <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>
Subject: Re: Accessing XDP packet memory from the end
Content-Language: en-US
To:     Larysa Zaremba <larysa.zaremba@intel.com>,
        bpf <bpf@vger.kernel.org>
References: <20220421155620.81048-1-larysa.zaremba@intel.com>
In-Reply-To: <20220421155620.81048-1-larysa.zaremba@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21/04/2022 17.56, Larysa Zaremba wrote:
> Dear all,
> Our team has encountered a need of accessing data_meta in a following way:
> 
> int xdp_meta_prog(struct xdp_md *ctx)
> {
> 	void *data_meta_ptr = (void *)(long)ctx->data_meta;
> 	void *data_end = (void *)(long)ctx->data_end;
> 	void *data = (void *)(long)ctx->data;
> 	u64 data_size = sizeof(u32);
> 	u32 magic_meta;
> 	u8 offset;
> 
> 	offset = (u8)((s64)data - (s64)data_meta_ptr);

I'm not sure the verifier can handle this 'offset' calc. As it cannot
statically know the sized based on this statement. Maybe this is not the
issue.

> 	if (offset < data_size) {
> 		bpf_printk("invalid offset: %ld\n", offset);
> 		return XDP_DROP;
> 	}
> 
> 	data_meta_ptr += offset;
> 	data_meta_ptr -= data_size;
> 
> 	if (data_meta_ptr + data_size > data) {
> 		return XDP_DROP;
> 	}
> 		
> 	magic_meta = *((u32 *)data);
> 	bpf_printk("Magic: %d\n", magic_meta);
> 	return XDP_PASS;
> }
> 
> Unfortunately, verifier claims this code attempts to access packet with
> an offset of -2 (a constant part) and negative offset is generally forbidden.

Are you forgetting to mention:
  - Have you modified the NIC driver to adjust data_meta pointer and 
provide info in this area?

p.s. this is exactly what I'm also working towards[1], so I'll be happy
to collaborate.  I'm missing the driver code, as link[1] is focused on
decoding BTF data_meta area in userspace for AF_XDP.

[1] 
https://github.com/xdp-project/bpf-examples/tree/master/AF_XDP-interaction

> For now we have 2 solutions, one is using bpf_xdp_adjust_meta(),
> which is pretty good, but not ideal for the hot path.
> The second one is the patch at the end.
> 

Are you saying, verifier cannot handle that driver changed data_meta 
pointer and provided info there (without calling bpf_xdp_adjust_meta)?


> Do you see any other way of accessing memory from the end of data_meta/data?
> What do you think about both suggested solutions?
> 
> Best regards,
> Larysa Zaremba
> 
> ---
> 
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3576,8 +3576,11 @@ static int check_packet_access(struct bpf_verifier_env *env, u32 regno, int off,
>   	}
>   
>   	err = reg->range < 0 ? -EINVAL :
> -	      __check_mem_access(env, regno, off, size, reg->range,
> -				 zero_size_allowed);
> +	      __check_mem_access(env, regno, off + reg->smin_value, size,
> +				 reg->range + reg->smin_value, zero_size_allowed);
> +	err = err ? :
> +	      __check_mem_access(env, regno, off + reg->umax_value, size,
> +				 reg->range + reg->umax_value, zero_size_allowed);
>   	if (err) {
>   		verbose(env, "R%d offset is outside of the packet\n", regno);
>   		return err;
> 

