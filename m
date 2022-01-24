Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8244989B1
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344059AbiAXS5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:57:47 -0500
Received: from mail-ua1-f52.google.com ([209.85.222.52]:40701 "EHLO
        mail-ua1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242445AbiAXSzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:55:45 -0500
Received: by mail-ua1-f52.google.com with SMTP id w21so32801061uan.7;
        Mon, 24 Jan 2022 10:55:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ME4XZXZ5PNYvzDH4OmBox2BIuMK+Mc5MwbGfrqjcLBM=;
        b=krwgaVuE7IDC/rxMSMdLVC6uJSa/IKo1aMFUsDzc8QqnxQzkUgm+00n86vnoUFQF0V
         t/afEQFBE5qkd4PwgnEWzJiBnrV7wjOjH4Yb+FUufm3HBdIfbdx50jPutmKTFXqjodzD
         m6d4F7+l5FYX18rXQ8oFFekvkdnh5QYpS7ERz7sQzH/FdjHdTbT1Krdgfs5LyaZp6DuS
         2k3pAQCkj1l7z8k0wEvEF4rEwZr1u0se7eCCCLbKgTn3uZQvaHOx1tM+JdSCp3wDmegH
         7ou9UbdSXcUwNwZwBtQjgczB7V0ZYrbyp/+JMycS0bXEEBxeqplavCDDZroxzta12JMF
         MuRw==
X-Gm-Message-State: AOAM532Rwk+fClYn7Oie+oxm1D0fIxBdQ6oQRFbAG59aU59Nu1WSe/Va
        0vQ8LjJLPDlEPSEr3TyoFZpJdxMmjGia0w==
X-Google-Smtp-Source: ABdhPJzErMxVydBitJvV9DhLIxXl2tkEu3hu1ychn50c2rXn3rVSZyzIt49BJeS/bJthEGNUNJ53Cw==
X-Received: by 2002:ab0:5e93:: with SMTP id y19mr6435088uag.13.1643050543868;
        Mon, 24 Jan 2022 10:55:43 -0800 (PST)
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com. [209.85.222.47])
        by smtp.gmail.com with ESMTPSA id e194sm257894vke.37.2022.01.24.10.55.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 10:55:43 -0800 (PST)
Received: by mail-ua1-f47.google.com with SMTP id 2so32864999uax.10;
        Mon, 24 Jan 2022 10:55:43 -0800 (PST)
X-Received: by 2002:a9f:2070:: with SMTP id 103mr2821729uam.122.1643050543058;
 Mon, 24 Jan 2022 10:55:43 -0800 (PST)
MIME-Version: 1.0
References: <20220123125737.2658758-1-geert@linux-m68k.org>
 <alpine.DEB.2.22.394.2201240851560.2674757@ramsan.of.borg> <CADnq5_MUq0fX7wMLJyUUxxa+2xoRinonL-TzD8tUhXALRfY8-A@mail.gmail.com>
In-Reply-To: <CADnq5_MUq0fX7wMLJyUUxxa+2xoRinonL-TzD8tUhXALRfY8-A@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 24 Jan 2022 19:55:32 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWUWqHYbbavtMT-XAD_sarDPC5xnc3c0pX1ZAh3Wuzuzg@mail.gmail.com>
Message-ID: <CAMuHMdWUWqHYbbavtMT-XAD_sarDPC5xnc3c0pX1ZAh3Wuzuzg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v5.17-rc1
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        KVM list <kvm@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-um <linux-um@lists.infradead.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>,
        sparclinux <sparclinux@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "Tobin C. Harding" <me@tobin.cc>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

On Mon, Jan 24, 2022 at 7:52 PM Alex Deucher <alexdeucher@gmail.com> wrote:
> On Mon, Jan 24, 2022 at 5:25 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Sun, 23 Jan 2022, Geert Uytterhoeven wrote:
> > >  + /kisskb/src/drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c: error: control reaches end of non-void function [-Werror=return-type]:  => 1560:1
>
> I don't really see what's going on here:
>
> #ifdef CONFIG_X86_64
> return cpu_data(first_cpu_of_numa_node).apicid;
> #else
> return first_cpu_of_numa_node;
> #endif

Ah, the actual failure causing this was not included:

In file included from /kisskb/src/arch/x86/um/asm/processor.h:41:0,
                 from /kisskb/src/include/linux/mutex.h:19,
                 from /kisskb/src/include/linux/kernfs.h:11,
                 from /kisskb/src/include/linux/sysfs.h:16,
                 from /kisskb/src/include/linux/kobject.h:20,
                 from /kisskb/src/include/linux/pci.h:35,
                 from
/kisskb/src/drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c:25:
/kisskb/src/drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c: In
function 'kfd_cpumask_to_apic_id':
/kisskb/src/arch/um/include/asm/processor-generic.h:103:18: error:
called object is not a function or function pointer
 #define cpu_data (&boot_cpu_data)
                  ^
/kisskb/src/drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c:1556:9:
note: in expansion of macro 'cpu_data'
  return cpu_data(first_cpu_of_numa_node).apicid;
         ^
/kisskb/src/drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c:1560:1:
error: control reaches end of non-void function [-Werror=return-type]
 }
 ^

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
