Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61E08105C1C
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 22:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfKUVgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 16:36:46 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42219 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbfKUVgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 16:36:46 -0500
Received: by mail-qt1-f196.google.com with SMTP id t20so5382968qtn.9
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 13:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZXH/qSaia/mtRLdnPBEb9WQPrUWDOjWQAMBCnXB/vUw=;
        b=ZnaLPGPSDZhOWgJOm+5wJhr6bYh1sg+f4cUQFnP73ZzRuZJ6YYiLlXXV7vH2lp2DaD
         VmEpvWp49Me4Wcqe8k0f04+BPOCNHtAZkfiCVDIOquO2SdkeLiKSIi9MlHP/TWYuu2Pw
         LWJSB9tidxBsJ9lTffpfnDWjQfXGGJVu34VPh1ebJCGI6sBM5JCMc0tr20sI11AouWZG
         lQbdCWDAP+nuwA0Kj/R8Vbgr9PuuvcjEEdpRxFeWW0E/VuXUd8YUHLl1h3hX9bPuOWDC
         8p+cZUBzFfM2QdpsQzLw+1d0ZtNT3DVnv7y0FGzgMyAExHRNOCKL+aC73i9w9NCsnQm+
         rOMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZXH/qSaia/mtRLdnPBEb9WQPrUWDOjWQAMBCnXB/vUw=;
        b=dBoiqpNMXBwfsX4oBjb9tFHanOEsi/y0ETH7PGq1InJXZ40VpsyItlX107dq5a4Iuo
         z9nQeroj9sdfUYMHv6rcxkYTwTY7LhCQ9rdsJyDMySI1hzNqhd1c6Gvs357oPfApRqmD
         v7SSbJQyuPG6M8cKDiRgG4LkM3o4RHoJ6bZ3H9xDuQ3jXKznEDsPCoUU0Ix4XaiNbFh7
         CjK9SVrqqoaSp7Vrmd0wAwpnZ0+O++bHLga+CCIlTzmVrrBoMMIgbtN5lzG812rlN3zf
         21rn9ImUDxd25lTxnORBSX+9j63nmKtX8IKCUPkQF2+v44Bsxnz+pAy/2/ggN0xYLE/e
         KQtg==
X-Gm-Message-State: APjAAAVAOorYk8mVU75D0yNlwQyP33CQyZZN9GoYYTDbPUoMqF0KlA9M
        STg3JdyNN8GrSnb09+p4bBBbWBka+FzN0SAMOksOug==
X-Google-Smtp-Source: APXvYqwCEWsk+yQF5Aykpihy5xSsrZK+aZL23vsQZD7o/EIuD5IdI269YxEVt21icfYqz+mHdWs1I5+JOLn5uSGYdIg=
X-Received: by 2002:ac8:1e13:: with SMTP id n19mr4815349qtl.384.1574372204088;
 Thu, 21 Nov 2019 13:36:44 -0800 (PST)
MIME-Version: 1.0
References: <20191119193036.92831-1-brianvv@google.com> <20191119193036.92831-3-brianvv@google.com>
 <de05c3f2-5b70-b9af-445c-9cf43b55737c@fb.com>
In-Reply-To: <de05c3f2-5b70-b9af-445c-9cf43b55737c@fb.com>
From:   Brian Vazquez <brianvv@google.com>
Date:   Thu, 21 Nov 2019 13:36:33 -0800
Message-ID: <CAMzD94TfpQaFN=7cQR9kmHun0gZNF2oMwEJu7aZMYhsYhvgRDg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/9] bpf: add generic support for lookup and
 lookup_and_delete batch ops
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

Hi Yonghong,
thanks for reviewing the patch, I will fix all the direct returns and
small fixes in next version.

On Thu, Nov 21, 2019 at 9:36 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 11/19/19 11:30 AM, Brian Vazquez wrote:
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
> >   kernel/bpf/syscall.c     | 176 +++++++++++++++++++++++++++++++++++++++
> >   3 files changed, 206 insertions(+)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 5b81cde47314e..767a823dbac74 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -41,6 +41,11 @@ struct bpf_map_ops {
> >       int (*map_get_next_key)(struct bpf_map *map, void *key, void *next_key);
> >       void (*map_release_uref)(struct bpf_map *map);
> >       void *(*map_lookup_elem_sys_only)(struct bpf_map *map, void *key);
> > +     int (*map_lookup_batch)(struct bpf_map *map, const union bpf_attr *attr,
> > +                             union bpf_attr __user *uattr);
> > +     int (*map_lookup_and_delete_batch)(struct bpf_map *map,
> > +                                        const union bpf_attr *attr,
> > +                                        union bpf_attr __user *uattr);
> >
> >       /* funcs callable from userspace and from eBPF programs */
> >       void *(*map_lookup_elem)(struct bpf_map *map, void *key);
> > @@ -797,6 +802,12 @@ void bpf_map_charge_move(struct bpf_map_memory *dst,
> >   void *bpf_map_area_alloc(size_t size, int numa_node);
> >   void bpf_map_area_free(void *base);
> >   void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr);
> > +int  generic_map_lookup_batch(struct bpf_map *map,
> > +                           const union bpf_attr *attr,
> > +                           union bpf_attr __user *uattr);
> > +int  generic_map_lookup_and_delete_batch(struct bpf_map *map,
> > +                                      const union bpf_attr *attr,
> > +                                      union bpf_attr __user *uattr);
> >
> >   extern int sysctl_unprivileged_bpf_disabled;
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 4842a134b202a..e60b7b7cda61a 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -107,6 +107,8 @@ enum bpf_cmd {
> >       BPF_MAP_LOOKUP_AND_DELETE_ELEM,
> >       BPF_MAP_FREEZE,
> >       BPF_BTF_GET_NEXT_ID,
> > +     BPF_MAP_LOOKUP_BATCH,
> > +     BPF_MAP_LOOKUP_AND_DELETE_BATCH,
> >   };
> >
> >   enum bpf_map_type {
> > @@ -400,6 +402,23 @@ union bpf_attr {
> >               __u64           flags;
> >       };
> >
> > +     struct { /* struct used by BPF_MAP_*_BATCH commands */
> > +             __aligned_u64   in_batch;       /* start batch,
> > +                                              * NULL to start from beginning
> > +                                              */
> > +             __aligned_u64   out_batch;      /* output: next start batch */
> > +             __aligned_u64   keys;
> > +             __aligned_u64   values;
> > +             __u32           count;          /* input/output:
> > +                                              * input: # of key/value
> > +                                              * elements
> > +                                              * output: # of filled elements
> > +                                              */
> > +             __u32           map_fd;
> > +             __u64           elem_flags;
> > +             __u64           flags;
> > +     } batch;
> > +
> >       struct { /* anonymous struct used by BPF_PROG_LOAD command */
> >               __u32           prog_type;      /* one of enum bpf_prog_type */
> >               __u32           insn_cnt;
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index cc714c9d5b4cc..d0d3d0e0eaca4 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -1127,6 +1127,124 @@ static int map_get_next_key(union bpf_attr *attr)
> >       return err;
> >   }
> >
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
> > +     int err, retry = 3;
> > +
> > +     if (attr->batch.elem_flags & ~BPF_F_LOCK)
> > +             return -EINVAL;
> > +
> > +     if ((attr->batch.elem_flags & BPF_F_LOCK) &&
> > +         !map_value_has_spin_lock(map)) {
> > +             err = -EINVAL;
> > +             goto err_put;
> > +     }
>
> Direct return -EINVAL?
>
> > +
> > +     if (map->map_type == BPF_MAP_TYPE_QUEUE ||
> > +         map->map_type == BPF_MAP_TYPE_STACK) {
> > +             err = -ENOTSUPP;
> > +             goto err_put;
> > +     }
>
> Direct return -ENOTSUPP?
>
> > +
> > +     value_size = bpf_map_value_size(map);
> > +
> > +     max_count = attr->batch.count;
> > +     if (!max_count)
> > +             return 0;
> > +
> > +     err = -ENOMEM;
> > +     buf = kmalloc(map->key_size + value_size, GFP_USER | __GFP_NOWARN);
> > +     if (!buf)
> > +             goto err_put;
>
> Direct return -ENOMEM?
>
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
> > +
> One extra line.
>
> > +     for (cp = 0; cp < max_count; cp++) {
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
>
> What is the 'retry' semantics here? After 'continue', cp++ is executed.

Good catch, I'll move cp++ to a proper place. retry is used to prevent
the cases where the map is doing many concurrent additions and
deletions, this could result in map_get_next_key succeeding but
bpf_map_copy_value failing, in which case I think it'd be better to
try and find a next elem, but we don't want to do this for more than 3
times.

>
> > +                             continue;
> > +                     }
> > +                     err = -EINTR;
>
> Why returning -EINTR?

I thought that this is the err more appropriate for the behaviour I
describe above. Should I handle that case? WDYT?


>
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
> > +             retry = 3;
> > +     }
> > +     if (!err) {
> > +             rcu_read_lock();
> > +             err = map->ops->map_get_next_key(map, prev_key, key);
>
> if err != 0, the 'key' will be invalid and it cannot be used by below
> copy_to_user.
>
> > +             rcu_read_unlock();
> > +     } > +
> > +     if ((copy_to_user(&uattr->batch.count, &cp, sizeof(cp)) ||
>
> The 'cp' may not be accurate if 'retry' is triggered in the above.
>
> > +                 (copy_to_user(uobatch, key, map->key_size))))
> > +             err = -EFAULT;
> > +
> > +free_buf:
> > +     kfree(buf);
> > +err_put:
>
> err_put can be removed.
>
> > +     return err;
> > +}
> > +
> > +int generic_map_lookup_batch(struct bpf_map *map,
> > +                          const union bpf_attr *attr,
> > +                          union bpf_attr __user *uattr)
> > +{
> > +     return __generic_map_lookup_batch(map, attr, uattr, false);
> > +}
> > +
> > +int generic_map_lookup_and_delete_batch(struct bpf_map *map,
> > +                                     const union bpf_attr *attr,
> > +                                     union bpf_attr __user *uattr)
> > +{
> > +     return __generic_map_lookup_batch(map, attr, uattr, true);
> > +}
> > +
> >   #define BPF_MAP_LOOKUP_AND_DELETE_ELEM_LAST_FIELD value
> >
> >   static int map_lookup_and_delete_elem(union bpf_attr *attr)
> > @@ -2956,6 +3074,57 @@ static int bpf_task_fd_query(const union bpf_attr *attr,
> >       return err;
> >   }
> >
> > +#define BPF_MAP_BATCH_LAST_FIELD batch.flags
> > +
> > +#define BPF_DO_BATCH(fn)                     \
> > +     do {                                    \
> > +             if (!fn) {                      \
> > +                     err = -ENOTSUPP;        \
> > +                     goto err_put;           \
> > +             }                               \
> > +             err = fn(map, attr, uattr);     \
> > +     } while (0)
> > +
> > +static int bpf_map_do_batch(const union bpf_attr *attr,
> > +                         union bpf_attr __user *uattr,
> > +                         int cmd)
> > +{
> > +     struct bpf_map *map;
> > +     int err, ufd;
> > +     struct fd f;
> > +
> > +     if (CHECK_ATTR(BPF_MAP_BATCH))
> > +             return -EINVAL;
> > +
> > +     ufd = attr->batch.map_fd;
> > +     f = fdget(ufd);
> > +     map = __bpf_map_get(f);
> > +     if (IS_ERR(map))
> > +             return PTR_ERR(map);
> > +
> > +     if ((cmd == BPF_MAP_LOOKUP_BATCH ||
> > +          cmd == BPF_MAP_LOOKUP_AND_DELETE_BATCH) &&
> > +         !(map_get_sys_perms(map, f) & FMODE_CAN_READ)) {
> > +             err = -EPERM;
> > +             goto err_put;
> > +     }
> > +
> > +     if (cmd != BPF_MAP_LOOKUP_BATCH &&
>
> Here should be BPF_MAP_LOOKUP_AND_DELETE_BATCH.
> BPF_MAP_LOOKUP_BATCH does not need FMODE_CAN_WRITE.

ACK.
>
> > +         !(map_get_sys_perms(map, f) & FMODE_CAN_WRITE)) {
> > +             err = -EPERM;
> > +             goto err_put;
> > +     }
> > +
> > +     if (cmd == BPF_MAP_LOOKUP_BATCH)
> > +             BPF_DO_BATCH(map->ops->map_lookup_batch);
> > +     else
> > +             BPF_DO_BATCH(map->ops->map_lookup_and_delete_batch);
> > +
> > +err_put:
> > +     fdput(f);
> > +     return err;
> > +}
> > +
> >   SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
> >   {
> >       union bpf_attr attr = {};
> > @@ -3053,6 +3222,13 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
> >       case BPF_MAP_LOOKUP_AND_DELETE_ELEM:
> >               err = map_lookup_and_delete_elem(&attr);
> >               break;
> > +     case BPF_MAP_LOOKUP_BATCH:
> > +             err = bpf_map_do_batch(&attr, uattr, BPF_MAP_LOOKUP_BATCH);
> > +             break;
> > +     case BPF_MAP_LOOKUP_AND_DELETE_BATCH:
> > +             err = bpf_map_do_batch(&attr, uattr,
> > +                                    BPF_MAP_LOOKUP_AND_DELETE_BATCH);
> > +             break;
> >       default:
> >               err = -EINVAL;
> >               break;
> >
