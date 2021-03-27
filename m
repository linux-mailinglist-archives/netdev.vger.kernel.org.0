Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C7634B431
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 05:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhC0D7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 23:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbhC0D7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 23:59:37 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F2EC0613AA;
        Fri, 26 Mar 2021 20:59:37 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id ay2so1850405plb.3;
        Fri, 26 Mar 2021 20:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bEbMUAnvqy6YfRUOELcRxthLxP0F9gZlIO++dxXagaA=;
        b=CZyP0Cw0a7CXNAt1C2NCccLQqHibHnxfl6eAlOtkeHxANIELlrRgbwqbaNeced4MbL
         7r2QwsjdMN6qLIF2B9jZeFxHR5y74IK4fPBUVB9MUoay1hTH+opCamxknWySTCYMPoTx
         EqyMmYexOHsw4HSK+8J0Vqs0J9MNnyo+cX921Plpo6z6xBH0ka6ZmirONslatpVMoi94
         xi5MNdi/+wJKN9zNpnlrWQVdhnd507yHAHeMqA+4zm2nqEcm4lSftGzJLW3nPWoOIhtC
         hoVw3C/bFxeKf8fYEV03s5s7eq0inUoL/cxh4szDENcusY8Dmk0XjRnzL2Y1YfxB1Pig
         0J/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bEbMUAnvqy6YfRUOELcRxthLxP0F9gZlIO++dxXagaA=;
        b=GjO8TTugRWJ2/13QKuutxUuisCH5yMJEeUYfA4Nc/LZ93NpySBxrybLfJrHsdNtptH
         +c7UU/9CSnKjZkKeLrMfDV5aaxCy/zHsC6BOXO+Egr06bZNp+T3FPvv7KUF6c+3STLaY
         5cjEclQv0qv0Z9oeSMc02sZCwZJ8qQex79LBM35autGw4RGatgDA97Spz/OGiZmKsb06
         Hp54AtNOl9bOrM2UdqI966BjvgRueuQcHwCpB+pb7gHw+RLtYfNQanqcEmn/26URQKdi
         gq2OCnuKfdolgrIHuaRrrM1c9NsSZ0OOPCH/RKvdf5AgByLVppgKug5MWneFXwgFLeOC
         9T0w==
X-Gm-Message-State: AOAM5320I+olEziQ69dYyVuEruVGyEJcXUuQvj8vwshQpkLIc/7R3wNs
        4JKM9ChwnhHOR+rFH7or0UU=
X-Google-Smtp-Source: ABdhPJxwVsj39A86XL3OgjtmcK5gPOveqvKWDpVYMPFmYWju6G67UBX1mQafIDGxBT/9+bx2LiysZg==
X-Received: by 2002:a17:902:e882:b029:e6:caba:fff6 with SMTP id w2-20020a170902e882b02900e6cabafff6mr17892114plg.73.1616817576925;
        Fri, 26 Mar 2021 20:59:36 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:15b8])
        by smtp.gmail.com with ESMTPSA id f20sm10409512pfa.10.2021.03.26.20.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 20:59:36 -0700 (PDT)
Date:   Fri, 26 Mar 2021 20:59:34 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 bpf-next 03/14] bpf: Support bpf program calling
 kernel function
Message-ID: <20210327035934.7cyxbli73qqjwnqv@ast-mbp>
References: <20210325015124.1543397-1-kafai@fb.com>
 <20210325015142.1544736-1-kafai@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325015142.1544736-1-kafai@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 06:51:42PM -0700, Martin KaFai Lau wrote:
>  		ref_tname = btf_name_by_offset(btf, ref_t->name_off);
> -		if (btf_get_prog_ctx_type(log, btf, t, env->prog->type, i)) {
> +		if (btf_is_kernel(btf)) {
> +			const struct btf_type *reg_ref_t;
> +			const struct btf *reg_btf;
> +			const char *reg_ref_tname;
> +			u32 reg_ref_id;
> +
> +			if (!btf_type_is_struct(ref_t)) {
> +				bpf_log(log, "kernel function %s args#%d pointer type %s %s is not supported\n",
> +					func_name, i, btf_type_str(ref_t),
> +					ref_tname);
> +				return -EINVAL;
> +			}

Looks great. Applied to bpf-next.

Please follow up:
- the argument restriction of scalar and ptr_to_btf_id above should be easy to overcome.
I think either if (ptr_to_mem_ok) bit will be able to handle it
or ptr_to_btf_id can point to int/long type.
I hope some minor refactoring of these two cases will make kfunc calling more usable.
And since the code will be common would be great to add ptr_to_btf_id support
to global funcs as well. Currently ptr to struct is ptr_to_mem, so all types
inside the struct are just memory.

- please update selftest/bpf/README.rst with llvm diff url that added support for
extern funcs in BTF.

- please update bpf_design_QA.rst to make it clear that kfunc calling is not an ABI.
The kernel functions protos will change and progs will be rejected by the verifier.
Pretty much what is already in this commit log. Just copy paste into the doc, so it
doesn't get lost in git history.
