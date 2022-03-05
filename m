Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1CD4CE16A
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 01:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiCEAVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 19:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiCEAVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 19:21:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C74255F90;
        Fri,  4 Mar 2022 16:21:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D24F561F08;
        Sat,  5 Mar 2022 00:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3966BC340F3;
        Sat,  5 Mar 2022 00:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646439659;
        bh=B1FjitSdpbaZU/Y+cqd+b/Ws5YFB8gaS+fSH+7oHtf8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AkPcC0ZwOkREUF8PF9uRiiiNHA7QlRzkeG0+/58FUt/Bs2Dg5/ng3PyE/ebAZzAoh
         9PImjDhdfeq08e/rLq7O5oqeEERvLuQPpgqGBG1O9d76r41yXyfD7BVhoow2GGRJhO
         xthX6t7t5FB1Z4QNxK9v3Q/VcGsUNvJSqZeA4cHbq0y6ti/4ze3gapr5dpGJFGCvDK
         tfXuXVAEIg1lF5WS3DiCChbKXHUoU8ImQOXdxGUAvugVErm/aN6NG4GEUUZjAtl0I9
         Kl3y5byOjiMbvzVoILroCewuKAVm4kTquniu5hsp1AeXhbjxFrwM7Y8Js5yLHKLZp6
         Ie0PtP5GTiT7Q==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-2d07ae0b1c4so108840637b3.11;
        Fri, 04 Mar 2022 16:20:59 -0800 (PST)
X-Gm-Message-State: AOAM533oI7XdvvTyJrqldg7ZOpv7BbwtrmPWLoKAWWa5ouC6HSbV45q6
        eAJfJYeO5GhI0KVgkntbiDI9T3hN0XpBaTKCC1o=
X-Google-Smtp-Source: ABdhPJwEKBwWWaOAF6bL3fC7cgLiukLooTdcPALz1Su1cbj0MLLRaEOXNuJuNIbTCI/mSEImg6jSKahuqZ3hLpS/aeQ=
X-Received: by 2002:a81:57d5:0:b0:2dc:62b3:1455 with SMTP id
 l204-20020a8157d5000000b002dc62b31455mr1007641ywb.73.1646439658179; Fri, 04
 Mar 2022 16:20:58 -0800 (PST)
MIME-Version: 1.0
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com> <20220304172852.274126-3-benjamin.tissoires@redhat.com>
In-Reply-To: <20220304172852.274126-3-benjamin.tissoires@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 4 Mar 2022 16:20:46 -0800
X-Gmail-Original-Message-ID: <CAPhsuW62DZzYb6RwDETNB7u2gMWw2GRwQ_60-363PSvHWEyhUA@mail.gmail.com>
Message-ID: <CAPhsuW62DZzYb6RwDETNB7u2gMWw2GRwQ_60-363PSvHWEyhUA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 02/28] bpf: introduce hid program type
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
[...]
> +#endif
> +
> +static inline bool bpf_hid_link_empty(struct bpf_hid *bpf,
> +                                     enum bpf_hid_attach_type type)
> +{
> +       return list_empty(&bpf->links[type]);
> +}
> +
> +struct bpf_hid_hooks {
> +       struct hid_device *(*hdev_from_fd)(int fd);
> +       int (*link_attach)(struct hid_device *hdev, enum bpf_hid_attach_type type);
> +       void (*array_detached)(struct hid_device *hdev, enum bpf_hid_attach_type type);

shall we call this array_detach()? detached sounds like a function that
checks the status of link/hook.

[...]

> --- /dev/null
> +++ b/kernel/bpf/hid.c
> @@ -0,0 +1,437 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * based on kernel/bpf/net-namespace.c
> + */

I guess we don't need this comment.

> +
> +#include <linux/bpf.h>
> +#include <linux/bpf-hid.h>
> +#include <linux/filter.h>
> +#include <linux/hid.h>
> +#include <linux/hidraw.h>
[...]
