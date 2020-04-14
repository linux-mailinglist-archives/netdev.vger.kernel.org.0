Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE541A6FF3
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 02:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390377AbgDNANv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 20:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390372AbgDNANv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 20:13:51 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3237BC0A3BDC;
        Mon, 13 Apr 2020 17:13:51 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id q17so8500893qtp.4;
        Mon, 13 Apr 2020 17:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ctsNaeDB/FhzDxVLxdQCuZgd7WZJGSkNfIxxzpN81Ek=;
        b=trpCxkFNSPzBe5q21kPCbeP/DSePgIJtc/Sh1egsgZd1b+4/3iXRpPKheqsv+WfuIO
         nCm0v8zkMmZckykiVJTBghrR8KABfEUavudS1LvZV158EEmQbe7pgH5XwHGnTtVcG72S
         c6Y3IZJlCP6sRK4tCji1ViDQo2CCsrY1b/bn1HE96vEZK669r9PNyTMpq/u2XDPHipw5
         S0GpHigJ0Hant9Rlhs2R2fuyu65XRLzWdTI0fAyrqLHAbgR9SNDrArN+tWPIqKjl1cQX
         lkb3ExwEOuX8+1zb5ODgOsrP3Unr3PJr3HQmMwciCw29Q/u0HEYUhCMj4asV5lWZBZ+7
         TFrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ctsNaeDB/FhzDxVLxdQCuZgd7WZJGSkNfIxxzpN81Ek=;
        b=aWqSEoUpk1NosDhRp70QaNXU/am/n5ApNOoC3F3TqDwZzXlNLWkiL+FitjSXPnAoAM
         mgPUHAO64Bhust96g498VIq0sG+H1lZEEwI6Ifo2bPnSxd9HEhJ9WAz3+FIsP6HS6Zzl
         Fr2z88n/MYELKtCquIz7bdUetnEC1gQaeLPmVYz2ApDOsLcoh5OpG193SnXljFl38Gxq
         0h30K3X0jkGu8Cg6nHQKypmNHpciF7P7ygjd5p0Q+SUiVC+ObYp1ijFU++r2f2Dov0Ec
         34OLKLLO8RzEem+bKpGMvaTAV/vV0Pe0fTLxf1XYlNQo9QeLmnZoxpmhRMqCKSVVLxhk
         38tQ==
X-Gm-Message-State: AGi0PuZSWrQvVhLTQxmkcU50GNTsihhSDMFuBp5M3Stny4rSmbk4SpwX
        ljg12W3lv+bMVURBfwp5233jhNqBSEfIypwZZIHtXcslVUw=
X-Google-Smtp-Source: APiQypIj95cPbuZpOhzM3iOb7qDrEzrHs3Nk6COZwkER+NWhxiyCXAbIH53BLRef1/LZ9eKh7y/Wa3W68/61zYPnhok=
X-Received: by 2002:ac8:3f6d:: with SMTP id w42mr9410765qtk.171.1586823230290;
 Mon, 13 Apr 2020 17:13:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232532.2676247-1-yhs@fb.com>
In-Reply-To: <20200408232532.2676247-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Apr 2020 17:13:39 -0700
Message-ID: <CAEf4Bzb6Uied+4pE0+QbjoeBWVzVHmjEfPGfr5Gr_FKZg_CTEQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 10/16] bpf: support variable length array in
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

On Wed, Apr 8, 2020 at 4:26 PM Yonghong Song <yhs@fb.com> wrote:
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
>  kernel/bpf/btf.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index d65c6912bdaf..89a0d983b169 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3837,6 +3837,31 @@ int btf_struct_access(struct bpf_verifier_log *log,
>         }
>
>         if (off + size > t->size) {
> +               /* If the last element is a variable size array, we may
> +                * need to relax the rule.
> +                */
> +               struct btf_array *array_elem;
> +               u32 vlen = btf_type_vlen(t);
> +               u32 last_member_type;
> +
> +               member = btf_type_member(t);
> +               last_member_type = member[vlen - 1].type;

vlen could be zero, and this will be bad


> +               mtype = btf_type_by_id(btf_vmlinux, last_member_type);

might want to strip modifiers here?

> +               if (!btf_type_is_array(mtype))
> +                       goto error;
> +

should probably check that off is >= last_member's offset within a
struct? Otherwise access might be spanning previous field and this
array?

> +               array_elem = (struct btf_array *)(mtype + 1);
> +               if (array_elem->nelems != 0)
> +                       goto error;
> +
> +               elem_type = btf_type_by_id(btf_vmlinux, array_elem->type);

strip modifiers

> +               if (!btf_type_is_struct(elem_type))
> +                       goto error;
> +
> +               off = (off - t->size) % elem_type->size;

I think it will be safer to use field offset, not struct size.
Consider example below

$ cat test-test.c
struct bla {
        long a;
        int b;
        char c[];
};

int main() {
        static struct bla *x = 0;
        return 0;
}

$ pahole -F btf -C bla test-test.o
struct bla {
        long int                   a;                    /*     0     8 */
        int                        b;                    /*     8     4 */
        char                       c[];                  /*    12     0 */

        /* size: 16, cachelines: 1, members: 3 */
        /* padding: 4 */
        /* last cacheline: 16 bytes */
};

c is at offset 12, but struct size is 16 due to long alignment. It
could be a 4-byte struct instead of char there.

> +               return btf_struct_access(log, elem_type, off, size, atype, next_btf_id);
> +
> +error:
>                 bpf_log(log, "access beyond struct %s at off %u size %u\n",
>                         tname, off, size);
>                 return -EACCES;
> --
> 2.24.1
>
