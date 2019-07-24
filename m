Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36BE2741CE
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 01:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729659AbfGXXFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 19:05:02 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37729 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfGXXFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 19:05:01 -0400
Received: by mail-qt1-f194.google.com with SMTP id y26so47239131qto.4;
        Wed, 24 Jul 2019 16:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R7rWft6F3bA/tG51c+ZfWgjzu6JzJyAuVH+CKO1ZKEs=;
        b=gmAgAkG9blbkmEcLcxNuRMj67eOiDugp5u0rYEyqC581XKIXAAcCgYGONE2MK1Peol
         9JZwpj2FKEvzrCdU+8CAHRtu34WvauxS2zTZu1uUtHoNlBYeAWQ7U//qd+Sx3uZfdk70
         a1L3waOw/IfgwgJLjPkUrcEM1gYfjNxImetwrs+i9djjZZm2NQJgFLtMk1HJf2M5HDwN
         U7VtzLa2+OkuNP/tzgOpxO5R9gWo7ZVbTACkF13I5hJOBtk7LHEHU5kJozlaAqKAA9Ti
         O0F2PrKmKCm3T+jzVEpOvNdE0gpDKD0jBpsEYAyJgCxryj1wiHCK70yT3YxFAbbZJu6W
         zOVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R7rWft6F3bA/tG51c+ZfWgjzu6JzJyAuVH+CKO1ZKEs=;
        b=ZDYaxJoZvANrUKtin71Ty+60y+52e2gQfXjs6gh3iCzPS6tKvY2hqi7fCebh7bDpDD
         enGboK+Y9cuZgISLO0ZqtV68bkYQ/66mffsl+7zurad45q8TACkYVnblDcEY2Xgn7pi6
         tc5dFLBQJ0eJK5kLL90SJYHx5HYiFuhPP3LkoUTah3j6c/1L4wHMXQBV+RxuanTg+Doz
         KJVS06/FJRHA+fGyfarl/K4+jF0q1AjLTV+xkG4v6/OIPB/n+fLeMHrgEty70LobV7XU
         mAujEn/Ff0nNBEIfU250aRqmNTd6V3Bzpf7NKIXxXTBbNzT3IZoi39AXmln0kyWAArkw
         63Ig==
X-Gm-Message-State: APjAAAWQMRvUJPWc62IsCK74y3S9jNJMrVknacE6qX8cwBE40MlvS/dw
        9EouPImPSQziwWDk8THzPQ5brqx1IpjpmjTj328=
X-Google-Smtp-Source: APXvYqxVzAqOhXnhIHZLPDY0p/04H7QBnxJWXYjUbc0iECaFPDpTb187Sn/vNNJsFsZuxNbcmmIZD0ZwpmYiLpzwKV4=
X-Received: by 2002:ac8:6a17:: with SMTP id t23mr57874962qtr.183.1564009500202;
 Wed, 24 Jul 2019 16:05:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190724165803.87470-1-brianvv@google.com> <20190724165803.87470-3-brianvv@google.com>
 <CAPhsuW4HPjXE+zZGmPM9GVPgnVieRr0WOuXfM0W6ec3SB4imDw@mail.gmail.com> <CABCgpaXz4hO=iGoswdqYBECWE5eu2AdUgms=hyfKnqz7E+ZgNg@mail.gmail.com>
In-Reply-To: <CABCgpaXz4hO=iGoswdqYBECWE5eu2AdUgms=hyfKnqz7E+ZgNg@mail.gmail.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 24 Jul 2019 16:04:48 -0700
Message-ID: <CAPhsuW5NzzeDmNmgqRh0kwHnoQfaD90L44NJ9AbydG_tGJkKiQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] bpf: add BPF_MAP_DUMP command to dump more
 than one entry per call
To:     Brian Vazquez <brianvv.kernel@gmail.com>
Cc:     Brian Vazquez <brianvv@google.com>,
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

On Wed, Jul 24, 2019 at 3:44 PM Brian Vazquez <brianvv.kernel@gmail.com> wrote:
>
> On Wed, Jul 24, 2019 at 2:40 PM Song Liu <liu.song.a23@gmail.com> wrote:
> >
> > On Wed, Jul 24, 2019 at 10:10 AM Brian Vazquez <brianvv@google.com> wrote:
> > >
> > > This introduces a new command to retrieve multiple number of entries
> > > from a bpf map, wrapping the existing bpf methods:
> > > map_get_next_key and map_lookup_elem
> > >
> > > To start dumping the map from the beginning you must specify NULL as
> > > the prev_key.
> > >
> > > The new API returns 0 when it successfully copied all the elements
> > > requested or it copied less because there weren't more elements to
> > > retrieved (i.e err == -ENOENT). In last scenario err will be masked to 0.
> > >
> > > On a successful call buf and buf_len will contain correct data and in
> > > case prev_key was provided (not for the first walk, since prev_key is
> > > NULL) it will contain the last_key copied into the prev_key which will
> > > simplify next call.
> > >
> > > Only when it can't find a single element it will return -ENOENT meaning
> > > that the map has been entirely walked. When an error is return buf,
> > > buf_len and prev_key shouldn't be read nor used.
> > >
> > > Because maps can be called from userspace and kernel code, this function
> > > can have a scenario where the next_key was found but by the time we
> > > try to retrieve the value the element is not there, in this case the
> > > function continues and tries to get a new next_key value, skipping the
> > > deleted key. If at some point the function find itself trap in a loop,
> > > it will return -EINTR.
> > >
> > > The function will try to fit as much as possible in the buf provided and
> > > will return -EINVAL if buf_len is smaller than elem_size.
> > >
> > > QUEUE and STACK maps are not supported.
> > >
> > > Note that map_dump doesn't guarantee that reading the entire table is
> > > consistent since this function is always racing with kernel and user code
> > > but the same behaviour is found when the entire table is walked using
> > > the current interfaces: map_get_next_key + map_lookup_elem.
> > > It is also important to note that with  a locked map, the lock is grabbed
> > > for 1 entry at the time, meaning that the returned buf might or might not
> > > be consistent.
> > >
> > > Suggested-by: Stanislav Fomichev <sdf@google.com>
> > > Signed-off-by: Brian Vazquez <brianvv@google.com>
> > > ---
> > >  include/uapi/linux/bpf.h |   9 +++
> > >  kernel/bpf/syscall.c     | 117 +++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 126 insertions(+)
> > >
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index fa1c753dcdbc7..66dab5385170d 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -106,6 +106,7 @@ enum bpf_cmd {
> > >         BPF_TASK_FD_QUERY,
> > >         BPF_MAP_LOOKUP_AND_DELETE_ELEM,
> > >         BPF_MAP_FREEZE,
> > > +       BPF_MAP_DUMP,
> > >  };
> > >
> > >  enum bpf_map_type {
> > > @@ -388,6 +389,14 @@ union bpf_attr {
> > >                 __u64           flags;
> > >         };
> > >
> > > +       struct { /* struct used by BPF_MAP_DUMP command */
> > > +               __aligned_u64   prev_key;
> > > +               __aligned_u64   buf;
> > > +               __aligned_u64   buf_len; /* input/output: len of buf */
> > > +               __u64           flags;
> >
> > Please add explanation of flags here.
>
> got it!
>
> > Also, we need to update the
> > comments of BPF_F_LOCK for BPF_MAP_DUMP.
>
> What do you mean? I didn't get this part.

I meant, current comment says BPF_F_LOCK is for BPF_MAP_UPDATE_ELEM.
But it is also used by BPF_MAP_LOOKUP_ELEM and BPF_MAP_DUMP. So
current comment is not accurate either.

Maybe fix it while you are on it?
>
> >
> > > +               __u32           map_fd;
> > > +       } dump;
> > > +
> > >         struct { /* anonymous struct used by BPF_PROG_LOAD command */
> > >                 __u32           prog_type;      /* one of enum bpf_prog_type */
> > >                 __u32           insn_cnt;
> > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > index 86cdc2f7bb56e..0c35505aa219f 100644
> > > --- a/kernel/bpf/syscall.c
> > > +++ b/kernel/bpf/syscall.c
> > > @@ -1097,6 +1097,120 @@ static int map_get_next_key(union bpf_attr *attr)
> > >         return err;
> > >  }
> > >
> > > +/* last field in 'union bpf_attr' used by this command */
> > > +#define BPF_MAP_DUMP_LAST_FIELD dump.map_fd
> > > +
> > > +static int map_dump(union bpf_attr *attr)
> > > +{
> > > +       void __user *ukey = u64_to_user_ptr(attr->dump.prev_key);
> > > +       void __user *ubuf = u64_to_user_ptr(attr->dump.buf);
> > > +       u32 __user *ubuf_len = u64_to_user_ptr(attr->dump.buf_len);
> > > +       int ufd = attr->dump.map_fd;
> > > +       struct bpf_map *map;
> > > +       void *buf, *prev_key, *key, *value;
> > > +       u32 value_size, elem_size, buf_len, cp_len;
> > > +       struct fd f;
> > > +       int err;
> > > +       bool first_key = false;
> > > +
> > > +       if (CHECK_ATTR(BPF_MAP_DUMP))
> > > +               return -EINVAL;
> > > +
> > > +       if (attr->dump.flags & ~BPF_F_LOCK)
> > > +               return -EINVAL;
> > > +
> > > +       f = fdget(ufd);
> > > +       map = __bpf_map_get(f);
> > > +       if (IS_ERR(map))
> > > +               return PTR_ERR(map);
> > > +       if (!(map_get_sys_perms(map, f) & FMODE_CAN_READ)) {
> > > +               err = -EPERM;
> > > +               goto err_put;
> > > +       }
> > > +
> > > +       if ((attr->dump.flags & BPF_F_LOCK) &&
> > > +           !map_value_has_spin_lock(map)) {
> > > +               err = -EINVAL;
> > > +               goto err_put;
> > > +       }
> >
> > We can share these lines with map_lookup_elem(). Maybe
> > add another helper function?
>
> Which are the lines you are referring to? the dump.flags? It makes
> sense so that way when a new flag is added you only need to modify
> them in one spot.

I think I misread it. attr->dump.flags is not same as attr->flags.

So never mind.

>
> > > +
> > > +       if (map->map_type == BPF_MAP_TYPE_QUEUE ||
> > > +           map->map_type == BPF_MAP_TYPE_STACK) {
> > > +               err = -ENOTSUPP;
> > > +               goto err_put;
> > > +       }
> > > +
> > > +       value_size = bpf_map_value_size(map);
> > > +
> > > +       err = get_user(buf_len, ubuf_len);
> > > +       if (err)
> > > +               goto err_put;
> > > +
> > > +       elem_size = map->key_size + value_size;
> > > +       if (buf_len < elem_size) {
> > > +               err = -EINVAL;
> > > +               goto err_put;
> > > +       }
> > > +
> > > +       if (ukey) {
> > > +               prev_key = __bpf_copy_key(ukey, map->key_size);
> > > +               if (IS_ERR(prev_key)) {
> > > +                       err = PTR_ERR(prev_key);
> > > +                       goto err_put;
> > > +               }
> > > +       } else {
> > > +               prev_key = NULL;
> > > +               first_key = true;
> > > +       }
> > > +
> > > +       err = -ENOMEM;
> > > +       buf = kmalloc(elem_size, GFP_USER | __GFP_NOWARN);
> > > +       if (!buf)
> > > +               goto err_put;
> > > +
> > > +       key = buf;
> > > +       value = key + map->key_size;
> > > +       for (cp_len = 0; cp_len + elem_size <= buf_len;) {
> > > +               if (signal_pending(current)) {
> > > +                       err = -EINTR;
> > > +                       break;
> > > +               }
> > > +
> > > +               rcu_read_lock();
> > > +               err = map->ops->map_get_next_key(map, prev_key, key);
> >
> > If prev_key is deleted before map_get_next_key(), we get the first key
> > again. This is pretty weird.
>
> Yes, I know. But note that the current scenario happens even for the
> old interface (imagine you are walking a map from userspace and you
> tried get_next_key the prev_key was removed, you will start again from
> the beginning without noticing it).
> I tried to sent a patch in the past but I was missing some context:
> before NULL was used to get the very first_key the interface relied in
> a random (non existent) key to retrieve the first_key in the map, and
> I was told what we still have to support that scenario.

BPF_MAP_DUMP is slightly different, as you may return the first key
multiple times in the same call. Also, BPF_MAP_DUMP is new, so we
don't have to support legacy scenarios.

Since BPF_MAP_DUMP keeps a list of elements. It is possible to try
to look up previous keys. Would something down this direction work?

Thanks,
Song
