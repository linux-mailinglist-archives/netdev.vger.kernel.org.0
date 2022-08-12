Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29C2590D7F
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 10:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235671AbiHLIi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 04:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237389AbiHLIiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 04:38:22 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D831E1D30E
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 01:38:20 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id l4so398425wrm.13
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 01:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=BVoWrbqmJVd8EYZKtATQPrWe/sHOKUT5xASvY5MnCBs=;
        b=nP7v0cy0bIPNMehxWeAsXcuE1z/Ds/2vvmhT0dDMcN07e3cO+yVwh6I1lFc13yQrzz
         xUx1aJnb4rO562vpVJFUdoY9rOtioxEZ09CA+hBTMNXi5lZ8jHhwuZwtBSrzp/Fv+l1h
         cLj+kas6Fx+VHldt68NQYg1kZ0XnKMZNt6j0YpTmtmosrUf3jUs6DN2qve8s/EtWW1Ku
         B/b/a7uap4FTsvS+FhMupL06s7TJEwiHnSeQUy0rHZpEeScXX+bzkjRSk0KOhX4+xxeX
         iydWMxiZpkhxpEDq231GDhOUMF+ChJwYJNB/CM/PaOudEgeOp9qgrc8NHHhPFfeB8417
         Q1MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=BVoWrbqmJVd8EYZKtATQPrWe/sHOKUT5xASvY5MnCBs=;
        b=B780tTKu5KOdSRM1aR8LtUrZSGlFQ5+2tHimn6zPnCXzyusRcEU0agGTKsXO77Ihlv
         aqBI7o0K8fjVDAvD64HWX3snPG0+xIUDKN0nrdVTbvSwSG3b/TvY2dqwE/xi4/JUTKy2
         6IdsQ6L7xCldDSInmWteuDxYKcYrVFO8pkZAFDpFQhCcT9A1AQ7s71RYvDypbr77HCef
         1oBXD5YyjqHHjZ0qeCzTiMy/MyKch/buBgTZ8cMOw3rSyjP16NTdgRZ9QZ/jQABUWQb/
         awqShLByXmn8nD5cMkstc+jm/z31ThQLPSuBjyvAE0hi6YZu5oZpcis6KhuWezpXGACQ
         3UPw==
X-Gm-Message-State: ACgBeo1hSBXO7UXdmdTsTvLwYFqGVfxgcxNBbHj6zF5BS7plg2ov/wlZ
        yIcX/zBtxObUVswgBfIp6Ku/gg==
X-Google-Smtp-Source: AA6agR6k0lC1KLMLLmlqpnUJ6hOBMnKiibdJglWu5gWsVe5JfvP53ILE72cbXKNtXGE6JRj31a89ng==
X-Received: by 2002:a05:6000:2cb:b0:21e:d9bc:7aa2 with SMTP id o11-20020a05600002cb00b0021ed9bc7aa2mr1419251wry.467.1660293499412;
        Fri, 12 Aug 2022 01:38:19 -0700 (PDT)
Received: from [192.168.178.32] ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id q3-20020adff943000000b00222ed7ea203sm1307274wrr.100.2022.08.12.01.38.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 01:38:19 -0700 (PDT)
Message-ID: <407e67b7-b4f2-40db-6e13-409784fe32aa@isovalent.com>
Date:   Fri, 12 Aug 2022 09:38:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH bpf-next] libbpf: making bpf_prog_load() ignore name if
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
References: <20220812024038.7056-1-liuhangbin@gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20220812024038.7056-1-liuhangbin@gmail.com>
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

On 12/08/2022 03:40, Hangbin Liu wrote:
> Similar with commit 10b62d6a38f7 ("libbpf: Add names for auxiliary maps"),
> let's make bpf_prog_load() also ignore name if kernel doesn't support
> program name.
> 
> To achieve this, we need to call sys_bpf_prog_load() directly in
> probe_kern_prog_name() to avoid circular dependency. sys_bpf_prog_load()
> also need to be exported in the bpf.h file.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/lib/bpf/bpf.c    |  6 ++----
>  tools/lib/bpf/bpf.h    |  3 +++
>  tools/lib/bpf/libbpf.c | 11 +++++++++--
>  3 files changed, 14 insertions(+), 6 deletions(-)
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
> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> index 9c50beabdd14..125c580e45f8 100644
> --- a/tools/lib/bpf/bpf.h
> +++ b/tools/lib/bpf/bpf.h
> @@ -35,6 +35,9 @@
>  extern "C" {
>  #endif
>  
> +#define PROG_LOAD_ATTEMPTS 5
> +int sys_bpf_prog_load(union bpf_attr *attr, unsigned int size, int attempts);
> +

bpf.h is the user-facing header, should these go into libbpf_internal.h
instead?

By the way, I observe that libbpf_set_memlock_rlim() in bpf.h (below) is
not prefixed with LIBBPF_API, although it is exposed in the libbpf.map,
Andrii is this expected?

>  int libbpf_set_memlock_rlim(size_t memlock_bytes);
>  
>  struct bpf_map_create_opts {
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 3f01f5cd8a4c..1bcb2735d3f1 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4419,10 +4419,17 @@ static int probe_kern_prog_name(void)
>  		BPF_MOV64_IMM(BPF_REG_0, 0),
>  		BPF_EXIT_INSN(),
>  	};
> -	int ret, insn_cnt = ARRAY_SIZE(insns);
> +	union bpf_attr attr = {
> +		.prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
> +		.prog_name = "test",
> +		.license = ptr_to_u64("GPL"),
> +		.insns = ptr_to_u64(insns),
> +		.insn_cnt = (__u32)ARRAY_SIZE(insns),
> +	};

I think you cannot initialise "attr" directly, you need a "memset(&attr,
0, sizeof(attr));" first, in case the struct contains padding between
the fields.

> +	int ret;
>  
>  	/* make sure loading with name works */
> -	ret = bpf_prog_load(BPF_PROG_TYPE_SOCKET_FILTER, "test", "GPL", insns, insn_cnt, NULL);
> +	ret = sys_bpf_prog_load(&attr, sizeof(attr), PROG_LOAD_ATTEMPTS);
>  	return probe_fd(ret);
>  }
>  

