Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85332435250
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 20:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhJTSGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 14:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbhJTSGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 14:06:37 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8ED6C06161C;
        Wed, 20 Oct 2021 11:04:22 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id f21so16708751plb.3;
        Wed, 20 Oct 2021 11:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E3SK5MC8JyOHgjD7UChUlRcbSRC4qadj1ME7v92Afl0=;
        b=dnkfnWjDmMjlh0cyajhn5+UD1GqmsR8P3MuPGsVovzd+fzRPmclE4eIc+PSPAEVqzK
         yjxafSBJsgbV+4gRjpY14cdstBERF6ZbraYKAGaAVBl9B41KhB6RahLjzQ3CLxIQvaTx
         35dwH7t1/XmXS1QkH4+eQHhbWD//kg8g4OZvdgd2Lz0qTyRhqgF2J98Z3jGv2HCENlVV
         /nxIvpLt+1feXt3CB4LA4944kpI4VgnjrX77KjD1TtL0EGVvQDF+xOLfS+US05O8C903
         M/JgMzc3wMB6DgsPMPAImrroPj7U9movbqG2q/DAD3Epj6f/Dg3763Y2RsY2qUrQIHGA
         0q8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E3SK5MC8JyOHgjD7UChUlRcbSRC4qadj1ME7v92Afl0=;
        b=nVP35yqJ/ja8fo7VGv6FWtj6a4UgBKVb9Nc7hjBxgLJEbVaBRXF5eFuKXg6xpyf/zv
         6jA6KFoTFid+KyMpAIVc5+atxERGaGXfNV4asJhFj380eFo8IM5oZAQfDSKX+ppq2a4f
         03XyMrAs3zGCC48+Z6Df79irJ6IomxLTOX/W/pE+fFwP5kqd1ANcuX2uHTQec+QTX4Eh
         fE+uTkzuuGSb4JrZAmRpNRaCcKv0x7+TuBD7x82n4L5C548aY5zfxPh7wgGY4Uu4Yqgw
         wVIyVevIWsqVXkDMcbuJzDY8k3vv48vBYap0NhDMcKbuyAnnnUDqfQ+A9nlPC293ZqxP
         doag==
X-Gm-Message-State: AOAM533SWaQMB1xfQFGQvrLpzuN5LKV3byH35kNL7iDV6duWuVNKqtyc
        ZBfRRIQoexl1ZwPwG5sX9xw=
X-Google-Smtp-Source: ABdhPJxkCJFQfBLdRyShbBxxNJPdrOOc+BJql3KbweXig1CHSzz0p8M+MAaqZGhO76n31UgrKndpEQ==
X-Received: by 2002:a17:90a:fb4a:: with SMTP id iq10mr416119pjb.117.1634753062291;
        Wed, 20 Oct 2021 11:04:22 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:b634])
        by smtp.gmail.com with ESMTPSA id t14sm6438151pjl.10.2021.10.20.11.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 11:04:21 -0700 (PDT)
Date:   Wed, 20 Oct 2021 11:04:18 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 1/8] bpf: Add bpf_kallsyms_lookup_name helper
Message-ID: <20211020180418.5sgoickl4pucrk52@ast-mbp.dhcp.thefacebook.com>
References: <20211014205644.1837280-1-memxor@gmail.com>
 <20211014205644.1837280-2-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014205644.1837280-2-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 02:26:37AM +0530, Kumar Kartikeya Dwivedi wrote:
> This helper allows us to get the address of a kernel symbol from inside
> a BPF_PROG_TYPE_SYSCALL prog (used by gen_loader), so that we can
> relocate typeless ksym vars.
...
> +BPF_CALL_4(bpf_kallsyms_lookup_name, const char *, name, int, name_sz, int, flags, u64 *, res)
> +{
> +	if (flags)
> +		return -EINVAL;
> +
> +	if (name_sz <= 1 || name[name_sz - 1])
> +		return -EINVAL;
> +
> +	*res = kallsyms_lookup_name(name);
> +	return *res ? 0 : -ENOENT;
> +}
> +
> +const struct bpf_func_proto bpf_kallsyms_lookup_name_proto = {
> +	.func		= bpf_kallsyms_lookup_name,
> +	.gpl_only	= true,

When libbpf is processing of typeless ksyms it parses /proc/kallsyms.
There is no gpl-ness in the action of reading this file.
Hence above should be '= false' for consistency between
light and regular skeleton.

But different check is necessary.
This helper is available to syscall_bpf prog type (which is CAP_BPF)
and shouldn't be used to bypass kptr checks.
So bpf_kallsyms_lookup_name() should probably have:
if (!bpf_dump_raw_ok(current_cred())))
  return -EPERM;

The rest of the patches look great.
Thank you for working on this!
