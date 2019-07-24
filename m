Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 033D1740F3
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 23:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbfGXVkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 17:40:20 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38613 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfGXVkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 17:40:20 -0400
Received: by mail-qt1-f194.google.com with SMTP id n11so47045298qtl.5;
        Wed, 24 Jul 2019 14:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ur7nHuJpsqMgpd23Fe0eBpH79MeDuc3XSn4p7DfA0u0=;
        b=F/w7zju1ZEejvHfeOtN1DdSs/z7P66tSvOlM4gcXbOe+tiUEJgKHYxZTyyRgEdGvpc
         L9cKon/zZ70wtHdwV7fhEK2x9wLYt4QvLK39uFm9J3vs+w4Vx52VS4DjgUaTOIKTsvCD
         79G8/Zh2pV6TFJQpbcA2DE98hfcf0Xtr2Ip47pvCr/uM6ja8o1dHA8T83bKp87ZA0C3d
         TtPbJqhxJlvyazFlkjpiWs46hHiIA3iHmgmqGpULw5+kuuGcYDCoYI27jvKM0Gd8wAIO
         8Q3e2TCPbRgH0RQlDHg0oZWexxzhMHx1dCOhBugcS15l8PRDAEZqtfOMW0d1xFDGG9rR
         545Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ur7nHuJpsqMgpd23Fe0eBpH79MeDuc3XSn4p7DfA0u0=;
        b=HQkB3fGPqVC0U/RZkBWQi8jbjEqDhfOeKQaNgBxVmZryx07g3tp2DD1lF1cQy8JYPk
         trzfHwAcOt+2gFmt2yxEH3AJabE+9cJ/iSX7vYR0gXU7d6PAMJKeCMLDesJWls46L/VH
         0Jw1guOKpT5qXmLp7qzAG4Tok2OiCxncuKnXDueJDhY6e+ux7DRUS2fF0t8kNr2x9lPT
         IDM1HmrwrirQBO0FtvtwruXGc65iQz8bvXK9hR+KTtgrPdCoLKkZLZm563CTMQGVVTdf
         HOhjIB8hdu4kU/7VNLFGi6+Wro2GewsYJ47fW01ELF6yQ0jf64A/CGGlmmpCfAB+L1Ji
         +TUg==
X-Gm-Message-State: APjAAAXe2oKBqP5Eif19s/7IAtCxc0/+Ye/oaCZMnANOEr3CF1dJHRBz
        c1nlWiJ0AwxYB4VBFay6sbcyBJanvZED9Wpq3ZY=
X-Google-Smtp-Source: APXvYqzeTbbLX2hoL5SOpyWZ163CKr/BYaeKD20KVHAP6DTy5cafMq+43OVtgoDfz7064VCH6xPDuL4HIGfFgOOvE1c=
X-Received: by 2002:aed:38c2:: with SMTP id k60mr56193783qte.83.1564004418995;
 Wed, 24 Jul 2019 14:40:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190724165803.87470-1-brianvv@google.com> <20190724165803.87470-3-brianvv@google.com>
In-Reply-To: <20190724165803.87470-3-brianvv@google.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 24 Jul 2019 14:40:07 -0700
Message-ID: <CAPhsuW4HPjXE+zZGmPM9GVPgnVieRr0WOuXfM0W6ec3SB4imDw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] bpf: add BPF_MAP_DUMP command to dump more
 than one entry per call
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 10:10 AM Brian Vazquez <brianvv@google.com> wrote:
>
> This introduces a new command to retrieve multiple number of entries
> from a bpf map, wrapping the existing bpf methods:
> map_get_next_key and map_lookup_elem
>
> To start dumping the map from the beginning you must specify NULL as
> the prev_key.
>
> The new API returns 0 when it successfully copied all the elements
> requested or it copied less because there weren't more elements to
> retrieved (i.e err == -ENOENT). In last scenario err will be masked to 0.
>
> On a successful call buf and buf_len will contain correct data and in
> case prev_key was provided (not for the first walk, since prev_key is
> NULL) it will contain the last_key copied into the prev_key which will
> simplify next call.
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
> It is also important to note that with  a locked map, the lock is grabbed
> for 1 entry at the time, meaning that the returned buf might or might not
> be consistent.
>
> Suggested-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> ---
>  include/uapi/linux/bpf.h |   9 +++
>  kernel/bpf/syscall.c     | 117 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 126 insertions(+)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index fa1c753dcdbc7..66dab5385170d 100644
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
> +               __aligned_u64   prev_key;
> +               __aligned_u64   buf;
> +               __aligned_u64   buf_len; /* input/output: len of buf */
> +               __u64           flags;

Please add explanation of flags here. Also, we need to update the
comments of BPF_F_LOCK for BPF_MAP_DUMP.

> +               __u32           map_fd;
> +       } dump;
> +
>         struct { /* anonymous struct used by BPF_PROG_LOAD command */
>                 __u32           prog_type;      /* one of enum bpf_prog_type */
>                 __u32           insn_cnt;
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 86cdc2f7bb56e..0c35505aa219f 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1097,6 +1097,120 @@ static int map_get_next_key(union bpf_attr *attr)
>         return err;
>  }
>
> +/* last field in 'union bpf_attr' used by this command */
> +#define BPF_MAP_DUMP_LAST_FIELD dump.map_fd
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

We can share these lines with map_lookup_elem(). Maybe
add another helper function?

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

If prev_key is deleted before map_get_next_key(), we get the first key
again. This is pretty weird.

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
> @@ -2910,6 +3024,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
>         case BPF_MAP_LOOKUP_AND_DELETE_ELEM:
>                 err = map_lookup_and_delete_elem(&attr);
>                 break;
> +       case BPF_MAP_DUMP:
> +               err = map_dump(&attr);
> +               break;
>         default:
>                 err = -EINVAL;
>                 break;
> --
> 2.22.0.657.g960e92d24f-goog
>
