Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32369593206
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiHOPgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbiHOPgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 11:36:05 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4461209C
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 08:36:04 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id s23so3998346wmj.4
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 08:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=aLIgBOFDINfwWT7sgtqg5VHJeqaHc1mZmgglPh0sAyY=;
        b=cyPux8RNKFujd9roQpwDZOASW6ijxYgslOXdJqm0R8g26Zi+cI2KkwRECN+52orxyE
         9Zajuq+yuut4empWdcY3rREB4/K16QGTjzy7oXSanZwPZ38kiaBtECuBaxHV2Al1ZfjB
         9et+JqHCutUlrmNuWXKYwzOKsF3lC7Ryr7L6uZDBCUs+HHVqp3bnojSOvkNOL+rrkXwG
         C3LlmbixIKyTCijnk4mDaUHQl+CbVxICM4rBfZ6rsMKiJfXTa67r1jTDXqq7EBiBlksa
         G3RQfHlT+XrmF8Xe3DpJE9Ki3cOeFnEwLboUEr2D94+0v9YwTYQCWzMuIj6/ZV7VTpIx
         LXjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=aLIgBOFDINfwWT7sgtqg5VHJeqaHc1mZmgglPh0sAyY=;
        b=NfT8YBr4ons06PE8r3mUxpGm/SXNiCzHbPIDtpRktF+euQyWy8QWsC7gRZMuFpniVd
         zjeT0UKMJ/kvDn/m+KINoWGCw0qiAqYTCVfLOyLklxNohCqcuVLjG/rmwkHe9Pmoh1I4
         zsDZPuFF3R/kSey5a1zl0KvCj/V7yMaoN24hcV4/0wNBnLFYMKN7hi9I/h0r6w6shJGU
         rimg4BZt6hiplXm/CPKM+gRrDofOMVyTDuqMwqJDCiqrL7vPtAmM7SlWx8Lcv+9rIlLg
         FEXjFM+ZhMYZhYBXBvMRg2myE8my6PTGbOACUFo8eKZHvZrbd0nANwoXrSFsz59RFRQa
         5deg==
X-Gm-Message-State: ACgBeo3kXn16lROH2MLRxcarFUjPB9FzsHhg/LUuBbGreBXCu647KsT9
        MClen2QVaCt02ajrVYbcpt6/Nw==
X-Google-Smtp-Source: AA6agR6xIRa3yxAc16EqQ9DGTpZo2oUf/GBOyk4W5fy5KqhiMZ4slGdnFP3TOOY7UKY3cY4CQipzug==
X-Received: by 2002:a05:600c:b4b:b0:3a5:b76e:1350 with SMTP id k11-20020a05600c0b4b00b003a5b76e1350mr10524905wmr.108.1660577762827;
        Mon, 15 Aug 2022 08:36:02 -0700 (PDT)
Received: from [192.168.178.32] ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id j3-20020a5d5643000000b0021f138e07acsm7689668wrw.35.2022.08.15.08.36.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 08:36:02 -0700 (PDT)
Message-ID: <a3c23cfe-061a-1722-8521-26e57b4b2cf4@isovalent.com>
Date:   Mon, 15 Aug 2022 16:36:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCHv2 bpf-next] libbpf: making bpf_prog_load() ignore name if
 kernel doesn't support
Content-Language: en-GB
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        bpf@vger.kernel.org
References: <20220813000936.6464-1-liuhangbin@gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20220813000936.6464-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/08/2022 01:09, Hangbin Liu wrote:
> Similar with commit 10b62d6a38f7 ("libbpf: Add names for auxiliary maps"),
> let's make bpf_prog_load() also ignore name if kernel doesn't support
> program name.
> 
> To achieve this, we need to call sys_bpf_prog_load() directly in
> probe_kern_prog_name() to avoid circular dependency. sys_bpf_prog_load()
> also need to be exported in the libbpf_internal.h file.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
> v2: move sys_bpf_prog_load definition to libbpf_internal.h. memset attr
>     to 0 specifically to aviod padding.
> ---
>  tools/lib/bpf/bpf.c             |  6 ++----
>  tools/lib/bpf/libbpf.c          | 12 ++++++++++--
>  tools/lib/bpf/libbpf_internal.h |  3 +++
>  3 files changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 6a96e665dc5d..575867d69496 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -84,9 +84,7 @@ static inline int sys_bpf_fd(enum bpf_cmd cmd, union bpf_attr *attr,
>  	return ensure_good_fd(fd);
>  }
>  
> -#define PROG_LOAD_ATTEMPTS 5
> -
> -static inline int sys_bpf_prog_load(union bpf_attr *attr, unsigned int size, int attempts)
> +int sys_bpf_prog_load(union bpf_attr *attr, unsigned int size, int attempts)
>  {
>  	int fd;
>  
> @@ -263,7 +261,7 @@ int bpf_prog_load(enum bpf_prog_type prog_type,
>  	attr.prog_ifindex = OPTS_GET(opts, prog_ifindex, 0);
>  	attr.kern_version = OPTS_GET(opts, kern_version, 0);
>  
> -	if (prog_name)
> +	if (prog_name && kernel_supports(NULL, FEAT_PROG_NAME))
>  		libbpf_strlcpy(attr.prog_name, prog_name, sizeof(attr.prog_name));
>  	attr.license = ptr_to_u64(license);
>  
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 3f01f5cd8a4c..4a351897bdcc 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4419,10 +4419,18 @@ static int probe_kern_prog_name(void)
>  		BPF_MOV64_IMM(BPF_REG_0, 0),
>  		BPF_EXIT_INSN(),
>  	};
> -	int ret, insn_cnt = ARRAY_SIZE(insns);
> +	union bpf_attr attr;
> +	int ret;
> +
> +	memset(&attr, 0, sizeof(attr));
> +	attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
> +	attr.license = ptr_to_u64("GPL");
> +	attr.insns = ptr_to_u64(insns);
> +	attr.insn_cnt = (__u32)ARRAY_SIZE(insns);
> +	libbpf_strlcpy(attr.prog_name, "test", sizeof(attr.prog_name));
>  
>  	/* make sure loading with name works */
> -	ret = bpf_prog_load(BPF_PROG_TYPE_SOCKET_FILTER, "test", "GPL", insns, insn_cnt, NULL);
> +	ret = sys_bpf_prog_load(&attr, sizeof(attr), PROG_LOAD_ATTEMPTS);
>  	return probe_fd(ret);
>  }
>  
> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> index 4135ae0a2bc3..377642ff51fc 100644
> --- a/tools/lib/bpf/libbpf_internal.h
> +++ b/tools/lib/bpf/libbpf_internal.h
> @@ -573,4 +573,7 @@ static inline bool is_pow_of_2(size_t x)
>  	return x && (x & (x - 1)) == 0;
>  }
>  
> +#define PROG_LOAD_ATTEMPTS 5
> +int sys_bpf_prog_load(union bpf_attr *attr, unsigned int size, int attempts);
> +
>  #endif /* __LIBBPF_LIBBPF_INTERNAL_H */

Looks good to me, thanks!

Acked-by: Quentin Monnet <quentin@isovalent.com>
