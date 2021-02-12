Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D513931A6E9
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 22:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhBLVa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 16:30:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27983 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231501AbhBLVaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 16:30:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613165368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0maAmKJ5LszuYenhjRQmxflXMdoznBGG5sX99MzX/5k=;
        b=LTklSNe1PWZnqP8fDpmpybi5dynMrMRG55Jzc32m2nfEaCfh98eYbebwH5uJAlMPZyOFi+
        4DdfBAuUjzK2uPaZqgNpN5uCg276q0Fx07xRAjYFtibLVsa0kmJzShto3fJVNLPPR2rnDd
        KvbUiSXuhve0Gbg/P7dcSQigWRe2sUQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-tN_QltxJMeq54MN7TIBKnw-1; Fri, 12 Feb 2021 16:29:24 -0500
X-MC-Unique: tN_QltxJMeq54MN7TIBKnw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 838C0801965;
        Fri, 12 Feb 2021 21:29:22 +0000 (UTC)
Received: from krava (unknown [10.40.193.141])
        by smtp.corp.redhat.com (Postfix) with SMTP id 7298250A8B;
        Fri, 12 Feb 2021 21:29:19 +0000 (UTC)
Date:   Fri, 12 Feb 2021 22:29:18 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
Message-ID: <YCbzLrtukxH3r4Hf@krava>
References: <CAEf4BzaL=qsSyDc8OxeN4pr7+Lvv+de4f+hM5a56LY8EABAk3w@mail.gmail.com>
 <YCMEucGZVPPQuxWw@krava>
 <CAEf4BzacQrkSMnmeO3sunOs7sfhX1ZoD_Hnk4-cFUK-TpLNqUA@mail.gmail.com>
 <YCPfEzp3ogCBTBaS@krava>
 <CAEf4BzbzquqsA5=_UqDukScuoGLfDhZiiXs_sgYBuNUvTBuV6w@mail.gmail.com>
 <YCQ+d0CVgIclDwng@krava>
 <YCVIWzq0quDQm6bn@krava>
 <CAEf4Bzbt2-Mn4+y0c+sSZWUSrP705c_e3SxedjV_xYGPQL79=w@mail.gmail.com>
 <YCavItKm0mKxcVQD@krava>
 <CAEf4BzaJkfVYLU+zA6kmJRNd5uqGyk2B8G6BT22pKjMt7RqpSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaJkfVYLU+zA6kmJRNd5uqGyk2B8G6BT22pKjMt7RqpSg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 11:22:41AM -0800, Andrii Nakryiko wrote:

SNIP

> > +static int is_ftrace_func(struct elf_function *func, __u64 *addrs,
> > +                         __u64 count, bool kmod)
> > +{
> > +       /*
> > +        * For vmlinux image both addrs[x] and functions[x]::addr
> > +        * values are final address and are comparable.
> > +        *
> > +        * For kernel module addrs[x] is final address, but
> > +        * functions[x]::addr is relative address within section
> > +        * and needs to be relocated by adding sh_addr.
> > +        */
> > +       __u64 start = kmod ? func->addr + func->sh_addr : func->addr;
> > +       __u64 addr, end = func->addr + func->size;
> > +
> > +       /*
> > +        * The invariant here is addr[r] that is the smallest address
> > +        * that is >= than function start addr. Except the corner case
> > +        * where there is no such r, but for that we have a final check
> > +        * in the return.
> > +        */
> > +       size_t l = 0, r = count - 1, m;
> > +
> > +       /* make sure we don't use invalid r */
> > +       if (count == 0)
> > +               return false;
> > +
> > +       while (l < r) {
> > +               m = l + (r - l) / 2;
> > +               addr = addrs[m];
> > +
> > +               if (addr >= start) {
> > +                       /* we satisfy invariant, so tighten r */
> > +                       r = m;
> > +               } else {
> > +                       /* m is not good enough as l, maybe m + 1 will be */
> > +                       l = m + 1;
> > +               }
> > +       }
> > +
> > +       return start <= addrs[r] && addrs[r] < end;
> > +}
> > +
> >  static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
> >  {
> >         __u64 *addrs, count, i;
> > @@ -267,7 +321,7 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
> >         }
> >
> >         qsort(addrs, count, sizeof(addrs[0]), addrs_cmp);
> > -       qsort(functions, functions_cnt, sizeof(functions[0]), functions_cmp);
> > +       qsort(functions, functions_cnt, sizeof(functions[0]), functions_cmp_addr);
> 
> All looks good except this. We don't rely on functions being sorted in
> ascending start addr order, do we? If not, just drop this, no need to
> slow down the process.

right, it's not needed when we use st_size for function size

thanks,
jirka

