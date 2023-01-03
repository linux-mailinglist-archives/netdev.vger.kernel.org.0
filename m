Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D18F65C058
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 13:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237411AbjACMzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 07:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237508AbjACMzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 07:55:43 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BD110FFC;
        Tue,  3 Jan 2023 04:55:28 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id r26so38439656edc.5;
        Tue, 03 Jan 2023 04:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tZhfrGshmrL2XjyGozj/L+y57B2HE5giBujkZ+UBatQ=;
        b=EHLVSHUXZje52gcBgeyRJJomOk68pUKnrJyutjXq6GglFWBol39uXidiqqvvqKqLVy
         HTsVgcJg6ixKOQ9TJQrNDrfeIyNbPgTCNY9ZIHFnNrYdLDPirCZAMZ37rZM3IBVvPw0A
         VAsoqy41SE6d2jhNMmdFIhqtYKKrM7E4szHzUudBRQLTrylYnGuS1tv0ZkqZf6hHwxUe
         HFfDi2OuL16h4Y3dWDIcp1eLpZs2j0ywEhRhCCzyFJ/Loxl4SOT4GxJmMG9BXy5eP+lf
         5/QRKX/+519Q/OclVK7vIu60lc8Ma9Y99g9Wrhe2KctQ+pZ4KWDfEbxSckWOqmnxTjQq
         xkgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tZhfrGshmrL2XjyGozj/L+y57B2HE5giBujkZ+UBatQ=;
        b=jITfVrFN9FEsYa7W4ygftI2z3dpCCe0ePzv0qtiAVCxZPIaeHkIe+PDgzkzOZum70f
         3Bbls/lEE1A+T/JnRoA7M5WDaDlz/HVjNZhCG0WhAC/TettUYkKao15fWvFSRaGYWini
         whBsixo/QUIuNySmUQZGCo8Rqay63ksf5LaVqNheXiZLWAvHOnOMRMU6Tm68fLoYDoRg
         h73IS7m9V6/0Q9g2hfJUH6V6BH3gi+lGFNgYGFZ+9bSHrkAnEPWR3Nd6BNpxBK5qHrnz
         K8QZi8ahXwHeIcHeEG9yhuHvM77wG7smlW7YqocvAL5EzImq5UK91jX8SSUijJHs62BW
         mr2w==
X-Gm-Message-State: AFqh2kohD0CBVcjvf+0RIlJsoshYjbXkt85olCs/6WcvxiVJIUxKr2Ao
        XBYG9gcgRlN6dUFhieB2ugs=
X-Google-Smtp-Source: AMrXdXti5XLFJjMZEMjQdQPbnWJWr8YLpqEFcuIcGyNRs9GtVvpKpc7evg9537XQJjCk7EbDB1if1Q==
X-Received: by 2002:aa7:dd13:0:b0:461:e85e:39c7 with SMTP id i19-20020aa7dd13000000b00461e85e39c7mr34497789edv.1.1672750526787;
        Tue, 03 Jan 2023 04:55:26 -0800 (PST)
Received: from [10.158.37.55] ([193.47.165.251])
        by smtp.gmail.com with ESMTPSA id lc14-20020a170906f90e00b0084cd6343a1dsm1583570ejb.40.2023.01.03.04.55.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 04:55:26 -0800 (PST)
Message-ID: <40fd78fc-2bb1-8eed-0b64-55cb3db71664@gmail.com>
Date:   Tue, 3 Jan 2023 14:55:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v2] samples/bpf: fixup some tools to be able to
 support xdp multibuffer
Content-Language: en-US
To:     Andy Gospodarek <andrew.gospodarek@broadcom.com>, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, toke@redhat.com, lorenzo.bianconi@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Andy Gospodarek <gospo@broadcom.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, gal@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>, tariqt@nvidia.com
References: <20220621175402.35327-1-gospo@broadcom.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220621175402.35327-1-gospo@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21/06/2022 20:54, Andy Gospodarek wrote:
> This changes the section name for the bpf program embedded in these
> files to "xdp.frags" to allow the programs to be loaded on drivers that
> are using an MTU greater than PAGE_SIZE.  Rather than directly accessing
> the buffers, the packet data is now accessed via xdp helper functions to
> provide an example for those who may need to write more complex
> programs.
> 
> v2: remove new unnecessary variable
> 

Hi,

I'm trying to understand if there are any assumptions/requirements on 
the length of the xdp_buf linear part when passed to XDP multi-buf programs?
Can the linear part be empty, with all data residing in the fragments? 
Is it valid?

Per the proposed pattern below (calling bpf_xdp_load_bytes() to memcpy 
packet data into a local buffer), no such assumption is required, and an 
xdp_buf created by the driver with an empty linear part is valid.

However, in the _xdp_tx_iptunnel example program, it fails (returns 
XDP_DROP) in case the headers are not in the linear part.

Regards,
Tariq

> Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>   samples/bpf/xdp1_kern.c            | 11 ++++++++---
>   samples/bpf/xdp2_kern.c            | 11 ++++++++---
>   samples/bpf/xdp_tx_iptunnel_kern.c |  2 +-
>   3 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/samples/bpf/xdp1_kern.c b/samples/bpf/xdp1_kern.c
> index f0c5d95084de..0a5c704badd0 100644
> --- a/samples/bpf/xdp1_kern.c
> +++ b/samples/bpf/xdp1_kern.c
> @@ -39,11 +39,13 @@ static int parse_ipv6(void *data, u64 nh_off, void *data_end)
>   	return ip6h->nexthdr;
>   }
>   
> -SEC("xdp1")
> +#define XDPBUFSIZE	64
> +SEC("xdp.frags")
>   int xdp_prog1(struct xdp_md *ctx)
>   {
> -	void *data_end = (void *)(long)ctx->data_end;
> -	void *data = (void *)(long)ctx->data;
> +	__u8 pkt[XDPBUFSIZE] = {};
> +	void *data_end = &pkt[XDPBUFSIZE-1];
> +	void *data = pkt;
>   	struct ethhdr *eth = data;
>   	int rc = XDP_DROP;
>   	long *value;
> @@ -51,6 +53,9 @@ int xdp_prog1(struct xdp_md *ctx)
>   	u64 nh_off;
>   	u32 ipproto;
>   
> +	if (bpf_xdp_load_bytes(ctx, 0, pkt, sizeof(pkt)))
> +		return rc;
> +
>   	nh_off = sizeof(*eth);
>   	if (data + nh_off > data_end)
>   		return rc;
> diff --git a/samples/bpf/xdp2_kern.c b/samples/bpf/xdp2_kern.c
> index d8a64ab077b0..3332ba6bb95f 100644
> --- a/samples/bpf/xdp2_kern.c
> +++ b/samples/bpf/xdp2_kern.c
> @@ -55,11 +55,13 @@ static int parse_ipv6(void *data, u64 nh_off, void *data_end)
>   	return ip6h->nexthdr;
>   }
>   
> -SEC("xdp1")
> +#define XDPBUFSIZE	64
> +SEC("xdp.frags")
>   int xdp_prog1(struct xdp_md *ctx)
>   {
> -	void *data_end = (void *)(long)ctx->data_end;
> -	void *data = (void *)(long)ctx->data;
> +	__u8 pkt[XDPBUFSIZE] = {};
> +	void *data_end = &pkt[XDPBUFSIZE-1];
> +	void *data = pkt;
>   	struct ethhdr *eth = data;
>   	int rc = XDP_DROP;
>   	long *value;
> @@ -67,6 +69,9 @@ int xdp_prog1(struct xdp_md *ctx)
>   	u64 nh_off;
>   	u32 ipproto;
>   
> +	if (bpf_xdp_load_bytes(ctx, 0, pkt, sizeof(pkt)))
> +		return rc;
> +
>   	nh_off = sizeof(*eth);
>   	if (data + nh_off > data_end)
>   		return rc;
> diff --git a/samples/bpf/xdp_tx_iptunnel_kern.c b/samples/bpf/xdp_tx_iptunnel_kern.c
> index 575d57e4b8d6..0e2bca3a3fff 100644
> --- a/samples/bpf/xdp_tx_iptunnel_kern.c
> +++ b/samples/bpf/xdp_tx_iptunnel_kern.c
> @@ -212,7 +212,7 @@ static __always_inline int handle_ipv6(struct xdp_md *xdp)
>   	return XDP_TX;
>   }
>   
> -SEC("xdp_tx_iptunnel")
> +SEC("xdp.frags")
>   int _xdp_tx_iptunnel(struct xdp_md *xdp)
>   {
>   	void *data_end = (void *)(long)xdp->data_end;
