Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C69C1A6C81
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 21:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387874AbgDMTbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 15:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728291AbgDMTbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 15:31:35 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842AAC0A3BDC;
        Mon, 13 Apr 2020 12:31:34 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id b10so8110454qtt.9;
        Mon, 13 Apr 2020 12:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZIcWR1wfhkI+lSRNsf5YqGQchO1vzXNmyHuJ72XuZLs=;
        b=ou63s+l1Qp8aBGl3Mpyg/sgL4YQMxxcJQmWeTV53779rO5WDQxO5+a/1ir+0KHYmvX
         WXLlEPEJpQrCOs7njyMD01wC4/YJwjvZeIVnb4geT8P+VDlrJVn4oyOB1t9zogHHdb8L
         8yKEmXaoQIE8+s3DB99ucM4yZTXj+adFKlkb7/78dpoYtRhGtRbxQJVMmgdcfO8hUhTn
         NB6C3bQmOsNEHa0XOgoKbyyiHN1ofhQNLHiDrFOqfEaLa54WT66vY+tmgVkrybk4BjoW
         artBpelrpz7uWYsdQOV5hlQdvDADN1+lLe6kdaHp+MmkvUGTDFiuHTlLIIsRnSRbFUcY
         ebog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZIcWR1wfhkI+lSRNsf5YqGQchO1vzXNmyHuJ72XuZLs=;
        b=fiE8YqY/frycE+dyUIZWW+aiQZdxrR8GIj9sXkWc0PlDpp6VHbmUMxwMuagJsUprrk
         2PVK01EEKWbGroDLqmmI4vTOitdjYpCLfqJngCllCNymOtjuItYowacqZsWm0jSpMO4j
         KkAdX9qF14M+sd7cOSYQDK/QYt/ZoKiumSlNeJ09qywa+qDMEw88NkSI48xHPe1ntMvw
         H5JX7aCjahqqDuwoesLRidWQqfg0X1wtiMwOy4K5oPHHSmRHWjVE6TZMPIdMgPSLjFpA
         saI6FI3/WDCJZBzbRkt/P1PtAulf5Yklgcp+YJvRZfn45zYtYG7YSQxCO6EcBeKi1UZs
         e+lA==
X-Gm-Message-State: AGi0PuZXhSzNuxbnYnXcosvW8U126NfBkmMUyrxhlDrVqCiFj8nlJgQo
        +ImKLYER59zbq3IQGwOPW1gHCuhi9+JS9afgFNPv///L
X-Google-Smtp-Source: APiQypL01bxoAnhuWgoVqY9C9TwBLEFCDIGT9RBHtcS1eM8xxdclA4ZB0zXQm/xBRAo7zkXMzgnMlwXaav4w9H7M4bk=
X-Received: by 2002:ac8:1744:: with SMTP id u4mr6229887qtk.141.1586806293495;
 Mon, 13 Apr 2020 12:31:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232523.2675550-1-yhs@fb.com>
 <CAEf4Bzb5K6h+Cca63JU35XG+NFoFDCVrC=DhDNVz6KTmoyzpFw@mail.gmail.com> <904ce2a9-6318-9360-c1d5-16cb07c9ca5a@fb.com>
In-Reply-To: <904ce2a9-6318-9360-c1d5-16cb07c9ca5a@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Apr 2020 12:31:22 -0700
Message-ID: <CAEf4BzaYpNoFvs45r2Ymf-p1ZJ6-G8KphtOHMX1TL=qEJQVoPg@mail.gmail.com>
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

On Fri, Apr 10, 2020 at 4:24 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/10/20 3:18 PM, Andrii Nakryiko wrote:
> > On Wed, Apr 8, 2020 at 4:26 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >> Here, the target refers to a particular data structure
> >> inside the kernel we want to dump. For example, it
> >> can be all task_structs in the current pid namespace,
> >> or it could be all open files for all task_structs
> >> in the current pid namespace.
> >>
> >> Each target is identified with the following information:
> >>     target_rel_path   <=== relative path to /sys/kernel/bpfdump
> >>     target_proto      <=== kernel func proto which represents
> >>                            bpf program signature for this target
> >>     seq_ops           <=== seq_ops for seq_file operations
> >>     seq_priv_size     <=== seq_file private data size
> >>     target_feature    <=== target specific feature which needs
> >>                            handling outside seq_ops.
> >
> > It's not clear what "feature" stands for here... Is this just a sort
> > of private_data passed through to dumper?
>
> This is described later. It is some kind of target passed to the dumper.
>
> >
> >>
> >> The target relative path is a relative directory to /sys/kernel/bpfdump/.
> >> For example, it could be:
> >>     task                  <=== all tasks
> >>     task/file             <=== all open files under all tasks
> >>     ipv6_route            <=== all ipv6_routes
> >>     tcp6/sk_local_storage <=== all tcp6 socket local storages
> >>     foo/bar/tar           <=== all tar's in bar in foo
> >
> > ^^ this seems useful, but I don't think code as is supports more than 2 levels?
>
> Currently implement should support it.
> You need
>   - first register 'foo'. target name 'foo'.
>   - then register 'foo/bar'. 'foo' will be the parent of 'bar'. target
> name 'foo/bar'.
>   - then 'foo/bar/tar'. 'foo/bar' will be the parent of 'tar'. target
> name 'foo/bar/tar'.

Ah, I see, right, that would work. Please disregard then.

>
> >
> >>
> >> The "target_feature" is mostly used for reusing existing seq_ops.
> >> For example, for /proc/net/<> stats, the "net" namespace is often
> >> stored in file private data. The target_feature enables bpf based
> >> dumper to set "net" properly for itself before calling shared
> >> seq_ops.
> >>
> >> bpf_dump_reg_target() is implemented so targets
> >> can register themselves. Currently, module is not
> >> supported, so there is no bpf_dump_unreg_target().
> >> The main reason is that BTF is not available for modules
> >> yet.
> >>
> >> Since target might call bpf_dump_reg_target() before
> >> bpfdump mount point is created, __bpfdump_init()
> >> may be called in bpf_dump_reg_target() as well.
> >>
> >> The file-based dumpers will be regular files under
> >> the specific target directory. For example,
> >>     task/my1      <=== dumper "my1" iterates through all tasks
> >>     task/file/my2 <=== dumper "my2" iterates through all open files
> >>                        under all tasks
> >>
> >> Signed-off-by: Yonghong Song <yhs@fb.com>
> >> ---
> >>   include/linux/bpf.h |   4 +
> >>   kernel/bpf/dump.c   | 190 +++++++++++++++++++++++++++++++++++++++++++-
> >>   2 files changed, 193 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> >> index fd2b2322412d..53914bec7590 100644
> >> --- a/include/linux/bpf.h
> >> +++ b/include/linux/bpf.h
> >> @@ -1109,6 +1109,10 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
> >>   int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
> >>   int bpf_obj_get_user(const char __user *pathname, int flags);
> >>
> >> +int bpf_dump_reg_target(const char *target, const char *target_proto,
> >> +                       const struct seq_operations *seq_ops,
> >> +                       u32 seq_priv_size, u32 target_feature);
> >> +
> >>   int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
> >>   int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
> >>   int bpf_percpu_hash_update(struct bpf_map *map, void *key, void *value,
> >> diff --git a/kernel/bpf/dump.c b/kernel/bpf/dump.c
> >> index e0c33486e0e7..45528846557f 100644
> >> --- a/kernel/bpf/dump.c
> >> +++ b/kernel/bpf/dump.c
> >> @@ -12,6 +12,173 @@
> >>   #include <linux/filter.h>
> >>   #include <linux/bpf.h>
> >>
> >> +struct bpfdump_target_info {
> >> +       struct list_head list;
> >> +       const char *target;
> >> +       const char *target_proto;
> >> +       struct dentry *dir_dentry;
> >> +       const struct seq_operations *seq_ops;
> >> +       u32 seq_priv_size;
> >> +       u32 target_feature;
> >> +};
> >> +
> >> +struct bpfdump_targets {
> >> +       struct list_head dumpers;
> >> +       struct mutex dumper_mutex;
> >
> > nit: would be a bit simpler if these were static variables with static
> > initialization, similar to how bpfdump_dentry is separate?
>
> yes, we could do that. not 100% sure whether it will be simpler or not.
> the structure is to glue them together.
>
> >
> >> +};
> >> +
> >> +/* registered dump targets */
> >> +static struct bpfdump_targets dump_targets;
> >> +
> >> +static struct dentry *bpfdump_dentry;
> >> +
> >> +static struct dentry *bpfdump_add_dir(const char *name, struct dentry *parent,
> >> +                                     const struct inode_operations *i_ops,
> >> +                                     void *data);
> >> +static int __bpfdump_init(void);
> >> +
> >> +static int dumper_unlink(struct inode *dir, struct dentry *dentry)
> >> +{
> >> +       kfree(d_inode(dentry)->i_private);
> >> +       return simple_unlink(dir, dentry);
> >> +}
> >> +
> >> +static const struct inode_operations bpf_dir_iops = {
> >> +       .lookup         = simple_lookup,
> >> +       .unlink         = dumper_unlink,
> >> +};
> >> +
> >> +int bpf_dump_reg_target(const char *target,
> >> +                       const char *target_proto,
> >> +                       const struct seq_operations *seq_ops,
> >> +                       u32 seq_priv_size, u32 target_feature)
> >> +{
> >> +       struct bpfdump_target_info *tinfo, *ptinfo;
> >> +       struct dentry *dentry, *parent;
> >> +       const char *lastslash;
> >> +       bool existed = false;
> >> +       int err, parent_len;
> >> +
> >> +       if (!bpfdump_dentry) {
> >> +               err = __bpfdump_init();
> >
> > This will be called (again) if bpfdump_init() fails? Not sure why? In
> > rare cases, some dumper will fail to initialize, but then some might
> > succeed, which is going to be even more confusing, no?
>
> I can have a static variable to say bpfdump_init has been attempted to
> avoid such situation to avoid any second try.
>
> >
> >> +               if (err)
> >> +                       return err;
> >> +       }
> >> +
> >> +       tinfo = kmalloc(sizeof(*tinfo), GFP_KERNEL);
> >> +       if (!tinfo)
> >> +               return -ENOMEM;
> >> +
> >> +       tinfo->target = target;
> >> +       tinfo->target_proto = target_proto;
> >> +       tinfo->seq_ops = seq_ops;
> >> +       tinfo->seq_priv_size = seq_priv_size;
> >> +       tinfo->target_feature = target_feature;
> >> +       INIT_LIST_HEAD(&tinfo->list);
> >> +
> >> +       lastslash = strrchr(target, '/');
> >> +       if (!lastslash) {
> >> +               parent = bpfdump_dentry;
> >
> > Two nits here. First, it supports only one and two levels. But it
> > seems like it wouldn't be hard to support multiple? Instead of
> > reverse-searching for /, you can forward search and keep track of
> > "current parent".
> >
> > nit2:
> >
> > parent = bpfdump_dentry;
> > if (lastslash) {
> >
> >      parent = ptinfo->dir_dentry;
> > }
> >
> > seems a bit cleaner (and generalizes to multi-level a bit better).
> >
> >> +       } else {
> >> +               parent_len = (unsigned long)lastslash - (unsigned long)target;
> >> +
> >> +               mutex_lock(&dump_targets.dumper_mutex);
> >> +               list_for_each_entry(ptinfo, &dump_targets.dumpers, list) {
> >> +                       if (strlen(ptinfo->target) == parent_len &&
> >> +                           strncmp(ptinfo->target, target, parent_len) == 0) {
> >> +                               existed = true;
> >> +                               break;
> >> +                       }
> >> +               }
> >> +               mutex_unlock(&dump_targets.dumper_mutex);
> >> +               if (existed == false) {
> >> +                       err = -ENOENT;
> >> +                       goto free_tinfo;
> >> +               }
> >> +
> >> +               parent = ptinfo->dir_dentry;
> >> +               target = lastslash + 1;
> >> +       }
> >> +       dentry = bpfdump_add_dir(target, parent, &bpf_dir_iops, tinfo);
> >> +       if (IS_ERR(dentry)) {
> >> +               err = PTR_ERR(dentry);
> >> +               goto free_tinfo;
> >> +       }
> >> +
> >> +       tinfo->dir_dentry = dentry;
> >> +
> >> +       mutex_lock(&dump_targets.dumper_mutex);
> >> +       list_add(&tinfo->list, &dump_targets.dumpers);
> >> +       mutex_unlock(&dump_targets.dumper_mutex);
> >> +       return 0;
> >> +
> >> +free_tinfo:
> >> +       kfree(tinfo);
> >> +       return err;
> >> +}
> >> +
> >
> > [...]
> >
> >> +       if (S_ISDIR(mode)) {
> >> +               inode->i_op = i_ops;
> >> +               inode->i_fop = f_ops;
> >> +               inc_nlink(inode);
> >> +               inc_nlink(dir);
> >> +       } else {
> >> +               inode->i_fop = f_ops;
> >> +       }
> >> +
> >> +       d_instantiate(dentry, inode);
> >> +       dget(dentry);
> >
> > lookup_one_len already bumped refcount, why the second time here?
>
> good question. this is what security/inode.c is doing and seems working.
> do not really know the science behind this. will check more.

sounds good

>
> >
> >> +       inode_unlock(dir);
> >> +       return dentry;
> >> +
> >> +dentry_put:
> >> +       dput(dentry);
> >> +       dentry = ERR_PTR(err);
> >> +unlock:
> >> +       inode_unlock(dir);
> >> +       return dentry;
> >> +}
> >> +
> >
> > [...]
> >
