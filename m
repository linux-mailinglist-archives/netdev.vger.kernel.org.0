Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 961FC718CB
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 14:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389989AbfGWM7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 08:59:14 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:38324 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727219AbfGWM7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 08:59:13 -0400
Received: by mail-ot1-f66.google.com with SMTP id d17so43944182oth.5
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 05:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VMgHJ3oWUlg0dHXhzagtvE92NEvKZNlfguvZWEx6SHs=;
        b=UKp3SBNDb5+eCSWnQhvbiSWDAd0VQGB2B8bP8EZHonfn8F5Fypmg2WU7y4ZtKCnBbj
         ayrVT6jILYu8pykwLunmjlEdZszOmaKNfJHM0WMFt+IGCMLeKec+axxDo22+tY35cnsm
         SS4tg62cJSQ27i6fPAQkMPtHUcE/JCziCaqKg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VMgHJ3oWUlg0dHXhzagtvE92NEvKZNlfguvZWEx6SHs=;
        b=WVi4lSlMh6U+x+i+tcnChdMu2UW0t/0YYEzue3JT1sCYOt0iUMJy5YJykKeIMvUY3E
         tQY153wNh84XYikxkesGLafUzkLfXhLJWsyD2BZol9sVmHP5ISThtqjd/YomkXtabKit
         Dz99rokEnuwOycRZAexYK+wtgJ1PbOAhNZ1VIQgnI/1x+76OFvwr548BHN5pjqUUKok4
         8MC/J7/66d+G4KcmkFADSygIdHK6Z13i4/T3p/3bDoD2ZXf/pSZTT0OnKxUXJUqrlQao
         WNq3XN1XNL5zpdCgwhqc69H6/ExJ5flN8eiNbkHDnVv/aqhHHg9F0HdaTeNlc0KDDa9M
         dDzQ==
X-Gm-Message-State: APjAAAVA3UjLhX1sfDLWlJ3hHQoSblYip5PwtxdMgXHMY0lVtI9GTs1i
        xWVs2l8y0Z3Xn3JIjcR4bpK9MI6hDsUtqYudD4KUfA==
X-Google-Smtp-Source: APXvYqx0GhSzeUXzIwf0UC5sIirDdj7izv6T+TkQ8as0r38z0JNAVAX2UUwBVGX6uBBFJc4ys1CpTqjsHIqJKZly3mY=
X-Received: by 2002:a9d:28:: with SMTP id 37mr54454016ota.289.1563886752999;
 Tue, 23 Jul 2019 05:59:12 -0700 (PDT)
MIME-Version: 1.0
References: <CACAyw9-CWRHVH3TJ=Tke2x8YiLsH47sLCijdp=V+5M836R9aAA@mail.gmail.com>
 <20190718142041.83342-1-iii@linux.ibm.com>
In-Reply-To: <20190718142041.83342-1-iii@linux.ibm.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 23 Jul 2019 13:59:01 +0100
Message-ID: <CACAyw9-qZQ4Affu6w1VpyH0HjP9WBBuArdzW6Sdp9cNzWvjCsQ@mail.gmail.com>
Subject: Re: [PATCH bpf] tools/bpf: fix bpftool build with OUTPUT set
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ilya,

Thanks for your patch! I tried it but had problems with
cross-compilation. Not sure if this is related to the patch or not
though, I haven't had the time to follow up.

Best
Lorenz

On Thu, 18 Jul 2019 at 15:20, Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> Hi Lorenz,
>
> I've been using the following patch for quite some time now.
> Please let me know if it works for you.
>
> Best regards,
> Ilya
>
> ---
>
> When OUTPUT is set, bpftool and libbpf put their objects into the same
> directory, and since some of them have the same names, the collision
> happens.
>
> Fix by invoking libbpf build in a manner similar to $(call descend) -
> descend itself cannot be used, since libbpf is a sibling, and not a
> child, of bpftool.
>
> Also, don't link bpftool with libbpf.a twice.
>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---
>  tools/bpf/bpftool/Makefile | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
>
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index a7afea4dec47..2cbc3c166f44 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -15,23 +15,18 @@ else
>  endif
>
>  BPF_DIR = $(srctree)/tools/lib/bpf/
> -
> -ifneq ($(OUTPUT),)
> -  BPF_PATH = $(OUTPUT)
> -else
> -  BPF_PATH = $(BPF_DIR)
> -endif
> -
> -LIBBPF = $(BPF_PATH)libbpf.a
> +BPF_PATH = $(objtree)/tools/lib/bpf
> +LIBBPF = $(BPF_PATH)/libbpf.a
>
>  BPFTOOL_VERSION := $(shell make --no-print-directory -sC ../../.. kernelversion)
>
>  $(LIBBPF): FORCE
> -       $(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(OUTPUT) $(OUTPUT)libbpf.a
> +       $(Q)mkdir -p $(BPF_PATH)
> +       $(Q)$(MAKE) $(COMMAND_O) subdir=tools/lib/bpf -C $(BPF_DIR) $(LIBBPF)
>
>  $(LIBBPF)-clean:
>         $(call QUIET_CLEAN, libbpf)
> -       $(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(OUTPUT) clean >/dev/null
> +       $(Q)$(MAKE) $(COMMAND_O) subdir=tools/lib/bpf -C $(BPF_DIR) clean >/dev/null
>
>  prefix ?= /usr/local
>  bash_compdir ?= /usr/share/bash-completion/completions
> @@ -112,7 +107,7 @@ $(OUTPUT)disasm.o: $(srctree)/kernel/bpf/disasm.c
>         $(QUIET_CC)$(COMPILE.c) -MMD -o $@ $<
>
>  $(OUTPUT)bpftool: $(OBJS) $(LIBBPF)
> -       $(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)
> +       $(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)
>
>  $(OUTPUT)%.o: %.c
>         $(QUIET_CC)$(COMPILE.c) -MMD -o $@ $<
> --
> 2.21.0
>


-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
