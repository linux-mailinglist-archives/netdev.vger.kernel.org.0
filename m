Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959A61BE8D1
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgD2Ukh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgD2Ukg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:40:36 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A37C03C1AE;
        Wed, 29 Apr 2020 13:40:36 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id h124so3478587qke.11;
        Wed, 29 Apr 2020 13:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9tMJbiVrT9LFzwZ5MEioscrxCyJ4gVwoMkNjO1qKHKw=;
        b=W65JJjxAp2XNrwbbFo5Jx/O20b5HwFekZ5RpQ/lBh/1ix2QczkiADfWTmktOLRxy2q
         1QxigBtRaeiWvA1vKAGERi7qfLM9rNFV82q23Vd0VxzSjqEV22riAJtteIHWSx0hxjMx
         9QttwSBLXlSrC0wePFokf1MZD5uBqvbGboN6qxy/kU1MW5+zK0lNp74SqL9UmXCeWavu
         ktIs9KTgGioyN2yGoP84yjYPV633lW0tl8p/GYPvoHvNl8DKwiDmjvzLMg9HQ56k0LOi
         zzBTvXj7frSSP+e+yRXZWbEftDnK47t0hW7Llcx2HJqftOrFovXHSAm34VFThD90MjHF
         fIzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9tMJbiVrT9LFzwZ5MEioscrxCyJ4gVwoMkNjO1qKHKw=;
        b=WCUB2deHgQH8AYO9NXnFrhvbcTpFbL0+HfZ6oFm66B8eTuQYqCp1km1gOBkcZmlLnz
         ID24ghTpu736kDbWVSLOoQnkSUV1lLf9xp8zwjMD0Ck6ht+DUaQqbmopWL+3DT0Cm1Td
         4kyn5CkNeHY/NIaQHPqgPlyU3BR2jMlwkmTZCoSBrf1p2VnLtk64iwECSxQ95bc3dFCB
         d+dVjhJ8fa+Losy0HJVJC983D1DAqXw6ptGUPVbvtm1b219zGeCT8EcdODW+Pb1rirFI
         x5pGAVmJ8iB8rQU/wc5QnPh1lpXvB2CZ3kIgmWWs8Q3PCRYZf3c7VcysqepAKqWrcMcs
         Rrxg==
X-Gm-Message-State: AGi0PuawtfrzVAdDO3926GGG4WuBgwdiDqh+ufuBojzQJHdy/p0azZWr
        mfcF2e7ZeveR7yAGu4n+E3lyUaytVhlRZgoW7S0=
X-Google-Smtp-Source: APiQypIqhZmH6EI/xcQFlXyv8MnRflDW7FUShmMf4NgBMe6y7marSCihQ+26n8oDbewP30qKcwfAGXBwhWGeuG5hE7s=
X-Received: by 2002:ae9:e854:: with SMTP id a81mr354896qkg.36.1588192835714;
 Wed, 29 Apr 2020 13:40:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200427201235.2994549-1-yhs@fb.com> <20200427201244.2995241-1-yhs@fb.com>
In-Reply-To: <20200427201244.2995241-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 29 Apr 2020 13:40:24 -0700
Message-ID: <CAEf4BzY1gor=j9kh2JxZAQc4SoyaRoVGA_7UK9z_Nb0FpCudkQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 08/19] bpf: create file bpf iterator
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 1:18 PM Yonghong Song <yhs@fb.com> wrote:
>
> A new obj type BPF_TYPE_ITER is added to bpffs.
> To produce a file bpf iterator, the fd must be
> corresponding to a link_fd assocciated with a
> trace/iter program. When the pinned file is
> opened, a seq_file will be generated.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h   |  3 +++
>  kernel/bpf/bpf_iter.c | 48 ++++++++++++++++++++++++++++++++++++++++++-
>  kernel/bpf/inode.c    | 28 +++++++++++++++++++++++++
>  kernel/bpf/syscall.c  |  2 +-
>  4 files changed, 79 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 0f0cafc65a04..601b3299b7e4 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1021,6 +1021,8 @@ static inline void bpf_enable_instrumentation(void)
>
>  extern const struct file_operations bpf_map_fops;
>  extern const struct file_operations bpf_prog_fops;
> +extern const struct file_operations bpf_link_fops;
> +extern const struct file_operations bpffs_iter_fops;
>
>  #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
>         extern const struct bpf_prog_ops _name ## _prog_ops; \
> @@ -1136,6 +1138,7 @@ int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
>  int bpf_iter_link_replace(struct bpf_link *link, struct bpf_prog *old_prog,
>                           struct bpf_prog *new_prog);
>  int bpf_iter_new_fd(struct bpf_link *link);
> +void *bpf_iter_get_from_fd(u32 ufd);
>
>  int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
>  int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
> index 1f4e778d1814..f5e933236996 100644
> --- a/kernel/bpf/bpf_iter.c
> +++ b/kernel/bpf/bpf_iter.c
> @@ -123,7 +123,8 @@ struct bpf_prog *bpf_iter_get_prog(struct seq_file *seq, u32 priv_data_size,
>  {
>         struct extra_priv_data *extra_data;
>
> -       if (seq->file->f_op != &anon_bpf_iter_fops)
> +       if (seq->file->f_op != &anon_bpf_iter_fops &&
> +           seq->file->f_op != &bpffs_iter_fops)

Do we really need anon_bpf_iter_fops and bpffs_iter_fops? Seems like
the only difference is bpffs_iter_open. Could it be implemented as
part of anon_bpf_iter_ops as well? Seems like open() is never called
for anon_inode_file, so it should work for both?

>                 return NULL;
>
>         extra_data = get_extra_priv_dptr(seq->private, priv_data_size);
> @@ -310,3 +311,48 @@ int bpf_iter_new_fd(struct bpf_link *link)
>         put_unused_fd(fd);
>         return err;
>  }
> +
> +static int bpffs_iter_open(struct inode *inode, struct file *file)
> +{
> +       struct bpf_iter_link *link = inode->i_private;
> +
> +       return prepare_seq_file(file, link);
> +}
> +
> +static int bpffs_iter_release(struct inode *inode, struct file *file)
> +{
> +       return anon_iter_release(inode, file);
> +}
> +
> +const struct file_operations bpffs_iter_fops = {
> +       .open           = bpffs_iter_open,
> +       .read           = seq_read,
> +       .release        = bpffs_iter_release,
> +};
> +
> +void *bpf_iter_get_from_fd(u32 ufd)

return struct bpf_iter_link * here, given this is specific constructor
for bpf_iter_link?

> +{
> +       struct bpf_link *link;
> +       struct bpf_prog *prog;
> +       struct fd f;
> +
> +       f = fdget(ufd);
> +       if (!f.file)
> +               return ERR_PTR(-EBADF);
> +       if (f.file->f_op != &bpf_link_fops) {
> +               link = ERR_PTR(-EINVAL);
> +               goto out;
> +       }
> +
> +       link = f.file->private_data;
> +       prog = link->prog;
> +       if (prog->expected_attach_type != BPF_TRACE_ITER) {
> +               link = ERR_PTR(-EINVAL);
> +               goto out;
> +       }
> +
> +       bpf_link_inc(link);
> +out:
> +       fdput(f);
> +       return link;
> +}
> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> index 95087d9f4ed3..de4493983a37 100644
> --- a/kernel/bpf/inode.c
> +++ b/kernel/bpf/inode.c
> @@ -26,6 +26,7 @@ enum bpf_type {
>         BPF_TYPE_PROG,
>         BPF_TYPE_MAP,
>         BPF_TYPE_LINK,
> +       BPF_TYPE_ITER,

Adding ITER as an alternative type of pinned object to BPF_TYPE_LINK
seems undesirable. We can allow opening bpf_iter's seq_file by doing
the same trick as is done for bpf_maps, supporting seq_show (see
bpf_mkmap() and bpf_map_support_seq_show()). Do you think we can do
the same here? If we later see that more kinds of links would want to
allow direct open() to create a file with some output from BPF
program, we can generalize this as part of bpf_link infrastructure.
For now having a custom check similar to bpf_map's seems sufficient.

What do you think?

>  };
>
>  static void *bpf_any_get(void *raw, enum bpf_type type)
> @@ -38,6 +39,7 @@ static void *bpf_any_get(void *raw, enum bpf_type type)
>                 bpf_map_inc_with_uref(raw);
>                 break;
>         case BPF_TYPE_LINK:
> +       case BPF_TYPE_ITER:
>                 bpf_link_inc(raw);
>                 break;
>         default:
> @@ -58,6 +60,7 @@ static void bpf_any_put(void *raw, enum bpf_type type)
>                 bpf_map_put_with_uref(raw);
>                 break;
>         case BPF_TYPE_LINK:
> +       case BPF_TYPE_ITER:
>                 bpf_link_put(raw);
>                 break;
>         default:
> @@ -82,6 +85,15 @@ static void *bpf_fd_probe_obj(u32 ufd, enum bpf_type *type)
>                 return raw;
>         }
>

[...]
