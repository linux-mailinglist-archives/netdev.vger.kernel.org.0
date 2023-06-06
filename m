Return-Path: <netdev+bounces-8608-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D24CD724CB8
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 21:15:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17844280CB9
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 19:15:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F06C322E50;
	Tue,  6 Jun 2023 19:15:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCACF125CC
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 19:15:13 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B29C92;
	Tue,  6 Jun 2023 12:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686078911; x=1717614911;
  h=date:from:to:cc:subject:message-id;
  bh=QkvGHf4eq1pgC8dAn5Eqecs8H7OOz9rNo96l+Ulq1RU=;
  b=II9fc+pNLsdugCkKmuKCSTKgNbOcY6aR8eLWIS7ZFjYWvV0AW/5bPkfx
   ct/JDhYvySUsQ3n9N+KKBfMCcavkUzrLSh4MwUplv/djrNZTqQ4rCP+8N
   MQShmbJWVzIntT5m0JwIL3dHtyjn4GLOvXMvFLVDrHocXK3cFMvEuMIJh
   fbKwetFrPd1+RaWmAjApG8omBeNhk+/YZMzpzufY8E7I+4EJ4L8Zp7xWq
   91gGbxXVtj8cNEoDvVN+rd9IEGmbcxfwHe92eAMARHfSVQFR060XvOS1G
   kziMeWdhpG2OqJe3MSUx+IUlORRNUJ7XxZyk7OBkMM7utvXfrGqBznxto
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="354272280"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="354272280"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 12:15:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="659651927"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="659651927"
Received: from lkp-server01.sh.intel.com (HELO 15ab08e44a81) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 06 Jun 2023 12:15:07 -0700
Received: from kbuild by 15ab08e44a81 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q6c94-0005dX-2N;
	Tue, 06 Jun 2023 19:15:06 +0000
Date: Wed, 07 Jun 2023 03:14:34 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 dri-devel@lists.freedesktop.org, kasan-dev@googlegroups.com,
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-usb@vger.kernel.org,
 lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
 samba-technical@lists.samba.org
Subject: [linux-next:master] BUILD REGRESSION
 6db29e14f4fb7bce9eb5290288e71b05c2b0d118
Message-ID: <20230606191434.xY-E7%lkp@intel.com>
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
branch HEAD: 6db29e14f4fb7bce9eb5290288e71b05c2b0d118  Add linux-next specific files for 20230606

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202305132244.DwzBUcUd-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202306021936.OktTcMAT-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202306061802.DUh27KMQ-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

ERROR: modpost: "lynx_pcs_create_mdiodev" [drivers/net/ethernet/altera/altera_tse.ko] undefined!
ERROR: modpost: "lynx_pcs_destroy" [drivers/net/ethernet/stmicro/stmmac/stmmac.ko] undefined!
arm-linux-gnueabi-ld: altera_tse_main.c:(.text+0x1808): undefined reference to `lynx_pcs_destroy'
drivers/bus/fsl-mc/fsl-mc-allocator.c:108:12: warning: variable 'mc_bus_dev' is uninitialized when used here [-Wuninitialized]
drivers/net/ethernet/altera/altera_tse_main.c:1419: undefined reference to `lynx_pcs_create_mdiodev'
drivers/net/ethernet/altera/altera_tse_main.c:1473: undefined reference to `lynx_pcs_destroy'
drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c:669: undefined reference to `lynx_pcs_destroy'
include/drm/drm_print.h:456:39: error: format '%ld' expects argument of type 'long int', but argument 4 has type 'size_t' {aka 'unsigned int'} [-Werror=format=]
ld.lld: error: undefined symbol: lynx_pcs_create_mdiodev
ld.lld: error: undefined symbol: lynx_pcs_destroy
m68k-linux-ld: drivers/net/ethernet/altera/altera_tse_main.c:1451: undefined reference to `lynx_pcs_destroy'
microblaze-linux-ld: drivers/net/ethernet/altera/altera_tse_main.c:1451: undefined reference to `lynx_pcs_destroy'
mips64-linux-ld: drivers/net/ethernet/altera/altera_tse_main.c:1451: undefined reference to `lynx_pcs_destroy'
net/netfilter/ipvs/ip_vs_proto.o: warning: objtool: .init.text: unexpected end of section
nios2-linux-ld: drivers/net/ethernet/altera/altera_tse_main.c:1451: undefined reference to `lynx_pcs_destroy'
powerpc-linux-ld: drivers/net/ethernet/altera/altera_tse_main.c:1451: undefined reference to `lynx_pcs_destroy'
riscv32-linux-ld: altera_tse_main.c:(.text+0x2024): undefined reference to `lynx_pcs_destroy'

Unverified Error/Warning (likely false positive, please contact us if interested):

Warning: MAINTAINERS references a file that doesn't exist: Documentation/devicetree/bindings/usb/starfive,jh7110-usb.yaml
drivers/net/ethernet/emulex/benet/be_main.c:2460 be_rx_compl_process_gro() error: buffer overflow '((skb_end_pointer(skb)))->frags' 17 <= u16max
drivers/usb/cdns3/cdns3-starfive.c:23: warning: expecting prototype for cdns3(). Prototype was for USB_STRAP_HOST() instead
fs/btrfs/volumes.c:6407 btrfs_map_block() error: we previously assumed 'mirror_num_ret' could be null (see line 6245)
fs/smb/client/cifsfs.c:982 cifs_smb3_do_mount() warn: possible memory leak of 'cifs_sb'
fs/smb/client/cifssmb.c:4089 CIFSFindFirst() warn: missing error code? 'rc'
fs/smb/client/cifssmb.c:4216 CIFSFindNext() warn: missing error code? 'rc'
fs/smb/client/connect.c:2725 cifs_match_super() error: 'tlink' dereferencing possible ERR_PTR()
fs/smb/client/connect.c:2924 generic_ip_connect() error: we previously assumed 'socket' could be null (see line 2912)
kernel/events/uprobes.c:478 uprobe_write_opcode() warn: passing zero to 'PTR_ERR'

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   `-- drivers-usb-cdns3-cdns3-starfive.c:warning:expecting-prototype-for-cdns3().-Prototype-was-for-USB_STRAP_HOST()-instead
|-- arc-allyesconfig
|   `-- drivers-usb-cdns3-cdns3-starfive.c:warning:expecting-prototype-for-cdns3().-Prototype-was-for-USB_STRAP_HOST()-instead
|-- arm-allmodconfig
|   `-- drivers-usb-cdns3-cdns3-starfive.c:warning:expecting-prototype-for-cdns3().-Prototype-was-for-USB_STRAP_HOST()-instead
|-- arm-allyesconfig
|   `-- drivers-usb-cdns3-cdns3-starfive.c:warning:expecting-prototype-for-cdns3().-Prototype-was-for-USB_STRAP_HOST()-instead
|-- arm-randconfig-r022-20230606
|   `-- arm-linux-gnueabi-ld:altera_tse_main.c:(.text):undefined-reference-to-lynx_pcs_destroy
|-- arm64-allyesconfig
|   `-- drivers-usb-cdns3-cdns3-starfive.c:warning:expecting-prototype-for-cdns3().-Prototype-was-for-USB_STRAP_HOST()-instead
|-- arm64-buildonly-randconfig-r003-20230606
|   `-- ERROR:lynx_pcs_create_mdiodev-drivers-net-ethernet-altera-altera_tse.ko-undefined
|-- arm64-randconfig-s043-20230606
|   `-- mm-kfence-core.c:sparse:sparse:cast-to-restricted-__le64
|-- i386-allyesconfig
|   `-- include-drm-drm_print.h:error:format-ld-expects-argument-of-type-long-int-but-argument-has-type-size_t-aka-unsigned-int
|-- i386-randconfig-i005-20230606
|   `-- include-drm-drm_print.h:error:format-ld-expects-argument-of-type-long-int-but-argument-has-type-size_t-aka-unsigned-int
|-- i386-randconfig-m021-20230606
|   |-- fs-smb-client-cifsfs.c-cifs_smb3_do_mount()-warn:possible-memory-leak-of-cifs_sb
|   |-- fs-smb-client-cifssmb.c-CIFSFindFirst()-warn:missing-error-code-rc
|   |-- fs-smb-client-cifssmb.c-CIFSFindNext()-warn:missing-error-code-rc
|   |-- fs-smb-client-connect.c-cifs_match_super()-error:tlink-dereferencing-possible-ERR_PTR()
|   `-- fs-smb-client-connect.c-generic_ip_connect()-error:we-previously-assumed-socket-could-be-null-(see-line-)
|-- m68k-allmodconfig
|   `-- drivers-usb-cdns3-cdns3-starfive.c:warning:expecting-prototype-for-cdns3().-Prototype-was-for-USB_STRAP_HOST()-instead
|-- m68k-buildonly-randconfig-r002-20230606
|   `-- m68k-linux-ld:drivers-net-ethernet-altera-altera_tse_main.c:undefined-reference-to-lynx_pcs_destroy
|-- microblaze-randconfig-r022-20230606
|   `-- microblaze-linux-ld:drivers-net-ethernet-altera-altera_tse_main.c:undefined-reference-to-lynx_pcs_destroy
|-- mips-allmodconfig
|   `-- drivers-usb-cdns3-cdns3-starfive.c:warning:expecting-prototype-for-cdns3().-Prototype-was-for-USB_STRAP_HOST()-instead
|-- mips-allyesconfig
|   `-- drivers-usb-cdns3-cdns3-starfive.c:warning:expecting-prototype-for-cdns3().-Prototype-was-for-USB_STRAP_HOST()-instead
|-- mips-randconfig-r022-20230606
|   `-- mips64-linux-ld:drivers-net-ethernet-altera-altera_tse_main.c:undefined-reference-to-lynx_pcs_destroy
|-- nios2-3c120_defconfig
|   |-- drivers-net-ethernet-altera-altera_tse_main.c:undefined-reference-to-lynx_pcs_create_mdiodev
|   |-- drivers-net-ethernet-altera-altera_tse_main.c:undefined-reference-to-lynx_pcs_destroy
|   `-- nios2-linux-ld:drivers-net-ethernet-altera-altera_tse_main.c:undefined-reference-to-lynx_pcs_destroy
|-- nios2-allmodconfig
|   `-- drivers-usb-cdns3-cdns3-starfive.c:warning:expecting-prototype-for-cdns3().-Prototype-was-for-USB_STRAP_HOST()-instead
|-- nios2-defconfig
|   |-- drivers-net-ethernet-altera-altera_tse_main.c:undefined-reference-to-lynx_pcs_create_mdiodev
|   |-- drivers-net-ethernet-altera-altera_tse_main.c:undefined-reference-to-lynx_pcs_destroy
|   `-- nios2-linux-ld:drivers-net-ethernet-altera-altera_tse_main.c:undefined-reference-to-lynx_pcs_destroy
|-- powerpc-allmodconfig
|   `-- drivers-usb-cdns3-cdns3-starfive.c:warning:expecting-prototype-for-cdns3().-Prototype-was-for-USB_STRAP_HOST()-instead
|-- powerpc-randconfig-r021-20230605
|   `-- powerpc-linux-ld:drivers-net-ethernet-altera-altera_tse_main.c:undefined-reference-to-lynx_pcs_destroy
|-- riscv-allmodconfig
|   `-- drivers-usb-cdns3-cdns3-starfive.c:warning:expecting-prototype-for-cdns3().-Prototype-was-for-USB_STRAP_HOST()-instead
|-- riscv-defconfig
|   `-- ERROR:lynx_pcs_destroy-drivers-net-ethernet-stmicro-stmmac-stmmac.ko-undefined
|-- riscv-randconfig-r004-20230606
|   `-- riscv32-linux-ld:altera_tse_main.c:(.text):undefined-reference-to-lynx_pcs_destroy
|-- s390-allyesconfig
|   `-- drivers-usb-cdns3-cdns3-starfive.c:warning:expecting-prototype-for-cdns3().-Prototype-was-for-USB_STRAP_HOST()-instead
|-- s390-randconfig-s052-20230606
|   `-- mm-kfence-core.c:sparse:sparse:cast-to-restricted-__le64
|-- sparc-allyesconfig
|   `-- drivers-usb-cdns3-cdns3-starfive.c:warning:expecting-prototype-for-cdns3().-Prototype-was-for-USB_STRAP_HOST()-instead
|-- sparc64-randconfig-c024-20230606
|   `-- drivers-usb-cdns3-cdns3-starfive.c:warning:expecting-prototype-for-cdns3().-Prototype-was-for-USB_STRAP_HOST()-instead
|-- x86_64-allnoconfig
|   `-- Warning:MAINTAINERS-references-a-file-that-doesn-t-exist:Documentation-devicetree-bindings-usb-starfive-jh7110-usb.yaml
|-- x86_64-kexec
|   `-- drivers-net-ethernet-stmicro-stmmac-stmmac_mdio.c:undefined-reference-to-lynx_pcs_destroy
`-- x86_64-randconfig-m001-20230606
    |-- ERROR:lynx_pcs_create_mdiodev-drivers-net-ethernet-altera-altera_tse.ko-undefined
    |-- drivers-net-ethernet-emulex-benet-be_main.c-be_rx_compl_process_gro()-error:buffer-overflow-((skb_end_pointer(skb)))-frags-u16max
    |-- fs-btrfs-volumes.c-btrfs_map_block()-error:we-previously-assumed-mirror_num_ret-could-be-null-(see-line-)
    `-- kernel-events-uprobes.c-uprobe_write_opcode()-warn:passing-zero-to-PTR_ERR
clang_recent_errors
|-- arm-randconfig-r034-20230606
|   |-- ld.lld:error:undefined-symbol:lynx_pcs_create_mdiodev
|   `-- ld.lld:error:undefined-symbol:lynx_pcs_destroy
|-- arm64-randconfig-r025-20230606
|   `-- drivers-bus-fsl-mc-fsl-mc-allocator.c:warning:variable-mc_bus_dev-is-uninitialized-when-used-here
`-- x86_64-randconfig-x062-20230606
    `-- net-netfilter-ipvs-ip_vs_proto.o:warning:objtool:.init.text:unexpected-end-of-section

elapsed time: 866m

configs tested: 152
configs skipped: 7

tested configs:
alpha                            alldefconfig   gcc  
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r043-20230606   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                         axm55xx_defconfig   gcc  
arm          buildonly-randconfig-r004-20230606   gcc  
arm                                 defconfig   gcc  
arm                          exynos_defconfig   gcc  
arm                       multi_v4t_defconfig   gcc  
arm                             pxa_defconfig   gcc  
arm                  randconfig-r046-20230606   gcc  
arm                         socfpga_defconfig   clang
arm                          sp7021_defconfig   clang
arm                    vt8500_v6_v7_defconfig   clang
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r025-20230606   clang
csky                                defconfig   gcc  
csky                 randconfig-r022-20230606   gcc  
hexagon              randconfig-r041-20230606   clang
hexagon              randconfig-r045-20230606   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-i001-20230606   gcc  
i386                 randconfig-i002-20230606   gcc  
i386                 randconfig-i003-20230606   gcc  
i386                 randconfig-i004-20230606   gcc  
i386                 randconfig-i005-20230606   gcc  
i386                 randconfig-i006-20230606   gcc  
i386                 randconfig-i011-20230606   clang
i386                 randconfig-i012-20230606   clang
i386                 randconfig-i013-20230606   clang
i386                 randconfig-i014-20230606   clang
i386                 randconfig-i015-20230606   clang
i386                 randconfig-i016-20230606   clang
i386                 randconfig-i051-20230606   gcc  
i386                 randconfig-i052-20230606   gcc  
i386                 randconfig-i053-20230606   gcc  
i386                 randconfig-i054-20230606   gcc  
i386                 randconfig-i055-20230606   gcc  
i386                 randconfig-i056-20230606   gcc  
i386                 randconfig-i061-20230606   gcc  
i386                 randconfig-i062-20230606   gcc  
i386                 randconfig-i063-20230606   gcc  
i386                 randconfig-i064-20230606   gcc  
i386                 randconfig-i065-20230606   gcc  
i386                 randconfig-i066-20230606   gcc  
i386                 randconfig-r001-20230606   gcc  
i386                 randconfig-r015-20230606   clang
i386                 randconfig-r034-20230606   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r003-20230606   gcc  
loongarch            randconfig-r026-20230606   gcc  
loongarch            randconfig-r032-20230606   gcc  
m68k                             allmodconfig   gcc  
m68k                         amcore_defconfig   gcc  
m68k                                defconfig   gcc  
m68k                       m5208evb_defconfig   gcc  
m68k                        m5407c3_defconfig   gcc  
m68k                 randconfig-r004-20230606   gcc  
microblaze           randconfig-r024-20230606   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                      bmips_stb_defconfig   clang
mips                     decstation_defconfig   gcc  
mips                           ip32_defconfig   gcc  
mips                       lemote2f_defconfig   clang
mips                       rbtx49xx_defconfig   clang
nios2                         3c120_defconfig   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r002-20230606   gcc  
openrisc     buildonly-randconfig-r003-20230606   gcc  
openrisc             randconfig-r012-20230606   gcc  
parisc                              defconfig   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc      buildonly-randconfig-r001-20230606   clang
powerpc                     ep8248e_defconfig   gcc  
powerpc                      ep88xc_defconfig   gcc  
powerpc                     kilauea_defconfig   clang
powerpc                       maple_defconfig   gcc  
powerpc                 mpc8313_rdb_defconfig   clang
powerpc                 mpc85xx_cds_defconfig   gcc  
powerpc              randconfig-r014-20230606   clang
powerpc              randconfig-r021-20230606   clang
powerpc              randconfig-r033-20230606   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                               defconfig   gcc  
riscv             nommu_k210_sdcard_defconfig   gcc  
riscv                randconfig-r005-20230606   gcc  
riscv                randconfig-r036-20230606   gcc  
riscv                randconfig-r042-20230606   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390         buildonly-randconfig-r002-20230606   clang
s390                                defconfig   gcc  
s390                 randconfig-r044-20230606   clang
sh                               allmodconfig   gcc  
sh                   randconfig-r035-20230606   gcc  
sh                          rsk7203_defconfig   gcc  
sh                          rsk7264_defconfig   gcc  
sh                           se7751_defconfig   gcc  
sh                             shx3_defconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r011-20230606   gcc  
sparc                       sparc64_defconfig   gcc  
sparc64              randconfig-r031-20230606   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64       buildonly-randconfig-r005-20230606   gcc  
x86_64       buildonly-randconfig-r006-20230606   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230606   gcc  
x86_64               randconfig-a002-20230606   gcc  
x86_64               randconfig-a003-20230606   gcc  
x86_64               randconfig-a004-20230606   gcc  
x86_64               randconfig-a005-20230606   gcc  
x86_64               randconfig-a006-20230606   gcc  
x86_64               randconfig-a011-20230606   clang
x86_64               randconfig-a012-20230606   clang
x86_64               randconfig-a013-20230606   clang
x86_64               randconfig-a014-20230606   clang
x86_64               randconfig-a015-20230606   clang
x86_64               randconfig-a016-20230606   clang
x86_64               randconfig-k001-20230606   clang
x86_64               randconfig-r006-20230606   gcc  
x86_64               randconfig-x051-20230606   clang
x86_64               randconfig-x052-20230606   clang
x86_64               randconfig-x053-20230606   clang
x86_64               randconfig-x054-20230606   clang
x86_64               randconfig-x055-20230606   clang
x86_64               randconfig-x056-20230606   clang
x86_64               randconfig-x061-20230606   clang
x86_64               randconfig-x062-20230606   clang
x86_64               randconfig-x063-20230606   clang
x86_64               randconfig-x064-20230606   clang
x86_64               randconfig-x065-20230606   clang
x86_64               randconfig-x066-20230606   clang
x86_64                               rhel-8.3   gcc  
xtensa                  nommu_kc705_defconfig   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

