Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D893CC02B
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 02:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238456AbhGQAgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 20:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbhGQAgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 20:36:02 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CFCC06175F;
        Fri, 16 Jul 2021 17:33:06 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id v189so17656148ybg.3;
        Fri, 16 Jul 2021 17:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WehzBDOjJI5v2/ZnM5yr24s7M1qy/ZeBGhXX9HtcL94=;
        b=Tdavqq2EjzdOOQlvqF6DjwtjWE5xUYdz7O1oIvAbD+yrazoFECVnKX5kXcSKy3O07V
         uryvYPhZrobuYAtCs6FOh4hg5R9onHLtut4Z0p7KeHAHhkcMxyjmjsmlJpI9EbYWBPWi
         z/8FCXsyUvNoC5fJWGAgtr9mqu2XnBoVIPHKWg46LAVbgZzpJSJIGbcF9mqSNoPIvUuI
         c51vtE0Of1x+FNp89+L/hlAeBtlu8SHl2UOHQ/X/NjAkBXD8juN3G1cxcZ5EKPaXOTRG
         JHczCXdt+Ukw8ynAAHU5jYEThfNTvmesFqs/+g6Gtn5VrJKl2ikRwL9eyjif+CtSt4YH
         gewQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WehzBDOjJI5v2/ZnM5yr24s7M1qy/ZeBGhXX9HtcL94=;
        b=mR7FIT4iag1H1FwQYs4FnSDpo+IdAcflmv6faPCagaRCSKTSpq+PCSjqljN5gpibH0
         KDXc4PoPL2qp2Q5D053OUmMo4ShXyWd1DjPUXxzPRU6qzvd3J6GIphH4Zjt5L4DeWfwr
         QkLjJRIriYFDp56GCrfPuslOSmjh3cIwYN3/sDoo2Bbw2IPvV9x6hy6GHJAJvwGBG9BA
         9Rbq7iLfNSsMBz2v2vRCXDLkgEBw/tCg2ZCc6OMvSiF21BcXFvfe6demmD+Y8Z5tsDrH
         inxpqpfCSJ/ffxl+4ybmSJhwfu2/40tn6aQt30MLp9tHMfs0w+PNYHLQ4ai75tsmjN6F
         oVvw==
X-Gm-Message-State: AOAM531oQ6FWsFVuba3jsdWzBgpwqk+BEzWs8+EVj8D7cwsadims7qdz
        oTm3i1CY66wc1aLbltY5SKaFsyBZEx4bqWo2qdY=
X-Google-Smtp-Source: ABdhPJyOQHBk4PN0u1HRa6E5Lp7shEGrIFrkGUA6UJnquz7LxePRMpOjzxFYD/aBgbfMeQpawSbirYQtjMaegyfTUNs=
X-Received: by 2002:a25:1455:: with SMTP id 82mr16206006ybu.403.1626481985692;
 Fri, 16 Jul 2021 17:33:05 -0700 (PDT)
MIME-Version: 1.0
References: <1626475617-25984-1-git-send-email-alan.maguire@oracle.com> <1626475617-25984-4-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1626475617-25984-4-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 16 Jul 2021 17:32:54 -0700
Message-ID: <CAEf4BzbQKy=wuCnNBVPa+8HLkGWCYQ4nyPWMSW02=jnpNmOS6A@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/3] libbpf: btf typed dump does not need to
 allocate dump data
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Bill Wendling <morbo@google.com>,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 3:47 PM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> By using the stack for this small structure, we avoid the need
> for freeing memory in error paths.
>
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/lib/bpf/btf_dump.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
> index e5fbfb8..bd8e005 100644
> --- a/tools/lib/bpf/btf_dump.c
> +++ b/tools/lib/bpf/btf_dump.c
> @@ -2240,6 +2240,7 @@ int btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
>                              const void *data, size_t data_sz,
>                              const struct btf_dump_type_data_opts *opts)
>  {
> +       struct btf_dump_data typed_dump = {};
>         const struct btf_type *t;
>         int ret;
>
> @@ -2250,7 +2251,7 @@ int btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
>         if (!t)
>                 return libbpf_err(-ENOENT);
>
> -       d->typed_dump = calloc(1, sizeof(struct btf_dump_data));
> +       d->typed_dump = &typed_dump;
>         if (!d->typed_dump)
>                 return libbpf_err(-ENOMEM);

can't happen, removed, please pay attention to the surrounding code

>
> @@ -2269,7 +2270,5 @@ int btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
>
>         ret = btf_dump_dump_type_data(d, NULL, t, id, data, 0, 0);
>
> -       free(d->typed_dump);
> -

added resetting to NULL here, so that we don't have an accidental
dangling pointers

>         return libbpf_err(ret);
>  }

> --
> 1.8.3.1
>
