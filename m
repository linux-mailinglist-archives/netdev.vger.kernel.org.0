Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68F8D13D033
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 23:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730716AbgAOWi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 17:38:27 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45694 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730697AbgAOWiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 17:38:23 -0500
Received: by mail-qt1-f196.google.com with SMTP id w30so17232714qtd.12;
        Wed, 15 Jan 2020 14:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vhOCiRt319pWUsd7g17NDpKsG5GEE5LkfuLBKivRRdo=;
        b=PiI0p1wtxhJFe3JuvULZ3qXgyfwYoP0TWd6I3ovCmVlBtpaV0ii8iJt5TRrPgUhGZA
         oHGzGCMVaaMgHILcUY3dD3n8og3Er+QgKgTIFeOv5ewrrpvJixIdVZdBnQQB8JmM/LLJ
         4VJQWuqFkzd53TgQn6xZ2J1tbq+esiIngPA/5OEQsZ5wAPlJXNzMcMgg20CGTIgP0bA4
         IbHTv71QRRswXew9pOWiH5CDlL4c/qacZ4qdqM0iqptdwTyVB3RUoFury/Sx6TuiAMQQ
         0ICDZQz0Oby20/wYukY7j7gxVZAXA1g6T1xLcWjs0ttGhvnrXy/6Q5VtAEvWxb32W+/u
         mu9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vhOCiRt319pWUsd7g17NDpKsG5GEE5LkfuLBKivRRdo=;
        b=sUlAGvhdWOlmpSjE30vBr98/w4NlwSLKnARGkBNwD6E4K+9uGSuZ3SuDt2Xt2VffuU
         8EDqJV84J1dEw0vlvgOVERNRDVGic39FSCmZHXeg6Nyg2kDYhFyTU3617g1NFRi6nhzh
         BDo3lqX1Oo6f++KeKDIhyoydweYScIy6fNCAN6UBuHb4x6XKo4Smx0bjU8MSCTo9ibmv
         qLDP+LC+u3tmlMyuxTr1SWtTP24xPXBsDmy7rBcdXq3F9MJpg+X6+kwS+OhW7/AWMuGu
         QXTXMvUCCKaUv66uU14KepJ6pFslXJMl9jdW+FjbvjCCLgFIHiNoC9yQmikwgHPOv3xn
         uHmg==
X-Gm-Message-State: APjAAAXTBIB7ywnFwg9e7cNmsdA8iCq/9mHE4LYxTNtDW3sYw4tc2YjW
        4fML05Vm66ICssL4/wN1i0dD1vp24sG+pE0jUMOXnult
X-Google-Smtp-Source: APXvYqwOE9iNw5KvDDLQQfwsFh5E41X6mxODWQ38ud8hif8BGNtHEvEeIXhkMs9PN51lEr462yRkPzi1jEpb1Sd/2+w=
X-Received: by 2002:ac8:7b29:: with SMTP id l9mr865008qtu.141.1579127902500;
 Wed, 15 Jan 2020 14:38:22 -0800 (PST)
MIME-Version: 1.0
References: <20200115222241.945672-1-kafai@fb.com> <20200115222300.946936-1-kafai@fb.com>
In-Reply-To: <20200115222300.946936-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jan 2020 14:38:11 -0800
Message-ID: <CAEf4BzaAehB6v+4ZD1yGcu66iaJN2ptR-hVVND5JFxag3ZsO1Q@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/5] libbpf: Expose bpf_find_kernel_btf as a LIBBPF_API
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 2:26 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch exposes bpf_find_kernel_btf() as a LIBBPF_API.
> It will be used in 'bpftool map dump' in a following patch
> to dump a map with btf_vmlinux_value_type_id set.
>
> bpf_find_kernel_btf() is renamed to libbpf_find_kernel_btf()
> and moved to btf.c.  As <linux/kernel.h> is included,
> some of the max/min type casting needs to be fixed.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

Thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/btf.c      | 102 ++++++++++++++++++++++++++++++++++++---
>  tools/lib/bpf/btf.h      |   2 +
>  tools/lib/bpf/libbpf.c   |  93 ++---------------------------------
>  tools/lib/bpf/libbpf.map |   1 +
>  4 files changed, 102 insertions(+), 96 deletions(-)
>

[...]
