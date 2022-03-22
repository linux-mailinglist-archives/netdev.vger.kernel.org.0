Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0E34E495D
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 23:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238470AbiCVWxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 18:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiCVWxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 18:53:02 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04D25DA72;
        Tue, 22 Mar 2022 15:51:33 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id i184so2851551pgc.1;
        Tue, 22 Mar 2022 15:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1vztlqi0NlGRoIXQyqiMSOi7b8rX2cFL0tMJ+wH/2ZQ=;
        b=ZkaCFeD4okTI/mcV3ziegaOTmSg/J+0RaFUIlC8MYQP/DrFEQb7gGi1KPaWaTSktCo
         QiVQkhLhaua8oH9WYAA+gwWgpDMsZqF+qYAsIx6/itHn5lsfgFvdPiAZtEo58gW3U+5y
         Xj3X6rNyub9Zwu50L6TLSjfBD4ldzTSdYrkSN0I0j/oXkyNedfSHx44zL1jn20yAL0r7
         5q9B0OZuB1W4s5PkM23+U/v63t4JG8ATPv9NxwaYiMiZlfPAlOCSkb8FEGYkHvU4MH6m
         7tOZG7fWSrAkHiooTVrewT4wOSS9awCRHf5W0rISbSX+cYESykVlJSixcPzbw6slllia
         AhAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1vztlqi0NlGRoIXQyqiMSOi7b8rX2cFL0tMJ+wH/2ZQ=;
        b=OyHdIKrphA4SyjZqTUYD81r4oWQDm4rp15lf4BKXK1RawPnzDVDJbD2+rwWZPAPMUg
         bxHH+91lO2CLt8s+8knCNnQRrcjXMYERIV42y7W4PwTJ8ZiED9RLlbs/8BT3/TVLTC7V
         U9/LhnhnbtscaR4SOBpZIEtNLsGtQEb55I1NpMBWNhZVBRsDGUwfAjbNQvU0OLhVJN3k
         geQk5Mi4hRFN9twwnpr/+6Nz/DYVAMVkTbBZlZDIMhZ7wj/hK0i7zT/76+fxjnIdkKpe
         7dLkz4Tyt58gH27bjE2swNx5EA0oTY6usXwrGdtsDKq0dX+UTFusSHfyiAEW4muD0z8I
         p66Q==
X-Gm-Message-State: AOAM5306kcs0seQOwGmyWdw5Fa2CeJiTwMGl1UG6563GRnnt6vkVOsg2
        nnU3CCVpoLQvpd5W+G4O7/FgINTFLvCkBrcFkvA=
X-Google-Smtp-Source: ABdhPJxaDjb86XDSFFXHgm/5BHKgjZ1H5gBhPR6BvzC2gzZJ1eD2Zb8MXXorlR5YVKbkUivid4o3lla3Vec5E33VExI=
X-Received: by 2002:aa7:805a:0:b0:4f6:dc68:5d41 with SMTP id
 y26-20020aa7805a000000b004f6dc685d41mr31193479pfm.69.1647989493007; Tue, 22
 Mar 2022 15:51:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com> <20220318161528.1531164-7-benjamin.tissoires@redhat.com>
In-Reply-To: <20220318161528.1531164-7-benjamin.tissoires@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 22 Mar 2022 15:51:21 -0700
Message-ID: <CAADnVQLvhWxEtHETg0tasJ7Fp5JHNRYWdjhnxi1y1gBpXS=bvQ@mail.gmail.com>
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
        LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
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

On Fri, Mar 18, 2022 at 9:16 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
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

Looking at this patch and the majority of other patches...
the code is doing a lot of work to connect HID side with bpf.
At the same time the evolution of the patch series suggests
that these hook points are not quite stable. More hooks and
helpers are being added.
It tells us that it's way too early to introduce a stable
interface between HID and bpf.
We suggest to use __weak global functions and unstable kfunc helpers
to achieve the same goal.
This way HID side and bpf side can evolve without introducing
stable uapi burden.
For example this particular patch can be compressed to:
__weak int hid_bpf_report_fixup(struct hid_device *hdev, u8 *rdesc,
unsigned int *size)
{
   return 0;
}
ALLOW_ERROR_INJECTION(ALLOW_ERROR_INJECTION, ERRNO);

- buf = kmemdup(start, size, GFP_KERNEL);
+ if (!hid_bpf_report_fixup(device, start, &size))
+   buf = kmemdup(start, size, GFP_KERNEL);

Then bpf program can replace hid_bpf_report_fixup function and adjust its
return value while reading args.

Similar approach can be done with all other hooks.

Once api between HID and bpf stabilizes we can replace nop functions
with writeable tracepoints to make things a bit more stable
while still allowing for change of the interface in the future.

The amount of bpf specific code in HID core will be close to zero
while bpf can be used to flexibly tweak it.

kfunc is a corresponding mechanism to introduce unstable api
from bpf into the kernel instead of stable helpers.
Just whitelist some functions as unstable kfunc helpers and call them
from bpf progs.
See net/bpf/test_run.c and bpf_kfunc_call* for inspiration.
