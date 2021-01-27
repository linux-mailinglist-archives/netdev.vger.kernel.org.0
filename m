Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806633065F0
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 22:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbhA0VZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 16:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234125AbhA0VXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 16:23:35 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F20C061573;
        Wed, 27 Jan 2021 13:22:55 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id e206so3402161ybh.13;
        Wed, 27 Jan 2021 13:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xywJGgIcTxVvkZqtRxr3IHcoZ/CsjmP0+9gMWTEp1ss=;
        b=qkIGz0z4s8W1yAlglSlVW5Wf9AcYrGbrId2zsbWQuIFE15O4ID1t2iJ5IpT0G+UStb
         1rGK/eYmNQb89aXH0wMS6GHIxwYAGeijl+ffXCu/eSpiBVstK9dfuHBV7Ghw3bh/CCWC
         3IDuvCeTZ3aA4wEU9PKoj0D88eV1OLshk3K+93x9+au1AsLucXZO9khSMeM5BD+J4fiq
         mF3RHQ6NIncGQS8T0l3d/22XTFU97lKSxN4MxutPYHky7NrR2G8U7J9eDBAc1iT4KYfK
         hACFCCZJoqNrtZZiwX63q0xBl94WzBxov31w3f0a4Yy0QoXb8XvuKSP934vahqEoDayD
         p8/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xywJGgIcTxVvkZqtRxr3IHcoZ/CsjmP0+9gMWTEp1ss=;
        b=bqyCqa4C6fTtrlL7T1EsjxeSvqxpBi7OvAufeexHFrxX22jVk+CEBtfP20i4MsraVK
         zDTyP9+6tkl9WCJmZ0TSxPYEVxyjM2NHJ1G9Z+E5Y9Pqy5Ta65oEaWOTi6kBrgmKjiDa
         6SdU2eojHxBwlVjyCRycq9l+VEMpfm8lRMY0AeNxeN11JDE3QJlwq7igPJ+xGLbKgt8D
         7ZQwLRJPRVzMS6cmJOJt05UEkCnlWZvd/fyxlcM4ydFI5LilgPL9aT4G2pPHcS4rw8Hk
         mTq7aAkjFx9vpJApRtOswL1hCLawQPyrmpgK6Co6U3c3T4QIkfOjjwZ8WdQ7rBhQ3f3y
         8Y0Q==
X-Gm-Message-State: AOAM5334ZIV0QA/rTCXk3aSSwVnQubbr0NTNDRJO3kLz1qoGEd03+QYZ
        SrduPCNOFEecjDp4WvwGG5y9Pr/2jvSAtfE/HTc=
X-Google-Smtp-Source: ABdhPJzQr7gmXf0Yc6+bZmv6GEGsqchOR9l8EpglGdDc5IAwHjjIzxSFAia0eYJTZ8NGmScO44MbWCbgGj9ME7OgrYo=
X-Received: by 2002:a25:1287:: with SMTP id 129mr18349652ybs.27.1611782574731;
 Wed, 27 Jan 2021 13:22:54 -0800 (PST)
MIME-Version: 1.0
References: <20210126085923.469759-1-songliubraving@fb.com> <20210126085923.469759-4-songliubraving@fb.com>
In-Reply-To: <20210126085923.469759-4-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Jan 2021 13:22:44 -0800
Message-ID: <CAEf4BzYgs3bYxdQT724k8a9daP+tKoyf63EgNRwH5cgtvzKwUA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/4] bpf: runqslower: prefer use local
 KBUILD_OUTPUT/vmlinux or vmlinux
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Ziljstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 1:11 AM Song Liu <songliubraving@fb.com> wrote:
>
> Update the Makefile to prefer using KBUILD_OUTPUT/vmlinux (for selftests)
> or ../../../vmlinux. These two files should have latest definitions for
> vmlinux.h.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  tools/bpf/runqslower/Makefile | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
> index 4d5ca54fcd4c8..1f75c95d4d023 100644
> --- a/tools/bpf/runqslower/Makefile
> +++ b/tools/bpf/runqslower/Makefile
> @@ -19,7 +19,9 @@ CFLAGS := -g -Wall
>
>  # Try to detect best kernel BTF source
>  KERNEL_REL := $(shell uname -r)
> -VMLINUX_BTF_PATHS := /sys/kernel/btf/vmlinux /boot/vmlinux-$(KERNEL_REL)
> +VMLINUX_BTF_PATHS := $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux) \

O= overrides KBUILD_OUTPUT=, so please handle it first. See
selftests/bpf/Makefile.

> +       ../../../vmlinux /sys/kernel/btf/vmlinux \
> +       /boot/vmlinux-$(KERNEL_REL)
>  VMLINUX_BTF_PATH := $(or $(VMLINUX_BTF),$(firstword                           \
>                                           $(wildcard $(VMLINUX_BTF_PATHS))))
>
> --
> 2.24.1
>
