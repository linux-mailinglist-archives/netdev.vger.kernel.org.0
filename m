Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0491FD995
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 01:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgFQXVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 19:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbgFQXVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 19:21:04 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D488DC06174E;
        Wed, 17 Jun 2020 16:21:03 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id s18so4996220ioe.2;
        Wed, 17 Jun 2020 16:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=231wi2Er2OOJz0+jlitOVjoGRe+AiUOaqGzAgNNER3U=;
        b=P+Ic6lWoJ0GMk5TcvViu8sxk5k4V72UBN6IgrYQJyRa32C1OWzsHyjsuO0leo5midR
         XGjpRku2ys8jUQ5PUOgOIEI+4ooO/iEUeAgVDIJbMmig3gr5qaXqrzwjwSrXbseP+Rcd
         1eUaCl3yILUhheK730H88mPnApWRyB4tqb0bgi/3VX0OBhxoUXIFlCgroryi0aAc/hQ0
         tOGXQbMMJvdmmfoLyy5Kfqy4hbYlrdwUK+xODYKZ8ij/qixI2f4qf70cFvGwZO6EkEFD
         rzwDwppsK3BnxMUuDWS72LZFnf0DKlYFn5Sb2vCSs85652iwHXcqqb78bFIya+j7B9un
         Qrfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=231wi2Er2OOJz0+jlitOVjoGRe+AiUOaqGzAgNNER3U=;
        b=mInyoNswpAAueQBz4tzhUzE7wzH6fTv+C0tWt0DxI6g8BCUU77BBohYoZI4Vc52ygK
         wH/9s1kctedutZRQyiuYZiQugVpBU2cXTevfX3sWZBluwCsOKhh7Ikc8Xnc47fPO5E+f
         gI/1l8WuTWQKVzfgkHgx7Mpai2gID54CoWJA3x+woDl149tpGNOHNMrYPYZc3Zjn/h23
         gdSnXcqczByfYJfk8dt6CA5Vz3/0mD2P7i/d918s8P8paIAzJQe6KB8u/Zss0Tl0n6c0
         u/bKz0rJYK7zEMO1yIh5dJBURvf0eDpzwhQZLjzgHgk/srA2vq8jA8DG9xYCTxAeyHwS
         gy8w==
X-Gm-Message-State: AOAM532iBtOi4oLhslStt0WqMJVY0xIOynas+9mDxyYvILGvsJDzE/RS
        7bQZzlJhpXuN0LrkNcQeL9g=
X-Google-Smtp-Source: ABdhPJx3oQ+dsatWET3VuWpwzvcUZ2JwC0C+DjAXaLW70fM1urYC6bEOSSJAdlI7xLWlZaRXesZleQ==
X-Received: by 2002:a6b:b503:: with SMTP id e3mr1934195iof.175.1592436063271;
        Wed, 17 Jun 2020 16:21:03 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id r17sm577793ilc.33.2020.06.17.16.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 16:21:01 -0700 (PDT)
Date:   Wed, 17 Jun 2020 16:20:54 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Masanori Misono <m.misono760@gmail.com>
Message-ID: <5eeaa556c7a0e_38b82b28075185c46a@john-XPS-13-9370.notmuch>
In-Reply-To: <20200616173556.2204073-1-jolsa@kernel.org>
References: <20200616173556.2204073-1-jolsa@kernel.org>
Subject: RE: [PATCH] bpf: Allow small structs to be type of function argument
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Olsa wrote:
> This way we can have trampoline on function
> that has arguments with types like:
> 
>   kuid_t uid
>   kgid_t gid
> 
> which unwind into small structs like:
> 
>   typedef struct {
>         uid_t val;
>   } kuid_t;
> 
>   typedef struct {
>         gid_t val;
>   } kgid_t;
> 
> And we can use them in bpftrace like:
> (assuming d_path changes are in)
> 
>   # bpftrace -e 'lsm:path_chown { printf("uid %d, gid %d\n", args->uid, args->gid) }'
>   Attaching 1 probe...
>   uid 0, gid 0
>   uid 1000, gid 1000
>   ...
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/bpf/btf.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 58c9af1d4808..f8fee5833684 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -362,6 +362,14 @@ static bool btf_type_is_struct(const struct btf_type *t)
>  	return kind == BTF_KIND_STRUCT || kind == BTF_KIND_UNION;
>  }
>  
> +/* type is struct and its size is within 8 bytes
> + * and it can be value of function argument
> + */
> +static bool btf_type_is_struct_arg(const struct btf_type *t)
> +{
> +	return btf_type_is_struct(t) && (t->size <= sizeof(u64));

Can you comment on why sizeof(u64) here? The int types can be larger
than 64 for example and don't have a similar check, maybe the should
as well?

Here is an example from some made up program I ran through clang and
bpftool.

[2] INT '__int128' size=16 bits_offset=0 nr_bits=128 encoding=SIGNED

We also have btf_type_int_is_regular to decide if the int is of some
"regular" size but I don't see it used in these paths.

> +}
> +
>  static bool __btf_type_is_struct(const struct btf_type *t)
>  {
>  	return BTF_INFO_KIND(t->info) == BTF_KIND_STRUCT;
> @@ -3768,7 +3776,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>  	/* skip modifiers */
>  	while (btf_type_is_modifier(t))
>  		t = btf_type_by_id(btf, t->type);
> -	if (btf_type_is_int(t) || btf_type_is_enum(t))
> +	if (btf_type_is_int(t) || btf_type_is_enum(t) || btf_type_is_struct_arg(t))
>  		/* accessing a scalar */
>  		return true;
>  	if (!btf_type_is_ptr(t)) {
> @@ -4161,6 +4169,8 @@ static int __get_type_size(struct btf *btf, u32 btf_id,
>  		return sizeof(void *);
>  	if (btf_type_is_int(t) || btf_type_is_enum(t))
>  		return t->size;
> +	if (btf_type_is_struct_arg(t))
> +		return t->size;
>  	*bad_type = t;
>  	return -EINVAL;
>  }
> -- 
> 2.25.4
> 


