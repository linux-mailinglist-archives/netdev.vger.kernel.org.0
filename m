Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2CE43E7F2
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 20:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhJ1SHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 14:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbhJ1SHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 14:07:00 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B62C061570;
        Thu, 28 Oct 2021 11:04:33 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id 67so17410957yba.6;
        Thu, 28 Oct 2021 11:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IFJPYBM5GwrHA1lc6U2zZrfuoCSypc/v5xuYCReD7TI=;
        b=IrKtfUMZERI7+vaHnlDtMhII4VvLQEZgrtyRP7M3hZuyJ0+Lj/E3hUYlJ2gjZT/Vzk
         HMIjkQjioPSiKFfK03622sRfP/Wszw00oX+L5r1Q1RBt9mdulkRG8uozay9bP16Y5njs
         2k06ObfYocFa/aDX+8aLU3VkRzt+sIlZIVnfKoVtwL/h/Zszk1SR3bMDGB+naVpM/2fB
         yWZvBq8+WRH49VCM5shwEJ++dEsye+F+lQokjIRG0JxRmfhABMj/kaD2GcjslcPuRG2M
         wCGU6jdDzu8rV7ryBdBRZ9+eXLtQj4SAQdas9qercV6DChMzXjwYmZGqnyHN7aHQjYng
         Lb9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IFJPYBM5GwrHA1lc6U2zZrfuoCSypc/v5xuYCReD7TI=;
        b=d22Visff6uhXQPXuonmO3wbNKYLYMvakTNOwnL14xPxJjm/xMEpD5MQMJwLlSXQ0mF
         qIiHogyf9npwkkshmgRZ+qa0oXOO1318aEM2JfIttiKy8PFIFZ/4IgyCM7o2xeQgJTe6
         5RwlWh6OOjNqv0Z9reEqLR7ZNEagNQTPvuZoP0DvqagutbVUCv+lNXIlsvBJsdcUgu3W
         XvLL9mmChshyGn72o0Ree9pXIVoo0wbDGJm+EUpwQu449zlE1+cfPtmu0D4muAFRtFzr
         jVqMMBbCKP/c37jK3QBULvY+yjA5SJnD4ZsQXZoKkJp2D0tRg/T0+pTtWf+IKuP4BJLP
         cZJQ==
X-Gm-Message-State: AOAM532iZk8KahcqkUDspVeStfNI70HhXY0jDkXrHt03bKMcH/kicj+f
        DrN+9Mk4xRVDddo+QEwhDAkc4eZO/yd3uTaOgPU=
X-Google-Smtp-Source: ABdhPJxRWKDluSagO8+TAkpapbgTmIkT+bqH+mnQzOKFJ/vt+5bTHEtrVTTXNZacqg3sr6et1xVwn2kb7IhcqKQbUnA=
X-Received: by 2002:a25:afcf:: with SMTP id d15mr5462813ybj.433.1635444272684;
 Thu, 28 Oct 2021 11:04:32 -0700 (PDT)
MIME-Version: 1.0
References: <20211028063501.2239335-1-memxor@gmail.com> <20211028063501.2239335-6-memxor@gmail.com>
In-Reply-To: <20211028063501.2239335-6-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 28 Oct 2021 11:04:21 -0700
Message-ID: <CAEf4BzY9jq+hcJgBV5yX5xm1WzH4aqOqPSF9pzeYfUGwZ77PYA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 5/8] libbpf: Use O_CLOEXEC uniformly when
 opening fds
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
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

On Wed, Oct 27, 2021 at 11:35 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> There are some instances where we don't use O_CLOEXEC when opening an
> fd, fix these up. Otherwise, it is possible that a parallel fork causes
> these fds to leak into a child process on execve.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/lib/bpf/btf.c           | 2 +-
>  tools/lib/bpf/libbpf.c        | 6 +++---
>  tools/lib/bpf/libbpf_probes.c | 2 +-
>  tools/lib/bpf/linker.c        | 4 ++--
>  tools/lib/bpf/xsk.c           | 6 +++---
>  5 files changed, 10 insertions(+), 10 deletions(-)
>

[...]
