Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C403B18BB
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhFWLT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:19:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29729 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230202AbhFWLT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:19:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624447058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b/3yS7LjHTHKfwybIlEpPmbf7+iHJm11BxEfhxSMx4s=;
        b=SxQGLlR7g284IO5qTrBzTivM1l94i6wUUv8GFWr2FVWvd3LYWhyPb3eIiBtaJG8+02f7Qk
        ARb588eA81/RW7o4yYZiYSSV2lx/dhJkUvmmC5Hm6lI4n6Iu2S7GQ2ioXW9FMrjbw22n1X
        z5c0IJPE91L3PJ/Gc3lePSb9UQY0yDw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-IsLY0TH7NESPMOVkEQS-4Q-1; Wed, 23 Jun 2021 07:17:37 -0400
X-MC-Unique: IsLY0TH7NESPMOVkEQS-4Q-1
Received: by mail-ej1-f71.google.com with SMTP id f1-20020a1709064941b02903f6b5ef17bfso833947ejt.20
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 04:17:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=b/3yS7LjHTHKfwybIlEpPmbf7+iHJm11BxEfhxSMx4s=;
        b=TYZT0Kpgp95z40GYYHixPsd4+7Y6StcW2K9FV5A45jMgkFt41iPHcVGPO7xyhTGgG6
         Wm3hb50amkB3CnF8/bzSjgm/wKYV/WJ2YOftyEBZJxGXJVz2eOF7PZLmCJ/YsAjr/lUR
         MdhXrbjFAz7FV7Gflgzu0s4ircB+n/YoFA7hlEYfDvnXZ3WpFwaI9eOhQs/5a+Z9uSMk
         jYkBivOaWJzHK+g1B1Jczvb0JaTgiqfGrHaU4EDPLt97gKPeToLtklGw0aOFcV0fsb7d
         gljmLRi+ZhEaRzsLll+rOuaVo8SYMmvHfD8VDs87Rf2y0GtTSXUIYhcVM7JWJAVLhpS2
         6QXg==
X-Gm-Message-State: AOAM533UZOuECMqNo+mMOmDNB7eWqQm27Mf4NpUPiXQcZQFjcEZwrZnA
        ReZWyT3Sf37fMr0AtBDmvVifaghuSZN67JRTe4qmf99DcaVLOPdb7Z62wySC2kqXtppSdJL8arM
        2mo3BK8A+DnK6eYrO
X-Received: by 2002:a17:907:628a:: with SMTP id nd10mr9446195ejc.326.1624447056203;
        Wed, 23 Jun 2021 04:17:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz25B0vO27pZCcHDvVK0CgKzd9Bg8TdjridQdPvHb/yGoxtJKIdGkfYPe6XcUq0TCELpd5TLQ==
X-Received: by 2002:a17:907:628a:: with SMTP id nd10mr9446166ejc.326.1624447056034;
        Wed, 23 Jun 2021 04:17:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id cd4sm7154729ejb.104.2021.06.23.04.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 04:17:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EC264180730; Wed, 23 Jun 2021 13:17:34 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, netdev@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v3 5/5] bpf: update XDP selftests to not fail
 with generic XDP
In-Reply-To: <20210622202835.1151230-6-memxor@gmail.com>
References: <20210622202835.1151230-1-memxor@gmail.com>
 <20210622202835.1151230-6-memxor@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 23 Jun 2021 13:17:34 +0200
Message-ID: <878s30omnl.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

> Generic XDP devmaps and cpumaps now allow setting value_size to 8 bytes
> (so that prog_fd can be specified) and XDP progs using them succeed in
> SKB mode now. Adjust the checks.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c | 4 ++--
>  tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
> index 0176573fe4e7..42e46d2ae349 100644
> --- a/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
> @@ -29,8 +29,8 @@ void test_xdp_with_cpumap_helpers(void)
>  	 */
>  	prog_fd = bpf_program__fd(skel->progs.xdp_redir_prog);
>  	err = bpf_set_link_xdp_fd(IFINDEX_LO, prog_fd, XDP_FLAGS_SKB_MODE);
> -	CHECK(err == 0, "Generic attach of program with 8-byte CPUMAP",
> -	      "should have failed\n");
> +	CHECK(err, "Generic attach of program with 8-byte CPUMAP",
> +	      "shouldn't have failed\n");

There's a comment right above this that is now wrong... Also, this
program is never being detached.

>  	prog_fd = bpf_program__fd(skel->progs.xdp_dummy_cm);
>  	map_fd = bpf_map__fd(skel->maps.cpu_map);
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
> index 88ef3ec8ac4c..861db508ace2 100644
> --- a/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
> @@ -31,8 +31,8 @@ void test_xdp_with_devmap_helpers(void)
>  	 */
>  	dm_fd = bpf_program__fd(skel->progs.xdp_redir_prog);
>  	err = bpf_set_link_xdp_fd(IFINDEX_LO, dm_fd, XDP_FLAGS_SKB_MODE);
> -	CHECK(err == 0, "Generic attach of program with 8-byte devmap",
> -	      "should have failed\n");
> +	CHECK(err, "Generic attach of program with 8-byte devmap",
> +	      "shouldn't have failed\n");

... same here


-Toke

