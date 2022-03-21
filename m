Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6526C4E2D1F
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 17:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350646AbiCUQJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 12:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240640AbiCUQJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 12:09:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E64CE6662C
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 09:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647878857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zpcoCC4yHq3ajeXZ8IqHbBVz9eP4OTlopTuEhplFUg4=;
        b=iIHMcUiXpXOevy4z71I3UcGhsQMHIk7Yg5xxkJfLxPyKHzxRTx2qA8q2rj+WOTNPyuf4CW
        8/+FG+pflcliq31FSNK9wjOXq251I9N/kUvsrkSfshuFcypqxg/2m/vei5Fs5Flu2qA4ks
        2MlZqStmLoSi1N781hxlBJx9UahV7MM=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-Vk9O9nqQMK-tmzNKTEgv-A-1; Mon, 21 Mar 2022 12:07:35 -0400
X-MC-Unique: Vk9O9nqQMK-tmzNKTEgv-A-1
Received: by mail-pj1-f71.google.com with SMTP id mm2-20020a17090b358200b001bf529127dfso9168694pjb.6
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 09:07:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zpcoCC4yHq3ajeXZ8IqHbBVz9eP4OTlopTuEhplFUg4=;
        b=MGKFMu443kmLfAEVgob+YwhBjFZDUUzdcq4tMiY6w+OXXmSvzkq8Nmx4FaNRrBDkiq
         ozqXG3lN7MBTxUD/JYzATZNdUKr0wpouBFiQfrX5PBDMn+E1efBSdq8LvA88VepSK7B3
         QHUGM1zDpaLIFK78g1Y2OH9SOMDO3hau+3BJX4tJnVmyFcSge+O531U8aNU2PPFxXE4b
         CbaecZaJu1HNnXhYP71Q1G/4dFh2uCEEHai6L7ULMy507vVfms1yw02QY9NQWfqkYJuR
         3sK/8Gdi+pBs1jWJlR5HE0omIeHQetwUrdzPW1h8MSlUDLaUdGpRAIkjWU8oIpJZdwTG
         6kVQ==
X-Gm-Message-State: AOAM532YjGHriiIk+bxRVv3hSH4PIMDJHoa+y5JCbki13deZeoI03CDj
        ttlLGbTRYlKMmTxcnEQQRi5SeNwwZHqhiqlANog8f/GLWdhBU5GK4knUQxWsc6yuygh9on/QEvK
        oAFTKtlolJ2cA1lpc6hFel8gt3/NZ7nYR
X-Received: by 2002:a17:902:c401:b0:154:1398:a16b with SMTP id k1-20020a170902c40100b001541398a16bmr13429812plk.67.1647878853133;
        Mon, 21 Mar 2022 09:07:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfR7xojQGSh+SlE52ZB3p3sYi5T6jUKMUP6HdTYmBdE+aOadzDpu21O7Hr0mDvNquBoaR05abTWhccSffR0dM=
X-Received: by 2002:a17:902:c401:b0:154:1398:a16b with SMTP id
 k1-20020a170902c40100b001541398a16bmr13429769plk.67.1647878852756; Mon, 21
 Mar 2022 09:07:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
 <20220318161528.1531164-3-benjamin.tissoires@redhat.com> <CAPhsuW5qseqVs4=hz3VvSJ2ObqB2kTbKXoaOCh=5vjoU_AXnKQ@mail.gmail.com>
In-Reply-To: <CAPhsuW5qseqVs4=hz3VvSJ2ObqB2kTbKXoaOCh=5vjoU_AXnKQ@mail.gmail.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Mon, 21 Mar 2022 17:07:21 +0100
Message-ID: <CAO-hwJ+WSi645HhNV_BYACoJe2UTc4KZzqH0oHocfnBR8xUYEQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 02/17] bpf: introduce hid program type
To:     Song Liu <song@kernel.org>
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
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Song,

many thanks for the quick response.

On Fri, Mar 18, 2022 at 9:48 PM Song Liu <song@kernel.org> wrote:
>
> On Fri, Mar 18, 2022 at 9:16 AM Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
> >
> [...]
> >
> > diff --git a/include/linux/bpf-hid.h b/include/linux/bpf-hid.h
> > new file mode 100644
> > index 000000000000..9c8dbd389995
> > --- /dev/null
> > +++ b/include/linux/bpf-hid.h
> >
> [...]
> > +
> > +struct hid_bpf_ctx_kern {
> > +       enum hid_bpf_event type;        /* read-only */
> > +       struct hid_device *hdev;        /* read-only */
> > +
> > +       u16 size;                       /* used size in data (RW) */
> > +       u8 *data;                       /* data buffer (RW) */
> > +       u32 allocated_size;             /* allocated size of data (RO) */
>
> Why u16 size vs. u32 allocated_size?

Probably an oversight because I wrote u32 in the public uapi. Will
change this into u16 too.

> Also, maybe shuffle the members
> to remove some holes?

Ack will do in the next version.

>
> > +
> > +       s32 retval;                     /* in use when BPF_HID_ATTACH_USER_EVENT (RW) */
> > +};
> > +
> [...]
>
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>
> We need to mirror these changes to tools/include/uapi/linux/bpf.h.

OK. I did that in patch 4/17 but I can bring in the changes there too.

>
> > index 99fab54ae9c0..0e8438e93768 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -952,6 +952,7 @@ enum bpf_prog_type {
> >         BPF_PROG_TYPE_LSM,
> >         BPF_PROG_TYPE_SK_LOOKUP,
> >         BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
> > +       BPF_PROG_TYPE_HID,
> >  };
> [...]
> > +
> >  /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
> >   * the following extensions:
> >   *
> > @@ -5129,6 +5145,16 @@ union bpf_attr {
> >   *             The **hash_algo** is returned on success,
> >   *             **-EOPNOTSUP** if the hash calculation failed or **-EINVAL** if
> >   *             invalid arguments are passed.
> > + *
> > + * void *bpf_hid_get_data(void *ctx, u64 offset, u64 size)
> > + *     Description
> > + *             Returns a pointer to the data associated with context at the given
> > + *             offset and size (in bytes).
> > + *
> > + *             Note: the returned pointer is refcounted and must be dereferenced
> > + *             by a call to bpf_hid_discard;
> > + *     Return
> > + *             The pointer to the data. On error, a null value is returned.
>
> Please use annotations like *size*, **NULL**.

Ack

>
> >   */
> >  #define __BPF_FUNC_MAPPER(FN)          \
> >         FN(unspec),                     \
> > @@ -5325,6 +5351,7 @@ union bpf_attr {
> >         FN(copy_from_user_task),        \
> >         FN(skb_set_tstamp),             \
> >         FN(ima_file_hash),              \
> > +       FN(hid_get_data),               \
> >         /* */
> >
> >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > @@ -5925,6 +5952,10 @@ struct bpf_link_info {
> >                 struct {
> >                         __u32 ifindex;
> >                 } xdp;
> > +               struct  {
> > +                       __s32 hidraw_number;
> > +                       __u32 attach_type;
> > +               } hid;
> >         };
> >  } __attribute__((aligned(8)));
> >
> > diff --git a/include/uapi/linux/bpf_hid.h b/include/uapi/linux/bpf_hid.h
> > new file mode 100644
> > index 000000000000..64a8b9dd8809
> > --- /dev/null
> > +++ b/include/uapi/linux/bpf_hid.h
> > @@ -0,0 +1,31 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later WITH Linux-syscall-note */
> > +
> > +/*
> > + *  HID BPF public headers
> > + *
> > + *  Copyright (c) 2022 Benjamin Tissoires
> > + */
> > +
> > +#ifndef _UAPI__LINUX_BPF_HID_H__
> > +#define _UAPI__LINUX_BPF_HID_H__
> > +
> > +#include <linux/types.h>
> > +
> > +enum hid_bpf_event {
> > +       HID_BPF_UNDEF = 0,
> > +       HID_BPF_DEVICE_EVENT,           /* when attach type is BPF_HID_DEVICE_EVENT */
> > +       HID_BPF_RDESC_FIXUP,            /* ................... BPF_HID_RDESC_FIXUP */
> > +       HID_BPF_USER_EVENT,             /* ................... BPF_HID_USER_EVENT */
>
> Why don't we have a DRIVER_EVENT type here?

For driver event, I want to have a little bit more of information
which tells which event we have:
- HID_BPF_DRIVER_PROBE
- HID_BPF_DRIVER_SUSPEND
- HID_BPF_DRIVER_RAW_REQUEST
- HID_BPF_DRIVER_RAW_REQUEST_ANSWER
- etc...

However, I am not entirely sure on the implementation of all of those,
so I left them aside for now.

I'll work on that for v4.

>
> >
> [...]
> > +
> > +BPF_CALL_3(bpf_hid_get_data, struct hid_bpf_ctx_kern*, ctx, u64, offset, u64, size)
> > +{
> > +       if (!size)
> > +               return 0UL;
> > +
> > +       if (offset + size > ctx->allocated_size)
> > +               return 0UL;
> > +
> > +       return (unsigned long)(ctx->data + offset);
> > +}
> > +
> > +static const struct bpf_func_proto bpf_hid_get_data_proto = {
> > +       .func      = bpf_hid_get_data,
> > +       .gpl_only  = true,
> > +       .ret_type  = RET_PTR_TO_ALLOC_MEM_OR_NULL,
> > +       .arg1_type = ARG_PTR_TO_CTX,
> > +       .arg2_type = ARG_ANYTHING,
> > +       .arg3_type = ARG_CONST_ALLOC_SIZE_OR_ZERO,
>
> I think we should use ARG_CONST_SIZE or ARG_CONST_SIZE_OR_ZERO?

I initially tried this with ARG_CONST_SIZE_OR_ZERO but it doesn't work
for 2 reasons:
- we need to pair the argument ARG_CONST_SIZE_* with a pointer to a
memory just before, which doesn't really make sense here
- ARG_CONST_SIZE_* isn't handled in the same way
ARG_CONST_ALLOC_SIZE_OR_ZERO is. The latter tells the verifier that
the given size is the available size of the returned
PTR_TO_ALLOC_MEM_OR_NULL, which is exactly what we want.

>
> > +};
> > +
> > +static const struct bpf_func_proto *
> > +hid_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> > +{
> > +       switch (func_id) {
> > +       case BPF_FUNC_hid_get_data:
> > +               return &bpf_hid_get_data_proto;
> > +       default:
> > +               return bpf_base_func_proto(func_id);
> > +       }
> > +}
> [...]
> > +
> > +static int hid_bpf_prog_test_run(struct bpf_prog *prog,
> > +                                const union bpf_attr *attr,
> > +                                union bpf_attr __user *uattr)
> > +{
> > +       struct hid_device *hdev = NULL;
> > +       struct bpf_prog_array *progs;
> > +       bool valid_prog = false;
> > +       int i;
> > +       int target_fd, ret;
> > +       void __user *data_out = u64_to_user_ptr(attr->test.data_out);
> > +       void __user *data_in = u64_to_user_ptr(attr->test.data_in);
> > +       u32 user_size_in = attr->test.data_size_in;
> > +       u32 user_size_out = attr->test.data_size_out;
> > +       u32 allocated_size = max(user_size_in, user_size_out);
> > +       struct hid_bpf_ctx_kern ctx = {
> > +               .type = HID_BPF_USER_EVENT,
> > +               .allocated_size = allocated_size,
> > +       };
> > +
> > +       if (!hid_hooks.hdev_from_fd)
> > +               return -EOPNOTSUPP;
> > +
> > +       if (attr->test.ctx_size_in != sizeof(int))
> > +               return -EINVAL;
>
> ctx_size_in is always 4 bytes?

Yes. Basically what I had in mind is that the "ctx" for
user_prog_test_run is the file descriptor to the sysfs that represent
the HID device.
This seemed to me to be the easiest to handle for users.

I'm open to suggestions though.

>
> > +
> > +       if (allocated_size > HID_MAX_BUFFER_SIZE)
> > +               return -E2BIG;
> > +
> > +       if (copy_from_user(&target_fd, (void *)attr->test.ctx_in, attr->test.ctx_size_in))
> > +               return -EFAULT;
> > +
> > +       hdev = hid_hooks.hdev_from_fd(target_fd);
> > +       if (IS_ERR(hdev))
> > +               return PTR_ERR(hdev);
> > +
> > +       if (allocated_size) {
> > +               ctx.data = kzalloc(allocated_size, GFP_KERNEL);
> > +               if (!ctx.data)
> > +                       return -ENOMEM;
> > +
> > +               ctx.allocated_size = allocated_size;
> > +       }
> > +       ctx.hdev = hdev;
> > +
> > +       ret = mutex_lock_interruptible(&bpf_hid_mutex);
> > +       if (ret)
> > +               return ret;
> > +
> > +       /* check if the given program is of correct type and registered */
> > +       progs = rcu_dereference_protected(hdev->bpf.run_array[BPF_HID_ATTACH_USER_EVENT],
> > +                                         lockdep_is_held(&bpf_hid_mutex));
> > +       if (!progs) {
> > +               ret = -EFAULT;
> > +               goto unlock;
> > +       }
> > +
> > +       for (i = 0; i < bpf_prog_array_length(progs); i++) {
> > +               if (progs->items[i].prog == prog) {
> > +                       valid_prog = true;
> > +                       break;
> > +               }
> > +       }
> > +
> > +       if (!valid_prog) {
> > +               ret = -EINVAL;
> > +               goto unlock;
> > +       }
> > +
> > +       /* copy data_in from userspace */
> > +       if (user_size_in) {
> > +               if (copy_from_user(ctx.data, data_in, user_size_in)) {
> > +                       ret = -EFAULT;
> > +                       goto unlock;
> > +               }
> > +
> > +               ctx.size = user_size_in;
> > +       }
> > +
> > +       migrate_disable();
> > +
> > +       ret = bpf_prog_run(prog, &ctx);
> > +
> > +       migrate_enable();
> > +
> > +       if (user_size_out && data_out) {
> > +               user_size_out = min3(user_size_out, (u32)ctx.size, allocated_size);
> > +
> > +               if (copy_to_user(data_out, ctx.data, user_size_out)) {
> > +                       ret = -EFAULT;
> > +                       goto unlock;
> > +               }
> > +
> > +               if (copy_to_user(&uattr->test.data_size_out,
> > +                                &user_size_out,
> > +                                sizeof(user_size_out))) {
> > +                       ret = -EFAULT;
> > +                       goto unlock;
> > +               }
> > +       }
> > +
> > +       if (copy_to_user(&uattr->test.retval, &ctx.retval, sizeof(ctx.retval)))
> > +               ret = -EFAULT;
> > +
> > +unlock:
> > +       kfree(ctx.data);
> > +
> > +       mutex_unlock(&bpf_hid_mutex);
> > +       return ret;
> > +}
> > +
> > +const struct bpf_prog_ops hid_prog_ops = {
> > +       .test_run = hid_bpf_prog_test_run,
> > +};
> > +
> > +int bpf_hid_init(struct hid_device *hdev)
> > +{
> > +       int type;
> > +
> > +       for (type = 0; type < MAX_BPF_HID_ATTACH_TYPE; type++)
> > +               INIT_LIST_HEAD(&hdev->bpf.links[type]);
> > +
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(bpf_hid_init);
> > +
> > +void bpf_hid_exit(struct hid_device *hdev)
> > +{
> > +       enum bpf_hid_attach_type type;
> > +       struct bpf_hid_link *hid_link;
> > +
> > +       mutex_lock(&bpf_hid_mutex);
> > +       for (type = 0; type < MAX_BPF_HID_ATTACH_TYPE; type++) {
> > +               bpf_hid_run_array_detach(hdev, type);
> > +               list_for_each_entry(hid_link, &hdev->bpf.links[type], node) {
> > +                       hid_link->hdev = NULL; /* auto-detach link */
> > +               }
> > +       }
> > +       mutex_unlock(&bpf_hid_mutex);
> > +}
> > +EXPORT_SYMBOL_GPL(bpf_hid_exit);
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index b88688264ad0..d1c05011e5ab 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -3,6 +3,7 @@
> >   */
> >  #include <linux/bpf.h>
> >  #include <linux/bpf-cgroup.h>
> > +#include <linux/bpf-hid.h>
> >  #include <linux/bpf_trace.h>
> >  #include <linux/bpf_lirc.h>
> >  #include <linux/bpf_verifier.h>
> > @@ -2205,6 +2206,7 @@ static bool is_sys_admin_prog_type(enum bpf_prog_type prog_type)
> >  {
> >         switch (prog_type) {
> >         case BPF_PROG_TYPE_LIRC_MODE2:
> > +       case BPF_PROG_TYPE_HID:
> >                 return true;
> >         default:
> >                 return false;
> > @@ -3199,6 +3201,11 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
> >                 return BPF_PROG_TYPE_SK_LOOKUP;
> >         case BPF_XDP:
> >                 return BPF_PROG_TYPE_XDP;
> > +       case BPF_HID_DEVICE_EVENT:
> > +       case BPF_HID_RDESC_FIXUP:
> > +       case BPF_HID_USER_EVENT:
> > +       case BPF_HID_DRIVER_EVENT:
> > +               return BPF_PROG_TYPE_HID;
> >         default:
> >                 return BPF_PROG_TYPE_UNSPEC;
> >         }
> > @@ -3342,6 +3349,11 @@ static int bpf_prog_query(const union bpf_attr *attr,
> >         case BPF_SK_MSG_VERDICT:
> >         case BPF_SK_SKB_VERDICT:
> >                 return sock_map_bpf_prog_query(attr, uattr);
> > +       case BPF_HID_DEVICE_EVENT:
> > +       case BPF_HID_RDESC_FIXUP:
> > +       case BPF_HID_USER_EVENT:
> > +       case BPF_HID_DRIVER_EVENT:
> > +               return bpf_hid_prog_query(attr, uattr);
> >         default:
> >                 return -EINVAL;
> >         }
> > @@ -4336,6 +4348,8 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
> >                 ret = bpf_perf_link_attach(attr, prog);
> >                 break;
> >  #endif
> > +       case BPF_PROG_TYPE_HID:
> > +               return bpf_hid_link_create(attr, prog);
> >         default:
> >                 ret = -EINVAL;
> >         }
> > --
> > 2.35.1
> >
>

Cheers,
Benjamin

