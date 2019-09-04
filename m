Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1B3A7B8A
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 08:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbfIDGTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 02:19:41 -0400
Received: from conssluserg-04.nifty.com ([210.131.2.83]:55575 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfIDGTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 02:19:41 -0400
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id x846JWTl031934;
        Wed, 4 Sep 2019 15:19:32 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com x846JWTl031934
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1567577973;
        bh=KcfNyd0d6qNZe5po5Im8NYxMh43Vdsb11cvHEmcz+PU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NFYOBONJGnDm89krh6tmh/c8NV0RUljxr598tyzlAbpSSOaVDb87+GVW4MsSfaON6
         S4QKPqIosZT1KHKY8MdVlNwS55LxMR4DCI90fCS0H5aarqAFr0yAmBST3cp9kY9eHb
         Xa3g6vPXnjryY96J0APPuerVKK1/HpwmCHvAJteKQb6SkTfFVRmYe24DG5K3lyDNhN
         9/vTU0ppedz8raShu8Klo827RW2HKq98AZSReapijmt+7sXBRm9Pn4+aaCVYStEh88
         TCVcGZYg+2emGCBdK24mzGhgjQeWKeJUo3GSIb7h3f5Al12Na2feckj29W9/6+ScKH
         fZaxPHjZLqSaw==
X-Nifty-SrcIP: [209.85.222.46]
Received: by mail-ua1-f46.google.com with SMTP id w16so561374uap.9;
        Tue, 03 Sep 2019 23:19:32 -0700 (PDT)
X-Gm-Message-State: APjAAAVpRN4eZF+ZbilvY3pw16/WlpqiL48VzgqOeZc421+9uaaJV9Nd
        ej0kqy3jBnZ7+s6Yx53neFMs47WPFDdP5Vd6Sz0=
X-Google-Smtp-Source: APXvYqzoSSq06AWlxLOXNs6NXjP7RWzDcrzRDyOUl33juPGfn0YLfNVF/6LIYBBz8pfzQph1UskTHf1y0APVT0gkpOg=
X-Received: by 2002:ab0:32d8:: with SMTP id f24mr18756941uao.121.1567577971564;
 Tue, 03 Sep 2019 23:19:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190904160021.72d104f1@canb.auug.org.au>
In-Reply-To: <20190904160021.72d104f1@canb.auug.org.au>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Wed, 4 Sep 2019 15:18:55 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQEU6uu-Z=VeR2KNa8ezCLA7VHtpvM2tvAKsWtUTi6Eug@mail.gmail.com>
Message-ID: <CAK7LNAQEU6uu-Z=VeR2KNa8ezCLA7VHtpvM2tvAKsWtUTi6Eug@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 4, 2019 at 3:00 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> After merging the net-next tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
>
> scripts/link-vmlinux.sh: 74: Bad substitution
>
> Caused by commit
>
>   341dfcf8d78e ("btf: expose BTF info through sysfs")
>
> interacting with commit
>
>   1267f9d3047d ("kbuild: add $(BASH) to run scripts with bash-extension")
>
> from the kbuild tree.


I knew that they were using bash-extension
in the #!/bin/sh script.  :-D


In fact, I wrote my patch in order to break their code
and  make btf people realize that they were doing wrong.



> The change in the net-next tree turned link-vmlinux.sh into a bash script
> (I think).
>
> I have applied the following patch for today:


But, this is a temporary fix only for linux-next.

scripts/link-vmlinux.sh does not need to use the
bash-extension ${@:2} in the first place.

I hope btf people will write the correct code.

Thanks.




> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 4 Sep 2019 15:43:41 +1000
> Subject: [PATCH] link-vmlinux.sh is now a bash script
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  Makefile                | 4 ++--
>  scripts/link-vmlinux.sh | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index ac97fb282d99..523d12c5cebe 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1087,7 +1087,7 @@ ARCH_POSTLINK := $(wildcard $(srctree)/arch/$(SRCARCH)/Makefile.postlink)
>
>  # Final link of vmlinux with optional arch pass after final link
>  cmd_link-vmlinux =                                                 \
> -       $(CONFIG_SHELL) $< $(LD) $(KBUILD_LDFLAGS) $(LDFLAGS_vmlinux) ;    \
> +       $(BASH) $< $(LD) $(KBUILD_LDFLAGS) $(LDFLAGS_vmlinux) ;    \
>         $(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) $@, true)
>
>  vmlinux: scripts/link-vmlinux.sh autoksyms_recursive $(vmlinux-deps) FORCE
> @@ -1403,7 +1403,7 @@ clean: rm-files := $(CLEAN_FILES)
>  PHONY += archclean vmlinuxclean
>
>  vmlinuxclean:
> -       $(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
> +       $(Q)$(BASH) $(srctree)/scripts/link-vmlinux.sh clean
>         $(Q)$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) clean)
>
>  clean: archclean vmlinuxclean
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index f7edb75f9806..ea1f8673869d 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -1,4 +1,4 @@
> -#!/bin/sh
> +#!/bin/bash
>  # SPDX-License-Identifier: GPL-2.0
>  #
>  # link vmlinux
> --
> 2.23.0.rc1
>
> --
> Cheers,
> Stephen Rothwell



--
Best Regards
Masahiro Yamada
