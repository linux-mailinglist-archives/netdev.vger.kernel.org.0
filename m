Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF77E4D56F4
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 01:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343796AbiCKAvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 19:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235560AbiCKAvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 19:51:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FE12627;
        Thu, 10 Mar 2022 16:50:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50EB5B829A1;
        Fri, 11 Mar 2022 00:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0BD5C340EC;
        Fri, 11 Mar 2022 00:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646959820;
        bh=IO8rAexqJOVECI+Go6BBgSARYGGCV+CVeaztQWwxRWs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WyhnZrW4xMPh7AwOByOMM+BFl4aXfTzLqB1YRjo3juB+vJ2k0nsTR+azxWVU7tWFP
         R5d/R1PfsI0ypQg8RsUa5S7X58+Q4tGqnFYjDzJLAdgWcfUnpgw9JzNDObQdjY3e0u
         tyM8XFJT7sltSIoLtm44tGez9MYaI3UuRQRmdu36FUwmJH4K7aUh5Mw+45TDQDSXg+
         h9fK60U45QlYvW5TXmbUh8tAYLnN/MuJMWJ4k9s2/ibSVz79ejwiO+NTYRe/hYYSSw
         6kqcrxLV/D4pm5BCec7v6PDXaj833bN7NeZHRqBJdzVR4Xh2F6elhbSbBTedMNhoEB
         8LeeZ0VgGTNKA==
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-2dc348dab52so77794617b3.6;
        Thu, 10 Mar 2022 16:50:19 -0800 (PST)
X-Gm-Message-State: AOAM530vjtoHg0d4EG0Hh9DDd0FyJFd7D7tU4dLKnqs5qllkG58wuAt0
        6rq5XiY9yZoX2eDrNZk7+TCSqa8gLdbygdpEui4=
X-Google-Smtp-Source: ABdhPJzoUAI9PJqi0lG05QCYxnBzaDHn3B4mCOu0ZTWwZXE5qmKJNqr63ecOqNCkVfXgJ7Bl78VV6iZdL1hSLd6b4gk=
X-Received: by 2002:a0d:fb45:0:b0:2d0:d09a:576c with SMTP id
 l66-20020a0dfb45000000b002d0d09a576cmr6515180ywf.447.1646959819038; Thu, 10
 Mar 2022 16:50:19 -0800 (PST)
MIME-Version: 1.0
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com> <20220304172852.274126-20-benjamin.tissoires@redhat.com>
In-Reply-To: <20220304172852.274126-20-benjamin.tissoires@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 10 Mar 2022 16:50:07 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6Jd_A7J8QQTqDZt9hwcy_Cnqm=9-+9qQ6-KTkLRT8NAA@mail.gmail.com>
Message-ID: <CAPhsuW6Jd_A7J8QQTqDZt9hwcy_Cnqm=9-+9qQ6-KTkLRT8NAA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 19/28] bpf/hid: add bpf_hid_raw_request helper function
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
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 4, 2022 at 9:35 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> When we are in a user_event context, we can talk to the device to fetch
> or set features/outputs/inputs reports.
> Add a bpf helper to do so. This helper is thus only available to
> user_events, because calling this function while in IRQ context (any
> other BPF type) is forbidden.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---
>
> changes in v2:
> - split the series by bpf/libbpf/hid/selftests and samples
> ---
>  include/linux/bpf-hid.h        |  2 ++
>  include/uapi/linux/bpf.h       |  8 ++++++++
>  kernel/bpf/hid.c               | 26 ++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |  8 ++++++++
>  4 files changed, 44 insertions(+)
>
> diff --git a/include/linux/bpf-hid.h b/include/linux/bpf-hid.h
> index 4cf2e99109fe..bd548f6a4a26 100644
> --- a/include/linux/bpf-hid.h
> +++ b/include/linux/bpf-hid.h
> @@ -100,6 +100,8 @@ struct bpf_hid_hooks {
>                             u64 offset, u32 n, u8 *data, u64 data_size);
>         int (*hid_set_data)(struct hid_device *hdev, u8 *buf, size_t buf_size,
>                             u64 offset, u32 n, u8 *data, u64 data_size);
> +       int (*hid_raw_request)(struct hid_device *hdev, u8 *buf, size_t size,
> +                              u8 rtype, u8 reqtype);
>  };
>
>  #ifdef CONFIG_BPF
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index b3063384d380..417cf1c31579 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5121,6 +5121,13 @@ union bpf_attr {
>   *     Return
>   *             The length of data copied into ctx->event.data. On error, a negative
>   *             value is returned.
> + *
> + * int bpf_hid_raw_request(void *ctx, void *buf, u64 size, u8 rtype, u8 reqtype)
> + *     Description
> + *             communicate with the HID device

I think we need more description here, e.g. what are rtype and reqtype here?


> + *     Return
> + *             0 on success.
> + *             negative value on error.
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -5317,6 +5324,7 @@ union bpf_attr {
>         FN(copy_from_user_task),        \
>         FN(hid_get_data),               \
>         FN(hid_set_data),               \
> +       FN(hid_raw_request),            \
>         /* */
[...]
