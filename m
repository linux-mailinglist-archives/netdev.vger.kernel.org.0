Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71A04C7358
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 18:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238168AbiB1Rei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 12:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238876AbiB1Rd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 12:33:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7D86B939A0
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 09:30:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646069435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TBNyyVKFIgtXo2siONgO+K8rh6ETB7+JIbrxg9YBDkY=;
        b=dxmv+EPOAJtpsV05KeDa4kwGDclYDEktu5xj+o4QEX4EaN47oDq/P5fgf3u5jFa4JEKC21
        Ir0SxVAZgyfFWZyrXkojqTXKWCV/ZpnMre/D5LnkW0xvbX26PXU4+Nvi/Y9YnFEo5xcoLa
        XF3+VyY5BatXoU3Oao9hKcc1bjKUkU0=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-wNwbdOulPBi8PUcY3Dquaw-1; Mon, 28 Feb 2022 12:30:31 -0500
X-MC-Unique: wNwbdOulPBi8PUcY3Dquaw-1
Received: by mail-pg1-f200.google.com with SMTP id j29-20020a634a5d000000b00376a7b5602dso5347119pgl.4
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 09:30:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TBNyyVKFIgtXo2siONgO+K8rh6ETB7+JIbrxg9YBDkY=;
        b=Mo2pcfyaRAEpOHS/eNAdR/beCqHH+xog6uf8PeLhLaM7w/kxkdicmatqLxFFp4JQ52
         I+yC4/iRH6OZesDpj+mLmXqgCBvCk0swv6rgn96arLJxj1dwRJXEHENjex7tSOzVWYcx
         wbvh6DPAlIP08nTbmtWT55C4Fkseg2cpnCaAdgJQA1+XpXG0YH5D5odKYLUCxmGK3PsW
         Bv4KNn06HpjPaT2v/ceNKCiSTHULIOeSXDnONyafyvZ3XJVFeWuo7Bnz/VpSUGbxa76R
         25CbBY517sYm1KyHq1HG0yOGUdpSgElEqptx+oRfTnhpAJSOQMWaRYsWC61ITko3DzvF
         zaHQ==
X-Gm-Message-State: AOAM532fKrRsmllHWmB2BskUTMMWnn+MGeZmRmZxDRdMu2olnLqMBFWc
        Bh1DaLwRqcvRR3HE8uRtuV+IJu2L0otTTNGgS2FgZcukQ80E7W4GrhxPzl+G/XNu0gYFi3sxSh/
        WhUij53BHK6awE2DOuUYpvxmyAfTjMCZf
X-Received: by 2002:a17:90a:560a:b0:1bc:72e7:3c13 with SMTP id r10-20020a17090a560a00b001bc72e73c13mr17481033pjf.246.1646069430727;
        Mon, 28 Feb 2022 09:30:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw1v8+Lu0rP+9NAXHotlnTBxz36fDCgljyirfY6qlP//hmJIiUmPdBMWOJ0HtOZuZM/abGbibrD7d754N3pyLA=
X-Received: by 2002:a17:90a:560a:b0:1bc:72e7:3c13 with SMTP id
 r10-20020a17090a560a00b001bc72e73c13mr17481014pjf.246.1646069430520; Mon, 28
 Feb 2022 09:30:30 -0800 (PST)
MIME-Version: 1.0
References: <20220224110828.2168231-1-benjamin.tissoires@redhat.com>
 <20220224110828.2168231-2-benjamin.tissoires@redhat.com> <YhdtKN7qodX7VDPV@kroah.com>
In-Reply-To: <YhdtKN7qodX7VDPV@kroah.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Mon, 28 Feb 2022 18:30:19 +0100
Message-ID: <CAO-hwJL73en_7thxM6Xt-RC2kqp=D8oyWuU_EL60hCsFCYPrsg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 1/6] HID: initial BPF implementation
To:     Greg KH <greg@kroah.com>
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
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 12:41 PM Greg KH <greg@kroah.com> wrote:
>
> On Thu, Feb 24, 2022 at 12:08:23PM +0100, Benjamin Tissoires wrote:
> > index 000000000000..243ac45a253f
> > --- /dev/null
> > +++ b/include/uapi/linux/bpf_hid.h
> > @@ -0,0 +1,39 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later WITH Linux-syscall-note */
> > +
> > +/*
> > + *  HID BPF public headers
> > + *
> > + *  Copyright (c) 2021 Benjamin Tissoires
> > + */
> > +
> > +#ifndef _UAPI__LINUX_BPF_HID_H__
> > +#define _UAPI__LINUX_BPF_HID_H__
> > +
> > +#include <linux/types.h>
> > +
> > +#define HID_BPF_MAX_BUFFER_SIZE              16384           /* 16kb */
> > +
> > +struct hid_device;
> > +
> > +enum hid_bpf_event {
> > +     HID_BPF_UNDEF = 0,
> > +     HID_BPF_DEVICE_EVENT,
> > +};
> > +
> > +/* type is HID_BPF_DEVICE_EVENT */
> > +struct hid_bpf_ctx_device_event {
> > +     __u8 data[HID_BPF_MAX_BUFFER_SIZE];
> > +     unsigned long size;
>
> That's not a valid type to cross the user/kernel boundry, shouldn't it
> be "__u64"?  But really, isn't __u32 enough here?

Fixed locally with a __u16 instead. Will be present in v2.

Cheers,
Benjamin

