Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 364BC60A2B
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 18:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbfGEQW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 12:22:57 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:35848 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728368AbfGEQW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 12:22:56 -0400
Received: by mail-io1-f66.google.com with SMTP id o9so4658822iom.3;
        Fri, 05 Jul 2019 09:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3wQNeBFGdF1nQw7LpAoGt6bfTmmmJ7AdVeXNyOERX+Y=;
        b=uvIrqEddJ5eNmcSrvDrsHeg92EsGBMqWo8tug4JmU1Xw8N3j2IPhIOPf012GHbdZuk
         D5150qmM3bhAspc2aPHscYEfetbgsnTRbtCtl0X17w7J5yYRgG1MT2DKrMG51++7jNxJ
         a152+bk8o/4fIvkGMwrifrAxPyRhv7gfNnorBBZspHc+dNhTCpVSw1PnEL+967jP2OeH
         t3BBwQFrNVH+KELjsrsIT0/YGdH64L6x9FvPxK2dXzcgmSTT/1/J8mhv2SCMyhowyaWa
         wskSMzUI86aq6cbsg006hJl5YIOy4l6cZ5pNtdDpleI+7VVrvm3knYKptuigyABEyjwX
         4RXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3wQNeBFGdF1nQw7LpAoGt6bfTmmmJ7AdVeXNyOERX+Y=;
        b=dnQJPJvCJBNa6F8GF/f5DNDO97BzIIweSeZltstkxrDLzgRmPzJrg02fpEcdi1giSb
         rYVa/teXJWi6dyL7ZzQxfN8Cv6gFeKpWhLlrcV5zMdbq+r1lt+VIbDo7ckQjSDOD5IsT
         2FYJEXiOJXv9vUdD5nE+Iv3SCpMUdFUU29dDjdS8PYe76GXm1bv3IrUoKmj1yVrdeTcO
         F+NJWrHwshVzVDlZ6Q0v3n4s75k+XLzmSwxcfCWMxLympgXeTr/94RSF0eMgMW+ZQk/y
         Y81ktUyhEF2ZBEMTRgZtJiIGt8qXLaIXBAP1eNA914QUCX8ST4IuKZBTMasKSlD9BVT4
         q5VA==
X-Gm-Message-State: APjAAAXU1L9GIW7+zO4r47VaPK/GMRAYKdEWyiPTgbNheYyaicVFXRuj
        PeUb2q50WXHW5h/E2t481B3jybsIAjeEVrFX9p8=
X-Google-Smtp-Source: APXvYqyt1RcZvgV1yxmaP1a3dEd9X5H3DDSSsTfQ2sPLmUCekConRSATkDLicdiMnbaWBStMPSswm/l90kozSsfX7H4=
X-Received: by 2002:a6b:dd18:: with SMTP id f24mr3572565ioc.97.1562343775606;
 Fri, 05 Jul 2019 09:22:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190703170118.196552-1-brianvv@google.com> <20190703170118.196552-3-brianvv@google.com>
In-Reply-To: <20190703170118.196552-3-brianvv@google.com>
From:   Y Song <ys114321@gmail.com>
Date:   Fri, 5 Jul 2019 09:22:19 -0700
Message-ID: <CAH3MdRU505Er44m460c7y5nxtZxmDmVY4jDrWOYt2=OdP2d5Ow@mail.gmail.com>
Subject: Re: [PATCH bpf-next RFC v3 2/6] bpf: add BPF_MAP_DUMP command to dump
 more than one entry per call
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 3, 2019 at 10:03 AM Brian Vazquez <brianvv@google.com> wrote:
>
> This introduces a new command to retrieve a variable number of entries
> from a bpf map wrapping the existing bpf methods:
> map_get_next_key and map_lookup_elem
>
> To start dumping the map from the beginning you must specify NULL as
> the prev_key.
>
> The new API returns 0 when it successfully copied all the elements
> requested or it copied less because there weren't more elements to
> retrieved (err == -ENOENT). In last scenario err will be masked to 0.
>
> On a successful call buf and buf_len will contain correct data and in
> case prev_key was provided (not for the first walk, since prev_key is
> NULL) it will contain the last_key copied into the buf which will simplify
> next call.
>
> Only when it can't find a single element it will return -ENOENT meaning
> that the map has been entirely walked. When an error is return buf,
> buf_len and prev_key shouldn't be read nor used.
>
> Because maps can be called from userspace and kernel code, this function
> can have a scenario where the next_key was found but by the time we
> try to retrieve the value the element is not there, in this case the
> function continues and tries to get a new next_key value, skipping the
> deleted key. If at some point the function find itself trap in a loop,
> it will return -EINTR.
>
> The function will try to fit as much as possible in the buf provided and
> will return -EINVAL if buf_len is smaller than elem_size.
>
> QUEUE and STACK maps are not supported.
>
> Note that map_dump doesn't guarantee that reading the entire table is
> consistent since this function is always racing with kernel and user code
> but the same behaviour is found when the entire table is walked using
> the current interfaces: map_get_next_key + map_lookup_elem.
> It is also important to note that when a locked map the lock is grabbed for
> 1 entry at the time, meaning that the buf returned might or might not be
> consistent.

First, thanks for the RFC. I do think there are use cases where
batch dumping helps.
Some comments below.

>
> Suggested-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> ---
>  include/uapi/linux/bpf.h |   9 +++
>  kernel/bpf/syscall.c     | 118 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 127 insertions(+)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index cffea1826a1f..cc589570a639 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -106,6 +106,7 @@ enum bpf_cmd {
>         BPF_TASK_FD_QUERY,
>         BPF_MAP_LOOKUP_AND_DELETE_ELEM,
>         BPF_MAP_FREEZE,
> +       BPF_MAP_DUMP,
>  };
>
>  enum bpf_map_type {
> @@ -388,6 +389,14 @@ union bpf_attr {
>                 __u64           flags;
>         };
>
> +       struct { /* struct used by BPF_MAP_DUMP command */
> +               __u32           map_fd;
> +               __aligned_u64   prev_key;
> +               __aligned_u64   buf;
> +               __aligned_u64   buf_len; /* input/output: len of buf */
> +               __u64           flags;
> +       } dump;

Maybe you can swap map_fd and flags?
This way, you won't have hole right after map_fd?

> +
>         struct { /* anonymous struct used by BPF_PROG_LOAD command */
>                 __u32           prog_type;      /* one of enum bpf_prog_type */
>                 __u32           insn_cnt;
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index d200d2837ade..78d55463fc76 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1097,6 +1097,121 @@ static int map_get_next_key(union bpf_attr *attr)
>         return err;
>  }
>
> +/* last field in 'union bpf_attr' used by this command */
> +#define BPF_MAP_DUMP_LAST_FIELD dump.buf_len
> +
> +static int map_dump(union bpf_attr *attr)
> +{
> +       void __user *ukey = u64_to_user_ptr(attr->dump.prev_key);
> +       void __user *ubuf = u64_to_user_ptr(attr->dump.buf);
> +       u32 __user *ubuf_len = u64_to_user_ptr(attr->dump.buf_len);
> +       int ufd = attr->dump.map_fd;
> +       struct bpf_map *map;
> +       void *buf, *prev_key, *key, *value;
> +       u32 value_size, elem_size, buf_len, cp_len;
> +       struct fd f;
> +       int err;
> +       bool first_key = false;
> +
> +       if (CHECK_ATTR(BPF_MAP_DUMP))
> +               return -EINVAL;
> +
> +       attr->flags = 0;

Why do you want attr->flags? This is to modify anonumous struct used by
BPF_MAP_*_ELEM commands.

> +       if (attr->dump.flags & ~BPF_F_LOCK)
> +               return -EINVAL;
> +
> +       f = fdget(ufd);
> +       map = __bpf_map_get(f);
> +       if (IS_ERR(map))
> +               return PTR_ERR(map);
> +       if (!(map_get_sys_perms(map, f) & FMODE_CAN_READ)) {
> +               err = -EPERM;
> +               goto err_put;
> +       }
> +
> +       if ((attr->dump.flags & BPF_F_LOCK) &&
> +           !map_value_has_spin_lock(map)) {
> +               err = -EINVAL;
> +               goto err_put;
> +       }
> +
> +       if (map->map_type == BPF_MAP_TYPE_QUEUE ||
> +           map->map_type == BPF_MAP_TYPE_STACK) {
> +               err = -ENOTSUPP;
> +               goto err_put;
> +       }
> +
> +       value_size = bpf_map_value_size(map);
> +
> +       err = get_user(buf_len, ubuf_len);
> +       if (err)
> +               goto err_put;
> +
> +       elem_size = map->key_size + value_size;
> +       if (buf_len < elem_size) {
> +               err = -EINVAL;
> +               goto err_put;
> +       }
> +
> +       if (ukey) {
> +               prev_key = __bpf_copy_key(ukey, map->key_size);
> +               if (IS_ERR(prev_key)) {
> +                       err = PTR_ERR(prev_key);
> +                       goto err_put;
> +               }
> +       } else {
> +               prev_key = NULL;
> +               first_key = true;
> +       }
> +
> +       err = -ENOMEM;
> +       buf = kmalloc(elem_size, GFP_USER | __GFP_NOWARN);
> +       if (!buf)
> +               goto err_put;
> +
> +       key = buf;
> +       value = key + map->key_size;
> +       for (cp_len = 0; cp_len + elem_size <= buf_len;) {
> +               if (signal_pending(current)) {
> +                       err = -EINTR;
> +                       break;
> +               }
> +
> +               rcu_read_lock();
> +               err = map->ops->map_get_next_key(map, prev_key, key);
> +               rcu_read_unlock();
> +
> +               if (err)
> +                       break;
> +
> +               err = bpf_map_copy_value(map, key, value, attr->dump.flags);
> +
> +               if (err == -ENOENT)
> +                       continue;
> +               if (err)
> +                       goto free_buf;
> +
> +               if (copy_to_user(ubuf + cp_len, buf, elem_size)) {
> +                       err = -EFAULT;
> +                       goto free_buf;
> +               }
> +
> +               prev_key = key;
> +               cp_len += elem_size;
> +       }
> +
> +       if (err == -ENOENT && cp_len)
> +               err = 0;
> +       if (!err && (copy_to_user(ubuf_len, &cp_len, sizeof(cp_len)) ||
> +                   (!first_key && copy_to_user(ukey, key, map->key_size))))
> +               err = -EFAULT;
> +free_buf:
> +       kfree(buf);
> +err_put:
> +       fdput(f);
> +       return err;
> +}
> +
>  #define BPF_MAP_LOOKUP_AND_DELETE_ELEM_LAST_FIELD value
>
>  static int map_lookup_and_delete_elem(union bpf_attr *attr)
> @@ -2910,6 +3025,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
>         case BPF_MAP_LOOKUP_AND_DELETE_ELEM:
>                 err = map_lookup_and_delete_elem(&attr);
>                 break;
> +       case BPF_MAP_DUMP:
> +               err = map_dump(&attr);
> +               break;

In bcc, we have use cases like this. At a certain time interval (e.g.,
every 2 seconds),
we get all key/value pairs for a map, we format and print out map
key/values on the screen,
and then delete all key/value pairs we retrieved earlier.

Currently, bpf_get_next_key() is used to get all key/value pairs, and
deletion also happened
at each key level.

Your batch dump command should help retrieving map key/value pairs.
What do you think deletions of those just retrieved map entries?
With an additional flag and fold into BPF_MAP_DUMP?
or implement a new BPF_MAP_DUMP_AND_DELETE?

I mentioned this so that we can start discussion now.
You do not need to implement batch deletion part, but let us
have a design extensible for that.

Thanks.

>         default:
>                 err = -EINVAL;
>                 break;
> --
> 2.22.0.410.gd8fdbe21b5-goog
>
