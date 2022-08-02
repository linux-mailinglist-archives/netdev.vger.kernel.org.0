Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99EE25883BF
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 23:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbiHBVrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 17:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbiHBVre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 17:47:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E47425C79
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 14:47:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C515B819F1
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 21:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FEFC4347C
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 21:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659476850;
        bh=bw7ZR3OubmcRjpwNuSpXxWiUDJEe/z23F1fjfbai/Z8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OvLbgmDndBHNQP0tVJ1hHSrKjt6cZe80PHrVWs2uSh7XQzCne8KBq+oFkcH1vRxFc
         wrtGnfTBbf2h6c+7Utrt7AvWqZI4SugTZqG/SlJCGL80bOypt7s+rrqwSFTATxMVOi
         JjNHd9sLBPDLXuEr4l4hPRDyvb8JsofxJ5qSsugTXCRgBR+doo+CTi0MuRGxCVZWR5
         iboQvmbAuP2Lvd5m1FX613Vo5MW2RJJStHNsoiCORC1x/O42b1IwV/mQcsgLak6ny/
         dimWU3akttRARF4SyzN35Cc9TRLOhl454gBj1moYKFoFEIuOwqox6N2JMh3AMMXI5x
         rjvQGZiUH3XFw==
Received: by mail-yb1-f175.google.com with SMTP id o15so25487358yba.10
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 14:47:30 -0700 (PDT)
X-Gm-Message-State: ACgBeo2fTFshBgPRl6U9c75/Ka3qCUvTkE0SslVpyN604cZtyZozYSil
        PS2M04JKZJFjrVJQ7NeqHjIHEJgRzoJOgjJApP1Jtw==
X-Google-Smtp-Source: AA6agR4fnI8EaqJu29BFVOEueN1dznAYAG7hl+whc2++wbcE3Ahd5U9wkn2b/VFuz0XOU8vk11ZqrjSnAeTTXExhUt8=
X-Received: by 2002:a81:9148:0:b0:328:2c96:eaed with SMTP id
 i69-20020a819148000000b003282c96eaedmr1782937ywg.314.1659476838933; Tue, 02
 Aug 2022 14:47:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220801180146.1157914-1-fred@cloudflare.com> <20220801180146.1157914-2-fred@cloudflare.com>
In-Reply-To: <20220801180146.1157914-2-fred@cloudflare.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Tue, 2 Aug 2022 23:47:08 +0200
X-Gmail-Original-Message-ID: <CACYkzJ4x90DamdN4dRCn1gZuAHLqJNy4MoP=qTX+44Bqx1uxSQ@mail.gmail.com>
Message-ID: <CACYkzJ4x90DamdN4dRCn1gZuAHLqJNy4MoP=qTX+44Bqx1uxSQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] security, lsm: Introduce security_create_user_ns()
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        shuah@kernel.org, brauner@kernel.org, casey@schaufler-ca.com,
        ebiederm@xmission.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        cgzones@googlemail.com, karl@bigbadwolfsecurity.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 1, 2022 at 8:02 PM Frederick Lawler <fred@cloudflare.com> wrote:
>
> Preventing user namespace (privileged or otherwise) creation comes in a
> few of forms in order of granularity:
>
>         1. /proc/sys/user/max_user_namespaces sysctl
>         2. OS specific patch(es)
>         3. CONFIG_USER_NS
>
> To block a task based on its attributes, the LSM hook cred_prepare is a
> good candidate for use because it provides more granular control, and
> it is called before create_user_ns():
>
>         cred = prepare_creds()
>                 security_prepare_creds()
>                         call_int_hook(cred_prepare, ...
>         if (cred)
>                 create_user_ns(cred)
>
> Since security_prepare_creds() is meant for LSMs to copy and prepare
> credentials, access control is an unintended use of the hook. Therefore
> introduce a new function security_create_user_ns() with an accompanying
> userns_create LSM hook.
>
> This hook takes the prepared creds for LSM authors to write policy
> against. On success, the new namespace is applied to credentials,
> otherwise an error is returned.
>
> Signed-off-by: Frederick Lawler <fred@cloudflare.com>
> Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>

Reviewed-by: KP Singh <kpsingh@kernel.org>

This looks useful, and I would also like folks to consider the
observability aspects of BPF LSM as
brought up here:

https://lore.kernel.org/all/CAEiveUdPhEPAk7Y0ZXjPsD=Vb5hn453CHzS9aG-tkyRa8bf_eg@mail.gmail.com/

Frederick, what about adding the observability aspects to the commit
description as well.

- KP

>
> ---
> Changes since v3:
> - No changes
> Changes since v2:
> - Rename create_user_ns hook to userns_create
> Changes since v1:
> - Changed commit wording
> - Moved execution to be after id mapping check
> - Changed signature to only accept a const struct cred *
> ---
>  include/linux/lsm_hook_defs.h | 1 +
>  include/linux/lsm_hooks.h     | 4 ++++
>  include/linux/security.h      | 6 ++++++
>  kernel/user_namespace.c       | 5 +++++
>  security/security.c           | 5 +++++
>  5 files changed, 21 insertions(+)
>
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index eafa1d2489fd..7ff93cb8ca8d 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -223,6 +223,7 @@ LSM_HOOK(int, -ENOSYS, task_prctl, int option, unsigned long arg2,
>          unsigned long arg3, unsigned long arg4, unsigned long arg5)
>  LSM_HOOK(void, LSM_RET_VOID, task_to_inode, struct task_struct *p,
>          struct inode *inode)
> +LSM_HOOK(int, 0, userns_create, const struct cred *cred)
>  LSM_HOOK(int, 0, ipc_permission, struct kern_ipc_perm *ipcp, short flag)
>  LSM_HOOK(void, LSM_RET_VOID, ipc_getsecid, struct kern_ipc_perm *ipcp,
>          u32 *secid)
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 91c8146649f5..54fe534d0e01 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -799,6 +799,10 @@
>   *     security attributes, e.g. for /proc/pid inodes.
>   *     @p contains the task_struct for the task.
>   *     @inode contains the inode structure for the inode.
> + * @userns_create:
> + *     Check permission prior to creating a new user namespace.
> + *     @cred points to prepared creds.
> + *     Return 0 if successful, otherwise < 0 error code.
>   *
>   * Security hooks for Netlink messaging.
>   *
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 7fc4e9f49f54..a195bf33246a 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -435,6 +435,7 @@ int security_task_kill(struct task_struct *p, struct kernel_siginfo *info,
>  int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
>                         unsigned long arg4, unsigned long arg5);
>  void security_task_to_inode(struct task_struct *p, struct inode *inode);
> +int security_create_user_ns(const struct cred *cred);
>  int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag);
>  void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid);
>  int security_msg_msg_alloc(struct msg_msg *msg);
> @@ -1185,6 +1186,11 @@ static inline int security_task_prctl(int option, unsigned long arg2,
>  static inline void security_task_to_inode(struct task_struct *p, struct inode *inode)
>  { }
>
> +static inline int security_create_user_ns(const struct cred *cred)
> +{
> +       return 0;
> +}
> +
>  static inline int security_ipc_permission(struct kern_ipc_perm *ipcp,
>                                           short flag)
>  {
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 5481ba44a8d6..3f464bbda0e9 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -9,6 +9,7 @@
>  #include <linux/highuid.h>
>  #include <linux/cred.h>
>  #include <linux/securebits.h>
> +#include <linux/security.h>
>  #include <linux/keyctl.h>
>  #include <linux/key-type.h>
>  #include <keys/user-type.h>
> @@ -113,6 +114,10 @@ int create_user_ns(struct cred *new)
>             !kgid_has_mapping(parent_ns, group))
>                 goto fail_dec;
>
> +       ret = security_create_user_ns(new);
> +       if (ret < 0)
> +               goto fail_dec;
> +
>         ret = -ENOMEM;
>         ns = kmem_cache_zalloc(user_ns_cachep, GFP_KERNEL);
>         if (!ns)
> diff --git a/security/security.c b/security/security.c
> index 188b8f782220..ec9b4696e86c 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -1903,6 +1903,11 @@ void security_task_to_inode(struct task_struct *p, struct inode *inode)
>         call_void_hook(task_to_inode, p, inode);
>  }
>
> +int security_create_user_ns(const struct cred *cred)
> +{
> +       return call_int_hook(userns_create, 0, cred);
> +}
> +
>  int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
>  {
>         return call_int_hook(ipc_permission, 0, ipcp, flag);
> --
> 2.30.2
>
