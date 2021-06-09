Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520DC3A0BDD
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 07:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236210AbhFIFck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 01:32:40 -0400
Received: from mail-yb1-f173.google.com ([209.85.219.173]:41859 "EHLO
        mail-yb1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhFIFck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 01:32:40 -0400
Received: by mail-yb1-f173.google.com with SMTP id q21so33696872ybg.8;
        Tue, 08 Jun 2021 22:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8YlOJZ+r6aLVjjfIp7idcCqX4B6xw/jCujxoJAaZI3s=;
        b=ha6aJftWz30d3EtmwjQj/1ii9vH5rQdwquY1Pi31gW3FJogSENa466/gSxK3EHbd9v
         KsyfINinRnJkxr60pa5Eg0ZnvpS2l/AHNOYqtM6dK4dIp1u7s9ikt6SKzDQVI00/4lLg
         I/IeyplAxmqg/LBdXiUBx2KxkzaRCps0N1EiAPzPXNZ4fWqNSlgautNjSoJK3c4lomHb
         BrPuaQyWpJu0AHWyrV9oGvGi/76U0e66nNSiEPkzxIhagrSvltJ84B1wTOiQLKoow9Gt
         ItOg6wxAdjBNYJq3GO2lPqy/ii/fyJnUYhUXqePPU3J7G/GNi0S0Qj/Q7pEm0pGJ7kyw
         Eb6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8YlOJZ+r6aLVjjfIp7idcCqX4B6xw/jCujxoJAaZI3s=;
        b=WQ/E7RsP0eCkwy2zsMMVtEiLBNfiiUg1n8ryl3OH1YPBwRR5niJtzUTnQAn23+sRJd
         PnziUpu1/GpUa3/Btz9vmdhAD82UDFyWHaWHtjodHFvDRMo1qjyfttNg0dJsA8tUnGpn
         9V+D/Lh8l75U/AGSqtSgan37tsoDm6vnbaItqv85uhdQp0erymG7opaEqaGcEIlhv26X
         iSKCr9RN16iiMKsKgNvKynIc2RTKv4VwKbZOMU1qTpt1HXxKqcd5xPjLm4vfwH58wYTH
         8Nq9kRVmnwmHxPn2Km9hc8PVt7l/1r+ImVGmb4OcQZHq9rnOtCJ6mSk4E49Q93lKy1XR
         YcgA==
X-Gm-Message-State: AOAM5326369HeluiT/hLk/KGPQ1yd6xszMvPpB3aFIyNriIEcyXHS4AS
        IdksclGerYPkVWSB4+6/66VRJrBlwnvYb1myFqI=
X-Google-Smtp-Source: ABdhPJxenRpktScHEzxOzkPjobeCeWLPzUhHNSlTJcYgwPHvgxtl92KmxGh1K+dQxpg4fthvN54ypaLxlycYzoqxoGg=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr34349565ybg.459.1623216570592;
 Tue, 08 Jun 2021 22:29:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210605111034.1810858-1-jolsa@kernel.org> <20210605111034.1810858-15-jolsa@kernel.org>
In-Reply-To: <20210605111034.1810858-15-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Jun 2021 22:29:19 -0700
Message-ID: <CAEf4BzaT9eiyMrpKbmmq3hOpD29b8K6DiRzB0eRKnTso93YRoA@mail.gmail.com>
Subject: Re: [PATCH 14/19] libbpf: Add btf__find_by_pattern_kind function
To:     Jiri Olsa <jolsa@kernel.org>
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

On Sat, Jun 5, 2021 at 4:14 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding btf__find_by_pattern_kind function that returns
> array of BTF ids for given function name pattern.
>
> Using libc's regex.h support for that.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/lib/bpf/btf.c | 68 +++++++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/btf.h |  3 ++
>  2 files changed, 71 insertions(+)
>
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index b46760b93bb4..421dd6c1e44a 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
>  /* Copyright (c) 2018 Facebook */
>
> +#define _GNU_SOURCE
>  #include <byteswap.h>
>  #include <endian.h>
>  #include <stdio.h>
> @@ -16,6 +17,7 @@
>  #include <linux/err.h>
>  #include <linux/btf.h>
>  #include <gelf.h>
> +#include <regex.h>
>  #include "btf.h"
>  #include "bpf.h"
>  #include "libbpf.h"
> @@ -711,6 +713,72 @@ __s32 btf__find_by_name_kind(const struct btf *btf, const char *type_name,
>         return libbpf_err(-ENOENT);
>  }
>
> +static bool is_wildcard(char c)
> +{
> +       static const char *wildchars = "*?[|";
> +
> +       return strchr(wildchars, c);
> +}
> +
> +int btf__find_by_pattern_kind(const struct btf *btf,
> +                             const char *type_pattern, __u32 kind,
> +                             __s32 **__ids)
> +{
> +       __u32 i, nr_types = btf__get_nr_types(btf);
> +       __s32 *ids = NULL;
> +       int cnt = 0, alloc = 0, ret;
> +       regex_t regex;
> +       char *pattern;
> +
> +       if (kind == BTF_KIND_UNKN || !strcmp(type_pattern, "void"))
> +               return 0;
> +
> +       /* When the pattern does not start with wildcard, treat it as
> +        * if we'd want to match it from the beginning of the string.
> +        */

This assumption is absolutely atrocious. If we say it's regexp, then
it has to always be regexp, not something based on some random
heuristic based on the first character.

Taking a step back, though. Do we really need to provide this API? Why
applications can't implement it on their own, given regexp
functionality is provided by libc. Which I didn't know, actually, so
that's pretty nice, assuming that it's also available in more minimal
implementations like musl.

> +       asprintf(&pattern, "%s%s",
> +                is_wildcard(type_pattern[0]) ? "^" : "",
> +                type_pattern);
> +
> +       ret = regcomp(&regex, pattern, REG_EXTENDED);
> +       if (ret) {
> +               pr_warn("failed to compile regex\n");
> +               free(pattern);
> +               return -EINVAL;
> +       }
> +
> +       free(pattern);
> +
> +       for (i = 1; i <= nr_types; i++) {
> +               const struct btf_type *t = btf__type_by_id(btf, i);
> +               const char *name;
> +               __s32 *p;
> +
> +               if (btf_kind(t) != kind)
> +                       continue;
> +               name = btf__name_by_offset(btf, t->name_off);
> +               if (name && regexec(&regex, name, 0, NULL, 0))
> +                       continue;
> +               if (cnt == alloc) {
> +                       alloc = max(100, alloc * 3 / 2);
> +                       p = realloc(ids, alloc * sizeof(__u32));

this memory allocation and re-allocation on behalf of users is another
argument against this API

> +                       if (!p) {
> +                               free(ids);
> +                               regfree(&regex);
> +                               return -ENOMEM;
> +                       }
> +                       ids = p;
> +               }
> +
> +               ids[cnt] = i;
> +               cnt++;
> +       }
> +
> +       regfree(&regex);
> +       *__ids = ids;
> +       return cnt ?: -ENOENT;
> +}
> +
>  static bool btf_is_modifiable(const struct btf *btf)
>  {
>         return (void *)btf->hdr != btf->raw_data;
> diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> index b54f1c3ebd57..036857aded94 100644
> --- a/tools/lib/bpf/btf.h
> +++ b/tools/lib/bpf/btf.h
> @@ -371,6 +371,9 @@ btf_var_secinfos(const struct btf_type *t)
>         return (struct btf_var_secinfo *)(t + 1);
>  }
>
> +int btf__find_by_pattern_kind(const struct btf *btf,
> +                             const char *type_pattern, __u32 kind,
> +                             __s32 **__ids);
>  #ifdef __cplusplus
>  } /* extern "C" */
>  #endif
> --
> 2.31.1
>
