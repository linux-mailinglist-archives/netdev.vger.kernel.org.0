Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06029474530
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbhLNOe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbhLNOe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 09:34:26 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D394C061574;
        Tue, 14 Dec 2021 06:34:26 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id h24so14459979pjq.2;
        Tue, 14 Dec 2021 06:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XNIpgEgyqX/6Bw6X5oNpQZi1Bxzsn2FqGeRz77dtVlM=;
        b=jWGzXuMqVaeunHZsSKXHD+jr45avJ2j3b+k0/75a+RzVmXdpegXpGwI/bIPBY2PqtN
         19WRXlL2w2r+tGjGiKJgShc0a+TpzZI6fiuBPIZrKsR0xgtKwJ1/a9ylq5/LAVXraH8K
         7Kge6tmdeSc0dVher3GP+uwyRxn9Qs18EcZRP3DoV40piHYJ6eic8uvd39sL9XgzKCFF
         cndcX97ZYvSUFj6MgLwjNOdnCY1474jJ4EcUdpB/EfPB2w8cHf1F2AEeOgGsD4XXpS4s
         ae1VWHqGdcdMyTusMeEj225pEBiG3b8w8WdfYuWXjOCm7spbsH+Ubfp+mwhh+2luAsN1
         9iqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XNIpgEgyqX/6Bw6X5oNpQZi1Bxzsn2FqGeRz77dtVlM=;
        b=VsN0KWtFeFjbGPz4b+AVVXCWXrGZoyUMwlSfYIl+XCYnpWoBCWet9BhfKn/FrEgFYV
         311U5XKlsBaw1XZCfJMgDSb3+Ng9QgSccmDfldNZWsMtPViyQHuOyD0hqrF0VStwreOU
         vI+IOf52x/mXNRqUnH5UgDDhbTnojDJTi+MG8Wsg9LNON2k4G3v+dlERHnPjFMN4TLNz
         WCRsry1tUzkiclqHItn+aNzbE1FdSylPvTaW7QquKHx1I793f580D8ddXX/ZeORA1fmg
         Dm0k3cXXrpFhbmwxIAEhokbo+xCXYSOBNggDwrTNwtVPkUI5dnTgTmrSTh2ReepO4tP1
         NZaw==
X-Gm-Message-State: AOAM533XhSeiJVqdT9nJc7bTqQdy7woiUS128sMC2ZBdAFyANlbPg5iS
        P1ijtQp23srt+9KTQ0z79/k=
X-Google-Smtp-Source: ABdhPJwL6pjVxqX85RYCRWOnLVkgjrj6dE6R7eM6PE29S21ohF9IIzSPbCsDDSSXZ7rOJDYpN6LVEA==
X-Received: by 2002:a17:902:9b8c:b0:148:9c40:690c with SMTP id y12-20020a1709029b8c00b001489c40690cmr1672666plp.8.1639492465433;
        Tue, 14 Dec 2021 06:34:25 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id g15sm57165pfj.144.2021.12.14.06.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 06:34:25 -0800 (PST)
Date:   Tue, 14 Dec 2021 20:04:22 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 9/9] selftests/bpf: Add test for unstable CT
 lookup API
Message-ID: <20211214143422.kux4euw6f6vy5fm4@apollo.legion>
References: <20211210130230.4128676-1-memxor@gmail.com>
 <20211210130230.4128676-10-memxor@gmail.com>
 <da66687b-17fb-caa6-b5aa-7dff6b7bcb63@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da66687b-17fb-caa6-b5aa-7dff6b7bcb63@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 07:43:13PM IST, Maxim Mikityanskiy wrote:
> On 2021-12-10 15:02, Kumar Kartikeya Dwivedi wrote:
> > This tests that we return errors as documented, and also that the kfunc
> > calls work from both XDP and TC hooks.
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> > [...]
> > +
> > +#define nf_ct_test(func, ctx)                                                  \
> > +	({                                                                     \
> > +		struct bpf_ct_opts opts_def = { .l4proto = IPPROTO_TCP,        \
> > +						.netns_id = -1 };              \
>
> I noticed that when CONFIG_NF_CONNTRACK=m, struct bpf_ct_opts doesn't get
> added to vmlinux.h. What is the right way to get definitions of structs from
> modules in BPF programs? Are they supposed to be part of vmlinux.h?
>

Right, you'll have to do:
# bpftool btf dump file /sys/kernel/btf/nf_conntrack format c > vmlinux.h
after loading the module. This will have the definitions for vmlinux BTF +
nf_conntrack BTF.

> [...]

--
Kartikeya
