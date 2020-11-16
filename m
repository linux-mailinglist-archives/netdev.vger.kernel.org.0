Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21BC02B546F
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730460AbgKPWfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:35:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbgKPWfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 17:35:52 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38E9C0613CF;
        Mon, 16 Nov 2020 14:35:51 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id i193so17149972yba.1;
        Mon, 16 Nov 2020 14:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jkHt9LMbYZ9ge4qTE4YzluKemOMBA6hYcogD0/VZWR4=;
        b=nv4q7iUd/a2wzWxDUubWGsLt6SOhLRp4uwFy3lPFcBz+Z2vNCSLkv1JJfeMNtUSNjw
         ftPcVUHjsZZkvhRm8KNiUHzkmArlo6ZkaBQK0ux1mkzKM2HeM44KRzoV062ORupMolyh
         JEqV9XYOxwp6UjTC833DB84pvAVZR1nVLWzHGmzgaN55/9x+nrUYEa5zJ1dbGow1hAVP
         laZcqqxYnqORkMM+gg+iE4q9ZqnWUj2FbSxTz8l5WeeNbxFZV39wsoWwlM/HIsjJ+oux
         qS8nxoc1CPdZoAaD3OYffcUp+TJhgvkWVgpyZNvlFCwPp9m/xD2dCxnQwa9sAFVewGh8
         fq1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jkHt9LMbYZ9ge4qTE4YzluKemOMBA6hYcogD0/VZWR4=;
        b=iavO/li4vz2hhP8PL2BLqCWGF1dIiwuiTZ0JuNNDHWzSN+CfJEdkqkQdXmI+aT7Xzi
         KnSD0loM6iHU1EToN8g0YtRFfWYONktvG5c5hImvSjT7GWqn3utvM4i54GMgdcr3/fpY
         4PZ0iEPNlDfv7T7M4xeRpdpEitpo6Q1iBQFdjjR+V7rHY2vv3cBxUI4ulOBsNpyCtv8F
         ztuDStTPXm21SkmwV9p9pNWe9a64i2Asi1frw5fn5oOh1Vtm6XoNXskm1ldDeESXNNyK
         qllqMjuDLhhgcolHIGs2B/Q5GHw+H6eY+QQ9PWTOUf2C1ryHluPG2vSkyXLCzVC8ulBN
         eqAQ==
X-Gm-Message-State: AOAM53300phtgN1JlKULGutE9+4PtJeNOSWSkXh7oKc8GE0nmG1C58K3
        FjSN3/W2DdGNNLqGKi+izRhHVIC0u+uTlMXGXns=
X-Google-Smtp-Source: ABdhPJwQ9EhZXihJyYjt8djyMH7UMJ6JH/J1r6f3euOtL9sdQST0RXVx8IMRTU+h3vTVdtZoNArPBNm53c9kmcXJwMk=
X-Received: by 2002:a25:7717:: with SMTP id s23mr26263356ybc.459.1605566151158;
 Mon, 16 Nov 2020 14:35:51 -0800 (PST)
MIME-Version: 1.0
References: <20201110011932.3201430-1-andrii@kernel.org> <20201110011932.3201430-4-andrii@kernel.org>
 <B51AA745-00B6-4F2A-A7F0-461E845C8414@fb.com> <SN6PR11MB2751CF60B28D5788B0C15B5AB5E30@SN6PR11MB2751.namprd11.prod.outlook.com>
 <CAEf4BzYSN+XnaA4V3jTLEmoUZO=Yxwp7OAwAY+HOvVEKT5kRFA@mail.gmail.com> <20201116132409.4a5b8e0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201116132409.4a5b8e0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Nov 2020 14:35:39 -0800
Message-ID: <CAEf4Bzbs086r+sChU6wd_aXQ9KyBnKTF76-ev_Y2BNigf1jKAg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 3/5] kbuild: build kernel module BTFs if BTF
 is enabled and pahole supports it
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Allan, Bruce W" <bruce.w.allan@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "Starovoitov, Alexei" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 1:24 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 16 Nov 2020 12:34:17 -0800 Andrii Nakryiko wrote:
> > > This change, commit 5f9ae91f7c0d ("kbuild: Build kernel module BTFs if BTF is enabled and pahole
> > > supports it") currently in net-next, linux-next, etc. breaks the use-case of compiling only a specific
> > > kernel module (both in-tree and out-of-tree, e.g. 'make M=drivers/net/ethernet/intel/ice') after
> > > first doing a 'make modules_prepare'.  Previously, that use-case would result in a warning noting
> > > "Symbol info of vmlinux is missing. Unresolved symbol check will be entirely skipped" but now it
> > > errors out after noting "No rule to make target 'vmlinux', needed by '<...>.ko'.  Stop."
> > >
> > > Is that intentional?
> >
> > I wasn't aware of such a use pattern, so definitely not intentional.
> > But vmlinux is absolutely necessary to generate the module BTF. So I'm
> > wondering what's the proper fix here? Leave it as is (that error
> > message is actually surprisingly descriptive, btw)? Force vmlinux
> > build? Or skip BTF generation for that module?
>
> For an external out-of-tree module there is no guarantee that vmlinux
> will even be on the system, no? So only the last option can work in
> that case.


Ok, how about something like the patch below. With that I seem to be
getting the desired behavior:

$ make clean
$ touch drivers/acpi/button.c
$ make M=drivers/acpi
make[1]: Entering directory `/data/users/andriin/linux-build/default-x86_64'
  CC [M]  drivers/acpi/button.o
  MODPOST drivers/acpi/Module.symvers
  LD [M]  drivers/acpi/button.ko
  BTF [M] drivers/acpi/button.ko
Skipping BTF generation for drivers/acpi/button.ko due to
unavailability of vmlinux
make[1]: Leaving directory `/data/users/andriin/linux-build/default-x86_64'
$ readelf -S ~/linux-build/default/drivers/acpi/button.ko | grep BTF -A1
... empty ...

Now with normal build:

$ make all
...
LD [M]  drivers/acpi/button.ko
BTF [M] drivers/acpi/button.ko
...
$ readelf -S ~/linux-build/default/drivers/acpi/button.ko | grep BTF -A1
  [60] .BTF              PROGBITS         0000000000000000  00029310
       000000000000ab3f  0000000000000000           0     0     1



diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index 02b892421f7a..d49ec001825d 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -38,7 +38,12 @@ quiet_cmd_ld_ko_o = LD [M]  $@
     $(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) $@, true)

 quiet_cmd_btf_ko = BTF [M] $@
-      cmd_btf_ko = LLVM_OBJCOPY=$(OBJCOPY) $(PAHOLE) -J --btf_base vmlinux $@
+      cmd_btf_ko =                             \
+    if [ -f vmlinux ]; then                        \
+        LLVM_OBJCOPY=$(OBJCOPY) $(PAHOLE) -J --btf_base vmlinux $@; \
+    else                                \
+        printf "Skipping BTF generation for %s due to unavailability
of vmlinux\n" $@ 1>&2; \
+    fi;

 # Same as newer-prereqs, but allows to exclude specified extra dependencies
 newer_prereqs_except = $(filter-out $(PHONY) $(1),$?)
@@ -49,7 +54,7 @@ if_changed_except = $(if $(call
newer_prereqs_except,$(2))$(cmd-check),      \
     printf '%s\n' 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd, @:)

 # Re-generate module BTFs if either module's .ko or vmlinux changed
-$(modules): %.ko: %.o %.mod.o scripts/module.lds vmlinux FORCE
+$(modules): %.ko: %.o %.mod.o scripts/module.lds $(if
$(KBUILD_BUILTIN),vmlinux) FORCE
     +$(call if_changed_except,ld_ko_o,vmlinux)
 ifdef CONFIG_DEBUG_INFO_BTF_MODULES
     +$(if $(newer-prereqs),$(call cmd,btf_ko))
