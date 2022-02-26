Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F8C4C5460
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 08:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiBZH0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 02:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiBZHZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 02:25:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A1D28E20;
        Fri, 25 Feb 2022 23:25:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2D8260E92;
        Sat, 26 Feb 2022 07:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4499BC340E8;
        Sat, 26 Feb 2022 07:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645860325;
        bh=7Iwbbh2kgpifHB0Q/0bsXLw+x6HHzHpfdsbkd0Huexs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gCgdGwRtwVyHZuBlTLpCGWUBjiK9K74mQKUg6qGEW9GQX0EWSaMqKbBKeqK1NNJ0R
         sFpgHk+vjolUOXuYNdWXUQIdnruLl2+bUutzJi1+t567V2CW/ORshry1yfXqBNSZ+s
         1aSFxqYluV2IynT5WpB5Pg48eUK2vQxbS5KaW5C9f4ZiucNZxzqCOAbo6iz2RF4nw2
         2HSO2e5iDhU4pWnNOv4iv5Slw39LN4dtuwgJ3TMnVg0A4KsBshwYukqYGjtNZLWTwh
         spCecjD0WhcH7ju1Lw9qz6IkT+FJ4IG9gJ8bBIY6VW8YYi5DITX/otqiQGCB0Um6U5
         Rxe4730uN39SA==
Received: by mail-yb1-f173.google.com with SMTP id w63so10142863ybe.10;
        Fri, 25 Feb 2022 23:25:25 -0800 (PST)
X-Gm-Message-State: AOAM531wMvIBgDKlfW4dMtFWT3aPjpJLUsqBJWu91TT/IM0A0g1B7iRe
        674wCRjOUMy/MlVYoZNNYwYteD635PuXnYoFgAA=
X-Google-Smtp-Source: ABdhPJxMkP9CP4xO3yaRfTliCI3OPA5jSWLXhFbpX1hH1vIgXH7hpCbNdnbf+waXj+CbPFaujtTfnwl8QVR4opEGrp4=
X-Received: by 2002:a25:da87:0:b0:611:aa55:c37c with SMTP id
 n129-20020a25da87000000b00611aa55c37cmr10431925ybf.9.1645860324334; Fri, 25
 Feb 2022 23:25:24 -0800 (PST)
MIME-Version: 1.0
References: <20220224110828.2168231-1-benjamin.tissoires@redhat.com> <20220224110828.2168231-3-benjamin.tissoires@redhat.com>
In-Reply-To: <20220224110828.2168231-3-benjamin.tissoires@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 25 Feb 2022 23:25:13 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6m-HpfKLke1b7ni1j5Je3b3J0fa+MfJNnq2C9baOry1A@mail.gmail.com>
Message-ID: <CAPhsuW6m-HpfKLke1b7ni1j5Je3b3J0fa+MfJNnq2C9baOry1A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 2/6] HID: bpf: allow to change the report
 descriptor from an eBPF program
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
> The report descriptor is the dictionary of the HID protocol specific
> to the given device.
> Changing it is a common habit in the HID world, and making that feature
> accessible from eBPF allows to fix devices without having to install a
> new kernel.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

[...]

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
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 5978b92cacd3..a7a8d9cfcf24 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -999,6 +999,7 @@ enum bpf_attach_type {
>         BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
>         BPF_PERF_EVENT,
>         BPF_HID_DEVICE_EVENT,
> +       BPF_HID_RDESC_FIXUP,
>         __MAX_BPF_ATTACH_TYPE
>  };
>
> diff --git a/include/uapi/linux/bpf_hid.h b/include/uapi/linux/bpf_hid.h
> index 243ac45a253f..c0801d7174c3 100644
> --- a/include/uapi/linux/bpf_hid.h
> +++ b/include/uapi/linux/bpf_hid.h
> @@ -18,6 +18,7 @@ struct hid_device;
>  enum hid_bpf_event {
>         HID_BPF_UNDEF = 0,
>         HID_BPF_DEVICE_EVENT,
> +       HID_BPF_RDESC_FIXUP,
>  };
>
>  /* type is HID_BPF_DEVICE_EVENT */
> @@ -26,12 +27,19 @@ struct hid_bpf_ctx_device_event {
>         unsigned long size;
>  };
>
> +/* type is HID_BPF_RDESC_FIXUP */
> +struct hid_bpf_ctx_rdesc_fixup {
> +       __u8 data[HID_BPF_MAX_BUFFER_SIZE];
> +       unsigned long size;
> +};

This looks same as HID_BPF_DEVICE_EVENT, do we really need to
separate the two?

Thanks,
Song
