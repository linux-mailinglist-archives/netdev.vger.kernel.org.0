Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C5F1A6D95
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 22:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388606AbgDMUtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 16:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388526AbgDMUtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 16:49:02 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F46C0A3BDC;
        Mon, 13 Apr 2020 13:49:01 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id q17so8064624qtp.4;
        Mon, 13 Apr 2020 13:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kYsEClXkNUBty/oUDBtBz8T0Rc5qWhNZOSjMLm6lmes=;
        b=pc6R6Ir2P9GTMXIYf++wsqIeoLLHYVWTIdem+bwmjz22MxECkwnDpAW3yFKSJiQWwq
         ilJL2TkD3tAUlZ4wf5BeUGKQaxRQIY1Ey8oTUran2RM8JlJTJZD/Z2swbCa4lPyBoFGc
         qugt6LXzeFxFPYHIRoqTkb27QS40iq8/SiALUBpZ4Rzi4LnUE4r7QbhapwpVvg8gW/Dn
         Q38mPqNyvrYfkChwEFd87MftyP4h7lZ94/jZ7IYxipOAtqwlkWoHonF6n1R16TzjsIW3
         4Y3XxvtmPbkCDcNXVZHeJ8S8QTdeZwLtKEg7q1WIzhBCuQKBfHx+2r1xBzuqOp04P+e3
         SAvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kYsEClXkNUBty/oUDBtBz8T0Rc5qWhNZOSjMLm6lmes=;
        b=WS/u/PJWeH5nFo9iPZ+QGzcrODqUeynh+badZ5v8f7tMOakto4vdfGRmz2GQVDbmMA
         AWqFrZ2rjeGQg0m2avhUmheH/lVuUIPJUDHJwZ6oU0cLGsgxOa1bZZX16AcBbtTneod4
         /gQkzcgXmdlV+GvbTiNS/c1gR9LQIOHlpAMXp6E6vX3hwsJJnihwwdnt6NgPYIm44+xx
         6RsLGZNMv1W6HmwPgJBWgx9H93RvzlAJLKeVfVZTUTS/bl6gW+S3bNOOeNLGIXJ/TodU
         t7ZhMVlO7JAGeLNDAMggf+jirsdiJ3DnVxfBO0DnFciOJ0t7YJpIuhOj8xE8HD7dGhcG
         ZVlQ==
X-Gm-Message-State: AGi0PuYXD8k2dqPTWu2GD3A3aDd15glbmfbC8ukCZfdtoNytESFQwR69
        VE02ANs75SeWe0uGYTrcxxIf/ZmOCJokMS98Muk=
X-Google-Smtp-Source: APiQypLgq3ATiGRcdBK9wbDX225qpc5kQW3HOUMH7LK7/Fc1wRNTfF6tCsWtsOuxvNiBM7v21oU9scJMW5sEL6mpnKA=
X-Received: by 2002:aed:2e24:: with SMTP id j33mr13033130qtd.117.1586810940852;
 Mon, 13 Apr 2020 13:49:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232526.2675664-1-yhs@fb.com>
 <20200410030017.errh35srmbmd7uk5@ast-mbp.dhcp.thefacebook.com>
 <c34e8f08-c727-1006-e389-633f762106ab@fb.com> <CAEf4BzYM3fPUGVmRJOArbxgDg-xMpLxyKPxyiH5RQUbKVMPFvA@mail.gmail.com>
 <2d941e43-72de-b641-22b8-b9ec970ccf52@fb.com> <20200411231125.haqk5by4p34wudn7@ast-mbp>
In-Reply-To: <20200411231125.haqk5by4p34wudn7@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Apr 2020 13:48:49 -0700
Message-ID: <CAEf4BzaqUsefJMehPdU1GmM2=S2NZfM9_=hG=RexFqah2n_WiA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 11, 2020 at 4:11 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Apr 10, 2020 at 04:47:36PM -0700, Yonghong Song wrote:
> > >
> > > Instead of special-casing dumper_name, can we require specifying full
> > > path, and then check whether it is in BPF FS vs BPFDUMP FS? If the
> > > latter, additionally check that it is in the right sub-directory
> > > matching its intended target type.
> >
> > We could. I just think specifying full path for bpfdump is not necessary
> > since it is a single user mount...
> >
> > >
> > > But honestly, just doing everything within BPF FS starts to seem
> > > cleaner at this point...
> >
> > bpffs is multi mount, which is not a perfect fit for bpfdump,
> > considering mounting inside namespace, etc, all dumpers are gone.
>
> As Yonghong pointed out reusing bpffs for dumpers doesn't look possible
> from implementation perspective.
> Even if it was possible the files in such mix-and-match file system
> would be of different kinds with different semantics. I think that
> will lead to mediocre user experience when file 'foo' is cat-able
> with nice human output, but file 'bar' isn't cat-able at all because
> it's just a pinned map. imo having all dumpers in one fixed location
> in /sys/kernel/bpfdump makes it easy to discover for folks who might
> not even know what bpf is.

I agree about importance of discoverability, but bpffs will typically
be mounted as /sys/fs/bpf/ as well, so it's just as discoverable at
/sys/fs/bpf/bpfdump. But I'm not too fixated on unifying bpffs and
bpfdumpfs, it's just that bpfdumpfs feels a bit too single-purpose.

> For example when I'm trying to learn some new area of the kernel I might go
> poke around /proc and /sys directory looking for a file name that could be
> interesting to 'cat'. This is how I discovered /sys/kernel/slab/ :)
> I think keeping all dumpers in /sys/kernel/bpfdump/ will make them
> similarly discoverable.
>
> re: f_dump flag...
> May be it's a sign that pinning is not the right name for such operation?
> If kernel cannot distinguish pinning dumper prog into bpffs as a vanilla
> pinning operation vs pinning into bpfdumpfs to make it cat-able then something
> isn't right about api. Either it needs to be a new bpf syscall command (like
> install_dumper_in_dumpfs) or reuse pinning command, but make libbpf specify the
> full path. From bpf prog point of view it may still specify only the final
> name, but libbpf can prepend the /sys/kernel/bpfdump/.../. May be there is a
> third option. Extra flag for pinning just doesn't look right. What if we do
> another specialized file system later? It would need yet another flag to pin
> there?

I agree about specifying full path from libbpf side. But section
definition shouldn't include /sys/fs/bpfdump part, so program would be
defined as:

SEC("dump/task/file")
int prog(...) { }

And libbpf by default will concat that with /sys/fs/bpfdump, but
probably should also provide a way to override prefix with custom
value, provided by users.
