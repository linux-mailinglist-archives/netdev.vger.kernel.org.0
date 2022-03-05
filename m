Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 058A84CE172
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 01:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiCEAY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 19:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiCEAYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 19:24:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6587B555;
        Fri,  4 Mar 2022 16:23:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E670861F46;
        Sat,  5 Mar 2022 00:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57795C340F1;
        Sat,  5 Mar 2022 00:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646439816;
        bh=oVr0MHcRWA7BlyaKO3wuNIotdRH8J4KNzvrQ/jGVkD8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ExYDSE7cO64LbKB8MMqhdgVwaUEqsVziHk9DUkI6TrMrMdGWB8MweNd2sjAaQPcQA
         dybytGWsBzuR7B/vjZGVIcj4PAemUd72e06gAYDbQzWu7cIRc/nagMaPAP3B4RPUdX
         E+js8N6XrcSzImDyOEVwwdT/r3T9mpZC3Al5wbeoO7LqT1njD3pHihxj8SU/oUzI7C
         CwO5mm6lHFMgCBs3ji2dMn3kdAp4ov3Rm18qkxaWrHGP5JYE4NhGKx8mhfiXmo3xvk
         Jk2soRi+gzqQFqjRX8GV6yWvCg5ARMZuPi78da9+n27gspEm3iwHqoLxladL2N69ga
         w8LFjeBRdf9sQ==
Received: by mail-yb1-f175.google.com with SMTP id l2so536534ybe.8;
        Fri, 04 Mar 2022 16:23:36 -0800 (PST)
X-Gm-Message-State: AOAM530s/Y7Z9x6qlff4RSS5uF6Mcl/TGdITkGY0ppghpcBf8ahkdZLP
        2UJ0B0kl3XJ3t3nGx51zPo98/Mho+jtzk4U85Tw=
X-Google-Smtp-Source: ABdhPJxKvkWE3NA74yGINk/xO5jvCCL0DMTS/uh1q2KYRGBuxnS3RoyTMxWDUovTCNYRc94qBeDKauaBBebuL5T2JFs=
X-Received: by 2002:a25:8b81:0:b0:629:17d5:68c1 with SMTP id
 j1-20020a258b81000000b0062917d568c1mr415320ybl.449.1646439815376; Fri, 04 Mar
 2022 16:23:35 -0800 (PST)
MIME-Version: 1.0
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com> <20220304172852.274126-4-benjamin.tissoires@redhat.com>
In-Reply-To: <20220304172852.274126-4-benjamin.tissoires@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 4 Mar 2022 16:23:24 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5UmK0TQwjR3_oXLeTix3HimnQdjRLattmM+3i8Y996yA@mail.gmail.com>
Message-ID: <CAPhsuW5UmK0TQwjR3_oXLeTix3HimnQdjRLattmM+3i8Y996yA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 03/28] HID: hook up with bpf
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
        Joe Stringer <joe@cilium.io>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 4, 2022 at 9:31 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> Now that BPF can be compatible with HID, add the capability into HID.
> drivers/hid/hid-bpf.c takes care of the glue between bpf and HID, and
> hid-core can then inject any incoming event from the device into a BPF
> program to filter/analyze it.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
[...]

> +
> +static int hid_bpf_link_attach(struct hid_device *hdev, enum bpf_hid_attach_type type)
> +{
> +       int err = 0;
> +
> +       switch (type) {
> +       case BPF_HID_ATTACH_DEVICE_EVENT:
> +               if (!hdev->bpf.ctx) {
> +                       hdev->bpf.ctx = bpf_hid_allocate_ctx(hdev, HID_BPF_MAX_BUFFER_SIZE);
> +                       if (IS_ERR(hdev->bpf.ctx)) {
> +                               err = PTR_ERR(hdev->bpf.ctx);
> +                               hdev->bpf.ctx = NULL;
> +                       }
> +               }
> +               break;
> +       default:
> +               /* do nothing */

Do we need to show warning and/or return EINVAL here?

> +       }
> +
> +       return err;
> +}
> +
> +static void hid_bpf_array_detached(struct hid_device *hdev, enum bpf_hid_attach_type type)
> +{
> +       switch (type) {
> +       case BPF_HID_ATTACH_DEVICE_EVENT:
> +               kfree(hdev->bpf.ctx);
> +               hdev->bpf.ctx = NULL;
> +               break;
> +       default:
> +               /* do nothing */

ditto

[...]
