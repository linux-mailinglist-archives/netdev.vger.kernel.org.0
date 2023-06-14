Return-Path: <netdev+bounces-10837-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 358DC730779
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 20:42:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D22F01C20D7C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 18:42:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72AECC2C3;
	Wed, 14 Jun 2023 18:42:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3A47F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 18:42:33 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A08A1BF9;
	Wed, 14 Jun 2023 11:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686768150; x=1718304150;
  h=date:from:to:cc:subject:message-id;
  bh=NrAIYtXU/PqQjwGTIerTLpDp8yZRtzwBUpq6VeZVJPY=;
  b=fszsXEDUSjKF6T7SLVNMcIsSZ29Jn7k6zN4LA4SKPxggjeMbI/kGQdQ2
   OWVL8+o/80QgNx9ffSot1KvYUuw+pgI6PnsTg24uTzwAaTivlvXAe4nnt
   lWcbdflkBjJ0slDIoUOEwX/ZmZqkOMqIcEGwqV7gQS8cYOZWMEjqTKz12
   +KJRU5qCCn5eTLpl7B7IuUcOzaWo/9Lp6c5UgJv6je/nc+GWCVIFwq6Zn
   ieCxue3QYSBZ591rnfOotPZgFy6pKmm/rku8IiGXUz6OD94uo8mVuiu3K
   VrHFvTi3DgOddjcSbP4ubmJzJ9IWMzyeXmU0ByOR/5Q+vBgKrPqa45YGz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="358704653"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="358704653"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 11:42:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="886371524"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="886371524"
Received: from lkp-server02.sh.intel.com (HELO d59cacf64e9e) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 14 Jun 2023 11:42:24 -0700
Received: from kbuild by d59cacf64e9e with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q9VRn-0000xZ-1f;
	Wed, 14 Jun 2023 18:42:23 +0000
Date: Thu, 15 Jun 2023 02:42:10 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 apparmor@lists.ubuntu.com, intel-gfx@lists.freedesktop.org,
 kunit-dev@googlegroups.com, linux-cifs@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-integrity@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-leds@vger.kernel.org,
 linux-net-drivers@amd.com, linux-parisc@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-usb@vger.kernel.org, lvs-devel@vger.kernel.org,
 netdev@vger.kernel.org, rcu@vger.kernel.org,
 samba-technical@lists.samba.org
Subject: [linux-next:master] BUILD REGRESSION
 b16049b21162bb649cdd8519642a35972b7910fe
Message-ID: <202306150255.nUNQao5u-lkp@intel.com>
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
branch HEAD: b16049b21162bb649cdd8519642a35972b7910fe  Add linux-next specific files for 20230614

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202306122223.HHER4zOo-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202306132237.Z4LJE8bP-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202306140505.ZTBob65w-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202306141702.ZaO9V2lk-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202306141719.MJHClSrC-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202306141920.TTvpsXwJ-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202306141934.UKmM9bFX-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202306142017.23VmBLmG-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202306142023.vjEaFkk5-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst:57: WARNING: Unexpected indentation.
Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst:66: WARNING: undefined label: documentation/networking/devlink/devlink-params.rst (if the link has no caption the label must precede a section header)
arch/parisc/kernel/pdt.c:65:6: warning: no previous prototype for 'arch_report_meminfo' [-Wmissing-prototypes]
drivers/ata/pata_octeon_cf.c:835:7: error: call to undeclared function 'of_property_read_reg'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
drivers/char/mem.c:164:25: error: implicit declaration of function 'unxlate_dev_mem_ptr'; did you mean 'xlate_dev_mem_ptr'? [-Werror=implicit-function-declaration]
drivers/gpu/drm/i915/display/intel_display_power.h:255:70: error: declaration of 'struct seq_file' will not be visible outside of this function [-Werror,-Wvisibility]
drivers/gpu/drm/i915/display/intel_display_power.h:256:70: error: declaration of 'struct seq_file' will not be visible outside of this function [-Werror,-Wvisibility]
drivers/gpu/drm/i915/i915_driver.c:1806:17: error: use of undeclared identifier 'i915_drm_client_fdinfo'
drivers/leds/leds-cht-wcove.c:144:21: warning: no previous prototype for 'cht_wc_leds_brightness_get' [-Wmissing-prototypes]
drivers/net/ethernet/sfc/ef100_netdev.c:313: undefined reference to `efx_tc_netdev_event'
drivers/net/ethernet/sfc/ef100_netdev.c:329: undefined reference to `efx_tc_netevent_event'
kernel/rcu/rcuscale.c:301:20: error: use of undeclared identifier 'get_rcu_tasks_gp_kthread'; did you mean 'get_rcu_tasks_trace_gp_kthread'?
kernel/rcu/rcuscale.c:322:14: error: use of undeclared identifier 'tasks_scale_read_lock'
kernel/rcu/rcuscale.c:323:16: error: use of undeclared identifier 'tasks_scale_read_unlock'
kernel/rcu/rcuscale.c:330:20: error: use of undeclared identifier 'get_rcu_tasks_rude_gp_kthread'; did you mean 'get_rcu_tasks_trace_gp_kthread'?
kernel/rcu/tasks.h:1113:21: warning: no previous prototype for function 'get_rcu_tasks_gp_kthread' [-Wmissing-prototypes]
lib/kunit/executor_test.c:138:4: warning: cast from 'void (*)(const void *)' to 'kunit_action_t *' (aka 'void (*)(void *)') converts to incompatible function type [-Wcast-function-type-strict]
lib/kunit/test.c:775:38: warning: cast from 'void (*)(const void *)' to 'kunit_action_t *' (aka 'void (*)(void *)') converts to incompatible function type [-Wcast-function-type-strict]
security/apparmor/policy_unpack.c:1144: warning: expecting prototype for verify_dfa_accept_xindex(). Prototype was for verify_dfa_accept_index() instead

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/char/tpm/tpm_tis_spi_main.c:137 tpm_tis_spi_transfer_half() error: uninitialized symbol 'ret'.
drivers/net/ethernet/emulex/benet/be_main.c:2460 be_rx_compl_process_gro() error: buffer overflow '((skb_end_pointer(skb)))->frags' 17 <= u16max
drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c:98 mlx5_devcom_register_device() error: uninitialized symbol 'tmp_dev'.
drivers/usb/cdns3/cdns3-starfive.c:23: warning: expecting prototype for cdns3(). Prototype was for USB_STRAP_HOST() instead
fs/smb/client/cifsfs.c:982 cifs_smb3_do_mount() warn: possible memory leak of 'cifs_sb'
fs/smb/client/cifssmb.c:4089 CIFSFindFirst() warn: missing error code? 'rc'
fs/smb/client/cifssmb.c:4216 CIFSFindNext() warn: missing error code? 'rc'
fs/smb/client/connect.c:2775 cifs_match_super() error: 'tlink' dereferencing possible ERR_PTR()
fs/smb/client/connect.c:2974 generic_ip_connect() error: we previously assumed 'socket' could be null (see line 2962)
mm/mempolicy.c:1225 new_folio() error: uninitialized symbol 'address'.

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- i386-allyesconfig
|   `-- drivers-leds-leds-cht-wcove.c:warning:no-previous-prototype-for-cht_wc_leds_brightness_get
|-- i386-randconfig-i014-20230614
|   |-- drivers-net-ethernet-sfc-ef100_netdev.c:undefined-reference-to-efx_tc_netdev_event
|   `-- drivers-net-ethernet-sfc-ef100_netdev.c:undefined-reference-to-efx_tc_netevent_event
|-- i386-randconfig-m021-20230614
|   |-- fs-smb-client-cifsfs.c-cifs_smb3_do_mount()-warn:possible-memory-leak-of-cifs_sb
|   |-- fs-smb-client-cifssmb.c-CIFSFindFirst()-warn:missing-error-code-rc
|   |-- fs-smb-client-cifssmb.c-CIFSFindNext()-warn:missing-error-code-rc
|   |-- fs-smb-client-connect.c-cifs_match_super()-error:tlink-dereferencing-possible-ERR_PTR()
|   `-- fs-smb-client-connect.c-generic_ip_connect()-error:we-previously-assumed-socket-could-be-null-(see-line-)
|-- parisc-allyesconfig
|   `-- arch-parisc-kernel-pdt.c:warning:no-previous-prototype-for-arch_report_meminfo
|-- parisc-defconfig
|   `-- arch-parisc-kernel-pdt.c:warning:no-previous-prototype-for-arch_report_meminfo
|-- parisc-generic-64bit_defconfig
|   `-- arch-parisc-kernel-pdt.c:warning:no-previous-prototype-for-arch_report_meminfo
|-- parisc-randconfig-c004-20230614
|   `-- arch-parisc-kernel-pdt.c:warning:no-previous-prototype-for-arch_report_meminfo
|-- parisc-randconfig-r012-20230614
|   `-- arch-parisc-kernel-pdt.c:warning:no-previous-prototype-for-arch_report_meminfo
|-- parisc-randconfig-r024-20230612
|   `-- arch-parisc-kernel-pdt.c:warning:no-previous-prototype-for-arch_report_meminfo
|-- parisc-randconfig-s042-20230614
|   `-- arch-parisc-kernel-pdt.c:warning:no-previous-prototype-for-arch_report_meminfo
|-- parisc64-defconfig
|   `-- arch-parisc-kernel-pdt.c:warning:no-previous-prototype-for-arch_report_meminfo
|-- riscv-allmodconfig
|   `-- drivers-usb-cdns3-cdns3-starfive.c:warning:expecting-prototype-for-cdns3().-Prototype-was-for-USB_STRAP_HOST()-instead
|-- riscv-allyesconfig
|   `-- drivers-usb-cdns3-cdns3-starfive.c:warning:expecting-prototype-for-cdns3().-Prototype-was-for-USB_STRAP_HOST()-instead
|-- riscv-randconfig-s031-20230612
|   |-- arch-riscv-kernel-signal.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-noderef-__user-datap-got-void
|   `-- arch-riscv-kernel-signal.c:sparse:sparse:incorrect-type-in-initializer-(different-address-spaces)-expected-void-__x-got-void-noderef-__user-assigned-datap
|-- sh-allmodconfig
|   `-- drivers-char-mem.c:error:implicit-declaration-of-function-unxlate_dev_mem_ptr
|-- x86_64-allnoconfig
|   |-- Documentation-networking-device_drivers-ethernet-mellanox-mlx5-switchdev.rst:WARNING:Unexpected-indentation.
|   `-- Documentation-networking-device_drivers-ethernet-mellanox-mlx5-switchdev.rst:WARNING:undefined-label:documentation-networking-devlink-devlink-params.rst-(if-the-link-has-no-caption-the-label-must-prec
|-- x86_64-allyesconfig
|   `-- drivers-leds-leds-cht-wcove.c:warning:no-previous-prototype-for-cht_wc_leds_brightness_get
|-- x86_64-randconfig-m001-20230612
|   |-- drivers-net-ethernet-mellanox-mlx5-core-lib-devcom.c-mlx5_devcom_register_device()-error:uninitialized-symbol-tmp_dev-.
|   |-- fs-smb-client-cifsfs.c-cifs_smb3_do_mount()-warn:possible-memory-leak-of-cifs_sb
|   |-- fs-smb-client-cifssmb.c-CIFSFindFirst()-warn:missing-error-code-rc
|   |-- fs-smb-client-cifssmb.c-CIFSFindNext()-warn:missing-error-code-rc
|   |-- fs-smb-client-connect.c-cifs_match_super()-error:tlink-dereferencing-possible-ERR_PTR()
|   `-- fs-smb-client-connect.c-generic_ip_connect()-error:we-previously-assumed-socket-could-be-null-(see-line-)
`-- x86_64-randconfig-m031-20230611
    |-- drivers-char-tpm-tpm_tis_spi_main.c-tpm_tis_spi_transfer_half()-error:uninitialized-symbol-ret-.
    |-- drivers-net-ethernet-emulex-benet-be_main.c-be_rx_compl_process_gro()-error:buffer-overflow-((skb_end_pointer(skb)))-frags-u16max
    `-- mm-mempolicy.c-new_folio()-error:uninitialized-symbol-address-.
clang_recent_errors
|-- arm-randconfig-r046-20230614
|   |-- kernel-rcu-rcuscale.c:error:use-of-undeclared-identifier-get_rcu_tasks_gp_kthread
|   `-- kernel-rcu-tasks.h:warning:no-previous-prototype-for-function-get_rcu_tasks_gp_kthread
|-- hexagon-randconfig-r032-20230612
|   `-- lib-kunit-test.c:warning:cast-from-void-(-)(const-void-)-to-kunit_action_t-(aka-void-(-)(void-)-)-converts-to-incompatible-function-type
|-- hexagon-randconfig-r041-20230612
|   |-- lib-kunit-executor_test.c:warning:cast-from-void-(-)(const-void-)-to-kunit_action_t-(aka-void-(-)(void-)-)-converts-to-incompatible-function-type
|   `-- lib-kunit-test.c:warning:cast-from-void-(-)(const-void-)-to-kunit_action_t-(aka-void-(-)(void-)-)-converts-to-incompatible-function-type
|-- hexagon-randconfig-r041-20230614
|   |-- kernel-rcu-rcuscale.c:error:use-of-undeclared-identifier-get_rcu_tasks_rude_gp_kthread
|   |-- kernel-rcu-rcuscale.c:error:use-of-undeclared-identifier-tasks_scale_read_lock
|   `-- kernel-rcu-rcuscale.c:error:use-of-undeclared-identifier-tasks_scale_read_unlock
|-- hexagon-randconfig-r045-20230612
|   |-- lib-kunit-executor_test.c:warning:cast-from-void-(-)(const-void-)-to-kunit_action_t-(aka-void-(-)(void-)-)-converts-to-incompatible-function-type
|   `-- lib-kunit-test.c:warning:cast-from-void-(-)(const-void-)-to-kunit_action_t-(aka-void-(-)(void-)-)-converts-to-incompatible-function-type
|-- i386-buildonly-randconfig-r005-20230614
|   `-- drivers-gpu-drm-i915-display-intel_display_power.h:error:declaration-of-struct-seq_file-will-not-be-visible-outside-of-this-function-Werror-Wvisibility
|-- i386-randconfig-i001-20230614
|   `-- security-apparmor-policy_unpack.c:warning:expecting-prototype-for-verify_dfa_accept_xindex().-Prototype-was-for-verify_dfa_accept_index()-instead
|-- mips-randconfig-r016-20230614
|   |-- drivers-ata-pata_octeon_cf.c:error:call-to-undeclared-function-of_property_read_reg-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   |-- lib-kunit-executor_test.c:warning:cast-from-void-(-)(const-void-)-to-kunit_action_t-(aka-void-(-)(void-)-)-converts-to-incompatible-function-type
|   `-- lib-kunit-test.c:warning:cast-from-void-(-)(const-void-)-to-kunit_action_t-(aka-void-(-)(void-)-)-converts-to-incompatible-function-type
|-- x86_64-buildonly-randconfig-r006-20230614
|   `-- drivers-gpu-drm-i915-i915_driver.c:error:use-of-undeclared-identifier-i915_drm_client_fdinfo
|-- x86_64-randconfig-a001-20230612
|   `-- drivers-gpu-drm-i915-display-intel_display_power.h:error:declaration-of-struct-seq_file-will-not-be-visible-outside-of-this-function-Werror-Wvisibility
`-- x86_64-randconfig-a005-20230614
    `-- net-netfilter-ipvs-ip_vs_proto.o:warning:objtool:.init.text:unexpected-end-of-section

elapsed time: 723m

configs tested: 125
configs skipped: 5

tested configs:
alpha                            allyesconfig   gcc  
alpha        buildonly-randconfig-r002-20230614   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r005-20230612   gcc  
alpha                randconfig-r025-20230612   gcc  
arc                              allyesconfig   gcc  
arc          buildonly-randconfig-r003-20230614   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r043-20230612   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                     am200epdkit_defconfig   clang
arm                                 defconfig   gcc  
arm                            dove_defconfig   clang
arm                            hisi_defconfig   gcc  
arm                         lpc18xx_defconfig   gcc  
arm                         lpc32xx_defconfig   clang
arm                       multi_v4t_defconfig   gcc  
arm                        mvebu_v5_defconfig   clang
arm                  randconfig-r046-20230612   clang
arm                       spear13xx_defconfig   clang
arm                           sunxi_defconfig   gcc  
arm                         vf610m4_defconfig   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
csky                                defconfig   gcc  
hexagon              randconfig-r032-20230612   clang
hexagon              randconfig-r041-20230612   clang
hexagon              randconfig-r045-20230612   clang
i386                             alldefconfig   gcc  
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-i001-20230614   clang
i386                 randconfig-i002-20230614   clang
i386                 randconfig-i003-20230614   clang
i386                 randconfig-i004-20230614   clang
i386                 randconfig-i005-20230614   clang
i386                 randconfig-i006-20230614   clang
i386                 randconfig-i011-20230614   gcc  
i386                 randconfig-i012-20230614   gcc  
i386                 randconfig-i013-20230614   gcc  
i386                 randconfig-i014-20230614   gcc  
i386                 randconfig-i015-20230614   gcc  
i386                 randconfig-i016-20230614   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r021-20230612   gcc  
loongarch            randconfig-r031-20230612   gcc  
loongarch            randconfig-r035-20230612   gcc  
m68k                             allmodconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
microblaze           randconfig-r004-20230612   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                            gpr_defconfig   gcc  
mips                           jazz_defconfig   gcc  
mips                    maltaup_xpa_defconfig   gcc  
mips                 randconfig-r003-20230612   gcc  
mips                 randconfig-r016-20230614   clang
nios2                               defconfig   gcc  
nios2                randconfig-r034-20230612   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc                generic-64bit_defconfig   gcc  
parisc               randconfig-r012-20230614   gcc  
parisc               randconfig-r024-20230612   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc      buildonly-randconfig-r005-20230614   gcc  
powerpc                   lite5200b_defconfig   clang
powerpc                 mpc8540_ads_defconfig   gcc  
powerpc                     sequoia_defconfig   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv        buildonly-randconfig-r001-20230614   gcc  
riscv        buildonly-randconfig-r004-20230614   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r002-20230612   clang
riscv                randconfig-r006-20230612   clang
riscv                randconfig-r023-20230612   gcc  
riscv                randconfig-r042-20230612   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r011-20230614   gcc  
s390                 randconfig-r014-20230614   gcc  
s390                 randconfig-r044-20230612   gcc  
sh                               alldefconfig   gcc  
sh                               allmodconfig   gcc  
sh           buildonly-randconfig-r006-20230614   gcc  
sh                          polaris_defconfig   gcc  
sh                   randconfig-r001-20230612   gcc  
sh                   randconfig-r036-20230612   gcc  
sh                           se7343_defconfig   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
um                               alldefconfig   clang
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   clang
um                           x86_64_defconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230612   clang
x86_64               randconfig-a002-20230612   clang
x86_64               randconfig-a003-20230612   clang
x86_64               randconfig-a004-20230612   clang
x86_64               randconfig-a005-20230612   clang
x86_64               randconfig-a006-20230612   clang
x86_64               randconfig-a011-20230612   gcc  
x86_64               randconfig-a012-20230612   gcc  
x86_64               randconfig-a013-20230612   gcc  
x86_64               randconfig-a014-20230612   gcc  
x86_64               randconfig-a015-20230612   gcc  
x86_64               randconfig-a016-20230612   gcc  
x86_64               randconfig-r022-20230612   gcc  
x86_64               randconfig-r033-20230612   clang
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa                         virt_defconfig   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

