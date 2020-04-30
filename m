Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B341C0754
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgD3UEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgD3UEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:04:46 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4974C035494;
        Thu, 30 Apr 2020 13:04:45 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id q2so3704812qvd.1;
        Thu, 30 Apr 2020 13:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vgf2SwLa/icc+Mda7sTpSzoCj9r0ixnHT/moZ9K+las=;
        b=A6LyS5MeDk8qiAKyvE9IRqnEyvKHwjJIXz/rjOZXXwHyHqK7+go+/yh1eWvRGLLT1i
         aYSWc/7023lyLi3O62MliMoSMhpixWqKObnjFAHGTwIP57/2PEYo1I0EfIU25l4c4QZJ
         U0AVCl15veEVtZSl6SeeY5Cz6zAfmCQd6OgAllmYf9a4JV4R+TEgsfdaviFOBBQyLkQ5
         y+vmEzGDcrpKu47hWjnHZxKWGN5bZUrKLqIK/Jd6sqivaSgppwZeqLhefxTFb/Y85B1a
         pmf3TAqO+LKraukp7cska3IyjOG6jk2u9172qziDakfcTzh6RmAZ9xSqZV8m3hAg103c
         Nw1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vgf2SwLa/icc+Mda7sTpSzoCj9r0ixnHT/moZ9K+las=;
        b=FurY2o9C1/FymdV6NCuxcGjjxRLEZk5OQw+Jq/1CRz+7cvSS67E79zyPoWJ9/tmpFx
         Lo05fMDKNeZvaLiwwy/kqH4ojRgX8UDNQXqzZMgm4ghgiKXDBZLVR1AMjkVxsV6/KZ6T
         +EEra+m5ReMp0qg6ZQKtKv35J/MmP0lQ8mi7QnM8E8Y4l6pgypzJmjVnR6vOQRvYArNA
         d63Toc75U+9VyjMcwKmFHMNaeMgTJ3fkwpoU99QWtaYW7/jgKKOt5ikuCEEiRg19Fdyo
         oUTJCfQZgEuFMyd1h6p5tYFH5OlU2t5uPoA+Va3BJuoShkdKBCHQHN3Zso2ITDsyA48/
         cynA==
X-Gm-Message-State: AGi0PubUOl9UX+q4Un8gR1d+bUrjBA/pfbeEr0emlfJUxl3q8BsPfZh0
        Y6ZS7UBjpT60MD1Lic+eotfb+IAUf3Von4hHTe4=
X-Google-Smtp-Source: APiQypIOOqncD289yKoK280vyYMqVxFrx2S0w1ZOsvP4vuySo6lMQ4/e5LAGxCvzHuya074Rie/CZGNkIXifKnsaluk=
X-Received: by 2002:a0c:eb09:: with SMTP id j9mr669376qvp.196.1588277084920;
 Thu, 30 Apr 2020 13:04:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200427201235.2994549-1-yhs@fb.com> <20200427201251.2995957-1-yhs@fb.com>
In-Reply-To: <20200427201251.2995957-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 30 Apr 2020 13:04:33 -0700
Message-ID: <CAEf4BzYxANRng+3JbYrrcgre-mM_BC_+kefYDHY1gG=r_emwBg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 14/19] bpf: support variable length array in
 tracing programs
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 1:17 PM Yonghong Song <yhs@fb.com> wrote:
>
> In /proc/net/ipv6_route, we have
>   struct fib6_info {
>     struct fib6_table *fib6_table;
>     ...
>     struct fib6_nh fib6_nh[0];
>   }
>   struct fib6_nh {
>     struct fib_nh_common nh_common;
>     struct rt6_info **rt6i_pcpu;
>     struct rt6_exception_bucket *rt6i_exception_bucket;
>   };
>   struct fib_nh_common {
>     ...
>     u8 nhc_gw_family;
>     ...
>   }
>
> The access:
>   struct fib6_nh *fib6_nh = &rt->fib6_nh;
>   ... fib6_nh->nh_common.nhc_gw_family ...
>
> This patch ensures such an access is handled properly.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  kernel/bpf/btf.c | 33 ++++++++++++++++++++++++++++++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 2c098e6b1acc..22c69e1d5a56 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3831,6 +3831,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
>         const struct btf_type *mtype, *elem_type = NULL;
>         const struct btf_member *member;
>         const char *tname, *mname;
> +       u32 vlen;
>
>  again:
>         tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
> @@ -3839,7 +3840,37 @@ int btf_struct_access(struct bpf_verifier_log *log,
>                 return -EINVAL;
>         }
>
> -       if (off + size > t->size) {
> +       vlen = btf_type_vlen(t);
> +       if (vlen > 0 && off + size > t->size) {

if vlen == 0, it will skip this entire check and will eventually go to:

bpf_log(log, "struct %s doesn't have field at offset %d\n", tname, off);
return -EINVAL;

That's probably not right and we are better still reporting:

bpf_log(log, "access beyond struct %s at off %u size %u\n"
        tname, off, size);
return -EACCESS;

So this if (vlen > 0) check should be nested in this if?

> +               /* If the last element is a variable size array, we may
> +                * need to relax the rule.
> +                */
> +               struct btf_array *array_elem;
> +
> +               member = btf_type_member(t) + vlen - 1;
> +               mtype = btf_type_skip_modifiers(btf_vmlinux, member->type,
> +                                               NULL);
> +               if (!btf_type_is_array(mtype))
> +                       goto error;
> +
> +               array_elem = (struct btf_array *)(mtype + 1);
> +               if (array_elem->nelems != 0)
> +                       goto error;
> +
> +               moff = btf_member_bit_offset(t, member) / 8;
> +               if (off < moff)
> +                       goto error;
> +
> +               elem_type = btf_type_skip_modifiers(btf_vmlinux,
> +                                                   array_elem->type, NULL);
> +               if (!btf_type_is_struct(elem_type))
> +                       goto error;

What about array of primitive types or pointers? Do we want to
explicitly disable such use cases?

> +
> +               off = (off - moff) % elem_type->size;
> +               return btf_struct_access(log, elem_type, off, size, atype,
> +                                        next_btf_id);
> +
> +error:
>                 bpf_log(log, "access beyond struct %s at off %u size %u\n",
>                         tname, off, size);
>                 return -EACCES;
> --
> 2.24.1
>
