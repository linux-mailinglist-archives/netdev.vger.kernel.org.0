Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A04668CF1
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 07:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240620AbjAMGZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 01:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235686AbjAMGYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 01:24:16 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90C95BA21;
        Thu, 12 Jan 2023 22:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=bZRrd/4ijWm8Q+qC6IXW3jzPVelZaA012+Uvm5zmnAE=; b=1dkXCLun5XfxKB6vUDKyUdQse/
        hwZfQvAicEUwutWqS153BT/h4C7pI5Pohwkt5PIxwTZ9+aoWcQL14KKGZwCxLU6pddGLw+ceVwUuM
        YcHY1M52KVxOkQcb5SFeTwOp4EfRl6h+UQRn3Hjw64kcORDAZGb3GxqawaXomSmRgCDXpjKIUOoog
        MfZHsbHa2OK2bsMhfUS20YhARK/lXe56yR9OhApShAX4w9itOXXK4sHz5o+O4m7f4Mqe1E+qBu3ay
        DOUMtibRQEJ36AcaK2u9/mLkZqdsrbtA5FNIuirm1UtF4Z4gUCq4xqPGumNXRtNiPikPt8t4O/oAf
        99ZG/2Aw==;
Received: from [2001:4bb8:181:656b:9509:7d20:8d39:f895] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pGDTZ-000lMO-OM; Fri, 13 Jan 2023 06:23:42 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org
Subject: remove arch/sh
Date:   Fri, 13 Jan 2023 07:23:17 +0100
Message-Id: <20230113062339.1909087-1-hch@lst.de>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

arch/sh has been a long drag because it supports a lot of SOCs, and most
of them haven't even been converted to device tree infrastructure.  These
SOCs are generally obsolete as well, and all of the support has been barely
maintained for almost 10 years, and not at all for more than 1 year.

Drop arch/sh and everything that depends on it.

Diffstat:
 Documentation/sh/booting.rst                             |   12 
 Documentation/sh/features.rst                            |    3 
 Documentation/sh/index.rst                               |   56 
 Documentation/sh/new-machine.rst                         |  277 -
 Documentation/sh/register-banks.rst                      |   40 
 arch/sh/Kbuild                                           |    7 
 arch/sh/Kconfig                                          |  793 ----
 arch/sh/Kconfig.cpu                                      |  100 
 arch/sh/Kconfig.debug                                    |   78 
 arch/sh/Makefile                                         |  215 -
 arch/sh/boards/Kconfig                                   |  400 --
 arch/sh/boards/Makefile                                  |   20 
 arch/sh/boards/board-apsh4a3a.c                          |  182 
 arch/sh/boards/board-apsh4ad0a.c                         |  132 
 arch/sh/boards/board-edosk7705.c                         |   79 
 arch/sh/boards/board-edosk7760.c                         |  178 
 arch/sh/boards/board-espt.c                              |  105 
 arch/sh/boards/board-magicpanelr2.c                      |  390 --
 arch/sh/boards/board-polaris.c                           |  156 
 arch/sh/boards/board-secureedge5410.c                    |   75 
 arch/sh/boards/board-sh2007.c                            |  146 
 arch/sh/boards/board-sh7757lcr.c                         |  604 ---
 arch/sh/boards/board-sh7785lcr.c                         |  384 --
 arch/sh/boards/board-shmin.c                             |   35 
 arch/sh/boards/board-titan.c                             |   21 
 arch/sh/boards/board-urquell.c                           |  218 -
 arch/sh/boards/mach-ap325rxa/Makefile                    |    3 
 arch/sh/boards/mach-ap325rxa/sdram.S                     |   66 
 arch/sh/boards/mach-ap325rxa/setup.c                     |  573 ---
 arch/sh/boards/mach-dreamcast/Makefile                   |    7 
 arch/sh/boards/mach-dreamcast/irq.c                      |  155 
 arch/sh/boards/mach-dreamcast/rtc.c                      |   96 
 arch/sh/boards/mach-dreamcast/setup.c                    |   39 
 arch/sh/boards/mach-ecovec24/Makefile                    |   10 
 arch/sh/boards/mach-ecovec24/sdram.S                     |  108 
 arch/sh/boards/mach-ecovec24/setup.c                     | 1521 --------
 arch/sh/boards/mach-highlander/Kconfig                   |   26 
 arch/sh/boards/mach-highlander/Makefile                  |   12 
 arch/sh/boards/mach-highlander/irq-r7780mp.c             |   71 
 arch/sh/boards/mach-highlander/irq-r7780rp.c             |   64 
 arch/sh/boards/mach-highlander/irq-r7785rp.c             |   83 
 arch/sh/boards/mach-highlander/pinmux-r7785rp.c          |   17 
 arch/sh/boards/mach-highlander/psw.c                     |  119 
 arch/sh/boards/mach-highlander/setup.c                   |  416 --
 arch/sh/boards/mach-hp6xx/Makefile                       |    8 
 arch/sh/boards/mach-hp6xx/hp6xx_apm.c                    |  109 
 arch/sh/boards/mach-hp6xx/pm.c                           |  156 
 arch/sh/boards/mach-hp6xx/pm_wakeup.S                    |   39 
 arch/sh/boards/mach-hp6xx/setup.c                        |  172 
 arch/sh/boards/mach-kfr2r09/Makefile                     |    5 
 arch/sh/boards/mach-kfr2r09/lcd_wqvga.c                  |  275 -
 arch/sh/boards/mach-kfr2r09/sdram.S                      |   77 
 arch/sh/boards/mach-kfr2r09/setup.c                      |  649 ---
 arch/sh/boards/mach-landisk/Makefile                     |    6 
 arch/sh/boards/mach-landisk/gio.c                        |  164 
 arch/sh/boards/mach-landisk/irq.c                        |   63 
 arch/sh/boards/mach-landisk/psw.c                        |  140 
 arch/sh/boards/mach-landisk/setup.c                      |  102 
 arch/sh/boards/mach-lboxre2/Makefile                     |    6 
 arch/sh/boards/mach-lboxre2/irq.c                        |   27 
 arch/sh/boards/mach-lboxre2/setup.c                      |   79 
 arch/sh/boards/mach-microdev/Makefile                    |    6 
 arch/sh/boards/mach-microdev/fdc37c93xapm.c              |  157 
 arch/sh/boards/mach-microdev/io.c                        |  123 
 arch/sh/boards/mach-microdev/irq.c                       |  150 
 arch/sh/boards/mach-microdev/setup.c                     |  197 -
 arch/sh/boards/mach-migor/Kconfig                        |   16 
 arch/sh/boards/mach-migor/Makefile                       |    3 
 arch/sh/boards/mach-migor/lcd_qvga.c                     |  163 
 arch/sh/boards/mach-migor/sdram.S                        |   66 
 arch/sh/boards/mach-migor/setup.c                        |  649 ---
 arch/sh/boards/mach-r2d/Kconfig                          |   24 
 arch/sh/boards/mach-r2d/Makefile                         |    6 
 arch/sh/boards/mach-r2d/irq.c                            |  156 
 arch/sh/boards/mach-r2d/setup.c                          |  305 -
 arch/sh/boards/mach-rsk/Kconfig                          |   29 
 arch/sh/boards/mach-rsk/Makefile                         |    5 
 arch/sh/boards/mach-rsk/devices-rsk7203.c                |  137 
 arch/sh/boards/mach-rsk/devices-rsk7264.c                |   55 
 arch/sh/boards/mach-rsk/devices-rsk7269.c                |   57 
 arch/sh/boards/mach-rsk/setup.c                          |   84 
 arch/sh/boards/mach-sdk7780/Kconfig                      |   17 
 arch/sh/boards/mach-sdk7780/Makefile                     |    6 
 arch/sh/boards/mach-sdk7780/irq.c                        |   43 
 arch/sh/boards/mach-sdk7780/setup.c                      |   96 
 arch/sh/boards/mach-sdk7786/Makefile                     |    5 
 arch/sh/boards/mach-sdk7786/fpga.c                       |   69 
 arch/sh/boards/mach-sdk7786/gpio.c                       |   46 
 arch/sh/boards/mach-sdk7786/irq.c                        |   45 
 arch/sh/boards/mach-sdk7786/nmi.c                        |   80 
 arch/sh/boards/mach-sdk7786/setup.c                      |  266 -
 arch/sh/boards/mach-sdk7786/sram.c                       |   69 
 arch/sh/boards/mach-se/7206/Makefile                     |    6 
 arch/sh/boards/mach-se/7206/irq.c                        |  151 
 arch/sh/boards/mach-se/7206/setup.c                      |   96 
 arch/sh/boards/mach-se/7343/Makefile                     |    6 
 arch/sh/boards/mach-se/7343/irq.c                        |  123 
 arch/sh/boards/mach-se/7343/setup.c                      |  182 
 arch/sh/boards/mach-se/770x/Makefile                     |    6 
 arch/sh/boards/mach-se/770x/irq.c                        |  109 
 arch/sh/boards/mach-se/770x/setup.c                      |  205 -
 arch/sh/boards/mach-se/7721/Makefile                     |    2 
 arch/sh/boards/mach-se/7721/irq.c                        |   42 
 arch/sh/boards/mach-se/7721/setup.c                      |   92 
 arch/sh/boards/mach-se/7722/Makefile                     |   11 
 arch/sh/boards/mach-se/7722/irq.c                        |  116 
 arch/sh/boards/mach-se/7722/setup.c                      |  190 
 arch/sh/boards/mach-se/7724/Makefile                     |   11 
 arch/sh/boards/mach-se/7724/irq.c                        |  143 
 arch/sh/boards/mach-se/7724/sdram.S                      |  128 
 arch/sh/boards/mach-se/7724/setup.c                      |  986 -----
 arch/sh/boards/mach-se/7751/Makefile                     |    6 
 arch/sh/boards/mach-se/7751/irq.c                        |   51 
 arch/sh/boards/mach-se/7751/setup.c                      |   60 
 arch/sh/boards/mach-se/7780/Makefile                     |   11 
 arch/sh/boards/mach-se/7780/irq.c                        |   65 
 arch/sh/boards/mach-se/7780/setup.c                      |  111 
 arch/sh/boards/mach-se/Makefile                          |   11 
 arch/sh/boards/mach-se/board-se7619.c                    |   27 
 arch/sh/boards/mach-sh03/Makefile                        |    7 
 arch/sh/boards/mach-sh03/rtc.c                           |  143 
 arch/sh/boards/mach-sh03/setup.c                         |   97 
 arch/sh/boards/mach-sh7763rdp/Makefile                   |    2 
 arch/sh/boards/mach-sh7763rdp/irq.c                      |   42 
 arch/sh/boards/mach-sh7763rdp/setup.c                    |  213 -
 arch/sh/boards/mach-x3proto/Makefile                     |    4 
 arch/sh/boards/mach-x3proto/gpio.c                       |  136 
 arch/sh/boards/mach-x3proto/ilsel.c                      |  156 
 arch/sh/boards/mach-x3proto/setup.c                      |  270 -
 arch/sh/boards/of-generic.c                              |  172 
 arch/sh/boot/.gitignore                                  |    5 
 arch/sh/boot/Makefile                                    |  115 
 arch/sh/boot/compressed/.gitignore                       |    2 
 arch/sh/boot/compressed/Makefile                         |   66 
 arch/sh/boot/compressed/ashiftrt.S                       |    2 
 arch/sh/boot/compressed/ashldi3.c                        |    2 
 arch/sh/boot/compressed/ashlsi3.S                        |    2 
 arch/sh/boot/compressed/ashrsi3.S                        |    2 
 arch/sh/boot/compressed/cache.c                          |   13 
 arch/sh/boot/compressed/head_32.S                        |  126 
 arch/sh/boot/compressed/head_64.S                        |  159 
 arch/sh/boot/compressed/lshrsi3.S                        |    2 
 arch/sh/boot/compressed/misc.c                           |  146 
 arch/sh/boot/compressed/vmlinux.scr                      |   10 
 arch/sh/boot/dts/Makefile                                |    2 
 arch/sh/boot/dts/j2_mimas_v2.dts                         |   99 
 arch/sh/boot/romimage/Makefile                           |   30 
 arch/sh/boot/romimage/head.S                             |   85 
 arch/sh/boot/romimage/mmcif-sh7724.c                     |   78 
 arch/sh/boot/romimage/vmlinux.scr                        |    8 
 arch/sh/cchips/Kconfig                                   |   46 
 arch/sh/cchips/hd6446x/Makefile                          |    4 
 arch/sh/cchips/hd6446x/hd64461.c                         |  112 
 arch/sh/configs/ap325rxa_defconfig                       |  103 
 arch/sh/configs/apsh4a3a_defconfig                       |   91 
 arch/sh/configs/apsh4ad0a_defconfig                      |  122 
 arch/sh/configs/dreamcast_defconfig                      |   72 
 arch/sh/configs/ecovec24-romimage_defconfig              |   58 
 arch/sh/configs/ecovec24_defconfig                       |  132 
 arch/sh/configs/edosk7705_defconfig                      |   35 
 arch/sh/configs/edosk7760_defconfig                      |  114 
 arch/sh/configs/espt_defconfig                           |  114 
 arch/sh/configs/hp6xx_defconfig                          |   60 
 arch/sh/configs/j2_defconfig                             |   42 
 arch/sh/configs/kfr2r09-romimage_defconfig               |   53 
 arch/sh/configs/kfr2r09_defconfig                        |   84 
 arch/sh/configs/landisk_defconfig                        |  115 
 arch/sh/configs/lboxre2_defconfig                        |   62 
 arch/sh/configs/magicpanelr2_defconfig                   |   90 
 arch/sh/configs/microdev_defconfig                       |   43 
 arch/sh/configs/migor_defconfig                          |   94 
 arch/sh/configs/polaris_defconfig                        |   83 
 arch/sh/configs/r7780mp_defconfig                        |  109 
 arch/sh/configs/r7785rp_defconfig                        |  107 
 arch/sh/configs/rsk7201_defconfig                        |   63 
 arch/sh/configs/rsk7203_defconfig                        |  121 
 arch/sh/configs/rsk7264_defconfig                        |   71 
 arch/sh/configs/rsk7269_defconfig                        |   56 
 arch/sh/configs/rts7751r2d1_defconfig                    |   91 
 arch/sh/configs/rts7751r2dplus_defconfig                 |   96 
 arch/sh/configs/sdk7780_defconfig                        |  139 
 arch/sh/configs/sdk7786_defconfig                        |  217 -
 arch/sh/configs/se7206_defconfig                         |  108 
 arch/sh/configs/se7343_defconfig                         |   96 
 arch/sh/configs/se7619_defconfig                         |   43 
 arch/sh/configs/se7705_defconfig                         |   54 
 arch/sh/configs/se7712_defconfig                         |  101 
 arch/sh/configs/se7721_defconfig                         |  127 
 arch/sh/configs/se7722_defconfig                         |   56 
 arch/sh/configs/se7724_defconfig                         |  132 
 arch/sh/configs/se7750_defconfig                         |   55 
 arch/sh/configs/se7751_defconfig                         |   46 
 arch/sh/configs/se7780_defconfig                         |  106 
 arch/sh/configs/secureedge5410_defconfig                 |   53 
 arch/sh/configs/sh03_defconfig                           |  126 
 arch/sh/configs/sh2007_defconfig                         |  199 -
 arch/sh/configs/sh7710voipgw_defconfig                   |   55 
 arch/sh/configs/sh7724_generic_defconfig                 |   41 
 arch/sh/configs/sh7757lcr_defconfig                      |   85 
 arch/sh/configs/sh7763rdp_defconfig                      |  116 
 arch/sh/configs/sh7770_generic_defconfig                 |   43 
 arch/sh/configs/sh7785lcr_32bit_defconfig                |  149 
 arch/sh/configs/sh7785lcr_defconfig                      |  117 
 arch/sh/configs/shmin_defconfig                          |   52 
 arch/sh/configs/shx3_defconfig                           |  103 
 arch/sh/configs/titan_defconfig                          |  272 -
 arch/sh/configs/ul2_defconfig                            |   84 
 arch/sh/configs/urquell_defconfig                        |  147 
 arch/sh/drivers/Kconfig                                  |   20 
 arch/sh/drivers/Makefile                                 |   11 
 arch/sh/drivers/dma/Kconfig                              |   74 
 arch/sh/drivers/dma/Makefile                             |    9 
 arch/sh/drivers/dma/dma-api.c                            |  417 --
 arch/sh/drivers/dma/dma-g2.c                             |  197 -
 arch/sh/drivers/dma/dma-pvr2.c                           |  102 
 arch/sh/drivers/dma/dma-sh.c                             |  414 --
 arch/sh/drivers/dma/dma-sysfs.c                          |  164 
 arch/sh/drivers/dma/dmabrg.c                             |  196 -
 arch/sh/drivers/heartbeat.c                              |  152 
 arch/sh/drivers/pci/Makefile                             |   27 
 arch/sh/drivers/pci/common.c                             |  159 
 arch/sh/drivers/pci/fixups-dreamcast.c                   |   84 
 arch/sh/drivers/pci/fixups-landisk.c                     |   57 
 arch/sh/drivers/pci/fixups-r7780rp.c                     |   18 
 arch/sh/drivers/pci/fixups-rts7751r2d.c                  |   64 
 arch/sh/drivers/pci/fixups-sdk7780.c                     |   40 
 arch/sh/drivers/pci/fixups-sdk7786.c                     |   64 
 arch/sh/drivers/pci/fixups-se7751.c                      |  113 
 arch/sh/drivers/pci/fixups-sh03.c                        |   33 
 arch/sh/drivers/pci/fixups-snapgear.c                    |   37 
 arch/sh/drivers/pci/fixups-titan.c                       |   36 
 arch/sh/drivers/pci/ops-dreamcast.c                      |   79 
 arch/sh/drivers/pci/ops-sh4.c                            |  105 
 arch/sh/drivers/pci/ops-sh7786.c                         |  168 
 arch/sh/drivers/pci/pci-dreamcast.c                      |   97 
 arch/sh/drivers/pci/pci-sh4.h                            |  182 
 arch/sh/drivers/pci/pci-sh7751.c                         |  179 
 arch/sh/drivers/pci/pci-sh7751.h                         |  126 
 arch/sh/drivers/pci/pci-sh7780.c                         |  407 --
 arch/sh/drivers/pci/pci-sh7780.h                         |   43 
 arch/sh/drivers/pci/pci.c                                |  298 -
 arch/sh/drivers/pci/pcie-sh7786.c                        |  609 ---
 arch/sh/drivers/pci/pcie-sh7786.h                        |  577 ---
 arch/sh/drivers/platform_early.c                         |  340 -
 arch/sh/drivers/push-switch.c                            |  136 
 arch/sh/drivers/superhyway/Makefile                      |    7 
 arch/sh/drivers/superhyway/ops-sh4-202.c                 |  168 
 arch/sh/include/asm/Kbuild                               |    5 
 arch/sh/include/asm/adc.h                                |   12 
 arch/sh/include/asm/addrspace.h                          |   63 
 arch/sh/include/asm/alignment.h                          |   22 
 arch/sh/include/asm/asm-offsets.h                        |    2 
 arch/sh/include/asm/atomic-grb.h                         |   86 
 arch/sh/include/asm/atomic-irq.h                         |   72 
 arch/sh/include/asm/atomic-llsc.h                        |   88 
 arch/sh/include/asm/atomic.h                             |   38 
 arch/sh/include/asm/barrier.h                            |   45 
 arch/sh/include/asm/bitops-cas.h                         |   94 
 arch/sh/include/asm/bitops-grb.h                         |  173 
 arch/sh/include/asm/bitops-llsc.h                        |  147 
 arch/sh/include/asm/bitops-op32.h                        |  143 
 arch/sh/include/asm/bitops.h                             |   72 
 arch/sh/include/asm/bl_bit.h                             |    2 
 arch/sh/include/asm/bl_bit_32.h                          |   34 
 arch/sh/include/asm/bug.h                                |  121 
 arch/sh/include/asm/bugs.h                               |   74 
 arch/sh/include/asm/cache.h                              |   46 
 arch/sh/include/asm/cache_insns.h                        |    2 
 arch/sh/include/asm/cache_insns_32.h                     |   22 
 arch/sh/include/asm/cacheflush.h                         |  106 
 arch/sh/include/asm/checksum.h                           |    2 
 arch/sh/include/asm/checksum_32.h                        |  203 -
 arch/sh/include/asm/clock.h                              |   17 
 arch/sh/include/asm/cmpxchg-cas.h                        |   25 
 arch/sh/include/asm/cmpxchg-grb.h                        |   95 
 arch/sh/include/asm/cmpxchg-irq.h                        |   54 
 arch/sh/include/asm/cmpxchg-llsc.h                       |   53 
 arch/sh/include/asm/cmpxchg-xchg.h                       |   50 
 arch/sh/include/asm/cmpxchg.h                            |   74 
 arch/sh/include/asm/device.h                             |   17 
 arch/sh/include/asm/dma-register.h                       |   50 
 arch/sh/include/asm/dma.h                                |  140 
 arch/sh/include/asm/dmabrg.h                             |   24 
 arch/sh/include/asm/dwarf.h                              |  417 --
 arch/sh/include/asm/elf.h                                |  211 -
 arch/sh/include/asm/entry-macros.S                       |  123 
 arch/sh/include/asm/extable.h                            |    7 
 arch/sh/include/asm/fb.h                                 |   20 
 arch/sh/include/asm/fixmap.h                             |   86 
 arch/sh/include/asm/flat.h                               |   33 
 arch/sh/include/asm/fpu.h                                |   69 
 arch/sh/include/asm/freq.h                               |   12 
 arch/sh/include/asm/ftrace.h                             |   48 
 arch/sh/include/asm/futex-cas.h                          |   35 
 arch/sh/include/asm/futex-irq.h                          |   25 
 arch/sh/include/asm/futex-llsc.h                         |   42 
 arch/sh/include/asm/futex.h                              |   72 
 arch/sh/include/asm/gpio.h                               |   50 
 arch/sh/include/asm/hardirq.h                            |   11 
 arch/sh/include/asm/hd64461.h                            |  252 -
 arch/sh/include/asm/heartbeat.h                          |   19 
 arch/sh/include/asm/hugetlb.h                            |   38 
 arch/sh/include/asm/hw_breakpoint.h                      |   70 
 arch/sh/include/asm/hw_irq.h                             |   36 
 arch/sh/include/asm/i2c-sh7760.h                         |   21 
 arch/sh/include/asm/io.h                                 |  294 -
 arch/sh/include/asm/io_generic.h                         |   19 
 arch/sh/include/asm/io_noioport.h                        |   86 
 arch/sh/include/asm/io_trapped.h                         |   59 
 arch/sh/include/asm/irq.h                                |   58 
 arch/sh/include/asm/irqflags.h                           |   10 
 arch/sh/include/asm/kdebug.h                             |   19 
 arch/sh/include/asm/kexec.h                              |   72 
 arch/sh/include/asm/kgdb.h                               |   38 
 arch/sh/include/asm/kprobes.h                            |   57 
 arch/sh/include/asm/linkage.h                            |    8 
 arch/sh/include/asm/machvec.h                            |   41 
 arch/sh/include/asm/mmiowb.h                             |   12 
 arch/sh/include/asm/mmu.h                                |  107 
 arch/sh/include/asm/mmu_context.h                        |  178 
 arch/sh/include/asm/mmu_context_32.h                     |   51 
 arch/sh/include/asm/mmzone.h                             |   45 
 arch/sh/include/asm/module.h                             |   14 
 arch/sh/include/asm/page.h                               |  186 
 arch/sh/include/asm/pci.h                                |   91 
 arch/sh/include/asm/perf_event.h                         |   30 
 arch/sh/include/asm/pgalloc.h                            |   40 
 arch/sh/include/asm/pgtable-2level.h                     |   24 
 arch/sh/include/asm/pgtable-3level.h                     |   59 
 arch/sh/include/asm/pgtable.h                            |  150 
 arch/sh/include/asm/pgtable_32.h                         |  462 --
 arch/sh/include/asm/platform_early.h                     |   61 
 arch/sh/include/asm/posix_types.h                        |    2 
 arch/sh/include/asm/processor.h                          |  173 
 arch/sh/include/asm/processor_32.h                       |  202 -
 arch/sh/include/asm/ptrace.h                             |  139 
 arch/sh/include/asm/ptrace_32.h                          |   14 
 arch/sh/include/asm/push-switch.h                        |   32 
 arch/sh/include/asm/reboot.h                             |   22 
 arch/sh/include/asm/romimage-macros.h                    |   74 
 arch/sh/include/asm/rtc.h                                |   15 
 arch/sh/include/asm/seccomp.h                            |   21 
 arch/sh/include/asm/sections.h                           |   12 
 arch/sh/include/asm/setup.h                              |   25 
 arch/sh/include/asm/sfp-machine.h                        |   80 
 arch/sh/include/asm/sh7760fb.h                           |  198 -
 arch/sh/include/asm/sh_bios.h                            |   28 
 arch/sh/include/asm/shmparam.h                           |   19 
 arch/sh/include/asm/siu.h                                |   20 
 arch/sh/include/asm/smc37c93x.h                          |  191 -
 arch/sh/include/asm/smp-ops.h                            |   52 
 arch/sh/include/asm/smp.h                                |   83 
 arch/sh/include/asm/sparsemem.h                          |   12 
 arch/sh/include/asm/spi.h                                |   14 
 arch/sh/include/asm/spinlock-cas.h                       |   89 
 arch/sh/include/asm/spinlock-llsc.h                      |  198 -
 arch/sh/include/asm/spinlock.h                           |   19 
 arch/sh/include/asm/spinlock_types.h                     |   22 
 arch/sh/include/asm/sram.h                               |   39 
 arch/sh/include/asm/stackprotector.h                     |   21 
 arch/sh/include/asm/stacktrace.h                         |   21 
 arch/sh/include/asm/string.h                             |    2 
 arch/sh/include/asm/string_32.h                          |  102 
 arch/sh/include/asm/suspend.h                            |   97 
 arch/sh/include/asm/switch_to.h                          |    7 
 arch/sh/include/asm/switch_to_32.h                       |  131 
 arch/sh/include/asm/syscall.h                            |    9 
 arch/sh/include/asm/syscall_32.h                         |   69 
 arch/sh/include/asm/syscalls.h                           |   14 
 arch/sh/include/asm/syscalls_32.h                        |   27 
 arch/sh/include/asm/thread_info.h                        |  171 
 arch/sh/include/asm/timex.h                              |   24 
 arch/sh/include/asm/tlb.h                                |   29 
 arch/sh/include/asm/tlbflush.h                           |   52 
 arch/sh/include/asm/topology.h                           |   28 
 arch/sh/include/asm/traps.h                              |   18 
 arch/sh/include/asm/traps_32.h                           |   61 
 arch/sh/include/asm/types.h                              |   16 
 arch/sh/include/asm/uaccess.h                            |  133 
 arch/sh/include/asm/uaccess_32.h                         |  227 -
 arch/sh/include/asm/uncached.h                           |   59 
 arch/sh/include/asm/unistd.h                             |   31 
 arch/sh/include/asm/unwinder.h                           |   32 
 arch/sh/include/asm/user.h                               |   55 
 arch/sh/include/asm/vermagic.h                           |   30 
 arch/sh/include/asm/vga.h                                |    7 
 arch/sh/include/asm/vmalloc.h                            |    4 
 arch/sh/include/asm/vmlinux.lds.h                        |   18 
 arch/sh/include/asm/watchdog.h                           |  159 
 arch/sh/include/asm/word-at-a-time.h                     |   54 
 arch/sh/include/cpu-common/cpu/addrspace.h               |   16 
 arch/sh/include/cpu-common/cpu/mmu_context.h             |   13 
 arch/sh/include/cpu-common/cpu/pfc.h                     |   18 
 arch/sh/include/cpu-common/cpu/rtc.h                     |    9 
 arch/sh/include/cpu-common/cpu/sigcontext.h              |   18 
 arch/sh/include/cpu-common/cpu/timer.h                   |    7 
 arch/sh/include/cpu-sh2/cpu/cache.h                      |   40 
 arch/sh/include/cpu-sh2/cpu/freq.h                       |   15 
 arch/sh/include/cpu-sh2/cpu/watchdog.h                   |   66 
 arch/sh/include/cpu-sh2a/cpu/addrspace.h                 |   11 
 arch/sh/include/cpu-sh2a/cpu/cache.h                     |   40 
 arch/sh/include/cpu-sh2a/cpu/freq.h                      |   13 
 arch/sh/include/cpu-sh2a/cpu/rtc.h                       |    9 
 arch/sh/include/cpu-sh2a/cpu/sh7203.h                    |  144 
 arch/sh/include/cpu-sh2a/cpu/sh7264.h                    |  169 
 arch/sh/include/cpu-sh2a/cpu/sh7269.h                    |  213 -
 arch/sh/include/cpu-sh2a/cpu/watchdog.h                  |    2 
 arch/sh/include/cpu-sh3/cpu/adc.h                        |   29 
 arch/sh/include/cpu-sh3/cpu/cache.h                      |   40 
 arch/sh/include/cpu-sh3/cpu/dac.h                        |   42 
 arch/sh/include/cpu-sh3/cpu/dma-register.h               |   38 
 arch/sh/include/cpu-sh3/cpu/dma.h                        |   19 
 arch/sh/include/cpu-sh3/cpu/freq.h                       |   24 
 arch/sh/include/cpu-sh3/cpu/gpio.h                       |   78 
 arch/sh/include/cpu-sh3/cpu/mmu_context.h                |   42 
 arch/sh/include/cpu-sh3/cpu/serial.h                     |   11 
 arch/sh/include/cpu-sh3/cpu/sh7720.h                     |  175 
 arch/sh/include/cpu-sh3/cpu/watchdog.h                   |   22 
 arch/sh/include/cpu-sh4/cpu/addrspace.h                  |   41 
 arch/sh/include/cpu-sh4/cpu/cache.h                      |   41 
 arch/sh/include/cpu-sh4/cpu/dma-register.h               |   98 
 arch/sh/include/cpu-sh4/cpu/dma.h                        |   18 
 arch/sh/include/cpu-sh4/cpu/fpu.h                        |   30 
 arch/sh/include/cpu-sh4/cpu/freq.h                       |   74 
 arch/sh/include/cpu-sh4/cpu/mmu_context.h                |   79 
 arch/sh/include/cpu-sh4/cpu/rtc.h                        |   14 
 arch/sh/include/cpu-sh4/cpu/sh7722.h                     |  252 -
 arch/sh/include/cpu-sh4/cpu/sh7723.h                     |  285 -
 arch/sh/include/cpu-sh4/cpu/sh7724.h                     |  319 -
 arch/sh/include/cpu-sh4/cpu/sh7734.h                     |  307 -
 arch/sh/include/cpu-sh4/cpu/sh7757.h                     |  290 -
 arch/sh/include/cpu-sh4/cpu/sh7785.h                     |  260 -
 arch/sh/include/cpu-sh4/cpu/sh7786.h                     |  138 
 arch/sh/include/cpu-sh4/cpu/shx3.h                       |   65 
 arch/sh/include/cpu-sh4/cpu/sigcontext.h                 |   25 
 arch/sh/include/cpu-sh4/cpu/sq.h                         |   33 
 arch/sh/include/cpu-sh4/cpu/watchdog.h                   |   41 
 arch/sh/include/cpu-sh4a/cpu/dma.h                       |   72 
 arch/sh/include/cpu-sh4a/cpu/serial.h                    |    8 
 arch/sh/include/mach-common/mach/highlander.h            |  208 -
 arch/sh/include/mach-common/mach/hp6xx.h                 |   59 
 arch/sh/include/mach-common/mach/lboxre2.h               |   24 
 arch/sh/include/mach-common/mach/magicpanelr2.h          |   64 
 arch/sh/include/mach-common/mach/mangle-port.h           |   46 
 arch/sh/include/mach-common/mach/microdev.h              |   69 
 arch/sh/include/mach-common/mach/r2d.h                   |   71 
 arch/sh/include/mach-common/mach/romimage.h              |   12 
 arch/sh/include/mach-common/mach/sdk7780.h               |   79 
 arch/sh/include/mach-common/mach/secureedge5410.h        |   47 
 arch/sh/include/mach-common/mach/sh2007.h                |  118 
 arch/sh/include/mach-common/mach/sh7763rdp.h             |   50 
 arch/sh/include/mach-common/mach/sh7785lcr.h             |   58 
 arch/sh/include/mach-common/mach/shmin.h                 |   10 
 arch/sh/include/mach-common/mach/titan.h                 |   20 
 arch/sh/include/mach-common/mach/urquell.h               |   69 
 arch/sh/include/mach-dreamcast/mach/dma.h                |   29 
 arch/sh/include/mach-dreamcast/mach/maple.h              |   38 
 arch/sh/include/mach-dreamcast/mach/pci.h                |   24 
 arch/sh/include/mach-dreamcast/mach/sysasic.h            |   46 
 arch/sh/include/mach-ecovec24/mach/partner-jet-setup.txt |   82 
 arch/sh/include/mach-ecovec24/mach/romimage.h            |   48 
 arch/sh/include/mach-kfr2r09/mach/kfr2r09.h              |   24 
 arch/sh/include/mach-kfr2r09/mach/partner-jet-setup.txt  |  144 
 arch/sh/include/mach-kfr2r09/mach/romimage.h             |   31 
 arch/sh/include/mach-landisk/mach/gio.h                  |   38 
 arch/sh/include/mach-landisk/mach/iodata_landisk.h       |   46 
 arch/sh/include/mach-migor/mach/migor.h                  |   16 
 arch/sh/include/mach-sdk7786/mach/fpga.h                 |  156 
 arch/sh/include/mach-sdk7786/mach/irq.h                  |    8 
 arch/sh/include/mach-se/mach/mrshpc.h                    |   53 
 arch/sh/include/mach-se/mach/se.h                        |  120 
 arch/sh/include/mach-se/mach/se7206.h                    |   14 
 arch/sh/include/mach-se/mach/se7343.h                    |  143 
 arch/sh/include/mach-se/mach/se7721.h                    |   68 
 arch/sh/include/mach-se/mach/se7722.h                    |   98 
 arch/sh/include/mach-se/mach/se7724.h                    |   69 
 arch/sh/include/mach-se/mach/se7751.h                    |   75 
 arch/sh/include/mach-se/mach/se7780.h                    |  106 
 arch/sh/include/mach-sh03/mach/io.h                      |   26 
 arch/sh/include/mach-sh03/mach/sh03.h                    |   19 
 arch/sh/include/mach-x3proto/mach/hardware.h             |   13 
 arch/sh/include/mach-x3proto/mach/ilsel.h                |   46 
 arch/sh/include/uapi/asm/Kbuild                          |    4 
 arch/sh/include/uapi/asm/auxvec.h                        |   39 
 arch/sh/include/uapi/asm/byteorder.h                     |   11 
 arch/sh/include/uapi/asm/cachectl.h                      |   20 
 arch/sh/include/uapi/asm/cpu-features.h                  |   28 
 arch/sh/include/uapi/asm/hw_breakpoint.h                 |    5 
 arch/sh/include/uapi/asm/ioctls.h                        |  116 
 arch/sh/include/uapi/asm/posix_types.h                   |    2 
 arch/sh/include/uapi/asm/posix_types_32.h                |   23 
 arch/sh/include/uapi/asm/ptrace.h                        |   30 
 arch/sh/include/uapi/asm/ptrace_32.h                     |   78 
 arch/sh/include/uapi/asm/sigcontext.h                    |   25 
 arch/sh/include/uapi/asm/signal.h                        |   18 
 arch/sh/include/uapi/asm/sockios.h                       |   18 
 arch/sh/include/uapi/asm/stat.h                          |   78 
 arch/sh/include/uapi/asm/swab.h                          |   50 
 arch/sh/include/uapi/asm/unistd.h                        |    2 
 arch/sh/kernel/.gitignore                                |    2 
 arch/sh/kernel/Makefile                                  |   49 
 arch/sh/kernel/asm-offsets.c                             |   60 
 arch/sh/kernel/cpu/Makefile                              |   21 
 arch/sh/kernel/cpu/adc.c                                 |   37 
 arch/sh/kernel/cpu/clock-cpg.c                           |   78 
 arch/sh/kernel/cpu/clock.c                               |   52 
 arch/sh/kernel/cpu/fpu.c                                 |   92 
 arch/sh/kernel/cpu/init.c                                |  366 -
 arch/sh/kernel/cpu/irq/Makefile                          |    6 
 arch/sh/kernel/cpu/irq/imask.c                           |   85 
 arch/sh/kernel/cpu/irq/ipr.c                             |   80 
 arch/sh/kernel/cpu/pfc.c                                 |   25 
 arch/sh/kernel/cpu/proc.c                                |  151 
 arch/sh/kernel/cpu/sh2/Makefile                          |   12 
 arch/sh/kernel/cpu/sh2/clock-sh7619.c                    |   74 
 arch/sh/kernel/cpu/sh2/entry.S                           |  373 -
 arch/sh/kernel/cpu/sh2/ex.S                              |   44 
 arch/sh/kernel/cpu/sh2/probe.c                           |   71 
 arch/sh/kernel/cpu/sh2/setup-sh7619.c                    |  205 -
 arch/sh/kernel/cpu/sh2/smp-j2.c                          |  136 
 arch/sh/kernel/cpu/sh2a/Makefile                         |   25 
 arch/sh/kernel/cpu/sh2a/clock-sh7201.c                   |   82 
 arch/sh/kernel/cpu/sh2a/clock-sh7203.c                   |   78 
 arch/sh/kernel/cpu/sh2a/clock-sh7206.c                   |   80 
 arch/sh/kernel/cpu/sh2a/clock-sh7264.c                   |  157 
 arch/sh/kernel/cpu/sh2a/clock-sh7269.c                   |  181 
 arch/sh/kernel/cpu/sh2a/entry.S                          |  247 -
 arch/sh/kernel/cpu/sh2a/ex.S                             |   70 
 arch/sh/kernel/cpu/sh2a/fpu.c                            |  572 ---
 arch/sh/kernel/cpu/sh2a/opcode_helper.c                  |   51 
 arch/sh/kernel/cpu/sh2a/pinmux-sh7203.c                  |   27 
 arch/sh/kernel/cpu/sh2a/pinmux-sh7264.c                  |   27 
 arch/sh/kernel/cpu/sh2a/pinmux-sh7269.c                  |   28 
 arch/sh/kernel/cpu/sh2a/probe.c                          |   57 
 arch/sh/kernel/cpu/sh2a/setup-mxg.c                      |  175 
 arch/sh/kernel/cpu/sh2a/setup-sh7201.c                   |  418 --
 arch/sh/kernel/cpu/sh2a/setup-sh7203.c                   |  355 -
 arch/sh/kernel/cpu/sh2a/setup-sh7206.c                   |  291 -
 arch/sh/kernel/cpu/sh2a/setup-sh7264.c                   |  552 --
 arch/sh/kernel/cpu/sh2a/setup-sh7269.c                   |  568 --
 arch/sh/kernel/cpu/sh3/Makefile                          |   34 
 arch/sh/kernel/cpu/sh3/clock-sh3.c                       |   86 
 arch/sh/kernel/cpu/sh3/clock-sh7705.c                    |   81 
 arch/sh/kernel/cpu/sh3/clock-sh7706.c                    |   81 
 arch/sh/kernel/cpu/sh3/clock-sh7709.c                    |   82 
 arch/sh/kernel/cpu/sh3/clock-sh7710.c                    |   75 
 arch/sh/kernel/cpu/sh3/clock-sh7712.c                    |   68 
 arch/sh/kernel/cpu/sh3/entry.S                           |  509 --
 arch/sh/kernel/cpu/sh3/ex.S                              |   56 
 arch/sh/kernel/cpu/sh3/pinmux-sh7720.c                   |   27 
 arch/sh/kernel/cpu/sh3/probe.c                           |  108 
 arch/sh/kernel/cpu/sh3/serial-sh770x.c                   |   34 
 arch/sh/kernel/cpu/sh3/serial-sh7710.c                   |   21 
 arch/sh/kernel/cpu/sh3/serial-sh7720.c                   |   38 
 arch/sh/kernel/cpu/sh3/setup-sh3.c                       |   69 
 arch/sh/kernel/cpu/sh3/setup-sh7705.c                    |  190 
 arch/sh/kernel/cpu/sh3/setup-sh770x.c                    |  246 -
 arch/sh/kernel/cpu/sh3/setup-sh7710.c                    |  189 
 arch/sh/kernel/cpu/sh3/setup-sh7720.c                    |  286 -
 arch/sh/kernel/cpu/sh3/swsusp.S                          |  144 
 arch/sh/kernel/cpu/sh4/Makefile                          |   37 
 arch/sh/kernel/cpu/sh4/clock-sh4-202.c                   |  174 
 arch/sh/kernel/cpu/sh4/clock-sh4.c                       |   77 
 arch/sh/kernel/cpu/sh4/fpu.c                             |  425 --
 arch/sh/kernel/cpu/sh4/perf_event.c                      |  265 -
 arch/sh/kernel/cpu/sh4/probe.c                           |  260 -
 arch/sh/kernel/cpu/sh4/setup-sh4-202.c                   |  139 
 arch/sh/kernel/cpu/sh4/setup-sh7750.c                    |  359 -
 arch/sh/kernel/cpu/sh4/setup-sh7760.c                    |  297 -
 arch/sh/kernel/cpu/sh4/softfloat.c                       |  930 ----
 arch/sh/kernel/cpu/sh4/sq.c                              |  414 --
 arch/sh/kernel/cpu/sh4a/Makefile                         |   53 
 arch/sh/kernel/cpu/sh4a/clock-sh7343.c                   |  277 -
 arch/sh/kernel/cpu/sh4a/clock-sh7366.c                   |  270 -
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c                   |  253 -
 arch/sh/kernel/cpu/sh4a/clock-sh7723.c                   |  301 -
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c                   |  367 -
 arch/sh/kernel/cpu/sh4a/clock-sh7734.c                   |  256 -
 arch/sh/kernel/cpu/sh4a/clock-sh7757.c                   |  152 
 arch/sh/kernel/cpu/sh4a/clock-sh7763.c                   |  116 
 arch/sh/kernel/cpu/sh4a/clock-sh7770.c                   |   70 
 arch/sh/kernel/cpu/sh4a/clock-sh7780.c                   |  122 
 arch/sh/kernel/cpu/sh4a/clock-sh7785.c                   |  174 
 arch/sh/kernel/cpu/sh4a/clock-sh7786.c                   |  189 
 arch/sh/kernel/cpu/sh4a/clock-shx3.c                     |  148 
 arch/sh/kernel/cpu/sh4a/intc-shx3.c                      |   31 
 arch/sh/kernel/cpu/sh4a/perf_event.c                     |  299 -
 arch/sh/kernel/cpu/sh4a/pinmux-sh7722.c                  |   21 
 arch/sh/kernel/cpu/sh4a/pinmux-sh7723.c                  |   27 
 arch/sh/kernel/cpu/sh4a/pinmux-sh7724.c                  |   32 
 arch/sh/kernel/cpu/sh4a/pinmux-sh7734.c                  |   32 
 arch/sh/kernel/cpu/sh4a/pinmux-sh7757.c                  |   32 
 arch/sh/kernel/cpu/sh4a/pinmux-sh7785.c                  |   27 
 arch/sh/kernel/cpu/sh4a/pinmux-sh7786.c                  |   32 
 arch/sh/kernel/cpu/sh4a/pinmux-shx3.c                    |   26 
 arch/sh/kernel/cpu/sh4a/serial-sh7722.c                  |   24 
 arch/sh/kernel/cpu/sh4a/setup-sh7343.c                   |  444 --
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c                   |  388 --
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c                   |  666 ---
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c                   |  644 ---
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c                   | 1288 ------
 arch/sh/kernel/cpu/sh4a/setup-sh7734.c                   |  621 ---
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c                   | 1242 ------
 arch/sh/kernel/cpu/sh4a/setup-sh7763.c                   |  455 --
 arch/sh/kernel/cpu/sh4a/setup-sh7770.c                   |  571 ---
 arch/sh/kernel/cpu/sh4a/setup-sh7780.c                   |  505 --
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c                   |  608 ---
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c                   |  841 ----
 arch/sh/kernel/cpu/sh4a/setup-shx3.c                     |  396 --
 arch/sh/kernel/cpu/sh4a/smp-shx3.c                       |  146 
 arch/sh/kernel/cpu/sh4a/ubc.c                            |  130 
 arch/sh/kernel/cpu/shmobile/Makefile                     |    8 
 arch/sh/kernel/cpu/shmobile/cpuidle.c                    |   95 
 arch/sh/kernel/cpu/shmobile/pm.c                         |  153 
 arch/sh/kernel/cpu/shmobile/sleep.S                      |  402 --
 arch/sh/kernel/crash_dump.c                              |   27 
 arch/sh/kernel/debugtraps.S                              |   38 
 arch/sh/kernel/disassemble.c                             |  572 ---
 arch/sh/kernel/dma-coherent.c                            |   33 
 arch/sh/kernel/dumpstack.c                               |  156 
 arch/sh/kernel/dwarf.c                                   | 1206 ------
 arch/sh/kernel/entry-common.S                            |  400 --
 arch/sh/kernel/ftrace.c                                  |  365 -
 arch/sh/kernel/head_32.S                                 |  365 -
 arch/sh/kernel/hw_breakpoint.c                           |  408 --
 arch/sh/kernel/idle.c                                    |   57 
 arch/sh/kernel/io.c                                      |  111 
 arch/sh/kernel/io_trapped.c                              |  291 -
 arch/sh/kernel/iomap.c                                   |  162 
 arch/sh/kernel/ioport.c                                  |   41 
 arch/sh/kernel/irq.c                                     |  249 -
 arch/sh/kernel/irq_32.c                                  |   54 
 arch/sh/kernel/kdebugfs.c                                |   14 
 arch/sh/kernel/kgdb.c                                    |  378 -
 arch/sh/kernel/kprobes.c                                 |  452 --
 arch/sh/kernel/machine_kexec.c                           |  204 -
 arch/sh/kernel/machvec.c                                 |  122 
 arch/sh/kernel/module.c                                  |  104 
 arch/sh/kernel/nmi_debug.c                               |   75 
 arch/sh/kernel/perf_callchain.c                          |   32 
 arch/sh/kernel/perf_event.c                              |  363 -
 arch/sh/kernel/process.c                                 |   77 
 arch/sh/kernel/process_32.c                              |  197 -
 arch/sh/kernel/ptrace.c                                  |   34 
 arch/sh/kernel/ptrace_32.c                               |  487 --
 arch/sh/kernel/reboot.c                                  |   96 
 arch/sh/kernel/relocate_kernel.S                         |  230 -
 arch/sh/kernel/return_address.c                          |   56 
 arch/sh/kernel/setup.c                                   |  356 -
 arch/sh/kernel/sh_bios.c                                 |  169 
 arch/sh/kernel/sh_ksyms_32.c                             |  118 
 arch/sh/kernel/signal_32.c                               |  507 --
 arch/sh/kernel/smp.c                                     |  471 --
 arch/sh/kernel/stacktrace.c                              |   79 
 arch/sh/kernel/swsusp.c                                  |   35 
 arch/sh/kernel/sys_sh.c                                  |   96 
 arch/sh/kernel/sys_sh32.c                                |   61 
 arch/sh/kernel/syscalls/Makefile                         |   32 
 arch/sh/kernel/syscalls/syscall.tbl                      |  455 --
 arch/sh/kernel/syscalls_32.S                             |   17 
 arch/sh/kernel/time.c                                    |   45 
 arch/sh/kernel/topology.c                                |   74 
 arch/sh/kernel/traps.c                                   |  204 -
 arch/sh/kernel/traps_32.c                                |  795 ----
 arch/sh/kernel/unwinder.c                                |  165 
 arch/sh/kernel/vmlinux.lds.S                             |   82 
 arch/sh/kernel/vsyscall/.gitignore                       |    2 
 arch/sh/kernel/vsyscall/Makefile                         |   36 
 arch/sh/kernel/vsyscall/vsyscall-note.S                  |   26 
 arch/sh/kernel/vsyscall/vsyscall-sigreturn.S             |   75 
 arch/sh/kernel/vsyscall/vsyscall-syscall.S               |   11 
 arch/sh/kernel/vsyscall/vsyscall-trapa.S                 |   40 
 arch/sh/kernel/vsyscall/vsyscall.c                       |   93 
 arch/sh/kernel/vsyscall/vsyscall.lds.S                   |   85 
 arch/sh/lib/Makefile                                     |   32 
 arch/sh/lib/__clear_user.S                               |  109 
 arch/sh/lib/ashiftrt.S                                   |  128 
 arch/sh/lib/ashldi3.c                                    |   30 
 arch/sh/lib/ashlsi3.S                                    |  189 
 arch/sh/lib/ashrdi3.c                                    |   32 
 arch/sh/lib/ashrsi3.S                                    |  179 
 arch/sh/lib/checksum.S                                   |  365 -
 arch/sh/lib/copy_page.S                                  |  390 --
 arch/sh/lib/delay.c                                      |   54 
 arch/sh/lib/div64-generic.c                              |   20 
 arch/sh/lib/div64.S                                      |   47 
 arch/sh/lib/io.c                                         |   79 
 arch/sh/lib/libgcc.h                                     |   27 
 arch/sh/lib/lshrdi3.c                                    |   30 
 arch/sh/lib/lshrsi3.S                                    |  188 
 arch/sh/lib/mcount.S                                     |  287 -
 arch/sh/lib/memchr.S                                     |   27 
 arch/sh/lib/memcpy-sh4.S                                 |  800 ----
 arch/sh/lib/memcpy.S                                     |  228 -
 arch/sh/lib/memmove.S                                    |  255 -
 arch/sh/lib/memset-sh4.S                                 |  108 
 arch/sh/lib/memset.S                                     |   59 
 arch/sh/lib/movmem.S                                     |  217 -
 arch/sh/lib/strlen.S                                     |   71 
 arch/sh/lib/udiv_qrnnd.S                                 |   60 
 arch/sh/lib/udivsi3.S                                    |   66 
 arch/sh/lib/udivsi3_i4i-Os.S                             |  128 
 arch/sh/lib/udivsi3_i4i.S                                |  645 ---
 arch/sh/math-emu/Makefile                                |    2 
 arch/sh/math-emu/math.c                                  |  506 --
 arch/sh/math-emu/sfp-util.h                              |   73 
 arch/sh/mm/Kconfig                                       |  254 -
 arch/sh/mm/Makefile                                      |   45 
 arch/sh/mm/alignment.c                                   |  189 
 arch/sh/mm/asids-debugfs.c                               |   59 
 arch/sh/mm/cache-debugfs.c                               |  109 
 arch/sh/mm/cache-j2.c                                    |   64 
 arch/sh/mm/cache-sh2.c                                   |   90 
 arch/sh/mm/cache-sh2a.c                                  |  188 
 arch/sh/mm/cache-sh3.c                                   |  102 
 arch/sh/mm/cache-sh4.c                                   |  390 --
 arch/sh/mm/cache-sh7705.c                                |  194 -
 arch/sh/mm/cache-shx3.c                                  |   44 
 arch/sh/mm/cache.c                                       |  360 -
 arch/sh/mm/consistent.c                                  |   65 
 arch/sh/mm/extable_32.c                                  |   24 
 arch/sh/mm/fault.c                                       |  504 --
 arch/sh/mm/flush-sh4.c                                   |  111 
 arch/sh/mm/hugetlbpage.c                                 |   82 
 arch/sh/mm/init.c                                        |  424 --
 arch/sh/mm/ioremap.c                                     |  192 -
 arch/sh/mm/ioremap.h                                     |   23 
 arch/sh/mm/ioremap_fixed.c                               |  135 
 arch/sh/mm/kmap.c                                        |   65 
 arch/sh/mm/mmap.c                                        |  184 
 arch/sh/mm/nommu.c                                       |   98 
 arch/sh/mm/numa.c                                        |   56 
 arch/sh/mm/pgtable.c                                     |   57 
 arch/sh/mm/pmb.c                                         |  887 ----
 arch/sh/mm/sram.c                                        |   35 
 arch/sh/mm/tlb-debugfs.c                                 |  160 
 arch/sh/mm/tlb-pteaex.c                                  |  106 
 arch/sh/mm/tlb-sh3.c                                     |   95 
 arch/sh/mm/tlb-sh4.c                                     |  108 
 arch/sh/mm/tlb-urb.c                                     |   93 
 arch/sh/mm/tlbex_32.c                                    |   82 
 arch/sh/mm/tlbflush_32.c                                 |  137 
 arch/sh/mm/uncached.c                                    |   44 
 arch/sh/tools/Makefile                                   |   16 
 arch/sh/tools/gen-mach-types                             |   48 
 arch/sh/tools/mach-types                                 |   67 
 b/Documentation/arch.rst                                 |    1 
 b/Documentation/watchdog/watchdog-parameters.rst         |   12 
 b/MAINTAINERS                                            |   10 
 b/drivers/Makefile                                       |    1 
 b/drivers/base/platform.c                                |    4 
 b/drivers/clocksource/sh_cmt.c                           |   16 
 b/drivers/clocksource/sh_mtu2.c                          |   16 
 b/drivers/clocksource/sh_tmu.c                           |   17 
 b/drivers/cpufreq/Kconfig                                |   14 
 b/drivers/cpufreq/Makefile                               |    1 
 b/drivers/dma/sh/Kconfig                                 |   20 
 b/drivers/dma/sh/Makefile                                |   13 
 b/drivers/gpu/drm/Kconfig                                |    2 
 b/drivers/gpu/drm/Makefile                               |    1 
 b/drivers/i2c/busses/Kconfig                             |   13 
 b/drivers/i2c/busses/Makefile                            |    1 
 b/drivers/input/keyboard/Kconfig                         |   10 
 b/drivers/input/keyboard/Makefile                        |    1 
 b/drivers/media/platform/renesas/Kconfig                 |   11 
 b/drivers/media/platform/renesas/Makefile                |    1 
 b/drivers/mmc/host/Kconfig                               |    6 
 b/drivers/mmc/host/sh_mmcif.c                            |   21 
 b/drivers/mtd/nand/raw/Kconfig                           |    8 
 b/drivers/mtd/nand/raw/Makefile                          |    1 
 b/drivers/net/ethernet/8390/Kconfig                      |   14 
 b/drivers/net/ethernet/8390/Makefile                     |    1 
 b/drivers/net/ethernet/renesas/Kconfig                   |    2 
 b/drivers/net/ethernet/smsc/Kconfig                      |    4 
 b/drivers/pinctrl/renesas/Kconfig                        |   63 
 b/drivers/pinctrl/renesas/Makefile                       |   27 
 b/drivers/pinctrl/renesas/core.c                         |  598 ---
 b/drivers/rtc/Kconfig                                    |    4 
 b/drivers/rtc/rtc-sh.c                                   |   18 
 b/drivers/spi/Kconfig                                    |   24 
 b/drivers/spi/Makefile                                   |    3 
 b/drivers/tty/serial/Kconfig                             |    3 
 b/drivers/tty/serial/sh-sci.c                            |   57 
 b/drivers/tty/vt/keyboard.c                              |    2 
 b/drivers/usb/host/Kconfig                               |   18 
 b/drivers/usb/host/ehci-hcd.c                            |    7 
 b/drivers/usb/renesas_usbhs/Kconfig                      |    2 
 b/drivers/video/console/Kconfig                          |    2 
 b/drivers/video/fbdev/Kconfig                            |   17 
 b/drivers/video/fbdev/Makefile                           |    1 
 b/drivers/video/logo/Kconfig                             |   15 
 b/drivers/video/logo/Makefile                            |    3 
 b/drivers/video/logo/logo.c                              |   12 
 b/drivers/watchdog/Kconfig                               |   20 
 b/drivers/watchdog/Makefile                              |    3 
 b/fs/Kconfig.binfmt                                      |    2 
 b/fs/minix/Kconfig                                       |    2 
 b/include/linux/cpuhotplug.h                             |    1 
 b/include/linux/platform_device.h                        |   15 
 b/include/linux/sh_intc.h                                |    4 
 b/include/linux/shdma-base.h                             |    4 
 b/init/Kconfig                                           |    2 
 b/kernel/sysctl.c                                        |    3 
 b/lib/Kconfig.debug                                      |    2 
 b/lib/math/div64.c                                       |    4 
 b/lib/test_user_copy.c                                   |    3 
 b/scripts/coccinelle/misc/cond_no_effect.cocci           |   13 
 b/scripts/head-object-list.txt                           |    1 
 b/sound/Kconfig                                          |    2 
 b/sound/Makefile                                         |    2 
 b/sound/soc/sh/Kconfig                                   |   48 
 b/sound/soc/sh/Makefile                                  |   16 
 b/sound/soc/sh/fsi.c                                     |    9 
 b/tools/include/asm/barrier.h                            |    2 
 b/tools/perf/util/dwarf-regs.c                           |    1 
 drivers/cpufreq/sh-cpufreq.c                             |  175 
 drivers/dma/sh/shdma-base.c                              | 1052 -----
 drivers/dma/sh/shdma.h                                   |   61 
 drivers/dma/sh/shdmac.c                                  |  938 ----
 drivers/gpu/drm/shmobile/Kconfig                         |   12 
 drivers/gpu/drm/shmobile/Makefile                        |    8 
 drivers/gpu/drm/shmobile/shmob_drm_backlight.c           |   82 
 drivers/gpu/drm/shmobile/shmob_drm_backlight.h           |   19 
 drivers/gpu/drm/shmobile/shmob_drm_crtc.c                |  683 ---
 drivers/gpu/drm/shmobile/shmob_drm_crtc.h                |   55 
 drivers/gpu/drm/shmobile/shmob_drm_drv.c                 |  303 -
 drivers/gpu/drm/shmobile/shmob_drm_drv.h                 |   42 
 drivers/gpu/drm/shmobile/shmob_drm_kms.c                 |  150 
 drivers/gpu/drm/shmobile/shmob_drm_kms.h                 |   29 
 drivers/gpu/drm/shmobile/shmob_drm_plane.c               |  261 -
 drivers/gpu/drm/shmobile/shmob_drm_plane.h               |   19 
 drivers/gpu/drm/shmobile/shmob_drm_regs.h                |  310 -
 drivers/i2c/busses/i2c-sh7760.c                          |  565 --
 drivers/input/keyboard/sh_keysc.c                        |  334 -
 drivers/media/platform/renesas/sh_vou.c                  | 1375 -------
 drivers/mtd/nand/raw/sh_flctl.c                          | 1234 ------
 drivers/net/ethernet/8390/stnic.c                        |  302 -
 drivers/pinctrl/renesas/pfc-sh7203.c                     | 1577 --------
 drivers/pinctrl/renesas/pfc-sh7264.c                     | 2131 -----------
 drivers/pinctrl/renesas/pfc-sh7269.c                     | 2851 ---------------
 drivers/pinctrl/renesas/pfc-sh7720.c                     | 1201 ------
 drivers/pinctrl/renesas/pfc-sh7722.c                     | 1703 --------
 drivers/pinctrl/renesas/pfc-sh7723.c                     | 1902 ----------
 drivers/pinctrl/renesas/pfc-sh7724.c                     | 2177 -----------
 drivers/pinctrl/renesas/pfc-sh7734.c                     | 2408 ------------
 drivers/pinctrl/renesas/pfc-sh7757.c                     | 2219 -----------
 drivers/pinctrl/renesas/pfc-sh7785.c                     | 1258 ------
 drivers/pinctrl/renesas/pfc-sh7786.c                     |  809 ----
 drivers/pinctrl/renesas/pfc-shx3.c                       |  557 --
 drivers/sh/Kconfig                                       |    6 
 drivers/sh/Makefile                                      |   12 
 drivers/sh/clk/Makefile                                  |    4 
 drivers/sh/clk/core.c                                    |  624 ---
 drivers/sh/clk/cpg.c                                     |  477 --
 drivers/sh/intc/Kconfig                                  |   44 
 drivers/sh/intc/Makefile                                 |    6 
 drivers/sh/intc/access.c                                 |  246 -
 drivers/sh/intc/balancing.c                              |   97 
 drivers/sh/intc/chip.c                                   |  211 -
 drivers/sh/intc/core.c                                   |  501 --
 drivers/sh/intc/handle.c                                 |  306 -
 drivers/sh/intc/internals.h                              |  191 -
 drivers/sh/intc/irqdomain.c                              |   68 
 drivers/sh/intc/userimask.c                              |   84 
 drivers/sh/intc/virq-debugfs.c                           |   54 
 drivers/sh/intc/virq.c                                   |  269 -
 drivers/sh/maple/Makefile                                |    4 
 drivers/sh/maple/maple.c                                 |  895 ----
 drivers/sh/pm_runtime.c                                  |   40 
 drivers/sh/superhyway/Makefile                           |    8 
 drivers/sh/superhyway/superhyway-sysfs.c                 |   54 
 drivers/sh/superhyway/superhyway.c                       |  234 -
 drivers/spi/spi-jcore.c                                  |  235 -
 drivers/spi/spi-sh-sci.c                                 |  197 -
 drivers/spi/spi-sh.c                                     |  474 --
 drivers/usb/host/ehci-sh.c                               |  182 
 drivers/video/fbdev/sh7760fb.c                           |  587 ---
 drivers/video/logo/logo_superh_clut224.ppm               | 1604 --------
 drivers/video/logo/logo_superh_vga16.ppm                 | 1604 --------
 drivers/watchdog/shwdt.c                                 |  344 -
 include/linux/mtd/sh_flctl.h                             |  180 
 include/linux/sh_clk.h                                   |  213 -
 include/linux/superhyway.h                               |  107 
 sound/sh/Kconfig                                         |   32 
 sound/sh/Makefile                                        |   11 
 sound/sh/aica.c                                          |  628 ---
 sound/sh/aica.h                                          |   68 
 sound/sh/sh_dac_audio.c                                  |  412 --
 sound/soc/sh/dma-sh7760.c                                |  334 -
 sound/soc/sh/hac.c                                       |  345 -
 sound/soc/sh/migor.c                                     |  205 -
 sound/soc/sh/sh7760-ac97.c                               |   72 
 sound/soc/sh/siu.h                                       |  180 
 sound/soc/sh/siu_dai.c                                   |  799 ----
 sound/soc/sh/siu_pcm.c                                   |  553 --
 sound/soc/sh/ssi.c                                       |  403 --
 896 files changed, 46 insertions(+), 138518 deletions(-)
