Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAB5EC514
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 15:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbfKAOwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 10:52:04 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:47086 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727313AbfKAOwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 10:52:04 -0400
Received: by mail-io1-f66.google.com with SMTP id c6so11133117ioo.13;
        Fri, 01 Nov 2019 07:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=UhjQGqJBUwWxhPrUXNTvf2v3g/fE4UlgFpuSM1dMpPg=;
        b=MYL7s4l9S/pFcKmrbKFH6KCGTlJruf307g9JET4uDu8iG+6VjjwC4P9AD/lpcoz+vM
         Q3vBVd614+9ESFoAEQiqnIgx4lFNLgdSKP4xhaByjsFGW/r87bNrStNg51bvetib8Us6
         4xcC2PNx87SK1WT8/9C0EYMQ9IlQQcavqSK6CM34X7ZzJJubLqUOEE1/sYeP78vmyQNL
         nQ80Eu6oIukDdVA5zU3lBvi+oq3p9G9ZiTaUN3oP2dT/a14t5S87upcebl14X6w39sMa
         VuGn3R3DS7qu7aqJkbz6HcciKCXZ6uAge39qOmcdARoq4d6AX/a7asbNlWyW3BfOq6Uk
         Kamg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=UhjQGqJBUwWxhPrUXNTvf2v3g/fE4UlgFpuSM1dMpPg=;
        b=EAzFfwez850GTeXVLi6CFPFW0BkVHypiJnessRpF9Gnh1gCIFN4sVw10gkkPwUdEGA
         hUcIqyvTAM1I2fx/5sXqxUUvw9oI/KhEqVf6By9vsPJr8e6K5ApqqlkT2MOXu5afGq52
         Lpoz+XQYp1GTm3FZiuz7QaLEHM+9scXuaRkpNhCNUeaWLwQOxMcDm8FWMxxiXFYxaGo1
         rNWNjdWL3VsVuBSxF7vc7041LuB9AIN+SgTOwmcHK9qfs63g4mR+EnHQ4YJruUEOwJP6
         cuv+Q59NzgUzcEOpkGKLj/JX30oxdWVcR1Eb7ow5rkNhPEkEf9EWlQ6a8L+R5nc2kZXK
         zmdQ==
X-Gm-Message-State: APjAAAUc0rYtonmsKyCayOY1bcOyw1eFZee4MLVE6GjpWDU1qKdOSQzF
        aYJzxuWPnsS1YhSi2qgJMfBJvHxYGM4=
X-Google-Smtp-Source: APXvYqzn1q5mBnTje1ZFAmqsT9s9Ay9ZoxZUN1yXijlT6xreLf9ETZyojCsuInUlHPZAzuPJccxubQ==
X-Received: by 2002:a6b:3b57:: with SMTP id i84mr4683693ioa.85.1572619922865;
        Fri, 01 Nov 2019 07:52:02 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v28sm1108280ill.74.2019.11.01.07.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 07:52:02 -0700 (PDT)
Date:   Fri, 01 Nov 2019 07:51:54 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, degeneloy@gmail.com,
        John Fastabend <john.fastabend@gmail.com>
Message-ID: <5dbc468adbc4c_e4e2b12b10265b88@john-XPS-13-9370.notmuch>
In-Reply-To: <87tv7olzwd.fsf@toke.dk>
References: <CAJ+HfNimRqftmKASOdceXFJmgbLvXnNBZATTnfA9LMF2amGzzA@mail.gmail.com>
 <CAADnVQJRe4Pm-Rxx9zobn8YRHh9i+xQp7HX4gidqq9Mse7PJ5g@mail.gmail.com>
 <87lft1ngtn.fsf@toke.dk>
 <CAADnVQLrg6f_zjvNfiEVfdjcx9+DW_RFjVGetavvMNo=VXAR+g@mail.gmail.com>
 <87imo5ng7w.fsf@toke.dk>
 <CAADnVQLJ2JTsbxd2am6XY0EiocMgM29JqFVRnZ9PBcwqd7-dAQ@mail.gmail.com>
 <87d0ednf0t.fsf@toke.dk>
 <CAADnVQ+V4OMjJqSdE_OQ1Vr99kqTF=ZB3UUMKiCSg=3=c+exqg@mail.gmail.com>
 <20191031174208.GC2794@krava>
 <CAADnVQJ=cEeFdYFGnfu6hLyTABWf2==e_1LEhBup5Phe6Jg5hw@mail.gmail.com>
 <20191031191815.GD2794@krava>
 <CAADnVQJdAZS9AHx_B3SZTcWRdigZZsK1ccsYZK0qUsd1yZQqbw@mail.gmail.com>
 <87tv7olzwd.fsf@toke.dk>
Subject: Re: [PATCH bpf-next v3] libbpf: fix compatibility for kernels without
 need_wakeup
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> =

> > On Thu, Oct 31, 2019 at 12:18 PM Jiri Olsa <jolsa@redhat.com> wrote:
> >> >
> >> > yes. older vmlinux and newer installed libbpf.so
> >> > or any version of libbpf.a that is statically linked into apps
> >> > is something that libbpf code has to support.
> >> > The server can be rebooted into older than libbpf kernel and
> >> > into newer than libbpf kernel. libbpf has to recognize all these
> >> > combinations and work appropriately.
> >> > That's what backward and forward compatibility is.
> >> > That's what makes libbpf so difficult to test, develop and code re=
view.
> >> > What that particular server has in /usr/include is irrelevant.
> >>
> >> sure, anyway we can't compile following:
> >>
> >>         tredaell@aldebaran ~ $ echo "#include <bpf/xsk.h>" | gcc -x =
c -
> >>         In file included from <stdin>:1:
> >>         /usr/include/bpf/xsk.h: In function =E2=80=98xsk_ring_prod__=
needs_wakeup=E2=80=99:
> >>         /usr/include/bpf/xsk.h:82:21: error: =E2=80=98XDP_RING_NEED_=
WAKEUP=E2=80=99 undeclared (first use in this function)
> >>            82 |  return *r->flags & XDP_RING_NEED_WAKEUP;
> >>         ...
> >>
> >>         XDP_RING_NEED_WAKEUP is defined in kernel v5.4-rc1 (77cd0d7b=
3f257fd0e3096b4fdcff1a7d38e99e10).
> >>         XSK_UNALIGNED_BUF_ADDR_MASK and XSK_UNALIGNED_BUF_OFFSET_SHI=
FT are defined in kernel v5.4-rc1 (c05cd3645814724bdeb32a2b4d953b12bdea5f=
8c).
> >>
> >> with:
> >>   kernel-headers-5.3.6-300.fc31.x86_64
> >>   libbpf-0.0.5-1.fc31.x86_64
> >>
> >> if you're saying this is not supported, I guess we could be postponi=
ng
> >> libbpf rpm releases until we have the related fedora kernel released=

> >
> > why? github/libbpf is the source of truth for building packages
> > and afaik it builds fine.
> >
> >> or how about inluding uapi headers in libbpf-devel.. but that might
> >> actualy cause more confusion
> >
> > Libraries (libbpf or any other) should not install headers that
> > typically go into /usr/include/
> > if_xdp.h case is not unique.
> > We'll surely add another #define, enum, etc to uapi/linux/bpf.h tomor=
row.
> > And we will not copy paste these constants and types into tools/lib/b=
pf/.
> > In kernel tree libbpf development is using kernel tree headers.
> > No problem there for libbpf developers.
> > Packages are built out of github/libbpf that has a copy of uapi heade=
rs
> > necessary to create packages.
> > No problem there for package builders either.
> > But libbpf package is not going to install those uapi headers.
> > libbpf package installs only libbpf own headers (like libbpf.h)
> > The users that want to build against the latest libbpf package need
> > to install corresponding uapi headers package.
> > I don't think such dependency is specified in rpm scripts.
> > May be it is something to fix? Or may be not.
> > Some folks might not want to update all of /usr/include to bring libb=
pf-devel.
> > Then it would be their responsibility to get fresh /usr/include heade=
rs.
> =

> We can certainly tie libbpf to the kernel version. The obvious way to d=
o
> that is to just ship the version of libbpf that's in the kernel tree of=

> whatever kernel version the distro ships. But how will we handle
> bugfixes, then? You've explicitly stated that libbpf gets no bugfixes
> outside of bpf-next...
> =

> -Toke

We use libbpf and build for a wide variety of kernels so I don't think we=

want to make libbpf kernel version specific. I always want the latest lib=
bpf
features even when building on older kernels. I generally use the bpf-nex=
t
version though so maybe I'm not the target user.

.John
