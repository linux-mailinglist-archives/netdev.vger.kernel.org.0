Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DABBC3FD027
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 02:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242769AbhIAAMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 20:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242976AbhIAAMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 20:12:02 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72ABC061796;
        Tue, 31 Aug 2021 17:11:04 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id e131so1766040ybb.7;
        Tue, 31 Aug 2021 17:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uXH+OjagNq+86e0j5CA3e3qsVMwwSbj8xS3pL4+lvCY=;
        b=Cucg7420wvtLxFlTEsVCMiNEpkmrzqvnapPMxezCEOa7LeBRvSFwN3+2ogm/C1f0G2
         k4mVLKbvxr5az/zaAFdXx9Vj9ADbY0QCTZrQ9Jd5nVxmLT0CBmOYnenMUqjWdVoUyuND
         p12zEfxkyIZVC97XbYUYYrKVbQy225lJXr9KmvmsgXpYSaJYB+Xrrca+t+njJrIEd0He
         I5TB1dxfi7WW4WHYh5DO6X/MKNo1fER9BhRFPh/zPlv6zeOu9v2UezKxhgnjI6Wyxkh/
         th9RVLQkc/yLTUGsbCDQzHqwTqYVcK5BsCPU5JY1tdUO+YCCvgqm7szkFMnbwgUSwZ8e
         lBGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uXH+OjagNq+86e0j5CA3e3qsVMwwSbj8xS3pL4+lvCY=;
        b=sIpK4WCPRvH+08hTPxonzXsQwPjgKVsu1bMk7XSsJM//0Et8ZfcOZdFC2UKRoBe3uR
         tJqw2k3r4h3goltCqPxHtZ44Jt3IZCISGuzWDq6sxlZuzWG293Ue6hR7wgEkR38B9Gb8
         wgbRX0j+YdwH+9d1eya9NBSfMCqQP7JK9QNf+9kspNdMplTD6k+SQ/QlONR/ufeFdLa+
         kwYE3HKHb3kMzU2eT2OKsbizDJffQe7gMq6FQ/o0t1pAaYUXZ6k/f/oUmhXNgdBEJALw
         DgY6LY/Mf/MxUX8Yj25N/hi6yeuDT2CsUxvH3rbFNpYR802uI+4sefFRDMlKd26QzNGz
         Jp7w==
X-Gm-Message-State: AOAM532Ggm9SWdLtTbBuQ5MaYlh24QOXOKAppbq64LDHqdIct1i2T92V
        /XW9kzBJXepWVqFGGYjRinmdw1WETXiQTPkRVDDXtMDm
X-Google-Smtp-Source: ABdhPJwoLLyhLvUWfv6eF4Jvr/IVrTl+/0S3MQeb9lMtTc9Fd43E1X8VQ9litXrdjHZ8tsgwg5wn8r2PUTq29locDNg=
X-Received: by 2002:a5b:142:: with SMTP id c2mr32255238ybp.425.1630455064023;
 Tue, 31 Aug 2021 17:11:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210826193922.66204-1-jolsa@kernel.org> <20210826193922.66204-21-jolsa@kernel.org>
In-Reply-To: <20210826193922.66204-21-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 31 Aug 2021 17:10:52 -0700
Message-ID: <CAEf4BzaxuWMDW5shE_LuAkHfy0rkbdd05t9QAtL4j9XPZ1_rYQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 20/27] libbpf: Add btf__find_by_glob_kind function
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

On Thu, Aug 26, 2021 at 12:41 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> Adding btf__find_by_glob_kind function that returns array of
> BTF ids that match given kind and allow/deny patterns.
>
> int btf__find_by_glob_kind(const struct btf *btf, __u32 kind,
>                            const char *allow_pattern,
>                            const char *deny_pattern,
>                            __u32 **__ids);
>
> The __ids array is allocated and needs to be manually freed.
>
> At the moment the supported pattern is '*' at the beginning or
> the end of the pattern.
>
> Kindly borrowed from retsnoop.
>
> Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/lib/bpf/btf.c | 80 +++++++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/btf.h |  3 ++
>  2 files changed, 83 insertions(+)
>
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 77dc24d58302..5baaca6c3134 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -711,6 +711,86 @@ __s32 btf__find_by_name_kind(const struct btf *btf, const char *type_name,
>         return libbpf_err(-ENOENT);
>  }
>
> +/* 'borrowed' from retsnoop */
> +static bool glob_matches(const char *glob, const char *s)
> +{
> +       int n = strlen(glob);
> +
> +       if (n == 1 && glob[0] == '*')
> +               return true;
> +
> +       if (glob[0] == '*' && glob[n - 1] == '*') {
> +               const char *subs;
> +               /* substring match */
> +
> +               /* this is hacky, but we don't want to allocate for no good reason */
> +               ((char *)glob)[n - 1] = '\0';
> +               subs = strstr(s, glob + 1);
> +               ((char *)glob)[n - 1] = '*';
> +
> +               return subs != NULL;
> +       } else if (glob[0] == '*') {
> +               size_t nn = strlen(s);
> +               /* suffix match */
> +
> +               /* too short for a given suffix */
> +               if (nn < n - 1)
> +                       return false;
> +
> +               return strcmp(s + nn - (n - 1), glob + 1) == 0;
> +       } else if (glob[n - 1] == '*') {
> +               /* prefix match */
> +               return strncmp(s, glob, n - 1) == 0;
> +       } else {
> +               /* exact match */
> +               return strcmp(glob, s) == 0;
> +       }
> +}
> +
> +int btf__find_by_glob_kind(const struct btf *btf, __u32 kind,
> +                          const char *allow_pattern, const char *deny_pattern,
> +                          __u32 **__ids)
> +{
> +       __u32 i, nr_types = btf__get_nr_types(btf);
> +       int cnt = 0, alloc = 0;
> +       __u32 *ids = NULL;
> +
> +       for (i = 1; i <= nr_types; i++) {
> +               const struct btf_type *t = btf__type_by_id(btf, i);
> +               bool match = false;
> +               const char *name;
> +               __u32 *p;
> +
> +               if (btf_kind(t) != kind)
> +                       continue;
> +               name = btf__name_by_offset(btf, t->name_off);
> +               if (!name)
> +                       continue;
> +
> +               if (allow_pattern && glob_matches(allow_pattern, name))
> +                       match = true;
> +               if (deny_pattern && !glob_matches(deny_pattern, name))
> +                       match = true;

this is wrong, if it matches both deny and allow patterns, you'll
still pass it through. Drop the match flag, just check deny first and
`continue` if matches.

> +               if (!match)
> +                       continue;
> +
> +               if (cnt == alloc) {
> +                       alloc = max(100, alloc * 3 / 2);

nit: maybe start with something like 16?

> +                       p = realloc(ids, alloc * sizeof(__u32));

we have libbpf_reallocarray, please use it

> +                       if (!p) {
> +                               free(ids);
> +                               return -ENOMEM;
> +                       }
> +                       ids = p;
> +               }
> +               ids[cnt] = i;
> +               cnt++;
> +       }
> +
> +       *__ids = ids;
> +       return cnt ?: -ENOENT;

cnt == 0 means -ENOENT, basically, no? It's up to the application to
decide if that's an error, let's just return the number of matches,
i.e., zero.

> +}
> +
>  static bool btf_is_modifiable(const struct btf *btf)
>  {
>         return (void *)btf->hdr != btf->raw_data;
> diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> index 4a711f990904..b288211770c3 100644
> --- a/tools/lib/bpf/btf.h
> +++ b/tools/lib/bpf/btf.h
> @@ -396,6 +396,9 @@ btf_var_secinfos(const struct btf_type *t)
>         return (struct btf_var_secinfo *)(t + 1);
>  }
>
> +int btf__find_by_glob_kind(const struct btf *btf, __u32 kind,
> +                          const char *allow_pattern, const char *deny_pattern,
> +                          __u32 **__ids);
>  #ifdef __cplusplus
>  } /* extern "C" */
>  #endif
> --
> 2.31.1
>
