Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B1047FC4D
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 12:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236486AbhL0Lrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 06:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233644AbhL0Lri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 06:47:38 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437A2C06173E;
        Mon, 27 Dec 2021 03:47:38 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id q3so9164432pfs.7;
        Mon, 27 Dec 2021 03:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=G9iuBVZjT8vUmCjrkgGPpAr0bPP8S/6A2uyuP5TVG6k=;
        b=oBP0MUz/A04YrLV1RHVS9RrRij4wELPOWB7YyoZkLhB0LTLnTFlGJw3XZ2sg0g6DLa
         z8nAl3j140KJOF/z+KpoXwmP5wgw3YtDCX27s+cbp6hnLX1YQzRlAK5/tpPeBU2WfQqZ
         QeaEDETRGSwSELGWlKYECczbG4sdcjTEgiPvk1m5gJEoVYUbISSm5EJlOVwMtc2Xb39i
         6LLGQYhvyPhn27hveZeMhZ7orx/Wbb89EiFolomRc10xw8uj/DYbzuVPrIOOft1/BtbN
         wIBafK89Xuks69S+S0Lq0GI5J1Ps5pVYeEs9I32hbB11Rh5UTNAY1jXwT8dmZRvEZ0/E
         rncQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=G9iuBVZjT8vUmCjrkgGPpAr0bPP8S/6A2uyuP5TVG6k=;
        b=LgL3c3sI1YbTloVMczGhgomAoYNVLSRRtPbsDjNNfOs/ilFxHyPZj5Yz8kjCIBQQCj
         /cZhgRU5Erkx1N2RhlE48vRP1s8zakMbADH3v0Yu9ulsgWc5BH/NVKW9Fl2S8mhcazTy
         i0M5j9Nkf40RAyQQa2oToL9ynpO+AO272M1gVsD1BYiUAPPi2ZfrxpxPX7kd/KID3BSV
         UWBmsVgG2iofUQYVf42QM0/np66TJisFb7/RLcg/qxYNpaktG4bsSe0soCrtSv9tJZZn
         VsNUuSR82d4oaL1TaNinfRdatpw2EsBG9xIgJbt6q++J7IAQLbw0ie9sEIp5HVRoLVBT
         S2NA==
X-Gm-Message-State: AOAM533iKslDt6P2loLqoat37gM+ke9pXOsXcXttCUpN5uYlmbUNekQL
        bgpQ6eGpkkDiYl1ij+9Ddgc=
X-Google-Smtp-Source: ABdhPJxAQrBUDLOKsXFFEMt26ELGRaq1hWhDCymkbKV7dZ8bZXV+7b73tsWZJ0SlefyoNDp2HvwPgw==
X-Received: by 2002:a62:6497:0:b0:4ba:737c:8021 with SMTP id y145-20020a626497000000b004ba737c8021mr17590806pfb.18.1640605657834;
        Mon, 27 Dec 2021 03:47:37 -0800 (PST)
Received: from [192.168.255.10] ([203.205.141.115])
        by smtp.gmail.com with ESMTPSA id t21sm19107051pjq.9.2021.12.27.03.47.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Dec 2021 03:47:37 -0800 (PST)
Message-ID: <aebfbe2e-598e-ef57-2412-605aa15d29e4@gmail.com>
Date:   Mon, 27 Dec 2021 19:47:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH 1/2] libbpf: Use probe_name for legacy kprobe
Content-Language: en-US
To:     Qiang Wang <wangqiang.wq.frank@bytedance.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhouchengming@bytedance.com,
        songmuchun@bytedance.com, duanxiongchun@bytedance.com,
        shekairui@bytedance.com
References: <20211225083242.38498-1-wangqiang.wq.frank@bytedance.com>
From:   Hengqi Chen <hengqi.chen@gmail.com>
In-Reply-To: <20211225083242.38498-1-wangqiang.wq.frank@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/12/25 4:32 PM, Qiang Wang wrote:
> Fix a bug in commit 46ed5fc33db9, which wrongly used the
> func_name instead of probe_name to register legacy kprobe.
> 
> Fixes: 46ed5fc33db9 ("libbpf: Refactor and simplify legacy kprobe code")
> Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
> Signed-off-by: Qiang Wang <wangqiang.wq.frank@bytedance.com>
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
> ---
>  tools/lib/bpf/libbpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 7c74342bb668..b7d6c951fa09 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -9735,7 +9735,7 @@ bpf_program__attach_kprobe_opts(const struct bpf_program *prog,
>  		gen_kprobe_legacy_event_name(probe_name, sizeof(probe_name),
>  					     func_name, offset);
>  
> -		legacy_probe = strdup(func_name);
> +		legacy_probe = strdup(probe_name);
>  		if (!legacy_probe)
>  			return libbpf_err_ptr(-ENOMEM);
>  

Reviewed-by: Hengqi Chen <hengqi.chen@gmail.com>
Tested-by: Hengqi Chen <hengqi.chen@gmail.com>
