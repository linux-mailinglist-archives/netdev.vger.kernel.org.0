Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74BD635FAC
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238574AbiKWNbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236788AbiKWNbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:31:03 -0500
Received: from conssluserg-02.nifty.com (conssluserg-02.nifty.com [210.131.2.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4AFDBC19;
        Wed, 23 Nov 2022 05:12:46 -0800 (PST)
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id 2ANDCQHs013863;
        Wed, 23 Nov 2022 22:12:26 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com 2ANDCQHs013863
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1669209147;
        bh=8jg0eK856v6/vSmmCu8usTZtU3XubFgWRrcXjnjxrvs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aM72sBXQYlXHf/WHgRbb4fu5gPatU3abKyqkxUBpFBfHp1r/xu1Ixw/v9yDG5Qa4m
         qa3qtlMvPB9Do0bm3Rt8uR3C9sZDr270fvkrnQF0v+2/kTXyI37dObHmDPkptRhEm/
         GKkTJG1SSwmyWbxE0XTbRjz+9ywbd2Ol895bBYYmPCTgDnPJym7/FYZblQlGlyXVpo
         8xaJuvh4LYBAw6tdYfe0ybfXbI6U08zBrKND1/FfivlB2DZC/kaDcpo1ENjWtq8CHm
         rds7JU+S9+ayqu2q9sawQnBuyyaZFrIAYmCZu3IB3L7YFG7GVK2T2+ofAcVeIHc1jp
         S6f+v56eeC2sw==
X-Nifty-SrcIP: [209.85.210.41]
Received: by mail-ot1-f41.google.com with SMTP id p10-20020a9d76ca000000b0066d6c6bce58so11148551otl.7;
        Wed, 23 Nov 2022 05:12:26 -0800 (PST)
X-Gm-Message-State: ANoB5pk0ZvTPe6jvphrd2+2oRhbkI5g1+nf9l/NvWGx+88XGTKobRuCx
        jjZUtwgPOMJmj3wm0pth5pVYPmAIZlfTbiu0Dog=
X-Google-Smtp-Source: AA0mqf7QArILuryD7V3uLIADk1D3AWOAI60VZTu8+iCqdU1QcePp78CYOR6jKGnV43tqjC7qh5N1MAlKf9OQXNpxmPc=
X-Received: by 2002:a9d:282:0:b0:66c:794e:f8c6 with SMTP id
 2-20020a9d0282000000b0066c794ef8c6mr14811390otl.343.1669209145738; Wed, 23
 Nov 2022 05:12:25 -0800 (PST)
MIME-Version: 1.0
References: <20221119225650.1044591-1-alobakin@pm.me> <20221119225650.1044591-13-alobakin@pm.me>
In-Reply-To: <20221119225650.1044591-13-alobakin@pm.me>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Wed, 23 Nov 2022 22:11:49 +0900
X-Gmail-Original-Message-ID: <CAK7LNASni5uNFOtR-6VykBHX1Wgg-rOt=q0Lk+H2Vbn7pCsBDQ@mail.gmail.com>
Message-ID: <CAK7LNASni5uNFOtR-6VykBHX1Wgg-rOt=q0Lk+H2Vbn7pCsBDQ@mail.gmail.com>
Subject: Re: [PATCH 12/18] mtd: tests: fix object shared between several modules
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     linux-kbuild@vger.kernel.org, Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 20, 2022 at 8:08 AM Alexander Lobakin <alobakin@pm.me> wrote:
>
> mtd_test.o is linked to 8(!) different test modules:
>
> > scripts/Makefile.build:252: ./drivers/mtd/tests/Makefile: mtd_test.o
> > is added to multiple modules: mtd_nandbiterrs mtd_oobtest mtd_pagetest
> > mtd_readtest mtd_speedtest mtd_stresstest mtd_subpagetest mtd_torturetest
>
> Although all of them share one Kconfig option
> (CONFIG_MTD_TESTS), it's better to not link one object file into
> several modules (and/or vmlinux).
> Under certain circumstances, such can lead to the situation fixed by
> commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects").
> In this particular case, there's also no need to duplicate the very
> same object code 8 times.
>
> Convert mtd_test.o to a standalone module which will export its
> functions to the rest.
>
> Fixes: a995c792280d ("mtd: tests: rename sources in order to link a helper object")
> Suggested-by: Masahiro Yamada <masahiroy@kernel.org>

IMHO, Reported-by might be a better fit.


I think they can become static inline functions in mtd_test.h
(at least, mtdtest_relax() is a static inline there), but I am not sure.

Please send this to the MTD list, and consult the maintainer(s).






> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  drivers/mtd/tests/Makefile      | 17 +++++++++--------
>  drivers/mtd/tests/mtd_test.c    |  9 +++++++++
>  drivers/mtd/tests/nandbiterrs.c |  2 ++
>  drivers/mtd/tests/oobtest.c     |  2 ++
>  drivers/mtd/tests/pagetest.c    |  2 ++
>  drivers/mtd/tests/readtest.c    |  2 ++
>  drivers/mtd/tests/speedtest.c   |  2 ++
>  drivers/mtd/tests/stresstest.c  |  2 ++
>  drivers/mtd/tests/subpagetest.c |  2 ++
>  drivers/mtd/tests/torturetest.c |  2 ++
>  10 files changed, 34 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/mtd/tests/Makefile b/drivers/mtd/tests/Makefile
> index 5de0378f90db..e3f86ed123ca 100644
> --- a/drivers/mtd/tests/Makefile
> +++ b/drivers/mtd/tests/Makefile
> @@ -1,4 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
> +obj-$(CONFIG_MTD_TESTS) += mtd_test.o
>  obj-$(CONFIG_MTD_TESTS) += mtd_oobtest.o
>  obj-$(CONFIG_MTD_TESTS) += mtd_pagetest.o
>  obj-$(CONFIG_MTD_TESTS) += mtd_readtest.o
> @@ -9,11 +10,11 @@ obj-$(CONFIG_MTD_TESTS) += mtd_torturetest.o
>  obj-$(CONFIG_MTD_TESTS) += mtd_nandecctest.o
>  obj-$(CONFIG_MTD_TESTS) += mtd_nandbiterrs.o
>
> -mtd_oobtest-objs := oobtest.o mtd_test.o
> -mtd_pagetest-objs := pagetest.o mtd_test.o
> -mtd_readtest-objs := readtest.o mtd_test.o
> -mtd_speedtest-objs := speedtest.o mtd_test.o
> -mtd_stresstest-objs := stresstest.o mtd_test.o
> -mtd_subpagetest-objs := subpagetest.o mtd_test.o
> -mtd_torturetest-objs := torturetest.o mtd_test.o
> -mtd_nandbiterrs-objs := nandbiterrs.o mtd_test.o
> +mtd_oobtest-objs := oobtest.o
> +mtd_pagetest-objs := pagetest.o
> +mtd_readtest-objs := readtest.o
> +mtd_speedtest-objs := speedtest.o
> +mtd_stresstest-objs := stresstest.o
> +mtd_subpagetest-objs := subpagetest.o
> +mtd_torturetest-objs := torturetest.o
> +mtd_nandbiterrs-objs := nandbiterrs.o
> diff --git a/drivers/mtd/tests/mtd_test.c b/drivers/mtd/tests/mtd_test.c
> index c84250beffdc..93920a714315 100644
> --- a/drivers/mtd/tests/mtd_test.c
> +++ b/drivers/mtd/tests/mtd_test.c
> @@ -25,6 +25,7 @@ int mtdtest_erase_eraseblock(struct mtd_info *mtd, unsigned int ebnum)
>
>         return 0;
>  }
> +EXPORT_SYMBOL_NS_GPL(mtdtest_erase_eraseblock, MTD_TESTS);
>
>  static int is_block_bad(struct mtd_info *mtd, unsigned int ebnum)
>  {
> @@ -57,6 +58,7 @@ int mtdtest_scan_for_bad_eraseblocks(struct mtd_info *mtd, unsigned char *bbt,
>
>         return 0;
>  }
> +EXPORT_SYMBOL_NS_GPL(mtdtest_scan_for_bad_eraseblocks, MTD_TESTS);
>
>  int mtdtest_erase_good_eraseblocks(struct mtd_info *mtd, unsigned char *bbt,
>                                 unsigned int eb, int ebcnt)
> @@ -75,6 +77,7 @@ int mtdtest_erase_good_eraseblocks(struct mtd_info *mtd, unsigned char *bbt,
>
>         return 0;
>  }
> +EXPORT_SYMBOL_NS_GPL(mtdtest_erase_good_eraseblocks, MTD_TESTS);
>
>  int mtdtest_read(struct mtd_info *mtd, loff_t addr, size_t size, void *buf)
>  {
> @@ -92,6 +95,7 @@ int mtdtest_read(struct mtd_info *mtd, loff_t addr, size_t size, void *buf)
>
>         return err;
>  }
> +EXPORT_SYMBOL_NS_GPL(mtdtest_read, MTD_TESTS);
>
>  int mtdtest_write(struct mtd_info *mtd, loff_t addr, size_t size,
>                 const void *buf)
> @@ -107,3 +111,8 @@ int mtdtest_write(struct mtd_info *mtd, loff_t addr, size_t size,
>
>         return err;
>  }
> +EXPORT_SYMBOL_NS_GPL(mtdtest_write, MTD_TESTS);
> +
> +MODULE_DESCRIPTION("MTD test common module");
> +MODULE_AUTHOR("Adrian Hunter");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/mtd/tests/nandbiterrs.c b/drivers/mtd/tests/nandbiterrs.c
> index 98d7508f95b1..acf44edfca53 100644
> --- a/drivers/mtd/tests/nandbiterrs.c
> +++ b/drivers/mtd/tests/nandbiterrs.c
> @@ -414,6 +414,8 @@ static void __exit mtd_nandbiterrs_exit(void)
>  module_init(mtd_nandbiterrs_init);
>  module_exit(mtd_nandbiterrs_exit);
>
> +MODULE_IMPORT_NS(MTD_TESTS);
> +
>  MODULE_DESCRIPTION("NAND bit error recovery test");
>  MODULE_AUTHOR("Iwo Mergler");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/mtd/tests/oobtest.c b/drivers/mtd/tests/oobtest.c
> index 13fed398937e..da4efcdd59b2 100644
> --- a/drivers/mtd/tests/oobtest.c
> +++ b/drivers/mtd/tests/oobtest.c
> @@ -728,6 +728,8 @@ static void __exit mtd_oobtest_exit(void)
>  }
>  module_exit(mtd_oobtest_exit);
>
> +MODULE_IMPORT_NS(MTD_TESTS);
> +
>  MODULE_DESCRIPTION("Out-of-band test module");
>  MODULE_AUTHOR("Adrian Hunter");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/mtd/tests/pagetest.c b/drivers/mtd/tests/pagetest.c
> index 8eb40b6e6dfa..ac2bcc76b402 100644
> --- a/drivers/mtd/tests/pagetest.c
> +++ b/drivers/mtd/tests/pagetest.c
> @@ -456,6 +456,8 @@ static void __exit mtd_pagetest_exit(void)
>  }
>  module_exit(mtd_pagetest_exit);
>
> +MODULE_IMPORT_NS(MTD_TESTS);
> +
>  MODULE_DESCRIPTION("NAND page test");
>  MODULE_AUTHOR("Adrian Hunter");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/mtd/tests/readtest.c b/drivers/mtd/tests/readtest.c
> index 99670ef91f2b..7e01dbc1e8ca 100644
> --- a/drivers/mtd/tests/readtest.c
> +++ b/drivers/mtd/tests/readtest.c
> @@ -210,6 +210,8 @@ static void __exit mtd_readtest_exit(void)
>  }
>  module_exit(mtd_readtest_exit);
>
> +MODULE_IMPORT_NS(MTD_TESTS);
> +
>  MODULE_DESCRIPTION("Read test module");
>  MODULE_AUTHOR("Adrian Hunter");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/mtd/tests/speedtest.c b/drivers/mtd/tests/speedtest.c
> index 075bce32caa5..58f3701d65f2 100644
> --- a/drivers/mtd/tests/speedtest.c
> +++ b/drivers/mtd/tests/speedtest.c
> @@ -413,6 +413,8 @@ static void __exit mtd_speedtest_exit(void)
>  }
>  module_exit(mtd_speedtest_exit);
>
> +MODULE_IMPORT_NS(MTD_TESTS);
> +
>  MODULE_DESCRIPTION("Speed test module");
>  MODULE_AUTHOR("Adrian Hunter");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/mtd/tests/stresstest.c b/drivers/mtd/tests/stresstest.c
> index 75b6ddc5dc4d..341d7cc86d89 100644
> --- a/drivers/mtd/tests/stresstest.c
> +++ b/drivers/mtd/tests/stresstest.c
> @@ -227,6 +227,8 @@ static void __exit mtd_stresstest_exit(void)
>  }
>  module_exit(mtd_stresstest_exit);
>
> +MODULE_IMPORT_NS(MTD_TESTS);
> +
>  MODULE_DESCRIPTION("Stress test module");
>  MODULE_AUTHOR("Adrian Hunter");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/mtd/tests/subpagetest.c b/drivers/mtd/tests/subpagetest.c
> index 05250a080139..87ee2a5c518a 100644
> --- a/drivers/mtd/tests/subpagetest.c
> +++ b/drivers/mtd/tests/subpagetest.c
> @@ -432,6 +432,8 @@ static void __exit mtd_subpagetest_exit(void)
>  }
>  module_exit(mtd_subpagetest_exit);
>
> +MODULE_IMPORT_NS(MTD_TESTS);
> +
>  MODULE_DESCRIPTION("Subpage test module");
>  MODULE_AUTHOR("Adrian Hunter");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/mtd/tests/torturetest.c b/drivers/mtd/tests/torturetest.c
> index 841689b4d86d..2de770f18724 100644
> --- a/drivers/mtd/tests/torturetest.c
> +++ b/drivers/mtd/tests/torturetest.c
> @@ -475,6 +475,8 @@ static int countdiffs(unsigned char *buf, unsigned char *check_buf,
>         return first;
>  }
>
> +MODULE_IMPORT_NS(MTD_TESTS);
> +
>  MODULE_DESCRIPTION("Eraseblock torturing module");
>  MODULE_AUTHOR("Artem Bityutskiy, Jarkko Lavinen, Adrian Hunter");
>  MODULE_LICENSE("GPL");
> --
> 2.38.1
>
>


-- 
Best Regards
Masahiro Yamada
