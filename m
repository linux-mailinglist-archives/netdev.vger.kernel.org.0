Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 433BF2E137
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 17:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfE2Pfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 11:35:39 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33125 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfE2Pfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 11:35:39 -0400
Received: by mail-qt1-f193.google.com with SMTP id 14so3166469qtf.0;
        Wed, 29 May 2019 08:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XO3K1Hnp8UeFU/xbsoXmwGYYL20N+iCxpTzObuQfFfY=;
        b=LeThDa38ADFHQXl2DawpI9KMmnG7bwqq7wZ3Dvabo+jw5TEMD3VVrhulfmo76p6mGy
         bamhyGln7YM2oxS9ajLLro5MUDki21aCUie0BNA9qrwaXdBK25dvW0Wt4U9YDMY9uxzA
         h2rRg30sTKBcixVx2wDLRy1yG54CnF17xdZkjHtPzP23O8q+N28tcnt7unF5Y9r9uYS7
         IHYDdAtyPrQUmeZvd94Z84Va3iG5CzepfjLcEVz4XfUBpBTijBjJMzjprxL/ITkT5L8Z
         eKpUtTmosziXNRX3P86lTvcxKZsrU2T5SLdZwTpzRelR/qqltNEFyBtqcPhC9VS80OZX
         4lhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XO3K1Hnp8UeFU/xbsoXmwGYYL20N+iCxpTzObuQfFfY=;
        b=VbTz8hWqxlAaEoVLctB43+mM0rlX/vuuldhSgApXOwYMeDRfZ1/z6wfoNTXtLhr9ZT
         Va0xrV6Ij5/7OIOnf3pLi7M86gvT/Lgfq5v6mcPyyX1fPy5tJNsMbmnakjlve0NXnj8c
         JpPM/ixJBCZvHWYkWk3wETxh5kcoeUsy/1GNkZOsh+dDLSvDXzp5HLPXLYbDh54sImLm
         SjJHEy+uo6AzkhzrUsf4ws4lqKy8G32gnFQgZIrr9WFj67UXA+C008X4RLKjoeNtNhdu
         OmyGnz4VCsiB9esNdIA89OiKMI1Q6CGhzanegNRdjhiWbJD7ttVGCsN/kYNHczfQ4nZM
         ef7g==
X-Gm-Message-State: APjAAAUmQ+YvVSJILZ0fnZ9hk8nxDAemOCN1DVuwvmhGsi2BYHtjiIqj
        2rEa2LdZnW8FnK5g3boiuOi3bvjt9EtS16dmqL7rZmV9rIw=
X-Google-Smtp-Source: APXvYqz8vJOWKPfvBsbhK2wiHTaKfMV65SSdNe3CEsU7WCEGFnWZvRH2DSJi6oFE6jPiJ6Kupu1P1s4zgrvbuvfPzxs=
X-Received: by 2002:ac8:668d:: with SMTP id d13mr102162515qtp.59.1559144137315;
 Wed, 29 May 2019 08:35:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190529082941.9440-1-mrostecki@opensuse.org>
In-Reply-To: <20190529082941.9440-1-mrostecki@opensuse.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 29 May 2019 08:35:25 -0700
Message-ID: <CAEf4Bza2cUvSsncsKe4vX4GPRgAvaDcHXTsp+q4tf5ADA0GaLg@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: Return btf_fd in libbpf__probe_raw_btf
To:     Michal Rostecki <mrostecki@opensuse.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 1:30 AM Michal Rostecki <mrostecki@opensuse.org> wrote:
>
> Function load_sk_storage_btf expects that libbpf__probe_raw_btf is
> returning a btf descriptor, but before this change it was returning
> an information about whether the probe was successful (0 or 1).
> load_sk_storage_btf was using that value as an argument to the close
> function, which was resulting in closing stdout and thus terminating the
> process which used that dunction.
>
> That bug was visible in bpftool. `bpftool feature` subcommand was always
> exiting too early (because of closed stdout) and it didn't display all
> requested probes. `bpftool -j feature` or `bpftool -p feature` were not
> returning a valid json object.
>

Thanks for the fix!

> Fixes: d7c4b3980c18 ("libbpf: detect supported kernel BTF features and sanitize BTF")
> Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
> ---
>  tools/lib/bpf/libbpf.c        | 36 +++++++++++++++++++++--------------
>  tools/lib/bpf/libbpf_probes.c |  7 +------
>  2 files changed, 23 insertions(+), 20 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 197b574406b3..bc2dca36bced 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1645,15 +1645,19 @@ static int bpf_object__probe_btf_func(struct bpf_object *obj)
>                 /* FUNC x */                                    /* [3] */
>                 BTF_TYPE_ENC(5, BTF_INFO_ENC(BTF_KIND_FUNC, 0, 0), 2),
>         };
> -       int res;
> +       int btf_fd;
> +       int ret;
>
> -       res = libbpf__probe_raw_btf((char *)types, sizeof(types),
> -                                   strs, sizeof(strs));
> -       if (res < 0)
> -               return res;
> -       if (res > 0)
> +       btf_fd = libbpf__probe_raw_btf((char *)types, sizeof(types),
> +                                      strs, sizeof(strs));
> +       if (btf_fd < 0)
> +               ret = 0;
> +       else {
> +               ret = 1;

This whole ret variable seems unnecessary. Also if btf_fd is invalid,
we probably shouldn't close it. So just this should work:

btf_fd = libbpf__probe_raw_btf(...);
if (btf_fd >= 0) {
    obj->caps.btf_func = 1;
    close(btf_fd);
}
return btf_fd >= 0;

>                 obj->caps.btf_func = 1;
> -       return 0;
> +       }
> +       close(btf_fd);
> +       return ret;
>  }
>
>  static int bpf_object__probe_btf_datasec(struct bpf_object *obj)
> @@ -1670,15 +1674,19 @@ static int bpf_object__probe_btf_datasec(struct bpf_object *obj)
>                 BTF_TYPE_ENC(3, BTF_INFO_ENC(BTF_KIND_DATASEC, 0, 1), 4),
>                 BTF_VAR_SECINFO_ENC(2, 0, 4),
>         };
> -       int res;
> +       int btf_fd;
> +       int ret;
>
> -       res = libbpf__probe_raw_btf((char *)types, sizeof(types),
> -                                   strs, sizeof(strs));
> -       if (res < 0)
> -               return res;
> -       if (res > 0)
> +       btf_fd = libbpf__probe_raw_btf((char *)types, sizeof(types),
> +                                      strs, sizeof(strs));
> +       if (btf_fd < 0)
> +               ret = 0;
> +       else {
> +               ret = 1;
>                 obj->caps.btf_datasec = 1;
> -       return 0;
> +       }
> +       close(btf_fd);

Same as above.

> +       return ret;
>  }
>
>  static int
> diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
> index 5e2aa83f637a..2c2828345514 100644
> --- a/tools/lib/bpf/libbpf_probes.c
> +++ b/tools/lib/bpf/libbpf_probes.c
> @@ -157,14 +157,9 @@ int libbpf__probe_raw_btf(const char *raw_types, size_t types_len,

I'm wondering if it's better to rename this function to something like
libbpf__load_raw_btf? probe (at least to me) implies true/false
result, so feels like it might be easily misused.

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
> --
> 2.21.0
>
