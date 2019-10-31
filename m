Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB7DCEB878
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 21:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729768AbfJaUj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 16:39:27 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44986 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727477AbfJaUj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 16:39:27 -0400
Received: by mail-lj1-f194.google.com with SMTP id g3so1952296ljl.11;
        Thu, 31 Oct 2019 13:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FC/oQ8+7Q+YoCj6capL5FnDUkmWCjdIppXqxhU/gz4w=;
        b=GyTjR8lbJWtROpfgXjW2aoT12j8XIUUFWkMkroQeN2iYdl60KmxalHo7CrS55g8n/o
         dSFczYuOAyz4KFP3brocXM6pwuvt9FQfA95/VKdX9NALpJrGUUTmN6QxDhZ/2GvD/w/6
         EiYXs7ymBW5w81mc0w6Npl1kvIVvio1UK0AWsM0jabub78A9KcrUyovg01SSJ/YxNpK9
         6SrxnaSGD99Or4XuOWGEloCs/gudzbVd1EY//8gQvQqmA1cW4Vl7qiOGHFCwGu8lBvLK
         7gorVO/FHBCx4oAzlIh1cPzTYIBJbM0qtzqRchjQ4G52x2kqonFSVfhZR9aEyMbxM490
         6gxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FC/oQ8+7Q+YoCj6capL5FnDUkmWCjdIppXqxhU/gz4w=;
        b=PE/eIO/OkzTrWcOjUP0hN9Jqrvyi6QUQYd6731p01Zx7jqPp2SIelZh4iDk5eqtcbE
         w7ctaFwrkXzMtHnnN115q+R72d9I+WnV+gWLs/R7bK+1F5qcJ96uHQoO7MnqYKJMhtFT
         bi65Xan8d1eOfH/SKnZkE77UcRAbwYL6+8mjPxUTQWy6pXNWKIhZtXm4XEiljhswEUDl
         CG+a7yBTbHh5cbStW77klA1dqq96ED8SonJokoIFlXqctAY1JDYW7Ivp1JdYm6CRLqLB
         F6gQ1oJEIF02FhTUNXsVlHQMfVs2Yy48fd49gfiQE2Bx+0h7cn23OuBdNlXg2gCt/6x/
         mekQ==
X-Gm-Message-State: APjAAAX62lAVdbEExx5V3o4SBD+yVpULG4kKIyR4fDR35mm0c3PU1wEz
        Tp6d0d38QyDHtEJYjgE/X/x77GkQvp9R39IYFxk=
X-Google-Smtp-Source: APXvYqyDOxEhlm4EzHtn7io1ccsmsFqZe1IDyF49XKogIxqPbwdtgRthABt5t2eiIzSrdLu5C3khYoiQ9MMkw2sASE4=
X-Received: by 2002:a2e:2e10:: with SMTP id u16mr1765161lju.51.1572554364478;
 Thu, 31 Oct 2019 13:39:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ+HfNimRqftmKASOdceXFJmgbLvXnNBZATTnfA9LMF2amGzzA@mail.gmail.com>
 <CAADnVQJRe4Pm-Rxx9zobn8YRHh9i+xQp7HX4gidqq9Mse7PJ5g@mail.gmail.com>
 <87lft1ngtn.fsf@toke.dk> <CAADnVQLrg6f_zjvNfiEVfdjcx9+DW_RFjVGetavvMNo=VXAR+g@mail.gmail.com>
 <87imo5ng7w.fsf@toke.dk> <CAADnVQLJ2JTsbxd2am6XY0EiocMgM29JqFVRnZ9PBcwqd7-dAQ@mail.gmail.com>
 <87d0ednf0t.fsf@toke.dk> <CAADnVQ+V4OMjJqSdE_OQ1Vr99kqTF=ZB3UUMKiCSg=3=c+exqg@mail.gmail.com>
 <20191031174208.GC2794@krava> <CAADnVQJ=cEeFdYFGnfu6hLyTABWf2==e_1LEhBup5Phe6Jg5hw@mail.gmail.com>
 <20191031191815.GD2794@krava>
In-Reply-To: <20191031191815.GD2794@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 31 Oct 2019 13:39:12 -0700
Message-ID: <CAADnVQJdAZS9AHx_B3SZTcWRdigZZsK1ccsYZK0qUsd1yZQqbw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] libbpf: fix compatibility for kernels without need_wakeup
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, degeneloy@gmail.com,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 12:18 PM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > yes. older vmlinux and newer installed libbpf.so
> > or any version of libbpf.a that is statically linked into apps
> > is something that libbpf code has to support.
> > The server can be rebooted into older than libbpf kernel and
> > into newer than libbpf kernel. libbpf has to recognize all these
> > combinations and work appropriately.
> > That's what backward and forward compatibility is.
> > That's what makes libbpf so difficult to test, develop and code review.
> > What that particular server has in /usr/include is irrelevant.
>
> sure, anyway we can't compile following:
>
>         tredaell@aldebaran ~ $ echo "#include <bpf/xsk.h>" | gcc -x c -
>         In file included from <stdin>:1:
>         /usr/include/bpf/xsk.h: In function =E2=80=98xsk_ring_prod__needs=
_wakeup=E2=80=99:
>         /usr/include/bpf/xsk.h:82:21: error: =E2=80=98XDP_RING_NEED_WAKEU=
P=E2=80=99 undeclared (first use in this function)
>            82 |  return *r->flags & XDP_RING_NEED_WAKEUP;
>         ...
>
>         XDP_RING_NEED_WAKEUP is defined in kernel v5.4-rc1 (77cd0d7b3f257=
fd0e3096b4fdcff1a7d38e99e10).
>         XSK_UNALIGNED_BUF_ADDR_MASK and XSK_UNALIGNED_BUF_OFFSET_SHIFT ar=
e defined in kernel v5.4-rc1 (c05cd3645814724bdeb32a2b4d953b12bdea5f8c).
>
> with:
>   kernel-headers-5.3.6-300.fc31.x86_64
>   libbpf-0.0.5-1.fc31.x86_64
>
> if you're saying this is not supported, I guess we could be postponing
> libbpf rpm releases until we have the related fedora kernel released

why? github/libbpf is the source of truth for building packages
and afaik it builds fine.

> or how about inluding uapi headers in libbpf-devel.. but that might
> actualy cause more confusion

Libraries (libbpf or any other) should not install headers that
typically go into /usr/include/
if_xdp.h case is not unique.
We'll surely add another #define, enum, etc to uapi/linux/bpf.h tomorrow.
And we will not copy paste these constants and types into tools/lib/bpf/.
In kernel tree libbpf development is using kernel tree headers.
No problem there for libbpf developers.
Packages are built out of github/libbpf that has a copy of uapi headers
necessary to create packages.
No problem there for package builders either.
But libbpf package is not going to install those uapi headers.
libbpf package installs only libbpf own headers (like libbpf.h)
The users that want to build against the latest libbpf package need
to install corresponding uapi headers package.
I don't think such dependency is specified in rpm scripts.
May be it is something to fix? Or may be not.
Some folks might not want to update all of /usr/include to bring libbpf-dev=
el.
Then it would be their responsibility to get fresh /usr/include headers.
