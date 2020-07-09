Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE7A219687
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 05:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgGIDPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 23:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgGIDPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 23:15:18 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E64C061A0B;
        Wed,  8 Jul 2020 20:15:17 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id h17so375528qvr.0;
        Wed, 08 Jul 2020 20:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qem3/7JAMxwp2XvQr47isJLzhtW2DSpGdcpfSmsSEgQ=;
        b=acgbVwi9FFqPclfKd4VloCf568TaHsfww746RKQaXXTOSCMYyR3rJJjyeXsgl8laeS
         lD9/YvTL2dSTjYbcBe9ABhCR3P77m32jxjKydi9SZDZfAZV3nEYKeExX/CvZ4vgBtV/S
         OLfD00vX3kYtp9+2IZTMZxjfbw77ZcYeZGaigmXif8muxRisTK96SEKxTWfcfCB2O4xH
         +jXSIodXaTa4fOq99nq2tW03K/y9S3W4c52barKJMn9fJQdmGo1knv9kr7XqteZl8KyJ
         IWIE3f+kSX/e08lDOUg/BqyJGC1N46RVzA8Ow/xEi6RJEMwhaYbew1YWDxXGAper73Tf
         qSJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qem3/7JAMxwp2XvQr47isJLzhtW2DSpGdcpfSmsSEgQ=;
        b=VnMb0/iy5Wp733tqz7rMKqx4CucMiXVPJvf9mr5cLlfXwZI+wnxFVbkelODZNiPEI9
         1Hpglq3FbrIny4wOCCNi5Fm6ydoqaM2IxuxRgiDJ8hcmw/lQtRxY0Lzj4x4idy55gigr
         SonLypZJNanHIDRxwesE9LBVTZMVH50VUgtIrSD3/MFvKUi6nfEJwLkvVQLkLyP9JeG5
         NzmHETvcLvCYwEDZaMvQecqM7ulbVro2lAp0nze3fSLeq4vSeR52Fg1uyyUrdJGO6Jfs
         SeVYUdI92JLVWvUveGX9UDv+NzDUoPI8t2kHpUwS6nvSumLbUMTgJxCKAqzoF4De2RHH
         RTqg==
X-Gm-Message-State: AOAM532zNL5bCyFx83nAs736adgaaRm2+VekABEnsX0Enmj+hqHNpIv0
        YiO81VfT6gG8eP6FPwDmRbBneirIpyRMh8rXrps=
X-Google-Smtp-Source: ABdhPJwRXkhGnqfHL36u3j4YjSOV721LgqwXyqcAo/bkRvDKj7y4CmfhinxBqM62k7ne5AYo/rzZ5ZhPhdiysjEnGx0=
X-Received: by 2002:a05:6214:8f4:: with SMTP id dr20mr56978987qvb.228.1594264517036;
 Wed, 08 Jul 2020 20:15:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200702200329.83224-1-alexei.starovoitov@gmail.com> <20200702200329.83224-4-alexei.starovoitov@gmail.com>
In-Reply-To: <20200702200329.83224-4-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 8 Jul 2020 20:15:05 -0700
Message-ID: <CAEf4BzYf64VEEMJaF8jS=KjRw7UQzOhNJpXW0+YtQZ+TxpT2aQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] bpf: Add kernel module with user mode driver
 that populates bpffs.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 1:04 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Add kernel module with user mode driver that populates bpffs with
> BPF iterators.
>
> $ mount bpffs /sys/fs/bpf/ -t bpf
> $ ls -la /sys/fs/bpf/
> total 4
> drwxrwxrwt  2 root root    0 Jul  2 00:27 .
> drwxr-xr-x 19 root root 4096 Jul  2 00:09 ..
> -rw-------  1 root root    0 Jul  2 00:27 maps
> -rw-------  1 root root    0 Jul  2 00:27 progs
>
> The user mode driver will load BPF Type Formats, create BPF maps, populate BPF
> maps, load two BPF programs, attach them to BPF iterators, and finally send two
> bpf_link IDs back to the kernel.
> The kernel will pin two bpf_links into newly mounted bpffs instance under
> names "progs" and "maps". These two files become human readable.
>
> $ cat /sys/fs/bpf/progs
>   id name            pages attached
>   11    dump_bpf_map     1 bpf_iter_bpf_map
>   12   dump_bpf_prog     1 bpf_iter_bpf_prog
>   27 test_pkt_access     1
>   32       test_main     1 test_pkt_access test_pkt_access
>   33   test_subprog1     1 test_pkt_access_subprog1 test_pkt_access
>   34   test_subprog2     1 test_pkt_access_subprog2 test_pkt_access
>   35   test_subprog3     1 test_pkt_access_subprog3 test_pkt_access
>   36 new_get_skb_len     1 get_skb_len test_pkt_access
>   37 new_get_skb_ifi     1 get_skb_ifindex test_pkt_access
>   38 new_get_constan     1 get_constant test_pkt_access
>
> The BPF program dump_bpf_prog() in iterators.bpf.c is printing this data about
> all BPF programs currently loaded in the system. This information is unstable
> and will change from kernel to kernel.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

[...]

> +static int bpf_link_pin_kernel(struct dentry *parent,
> +                              const char *name, struct bpf_link *link)
> +{
> +       umode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
> +       struct dentry *dentry;
> +       int ret;
> +
> +       inode_lock(parent->d_inode);
> +       dentry = lookup_one_len(name, parent, strlen(name));
> +       if (IS_ERR(dentry)) {
> +               inode_unlock(parent->d_inode);
> +               return PTR_ERR(dentry);
> +       }
> +       ret = bpf_mkobj_ops(dentry, mode, link, &bpf_link_iops,
> +                           &bpf_iter_fops);

bpf_iter_fops only applies to bpf_iter links, while
bpf_link_pin_kernel allows any link type. See bpf_mklink(), it checks
bpf_link_is_iter() to decide between bpf_iter_fops and bpffs_obj_fops.


> +       dput(dentry);
> +       inode_unlock(parent->d_inode);
> +       return ret;
> +}
> +
>  static int bpf_obj_do_pin(const char __user *pathname, void *raw,
>                           enum bpf_type type)
>  {
> @@ -638,6 +659,57 @@ static int bpf_parse_param(struct fs_context *fc, struct fs_parameter *param)
>         return 0;
>  }
>
> +struct bpf_preload_ops bpf_preload_ops = { .info.driver_name = "bpf_preload" };
> +EXPORT_SYMBOL_GPL(bpf_preload_ops);
> +
> +static int populate_bpffs(struct dentry *parent)

So all the pinning has to happen from the kernel side because at the
time that bpf_fill_super is called, user-space can't yet see the
mounted BPFFS, do I understand the problem correctly? Would it be
possible to add callback to fs_context_operations that would be called
after FS is mounted and visible to user-space? At that point the
kernel can spawn the user-mode blob and just instruct it to do both
BPF object loading and pinning?

Or are there some other complications with such approach?

> +{
> +       struct bpf_link *links[BPF_PRELOAD_LINKS] = {};
> +       u32 link_id[BPF_PRELOAD_LINKS] = {};
> +       int err = 0, i;
> +
> +       mutex_lock(&bpf_preload_ops.lock);
> +       if (!bpf_preload_ops.do_preload) {
> +               mutex_unlock(&bpf_preload_ops.lock);
> +               request_module("bpf_preload");
> +               mutex_lock(&bpf_preload_ops.lock);
> +
> +               if (!bpf_preload_ops.do_preload) {
> +                       pr_err("bpf_preload module is missing.\n"
> +                              "bpffs will not have iterators.\n");
> +                       goto out;
> +               }
> +       }
> +
> +       if (!bpf_preload_ops.info.tgid) {
> +               err = bpf_preload_ops.do_preload(link_id);
> +               if (err)
> +                       goto out;
> +               for (i = 0; i < BPF_PRELOAD_LINKS; i++) {
> +                       links[i] = bpf_link_by_id(link_id[i]);
> +                       if (IS_ERR(links[i])) {
> +                               err = PTR_ERR(links[i]);
> +                               goto out;
> +                       }
> +               }
> +               err = bpf_link_pin_kernel(parent, "maps", links[0]);
> +               if (err)
> +                       goto out;
> +               err = bpf_link_pin_kernel(parent, "progs", links[1]);
> +               if (err)
> +                       goto out;

This hard coded "maps" -> link #0, "progs" -> link #1 mapping is what
motivated the question above about letting user-space do all pinning.
It would significantly simplify the kernel part, right?

> +               err = bpf_preload_ops.do_finish();
> +               if (err)
> +                       goto out;
> +       }

[...]
