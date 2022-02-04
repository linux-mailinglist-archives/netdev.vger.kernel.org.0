Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153AD4A9FFA
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 20:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbiBDTY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 14:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbiBDTY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 14:24:29 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E38AC061714;
        Fri,  4 Feb 2022 11:24:29 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id s18so8584104ioa.12;
        Fri, 04 Feb 2022 11:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2GFiS3yxbCUv0XB5aipeyYSgthT+Hc5+LFsnpwnolvw=;
        b=HBJtlreym4nE4YczqPorExTY5sI3fWcTTIcE+o3V3C7JTO0CJHlZqmU0/PbZadXnh9
         4k5jdLaTy5N6L6ncBywEkwgsfntjpHSidBDSssfvbYbasjBLAA0b4W875P+sDND95Rbd
         70mUamNKkDXNBqj6tpq2Ah5UG4cGdQH9WdKaPO50BRcou2NukzfrFFSvrUQWjjXZNvnz
         g8hOziraE7oso9VWrYG/coFTWFAaZHBrvO6fi/PWKOR8jI1Yge3XQdOoVzyFzS88Mebd
         5g/diXKopH7sI9txNzCvhgcZTk98ZhEZonZs1zL21OeWlKWmngSy1W1/e+fctk0JerOq
         F5SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2GFiS3yxbCUv0XB5aipeyYSgthT+Hc5+LFsnpwnolvw=;
        b=YkBdU3UP8/gl5djsQJqAfX1QOhvn9pAkea3OIVxCHOS6nasxnGlx2gXYE42BFz4zlg
         wxAFBShZ/SxkR4CJgNW14PEPX+iS8KtePuH8c9GXXuLw4yF6x/F7PVEcLdoDNS3mbrzl
         kUUmWk3xtcg4nLnI0PiyUDHVQrT1HYY2x2d/PMpIUYQUsMXr1jAmOHw9lDCpTrr5D/xN
         A92SKu37i6LN2Vu2jM0HNm7lsEib7AkAwGVORfU2zINDsP4YB1tze4JAAXZSOc3rNUbG
         7CngNhbR3pzK0KadkBw3AUbChhXYI/ZBrr0kzcte2x1hRnorYUGNUGTzz6V1jSNWhLFt
         nS4Q==
X-Gm-Message-State: AOAM532/6hbwMYv/TVkJ0I6sFPtNR8j7JgwmWd84oIcdu22fZL+kVimN
        Lf/xhMIiM6NLsFIBdLAQ/TpbltpJ346+8TF1KXc=
X-Google-Smtp-Source: ABdhPJzxmz3wLTu9mGiYINQ0soS/QI81RheNiT9QepsAThlm8J7xZC2DoIRpuc29HTdCaTtUVQ55F+qx/ABxXyikHV4=
X-Received: by 2002:a5e:a806:: with SMTP id c6mr292247ioa.112.1644002668555;
 Fri, 04 Feb 2022 11:24:28 -0800 (PST)
MIME-Version: 1.0
References: <1643645554-28723-1-git-send-email-alan.maguire@oracle.com> <1643645554-28723-4-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1643645554-28723-4-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Feb 2022 11:24:17 -0800
Message-ID: <CAEf4BzbyWd6bfWFGLX-c7s2YLjFTQXAc=NOEFChwu2ApvJNeFQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 3/4] selftests/bpf: add get_lib_path() helper
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 8:13 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> get_lib_path(path_substr) returns full path to a library
> containing path_substr (such as "libc-") found via
> /proc/self/maps.  Caller is responsible for freeing
> the returned string.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/testing/selftests/bpf/trace_helpers.c | 17 +++++++++++++++++
>  tools/testing/selftests/bpf/trace_helpers.h |  2 ++
>  2 files changed, 19 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
> index ca6abae..49e5f0d 100644
> --- a/tools/testing/selftests/bpf/trace_helpers.c
> +++ b/tools/testing/selftests/bpf/trace_helpers.c
> @@ -216,3 +216,20 @@ ssize_t get_rel_offset(uintptr_t addr)
>         fclose(f);
>         return -EINVAL;
>  }
> +
> +char *get_lib_path(const char *path_substr)
> +{
> +       char *found = NULL;
> +       char lib_path[512];
> +       FILE *f;
> +
> +       f = fopen("/proc/self/maps", "r");
> +       while (fscanf(f, "%*s %*s %*s %*s %*s %[^\n]", lib_path) == 1) {

I think it can be followed by " (deleted)", right? Do we want to
detect that and do something about it?

> +               if (strstr(lib_path, path_substr) == NULL)
> +                       continue;
> +               found = strdup(lib_path);
> +               break;
> +       }
> +       fclose(f);
> +       return found;
> +}
> diff --git a/tools/testing/selftests/bpf/trace_helpers.h b/tools/testing/selftests/bpf/trace_helpers.h
> index 238a9c9..ff379f6 100644
> --- a/tools/testing/selftests/bpf/trace_helpers.h
> +++ b/tools/testing/selftests/bpf/trace_helpers.h
> @@ -20,5 +20,7 @@ struct ksym {
>
>  ssize_t get_uprobe_offset(const void *addr);
>  ssize_t get_rel_offset(uintptr_t addr);
> +/* Return allocated string path to library that contains path_substr. */
> +char *get_lib_path(const char *path_substr);
>
>  #endif
> --
> 1.8.3.1
>
