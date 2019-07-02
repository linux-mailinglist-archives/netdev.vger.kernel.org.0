Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 267DE5DA3F
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 03:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfGCBGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 21:06:18 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:39832 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727117AbfGCBGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 21:06:18 -0400
Received: by mail-oi1-f193.google.com with SMTP id m202so612272oig.6
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 18:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=luvfa0E4zTa+mcJld8jPAXpzZzjY7UmGrCwGyWHIIKA=;
        b=vBhqzuKwMnBliLxQX82mcgQzgBRPjVwVRNTf9So0F6Iw1ac8vFdbRnThh74e2VubIw
         bcaaZmHI5Wu2wEwr6RdbXuwahmLk9uKdjyL2FPQuBJFGXONMdqMoI4TjoDtpfy2Bd4C0
         2iqlI0jNPehwk+PCirQ9IKCqvWoMy/uGGQK/m+Hu7HTKZopkdvaO6WF+UkbjLVGbFz2u
         satGm4GPy2IpecjiugIzfQhB52L8q9gl8sE7Pd7Y9lx8Z7HcixG9TmekS8bOE485ek7h
         pJFilLEUWfz4cFociy2GI+EfciWV+KV3JM1cblSdc2Qh1tufSHw+8ZDqWqpRa3Gmv4j/
         Ia+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=luvfa0E4zTa+mcJld8jPAXpzZzjY7UmGrCwGyWHIIKA=;
        b=pyzfsjxhxRPtsw8Ez/UdZskYEeDlAyh2P0nhYfAgtTpIm6LgbsqYPhU3htxjGTjGnP
         EHrXGX6jfhwraxxcaixw8jnZrZkmWaH88TEoAlr2AeXiC7Tnb02+jmH2gRQF9w3nJ3iI
         RcGu+5X3GPNg4G2K2wyxUpnn4OeOGf9YQv7zNwulZcTsfp7PvIh4DnRtH4Jw12ltlZTg
         ERLw395cmayNFMoLHxPzfEWJZKqzhvtxYwvuYwBJnKvocZF8P0nZ+PJoTxz2G46fD7Bf
         XpM0fpIbXJFNkFS/UCebuHGrQw4dFqUiNNPPqrOUWbH95zuGR0dBr4Arz1lDHUMwD/6J
         VAXQ==
X-Gm-Message-State: APjAAAVX3tvnMmk1DH3yGTfSP8FOUr1KESKAB6v8heUv3Dob1mJJJi3M
        +oMY9yjRuzsZ1tYJDpDI48dCK25mimU=
X-Google-Smtp-Source: APXvYqzzZNG5r04NQAuUMRk/9I0Mi+YDsPPb2b4hnbUE5RRRO15d3vWd1bYFPeaRWxU5kPD0YcyDiw==
X-Received: by 2002:a63:5a0a:: with SMTP id o10mr33887668pgb.282.1562109510489;
        Tue, 02 Jul 2019 16:18:30 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id 14sm173678pfj.36.2019.07.02.16.18.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 16:18:28 -0700 (PDT)
Date:   Tue, 2 Jul 2019 16:18:26 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, ast@fb.com, daniel@iogearbox.net,
        kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 6/9] libbpf: use negative fd to specify
 missing BTF
Message-ID: <20190702231826.GL6757@mini-arch>
References: <20190529173611.4012579-1-andriin@fb.com>
 <20190529173611.4012579-7-andriin@fb.com>
 <20190702225733.GK6757@mini-arch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702225733.GK6757@mini-arch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/02, Stanislav Fomichev wrote:
> On 05/29, Andrii Nakryiko wrote:
> > 0 is a valid FD, so it's better to initialize it to -1, as is done in
> > other places. Also, technically, BTF type ID 0 is valid (it's a VOID
> > type), so it's more reliable to check btf_fd, instead of
> > btf_key_type_id, to determine if there is any BTF associated with a map.
> > 
> > Acked-by: Song Liu <songliubraving@fb.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c | 13 +++++++------
> >  1 file changed, 7 insertions(+), 6 deletions(-)
> > 
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index c972fa10271f..a27a0351e595 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -1751,7 +1751,7 @@ bpf_object__create_maps(struct bpf_object *obj)
> >  		create_attr.key_size = def->key_size;
> >  		create_attr.value_size = def->value_size;
> >  		create_attr.max_entries = def->max_entries;
> > -		create_attr.btf_fd = 0;
> > +		create_attr.btf_fd = -1;
> >  		create_attr.btf_key_type_id = 0;
> >  		create_attr.btf_value_type_id = 0;
> >  		if (bpf_map_type__is_map_in_map(def->type) &&
> > @@ -1765,11 +1765,11 @@ bpf_object__create_maps(struct bpf_object *obj)
> >  		}
> >  
> >  		*pfd = bpf_create_map_xattr(&create_attr);
> > -		if (*pfd < 0 && create_attr.btf_key_type_id) {
> > +		if (*pfd < 0 && create_attr.btf_fd >= 0) {
> >  			cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
> >  			pr_warning("Error in bpf_create_map_xattr(%s):%s(%d). Retrying without BTF.\n",
> >  				   map->name, cp, errno);
> > -			create_attr.btf_fd = 0;
> > +			create_attr.btf_fd = -1;
> This breaks libbpf compatibility with the older kernels. If the kernel
> doesn't know about btf_fd and we set it to -1, then CHECK_ATTR
> fails :-(
> 
> Any objections to converting BTF retries to bpf_capabilities and then
> knowingly passing bft_fd==0 or proper fd?
Oh, nevermind, it looks like you fixed it already in e55d54f43d3f.

> >  			create_attr.btf_key_type_id = 0;
> >  			create_attr.btf_value_type_id = 0;
> >  			map->btf_key_type_id = 0;
> > @@ -2053,6 +2053,9 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
> >  	char *log_buf;
> >  	int ret;
> >  
> > +	if (!insns || !insns_cnt)
> > +		return -EINVAL;
> > +
> >  	memset(&load_attr, 0, sizeof(struct bpf_load_program_attr));
> >  	load_attr.prog_type = prog->type;
> >  	load_attr.expected_attach_type = prog->expected_attach_type;
> > @@ -2063,7 +2066,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
> >  	load_attr.license = license;
> >  	load_attr.kern_version = kern_version;
> >  	load_attr.prog_ifindex = prog->prog_ifindex;
> > -	load_attr.prog_btf_fd = prog->btf_fd >= 0 ? prog->btf_fd : 0;
> > +	load_attr.prog_btf_fd = prog->btf_fd;
> >  	load_attr.func_info = prog->func_info;
> >  	load_attr.func_info_rec_size = prog->func_info_rec_size;
> >  	load_attr.func_info_cnt = prog->func_info_cnt;
> > @@ -2072,8 +2075,6 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
> >  	load_attr.line_info_cnt = prog->line_info_cnt;
> >  	load_attr.log_level = prog->log_level;
> >  	load_attr.prog_flags = prog->prog_flags;
> > -	if (!load_attr.insns || !load_attr.insns_cnt)
> > -		return -EINVAL;
> >  
> >  retry_load:
> >  	log_buf = malloc(log_buf_size);
> > -- 
> > 2.17.1
> > 
