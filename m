Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D138229F636
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 21:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgJ2Ual (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 16:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgJ2Uak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 16:30:40 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14781C0613CF;
        Thu, 29 Oct 2020 13:30:40 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id h196so3270397ybg.4;
        Thu, 29 Oct 2020 13:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OupQpSO/sS5FTJxTabAsu1fVC7KBudZXyt8yG3aNEF0=;
        b=VgrwgJe63b2c4rwQDhYFLKEb/PtrF/DA5NYzERrW/+os5xcYFYPQa+cB8Zj9TbWSEh
         sQoypf6yTwEMMBXFLdGid8UVCelW4cs+Tyoa8/6CxGqd5HfkuuWxfSfbBKQDtwwGWMni
         TFds2znryMtLBAcj8Efh3vVlH5ih6CPTotLXaFYgxJKk3akpbigWGBp5OD3e5pgqEaZu
         oUVVBp6cOw8zq9nwIUoq+seO71nuWmegfPYhDFjHZtH+Phtp2D+0qMTp43TRWIn0xRsa
         /3N/4wE08+BKM/xe3m5qQj5J8Zr93HuNseH7ywaRYG7er0kb7A9UY2duGJqyzXUSVP+x
         70Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OupQpSO/sS5FTJxTabAsu1fVC7KBudZXyt8yG3aNEF0=;
        b=hczqRQmlmGq2T822iG4a08/XANmoE3PFr5mMvJijHfxTy0Fjl3Ny8m11GbodD7uKf2
         dsC9A3yr9Sk24LXUE6qqz6DXaZyD+JeRel3ZNTa4qAN0Wsv6nB0/v0CwI0p2LGIBCZ3T
         eVFCXq+MDNsVULwOvufmcZpof0HBoDxRUFS/f3d/Udsu4ypq9OmQflDZgM6c5BSZNJO1
         dZgK0Z2s5PFHHgxZjhzVXPvOQaCb2aUQa9LvYAOrqqkK0xjyj4VZSDKOy15LrsGMM0aQ
         hZvmFgukHyKMF1gZhJFrTqVwQxaBSZBx384rJlpFtzv4a8PDZTobnUq3oN63K4baI/9S
         /HhA==
X-Gm-Message-State: AOAM530alvfKYz/rK3oeksFNRRndnijbcN4YavRfMqp1L7Dchz41GK+c
        WA1ZaZg8/WgArcuQktoWccyTP5boVjUj6FRcFaE=
X-Google-Smtp-Source: ABdhPJyBBJwPL/hSuW1Uu/ym4PaSMKs/a+hHsrYOM+JGpFnDdFBhBfLGjtJLygJV4bZ+a8ZZLPC3nUkwqdgZoG/6ZxY=
X-Received: by 2002:a25:b0d:: with SMTP id 13mr8630671ybl.347.1604003439145;
 Thu, 29 Oct 2020 13:30:39 -0700 (PDT)
MIME-Version: 1.0
References: <20201023033855.3894509-1-haliu@redhat.com> <20201028132529.3763875-1-haliu@redhat.com>
 <7babcccb-2b31-f9bf-16ea-6312e449b928@gmail.com> <20201029020637.GM2408@dhcp-12-153.nay.redhat.com>
 <CAEf4BzZR4MqQJCD4kzFsbhpfmp4RB7SHcP5AbAiqzqK7to2u+g@mail.gmail.com>
 <20201028193438.21f1c9b0@hermes.local> <CAEf4BzY1gz2fR0DXOYgbheDArdYhWA66YRFuy=xMRveHTx=VVQ@mail.gmail.com>
 <20201029123801.4d03ebb5@carbon>
In-Reply-To: <20201029123801.4d03ebb5@carbon>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 29 Oct 2020 13:30:28 -0700
Message-ID: <CAEf4BzYZZa7FkQ5F=aKyjyrX2ekU6D67SN_pkCLZ=5tchmWurw@mail.gmail.com>
Subject: Re: [PATCHv2 iproute2-next 0/5] iproute2: add libbpf support
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <haliu@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 4:38 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Wed, 28 Oct 2020 19:50:51 -0700
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > On Wed, Oct 28, 2020 at 7:34 PM Stephen Hemminger
> > <stephen@networkplumber.org> wrote:
> > >
> > > On Wed, 28 Oct 2020 19:27:20 -0700
> > > Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > >
> > > > On Wed, Oct 28, 2020 at 7:06 PM Hangbin Liu <haliu@redhat.com> wrote:
> > > > >
> > > > > On Wed, Oct 28, 2020 at 05:02:34PM -0600, David Ahern wrote:
> > > > > > fails to compile on Ubuntu 20.10:
> > > > > >
> [...]
> > > > > You need to update libbpf to latest version.
> > > >
> > > > Why not using libbpf from submodule?
> > >
> > > Because it makes it harder for people downloading tarballs and distributions.
> >
> > Genuinely curious, making harder how exactly? When packaging sources
> > as a tarball you'd check out submodules before packaging, right?
> >
> > > Iproute2 has worked well by being standalone.
> >
> > Again, maybe I'm missing something, but what makes it not a
> > standalone, if it is using a submodule? Pahole, for instance, is using
> > libbpf through submodule and just bypasses all the problems with
> > detection of features and library availability. I haven't heard anyone
> > complaining about it made working with pahole harder in any way.
>
> I do believe you are missing something.

I don't think I got an answer how submodules make it harder for people
downloading tarballs and distributions, and the standalone-ness issue.
Your security angle is a very different aspect.

>  I guess I can be the relay for
> complains, so you will officially hear about this.  Red Hat and Fedora
> security is complaining that we are packaging a library (libbpf)
> directly into the individual packages.  They complain because in case
> of a security issue, they have to figure out to rebuild all the software
> packages that are statically compiled with this library.

They must be having nightmares already about BCC, bpftool, pahole, as
well as perf built with libbpf statically (perf on my server is, at
least). I also wonder how many other projects do use either submodules
or static linking with libraries as well.

>
> Maybe you say I don't care that Distro security teams have to do more
> work and update more packages.  Then security team says, we expect
> customers will use this library right, and if we ship it as a dynamic
> loadable (.so) file, then we can update and fix security issues in
> library without asking customers to recompile. (Notice the same story
> goes if we can update the base-image used by a container).

It's a trade off, and everyone decides for themselves where they want
to stand on this.

On the one hand, there are security folks obsessing about hypothetical
security vulnerabilities in libbpf so bad that they will need to
update libbpf overnight.

On the other hand, extra complexity for multiple users of libbpf to do
feature detection and working around the lack of some of the APIs in
libbpf due to older versions in the system. That extra complexity
might lead to more problems, bugs, vulnerabilities in the long run.

I understand the concerns and how dynamic libraries make it easier. We
can't really know for sure which of those two aspects would lead to
more pain and problems overall. I personally choose simplicity,
though.

But as I said, it's up to iproute2 folks to decide. Was just curious
about some of the claims I cited.


>
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
