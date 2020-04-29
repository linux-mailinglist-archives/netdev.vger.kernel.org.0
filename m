Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A921BE786
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgD2Tjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726481AbgD2Tji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:39:38 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55DEC03C1AE;
        Wed, 29 Apr 2020 12:39:38 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id e17so2950512qtp.7;
        Wed, 29 Apr 2020 12:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zw+cx/u9M73JUnxMY2kmXPY4p8Ij3gSiZDolIp9nYa0=;
        b=ao9gWyMmJY7gahJk+Fewkx+7Ircb0q/KtuAkJPRpQ5Oetwrr5uOTaFRP21mz8tK4AB
         EYdTJOyo0/pctu0ULDPiAKmfeCJId6UplkrwZfZa8PBo5Ap1Pb5NzmPELWOyntDHwt9V
         iuJOqPTedaVFkL9K+TNIciaurYn1Wdog2lmpdl60XBaU1Xgcjv3yJwxAOTbLggdrcmiG
         opohFnkfm6mIoA08QQPnndpkIpeBF6h30r6LmFSkTVJTb7owGTUYV1m6q9FKnK0f8HvG
         +dwxevjSXnW05XNte9T9qUNp3H8Pna/CyV90nW5qDj3AxQ0lqwUnzClMbqoQ1EvWuBDr
         pSLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zw+cx/u9M73JUnxMY2kmXPY4p8Ij3gSiZDolIp9nYa0=;
        b=EuGiXjlmCYtEqNwpIayRERnJuiikr6K00IEmApe1Vz+var41SfO/DE+RlFMdgMpE8k
         W9HPRLsBywVgcf2kI3kzKYIzieSCayM7KTc5Nc/DLY+hMAXIJlLXj2T0rPyalbQql9po
         E57r+uKF4gGSFlypyxm1USNTO4D1YJXncq4uhX1ImVFaZ9fH/IlBuZh3WFdmc6uDnt4n
         5abkH13iFft6U7P0ya5cHasLwrYA2lE6ACpnDDNAG2yrSZGDh7Ho3rU1YZBX8Xbhp95N
         qbLs1824YYuWt9W72F6kyZ5yEU37U+HpckfUoyTKUsqhxuOa4JL2ySrmRlkFi5DtFVwd
         q4sQ==
X-Gm-Message-State: AGi0PuYcFufWkYprQ2ERwRCQQdC6K6CKxrg8E9JL6WZnbQpanAhUT6dM
        YKcOhhcF3KNx1T2Q6hcxiyF+HcjcdSJ5ThdgehQ=
X-Google-Smtp-Source: APiQypKg/IB/sPihHWCpEB5rLiJZCiwz58cqjI15m57ldBQ4YdP+rmBAIhrYMeX/CXxyqVnFAd/WKXa8waOP6ox/LKE=
X-Received: by 2002:aed:2e24:: with SMTP id j33mr35828532qtd.117.1588189177823;
 Wed, 29 Apr 2020 12:39:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200427201235.2994549-1-yhs@fb.com> <20200427201242.2995160-1-yhs@fb.com>
In-Reply-To: <20200427201242.2995160-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 29 Apr 2020 12:39:26 -0700
Message-ID: <CAEf4Bzaox3LY04z0xeN6W_9SMqTyxOh1eKk3utanyKG2fcWcyQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 07/19] bpf: create anonymous bpf iterator
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

On Mon, Apr 27, 2020 at 1:19 PM Yonghong Song <yhs@fb.com> wrote:
>
> A new bpf command BPF_ITER_CREATE is added.
>
> The anonymous bpf iterator is seq_file based.
> The seq_file private data are referenced by targets.
> The bpf_iter infrastructure allocated additional space
> at seq_file->private after the space used by targets
> to store some meta data, e.g.,
>   prog:       prog to run
>   session_id: an unique id for each opened seq_file
>   seq_num:    how many times bpf programs are queried in this session
>   has_last:   indicate whether or not bpf_prog has been called after
>               all valid objects have been processed
>
> A map between file and prog/link is established to help
> fops->release(). When fops->release() is called, just based on
> inode and file, bpf program cannot be located since target
> seq_priv_size not available. This map helps retrieve the prog
> whose reference count needs to be decremented.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h            |   3 +
>  include/uapi/linux/bpf.h       |   6 ++
>  kernel/bpf/bpf_iter.c          | 162 ++++++++++++++++++++++++++++++++-
>  kernel/bpf/syscall.c           |  27 ++++++
>  tools/include/uapi/linux/bpf.h |   6 ++
>  5 files changed, 203 insertions(+), 1 deletion(-)
>

[...]

>  int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
>  {
>         struct bpf_iter_target_info *tinfo;
> @@ -37,6 +95,8 @@ int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
>                 INIT_LIST_HEAD(&targets);
>                 mutex_init(&targets_mutex);
>                 mutex_init(&bpf_iter_mutex);
> +               INIT_LIST_HEAD(&anon_iter_info);
> +               mutex_init(&anon_iter_info_mutex);
>                 bpf_iter_inited = true;
>         }
>
> @@ -61,7 +121,20 @@ int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
>  struct bpf_prog *bpf_iter_get_prog(struct seq_file *seq, u32 priv_data_size,
>                                    u64 *session_id, u64 *seq_num, bool is_last)

instead of passing many pointers (session_id, seq_num), would it be
better to just pass bpf_iter_meta * instead?

>  {
> -       return NULL;
> +       struct extra_priv_data *extra_data;
> +
> +       if (seq->file->f_op != &anon_bpf_iter_fops)
> +               return NULL;
> +
> +       extra_data = get_extra_priv_dptr(seq->private, priv_data_size);
> +       if (extra_data->has_last)
> +               return NULL;
> +
> +       *session_id = extra_data->session_id;
> +       *seq_num = extra_data->seq_num++;
> +       extra_data->has_last = is_last;
> +
> +       return extra_data->prog;
>  }
>
>  int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx)
> @@ -150,3 +223,90 @@ int bpf_iter_link_replace(struct bpf_link *link, struct bpf_prog *old_prog,
>         mutex_unlock(&bpf_iter_mutex);
>         return ret;
>  }
> +
> +static void init_seq_file(void *priv_data, struct bpf_iter_target_info *tinfo,
> +                         struct bpf_prog *prog)
> +{
> +       struct extra_priv_data *extra_data;
> +
> +       if (tinfo->target_feature & BPF_DUMP_SEQ_NET_PRIVATE)
> +               set_seq_net_private((struct seq_net_private *)priv_data,
> +                                   current->nsproxy->net_ns);
> +
> +       extra_data = get_extra_priv_dptr(priv_data, tinfo->seq_priv_size);
> +       extra_data->session_id = atomic64_add_return(1, &session_id);
> +       extra_data->prog = prog;
> +       extra_data->seq_num = 0;
> +       extra_data->has_last = false;
> +}
> +
> +static int prepare_seq_file(struct file *file, struct bpf_iter_link *link)
> +{
> +       struct anon_file_prog_assoc *finfo;
> +       struct bpf_iter_target_info *tinfo;
> +       struct bpf_prog *prog;
> +       u32 total_priv_dsize;
> +       void *priv_data;
> +
> +       finfo = kmalloc(sizeof(*finfo), GFP_USER | __GFP_NOWARN);
> +       if (!finfo)
> +               return -ENOMEM;
> +
> +       mutex_lock(&bpf_iter_mutex);
> +       prog = link->link.prog;
> +       bpf_prog_inc(prog);
> +       mutex_unlock(&bpf_iter_mutex);
> +
> +       tinfo = link->tinfo;
> +       total_priv_dsize = get_total_priv_dsize(tinfo->seq_priv_size);
> +       priv_data = __seq_open_private(file, tinfo->seq_ops, total_priv_dsize);
> +       if (!priv_data) {
> +               bpf_prog_sub(prog, 1);
> +               kfree(finfo);
> +               return -ENOMEM;
> +       }
> +
> +       init_seq_file(priv_data, tinfo, prog);
> +
> +       finfo->file = file;
> +       finfo->prog = prog;
> +
> +       mutex_lock(&anon_iter_info_mutex);
> +       list_add(&finfo->list, &anon_iter_info);
> +       mutex_unlock(&anon_iter_info_mutex);
> +       return 0;
> +}
> +
> +int bpf_iter_new_fd(struct bpf_link *link)
> +{
> +       struct file *file;
> +       int err, fd;
> +
> +       if (link->ops != &bpf_iter_link_lops)
> +               return -EINVAL;
> +
> +       fd = get_unused_fd_flags(O_CLOEXEC);
> +       if (fd < 0)
> +               return fd;
> +
> +       file = anon_inode_getfile("bpf_iter", &anon_bpf_iter_fops,
> +                                 NULL, O_CLOEXEC);

Shouldn't this anon file be readable and have O_RDONLY flag as well?

> +       if (IS_ERR(file)) {
> +               err = PTR_ERR(file);
> +               goto free_fd;
> +       }
> +
> +       err = prepare_seq_file(file,
> +                              container_of(link, struct bpf_iter_link, link));
> +       if (err)
> +               goto free_file;
> +
> +       fd_install(fd, file);
> +       return fd;
> +
> +free_file:
> +       fput(file);
> +free_fd:
> +       put_unused_fd(fd);
> +       return err;
> +}
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index b7af4f006f2e..458f7000887a 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -3696,6 +3696,30 @@ static int link_update(union bpf_attr *attr)
>         return ret;
>  }
>
> +#define BPF_ITER_CREATE_LAST_FIELD iter_create.flags
> +
> +static int bpf_iter_create(union bpf_attr *attr)
> +{
> +       struct bpf_link *link;
> +       int err;
> +
> +       if (CHECK_ATTR(BPF_ITER_CREATE))
> +               return -EINVAL;
> +
> +       if (attr->iter_create.flags)
> +               return -EINVAL;
> +
> +       link = bpf_link_get_from_fd(attr->iter_create.link_fd);
> +       if (IS_ERR(link))
> +               return PTR_ERR(link);
> +
> +       err = bpf_iter_new_fd(link);
> +       if (err < 0)
> +               bpf_link_put(link);

bpf_iter_new_fd() doesn't take a refcnt on link, so you need to put it
regardless of success or error

> +
> +       return err;
> +}
> +
>  SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
>  {
>         union bpf_attr attr;
> @@ -3813,6 +3837,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
>         case BPF_LINK_UPDATE:
>                 err = link_update(&attr);
>                 break;
> +       case BPF_ITER_CREATE:
> +               err = bpf_iter_create(&attr);
> +               break;
>         default:
>                 err = -EINVAL;
>                 break;

[...]
