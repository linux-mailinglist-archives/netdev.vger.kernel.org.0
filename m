Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDFA30484
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 00:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfE3WDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 18:03:03 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35677 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbfE3WDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 18:03:03 -0400
Received: by mail-qt1-f195.google.com with SMTP id w1so9001511qts.2;
        Thu, 30 May 2019 15:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YSnAq3eKQkU54nDdKJphmGJsI8pTPt78FTo77Vo/2Xo=;
        b=siIFyXztRvfOPf7xj65X+x00d6jAnupeh7lmFFIGJZsJQpmP0BK1Ca27TKaYCf4BHV
         Mvta0w/zpnHYFw+CWMlPk8JH5u9TZSxEEaSY9/Lo80ukSQdXYVYnRwrnPvHqX6UMZ4hs
         2OP6MfGuyXK6j2CuKzhZDVxyluTz7Ue2/RaQ3IHpMqWqqoWZD9OFBmVmFZT89UvYtVi2
         Y0Rq4tP4TPQ0Zx4BhC69WzANk+1AGw+ZNBkNlXUhDagHAj/cdLYjoEqOYcvVnRMe43QE
         I6oQADALlCdC+9h5jyYTuFx05x057Pyze9GYOJ1/qroSFG0hKlyT80ncb+vNaiUfZhrR
         24zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YSnAq3eKQkU54nDdKJphmGJsI8pTPt78FTo77Vo/2Xo=;
        b=N4oJC+onZXh/9q27KrvMTEx8t5KACCCLYjCgZdI+dUr8Unjor1F9ppmzn9xG28IVG+
         +Nn7NSaclAHj41z8JreJMnY8Fmr4U+X82HtAOyl8MypvUj7V+wzpJHIvWzZI2TXMR2yX
         wsz7qk8ehQlbapL1OOwzkAvTCnG79WlusmLb6x9O/Na5pQ3es+MDRvVErx6x53KDylLN
         OJP/BNcLGir7CwbtF7gKVXekW6BbqsLuz398uxqsHNvop1unrt6q4ajkrS7ifgL0FvQb
         hXOQ9z02okpMLBPrTjcORufP5LFrrTvlx6myqeH/AWSAV8+nbrgvO4bUk6ZVGXmZgbuQ
         fNtQ==
X-Gm-Message-State: APjAAAXrb0TbOKNT7XB73NqunRaNCMosHnzRxWfXhHNoy3yebACwPJOb
        Xp2GPFc/a4oK/cTu3lkfC0S9SAPaXwk7kojfzQMUuz8K
X-Google-Smtp-Source: APXvYqxkm0nA87BHD0ZYYUqgK5f/C1G3gfVmUkzmB+1Ed62DiDwD10zGKHZAQ44jlk3F/VpxwkjoDIcqP6Ysjv9Y3qA=
X-Received: by 2002:ac8:2a73:: with SMTP id l48mr5678673qtl.183.1559252048319;
 Thu, 30 May 2019 14:34:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190529183109.17317-1-mrostecki@opensuse.org>
In-Reply-To: <20190529183109.17317-1-mrostecki@opensuse.org>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 30 May 2019 14:33:56 -0700
Message-ID: <CAPhsuW7KhR1XXDb6Sv54xb1OiLQUC7NH4+uf8_b3tRje7O-YUQ@mail.gmail.com>
Subject: Re: [PATCH bpf v4] libbpf: Return btf_fd for load_sk_storage_btf
To:     Michal Rostecki <mrostecki@opensuse.org>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 11:30 AM Michal Rostecki <mrostecki@opensuse.org> wrote:
>
> Before this change, function load_sk_storage_btf expected that
> libbpf__probe_raw_btf was returning a BTF descriptor, but in fact it was
> returning an information about whether the probe was successful (0 or
> 1). load_sk_storage_btf was using that value as an argument of the close
> function, which was resulting in closing stdout and thus terminating the
> process which called that function.
>
> That bug was visible in bpftool. `bpftool feature` subcommand was always
> exiting too early (because of closed stdout) and it didn't display all
> requested probes. `bpftool -j feature` or `bpftool -p feature` were not
> returning a valid json object.
>
> This change renames the libbpf__probe_raw_btf function to
> libbpf__load_raw_btf, which now returns a BTF descriptor, as expected in
> load_sk_storage_btf.
>
> v2:
> - Fix typo in the commit message.
>
> v3:
> - Simplify BTF descriptor handling in bpf_object__probe_btf_* functions.
> - Rename libbpf__probe_raw_btf function to libbpf__load_raw_btf and
> return a BTF descriptor.
>
> v4:
> - Fix typo in the commit message.
>
> Fixes: d7c4b3980c18 ("libbpf: detect supported kernel BTF features and sanitize BTF")
> Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

Thanks for the fix!

> ---
>  tools/lib/bpf/libbpf.c          | 28 ++++++++++++++++------------
>  tools/lib/bpf/libbpf_internal.h |  4 ++--
>  tools/lib/bpf/libbpf_probes.c   | 13 ++++---------
>  3 files changed, 22 insertions(+), 23 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 197b574406b3..5d046cc7b207 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1645,14 +1645,16 @@ static int bpf_object__probe_btf_func(struct bpf_object *obj)
>                 /* FUNC x */                                    /* [3] */
>                 BTF_TYPE_ENC(5, BTF_INFO_ENC(BTF_KIND_FUNC, 0, 0), 2),
>         };
> -       int res;
> +       int btf_fd;
>
> -       res = libbpf__probe_raw_btf((char *)types, sizeof(types),
> -                                   strs, sizeof(strs));
> -       if (res < 0)
> -               return res;
> -       if (res > 0)
> +       btf_fd = libbpf__load_raw_btf((char *)types, sizeof(types),
> +                                     strs, sizeof(strs));
> +       if (btf_fd >= 0) {
>                 obj->caps.btf_func = 1;
> +               close(btf_fd);
> +               return 1;
> +       }
> +
>         return 0;
>  }
>
> @@ -1670,14 +1672,16 @@ static int bpf_object__probe_btf_datasec(struct bpf_object *obj)
>                 BTF_TYPE_ENC(3, BTF_INFO_ENC(BTF_KIND_DATASEC, 0, 1), 4),
>                 BTF_VAR_SECINFO_ENC(2, 0, 4),
>         };
> -       int res;
> +       int btf_fd;
>
> -       res = libbpf__probe_raw_btf((char *)types, sizeof(types),
> -                                   strs, sizeof(strs));
> -       if (res < 0)
> -               return res;
> -       if (res > 0)
> +       btf_fd = libbpf__load_raw_btf((char *)types, sizeof(types),
> +                                     strs, sizeof(strs));
> +       if (btf_fd >= 0) {
>                 obj->caps.btf_datasec = 1;
> +               close(btf_fd);
> +               return 1;
> +       }
> +
>         return 0;
>  }
>
> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> index f3025b4d90e1..dfab8012185c 100644
> --- a/tools/lib/bpf/libbpf_internal.h
> +++ b/tools/lib/bpf/libbpf_internal.h
> @@ -34,7 +34,7 @@ do {                          \
>  #define pr_info(fmt, ...)      __pr(LIBBPF_INFO, fmt, ##__VA_ARGS__)
>  #define pr_debug(fmt, ...)     __pr(LIBBPF_DEBUG, fmt, ##__VA_ARGS__)
>
> -int libbpf__probe_raw_btf(const char *raw_types, size_t types_len,
> -                         const char *str_sec, size_t str_len);
> +int libbpf__load_raw_btf(const char *raw_types, size_t types_len,
> +                        const char *str_sec, size_t str_len);
>
>  #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
> diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
> index 5e2aa83f637a..6635a31a7a16 100644
> --- a/tools/lib/bpf/libbpf_probes.c
> +++ b/tools/lib/bpf/libbpf_probes.c
> @@ -133,8 +133,8 @@ bool bpf_probe_prog_type(enum bpf_prog_type prog_type, __u32 ifindex)
>         return errno != EINVAL && errno != EOPNOTSUPP;
>  }
>
> -int libbpf__probe_raw_btf(const char *raw_types, size_t types_len,
> -                         const char *str_sec, size_t str_len)
> +int libbpf__load_raw_btf(const char *raw_types, size_t types_len,
> +                        const char *str_sec, size_t str_len)
>  {
>         struct btf_header hdr = {
>                 .magic = BTF_MAGIC,
> @@ -157,14 +157,9 @@ int libbpf__probe_raw_btf(const char *raw_types, size_t types_len,
>         memcpy(raw_btf + hdr.hdr_len + hdr.type_len, str_sec, hdr.str_len);
>
>         btf_fd = bpf_load_btf(raw_btf, btf_len, NULL, 0, false);
> -       if (btf_fd < 0) {
> -               free(raw_btf);
> -               return 0;
> -       }
>
> -       close(btf_fd);
>         free(raw_btf);
> -       return 1;
> +       return btf_fd;
>  }
>
>  static int load_sk_storage_btf(void)
> @@ -190,7 +185,7 @@ static int load_sk_storage_btf(void)
>                 BTF_MEMBER_ENC(23, 2, 32),/* struct bpf_spin_lock l; */
>         };
>
> -       return libbpf__probe_raw_btf((char *)types, sizeof(types),
> +       return libbpf__load_raw_btf((char *)types, sizeof(types),
>                                      strs, sizeof(strs));
>  }
>
> --
> 2.21.0
>
