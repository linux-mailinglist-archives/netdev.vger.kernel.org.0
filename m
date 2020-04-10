Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 935991A4C09
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 00:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgDJWZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 18:25:28 -0400
Received: from mail-qv1-f65.google.com ([209.85.219.65]:36747 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbgDJWZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 18:25:28 -0400
Received: by mail-qv1-f65.google.com with SMTP id o15so1661944qvl.3;
        Fri, 10 Apr 2020 15:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E8YkzCFP5nolcIOAwtOLrccsuQY8xpA7hxmqnOBhnO8=;
        b=OjSQYhObB5PbrVkT9oNXgYCDiTho/E79lggHHukymogMN3LE6F23/GtFftQnkSHaAY
         t6omK3M5AUebCT8U5sWpWN7SphmvvF8TzeK0t/Wh+oabMa++wpEf71+fO1wR7Ztzouvr
         fxzfbNFbrlEpqNCE9M3Ef3WEDXHgxS7nAgTq/hwiOrK+3F+X3demM6VcYuxyxCNFNhox
         ip6dDqyJcjAG3436fMvY7Q3DHb9GByoGxhd0sPxvET4d87o8aLBruwg/Kh3BGUdYLuoR
         tipFrN3gRW6ufD7nRjBjuE1cLUoiKtoo2i14HjNjQYn07XOUKbBZMeYYlQrffrXz/K1A
         2RUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E8YkzCFP5nolcIOAwtOLrccsuQY8xpA7hxmqnOBhnO8=;
        b=GvmPc+Y1Hlafn8oO6zpbGr9e2fpab8F9iULN7wde3Ic+2CCBUZlgvEgdYO/iKSDtLM
         EkAXL/IXexqDP5nl+bjrslDC/nLXjwBXI7iaGhWA0SmwJKt54WK2j2ayhl0OW1NCMHZE
         xlEbAfhDmPWXhTzKp1XB+gn5zxJTQbQ1xz5C6es/MT8QuRqrRAXUVexL/HHllhVnj8/7
         iN0tp57PXWRyo0BmhQK7mflO1ygiucxhtZBinUND5CSppwRhtM77LjIFa3SxYBKtknGu
         Z1uCtiybL9I03WuYAR24ybgUARCyS4GH6YTSX9PToW2FYcaZyhsGHKhVcxcLgWzqslxG
         HY2A==
X-Gm-Message-State: AGi0PuYQOdhAUvCTLomYcVZSpquFEFdHIX9clYHF548FpS54IleYCahm
        bL2/rIB40YOKEcnk5f7OKRniGafPZ36ZlqZFD+w=
X-Google-Smtp-Source: APiQypLSNCHr71KVU0Rj3h58lGQ0RuETtGSDTjn18/4CXgGJ9E8uHupII6R3H61Ip/kUEkfrI+CNDiPirH1uPqV4Izo=
X-Received: by 2002:ad4:568b:: with SMTP id bc11mr6861932qvb.228.1586557527354;
 Fri, 10 Apr 2020 15:25:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232523.2675550-1-yhs@fb.com>
In-Reply-To: <20200408232523.2675550-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 10 Apr 2020 15:25:16 -0700
Message-ID: <CAEf4BzYd5gkytGookaVU_nCVVyxTYM1Z4ohqPFZW2YSY2VJ9Fg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 03/16] bpf: provide a way for targets to
 register themselves
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

On Wed, Apr 8, 2020 at 4:26 PM Yonghong Song <yhs@fb.com> wrote:
>
> Here, the target refers to a particular data structure
> inside the kernel we want to dump. For example, it
> can be all task_structs in the current pid namespace,
> or it could be all open files for all task_structs
> in the current pid namespace.
>
> Each target is identified with the following information:
>    target_rel_path   <=== relative path to /sys/kernel/bpfdump
>    target_proto      <=== kernel func proto which represents
>                           bpf program signature for this target
>    seq_ops           <=== seq_ops for seq_file operations
>    seq_priv_size     <=== seq_file private data size
>    target_feature    <=== target specific feature which needs
>                           handling outside seq_ops.
>
> The target relative path is a relative directory to /sys/kernel/bpfdump/.
> For example, it could be:
>    task                  <=== all tasks
>    task/file             <=== all open files under all tasks
>    ipv6_route            <=== all ipv6_routes
>    tcp6/sk_local_storage <=== all tcp6 socket local storages
>    foo/bar/tar           <=== all tar's in bar in foo
>
> The "target_feature" is mostly used for reusing existing seq_ops.
> For example, for /proc/net/<> stats, the "net" namespace is often
> stored in file private data. The target_feature enables bpf based
> dumper to set "net" properly for itself before calling shared
> seq_ops.
>
> bpf_dump_reg_target() is implemented so targets
> can register themselves. Currently, module is not
> supported, so there is no bpf_dump_unreg_target().
> The main reason is that BTF is not available for modules
> yet.
>
> Since target might call bpf_dump_reg_target() before
> bpfdump mount point is created, __bpfdump_init()
> may be called in bpf_dump_reg_target() as well.
>
> The file-based dumpers will be regular files under
> the specific target directory. For example,
>    task/my1      <=== dumper "my1" iterates through all tasks
>    task/file/my2 <=== dumper "my2" iterates through all open files
>                       under all tasks
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h |   4 +
>  kernel/bpf/dump.c   | 190 +++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 193 insertions(+), 1 deletion(-)
>

[...]

> +
> +static int dumper_unlink(struct inode *dir, struct dentry *dentry)
> +{
> +       kfree(d_inode(dentry)->i_private);
> +       return simple_unlink(dir, dentry);
> +}
> +
> +static const struct inode_operations bpf_dir_iops = {

noticed this reading next patch. It should probably be called
bpfdump_dir_iops to avoid confusion with bpf_dir_iops of BPF FS in
kernel/bpf/inode.c?

> +       .lookup         = simple_lookup,
> +       .unlink         = dumper_unlink,
> +};
> +

[...]
