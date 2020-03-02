Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66AE917620A
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 19:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgCBSKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 13:10:12 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34114 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgCBSKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 13:10:12 -0500
Received: by mail-qk1-f193.google.com with SMTP id 11so635698qkd.1;
        Mon, 02 Mar 2020 10:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NyTuMNwp07K/3UvNv2t2JcR/iqnA3cd9SFwDpJQ0EOM=;
        b=RLMnc9KBRdUhc9av4WdOeWxzOuqPJ77WJYY58/k5HXhccWkjjJfsc/BFvoyAJUDCpU
         TAOG9iXEKHS+GJX3KXwbbGooj34Vh1PDuwKFQWTqX+rZ6rvSn9HthSus9cHB1wzH9lCU
         UTtvEtXzNTb75jKWsmqHb9Qy+TwTmEV/PeMbZWc0LYTj3cm3qzyYE0Av8mggsb+PTo8V
         nk+ViKoWbWU0/xniSreo2TumPzKZFXE7icG8uTfGRVAPraPQ2wNPdpwdQl/ui7B6MVjB
         mk4znbVj+ErhmOwcT2GKg3RV7DS/AZNaPUbY9isFV5xUTlh0p0TidiSMmC/k1lLjOJjF
         JRBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NyTuMNwp07K/3UvNv2t2JcR/iqnA3cd9SFwDpJQ0EOM=;
        b=bRClpnQrKWHWPOAy/BKnreyKQz2/zBIWIyO7qYeDqXWjokUxP/INn8FH0KfmyoMJkZ
         /pVmuRe2PsHyFn1/RXfXxMbWKBfcUfwngbvZXPVRx/FiHswrO+ZEW+KFHz+b+3/is7uG
         R8gshG5re7mR+XRJPSqDGt8fc39fxMRte54uN95sdGTipmzMkcHNWkFAlfcLCk2fvslJ
         DnU807XRyE80aYugGFRifiKbULE7/ooP6e+ItumQFu6NUE/QzkIVfsOzkwU2ttzi7lUs
         9XnhLF7lpBMR8iKMJo61OYdDStydwAbRkhZ93xerYxqEteL5daQbqcolyqaUS+PSm2xo
         QCEw==
X-Gm-Message-State: ANhLgQ1LGNSI3WSaJszF1mkdQl5L1p30ctfiEFBGj3S52Za/kF353Yh7
        D8kqvleRQBraFUaD/iChmHLiP51a2MSiNeYBnos=
X-Google-Smtp-Source: ADFU+vv48PxnvlBfFGkp9goCia2yFmBd2c7tdKvtHq4GETGjt3J7xXV5XqEqoKC22ROicR8vcHlPk+67KjLTBB7qiQI=
X-Received: by 2002:a37:6716:: with SMTP id b22mr454339qkc.437.1583172610268;
 Mon, 02 Mar 2020 10:10:10 -0800 (PST)
MIME-Version: 1.0
References: <20200228223948.360936-1-andriin@fb.com> <20200228223948.360936-3-andriin@fb.com>
 <87h7z7t620.fsf@toke.dk>
In-Reply-To: <87h7z7t620.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Mar 2020 10:09:59 -0800
Message-ID: <CAEf4BzakHPjOHcyf=idh+kMUVhk0jr=Zqd2px8vfxU5N1MV3Rg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] libbpf: add bpf_link pinning/unpinning
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 2, 2020 at 2:17 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Andrii Nakryiko <andriin@fb.com> writes:
>
> > With bpf_link abstraction supported by kernel explicitly, add
> > pinning/unpinning API for links. Also allow to create (open) bpf_link f=
rom BPF
> > FS file.
> >
> > This API allows to have an "ephemeral" FD-based BPF links (like raw tra=
cepoint
> > or fexit/freplace attachments) surviving user process exit, by pinning =
them in
> > a BPF FS, which is an important use case for long-running BPF programs.
> >
> > As part of this, expose underlying FD for bpf_link. While legacy bpf_li=
nk's
> > might not have a FD associated with them (which will be expressed as
> > a bpf_link with fd=3D-1), kernel's abstraction is based around FD-based=
 usage,
> > so match it closely. This, subsequently, allows to have a generic
> > pinning/unpinning API for generalized bpf_link. For some types of bpf_l=
inks
> > kernel might not support pinning, in which case bpf_link__pin() will re=
turn
> > error.
> >
> > With FD being part of generic bpf_link, also get rid of bpf_link_fd in =
favor
> > of using vanialla bpf_link.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c   | 131 +++++++++++++++++++++++++++++++--------
> >  tools/lib/bpf/libbpf.h   |   5 ++
> >  tools/lib/bpf/libbpf.map |   5 ++
> >  3 files changed, 114 insertions(+), 27 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 996162801f7a..f8c4042e5855 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -6931,6 +6931,8 @@ int bpf_prog_load_xattr(const struct bpf_prog_loa=
d_attr *attr,
> >  struct bpf_link {
> >       int (*detach)(struct bpf_link *link);
> >       int (*destroy)(struct bpf_link *link);
> > +     char *pin_path;         /* NULL, if not pinned */
> > +     int fd;                 /* hook FD, -1 if not applicable */
> >       bool disconnected;
> >  };
> >
> > @@ -6960,26 +6962,109 @@ int bpf_link__destroy(struct bpf_link *link)
> >               err =3D link->detach(link);
> >       if (link->destroy)
> >               link->destroy(link);
> > +     if (link->pin_path)
> > +             free(link->pin_path);
>
> This will still detach the link even if it's pinned, won't it? What's

No, this will just free pin_path string memory.

> the expectation, that the calling application just won't call
> bpf_link__destroy() if it pins the link? But then it will leak memory?
> Or is it just that __destroy() will close the fd, but if it's pinned the
> kernel won't actually detach anything? In that case, it seems like the
> function name becomes somewhat misleading?

Yes, the latter, it will close its own FD, but if someone else has
open other FD against the same bpf_link (due to pinning or if you
shared FD with child process, etc), then kernel will keep it.
bpf_link__destroy() is more of a "sever the link my process has" or
"destroy my local link". Maybe not ideal name, but should be close
enough, I think.

>
> -Toke
>
