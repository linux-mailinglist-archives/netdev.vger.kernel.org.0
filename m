Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27AB24DE345
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 22:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241044AbiCRVLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 17:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241034AbiCRVLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 17:11:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2898D1A8FD4;
        Fri, 18 Mar 2022 14:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9406B825AE;
        Fri, 18 Mar 2022 21:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868F7C340F0;
        Fri, 18 Mar 2022 21:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647637812;
        bh=uRbG0uWM5xu5uaPfqEzJdtDtnU9jnY1GFY9rvCd+m5Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OV+8ZI7Xy7U6DF87KRXD4f8tAfq2DARUsgJ72O0tTxibY7I0VMi8F7RAln2YqybOD
         N2n9oRrG2Fmp74OqhigcRwWMRVvO2OxG0MtEw3/2INUW01Fp5YmwpqPQbT6iI0jqIR
         vf9cs0RYyMleU58ulv+8F6D9hytkJa/1RuPyoQNMuIfrxOGGvvVipssaZ2YEr1ngqN
         sHfxYY/XQwvKukRfPUGuIUQVh/5SlZVYLF9tMPU3sW4HIQvdW5LmZ/gxWNHTW9LaNx
         tU0mkOTgwhjKwB8SB5qb6bpOChTeXEp8vXmtpJIi9SHo2YcybedbhIQGoDbDGxFRzT
         GyR7glGKi2HGg==
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-2d07ae0b1c0so103916897b3.2;
        Fri, 18 Mar 2022 14:10:12 -0700 (PDT)
X-Gm-Message-State: AOAM533813GwlcZaX/Jl2o8rYXA+9fqNyoFmjq6jyeFFvZd9ZUaSToho
        QDMfGB79fVf/QMrZbcFyLnjcUSxdq4JfHQuJ3u8=
X-Google-Smtp-Source: ABdhPJw+OwFyoclcU9oDOLY4n3474A6HHrXGugvC05Pk+De9AOuuW+SfZTYS2Yz32tm6untjnH+0BGIvulK1hB2Nnxg=
X-Received: by 2002:a81:c405:0:b0:2d0:d09a:576c with SMTP id
 j5-20020a81c405000000b002d0d09a576cmr13537663ywi.447.1647637811581; Fri, 18
 Mar 2022 14:10:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com> <20220318161528.1531164-7-benjamin.tissoires@redhat.com>
In-Reply-To: <20220318161528.1531164-7-benjamin.tissoires@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 18 Mar 2022 14:10:00 -0700
X-Gmail-Original-Message-ID: <CAPhsuW64x8_m1pNN9gC8LA8ajAmy+5O3y+iOaC7ixSXU=J624Q@mail.gmail.com>
Message-ID: <CAPhsuW64x8_m1pNN9gC8LA8ajAmy+5O3y+iOaC7ixSXU=J624Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 06/17] HID: allow to change the report
 descriptor from an eBPF program
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
> Make use of BPF_HID_ATTACH_RDESC_FIXUP so we can trigger an rdesc fixup
> in the bpf world.
>
> Whenever the program gets attached/detached, the device is reconnected
> meaning that userspace will see it disappearing and reappearing with
> the new report descriptor.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---
>
> changes in v3:
> - ensure the ctx.size is properly bounded by allocated size
> - s/link_attached/post_link_attach/
> - removed the switch statement with only one case
>
> changes in v2:
> - split the series by bpf/libbpf/hid/selftests and samples
> ---
>  drivers/hid/hid-bpf.c  | 62 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/hid/hid-core.c |  3 +-
>  include/linux/hid.h    |  6 ++++
>  3 files changed, 70 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/hid/hid-bpf.c b/drivers/hid/hid-bpf.c
> index 5060ebcb9979..45c87ff47324 100644
> --- a/drivers/hid/hid-bpf.c
> +++ b/drivers/hid/hid-bpf.c
> @@ -50,6 +50,14 @@ static struct hid_device *hid_bpf_fd_to_hdev(int fd)
>         return hdev;
>  }
>
> +static int hid_reconnect(struct hid_device *hdev)
> +{
> +       if (!test_and_set_bit(ffs(HID_STAT_REPROBED), &hdev->status))
> +               return device_reprobe(&hdev->dev);
> +
> +       return 0;
> +}
> +
>  static int hid_bpf_pre_link_attach(struct hid_device *hdev, enum bpf_hid_attach_type type)
>  {
>         int err = 0;
> @@ -92,6 +100,12 @@ static int hid_bpf_pre_link_attach(struct hid_device *hdev, enum bpf_hid_attach_
>         return err;
>  }
>
> +static void hid_bpf_post_link_attach(struct hid_device *hdev, enum bpf_hid_attach_type type)
> +{
> +       if (type == BPF_HID_ATTACH_RDESC_FIXUP)
> +               hid_reconnect(hdev);
> +}
> +
>  static void hid_bpf_array_detach(struct hid_device *hdev, enum bpf_hid_attach_type type)
>  {
>         switch (type) {
> @@ -99,6 +113,9 @@ static void hid_bpf_array_detach(struct hid_device *hdev, enum bpf_hid_attach_ty
>                 kfree(hdev->bpf.device_data);
>                 hdev->bpf.device_data = NULL;
>                 break;
> +       case BPF_HID_ATTACH_RDESC_FIXUP:
> +               hid_reconnect(hdev);
> +               break;
>         default:
>                 /* do nothing */
>                 break;
> @@ -116,6 +133,9 @@ static int hid_bpf_run_progs(struct hid_device *hdev, struct hid_bpf_ctx_kern *c
>         case HID_BPF_DEVICE_EVENT:
>                 type = BPF_HID_ATTACH_DEVICE_EVENT;
>                 break;
> +       case HID_BPF_RDESC_FIXUP:
> +               type = BPF_HID_ATTACH_RDESC_FIXUP;
> +               break;
>         default:
>                 return -EINVAL;
>         }
> @@ -155,11 +175,53 @@ u8 *hid_bpf_raw_event(struct hid_device *hdev, u8 *data, int *size)
>         return ctx.data;
>  }
>
> +u8 *hid_bpf_report_fixup(struct hid_device *hdev, u8 *rdesc, unsigned int *size)
> +{
> +       int ret;
> +       struct hid_bpf_ctx_kern ctx = {
> +               .type = HID_BPF_RDESC_FIXUP,
> +               .hdev = hdev,
> +               .size = *size,
> +       };
> +
> +       if (bpf_hid_link_empty(&hdev->bpf, BPF_HID_ATTACH_RDESC_FIXUP))

Do we need to lock bpf_hid_mutex before calling bpf_hid_link_empty()?
(or maybe we
already did?)


> +               goto ignore_bpf;
> +
> +       ctx.data = kmemdup(rdesc, HID_MAX_DESCRIPTOR_SIZE, GFP_KERNEL);
> +       if (!ctx.data)
> +               goto ignore_bpf;
> +
> +       ctx.allocated_size = HID_MAX_DESCRIPTOR_SIZE;
> +
> +       ret = hid_bpf_run_progs(hdev, &ctx);
> +       if (ret)
> +               goto ignore_bpf;
> +
> +       if (ctx.size > ctx.allocated_size)
> +               goto ignore_bpf;
> +
> +       *size = ctx.size;
> +
> +       if (*size) {
> +               rdesc = krealloc(ctx.data, *size, GFP_KERNEL);
> +       } else {
> +               rdesc = NULL;
> +               kfree(ctx.data);
> +       }
> +
> +       return rdesc;
> +
> + ignore_bpf:
> +       kfree(ctx.data);
> +       return kmemdup(rdesc, *size, GFP_KERNEL);
> +}
> +
>  int __init hid_bpf_module_init(void)
>  {
>         struct bpf_hid_hooks hooks = {
>                 .hdev_from_fd = hid_bpf_fd_to_hdev,
>                 .pre_link_attach = hid_bpf_pre_link_attach,
> +               .post_link_attach = hid_bpf_post_link_attach,
>                 .array_detach = hid_bpf_array_detach,
>         };
>
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 937fab7eb9c6..3182c39db006 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1213,7 +1213,8 @@ int hid_open_report(struct hid_device *device)
>                 return -ENODEV;
>         size = device->dev_rsize;
>
> -       buf = kmemdup(start, size, GFP_KERNEL);
> +       /* hid_bpf_report_fixup() ensures we work on a copy of rdesc */
> +       buf = hid_bpf_report_fixup(device, start, &size);
>         if (buf == NULL)
>                 return -ENOMEM;
>
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index 8fd79011f461..66d949d10b78 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -1213,10 +1213,16 @@ do {                                                                    \
>
>  #ifdef CONFIG_BPF
>  u8 *hid_bpf_raw_event(struct hid_device *hdev, u8 *rd, int *size);
> +u8 *hid_bpf_report_fixup(struct hid_device *hdev, u8 *rdesc, unsigned int *size);
>  int hid_bpf_module_init(void);
>  void hid_bpf_module_exit(void);
>  #else
>  static inline u8 *hid_bpf_raw_event(struct hid_device *hdev, u8 *rd, int *size) { return rd; }
> +static inline u8 *hid_bpf_report_fixup(struct hid_device *hdev, u8 *rdesc,
> +                                      unsigned int *size)
> +{
> +       return kmemdup(rdesc, *size, GFP_KERNEL);
> +}
>  static inline int hid_bpf_module_init(void) { return 0; }
>  static inline void hid_bpf_module_exit(void) {}
>  #endif
> --
> 2.35.1
>
