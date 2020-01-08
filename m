Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 394E4134CEB
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 21:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgAHUNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 15:13:00 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37134 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgAHUNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 15:13:00 -0500
Received: by mail-pf1-f194.google.com with SMTP id p14so2173188pfn.4;
        Wed, 08 Jan 2020 12:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Pmq7WOU5AkHP85i5Rhy4xBLNQeJ5Y4ms/Tcvza1stQ0=;
        b=UAHZYz3TujaUfEV2FpdbfyhiRu+XRjIvK966ytWAXIV0yxPEnmndwaH85PaOYTEOKS
         mxFht9hf6dRGgymp68Vd+mF+ZUwTB5qW32+qtE5HOPIIfoEHNnjLeatX5BadPCFVvEET
         AoHlCvM+onBtBKpKsUQk9y1zOvzqlmnpqmAV/F+vutvdiq19WsDp4i44OdV3/5f2UHX7
         VPuEFVhX4hOqosNj9KG2Xq9HC5WIbrcdxbvtm+0hXdN0k9CKcr4lktGLsgDXoz0A0mj+
         XyHWbU12ktEG90lH/dZGRpamPmRw4J0XZdSdUFy9htm84kTpP5+8cXBYHkDO2MR/I/i+
         rgKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Pmq7WOU5AkHP85i5Rhy4xBLNQeJ5Y4ms/Tcvza1stQ0=;
        b=do1YnIaexjSEjOijkKsfug/G3UajBs1yY5SRIsHizY0JKZWTIJnBFjCrdgdJI1Qa0M
         2qZRPdycKavsJjaYnh82Pg/RKOjzgBFDuY3NPbf87vEP1o69nto/com1I09FhRMqHQ4m
         nJRXWe+1DcaKMqvnqjHGAqCXjNIaW3XbYxIej3ytNn59XH9OAQfNN9xSXue2gmpJf5g7
         hFKLu+7A3qr2HutvrSTu7Pg0ClPD/rsC8HcVYklgn5baup9xE3Bp5zMj3F3TeSak+f9j
         RzWQmbH6ZWorpkW9fCfQ+JQ+scjkov205ugS7LvvFNNrIWdOHfNRKQ0mkNW9OtMVf86+
         rJAg==
X-Gm-Message-State: APjAAAVNg9xKHxBYNzIzBMFO7oOjTFocHFizyEHxrYRE2zZ7i+MR5+pW
        WdGNR8jRIkLmgOVHft0eeTw=
X-Google-Smtp-Source: APXvYqxUrEcgty5JksDAvM9E8RTnHQYOaCYAL74Tj5q8oO+Zjavm6cCrmJvXxtNgo3u6NH9ZiiQpYg==
X-Received: by 2002:a05:6a00:90:: with SMTP id c16mr6803170pfj.230.1578514379418;
        Wed, 08 Jan 2020 12:12:59 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:200::3:1e54])
        by smtp.gmail.com with ESMTPSA id q22sm4724369pfg.170.2020.01.08.12.12.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jan 2020 12:12:58 -0800 (PST)
Date:   Wed, 8 Jan 2020 12:12:57 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/6] libbpf: Sanitize BTF_KIND_FUNC linkage
Message-ID: <20200108201256.2wtawgl3e4d4dkka@ast-mbp>
References: <20200108072538.3359838-1-ast@kernel.org>
 <20200108072538.3359838-2-ast@kernel.org>
 <d2fab68b-cd03-7a15-e353-c614f6079b89@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2fab68b-cd03-7a15-e353-c614f6079b89@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 06:57:18PM +0000, Yonghong Song wrote:
> 
> 
> On 1/7/20 11:25 PM, Alexei Starovoitov wrote:
> > In case kernel doesn't support static/global/extern liknage of BTF_KIND_FUNC
> > sanitize BTF produced by llvm.
> > 
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> >   tools/include/uapi/linux/btf.h |  6 ++++++
> >   tools/lib/bpf/libbpf.c         | 35 +++++++++++++++++++++++++++++++++-
> >   2 files changed, 40 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/include/uapi/linux/btf.h b/tools/include/uapi/linux/btf.h
> > index 1a2898c482ee..5a667107ad2c 100644
> > --- a/tools/include/uapi/linux/btf.h
> > +++ b/tools/include/uapi/linux/btf.h
> > @@ -146,6 +146,12 @@ enum {
> >   	BTF_VAR_GLOBAL_EXTERN = 2,
> >   };
> >   
> > +enum btf_func_linkage {
> > +	BTF_FUNC_STATIC = 0,
> > +	BTF_FUNC_GLOBAL = 1,
> > +	BTF_FUNC_EXTERN = 2,
> > +};
> > +
> >   /* BTF_KIND_VAR is followed by a single "struct btf_var" to describe
> >    * additional information related to the variable such as its linkage.
> >    */
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 7513165b104f..f72b3ed6c34b 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -166,6 +166,8 @@ struct bpf_capabilities {
> >   	__u32 btf_datasec:1;
> >   	/* BPF_F_MMAPABLE is supported for arrays */
> >   	__u32 array_mmap:1;
> > +	/* static/global/extern is supported for BTF_KIND_FUNC */
> > +	__u32 btf_func_linkage:1;
> >   };
> >   
> >   enum reloc_type {
> > @@ -1817,13 +1819,14 @@ static bool section_have_execinstr(struct bpf_object *obj, int idx)
> >   
> >   static void bpf_object__sanitize_btf(struct bpf_object *obj)
> >   {
> > +	bool has_func_linkage = obj->caps.btf_func_linkage;
> >   	bool has_datasec = obj->caps.btf_datasec;
> >   	bool has_func = obj->caps.btf_func;
> >   	struct btf *btf = obj->btf;
> >   	struct btf_type *t;
> >   	int i, j, vlen;
> >   
> > -	if (!obj->btf || (has_func && has_datasec))
> > +	if (!obj->btf || (has_func && has_datasec && has_func_linkage))
> >   		return;
> >   
> >   	for (i = 1; i <= btf__get_nr_types(btf); i++) {
> > @@ -1871,6 +1874,9 @@ static void bpf_object__sanitize_btf(struct bpf_object *obj)
> >   		} else if (!has_func && btf_is_func(t)) {
> >   			/* replace FUNC with TYPEDEF */
> >   			t->info = BTF_INFO_ENC(BTF_KIND_TYPEDEF, 0, 0);
> > +		} else if (!has_func_linkage && btf_is_func(t)) {
> > +			/* replace BTF_FUNC_GLOBAL with BTF_FUNC_STATIC */
> > +			t->info = BTF_INFO_ENC(BTF_KIND_FUNC, 0, 0);
> 
> The comment says we only sanitize BTF_FUNC_GLOBAL here.
> Actually, it also sanitize BTF_FUNC_EXTERN.
> 
> Currently, in kernel/bpf/btf.c, we have
> static int btf_check_all_types(struct btf_verifier_env *env)
> {
> 		...
>                  if (btf_type_is_func(t)) {
>                          err = btf_func_check(env, t);
>                          if (err)
>                                  return err;
>                  }
> 		...
> }
> 
> btf_func_check() will ensure func btf_type->type is a func_proto
> and all arguments of func_proto has a name except void which is
> considered as varg.
> 
> For extern function, the argument name is lost in llvm/clang.
> 
> -bash-4.4$ cat test.c 
> 
> extern int foo(int a);
> int test() { return foo(5); }
> -bash-4.4$
> -bash-4.4$ clang -target bpf -O2 -g -S -emit-llvm test.c
> 
> !2 = !{}
> !4 = !DISubprogram(name: "foo", scope: !1, file: !1, line: 1, type: !5, 
> flags: DIFlagPrototyped, spFlags: DISPFlagOptimized, retainedNodes: !2)
> !5 = !DISubroutineType(types: !6)
> !6 = !{!7, !7}
> !7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
> 
> To avoid kernel complaints, we need to sanitize in a different way.
> For example extern BTF_KIND_FUNC could be rewritten to a
> BTF_KIND_PTR to void.

Good point. I'll reword the comment and rename the test to btf_func_global,
so it probes kernel for KIND_GLOBAL only and santizes only that bit.
KIND_EXTERN sanitization is to be done later. Separate libbpf and kernel patches.
