Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8573C2A3CCB
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 07:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbgKCG1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 01:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgKCG1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 01:27:33 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED58C0617A6;
        Mon,  2 Nov 2020 22:27:32 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id m188so13904784ybf.2;
        Mon, 02 Nov 2020 22:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rTRO4F1w5EMvWqRm9rx/p6VM9VDpE92UT3UmHBF1JwU=;
        b=IT7npgXArKO4DpXqaLINH76X6L4lhc8pEUQU804tI6S+zPh+qhA86UZ7cwPLjLT/SB
         fFjRVQUOq1cO2IMFJd6SE2JTMD5QOYv3hXIcTgS3LA/FGZXRL8LAmGcSwhoIg+PhWTNP
         qzyHwWQ01KVJEb17qHzNCODsDOUN6Oe3dXxIiaZgdc6uS61rVFm5pIlzssvVHzuf9tr+
         WcnhoknDwGEdCnQfj8IVU2FCXB5MMz+bStd30/QfoxHG1GdSC1N8HLUeuPsf4lzVO0s9
         mucsAiL+vEphtFmVMg5Ui4Akl3jL4iTaynybtu1rd4xtUPVKYkEevNwRAh5fYnW6ElqU
         D9ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rTRO4F1w5EMvWqRm9rx/p6VM9VDpE92UT3UmHBF1JwU=;
        b=sz0ZH6W+DX7NE0K/GlVhhqYz5eaFt8gXG2UZkf83PDQoBtpS8BXz3jFDkIIjVAxWxL
         ASAGLN9161Aksw8J/6FE2ldkA6xFTJNfltz88boqjTL75RjjH9cHZNYZWXi+2WK6uPMy
         8fc1wbS2kU0OU5kRD3ImimKFCCcbDT95GyL2YN2N1S7hv1XWyKOvhi9w2QdOdWHJdLxX
         ltkH5RbFxcPxV7vNZ039H2vmLp67r2JafnG7VglmM9KG51zJmBlotSa1aNauoWhBgX5f
         AXL1izegbDRrGrtxp3rjhMjr79dmFj88/8H6hcGuyTIc80NxKHCGNYRIT8xQM2DZwwmH
         e25Q==
X-Gm-Message-State: AOAM531/r577uLYGmYF/NYIDuOTrMZP/qTBM0C75jHpahg8+IqZ2b8hf
        rUTGnLK3webJFGjgxPQqkzs04y9sm+2NavCfri0=
X-Google-Smtp-Source: ABdhPJwYCz8P5u3NALtDms7RyYJ2NlDPRwug9D1wKu/MzfSj9kLAG6jW5SgvKi/OwtgBWxS8HNk/ZW2AX0s8Plg2KOI=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr27017276ybe.403.1604384851614;
 Mon, 02 Nov 2020 22:27:31 -0800 (PST)
MIME-Version: 1.0
References: <20201029005902.1706310-1-andrii@kernel.org> <20201029005902.1706310-9-andrii@kernel.org>
 <20201103051003.i565jv3ph54lw5rj@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201103051003.i565jv3ph54lw5rj@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Nov 2020 22:27:20 -0800
Message-ID: <CAEf4BzZV8oysWVmkF0K=FBFa5x=98duK8c+ixfiCFFP8dzWg2w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 08/11] libbpf: support BTF dedup of split BTFs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 2, 2020 at 9:10 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Oct 28, 2020 at 05:58:59PM -0700, Andrii Nakryiko wrote:
> > @@ -2942,6 +2948,13 @@ struct btf_dedup {
> >       __u32 *hypot_list;
> >       size_t hypot_cnt;
> >       size_t hypot_cap;
> > +     /* Whether hypothethical mapping, if successful, would need to adjust
> > +      * already canonicalized types (due to a new forward declaration to
> > +      * concrete type resolution). In such case, during split BTF dedup
> > +      * candidate type would still be considered as different, because base
> > +      * BTF is considered to be immutable.
> > +      */
> > +     bool hypot_adjust_canon;
>
> why one flag per dedup session is enough?

So the entire hypot_xxx state is reset before each struct/union type
graph equivalence check. Then for each struct/union type we might do
potentially many type graph equivalence checks against each of
potential canonical (already deduplicated) struct. Let's keep that in
mind for the answer below.

> Don't you have a case where some fwd are pointing to base btf and shouldn't
> be adjusted while some are in split btf and should be?
> It seems when this flag is set to true it will miss fwd in split btf?

So keeping the above note in mind, let's think about this case. You
are saying that some FWDs would have candidates in base BTF, right?
That means that the canonical type we are checking equivalence against
has to be in the base BTF. That also means that all the canonical type
graph types are in the base BTF, right? Because no base BTF type can
reference types from split BTF. This, subsequently, means that no FWDs
from split BTF graph could have canonical matching types in split BTF,
because we are comparing split types against only base BTF types.

With that, if hypot_adjust_canon is triggered, *entire graph*
shouldn't be matched. No single type in that (connected) graph should
be matched to base BTF. We essentially pretend that canonical type
doesn't even exist for us (modulo the subtle bit of still recording
base BTF's FWD mapping to a concrete type in split BTF for FWD-to-FWD
resolution at the very end, we can ignore that here, though, it's an
ephemeral bookkeeping discarded after dedup).

In your example you worry about resolving FWD in split BTF to concrete
type in split BTF. If that's possible (i.e., we have duplicates and
enough information to infer the FWD-to-STRUCT mapping), then we'll
have another canonical type to compare against, at which point we'll
establish FWD-to-STRUCT mapping, like usual, and hypot_adjust_canon
will stay false (because we'll be staying with split BTF types only).

But honestly, with graphs it can get so complicated that I wouldn't be
surprised if I'm still missing something. So far, manually checking
the resulting BTF showed that generated deduped BTF types look
correct. Few cases where module BTFs had duplicated types from vmlinux
I was able to easily find where exactly vmlinux had FWD while modules
had STRUCT/UNION.

But also, by being conservative with hypot_adjust_canon, the worst
case would be slight duplication of types, which is not the end of the
world. Everything will keep working, no data will be corrupted, libbpf
will still perform CO-RE relocation correctly (because memory layout
of duplicated structs will be consistent across all copies, just like
it was with task_struct until ring_buffers were renamed).
