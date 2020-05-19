Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1A91D8C3E
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 02:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgESAZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 20:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgESAZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 20:25:39 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69063C061A0C;
        Mon, 18 May 2020 17:25:39 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id d7so9740796qtn.11;
        Mon, 18 May 2020 17:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6nQAIsGmbBiNV1zSsJWz0TENOrH6776bbwZuF8Trr/w=;
        b=PuB7x/uVjj+wZ/Gxit6ndJAZ2p1GOG41RE3fdhvuzB3KG3w1MrvH1AbDzwTBrI+OTg
         3qlFSI/J7tqm0sQzs0JKdBholOEQl5vDk9J8gEyowujMKD+xSbp15FX10gXg2rs+9N4/
         15Qw+H+xeMeYCziG8zL48HeAJOISggk/T/BCCZD5qCP0Rc4U2rdcktZRudMN9NndwVG/
         MBSovAoMGGZXRzHbXEdGGSKtka3KBnGf8kJ3JhVu+DXuP3mdzQ0PKnzNV3LLrURgqcSG
         pCUq9CBCQ0pErIWy7cV+APAwi7ObeXfRIXnqAlNR5XfocyfJ43KTrjbs2x7RGEPqcKd+
         C+Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6nQAIsGmbBiNV1zSsJWz0TENOrH6776bbwZuF8Trr/w=;
        b=qfFgQMcfEDXig+jaxgZb0JoVXz8djD9DycH4LztP1jZJu5iGVhYnhaS5iGOo4JQz1u
         5L6S51E7LwhWE9iUTWA8/2LnAtAcKn4EA4gi8UylYMB01OgkXQn4dPBHkUewswBHL324
         7fU57mVNAeGmVqKVbZ5jGSg3aZDu1KKVLasmKSl7fzYP5pjBMZRaHgjoUHbBVMUAYGKD
         rCNyTcXX6qRAJXKOecUcFYFkjPPr5aCCQZfaaLVekdSpcFSVRK+gEpzvLPk7btT2/eju
         /Fj5QotY7j27cqJU7C9RweRsDNOBSkuq7z4xzjcevyxwrZpmKJ+8rc60zwaKvAbdEFq2
         907Q==
X-Gm-Message-State: AOAM533jPtUbVqWpjFOML+Qf66VZ/47Q4IJltQVeLgNWNJFQddSE8m3H
        R30plWTig35KwoL1w1lwygQtS+aWEzB4FzJ0I0g=
X-Google-Smtp-Source: ABdhPJz4l7HrIm3Z41Fbwv9AZMAfCNar9zykDJML/8NhiMsNv1WTtuHZdvzwk12LIrWvtKuF/4VC9YZz8BdRrF7pHxk=
X-Received: by 2002:aed:24a1:: with SMTP id t30mr18426331qtc.93.1589847938662;
 Mon, 18 May 2020 17:25:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAG=TAF6mfrwxF1-xEJJ9dL675uMUa7RZrOa_eL2mJizZJ-U7iQ@mail.gmail.com>
 <CAEf4BzazvGOoJbm+zNMqTjhTPJAnVLVv9V=rXkdXZELJ4FPtiA@mail.gmail.com> <CAG=TAF6aqo-sT2YE30riqp7f47KyXH_uhNJ=M9L12QU6EEEfqQ@mail.gmail.com>
In-Reply-To: <CAG=TAF6aqo-sT2YE30riqp7f47KyXH_uhNJ=M9L12QU6EEEfqQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 May 2020 17:25:27 -0700
Message-ID: <CAEf4BzaBfnDL=WpRP-7rYFhocOsCQyFuZaLvM0+k9sv2t_=rVw@mail.gmail.com>
Subject: Re: UBSAN: array-index-out-of-bounds in kernel/bpf/arraymap.c:177
To:     Qian Cai <cai@lca.pw>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 5:09 PM Qian Cai <cai@lca.pw> wrote:
>
> On Mon, May 18, 2020 at 7:55 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Sun, May 17, 2020 at 7:45 PM Qian Cai <cai@lca.pw> wrote:
> > >
> > > With Clang 9.0.1,
> > >
> > > return array->value + array->elem_size * (index & array->index_mask);
> > >
> > > but array->value is,
> > >
> > > char value[0] __aligned(8);
> >
> > This, and ptrs and pptrs, should be flexible arrays. But they are in a
> > union, and unions don't support flexible arrays. Putting each of them
> > into anonymous struct field also doesn't work:
> >
> > /data/users/andriin/linux/include/linux/bpf.h:820:18: error: flexible
> > array member in a struct with no named members
> >    struct { void *ptrs[] __aligned(8); };
> >
> > So it probably has to stay this way. Is there a way to silence UBSAN
> > for this particular case?
>
> I am not aware of any way to disable a particular function in UBSAN
> except for the whole file in kernel/bpf/Makefile,
>
> UBSAN_SANITIZE_arraymap.o := n
>
> If there is no better way to do it, I'll send a patch for it.


That's probably going to be too drastic, we still would want to
validate the rest of arraymap.c code, probably. Not sure, maybe
someone else has better ideas.
