Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A227F2CC9CD
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387632AbgLBWo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728965AbgLBWo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:44:27 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC57C061A04;
        Wed,  2 Dec 2020 14:43:40 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id l14so220014ybq.3;
        Wed, 02 Dec 2020 14:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jo7AwbbsKyjCl+f8N9cedM1gHIy9+JL60ER0OVHkV7w=;
        b=d/zL1nK6wHh2iEdb4YZOrjh7UJx0Pz7CyW8wcSWq6Oml0mn4C5s1x8r3gPA2a+nzRH
         G969hYZtONyv0/Ns7mRr0AqIUCu7jfApYZorApPif4keNDSpBtJW6CNlhfom4ucfCABD
         8BishkNL74LPbbTYfbhygteeurTbfz5C7bwEhRPyam4OpRensyBZoozQHIiMGaSL8JKj
         CP9wAHkdkeG51qmwzpr7czGU8q4nuvQIWDkYQZsLPJ/svw0q6ItAsVkSb0zdEShT3fyN
         M/hOryfsHeEeOldQnGMPNPDV7aSUUf+IEn2aYV04v0+oAAvriuOoq0csb0KVky2JXkBm
         TyNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jo7AwbbsKyjCl+f8N9cedM1gHIy9+JL60ER0OVHkV7w=;
        b=MtUWn1yrndOr3MxJxcCQvAu9uE06i+8ejK/rN6L+RvC52bHAIaBaX9zU93Tm3kfH/P
         WRgg4g38/3uOX0FasdkiOED0fJqHbaznaYhWGoGDxzJNN3+I0HUJi2OrDY01ABjDIVbG
         5QjIyyT2tTvZAXyW98BvdGdju+SByxPg8PRdQwfAGDik8Psitw8RQTedKnuZVzbQA4mJ
         Cs5yGjG/sAvkaZfgIvCksEfeqOIdeR+C3sIChi3a7d49sEEfFnlRdni4AM6w0soEiAt7
         3sGO4myEpAg7Rrw9PR3jq6ob8pAftEix43djfu7v8jx8xnL5bI9wDCvqrLqTHn2dq8o+
         nu6Q==
X-Gm-Message-State: AOAM5314xCWItTwe3O8YzgF6p+WOVViXc7BM5QZqI/nFo2ahsG2vtmHU
        ezYBRcosbLFKR50ljTcd35tD+RKgrCDV7omOxWQ=
X-Google-Smtp-Source: ABdhPJzDIz3LYg2RKM5/Oa1JLr66IeH1OPC7PVLai7cefC7V4bi2S2CDjkHdE40HOL7UhO0linAOKWUyOKygEYPHYwM=
X-Received: by 2002:a25:2845:: with SMTP id o66mr596610ybo.260.1606949020287;
 Wed, 02 Dec 2020 14:43:40 -0800 (PST)
MIME-Version: 1.0
References: <20201202001616.3378929-1-andrii@kernel.org> <20201202001616.3378929-11-andrii@kernel.org>
 <20201202205809.qwbismdmmtrcsar7@ast-mbp>
In-Reply-To: <20201202205809.qwbismdmmtrcsar7@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Dec 2020 14:43:29 -0800
Message-ID: <CAEf4BzbeUu78v63UmDCzQ5jDhBqzaX-85GHdqc1aMuiy7ZMn3w@mail.gmail.com>
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

On Wed, Dec 2, 2020 at 12:58 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Dec 01, 2020 at 04:16:12PM -0800, Andrii Nakryiko wrote:
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index c3458ec1f30a..60b95b51ccb8 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -558,6 +558,7 @@ union bpf_attr {
> >               __u32           line_info_cnt;  /* number of bpf_line_info records */
> >               __u32           attach_btf_id;  /* in-kernel BTF type id to attach to */
> >               __u32           attach_prog_fd; /* 0 to attach to vmlinux */
> > +             __u32           attach_btf_obj_id; /* vmlinux/module BTF object ID for BTF type */
>
> I think the uapi should use attach_btf_obj_fd here.
> Everywhere else uapi is using FDs to point to maps, progs, BTFs of progs.
> BTF of a module isn't different from BTF of a program.
> Looking at libbpf implementation... it has the FD of a module anyway,
> since it needs to fetch it to search for the function btf_id in there.
> So there won't be any inconvenience for libbpf to pass FD in here.
> From the uapi perspective attach_btf_obj_fd will remove potential
> race condition. It's very unlikely race, of course.

Yes, I actually contemplated that, but my preference went the ID way,
because it made libbpf implementation simpler and there was a nice
duality of using ID for types and BTF instances themselves.

The problem with FD is that when I load all module BTF objects, I open
their FD one at a time, and close it as soon as I read BTF raw data
back. If I don't do that on systems with many modules, I'll be keeping
potentially hundreds of FDs open, so I figured I don't want to do
that.

But I do see the FD instead of ID consistency as well, so I can go
with a simple and inefficient implementation of separate FD for each
BTF object for now, and if someone complains, we can teach libbpf to
lazily open FDs of module BTFs that are actually used (later, it will
complicate code unnecessarily). Not really worried about racing with
kernel modules being unloaded.

Also, if we use FD, we might not need a new attach_bpf_obj_id field at
all, we can re-use attach_prog_fd field (put it in union and have
attach_prog_fd/attach_btf_fd). On the kernel side, it would be easy to
check whether provided FD is for bpf_prog or btf. What do you think?
Too mysterious? Or good?

>
> The rest of the series look good to me.

Cool, thanks.
