Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEA052A8B8
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 18:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351275AbiEQQ6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 12:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347238AbiEQQ6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 12:58:09 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D414FC56;
        Tue, 17 May 2022 09:58:08 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id e20so1898337qvr.6;
        Tue, 17 May 2022 09:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zag6DxyUvX35uCpSTZxUOhCfsgCuB2xeq5nyKpnfous=;
        b=aBvv7qbEuM5NOK3+ms6RjRMvBBgwoYcmyMWEJ2iAj+Z6C4UoNLxpGtx0dTrTVKbZyI
         0764LNEo1doQjfRHRBHMytNVoRvB+SaLNlTi2PksdbJZuZX9pJASZbAWdNz+KRZAX9S4
         K6zeDGxpNYqm3M5ariW1ZapeflzxN9VQ2esmRbg0SMxaksjNGT4FRv4KmoxuM90r6QsS
         72gtk9imp5a7Yf/5L72DUC+fnnV31SkMTSoo++hNq7EVJJUkUsUW5NXhiBekuINSlU9V
         uvBhHKLGvuv9q3ORJUxP263ruNJZM/35ID3sE4gzCgw5bkJfN8RSNuKLJDRYjn7EmJCX
         RcVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zag6DxyUvX35uCpSTZxUOhCfsgCuB2xeq5nyKpnfous=;
        b=du4FLCdAP/dzt1OaETFN7pq6b+1oqcpz2RX9WA2QbH0rG2Pv4BcOk7v1hJ+QcPduqn
         Rl/4BXn/Ef3cNLWtCR5mbvutkWS5skPh3GVrbkqFXGHQ7sQ0Hn6EJ5lTtWrf5eVE4KSD
         kueYzHT6ZsW3GbXtP0zyg4oetIpHO+A41HH9cacdY2NQKBqMQDFbx8+KUK3gW3gopU/D
         EncIXc5ZBCwJwj1eDTbiryTIi8vTJV9iMJ0LkEsJhvQsc6IyxS3ZVyHI/RQASdTZ1c5A
         ZrYO6UtSUvs/8+gWUQEGb/0miAEYZHPMwFXEAfCFjn1pk/7z2w4Prr9IxZywCZMK4NZ+
         krFA==
X-Gm-Message-State: AOAM532nV/RAdv2HwfwFFG4R86PVocCsacjDcwmfFzcaR8LfQMe2HLgI
        1GctQxvPhbRBKqeWOiE3/d1sJBrxuXWYbCGolYeaynIPhLs=
X-Google-Smtp-Source: ABdhPJzRetzGWaJgM5Bm8XUyu7JFJUNEPNIplk6KRyI2Mbb/gbaZFn5rwik9ILly613XvLY63cw4sgsA4PSnFm+j93s=
X-Received: by 2002:ad4:5c6e:0:b0:45a:aefd:f551 with SMTP id
 i14-20020ad45c6e000000b0045aaefdf551mr21174026qvh.95.1652806687381; Tue, 17
 May 2022 09:58:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220517034107.92194-1-imagedong@tencent.com>
In-Reply-To: <20220517034107.92194-1-imagedong@tencent.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 17 May 2022 09:57:56 -0700
Message-ID: <CAADnVQLRmv107zFL-dgB07Mf8NmR0TCAC9eG9aZ1O4DG3=ityw@mail.gmail.com>
Subject: Re: [PATCH] bpf: add access control for map
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alan Maguire <alan.maguire@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 8:44 PM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> Hello,
>
> I have a idea about the access control of eBPF map, could you help
> to see if it works?
>
> For now, only users with the CAP_SYS_ADMIN or CAP_BPF have the right
> to access the data in eBPF maps. So I'm thinking, are there any way
> to control the access to the maps, just like what we do to files?

The bpf objects pinned in bpffs should always be accessible
as files regardless of sysctl or cap-s.

> Therefore, we can decide who have the right to read the map and who
> can write.
>
> I think it is useful in some case. For example, I made a eBPF-based
> network statistics program, and the information is stored in an array
> map. And I want all users can read the information in the map, without
> changing the capacity of them. As the information is iunsensitive,
> normal users can read it. This make publish-consume mode possible,
> the eBPF program is publisher and the user space program is consumer.

Right. It is a choice of the bpf prog which data expose in the map.

> So this aim can be achieve, if we can control the access of maps as a
> file. There are many ways I thought, and I choosed one to implement:
>
> While pining the map, add the inode that is created to a list on the
> map. root can change the permission of the inode through the pin path.
> Therefore, we can try to find the inode corresponding to current user
> namespace in the list, and check whether user have permission to read
> or write.
>
> The steps can be:
>
> 1. create the map with BPF_F_UMODE flags, which imply that enable
>    access control in this map.
> 2. load and pin the map on /sys/fs/bpf/xxx.
> 3. change the umode of /sys/fs/bpf/xxx with 'chmod 744 /sys/fs/bpf/xxx',
>    therefor all user can read the map.

This behavior should be available by default.
Only sysctl was preventing it. It's being fixed by
the following patch. Please take a look at:
https://patchwork.kernel.org/project/netdevbpf/patch/1652788780-25520-2-git-send-email-alan.maguire@oracle.com/

Does it solve your use case?

> @@ -542,14 +557,26 @@ int bpf_obj_get_user(const char __user *pathname, int flags)
>         if (IS_ERR(raw))
>                 return PTR_ERR(raw);
>
> -       if (type == BPF_TYPE_PROG)
> +       if (type != BPF_TYPE_MAP && !bpf_capable())
> +               return -EPERM;

obj_get already implements normal ACL style access to files.
Let's not fragment this security model with extra cap checks.

> +
> +       switch (type) {
> +       case BPF_TYPE_PROG:
>                 ret = bpf_prog_new_fd(raw);
> -       else if (type == BPF_TYPE_MAP)
> +               break;
> +       case BPF_TYPE_MAP:
> +               if (bpf_map_permission(raw, f_flags)) {
> +                       bpf_any_put(raw, type);
> +                       return -EPERM;
> +               }

bpf_obj_do_get() already does such check.

> +int bpf_map_permission(struct bpf_map *map, int flags)
> +{
> +       struct bpf_map_inode *map_inode;
> +       struct user_namespace *ns;
> +
> +       if (capable(CAP_SYS_ADMIN))
> +               return 0;
> +
> +       if (!(map->map_flags & BPF_F_UMODE))
> +               return -1;
> +
> +       rcu_read_lock();
> +       list_for_each_entry_rcu(map_inode, &map->inode_list, list) {
> +               ns = map_inode->inode->i_sb->s_user_ns;
> +               if (ns == current_user_ns())
> +                       goto found;
> +       }
> +       rcu_read_unlock();
> +       return -1;
> +found:
> +       rcu_read_unlock();
> +       return inode_permission(ns, map_inode->inode, ACC_MODE(flags));
> +}

See path_permission() in bpf_obj_do_get().

>  static int bpf_map_get_fd_by_id(const union bpf_attr *attr)
> @@ -3720,9 +3757,6 @@ static int bpf_map_get_fd_by_id(const union bpf_attr *attr)
>             attr->open_flags & ~BPF_OBJ_FLAG_MASK)
>                 return -EINVAL;
>
> -       if (!capable(CAP_SYS_ADMIN))
> -               return -EPERM;
> -

This part we cannot relax.
What you're trying to do is to bypass path checks
by pointing at a map with its ID only.
That contradicts to your official goal in the cover letter.

bpf_map_get_fd_by_id() has to stay cap_sys_admin only.
Exactly for the reason that bpf subsystem has file ACL style.
fd_by_id is a debug interface used by tools like bpftool and
root admin that needs to see the system as a whole.
Normal tasks/processes need to use bpffs and pin files with
correct permissions to pass maps from one process to another.
Or use FD passing kernel facilities.
