Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445144DE335
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 22:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240383AbiCRVDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 17:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbiCRVDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 17:03:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDA02DF3CE;
        Fri, 18 Mar 2022 14:02:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 188C5B825A1;
        Fri, 18 Mar 2022 21:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1B7C340F0;
        Fri, 18 Mar 2022 21:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647637343;
        bh=fS4BOjVzyvppTrYK3z2dZ89hlOvrjRZPlby5Ug9xKl4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GAxtZ/K/N3qJKE1Zn61u2HMgZLGxJotxT/hbdsXKLBvh+5trwG+FLNYbX1zyeWkAg
         FRBkGoFSikcuJ5Whhp94HSQ+M7Vn58gmMNR0Twe9gfgmD1InmAjqViDMapTiPBusdj
         zCRh3GyYeighr9Xsh/cBbN2XwKbQIBniUu/mz3exNdRr6pmpGm59pCNo5ZcUfeBbDR
         G8jpiJBzl1MneE1HVpeeKZVk5zMeV6Yw4bjuWnt6Tg6Ttp4uRJzeP+EY3nvVDY/Mja
         /Ub7bAqnsJdH8RnguZiI7pIO9Kh/rlnUXU+xxEazulP6YC7kihSrGjiaee2LEDgh8u
         gZLK2juPjUMRg==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-2e5e31c34bfso24434317b3.10;
        Fri, 18 Mar 2022 14:02:23 -0700 (PDT)
X-Gm-Message-State: AOAM533y5DvLwvb47go+Y7rd3CIuK7cfPAjfumA4O8V3KXUCjKYgMjMb
        drsNK5PIWGQut5PGcQZ43K43lWnVd9p72pAoJtg=
X-Google-Smtp-Source: ABdhPJx3jkCbHbr6rgCRI1G9liFl3sZGGO4Sefl0ajvshE1KR7J20nmtMuEtiMTGTVGlaJq+g0+7ACPLFUfwE8uv+Cg=
X-Received: by 2002:a81:951:0:b0:2e5:9e38:147c with SMTP id
 78-20020a810951000000b002e59e38147cmr13265656ywj.211.1647637342737; Fri, 18
 Mar 2022 14:02:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com> <20220318161528.1531164-6-benjamin.tissoires@redhat.com>
In-Reply-To: <20220318161528.1531164-6-benjamin.tissoires@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 18 Mar 2022 14:02:11 -0700
X-Gmail-Original-Message-ID: <CAPhsuW47s2tUhe-XQHJonBM9P3Upv8CNKpW_Zewgc_3RYW9WMQ@mail.gmail.com>
Message-ID: <CAPhsuW47s2tUhe-XQHJonBM9P3Upv8CNKpW_Zewgc_3RYW9WMQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 05/17] HID: hook up with bpf
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

On Fri, Mar 18, 2022 at 9:17 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> Now that BPF can be compatible with HID, add the capability into HID.
> drivers/hid/hid-bpf.c takes care of the glue between bpf and HID, and
> hid-core can then inject any incoming event from the device into a BPF
> program to filter/analyze it.

So we only need this part for DEVICE EVENT?

>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---
>
> changes in v3:
> - squashed "only call hid_bpf_raw_event() if a ctx is available"
>   and "bpf: compute only the required buffer size for the device"
>   into this one
> - ensure the ctx.size is properly bounded by allocated size
> - s/link_attach/pre_link_attach/
> - s/array_detached/array_detach/
> - fix default switch case when doing nothing
> - reworked hid_bpf_pre_link_attach() to avoid the switch
>
> changes in v2:
> - split the series by bpf/libbpf/hid/selftests and samples
> - addressed review comments from v1
> ---
>  drivers/hid/Makefile   |   1 +
>  drivers/hid/hid-bpf.c  | 174 +++++++++++++++++++++++++++++++++++++++++
>  drivers/hid/hid-core.c |  24 +++++-
>  include/linux/hid.h    |  11 +++
>  4 files changed, 207 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/hid/hid-bpf.c
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
> index 000000000000..5060ebcb9979
> --- /dev/null
> +++ b/drivers/hid/hid-bpf.c
> @@ -0,0 +1,174 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + *  BPF in HID support for Linux
> + *
> + *  Copyright (c) 2022 Benjamin Tissoires
> + */
> +
> +#include <linux/filter.h>
> +#include <linux/mutex.h>
> +#include <linux/slab.h>
> +
> +#include <uapi/linux/bpf_hid.h>
> +#include <linux/hid.h>
> +
> +static int __hid_bpf_match_sysfs(struct device *dev, const void *data)
> +{
> +       struct kernfs_node *kn = dev->kobj.sd;
> +       struct kernfs_node *uevent_kn;
> +
> +       uevent_kn = kernfs_find_and_get_ns(kn, "uevent", NULL);
> +
> +       return uevent_kn == data;
> +}
> +
> +static struct hid_device *hid_bpf_fd_to_hdev(int fd)
> +{
> +       struct device *dev;
> +       struct hid_device *hdev;
> +       struct fd f = fdget(fd);
> +       struct inode *inode;
> +       struct kernfs_node *node;
> +
> +       if (!f.file) {
> +               hdev = ERR_PTR(-EBADF);
> +               goto out;
> +       }
> +
> +       inode = file_inode(f.file);
> +       node = inode->i_private;
> +
> +       dev = bus_find_device(&hid_bus_type, NULL, node, __hid_bpf_match_sysfs);
> +
> +       if (dev)
> +               hdev = to_hid_device(dev);
> +       else
> +               hdev = ERR_PTR(-EINVAL);
> +
> + out:
> +       fdput(f);
> +       return hdev;
> +}
> +
> +static int hid_bpf_pre_link_attach(struct hid_device *hdev, enum bpf_hid_attach_type type)
> +{
> +       int err = 0;
> +       unsigned int i, j, max_report_len = 0;
> +       unsigned int alloc_size = 0;
> +
> +       if (type != BPF_HID_ATTACH_DEVICE_EVENT)
> +               return 0;
> +
> +       /* hdev->bpf.device_data is already allocated, abort */
> +       if (hdev->bpf.device_data)
> +               return 0;
> +
> +       /* compute the maximum report length for this device */
> +       for (i = 0; i < HID_REPORT_TYPES; i++) {
> +               struct hid_report_enum *report_enum = hdev->report_enum + i;
> +
> +               for (j = 0; j < HID_MAX_IDS; j++) {
> +                       struct hid_report *report = report_enum->report_id_hash[j];
> +
> +                       if (report)
> +                               max_report_len = max(max_report_len, hid_report_len(report));
> +               }
> +       }
> +
> +       /*
> +        * Give us a little bit of extra space and some predictability in the
> +        * buffer length we create. This way, we can tell users that they can
> +        * work on chunks of 64 bytes of memory without having the bpf verifier
> +        * scream at them.
> +        */
> +       alloc_size = DIV_ROUND_UP(max_report_len, 64) * 64;
> +
> +       hdev->bpf.device_data = kzalloc(alloc_size, GFP_KERNEL);
> +       if (!hdev->bpf.device_data)
> +               err = -ENOMEM;
> +       else
> +               hdev->bpf.allocated_data = alloc_size;
> +
> +       return err;
> +}
> +
> +static void hid_bpf_array_detach(struct hid_device *hdev, enum bpf_hid_attach_type type)
> +{
> +       switch (type) {
> +       case BPF_HID_ATTACH_DEVICE_EVENT:
> +               kfree(hdev->bpf.device_data);
> +               hdev->bpf.device_data = NULL;
> +               break;
> +       default:
> +               /* do nothing */
> +               break;
> +       }
> +}
> +
> +static int hid_bpf_run_progs(struct hid_device *hdev, struct hid_bpf_ctx_kern *ctx)
> +{
> +       enum bpf_hid_attach_type type;
> +
> +       if (!ctx)
> +               return -EINVAL;
> +
> +       switch (ctx->type) {
> +       case HID_BPF_DEVICE_EVENT:
> +               type = BPF_HID_ATTACH_DEVICE_EVENT;
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       if (!hdev->bpf.run_array[type])
> +               return 0;
> +
> +       return BPF_PROG_RUN_ARRAY(hdev->bpf.run_array[type], ctx, bpf_prog_run);
> +}
> +
> +u8 *hid_bpf_raw_event(struct hid_device *hdev, u8 *data, int *size)
> +{
> +       int ret;
> +       struct hid_bpf_ctx_kern ctx = {
> +               .type = HID_BPF_DEVICE_EVENT,
> +               .hdev = hdev,
> +               .size = *size,
> +               .data = hdev->bpf.device_data,
> +               .allocated_size = hdev->bpf.allocated_data,
> +       };
> +
> +       if (bpf_hid_link_empty(&hdev->bpf, BPF_HID_ATTACH_DEVICE_EVENT))
> +               return data;
> +
> +       memset(ctx.data, 0, hdev->bpf.allocated_data);
> +       memcpy(ctx.data, data, *size);
> +
> +       ret = hid_bpf_run_progs(hdev, &ctx);
> +       if (ret)
> +               return ERR_PTR(-EIO);
> +
> +       if (!ctx.size || ctx.size > ctx.allocated_size)
> +               return ERR_PTR(-EINVAL);
> +
> +       *size = ctx.size;
> +
> +       return ctx.data;
> +}
> +
> +int __init hid_bpf_module_init(void)
> +{
> +       struct bpf_hid_hooks hooks = {
> +               .hdev_from_fd = hid_bpf_fd_to_hdev,
> +               .pre_link_attach = hid_bpf_pre_link_attach,
> +               .array_detach = hid_bpf_array_detach,
> +       };
> +
> +       bpf_hid_set_hooks(&hooks);
> +
> +       return 0;
> +}
> +
> +void __exit hid_bpf_module_exit(void)
> +{
> +       bpf_hid_set_hooks(NULL);
> +}
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index f1aed5bbd000..937fab7eb9c6 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1748,13 +1748,24 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, u32 size,
>         struct hid_driver *hdrv;
>         unsigned int a;
>         u32 rsize, csize = size;
> -       u8 *cdata = data;
> +       u8 *cdata;
>         int ret = 0;
>
> +       /* we pre-test if device_data is available here to cut the calls at the earliest */
> +       if (hid->bpf.device_data) {
> +               data = hid_bpf_raw_event(hid, data, &size);
> +               if (IS_ERR(data)) {
> +                       ret = PTR_ERR(data);
> +                       goto out;
> +               }
> +       }
> +
>         report = hid_get_report(report_enum, data);
>         if (!report)
>                 goto out;
>
> +       cdata = data;
> +
>         if (report_enum->numbered) {
>                 cdata++;
>                 csize--;
> @@ -2528,10 +2539,12 @@ int hid_add_device(struct hid_device *hdev)
>
>         hid_debug_register(hdev, dev_name(&hdev->dev));
>         ret = device_add(&hdev->dev);
> -       if (!ret)
> +       if (!ret) {
>                 hdev->status |= HID_STAT_ADDED;
> -       else
> +       } else {
>                 hid_debug_unregister(hdev);
> +               bpf_hid_exit(hdev);
> +       }
>
>         return ret;
>  }
> @@ -2567,6 +2580,7 @@ struct hid_device *hid_allocate_device(void)
>         spin_lock_init(&hdev->debug_list_lock);
>         sema_init(&hdev->driver_input_lock, 1);
>         mutex_init(&hdev->ll_open_lock);
> +       bpf_hid_init(hdev);
>
>         return hdev;
>  }
> @@ -2574,6 +2588,7 @@ EXPORT_SYMBOL_GPL(hid_allocate_device);
>
>  static void hid_remove_device(struct hid_device *hdev)
>  {
> +       bpf_hid_exit(hdev);
>         if (hdev->status & HID_STAT_ADDED) {
>                 device_del(&hdev->dev);
>                 hid_debug_unregister(hdev);
> @@ -2700,6 +2715,8 @@ static int __init hid_init(void)
>
>         hid_debug_init();
>
> +       hid_bpf_module_init();
> +
>         return 0;
>  err_bus:
>         bus_unregister(&hid_bus_type);
> @@ -2709,6 +2726,7 @@ static int __init hid_init(void)
>
>  static void __exit hid_exit(void)
>  {
> +       hid_bpf_module_exit();
>         hid_debug_exit();
>         hidraw_exit();
>         bus_unregister(&hid_bus_type);
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index 56f6f4ad45a7..8fd79011f461 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -27,6 +27,7 @@
>  #include <linux/mutex.h>
>  #include <linux/power_supply.h>
>  #include <uapi/linux/hid.h>
> +#include <uapi/linux/bpf_hid.h>
>
>  /*
>   * We parse each description item into this structure. Short items data
> @@ -1210,4 +1211,14 @@ do {                                                                     \
>  #define hid_dbg_once(hid, fmt, ...)                    \
>         dev_dbg_once(&(hid)->dev, fmt, ##__VA_ARGS__)
>
> +#ifdef CONFIG_BPF
> +u8 *hid_bpf_raw_event(struct hid_device *hdev, u8 *rd, int *size);
> +int hid_bpf_module_init(void);
> +void hid_bpf_module_exit(void);
> +#else
> +static inline u8 *hid_bpf_raw_event(struct hid_device *hdev, u8 *rd, int *size) { return rd; }
> +static inline int hid_bpf_module_init(void) { return 0; }
> +static inline void hid_bpf_module_exit(void) {}
> +#endif
> +
>  #endif
> --
> 2.35.1
>
