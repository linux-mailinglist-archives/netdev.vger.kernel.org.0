Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1994DE2CD
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240807AbiCRUt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238418AbiCRUtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:49:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D60F8EF2;
        Fri, 18 Mar 2022 13:48:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60D6E60B63;
        Fri, 18 Mar 2022 20:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BC8C340F3;
        Fri, 18 Mar 2022 20:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647636512;
        bh=6OTsRaGWWIIN07PPy+vzcT2zKtbU35cgCZ518v/U5iI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JZawGVTvISjTHDzu71DGyl+uP1t9sBaaAqibaqz3GzK+GR+ahKfcyUvtzd5IKuVO+
         PkJhqoymwnPfg3kOhT64o13cHF4tsrFXdDJUw+nZL7XdzrWWiWGFQVgJ//7zHA31JL
         XTtzG9kMSPu7Vt2Q18oK4IosNlm15YXFlBCyaxZ37bNNDJS6jhByG5fFAEaQJ+dn4x
         8gjmOLYrbrDoBLM5FNnwtMbv0symGeRZgiOL+A2NPYTZgFY03LohrzfhBKD4LhyuHK
         7lHykLgBs0cfJpe1obkUBKrqV4EqglTXNWaeIg+tRtXUO4ughs0wgkvZJZEyBjdqeR
         Ht7533wqxSVdQ==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-2e592e700acso103467077b3.5;
        Fri, 18 Mar 2022 13:48:32 -0700 (PDT)
X-Gm-Message-State: AOAM531zdC92U72JtYv8iswIRPQ3WM/RJYjEF5R5wV8vE9t4Zm5RYd8m
        pYnJh650R/oRc1JkrvhqBzxcXJB5ONJKCaCxyqk=
X-Google-Smtp-Source: ABdhPJyAJqzK22k10HsduvEfhFAHEbo1x6Da0+PIgRuJO7qR3Qg2nFr2pAcxw0uxvCjA3hQf1vpR2YBkxn+bayN+BR8=
X-Received: by 2002:a81:951:0:b0:2e5:9e38:147c with SMTP id
 78-20020a810951000000b002e59e38147cmr13214784ywj.211.1647636511711; Fri, 18
 Mar 2022 13:48:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com> <20220318161528.1531164-3-benjamin.tissoires@redhat.com>
In-Reply-To: <20220318161528.1531164-3-benjamin.tissoires@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 18 Mar 2022 13:48:20 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5qseqVs4=hz3VvSJ2ObqB2kTbKXoaOCh=5vjoU_AXnKQ@mail.gmail.com>
Message-ID: <CAPhsuW5qseqVs4=hz3VvSJ2ObqB2kTbKXoaOCh=5vjoU_AXnKQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 02/17] bpf: introduce hid program type
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 9:16 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
[...]
>
> diff --git a/include/linux/bpf-hid.h b/include/linux/bpf-hid.h
> new file mode 100644
> index 000000000000..9c8dbd389995
> --- /dev/null
> +++ b/include/linux/bpf-hid.h
>
[...]
> +
> +struct hid_bpf_ctx_kern {
> +       enum hid_bpf_event type;        /* read-only */
> +       struct hid_device *hdev;        /* read-only */
> +
> +       u16 size;                       /* used size in data (RW) */
> +       u8 *data;                       /* data buffer (RW) */
> +       u32 allocated_size;             /* allocated size of data (RO) */

Why u16 size vs. u32 allocated_size? Also, maybe shuffle the members
to remove some holes?

> +
> +       s32 retval;                     /* in use when BPF_HID_ATTACH_USER_EVENT (RW) */
> +};
> +
[...]

> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h

We need to mirror these changes to tools/include/uapi/linux/bpf.h.

> index 99fab54ae9c0..0e8438e93768 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -952,6 +952,7 @@ enum bpf_prog_type {
>         BPF_PROG_TYPE_LSM,
>         BPF_PROG_TYPE_SK_LOOKUP,
>         BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
> +       BPF_PROG_TYPE_HID,
>  };
[...]
> +
>  /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
>   * the following extensions:
>   *
> @@ -5129,6 +5145,16 @@ union bpf_attr {
>   *             The **hash_algo** is returned on success,
>   *             **-EOPNOTSUP** if the hash calculation failed or **-EINVAL** if
>   *             invalid arguments are passed.
> + *
> + * void *bpf_hid_get_data(void *ctx, u64 offset, u64 size)
> + *     Description
> + *             Returns a pointer to the data associated with context at the given
> + *             offset and size (in bytes).
> + *
> + *             Note: the returned pointer is refcounted and must be dereferenced
> + *             by a call to bpf_hid_discard;
> + *     Return
> + *             The pointer to the data. On error, a null value is returned.

Please use annotations like *size*, **NULL**.

>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -5325,6 +5351,7 @@ union bpf_attr {
>         FN(copy_from_user_task),        \
>         FN(skb_set_tstamp),             \
>         FN(ima_file_hash),              \
> +       FN(hid_get_data),               \
>         /* */
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> @@ -5925,6 +5952,10 @@ struct bpf_link_info {
>                 struct {
>                         __u32 ifindex;
>                 } xdp;
> +               struct  {
> +                       __s32 hidraw_number;
> +                       __u32 attach_type;
> +               } hid;
>         };
>  } __attribute__((aligned(8)));
>
> diff --git a/include/uapi/linux/bpf_hid.h b/include/uapi/linux/bpf_hid.h
> new file mode 100644
> index 000000000000..64a8b9dd8809
> --- /dev/null
> +++ b/include/uapi/linux/bpf_hid.h
> @@ -0,0 +1,31 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later WITH Linux-syscall-note */
> +
> +/*
> + *  HID BPF public headers
> + *
> + *  Copyright (c) 2022 Benjamin Tissoires
> + */
> +
> +#ifndef _UAPI__LINUX_BPF_HID_H__
> +#define _UAPI__LINUX_BPF_HID_H__
> +
> +#include <linux/types.h>
> +
> +enum hid_bpf_event {
> +       HID_BPF_UNDEF = 0,
> +       HID_BPF_DEVICE_EVENT,           /* when attach type is BPF_HID_DEVICE_EVENT */
> +       HID_BPF_RDESC_FIXUP,            /* ................... BPF_HID_RDESC_FIXUP */
> +       HID_BPF_USER_EVENT,             /* ................... BPF_HID_USER_EVENT */

Why don't we have a DRIVER_EVENT type here?

>
[...]
> +
> +BPF_CALL_3(bpf_hid_get_data, struct hid_bpf_ctx_kern*, ctx, u64, offset, u64, size)
> +{
> +       if (!size)
> +               return 0UL;
> +
> +       if (offset + size > ctx->allocated_size)
> +               return 0UL;
> +
> +       return (unsigned long)(ctx->data + offset);
> +}
> +
> +static const struct bpf_func_proto bpf_hid_get_data_proto = {
> +       .func      = bpf_hid_get_data,
> +       .gpl_only  = true,
> +       .ret_type  = RET_PTR_TO_ALLOC_MEM_OR_NULL,
> +       .arg1_type = ARG_PTR_TO_CTX,
> +       .arg2_type = ARG_ANYTHING,
> +       .arg3_type = ARG_CONST_ALLOC_SIZE_OR_ZERO,

I think we should use ARG_CONST_SIZE or ARG_CONST_SIZE_OR_ZERO?

> +};
> +
> +static const struct bpf_func_proto *
> +hid_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> +{
> +       switch (func_id) {
> +       case BPF_FUNC_hid_get_data:
> +               return &bpf_hid_get_data_proto;
> +       default:
> +               return bpf_base_func_proto(func_id);
> +       }
> +}
[...]
> +
> +static int hid_bpf_prog_test_run(struct bpf_prog *prog,
> +                                const union bpf_attr *attr,
> +                                union bpf_attr __user *uattr)
> +{
> +       struct hid_device *hdev = NULL;
> +       struct bpf_prog_array *progs;
> +       bool valid_prog = false;
> +       int i;
> +       int target_fd, ret;
> +       void __user *data_out = u64_to_user_ptr(attr->test.data_out);
> +       void __user *data_in = u64_to_user_ptr(attr->test.data_in);
> +       u32 user_size_in = attr->test.data_size_in;
> +       u32 user_size_out = attr->test.data_size_out;
> +       u32 allocated_size = max(user_size_in, user_size_out);
> +       struct hid_bpf_ctx_kern ctx = {
> +               .type = HID_BPF_USER_EVENT,
> +               .allocated_size = allocated_size,
> +       };
> +
> +       if (!hid_hooks.hdev_from_fd)
> +               return -EOPNOTSUPP;
> +
> +       if (attr->test.ctx_size_in != sizeof(int))
> +               return -EINVAL;

ctx_size_in is always 4 bytes?

> +
> +       if (allocated_size > HID_MAX_BUFFER_SIZE)
> +               return -E2BIG;
> +
> +       if (copy_from_user(&target_fd, (void *)attr->test.ctx_in, attr->test.ctx_size_in))
> +               return -EFAULT;
> +
> +       hdev = hid_hooks.hdev_from_fd(target_fd);
> +       if (IS_ERR(hdev))
> +               return PTR_ERR(hdev);
> +
> +       if (allocated_size) {
> +               ctx.data = kzalloc(allocated_size, GFP_KERNEL);
> +               if (!ctx.data)
> +                       return -ENOMEM;
> +
> +               ctx.allocated_size = allocated_size;
> +       }
> +       ctx.hdev = hdev;
> +
> +       ret = mutex_lock_interruptible(&bpf_hid_mutex);
> +       if (ret)
> +               return ret;
> +
> +       /* check if the given program is of correct type and registered */
> +       progs = rcu_dereference_protected(hdev->bpf.run_array[BPF_HID_ATTACH_USER_EVENT],
> +                                         lockdep_is_held(&bpf_hid_mutex));
> +       if (!progs) {
> +               ret = -EFAULT;
> +               goto unlock;
> +       }
> +
> +       for (i = 0; i < bpf_prog_array_length(progs); i++) {
> +               if (progs->items[i].prog == prog) {
> +                       valid_prog = true;
> +                       break;
> +               }
> +       }
> +
> +       if (!valid_prog) {
> +               ret = -EINVAL;
> +               goto unlock;
> +       }
> +
> +       /* copy data_in from userspace */
> +       if (user_size_in) {
> +               if (copy_from_user(ctx.data, data_in, user_size_in)) {
> +                       ret = -EFAULT;
> +                       goto unlock;
> +               }
> +
> +               ctx.size = user_size_in;
> +       }
> +
> +       migrate_disable();
> +
> +       ret = bpf_prog_run(prog, &ctx);
> +
> +       migrate_enable();
> +
> +       if (user_size_out && data_out) {
> +               user_size_out = min3(user_size_out, (u32)ctx.size, allocated_size);
> +
> +               if (copy_to_user(data_out, ctx.data, user_size_out)) {
> +                       ret = -EFAULT;
> +                       goto unlock;
> +               }
> +
> +               if (copy_to_user(&uattr->test.data_size_out,
> +                                &user_size_out,
> +                                sizeof(user_size_out))) {
> +                       ret = -EFAULT;
> +                       goto unlock;
> +               }
> +       }
> +
> +       if (copy_to_user(&uattr->test.retval, &ctx.retval, sizeof(ctx.retval)))
> +               ret = -EFAULT;
> +
> +unlock:
> +       kfree(ctx.data);
> +
> +       mutex_unlock(&bpf_hid_mutex);
> +       return ret;
> +}
> +
> +const struct bpf_prog_ops hid_prog_ops = {
> +       .test_run = hid_bpf_prog_test_run,
> +};
> +
> +int bpf_hid_init(struct hid_device *hdev)
> +{
> +       int type;
> +
> +       for (type = 0; type < MAX_BPF_HID_ATTACH_TYPE; type++)
> +               INIT_LIST_HEAD(&hdev->bpf.links[type]);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(bpf_hid_init);
> +
> +void bpf_hid_exit(struct hid_device *hdev)
> +{
> +       enum bpf_hid_attach_type type;
> +       struct bpf_hid_link *hid_link;
> +
> +       mutex_lock(&bpf_hid_mutex);
> +       for (type = 0; type < MAX_BPF_HID_ATTACH_TYPE; type++) {
> +               bpf_hid_run_array_detach(hdev, type);
> +               list_for_each_entry(hid_link, &hdev->bpf.links[type], node) {
> +                       hid_link->hdev = NULL; /* auto-detach link */
> +               }
> +       }
> +       mutex_unlock(&bpf_hid_mutex);
> +}
> +EXPORT_SYMBOL_GPL(bpf_hid_exit);
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index b88688264ad0..d1c05011e5ab 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -3,6 +3,7 @@
>   */
>  #include <linux/bpf.h>
>  #include <linux/bpf-cgroup.h>
> +#include <linux/bpf-hid.h>
>  #include <linux/bpf_trace.h>
>  #include <linux/bpf_lirc.h>
>  #include <linux/bpf_verifier.h>
> @@ -2205,6 +2206,7 @@ static bool is_sys_admin_prog_type(enum bpf_prog_type prog_type)
>  {
>         switch (prog_type) {
>         case BPF_PROG_TYPE_LIRC_MODE2:
> +       case BPF_PROG_TYPE_HID:
>                 return true;
>         default:
>                 return false;
> @@ -3199,6 +3201,11 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
>                 return BPF_PROG_TYPE_SK_LOOKUP;
>         case BPF_XDP:
>                 return BPF_PROG_TYPE_XDP;
> +       case BPF_HID_DEVICE_EVENT:
> +       case BPF_HID_RDESC_FIXUP:
> +       case BPF_HID_USER_EVENT:
> +       case BPF_HID_DRIVER_EVENT:
> +               return BPF_PROG_TYPE_HID;
>         default:
>                 return BPF_PROG_TYPE_UNSPEC;
>         }
> @@ -3342,6 +3349,11 @@ static int bpf_prog_query(const union bpf_attr *attr,
>         case BPF_SK_MSG_VERDICT:
>         case BPF_SK_SKB_VERDICT:
>                 return sock_map_bpf_prog_query(attr, uattr);
> +       case BPF_HID_DEVICE_EVENT:
> +       case BPF_HID_RDESC_FIXUP:
> +       case BPF_HID_USER_EVENT:
> +       case BPF_HID_DRIVER_EVENT:
> +               return bpf_hid_prog_query(attr, uattr);
>         default:
>                 return -EINVAL;
>         }
> @@ -4336,6 +4348,8 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
>                 ret = bpf_perf_link_attach(attr, prog);
>                 break;
>  #endif
> +       case BPF_PROG_TYPE_HID:
> +               return bpf_hid_link_create(attr, prog);
>         default:
>                 ret = -EINVAL;
>         }
> --
> 2.35.1
>
