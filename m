Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 974581761E0
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 19:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgCBSGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 13:06:47 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:36968 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgCBSGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 13:06:47 -0500
Received: by mail-qv1-f65.google.com with SMTP id c19so328728qvv.4;
        Mon, 02 Mar 2020 10:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OKgisICyoZSbDhv9Ew9TN5xZcKtdK8+xF57bcQehtcM=;
        b=AfY/2CXwEfI1GwzWfIbzhKTGdn9uQh8kV34p4f2kwgDWBAy5QfPmPIyPypMiJHQRxz
         fofVQ0eyAP6fDtR7mv+YnN/LLEgXAAeBTUI5eRlfA0LnYDDiKiGzOT2qXhrCzpm6Xwgk
         7sY/3d1FRHl2hPlyj/J/C0iZEvS3EHacNwkmYK9WHV5F6HO3NO/pyS4PYC+wffUHj+MW
         l0+y+FHhXkOHqc0H3LtH4z4KwfyMAylDSX8XT3ONXo8hV4YZnQFuE1MrnC82uNuJj09V
         FOJspVujx7QXt7LAbIEH6gLGZhitzUFuf+1WDz862oISED4yinGBqsVrOGn/6pXl6cwU
         GiBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OKgisICyoZSbDhv9Ew9TN5xZcKtdK8+xF57bcQehtcM=;
        b=oPxFroCPqwY3xYFst38XyBoHy4Z+zeolO7CemriOUHLb6opGKG7p8b8M8WflHLMJ5y
         8Li/g6UXyA+Zu6sojSNK5b9OMnb1VbCZat03wzUTK8Sqf1xacCTp36Dgh8m/V+HLG6Mj
         lHjiLmpv6+QLWgViOkQeLyvMwbVVzZFY6CsM91xZzGJN02mXcRfTSQ5uwnP4aSjd+eqU
         jXuFiqywDIezpgFsecXqHm0PQBYZUco9Ih7QakQski7jD/1pOl+Wl6j2ctXjC1JVkjUo
         LpAMcFv/tnUrbJhEEv4MdiltOmIS+gSzoV0EdFN8/uWtmgr55ri4ehwfCj7TzkzWk4Hn
         g1Qg==
X-Gm-Message-State: ANhLgQ0DCP5BeROciNPo9hD8wgoNUu1wquLWMZhUtHWWNExJHRFbG+aK
        cU0eqe4De4IrKoURSPDrqp9ihu72NTS3xmjSOl0=
X-Google-Smtp-Source: ADFU+vsdJ1LoC2Vp97TqMBcE88/O7JklrqLF6L23rakw4+lqlnfsy+hKbr+6ynxUBFV4rOJarkn+btSSv5CarEK26Po=
X-Received: by 2002:ad4:514e:: with SMTP id g14mr596193qvq.196.1583172404227;
 Mon, 02 Mar 2020 10:06:44 -0800 (PST)
MIME-Version: 1.0
References: <20200228223948.360936-1-andriin@fb.com> <20200228223948.360936-2-andriin@fb.com>
 <87k143t682.fsf@toke.dk>
In-Reply-To: <87k143t682.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Mar 2020 10:06:33 -0800
Message-ID: <CAEf4BzY_2rLNS4rJnySGr_44e315SGs0FMBNh1010YYBX8OBmg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: introduce pinnable bpf_link abstraction
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

On Mon, Mar 2, 2020 at 2:13 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Andrii Nakryiko <andriin@fb.com> writes:
>
> > Introduce bpf_link abstraction, representing an attachment of BPF progr=
am to
> > a BPF hook point (e.g., tracepoint, perf event, etc). bpf_link encapsul=
ates
> > ownership of attached BPF program, reference counting of a link itself,=
 when
> > reference from multiple anonymous inodes, as well as ensures that relea=
se
> > callback will be called from a process context, so that users can safel=
y take
> > mutex locks and sleep.
> >
> > Additionally, with a new abstraction it's now possible to generalize pi=
nning
> > of a link object in BPF FS, allowing to explicitly prevent BPF program
> > detachment on process exit by pinning it in a BPF FS and let it open fr=
om
> > independent other process to keep working with it.
> >
> > Convert two existing bpf_link-like objects (raw tracepoint and tracing =
BPF
> > program attachments) into utilizing bpf_link framework, making them pin=
nable
> > in BPF FS. More FD-based bpf_links will be added in follow up patches.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  include/linux/bpf.h  |  13 +++
> >  kernel/bpf/inode.c   |  42 ++++++++-
> >  kernel/bpf/syscall.c | 209 ++++++++++++++++++++++++++++++++++++-------
> >  3 files changed, 226 insertions(+), 38 deletions(-)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 6015a4daf118..f13c78c6f29d 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -1056,6 +1056,19 @@ extern int sysctl_unprivileged_bpf_disabled;
> >  int bpf_map_new_fd(struct bpf_map *map, int flags);
> >  int bpf_prog_new_fd(struct bpf_prog *prog);
> >
> > +struct bpf_link;
> > +
> > +struct bpf_link_ops {
> > +     void (*release)(struct bpf_link *link);
> > +};
> > +
> > +void bpf_link_init(struct bpf_link *link, const struct bpf_link_ops *o=
ps,
> > +                struct bpf_prog *prog);
> > +void bpf_link_inc(struct bpf_link *link);
> > +void bpf_link_put(struct bpf_link *link);
> > +int bpf_link_new_fd(struct bpf_link *link);
> > +struct bpf_link *bpf_link_get_from_fd(u32 ufd);
> > +
> >  int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
> >  int bpf_obj_get_user(const char __user *pathname, int flags);
> >
> > diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> > index 5e40e7fccc21..95087d9f4ed3 100644
> > --- a/kernel/bpf/inode.c
> > +++ b/kernel/bpf/inode.c
> > @@ -25,6 +25,7 @@ enum bpf_type {
> >       BPF_TYPE_UNSPEC =3D 0,
> >       BPF_TYPE_PROG,
> >       BPF_TYPE_MAP,
> > +     BPF_TYPE_LINK,
> >  };
> >
> >  static void *bpf_any_get(void *raw, enum bpf_type type)
> > @@ -36,6 +37,9 @@ static void *bpf_any_get(void *raw, enum bpf_type typ=
e)
> >       case BPF_TYPE_MAP:
> >               bpf_map_inc_with_uref(raw);
> >               break;
> > +     case BPF_TYPE_LINK:
> > +             bpf_link_inc(raw);
> > +             break;
> >       default:
> >               WARN_ON_ONCE(1);
> >               break;
> > @@ -53,6 +57,9 @@ static void bpf_any_put(void *raw, enum bpf_type type=
)
> >       case BPF_TYPE_MAP:
> >               bpf_map_put_with_uref(raw);
> >               break;
> > +     case BPF_TYPE_LINK:
> > +             bpf_link_put(raw);
> > +             break;
> >       default:
> >               WARN_ON_ONCE(1);
> >               break;
> > @@ -63,20 +70,32 @@ static void *bpf_fd_probe_obj(u32 ufd, enum bpf_typ=
e *type)
> >  {
> >       void *raw;
> >
> > -     *type =3D BPF_TYPE_MAP;
> >       raw =3D bpf_map_get_with_uref(ufd);
> > -     if (IS_ERR(raw)) {
> > +     if (!IS_ERR(raw)) {
> > +             *type =3D BPF_TYPE_MAP;
> > +             return raw;
> > +     }
> > +
> > +     raw =3D bpf_prog_get(ufd);
> > +     if (!IS_ERR(raw)) {
> >               *type =3D BPF_TYPE_PROG;
> > -             raw =3D bpf_prog_get(ufd);
> > +             return raw;
> >       }
> >
> > -     return raw;
> > +     raw =3D bpf_link_get_from_fd(ufd);
> > +     if (!IS_ERR(raw)) {
> > +             *type =3D BPF_TYPE_LINK;
> > +             return raw;
> > +     }
> > +
> > +     return ERR_PTR(-EINVAL);
> >  }
> >
> >  static const struct inode_operations bpf_dir_iops;
> >
> >  static const struct inode_operations bpf_prog_iops =3D { };
> >  static const struct inode_operations bpf_map_iops  =3D { };
> > +static const struct inode_operations bpf_link_iops  =3D { };
> >
> >  static struct inode *bpf_get_inode(struct super_block *sb,
> >                                  const struct inode *dir,
> > @@ -114,6 +133,8 @@ static int bpf_inode_type(const struct inode *inode=
, enum bpf_type *type)
> >               *type =3D BPF_TYPE_PROG;
> >       else if (inode->i_op =3D=3D &bpf_map_iops)
> >               *type =3D BPF_TYPE_MAP;
> > +     else if (inode->i_op =3D=3D &bpf_link_iops)
> > +             *type =3D BPF_TYPE_LINK;
> >       else
> >               return -EACCES;
> >
> > @@ -335,6 +356,12 @@ static int bpf_mkmap(struct dentry *dentry, umode_=
t mode, void *arg)
> >                            &bpffs_map_fops : &bpffs_obj_fops);
> >  }
> >
> > +static int bpf_mklink(struct dentry *dentry, umode_t mode, void *arg)
> > +{
> > +     return bpf_mkobj_ops(dentry, mode, arg, &bpf_link_iops,
> > +                          &bpffs_obj_fops);
> > +}
> > +
> >  static struct dentry *
> >  bpf_lookup(struct inode *dir, struct dentry *dentry, unsigned flags)
> >  {
> > @@ -411,6 +438,9 @@ static int bpf_obj_do_pin(const char __user *pathna=
me, void *raw,
> >       case BPF_TYPE_MAP:
> >               ret =3D vfs_mkobj(dentry, mode, bpf_mkmap, raw);
> >               break;
> > +     case BPF_TYPE_LINK:
> > +             ret =3D vfs_mkobj(dentry, mode, bpf_mklink, raw);
> > +             break;
> >       default:
> >               ret =3D -EPERM;
> >       }
> > @@ -487,6 +517,8 @@ int bpf_obj_get_user(const char __user *pathname, i=
nt flags)
> >               ret =3D bpf_prog_new_fd(raw);
> >       else if (type =3D=3D BPF_TYPE_MAP)
> >               ret =3D bpf_map_new_fd(raw, f_flags);
> > +     else if (type =3D=3D BPF_TYPE_LINK)
> > +             ret =3D bpf_link_new_fd(raw);
> >       else
> >               return -ENOENT;
> >
> > @@ -504,6 +536,8 @@ static struct bpf_prog *__get_prog_inode(struct ino=
de *inode, enum bpf_prog_type
> >
> >       if (inode->i_op =3D=3D &bpf_map_iops)
> >               return ERR_PTR(-EINVAL);
> > +     if (inode->i_op =3D=3D &bpf_link_iops)
> > +             return ERR_PTR(-EINVAL);
> >       if (inode->i_op !=3D &bpf_prog_iops)
> >               return ERR_PTR(-EACCES);
> >
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index c536c65256ad..fca8de7e7872 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -2173,23 +2173,153 @@ static int bpf_obj_get(const union bpf_attr *a=
ttr)
> >                               attr->file_flags);
> >  }
> >
> > -static int bpf_tracing_prog_release(struct inode *inode, struct file *=
filp)
> > +struct bpf_link {
> > +     atomic64_t refcnt;
>
> refcount_t ?

Both bpf_map and bpf_prog stick to atomic64 for their refcounting, so
I'd like to stay consistent and use refcount that can't possible leak
resources (which refcount_t can, if it's overflown).

>
> -Toke
>
