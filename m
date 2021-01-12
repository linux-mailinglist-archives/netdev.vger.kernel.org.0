Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970702F286E
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 07:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730595AbhALGmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 01:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728490AbhALGmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 01:42:11 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9680FC061575;
        Mon, 11 Jan 2021 22:41:31 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id r63so1205967ybf.5;
        Mon, 11 Jan 2021 22:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sgqx8hucgJ/Jqu0kJ1lD0k4L9Aktn/CDYsokI4Eu7+8=;
        b=DrY3ScReRR+F0mZnClZywrBJslMJHf8zZ1/xhzD5Q+BN8uOyAb2uRYCgvBxeJ2u+nY
         iNPfzxADvLAJ7/vPYfSJpSzqNf10Ag4lOuV32I+06QIgBwNrr/RZhaYsXsi71U7wnBPz
         YHTQplAljKjoo/ZexVavVOkaa0VyfkDVjCIlATGAkrpjWJe4XJJMgiS1ZkOZAPlubg12
         PETCtPteHPkCNt0FVq84pB3+K9OI4gcYQZNk3RWsof9n0ERfD6TirhrM9pCz+uegoneG
         PwAdJlNBeB7b4yXk2YpnJIsnkCzNBnSoyMyYdFfwvlS4pKlDe7YAY7tYRw6xaRk0a69R
         YFlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sgqx8hucgJ/Jqu0kJ1lD0k4L9Aktn/CDYsokI4Eu7+8=;
        b=HbAAAcRBbmwgCua0p9sfSX8xfIRrCWK2YLFantSTajfa/NbrJ6CLh5HYhAB3VmWNqp
         LR7qYgLCnPOCGWQLnatZZ4gv9HmEkxiMrwR7ivAX+8mz9AiPTtg9GQY1TCWRc4MadyLA
         21cXVn8O5Oiiy3GhMuMwi8dVKg7XqMUY0OYfXsEmLN7Wl7QyR9O7JEHuo3k2pkWrBPfn
         tLf1KpYjWkaLs3+hF/MQj0dVMHhow+ipBZOIAFRNJGTlsL1sEB3DniumrxpjwITVDzLo
         uQcyF8zJ00mRzu0cIrTtobClwHtJ1FWgHpsMaD4n5mpA8rV47oUSBxE9DQLNjfNORs2m
         8hHg==
X-Gm-Message-State: AOAM533AuFYQjMyt4sYG39vBhcLE3w5/2BSUiQWx9k/5z1iZ3r61qa26
        JeVLZADQGYFy17HCdiBFKwIL1R4lbOwvgmws5d8=
X-Google-Smtp-Source: ABdhPJzdkyagXSAzLv1r3Ja9JnKutKoo/atiU3rwMBgJdS6eyoIvnIaXMSgDExrzwQJcAGv2ZRFKqtiSCHnGYPnanXk=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr4465108ybe.403.1610433690725;
 Mon, 11 Jan 2021 22:41:30 -0800 (PST)
MIME-Version: 1.0
References: <20210110070341.1380086-1-andrii@kernel.org> <20210110070341.1380086-2-andrii@kernel.org>
 <e621981d-5c3d-6d92-871b-a98520778363@fb.com> <CAEf4BzZhFrHho-F+JyY6wQyWUZ+0cJJLkGv+=DHP4equkkm4iw@mail.gmail.com>
 <31ebd16f-8218-1457-b4e2-3728ab147747@fb.com>
In-Reply-To: <31ebd16f-8218-1457-b4e2-3728ab147747@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Jan 2021 22:41:19 -0800
Message-ID: <CAEf4BzY0xwwH+yD3dvjSjDG1t_w4ktAeo_gM6WQWw676TghJpQ@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] libbpf: allow loading empty BTFs
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Christopher William Snowhill <chris@kode54.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 5:16 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 1/11/21 12:51 PM, Andrii Nakryiko wrote:
> > On Mon, Jan 11, 2021 at 10:13 AM Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 1/9/21 11:03 PM, Andrii Nakryiko wrote:
> >>> Empty BTFs do come up (e.g., simple kernel modules with no new types and
> >>> strings, compared to the vmlinux BTF) and there is nothing technically wrong
> >>> with them. So remove unnecessary check preventing loading empty BTFs.
> >>>
> >>> Reported-by: Christopher William Snowhill <chris@kode54.net>
> >>> Fixes: ("d8123624506c libbpf: Fix BTF data layout checks and allow empty BTF")
> >>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> >>> ---
> >>>    tools/lib/bpf/btf.c | 5 -----
> >>>    1 file changed, 5 deletions(-)
> >>>
> >>> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> >>> index 3c3f2bc6c652..9970a288dda5 100644
> >>> --- a/tools/lib/bpf/btf.c
> >>> +++ b/tools/lib/bpf/btf.c
> >>> @@ -240,11 +240,6 @@ static int btf_parse_hdr(struct btf *btf)
> >>>        }
> >>>
> >>>        meta_left = btf->raw_size - sizeof(*hdr);
> >>> -     if (!meta_left) {
> >>> -             pr_debug("BTF has no data\n");
> >>> -             return -EINVAL;
> >>> -     }
> >>
> >> Previous kernel patch allows empty btf only if that btf is module (not
> >> base/vmlinux) btf. Here it seems we allow any empty non-module btf to be
> >> loaded into the kernel. In such cases, loading may fail? Maybe we should
> >> detect such cases in libbpf and error out instead of going to kernel and
> >> get error back?
> >
> > I did this consciously. Kernel is more strict, because there is no
> > reasonable case when vmlinux BTF or BPF program's BTF can be empty (at
> > least not that now we have FUNCs in BTF). But allowing libbpf to load
> > empty BTF generically is helpful for bpftool, as one example, for
> > inspection. If you do `bpftool btf dump` on empty BTF, it will just
> > print nothing and you'll know that it's a valid (from BTF header
> > perspective) BTF, just doesn't have any types (besides VOID). If we
> > don't allow it, then we'll just get an error and then you'll have to
> > do painful hex dumping and decoding to see what's wrong.
>
> It is totally okay to allow empty btf in libbpf. I just want to check
> if this btf is going to be loaded into the kernel, right before it is
> loading whether libbpf could check whether it is a non-module empty btf
> or not, if it is, do not go to kernel.

Ok, I see what you are proposing. We can do that, but it's definitely
separate from these bug fixes. But, to be honest, I wouldn't bother
because libbpf will return BTF verification log with a very readable
"No data" message in it.

>
> >
> > In practice, no BPF program's BTF should be empty, but if it is, the
> > kernel will rightfully stop you. I don't think it's a common enough
> > case for libbpf to handle.
>
> In general, libbpf should catch errors earlier if possible without going
> to kernel. This way, we can have better error messages for user.
> But I won't insist in this case as it is indeed really rare.

I wouldn't say in general. Rather in cases that commonly would cause
confusion. I don't think libbpf should grow into a massive "let's
double check everything before kernel" thing.

>
> >
> >>
> >>> -
> >>>        if (meta_left < hdr->str_off + hdr->str_len) {
> >>>                pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
> >>>                return -EINVAL;
> >>>
