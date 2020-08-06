Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA5923E405
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 00:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgHFWai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 18:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgHFWah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 18:30:37 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EA6C061574;
        Thu,  6 Aug 2020 15:30:37 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u128so594910pfb.6;
        Thu, 06 Aug 2020 15:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KnnJya1ORtSHjl6qbhImfMS9/fnJjTPTj+DIW8mJNx0=;
        b=qGHiQxdxuQPcaNxo10vg79iKeWKFKHYkJyAnKe36hOhqyM2DevGwpeBm6rbz+5iliq
         um9Iaeo/0Wacd5A2ZIO7+3HZvutXACFL0B/xzUywGIDvuZyFg9s8lZaAUdhLDwYiXzj1
         MDyPO4j3xSfKpTjb7wExJDIiFSQgt+fo0R5nCqEUGqWwz/yGY41LY6w+q8tUQICJrwxF
         QC1ubBV9YFAkzgiL0YAhsADnkqQ6x9Vc6hHw93L/flWoUPtG3I2rD8G4TJlf4xjvXNA8
         kY8I1+TBijz6nCLYJaV9aGA62dh6Wswz9wnzykIAD8HkaJJ9+iXcD7awy9JnupJE23uW
         mOMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KnnJya1ORtSHjl6qbhImfMS9/fnJjTPTj+DIW8mJNx0=;
        b=VBdoqYBk7abpfLRpjqbKJgcxUIRwJMiBY2GdCD8vrZkoNXHm8G6HXUC4L+Dr3X2pOc
         Tnse+JX11m41ZPHPqda86CQ/jz9SStRs2hFckpzVCYjGWInBJA0CmxVjwIYRr7Kc6++Y
         6/IdJyR3cSy1DlezkkdacBLpE6/T4XpO0KWdhMtewm7Li9OM5MYhlqscA0HT+8w3nCAB
         g8G8fyUhQloTGOAUim76EKDgCGo+/C3EbegCM5jzfm3MGpFutmrGAnxB23SImi7ODPuk
         zEZ3rh93yxbHw8ZbV8lm3Nc21wfSOMoQmEtxw2YyoIxy4SptgF8qwkGWfEToDxEsFY3d
         XU7A==
X-Gm-Message-State: AOAM5334+Aa+ItQO8F6zJyQpAFpGBF8aVos+DT4LQhvKaJP/117rL76S
        aKDDDYD8X55z6jQLAZvf7sY=
X-Google-Smtp-Source: ABdhPJyQQbM+5WhBnZs4tZngJ2DkitApFkhScuJU5+9mATofajDRZXbJCONRF0YABzrkeOXefveHtQ==
X-Received: by 2002:a65:5c47:: with SMTP id v7mr8883750pgr.56.1596753037005;
        Thu, 06 Aug 2020 15:30:37 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:2a06])
        by smtp.gmail.com with ESMTPSA id lk16sm8129439pjb.13.2020.08.06.15.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 15:30:36 -0700 (PDT)
Date:   Thu, 6 Aug 2020 15:30:33 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [RFC PATCH bpf-next 7/9] selftests/bpf: add CO-RE relo test for
 TYPE_ID_LOCAL/TYPE_ID_TARGET
Message-ID: <20200806223033.m5fe4cppxz5t3n54@ast-mbp.dhcp.thefacebook.com>
References: <20200804182409.1512434-1-andriin@fb.com>
 <20200804182409.1512434-8-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804182409.1512434-8-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 11:24:07AM -0700, Andrii Nakryiko wrote:
> +
> +SEC("raw_tracepoint/sys_enter")
> +int test_core_type_id(void *ctx)
> +{
> +	struct core_reloc_type_id_output *out = (void *)&data.out;
> +
> +	out->local_anon_struct = bpf_core_type_id_local(struct { int marker_field; });
> +	out->local_anon_union = bpf_core_type_id_local(union { int marker_field; });
> +	out->local_anon_enum = bpf_core_type_id_local(enum { MARKER_ENUM_VAL = 123 });
> +	out->local_anon_func_proto_ptr = bpf_core_type_id_local(_Bool(*)(int));
> +	out->local_anon_void_ptr = bpf_core_type_id_local(void *);
> +	out->local_anon_arr = bpf_core_type_id_local(_Bool[47]);
> +
> +	out->local_struct = bpf_core_type_id_local(struct a_struct);
> +	out->local_union = bpf_core_type_id_local(union a_union);
> +	out->local_enum = bpf_core_type_id_local(enum an_enum);
> +	out->local_int = bpf_core_type_id_local(int);
> +	out->local_struct_typedef = bpf_core_type_id_local(named_struct_typedef);
> +	out->local_func_proto_typedef = bpf_core_type_id_local(func_proto_typedef);
> +	out->local_arr_typedef = bpf_core_type_id_local(arr_typedef);
> +
> +	out->targ_struct = bpf_core_type_id_kernel(struct a_struct);
> +	out->targ_union = bpf_core_type_id_kernel(union a_union);
> +	out->targ_enum = bpf_core_type_id_kernel(enum an_enum);
> +	out->targ_int = bpf_core_type_id_kernel(int);
> +	out->targ_struct_typedef = bpf_core_type_id_kernel(named_struct_typedef);
> +	out->targ_func_proto_typedef = bpf_core_type_id_kernel(func_proto_typedef);
> +	out->targ_arr_typedef = bpf_core_type_id_kernel(arr_typedef);

bpf_core_type_id_kernel() returns btf_id of the type in vmlinux BTF or zero,
so what is the point of above tests? All targ_* will be zero.
Should the test find a type that actually exists in the kernel?
What am I missing?
