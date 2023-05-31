Return-Path: <netdev+bounces-6706-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A29A2717801
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:24:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BADA281376
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:23:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48600A940;
	Wed, 31 May 2023 07:23:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3111F944F;
	Wed, 31 May 2023 07:23:55 +0000 (UTC)
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08803E4F;
	Wed, 31 May 2023 00:23:47 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-96fab30d1e1so135467966b.0;
        Wed, 31 May 2023 00:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685517825; x=1688109825;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OxuhWIhRkmXBnBpNxVOW7a5ND9G8pijrGvNA5/AnA5w=;
        b=T7BuBG3TNKWFHdYevDkpaM8LNj6redbhdUeQ9dDldGp8DBzYa6YH6TBm95r8kECl+S
         ciHSaQTnrhdZxO/p9u0viSr28q+47qr7RJpSkGLuYE0KY86NjUd6QPYpBZ4dmbmbMdb9
         NdHao76BFiKJW3EFFzvQFwF8Byu2Nyk7qeeVAlRGkDkOXjmnAqTqpcS4ZTKuidVjhuxS
         IzXTqTz0+W/YtLiIMQrgYVgxvlBReL1RSqVhJ1315fPhYcSqvPM/4tgS0AiZ44iQK1zZ
         NeAKOptct6oEa8vVMnx2YuQ5TJ7Q2cTMBGaBCUu/fLa2+UMFskNczUn2lQ3/B+FDnVy4
         rTpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685517825; x=1688109825;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OxuhWIhRkmXBnBpNxVOW7a5ND9G8pijrGvNA5/AnA5w=;
        b=BUr4YDYchuNpuXCohnbXycroWIpaS+I/EzZhGWvhS8VvG+KowXMg7jVmBWBLmlDl8y
         C7+CUnlW/6Gkuk5Z7SVP4uin8tYWP7XPTeEFa1gejPkr5WYQ+RsQqO3YCnKL+660iK6l
         1xDoRfuQzk/9OEJNSwiyvOwG9LE1w9z2aviATzmLPMNjFRH/xQ6laeKiIsFOgJw5tMS2
         I82BuqVvGKZSUfW5sot0SgYgQfVYZUerjYceonm/pfPKHbkQhk2hPoJ1s1tOXo3tt083
         51WtMPyMVO7KYoBRS4/Ig89PldIshUJdZSTo2nwSt1mUvekvMjmsu5+dciaDtE/urHdU
         +voA==
X-Gm-Message-State: AC+VfDyBDmyBJCGsbN03cDJsg+WyJ10xvt45D9S/AaKDKtmvaMU+90hq
	34U098Tloa5O4tb60nNf/D4=
X-Google-Smtp-Source: ACHHUZ7eM+ZkDAG7UzhJcd7om1RhQbuZCtX4q7OrQUWJM7chnjle47rycsOpV256HT2Sd4dLb7WUcA==
X-Received: by 2002:a17:907:7da0:b0:96f:b40a:c85f with SMTP id oz32-20020a1709077da000b0096fb40ac85fmr12981671ejc.23.1685517825252;
        Wed, 31 May 2023 00:23:45 -0700 (PDT)
Received: from [192.168.0.107] ([77.124.85.177])
        by smtp.gmail.com with ESMTPSA id i13-20020a17090685cd00b0096f83b16ab1sm8485830ejy.136.2023.05.31.00.23.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 00:23:44 -0700 (PDT)
Message-ID: <948629b6-8607-9797-8897-7d3e0535fa7b@gmail.com>
Date: Wed, 31 May 2023 10:23:41 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH bpf-next] samples/bpf: xdp1 and xdp2 reduce XDPBUFSIZE to
 60
Content-Language: en-US
To: Jesper Dangaard Brouer <brouer@redhat.com>,
 Tariq Toukan <ttoukan.linux@gmail.com>,
 Daniel Borkmann <borkmann@iogearbox.net>, Alexei Starovoitov
 <ast@kernel.org>, Andrii Nakryiko <andrii.nakryiko@gmail.com>,
 bpf@vger.kernel.org
Cc: gal@nvidia.com, lorenzo@kernel.org, netdev@vger.kernel.org,
 andrew.gospodarek@broadcom.com, Tariq Toukan <tariqt@nvidia.com>
References: <168545704139.2996228.2516528552939485216.stgit@firesoul>
From: Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <168545704139.2996228.2516528552939485216.stgit@firesoul>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 30/05/2023 17:30, Jesper Dangaard Brouer wrote:
> Default samples/pktgen scripts send 60 byte packets as hardware
> adds 4-bytes FCS checksum, which fulfils minimum Ethernet 64 bytes
> frame size.
> 
> XDP layer will not necessary have access to the 4-bytes FCS checksum.
> 
> This leads to bpf_xdp_load_bytes() failing as it tries to copy
> 64-bytes from an XDP packet that only have 60-bytes available.
> 
> Fixes: 772251742262 ("samples/bpf: fixup some tools to be able to support xdp multibuffer")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   samples/bpf/xdp1_kern.c |    2 +-
>   samples/bpf/xdp2_kern.c |    2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/samples/bpf/xdp1_kern.c b/samples/bpf/xdp1_kern.c
> index 0a5c704badd0..d91f27cbcfa9 100644
> --- a/samples/bpf/xdp1_kern.c
> +++ b/samples/bpf/xdp1_kern.c
> @@ -39,7 +39,7 @@ static int parse_ipv6(void *data, u64 nh_off, void *data_end)
>   	return ip6h->nexthdr;
>   }
>   
> -#define XDPBUFSIZE	64
> +#define XDPBUFSIZE	60

Perf with the presence of load/store copies is far from being optimal..
Still, do we care if memcpy of 60 bytes performs worse than 64 (full 
cacheline)?
Maybe not really in this case, looking forward for the replacement of 
memcpy with the proper dyncptr API.

Other than that:
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>


>   SEC("xdp.frags")
>   int xdp_prog1(struct xdp_md *ctx)
>   {
> diff --git a/samples/bpf/xdp2_kern.c b/samples/bpf/xdp2_kern.c
> index 67804ecf7ce3..8bca674451ed 100644
> --- a/samples/bpf/xdp2_kern.c
> +++ b/samples/bpf/xdp2_kern.c
> @@ -55,7 +55,7 @@ static int parse_ipv6(void *data, u64 nh_off, void *data_end)
>   	return ip6h->nexthdr;
>   }
>   
> -#define XDPBUFSIZE	64
> +#define XDPBUFSIZE	60
>   SEC("xdp.frags")
>   int xdp_prog1(struct xdp_md *ctx)
>   {
> 
> 

