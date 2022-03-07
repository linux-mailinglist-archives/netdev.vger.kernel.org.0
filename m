Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6D74D05C8
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 18:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244591AbiCGR7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 12:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240723AbiCGR7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 12:59:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6960F23BFF
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 09:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646675887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=09u9JLzPtVxDRy5KymybGQkLWvhxr6nyrHDbu84UlmM=;
        b=DSIxEEGqxAA3jL8qtyInCVnLzDiqTd99h7bNpmUB0eCxSnvf3UHEclk7rS3cg86ieAUmhm
        rywwoNH62Uqbe0sL4+3rW2xy3uqwgbCez8C826LL5+F35O4vn8bJ8UG/PK7N+zflU7BGla
        qmsPMbSkGM2QG+uSr3thhOSwL20NBtA=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-xUM-7lfwMA-7NFPNbnE_aQ-1; Mon, 07 Mar 2022 12:58:06 -0500
X-MC-Unique: xUM-7lfwMA-7NFPNbnE_aQ-1
Received: by mail-pg1-f199.google.com with SMTP id v32-20020a634660000000b0037c3f654c50so8189923pgk.6
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 09:58:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=09u9JLzPtVxDRy5KymybGQkLWvhxr6nyrHDbu84UlmM=;
        b=koF7YiNfApOl38yQ9z66LCWqcyYWYmkKmJVg2L42SZV77Fv7eYY6hL7kT/jlUtDuUh
         Z804ce8hUk+P9ixaw0W5Ne1cgOjemQ3pixqIMv/PCz2dvI24MEPl+8CwwbGXNxXUROPX
         X9XF9izGqikqXocBQZJl4z11vzNjBdkZc87oZyixx7FT89Gtx5rCPUTJ+WD4DTwHezZZ
         l9wY4P9ru0By5Xx8e1uk79esj41CIxoW6wlgL6mxoUjnwUrE5iDlidYVXo83AamgSMNR
         3pvKtLpr6PwxvXdOeCT1Ip6QkUPGXBPCovzsrVE6FLneZUaBhVx8/fzzJukhVKtXmX6N
         pLhA==
X-Gm-Message-State: AOAM531jmJIFbtopBPJVgGNhCe3rLYpfsMX3UD0m4c+2yfvAm5w9FcfN
        b9XNLqk/WBxHK7OPSKawTzkQSn29Z0NPI6F21ftXV+0iyB0q91U6nqi7sp5ntXQ6Qfo+fQgi6nH
        HdZhMSFcyd/Wv1En+esQT023/NJA9J0Vq
X-Received: by 2002:a17:90a:560a:b0:1bc:72e7:3c13 with SMTP id r10-20020a17090a560a00b001bc72e73c13mr117261pjf.246.1646675884993;
        Mon, 07 Mar 2022 09:58:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwdS69KfZP2u4oQXWT/yMi0uEk8IG8gMJ+yzn07MH1yQIxzQm588R7BRzPYd4sUr9Utvgyynhtw+t8BAfdnkGQ=
X-Received: by 2002:a17:90a:560a:b0:1bc:72e7:3c13 with SMTP id
 r10-20020a17090a560a00b001bc72e73c13mr117227pjf.246.1646675884637; Mon, 07
 Mar 2022 09:58:04 -0800 (PST)
MIME-Version: 1.0
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
 <20220304172852.274126-3-benjamin.tissoires@redhat.com> <YiJYlfIywoG5yIMd@kroah.com>
In-Reply-To: <YiJYlfIywoG5yIMd@kroah.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Mon, 7 Mar 2022 18:57:53 +0100
Message-ID: <CAO-hwJ+oF+WtsQziHBJ6ZESG+C+zw71Hje+SYa8Zn-V4nPZDMQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 02/28] bpf: introduce hid program type
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 4, 2022 at 7:21 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Mar 04, 2022 at 06:28:26PM +0100, Benjamin Tissoires wrote:
> > HID is a protocol that could benefit from using BPF too.
> >
> > This patch implements a net-like use of BPF capability for HID.
> > Any incoming report coming from the device can be injected into a series
> > of BPF programs that can modify it or even discard it by setting the
> > size in the context to 0.
> >
> > The kernel/bpf implementation is based on net-namespace.c, with only
> > the bpf_link part kept, there is no real points in keeping the
> > bpf_prog_{attach|detach} API.
> >
> > The implementation here is only focusing on the bpf changes. The HID
> > changes that hooks onto this are coming in a separate patch.
> >
> > Given that HID can be compiled in as a module, and the functions that
> > kernel/bpf/hid.c needs to call in hid.ko are exported in struct hid_hooks.
> >
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> >
> > ---
> >
> > changes in v2:
> > - split the series by bpf/libbpf/hid/selftests and samples
> > - unsigned long -> __u16 in uapi/linux/bpf_hid.h
> > - change the bpf_ctx to be of variable size, with a min of 1024 bytes
> > - make this 1 kB available directly from bpf program, the rest will
> >   need a helper
> > - add some more doc comments in uapi
> > ---
> >  include/linux/bpf-hid.h        | 108 ++++++++
> >  include/linux/bpf_types.h      |   4 +
> >  include/linux/hid.h            |   5 +
> >  include/uapi/linux/bpf.h       |   7 +
> >  include/uapi/linux/bpf_hid.h   |  39 +++
> >  kernel/bpf/Makefile            |   3 +
> >  kernel/bpf/hid.c               | 437 +++++++++++++++++++++++++++++++++
> >  kernel/bpf/syscall.c           |   8 +
> >  tools/include/uapi/linux/bpf.h |   7 +
> >  9 files changed, 618 insertions(+)
> >  create mode 100644 include/linux/bpf-hid.h
> >  create mode 100644 include/uapi/linux/bpf_hid.h
> >  create mode 100644 kernel/bpf/hid.c
> >
> > diff --git a/include/linux/bpf-hid.h b/include/linux/bpf-hid.h
> > new file mode 100644
> > index 000000000000..3cda78051b5f
> > --- /dev/null
> > +++ b/include/linux/bpf-hid.h
> > @@ -0,0 +1,108 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _BPF_HID_H
> > +#define _BPF_HID_H
> > +
> > +#include <linux/mutex.h>
> > +#include <uapi/linux/bpf.h>
> > +#include <uapi/linux/bpf_hid.h>
> > +#include <linux/list.h>
> > +#include <linux/slab.h>
> > +
> > +struct bpf_prog;
> > +struct bpf_prog_array;
> > +struct hid_device;
> > +
> > +enum bpf_hid_attach_type {
> > +     BPF_HID_ATTACH_INVALID = -1,
> > +     BPF_HID_ATTACH_DEVICE_EVENT = 0,
> > +     MAX_BPF_HID_ATTACH_TYPE
> > +};
> > +
> > +struct bpf_hid {
> > +     struct hid_bpf_ctx *ctx;
> > +
> > +     /* Array of programs to run compiled from links */
> > +     struct bpf_prog_array __rcu *run_array[MAX_BPF_HID_ATTACH_TYPE];
> > +     struct list_head links[MAX_BPF_HID_ATTACH_TYPE];
> > +};
> > +
> > +static inline enum bpf_hid_attach_type
> > +to_bpf_hid_attach_type(enum bpf_attach_type attach_type)
> > +{
> > +     switch (attach_type) {
> > +     case BPF_HID_DEVICE_EVENT:
> > +             return BPF_HID_ATTACH_DEVICE_EVENT;
> > +     default:
> > +             return BPF_HID_ATTACH_INVALID;
> > +     }
> > +}
> > +
> > +static inline struct hid_bpf_ctx *bpf_hid_allocate_ctx(struct hid_device *hdev,
> > +                                                    size_t data_size)
> > +{
> > +     struct hid_bpf_ctx *ctx;
> > +
> > +     /* ensure data_size is between min and max */
> > +     data_size = clamp_val(data_size,
> > +                           HID_BPF_MIN_BUFFER_SIZE,
> > +                           HID_BPF_MAX_BUFFER_SIZE);
>
> Do you want to return an error if the data size is not within the range?

That was not something I was counting on.
Though I am thinking of not necessarily clamping this value in the end
because I might have found a way to not do the initial memcpy when
running a prog, and so not having to limit the size of the data.

> Otherwise people will just start to use crazy values and you will always
> be limiting them?

The users of this helper are really limited to drivers/hid/hid_pbf.c
and kernel/bpf/hid.c. And they are known in advance and there must be
only one user per attach type.
The only thing where the data might explode is when in used with
SEC(hid/device_event), because we statically allocate one bpf_ctx
based on the device report descriptor.
But if the required size is bigger than HID_BPF_MAX_BUFFER_SIZE, the
device will not probe or at least already logs something in the dmesg
that we are using a too big buffer.

>
> > +
> > +     ctx = kzalloc(sizeof(*ctx) + data_size, GFP_KERNEL);
> > +     if (!ctx)
> > +             return ERR_PTR(-ENOMEM);
> > +
> > +     ctx->hdev = hdev;
> > +     ctx->allocated_size = data_size;
> > +
> > +     return ctx;
> > +}
>
> And why is this an inline function?  Why not put it in a .c file?

The problem I have here is that the hid module can be loaded as an
external module. So I can not directly use that helper from hid.ko
from kernel/bpf/hid.c (I need it there once for the
SEC(hid/user_event) bprogram attach type).

So the solution would be to have the code in the c part of
kernel/bpf/hid.c and export the function as GPL, but I wanted to have
the minimum of knowledge of HID-BPF internals in that file. So I ended
up using an inline so I can reuse it independently in kernel/bpf/hid.c
and drivers/hid/hid-bpf.c.

>
> > +
> > +union bpf_attr;
> > +struct bpf_prog;
> > +
> > +#if IS_ENABLED(CONFIG_HID)
> > +int bpf_hid_prog_query(const union bpf_attr *attr,
> > +                    union bpf_attr __user *uattr);
> > +int bpf_hid_link_create(const union bpf_attr *attr,
> > +                     struct bpf_prog *prog);
> > +#else
> > +static inline int bpf_hid_prog_query(const union bpf_attr *attr,
> > +                                  union bpf_attr __user *uattr)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> > +
> > +static inline int bpf_hid_link_create(const union bpf_attr *attr,
> > +                                   struct bpf_prog *prog)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> > +#endif
> > +
> > +static inline bool bpf_hid_link_empty(struct bpf_hid *bpf,
> > +                                   enum bpf_hid_attach_type type)
> > +{
> > +     return list_empty(&bpf->links[type]);
> > +}
> > +
> > +struct bpf_hid_hooks {
> > +     struct hid_device *(*hdev_from_fd)(int fd);
> > +     int (*link_attach)(struct hid_device *hdev, enum bpf_hid_attach_type type);
> > +     void (*array_detached)(struct hid_device *hdev, enum bpf_hid_attach_type type);
> > +};
> > +
> > +#ifdef CONFIG_BPF
> > +int bpf_hid_init(struct hid_device *hdev);
> > +void bpf_hid_exit(struct hid_device *hdev);
> > +void bpf_hid_set_hooks(struct bpf_hid_hooks *hooks);
> > +#else
> > +static inline int bpf_hid_init(struct hid_device *hdev)
> > +{
> > +     return 0;
> > +}
> > +
> > +static inline void bpf_hid_exit(struct hid_device *hdev) {}
> > +static inline void bpf_hid_set_hooks(struct bpf_hid_hooks *hooks) {}
> > +#endif
> > +
> > +#endif /* _BPF_HID_H */
> > diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> > index 48a91c51c015..1509862aacc4 100644
> > --- a/include/linux/bpf_types.h
> > +++ b/include/linux/bpf_types.h
> > @@ -76,6 +76,10 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_EXT, bpf_extension,
> >  BPF_PROG_TYPE(BPF_PROG_TYPE_LSM, lsm,
> >              void *, void *)
> >  #endif /* CONFIG_BPF_LSM */
> > +#if IS_ENABLED(CONFIG_HID)
> > +BPF_PROG_TYPE(BPF_PROG_TYPE_HID, hid,
> > +           __u32, u32)
>
> Why the mix of __u32 and u32 here?

This is actually valid. I tracked it down to kernel/bpf/btf.c with:

static union {
          struct bpf_ctx_convert {
  #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
          prog_ctx_type _id##_prog; \
          kern_ctx_type _id##_kern;
  #include <linux/bpf_types.h>
  #undef BPF_PROG_TYPE
          } *__t;
          /* 't' is written once under lock. Read many times. */
          const struct btf_type *t;
} bpf_ctx_convert;

So prog_ctx_type represents a user API, while kern_ctx_type
represents the kernel counterpart.

That being said, this is plain wrong, because I am not using u32 as
bpf context, but a properly defined struct :o)

So I probably need to amend this to be either "void *, void *)" or
something better (I'll ask Song in my reply to him).


>
> > +#endif
> >  #endif
> >  BPF_PROG_TYPE(BPF_PROG_TYPE_SYSCALL, bpf_syscall,
> >             void *, void *)
> > diff --git a/include/linux/hid.h b/include/linux/hid.h
> > index 7487b0586fe6..56f6f4ad45a7 100644
> > --- a/include/linux/hid.h
> > +++ b/include/linux/hid.h
> > @@ -15,6 +15,7 @@
> >
> >
> >  #include <linux/bitops.h>
> > +#include <linux/bpf-hid.h>
> >  #include <linux/types.h>
> >  #include <linux/slab.h>
> >  #include <linux/list.h>
> > @@ -639,6 +640,10 @@ struct hid_device {                                                      /* device report descriptor */
> >       struct list_head debug_list;
> >       spinlock_t  debug_list_lock;
> >       wait_queue_head_t debug_wait;
> > +
> > +#ifdef CONFIG_BPF
> > +     struct bpf_hid bpf;
> > +#endif
> >  };
> >
> >  #define to_hid_device(pdev) \
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index afe3d0d7f5f2..5978b92cacd3 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -952,6 +952,7 @@ enum bpf_prog_type {
> >       BPF_PROG_TYPE_LSM,
> >       BPF_PROG_TYPE_SK_LOOKUP,
> >       BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
> > +     BPF_PROG_TYPE_HID,
> >  };
> >
> >  enum bpf_attach_type {
> > @@ -997,6 +998,7 @@ enum bpf_attach_type {
> >       BPF_SK_REUSEPORT_SELECT,
> >       BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
> >       BPF_PERF_EVENT,
> > +     BPF_HID_DEVICE_EVENT,
> >       __MAX_BPF_ATTACH_TYPE
> >  };
> >
> > @@ -1011,6 +1013,7 @@ enum bpf_link_type {
> >       BPF_LINK_TYPE_NETNS = 5,
> >       BPF_LINK_TYPE_XDP = 6,
> >       BPF_LINK_TYPE_PERF_EVENT = 7,
> > +     BPF_LINK_TYPE_HID = 8,
> >
> >       MAX_BPF_LINK_TYPE,
> >  };
> > @@ -5870,6 +5873,10 @@ struct bpf_link_info {
> >               struct {
> >                       __u32 ifindex;
> >               } xdp;
> > +             struct  {
> > +                     __s32 hidraw_ino;
>
> "ino"?  We have lots of letters to spell words out :)

no comments... :)

>
> > +                     __u32 attach_type;
> > +             } hid;
> >       };
> >  } __attribute__((aligned(8)));
> >
> > diff --git a/include/uapi/linux/bpf_hid.h b/include/uapi/linux/bpf_hid.h
> > new file mode 100644
> > index 000000000000..975ca5bd526f
> > --- /dev/null
> > +++ b/include/uapi/linux/bpf_hid.h
> > @@ -0,0 +1,39 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later WITH Linux-syscall-note */
> > +
> > +/*
> > + *  HID BPF public headers
> > + *
> > + *  Copyright (c) 2021 Benjamin Tissoires
>
> Did you forget the copyright line on the other .h file above?

oops

>
> > + */
> > +
> > +#ifndef _UAPI__LINUX_BPF_HID_H__
> > +#define _UAPI__LINUX_BPF_HID_H__
> > +
> > +#include <linux/types.h>
> > +
> > +/*
> > + * The first 1024 bytes are available directly in the bpf programs.
> > + * To access the rest of the data (if allocated_size is bigger
> > + * than 1024, you need to use bpf_hid_ helpers.
> > + */
> > +#define HID_BPF_MIN_BUFFER_SIZE              1024
> > +#define HID_BPF_MAX_BUFFER_SIZE              16384           /* in sync with HID_MAX_BUFFER_SIZE */
>
> Can't you just use HID_MAX_BUFFER_SIZE?

Call me dumb, but curiously I could not get my code to compile there.
If I include linux/hid.h, things are getting messy and either the
tools or the kernel itself was not compiling properly (couldn't really
remember what was failing exactly, sorry).

>
> Anyway, all minor stuff, looks good!

Thanks. Not sure I'll keep the bpf_ctx the same after further
thoughts, but I appreciate the review :)

Cheers,
Benjamin

>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>

