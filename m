Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438AB36DF25
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 20:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240290AbhD1SpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 14:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhD1SpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 14:45:18 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6196C061573;
        Wed, 28 Apr 2021 11:44:29 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id y2so73118201ybq.13;
        Wed, 28 Apr 2021 11:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zBLqZ9IWdvczfLPhIohpqWU++dyivLH8IfdhiOCsogM=;
        b=fGssajRhMUOJpvzbtRd7j16IyFQnjTX/8+oxcOWpTBJ+9do/rs7/C6wsNYAo3hf/+m
         JWGJjN5thvAaJRRe2Gwti6T/6Y+AAN/2eGFnNnScxgFslk1K75GIUXPEa6x8s259RUuj
         k9lvrzGPJhwzxxcYDFSZXvM+voPyTHniMPvO7YKoWuaiNm1EdVHYk4isdBejEuSXaT64
         XWE3SoaNODj97/jkRiZtNRBTBWvsD597KECjNZvhKGQJZSrsQnGBm4Y13xTRwuwv1YNG
         tdyWGyLiVuLP+i4UYAEY4ZCyvJyzv7LDe/ymog+y2vQ3HlcDq1vufufVcq941Hhe3oeM
         se8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zBLqZ9IWdvczfLPhIohpqWU++dyivLH8IfdhiOCsogM=;
        b=FrolJqVEVMrZRz7J01cARZ9O8mwNSscxHbYURMS790Uvj44kp96Ct3HFiekVoTzC6v
         T3Cof35VL0d2ENk0VxZz7tBNs+4qHIRp4uJjqusK3E+/I7BlNl5itItoNdeJjJ/XbrMd
         uCSKV1pkErDsIkofZ7l2QfmzYrJb4cvETm28/nHVWdmySAAaN9VJsBB66s4lIG7HELLW
         xT76tjIcTRX565vVTELo+7B7d9RmyZmvhDkm7SwYcn/kWoTvebi+xViOWG9ahgM7+uCC
         Nml0a7l6dozgvH4Q1F58ZR8OPc+eG+TUsznup3G784wNqbcr8OamZn9zz3A8oec5LjCz
         l5Fg==
X-Gm-Message-State: AOAM531eHaQnK3k7n4W8APZlsprCk9AuwXXrsgLfBj7FJPzArM+83KUW
        J9zQxNev5F1MrMwmGJBFNp2jKP2hFgVY3Vj7fno=
X-Google-Smtp-Source: ABdhPJwGCWSqr72vtkOcdHHET1JYxUVZuTF5+4c4wezgLCjSNl5R8ZMsj4ToR7YFAlR7WWQVDxocFP+NmanzaTUYZWw=
X-Received: by 2002:a05:6902:1144:: with SMTP id p4mr42032155ybu.510.1619635469286;
 Wed, 28 Apr 2021 11:44:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
 <20210423002646.35043-11-alexei.starovoitov@gmail.com> <CAEf4BzYkzzN=ZD2X1bOg8U39Whbe6oTPuUEMOpACw6NPEW69NA@mail.gmail.com>
 <20210427033707.fu7hsm6xi5ayx6he@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzaPDF8h9t1xqMo-hKqp=J_bE1OtWXh+jugZxV597qjdaw@mail.gmail.com> <20210428015554.j7cffimb6lnv3ir7@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210428015554.j7cffimb6lnv3ir7@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 28 Apr 2021 11:44:18 -0700
Message-ID: <CAEf4BzacafBu9Hzu-GVi2Q5TEbPfkgmtYn0KHKMtSafqBBLqGg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 10/16] bpf: Add bpf_btf_find_by_name_kind() helper.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 6:55 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Apr 27, 2021 at 10:45:38AM -0700, Andrii Nakryiko wrote:
> > > >
> > > > > + *             If btf_fd is zero look for the name in vmlinux BTF and in module's BTFs.
> > > > > + *     Return
> > > > > + *             Returns btf_id and btf_obj_fd in lower and upper 32 bits.
> > > >
> > > > Mention that for vmlinux BTF btf_obj_fd will be zero? Also who "owns"
> > > > the FD? If the BPF program doesn't close it, when are they going to be
> > > > cleaned up?
> > >
> > > just like bpf_sys_bpf. Who owns returned FD? The program that called
> > > the helper, of course.
> >
> > "program" as in the user-space process that did bpf_prog_test_run(),
> > right? In the cover letter you mentioned that BPF_PROG_TYPE_SYSCALL
> > might be called on syscall entry in the future, for that case there is
> > no clear "owning" process, so would be curious to see how that problem
> > gets solved.
>
> well, there is always an owner process. When syscall progs is attached
> to syscall such FDs will be in the process that doing syscall.
> It's kinda 'random', but that's the job of the prog to make 'non random'.
> If it's doing syscalls that will install FDs it should have a reason
> to do so. Likely there will be limitations on what bpf helpers such syscall
> prog can do if it's attached to this or that syscall.
> Currently it's test_run only.
>
> I'm not sure whether you're hinting that it all should be FD-less or I'm
> putting a question in your mouth, but I've considered doing that and
> figured that it's an overkill. It's possible to convert .*bpf.* do deal
> with FDs and with some other temporary handle. Instead of map_fd the
> loader prog would create a map and get a handle back that it will use
> later in prog_load, etc.
> But amount of refactoring looks excessive.
> The generated loader prog should be correct by construction and
> clean up after itself instead of burdening the kernel cleaning
> those extra handles.

That's not really the suggestion or question I had in mind. I was
contemplating how the FD handling will happen if such BPF program is
running from some other process's context and it seemed (and still
seems) very surprising if new FD will just be added to a "random"
process. Ignoring all the technical difficulties, I'd say ideally
those FDs should be owned by BPF program itself, and when it gets
unloaded, just like at the process exit, all still open FDs should be
closed. How technically feasible that is is entirely different
question.

But basically, I wanted to confirm I understand where those new FDs
are attached to.
