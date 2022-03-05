Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3124CE150
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 01:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiCEADy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 19:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiCEADx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 19:03:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA971FA1C5;
        Fri,  4 Mar 2022 16:03:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF05FB82C77;
        Sat,  5 Mar 2022 00:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461F5C340E9;
        Sat,  5 Mar 2022 00:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646438581;
        bh=HkQ4qKe5yFev3q2U/3+9s4iDlAiLS8y6DXp1GDO1UtQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LP+SM2taO+rPs4vmzpYIxIk58rHQ5CsAq0GDiYcja/rNgS74SUtbCyii3pngvVRvU
         Bhj8nszROutnhmR3kkF6jHoimCEG1j7xv2TgPTKPLurLSxyVUS8uraZUxixZ6J3KGt
         1QFXCSbB+Ai/6A3TkxdPCneLdaTnIDx7skKRJmy/F5ClgnEHzPXRUae/4q9HcYmZ2O
         rrUqdjuUuejc7bwaY7RaAObZWCRsHIsdnWNlVucn5hnq0KiLke+iYHxq6UCDGRORdZ
         9ZTc+zIGLleAclobsmAmMsRBog98Edls8noBeJCw/q0uuwErkU26EkriyLqHSv3i/5
         BbHf0HT3g4LHA==
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-2dc0364d2ceso108898417b3.7;
        Fri, 04 Mar 2022 16:03:01 -0800 (PST)
X-Gm-Message-State: AOAM531qpEVi2knn610Vizqkoxu99XEeOUvezOcdge5ssoGK4OJWw3nj
        ABZTjliRqK6+kkuuCBLyHLQDtjfhFdafh1NXw0E=
X-Google-Smtp-Source: ABdhPJzqy9U4NMVkCiJSdrG4jE3r+07o5tK+2YmcaQ58sGinDLQEh5daP1Ce1ujhZvoysk50PZ14aLNbDE6nXFJOBgA=
X-Received: by 2002:a81:10cc:0:b0:2dc:24f7:7dd3 with SMTP id
 195-20020a8110cc000000b002dc24f77dd3mr1020905ywq.460.1646438580349; Fri, 04
 Mar 2022 16:03:00 -0800 (PST)
MIME-Version: 1.0
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com> <20220304172852.274126-3-benjamin.tissoires@redhat.com>
In-Reply-To: <20220304172852.274126-3-benjamin.tissoires@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 4 Mar 2022 16:02:49 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5CYF9isR4ffRdm3xA_n_FBoL+AGFkzNn4dn2LgRaQQkg@mail.gmail.com>
Message-ID: <CAPhsuW5CYF9isR4ffRdm3xA_n_FBoL+AGFkzNn4dn2LgRaQQkg@mail.gmail.com>
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
> HID is a protocol that could benefit from using BPF too.

[...]

> +#include <linux/list.h>
> +#include <linux/slab.h>
> +
> +struct bpf_prog;
> +struct bpf_prog_array;
> +struct hid_device;
> +
> +enum bpf_hid_attach_type {
> +       BPF_HID_ATTACH_INVALID = -1,
> +       BPF_HID_ATTACH_DEVICE_EVENT = 0,
> +       MAX_BPF_HID_ATTACH_TYPE

Is it typical to have different BPF programs for different attach types?
Otherwise, (different types may have similar BPF programs), maybe
we can pass type as an argument to the program (shared among
different types)?

[...]

> +struct hid_device;
> +
> +enum hid_bpf_event {
> +       HID_BPF_UNDEF = 0,
> +       HID_BPF_DEVICE_EVENT,           /* when attach type is BPF_HID_DEVICE_EVENT */
> +};
> +
> +struct hid_bpf_ctx {
> +       enum hid_bpf_event type;        /* read-only */
> +       __u16 allocated_size;           /* the allocated size of data below (RO) */

There is a (6-byte?) hole here.

> +       struct hid_device *hdev;        /* read-only */
> +
> +       __u16 size;                     /* used size in data (RW) */
> +       __u8 data[];                    /* data buffer (RW) */
> +};

Do we really need hit_bpf_ctx in uapi? Maybe we can just use it
from vmlinuxh?

[...]

> +
> +static bool hid_is_valid_access(int off, int size,
> +                               enum bpf_access_type access_type,
> +                               const struct bpf_prog *prog,
> +                               struct bpf_insn_access_aux *info)
> +{
> +       /* everything not in ctx is prohibited */
> +       if (off < 0 || off + size > sizeof(struct hid_bpf_ctx) + HID_BPF_MIN_BUFFER_SIZE)
> +               return false;

Mabe add the following here to fail unaligned accesses

        if (off % size != 0)
                return false;
[...]
