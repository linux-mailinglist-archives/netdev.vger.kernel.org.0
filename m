Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8294F9EBA
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 23:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239664AbiDHVHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 17:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbiDHVHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 17:07:07 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B4913925E;
        Fri,  8 Apr 2022 14:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649451900; x=1680987900;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=ecQ6sxksjqN2PixN4hAYCOpaaA6nwFnyhiWt1TWhGuY=;
  b=Gu/MvOPvhmCTD9Myb0INAlSh/Uqcw6q0jCEHE+ZDbLN+fCXfNKXGyUqH
   71m/S2xi4/xuW9P/tev5UveyOTUqJwN+svAigLx6YXrH2YMVs57oyyU/B
   rphuFPb6AH0wkDF2UCX8CZmJMqOhY2mhpyIc3uzwSUNZn8lCX5kCaK/Wz
   uggwZn1OSXnvgGB1FPiq9fiqP7RTEdzijDe2OZj7afWZ5gUn8OJZwWFZE
   fmvCdkm38QdaJikTySbNtI9Cfp0jApWnAyi6+ua9YiX3wfAHGK+XKM4M6
   v31uLneT5HTinvIhIHEp8WYb7s5YYU9opTwC//Nd54a1SqQVb3u6dlJiA
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10311"; a="348121204"
X-IronPort-AV: E=Sophos;i="5.90,246,1643702400"; 
   d="scan'208";a="348121204"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 14:04:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,246,1643702400"; 
   d="scan'208";a="643035702"
Received: from lkp-server02.sh.intel.com (HELO 7e80bc2a00a0) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Apr 2022 14:04:51 -0700
Received: from kbuild by 7e80bc2a00a0 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ncvmk-0000dl-Oy;
        Fri, 08 Apr 2022 21:04:50 +0000
Date:   Sat, 09 Apr 2022 05:04:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     virtualization@lists.linux-foundation.org, rcu@vger.kernel.org,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-wireless@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-nvme@lists.infradead.org, linux-mtd@lists.infradead.org,
        linux-modules@vger.kernel.org, linux-mm@kvack.org,
        linux-media@vger.kernel.org, linux-input@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, io-uring@vger.kernel.org,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        cgroups@vger.kernel.org, autofs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, alsa-devel@alsa-project.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 ff511c1c68a5a35ab0b3efb3c306fd80b10d74be
Message-ID: <6250a340.ns5F04hmupCdJliY%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: ff511c1c68a5a35ab0b3efb3c306fd80b10d74be  Add linux-next specific files for 20220408

Error/Warning reports:

https://lore.kernel.org/linux-mm/202203160358.yulPl6b4-lkp@intel.com
https://lore.kernel.org/linux-mm/202204081656.6x4pfen4-lkp@intel.com
https://lore.kernel.org/llvm/202203241958.Uw9bWfMD-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

ERROR: dtschema minimum version is v2022.3
ERROR: modpost: "__aeabi_uldivmod" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
drivers/bus/mhi/host/main.c:792:13: warning: parameter 'event_quota' set but not used [-Wunused-but-set-parameter]
drivers/gpu/drm/amd/amdgpu/../display/dc/virtual/virtual_link_hwss.c:32:6: warning: no previous prototype for 'virtual_setup_stream_attribute' [-Wmissing-prototypes]
freesync.c:(.text+0x25cc): undefined reference to `__aeabi_uldivmod'
kernel/sched/sched.h: linux/static_key.h is included more than once.

Unverified Error/Warning (likely false positive, please contact us if interested):

Makefile:684: arch/h8300/Makefile: No such file or directory
arch/Kconfig:10: can't open file "arch/h8300/Kconfig"
arch/riscv/kernel/cacheinfo.c:189:1: internal compiler error: Segmentation fault
arch/riscv/kernel/patch.c:133:1: internal compiler error: Segmentation fault
arch/riscv/kernel/signal.c:323:1: internal compiler error: Segmentation fault
arch/riscv/mm/extable.c:71:1: internal compiler error: Segmentation fault
arch/s390/include/asm/spinlock.h:81:3: error: unexpected token in '.rept' directive
arch/s390/include/asm/spinlock.h:81:3: error: unknown directive
arch/s390/include/asm/spinlock.h:81:3: error: unmatched '.endr' directive
arch/s390/lib/spinlock.c:78:3: error: unexpected token in '.rept' directive
arch/s390/lib/spinlock.c:78:3: error: unknown directive
arch/s390/lib/spinlock.c:78:3: error: unmatched '.endr' directive
block/blk-zoned.c:641:1: internal compiler error: Segmentation fault
crypto/acompress.c:198:1: internal compiler error: Segmentation fault
crypto/aead.c:303:1: internal compiler error: Segmentation fault
crypto/ahash.c:660:1: internal compiler error: Segmentation fault
crypto/akcipher.c:158:1: internal compiler error: Segmentation fault
crypto/api.c:660:1: internal compiler error: Segmentation fault
crypto/ecc.c:1668:1: internal compiler error: Segmentation fault
crypto/geniv.c:163:1: internal compiler error: Segmentation fault
crypto/gf128mul.c:416:1: internal compiler error: Segmentation fault
crypto/kpp.c:144:1: internal compiler error: Segmentation fault
crypto/rng.c:228:1: internal compiler error: Segmentation fault
crypto/scompress.c:305:1: internal compiler error: Segmentation fault
crypto/shash.c:627:1: internal compiler error: Segmentation fault
crypto/skcipher.c:984:1: internal compiler error: Segmentation fault
drivers/base/map.c:154:1: internal compiler error: Segmentation fault
drivers/base/regmap/regcache-flat.c:83:1: internal compiler error: Segmentation fault
drivers/base/regmap/regcache-rbtree.c:553:1: internal compiler error: Segmentation fault
drivers/base/regmap/regcache.c:785:1: internal compiler error: Segmentation fault
drivers/base/regmap/regmap-debugfs.c:692:1: internal compiler error: Segmentation fault
drivers/base/regmap/regmap-mmio.c:453:1: internal compiler error: Segmentation fault
drivers/clk/clk-composite.c:487:1: internal compiler error: Segmentation fault
drivers/clk/clk-fractional-divider.c:259:1: internal compiler error: Segmentation fault
drivers/counter/104-quad-8.c:150:9: sparse:    unsigned char
drivers/counter/104-quad-8.c:150:9: sparse:    void
drivers/counter/104-quad-8.c:150:9: sparse: sparse: incompatible types in conditional expression (different base types):
drivers/crypto/ccree/cc_aead.c:2664:1: internal compiler error: Segmentation fault
drivers/crypto/ccree/cc_buffer_mgr.c:1390:1: internal compiler error: Segmentation fault
drivers/crypto/ccree/cc_cipher.c:1509:1: internal compiler error: Segmentation fault
drivers/crypto/ccree/cc_fips.c:154:1: internal compiler error: Segmentation fault
drivers/crypto/ccree/cc_hash.c:2315:1: internal compiler error: Segmentation fault
drivers/crypto/ccree/cc_request_mgr.c:662:1: internal compiler error: Segmentation fault
drivers/crypto/ccree/cc_sram_mgr.c:91:1: internal compiler error: Segmentation fault
drivers/dma-buf/dma-heap.c:324:1: internal compiler error: Segmentation fault
drivers/dma-buf/st-dma-fence-unwrap.c:125:13: warning: variable 'err' set but not used [-Wunused-but-set-variable]
drivers/dma-buf/st-dma-fence-unwrap.c:261:1: internal compiler error: Segmentation fault
drivers/gpio/gpiolib-of.c:1055:1: internal compiler error: Segmentation fault
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn31/dcn31_hubp.c:57:6: warning: no previous prototype for 'hubp31_program_extended_blank' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c:1283 amdgpu_cs_submit() warn: ignoring unreachable code.
drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c:984:1: internal compiler error: Segmentation fault
drivers/gpu/drm/selftests/test-drm_buddy.c:525:7: warning: Value stored to 'err' is never read [clang-analyzer-deadcode.DeadStores]
drivers/hid/hid-debug.c:1269:1: internal compiler error: Segmentation fault
drivers/hid/hid-vivaldi-common.c:140:1: internal compiler error: Segmentation fault
drivers/iio/test/iio-test-rescale.c:32:30: sparse: sparse: symbol 'scale_cases' was not declared. Should it be static?
drivers/iio/test/iio-test-rescale.c:480:30: sparse: sparse: symbol 'offset_cases' was not declared. Should it be static?
drivers/input/input-poller.c:222:1: internal compiler error: Segmentation fault
drivers/input/matrix-keymap.c:202:1: internal compiler error: Segmentation fault
drivers/input/rmi4/rmi_f01.c:729:1: internal compiler error: Segmentation fault
drivers/input/rmi4/rmi_f03.c:328:1: internal compiler error: Segmentation fault
drivers/input/rmi4/rmi_f30.c:405:1: internal compiler error: Segmentation fault
drivers/input/touchscreen.c:207:1: internal compiler error: Segmentation fault
drivers/iommu/of_iommu.c:174:1: internal compiler error: Segmentation fault
drivers/mfd/mfd-core.c:440:1: internal compiler error: Segmentation fault
drivers/mtd/chips/cfi_cmdset_0020.c:1401:1: internal compiler error: Segmentation fault
drivers/mtd/nand/ecc-mxic.c:523:17: warning: Value stored to 'dev' during its initialization is never read [clang-analyzer-deadcode.DeadStores]
drivers/mtd/nand/ecc-mxic.c:595:6: warning: Branch condition evaluates to a garbage value [clang-analyzer-core.uninitialized.Branch]
drivers/mtd/nand/ecc-sw-hamming.c:660:1: internal compiler error: Segmentation fault
drivers/mtd/nand/raw/denali.c:1381:1: internal compiler error: Segmentation fault
drivers/mtd/nand/raw/nand_base.c:6464:1: internal compiler error: Segmentation fault
drivers/mtd/nand/raw/nand_hynix.c:735:1: internal compiler error: Segmentation fault
drivers/mtd/nand/raw/nand_jedec.c:139:1: internal compiler error: Segmentation fault
drivers/mtd/nand/raw/nand_legacy.c:644:1: internal compiler error: Segmentation fault
drivers/mtd/nand/raw/nand_macronix.c:334:1: internal compiler error: Segmentation fault
drivers/mtd/nand/raw/nand_micron.c:599:1: internal compiler error: Segmentation fault
drivers/mtd/nand/raw/nand_onfi.c:337:1: internal compiler error: Segmentation fault
drivers/mtd/nand/raw/nand_samsung.c:139:1: internal compiler error: Segmentation fault
drivers/mtd/nand/raw/nand_timings.c:737:1: internal compiler error: Segmentation fault
drivers/mtd/nand/raw/nand_toshiba.c:300:1: internal compiler error: Segmentation fault
drivers/net/vxlan/vxlan_core.c:440:34: sparse: sparse: incorrect type in argument 2 (different base types)
drivers/nvme/host/zns.c:250:1: internal compiler error: Segmentation fault
drivers/of/kobj.c:165:1: internal compiler error: Segmentation fault
drivers/pci/vgaarb.c:213:17: warning: Value stored to 'dev' during its initialization is never read [clang-analyzer-deadcode.DeadStores]
drivers/phy/broadcom/phy-brcm-usb.c:233:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/scsi/ufs/ufs-sysfs.c:1267:1: internal compiler error: Segmentation fault
drivers/ssb/driver_chipcommon.c:598:1: internal compiler error: Segmentation fault
drivers/ssb/scan.c:446:1: internal compiler error: Segmentation fault
drivers/usb/chipidea/core.c:956:10: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/gadget/configfs.c:237:8: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/gadget/udc/core.c:1664:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/typec/altmodes/displayport.c:396:8: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/vfio/mdev/vfio_mdev.c:152:1: internal compiler error: Segmentation fault
drivers/virtio/virtio_ring.c:2448:1: internal compiler error: Segmentation fault
drivers/w1/w1_family.c:130:1: internal compiler error: Segmentation fault
fs/autofs/expire.c:620:1: internal compiler error: Segmentation fault
fs/autofs/inode.c:385:1: internal compiler error: Segmentation fault
fs/autofs/root.c:919:1: internal compiler error: Segmentation fault
fs/autofs/symlink.c:26:1: internal compiler error: Segmentation fault
fs/autofs/waitq.c:512:1: internal compiler error: Segmentation fault
fs/btrfs/async-thread.c:419:1: internal compiler error: Segmentation fault
fs/btrfs/block-rsv.c:558:1: internal compiler error: Segmentation fault
fs/btrfs/delalloc-space.c:489:1: internal compiler error: Segmentation fault
fs/btrfs/dir-item.c:441:1: internal compiler error: Segmentation fault
fs/btrfs/discard.c:723:1: internal compiler error: Segmentation fault
fs/btrfs/export.c:281:1: internal compiler error: Segmentation fault
fs/btrfs/locking.c:291:1: internal compiler error: Segmentation fault
fs/btrfs/print-tree.c:411:1: internal compiler error: Segmentation fault
fs/btrfs/root-tree.c:546:1: internal compiler error: Segmentation fault
fs/btrfs/tree-defrag.c:132:1: internal compiler error: Segmentation fault
fs/btrfs/ulist.c:276:1: internal compiler error: Segmentation fault
fs/btrfs/uuid-tree.c:390:1: internal compiler error: Segmentation fault
fs/btrfs/zlib.c:462:1: internal compiler error: Segmentation fault
fs/btrfs/zstd.c:706:1: internal compiler error: Segmentation fault
fs/configfs/file.c:482:1: internal compiler error: Segmentation fault
fs/configfs/inode.c:244:1: internal compiler error: Segmentation fault
fs/configfs/symlink.c:269:1: internal compiler error: Segmentation fault
fs/crypto/hkdf.c:182:1: internal compiler error: Segmentation fault
fs/crypto/keysetup_v1.c:319:1: internal compiler error: Segmentation fault
fs/d_path.c:448:1: internal compiler error: Segmentation fault
fs/eventfd.c:457:1: internal compiler error: Segmentation fault
fs/exportfs/expfs.c:586:1: internal compiler error: Segmentation fault
fs/fs_context.c:717:1: internal compiler error: Segmentation fault
fs/fs_pin.c:97:1: internal compiler error: Segmentation fault
fs/fs_struct.c:168:1: internal compiler error: Segmentation fault
fs/fsopen.c:469:1: internal compiler error: Segmentation fault
fs/ioctl.c:875:1: internal compiler error: Segmentation fault
fs/kernfs/dir.c:1769:1: internal compiler error: Segmentation fault
fs/kernfs/file.c:1017:1: internal compiler error: Segmentation fault
fs/kernfs/inode.c:446:1: internal compiler error: Segmentation fault
fs/kernfs/symlink.c:153:1: internal compiler error: Segmentation fault
fs/nls/nls_base.c:548:1: internal compiler error: Segmentation fault
fs/overlayfs/dir.c:1315:1: internal compiler error: Segmentation fault
fs/overlayfs/export.c:872:1: internal compiler error: Segmentation fault
fs/overlayfs/inode.c:1196:1: internal compiler error: Segmentation fault
fs/overlayfs/namei.c:1191:1: internal compiler error: Segmentation fault
fs/overlayfs/readdir.c:1233:1: internal compiler error: Segmentation fault
fs/overlayfs/util.c:1062:1: internal compiler error: Segmentation fault
fs/pnode.c:602:1: internal compiler error: Segmentation fault
fs/posix_acl.c:1018:1: internal compiler error: Segmentation fault
fs/quota/quota.c:1013:1: internal compiler error: Segmentation fault
fs/readdir.c:384:1: internal compiler error: Segmentation fault
fs/select.c:1123:1: internal compiler error: Segmentation fault
fs/splice.c:1721:1: internal compiler error: Segmentation fault
fs/statfs.c:264:1: internal compiler error: Segmentation fault
fs/sync.c:382:1: internal compiler error: Segmentation fault
fs/unicode/utf8-core.c:217:1: internal compiler error: Segmentation fault
fs/utimes.c:164:1: internal compiler error: Segmentation fault
fs/xattr.c:1183:1: internal compiler error: Segmentation fault
include/linux/module.h:274:46: internal compiler error: Segmentation fault
kernel/cgroup/freezer.c:323:1: internal compiler error: Segmentation fault
kernel/dma/direct.c:633:1: internal compiler error: Segmentation fault
kernel/irq/chip.c:1606:1: internal compiler error: Segmentation fault
kernel/module/kallsyms.c:473:1: internal compiler error: Segmentation fault
kernel/module/strict_rwx.c:143:1: internal compiler error: Segmentation fault
kernel/module/sysfs.c:436:1: internal compiler error: Segmentation fault
kernel/module/tree_lookup.c:117:1: internal compiler error: Segmentation fault
kernel/range.c:165:1: internal compiler error: Segmentation fault
kernel/rcu/rcu_segcblist.c:633:1: internal compiler error: Segmentation fault
kernel/rcu/sync.c:206:1: internal compiler error: Segmentation fault
kernel/sched/core.c:5268:20: warning: no previous prototype for function 'task_sched_runtime' [-Wmissing-prototypes]
kernel/sched/core.c:8997:6: warning: no previous prototype for 'idle_task_exit' [-Wmissing-prototypes]
kernel/sched/core.c:8997:6: warning: no previous prototype for function 'idle_task_exit' [-Wmissing-prototypes]
kernel/sched/core.c:9232:5: warning: no previous prototype for 'sched_cpu_activate' [-Wmissing-prototypes]
kernel/sched/core.c:9232:5: warning: no previous prototype for function 'sched_cpu_activate' [-Wmissing-prototypes]
kernel/sched/core.c:9277:5: warning: no previous prototype for 'sched_cpu_deactivate' [-Wmissing-prototypes]
kernel/sched/core.c:9277:5: warning: no previous prototype for function 'sched_cpu_deactivate' [-Wmissing-prototypes]
kernel/sched/core.c:9352:5: warning: no previous prototype for 'sched_cpu_starting' [-Wmissing-prototypes]
kernel/sched/core.c:9352:5: warning: no previous prototype for function 'sched_cpu_starting' [-Wmissing-prototypes]
kernel/sched/core.c:9373:5: warning: no previous prototype for 'sched_cpu_wait_empty' [-Wmissing-prototypes]
kernel/sched/core.c:9373:5: warning: no previous prototype for function 'sched_cpu_wait_empty' [-Wmissing-prototypes]
kernel/sched/core.c:9415:5: warning: no previous prototype for 'sched_cpu_dying' [-Wmissing-prototypes]
kernel/sched/core.c:9415:5: warning: no previous prototype for function 'sched_cpu_dying' [-Wmissing-prototypes]
kernel/sched/core.c:9438:13: warning: no previous prototype for function 'sched_init_smp' [-Wmissing-prototypes]
kernel/sched/core.c:9471:13: warning: no previous prototype for function 'sched_init_smp' [-Wmissing-prototypes]
kernel/sched/core.c:9499:13: warning: no previous prototype for function 'sched_init' [-Wmissing-prototypes]
kernel/sched/fair.c:10665:6: warning: no previous prototype for 'nohz_balance_enter_idle' [-Wmissing-prototypes]
kernel/sched/fair.c:10665:6: warning: no previous prototype for function 'nohz_balance_enter_idle' [-Wmissing-prototypes]
kernel/sched/loadavg.c:245:6: warning: no previous prototype for 'calc_load_nohz_start' [-Wmissing-prototypes]
kernel/sched/loadavg.c:245:6: warning: no previous prototype for function 'calc_load_nohz_start' [-Wmissing-prototypes]
kernel/sched/loadavg.c:258:6: warning: no previous prototype for 'calc_load_nohz_remote' [-Wmissing-prototypes]
kernel/sched/loadavg.c:258:6: warning: no previous prototype for function 'calc_load_nohz_remote' [-Wmissing-prototypes]
kernel/sched/loadavg.c:263:6: warning: no previous prototype for 'calc_load_nohz_stop' [-Wmissing-prototypes]
kernel/sched/loadavg.c:263:6: warning: no previous prototype for function 'calc_load_nohz_stop' [-Wmissing-prototypes]
kernel/sys.c:2711:1: internal compiler error: Segmentation fault
kernel/task_work.c:169:1: internal compiler error: Segmentation fault
kernel/trace/trace_clock.c:158:1: internal compiler error: Segmentation fault
kernel/umh.c:564:1: internal compiler error: Segmentation fault
lib/asn1_decoder.c:521:1: internal compiler error: Segmentation fault
lib/crc-itu-t.c:66:1: internal compiler error: Segmentation fault
lib/crc16.c:64:1: internal compiler error: Segmentation fault
lib/crypto/aes.c:356:1: internal compiler error: Segmentation fault
lib/crypto/blake2s-generic.c:115:1: internal compiler error: Segmentation fault
lib/crypto/poly1305.c:78:1: internal compiler error: Segmentation fault
lib/extable.c:118:1: internal compiler error: Segmentation fault
lib/fdt.c:3: internal compiler error: Segmentation fault
lib/fdt_ro.c:3: internal compiler error: Segmentation fault
lib/fdt_rw.c:3: internal compiler error: Segmentation fault
lib/fdt_sw.c:3: internal compiler error: Segmentation fault
lib/fdt_wip.c:3: internal compiler error: Segmentation fault
lib/flex_proportions.c:282:1: internal compiler error: Segmentation fault
lib/iov_iter.c:2067:1: internal compiler error: Segmentation fault
lib/is_single_threaded.c:54:1: internal compiler error: Segmentation fault
lib/linear_ranges.c:276:1: internal compiler error: Segmentation fault
lib/logic_pio.c:232:1: internal compiler error: Segmentation fault
lib/lz4/lz4_compress.c:940:1: internal compiler error: Segmentation fault
lib/lz4/lz4_decompress.c:719:1: internal compiler error: Segmentation fault
lib/lzo/lzo1x_compress.c:400:1: internal compiler error: Segmentation fault
lib/lzo/lzo1x_decompress_safe.c:294:1: internal compiler error: Segmentation fault
lib/math/rational.c:111:1: internal compiler error: Segmentation fault
lib/mpi/generic_mpih-mul2.c:47:1: internal compiler error: Segmentation fault
lib/mpi/generic_mpih-mul3.c:48:1: internal compiler error: Segmentation fault
lib/mpi/mpi-div.c:234:1: internal compiler error: Segmentation fault
lib/mpi/mpi-mod.c:157:1: internal compiler error: Segmentation fault
lib/mpi/mpih-div.c:517:1: internal compiler error: Segmentation fault
lib/mpi/mpih-mul.c:509:1: internal compiler error: Segmentation fault
lib/plist.c:173:1: internal compiler error: Segmentation fault
lib/raid6/int1.c:154:1: internal compiler error: Segmentation fault
lib/raid6/int2.c:180:1: internal compiler error: Segmentation fault
lib/raid6/int4.c:232:1: internal compiler error: Segmentation fault
lib/raid6/int8.c:336:1: internal compiler error: Segmentation fault
lib/seq_buf.c:397:1: internal compiler error: Segmentation fault
lib/stackinit_kunit.c:259:8: warning: Excessive padding in 'struct test_big_hole' (124 padding bytes, where 60 is optimal).
lib/stackinit_kunit.c:339:1: warning: Address of stack memory associated with local variable 'var' is still referred to by the global variable 'fill_start' upon returning to the caller.  This will be a dangling reference [clang-analyzer-core.StackAddressEscape]
lib/stackinit_kunit.c:339:1: warning: Address of stack memory associated with local variable 'var' is still referred to by the global variable 'target_start' upon returning to the caller.  This will be a dangling reference [clang-analyzer-core.StackAddressEscape]
lib/stackinit_kunit.c:343:1: warning: Undefined or garbage value returned to caller [clang-analyzer-core.uninitialized.UndefReturn]
lib/syscall.c:88:1: internal compiler error: Segmentation fault
lib/vsprintf.c:2781:5: warning: Null pointer passed as 1st argument to memory copy function [clang-analyzer-unix.cstring.NullArg]
lib/vsprintf.c:2801:12: warning: Dereference of null pointer (loaded from variable 'str') [clang-analyzer-core.NullDereference]
lib/zlib_deflate/deflate.c:1146:1: internal compiler error: Segmentation fault
lib/zlib_deflate/deftree.c:1058:1: internal compiler error: Segmentation fault
lib/zlib_inflate/inffast.c:325:1: internal compiler error: Segmentation fault
lib/zlib_inflate/inflate.c:814:1: internal compiler error: Segmentation fault
lib/zstd/common/entropy_common.c:357:1: internal compiler error: Segmentation fault
lib/zstd/common/fse_decompress.c:386:1: internal compiler error: Segmentation fault
lib/zstd/compress/fse_compress.c:622:1: internal compiler error: Segmentation fault
lib/zstd/compress/hist.c:164:1: internal compiler error: Segmentation fault
lib/zstd/compress/huf_compress.c:904:1: internal compiler error: Segmentation fault
lib/zstd/compress/zstd_compress.c:5109:1: internal compiler error: Segmentation fault
lib/zstd/compress/zstd_compress_literals.c:158:1: internal compiler error: Segmentation fault
lib/zstd/compress/zstd_compress_sequences.c:439:1: internal compiler error: Segmentation fault
lib/zstd/compress/zstd_compress_superblock.c:852:1: internal compiler error: Segmentation fault
lib/zstd/compress/zstd_double_fast.c:519:1: internal compiler error: Segmentation fault
lib/zstd/compress/zstd_fast.c:496:1: internal compiler error: Segmentation fault
lib/zstd/compress/zstd_lazy.c:1414:1: internal compiler error: Segmentation fault
lib/zstd/compress/zstd_ldm.c:686:1: internal compiler error: Segmentation fault
lib/zstd/compress/zstd_opt.c:1354:1: internal compiler error: Segmentation fault
lib/zstd/decompress/huf_decompress.c:1205:1: internal compiler error: Segmentation fault
lib/zstd/decompress/zstd_ddict.c:241:1: internal compiler error: Segmentation fault
lib/zstd/decompress/zstd_decompress.c:2085:1: internal compiler error: Segmentation fault
lib/zstd/decompress/zstd_decompress_block.c:1540:1: internal compiler error: Segmentation fault
make[1]: *** No rule to make target 'arch/h8300/Makefile'.
mm/folio-compat.c:166:1: internal compiler error: Segmentation fault
mm/interval_tree.c:103:1: internal compiler error: Segmentation fault
mm/migrate.c:1566:1: internal compiler error: Segmentation fault
security/integrity/evm/evm_secfs.c:159:3: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
sound/core/memalloc.c:750:1: internal compiler error: Segmentation fault
sound/core/pcm_dmaengine.c:461:1: internal compiler error: Segmentation fault
sound/core/pcm_native.c:4132:1: internal compiler error: Segmentation fault
sound/core/seq/seq_fifo.c:283:1: internal compiler error: Segmentation fault
sound/core/seq/seq_memory.c:504:1: internal compiler error: Segmentation fault
sound/core/seq/seq_midi_event.c:459:1: internal compiler error: Segmentation fault
sound/core/seq/seq_prioq.c:434:1: internal compiler error: Segmentation fault
sound/core/seq/seq_queue.c:726:1: internal compiler error: Segmentation fault
sound/core/seq/seq_timer.c:471:1: internal compiler error: Segmentation fault
sound/soc/bcm/bcm63xx-pcm-whistler.c:414:1: internal compiler error: Segmentation fault
sound/soc/codecs/rl6231.c:253:1: internal compiler error: Segmentation fault
sound/soc/codecs/rt5682.c:3150:1: internal compiler error: Segmentation fault
sound/soc/fsl/fsl_ssi_dbg.c:140:1: internal compiler error: Segmentation fault
sound/soc/generic/simple-card-utils.c:933:1: internal compiler error: Segmentation fault
sound/soc/soc-component.c:1244:1: internal compiler error: Segmentation fault
sound/soc/soc-dapm.c:4875:1: internal compiler error: Segmentation fault
sound/soc/soc-generic-dmaengine-pcm.c:501:1: internal compiler error: Segmentation fault

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- alpha-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
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
|-- arc-randconfig-r015-20220408
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- arc-randconfig-r043-20220408
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-randconfig-s031-20220408
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- arm-allmodconfig
|   |-- ERROR:__aeabi_uldivmod-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
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
|-- arm-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- freesync.c:(.text):undefined-reference-to-__aeabi_uldivmod
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
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
|-- arm-axm55xx_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- arm-defconfig
|   |-- ERROR:dtschema-minimum-version-is-v2022.
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
|-- arm-imx_v6_v7_defconfig
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
|-- arm-mvebu_v7_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- arm-randconfig-c002-20220408
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm64-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm64-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm64-defconfig
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- csky-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- csky-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- csky-defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- h8300-allmodconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-allyesconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-randconfig-r035-20220408
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- i386-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn31-dcn31_hubp.c:warning:no-previous-prototype-for-hubp31_program_extended_blank
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
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
|-- i386-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn31-dcn31_hubp.c:warning:no-previous-prototype-for-hubp31_program_extended_blank
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
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
|-- i386-randconfig-a003
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- i386-randconfig-a005
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- i386-randconfig-a012
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-a014
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- i386-randconfig-a016
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- i386-randconfig-c001
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-m021
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- i386-randconfig-s001
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-s002
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- ia64-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- ia64-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- ia64-bigsur_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- ia64-defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- ia64-generic_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- ia64-randconfig-m031-20220406
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_cs.c-amdgpu_cs_submit()-warn:ignoring-unreachable-code.
|-- m68k-allmodconfig
|   |-- drivers-counter-quad-.c:sparse:sparse:incompatible-types-in-conditional-expression-(different-base-types):
|   |-- drivers-counter-quad-.c:sparse:unsigned-char
|   |-- drivers-counter-quad-.c:sparse:void
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- m68k-allyesconfig
|   |-- drivers-counter-quad-.c:sparse:sparse:incompatible-types-in-conditional-expression-(different-base-types):
|   |-- drivers-counter-quad-.c:sparse:unsigned-char
|   |-- drivers-counter-quad-.c:sparse:void
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- m68k-randconfig-r004-20220408
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- microblaze-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- microblaze-randconfig-r011-20220408
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- mips-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
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
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
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
|-- mips-randconfig-m031-20220408
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- nios2-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- nios2-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- nios2-defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- openrisc-buildonly-randconfig-r005-20220408
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- openrisc-defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- parisc-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- parisc-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
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
|-- parisc-randconfig-c024-20220408
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- parisc-randconfig-r002-20220408
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- parisc64-defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- powerpc-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
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
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
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
|-- powerpc-iss476-smp_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- powerpc-randconfig-p002-20220408
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- powerpc-randconfig-r016-20220408
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- powerpc-randconfig-r023-20220408
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- powerpc64-randconfig-c004-20220408
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn31-dcn31_hubp.c:warning:no-previous-prototype-for-hubp31_program_extended_blank
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
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
|-- powerpc64-randconfig-r014-20220408
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn31-dcn31_hubp.c:warning:no-previous-prototype-for-hubp31_program_extended_blank
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
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
|-- powerpc64-randconfig-r021-20220408
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- powerpc64-randconfig-r022-20220408
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- riscv-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
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
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
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
|-- riscv-randconfig-p001-20220408
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- riscv-randconfig-r025-20220408
|   |-- arch-riscv-kernel-cacheinfo.c:internal-compiler-error:Segmentation-fault
|   |-- arch-riscv-kernel-patch.c:internal-compiler-error:Segmentation-fault
|   |-- arch-riscv-kernel-signal.c:internal-compiler-error:Segmentation-fault
|   |-- arch-riscv-mm-extable.c:internal-compiler-error:Segmentation-fault
|   |-- block-blk-zoned.c:internal-compiler-error:Segmentation-fault
|   |-- crypto-acompress.c:internal-compiler-error:Segmentation-fault
|   |-- crypto-aead.c:internal-compiler-error:Segmentation-fault
|   |-- crypto-ahash.c:internal-compiler-error:Segmentation-fault
|   |-- crypto-akcipher.c:internal-compiler-error:Segmentation-fault
|   |-- crypto-api.c:internal-compiler-error:Segmentation-fault
|   |-- crypto-ecc.c:internal-compiler-error:Segmentation-fault
|   |-- crypto-geniv.c:internal-compiler-error:Segmentation-fault
|   |-- crypto-gf128mul.c:internal-compiler-error:Segmentation-fault
|   |-- crypto-kpp.c:internal-compiler-error:Segmentation-fault
|   |-- crypto-rng.c:internal-compiler-error:Segmentation-fault
|   |-- crypto-scompress.c:internal-compiler-error:Segmentation-fault
|   |-- crypto-shash.c:internal-compiler-error:Segmentation-fault
|   |-- crypto-skcipher.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-base-map.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-base-regmap-regcache-flat.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-base-regmap-regcache-rbtree.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-base-regmap-regcache.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-base-regmap-regmap-debugfs.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-base-regmap-regmap-mmio.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-clk-clk-composite.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-clk-clk-fractional-divider.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-crypto-ccree-cc_aead.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-crypto-ccree-cc_buffer_mgr.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-crypto-ccree-cc_cipher.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-crypto-ccree-cc_fips.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-crypto-ccree-cc_hash.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-crypto-ccree-cc_request_mgr.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-crypto-ccree-cc_sram_mgr.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-dma-buf-dma-heap.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpio-gpiolib-of.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_vm_pt.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-hid-hid-debug.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-hid-hid-vivaldi-common.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-input-input-poller.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-input-matrix-keymap.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-input-rmi4-rmi_f01.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-input-rmi4-rmi_f03.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-input-rmi4-rmi_f30.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-input-touchscreen.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-iommu-of_iommu.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-mfd-mfd-core.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-mtd-chips-cfi_cmdset_0020.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-mtd-nand-ecc-sw-hamming.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-mtd-nand-raw-denali.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-mtd-nand-raw-nand_base.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-mtd-nand-raw-nand_hynix.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-mtd-nand-raw-nand_jedec.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-mtd-nand-raw-nand_legacy.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-mtd-nand-raw-nand_macronix.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-mtd-nand-raw-nand_micron.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-mtd-nand-raw-nand_onfi.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-mtd-nand-raw-nand_samsung.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-mtd-nand-raw-nand_timings.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-mtd-nand-raw-nand_toshiba.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-nvme-host-zns.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-of-kobj.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-scsi-ufs-ufs-sysfs.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-ssb-driver_chipcommon.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-ssb-scan.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-vfio-mdev-vfio_mdev.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-virtio-virtio_ring.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-w1-w1_family.c:internal-compiler-error:Segmentation-fault
|   |-- fs-autofs-expire.c:internal-compiler-error:Segmentation-fault
|   |-- fs-autofs-inode.c:internal-compiler-error:Segmentation-fault
|   |-- fs-autofs-root.c:internal-compiler-error:Segmentation-fault
|   |-- fs-autofs-symlink.c:internal-compiler-error:Segmentation-fault
|   |-- fs-autofs-waitq.c:internal-compiler-error:Segmentation-fault
|   |-- fs-btrfs-async-thread.c:internal-compiler-error:Segmentation-fault
|   |-- fs-btrfs-block-rsv.c:internal-compiler-error:Segmentation-fault
|   |-- fs-btrfs-delalloc-space.c:internal-compiler-error:Segmentation-fault
|   |-- fs-btrfs-dir-item.c:internal-compiler-error:Segmentation-fault
|   |-- fs-btrfs-discard.c:internal-compiler-error:Segmentation-fault
|   |-- fs-btrfs-export.c:internal-compiler-error:Segmentation-fault
|   |-- fs-btrfs-locking.c:internal-compiler-error:Segmentation-fault
|   |-- fs-btrfs-print-tree.c:internal-compiler-error:Segmentation-fault
|   |-- fs-btrfs-root-tree.c:internal-compiler-error:Segmentation-fault
|   |-- fs-btrfs-tree-defrag.c:internal-compiler-error:Segmentation-fault
|   |-- fs-btrfs-ulist.c:internal-compiler-error:Segmentation-fault
|   |-- fs-btrfs-uuid-tree.c:internal-compiler-error:Segmentation-fault
|   |-- fs-btrfs-zlib.c:internal-compiler-error:Segmentation-fault
|   |-- fs-btrfs-zstd.c:internal-compiler-error:Segmentation-fault
|   |-- fs-configfs-file.c:internal-compiler-error:Segmentation-fault
|   |-- fs-configfs-inode.c:internal-compiler-error:Segmentation-fault
|   |-- fs-configfs-symlink.c:internal-compiler-error:Segmentation-fault
|   |-- fs-crypto-hkdf.c:internal-compiler-error:Segmentation-fault
|   |-- fs-crypto-keysetup_v1.c:internal-compiler-error:Segmentation-fault
|   |-- fs-d_path.c:internal-compiler-error:Segmentation-fault
|   |-- fs-eventfd.c:internal-compiler-error:Segmentation-fault
|   |-- fs-exportfs-expfs.c:internal-compiler-error:Segmentation-fault
|   |-- fs-fs_context.c:internal-compiler-error:Segmentation-fault
|   |-- fs-fs_pin.c:internal-compiler-error:Segmentation-fault
|   |-- fs-fs_struct.c:internal-compiler-error:Segmentation-fault
|   |-- fs-fsopen.c:internal-compiler-error:Segmentation-fault
|   |-- fs-ioctl.c:internal-compiler-error:Segmentation-fault
|   |-- fs-kernfs-dir.c:internal-compiler-error:Segmentation-fault
|   |-- fs-kernfs-file.c:internal-compiler-error:Segmentation-fault
|   |-- fs-kernfs-inode.c:internal-compiler-error:Segmentation-fault
|   |-- fs-kernfs-symlink.c:internal-compiler-error:Segmentation-fault
|   |-- fs-nls-nls_base.c:internal-compiler-error:Segmentation-fault
|   |-- fs-overlayfs-dir.c:internal-compiler-error:Segmentation-fault
|   |-- fs-overlayfs-export.c:internal-compiler-error:Segmentation-fault
|   |-- fs-overlayfs-inode.c:internal-compiler-error:Segmentation-fault
|   |-- fs-overlayfs-namei.c:internal-compiler-error:Segmentation-fault
|   |-- fs-overlayfs-readdir.c:internal-compiler-error:Segmentation-fault
|   |-- fs-overlayfs-util.c:internal-compiler-error:Segmentation-fault
|   |-- fs-pnode.c:internal-compiler-error:Segmentation-fault
|   |-- fs-posix_acl.c:internal-compiler-error:Segmentation-fault
|   |-- fs-quota-quota.c:internal-compiler-error:Segmentation-fault
|   |-- fs-readdir.c:internal-compiler-error:Segmentation-fault
|   |-- fs-select.c:internal-compiler-error:Segmentation-fault
|   |-- fs-splice.c:internal-compiler-error:Segmentation-fault
|   |-- fs-statfs.c:internal-compiler-error:Segmentation-fault
|   |-- fs-sync.c:internal-compiler-error:Segmentation-fault
|   |-- fs-unicode-utf8-core.c:internal-compiler-error:Segmentation-fault
|   |-- fs-utimes.c:internal-compiler-error:Segmentation-fault
|   |-- fs-xattr.c:internal-compiler-error:Segmentation-fault
|   |-- include-linux-module.h:internal-compiler-error:Segmentation-fault
|   |-- kernel-cgroup-freezer.c:internal-compiler-error:Segmentation-fault
|   |-- kernel-dma-direct.c:internal-compiler-error:Segmentation-fault
|   |-- kernel-irq-chip.c:internal-compiler-error:Segmentation-fault
|   |-- kernel-module-kallsyms.c:internal-compiler-error:Segmentation-fault
|   |-- kernel-module-strict_rwx.c:internal-compiler-error:Segmentation-fault
|   |-- kernel-module-sysfs.c:internal-compiler-error:Segmentation-fault
|   |-- kernel-module-tree_lookup.c:internal-compiler-error:Segmentation-fault
|   |-- kernel-range.c:internal-compiler-error:Segmentation-fault
|   |-- kernel-rcu-rcu_segcblist.c:internal-compiler-error:Segmentation-fault
|   |-- kernel-rcu-sync.c:internal-compiler-error:Segmentation-fault
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
|   |-- kernel-sys.c:internal-compiler-error:Segmentation-fault
|   |-- kernel-task_work.c:internal-compiler-error:Segmentation-fault
|   |-- kernel-trace-trace_clock.c:internal-compiler-error:Segmentation-fault
|   |-- kernel-umh.c:internal-compiler-error:Segmentation-fault
|   |-- lib-asn1_decoder.c:internal-compiler-error:Segmentation-fault
|   |-- lib-crc-itu-t.c:internal-compiler-error:Segmentation-fault
|   |-- lib-crc16.c:internal-compiler-error:Segmentation-fault
|   |-- lib-crypto-aes.c:internal-compiler-error:Segmentation-fault
|   |-- lib-crypto-blake2s-generic.c:internal-compiler-error:Segmentation-fault
|   |-- lib-crypto-poly1305.c:internal-compiler-error:Segmentation-fault
|   |-- lib-extable.c:internal-compiler-error:Segmentation-fault
|   |-- lib-fdt.c:internal-compiler-error:Segmentation-fault
|   |-- lib-fdt_ro.c:internal-compiler-error:Segmentation-fault
|   |-- lib-fdt_rw.c:internal-compiler-error:Segmentation-fault
|   |-- lib-fdt_sw.c:internal-compiler-error:Segmentation-fault
|   |-- lib-fdt_wip.c:internal-compiler-error:Segmentation-fault
|   |-- lib-flex_proportions.c:internal-compiler-error:Segmentation-fault
|   |-- lib-iov_iter.c:internal-compiler-error:Segmentation-fault
|   |-- lib-is_single_threaded.c:internal-compiler-error:Segmentation-fault
|   |-- lib-linear_ranges.c:internal-compiler-error:Segmentation-fault
|   |-- lib-logic_pio.c:internal-compiler-error:Segmentation-fault
|   |-- lib-lz4-lz4_compress.c:internal-compiler-error:Segmentation-fault
|   |-- lib-lz4-lz4_decompress.c:internal-compiler-error:Segmentation-fault
|   |-- lib-lzo-lzo1x_compress.c:internal-compiler-error:Segmentation-fault
|   |-- lib-lzo-lzo1x_decompress_safe.c:internal-compiler-error:Segmentation-fault
|   |-- lib-math-rational.c:internal-compiler-error:Segmentation-fault
|   |-- lib-mpi-generic_mpih-mul2.c:internal-compiler-error:Segmentation-fault
|   |-- lib-mpi-generic_mpih-mul3.c:internal-compiler-error:Segmentation-fault
|   |-- lib-mpi-mpi-div.c:internal-compiler-error:Segmentation-fault
|   |-- lib-mpi-mpi-mod.c:internal-compiler-error:Segmentation-fault
|   |-- lib-mpi-mpih-div.c:internal-compiler-error:Segmentation-fault
|   |-- lib-mpi-mpih-mul.c:internal-compiler-error:Segmentation-fault
|   |-- lib-plist.c:internal-compiler-error:Segmentation-fault
|   |-- lib-raid6-int1.c:internal-compiler-error:Segmentation-fault
|   |-- lib-raid6-int2.c:internal-compiler-error:Segmentation-fault
|   |-- lib-raid6-int4.c:internal-compiler-error:Segmentation-fault
|   |-- lib-raid6-int8.c:internal-compiler-error:Segmentation-fault
|   |-- lib-seq_buf.c:internal-compiler-error:Segmentation-fault
|   |-- lib-syscall.c:internal-compiler-error:Segmentation-fault
|   |-- lib-zlib_deflate-deflate.c:internal-compiler-error:Segmentation-fault
|   |-- lib-zlib_deflate-deftree.c:internal-compiler-error:Segmentation-fault
|   |-- lib-zlib_inflate-inffast.c:internal-compiler-error:Segmentation-fault
|   |-- lib-zlib_inflate-inflate.c:internal-compiler-error:Segmentation-fault
|   |-- lib-zstd-common-entropy_common.c:internal-compiler-error:Segmentation-fault
|   |-- lib-zstd-common-fse_decompress.c:internal-compiler-error:Segmentation-fault
|   |-- lib-zstd-compress-fse_compress.c:internal-compiler-error:Segmentation-fault
|   |-- lib-zstd-compress-hist.c:internal-compiler-error:Segmentation-fault
|   |-- lib-zstd-compress-huf_compress.c:internal-compiler-error:Segmentation-fault
|   |-- lib-zstd-compress-zstd_compress.c:internal-compiler-error:Segmentation-fault
|   |-- lib-zstd-compress-zstd_compress_literals.c:internal-compiler-error:Segmentation-fault
|   |-- lib-zstd-compress-zstd_compress_sequences.c:internal-compiler-error:Segmentation-fault
|   |-- lib-zstd-compress-zstd_compress_superblock.c:internal-compiler-error:Segmentation-fault
|   |-- lib-zstd-compress-zstd_double_fast.c:internal-compiler-error:Segmentation-fault
|   |-- lib-zstd-compress-zstd_fast.c:internal-compiler-error:Segmentation-fault
|   |-- lib-zstd-compress-zstd_lazy.c:internal-compiler-error:Segmentation-fault
|   |-- lib-zstd-compress-zstd_ldm.c:internal-compiler-error:Segmentation-fault
|   |-- lib-zstd-compress-zstd_opt.c:internal-compiler-error:Segmentation-fault
|   |-- lib-zstd-decompress-huf_decompress.c:internal-compiler-error:Segmentation-fault
|   |-- lib-zstd-decompress-zstd_ddict.c:internal-compiler-error:Segmentation-fault
|   |-- lib-zstd-decompress-zstd_decompress.c:internal-compiler-error:Segmentation-fault
|   |-- lib-zstd-decompress-zstd_decompress_block.c:internal-compiler-error:Segmentation-fault
|   |-- mm-folio-compat.c:internal-compiler-error:Segmentation-fault
|   |-- mm-interval_tree.c:internal-compiler-error:Segmentation-fault
|   |-- mm-migrate.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-memalloc.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-pcm_dmaengine.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-pcm_native.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-seq-seq_fifo.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-seq-seq_memory.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-seq-seq_midi_event.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-seq-seq_prioq.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-seq-seq_queue.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-seq-seq_timer.c:internal-compiler-error:Segmentation-fault
|   |-- sound-soc-bcm-bcm63xx-pcm-whistler.c:internal-compiler-error:Segmentation-fault
|   |-- sound-soc-codecs-rl6231.c:internal-compiler-error:Segmentation-fault
|   |-- sound-soc-codecs-rt5682.c:internal-compiler-error:Segmentation-fault
|   |-- sound-soc-fsl-fsl_ssi_dbg.c:internal-compiler-error:Segmentation-fault
|   |-- sound-soc-generic-simple-card-utils.c:internal-compiler-error:Segmentation-fault
|   |-- sound-soc-soc-component.c:internal-compiler-error:Segmentation-fault
|   |-- sound-soc-soc-dapm.c:internal-compiler-error:Segmentation-fault
|   `-- sound-soc-soc-generic-dmaengine-pcm.c:internal-compiler-error:Segmentation-fault
|-- riscv-randconfig-r042-20220408
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
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
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
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
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
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
|-- s390-buildonly-randconfig-r003-20220408
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
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
|-- s390-randconfig-r013-20220408
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
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
|-- s390-randconfig-r044-20220408
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- sh-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sh-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sh-randconfig-s032-20220408
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-iio-test-iio-test-rescale.c:sparse:sparse:symbol-offset_cases-was-not-declared.-Should-it-be-static
|   |-- drivers-iio-test-iio-test-rescale.c:sparse:sparse:symbol-scale_cases-was-not-declared.-Should-it-be-static
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sparc-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
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
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
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
|-- sparc-randconfig-r012-20220408
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sparc-randconfig-r024-20220408
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sparc64-randconfig-c003-20220408
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- um-i386_defconfig
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- um-x86_64_defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
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
|   `-- kernel-sched-sched.h:linux-static_key.h-is-included-more-than-once.
|-- x86_64-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
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
|-- x86_64-randconfig-a002
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-randconfig-a004
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
|-- x86_64-randconfig-a006
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
|-- x86_64-randconfig-a011
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
|-- x86_64-randconfig-a015
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
|-- x86_64-randconfig-c002
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-randconfig-c022
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-randconfig-s021
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
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
|-- x86_64-randconfig-s022
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
|-- x86_64-rhel-8.3
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
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
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
|-- xtensa-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- xtensa-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- xtensa-buildonly-randconfig-r004-20220408
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- xtensa-randconfig-r033-20220408
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
`-- xtensa-randconfig-r034-20220408
    |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
    |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
    `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop

clang_recent_errors
|-- arm-buildonly-randconfig-r002-20220408
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- arm-defconfig
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
|-- arm-magician_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- arm-moxart_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- arm-orion5x_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- arm-randconfig-c002-20220408
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- drivers-mtd-nand-ecc-mxic.c:warning:Branch-condition-evaluates-to-a-garbage-value-clang-analyzer-core.uninitialized.Branch
|   |-- drivers-mtd-nand-ecc-mxic.c:warning:Value-stored-to-dev-during-its-initialization-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- drivers-phy-broadcom-phy-brcm-usb.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-an
|   |-- drivers-usb-gadget-configfs.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogou
|   |-- drivers-usb-gadget-udc-core.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogou
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|   |-- lib-stackinit_kunit.c:warning:Address-of-stack-memory-associated-with-local-variable-var-is-still-referred-to-by-the-global-variable-fill_start-upon-returning-to-the-caller.-This-will-be-a-dangling-re
|   |-- lib-stackinit_kunit.c:warning:Address-of-stack-memory-associated-with-local-variable-var-is-still-referred-to-by-the-global-variable-target_start-upon-returning-to-the-caller.-This-will-be-a-dangling-
|   |-- lib-stackinit_kunit.c:warning:Excessive-padding-in-struct-test_big_hole-(-padding-bytes-where-is-optimal).
|   |-- lib-stackinit_kunit.c:warning:Undefined-or-garbage-value-returned-to-caller-clang-analyzer-core.uninitialized.UndefReturn
|   `-- security-integrity-evm-evm_secfs.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-ana
|-- arm-shannon_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- arm-socfpga_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- arm64-randconfig-r032-20220408
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- hexagon-randconfig-r041-20220408
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
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
|-- hexagon-randconfig-r045-20220408
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- i386-randconfig-a002
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
|-- i386-randconfig-a004
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- i386-randconfig-a006
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- i386-randconfig-a011
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
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
|-- i386-randconfig-a013
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- i386-randconfig-a015
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- i386-randconfig-c001
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|   |-- lib-vsprintf.c:warning:Dereference-of-null-pointer-(loaded-from-variable-str-)-clang-analyzer-core.NullDereference
|   `-- lib-vsprintf.c:warning:Null-pointer-passed-as-1st-argument-to-memory-copy-function-clang-analyzer-unix.cstring.NullArg
|-- mips-loongson1c_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- mips-rs90_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- riscv-randconfig-c006-20220408
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- drivers-gpu-drm-selftests-test-drm_buddy.c:warning:Value-stored-to-err-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- drivers-usb-chipidea-core.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-
|   |-- drivers-usb-gadget-configfs.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogou
|   |-- drivers-usb-gadget-udc-core.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogou
|   |-- drivers-usb-typec-altmodes-displayport.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-wi
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- s390-randconfig-c005-20220408
|   |-- arch-s390-include-asm-spinlock.h:error:unexpected-token-in-.rept-directive
|   |-- arch-s390-include-asm-spinlock.h:error:unknown-directive
|   |-- arch-s390-include-asm-spinlock.h:error:unmatched-.endr-directive
|   |-- arch-s390-lib-spinlock.c:error:unexpected-token-in-.rept-directive
|   |-- arch-s390-lib-spinlock.c:error:unknown-directive
|   |-- arch-s390-lib-spinlock.c:error:unmatched-.endr-directive
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- x86_64-randconfig-a001
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- x86_64-randconfig-a003
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- x86_64-randconfig-a005
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
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
|-- x86_64-randconfig-a012
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- x86_64-randconfig-a014
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
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
|-- x86_64-randconfig-a016
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
`-- x86_64-randconfig-c007
    |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
    |-- drivers-pci-vgaarb.c:warning:Value-stored-to-dev-during-its-initialization-is-never-read-clang-analyzer-deadcode.DeadStores
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

elapsed time: 728m

configs tested: 114
configs skipped: 3

gcc tested configs:
arm                              allyesconfig
arm                                 defconfig
arm64                               defconfig
arm                              allmodconfig
arm64                            allyesconfig
i386                          randconfig-c001
um                             i386_defconfig
m68k                             allyesconfig
s390                             allmodconfig
powerpc                          allmodconfig
powerpc                          allyesconfig
m68k                             allmodconfig
s390                             allyesconfig
parisc                           allyesconfig
sh                               allmodconfig
h8300                            allyesconfig
xtensa                           allyesconfig
arc                              allyesconfig
alpha                            allyesconfig
nios2                            allyesconfig
arm                        mvebu_v7_defconfig
arc                        nsim_700_defconfig
arm                         axm55xx_defconfig
arm                       imx_v6_v7_defconfig
openrisc                            defconfig
powerpc                  iss476-smp_defconfig
x86_64                           alldefconfig
ia64                        generic_defconfig
ia64                         bigsur_defconfig
mips                            ar7_defconfig
sh                           se7780_defconfig
sh                          sdk7780_defconfig
xtensa                           alldefconfig
arm                  randconfig-c002-20220408
x86_64                        randconfig-c001
ia64                                defconfig
ia64                             allyesconfig
ia64                             allmodconfig
m68k                                defconfig
alpha                               defconfig
csky                                defconfig
arc                                 defconfig
parisc                              defconfig
parisc64                            defconfig
s390                                defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
i386                                defconfig
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
nios2                               defconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                           allnoconfig
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                        randconfig-a013
x86_64                        randconfig-a011
x86_64                        randconfig-a015
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
x86_64                        randconfig-a002
x86_64                        randconfig-a006
x86_64                        randconfig-a004
arc                  randconfig-r043-20220408
riscv                randconfig-r042-20220408
s390                 randconfig-r044-20220408
riscv                            allmodconfig
riscv                    nommu_k210_defconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                          rv32_defconfig
riscv                            allyesconfig
riscv                               defconfig
x86_64                    rhel-8.3-kselftests
um                           x86_64_defconfig
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                                  kexec
x86_64                          rhel-8.3-func
x86_64                               rhel-8.3
x86_64                         rhel-8.3-kunit

clang tested configs:
powerpc              randconfig-c003-20220408
mips                 randconfig-c004-20220408
arm                  randconfig-c002-20220408
s390                 randconfig-c005-20220408
x86_64                        randconfig-c007
riscv                randconfig-c006-20220408
i386                          randconfig-c001
powerpc                   microwatt_defconfig
arm                         orion5x_defconfig
mips                     loongson1c_defconfig
powerpc                  mpc885_ads_defconfig
powerpc                     powernv_defconfig
mips                           rs90_defconfig
arm                         shannon_defconfig
arm                        magician_defconfig
arm                          moxart_defconfig
arm                         socfpga_defconfig
arm                                 defconfig
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64                        randconfig-a005
hexagon              randconfig-r045-20220408
hexagon              randconfig-r041-20220408

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
