Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6A646B183
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 04:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234224AbhLGDjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 22:39:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbhLGDjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 22:39:01 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D30FC061746;
        Mon,  6 Dec 2021 19:35:32 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id d10so37206653ybe.3;
        Mon, 06 Dec 2021 19:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VhnVwEWLdblOjr90EMEMGhUapGYQEMmVHRRWBGP+yjw=;
        b=KOwS4EtQuhp4PrM6HVNezG+TT+Q7knK5h5qA8nxKdQhj06qYbByS10l4IPBnwjo7N5
         h4UUzStinEkO6vAssGrKkDO3/PMGKcYJx3M+8lKnR9PwpyuJjOkiBQNEGJhsAh5rvvVH
         i7DHd3dBpTLNwLcJTi32jDw/4iycLdQh+Vzc0+eNvqCCcIFx7IM2NuWAUlgrJ3NPwpMc
         KA5qlBJtwsRvyxQZXB3x3XXaLXEvQgfyQCqm+FbNJOglEkMvjVI+zmQD4Qcmt4Z3I20j
         3rivXIFNbdxxdZcF27goiZk89ezC0WTkdhwsIZSDzqWCq6BB0K+FN5ALDNxN7Ln77BWe
         rzjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VhnVwEWLdblOjr90EMEMGhUapGYQEMmVHRRWBGP+yjw=;
        b=p4LbUmX3yeHoO04SWmG4TaJ7Oi5etchiGrvpVwC5frihNQCBeDvvEnTpihuVgJL9WP
         oCABwKBrRXe/biZjlw3OikiYGwZcoluNvJ/us509QQ9UzyBSKNm1mSE1/5PJtTJ6NjMx
         GgQJ2w8FglkmhRuIh3ShW4enmWxyd9pe7q5upEGzQ2y3JScElnVebwFJEQlGodeXfDcB
         Vz5WEqJw+zOyX70/R/oc6X9Q5/ZAhLvdYFLKbE2B1i1OP0b7uyzi4SMVxmQ4BBs7vMVw
         vg98WZQQAmQ9aYjYuLFX8gWy3llAgoSK0LCNe+Xc1uNXKbcoiSXVXJvKIrymMRvJxmsy
         iwiw==
X-Gm-Message-State: AOAM531yU5BXubfC/Y/qImLnsgfcS7P31sxPk/EVPy8cle1f4hsojwPX
        ZfBPluaIc796saDel8aVZAZaS0DWRxgqYfol/9g=
X-Google-Smtp-Source: ABdhPJynZCr7m7alFn9eEw0KlD0b7XnSu9eeqFbyzTLyGtGWoaVXfKduwnIJx828coovBV12MA4M5c6d7qqK6rXsO1o=
X-Received: by 2002:a25:84c1:: with SMTP id x1mr48226892ybm.690.1638848131288;
 Mon, 06 Dec 2021 19:35:31 -0800 (PST)
MIME-Version: 1.0
References: <20211203195004.5803-1-alexandr.lobakin@intel.com>
In-Reply-To: <20211203195004.5803-1-alexandr.lobakin@intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Dec 2021 19:35:20 -0800
Message-ID: <CAEf4BzZLt_ojTAf-=1nO2R7F8ROUwBdUsfp_W9NaAk-XSNEYmA@mail.gmail.com>
Subject: Re: [PATCH bpf 0/2] samples: bpf: fix build issues with Clang/LLVM
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 3, 2021 at 11:55 AM Alexander Lobakin
<alexandr.lobakin@intel.com> wrote:
>
> Samples, at least XDP ones, can be built only with the compiler used
> to build the kernel itself.
> However, XDP sample infra introduced in Aug'21 was probably tested
> with GCC/Binutils only as it's not really compilable for now with
> Clang/LLVM.
> These two are trivial fixes addressing this.
>
> Alexander Lobakin (2):
>   samples: bpf: fix xdp_sample_user.o linking with Clang
>   samples: bpf: fix 'unknown warning group' build warning on Clang
>

There were conflicts when applying, but luckily I was the one who
caused this conflict in XDP_SAMPLE_CFLAGS, so I just fixed it up
locally and pushed to bpf-next. Thanks.

>  samples/bpf/Makefile          | 5 +++++
>  samples/bpf/Makefile.target   | 2 +-
>  samples/bpf/xdp_sample_user.h | 2 ++
>  3 files changed, 8 insertions(+), 1 deletion(-)
>
> --
> 2.33.1
>
