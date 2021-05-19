Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418C13895BD
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 20:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhESStF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 14:49:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230192AbhESStF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 14:49:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04EFE6135F;
        Wed, 19 May 2021 18:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621450065;
        bh=pp5A433lvyiqKfm4cuGJF94wkrM49Tu27uTJcH/zrJA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PGE1pUFIZFvsWGGwwyGOud54Gs6jWGSJdb565EJlOv7xRvZKOcg/U/TVtq+7x1T/I
         XkPy3yLoglV2/jI5fuj1tbapofJzY9dkL2sxtV5wScqhuPAok6yp8Kcku1ataKGw8U
         h3cuIY4qlX4V6PiETEk5iCRj+iacURZXK4yNUJd1DVPoGl9xwMgymg9wxn4+YgeZc4
         Krn2U2OCOm1iVEuwB3+BbqqT3KNFLwzOpRv7QVluIdmftX6Y4ojufqgllW2GQ7l0CE
         5cAw1gf2IIcfmhzUJZ36jjoGjEfghap1mhTeXQL1x1obXRFb1rJPtVXvyiOxlK9LCt
         ZckiYMQNR1Q9g==
Received: by mail-lf1-f54.google.com with SMTP id w33so12672449lfu.7;
        Wed, 19 May 2021 11:47:44 -0700 (PDT)
X-Gm-Message-State: AOAM533NcouGW0yrR1wfoIWaHOqCmB2ViHFjxiUGBvI6wMVvL3+L4q42
        5sM6JXVh2YGfspEQ/rPbvhIJowf/WZ8bpYQCsKU=
X-Google-Smtp-Source: ABdhPJx9KtjbK06p9pon23X1IIzG0WmloUwgdGPWx5VcZsuruUW4LgqTOqC9RRwponyEhFFj5wXO2JvmPEavjBsX08c=
X-Received: by 2002:ac2:5b12:: with SMTP id v18mr603220lfn.261.1621450063294;
 Wed, 19 May 2021 11:47:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210517225308.720677-1-me@ubique.spb.ru> <20210517225308.720677-4-me@ubique.spb.ru>
In-Reply-To: <20210517225308.720677-4-me@ubique.spb.ru>
From:   Song Liu <song@kernel.org>
Date:   Wed, 19 May 2021 11:47:32 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6J3KR9Yy+avL3ayZ7G6ypJwK3Dg+wvhsG5wgP6_fL1CA@mail.gmail.com>
Message-ID: <CAPhsuW6J3KR9Yy+avL3ayZ7G6ypJwK3Dg+wvhsG5wgP6_fL1CA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 03/11] bpfilter: Add IO functions
To:     Dmitrii Banshchikov <me@ubique.spb.ru>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 18, 2021 at 11:06 PM Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
>
> Introduce IO functions for:
> 1) reading and writing data from a descriptor: read_exact(), write_exact(),
> 2) reading and writing memory of other processes: pvm_read(), pvm_write().
>
> read_exact() and write_exact() are wrappers over read(2)/write(2) with
> correct handling of partial read/write. These functions are intended to
> be used for communication over pipe with the kernel part of bpfilter.
>
> pvm_read() and pvm_write() are wrappers over
> process_vm_readv(2)/process_vm_writev(2) with an interface that uses a
> single buffer instead of vectored form. These functions are intended to
> be used for readining/writing memory buffers supplied to iptables ABI
> setsockopt(2) from other processes.
>
> Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>

The code looks correct, so

Acked-by: Song Liu <songliubraving@fb.com>

However, I am not sure whether we really want these wrapper functions.

[...]
