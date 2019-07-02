Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A255D962
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbfGCAmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:42:25 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:43958 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfGCAmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:42:25 -0400
Received: by mail-oi1-f194.google.com with SMTP id w79so556999oif.10
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 17:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AQROqwlwlcVby5ek+TITqdH8ekWL+tjjpKHjhSfuljY=;
        b=lFUew9t4SpqLIxVQ+b3pE5iaXJTXT08X0cavLhJcuwMTfGNb0JL6Jp6tSba7GvXgiz
         8BOk4n+mWUpyaieRhh7VRz9maYwzMF6hUGu0bb6meTpYCEA/H4l2XrKsXrERKvuAeFd+
         ew/+Qp75kxmr/HUbFhaHA+2Hc3cWFzzZJni6UDkp+H2BFaqUPlGeNr9RZ071MLnWlRxE
         pTDOqL+r9IURWCY1bCupg1jqpx6tmjiUDqZ02Jr3+tznYt9Ogkt6apkyRgxAOXjG8Cb1
         IMUmC7nXY0LXCTaazpKKUfzNdDD8PX+9sK93pK67RA3GNODLGLQYQ9ducIHjhD3NdCLX
         dbEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AQROqwlwlcVby5ek+TITqdH8ekWL+tjjpKHjhSfuljY=;
        b=UUbFzIyJITG6vb3nmghepx5Cn/UXyGwxsW4ArOCp8yEH7T5bUnp+Or3jNMO3LD6B0J
         Kj8AhCYKhVWAM+wksoLO2WYc86iReh3Vxsc2sEvvVJ/L1zOgra4yTI5sSAVTBj110zOK
         5EkBBRsurbiRBAV6rsfaaEUZeLykUXto4LJAaFimZ418TMNswqK6IoIWvNK4s+ZIVvos
         erLNG+0g4PrExA+9IEajBjqQbVJlWpzREcNlDWv/hUSx6fApY41Dcfoxila4unZvlxjS
         I427e+tYt63uXlwj8MEa1iIUCTiiX5tVGNqgAaSNNx/+Oyvb6mIDFJhjTOP07TRRfKYG
         Ig4Q==
X-Gm-Message-State: APjAAAVgzQZkWMjwdyBRIzNEXUmOlfj5b2L+nC2qgvZWXvGCKO4CNy6c
        JhQCvFkuHW3/WwhxFsMOOBfsRiQ4lc4=
X-Google-Smtp-Source: APXvYqzMPmT8XF7jgNXjqqSd+W+mSY2cud3GxGux1xHIX0Cu8BaDs5Cw+2bRh6ydBB9E+FiObVDS0w==
X-Received: by 2002:a63:1645:: with SMTP id 5mr32666498pgw.175.1562108260782;
        Tue, 02 Jul 2019 15:57:40 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id t2sm116719pfh.166.2019.07.02.15.57.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 15:57:39 -0700 (PDT)
Date:   Tue, 2 Jul 2019 15:57:33 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, ast@fb.com, daniel@iogearbox.net,
        kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 6/9] libbpf: use negative fd to specify
 missing BTF
Message-ID: <20190702225733.GK6757@mini-arch>
References: <20190529173611.4012579-1-andriin@fb.com>
 <20190529173611.4012579-7-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529173611.4012579-7-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/29, Andrii Nakryiko wrote:
> 0 is a valid FD, so it's better to initialize it to -1, as is done in
> other places. Also, technically, BTF type ID 0 is valid (it's a VOID
> type), so it's more reliable to check btf_fd, instead of
> btf_key_type_id, to determine if there is any BTF associated with a map.
> 
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index c972fa10271f..a27a0351e595 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1751,7 +1751,7 @@ bpf_object__create_maps(struct bpf_object *obj)
>  		create_attr.key_size = def->key_size;
>  		create_attr.value_size = def->value_size;
>  		create_attr.max_entries = def->max_entries;
> -		create_attr.btf_fd = 0;
> +		create_attr.btf_fd = -1;
>  		create_attr.btf_key_type_id = 0;
>  		create_attr.btf_value_type_id = 0;
>  		if (bpf_map_type__is_map_in_map(def->type) &&
> @@ -1765,11 +1765,11 @@ bpf_object__create_maps(struct bpf_object *obj)
>  		}
>  
>  		*pfd = bpf_create_map_xattr(&create_attr);
> -		if (*pfd < 0 && create_attr.btf_key_type_id) {
> +		if (*pfd < 0 && create_attr.btf_fd >= 0) {
>  			cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
>  			pr_warning("Error in bpf_create_map_xattr(%s):%s(%d). Retrying without BTF.\n",
>  				   map->name, cp, errno);
> -			create_attr.btf_fd = 0;
> +			create_attr.btf_fd = -1;
This breaks libbpf compatibility with the older kernels. If the kernel
doesn't know about btf_fd and we set it to -1, then CHECK_ATTR
fails :-(

Any objections to converting BTF retries to bpf_capabilities and then
knowingly passing bft_fd==0 or proper fd?

>  			create_attr.btf_key_type_id = 0;
>  			create_attr.btf_value_type_id = 0;
>  			map->btf_key_type_id = 0;
> @@ -2053,6 +2053,9 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
>  	char *log_buf;
>  	int ret;
>  
> +	if (!insns || !insns_cnt)
> +		return -EINVAL;
> +
>  	memset(&load_attr, 0, sizeof(struct bpf_load_program_attr));
>  	load_attr.prog_type = prog->type;
>  	load_attr.expected_attach_type = prog->expected_attach_type;
> @@ -2063,7 +2066,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
>  	load_attr.license = license;
>  	load_attr.kern_version = kern_version;
>  	load_attr.prog_ifindex = prog->prog_ifindex;
> -	load_attr.prog_btf_fd = prog->btf_fd >= 0 ? prog->btf_fd : 0;
> +	load_attr.prog_btf_fd = prog->btf_fd;
>  	load_attr.func_info = prog->func_info;
>  	load_attr.func_info_rec_size = prog->func_info_rec_size;
>  	load_attr.func_info_cnt = prog->func_info_cnt;
> @@ -2072,8 +2075,6 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
>  	load_attr.line_info_cnt = prog->line_info_cnt;
>  	load_attr.log_level = prog->log_level;
>  	load_attr.prog_flags = prog->prog_flags;
> -	if (!load_attr.insns || !load_attr.insns_cnt)
> -		return -EINVAL;
>  
>  retry_load:
>  	log_buf = malloc(log_buf_size);
> -- 
> 2.17.1
> 
