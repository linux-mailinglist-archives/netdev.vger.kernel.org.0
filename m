Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 609F618FD9F
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 20:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgCWT3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 15:29:11 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:25093 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727576AbgCWT3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 15:29:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584991748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iHWYdSYL93Ywktf/H5b1/5IXNHDwqJMHQr3XBqc0DNY=;
        b=hbUlTMhq7tK7/vCQ1tnQDUd6SlEbTTAx7bulwGYKA0FhAbv28lkDC+6H4vagg4frCNJFg7
        4As3ETC1MpfIam4dqe75SLcoq/Awg7NWZJlVxOP7AqzHOE2b+yDP3Drq9zo8SmvI2wPK/9
        5PFYzRwkTbDB6yOfPha6zcDM4VAt71k=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-IMcNIqgJPxWDXDOzRyZy1w-1; Mon, 23 Mar 2020 15:29:06 -0400
X-MC-Unique: IMcNIqgJPxWDXDOzRyZy1w-1
Received: by mail-wr1-f69.google.com with SMTP id y1so2867371wrn.10
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 12:29:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=iHWYdSYL93Ywktf/H5b1/5IXNHDwqJMHQr3XBqc0DNY=;
        b=hEuVPKrZc59KRC97f5ZhGdJiNGoB8/I8rN5eHfC94mj+dll37QSdVgFevbkDn0BSwl
         H8vM+RXllrBQwmVnDQ/zN/3VmYmor+yf4SIYF7/5k97VJvHw2ucn6utmiKr0jbA2EG0h
         LGhOSIBV+U52Nl8AUHY5j3kMuk5YJfEi/CO50TlxOCBEr2fkgGGcDvQOd7mYHI+SKQHP
         twRHZobId3mQhVXVU2dQi9WgkYElNtNQgwRgY8bgSRiPm4JQZ59KBUoWS0m0s1mdgV7V
         smNEtd+ClM+th6GcZhTTmh6QXljSgnhlkvEk4v75n54VigG/e3Zz36V9MuEkgoQJakPC
         V+zg==
X-Gm-Message-State: ANhLgQ1FWqRWWYLbXacwp7HqDR5t2iwJr1F8azObHIVdOG+S3OZ+9tAn
        LOj/QQUlFIiqs55glaSMbYlyLq4/3CQIKH3gzoKoPSdPZzx4D3oMUsxeI90veFZ0nsLoHRQgdKa
        EcqfSgB4miTOTbNbB
X-Received: by 2002:a7b:c542:: with SMTP id j2mr986896wmk.39.1584991745475;
        Mon, 23 Mar 2020 12:29:05 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuthwNGqAWaksUyIu5ROdOXrGKy2INpfMllbGVGhuCMOMp2KPAC3IuUz1NTpPmBqu53m/YHZw==
X-Received: by 2002:a7b:c542:: with SMTP id j2mr986853wmk.39.1584991745102;
        Mon, 23 Mar 2020 12:29:05 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id f12sm814604wmh.4.2020.03.23.12.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 12:29:04 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 01D61180371; Mon, 23 Mar 2020 20:29:03 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 4/6] bpf: implement bpf_prog replacement for an active bpf_cgroup_link
In-Reply-To: <CAEf4BzbnZzwUSXMyNetHzOEjLSZS_z-NDAU0LJHH-81JRS=+rw@mail.gmail.com>
References: <20200320203615.1519013-1-andriin@fb.com> <20200320203615.1519013-5-andriin@fb.com> <87zhc749tu.fsf@toke.dk> <CAEf4BzbnZzwUSXMyNetHzOEjLSZS_z-NDAU0LJHH-81JRS=+rw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 23 Mar 2020 20:29:03 +0100
Message-ID: <87eeti3m68.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Mon, Mar 23, 2020 at 3:58 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andriin@fb.com> writes:
>>
>> > Add new operation (LINK_UPDATE), which allows to replace active bpf_pr=
og from
>> > under given bpf_link. Currently this is only supported for bpf_cgroup_=
link,
>> > but will be extended to other kinds of bpf_links in follow-up patches.
>> >
>> > For bpf_cgroup_link, implemented functionality matches existing semant=
ics for
>> > direct bpf_prog attachment (including BPF_F_REPLACE flag). User can ei=
ther
>> > unconditionally set new bpf_prog regardless of which bpf_prog is curre=
ntly
>> > active under given bpf_link, or, optionally, can specify expected acti=
ve
>> > bpf_prog. If active bpf_prog doesn't match expected one, operation is =
a noop
>> > and returns a failure.
>>
>> Nit: I'd consider a 'noop' to be something that succeeds, so that last
>> sentence is a contradiction. Maybe "If active bpf_prog doesn't match
>> expected one, the kernel will abort the operation and return a failure."?
>
> Heh, for me "noop" (no operation) means no changes done, it doesn't
> mean that syscall itself is successful. But I'll change the wording to
> be less confusing.

Cool.

>>
>> > cgroup_bpf_replace() operation is resolving race between auto-detachme=
nt and
>> > bpf_prog update in the same fashion as it's done for bpf_link detachme=
nt,
>> > except in this case update has no way of succeeding because of target =
cgroup
>> > marked as dying. So in this case error is returned.
>> >
>> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>> > ---
>> >  include/linux/bpf-cgroup.h |  4 ++
>> >  include/uapi/linux/bpf.h   | 12 ++++++
>> >  kernel/bpf/cgroup.c        | 77 ++++++++++++++++++++++++++++++++++++++
>> >  kernel/bpf/syscall.c       | 60 +++++++++++++++++++++++++++++
>> >  kernel/cgroup/cgroup.c     | 21 +++++++++++
>> >  5 files changed, 174 insertions(+)
>> >
>> > diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
>> > index ab95824a1d99..5735d8bfd69e 100644
>> > --- a/include/linux/bpf-cgroup.h
>> > +++ b/include/linux/bpf-cgroup.h
>> > @@ -98,6 +98,8 @@ int __cgroup_bpf_attach(struct cgroup *cgrp,
>> >  int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>> >                       struct bpf_cgroup_link *link,
>> >                       enum bpf_attach_type type);
>> > +int __cgroup_bpf_replace(struct cgroup *cgrp, struct bpf_cgroup_link =
*link,
>> > +                      struct bpf_prog *new_prog);
>> >  int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *att=
r,
>> >                      union bpf_attr __user *uattr);
>> >
>> > @@ -108,6 +110,8 @@ int cgroup_bpf_attach(struct cgroup *cgrp,
>> >                     u32 flags);
>> >  int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>> >                     enum bpf_attach_type type);
>> > +int cgroup_bpf_replace(struct cgroup *cgrp, struct bpf_cgroup_link *l=
ink,
>> > +                    struct bpf_prog *old_prog, struct bpf_prog *new_p=
rog);
>> >  int cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
>> >                    union bpf_attr __user *uattr);
>> >
>> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> > index fad9f79bb8f1..fa944093f9fc 100644
>> > --- a/include/uapi/linux/bpf.h
>> > +++ b/include/uapi/linux/bpf.h
>> > @@ -112,6 +112,7 @@ enum bpf_cmd {
>> >       BPF_MAP_UPDATE_BATCH,
>> >       BPF_MAP_DELETE_BATCH,
>> >       BPF_LINK_CREATE,
>> > +     BPF_LINK_UPDATE,
>> >  };
>>
>> I feel like there's a BPF_LINK_QUERY operation missing here? Otherwise,
>> how is userspace supposed to discover which program is currently
>> attached to a link?
>
> Probably, but it should return not just attached BPF program, but also
> whatever target it is attached to (e.g., cgroup, ifindex, perf event
> fd, etc).

Yes, sure.

> But we'll need to design it properly, so I didn't do implementation
> yet.

Right, OK.

>> >  enum bpf_map_type {
>> > @@ -574,6 +575,17 @@ union bpf_attr {
>> >               __u32           target_fd;      /* object to attach to */
>> >               __u32           attach_type;    /* attach type */
>> >       } link_create;
>> > +
>> > +     struct { /* struct used by BPF_LINK_UPDATE command */
>> > +             __u32           link_fd;        /* link fd */
>> > +             /* new program fd to update link with */
>> > +             __u32           new_prog_fd;
>> > +             __u32           flags;          /* extra flags */
>> > +             /* expected link's program fd; is specified only if
>> > +              * BPF_F_REPLACE flag is set in flags */
>> > +             __u32           old_prog_fd;
>> > +     } link_update;
>> > +
>> >  } __attribute__((aligned(8)));
>> >
>> >  /* The description below is an attempt at providing documentation to =
eBPF
>> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
>> > index b960e8633f23..b9f4971336f3 100644
>> > --- a/kernel/bpf/cgroup.c
>> > +++ b/kernel/bpf/cgroup.c
>> > @@ -501,6 +501,83 @@ int __cgroup_bpf_attach(struct cgroup *cgrp,
>> >       return err;
>> >  }
>> >
>> > +/* Swap updated BPF program for given link in effective program array=
s across
>> > + * all descendant cgroups. This function is guaranteed to succeed.
>> > + */
>> > +static void replace_effective_prog(struct cgroup *cgrp,
>> > +                                enum bpf_attach_type type,
>> > +                                struct bpf_cgroup_link *link)
>> > +{
>> > +     struct bpf_prog_array_item *item;
>> > +     struct cgroup_subsys_state *css;
>> > +     struct bpf_prog_array *progs;
>> > +     struct bpf_prog_list *pl;
>> > +     struct list_head *head;
>> > +     struct cgroup *cg;
>> > +     int pos;
>> > +
>> > +     css_for_each_descendant_pre(css, &cgrp->self) {
>> > +             struct cgroup *desc =3D container_of(css, struct cgroup,=
 self);
>> > +
>> > +             if (percpu_ref_is_zero(&desc->bpf.refcnt))
>> > +                     continue;
>> > +
>> > +             /* found position of link in effective progs array */
>> > +             for (pos =3D 0, cg =3D desc; cg; cg =3D cgroup_parent(cg=
)) {
>> > +                     if (pos && !(cg->bpf.flags[type] & BPF_F_ALLOW_M=
ULTI))
>> > +                             continue;
>> > +
>> > +                     head =3D &cg->bpf.progs[type];
>> > +                     list_for_each_entry(pl, head, node) {
>> > +                             if (!prog_list_prog(pl))
>> > +                                     continue;
>> > +                             if (pl->link =3D=3D link)
>> > +                                     goto found;
>> > +                             pos++;
>> > +                     }
>> > +             }
>> > +found:
>> > +             BUG_ON(!cg);
>> > +             progs =3D rcu_dereference_protected(
>> > +                             desc->bpf.effective[type],
>> > +                             lockdep_is_held(&cgroup_mutex));
>> > +             item =3D &progs->items[pos];
>> > +             WRITE_ONCE(item->prog, link->link.prog);
>> > +     }
>> > +}
>> > +
>> > +/**
>> > + * __cgroup_bpf_replace() - Replace link's program and propagate the =
change
>> > + *                          to descendants
>> > + * @cgrp: The cgroup which descendants to traverse
>> > + * @link: A link for which to replace BPF program
>> > + * @type: Type of attach operation
>> > + *
>> > + * Must be called with cgroup_mutex held.
>> > + */
>> > +int __cgroup_bpf_replace(struct cgroup *cgrp, struct bpf_cgroup_link =
*link,
>> > +                      struct bpf_prog *new_prog)
>> > +{
>> > +     struct list_head *progs =3D &cgrp->bpf.progs[link->type];
>> > +     struct bpf_prog *old_prog;
>> > +     struct bpf_prog_list *pl;
>> > +     bool found =3D false;
>> > +
>> > +     list_for_each_entry(pl, progs, node) {
>> > +             if (pl->link =3D=3D link) {
>> > +                     found =3D true;
>> > +                     break;
>> > +             }
>> > +     }
>> > +     if (!found)
>> > +             return -ENOENT;
>> > +
>> > +     old_prog =3D xchg(&link->link.prog, new_prog);
>> > +     replace_effective_prog(cgrp, link->type, link);
>> > +     bpf_prog_put(old_prog);
>> > +     return 0;
>> > +}
>> > +
>> >  static struct bpf_prog_list *find_detach_entry(struct list_head *prog=
s,
>> >                                              struct bpf_prog *prog,
>> >                                              struct bpf_cgroup_link *l=
ink,
>> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>> > index f6e7d32a2632..1ff7aaa2c727 100644
>> > --- a/kernel/bpf/syscall.c
>> > +++ b/kernel/bpf/syscall.c
>> > @@ -3572,6 +3572,63 @@ static int link_create(union bpf_attr *attr)
>> >       return ret;
>> >  }
>> >
>> > +#define BPF_LINK_UPDATE_LAST_FIELD link_update.old_prog_fd
>> > +
>> > +static int link_update(union bpf_attr *attr)
>> > +{
>> > +     struct bpf_prog *old_prog =3D NULL, *new_prog;
>> > +     enum bpf_prog_type ptype;
>> > +     struct bpf_link *link;
>> > +     u32 flags;
>> > +     int ret;
>> > +
>> > +     if (CHECK_ATTR(BPF_LINK_UPDATE))
>> > +             return -EINVAL;
>> > +
>> > +     flags =3D attr->link_update.flags;
>> > +     if (flags & ~BPF_F_REPLACE)
>> > +             return -EINVAL;
>> > +
>> > +     link =3D bpf_link_get_from_fd(attr->link_update.link_fd);
>> > +     if (IS_ERR(link))
>> > +             return PTR_ERR(link);
>> > +
>> > +     new_prog =3D bpf_prog_get(attr->link_update.new_prog_fd);
>> > +     if (IS_ERR(new_prog))
>> > +             return PTR_ERR(new_prog);
>> > +
>> > +     if (flags & BPF_F_REPLACE) {
>> > +             old_prog =3D bpf_prog_get(attr->link_update.old_prog_fd);
>> > +             if (IS_ERR(old_prog)) {
>> > +                     ret =3D PTR_ERR(old_prog);
>> > +                     old_prog =3D NULL;
>> > +                     goto out_put_progs;
>> > +             }
>> > +     }
>>
>> Shouldn't the default be to require an old FD and do atomic update, but
>> provide a flag (BPF_F_CLOBBER?) to opt-in to unconditional replace
>> behaviour? Since the unconditional replace is inherently racy I don't
>> think it should be the default; in fact, I'm not sure if it should be
>> allowed at all?
>
> I don't feel strongly either way, but I expect majority of use cases
> to use non-pinned bpf_link with just FD open by an application, where
> application knows that no one else can update program from under link.
> In which case setting new BPF program won't be racy.

Ah. As you've probably noticed, my mental model is somewhat biased
towards utilities that exit after invocation, so didn't think about that :)

Still, even in the case of such a long-running application, it would
still know which fd was already attached, so it could still supply it,
even though there's no possibility of a race. Especially if we abstract
that behind the bpf_link data structure in libbpf.

-Toke

