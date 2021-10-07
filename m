Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B580425F8A
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 23:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242611AbhJGVvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 17:51:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234061AbhJGVvD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 17:51:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20E60610E6;
        Thu,  7 Oct 2021 21:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633643349;
        bh=wpquOHRgARsEE6I4TUhVbpXVvtc1zn9s+ZzmLeT4X1U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=L4v84mEUYeZw28kcHc0rBoloQefp3kMWYGc8OWE7bF47A34iaqyWStmpfNEEFLXV4
         XTvyTwGfyKKSckIJHzYZSPJsHsUrHfpTpdSz0mSijeRjEET9WtzAjuHPC6DWIES+nt
         VEkhKbgmPRhXqGLn4EhMno6e0Bwo1p5Mtf33vcWkUgNxBmIWRp6ExuIebI2tPNZSH1
         xedqIiHJdylvzBnkJk3uKQjURf62UaUOslcEcXia3+Xf/RUsI9uq8BYyJjSJdfV2o6
         tvkviEJceXNW2mVaOo3ctdFZ9le9GIl9RsCpdMuIjbmh0w+JNfw4nNJfraK0/PWceG
         4FK3Clt39U1xg==
Received: by mail-lf1-f48.google.com with SMTP id n8so28890357lfk.6;
        Thu, 07 Oct 2021 14:49:09 -0700 (PDT)
X-Gm-Message-State: AOAM532HN+fewnD0+KDvIluHuEcmoIGOrlMU1Wfi+bWmtvGs1Mc0I8Vc
        pxgM95FyANb+wSEzr9iUyXdoT/ygsEhBi3Yq958=
X-Google-Smtp-Source: ABdhPJxu3u4xjhQeIcrxHQJqkOPx454nsMj5Cmm95BguRwpdlSdgSNq+Z4MaLsnaAmS4obu0R57nb4ElKioQEkA15as=
X-Received: by 2002:ac2:41d4:: with SMTP id d20mr6787679lfi.598.1633643347492;
 Thu, 07 Oct 2021 14:49:07 -0700 (PDT)
MIME-Version: 1.0
References: <20211006002853.308945-1-memxor@gmail.com> <20211006002853.308945-7-memxor@gmail.com>
 <CAEf4BzZLMkQA3Sb9=Ojpif1UiZo6ecbXCAz7u_Qi7_GEEYfs1A@mail.gmail.com>
In-Reply-To: <CAEf4BzZLMkQA3Sb9=Ojpif1UiZo6ecbXCAz7u_Qi7_GEEYfs1A@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 7 Oct 2021 14:48:56 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6+UaaHzMo2PoW6fUBOvts9w2d8VY2UR7h9kVC+Xbh6NQ@mail.gmail.com>
Message-ID: <CAPhsuW6+UaaHzMo2PoW6fUBOvts9w2d8VY2UR7h9kVC+Xbh6NQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 6/6] bpf: selftests: Fix memory leak in test_ima
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 5, 2021 at 9:46 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Oct 5, 2021 at 5:29 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> >
> > The allocated ring buffer is never freed, do so in the cleanup path.
> >
> > Fixes: f446b570ac7e (bpf/selftests: Update the IMA test to use BPF ring buffer)
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
>
> Please stick to "selftests/bpf: " prefix which we use consistently for
> BPF selftests patches.
>
> Other than that LGTM.
>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>
