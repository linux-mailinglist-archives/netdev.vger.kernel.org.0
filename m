Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE4F2CCA63
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 00:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgLBXPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 18:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgLBXPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 18:15:31 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4140C0613D6;
        Wed,  2 Dec 2020 15:14:50 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id x2so239026ybt.11;
        Wed, 02 Dec 2020 15:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nGxCtMNJDgf1cyOB7q7af9Sc386RqxI2oNG59WeMtQg=;
        b=h2kk8P+aYs8odNE+dXHkUSreESq6Oh0CezWkKmbHCowgZ5oARvfq+l2MfYZdsOFcmU
         cXm1BDBZdmTY1/oer1MJNkSx/CoheCFPVwIGRZEhR4Y9i05WHeTNXKIbl+OxWpocngJk
         pBe53T0MFcUwTbCJ2QsL5D4LSpiWuBFIUcNQRIx7vIAecvtsceJ1jLdEdx2IXGA9C379
         tqSBdpgSHrCpYWOqOfT9P/VrSTih/yxMlEvZyYwxXuVqFnrL/1NpAuDQqAI8ypXR5Yes
         dbW7LyBF6pezIp87EpDVy/FkPpz/xcXxeW76NI76qfB60dsuMCzMMBrIQeOnxQVV183O
         k67A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nGxCtMNJDgf1cyOB7q7af9Sc386RqxI2oNG59WeMtQg=;
        b=S4hZ5M3k42ef7dSc5RhEOxaxWQCLdUI+/PkIAKNoteDkhGOLk7/fYIqictSBsGF16O
         M/FyEP0QtN2FeVGSaBJvvmB+nQP4ojDuflCefrUIlF1VtgQWW7OtNdguaNy8cejYda+E
         GNIstdtm3r07w06tV2uAPx66FZv1+ZC8EzkQ8WZS3lF+G4bFVT4G8eisTAPH4zw/wrLa
         57iPz1mqDvD/Gk69QrOilM//uIykoGHfTzkYHZDzHFRXpje3ZDEdvL6P+8ulSvoNLyQ1
         jfUnDYRPaX2LECkas8vETe6DEGuYtQHsIz4oAkNNDNER0xkdrwoW6zvJuyko0qyjW9h7
         g56Q==
X-Gm-Message-State: AOAM5339QUmfA3IZesJz4pLIOPZP64y/OM6GZuA4d9X9EQu95R9b8fi5
        lpfphhQx1YSWgdNKh6f4HMfnKAC5j5QT3FcScKs=
X-Google-Smtp-Source: ABdhPJxTlvqcbHxY76d9DlbJ25btfcQck5JgD+8jIdz+Bbe+98FLpF5W40UD6K/R3Adg6FxQjhUB6I0iuQzF9+eBreg=
X-Received: by 2002:a25:3d7:: with SMTP id 206mr667826ybd.27.1606950890156;
 Wed, 02 Dec 2020 15:14:50 -0800 (PST)
MIME-Version: 1.0
References: <20201202001616.3378929-1-andrii@kernel.org> <20201202001616.3378929-11-andrii@kernel.org>
 <20201202205809.qwbismdmmtrcsar7@ast-mbp> <CAEf4BzbeUu78v63UmDCzQ5jDhBqzaX-85GHdqc1aMuiy7ZMn3w@mail.gmail.com>
 <CAADnVQ+6QAGSgaXZu7g75suOcG+KEanoJNb6DP-jFKoHZKKxiA@mail.gmail.com>
In-Reply-To: <CAADnVQ+6QAGSgaXZu7g75suOcG+KEanoJNb6DP-jFKoHZKKxiA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Dec 2020 15:14:39 -0800
Message-ID: <CAEf4BzYoA-xDwPtGAV-rtd7VObpHefNd0YgLguJJdTp70_PK5w@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 10/14] bpf: allow to specify kernel module
 BTFs when attaching BPF programs
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

On Wed, Dec 2, 2020 at 3:12 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Dec 2, 2020 at 2:43 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Dec 2, 2020 at 12:58 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Tue, Dec 01, 2020 at 04:16:12PM -0800, Andrii Nakryiko wrote:
> > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > index c3458ec1f30a..60b95b51ccb8 100644
> > > > --- a/include/uapi/linux/bpf.h
> > > > +++ b/include/uapi/linux/bpf.h
> > > > @@ -558,6 +558,7 @@ union bpf_attr {
> > > >               __u32           line_info_cnt;  /* number of bpf_line_info records */
> > > >               __u32           attach_btf_id;  /* in-kernel BTF type id to attach to */
> > > >               __u32           attach_prog_fd; /* 0 to attach to vmlinux */
> > > > +             __u32           attach_btf_obj_id; /* vmlinux/module BTF object ID for BTF type */
> > >
> > > I think the uapi should use attach_btf_obj_fd here.
> > > Everywhere else uapi is using FDs to point to maps, progs, BTFs of progs.
> > > BTF of a module isn't different from BTF of a program.
> > > Looking at libbpf implementation... it has the FD of a module anyway,
> > > since it needs to fetch it to search for the function btf_id in there.
> > > So there won't be any inconvenience for libbpf to pass FD in here.
> > > From the uapi perspective attach_btf_obj_fd will remove potential
> > > race condition. It's very unlikely race, of course.
> >
> > Yes, I actually contemplated that, but my preference went the ID way,
> > because it made libbpf implementation simpler and there was a nice
> > duality of using ID for types and BTF instances themselves.
> >
> > The problem with FD is that when I load all module BTF objects, I open
> > their FD one at a time, and close it as soon as I read BTF raw data
> > back. If I don't do that on systems with many modules, I'll be keeping
> > potentially hundreds of FDs open, so I figured I don't want to do
> > that.
> >
> > But I do see the FD instead of ID consistency as well, so I can go
> > with a simple and inefficient implementation of separate FD for each
> > BTF object for now, and if someone complains, we can teach libbpf to
> > lazily open FDs of module BTFs that are actually used (later, it will
> > complicate code unnecessarily). Not really worried about racing with
> > kernel modules being unloaded.
> >
> > Also, if we use FD, we might not need a new attach_bpf_obj_id field at
> > all, we can re-use attach_prog_fd field (put it in union and have
> > attach_prog_fd/attach_btf_fd). On the kernel side, it would be easy to
> > check whether provided FD is for bpf_prog or btf. What do you think?
> > Too mysterious? Or good?
>
> You mean like:
> union {
>          __u32           attach_prog_fd; /* valid prog_fd to attach to
> bpf prog */
>          __u32           attach_btf_obj_fd; /* or  valid module BTF
> object fd or zero to attach to vmlinux */
> };

like this with union, an aliased field name with a meaningful name

> or don't introduce a new field name at all?
> Sure. I'm fine with both. I think it's a good idea.

ok, will do this then
