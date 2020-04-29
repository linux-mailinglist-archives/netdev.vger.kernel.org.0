Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7DB1BD531
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 08:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgD2G40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 02:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgD2G4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 02:56:25 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E39C03C1AD;
        Tue, 28 Apr 2020 23:56:25 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id n143so970978qkn.8;
        Tue, 28 Apr 2020 23:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lse1PmF8wwV6C/VCGw2oagFOZa7yvyxlL+x7mvbMGMA=;
        b=dk8XNT3KVAgKroUsD74emmO97xjS7kLxJI8dlj+nDKJ6k7vRbQGiqkiqJnLfWFtw7d
         vSTMBkdySgjJhYGUs7neYVW8kOjod/YADnhnfqHZ3NIh9EotbSUAnnaG6N85GA4An+VO
         mHTOcwJz5Ar8xnvU5tbop7lELvjchCiHCoa9rt5mJ0ltireRMiyNN6T9ai+afDHgbuml
         8ne8/vCKrO5UvnQYuRAXrR4BCyYkfwlkkuXtBd/+ryKVpulB8RjOUx8gVwME5fGdatHV
         PqSkVRLK5d7rWSXw4WzY8FjdkKpB4nRLClbG8mIjDVceD8HIxpd+k5ze4ACQi4VX6p/X
         AtJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lse1PmF8wwV6C/VCGw2oagFOZa7yvyxlL+x7mvbMGMA=;
        b=T85OI12uQEzOrsQbDAJqUjcSBg1YEjcAdMG34Kk9lL4vC/wFXrGHZrhS7XvGBoxJp9
         cpFSuMQfbePySzFE6N+hS+HrCzgnAglZvVmokidP1JU801KjQ46+8aRJkCK44+i6PMTs
         LZg08DeT7gzRSadqZBhhrNjkAkdhhuyO8lqvtUYMzo2bBb2Js3f/c/2jRSpguBTW4eOp
         5GMswC3aIJlogDqyB2kJ2qqoGKl43ph6rR0UduK8IuIAJamtsjKohaa8db/4nmJpEExd
         370M9yRqa3lSb8X1ItNEgQOQLqw+Lwo6xN27Ea4iTSHSZJxrGg/V5jR7ienuqrNj1FzW
         RpBQ==
X-Gm-Message-State: AGi0PubBMey93C1TenM0l+AONiv6/2Ng+uzF+cLTCTUrXo8sGkDBvzMo
        RS/Dtoci8iyRTxGppGUGHqoDyc4BAPs4or6OiCugwMCGcns=
X-Google-Smtp-Source: APiQypK/ZmN+wD+HI3WFQ/bYBd/YF14F/gHlf9WO0viFodQ3xZ1sSfxNXGthoe3cL6eV2R0H2Xz3fGoDMMniD0dGxfA=
X-Received: by 2002:a37:787:: with SMTP id 129mr30960891qkh.92.1588143384406;
 Tue, 28 Apr 2020 23:56:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200427201235.2994549-1-yhs@fb.com> <20200427201242.2995160-1-yhs@fb.com>
In-Reply-To: <20200427201242.2995160-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Apr 2020 23:56:13 -0700
Message-ID: <CAEf4BzYtxOrzSW6Yy+0ABbm0Q71dkZTGDOcGCgHCVT=4ty5k1g@mail.gmail.com>
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
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 4fc39d9b5cd0..0f0cafc65a04 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1112,6 +1112,8 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
>  int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
>  int bpf_obj_get_user(const char __user *pathname, int flags);
>
> +#define BPF_DUMP_SEQ_NET_PRIVATE       BIT(0)
> +
>  struct bpf_iter_reg {
>         const char *target;
>         const char *target_func_name;
> @@ -1133,6 +1135,7 @@ int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx);
>  int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
>  int bpf_iter_link_replace(struct bpf_link *link, struct bpf_prog *old_prog,
>                           struct bpf_prog *new_prog);
> +int bpf_iter_new_fd(struct bpf_link *link);
>
>  int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
>  int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index f39b9fec37ab..576651110d16 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -113,6 +113,7 @@ enum bpf_cmd {
>         BPF_MAP_DELETE_BATCH,
>         BPF_LINK_CREATE,
>         BPF_LINK_UPDATE,
> +       BPF_ITER_CREATE,
>  };
>
>  enum bpf_map_type {
> @@ -590,6 +591,11 @@ union bpf_attr {
>                 __u32           old_prog_fd;
>         } link_update;
>
> +       struct { /* struct used by BPF_ITER_CREATE command */
> +               __u32           link_fd;
> +               __u32           flags;
> +       } iter_create;
> +
>  } __attribute__((aligned(8)));
>
>  /* The description below is an attempt at providing documentation to eBPF
> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
> index fc1ce5ee5c3f..1f4e778d1814 100644
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
> @@ -19,6 +20,19 @@ struct bpf_iter_link {
>         struct bpf_iter_target_info *tinfo;
>  };
>
> +struct extra_priv_data {
> +       struct bpf_prog *prog;
> +       u64 session_id;
> +       u64 seq_num;
> +       bool has_last;
> +};
> +
> +struct anon_file_prog_assoc {
> +       struct list_head list;
> +       struct file *file;
> +       struct bpf_prog *prog;
> +};
> +
>  static struct list_head targets;
>  static struct mutex targets_mutex;
>  static bool bpf_iter_inited = false;
> @@ -26,6 +40,50 @@ static bool bpf_iter_inited = false;
>  /* protect bpf_iter_link.link->prog upddate */
>  static struct mutex bpf_iter_mutex;
>
> +/* Since at anon seq_file release function, the prog cannot
> + * be retrieved since target seq_priv_size is not available.
> + * Keep a list of <anon_file, prog> mapping, so that
> + * at file release stage, the prog can be released properly.
> + */
> +static struct list_head anon_iter_info;
> +static struct mutex anon_iter_info_mutex;
> +
> +/* incremented on every opened seq_file */
> +static atomic64_t session_id;
> +
> +static u32 get_total_priv_dsize(u32 old_size)
> +{
> +       return roundup(old_size, 8) + sizeof(struct extra_priv_data);
> +}
> +
> +static void *get_extra_priv_dptr(void *old_ptr, u32 old_size)
> +{
> +       return old_ptr + roundup(old_size, 8);
> +}
> +
> +static int anon_iter_release(struct inode *inode, struct file *file)
> +{
> +       struct anon_file_prog_assoc *finfo;
> +
> +       mutex_lock(&anon_iter_info_mutex);
> +       list_for_each_entry(finfo, &anon_iter_info, list) {
> +               if (finfo->file == file) {

I'll look at this and other patches more thoroughly tomorrow with
clear head, but this iteration to find anon_file_prog_assoc is really
unfortunate.

I think the problem is that you are allowing seq_file infrastructure
to call directly into target implementation of seq_operations without
intercepting them. If you change that and put whatever extra info is
necessary into seq_file->private in front of target's private state,
then you shouldn't need this, right?

This would also make each target's logic a bit simpler because you can:
- centralize creation and initialization of bpf_iter_meta (session_id,
seq, seq_num will be set up once in this generic code);
- loff_t pos increments;
- you can extract and centralize bpf_iter_get_prog() call in show()
implementation as well.

I think with that each target's logic will be simpler and you won't
need to maintain anon_file_prog_assocs.

Are there complications I'm missing?

[...]
