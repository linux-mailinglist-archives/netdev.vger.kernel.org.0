Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A9440CF5C
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 00:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbhIOWfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 18:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232800AbhIOWfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 18:35:05 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F071FC061574;
        Wed, 15 Sep 2021 15:33:45 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id s20so6369897oiw.3;
        Wed, 15 Sep 2021 15:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ksGzvLSG/bzIwuiVwvc1qXj6lhrhSA0oI9AgijGYHnE=;
        b=nRZgNNoxUrXzykvomyIvjO0p7RzeOhbJM1zC8+U67x+oop7phIOyMTUQB4VJu0Kpbg
         Zn4X36T8Vr9ymebsW25ho7zLzT6PFgZAmn7yhqdaAwC4/MCiiw2nYq/g8KJSfwenD8Py
         9itWXiC60IVoRsfLErpTSvMjP/sQx6dhiTdorErun+O5TGxn8m4rwP84aDjh/iedGZPe
         1+08fd54Xo9mtzY64uBheFtDsGmXU47lVYE4EiWbU4UNdJYoRfdQ5qOEInqOQZqldrVa
         rncW/OLp1FgJNfVU9xikewUURsQafqfMikHeqngulaNx1ELnUx1I2n6pzuPtyq6Lu19N
         6sQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ksGzvLSG/bzIwuiVwvc1qXj6lhrhSA0oI9AgijGYHnE=;
        b=E6EF3Q5zTWd+ahvsYlQSPZNK9jE4wfGozAWh3pFUbi7IjW8/g+tECuj6Z+w15Qxdgu
         yuHl5CkPI7DpjkZmuM3k4ei115k37iYpmCUwxRdmfmBKXHweKGyFocA67GuZE5EJaH2R
         c6+jCI9FIfK5jV0hf63/hRzB152dWeu1BQa73iWxQu9U/81K/iMLug3yQ68fKISzsouc
         DvVlS0RdM1OK57u0cVdeFgy1VBfap24qYLrSPixeqHEXNYmqRKtY6R6Br7R8PU0Dss4p
         m6Pp6Iu3RRX3K4gaPJPhFAKCLME+bj1Bh52O8mKf9R5WhEbGjJXdiCyzNfm4ZKvR2QWi
         eCbg==
X-Gm-Message-State: AOAM5325N8CSp4ZJbysN1Ft995uTuhQeiKv60+4d/LR7tFAksBYxvqC0
        rCe+VoZcN91bfpJTHjygyQs=
X-Google-Smtp-Source: ABdhPJy5trDub6V96dJLfGPZE5CcTNtlEsDea283NASQvaMM3CfvKy3c2V2VCuRN6ScxtjSVKcezMA==
X-Received: by 2002:a05:6808:1481:: with SMTP id e1mr1480453oiw.5.1631745225297;
        Wed, 15 Sep 2021 15:33:45 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p65sm360614oif.57.2021.09.15.15.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 15:33:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 15 Sep 2021 15:33:42 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] Introduce and use absolute_pointer macro
Message-ID: <20210915223342.GA1556394@roeck-us.net>
References: <20210915035227.630204-1-linux@roeck-us.net>
 <CAHk-=wjXr+NnNPTorhaW81eAbdF90foVo-5pQqRmXZi-ZGaX6Q@mail.gmail.com>
 <47fcc9cc-7d2e-bc79-122b-8eccfe00d8f3@roeck-us.net>
 <CAHk-=wgdEHPm6vGcJ_Zr-Q_p=Muv1Oby5H2+6QyPGxiZ7_Wv+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgdEHPm6vGcJ_Zr-Q_p=Muv1Oby5H2+6QyPGxiZ7_Wv+w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 12:47:44PM -0700, Linus Torvalds wrote:
> On Wed, Sep 15, 2021 at 12:35 PM Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > On a side note, we may revive the parisc patch. Helge isn't entirely
> > happy with the other solution for parisc; it is quite invasive and
> > touches a total of 19 files if I counted correctly.
> 
> Ok, my suggestion to use the linker was not a "do it this way", it
> really was just a "maybe alternate approach". So no objections if
> absolute_pointer() ends up being the simpler solution.
> 
> What other notable issues end up being still live? I sent out that one
> patch for sparc, but didn't get any response to it. I'm inclined to
> just apply it (the 'struct mdesc_hdr' pointer misuse one).
> 

You mean allmodconfig build failures ? There is still a bunch.
For v5.15-rc1-27-gb7213ffa0e58:

alpha:

drivers/net/ethernet/3com/3c515.c: In function 'corkscrew_start_xmit':
drivers/net/ethernet/3com/3c515.c:1053:22: error:
	cast from pointer to integer of different size

That is a typecast from a pointer to an int, which is then sent to an
i/o port. That driver should probably be disabled for 64-bit builds.

---

drivers/net/wan/lmc/lmc_main.c: In function 'lmc_softreset':
drivers/net/wan/lmc/lmc_main.c:1782:50: error:
	passing argument 1 of 'virt_to_bus' discards 'volatile' qualifier from pointer target type

and several other similar errors.

patch:
	https://lore.kernel.org/lkml/20210909050033.1564459-1-linux@roeck-us.net/
Arnd sent an Ack, but it doesn't look like it was picked up.

---
drivers/net/hamradio/6pack.c: In function 'sixpack_open':
drivers/net/hamradio/6pack.c:71:41: error:
	unsigned conversion from 'int' to 'unsigned char' changes value from '256' to '0'

patch:
	https://lore.kernel.org/lkml/20210909035743.1247042-1-linux@roeck-us.net/
David says it is wrong, and I don't know the code well enough
to feel comfortable touching that code. That may be a lost cause.
"depends on BROKEN if ALPHA" may be appropriate here.

===
arm:

drivers/cpufreq/vexpress-spc-cpufreq.c: In function 've_spc_cpufreq_exit':
drivers/cpufreq/vexpress-spc-cpufreq.c:454:13: error: unused variable 'cur_cluster'

patch:
	https://patchwork.kernel.org/project/linux-arm-kernel/patch/20210909184714.153068-1-linux@roeck-us.net/

===
m68k:

arch/m68k/mvme147/config.c: In function 'mvme147_hwclk':
arch/m68k/mvme147/config.c:174:2: error: #warning check me! [-Werror=cpp]
  174 | #warning check me!
      |  ^~~~~~~
arch/m68k/mvme16x/config.c: In function 'mvme16x_hwclk':
arch/m68k/mvme16x/config.c:439:2: error: #warning check me! [-Werror=cpp]

drivers/misc/altera-stapl/altera-lpt.c: In function 'byteblaster_write':
arch/m68k/include/asm/raw_io.h:30:32: error:
	cast to pointer from integer of different size

[ and several other similar problems ]

Patches should be queued in m68k tree.

===
mips:

In file included from arch/mips/include/asm/sibyte/sb1250.h:28,
                 from drivers/watchdog/sb_wdog.c:58:
arch/mips/include/asm/sibyte/bcm1480_scd.h:261: error: "M_SPC_CFG_CLEAR" redefined

and similar. Patch:

https://patchwork.kernel.org/project/linux-watchdog/patch/20210913073220.1159520-1-liu.yun@linux.dev/

I'll need to get Wim to push it.

===
parisc:

arch/parisc/kernel/setup.c: In function 'start_parisc':
arch/parisc/kernel/setup.c:387:28: error:
	'__builtin_memcmp_eq' specified bound 8 exceeds source size 0

Waiting for the absolute_pointer patch

===
riscv32, riscv64:

drivers/gpu/drm/rockchip/cdn-dp-core.c:1126:12: error: 'cdn_dp_resume' defined but not used

patch:

https://patchwork.kernel.org/project/linux-rockchip/patch/20200925215524.2899527-3-sam@ravnborg.org/

Looks like that and similar patches were submitted several times,
but never picked up.

===
s390:

drivers/spi/spi-tegra20-slink.c:1200:12: error:
	'tegra_slink_runtime_resume' defined but not used
drivers/spi/spi-tegra20-slink.c:1188:12: error:
	'tegra_slink_runtime_suspend' defined but not used

patch:
	https://patchwork.kernel.org/project/spi-devel-general/patch/20210907045358.2138282-1-linux@roeck-us.net/

marked as accepted, so should hopefully find its way upstream soon.

---
lib/test_kasan.c: In function 'kasan_alloca_oob_right':
lib/test_kasan.c:782:1: error: 'kasan_alloca_oob_right' uses dynamic stack allocation

and a couple of similar errors. s390 has a special configuration option
to enable warnings on dynamic stack allocations. A patch to remove that
option is pending according to s390 maintainers.

---
drivers/gpu/drm/rockchip/cdn-dp-core.c:1126:12: error: 'cdn_dp_resume' defined but not used

Same as for riscv.

===
xtensa:

Various stack frame errors (more than 50).

drivers/video/fbdev/omap2/omapfb/dss/dsi.c: In function 'dsi_dump_dsidev_irqs':
drivers/video/fbdev/omap2/omapfb/dss/dsi.c:1623:1: error:
	the frame size of 1104 bytes is larger than 1024 bytes

Patch:

https://lore.kernel.org/lkml/20210912025235.3514761-1-linux@roeck-us.net/

Should find its way upstream through mmotm.

Guenter
