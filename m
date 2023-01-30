Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3CFD681612
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237178AbjA3QMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237196AbjA3QMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:12:44 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2938942BF0
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:12:39 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id l7so3430111ilf.0
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ghoRgfFqMCsRQPOK6Z87rokxeBUN/IZ6P29KfrQWstc=;
        b=e5IZ9do1pfD6MUrNQcUKjhTDYhpG+gdXhD1LR6dKlzH811ohbZEAJMr13jaeF+ohcE
         l0aNjghOjj1QffLtdPrX9lkSjrfE6XSu0mmOvdgzkdtfvBX5p0xJq2/DJFdxzHRO44fN
         r45c95qg8Lj8i6rtaRiM8uwHDQ7Wb9/Ja/HfI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ghoRgfFqMCsRQPOK6Z87rokxeBUN/IZ6P29KfrQWstc=;
        b=LfpWDB9GcntH7FRVKl7tWp+qTxvl9P/WZT47Nv9yZC8vl36nhFHym1I7B5XpWV8HIT
         DYZsigH4hzQc0+yz99s7KySD5RV3L080MLuD8R6bgtd19Mb6Ly0lvX9hrXJux9WeRWir
         ULMQByIJ+4A65m7nre4cf2V60uJvaljk0War7f/Uf1KDaG5wRnIh6DrS4LLIYZBqXwI9
         Rm8xFODq0LG5siKgdOq8PZpskfLm+yyZrziez7QKEllP6qBbVhSHKGYgdmSsrh43G0FD
         weJzSNrt8zwyx4fNjb8IvrcrWeiUjpgsQ8ylICgS43M5v9a4lJC+w9ECoXkx2gDAvd45
         c4qA==
X-Gm-Message-State: AO0yUKVQiNVNnWdfCickTSIdPYoiDwJN7wnX0Ql3soYnCLmoRUYtLW9u
        vJEsxx3f3vTYFI9dl59oKMVYVw==
X-Google-Smtp-Source: AK7set/Qlfq1pQGWZOK81YRqIs6hOJ+QifenEqB0RrybDWb85kQCHFUi96YlZSmf54OF7eCNuGqYrw==
X-Received: by 2002:a05:6e02:1a46:b0:310:ecea:b488 with SMTP id u6-20020a056e021a4600b00310eceab488mr988065ilv.3.1675095158488;
        Mon, 30 Jan 2023 08:12:38 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id v16-20020a056638009000b003ab21c8fa84sm3599666jao.121.2023.01.30.08.12.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 08:12:37 -0800 (PST)
Message-ID: <4defb04e-ddcb-b344-6e9f-35023dee0d2a@linuxfoundation.org>
Date:   Mon, 30 Jan 2023 09:12:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 02/34] selftests: bpf: Fix incorrect kernel headers search
 path
Content-Language: en-US
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
 <20230127135755.79929-3-mathieu.desnoyers@efficios.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230127135755.79929-3-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/23 06:57, Mathieu Desnoyers wrote:
> Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
> building against kernel headers from the build environment in scenarios
> where kernel headers are installed into a specific output directory
> (O=...).
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: linux-kselftest@vger.kernel.org
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: <stable@vger.kernel.org>    [5.18+]
> ---
>   tools/testing/selftests/bpf/Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index c22c43bbee19..6998c816afef 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -327,7 +327,7 @@ endif
>   CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
>   BPF_CFLAGS = -g -Werror -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN) 		\
>   	     -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR)			\
> -	     -I$(abspath $(OUTPUT)/../usr/include)
> +	     $(KHDR_INCLUDES)
>   
>   CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
>   	       -Wno-compare-distinct-pointer-types



Adding bpf maintainers - bpf patches usually go through bpf tree.

Acked-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
