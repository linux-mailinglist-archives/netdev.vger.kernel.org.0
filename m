Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68BC4F87FE
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 21:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiDGTZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 15:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiDGTZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 15:25:16 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B49270851
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 12:23:13 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id 125so8011353iov.10
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 12:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l8OgFspqIU7b4vxeuPh92V4JMHLE7mkjNVSAXOwkoiI=;
        b=hqEsqkdUEZnH1z3sA9zbHCvR08eMANE+TcmOmjbDqr6CSsj75T6hADaySzUCuq0SeM
         w8EgXroBrA+8AiQz6o5psyA0BnEiA5dPpuNR5VWR5JMeOkqZYfSeU9xOJDozQ/6B7iTE
         EQEw0P1idXPRoOOjCOI0PDLVMOiRJSlqTlSm8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l8OgFspqIU7b4vxeuPh92V4JMHLE7mkjNVSAXOwkoiI=;
        b=lRSXDMVm8aXjsHpeiHvhjeKl38Td1dEeE7/WTcMOGLQu/uGWs+cIMuMrOueBgJbDrK
         xldf/pd60apFBBz1j8hZb8Nw+tRN59KsLAKIgBhFbeoZMwJrKH7GvIPXCjZJGvApPaC3
         VnXIKetBXUZdddh15dmKUP2McsAqzb5vNt1HtWezT0k7VJ2LSdEmLWrXPFwmjC/axKAh
         jDjvfaq/yoCNWxRNJkLGNyu0vfdeDHtvsJKeoKlSE8KSEdnStRrlzHmQQq9x5bBKShfz
         PRFnUk3SMEWDcNLz/aPEzJvooBxUTLZ6uZ1Sv+Si8paHNOrZHD2HMu5lyxf2n1QzcD1Z
         bXhw==
X-Gm-Message-State: AOAM531EsehGFNXALAx3k3CS9re43myzYv8mmLdB7ak3KQR1lu+fGmHj
        FzyIq2Fc9r70kNKpSJ7d86zElw==
X-Google-Smtp-Source: ABdhPJxo55dq2+4K1HsfVCjcmhVHiDxQKD4sjTU1sAei6R98e/vSm8ep5Z2aHOSWZ1QeDYi08Ztk2w==
X-Received: by 2002:a05:6602:490:b0:638:c8ed:1e38 with SMTP id y16-20020a056602049000b00638c8ed1e38mr6848815iov.202.1649359392707;
        Thu, 07 Apr 2022 12:23:12 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id i12-20020a056e020ecc00b002ca53aba365sm5885794ilk.64.2022.04.07.12.23.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 12:23:11 -0700 (PDT)
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix return value checks in
 perf_event_stackmap.c
To:     Yuntao Wang <ytcoode@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Hengqi Chen <hengqi.chen@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220407153814.104914-1-ytcoode@gmail.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <7ac36fbe-aa44-9311-320b-1e953c29a3c4@linuxfoundation.org>
Date:   Thu, 7 Apr 2022 13:23:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220407153814.104914-1-ytcoode@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/22 9:38 AM, Yuntao Wang wrote:
> The bpf_get_stackid() function may also return 0 on success.

Can you add couple of sentences to describe what this patch
does? bpf_get_stackid() may also return doesn't really say
anything about why this patch is needed.

> 
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
>   tools/testing/selftests/bpf/progs/perf_event_stackmap.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/perf_event_stackmap.c b/tools/testing/selftests/bpf/progs/perf_event_stackmap.c
> index b3fcb5274ee0..f793280a3238 100644
> --- a/tools/testing/selftests/bpf/progs/perf_event_stackmap.c
> +++ b/tools/testing/selftests/bpf/progs/perf_event_stackmap.c
> @@ -35,10 +35,10 @@ int oncpu(void *ctx)
>   	long val;
>   
>   	val = bpf_get_stackid(ctx, &stackmap, 0);
> -	if (val > 0)
> +	if (val >= 0)
>   		stackid_kernel = 2;
>   	val = bpf_get_stackid(ctx, &stackmap, BPF_F_USER_STACK);
> -	if (val > 0)
> +	if (val >= 0)
>   		stackid_user = 2;
>   
>   	trace = bpf_map_lookup_elem(&stackdata_map, &key);
> 
Linux 5.18-rc1 shows a couple of more bpf_get_stackid() in this function.
Removed in bpf-next - I assume.

The change is good. I would like to see it explained better in the
commit log.

With the commit log fixed to explain why this change is needed and
what happens if val equals to 0 condition isn't checked:

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
