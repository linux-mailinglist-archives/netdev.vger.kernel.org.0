Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CABB46D8A5
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 17:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234710AbhLHQmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 11:42:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:25344 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234732AbhLHQlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 11:41:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638981499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3w5d+VyTnk5k7iQbsZq9TK6rK+JJNoE/0JGR0T2qY9s=;
        b=Hv0EToF/BQTsE6JCCjdnOSYTG6Js3RI/895EerR/3l7+XD3FOrH8B6j046OUJQKikdtObc
        o69ZvI2M1A159RiSiJSCSbGMJFMdxhclUfU2nx/+fScA3COP6Xo3fNZbO7Q9qgWFWFYvwk
        UyYq1MgPNmuypq+53Bi/pP7ObENd7xA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-sbuzzu4ZM06b2Pt6UGtNhg-1; Wed, 08 Dec 2021 11:38:18 -0500
X-MC-Unique: sbuzzu4ZM06b2Pt6UGtNhg-1
Received: by mail-wm1-f69.google.com with SMTP id a64-20020a1c7f43000000b003335e5dc26bso1548309wmd.8
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 08:38:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3w5d+VyTnk5k7iQbsZq9TK6rK+JJNoE/0JGR0T2qY9s=;
        b=KG1zHIe7Pr98FS/VJ6xHzu5P8kCG1kN77Jg7ivBYiJdb5VuxeIzPXM1SHvw66Hf/wk
         pPXCSllvKnydyXkLg4jlOMVe9ELN5ARlFMoB6Tu2TjVEfq/MwvACsJrrlBuT14PrMuVV
         EU7PgWw/b85WnFHsXYDHoh5jfv8TtuX6DRRhqnoLYb6B61wh/m8936pZDcVF89ban4dH
         +qq1BRnUL/en4hgtLhShQxBjVdNWwXyyU9GInw69bWYItRZhKd8n/zutgCNOwEUeG2Se
         +pprkYtIxXae7h58QlIrCa+UyqThVsruNK1sVKiNWtwzCDX2BEyEJL8kulwAgwSLxu+i
         LrgA==
X-Gm-Message-State: AOAM532kUp3+OlJeeM1yXWWD9d+hbM8p9kANFJyjHLu+k/Nb39gGzmSo
        bEo5vv1ohBXLl1wE1Y5XGq7tKnmGKKkH2wOry5cT6KZo27kpWt1VhPinA0pGlgNGkZ0Iban7laE
        CGzui+APZsLwL35o7
X-Received: by 2002:a5d:59aa:: with SMTP id p10mr15396591wrr.1.1638981497262;
        Wed, 08 Dec 2021 08:38:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxGeE3GYy7AvVm/hh/SIoFY65MkYEEB8o232bOiUIAgRW94/gAYUEE105B2sQUeWhDfqoc6og==
X-Received: by 2002:a5d:59aa:: with SMTP id p10mr15396556wrr.1.1638981496983;
        Wed, 08 Dec 2021 08:38:16 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id f7sm7855427wmg.6.2021.12.08.08.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 08:38:16 -0800 (PST)
Date:   Wed, 8 Dec 2021 17:38:14 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: Add tests for
 get_func_[arg|ret|arg_cnt] helpers
Message-ID: <YbDfdiW3/uPT3J1O@krava>
References: <20211204140700.396138-1-jolsa@kernel.org>
 <20211204140700.396138-4-jolsa@kernel.org>
 <7df54ca3-1bae-4d54-e30f-c2474c48ede0@fb.com>
 <Ya+kg3SPcBU4loIz@krava>
 <CAEf4BzbAVO-SGub8+haDayhnL_VLyYAof8eUB_d6Qp18yC2Adw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbAVO-SGub8+haDayhnL_VLyYAof8eUB_d6Qp18yC2Adw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 02:54:33PM -0800, Andrii Nakryiko wrote:

SNIP

> > > > +__u64 test1_result = 0;
> > > > +SEC("fentry/bpf_fentry_test1")
> > > > +int BPF_PROG(test1)
> > > > +{
> > > > +   __u64 cnt = bpf_get_func_arg_cnt(ctx);
> > > > +   __u64 a = 0, z = 0, ret = 0;
> > > > +   __s64 err;
> > > > +
> > > > +   test1_result = cnt == 1;
> > > > +
> > > > +   /* valid arguments */
> > > > +   err = bpf_get_func_arg(ctx, 0, &a);
> > > > +   test1_result &= err == 0 && (int) a == 1;
> > >
> > >
> > > int cast unnecessary? but some ()'s wouldn't hurt...
> >
> > it is, 'a' is int and trampoline saves it with 32-bit register like:
> >
> >   mov    %edi,-0x8(%rbp)
> >
> > so the upper 4 bytes are not zeroed
> 
> oh, this is definitely worth a comment, it's quite a big gotcha we'll
> need to remember


ok, will add comment for that

jirka

> 
> 
> >
> > >
> > >
> > > > +
> > > > +   /* not valid argument */
> > > > +   err = bpf_get_func_arg(ctx, 1, &z);
> > > > +   test1_result &= err == -EINVAL;
> > > > +
> > > > +   /* return value fails in fentry */
> > > > +   err = bpf_get_func_ret(ctx, &ret);
> > > > +   test1_result &= err == -EINVAL;
> > > > +   return 0;
> > > > +}
> > > > +
> > > > +__u64 test2_result = 0;
> > > > +SEC("fexit/bpf_fentry_test2")
> > > > +int BPF_PROG(test2)
> > > > +{
> > > > +   __u64 cnt = bpf_get_func_arg_cnt(ctx);
> > > > +   __u64 a = 0, b = 0, z = 0, ret = 0;
> > > > +   __s64 err;
> > > > +
> > > > +   test2_result = cnt == 2;
> > > > +
> > > > +   /* valid arguments */
> > > > +   err = bpf_get_func_arg(ctx, 0, &a);
> > > > +   test2_result &= err == 0 && (int) a == 2;
> > > > +
> > > > +   err = bpf_get_func_arg(ctx, 1, &b);
> > > > +   test2_result &= err == 0 && b == 3;
> > > > +
> > > > +   /* not valid argument */
> > > > +   err = bpf_get_func_arg(ctx, 2, &z);
> > > > +   test2_result &= err == -EINVAL;
> > > > +
> > > > +   /* return value */
> > > > +   err = bpf_get_func_ret(ctx, &ret);
> > > > +   test2_result &= err == 0 && ret == 5;
> > > > +   return 0;
> > > > +}
> > > > +
> > > > +__u64 test3_result = 0;
> > > > +SEC("fmod_ret/bpf_modify_return_test")
> > > > +int BPF_PROG(fmod_ret_test, int _a, int *_b, int _ret)
> > > > +{
> > > > +   __u64 cnt = bpf_get_func_arg_cnt(ctx);
> > > > +   __u64 a = 0, b = 0, z = 0, ret = 0;
> > > > +   __s64 err;
> > > > +
> > > > +   test3_result = cnt == 2;
> > > > +
> > > > +   /* valid arguments */
> > > > +   err = bpf_get_func_arg(ctx, 0, &a);
> > > > +   test3_result &= err == 0 && (int) a == 1;
> > > > +
> > > > +   err = bpf_get_func_arg(ctx, 1, &b);
> > > > +   test3_result &= err == 0;
> > >
> > >
> > > why no checking of b value here?
> >
> > right, ok
> >
> > >
> > > > +
> > > > +   /* not valid argument */
> > > > +   err = bpf_get_func_arg(ctx, 2, &z);
> > > > +   test3_result &= err == -EINVAL;
> > > > +
> > > > +   /* return value */
> > > > +   err = bpf_get_func_ret(ctx, &ret);
> > > > +   test3_result &= err == 0 && ret == 0;
> > > > +   return 1234;
> > > > +}
> > > > +
> > > > +__u64 test4_result = 0;
> > > > +SEC("fexit/bpf_modify_return_test")
> > > > +int BPF_PROG(fexit_test, int _a, __u64 _b, int _ret)
> > > > +{
> > > > +   __u64 cnt = bpf_get_func_arg_cnt(ctx);
> > > > +   __u64 a = 0, b = 0, z = 0, ret = 0;
> > > > +   __s64 err;
> > > > +
> > > > +   test4_result = cnt == 2;
> > > > +
> > > > +   /* valid arguments */
> > > > +   err = bpf_get_func_arg(ctx, 0, &a);
> > > > +   test4_result &= err == 0 && (int) a == 1;
> > > > +
> > > > +   err = bpf_get_func_arg(ctx, 1, &b);
> > > > +   test4_result &= err == 0;
> > >
> > >
> > > same, for consistency, b should have been checked, no?
> >
> > ok
> >
> > thanks,
> > jirka
> >
> 

