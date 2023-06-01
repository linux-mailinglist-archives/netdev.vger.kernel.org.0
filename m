Return-Path: <netdev+bounces-7203-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A72FF71F0D1
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:32:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CCE01C210B2
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0466A47012;
	Thu,  1 Jun 2023 17:32:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F934700C
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:32:18 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABC6D1;
	Thu,  1 Jun 2023 10:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685640736; x=1717176736;
  h=date:from:to:cc:subject:message-id;
  bh=PwsoXWiLBDAbQJFI4tD6NtsrJe7S2Evx4gR71sHvmOw=;
  b=SyHE0gWlhbs/Uoa0obaOmw6eFiONuoaOgi7rGSb/0WmYJOqC/ZDK4XOf
   tLVrKDTw6Y1+ArS1WaWOSifNyOjtEJaC8BsT6Au0S/8NewnrpQIBI2x08
   5YGBx27C/4suo48o9WmqEaH3+KHhI67zFtlFjqDT7SWfZDxylWYisQCO3
   xrb0A613OpvJNWUaGD7VJ6RFGchC3NOq/ddEdyXJccRHYy5/W1fF/eYwV
   /CuILvyl8oUJQagKabYF/Z5dIr7ViTMIV8wOy7slStwz2D8TT3wY9PoWj
   iIN58X2eFWXdc2KwBSG69TOeHZPcGxKkuFAnj85E5C/4oMJxsY0pw6s0H
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="335251261"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="335251261"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 10:31:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="740441477"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="740441477"
Received: from lkp-server01.sh.intel.com (HELO fb1ced2c09fb) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 01 Jun 2023 10:31:34 -0700
Received: from kbuild by fb1ced2c09fb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q4m97-0002XC-0h;
	Thu, 01 Jun 2023 17:31:33 +0000
Date: Fri, 02 Jun 2023 01:30:59 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-cifs@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-usb@vger.kernel.org, linux-xfs@vger.kernel.org,
 netdev@vger.kernel.org, samba-technical@lists.samba.org
Subject: [linux-next:master] BUILD REGRESSION
 571d71e886a5edc89b4ea6d0fe6f445282938320
Message-ID: <20230601173059.4lk2w%lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 571d71e886a5edc89b4ea6d0fe6f445282938320  Add linux-next specific files for 20230601

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202305230552.WOByQyYa-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202305311652.OP9x8xkW-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202306010248.g3ZqQg4W-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202306011356.MNtU7Q9Z-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202306011435.2BxsHFUE-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202306011753.7eXAmz0M-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202306011915.bWdy8AJ8-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

drivers/net/dsa/qca/qca8k-leds.c:377:31: error: 'struct led_classdev' has no member named 'hw_control_is_supported'
drivers/net/dsa/qca/qca8k-leds.c:378:31: error: 'struct led_classdev' has no member named 'hw_control_set'
drivers/net/dsa/qca/qca8k-leds.c:379:31: error: 'struct led_classdev' has no member named 'hw_control_get'
drivers/net/dsa/qca/qca8k-leds.c:380:31: error: 'struct led_classdev' has no member named 'hw_control_trigger'
drivers/net/dsa/qca/qca8k-leds.c:406:18: error: no member named 'hw_control_get_device' in 'struct led_classdev'
drivers/net/dsa/qca/qca8k-leds.c:406:31: error: 'struct led_classdev' has no member named 'hw_control_get_device'
include/drm/drm_print.h:456:39: error: format '%ld' expects argument of type 'long int', but argument 4 has type 'size_t' {aka 'unsigned int'} [-Werror=format=]
include/linux/usb/typec_mux.h:76:33: warning: 'fwnode_typec_mux_get' used but never defined
include/linux/usb/typec_mux.h:77:1: error: expected identifier or '('
include/linux/usb/typec_mux.h:77:1: error: expected identifier or '(' before '{' token
mm/zswap.c:1183:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]

Unverified Error/Warning (likely false positive, please contact us if interested):

arch/arm64/kvm/mmu.c:147:3-9: preceding lock on line 140
fs/smb/client/cifsfs.c:982 cifs_smb3_do_mount() warn: possible memory leak of 'cifs_sb'
fs/smb/client/cifssmb.c:4089 CIFSFindFirst() warn: missing error code? 'rc'
fs/smb/client/cifssmb.c:4216 CIFSFindNext() warn: missing error code? 'rc'
fs/smb/client/connect.c:2725 cifs_match_super() error: 'tlink' dereferencing possible ERR_PTR()
fs/smb/client/connect.c:2924 generic_ip_connect() error: we previously assumed 'socket' could be null (see line 2912)
fs/xfs/scrub/fscounters.c:459 xchk_fscounters() warn: ignoring unreachable code.
kernel/events/uprobes.c:478 uprobe_write_opcode() warn: passing zero to 'PTR_ERR'
{standard input}:1078: Error: pcrel too far

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- arc-randconfig-c004-20230531
|   |-- include-linux-usb-typec_mux.h:error:expected-identifier-or-(-before-token
|   `-- include-linux-usb-typec_mux.h:warning:fwnode_typec_mux_get-used-but-never-defined
|-- arm64-randconfig-c033-20230531
|   |-- arch-arm64-kvm-mmu.c:preceding-lock-on-line
|   |-- include-linux-usb-typec_mux.h:error:expected-identifier-or-(-before-token
|   `-- include-linux-usb-typec_mux.h:warning:fwnode_typec_mux_get-used-but-never-defined
|-- arm64-randconfig-r001-20230531
|   |-- drivers-net-dsa-qca-qca8k-leds.c:error:struct-led_classdev-has-no-member-named-hw_control_get
|   |-- drivers-net-dsa-qca-qca8k-leds.c:error:struct-led_classdev-has-no-member-named-hw_control_get_device
|   |-- drivers-net-dsa-qca-qca8k-leds.c:error:struct-led_classdev-has-no-member-named-hw_control_is_supported
|   |-- drivers-net-dsa-qca-qca8k-leds.c:error:struct-led_classdev-has-no-member-named-hw_control_set
|   `-- drivers-net-dsa-qca-qca8k-leds.c:error:struct-led_classdev-has-no-member-named-hw_control_trigger
|-- arm64-randconfig-r016-20230601
|   `-- include-linux-usb-typec_mux.h:error:expected-identifier-or-(-before-token
|-- i386-allyesconfig
|   `-- include-drm-drm_print.h:error:format-ld-expects-argument-of-type-long-int-but-argument-has-type-size_t-aka-unsigned-int
|-- i386-randconfig-m021-20230531
|   |-- fs-smb-client-cifsfs.c-cifs_smb3_do_mount()-warn:possible-memory-leak-of-cifs_sb
|   |-- fs-smb-client-cifssmb.c-CIFSFindFirst()-warn:missing-error-code-rc
|   |-- fs-smb-client-cifssmb.c-CIFSFindNext()-warn:missing-error-code-rc
|   |-- fs-smb-client-connect.c-cifs_match_super()-error:tlink-dereferencing-possible-ERR_PTR()
|   |-- fs-smb-client-connect.c-generic_ip_connect()-error:we-previously-assumed-socket-could-be-null-(see-line-)
|   |-- fs-xfs-scrub-fscounters.c-xchk_fscounters()-warn:ignoring-unreachable-code.
|   `-- kernel-events-uprobes.c-uprobe_write_opcode()-warn:passing-zero-to-PTR_ERR
|-- riscv-randconfig-m031-20230531
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_gfx.c-amdgpu_gfx_enable_kcq()-warn:inconsistent-indenting
|   `-- kernel-events-uprobes.c-uprobe_write_opcode()-warn:passing-zero-to-PTR_ERR
|-- sh-allmodconfig
|   `-- standard-input:Error:pcrel-too-far
`-- x86_64-randconfig-m001-20230601
    |-- fs-smb-client-cifsfs.c-cifs_smb3_do_mount()-warn:possible-memory-leak-of-cifs_sb
    |-- fs-smb-client-cifssmb.c-CIFSFindFirst()-warn:missing-error-code-rc
    |-- fs-smb-client-cifssmb.c-CIFSFindNext()-warn:missing-error-code-rc
    |-- fs-smb-client-connect.c-cifs_match_super()-error:tlink-dereferencing-possible-ERR_PTR()
    |-- fs-smb-client-connect.c-generic_ip_connect()-error:we-previously-assumed-socket-could-be-null-(see-line-)
    `-- kernel-events-uprobes.c-uprobe_write_opcode()-warn:passing-zero-to-PTR_ERR
clang_recent_errors
|-- arm-randconfig-r006-20230531
|   `-- include-linux-usb-typec_mux.h:error:expected-identifier-or-(
|-- hexagon-randconfig-r045-20230531
|   `-- mm-zswap.c:warning:variable-ret-is-used-uninitialized-whenever-if-condition-is-true
|-- mips-randconfig-r003-20230531
|   `-- drivers-net-dsa-qca-qca8k-leds.c:error:no-member-named-hw_control_get_device-in-struct-led_classdev
|-- s390-randconfig-r044-20230531
|   `-- mm-zswap.c:warning:variable-ret-is-used-uninitialized-whenever-if-condition-is-true
`-- x86_64-randconfig-x063-20230531
    `-- mm-zswap.c:warning:variable-ret-is-used-uninitialized-whenever-if-condition-is-true

elapsed time: 799m

configs tested: 134
configs skipped: 7

tested configs:
alpha                            allyesconfig   gcc  
alpha        buildonly-randconfig-r006-20230531   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r034-20230531   gcc  
arc                              alldefconfig   gcc  
arc                              allyesconfig   gcc  
arc          buildonly-randconfig-r005-20230531   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r043-20230531   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm          buildonly-randconfig-r001-20230531   gcc  
arm                                 defconfig   gcc  
arm                   milbeaut_m10v_defconfig   clang
arm                  randconfig-r006-20230531   clang
arm                  randconfig-r046-20230531   gcc  
arm                        spear6xx_defconfig   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r036-20230531   gcc  
csky         buildonly-randconfig-r002-20230531   gcc  
csky                                defconfig   gcc  
hexagon              randconfig-r005-20230531   clang
hexagon              randconfig-r022-20230531   clang
hexagon              randconfig-r041-20230531   clang
hexagon              randconfig-r045-20230531   clang
i386                              allnoconfig   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-i001-20230531   gcc  
i386                 randconfig-i002-20230531   gcc  
i386                 randconfig-i003-20230531   gcc  
i386                 randconfig-i004-20230531   gcc  
i386                 randconfig-i005-20230531   gcc  
i386                 randconfig-i006-20230531   gcc  
i386                 randconfig-i011-20230531   clang
i386                 randconfig-i012-20230531   clang
i386                 randconfig-i013-20230531   clang
i386                 randconfig-i014-20230531   clang
i386                 randconfig-i015-20230531   clang
i386                 randconfig-i016-20230531   clang
i386                 randconfig-i051-20230531   gcc  
i386                 randconfig-i052-20230531   gcc  
i386                 randconfig-i053-20230531   gcc  
i386                 randconfig-i054-20230531   gcc  
i386                 randconfig-i055-20230531   gcc  
i386                 randconfig-i056-20230531   gcc  
i386                 randconfig-i061-20230531   gcc  
i386                 randconfig-i062-20230531   gcc  
i386                 randconfig-i063-20230531   gcc  
i386                 randconfig-i064-20230531   gcc  
i386                 randconfig-i065-20230531   gcc  
i386                 randconfig-i066-20230531   gcc  
i386                 randconfig-r004-20230531   gcc  
i386                 randconfig-r016-20230531   clang
ia64                         bigsur_defconfig   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r023-20230531   gcc  
m68k                             allmodconfig   gcc  
m68k                                defconfig   gcc  
microblaze           randconfig-r013-20230531   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                           ip22_defconfig   clang
mips                           jazz_defconfig   gcc  
mips                malta_qemu_32r6_defconfig   clang
mips                           mtx1_defconfig   clang
mips                 randconfig-r003-20230531   clang
mips                 randconfig-r012-20230531   gcc  
nios2        buildonly-randconfig-r004-20230531   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r011-20230531   gcc  
nios2                randconfig-r026-20230531   gcc  
openrisc                            defconfig   gcc  
openrisc             randconfig-r035-20230531   gcc  
parisc                              defconfig   gcc  
parisc64                            defconfig   gcc  
powerpc                     akebono_defconfig   clang
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                   lite5200b_defconfig   clang
powerpc                 mpc834x_itx_defconfig   gcc  
powerpc              randconfig-r025-20230531   clang
powerpc                     stx_gp3_defconfig   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r042-20230531   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                          debug_defconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r002-20230531   gcc  
s390                 randconfig-r031-20230531   gcc  
s390                 randconfig-r044-20230531   clang
sh                               allmodconfig   gcc  
sh                                  defconfig   gcc  
sh                          urquell_defconfig   gcc  
sparc                               defconfig   gcc  
sparc64              randconfig-r015-20230531   gcc  
sparc64              randconfig-r033-20230531   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230531   gcc  
x86_64               randconfig-a002-20230531   gcc  
x86_64               randconfig-a003-20230531   gcc  
x86_64               randconfig-a004-20230531   gcc  
x86_64               randconfig-a005-20230531   gcc  
x86_64               randconfig-a006-20230531   gcc  
x86_64               randconfig-a011-20230531   clang
x86_64               randconfig-a012-20230531   clang
x86_64               randconfig-a013-20230531   clang
x86_64               randconfig-a014-20230531   clang
x86_64               randconfig-a015-20230531   clang
x86_64               randconfig-a016-20230531   clang
x86_64               randconfig-k001-20230531   clang
x86_64               randconfig-x051-20230531   clang
x86_64               randconfig-x052-20230531   clang
x86_64               randconfig-x053-20230531   clang
x86_64               randconfig-x054-20230531   clang
x86_64               randconfig-x055-20230531   clang
x86_64               randconfig-x056-20230531   clang
x86_64               randconfig-x061-20230531   clang
x86_64               randconfig-x063-20230531   clang
x86_64                               rhel-8.3   gcc  
xtensa               randconfig-r014-20230531   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

