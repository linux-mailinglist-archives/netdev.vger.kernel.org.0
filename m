Return-Path: <netdev+bounces-9625-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 504D272A0AB
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:53:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6334281935
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:53:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B85BB1B8EE;
	Fri,  9 Jun 2023 16:53:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A714519E52
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:53:47 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634B33A89;
	Fri,  9 Jun 2023 09:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686329625; x=1717865625;
  h=date:from:to:cc:subject:message-id;
  bh=JAWK//mHu4QV1YFotj0qDhrypark3wKg/MHiFxQrmtg=;
  b=XwvPQHKILVD4RYNyEJ8XWRQzulDT2sXEhgxwZoLAPsx3l2/AdMEoAle0
   bi9nzbPgcTC2IBxX8u4rGWupq2ICimNIMJEwf8ZSRD9tKQsP4jd5xj2qE
   IeaXQY4eB++Cm91sCsJqdSFa7GM7Wod3KCmt8mgQm9RSRGighRbsWUs1v
   EGiSEciqrqcNjVSoAfnYEmSPmKxiA4TXbKLrhrPhURagOj4g51OcVHMNu
   Z9ZUYcbK7cJDMIhcRhldeNnN+t4BRAhM48CRLfLsxBrLn79TsJ0YN2FPY
   LE0UcZFnrjtty/+EQNoBMZwxQKzjJ+dVnP0YQRW/xcprA9uRWRzf6mTWp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="338000296"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="338000296"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 09:53:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="957215847"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="957215847"
Received: from lkp-server01.sh.intel.com (HELO 15ab08e44a81) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 09 Jun 2023 09:53:37 -0700
Received: from kbuild by 15ab08e44a81 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q7fMm-0009Eo-0m;
	Fri, 09 Jun 2023 16:53:36 +0000
Date: Sat, 10 Jun 2023 00:53:06 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 linux-btrfs@vger.kernel.org, linux-leds@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: [linux-next:master] BUILD REGRESSION
 53ab6975c12d1ad86c599a8927e8c698b144d669
Message-ID: <202306100045.iM5qbyCz-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 53ab6975c12d1ad86c599a8927e8c698b144d669  Add linux-next specific files for 20230609

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202306081708.gtVAcXsh-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202306082341.UQtCM8PO-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202306100035.VTusNhm4-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202306100056.Z3G9GUfT-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

drivers/gpu/drm/i915/pxp/intel_pxp_gsccs.c:113:17: warning: format specifies type 'long' but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
drivers/gpu/drm/i915/pxp/intel_pxp_gsccs.c:147:17: warning: format specifies type 'long' but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
drivers/leds/leds-cht-wcove.c:144:21: warning: no previous prototype for 'cht_wc_leds_brightness_get' [-Wmissing-prototypes]
drivers/scsi/FlashPoint.c:1712:12: warning: stack frame size (1056) exceeds limit (1024) in 'FlashPoint_HandleInterrupt' [-Wframe-larger-than]
include/drm/drm_print.h:456:39: error: format '%ld' expects argument of type 'long int', but argument 4 has type 'size_t' {aka 'unsigned int'} [-Werror=format=]
include/drm/drm_print.h:456:39: warning: format '%ld' expects argument of type 'long int', but argument 4 has type 'size_t' {aka 'unsigned int'} [-Wformat=]
uvdevice.c:(.init.text+0x2e): undefined reference to `uv_info'

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/net/ethernet/emulex/benet/be_main.c:2460 be_rx_compl_process_gro() error: buffer overflow '((skb_end_pointer(skb)))->frags' 17 <= u16max
drivers/usb/cdns3/cdns3-starfive.c:23: warning: expecting prototype for cdns3(). Prototype was for USB_STRAP_HOST() instead
fs/btrfs/volumes.c:6407 btrfs_map_block() error: we previously assumed 'mirror_num_ret' could be null (see line 6245)
kernel/events/uprobes.c:478 uprobe_write_opcode() warn: passing zero to 'PTR_ERR'

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- i386-allyesconfig
|   |-- drivers-leds-leds-cht-wcove.c:warning:no-previous-prototype-for-cht_wc_leds_brightness_get
|   `-- include-drm-drm_print.h:error:format-ld-expects-argument-of-type-long-int-but-argument-has-type-size_t-aka-unsigned-int
|-- i386-randconfig-i004-20230608
|   `-- include-drm-drm_print.h:error:format-ld-expects-argument-of-type-long-int-but-argument-has-type-size_t-aka-unsigned-int
|-- i386-randconfig-i062-20230608
|   `-- include-drm-drm_print.h:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-size_t-aka-unsigned-int
|-- riscv-allmodconfig
|   `-- drivers-usb-cdns3-cdns3-starfive.c:warning:expecting-prototype-for-cdns3().-Prototype-was-for-USB_STRAP_HOST()-instead
|-- riscv-allyesconfig
|   `-- drivers-usb-cdns3-cdns3-starfive.c:warning:expecting-prototype-for-cdns3().-Prototype-was-for-USB_STRAP_HOST()-instead
|-- s390-randconfig-r044-20230609
|   `-- uvdevice.c:(.init.text):undefined-reference-to-uv_info
|-- x86_64-allyesconfig
|   `-- drivers-leds-leds-cht-wcove.c:warning:no-previous-prototype-for-cht_wc_leds_brightness_get
`-- x86_64-randconfig-m001-20230608
    |-- drivers-net-ethernet-emulex-benet-be_main.c-be_rx_compl_process_gro()-error:buffer-overflow-((skb_end_pointer(skb)))-frags-u16max
    |-- fs-btrfs-volumes.c-btrfs_map_block()-error:we-previously-assumed-mirror_num_ret-could-be-null-(see-line-)
    `-- kernel-events-uprobes.c-uprobe_write_opcode()-warn:passing-zero-to-PTR_ERR
clang_recent_errors
|-- i386-randconfig-i014-20230608
|   `-- drivers-gpu-drm-i915-pxp-intel_pxp_gsccs.c:warning:format-specifies-type-long-but-the-argument-has-type-size_t-(aka-unsigned-int-)
|-- i386-randconfig-r026-20230608
|   `-- drivers-gpu-drm-i915-pxp-intel_pxp_gsccs.c:warning:format-specifies-type-long-but-the-argument-has-type-size_t-(aka-unsigned-int-)
`-- powerpc-allmodconfig
    `-- drivers-scsi-FlashPoint.c:warning:stack-frame-size-()-exceeds-limit-()-in-FlashPoint_HandleInterrupt

elapsed time: 729m

configs tested: 149
configs skipped: 6

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                         haps_hs_defconfig   gcc  
arc                  randconfig-r011-20230608   gcc  
arc                  randconfig-r033-20230608   gcc  
arc                  randconfig-r043-20230608   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                       aspeed_g4_defconfig   clang
arm                                 defconfig   gcc  
arm                      footbridge_defconfig   gcc  
arm                            hisi_defconfig   gcc  
arm                           imxrt_defconfig   gcc  
arm                  randconfig-r006-20230608   clang
arm                  randconfig-r046-20230608   gcc  
arm                        spear6xx_defconfig   gcc  
arm                           stm32_defconfig   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r024-20230608   clang
csky                                defconfig   gcc  
hexagon      buildonly-randconfig-r001-20230608   clang
hexagon              randconfig-r041-20230608   clang
hexagon              randconfig-r045-20230608   clang
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-r006-20230608   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-i001-20230608   gcc  
i386                 randconfig-i002-20230608   gcc  
i386                 randconfig-i003-20230608   gcc  
i386                 randconfig-i004-20230608   gcc  
i386                 randconfig-i005-20230608   gcc  
i386                 randconfig-i006-20230608   gcc  
i386                 randconfig-i011-20230608   clang
i386                 randconfig-i012-20230608   clang
i386                 randconfig-i013-20230608   clang
i386                 randconfig-i014-20230608   clang
i386                 randconfig-i015-20230608   clang
i386                 randconfig-i016-20230608   clang
i386                 randconfig-i051-20230608   gcc  
i386                 randconfig-i052-20230608   gcc  
i386                 randconfig-i053-20230608   gcc  
i386                 randconfig-i054-20230608   gcc  
i386                 randconfig-i055-20230608   gcc  
i386                 randconfig-i061-20230608   gcc  
i386                 randconfig-i062-20230608   gcc  
i386                 randconfig-i063-20230608   gcc  
i386                 randconfig-i064-20230608   gcc  
i386                 randconfig-i065-20230608   gcc  
i386                 randconfig-i066-20230608   gcc  
i386                 randconfig-r023-20230608   clang
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch                 loongson3_defconfig   gcc  
loongarch            randconfig-r004-20230608   gcc  
loongarch            randconfig-r025-20230608   gcc  
m68k                             allmodconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                          atari_defconfig   gcc  
m68k                       bvme6000_defconfig   gcc  
m68k                                defconfig   gcc  
m68k                        mvme16x_defconfig   gcc  
microblaze           randconfig-r034-20230608   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                          ath79_defconfig   clang
mips                     cu1000-neo_defconfig   clang
mips                          malta_defconfig   clang
mips                      malta_kvm_defconfig   clang
mips                        maltaup_defconfig   clang
mips                           rs90_defconfig   clang
nios2                               defconfig   gcc  
openrisc             randconfig-r015-20230608   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r016-20230608   gcc  
parisc64                            defconfig   gcc  
powerpc                      acadia_defconfig   clang
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                     asp8347_defconfig   gcc  
powerpc                        cell_defconfig   gcc  
powerpc                     ep8248e_defconfig   gcc  
powerpc                        fsp2_defconfig   clang
powerpc                    gamecube_defconfig   clang
powerpc                     ksi8560_defconfig   clang
powerpc                 mpc8560_ads_defconfig   clang
powerpc              randconfig-r012-20230608   clang
powerpc              randconfig-r021-20230608   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r032-20230608   gcc  
riscv                randconfig-r036-20230608   gcc  
riscv                randconfig-r042-20230608   clang
riscv                          rv32_defconfig   gcc  
s390                             alldefconfig   clang
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390         buildonly-randconfig-r005-20230608   clang
s390                                defconfig   gcc  
s390                 randconfig-r013-20230608   clang
s390                 randconfig-r014-20230608   clang
s390                 randconfig-r044-20230608   clang
sh                               allmodconfig   gcc  
sh           buildonly-randconfig-r003-20230608   gcc  
sh                          kfr2r09_defconfig   gcc  
sh                         microdev_defconfig   gcc  
sh                     sh7710voipgw_defconfig   gcc  
sparc                            allyesconfig   gcc  
sparc        buildonly-randconfig-r002-20230608   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r005-20230608   gcc  
sparc                randconfig-r031-20230608   gcc  
sparc                randconfig-r035-20230608   gcc  
sparc64              randconfig-r001-20230608   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64       buildonly-randconfig-r004-20230608   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230608   gcc  
x86_64               randconfig-a002-20230608   gcc  
x86_64               randconfig-a003-20230608   gcc  
x86_64               randconfig-a004-20230608   gcc  
x86_64               randconfig-a005-20230608   gcc  
x86_64               randconfig-a006-20230608   gcc  
x86_64               randconfig-a011-20230608   clang
x86_64               randconfig-a012-20230608   clang
x86_64               randconfig-a013-20230608   clang
x86_64               randconfig-a014-20230608   clang
x86_64               randconfig-a015-20230608   clang
x86_64               randconfig-a016-20230608   clang
x86_64               randconfig-x051-20230608   clang
x86_64               randconfig-x052-20230608   clang
x86_64               randconfig-x053-20230608   clang
x86_64               randconfig-x054-20230608   clang
x86_64               randconfig-x055-20230608   clang
x86_64               randconfig-x056-20230608   clang
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa                           alldefconfig   gcc  
xtensa                generic_kc705_defconfig   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

