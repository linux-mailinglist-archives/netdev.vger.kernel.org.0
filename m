Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 444B7132000
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 07:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgAGGu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 01:50:28 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37704 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgAGGu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 01:50:28 -0500
Received: by mail-lf1-f68.google.com with SMTP id b15so38092700lfc.4;
        Mon, 06 Jan 2020 22:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gGLRu/EujULvPOdtHeUTKiJhqL4e8NxjG+jiJ59KRgs=;
        b=urVe8hnvMKBduBTTNMuI7mD4RpydSQiXGs05+EjOZK59PXi3PzWHGVxbWN4VNucp5H
         qoTI2erwQcSYCnomhimK8tPT1pk7SnYKmwTWbOmpTYfC/4qlvP968LDbSfkU22WPw6Ot
         23r794pD0gi4QQ1MWMEhs0fhf67/LctYhwMjkLfeibfEPsCyCZPui/9Wltadt/Uji4yA
         RSSCCrd+O7MTHBrKq7FTg1oSrkSnCoz1ot0u0Y4NDdi2vLduLAQ6jyfJSLrhe/SCAiyz
         do2wVrRkKmG4L1VdnBCx9i8Qr4FeuejKrwlIW+1vmmmy2wk2LDAmpxMb58mDn4coOXgb
         UaSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gGLRu/EujULvPOdtHeUTKiJhqL4e8NxjG+jiJ59KRgs=;
        b=iCougFpthpLI+mDqggt+9hYMsYJgo+TM0rGr+8OoyUa74eaZrL7jC9GB+aYjFDhLhg
         vIaEQT1YrNmp6j2xvQR1WYPWp1LXe/TcIaBcIdSFvkuOt89zl4OBNglMIpiMf2Ekv0Bo
         6l2E69pYchYrFGcNMSEeA96LmtUHH/Sv3DyEHqA2tF2Pi64iG6N267RS7S8RINHGSdLz
         By3ujdgkh7/SJ7Fs4YbJGp4PESnLUyGGRSXKWXU0Tf5dYP+N6zKLsi1Tef6NIXFWEmfJ
         SfDCMoimz6/1yivamnB7zTMztIlc7UK5FHDj3DFbFQk9bojWohOOZH+ughTyJi3oyubC
         Gzmw==
X-Gm-Message-State: APjAAAW1RvmVy7NQpXsv1z3jPw4Z9C18BYQe2TAYWYFAs9+0KUhuv+1z
        tqGDWjM1gVH7qyXZqjyVrRjVeOF9mI5ye3Ss+/E=
X-Google-Smtp-Source: APXvYqzMl46Pyjk62Rn0sY34/z8PedBA97jNIEoF/k1w0o5KOoRAV6A2q/BMdauMFw1j6xW66TVM1CCZvuGGalH5dA4=
X-Received: by 2002:ac2:51a4:: with SMTP id f4mr62104449lfk.76.1578379824299;
 Mon, 06 Jan 2020 22:50:24 -0800 (PST)
MIME-Version: 1.0
References: <20191211223344.165549-1-brianvv@google.com> <20191211223344.165549-3-brianvv@google.com>
 <a2ce5033-fa75-c17b-ee97-8a7dcb67ab61@fb.com>
In-Reply-To: <a2ce5033-fa75-c17b-ee97-8a7dcb67ab61@fb.com>
From:   Brian Vazquez <brianvv.kernel@gmail.com>
Date:   Tue, 7 Jan 2020 00:50:12 -0600
Message-ID: <CABCgpaV47WD7wYG85pinv80JaNP7ZzqWM7JMnpKuJJaaadKR_w@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 02/11] bpf: add generic support for lookup and
 lookup_and_delete batch ops
To:     Yonghong Song <yhs@fb.com>
Cc:     Brian Vazquez <brianvv@google.com>,
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

On Fri, Dec 13, 2019 at 11:26 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 12/11/19 2:33 PM, Brian Vazquez wrote:
> > This commit introduces generic support for the bpf_map_lookup_batch and
> > bpf_map_lookup_and_delete_batch ops. This implementation can be used by
> > almost all the bpf maps since its core implementation is relying on the
> > existing map_get_next_key, map_lookup_elem and map_delete_elem
> > functions. The bpf syscall subcommands introduced are:
> >
> >    BPF_MAP_LOOKUP_BATCH
> >    BPF_MAP_LOOKUP_AND_DELETE_BATCH
> >
> > The UAPI attribute is:
> >
> >    struct { /* struct used by BPF_MAP_*_BATCH commands */
> >           __aligned_u64   in_batch;       /* start batch,
> >                                            * NULL to start from beginning
> >                                            */
> >           __aligned_u64   out_batch;      /* output: next start batch */
> >           __aligned_u64   keys;
> >           __aligned_u64   values;
> >           __u32           count;          /* input/output:
> >                                            * input: # of key/value
> >                                            * elements
> >                                            * output: # of filled elements
> >                                            */
> >           __u32           map_fd;
> >           __u64           elem_flags;
> >           __u64           flags;
> >    } batch;
> >
> > in_batch/out_batch are opaque values use to communicate between
> > user/kernel space, in_batch/out_batch must be of key_size length.
> >
> > To start iterating from the beginning in_batch must be null,
> > count is the # of key/value elements to retrieve. Note that the 'keys'
> > buffer must be a buffer of key_size * count size and the 'values' buffer
> > must be value_size * count, where value_size must be aligned to 8 bytes
> > by userspace if it's dealing with percpu maps. 'count' will contain the
> > number of keys/values successfully retrieved. Note that 'count' is an
> > input/output variable and it can contain a lower value after a call.
> >
> > If there's no more entries to retrieve, ENOENT will be returned. If error
> > is ENOENT, count might be > 0 in case it copied some values but there were
> > no more entries to retrieve.
> >
> > Note that if the return code is an error and not -EFAULT,
> > count indicates the number of elements successfully processed.
> >
> > Suggested-by: Stanislav Fomichev <sdf@google.com>
> > Signed-off-by: Brian Vazquez <brianvv@google.com>
> > Signed-off-by: Yonghong Song <yhs@fb.com>
> > ---
> >   include/linux/bpf.h      |  11 +++
> >   include/uapi/linux/bpf.h |  19 +++++
> >   kernel/bpf/syscall.c     | 172 +++++++++++++++++++++++++++++++++++++++
> >   3 files changed, 202 insertions(+)
> [...]
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index 2530266fa6477..708aa89fe2308 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -1206,6 +1206,120 @@ static int map_get_next_key(union bpf_attr *attr)
> >       return err;
> >   }
> >
> > +#define MAP_LOOKUP_RETRIES 3
> > +
> > +static int __generic_map_lookup_batch(struct bpf_map *map,
> > +                                   const union bpf_attr *attr,
> > +                                   union bpf_attr __user *uattr,
> > +                                   bool do_delete)
> > +{
> > +     void __user *ubatch = u64_to_user_ptr(attr->batch.in_batch);
> > +     void __user *uobatch = u64_to_user_ptr(attr->batch.out_batch);
> > +     void __user *values = u64_to_user_ptr(attr->batch.values);
> > +     void __user *keys = u64_to_user_ptr(attr->batch.keys);
> > +     void *buf, *prev_key, *key, *value;
> > +     u32 value_size, cp, max_count;
> > +     bool first_key = false;
> > +     int err, retry = MAP_LOOKUP_RETRIES;
>
> Could you try to use reverse Christmas tree style declaration here?

ACK
>
> > +
> > +     if (attr->batch.elem_flags & ~BPF_F_LOCK)
> > +             return -EINVAL;
> > +
> > +     if ((attr->batch.elem_flags & BPF_F_LOCK) &&
> > +         !map_value_has_spin_lock(map))
> > +             return -EINVAL;
> > +
> > +     value_size = bpf_map_value_size(map);
> > +
> > +     max_count = attr->batch.count;
> > +     if (!max_count)
> > +             return 0;
> > +
> > +     buf = kmalloc(map->key_size + value_size, GFP_USER | __GFP_NOWARN);
> > +     if (!buf)
> > +             return -ENOMEM;
> > +
> > +     err = -EFAULT;
> > +     first_key = false;
> > +     if (ubatch && copy_from_user(buf, ubatch, map->key_size))
> > +             goto free_buf;
> > +     key = buf;
> > +     value = key + map->key_size;
> > +     if (!ubatch) {
> > +             prev_key = NULL;
> > +             first_key = true;
> > +     }
> > +
> > +     for (cp = 0; cp < max_count;) {
> > +             if (cp || first_key) {
> > +                     rcu_read_lock();
> > +                     err = map->ops->map_get_next_key(map, prev_key, key);
> > +                     rcu_read_unlock();
> > +                     if (err)
> > +                             break;
> > +             }
> > +             err = bpf_map_copy_value(map, key, value,
> > +                                      attr->batch.elem_flags, do_delete);
> > +
> > +             if (err == -ENOENT) {
> > +                     if (retry) {
> > +                             retry--;
> > +                             continue;
> > +                     }
> > +                     err = -EINTR;
> > +                     break;
> > +             }
> > +
> > +             if (err)
> > +                     goto free_buf;
> > +
> > +             if (copy_to_user(keys + cp * map->key_size, key,
> > +                              map->key_size)) {
> > +                     err = -EFAULT;
> > +                     goto free_buf;
> > +             }
> > +             if (copy_to_user(values + cp * value_size, value, value_size)) {
> > +                     err = -EFAULT;
> > +                     goto free_buf;
> > +             }
> > +
> > +             prev_key = key;
> > +             retry = MAP_LOOKUP_RETRIES;
> > +             cp++;
> > +     }
> > +
> > +     if (!err) {
> > +             rcu_read_lock();
> > +             err = map->ops->map_get_next_key(map, prev_key, key);
> > +             rcu_read_unlock();
> > +     }
> > +
> > +     if (err)
> > +             memset(key, 0, map->key_size);
>
> So if any error happens due to above map_get_next_key() or earlier
> error, the next "batch" returned to user could be "0". What should
> user space handle this? Ultimately, the user space needs to start
> from the beginning again?
>
> What I mean is here how we could design an interface so user
> space, if no -EFAULT error, can successfully get all elements
> without duplication.
>
> One way to do here is just return -EFAULT if we cannot get
> proper next key. But maybe we could have better mechanism
> when we try to implement what user space codes will look like.

I was thinking that instead of using the "next key" as a token we
could use the last value successfully copied as the token, that way
user space code would always be able to start/retry from the last
processed entry. Do you think this would work?
>
> > +
> > +     if ((copy_to_user(&uattr->batch.count, &cp, sizeof(cp)) ||
> > +                 (copy_to_user(uobatch, key, map->key_size))))
> > +             err = -EFAULT;
> > +
> > +free_buf:
> > +     kfree(buf);
> > +     return err;
> > +}
> > +
> [...]
