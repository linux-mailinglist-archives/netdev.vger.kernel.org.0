Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E675E1A451
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 23:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbfEJVKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 17:10:55 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33725 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727835AbfEJVKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 17:10:55 -0400
Received: by mail-qt1-f195.google.com with SMTP id m32so5240984qtf.0
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 14:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=THcUwxzIuREArOc+zLL1sHNL/ieDsk0mHKvpJQeplds=;
        b=ucPlXOjkUvujI5+CcmJa1q+/PYuGeLz9CG6YtF32opv1CmO1yRuzS3NzVoMC7niovr
         Bj3aRZcK59Z2Hy1NEL979UF3psm6P64vsVqhBrDpNe16WvadkkC/TM0+V+TPK0YWuA0I
         CHawRHfs2f7wDq9ltXmIHBzawWgfWEfRSAkAWtC59trFt1bF7xjVW+Q+qhVuMjGaObpc
         9ZQg2+jG4sayCezw3gdgEG2TgCRZja1XaFh9BycNJgSHi4WU0cy3EqeOURkReZhJ6lAS
         kXaXHDHqZELD1AbTDwZp0GdNdhppWPMqX9cJEEvaC6VSXmz4hgZP6G8hBkl/WzIqCBYJ
         nIoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=THcUwxzIuREArOc+zLL1sHNL/ieDsk0mHKvpJQeplds=;
        b=HgNLzTDuVr7X6bEo3i1ZnQ5MdgNRrXHafcdvV4hOyo0BtSvP2ikfWaQ+1Ydfgdi01Y
         wc1SIHeXOXZfBDmbNXIEH7XOnHJq18qm1Nm7AxqBtKk4o6yKfZPsC76eJomh3eEy3vAM
         mP3E6i6tsf5VH/Ols128EADOZbCP6kVNDF9S9brw1ySrvEevn/VFQzHFXjBU5MxnhsUc
         aKOrtEUVlg2C3nJm4s9OyTSea0qDdXwNnJGQbSnPzdMvjqvCIY4dDHp2FRua58vyJEue
         doMTcw/JAzEz8+fWVtsygehOCDmcyv3qY3AbDO53GlJbBgKXRcd2/pWv2Msrd30l/3s/
         Vywg==
X-Gm-Message-State: APjAAAWaFKACKkL02K9S9Jx1uYwmrYu4SZxeK+6FwRqyW8rBBXBAX47/
        rsRg62drdqIlnBms1iKQY8t+yFxcqiAaHOFUrxc=
X-Google-Smtp-Source: APXvYqxEc8q1+A8w9K6RL7Egc1KNIBJc0e2EmABHfU223/ns+uTMVivsAEoUAwiIzhwMeKupo5eTJA4kYWAOfDyCfqw=
X-Received: by 2002:aed:2196:: with SMTP id l22mr11786455qtc.226.1557522654565;
 Fri, 10 May 2019 14:10:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190510184150.1671773-1-andriin@fb.com> <20190510201315.jrzt2yo2pchbckda@ast-mbp>
In-Reply-To: <20190510201315.jrzt2yo2pchbckda@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 10 May 2019 14:10:43 -0700
Message-ID: <CAEf4BzbmPwDqZBoKWK+L9VfKj1O=sC-RogzvT53jNEGMVMeZ2A@mail.gmail.com>
Subject: Re: [PATCH v2 bpf] libbpf: detect supported kernel BTF features and
 sanitize BTF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 10, 2019 at 1:13 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, May 10, 2019 at 11:41:50AM -0700, Andrii Nakryiko wrote:
> > Depending on used versions of libbpf, Clang, and kernel, it's possible to
> > have valid BPF object files with valid BTF information, that still won't
> > load successfully due to Clang emitting newer BTF features (e.g.,
> > BTF_KIND_FUNC, .BTF.ext's line_info/func_info, BTF_KIND_DATASEC, etc), that
> > are not yet supported by older kernel.
> >
> > This patch adds detection of BTF features and sanitizes BPF object's BTF
> > by substituting various supported BTF kinds, which have compatible layout:
> >   - BTF_KIND_FUNC -> BTF_KIND_TYPEDEF
> >   - BTF_KIND_FUNC_PROTO -> BTF_KIND_ENUM
> >   - BTF_KIND_VAR -> BTF_KIND_INT
> >   - BTF_KIND_DATASEC -> BTF_KIND_STRUCT
> >
> > Replacement is done in such a way as to preserve as much information as
> > possible (names, sizes, etc) where possible without violating kernel's
> > validation rules.
> >
> > v1->v2:
> >   - add internal libbpf_util.h w/ common stuff
> >   - switch SK storage BTF to use new libbpf__probe_raw_btf()
> >
> > Reported-by: Alexei Starovoitov <ast@fb.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ...
> > diff --git a/tools/lib/bpf/libbpf_util.h b/tools/lib/bpf/libbpf_util.h
> > index da94c4cb2e4d..319e744eb33a 100644
> > --- a/tools/lib/bpf/libbpf_util.h
> > +++ b/tools/lib/bpf/libbpf_util.h
> > @@ -57,4 +57,16 @@ do {                               \
> >  } /* extern "C" */
> >  #endif
> >
> > +#define BTF_INFO_ENC(kind, kind_flag, vlen) \
> > +     ((!!(kind_flag) << 31) | ((kind) << 24) | ((vlen) & BTF_MAX_VLEN))
> > +#define BTF_TYPE_ENC(name, info, size_or_type) (name), (info), (size_or_type)
> > +#define BTF_INT_ENC(encoding, bits_offset, nr_bits) \
> > +     ((encoding) << 24 | (bits_offset) << 16 | (nr_bits))
> > +#define BTF_TYPE_INT_ENC(name, encoding, bits_offset, bits, sz) \
> > +     BTF_TYPE_ENC(name, BTF_INFO_ENC(BTF_KIND_INT, 0, 0), sz), \
> > +     BTF_INT_ENC(encoding, bits_offset, bits)
> > +#define BTF_MEMBER_ENC(name, type, bits_offset) (name), (type), (bits_offset)
> > +#define BTF_PARAM_ENC(name, type) (name), (type)
> > +#define BTF_VAR_SECINFO_ENC(type, offset, size) (type), (offset), (size)
>
> hmm. why are those needed in libbpf_util.h ?
> I thought the goal is move them into libbpf_internal.h
> and not to expose to users?

Oh... Sorry, my bad, leftover from previous refactoring... Looks like
there will be v3.
