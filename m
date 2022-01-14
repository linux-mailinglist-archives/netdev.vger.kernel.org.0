Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374C448E36E
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 05:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbiANEwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 23:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiANEv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 23:51:58 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968B4C061574;
        Thu, 13 Jan 2022 20:51:58 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id w204so1764926pfc.7;
        Thu, 13 Jan 2022 20:51:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FEfIhylZgJlpKteWfIZHJq2IWx8YAn4GFncDmFXmViU=;
        b=LSS2drKcoKH9uoPViOzC3bbh/CdUPdF9Urim1NUYooS+fQf2yiSBf9UI2ldbAiy7Jp
         wwj7y7hkU/NVUXUXWwAfhMZaXwtIiDLUKbp5zLtArbyEhyLjt0UcI5G2HdOteIVBoOwY
         lISdaXTM0ANEdL0U3mjpg34MUkUw3to3sJIT/oYn9jdOvu5nuYsykZhup+K+WV+Fbo4g
         a+/XteAOr55EwWP200LTPktpSDVgFuEO2dN0JjDUdpqfR3C4yRJGMsi0bT6LdDBjDG1S
         1aiElyOEbuaY8IWfFpuffB4VKDt2vJoU77rsru8YkWfoa2qAq4FCWlWP8L99ww0qD6CG
         0clg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FEfIhylZgJlpKteWfIZHJq2IWx8YAn4GFncDmFXmViU=;
        b=vPmXiITViEsdIgqLUpP+Y/jukRzvzcBaCRMT9936nkMlD3dMYvyzR2z10exMhf2+lv
         qngQ0sEMolVx22BIst3kcsDftvlFDxRDyGlTHj+J7wW3/x2tp1D6MOSMMBzhNh5SHTsw
         TXOCJWHqojGVj+z+N4qf+Pl31GWSqSjUhyFjTGO/sIdquqkfH3YYpr2hBh/EfToGnlDR
         PfbcGYI2PiHjd/hGtZ4vvnu1hP2UXaLnIJC98v5C7mq0hZ+4+WXxMqFyTkjuEoyEo9VV
         VkIo6HxvOGWLzHB/mG/QScfh/WUj2LkadouRI/6rjzlBckojf5YhfDUVU0sIOAD9ZYSG
         UHJw==
X-Gm-Message-State: AOAM531n5aJo0A8wlfiEkiEkVE1YNlZe0t6OXTF1BF/8N7K6GM1bV2lX
        9jSwiLiD7d9QQoJZ02x/Bo8=
X-Google-Smtp-Source: ABdhPJwgHqnIfOB30mcUYuIjY+6UBsCLZYY4NBxvNl6O+BofHSy9KE/mNFFji/sLkBYY9S9y2/3RtA==
X-Received: by 2002:a63:3f03:: with SMTP id m3mr6687388pga.470.1642135917992;
        Thu, 13 Jan 2022 20:51:57 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:502e:73f4:8af1:9522])
        by smtp.gmail.com with ESMTPSA id z18sm4420469pfe.146.2022.01.13.20.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 20:51:57 -0800 (PST)
Date:   Fri, 14 Jan 2022 10:21:14 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v7 07/10] selftests/bpf: Add test for unstable
 CT lookup API
Message-ID: <20220114045114.pre4iyblsdntkmiy@apollo.legion>
References: <20220111180428.931466-1-memxor@gmail.com>
 <20220111180428.931466-8-memxor@gmail.com>
 <20220113223557.45d5czezncjwekge@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113223557.45d5czezncjwekge@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 04:05:57AM IST, Alexei Starovoitov wrote:
> On Tue, Jan 11, 2022 at 11:34:25PM +0530, Kumar Kartikeya Dwivedi wrote:
> > +
> > +#define nf_ct_test(func, ctx)                                                  \
> > +	({                                                                     \
> > +		struct bpf_ct_opts opts_def = { .l4proto = IPPROTO_TCP,        \
> > +						.netns_id = -1 };              \
> > +		struct bpf_sock_tuple bpf_tuple;                               \
> > +		struct nf_conn *ct;                                            \
> > +		__builtin_memset(&bpf_tuple, 0, sizeof(bpf_tuple.ipv4));       \
> > +		ct = func(ctx, NULL, 0, &opts_def, sizeof(opts_def));          \
>
> Have you tried converting the macro to static always_inline
> and passing func as a pointer to a function?
> The first argument 'ctx' is different, but if you prototype it
> in this static inline as (*fn)(void *ctx)
> and type case it later in nf_skb/xdp_ct_test() that should still work?

Good idea, I'll switch it to this in the next version.

--
Kartikeya
