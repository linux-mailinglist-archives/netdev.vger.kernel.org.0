Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACC34E37A2
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 04:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236234AbiCVDdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 23:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236091AbiCVDdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 23:33:20 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8454ECD3;
        Mon, 21 Mar 2022 20:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647919910; x=1679455910;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=foIDoPN3cHdtIU2x3TEBnJ1EiH+t5afgXqmd+NuBZsE=;
  b=Kbo9Kb60LEgHk6/dJ4auk4xeb+rDYaDLZcG1EqRri7Chsf0KOWheMGU8
   CeaFRPc17+oW0GrgrW47ZxYtT8QuNafPlLqC2iXpVqcoTYAfXHbdW45F+
   3dYffEbCqI5g29bNi8EIQnetBKmUqvoQuljwFCWg4DyjZAJ7DnYEWtQnr
   N8XIibd65lpJ01TEW/vpmH6x2NUPNoGbD9VrvOn7neDZIm8tWnw+B7VQC
   4mcZMy5KtZc5+Ffoc/RCzE0DwrxNJwbq/VuMhH8HvzzVMG8pgjvxDwfRz
   YbJOq4e8QmPDcN0cTN5v2WsmJCo0rKVH+jxxMovqKlWoATcg8b53yAf81
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10293"; a="256533247"
X-IronPort-AV: E=Sophos;i="5.90,200,1643702400"; 
   d="scan'208";a="256533247"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 20:31:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,200,1643702400"; 
   d="scan'208";a="692401685"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 21 Mar 2022 20:31:43 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nWVFH-000IQT-7m; Tue, 22 Mar 2022 03:31:43 +0000
Date:   Tue, 22 Mar 2022 11:31:26 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     uclinux-h8-devel@lists.sourceforge.jp, rcu@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-sh@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-alpha@vger.kernel.org,
        freedreno@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        alsa-devel@alsa-project.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 f9006d9269eac8ff295c2cb67280c54888c74106
Message-ID: <6239430e.oHI6CzShxclTvSyJ%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: f9006d9269eac8ff295c2cb67280c54888c74106  Add linux-next specific files for 20220321

Error/Warning reports:

https://lore.kernel.org/linux-doc/202202240704.pQD40A9L-lkp@intel.com
https://lore.kernel.org/linux-doc/202202240705.t3QbMnlt-lkp@intel.com
https://lore.kernel.org/linux-doc/202203180707.vLUjjmqY-lkp@intel.com
https://lore.kernel.org/linux-media/202203160306.SfWO9QWV-lkp@intel.com
https://lore.kernel.org/llvm/202202240636.szzbhplB-lkp@intel.com
https://lore.kernel.org/llvm/202202241039.g8GKEE4O-lkp@intel.com
https://lore.kernel.org/llvm/202203190931.X8NH0dPv-lkp@intel.com
https://lore.kernel.org/llvm/202203200835.wEdmTF1a-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

Documentation/driver-api/nvdimm/nvdimm.rst:146: (SEVERE/4) Title level inconsistent:
Makefile:683: arch/nds32/Makefile: No such file or directory
arch/Kconfig:10: can't open file "arch/nds32/Kconfig"
drivers/media/platform/samsung/exynos4-is/fimc-isp-video.h:35:6: warning: no previous prototype for 'fimc_isp_video_device_unregister' [-Wmissing-prototypes]
drivers/spi/spi-amd.c:296:21: warning: cast to smaller integer type 'enum amd_spi_versions' from 'const void *' [-Wvoid-pointer-to-enum-cast]
fs/btrfs/ordered-data.c:168: warning: expecting prototype for Add an ordered extent to the per(). Prototype was for btrfs_add_ordered_extent() instead
fs/btrfs/tree-log.c:6934: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
ld.lld: error: kernel/built-in.a(kallsyms.o):(function kallsyms_open: .text+0x81c): relocation R_RISCV_PCREL_HI20 out of range: -524450 is not in [-524288, 524287]; references kallsyms_markers
ld.lld: error: kernel/built-in.a(kallsyms.o):(function update_iter: .text+0x7a8): relocation R_RISCV_PCREL_HI20 out of range: -524450 is not in [-524288, 524287]; references kallsyms_offsets
lib/raid6/neon1.c:39:9: warning: mixing declarations and code is incompatible with standards before C99 [-Wdeclaration-after-statement]
lib/raid6/neon2.c:39:9: warning: mixing declarations and code is incompatible with standards before C99 [-Wdeclaration-after-statement]
lib/raid6/neon4.c:39:9: warning: mixing declarations and code is incompatible with standards before C99 [-Wdeclaration-after-statement]
lib/raid6/neon8.c:39:9: warning: mixing declarations and code is incompatible with standards before C99 [-Wdeclaration-after-statement]
lib/raid6/recov_neon_inner.c:55:8: warning: mixing declarations and code is incompatible with standards before C99 [-Wdeclaration-after-statement]
make[1]: *** No rule to make target 'arch/nds32/Makefile'.

Unverified Error/Warning (likely false positive, please contact us if interested):

(.text+0x352): undefined reference to `perf_pmu_unregister'
(.text+0xb12): undefined reference to `perf_pmu_register'
arch/alpha/include/asm/string.h:22:16: warning: '__builtin_memcpy' forming offset [40, 2051] is out of the bounds [0, 40] of object 'tag_buf' with type 'unsigned char[40]' [-Warray-bounds]
arch/s390/kernel/machine_kexec.c:57:9: warning: 'memcpy' offset [0, 511] is out of the bounds [0, 0] [-Warray-bounds]
arch/sh/kernel/machvec.c:105:33: warning: array subscript 'struct sh_machine_vector[0]' is partly outside array bounds of 'long int[1]' [-Warray-bounds]
arch/x86/kernel/cpu/mce/inject.c:355:6: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/ata/libata-sff.c:1649 ata_sff_lost_interrupt() error: uninitialized symbol 'status'.
drivers/clk/imx/clk-pll14xx.c:166:2: warning: Value stored to 'pll_div_ctl1' is never read [clang-analyzer-deadcode.DeadStores]
drivers/counter/104-quad-8.c:150:9: sparse:    unsigned char
drivers/counter/104-quad-8.c:150:9: sparse:    void
drivers/counter/104-quad-8.c:150:9: sparse: sparse: incompatible types in conditional expression (different base types):
drivers/firmware/turris-mox-rwtm.c:146:1: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_link.c:4374:7: warning: Dereference of null pointer [clang-analyzer-core.NullDereference]
drivers/gpu/drm/amd/amdgpu/../display/dc/dml/calcs/dce_calcs.c:1504:2: warning: Value stored to 'num_cursor_lines' is never read [clang-analyzer-deadcode.DeadStores]
drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:798:4: warning: Value stored to 'res' is never read [clang-analyzer-deadcode.DeadStores]
drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c:2129:2: warning: Undefined or garbage value returned to caller [clang-analyzer-core.uninitialized.UndefReturn]
drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c:403:5: warning: Value stored to 'ret' is never read [clang-analyzer-deadcode.DeadStores]
drivers/gpu/drm/msm/adreno/a6xx_gmu.h:101:16: sparse: sparse: incorrect type in argument 2 (different address spaces)
drivers/gpu/drm/msm/adreno/a6xx_gmu.h:96:16: sparse: sparse: incorrect type in argument 1 (different address spaces)
drivers/gpu/drm/selftests/test-drm_buddy.c:523:7: warning: Value stored to 'err' is never read [clang-analyzer-deadcode.DeadStores]
drivers/hid/hid-core.c:1665:30: warning: Although the value stored to 'field' is used in the enclosing expression, the value is never actually read from 'field' [clang-analyzer-deadcode.DeadStores]
drivers/hwmon/da9055-hwmon.c:201:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/hwmon/nsa320-hwmon.c:114:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/hwmon/vt8231.c:634:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/iio/frequency/admv1014.c:703:22: sparse: sparse: dubious: x & !y
drivers/infiniband/core/user_mad.c:564:50: warning: array subscript 'struct ib_rmpp_mad[0]' is partly outside array bounds of 'unsigned char[124]' [-Warray-bounds]
drivers/input/serio/ps2-gpio.c:223:4: warning: Value stored to 'rxflags' is never read [clang-analyzer-deadcode.DeadStores]
drivers/leds/trigger/ledtrig-tty.c:33:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/media/platform/st/stm32/dma2d/dma2d-hw.c:109:1: internal compiler error: in extract_insn, at recog.c:2770
drivers/misc/mei/main.c:1100:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/mtd/maps/amd76xrom.c:204:3: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/mtd/maps/ck804xrom.c:234:3: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/net/vxlan/vxlan_core.c:440:34: sparse: sparse: incorrect type in argument 2 (different base types)
drivers/nvmem/sunplus-ocotp.c:74:29: sparse: sparse: symbol 'sp_otp_v0' was not declared. Should it be static?
drivers/pci/vgaarb.c:213:17: warning: Value stored to 'dev' during its initialization is never read [clang-analyzer-deadcode.DeadStores]
drivers/phy/broadcom/phy-brcm-usb.c:233:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/platform/x86/asus-laptop.c:856:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/platform/x86/fujitsu-tablet.c:458:2: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/platform/x86/think-lmi.c:430:4: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/scsi/lpfc/lpfc_els.c:7983:38: sparse:    left side has type unsigned int
drivers/scsi/lpfc/lpfc_els.c:7983:38: sparse:    right side has type restricted __be32
drivers/scsi/lpfc/lpfc_els.c:7983:38: sparse: sparse: invalid assignment: |=
drivers/scsi/lpfc/lpfc_els.c:8504:33: sparse: sparse: incorrect type in assignment (different base types)
drivers/tty/serial/sunplus-uart.c:501:26: sparse: sparse: symbol 'sunplus_console_ports' was not declared. Should it be static?
drivers/usb/typec/rt1719.c:604:18: warning: Assigned value is garbage or undefined [clang-analyzer-core.uninitialized.Assign]
drivers/video/fbdev/matrox/matroxfb_base.c:1094:5: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
include/linux/cacheflush.h:12:46: warning: 'struct folio' declared inside parameter list will not be visible outside of this definition or declaration
include/linux/fortify-string.h:336:4: warning: call to __read_overflow2_field declared with 'warning' attribute: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
include/linux/rcupdate.h:414:36: error: dereferencing pointer to incomplete type 'struct css_set'
kernel/sched/core.c:5268:20: warning: no previous prototype for function 'task_sched_runtime' [-Wmissing-prototypes]
kernel/sched/core.c:8979:6: warning: no previous prototype for 'idle_task_exit' [-Wmissing-prototypes]
kernel/sched/core.c:8979:6: warning: no previous prototype for function 'idle_task_exit' [-Wmissing-prototypes]
kernel/sched/core.c:9214:5: warning: no previous prototype for 'sched_cpu_activate' [-Wmissing-prototypes]
kernel/sched/core.c:9214:5: warning: no previous prototype for function 'sched_cpu_activate' [-Wmissing-prototypes]
kernel/sched/core.c:9259:5: warning: no previous prototype for 'sched_cpu_deactivate' [-Wmissing-prototypes]
kernel/sched/core.c:9259:5: warning: no previous prototype for function 'sched_cpu_deactivate' [-Wmissing-prototypes]
kernel/sched/core.c:9334:5: warning: no previous prototype for 'sched_cpu_starting' [-Wmissing-prototypes]
kernel/sched/core.c:9334:5: warning: no previous prototype for function 'sched_cpu_starting' [-Wmissing-prototypes]
kernel/sched/core.c:9355:5: warning: no previous prototype for 'sched_cpu_wait_empty' [-Wmissing-prototypes]
kernel/sched/core.c:9355:5: warning: no previous prototype for function 'sched_cpu_wait_empty' [-Wmissing-prototypes]
kernel/sched/core.c:9397:5: warning: no previous prototype for 'sched_cpu_dying' [-Wmissing-prototypes]
kernel/sched/core.c:9397:5: warning: no previous prototype for function 'sched_cpu_dying' [-Wmissing-prototypes]
kernel/sched/core.c:9420:13: warning: no previous prototype for function 'sched_init_smp' [-Wmissing-prototypes]
kernel/sched/core.c:9453:13: warning: no previous prototype for function 'sched_init_smp' [-Wmissing-prototypes]
kernel/sched/core.c:9481:13: warning: no previous prototype for function 'sched_init' [-Wmissing-prototypes]
kernel/sched/fair.c:10665:6: warning: no previous prototype for 'nohz_balance_enter_idle' [-Wmissing-prototypes]
kernel/sched/fair.c:10665:6: warning: no previous prototype for function 'nohz_balance_enter_idle' [-Wmissing-prototypes]
kernel/sched/loadavg.c:245:6: warning: no previous prototype for 'calc_load_nohz_start' [-Wmissing-prototypes]
kernel/sched/loadavg.c:245:6: warning: no previous prototype for function 'calc_load_nohz_start' [-Wmissing-prototypes]
kernel/sched/loadavg.c:258:6: warning: no previous prototype for 'calc_load_nohz_remote' [-Wmissing-prototypes]
kernel/sched/loadavg.c:258:6: warning: no previous prototype for function 'calc_load_nohz_remote' [-Wmissing-prototypes]
kernel/sched/loadavg.c:263:6: warning: no previous prototype for 'calc_load_nohz_stop' [-Wmissing-prototypes]
kernel/sched/loadavg.c:263:6: warning: no previous prototype for function 'calc_load_nohz_stop' [-Wmissing-prototypes]
kernel/sched/sched.h:87:11: fatal error: 'asm/paravirt_api_clock.h' file not found
kernel/sched/sched.h:87:11: fatal error: asm/paravirt_api_clock.h: No such file or directory
ld.lld: error: kernel/built-in.a(kallsyms.o):(function get_symbol_offset: .text+0x3ae): relocation R_RISCV_PCREL_HI20 out of range: -524450 is not in [-524288, 524287]; references kallsyms_markers
ld.lld: error: kernel/built-in.a(kallsyms.o):(function get_symbol_offset: .text+0x3bc): relocation R_RISCV_PCREL_HI20 out of range: -524450 is not in [-524288, 524287]; references kallsyms_names
ld.lld: error: kernel/built-in.a(kallsyms.o):(function update_iter: .text+0x77c): relocation R_RISCV_PCREL_HI20 out of range: -524450 is not in [-524288, 524287]; references kallsyms_token_index
ld.lld: error: kernel/built-in.a(kallsyms.o):(function update_iter: .text+0x798): relocation R_RISCV_PCREL_HI20 out of range: -524450 is not in [-524288, 524287]; references kallsyms_token_table
lib/overflow_kunit.c:341 overflow_shift_test() warn: '(_a_full << _to_shift)' 32768 can't fit into 32767 '*_d'
lib/overflow_kunit.c:394 overflow_shift_test() warn: assigning 18446744073709551611 to unsigned variable '*_d'
nd_perf.c:(.text+0x14c): undefined reference to `perf_pmu_migrate_context'
nd_perf.c:(.text+0x242): undefined reference to `perf_pmu_migrate_context'
nd_perf.c:(.text+0x3f4): undefined reference to `perf_pmu_register'
nd_perf.c:(.text+0x464): undefined reference to `perf_pmu_register'
nd_perf.c:(.text+0x4e0): undefined reference to `perf_pmu_unregister'
nd_perf.c:(.text+0x5ac): undefined reference to `perf_pmu_unregister'
nd_perf.c:(.text+0x682): undefined reference to `perf_pmu_migrate_context'
net/ipv4/tcp_input.c:5012:2: warning: Value stored to 'reason' is never read [clang-analyzer-deadcode.DeadStores]
pahole: .tmp_vmlinux.btf: No such file or directory
security/integrity/evm/evm_secfs.c:159:3: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/smack/smackfs.c:1186:7: warning: Call to function 'sscanf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sscanf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
sound/soc/codecs/lpass-macro-common.c:53 lpass_macro_pds_init() warn: passing zero to 'ERR_PTR'
sound/usb/6fire/chip.c:130:2: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
sound/usb/line6/driver.c:770:2: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
sound/usb/usx2y/usbusx2y.c:382:2: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
{standard input}:1989: Error: unknown pseudo-op: `.sec'

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allmodconfig
|   |-- arch-alpha-include-asm-string.h:warning:__builtin_memcpy-forming-offset-is-out-of-the-bounds-of-object-tag_buf-with-type-unsigned-char
|   |-- drivers-iio-frequency-admv1014.c:sparse:sparse:dubious:x-y
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- alpha-allyesconfig
|   |-- arch-alpha-include-asm-string.h:warning:__builtin_memcpy-forming-offset-is-out-of-the-bounds-of-object-tag_buf-with-type-unsigned-char
|   |-- drivers-iio-frequency-admv1014.c:sparse:sparse:dubious:x-y
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- alpha-buildonly-randconfig-r004-20220320
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- alpha-randconfig-r021-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- alpha-randconfig-r026-20220321
|   `-- drivers-media-platform-samsung-exynos4-is-fimc-isp-video.h:warning:no-previous-prototype-for-fimc_isp_video_device_unregister
|-- arc-allmodconfig
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-allyesconfig
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-nsimosci_defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-nsimosci_hs_smp_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-randconfig-r032-20220320
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-randconfig-r032-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- arc-randconfig-r034-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- arc-randconfig-r043-20220320
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-randconfig-r043-20220321
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-randconfig-s031-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- arm-allmodconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- kernel-sched-sched.h:fatal-error:asm-paravirt_api_clock.h:No-such-file-or-directory
|-- arm-allyesconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- kernel-sched-sched.h:fatal-error:asm-paravirt_api_clock.h:No-such-file-or-directory
|-- arm-defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm-hisi_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm-randconfig-c002-20220320
|   `-- kernel-sched-sched.h:fatal-error:asm-paravirt_api_clock.h:No-such-file-or-directory
|-- arm-randconfig-c002-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- kernel-sched-sched.h:fatal-error:asm-paravirt_api_clock.h:No-such-file-or-directory
|-- arm-randconfig-c023-20220321
|   `-- kernel-sched-sched.h:fatal-error:asm-paravirt_api_clock.h:No-such-file-or-directory
|-- arm-randconfig-r012-20220320
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- kernel-sched-sched.h:fatal-error:asm-paravirt_api_clock.h:No-such-file-or-directory
|-- arm64-allmodconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm64-allyesconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm64-defconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm64-randconfig-r024-20220321
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm64-randconfig-r033-20220320
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- csky-allmodconfig
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- csky-allyesconfig
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- csky-defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- h8300-allmodconfig
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-media-platform-st-stm32-dma2d-dma2d-hw.c:internal-compiler-error:in-extract_insn-at-recog.c
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- include-linux-cacheflush.h:warning:struct-folio-declared-inside-parameter-list-will-not-be-visible-outside-of-this-definition-or-declaration
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- h8300-allyesconfig
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-media-platform-st-stm32-dma2d-dma2d-hw.c:internal-compiler-error:in-extract_insn-at-recog.c
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- include-linux-cacheflush.h:warning:struct-folio-declared-inside-parameter-list-will-not-be-visible-outside-of-this-definition-or-declaration
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- h8300-randconfig-r023-20220320
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- h8300-randconfig-r025-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-allmodconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-allnoconfig
|   `-- Documentation-driver-api-nvdimm-nvdimm.rst:(SEVERE-)-Title-level-inconsistent:
|-- i386-allyesconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-debian-10.3
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-debian-10.3-kselftests
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-defconfig
|   |-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-a011-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-a013-20220321
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-a014-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|-- i386-randconfig-a015-20220321
|   |-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-a016-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-c001-20220321
|   |-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-c021-20220321
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- i386-randconfig-m021-20220321
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|   `-- sound-soc-codecs-lpass-macro-common.c-lpass_macro_pds_init()-warn:passing-zero-to-ERR_PTR
|-- i386-randconfig-r022-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-s001
|   |-- drivers-gpu-drm-gma500-intel_bios.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-const-p-got-unsigned-char-noderef-usertype-__iomem
|   |-- drivers-gpu-drm-gma500-opregion.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-const-p-got-void-noderef-__iomem-assigned-base
|   |-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-s002
|   |-- drivers-gpu-drm-gma500-intel_bios.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-const-p-got-unsigned-char-noderef-usertype-__iomem
|   |-- drivers-gpu-drm-gma500-opregion.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-const-p-got-void-noderef-__iomem-assigned-base
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- ia64-allmodconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- ia64-allyesconfig
|   |-- (.text):undefined-reference-to-perf_pmu_register
|   |-- (.text):undefined-reference-to-perf_pmu_unregister
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   `-- nd_perf.c:(.text):undefined-reference-to-perf_pmu_migrate_context
|-- ia64-defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- m68k-allmodconfig
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- m68k-allyesconfig
|   |-- drivers-counter-quad-.c:sparse:sparse:incompatible-types-in-conditional-expression-(different-base-types):
|   |-- drivers-counter-quad-.c:sparse:unsigned-char
|   |-- drivers-counter-quad-.c:sparse:void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- m68k-buildonly-randconfig-r003-20220320
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- m68k-buildonly-randconfig-r004-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- m68k-defconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- m68k-mvme147_defconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- m68k-randconfig-m031-20220320
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- lib-overflow_kunit.c-overflow_shift_test()-warn:(_a_full-_to_shift)-can-t-fit-into-_d
|   `-- lib-overflow_kunit.c-overflow_shift_test()-warn:assigning-to-unsigned-variable-_d
|-- m68k-randconfig-r024-20220320
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- m68k-sun3x_defconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- microblaze-randconfig-r002-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- mips-allmodconfig
|   |-- drivers-gpu-drm-msm-adreno-a6xx_gmu.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-mem-got-void
|   |-- drivers-gpu-drm-msm-adreno-a6xx_gmu.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-volatile-noderef-__iomem-mem-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- mips-allyesconfig
|   |-- drivers-gpu-drm-msm-adreno-a6xx_gmu.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-mem-got-void
|   |-- drivers-gpu-drm-msm-adreno-a6xx_gmu.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-volatile-noderef-__iomem-mem-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- mips-db1xxx_defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- mips-randconfig-r015-20220320
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- nds32-allmodconfig
|   |-- Makefile:arch-nds32-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-nds32-Kconfig
|   `-- make:No-rule-to-make-target-arch-nds32-Makefile-.
|-- nds32-allnoconfig
|   |-- Makefile:arch-nds32-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-nds32-Kconfig
|   `-- make:No-rule-to-make-target-arch-nds32-Makefile-.
|-- nds32-allyesconfig
|   |-- Makefile:arch-nds32-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-nds32-Kconfig
|   `-- make:No-rule-to-make-target-arch-nds32-Makefile-.
|-- nds32-buildonly-randconfig-r005-20220320
|   |-- Makefile:arch-nds32-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-nds32-Kconfig
|   `-- make:No-rule-to-make-target-arch-nds32-Makefile-.
|-- nds32-defconfig
|   |-- Makefile:arch-nds32-Makefile:No-such-file-or-directory
|   `-- make:No-rule-to-make-target-arch-nds32-Makefile-.
|-- nds32-randconfig-c004-20220321
|   |-- Makefile:arch-nds32-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-nds32-Kconfig
|   `-- make:No-rule-to-make-target-arch-nds32-Makefile-.
|-- nds32-randconfig-c024-20220320
|   |-- Makefile:arch-nds32-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-nds32-Kconfig
|   `-- make:No-rule-to-make-target-arch-nds32-Makefile-.
|-- nds32-randconfig-m031-20220321
|   |-- Makefile:arch-nds32-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-nds32-Kconfig
|   `-- make:No-rule-to-make-target-arch-nds32-Makefile-.
|-- nds32-randconfig-r006-20220321
|   |-- Makefile:arch-nds32-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-nds32-Kconfig
|   `-- make:No-rule-to-make-target-arch-nds32-Makefile-.
|-- nds32-randconfig-r022-20220320
|   |-- Makefile:arch-nds32-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-nds32-Kconfig
|   `-- make:No-rule-to-make-target-arch-nds32-Makefile-.
|-- nios2-allmodconfig
|   |-- arch-nios2-kernel-misaligned.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-noderef-__user-to-got-unsigned-char-usertype-__pu_ptr
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- nios2-allyesconfig
|   |-- arch-nios2-kernel-misaligned.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-noderef-__user-to-got-unsigned-char-usertype-__pu_ptr
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- nios2-defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- nios2-randconfig-r004-20220321
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- openrisc-randconfig-c003-20220321
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- openrisc-randconfig-r003-20220320
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- openrisc-randconfig-r013-20220321
|   |-- drivers-infiniband-core-user_mad.c:warning:array-subscript-struct-ib_rmpp_mad-is-partly-outside-array-bounds-of-unsigned-char
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|   `-- pahole:.tmp_vmlinux.btf:No-such-file-or-directory
|-- parisc-allmodconfig
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- parisc-allyesconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- parisc-defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- powerpc-allmodconfig
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-scsi-lpfc-lpfc_els.c:sparse:left-side-has-type-unsigned-int
|   |-- drivers-scsi-lpfc-lpfc_els.c:sparse:right-side-has-type-restricted-__be32
|   |-- drivers-scsi-lpfc-lpfc_els.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-int-usertype-linkFailureCnt-got-restricted-__be32-usertype
|   |-- drivers-scsi-lpfc-lpfc_els.c:sparse:sparse:invalid-assignment:
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- powerpc-allyesconfig
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-scsi-lpfc-lpfc_els.c:sparse:left-side-has-type-unsigned-int
|   |-- drivers-scsi-lpfc-lpfc_els.c:sparse:right-side-has-type-restricted-__be32
|   |-- drivers-scsi-lpfc-lpfc_els.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-int-usertype-linkFailureCnt-got-restricted-__be32-usertype
|   |-- drivers-scsi-lpfc-lpfc_els.c:sparse:sparse:invalid-assignment:
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- powerpc-buildonly-randconfig-r003-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- powerpc-maple_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- powerpc-randconfig-m031-20220321
|   `-- drivers-ata-libata-sff.c-ata_sff_lost_interrupt()-error:uninitialized-symbol-status-.
|-- powerpc64-randconfig-r014-20220321
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- powerpc64-randconfig-r023-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- riscv-allmodconfig
|   |-- drivers-iio-frequency-admv1014.c:sparse:sparse:dubious:x-y
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- riscv-allyesconfig
|   |-- drivers-iio-frequency-admv1014.c:sparse:sparse:dubious:x-y
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- riscv-defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- riscv-nommu_k210_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- riscv-nommu_virt_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- riscv-randconfig-c024-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- riscv-randconfig-r042-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|   |-- nd_perf.c:(.text):undefined-reference-to-perf_pmu_migrate_context
|   |-- nd_perf.c:(.text):undefined-reference-to-perf_pmu_register
|   `-- nd_perf.c:(.text):undefined-reference-to-perf_pmu_unregister
|-- riscv-rv32_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- s390-allmodconfig
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- s390-allyesconfig
|   |-- drivers-iio-frequency-admv1014.c:sparse:sparse:dubious:x-y
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- include-linux-cacheflush.h:warning:struct-folio-declared-inside-parameter-list-will-not-be-visible-outside-of-this-definition-or-declaration
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- s390-defconfig
|   |-- arch-s390-kernel-machine_kexec.c:warning:memcpy-offset-is-out-of-the-bounds
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- s390-randconfig-c003-20220320
|   |-- arch-s390-kernel-machine_kexec.c:warning:memcpy-offset-is-out-of-the-bounds
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- nd_perf.c:(.text):undefined-reference-to-perf_pmu_migrate_context
|   |-- nd_perf.c:(.text):undefined-reference-to-perf_pmu_register
|   `-- nd_perf.c:(.text):undefined-reference-to-perf_pmu_unregister
|-- s390-randconfig-r036-20220320
|   |-- arch-s390-kernel-machine_kexec.c:warning:memcpy-offset-is-out-of-the-bounds
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- s390-randconfig-r044-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- sh-allmodconfig
|   |-- arch-sh-kernel-machvec.c:warning:array-subscript-struct-sh_machine_vector-is-partly-outside-array-bounds-of-long-int
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|   `-- standard-input:Error:unknown-pseudo-op:sec
|-- sh-rsk7201_defconfig
|   `-- arch-sh-kernel-machvec.c:warning:array-subscript-struct-sh_machine_vector-is-partly-outside-array-bounds-of-long-int
|-- sparc-allmodconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sparc-allyesconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sparc-randconfig-r002-20220320
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sparc-randconfig-r013-20220320
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sparc-randconfig-r035-20220321
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sparc64-randconfig-r004-20220320
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sparc64-randconfig-r031-20220320
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sparc64-randconfig-r031-20220321
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sparc64-randconfig-r034-20220320
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sparc64-randconfig-s032-20220321
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- um-i386_defconfig
|   |-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- um-x86_64_defconfig
|   |-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-allmodconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-allnoconfig
|   `-- Documentation-driver-api-nvdimm-nvdimm.rst:(SEVERE-)-Title-level-inconsistent:
|-- x86_64-allyesconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-defconfig
|   |-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-kexec
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-randconfig-a011-20220321
|   |-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- x86_64-randconfig-a012-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- x86_64-randconfig-a013-20220321
|   |-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-randconfig-a014-20220321
|   |-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-randconfig-a015-20220321
|   |-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- x86_64-randconfig-c002-20220321
|   |-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-randconfig-c022-20220321
|   |-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-randconfig-m001-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-rhel-8.3
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-rhel-8.3-func
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-rhel-8.3-kselftests
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-rhel-8.3-kunit
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- include-linux-rcupdate.h:error:dereferencing-pointer-to-incomplete-type-struct-css_set
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- xtensa-allyesconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- xtensa-cadence_csp_defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
`-- xtensa-randconfig-r005-20220321
    |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
    `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst

clang_recent_errors
|-- arm-am200epdkit_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- arm-collie_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- arm-ixp4xx_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- arm-neponset_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- arm-randconfig-c002-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- kernel-sched-sched.h:fatal-error:asm-paravirt_api_clock.h-file-not-found
|-- arm-randconfig-r016-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- kernel-sched-sched.h:fatal-error:asm-paravirt_api_clock.h-file-not-found
|-- arm-spear13xx_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- arm-spear3xx_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- arm64-randconfig-r026-20220320
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- lib-raid6-neon1.c:warning:mixing-declarations-and-code-is-incompatible-with-standards-before-C99
|   |-- lib-raid6-neon2.c:warning:mixing-declarations-and-code-is-incompatible-with-standards-before-C99
|   |-- lib-raid6-neon4.c:warning:mixing-declarations-and-code-is-incompatible-with-standards-before-C99
|   |-- lib-raid6-neon8.c:warning:mixing-declarations-and-code-is-incompatible-with-standards-before-C99
|   `-- lib-raid6-recov_neon_inner.c:warning:mixing-declarations-and-code-is-incompatible-with-standards-before-C99
|-- hexagon-buildonly-randconfig-r005-20220321
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- hexagon-buildonly-randconfig-r006-20220320
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- hexagon-buildonly-randconfig-r006-20220321
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- hexagon-randconfig-r021-20220320
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- hexagon-randconfig-r036-20220321
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- hexagon-randconfig-r041-20220320
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- hexagon-randconfig-r041-20220321
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- hexagon-randconfig-r045-20220320
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- hexagon-randconfig-r045-20220321
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- i386-allmodconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- i386-randconfig-a001-20220321
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- i386-randconfig-a002-20220321
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- i386-randconfig-a003-20220321
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- i386-randconfig-a004-20220321
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- i386-randconfig-a005-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- i386-randconfig-a006-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- i386-randconfig-c001-20220321
|   |-- drivers-hid-hid-core.c:warning:Although-the-value-stored-to-field-is-used-in-the-enclosing-expression-the-value-is-never-actually-read-from-field-clang-analyzer-deadcode.DeadStores
|   |-- drivers-hwmon-da9055-hwmon.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous
|   |-- drivers-hwmon-vt8231.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-funct
|   |-- drivers-input-serio-ps2-gpio.c:warning:Value-stored-to-rxflags-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- drivers-misc-mei-main.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-func
|   |-- drivers-mtd-maps-amd76xrom.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous
|   |-- drivers-mtd-maps-ck804xrom.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous
|   |-- drivers-pci-vgaarb.c:warning:Value-stored-to-dev-during-its-initialization-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- drivers-video-fbdev-matrox-matroxfb_base.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|   |-- net-ipv4-tcp_input.c:warning:Value-stored-to-reason-is-never-read-clang-analyzer-deadcode.DeadStores
|   `-- security-smack-smackfs.c:warning:Call-to-function-sscanf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-func
|-- mips-allnoconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- mips-omega2p_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- mips-randconfig-c004-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- riscv-buildonly-randconfig-r002-20220320
|   |-- drivers-spi-spi-amd.c:warning:cast-to-smaller-integer-type-enum-amd_spi_versions-from-const-void
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|   |-- ld.lld:error:kernel-built-in.a(kallsyms.o):(function-get_symbol_offset:.text):relocation-R_RISCV_PCREL_HI20-out-of-range:is-not-in-references-kallsyms_markers
|   |-- ld.lld:error:kernel-built-in.a(kallsyms.o):(function-get_symbol_offset:.text):relocation-R_RISCV_PCREL_HI20-out-of-range:is-not-in-references-kallsyms_names
|   |-- ld.lld:error:kernel-built-in.a(kallsyms.o):(function-kallsyms_open:.text):relocation-R_RISCV_PCREL_HI20-out-of-range:is-not-in-references-kallsyms_markers
|   |-- ld.lld:error:kernel-built-in.a(kallsyms.o):(function-update_iter:.text):relocation-R_RISCV_PCREL_HI20-out-of-range:is-not-in-references-kallsyms_offsets
|   |-- ld.lld:error:kernel-built-in.a(kallsyms.o):(function-update_iter:.text):relocation-R_RISCV_PCREL_HI20-out-of-range:is-not-in-references-kallsyms_token_index
|   `-- ld.lld:error:kernel-built-in.a(kallsyms.o):(function-update_iter:.text):relocation-R_RISCV_PCREL_HI20-out-of-range:is-not-in-references-kallsyms_token_table
|-- riscv-randconfig-c006-20220321
|   |-- drivers-clk-imx-clk-pll14xx.c:warning:Value-stored-to-pll_div_ctl1-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- drivers-firmware-turris-mox-rwtm.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-ana
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link.c:warning:Dereference-of-null-pointer-clang-analyzer-core.NullDereference
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml-calcs-dce_calcs.c:warning:Value-stored-to-num_cursor_lines-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:Value-stored-to-res-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c:warning:Undefined-or-garbage-value-returned-to-caller-clang-analyzer-core.uninitialized.UndefReturn
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_xgmi.c:warning:Value-stored-to-ret-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- drivers-gpu-drm-selftests-test-drm_buddy.c:warning:Value-stored-to-err-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- drivers-hid-hid-core.c:warning:Although-the-value-stored-to-field-is-used-in-the-enclosing-expression-the-value-is-never-actually-read-from-field-clang-analyzer-deadcode.DeadStores
|   |-- drivers-hwmon-nsa320-hwmon.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous
|   |-- drivers-leds-trigger-ledtrig-tty.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-ana
|   |-- drivers-pci-vgaarb.c:warning:Value-stored-to-dev-during-its-initialization-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- drivers-phy-broadcom-phy-brcm-usb.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-an
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   `-- net-ipv4-tcp_input.c:warning:Value-stored-to-reason-is-never-read-clang-analyzer-deadcode.DeadStores
|-- riscv-randconfig-r016-20220320
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- riscv-randconfig-r042-20220320
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- s390-randconfig-c005-20220321
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- s390-randconfig-r044-20220320
|   |-- drivers-spi-spi-amd.c:warning:cast-to-smaller-integer-type-enum-amd_spi_versions-from-const-void
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- x86_64-randconfig-a001-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- x86_64-randconfig-a002-20220321
|   |-- drivers-spi-spi-amd.c:warning:cast-to-smaller-integer-type-enum-amd_spi_versions-from-const-void
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- x86_64-randconfig-a003-20220321
|   |-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- x86_64-randconfig-a004-20220321
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- x86_64-randconfig-a005-20220321
|   |-- drivers-spi-spi-amd.c:warning:cast-to-smaller-integer-type-enum-amd_spi_versions-from-const-void
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- x86_64-randconfig-a006-20220321
|   |-- drivers-spi-spi-amd.c:warning:cast-to-smaller-integer-type-enum-amd_spi_versions-from-const-void
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- x86_64-randconfig-c007-20220321
|   |-- arch-x86-kernel-cpu-mce-inject.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analo
|   |-- drivers-hid-hid-core.c:warning:Although-the-value-stored-to-field-is-used-in-the-enclosing-expression-the-value-is-never-actually-read-from-field-clang-analyzer-deadcode.DeadStores
|   |-- drivers-input-serio-ps2-gpio.c:warning:Value-stored-to-rxflags-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- drivers-platform-x86-asus-laptop.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-ana
|   |-- drivers-platform-x86-fujitsu-tablet.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-
|   |-- drivers-platform-x86-think-lmi.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analo
|   |-- drivers-usb-typec-rt1719.c:warning:Assigned-value-is-garbage-or-undefined-clang-analyzer-core.uninitialized.Assign
|   |-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|   |-- net-ipv4-tcp_input.c:warning:Value-stored-to-reason-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- security-integrity-evm-evm_secfs.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-ana
|   |-- sound-usb-6fire-chip.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-funct
|   |-- sound-usb-line6-driver.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-fun
|   `-- sound-usb-usx2y-usbusx2y.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-f
`-- x86_64-randconfig-r003-20220321
    |-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
    |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
    |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
    |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
    |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
    |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
    |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
    |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
    |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
    |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
    |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
    |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
    |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
    `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop

elapsed time: 726m

configs tested: 128
configs skipped: 3

gcc tested configs:
arm                                 defconfig
arm64                               defconfig
arm64                            allyesconfig
arm                              allmodconfig
arm                              allyesconfig
i386                             allyesconfig
ia64                             allmodconfig
ia64                             allyesconfig
x86_64                    rhel-8.3-kselftests
i386                 randconfig-c001-20220321
um                             i386_defconfig
mips                             allmodconfig
riscv                            allmodconfig
um                           x86_64_defconfig
mips                             allyesconfig
riscv                            allyesconfig
sparc                            allyesconfig
alpha                            allyesconfig
arc                              allyesconfig
nios2                            allyesconfig
arm                        trizeps4_defconfig
arc                 nsimosci_hs_smp_defconfig
mips                           ip32_defconfig
xtensa                  cadence_csp_defconfig
m68k                             alldefconfig
m68k                       m5475evb_defconfig
mips                         db1xxx_defconfig
sh                         ecovec24_defconfig
arm                             rpc_defconfig
powerpc                       maple_defconfig
sh                        edosk7760_defconfig
arc                        nsimosci_defconfig
sh                          rsk7201_defconfig
sh                      rts7751r2d1_defconfig
m68k                          sun3x_defconfig
sh                        apsh4ad0a_defconfig
parisc                generic-64bit_defconfig
m68k                        mvme147_defconfig
arm                            hisi_defconfig
arm                  randconfig-c002-20220320
arm                  randconfig-c002-20220321
ia64                                defconfig
m68k                                defconfig
m68k                             allyesconfig
m68k                             allmodconfig
csky                                defconfig
alpha                               defconfig
nds32                               defconfig
arc                                 defconfig
sh                               allmodconfig
xtensa                           allyesconfig
h8300                            allyesconfig
parisc                              defconfig
s390                                defconfig
parisc64                            defconfig
s390                             allmodconfig
s390                             allyesconfig
parisc                           allyesconfig
i386                              debian-10.3
i386                   debian-10.3-kselftests
i386                                defconfig
sparc                               defconfig
nds32                             allnoconfig
nios2                               defconfig
powerpc                           allnoconfig
powerpc                          allmodconfig
powerpc                          allyesconfig
x86_64               randconfig-a013-20220321
x86_64               randconfig-a012-20220321
x86_64               randconfig-a014-20220321
x86_64               randconfig-a011-20220321
x86_64               randconfig-a016-20220321
x86_64               randconfig-a015-20220321
i386                 randconfig-a014-20220321
i386                 randconfig-a013-20220321
i386                 randconfig-a016-20220321
i386                 randconfig-a015-20220321
i386                 randconfig-a011-20220321
i386                 randconfig-a012-20220321
arc                  randconfig-r043-20220320
riscv                randconfig-r042-20220321
s390                 randconfig-r044-20220321
arc                  randconfig-r043-20220321
riscv                    nommu_k210_defconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
x86_64                              defconfig
x86_64                                  kexec
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit
x86_64                           allyesconfig

clang tested configs:
powerpc              randconfig-c003-20220321
x86_64               randconfig-c007-20220321
arm                  randconfig-c002-20220321
i386                 randconfig-c001-20220321
mips                 randconfig-c004-20220321
s390                 randconfig-c005-20220321
riscv                randconfig-c006-20220321
arm                     am200epdkit_defconfig
arm                        spear3xx_defconfig
arm                        neponset_defconfig
arm                       spear13xx_defconfig
powerpc                    gamecube_defconfig
arm                          collie_defconfig
powerpc                    mvme5100_defconfig
mips                  cavium_octeon_defconfig
arm                          ixp4xx_defconfig
mips                       lemote2f_defconfig
mips                        omega2p_defconfig
x86_64               randconfig-a002-20220321
x86_64               randconfig-a003-20220321
x86_64               randconfig-a005-20220321
x86_64               randconfig-a004-20220321
x86_64               randconfig-a001-20220321
x86_64               randconfig-a006-20220321
i386                 randconfig-a003-20220321
i386                 randconfig-a004-20220321
i386                 randconfig-a005-20220321
i386                 randconfig-a001-20220321
i386                 randconfig-a006-20220321
i386                 randconfig-a002-20220321
hexagon              randconfig-r041-20220321
hexagon              randconfig-r045-20220321
hexagon              randconfig-r045-20220320
hexagon              randconfig-r041-20220320
s390                 randconfig-r044-20220320
riscv                randconfig-r042-20220320

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
