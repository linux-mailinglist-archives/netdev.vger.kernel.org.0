Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D314E4C5456
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 08:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiBZHUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 02:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiBZHUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 02:20:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859E510EC6B;
        Fri, 25 Feb 2022 23:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DA61B80E98;
        Sat, 26 Feb 2022 07:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D579AC340F7;
        Sat, 26 Feb 2022 07:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645860011;
        bh=ofx/8UMawymSolW9/1spk+z2Bwj/As67j3fVkfBuAzs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iCF/uAhVIA7RG+I1dt0cBvq2m17PR8LzsMFcaai9xyipY638e4u7caZj8Up4mdbjC
         U0Qb2Wr02F3O/bfYLGfUHS6J1mAXTzmd4oiVd+C6/g0UYH+gVly5AiguSeBxU4hP3L
         fh14a1xXdNDi5+FFHmNfbhkjQkSefxg94D5o/uRJSNGxefLSBRkj3BX8tYCSS8TlfS
         y3w9rWoVFjmnUhWsP7hdDfr7ruc9vrqdo0YLMZQSjqqhZH8PZ8EJ/Dz9ZN8saD+bDs
         qdb+7+6Ov/jfnxUKVJSUPTsd99zAUwA+O9/2BL4Qlg5KEtPmNtnnhJGpkfdf+2qON9
         web5PzO55EKLA==
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-2d641c31776so55816417b3.12;
        Fri, 25 Feb 2022 23:20:11 -0800 (PST)
X-Gm-Message-State: AOAM530D9yFbOgmtHGarx0ARbaWS5mplACLtZ9vmFzNrCqUY0/2AZg53
        2vbhudY7OrD/KM3fDVhkORJs8keibEo5u7czvqY=
X-Google-Smtp-Source: ABdhPJxdIFLHwHUx529GD3ngCgx2QM3CmfT7PgzGhXo2DtgLpPra5Wv7EzZh/16FFBtkTaHYLf7wLuM43neFA3g+GMk=
X-Received: by 2002:a0d:ea0a:0:b0:2d6:93b9:cda1 with SMTP id
 t10-20020a0dea0a000000b002d693b9cda1mr11410445ywe.460.1645860010773; Fri, 25
 Feb 2022 23:20:10 -0800 (PST)
MIME-Version: 1.0
References: <20220224110828.2168231-1-benjamin.tissoires@redhat.com> <20220224110828.2168231-2-benjamin.tissoires@redhat.com>
In-Reply-To: <20220224110828.2168231-2-benjamin.tissoires@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 25 Feb 2022 23:19:59 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6wx6aNfLzFt5npCG+X=keB57_mkZNwHkAQ0gZWNk9ixw@mail.gmail.com>
Message-ID: <CAPhsuW6wx6aNfLzFt5npCG+X=keB57_mkZNwHkAQ0gZWNk9ixw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 1/6] HID: initial BPF implementation
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
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
        open list <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 3:09 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> HID is a protocol that could benefit from using BPF too.
>
> This patch implements a net-like use of BPF capability for HID.
> Any incoming report coming from the device gets injected into a series
> of BPF programs that can modify it or even discard it by setting the
> size in the context to 0.
>
> The kernel/bpf implementation is based on net-namespace.c, with only
> the bpf_link part kept, there is no real points in keeping the
> bpf_prog_{attach|detach} API.
>
> The implementation is split into 2 parts:
> - the kernel/bpf part which isn't aware of the HID usage, but takes care
>   of handling the BPF links
> - the drivers/hid/hid-bpf.c part which knows about HID
>
> Note that HID can be compiled in as a module, and so the functions that
> kernel/bpf/hid.c needs to call in hid.ko are exported in struct hid_hooks.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  drivers/hid/Makefile                         |   1 +
>  drivers/hid/hid-bpf.c                        | 176 ++++++++
>  drivers/hid/hid-core.c                       |  21 +-
>  include/linux/bpf-hid.h                      |  87 ++++
>  include/linux/bpf_types.h                    |   4 +
>  include/linux/hid.h                          |  16 +
>  include/uapi/linux/bpf.h                     |   7 +
>  include/uapi/linux/bpf_hid.h                 |  39 ++
>  kernel/bpf/Makefile                          |   3 +
>  kernel/bpf/hid.c                             | 437 +++++++++++++++++++
>  kernel/bpf/syscall.c                         |   8 +
>  samples/bpf/.gitignore                       |   1 +
>  samples/bpf/Makefile                         |   4 +
>  samples/bpf/hid_mouse_kern.c                 |  66 +++
>  samples/bpf/hid_mouse_user.c                 | 129 ++++++
>  tools/include/uapi/linux/bpf.h               |   7 +
>  tools/lib/bpf/libbpf.c                       |   7 +
>  tools/lib/bpf/libbpf.h                       |   2 +
>  tools/lib/bpf/libbpf.map                     |   1 +
>  tools/testing/selftests/bpf/prog_tests/hid.c | 318 ++++++++++++++
>  tools/testing/selftests/bpf/progs/hid.c      |  20 +
>  21 files changed, 1351 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/hid/hid-bpf.c
>  create mode 100644 include/linux/bpf-hid.h
>  create mode 100644 include/uapi/linux/bpf_hid.h
>  create mode 100644 kernel/bpf/hid.c
>  create mode 100644 samples/bpf/hid_mouse_kern.c
>  create mode 100644 samples/bpf/hid_mouse_user.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/hid.c
>  create mode 100644 tools/testing/selftests/bpf/progs/hid.c

Please split kernel changes, libbpf changes, selftests, and sample code into
separate patches.

>
> diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
> index 6d3e630e81af..08d2d7619937 100644
> --- a/drivers/hid/Makefile
> +++ b/drivers/hid/Makefile
> @@ -4,6 +4,7 @@
>  #
>  hid-y                  := hid-core.o hid-input.o hid-quirks.o
>  hid-$(CONFIG_DEBUG_FS)         += hid-debug.o
> +hid-$(CONFIG_BPF)              += hid-bpf.o
>
>  obj-$(CONFIG_HID)              += hid.o
>  obj-$(CONFIG_UHID)             += uhid.o
> diff --git a/drivers/hid/hid-bpf.c b/drivers/hid/hid-bpf.c
> new file mode 100644
> index 000000000000..6c8445820944
> --- /dev/null
> +++ b/drivers/hid/hid-bpf.c
> @@ -0,0 +1,176 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + *  BPF in HID support for Linux
> + *
> + *  Copyright (c) 2021 Benjamin Tissoires

Maybe 2022?

[...]

> +static int hid_bpf_run_progs(struct hid_device *hdev, enum bpf_hid_attach_type type,
> +                            struct hid_bpf_ctx *ctx, u8 *data, int size)
> +{
> +       enum hid_bpf_event event = HID_BPF_UNDEF;
> +
> +       if (type < 0 || !ctx)
> +               return -EINVAL;
> +
> +       switch (type) {
> +       case BPF_HID_ATTACH_DEVICE_EVENT:
> +               event = HID_BPF_DEVICE_EVENT;
> +               if (size > sizeof(ctx->u.device.data))
> +                       return -E2BIG;
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       if (!hdev->bpf.run_array[type])
> +               return 0;
> +
> +       memset(ctx, 0, sizeof(*ctx));
> +       ctx->hdev = hdev;
> +       ctx->type = event;
> +
> +       if (size && data) {
> +               switch (event) {
> +               case HID_BPF_DEVICE_EVENT:
> +                       memcpy(ctx->u.device.data, data, size);
> +                       ctx->u.device.size = size;
> +                       break;
> +               default:
> +                       /* do nothing */
> +               }
> +       }
> +
> +       BPF_PROG_RUN_ARRAY(hdev->bpf.run_array[type], ctx, bpf_prog_run);

I guess we need "return BPF_PROG_RUN_ARRAY(...)"?

> +
> +       return 0;
> +}
> +
> +u8 *hid_bpf_raw_event(struct hid_device *hdev, u8 *data, int *size)
> +{
> +       int ret;
> +
> +       if (bpf_hid_link_empty(&hdev->bpf, BPF_HID_ATTACH_DEVICE_EVENT))
> +               return data;
> +
> +       ret = hid_bpf_run_progs(hdev, BPF_HID_ATTACH_DEVICE_EVENT,
> +                               hdev->bpf.ctx, data, *size);
> +       if (ret)
> +               return data;

shall we return ERR_PTR(ret)?

> +
> +       if (!hdev->bpf.ctx->u.device.size)
> +               return ERR_PTR(-EINVAL);
> +
> +       *size = hdev->bpf.ctx->u.device.size;
> +
> +       return hdev->bpf.ctx->u.device.data;
> +}

[...]

> diff --git a/include/uapi/linux/bpf_hid.h b/include/uapi/linux/bpf_hid.h
> new file mode 100644
> index 000000000000..243ac45a253f
> --- /dev/null
> +++ b/include/uapi/linux/bpf_hid.h
> @@ -0,0 +1,39 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later WITH Linux-syscall-note */
> +
> +/*
> + *  HID BPF public headers
> + *
> + *  Copyright (c) 2021 Benjamin Tissoires
> + */
> +
> +#ifndef _UAPI__LINUX_BPF_HID_H__
> +#define _UAPI__LINUX_BPF_HID_H__
> +
> +#include <linux/types.h>
> +
> +#define HID_BPF_MAX_BUFFER_SIZE                16384           /* 16kb */
> +
> +struct hid_device;
> +
> +enum hid_bpf_event {
> +       HID_BPF_UNDEF = 0,
> +       HID_BPF_DEVICE_EVENT,
> +};
> +
> +/* type is HID_BPF_DEVICE_EVENT */
> +struct hid_bpf_ctx_device_event {
> +       __u8 data[HID_BPF_MAX_BUFFER_SIZE];

16kB sounds pretty big to me, do we usually need that much?

> +       unsigned long size;
> +};
> +
> +struct hid_bpf_ctx {
> +       enum hid_bpf_event type;
> +       struct hid_device *hdev;
> +
> +       union {
> +               struct hid_bpf_ctx_device_event device;
> +       } u;
> +};
> +
> +#endif /* _UAPI__LINUX_BPF_HID_H__ */
[...]

> diff --git a/kernel/bpf/hid.c b/kernel/bpf/hid.c
> new file mode 100644
> index 000000000000..d3cb952bfc26
> --- /dev/null
> +++ b/kernel/bpf/hid.c

[...]

> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 9c7a72b65eee..230ca6964a7e 100644
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
> @@ -2174,6 +2175,7 @@ static bool is_net_admin_prog_type(enum bpf_prog_type prog_type)
>         case BPF_PROG_TYPE_CGROUP_SYSCTL:
>         case BPF_PROG_TYPE_SOCK_OPS:
>         case BPF_PROG_TYPE_EXT: /* extends any prog */
> +       case BPF_PROG_TYPE_HID:

Is this net_admin type?

>                 return true;
>         case BPF_PROG_TYPE_CGROUP_SKB:
>                 /* always unpriv */
> @@ -3188,6 +3190,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
>                 return BPF_PROG_TYPE_SK_LOOKUP;
>         case BPF_XDP:
>                 return BPF_PROG_TYPE_XDP;
> +       case BPF_HID_DEVICE_EVENT:
> +               return BPF_PROG_TYPE_HID;
>         default:
>                 return BPF_PROG_TYPE_UNSPEC;
>         }
> @@ -3331,6 +3335,8 @@ static int bpf_prog_query(const union bpf_attr *attr,
>         case BPF_SK_MSG_VERDICT:
>         case BPF_SK_SKB_VERDICT:
>                 return sock_map_bpf_prog_query(attr, uattr);
> +       case BPF_HID_DEVICE_EVENT:
> +               return bpf_hid_prog_query(attr, uattr);
>         default:
>                 return -EINVAL;
>         }
> @@ -4325,6 +4331,8 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
>                 ret = bpf_perf_link_attach(attr, prog);
>                 break;
>  #endif
> +       case BPF_PROG_TYPE_HID:
> +               return bpf_hid_link_create(attr, prog);
>         default:
>                 ret = -EINVAL;
>         }

[...]

> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index afe3d0d7f5f2..5978b92cacd3 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -952,6 +952,7 @@ enum bpf_prog_type {
>         BPF_PROG_TYPE_LSM,
>         BPF_PROG_TYPE_SK_LOOKUP,
>         BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
> +       BPF_PROG_TYPE_HID,
>  };
>
>  enum bpf_attach_type {
> @@ -997,6 +998,7 @@ enum bpf_attach_type {
>         BPF_SK_REUSEPORT_SELECT,
>         BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
>         BPF_PERF_EVENT,
> +       BPF_HID_DEVICE_EVENT,
>         __MAX_BPF_ATTACH_TYPE
>  };
>
> @@ -1011,6 +1013,7 @@ enum bpf_link_type {
>         BPF_LINK_TYPE_NETNS = 5,
>         BPF_LINK_TYPE_XDP = 6,
>         BPF_LINK_TYPE_PERF_EVENT = 7,
> +       BPF_LINK_TYPE_HID = 8,
>
>         MAX_BPF_LINK_TYPE,
>  };
> @@ -5870,6 +5873,10 @@ struct bpf_link_info {
>                 struct {
>                         __u32 ifindex;
>                 } xdp;
> +               struct  {
> +                       __s32 hidraw_ino;
> +                       __u32 attach_type;
> +               } hid;
>         };
>  } __attribute__((aligned(8)));
>
