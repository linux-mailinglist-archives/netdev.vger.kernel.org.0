Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CB92CCA5B
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 00:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgLBXNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 18:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbgLBXNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 18:13:18 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0E5C0613D6;
        Wed,  2 Dec 2020 15:12:38 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id y16so389776ljk.1;
        Wed, 02 Dec 2020 15:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FHpERSumSrVk6EjMdTwvcnNqOmkyfUHJnVjfFgiAABU=;
        b=Di0xQeIPjp5/4/xaFKIKaNE0+N8If9vEHaNLGWASxd59rOImNsPK9exccSwxxqSvcz
         rf5hFTWntUyIG7yo9BP4NvndA/323ccho6Xz1DmeP9/CQB6aBIdjnKqVMyocr6wOQ6HQ
         /O+jjkeof/e+fFr2yqAb/Rb61fET6oDgDyzO8WbahETBp7Ko+z78GmTcYQFnJf0+4MNi
         tkmkN+DzLA1fA0BSVm4wKzZ/CPcM54bCX2crfBMh4qSun2ybQp4mx7ZF1MA+YtQERBc5
         D3I/UhkBoxXYtbFOHhnOEojnjC8yFVydjC6gRTO7ervAc2fwPF77vO460Dnh1EZwVkzJ
         jryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FHpERSumSrVk6EjMdTwvcnNqOmkyfUHJnVjfFgiAABU=;
        b=gVMXrZpmdIZpHT9rA/v8pojIrL8ITRzj7NqxVOTtxgrs59W1Dufw4LKaAsU3fRtxVo
         QNpvLkOikh26ulDtd8fdoYgZKaFkSfklOSi4ytwxfBFlZIXSlSTOr17ojHrjTxMv1aK8
         4qJm5LXp/gUpVn3UC0+VrRmgp5wxWWQcrgdgCaxNjtZoVYuTcdPj9C7lxaKEyUh8jU63
         HV3srY8pMNPfYlHPQ6ErNHJq3pMLSwskilkt9y8t2vV6YKzfZEjYVhaDRW8j61pyj2aK
         1TYToDGYR+VZRO3qVvWxkW6RkWMIDHXly6BIdqS+1KSFb+tNvZkE+54oVUZfZvS0QgNy
         ac5Q==
X-Gm-Message-State: AOAM532dDnXMQo2x8BpVmFsdk/yi5Q8/e65HQn5i5k9+56zwbJrHYDCj
        0Be5HDe0x1PfV57EwR+rAAL8pEHrkdet3UrhHtSmcgYaxzs=
X-Google-Smtp-Source: ABdhPJwOpdERgHwGb4rvrJrci1WzW4885EUbqlW2MDUuSQtisjBxJKC0r3wNG9d/yOyDfcRzhbayLCQ7Uh5+XeS9Znk=
X-Received: by 2002:a2e:b1c9:: with SMTP id e9mr71281lja.283.1606950756815;
 Wed, 02 Dec 2020 15:12:36 -0800 (PST)
MIME-Version: 1.0
References: <20201202001616.3378929-1-andrii@kernel.org> <20201202001616.3378929-11-andrii@kernel.org>
 <20201202205809.qwbismdmmtrcsar7@ast-mbp> <CAEf4BzbeUu78v63UmDCzQ5jDhBqzaX-85GHdqc1aMuiy7ZMn3w@mail.gmail.com>
In-Reply-To: <CAEf4BzbeUu78v63UmDCzQ5jDhBqzaX-85GHdqc1aMuiy7ZMn3w@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 2 Dec 2020 15:12:25 -0800
Message-ID: <CAADnVQ+6QAGSgaXZu7g75suOcG+KEanoJNb6DP-jFKoHZKKxiA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 10/14] bpf: allow to specify kernel module
 BTFs when attaching BPF programs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 2, 2020 at 2:43 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Dec 2, 2020 at 12:58 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Dec 01, 2020 at 04:16:12PM -0800, Andrii Nakryiko wrote:
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index c3458ec1f30a..60b95b51ccb8 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -558,6 +558,7 @@ union bpf_attr {
> > >               __u32           line_info_cnt;  /* number of bpf_line_info records */
> > >               __u32           attach_btf_id;  /* in-kernel BTF type id to attach to */
> > >               __u32           attach_prog_fd; /* 0 to attach to vmlinux */
> > > +             __u32           attach_btf_obj_id; /* vmlinux/module BTF object ID for BTF type */
> >
> > I think the uapi should use attach_btf_obj_fd here.
> > Everywhere else uapi is using FDs to point to maps, progs, BTFs of progs.
> > BTF of a module isn't different from BTF of a program.
> > Looking at libbpf implementation... it has the FD of a module anyway,
> > since it needs to fetch it to search for the function btf_id in there.
> > So there won't be any inconvenience for libbpf to pass FD in here.
> > From the uapi perspective attach_btf_obj_fd will remove potential
> > race condition. It's very unlikely race, of course.
>
> Yes, I actually contemplated that, but my preference went the ID way,
> because it made libbpf implementation simpler and there was a nice
> duality of using ID for types and BTF instances themselves.
>
> The problem with FD is that when I load all module BTF objects, I open
> their FD one at a time, and close it as soon as I read BTF raw data
> back. If I don't do that on systems with many modules, I'll be keeping
> potentially hundreds of FDs open, so I figured I don't want to do
> that.
>
> But I do see the FD instead of ID consistency as well, so I can go
> with a simple and inefficient implementation of separate FD for each
> BTF object for now, and if someone complains, we can teach libbpf to
> lazily open FDs of module BTFs that are actually used (later, it will
> complicate code unnecessarily). Not really worried about racing with
> kernel modules being unloaded.
>
> Also, if we use FD, we might not need a new attach_bpf_obj_id field at
> all, we can re-use attach_prog_fd field (put it in union and have
> attach_prog_fd/attach_btf_fd). On the kernel side, it would be easy to
> check whether provided FD is for bpf_prog or btf. What do you think?
> Too mysterious? Or good?

You mean like:
union {
         __u32           attach_prog_fd; /* valid prog_fd to attach to
bpf prog */
         __u32           attach_btf_obj_fd; /* or  valid module BTF
object fd or zero to attach to vmlinux */
};
or don't introduce a new field name at all?
Sure. I'm fine with both. I think it's a good idea.
