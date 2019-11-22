Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A244106603
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbfKVG1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:27:39 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43468 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727644AbfKVFuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 00:50:23 -0500
Received: by mail-qk1-f195.google.com with SMTP id p14so5267681qkm.10
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 21:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BInuDtEmn83Yr4/vXxtYKLbzSe86tKPQbTdHBllE85w=;
        b=c+eTSMnFlrhvjIf/tSqeW8boBOtNQwFu8k8iOZQ+tumhHPubnrAJCw8UL0WD3NNx4M
         Hn4p9tYcC79bfzOiFMviOpu7ZRPPSu8wrVCRW0N+ebNZuwqw+ZkRa+QEXyKQFBIPtJBN
         6jbxFp8UhsPXcO6Shr12Wg+x4jERK+JPFqU4awF3PDRXvwXI+UAt8Pj35NPlWHViIcvY
         U6bVdHclWTpG5WlD3jGMhqd3cnTGwSGhlVC9mnA8xK0OASPyrBx/JGOG/45IiJ4L32xo
         P6Rbb28M61IXP26hN5ccuPi8JFmnwRrGlXay+BrWYv1+BtZq/6X/3X5lccxE5MYS3KtY
         UQFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BInuDtEmn83Yr4/vXxtYKLbzSe86tKPQbTdHBllE85w=;
        b=bcHJoVS4JeQ18JD7Gw61W6k8FRVeoCbwdeeqtfIXhJTAGOz4B0CP2L9avqfm+v9DGf
         lHWSIiMepOal+dIfCMz178f1f/y9bj1YyrPu4DMUMaf2KeUU14YAYiu7QUNpNn488jdI
         uPK232ZDyHz6KGWIlte3ANCDmi4m9z60mtJD3aOpcWwDhT25oPPLmntq6sRrrNC349Hf
         nhUMVXzedzxYzulKY/F3HTEy/my3rMVdey19HQyW+LoxHknrrngxU5vW8o+xFiViQEe1
         DdQjNe8fwu7a0zvy5UdIxTE2agsra6m6vct/g9StrNA+Efn7I2DodKAuV4neEuStIMBV
         h5PQ==
X-Gm-Message-State: APjAAAV1bK1UNcJrfkhiYHrvbJiQaewu9q/szt6OiCiCnqZomWJfSw7v
        rDF828zJZ43KOhb58D5ZgYo5agFoCCwoNCvv/tKUmA==
X-Google-Smtp-Source: APXvYqznsA5jIsZlc4NPMuMOfMurPT370FUxVHC2iNOatV/+3itWvFRthszndatNYoLFCscDOGRhtoLBbYmZwCUGl8M=
X-Received: by 2002:ae9:f50a:: with SMTP id o10mr11402656qkg.143.1574401821716;
 Thu, 21 Nov 2019 21:50:21 -0800 (PST)
MIME-Version: 1.0
References: <20191119193036.92831-1-brianvv@google.com> <20191119193036.92831-4-brianvv@google.com>
 <47ebff4c-1cb6-c136-b4a8-19dfe47a721f@fb.com>
In-Reply-To: <47ebff4c-1cb6-c136-b4a8-19dfe47a721f@fb.com>
From:   Brian Vazquez <brianvv@google.com>
Date:   Thu, 21 Nov 2019 21:50:10 -0800
Message-ID: <CAMzD94SW6vr4V69mL3wNdLb9-O0y_z_Q6KehwuRw81WQ414bqA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/9] bpf: add generic support for update and
 delete batch ops
To:     Yonghong Song <yhs@fb.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ACK to all the observations, will fix in the next version. There are
just 2 things might be correct, PTAL.

On Thu, Nov 21, 2019 at 10:00 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 11/19/19 11:30 AM, Brian Vazquez wrote:
> > This commit adds generic support for update and delete batch ops that
> > can be used for almost all the bpf maps. These commands share the same
> > UAPI attr that lookup and lookup_and_delete batch ops use and the
> > syscall commands are:
> >
> >    BPF_MAP_UPDATE_BATCH
> >    BPF_MAP_DELETE_BATCH
> >
> > The main difference between update/delete and lookup/lookup_and_delete
> > batch ops is that for update/delete keys/values must be specified for
> > userspace and because of that, neither in_batch nor out_batch are used.
> >
> > Suggested-by: Stanislav Fomichev <sdf@google.com>
> > Signed-off-by: Brian Vazquez <brianvv@google.com>
> > Signed-off-by: Yonghong Song <yhs@fb.com>
> > ---
> >   include/linux/bpf.h      |  10 ++++
> >   include/uapi/linux/bpf.h |   2 +
> >   kernel/bpf/syscall.c     | 126 ++++++++++++++++++++++++++++++++++++++-
> >   3 files changed, 137 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 767a823dbac74..96a19e1fd2b5b 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -46,6 +46,10 @@ struct bpf_map_ops {
> >       int (*map_lookup_and_delete_batch)(struct bpf_map *map,
> >                                          const union bpf_attr *attr,
> >                                          union bpf_attr __user *uattr);
> > +     int (*map_update_batch)(struct bpf_map *map, const union bpf_attr *attr,
> > +                             union bpf_attr __user *uattr);
> > +     int (*map_delete_batch)(struct bpf_map *map, const union bpf_attr *attr,
> > +                             union bpf_attr __user *uattr);
> >
> >       /* funcs callable from userspace and from eBPF programs */
> >       void *(*map_lookup_elem)(struct bpf_map *map, void *key);
> > @@ -808,6 +812,12 @@ int  generic_map_lookup_batch(struct bpf_map *map,
> >   int  generic_map_lookup_and_delete_batch(struct bpf_map *map,
> >                                        const union bpf_attr *attr,
> >                                        union bpf_attr __user *uattr);
> > +int  generic_map_update_batch(struct bpf_map *map,
> > +                           const union bpf_attr *attr,
> > +                           union bpf_attr __user *uattr);
> > +int  generic_map_delete_batch(struct bpf_map *map,
> > +                           const union bpf_attr *attr,
> > +                           union bpf_attr __user *uattr);
> >
> >   extern int sysctl_unprivileged_bpf_disabled;
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index e60b7b7cda61a..0f6ff0c4d79dd 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -109,6 +109,8 @@ enum bpf_cmd {
> >       BPF_BTF_GET_NEXT_ID,
> >       BPF_MAP_LOOKUP_BATCH,
> >       BPF_MAP_LOOKUP_AND_DELETE_BATCH,
> > +     BPF_MAP_UPDATE_BATCH,
> > +     BPF_MAP_DELETE_BATCH,
> >   };
> >
> >   enum bpf_map_type {
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index d0d3d0e0eaca4..06e1bcf40fb8d 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -1127,6 +1127,120 @@ static int map_get_next_key(union bpf_attr *attr)
> >       return err;
> >   }
> >
> > +int generic_map_delete_batch(struct bpf_map *map,
> > +                          const union bpf_attr *attr,
> > +                          union bpf_attr __user *uattr)
> > +{
> > +     void __user *keys = u64_to_user_ptr(attr->batch.keys);
> > +     int ufd = attr->map_fd;
> > +     u32 cp, max_count;
> > +     struct fd f;
> > +     void *key;
> > +     int err;
> > +
> > +     f = fdget(ufd);
> > +     if (attr->batch.elem_flags & ~BPF_F_LOCK)
> > +             return -EINVAL;
> > +
> > +     if ((attr->batch.elem_flags & BPF_F_LOCK) &&
> > +         !map_value_has_spin_lock(map)) {
> > +             err = -EINVAL;
> > +             goto err_put;
>
> Just return -EINVAL?
>
> > +     }
> > +
> > +     max_count = attr->batch.count;
> > +     if (!max_count)
> > +             return 0;
> > +
> > +     err = -ENOMEM;
>
> Why initialize err to -ENOMEM? Maybe just err = 0.
>
> > +     for (cp = 0; cp < max_count; cp++) {
> > +             key = __bpf_copy_key(keys + cp * map->key_size, map->key_size);
> > +             if (IS_ERR(key)) {
> > +                     err = PTR_ERR(key);
> > +                     break;
> > +             }
> > +
> > +             if (err)
> > +                     break;
>
> The above is incorrect, esp. if you assign err initial value to -ENOMEM.
> The above ` if (err) break; ` is not really needed. If there is error,
> you already break in the above.
> If map->key_size is not 0, the return value 'key' cannot be NULL pointer.
>
> > +             if (bpf_map_is_dev_bound(map)) {
> > +                     err = bpf_map_offload_delete_elem(map, key);
> > +                     break;
> > +             }
> > +
> > +             preempt_disable();
> > +             __this_cpu_inc(bpf_prog_active);
> > +             rcu_read_lock();
> > +             err = map->ops->map_delete_elem(map, key);
> > +             rcu_read_unlock();
> > +             __this_cpu_dec(bpf_prog_active);
> > +             preempt_enable();
> > +             maybe_wait_bpf_programs(map);
> > +             if (err)
> > +                     break;
> > +     }
> > +     if (copy_to_user(&uattr->batch.count, &cp, sizeof(cp)))
> > +             err = -EFAULT;
>
> If previous err = -EFAULT, even if copy_to_user() succeeded,
> return value will be -EFAULT, so uattr->batch.count cannot be
> trusted. So may be do
>     if (err != -EFAULT && copy_to_user(...))
>        err = -EFAULT
> ?
> There are several other places like this.

I think whatever the err is, cp contains the right amount of entries
correctly updated/deleted and the idea is that you should always try
to copy that value to batch.count, and if that fails when uattr was
created by libbpf, everything was set to  0.

>
> > +err_put:
>
> You don't need err_put label in the above.
>
> > +     return err;
> > +}
> > +int generic_map_update_batch(struct bpf_map *map,
> > +                          const union bpf_attr *attr,
> > +                          union bpf_attr __user *uattr)
> > +{
> > +     void __user *values = u64_to_user_ptr(attr->batch.values);
> > +     void __user *keys = u64_to_user_ptr(attr->batch.keys);
> > +     u32 value_size, cp, max_count;
> > +     int ufd = attr->map_fd;
> > +     void *key, *value;
> > +     struct fd f;
> > +     int err;
> > +
> > +     f = fdget(ufd);
> > +     if (attr->batch.elem_flags & ~BPF_F_LOCK)
> > +             return -EINVAL;
> > +
> > +     if ((attr->batch.elem_flags & BPF_F_LOCK) &&
> > +         !map_value_has_spin_lock(map)) {
> > +             err = -EINVAL;
> > +             goto err_put;
>
> Directly return -EINVAL?
>
> > +     }
> > +
> > +     value_size = bpf_map_value_size(map);
> > +
> > +     max_count = attr->batch.count;
> > +     if (!max_count)
> > +             return 0;
> > +
> > +     err = -ENOMEM;
> > +     value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
> > +     if (!value)
> > +             goto err_put;
>
> Directly return -ENOMEM?
>
> > +
> > +     for (cp = 0; cp < max_count; cp++) {
> > +             key = __bpf_copy_key(keys + cp * map->key_size, map->key_size);
>
> Do you need to free 'key' after its use?
>
> > +             if (IS_ERR(key)) {
> > +                     err = PTR_ERR(key);
> > +                     break;
> > +             }
> > +             err = -EFAULT;
> > +             if (copy_from_user(value, values + cp * value_size, value_size))
> > +                     break;
> > +
> > +             err = bpf_map_update_value(map, f, key, value,
> > +                                        attr->batch.elem_flags);
> > +
> > +             if (err)
> > +                     break;
> > +     }
> > +
> > +     if (copy_to_user(&uattr->batch.count, &cp, sizeof(cp)))
> > +             err = -EFAULT;
>
> Similar to the above comment, if err already -EFAULT, no need
> to do copy_to_user().
>
> > +
> > +     kfree(value);
> > +err_put:
>
> err_put label is not needed.
>
> > +     return err;
> > +}
> > +
> >   static int __generic_map_lookup_batch(struct bpf_map *map,
> >                                     const union bpf_attr *attr,
> >                                     union bpf_attr __user *uattr,
> > @@ -3117,8 +3231,12 @@ static int bpf_map_do_batch(const union bpf_attr *attr,
> >
> >       if (cmd == BPF_MAP_LOOKUP_BATCH)
> >               BPF_DO_BATCH(map->ops->map_lookup_batch);
> > -     else
> > +     else if (cmd == BPF_MAP_LOOKUP_AND_DELETE_BATCH)
> >               BPF_DO_BATCH(map->ops->map_lookup_and_delete_batch);
> > +     else if (cmd == BPF_MAP_UPDATE_BATCH)
> > +             BPF_DO_BATCH(map->ops->map_update_batch);
> > +     else
> > +             BPF_DO_BATCH(map->ops->map_delete_batch);
>
> Also need to check map_get_sys_perms() permissions for these two new
> commands. Both delete and update needs FMODE_CAN_WRITE permission.
>
I also got confused for a moment, the check is correct since is using
'!=' not '=='
if (cmd != BPF_MAP_LOOKUP_BATCH &&
            !(map_get_sys_perms(map, f) & FMODE_CAN_WRITE)) {

so basically that means that cmd is update,delete or lookup_and_delete
so we check map_get_sys_perms.

> >
> >   err_put:
> >       fdput(f);
> > @@ -3229,6 +3347,12 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
> >               err = bpf_map_do_batch(&attr, uattr,
> >                                      BPF_MAP_LOOKUP_AND_DELETE_BATCH);
> >               break;
> > +     case BPF_MAP_UPDATE_BATCH:
> > +             err = bpf_map_do_batch(&attr, uattr, BPF_MAP_UPDATE_BATCH);
> > +             break;
> > +     case BPF_MAP_DELETE_BATCH:
> > +             err = bpf_map_do_batch(&attr, uattr, BPF_MAP_DELETE_BATCH);
> > +             break;
> >       default:
> >               err = -EINVAL;
> >               break;
> >
