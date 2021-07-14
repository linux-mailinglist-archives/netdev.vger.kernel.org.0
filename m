Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9EC3C864C
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 16:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239494AbhGNOrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 10:47:11 -0400
Received: from mail-vs1-f49.google.com ([209.85.217.49]:33488 "EHLO
        mail-vs1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbhGNOrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 10:47:10 -0400
Received: by mail-vs1-f49.google.com with SMTP id j8so1131366vsd.0;
        Wed, 14 Jul 2021 07:44:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0AK4IWMPZivSss56HDU1sJl/SWfYmT+xP3wCgy5bOzE=;
        b=nAetLVf0ltaACsif5FLoxqqENn95kAiHwJx9+ktR6uFNe/ARjVgM5c4WVnTujx64f8
         pKJDfu7MfqXRNe3E9rwlhxSDg/xWd/6Z/iF+oz66bck2J5mnol5zJTeCLY2atYnVb4Q9
         UgIwvW+kw1TWjfRUxj5CT4lpf57FOzhRhIcZqS4fL4BmQt8Ug2Re8kpx/gO+WkUJY5Ez
         ZucwzIZ6vbCby1MPX8kL8ImHErceJJmysPrSPFK7cYhfvbA++bwQeq/4dqSsFpknPGKs
         JxKfD/0IznM60PD1nqfTkkibBIoNqALSlNkSFZ23VWYuvuDx572oaoCO+uQT4x5Mnv/8
         4Vnw==
X-Gm-Message-State: AOAM533RaDdjYox7jcJOdcnni88anKExiFIlRzi/UBu7PsAgM4b00+d2
        y5C7BIbQYD7MDNAtbu8GnnssfM8nH1iRMBEA77HfHOrAY1bdCw==
X-Google-Smtp-Source: ABdhPJzO7ea/93MKk1mguNlLtQP8+Dk3hK7wTMIvOdXsCZms2gOrY6R4Mlyh7S+xBHzJd1yp5bpxzFpvAhS5zZCgL74=
X-Received: by 2002:a67:3c2:: with SMTP id 185mr14479038vsd.42.1626273857075;
 Wed, 14 Jul 2021 07:44:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210714143239.2529044-1-geert@linux-m68k.org>
In-Reply-To: <20210714143239.2529044-1-geert@linux-m68k.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 14 Jul 2021 16:44:05 +0200
Message-ID: <CAMuHMdWv8-6fBDLb8cFvvLxsb7RkEVkLNUBeCm-9yN9_iJkg-g@mail.gmail.com>
Subject: Re: Build regressions/improvements in v5.14-rc1
To:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     Marco Elver <elver@google.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        linux-um <linux-um@lists.infradead.org>,
        scsi <linux-scsi@vger.kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 4:35 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Below is the list of build error/warning regressions/improvements in
> v5.14-rc1[1] compared to v5.13+[2].
>
> Summarized:
>   - build errors: +24/-4
>   - build warnings: +71/-65
>
> Happy fixing! ;-)
>
> Thanks to the linux-next team for providing the build service.
>
> [1] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/e73f0f0ee7541171d89f2e2491130c7771ba58d3/ (all 189 configs)
> [2] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/66d9282523b3228183b14d9f812872dd2620704d/ (all 189 configs)
>
>
> *** ERRORS ***
>
> 24 error regressions:

  + /kisskb/src/drivers/dma/idxd/init.c: error: implicit declaration
of function 'cpu_feature_enabled'
[-Werror=implicit-function-declaration]:  => 805:7
  + /kisskb/src/drivers/dma/idxd/perfmon.h: error: 'struct perf_event'
has no member named 'pmu':  => 24:13, 35:13
  + /kisskb/src/drivers/dma/ioat/dca.c: error: implicit declaration of
function 'boot_cpu_has' [-Werror=implicit-function-declaration]:  =>
74:6
  + /kisskb/src/drivers/dma/ioat/dca.c: error: implicit declaration of
function 'cpuid_eax' [-Werror=implicit-function-declaration]:  =>
64:18
  + /kisskb/src/drivers/dma/ioat/dca.c: error: implicit declaration of
function 'cpuid_ebx' [-Werror=implicit-function-declaration]:  =>
17:31
  + /kisskb/src/drivers/pci/controller/vmd.c: error:
'X86_MSI_BASE_ADDRESS_HIGH' undeclared (first use in this function):
=> 150:20
  + /kisskb/src/drivers/pci/controller/vmd.c: error:
'X86_MSI_BASE_ADDRESS_LOW' undeclared (first use in this function):
=> 151:35
  + /kisskb/src/drivers/pci/controller/vmd.c: error:
'arch_msi_msg_addr_lo_t {aka struct arch_msi_msg_addr_lo}' has no
member named 'base_address':  => 151:19
  + /kisskb/src/drivers/pci/controller/vmd.c: error:
'arch_msi_msg_addr_lo_t {aka struct arch_msi_msg_addr_lo}' has no
member named 'destid_0_7':  => 152:19
  + /kisskb/src/drivers/pci/controller/vmd.c: error: control reaches
end of non-void function [-Werror=return-type]:  => 127:1
  + /kisskb/src/drivers/pci/controller/vmd.c: error: dereferencing
pointer to incomplete type 'struct pci_sysdata':  => 700:4
  + /kisskb/src/drivers/pci/controller/vmd.c: error: field 'sysdata'
has incomplete type:  => 116:21

um-x86_64/um-all{mod,yes}config

  + /kisskb/src/drivers/scsi/arm/fas216.c: error: 'GOOD' undeclared
(first use in this function):  => 2013:47

arm-gcc4.9/rpc_defconfig

  + /kisskb/src/drivers/tty/synclink_gt.c: error: conflicting types
for 'set_signals':  => 442:13

um-x86_64/um-allmodconfig

  + /kisskb/src/include/linux/compiler_attributes.h: error:
"__GCC4_has_attribute___no_sanitize_coverage__" is not defined
[-Werror=undef]:  => 29:29

mips-gcc4.9/mips-allmodconfig
s390x-gcc4.9/s390-allyesconfig

  + /kisskb/src/include/linux/compiler_types.h: error: call to
'__compiletime_assert_1857' declared with attribute error: FIELD_PREP:
value too large for the field:  => 328:38
  + /kisskb/src/include/linux/compiler_types.h: error: call to
'__compiletime_assert_1864' declared with attribute error: FIELD_PREP:
value too large for the field:  => 328:38

arm64-gcc5.4/arm64-allmodconfig
arm64-gcc8/arm64-allmodconfig

  + /kisskb/src/include/linux/compiler_types.h: error: call to
'__compiletime_assert_399' declared with attribute error: Unsupported
width, must be <= 40:  => 328:38
  + /kisskb/src/include/linux/compiler_types.h: error: call to
'__compiletime_assert_417' declared with attribute error: Unsupported
width, must be <= 40:  => 328:38
  + /kisskb/src/include/linux/compiler_types.h: error: call to
'__compiletime_assert_418' declared with attribute error: Unsupported
width, must be <= 40:  => 328:38
  + /kisskb/src/include/linux/compiler_types.h: error: call to
'__compiletime_assert_431' declared with attribute error: Unsupported
width, must be <= 40:  => 328:38
  + /kisskb/src/include/linux/compiler_types.h: error: call to
'__compiletime_assert_433' declared with attribute error: Unsupported
width, must be <= 40:  => 328:38
  + /kisskb/src/include/linux/compiler_types.h: error: call to
'__compiletime_assert_450' declared with attribute error: Unsupported
width, must be <= 40:  => 328:38
  + /kisskb/src/include/linux/compiler_types.h: error: call to
'__compiletime_assert_517' declared with attribute error: Unsupported
width, must be <= 40:  => 328:38

arm64-gcc5.4/arm64-allmodconfig
mipsel/mips-allmodconfig
mips-gcc4.9/mips-allmodconfig
powerpc-gcc4.9/allmodconfig+64K_PAGES
powerpc-gcc4.9/powerpc-allmodconfig
powerpc-gcc4.9/powerpc-allyesconfig
powerpc-gcc4.9/ppc64_book3e_allmodconfig
s390x-gcc4.9/s390-allyesconfig
sparc64/sparc64-allmodconfig
sparc64/sparc-allmodconfig
xtensa/xtensa-allmodconfig

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
