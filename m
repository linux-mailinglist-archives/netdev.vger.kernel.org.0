Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9AB368955
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 01:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239860AbhDVX3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 19:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239773AbhDVX3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 19:29:31 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08F4C061574;
        Thu, 22 Apr 2021 16:28:54 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id 82so53549173yby.7;
        Thu, 22 Apr 2021 16:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MsAUP8hfMm5Flo9URYi6EnEGXp6KOww0sDyUOef+0Rs=;
        b=jeE/a+TMQ+mamP5CRpcdvvoi1xb/6fwMugETHobjJuSmYRG2GCKAa7/nG5YyV7p1xK
         op2LBwpiX5ysJZB2I21EW4JgO8Ti3uNDXXgOHTyeAHyiIcRwFRFeDGhD24iX5KK/yGPt
         EU65cgVRYNosjXvsc0g9GfeiPh6l11fXXLuHxqtl1w/DTPlpVnx9arJIzbCaw9ToBBzJ
         wDcL8Sb4rWHG2WK6g23GaG+Udt2KEinWQJwXgkwsp/UI6lDzXjpGiuHuAm2HdduUSpdt
         e94WVsKAD8QEmhlTPg9nQlDSLYTQbg9thrakcBwMFp9FDg13WdtOahRUov0fg2t9xOtN
         zF8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MsAUP8hfMm5Flo9URYi6EnEGXp6KOww0sDyUOef+0Rs=;
        b=rKZgklsLhhCKZ1F4v8X4nx8beX/4RauSbR1Yd4x0Xrjw+9Z1RN7EVfY+HqbiOSw57B
         5cwIuSve/rMSnpVS7IIuoWfH2UhHOPNnrORQrevs2XtMzH77gRGQT5M9TB9MgEBa5RKp
         8Al5+3JNO5lXFDyLDtztj94qsd7V2jrXeFGtk+k+EGdGp4JTDkdDb7KsTDa51w3hBWz7
         s+QMNCYviSJvrcMbqqVfi2o9ga7OvJdchhDxUfBDTqrJnV432n3i2mjjVtl1sJCTw+/6
         ES2+JqWAXNpF61NoEn04d/XcEORxuZdvYxJ0hjjMGNkkOc43mxc29h3uyvxdm8/FqjS6
         uCug==
X-Gm-Message-State: AOAM532oJ7+zQft9bOVAVL9TKgtf3bBFJ8xsnot2V2mScoacnnEK/K+l
        MjvnP0NP22pMELY5wJt5ecJWO/xjQ3/xog9pMno=
X-Google-Smtp-Source: ABdhPJxt25Bl9NBktC7VIlxZQq/mpYZVdkUs1UC0pKAlHBpkIJTJp9sswqn/HBC6qwjQddYpJcFpvymbzmd8JKxLUO4=
X-Received: by 2002:a05:6902:1144:: with SMTP id p4mr1590838ybu.510.1619134134039;
 Thu, 22 Apr 2021 16:28:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-5-andrii@kernel.org>
 <8cde2756-e62f-7103-05b1-7d9a9d97442a@fb.com> <CAEf4BzYFHp8vt6rwgcZG5Lp-DQU0xrVq8QXvDqOyVOtx0gosnw@mail.gmail.com>
 <65869842-b1a0-5e95-9ca2-42aaf86644a8@fb.com>
In-Reply-To: <65869842-b1a0-5e95-9ca2-42aaf86644a8@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Apr 2021 16:28:42 -0700
Message-ID: <CAEf4BzZhgqDsBQ+Ytqmh9v7HFoHB1o9kWp1dgFay9d6kEyrMJA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 04/17] libbpf: mark BPF subprogs with hidden
 visibility as static for BPF verifier
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 4:00 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/22/21 11:09 AM, Andrii Nakryiko wrote:
> > On Wed, Apr 21, 2021 at 10:43 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> >>> Define __hidden helper macro in bpf_helpers.h, which is a short-hand for
> >>> __attribute__((visibility("hidden"))). Add libbpf support to mark BPF
> >>> subprograms marked with __hidden as static in BTF information to enforce BPF
> >>> verifier's static function validation algorithm, which takes more information
> >>> (caller's context) into account during a subprogram validation.
> >>>
> >>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> >>> ---
> >>>    tools/lib/bpf/bpf_helpers.h     |  8 ++++++
> >>>    tools/lib/bpf/btf.c             |  5 ----
> >>>    tools/lib/bpf/libbpf.c          | 45 ++++++++++++++++++++++++++++++++-
> >>>    tools/lib/bpf/libbpf_internal.h |  6 +++++
> >>>    4 files changed, 58 insertions(+), 6 deletions(-)
> >>>
> >>> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> >>> index 75c7581b304c..9720dc0b4605 100644
> >>> --- a/tools/lib/bpf/bpf_helpers.h
> >>> +++ b/tools/lib/bpf/bpf_helpers.h
> >>> @@ -47,6 +47,14 @@
> >>>    #define __weak __attribute__((weak))
> >>>    #endif
> >>>
> >>> +/*
> >>> + * Use __hidden attribute to mark a non-static BPF subprogram effectively
> >>> + * static for BPF verifier's verification algorithm purposes, allowing more
> >>> + * extensive and permissive BPF verification process, taking into account
> >>> + * subprogram's caller context.
> >>> + */
> >>> +#define __hidden __attribute__((visibility("hidden")))
> >>
> >> To prevent potential external __hidden macro definition conflict, how
> >> about
> >>
> >> #ifdef __hidden
> >> #undef __hidden
> >> #define __hidden __attribute__((visibility("hidden")))
> >> #endif
> >>
> >
> > We do force #undef only with __always_inline because of the bad
> > definition in linux/stddef.h And we check #ifndef for __weak, because
> > __weak is defined in kernel headers. This is not really the case for
> > __hidden, the only definition is in
> > tools/lib/traceevent/event-parse-local.h, which I don't think we
> > should worry about in BPF context. So I wanted to keep it simple and
> > fix only if that really causes some real conflicts.
> >
> > And keep in mind that in BPF code bpf_helpers.h is usually included as
> > one of the first few headers anyways.
>
> That is fine. Conflict of __hidden is a low risk and we can deal with it
> later if needed.
>
> >
> >
> >>> +
> >>>    /* When utilizing vmlinux.h with BPF CO-RE, user BPF programs can't include
> >>>     * any system-level headers (such as stddef.h, linux/version.h, etc), and
> >>>     * commonly-used macros like NULL and KERNEL_VERSION aren't available through
> >
> > [...]
> >
> >>> @@ -698,6 +700,15 @@ bpf_object__add_programs(struct bpf_object *obj, Elf_Data *sec_data,
> >>>                if (err)
> >>>                        return err;
> >>>
> >>> +             /* if function is a global/weak symbol, but has hidden
> >>> +              * visibility (or any non-default one), mark its BTF FUNC as
> >>> +              * static to enable more permissive BPF verification mode with
> >>> +              * more outside context available to BPF verifier
> >>> +              */
> >>> +             if (GELF_ST_BIND(sym.st_info) != STB_LOCAL
> >>> +                 && GELF_ST_VISIBILITY(sym.st_other) != STV_DEFAULT)
> >>
> >> Maybe we should check GELF_ST_VISIBILITY(sym.st_other) == STV_HIDDEN
> >> instead?
> >
> > It felt like only STV_DEFAULT should be "exported", semantically
> > speaking. Everything else would be treated as if it was static, except
> > that C rules require that function has to be global. Do you think
> > there is some danger to do it this way?
> >
> > Currently static linker doesn't do anything special for STV_INTERNAL
> > and STV_PROTECTED, so we could just disable those. Do you prefer that?
>
> Yes, let us just deal with STV_DEFAULT and STV_HIDDEN. We already
> specialized STV_HIDDEN, so we should not treat STV_INTERNAL/PROTECTED
> as what they mean in ELF standard, so let us disable them for now.

Yep, will do

>
> >
> > I just felt that there is no risk of regression if we do this for
> > non-STV_DEFAULT generically.
> >
> >
> >>
> >>> +                     prog->mark_btf_static = true;
> >>> +
> >>>                nr_progs++;
> >>>                obj->nr_programs = nr_progs;
> >>>
> >
> > [...]
> >
