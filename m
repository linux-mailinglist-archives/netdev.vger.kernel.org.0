Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0274A66AF
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242684AbiBAU5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:57:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242670AbiBAU5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 15:57:46 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB5CC06173B
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 12:57:41 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id v13so34316928wrv.10
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 12:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=J1HFXPZPodDe/pZhkiXP9l4lePCg+S9BGwX7+b5lEC8=;
        b=RLCagrgIH3DOtUzqjhPrfmsUSlUernbg8zK63BOj6HMMR0kmN1v3SxX/WuRdnyaWBA
         HN2p/Y+bg3KkWluccBkHMQEEC7wa0OBd4Y1g+h3gTTHnfvjUjKswFoAiyqfZ2jyS4ZTM
         28UEm6Sun0LBeJqicQEeMD/cuFjjObOCgrSmv3qnUk7HIrQRfTNo5gUa32+5gAfDz5OZ
         uXmZzDCFIwcxatEZLbFNyowlDBHNq+dZgsmnYzPNmToMX/S/aSZZrTk8j6X9CtXjvnlW
         HgAJCo9v5imvW+3iqQPjoKJoOylxpeBYroT+O0/mE8OMlZJbpAnAS1iFzrgrn5XncryN
         emWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=J1HFXPZPodDe/pZhkiXP9l4lePCg+S9BGwX7+b5lEC8=;
        b=Ja+zxJD9zCIhAdznXagNm2VpotExOciRm0Net1I+KhdPViUkwmqJ65BezWJFSo2z/K
         4OTqIv/GD9iXsioMMoH6FWfJcGFRFebrcyJMrpZarMicyF0fj5oUllfKqCs/MccZfOGq
         dyIgqMDysm3ym0aoJHZDOxy6ovfos84G/qGc6pWg15M+OcSAHC++TwFfOz32Gx0f8QJk
         rrV/+wILYJuPUI1+ISe0QbhfVcHU/Z6A1954j6dnoArZrQIudQCcsmMBxiTCkmXuI8XJ
         kFmTXVlG1vcNg0ilzZ+zrX8R15Np0Pmhd4B3UGH/1/KspObYNnmkmupbNPJTNAF9UY46
         MKsw==
X-Gm-Message-State: AOAM5339Dr7GCYq7AjILsWWI6fPcqO+8hRWFIf51PUbEekFtP5l9HgAq
        ZqakKXDFIXDmEIcDZeRzZKDc+lggbfq59w==
X-Google-Smtp-Source: ABdhPJzCs6L4Yge5a78Vk1RiylYn14prZg1hG+PWKP09bufQKaMEjGFH0LR1rGXabU3r8Rt+Ydaq5w==
X-Received: by 2002:a5d:4e81:: with SMTP id e1mr23151090wru.513.1643749060352;
        Tue, 01 Feb 2022 12:57:40 -0800 (PST)
Received: from [192.168.1.8] ([149.86.72.139])
        by smtp.gmail.com with ESMTPSA id u14sm15274771wrm.58.2022.02.01.12.57.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 12:57:39 -0800 (PST)
Message-ID: <1b081b16-d91e-01fd-9154-7845782e8715@isovalent.com>
Date:   Tue, 1 Feb 2022 20:57:38 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next v5 1/9] libbpf: Implement changes needed for
 BTFGen in bpftool
Content-Language: en-GB
To:     =?UTF-8?Q?Mauricio_V=c3=a1squez?= <mauricio@kinvolk.io>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
References: <20220128223312.1253169-1-mauricio@kinvolk.io>
 <20220128223312.1253169-2-mauricio@kinvolk.io>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20220128223312.1253169-2-mauricio@kinvolk.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-01-28 17:33 UTC-0500 ~ Mauricio Vásquez <mauricio@kinvolk.io>
> This commit extends libbpf with the features that are needed to
> implement BTFGen:
> 
> - Implement bpf_core_create_cand_cache() and bpf_core_free_cand_cache()
> to handle candidates cache.
> - Expose bpf_core_add_cands() and bpf_core_free_cands to handle
> candidates list.
> - Expose bpf_core_calc_relo_insn() to bpftool.
> 
> Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>

Hi, note that the patchset (or at least, this patch) does not apply
cleanly. Can you please double-check that it is based on bpf-next?

> ---
>  tools/lib/bpf/libbpf.c          | 44 ++++++++++++++++++++++-----------
>  tools/lib/bpf/libbpf_internal.h | 12 +++++++++
>  2 files changed, 41 insertions(+), 15 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 12771f71a6e7..61384d219e28 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -5195,18 +5195,18 @@ size_t bpf_core_essential_name_len(const char *name)
>  	return n;
>  }
>  
> -static void bpf_core_free_cands(struct bpf_core_cand_list *cands)
> +void bpf_core_free_cands(struct bpf_core_cand_list *cands)
>  {
>  	free(cands->cands);
>  	free(cands);
>  }
>  
> -static int bpf_core_add_cands(struct bpf_core_cand *local_cand,
> -			      size_t local_essent_len,
> -			      const struct btf *targ_btf,
> -			      const char *targ_btf_name,
> -			      int targ_start_id,
> -			      struct bpf_core_cand_list *cands)
> +int bpf_core_add_cands(struct bpf_core_cand *local_cand,
> +		       size_t local_essent_len,
> +		       const struct btf *targ_btf,
> +		       const char *targ_btf_name,
> +		       int targ_start_id,
> +		       struct bpf_core_cand_list *cands)
>  {
>  	struct bpf_core_cand *new_cands, *cand;
>  	const struct btf_type *t, *local_t;
> @@ -5577,6 +5577,25 @@ static int bpf_core_resolve_relo(struct bpf_program *prog,
>  				       targ_res);
>  }
>  
> +struct hashmap *bpf_core_create_cand_cache(void)
> +{
> +	return hashmap__new(bpf_core_hash_fn, bpf_core_equal_fn, NULL);
> +}
> +
> +void bpf_core_free_cand_cache(struct hashmap *cand_cache)
> +{
> +	struct hashmap_entry *entry;
> +	int i;
> +
> +	if (IS_ERR_OR_NULL(cand_cache))
> +		return;
> +
> +	hashmap__for_each_entry(cand_cache, entry, i) {
> +		bpf_core_free_cands(entry->value);
> +	}
> +	hashmap__free(cand_cache);
> +}
> +
>  static int
>  bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
>  {
> @@ -5584,7 +5603,6 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
>  	struct bpf_core_relo_res targ_res;
>  	const struct bpf_core_relo *rec;
>  	const struct btf_ext_info *seg;
> -	struct hashmap_entry *entry;
>  	struct hashmap *cand_cache = NULL;
>  	struct bpf_program *prog;
>  	struct bpf_insn *insn;
> @@ -5603,7 +5621,7 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
>  		}
>  	}
>  
> -	cand_cache = hashmap__new(bpf_core_hash_fn, bpf_core_equal_fn, NULL);
> +	cand_cache = bpf_core_create_cand_cache();
>  	if (IS_ERR(cand_cache)) {
>  		err = PTR_ERR(cand_cache);
>  		goto out;
> @@ -5694,12 +5712,8 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
>  	btf__free(obj->btf_vmlinux_override);
>  	obj->btf_vmlinux_override = NULL;
>  
> -	if (!IS_ERR_OR_NULL(cand_cache)) {
> -		hashmap__for_each_entry(cand_cache, entry, i) {
> -			bpf_core_free_cands(entry->value);
> -		}
> -		hashmap__free(cand_cache);
> -	}
> +	bpf_core_free_cand_cache(cand_cache);
> +
>  	return err;
>  }
>  
> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> index bc86b82e90d1..686a5654262b 100644
> --- a/tools/lib/bpf/libbpf_internal.h
> +++ b/tools/lib/bpf/libbpf_internal.h
> @@ -529,4 +529,16 @@ static inline int ensure_good_fd(int fd)
>  	return fd;
>  }
>  
> +struct hashmap;
> +
> +struct hashmap *bpf_core_create_cand_cache(void);
> +void bpf_core_free_cand_cache(struct hashmap *cand_cache);
> +int bpf_core_add_cands(struct bpf_core_cand *local_cand,
> +		       size_t local_essent_len,
> +		       const struct btf *targ_btf,
> +		       const char *targ_btf_name,
> +		       int targ_start_id,
> +		       struct bpf_core_cand_list *cands);
> +void bpf_core_free_cands(struct bpf_core_cand_list *cands);

I wonder if these might deserve a comment to mention that they are
exposed for bpftool? I fear someone might attempt to clean it up and
remove the unused exports otherwise.
