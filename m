Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C833225E7
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 07:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhBWG2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 01:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbhBWG15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 01:27:57 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C8DC061574;
        Mon, 22 Feb 2021 22:27:10 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id 133so15409408ybd.5;
        Mon, 22 Feb 2021 22:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vQxt3vjl8hhFxj2yTwj5NJNMGpqNwFzQ1v6m9IqJp0s=;
        b=YI0KiehGH12KlkWqZ8mey70HYtMLjQqybYI4U1ocAdJ0v4LkFSNCNQVCQ/INfj8/tA
         WD5pX+9XAmFjtZpaASJi9dXKF0STcnUEq/Kbrp8jIbyzwGZf9SAB8SF0HpcN/GNsf64q
         Wwf0EGN3Xisgmj/s0XrtHrDX1zMvykX8sgl1yxO4E0MwmR3MIuBpeCeb3A9qfEIZoUk1
         ZZhEvDtQm7DPexeRrxkjq1MybIXLpsvnK8sxqNXU85JA3d9wm9MgW0o2qoxYZ8BYt4W9
         pSYuHhmj4ol7E1zjTuLslEWkwMkQxqawnJE2JWO5uXtjBvJacqCyZeasgM+dFg8rsiy2
         kscQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vQxt3vjl8hhFxj2yTwj5NJNMGpqNwFzQ1v6m9IqJp0s=;
        b=mqf6sg19G56dVzn/FeMnnx+3djrVQcUzVmBAxLqwdDT8c5Ivc/aatOiaxCpibD/vDH
         NDwdf9rXGgAWm52fDoYej3K6e1WT9bamrUnIPelCvfO5n5FtEFpS4SuyL38+sKSIlmHj
         PhN4ysiO2eTVKRDXdjmi1EoW/mkzEhJ3NC6t6jqo1kgI+pI4LIjSbfBQSZpdeZ0QFbFq
         /XkfAPckMFiHGxpyDUhCHfJ0+GFA/N52ohOBAV/ASWs2C8PvKK1/6WTg90Ble7SkUc/i
         V5gkBb+3IE9u01+7p5gZnQDe/eBNq3hieMm4X7IskBQsvPvIvOrYM5YTB9jHYHgGzRuf
         Yltg==
X-Gm-Message-State: AOAM531U3Qn7TTGRkbJ7uEfgdQnhof7OC/KW2W/wWsFP5WGfWTq4Njf5
        m4Jsv9BTNncRca/sh6joH4d9hZ/COeP+95BSb8k=
X-Google-Smtp-Source: ABdhPJzHfwyP5Xcy1Qd8kqDfOkpURPnavcDhNokcrTRaADoWVGgJGpB7bfHoIhdQ+PfWwu1lM03T6IRld2n4aF57rwo=
X-Received: by 2002:a25:abb2:: with SMTP id v47mr37383050ybi.425.1614061629789;
 Mon, 22 Feb 2021 22:27:09 -0800 (PST)
MIME-Version: 1.0
References: <20210223012014.2087583-1-songliubraving@fb.com> <20210223012014.2087583-6-songliubraving@fb.com>
In-Reply-To: <20210223012014.2087583-6-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Feb 2021 22:26:58 -0800
Message-ID: <CAEf4BzZ5r7OJyhzoOY=UZyf29GCfLodauNxZzfN+2OkOSxgBzw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 5/6] bpf: runqslower: prefer using local
 vmlimux to generate vmlinux.h
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Peter Ziljstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 5:24 PM Song Liu <songliubraving@fb.com> wrote:
>
> Update the Makefile to prefer using $(O)/mvlinux, $(KBUILD_OUTPUT)/vmlinux
> (for selftests) or ../../../vmlinux. These two files should have latest
> definitions for vmlinux.h.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/bpf/runqslower/Makefile | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
> index 9d9fb6209be1b..c96ba90c6f018 100644
> --- a/tools/bpf/runqslower/Makefile
> +++ b/tools/bpf/runqslower/Makefile
> @@ -16,7 +16,10 @@ CFLAGS := -g -Wall
>
>  # Try to detect best kernel BTF source
>  KERNEL_REL := $(shell uname -r)
> -VMLINUX_BTF_PATHS := /sys/kernel/btf/vmlinux /boot/vmlinux-$(KERNEL_REL)
> +VMLINUX_BTF_PATHS := $(if $(O),$(O)/vmlinux)           \
> +       $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux) \
> +       ../../../vmlinux /sys/kernel/btf/vmlinux        \
> +       /boot/vmlinux-$(KERNEL_REL)
>  VMLINUX_BTF_PATH := $(or $(VMLINUX_BTF),$(firstword                           \
>                                           $(wildcard $(VMLINUX_BTF_PATHS))))
>
> --
> 2.24.1
>
