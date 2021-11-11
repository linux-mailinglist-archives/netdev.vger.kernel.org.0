Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A99444DBE8
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 19:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbhKKTCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 14:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbhKKTCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 14:02:21 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F52CC061766;
        Thu, 11 Nov 2021 10:59:32 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id j75so17478760ybj.6;
        Thu, 11 Nov 2021 10:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hk/jkCF3NnmetG2VnhLTRlUShF6p+8d6T3wHQ5hjpWA=;
        b=PnOWwjGfij1P4RDR2xksGVWXWmS0CCCuAHF4MZl7ZobmlFhE2R5xVx6pkDaW8tBwSq
         OSZrPWPCqqJ8IGlWALXrOKCeFJKpkzJbfEij5kqtysauvuLwKLwilSpOcg4tQCFdMaug
         Qx2M7+uLAz1fNLh+46WYT8C5JD2gptNm31Auon2CdRyCCFpf+W5kYPkGV+hklmlM1b4d
         e2bbI7XA3Zu/gMutlNOSkqhT+sRoS/ctdCPNfJCAhUvwzy4yKbVTAaqQ6VZq1gzb3sAh
         9ozgW1Sdq6UHycg0zdCecxRN7/yaN3G74wEjhHPx9bwWhCOJZNmb3GbZstv+XFIQKqEG
         SuJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hk/jkCF3NnmetG2VnhLTRlUShF6p+8d6T3wHQ5hjpWA=;
        b=jEHrtUnR/eYEhIdKytXCF0Yq6r8dQvHvWUOr8Mph9fFOrTYZtMZnpo/drpzKCTIBqZ
         Kcl4reH7x1lWtGn/4bjiPZwI+W7tfC+lCvy5y0BOiz2VyqPOZimpN8F1ceqbYCaNKS8M
         Ep0qrW2batpUS1ZQy5oVcFxwi4guvIwp9+cfsgaQ9f1ZXN7DeyOHOcJZ3QAP2Jry7AnV
         9zOTzgi2phSh0+Eb0CpypkqyRrzssgUui+7Y3hnFlrGJjX27y6HQBPNt48OUbsi0STcn
         6BVC2DnvcYFUCGB7d5rLefnyeXF1Yng36xw/4t9bCkzOFWIe2URhwy2dO0JpP0urVJkZ
         yVwg==
X-Gm-Message-State: AOAM532o67CaK516lHVX4vyNDwlTX5ODIBKoWGZp4xyqrWOKfv/JMQIx
        I2jNy2B3+DqW5lBjy7h4ZNxWL9vCKtGuO6fOz+E=
X-Google-Smtp-Source: ABdhPJyUl2ioPOpq9RUHCkikL4QZw2KPE01/wsZYcwtjyVxHVsF0ngroqvhhU8PbK8/caP011PqAmTNZmOCop5gy0sE=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr10686409ybj.504.1636657171758;
 Thu, 11 Nov 2021 10:59:31 -0800 (PST)
MIME-Version: 1.0
References: <20211110114632.24537-1-quentin@isovalent.com> <20211110114632.24537-4-quentin@isovalent.com>
In-Reply-To: <20211110114632.24537-4-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 11 Nov 2021 10:59:20 -0800
Message-ID: <CAEf4BzbtC8S_j7oZP9vqK+FwoSvBmt8Hp4_ZyzbwUifg8JfUUA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/6] bpftool: Use $(OUTPUT) and not $(O) for
 VMLINUX_BTF_PATHS in Makefile
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 3:46 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> The Makefile for bpftool relies on $(OUTPUT), and not on $(O), for
> passing the output directory. So $(VMLINUX_BTF_PATHS), used for
> searching for kernel BTF info, should use the same variable.
>
> Fixes: 05aca6da3b5a ("tools/bpftool: Generalize BPF skeleton support and generate vmlinux.h")
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/bpftool/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index 2a846cb92120..40abf50b59d4 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -150,7 +150,7 @@ $(BOOTSTRAP_OBJS): $(LIBBPF_BOOTSTRAP)
>  OBJS = $(patsubst %.c,$(OUTPUT)%.o,$(SRCS)) $(OUTPUT)disasm.o
>  $(OBJS): $(LIBBPF) $(LIBBPF_INTERNAL_HDRS)
>
> -VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)                           \
> +VMLINUX_BTF_PATHS ?= $(if $(OUTPUT),$(OUTPUT)/vmlinux)                 \
>                      $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)    \

But you still check KBUILD_OUTPUT? O overrides KBUILD_OUTPUT as far as
kernel build goes. So if you still support KBUILD_OUTPUT, you should
support O. And the $(OUTPUT) seems to be completely unrelated, as that
defines the output of bpftool build files, not the vmlinux image. Or
am I missing something?

>                      ../../../vmlinux                                   \
>                      /sys/kernel/btf/vmlinux                            \
> --
> 2.32.0
>
