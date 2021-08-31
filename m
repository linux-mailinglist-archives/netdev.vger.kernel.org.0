Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F1C3FCFDA
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 01:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240828AbhHaXSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 19:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233866AbhHaXSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 19:18:40 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEC6C061575;
        Tue, 31 Aug 2021 16:17:44 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id e133so1711865ybh.0;
        Tue, 31 Aug 2021 16:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BzuwlS5WFy8PUucxd6vatuT5n4c/2pnCLxcWNLj50gQ=;
        b=PPpr/vq6x8hmTBp/Z96zc9RtPx0F1giyCI9BcJFKNTFXhQ2OhNG8AGDPwBvJga+ywH
         dty93dj5z7IOBO4739rSZm+1PuAD0/8A80extNv8/+bNAcG8y1XYAaxxJOgzSdNTEA6q
         cAD9cHPK3wipO2AeSi5HzeRsG8sVHlU6omvZJrh9fdHAA39U6UKIw2DyKl3Nc/oQPLc1
         UeMdEXaHjcjQZ4grfIIe+bwN1/Q3o9Qz274iXn0bqhy35p0ZNYi7JnIuToUlyuug6foD
         1QkZbr3e+eBDw/A0wGewkbGka/PVu2ftkFz6UHcamEnnbdrgKmvbIE+4bSmHiQexwnIn
         mcXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BzuwlS5WFy8PUucxd6vatuT5n4c/2pnCLxcWNLj50gQ=;
        b=cayoNYcGSkKEtRKdYQY7eF8zvMcDnn6My2ygQUXGctl9mtXVLoc5I2/5Uq2fpK5zNm
         YzhisJvFKGWoiQ9Ar9mi+yYtcUV7li5TOacyLZLNnXkiAx6PqDd4qfbZiFjY2Ob9zXDI
         BF7JPX00BUZIB2hDP9FfOIb0q2azmo3t2TfdkDL2ezai9itGcitIefbYXI+SO+5sav3E
         cAyzQ1sLyAtlITtIeMcLpV3N5AIGdhsWDgs94qjsd/vxibI2oH8Q7hiCiwgnNvQrEcUi
         6fjo2fnufnCMEfO3cmzfK7v7Kl4VABOEEtorbGfWPyqSxlMXMKe/GXTMEuPANpGjrZv0
         qXTQ==
X-Gm-Message-State: AOAM532CwODev/IJYqc8tRwSKwMxywwDDkv10OSwE7biPdkv7416352V
        npMqZfhL63hIYFSw9n9PitWprR0B8xr/Hxzsqh0=
X-Google-Smtp-Source: ABdhPJxTOEdduooSFe6dY7eYrzRqKysPkoslVw5rkB0uwnK+bdH2Mvf5IVPpok7dCnFDvxhqrgp90A+IJTYBMieZZGA=
X-Received: by 2002:a25:bdc5:: with SMTP id g5mr33479248ybk.403.1630451864054;
 Tue, 31 Aug 2021 16:17:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210826193922.66204-1-jolsa@kernel.org> <20210826193922.66204-10-jolsa@kernel.org>
In-Reply-To: <20210826193922.66204-10-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 31 Aug 2021 16:17:33 -0700
Message-ID: <CAEf4BzYJXJbquSKdc_iEfFGXuA3eYMgwvAbOWEkBo7BW4faZww@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 09/27] bpf: Add support to load multi func
 tracing program
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 12:40 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> Adding support to load tracing program with new BPF_F_MULTI_FUNC flag,
> that allows the program to be loaded without specific function to be
> attached to.

Are there any benefits to using a new load flag vs having separate
expected attach types like FENTRY_MULTI/FEXIT_MULTI? I find load flags
a bigger pain to work with compared to expected attach type (and
expected attach type should be more apparent in BPF link info, bpftool
output, etc).

>
> Such program will be allowed to be attached to multiple functions
> in following patches.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/bpf.h            |  1 +
>  include/uapi/linux/bpf.h       |  7 +++++++
>  kernel/bpf/syscall.c           | 35 +++++++++++++++++++++++++++++-----
>  kernel/bpf/verifier.c          |  3 ++-
>  tools/include/uapi/linux/bpf.h |  7 +++++++
>  5 files changed, 47 insertions(+), 6 deletions(-)
>

[...]
