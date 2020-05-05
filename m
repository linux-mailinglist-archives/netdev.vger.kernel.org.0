Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4AF21C61AA
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbgEEULZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728135AbgEEULZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:11:25 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21922C061A0F;
        Tue,  5 May 2020 13:11:25 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id s30so3194356qth.2;
        Tue, 05 May 2020 13:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g2th3jL2wFkEZju+ac119wGX0qv5eo/GfbGRLZZExCY=;
        b=WxlidZ7XeZbj7KoRPHFSyT5WtixLdcxqdCNwFCo95Ho4AL1mm8lHO15o6KJEGQI2Hb
         /wmAhTNOh4TmpBw1vXK1+sRkX5IIhE0FCi0FyFJrt+LHNOGCkLmYIHbbK6Yl/KXPmeHT
         56mYsDxN5mCZqsCcfrlqtgxPhcB4FYr5wg+HlfGecZ6lVABLMIb4YLWvb2L9F+sCuwx+
         9Uv4TpeeTrkzYOk5Uou5FpwVJmehwpV54Wply5mN9/vZJrpbnJ4XI7jmhV2Xx/R2ipsE
         cpce9swweZHeJ4tHORud1EG9rUPf78gUPXnSQDSLWX9dB9Dqv/F4rrjwsD9WEjOVVWi0
         P/Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g2th3jL2wFkEZju+ac119wGX0qv5eo/GfbGRLZZExCY=;
        b=Ws0WxJYpfpUYwdtAsHslIwRIdaNOe7bnHha5SSzNejLG5WeJQ/L8oyAdJmQBoiEI7F
         uMIz5MgpjIgol0aQGCFhXwDTpS1c8A92ff+YclFHk7p75CWFUpa+wf0fqOwpm/QwrEzF
         dMQb0hHOzum96UYJOJEEL3pKyIC/s858J3eN3Fv3x/bPK4mLwuen582y02hUqjztxJb7
         OFu1HqGRx2jJ6FLru619LC9/g48hEj8kzo6604qdyu89joiPDoN35tv5O/XHxzhiJEb5
         0CBGiK+EXChqQgvUdkIyp+gD3gC5QfeSlFlpzKCbiEusg4N2bBC+vjTqrLa9uH0ZE94l
         WRcQ==
X-Gm-Message-State: AGi0Puae7zTt44yK81HJ+T+nbb8vAJ3gjwrA7rLYE79N2/YFyOzl79ZM
        Mg/e0u7tl+Nug9TIMAhi3W+RlSXrFWAtuIgKkO61RZvU
X-Google-Smtp-Source: APiQypJqxYm1f2qdMCcherHhBmhlEofamT00syND/X3TvRKL1CVgfjBt4myg2SS/QAUYvQkYhZNO6T0TUa51hAM+i/I=
X-Received: by 2002:ac8:193d:: with SMTP id t58mr4324932qtj.93.1588709484236;
 Tue, 05 May 2020 13:11:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062553.2047848-1-yhs@fb.com>
In-Reply-To: <20200504062553.2047848-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 May 2020 13:11:13 -0700
Message-ID: <CAEf4BzadAZy+GQwV3DXoGk6KdNYbVMxaP7BFphSc47w5WeXiRA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 06/20] bpf: create anonymous bpf iterator
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

On Sun, May 3, 2020 at 11:29 PM Yonghong Song <yhs@fb.com> wrote:
>
> A new bpf command BPF_ITER_CREATE is added.
>
> The anonymous bpf iterator is seq_file based.
> The seq_file private data are referenced by targets.
> The bpf_iter infrastructure allocated additional space
> at seq_file->private before the space used by targets
> to store some meta data, e.g.,
>   prog:       prog to run
>   session_id: an unique id for each opened seq_file
>   seq_num:    how many times bpf programs are queried in this session
>   do_stop:    an internal state to decide whether bpf program
>               should be called in seq_ops->stop() or not
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h            |   1 +
>  include/uapi/linux/bpf.h       |   6 ++
>  kernel/bpf/bpf_iter.c          | 128 +++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c           |  26 +++++++
>  tools/include/uapi/linux/bpf.h |   6 ++
>  5 files changed, 167 insertions(+)
>

[...]

>  /* The description below is an attempt at providing documentation to eBPF
> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
> index 2674c9cbc3dc..2a9f939be6e6 100644
> --- a/kernel/bpf/bpf_iter.c
> +++ b/kernel/bpf/bpf_iter.c
> @@ -2,6 +2,7 @@
>  /* Copyright (c) 2020 Facebook */
>
>  #include <linux/fs.h>
> +#include <linux/anon_inodes.h>
>  #include <linux/filter.h>
>  #include <linux/bpf.h>
>
> @@ -20,12 +21,26 @@ struct bpf_iter_link {
>         struct bpf_iter_target_info *tinfo;
>  };
>
> +struct bpf_iter_priv_data {
> +       struct {

nit: anon struct seems unnecessary here? is it just for visual grouping?

> +               struct bpf_iter_target_info *tinfo;
> +               struct bpf_prog *prog;
> +               u64 session_id;
> +               u64 seq_num;
> +               u64 do_stop;
> +       };
> +       u8 target_private[] __aligned(8);
> +};
> +
>  static struct list_head targets = LIST_HEAD_INIT(targets);
>  static DEFINE_MUTEX(targets_mutex);
>
>  /* protect bpf_iter_link changes */
>  static DEFINE_MUTEX(link_mutex);
>
> +/* incremented on every opened seq_file */
> +static atomic64_t session_id;
> +
>  /* bpf_seq_read, a customized and simpler version for bpf iterator.
>   * no_llseek is assumed for this file.
>   * The following are differences from seq_read():
> @@ -154,6 +169,31 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
>         goto Done;
>  }
>
> +static int iter_release(struct inode *inode, struct file *file)
> +{
> +       struct bpf_iter_priv_data *iter_priv;
> +       void *file_priv = file->private_data;
> +       struct seq_file *seq;
> +
> +       seq = file_priv;


seq might be NULL, if anon_inode_getfile succeeded, but then
prepare_seq_file failed, so you need to handle that.

Also, file_priv is redundant, assign to seq directly from file->private_data?

> +       iter_priv = container_of(seq->private, struct bpf_iter_priv_data,
> +                                target_private);
> +
> +       if (iter_priv->tinfo->fini_seq_private)
> +               iter_priv->tinfo->fini_seq_private(seq->private);
> +
> +       bpf_prog_put(iter_priv->prog);
> +       seq->private = iter_priv;
> +
> +       return seq_release_private(inode, file);
> +}
> +
> +static const struct file_operations bpf_iter_fops = {
> +       .llseek         = no_llseek,
> +       .read           = bpf_seq_read,
> +       .release        = iter_release,
> +};
> +
>  int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
>  {
>         struct bpf_iter_target_info *tinfo;
> @@ -289,3 +329,91 @@ int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>
>         return bpf_link_settle(&link_primer);
>  }
> +
> +static void init_seq_meta(struct bpf_iter_priv_data *priv_data,
> +                         struct bpf_iter_target_info *tinfo,
> +                         struct bpf_prog *prog)
> +{
> +       priv_data->tinfo = tinfo;
> +       priv_data->prog = prog;
> +       priv_data->session_id = atomic64_add_return(1, &session_id);

nit: atomic64_inc_return?

> +       priv_data->seq_num = 0;
> +       priv_data->do_stop = 0;
> +}
> +

[...]
