Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2ADE115B
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 06:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388930AbfJWE6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 00:58:53 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46965 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727850AbfJWE6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 00:58:53 -0400
Received: by mail-qt1-f194.google.com with SMTP id u22so30413774qtq.13;
        Tue, 22 Oct 2019 21:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KD9wk3rtlGk25cugQBW8PeMmDWyY5bD+3+xHNKYM4+M=;
        b=n2ek7N7LIUnGxMfxT6ProPSOnRma9QOTpPmqgCKjvVzxSUfcMjO1JR2PtStO7R6mdm
         TrZIwO/uVfhrpB+GxI1CtlOvXbDcNCVyS6wC/BIZ4dk14BzTti0WjrEYEPcNzZXDcGU1
         eTK7TgIFvKtlatJXfISkNAvG21F+FLTe6FTJHnU736zk9nXbo/rO0+ibvYTNSUcPWpXW
         6seaAtj9dASL6kKGqccgZjNqqiZjh25iecrWf+SLcPHPcn5VpOZgX7EWIrXVeI2lCcfd
         HNijg1+lMD2G70nisP6lyIniFB9oMUjH/1PaRK217jFdXNznzkqtDo89nkbzIoHf6PEW
         UkIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KD9wk3rtlGk25cugQBW8PeMmDWyY5bD+3+xHNKYM4+M=;
        b=WMQv7ry3Z8asNy8XRpI8udQ51LwwWGgT06gRD7bSB3C0lDyavXXTSUiD8WVtCwbknS
         7Zo76XLH6o8IVCWF8NKMTEEPi+Ibv515gGkwCfyS43O3J2D5zAioPc3lzbp0ng6G0u7q
         NS5hpz6iHSXmkKpUBLQtYgoaYeQifkK67WGzOkhI3N2/mYOH3jWWnEMdnc+ATIwejznx
         vuWS42+Ya3Za/4m/PfF4JjUGSNoUPpyxSeR9g0eN7myH+edEdqG1vZrowKvPBocXIib5
         KimdUMdRVdX07XDAOhjIWBo/OaUios3emz+aEsgACwQ/t+KSiwSKKW6RuwcPaRpqZMTt
         6xgw==
X-Gm-Message-State: APjAAAWhJrVXhbI4YAFCx0T1VOUJ4k9Kefa10uQfMAIBvsMTpH6akv43
        i9HECAeHV5eWMvovoh9GFq31qy8B4j4xv73fmPU=
X-Google-Smtp-Source: APXvYqxxryhdMIXux0RZDHmS7x1f/k2bBMHC6QglZx1yrb9ug/N0OA1HRtGRXWhXKUzZlH6Wx0axp63g3uQj84Hur5w=
X-Received: by 2002:a05:6214:16c5:: with SMTP id d5mr1480870qvz.247.1571806732279;
 Tue, 22 Oct 2019 21:58:52 -0700 (PDT)
MIME-Version: 1.0
References: <157175668770.112621.17344362302386223623.stgit@toke.dk>
 <157175669103.112621.7847833678119315310.stgit@toke.dk> <CAEf4BzbfV5vrFnkNyG35Db2iPmM2ubtFh6OTvLiaetAx6eFHHw@mail.gmail.com>
 <8736fkob4g.fsf@toke.dk>
In-Reply-To: <8736fkob4g.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Oct 2019 21:58:41 -0700
Message-ID: <CAEf4Bzap3oMPnGJQAsoV-g77ux0FdELiJpvpxn9_zadVnHYdSA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] libbpf: Add pin option to automount BPF
 filesystem before pinning
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 12:04 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Tue, Oct 22, 2019 at 9:08 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>
> >> While the current map pinning functions will check whether the pin pat=
h is
> >> contained on a BPF filesystem, it does not offer any options to mount =
the
> >> file system if it doesn't exist. Since we now have pinning options, ad=
d a
> >> new one to automount a BPF filesystem at the pinning path if that is n=
ot
> >
> > Next thing we'll be adding extra options to mount BPF FS... Can we
> > leave the task of auto-mounting BPF FS to tools/applications?
>
> Well, there was a reason I put this into a separate patch: I wasn't sure
> it really fit here. My reasoning is the following: If we end up with a
> default auto-pinning that works really well, people are going to just
> use that. And end up really confused when bpffs is not mounted. And it
> seems kinda silly to make every application re-implement the same mount
> check and logic.
>
> Or to put it another way: If we agree that the reasonable default thing
> is to just pin things in /sys/fs/bpf, let's make it as easy as possible
> for applications to do that right.
>

This reminds me the setrlimit() issue, though. And we decided that
library shouldn't be manipulating global resources on behalf of users.
I think this is a similar one.

> >> already pointing at a bpffs.
> >>
> >> The mounting logic itself is copied from the iproute2 BPF helper funct=
ions.
> >>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >>  tools/lib/bpf/libbpf.c |   47 +++++++++++++++++++++++++++++++++++++++=
++++++++
> >>  tools/lib/bpf/libbpf.h |    5 ++++-
> >>  2 files changed, 51 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> index aea3916de341..f527224bb211 100644
> >> --- a/tools/lib/bpf/libbpf.c
> >> +++ b/tools/lib/bpf/libbpf.c
> >> @@ -37,6 +37,7 @@
> >>  #include <sys/epoll.h>
> >>  #include <sys/ioctl.h>
> >>  #include <sys/mman.h>
> >> +#include <sys/mount.h>
> >>  #include <sys/stat.h>
> >>  #include <sys/types.h>
> >>  #include <sys/vfs.h>
> >> @@ -4072,6 +4073,35 @@ int bpf_map__unpin(struct bpf_map *map, const c=
har *path)
> >>         return 0;
> >>  }
> >>
> >> +static int mount_bpf_fs(const char *target)
> >> +{
> >> +       bool bind_done =3D false;
> >> +
> >> +       while (mount("", target, "none", MS_PRIVATE | MS_REC, NULL)) {
> >
> > what does this loop do? we need some comments explaining what's going
> > on here
>
> Well, as it says in the commit message I stole this from iproute2. I
> think the "--make-private, --bind" dance is there to make sure we don't
> mess up some other mount points at this path. Which seems like a good
> idea, and one of those things that most people probably won't think
> about when just writing an application that wants to mount the fs; which
> is another reason to put this into libbpf :)

I think this is exactly a reason to not do this and rely on
applications to know and set up their environment properly. All these
races, accidentally stomping on someone else's FS, etc, that sounds
like a really good excuse to not do this in libbpf. Definitely not
until we get a real experience, driven by production use cases, on how
to go about that correctly. It might be added as a helper, but I think
application has to call it explicitly.

>
> >> +               if (errno !=3D EINVAL || bind_done) {
> >> +                       pr_warning("mount --make-private %s failed: %s=
\n",
> >> +                                  target, strerror(errno));
> >> +                       return -1;
> >> +               }
> >> +
> >> +               if (mount(target, target, "none", MS_BIND, NULL)) {
> >> +                       pr_warning("mount --bind %s %s failed: %s\n",
> >> +                                  target, target, strerror(errno));
> >> +                       return -1;
> >> +               }
> >> +
> >> +               bind_done =3D true;
> >> +       }
> >> +
> >> +       if (mount("bpf", target, "bpf", 0, "mode=3D0700")) {
> >> +               fprintf(stderr, "mount -t bpf bpf %s failed: %s\n",
> >> +                       target, strerror(errno));
> >> +               return -1;
> >> +       }
> >> +
> >> +       return 0;
> >> +}
> >> +
> >>  static int get_pin_path(char *buf, size_t buf_len,
> >>                         struct bpf_map *map, struct bpf_object_pin_opt=
s *opts,
> >>                         bool mkdir)
> >> @@ -4102,6 +4132,23 @@ static int get_pin_path(char *buf, size_t buf_l=
en,
> >
> > Nothing in `get_pin_path` indicates that it's going to do an entire FS
> > mount, please split this out of get_pin_path.
>
> Regardless of the arguments above, that is certainly a fair point ;)
>
> -Toke
