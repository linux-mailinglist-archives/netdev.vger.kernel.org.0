Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79F0E176626
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 22:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgCBVkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 16:40:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49362 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726700AbgCBVkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 16:40:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583185243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cSbWfXtt0wfQJphDjnyDtA0R+HfCF/kyEHKSihZFDj4=;
        b=ipGIIxK82jSmVkGJsonxcQuEUojvBCWzIxCMdmHjtTzH56FmLNn9c0BdpUnkKWKvVaRUou
        pjxfO9Gs5kX8kBuoTlPCFYRxWc5VjAYCu09kq+CddWxNxiV6Ugl3HMnSKsB/EGZ+xHlupN
        YoqS1RBYTSev5aDrvEoU4PJY9iDt16w=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-A0Ol_gF0Nl6rLrKobWAPyg-1; Mon, 02 Mar 2020 16:40:39 -0500
X-MC-Unique: A0Ol_gF0Nl6rLrKobWAPyg-1
Received: by mail-wr1-f69.google.com with SMTP id 72so282712wrc.6
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 13:40:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=cSbWfXtt0wfQJphDjnyDtA0R+HfCF/kyEHKSihZFDj4=;
        b=VcJLhmXe4JCLXyDC4mpeiREY1Brw9odp72WppblbJt74dpZcMc4gbTHIBmmxX7DK7C
         i0OjbRZUElb2I/vphHANJ5/lx6lZU019HshHKZAySWsA0eKbO9vsiHLweDDHWB9CCffH
         EucopHrcYWBKMQ417Tw9/lMFEeLZtNXQC+V3yhWIQir7R6dKLHjSJ8A1H7bgqs9PeaRU
         e8027bFBds/6mynzoSsKOy0FaG/j1g3j6vGmwvYY1DuFuAHzmz7l4mnLR2Yfk4MANEQR
         NrhR34vRAPw29qHutPXB4xS93nAecDj/6Fgg+Z5s5H2LH4xga+OYiaqG3x+Lv/Nxa3z+
         axnw==
X-Gm-Message-State: ANhLgQ1SQYdMK0p/cIE1djTNkPp34qAjje/QJUkQJN3TfWjw8ktM9kac
        Jldg/+U6EgXDU+qupZjcTkTlkYOCVVPekEON2APU8i2j/fljUmdANY8mA5gmCsIxs9KmwfDVm5h
        f/vSHYwF2XFLKk/vJ
X-Received: by 2002:a5d:6385:: with SMTP id p5mr1425909wru.167.1583185238156;
        Mon, 02 Mar 2020 13:40:38 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsro6sgC5/pFDosqxpSiak1LaPzUR7QtdmrIkcPz8UOEXQPRId3VdJuCHtG456kmBG1SwY40g==
X-Received: by 2002:a5d:6385:: with SMTP id p5mr1425888wru.167.1583185237803;
        Mon, 02 Mar 2020 13:40:37 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id j12sm30661607wrt.35.2020.03.02.13.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 13:40:36 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 420F2180362; Mon,  2 Mar 2020 22:40:36 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: introduce pinnable bpf_link abstraction
In-Reply-To: <CAEf4BzY_2rLNS4rJnySGr_44e315SGs0FMBNh1010YYBX8OBmg@mail.gmail.com>
References: <20200228223948.360936-1-andriin@fb.com> <20200228223948.360936-2-andriin@fb.com> <87k143t682.fsf@toke.dk> <CAEf4BzY_2rLNS4rJnySGr_44e315SGs0FMBNh1010YYBX8OBmg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 02 Mar 2020 22:40:36 +0100
Message-ID: <87r1yasaej.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Mon, Mar 2, 2020 at 2:13 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>>
>> Andrii Nakryiko <andriin@fb.com> writes:
>>
>> > Introduce bpf_link abstraction, representing an attachment of BPF prog=
ram to
>> > a BPF hook point (e.g., tracepoint, perf event, etc). bpf_link encapsu=
lates
>> > ownership of attached BPF program, reference counting of a link itself=
, when
>> > reference from multiple anonymous inodes, as well as ensures that rele=
ase
>> > callback will be called from a process context, so that users can safe=
ly take
>> > mutex locks and sleep.
>> >
>> > Additionally, with a new abstraction it's now possible to generalize p=
inning
>> > of a link object in BPF FS, allowing to explicitly prevent BPF program
>> > detachment on process exit by pinning it in a BPF FS and let it open f=
rom
>> > independent other process to keep working with it.
>> >
>> > Convert two existing bpf_link-like objects (raw tracepoint and tracing=
 BPF
>> > program attachments) into utilizing bpf_link framework, making them pi=
nnable
>> > in BPF FS. More FD-based bpf_links will be added in follow up patches.
>> >
>> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>> > ---
>> >  include/linux/bpf.h  |  13 +++
>> >  kernel/bpf/inode.c   |  42 ++++++++-
>> >  kernel/bpf/syscall.c | 209 ++++++++++++++++++++++++++++++++++++-------
>> >  3 files changed, 226 insertions(+), 38 deletions(-)
>> >
>> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> > index 6015a4daf118..f13c78c6f29d 100644
>> > --- a/include/linux/bpf.h
>> > +++ b/include/linux/bpf.h
>> > @@ -1056,6 +1056,19 @@ extern int sysctl_unprivileged_bpf_disabled;
>> >  int bpf_map_new_fd(struct bpf_map *map, int flags);
>> >  int bpf_prog_new_fd(struct bpf_prog *prog);
>> >
>> > +struct bpf_link;
>> > +
>> > +struct bpf_link_ops {
>> > +     void (*release)(struct bpf_link *link);
>> > +};
>> > +
>> > +void bpf_link_init(struct bpf_link *link, const struct bpf_link_ops *=
ops,
>> > +                struct bpf_prog *prog);
>> > +void bpf_link_inc(struct bpf_link *link);
>> > +void bpf_link_put(struct bpf_link *link);
>> > +int bpf_link_new_fd(struct bpf_link *link);
>> > +struct bpf_link *bpf_link_get_from_fd(u32 ufd);
>> > +
>> >  int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
>> >  int bpf_obj_get_user(const char __user *pathname, int flags);
>> >
>> > diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
>> > index 5e40e7fccc21..95087d9f4ed3 100644
>> > --- a/kernel/bpf/inode.c
>> > +++ b/kernel/bpf/inode.c
>> > @@ -25,6 +25,7 @@ enum bpf_type {
>> >       BPF_TYPE_UNSPEC =3D 0,
>> >       BPF_TYPE_PROG,
>> >       BPF_TYPE_MAP,
>> > +     BPF_TYPE_LINK,
>> >  };
>> >
>> >  static void *bpf_any_get(void *raw, enum bpf_type type)
>> > @@ -36,6 +37,9 @@ static void *bpf_any_get(void *raw, enum bpf_type ty=
pe)
>> >       case BPF_TYPE_MAP:
>> >               bpf_map_inc_with_uref(raw);
>> >               break;
>> > +     case BPF_TYPE_LINK:
>> > +             bpf_link_inc(raw);
>> > +             break;
>> >       default:
>> >               WARN_ON_ONCE(1);
>> >               break;
>> > @@ -53,6 +57,9 @@ static void bpf_any_put(void *raw, enum bpf_type typ=
e)
>> >       case BPF_TYPE_MAP:
>> >               bpf_map_put_with_uref(raw);
>> >               break;
>> > +     case BPF_TYPE_LINK:
>> > +             bpf_link_put(raw);
>> > +             break;
>> >       default:
>> >               WARN_ON_ONCE(1);
>> >               break;
>> > @@ -63,20 +70,32 @@ static void *bpf_fd_probe_obj(u32 ufd, enum bpf_ty=
pe *type)
>> >  {
>> >       void *raw;
>> >
>> > -     *type =3D BPF_TYPE_MAP;
>> >       raw =3D bpf_map_get_with_uref(ufd);
>> > -     if (IS_ERR(raw)) {
>> > +     if (!IS_ERR(raw)) {
>> > +             *type =3D BPF_TYPE_MAP;
>> > +             return raw;
>> > +     }
>> > +
>> > +     raw =3D bpf_prog_get(ufd);
>> > +     if (!IS_ERR(raw)) {
>> >               *type =3D BPF_TYPE_PROG;
>> > -             raw =3D bpf_prog_get(ufd);
>> > +             return raw;
>> >       }
>> >
>> > -     return raw;
>> > +     raw =3D bpf_link_get_from_fd(ufd);
>> > +     if (!IS_ERR(raw)) {
>> > +             *type =3D BPF_TYPE_LINK;
>> > +             return raw;
>> > +     }
>> > +
>> > +     return ERR_PTR(-EINVAL);
>> >  }
>> >
>> >  static const struct inode_operations bpf_dir_iops;
>> >
>> >  static const struct inode_operations bpf_prog_iops =3D { };
>> >  static const struct inode_operations bpf_map_iops  =3D { };
>> > +static const struct inode_operations bpf_link_iops  =3D { };
>> >
>> >  static struct inode *bpf_get_inode(struct super_block *sb,
>> >                                  const struct inode *dir,
>> > @@ -114,6 +133,8 @@ static int bpf_inode_type(const struct inode *inod=
e, enum bpf_type *type)
>> >               *type =3D BPF_TYPE_PROG;
>> >       else if (inode->i_op =3D=3D &bpf_map_iops)
>> >               *type =3D BPF_TYPE_MAP;
>> > +     else if (inode->i_op =3D=3D &bpf_link_iops)
>> > +             *type =3D BPF_TYPE_LINK;
>> >       else
>> >               return -EACCES;
>> >
>> > @@ -335,6 +356,12 @@ static int bpf_mkmap(struct dentry *dentry, umode=
_t mode, void *arg)
>> >                            &bpffs_map_fops : &bpffs_obj_fops);
>> >  }
>> >
>> > +static int bpf_mklink(struct dentry *dentry, umode_t mode, void *arg)
>> > +{
>> > +     return bpf_mkobj_ops(dentry, mode, arg, &bpf_link_iops,
>> > +                          &bpffs_obj_fops);
>> > +}
>> > +
>> >  static struct dentry *
>> >  bpf_lookup(struct inode *dir, struct dentry *dentry, unsigned flags)
>> >  {
>> > @@ -411,6 +438,9 @@ static int bpf_obj_do_pin(const char __user *pathn=
ame, void *raw,
>> >       case BPF_TYPE_MAP:
>> >               ret =3D vfs_mkobj(dentry, mode, bpf_mkmap, raw);
>> >               break;
>> > +     case BPF_TYPE_LINK:
>> > +             ret =3D vfs_mkobj(dentry, mode, bpf_mklink, raw);
>> > +             break;
>> >       default:
>> >               ret =3D -EPERM;
>> >       }
>> > @@ -487,6 +517,8 @@ int bpf_obj_get_user(const char __user *pathname, =
int flags)
>> >               ret =3D bpf_prog_new_fd(raw);
>> >       else if (type =3D=3D BPF_TYPE_MAP)
>> >               ret =3D bpf_map_new_fd(raw, f_flags);
>> > +     else if (type =3D=3D BPF_TYPE_LINK)
>> > +             ret =3D bpf_link_new_fd(raw);
>> >       else
>> >               return -ENOENT;
>> >
>> > @@ -504,6 +536,8 @@ static struct bpf_prog *__get_prog_inode(struct in=
ode *inode, enum bpf_prog_type
>> >
>> >       if (inode->i_op =3D=3D &bpf_map_iops)
>> >               return ERR_PTR(-EINVAL);
>> > +     if (inode->i_op =3D=3D &bpf_link_iops)
>> > +             return ERR_PTR(-EINVAL);
>> >       if (inode->i_op !=3D &bpf_prog_iops)
>> >               return ERR_PTR(-EACCES);
>> >
>> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>> > index c536c65256ad..fca8de7e7872 100644
>> > --- a/kernel/bpf/syscall.c
>> > +++ b/kernel/bpf/syscall.c
>> > @@ -2173,23 +2173,153 @@ static int bpf_obj_get(const union bpf_attr *=
attr)
>> >                               attr->file_flags);
>> >  }
>> >
>> > -static int bpf_tracing_prog_release(struct inode *inode, struct file =
*filp)
>> > +struct bpf_link {
>> > +     atomic64_t refcnt;
>>
>> refcount_t ?
>
> Both bpf_map and bpf_prog stick to atomic64 for their refcounting, so
> I'd like to stay consistent and use refcount that can't possible leak
> resources (which refcount_t can, if it's overflown).

refcount_t is specifically supposed to turn a possible use-after-free on
under/overflow into a warning, isn't it? Not going to insist or anything
here, just found it odd that you'd prefer the other...

-Toke

