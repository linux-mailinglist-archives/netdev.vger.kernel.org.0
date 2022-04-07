Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74FA64F89D6
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 00:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbiDGUvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 16:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiDGUuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 16:50:40 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F53351512;
        Thu,  7 Apr 2022 13:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649364213; x=1680900213;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=wM0Qjnj33alBhk8tVlovrNerUXruPfozkRlptDNw8o8=;
  b=Gt7GaWjMK2flItDrzOwy0Y1ixmxJsvSbRCk5acf+PzwuRT/D8/EVUsqG
   t1K65mA7o7jH8qVVgZ4IdgwB+sEToZOr3DQd7zsaGMF97xIuO/9eKdBco
   Xgi/G9AX6fQStUDtG5xTEeX54RSkg2IBJN7hUGv3mYmUU4QTzBu3MIO+O
   Y3c4c6W2Ptn200hba1MGDj0U4rsq2dmWyy1vTl2y+hJ57qyVU9OP/WzA+
   sQBoZtK99apFml3ZzwaQ2AQpb7V55SOgDG5mnxBv9PrbLVoy4TImJo1iL
   sQdZccv2vQGg6J83DSKw5EE8ImWQaHPHLObaQJjbvkPorbrCYqhH3AHRx
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="286423143"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="286423143"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 13:35:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="652979357"
Received: from lkp-server02.sh.intel.com (HELO a44fdfb70b94) ([10.239.97.151])
  by fmsmga002.fm.intel.com with ESMTP; 07 Apr 2022 13:35:05 -0700
Received: from kbuild by a44fdfb70b94 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ncYqO-0005lL-N1;
        Thu, 07 Apr 2022 20:35:04 +0000
Date:   Fri, 08 Apr 2022 04:34:25 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     virtualization@lists.linux-foundation.org,
        samba-technical@lists.samba.org, rcu@vger.kernel.org,
        patches@opensource.cirrus.com,
        openipmi-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-unionfs@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-parport@lists.infradead.org, linux-nfc@lists.01.org,
        linux-mtd@lists.infradead.org, linux-mm@kvack.org,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-input@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-can@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-afs@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
        kunit-dev@googlegroups.com, keyrings@vger.kernel.org,
        iommu@lists.linux-foundation.org, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, dccp@vger.kernel.org,
        codalist@coda.cs.cmu.edu, cluster-devel@redhat.com,
        cgroups@vger.kernel.org, ceph-devel@vger.kernel.org,
        bridge@lists.linux-foundation.org, amd-gfx@lists.freedesktop.org,
        alsa-devel@alsa-project.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 2e9a9857569ec27e64d2ddd01294bbe3c736acb1
Message-ID: <624f4ad1.ehJRp+VA/jsfIl/D%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 2e9a9857569ec27e64d2ddd01294bbe3c736acb1  Add linux-next specific files for 20220407

Error/Warning reports:

https://lore.kernel.org/linux-mm/202203160358.yulPl6b4-lkp@intel.com
https://lore.kernel.org/llvm/202203241958.Uw9bWfMD-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

/kbuild/src/includecheck/kernel/sched/sched.h: linux/static_key.h is included more than once.
ERROR: dtschema minimum version is v2022.3
ERROR: modpost: "__aeabi_uldivmod" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
drivers/bus/mhi/host/main.c:792:13: warning: parameter 'event_quota' set but not used [-Wunused-but-set-parameter]
drivers/gpu/drm/amd/amdgpu/../display/dc/virtual/virtual_link_hwss.c:32:6: warning: no previous prototype for 'virtual_setup_stream_attribute' [-Wmissing-prototypes]
include/uapi/linux/byteorder/big_endian.h:32:52: warning: passing argument 1 of '__fswab64' makes integer from pointer without a cast [-Wint-conversion]
include/uapi/linux/swab.h:128:46: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
include/uapi/linux/swab.h:131:31: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

Unverified Error/Warning (likely false positive, please contact us if interested):

Makefile:684: arch/h8300/Makefile: No such file or directory
arch/Kconfig:10: can't open file "arch/h8300/Kconfig"
arch/riscv/kernel/cacheinfo.c:189:1: internal compiler error: Segmentation fault
arch/riscv/kernel/crash_dump.c:46:1: internal compiler error: Segmentation fault
arch/riscv/kernel/patch.c:133:1: internal compiler error: Segmentation fault
arch/riscv/kernel/signal.c:323:1: internal compiler error: Segmentation fault
arch/riscv/mm/extable.c:71:1: internal compiler error: Segmentation fault
arch/s390/include/asm/spinlock.h:81:3: error: unexpected token in '.rept' directive
arch/s390/include/asm/spinlock.h:81:3: error: unknown directive
arch/s390/include/asm/spinlock.h:81:3: error: unmatched '.endr' directive
arch/s390/lib/spinlock.c:78:3: error: unexpected token in '.rept' directive
arch/s390/lib/spinlock.c:78:3: error: unknown directive
arch/s390/lib/spinlock.c:78:3: error: unmatched '.endr' directive
arch/sh/lib/mcount.S:269: undefined reference to `dump_stack'
crypto/acompress.c:198:1: internal compiler error: Segmentation fault
crypto/aead.c:303:1: internal compiler error: Segmentation fault
crypto/ahash.c:660:1: internal compiler error: Segmentation fault
crypto/akcipher.c:158:1: internal compiler error: Segmentation fault
crypto/api.c:660:1: internal compiler error: Segmentation fault
crypto/asymmetric_keys/public_key.c:468:1: internal compiler error: Segmentation fault
crypto/dh.c:925:1: internal compiler error: Segmentation fault
crypto/ecc.c:1668:1: internal compiler error: Segmentation fault
crypto/geniv.c:163:1: internal compiler error: Segmentation fault
crypto/gf128mul.c:416:1: internal compiler error: Segmentation fault
crypto/kpp.c:144:1: internal compiler error: Segmentation fault
crypto/rng.c:228:1: internal compiler error: Segmentation fault
crypto/scompress.c:305:1: internal compiler error: Segmentation fault
crypto/shash.c:627:1: internal compiler error: Segmentation fault
crypto/skcipher.c:984:1: internal compiler error: Segmentation fault
drivers/acpi/arm64/agdi.c:88:13: warning: no previous prototype for function 'acpi_agdi_init' [-Wmissing-prototypes]
drivers/base/map.c:154:1: internal compiler error: Segmentation fault
drivers/base/regmap/regcache-flat.c:83:1: internal compiler error: Segmentation fault
drivers/base/regmap/regcache-rbtree.c:553:1: internal compiler error: Segmentation fault
drivers/base/regmap/regcache.c:785:1: internal compiler error: Segmentation fault
drivers/base/regmap/regmap-debugfs.c:692:1: internal compiler error: Segmentation fault
drivers/base/regmap/regmap-mmio.c:453:1: internal compiler error: Segmentation fault
drivers/base/syscore.c:128:1: internal compiler error: Segmentation fault
drivers/bluetooth/btbcm.c:722:1: internal compiler error: Segmentation fault
drivers/bluetooth/btintel.c:2660:1: internal compiler error: Segmentation fault
drivers/bluetooth/btmrvl_debugfs.c:206:1: internal compiler error: Segmentation fault
drivers/bluetooth/btmrvl_main.c:806:1: internal compiler error: Segmentation fault
drivers/bluetooth/btrtl.c:949:1: internal compiler error: Segmentation fault
drivers/char/ipmi/ipmi_bt_sm.c:696:1: internal compiler error: Segmentation fault
drivers/char/ipmi/ipmi_kcs_sm.c:536:1: internal compiler error: Segmentation fault
drivers/char/ipmi/ipmi_si_hotmod.c:237:1: internal compiler error: Segmentation fault
drivers/char/ipmi/ipmi_si_mem_io.c:146:1: internal compiler error: Segmentation fault
drivers/char/ipmi/ipmi_smic_sm.c:585:1: internal compiler error: Segmentation fault
drivers/clk/clk-composite.c:487:1: internal compiler error: Segmentation fault
drivers/clk/clk-fractional-divider.c:259:1: internal compiler error: Segmentation fault
drivers/clk/imx/clk-pll14xx.c:166:2: warning: Value stored to 'pll_div_ctl1' is never read [clang-analyzer-deadcode.DeadStores]
drivers/comedi/comedi_buf.c:691:1: internal compiler error: Segmentation fault
drivers/comedi/drivers.c:1183:1: internal compiler error: Segmentation fault
drivers/comedi/range.c:131:1: internal compiler error: Segmentation fault
drivers/connector/cn_queue.c:147:1: internal compiler error: Segmentation fault
drivers/connector/connector.c:284:1: internal compiler error: Segmentation fault
drivers/counter/104-quad-8.c:150:9: sparse:    unsigned char
drivers/counter/104-quad-8.c:150:9: sparse:    void
drivers/counter/104-quad-8.c:150:9: sparse: sparse: incompatible types in conditional expression (different base types):
drivers/crypto/ccree/cc_aead.c:2664:1: internal compiler error: Segmentation fault
drivers/crypto/ccree/cc_buffer_mgr.c:1390:1: internal compiler error: Segmentation fault
drivers/crypto/ccree/cc_cipher.c:1509:1: internal compiler error: Segmentation fault
drivers/crypto/ccree/cc_hash.c:2315:1: internal compiler error: Segmentation fault
drivers/crypto/ccree/cc_request_mgr.c:662:1: internal compiler error: Segmentation fault
drivers/crypto/ccree/cc_sram_mgr.c:91:1: internal compiler error: Segmentation fault
drivers/dma-buf/dma-fence-array.c:253:1: internal compiler error: Segmentation fault
drivers/dma-buf/dma-fence-chain.c:265:1: internal compiler error: Segmentation fault
drivers/dma-buf/dma-fence.c:960:1: internal compiler error: Segmentation fault
drivers/dma-buf/dma-heap.c:324:1: internal compiler error: Segmentation fault
drivers/dma-buf/st-dma-fence-unwrap.c:125:13: warning: variable 'err' set but not used [-Wunused-but-set-variable]
drivers/dma-buf/st-dma-fence-unwrap.c:261:1: internal compiler error: Segmentation fault
drivers/firmware/turris-mox-rwtm.c:146:1: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/gpio/gpiolib-of.c:1055:1: internal compiler error: Segmentation fault
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn31/dcn31_hubp.c:57:6: warning: no previous prototype for 'hubp31_program_extended_blank' [-Wmissing-prototypes]
drivers/gpu/drm/drm_of.c:292:2-13: ERROR: probable double put.
drivers/gpu/drm/selftests/test-drm_buddy.c:525:7: warning: Value stored to 'err' is never read [clang-analyzer-deadcode.DeadStores]
drivers/hid/hid-cmedia.c:246:1: internal compiler error: Segmentation fault
drivers/hid/hid-core.c:1665:30: warning: Although the value stored to 'field' is used in the enclosing expression, the value is never actually read from 'field' [clang-analyzer-deadcode.DeadStores]
drivers/hid/hid-debug.c:1269:1: internal compiler error: Segmentation fault
drivers/hid/hid-uclogic-params.c:1120:1: internal compiler error: Segmentation fault
drivers/hid/hid-uclogic-rdesc.c:873:1: internal compiler error: Segmentation fault
drivers/hid/usbhid/hiddev.c:945:1: internal compiler error: Segmentation fault
drivers/hwmon/da9055-hwmon.c:201:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/hwmon/nsa320-hwmon.c:114:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/infiniband/core/addr.c:889:1: internal compiler error: Segmentation fault
drivers/infiniband/core/agent.c:221:1: internal compiler error: Segmentation fault
drivers/infiniband/core/cache.c:1674:1: internal compiler error: Segmentation fault
drivers/infiniband/core/cm_trace.c:16: internal compiler error: Segmentation fault
drivers/infiniband/core/counters.c:669:1: internal compiler error: Segmentation fault
drivers/infiniband/core/cq.c:507:1: internal compiler error: Segmentation fault
drivers/infiniband/core/ib_core_uverbs.c:367:1: internal compiler error: Segmentation fault
drivers/infiniband/core/iwpm_msg.c:846:1: internal compiler error: Segmentation fault
drivers/infiniband/core/iwpm_util.c:793:1: internal compiler error: Segmentation fault
drivers/infiniband/core/lag.c:138:1: internal compiler error: Segmentation fault
drivers/infiniband/core/mad_rmpp.c:960:1: internal compiler error: Segmentation fault
drivers/infiniband/core/mr_pool.c:82:1: internal compiler error: Segmentation fault
drivers/infiniband/core/multicast.c:906:1: internal compiler error: Segmentation fault
drivers/infiniband/core/netlink.c:331:1: internal compiler error: Segmentation fault
drivers/infiniband/core/packer.c:201:1: internal compiler error: Segmentation fault
drivers/infiniband/core/restrack.c:355:1: internal compiler error: Segmentation fault
drivers/infiniband/core/rw.c:761:1: internal compiler error: Segmentation fault
drivers/infiniband/core/sa_query.c:2268:1: internal compiler error: Segmentation fault
drivers/infiniband/core/smi.c:338:1: internal compiler error: Segmentation fault
drivers/infiniband/core/sysfs.c:1475:1: internal compiler error: Segmentation fault
drivers/infiniband/core/trace.c:13: internal compiler error: Segmentation fault
drivers/infiniband/core/ud_header.c:547:1: internal compiler error: Segmentation fault
drivers/infiniband/core/verbs.c:3023:1: internal compiler error: Segmentation fault
drivers/infiniband/sw/siw/siw_cm.c:1956:1: internal compiler error: Segmentation fault
drivers/infiniband/sw/siw/siw_cq.c:102:1: internal compiler error: Segmentation fault
drivers/infiniband/sw/siw/siw_mem.c:449:1: internal compiler error: Segmentation fault
drivers/infiniband/sw/siw/siw_qp.c:1347:1: internal compiler error: Segmentation fault
drivers/infiniband/sw/siw/siw_qp_tx.c:1279:1: internal compiler error: Segmentation fault
drivers/infiniband/sw/siw/siw_verbs.c:1854:1: internal compiler error: Segmentation fault
drivers/input/matrix-keymap.c:202:1: internal compiler error: Segmentation fault
drivers/input/rmi4/rmi_2d_sensor.c:330:1: internal compiler error: Segmentation fault
drivers/input/rmi4/rmi_f01.c:729:1: internal compiler error: Segmentation fault
drivers/input/rmi4/rmi_f03.c:328:1: internal compiler error: Segmentation fault
drivers/input/rmi4/rmi_f55.c:128:1: internal compiler error: Segmentation fault
drivers/input/touchscreen.c:207:1: internal compiler error: Segmentation fault
drivers/leds/leds-ti-lmu-common.c:153:1: internal compiler error: Segmentation fault
drivers/media/common/videobuf2/frame_vector.c:235:1: internal compiler error: Segmentation fault
drivers/media/common/videobuf2/vb2-trace.c:10:1: internal compiler error: Segmentation fault
drivers/media/common/videobuf2/videobuf2-memops.c:129:1: internal compiler error: Segmentation fault
drivers/media/common/videobuf2/videobuf2-vmalloc.c:450:1: internal compiler error: Segmentation fault
drivers/memory/brcmstb_dpfe.c:707:10: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/mfd/madera-core.c:799:1: internal compiler error: Segmentation fault
drivers/mfd/mfd-core.c:440:1: internal compiler error: Segmentation fault
drivers/mtd/chips/cfi_cmdset_0020.c:1401:1: internal compiler error: Segmentation fault
drivers/mtd/hyperbus/hyperbus-core.c:144:1: internal compiler error: Segmentation fault
drivers/mtd/mtdsuper.c:202:1: internal compiler error: Segmentation fault
drivers/mtd/nand/bbt.c:131:1: internal compiler error: Segmentation fault
drivers/mtd/nand/ecc-mxic.c:523:17: warning: Value stored to 'dev' during its initialization is never read [clang-analyzer-deadcode.DeadStores]
drivers/mtd/nand/ecc-mxic.c:595:6: warning: Branch condition evaluates to a garbage value [clang-analyzer-core.uninitialized.Branch]
drivers/net/can/dev/bittiming.c:284:1: internal compiler error: Segmentation fault
drivers/net/can/dev/length.c:95:1: internal compiler error: Segmentation fault
drivers/net/can/dev/netlink.c:624:1: internal compiler error: Segmentation fault
drivers/net/can/dev/rx-offload.c:402:1: internal compiler error: Segmentation fault
drivers/net/can/dev/skb.c:254:1: internal compiler error: Segmentation fault
drivers/net/can/flexcan/flexcan-ethtool.c:114:1: internal compiler error: Segmentation fault
drivers/net/can/usb/etas_es58x/es581_4.c:507:1: internal compiler error: Segmentation fault
drivers/net/can/usb/etas_es58x/es58x_fd.c:565:1: internal compiler error: Segmentation fault
drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c:2065:1: internal compiler error: Segmentation fault
drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c:1398:1: internal compiler error: Segmentation fault
drivers/net/vxlan/vxlan_core.c:440:34: sparse: sparse: incorrect type in argument 2 (different base types)
drivers/nfc/fdp/fdp.c:756:1: internal compiler error: Segmentation fault
drivers/of/kobj.c:165:1: internal compiler error: Segmentation fault
drivers/parport/ieee1284_ops.c:893:1: internal compiler error: Segmentation fault
drivers/pci/of.c:635:1: internal compiler error: Segmentation fault
drivers/pci/vgaarb.c:213:17: warning: Value stored to 'dev' during its initialization is never read [clang-analyzer-deadcode.DeadStores]
drivers/phy/broadcom/phy-brcm-usb.c:233:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/ptp/ptp_vclock.c:270:1: internal compiler error: Segmentation fault
drivers/ssb/driver_chipcommon.c:598:1: internal compiler error: Segmentation fault
drivers/ssb/scan.c:446:1: internal compiler error: Segmentation fault
drivers/usb/cdns3/drd.c:495:1: internal compiler error: Segmentation fault
drivers/usb/chipidea/core.c:956:10: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/chipidea/host.c:486:1: internal compiler error: Segmentation fault
drivers/usb/core/config.c:1094:1: internal compiler error: Segmentation fault
drivers/usb/core/devices.c:593:1: internal compiler error: Segmentation fault
drivers/usb/core/endpoint.c:191:1: internal compiler error: Segmentation fault
drivers/usb/core/generic.c:324:1: internal compiler error: Segmentation fault
drivers/usb/core/port.c:658:1: internal compiler error: Segmentation fault
drivers/usb/core/quirks.c:703:1: internal compiler error: Segmentation fault
drivers/usb/core/sysfs.c:1263:1: internal compiler error: Segmentation fault
drivers/usb/dwc3/debugfs.c:934:1: internal compiler error: Segmentation fault
drivers/usb/dwc3/host.c:140:1: internal compiler error: Segmentation fault
drivers/usb/gadget/configfs.c:237:8: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/gadget/function/storage_common.c:370:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/gadget/udc/core.c:1664:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/host/xhci-dbg.c:35:1: internal compiler error: Segmentation fault
drivers/usb/typec/altmodes/displayport.c:396:8: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/typec/bus.c:412:1: internal compiler error: Segmentation fault
drivers/usb/usbip/usbip_event.c:196:1: internal compiler error: Segmentation fault
drivers/video/fbdev/core/fb_defio.c:258:1: internal compiler error: Segmentation fault
drivers/video/fbdev/core/fbcmap.c:362:1: internal compiler error: Segmentation fault
drivers/video/fbdev/core/fbsysfs.c:570:1: internal compiler error: Segmentation fault
drivers/virtio/virtio_ring.c:2448:1: internal compiler error: Segmentation fault
drivers/w1/w1_family.c:130:1: internal compiler error: Segmentation fault
fs/afs/addr_list.c:404:1: internal compiler error: Segmentation fault
fs/afs/callback.c:228:1: internal compiler error: Segmentation fault
fs/afs/cmservice.c:672:1: internal compiler error: Segmentation fault
fs/afs/dir_edit.c:493:1: internal compiler error: Segmentation fault
fs/afs/dir_silly.c:282:1: internal compiler error: Segmentation fault
fs/afs/dynroot.c:394:1: internal compiler error: Segmentation fault
fs/afs/file.c:600:1: internal compiler error: Segmentation fault
fs/afs/flock.c:877:1: internal compiler error: Segmentation fault
fs/afs/fs_operation.c:259:1: internal compiler error: Segmentation fault
fs/afs/fs_probe.c:475:1: internal compiler error: Segmentation fault
fs/afs/mntpt.c:225:1: internal compiler error: Segmentation fault
fs/afs/server_list.c:129:1: internal compiler error: Segmentation fault
fs/afs/vl_alias.c:383:1: internal compiler error: Segmentation fault
fs/afs/vl_list.c:335:1: internal compiler error: Segmentation fault
fs/afs/vl_probe.c:292:1: internal compiler error: Segmentation fault
fs/afs/vl_rotate.c:348:1: internal compiler error: Segmentation fault
fs/afs/vlclient.c:759:1: internal compiler error: Segmentation fault
fs/afs/volume.c:428:1: internal compiler error: Segmentation fault
fs/afs/write.c:1039:1: internal compiler error: Segmentation fault
fs/afs/xattr.c:363:1: internal compiler error: Segmentation fault
fs/ceph/addr.c:2041:1: internal compiler error: Segmentation fault
fs/ceph/caps.c:4712:1: internal compiler error: Segmentation fault
fs/ceph/debugfs.c:466:1: internal compiler error: Segmentation fault
fs/ceph/dir.c:2003:1: internal compiler error: Segmentation fault
fs/ceph/export.c:583:1: internal compiler error: Segmentation fault
fs/ceph/file.c:2611:1: internal compiler error: Segmentation fault
fs/ceph/inode.c:2495:1: internal compiler error: Segmentation fault
fs/ceph/io.c:163:1: internal compiler error: Segmentation fault
fs/ceph/ioctl.c:295:1: internal compiler error: Segmentation fault
fs/ceph/mdsmap.c:422:1: internal compiler error: Segmentation fault
fs/ceph/metric.c:353:1: internal compiler error: Segmentation fault
fs/ceph/quota.c:531:1: internal compiler error: Segmentation fault
fs/ceph/snap.c:1270:1: internal compiler error: Segmentation fault
fs/ceph/xattr.c:1408:1: internal compiler error: Segmentation fault
fs/cifs/cifs_debug.c:1066:1: internal compiler error: Segmentation fault
fs/cifs/cifs_dfs_ref.c:374:1: internal compiler error: Segmentation fault
fs/cifs/cifs_spnego.c:236:1: internal compiler error: Segmentation fault
fs/cifs/cifs_unicode.c:632:1: internal compiler error: Segmentation fault
fs/cifs/cifsacl.c:1668:1: internal compiler error: Segmentation fault
fs/cifs/cifsencrypt.c:767:1: internal compiler error: Segmentation fault
fs/cifs/cifssmb.c:6054:1: internal compiler error: Segmentation fault
fs/cifs/connect.c:4550:1: internal compiler error: Segmentation fault
fs/cifs/dfs_cache.c:1661:1: internal compiler error: Segmentation fault
fs/cifs/dir.c:864:1: internal compiler error: Segmentation fault
fs/cifs/file.c:5008:1: internal compiler error: Segmentation fault
fs/cifs/fs_context.c:1764:1: internal compiler error: Segmentation fault
fs/cifs/inode.c:3014:1: internal compiler error: Segmentation fault
fs/cifs/ioctl.c:501:1: internal compiler error: Segmentation fault
fs/cifs/link.c:734:1: internal compiler error: Segmentation fault
fs/cifs/misc.c:1353:1: internal compiler error: Segmentation fault
fs/cifs/netmisc.c:1021:1: internal compiler error: Segmentation fault
fs/cifs/readdir.c:1056:1: internal compiler error: Segmentation fault
fs/cifs/sess.c:1718:1: internal compiler error: Segmentation fault
fs/cifs/smb1ops.c:1256:1: internal compiler error: Segmentation fault
fs/cifs/smb2file.c:287:1: internal compiler error: Segmentation fault
fs/cifs/smb2inode.c:750:1: internal compiler error: Segmentation fault
fs/cifs/smb2maperror.c:2481:1: internal compiler error: Segmentation fault
fs/cifs/smb2misc.c:924:1: internal compiler error: Segmentation fault
fs/cifs/smb2ops.c:5993:1: internal compiler error: Segmentation fault
fs/cifs/smb2pdu.c:5616:1: internal compiler error: Segmentation fault
fs/cifs/smb2transport.c:933:1: internal compiler error: Segmentation fault
fs/cifs/smbencrypt.c:91:1: internal compiler error: Segmentation fault
fs/cifs/trace.c:9: internal compiler error: Segmentation fault
fs/cifs/transport.c:1639:1: internal compiler error: Segmentation fault
fs/cifs/unc.c:69:1: internal compiler error: Segmentation fault
fs/coda/cache.c:118:1: internal compiler error: Segmentation fault
fs/coda/cnode.c:178:1: internal compiler error: Segmentation fault
fs/coda/dir.c:595:1: internal compiler error: Segmentation fault
fs/coda/file.c:306:1: internal compiler error: Segmentation fault
fs/coda/pioctl.c:88:1: internal compiler error: Segmentation fault
fs/coda/symlink.c:48:1: internal compiler error: Segmentation fault
fs/coda/upcall.c:961:1: internal compiler error: Segmentation fault
fs/configfs/file.c:482:1: internal compiler error: Segmentation fault
fs/configfs/inode.c:244:1: internal compiler error: Segmentation fault
fs/configfs/symlink.c:269:1: internal compiler error: Segmentation fault
fs/crypto/fname.c:595:1: internal compiler error: Segmentation fault
fs/crypto/hkdf.c:182:1: internal compiler error: Segmentation fault
fs/crypto/hooks.c:430:1: internal compiler error: Segmentation fault
fs/crypto/keysetup.c:794:1: internal compiler error: Segmentation fault
fs/crypto/keysetup_v1.c:319:1: internal compiler error: Segmentation fault
fs/crypto/policy.c:818:1: internal compiler error: Segmentation fault
fs/d_path.c:448:1: internal compiler error: Segmentation fault
fs/dlm/dir.c:306:1: internal compiler error: Segmentation fault
fs/dlm/member.c:730:1: internal compiler error: Segmentation fault
fs/dlm/midcomms.c:1494:1: internal compiler error: Segmentation fault
fs/dlm/rcom.c:677:1: internal compiler error: Segmentation fault
fs/dlm/recover.c:955:1: internal compiler error: Segmentation fault
fs/dlm/recoverd.c:352:1: internal compiler error: Segmentation fault
fs/dlm/requestqueue.c:171:1: internal compiler error: Segmentation fault
fs/eventfd.c:457:1: internal compiler error: Segmentation fault
fs/exportfs/expfs.c:586:1: internal compiler error: Segmentation fault
fs/fhandle.c:267:1: internal compiler error: Segmentation fault
fs/fs_context.c:717:1: internal compiler error: Segmentation fault
fs/fs_pin.c:97:1: internal compiler error: Segmentation fault
fs/fs_struct.c:168:1: internal compiler error: Segmentation fault
fs/fsopen.c:469:1: internal compiler error: Segmentation fault
fs/ioctl.c:875:1: internal compiler error: Segmentation fault
fs/kernfs/dir.c:1769:1: internal compiler error: Segmentation fault
fs/kernfs/file.c:1017:1: internal compiler error: Segmentation fault
fs/kernfs/inode.c:446:1: internal compiler error: Segmentation fault
fs/kernfs/symlink.c:153:1: internal compiler error: Segmentation fault
fs/namei.c:5044:1: internal compiler error: Segmentation fault
fs/nls/nls_base.c:548:1: internal compiler error: Segmentation fault
fs/open.c:1562:1: internal compiler error: Segmentation fault
fs/overlayfs/dir.c:1315:1: internal compiler error: Segmentation fault
fs/overlayfs/export.c:872:1: internal compiler error: Segmentation fault
fs/overlayfs/inode.c:1196:1: internal compiler error: Segmentation fault
fs/overlayfs/namei.c:1191:1: internal compiler error: Segmentation fault
fs/overlayfs/readdir.c:1233:1: internal compiler error: Segmentation fault
fs/overlayfs/util.c:1062:1: internal compiler error: Segmentation fault
fs/pnode.c:602:1: internal compiler error: Segmentation fault
fs/posix_acl.c:1018:1: internal compiler error: Segmentation fault
fs/pstore/pmsg.c:94:1: internal compiler error: Segmentation fault
fs/quota/quota.c:1013:1: internal compiler error: Segmentation fault
fs/readdir.c:384:1: internal compiler error: Segmentation fault
fs/select.c:1123:1: internal compiler error: Segmentation fault
fs/smbfs_common/cifs_md4.c:197:1: internal compiler error: Segmentation fault
fs/splice.c:1721:1: internal compiler error: Segmentation fault
fs/statfs.c:264:1: internal compiler error: Segmentation fault
fs/sync.c:382:1: internal compiler error: Segmentation fault
fs/utimes.c:264:1: internal compiler error: Segmentation fault
fs/xattr.c:1183:1: internal compiler error: Segmentation fault
include/uapi/linux/byteorder/little_endian.h:32:43: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
ipc/msgutil.c:184:1: internal compiler error: Segmentation fault
kernel/cgroup/freezer.c:323:1: internal compiler error: Segmentation fault
kernel/dma/direct.c:633:1: internal compiler error: Segmentation fault
kernel/irq/chip.c:1606:1: internal compiler error: Segmentation fault
kernel/module/sysfs.c:436:1: internal compiler error: Segmentation fault
kernel/printk/printk_ringbuffer.c:2124:1: internal compiler error: Segmentation fault
kernel/printk/printk_safe.c:52:1: internal compiler error: Segmentation fault
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
lib/cmdline.c:275:1: internal compiler error: Segmentation fault
lib/crypto/aes.c:356:1: internal compiler error: Segmentation fault
lib/crypto/blake2s-generic.c:115:1: internal compiler error: Segmentation fault
lib/crypto/poly1305.c:78:1: internal compiler error: Segmentation fault
lib/dim/dim.c:83:1: internal compiler error: Segmentation fault
lib/dim/net_dim.c:246:1: internal compiler error: Segmentation fault
lib/dim/rdma_dim.c:108:1: internal compiler error: Segmentation fault
lib/dynamic_queue_limits.c:138:1: internal compiler error: Segmentation fault
lib/extable.c:118:1: internal compiler error: Segmentation fault
lib/fdt.c:3: internal compiler error: Segmentation fault
lib/fdt_ro.c:3: internal compiler error: Segmentation fault
lib/fdt_rw.c:3: internal compiler error: Segmentation fault
lib/fdt_sw.c:3: internal compiler error: Segmentation fault
lib/fdt_wip.c:3: internal compiler error: Segmentation fault
lib/flex_proportions.c:282:1: internal compiler error: Segmentation fault
lib/iov_iter.c:2067:1: internal compiler error: Segmentation fault
lib/is_single_threaded.c:54:1: internal compiler error: Segmentation fault
lib/kunit/resource.c:129:1: internal compiler error: Segmentation fault
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
lib/nlattr.c:1121:1: internal compiler error: Segmentation fault
lib/oid_registry.c:199:1: internal compiler error: Segmentation fault
lib/seq_buf.c:397:1: internal compiler error: Segmentation fault
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
mm/interval_tree.c:110:1: internal compiler error: Segmentation fault
net/802/stp.c:101:1: internal compiler error: Segmentation fault
net/ax25/ax25_iface.c:214:1: internal compiler error: Segmentation fault
net/ax25/ax25_in.c:451:1: internal compiler error: Segmentation fault
net/ax25/ax25_ip.c:246:1: internal compiler error: Segmentation fault
net/ax25/ax25_out.c:386:1: internal compiler error: Segmentation fault
net/ax25/ax25_std_in.c:443:1: internal compiler error: Segmentation fault
net/ax25/ax25_std_timer.c:175:1: internal compiler error: Segmentation fault
net/ax25/ax25_subr.c:296:1: internal compiler error: Segmentation fault
net/bluetooth/ecdh_helper.c:228:1: internal compiler error: Segmentation fault
net/bluetooth/eir.c:335:1: internal compiler error: Segmentation fault
net/bluetooth/hci_codec.c:252:1: internal compiler error: Segmentation fault
net/bluetooth/hci_conn.c:1790:1: internal compiler error: Segmentation fault
net/bluetooth/hci_core.c:3876:1: internal compiler error: Segmentation fault
net/bluetooth/hci_event.c:6956:1: internal compiler error: Segmentation fault
net/bluetooth/hci_request.c:2659:1: internal compiler error: Segmentation fault
net/bluetooth/hci_sync.c:5340:1: internal compiler error: Segmentation fault
net/bluetooth/leds.c:100:1: internal compiler error: Segmentation fault
net/bluetooth/mgmt.c:9890:1: internal compiler error: Segmentation fault
net/bluetooth/mgmt_config.c:346:1: internal compiler error: Segmentation fault
net/bluetooth/mgmt_util.c:316:1: internal compiler error: Segmentation fault
net/bluetooth/smp.c:3463:1: internal compiler error: Segmentation fault
net/bridge/br_arp_nd_proxy.c:228:1: internal compiler error: Segmentation fault
net/bridge/br_device.c:533:1: internal compiler error: Segmentation fault
net/bridge/br_forward.c:248:1: internal compiler error: Segmentation fault
net/bridge/br_if.c:787:1: internal compiler error: Segmentation fault
net/bridge/br_input.c:434:1: internal compiler error: Segmentation fault
net/bridge/br_ioctl.c:440:1: internal compiler error: Segmentation fault
net/bridge/br_mrp.c:1260:1: internal compiler error: Segmentation fault
net/bridge/br_mrp_netlink.c:571:1: internal compiler error: Segmentation fault
net/bridge/br_netlink_tunnel.c:339:1: internal compiler error: Segmentation fault
net/bridge/br_stp.c:713:1: internal compiler error: Segmentation fault
net/bridge/br_stp_bpdu.c:247:1: internal compiler error: Segmentation fault
net/bridge/br_stp_if.c:351:1: internal compiler error: Segmentation fault
net/bridge/br_stp_timer.c:161:1: internal compiler error: Segmentation fault
net/bridge/br_sysfs_br.c:1084:1: internal compiler error: Segmentation fault
net/bridge/br_sysfs_if.c:412:1: internal compiler error: Segmentation fault
net/caif/cfcnfg.c:612:1: internal compiler error: Segmentation fault
net/caif/cfctrl.c:634:1: internal compiler error: Segmentation fault
net/caif/cfdgml.c:113:1: internal compiler error: Segmentation fault
net/caif/cffrml.c:197:1: internal compiler error: Segmentation fault
net/caif/cfmuxl.c:267:1: internal compiler error: Segmentation fault
net/caif/cfpkt_skbuff.c:382:1: internal compiler error: Segmentation fault
net/caif/cfrfml.c:299:1: internal compiler error: Segmentation fault
net/caif/cfserl.c:192:1: internal compiler error: Segmentation fault
net/caif/cfsrvl.c:220:1: internal compiler error: Segmentation fault
net/caif/cfutill.c:104:1: internal compiler error: Segmentation fault
net/caif/cfveil.c:101:1: internal compiler error: Segmentation fault
net/ceph/armor.c:106:1: internal compiler error: Segmentation fault
net/ceph/auth.c:659:1: internal compiler error: Segmentation fault
net/ceph/auth_none.c:146:1: internal compiler error: Segmentation fault
net/ceph/auth_x.c:1122:1: internal compiler error: Segmentation fault
net/ceph/buffer.c:59:1: internal compiler error: Segmentation fault
net/ceph/cls_lock_client.c:431:1: internal compiler error: Segmentation fault
net/ceph/crush/crush.c:142:1: internal compiler error: Segmentation fault
net/ceph/crush/mapper.c:1099:1: internal compiler error: Segmentation fault
net/ceph/decode.c:193:1: internal compiler error: Segmentation fault
net/ceph/messenger_v1.c:1548:1: internal compiler error: Segmentation fault
net/ceph/messenger_v2.c:3577:1: internal compiler error: Segmentation fault
net/ceph/mon_client.c:1586:1: internal compiler error: Segmentation fault
net/ceph/msgpool.c:94:1: internal compiler error: Segmentation fault
net/ceph/osdmap.c:3090:1: internal compiler error: Segmentation fault
net/ceph/pagelist.c:171:1: internal compiler error: Segmentation fault
net/ceph/pagevec.c:166:1: internal compiler error: Segmentation fault
net/ceph/snapshot.c:63:1: internal compiler error: Segmentation fault
net/ceph/string_table.c:106:1: internal compiler error: Segmentation fault
net/ceph/striper.c:278:1: internal compiler error: Segmentation fault
net/core/datagram.c:837:1: internal compiler error: Segmentation fault
net/core/dev_addr_lists.c:1048:1: internal compiler error: Segmentation fault
net/core/dst.c:355:1: internal compiler error: Segmentation fault
net/core/dst_cache.c:183:1: internal compiler error: Segmentation fault
net/core/flow_offload.c:597:1: internal compiler error: Segmentation fault
net/core/gen_estimator.c:278:1: internal compiler error: Segmentation fault
net/core/gen_stats.c:485:1: internal compiler error: Segmentation fault
net/core/gro.c:787:1: internal compiler error: Segmentation fault
net/core/gro_cells.c:139:1: internal compiler error: Segmentation fault
net/core/link_watch.c:279:1: internal compiler error: Segmentation fault
net/core/lwtunnel.c:424:1: internal compiler error: Segmentation fault
net/core/net-traces.c:63:1: internal compiler error: Segmentation fault
net/core/of_net.c:170:1: internal compiler error: Segmentation fault
net/core/scm.c:367:1: internal compiler error: Segmentation fault
net/core/secure_seq.c:167:1: internal compiler error: Segmentation fault
net/core/sock.c:3948:1: internal compiler error: Segmentation fault
net/core/sock_reuseport.c:649:1: internal compiler error: Segmentation fault
net/core/stream.c:212:1: internal compiler error: Segmentation fault
net/core/tso.c:97:1: internal compiler error: Segmentation fault
net/core/utils.c:486:1: internal compiler error: Segmentation fault
net/dccp/ccids/ccid2.c:788:1: internal compiler error: Segmentation fault
net/dccp/input.c:739:1: internal compiler error: Segmentation fault
net/dccp/output.c:709:1: internal compiler error: Segmentation fault
net/dccp/qpolicy.c:136:1: internal compiler error: Segmentation fault
net/devres.c:95:1: internal compiler error: Segmentation fault
net/dns_resolver/dns_query.c:172:1: internal compiler error: Segmentation fault
net/ethtool/common.c:596:1: internal compiler error: Segmentation fault
net/ethtool/ioctl.c:3351:1: internal compiler error: Segmentation fault
net/ipv4/datagram.c:128:1: internal compiler error: Segmentation fault
net/ipv4/fib_semantics.c:2261:1: internal compiler error: Segmentation fault
net/ipv4/inet_connection_sock.c:1296:1: internal compiler error: Segmentation fault
net/ipv4/inet_timewait_sock.c:259:1: internal compiler error: Segmentation fault
net/ipv4/ip_forward.c:175:1: internal compiler error: Segmentation fault
net/ipv4/ip_input.c:661:1: internal compiler error: Segmentation fault
net/ipv4/ip_options.c:641:1: internal compiler error: Segmentation fault
net/ipv4/ip_sockglue.c:1794:1: internal compiler error: Segmentation fault
net/ipv4/ip_tunnel.c:1280:1: internal compiler error: Segmentation fault
net/ipv4/metrics.c:92:1: internal compiler error: Segmentation fault
net/ipv4/netlink.c:33:1: internal compiler error: Segmentation fault
net/ipv4/syncookies.c:449:1: internal compiler error: Segmentation fault
net/ipv4/tcp_fastopen.c:591:1: internal compiler error: Segmentation fault
net/ipv4/tcp_input.c:6992:1: internal compiler error: Segmentation fault
net/ipv4/tcp_minisocks.c:852:1: internal compiler error: Segmentation fault
net/ipv4/tcp_rate.c:204:1: internal compiler error: Segmentation fault
net/ipv4/tcp_recovery.c:240:1: internal compiler error: Segmentation fault
net/ipv4/tcp_timer.c:798:1: internal compiler error: Segmentation fault
net/ipv4/tcp_ulp.c:161:1: internal compiler error: Segmentation fault
net/ipv4/udp_tunnel_core.c:205:1: internal compiler error: Segmentation fault
net/ipv4/xfrm4_input.c:172:1: internal compiler error: Segmentation fault
net/ipv6/addrconf_core.c:273:1: internal compiler error: Segmentation fault
net/ipv6/exthdrs_core.c:280:1: internal compiler error: Segmentation fault
net/ipv6/ip6_checksum.c:137:1: internal compiler error: Segmentation fault
net/ipv6/output_core.c:165:1: internal compiler error: Segmentation fault
net/llc/llc_input.c:227:1: internal compiler error: Segmentation fault
net/llc/llc_output.c:74:1: internal compiler error: Segmentation fault
net/netrom/nr_dev.c:178:1: internal compiler error: Segmentation fault
net/netrom/nr_in.c:301:1: internal compiler error: Segmentation fault
net/netrom/nr_out.c:270:1: internal compiler error: Segmentation fault
net/netrom/nr_route.c:983:1: internal compiler error: Segmentation fault
net/netrom/nr_subr.c:278:1: internal compiler error: Segmentation fault
net/netrom/nr_timer.c:247:1: internal compiler error: Segmentation fault
net/rxrpc/call_accept.c:491:1: internal compiler error: Segmentation fault
net/rxrpc/call_event.c:446:1: internal compiler error: Segmentation fault
net/rxrpc/call_object.c:733:1: internal compiler error: Segmentation fault
net/rxrpc/conn_client.c:1121:1: internal compiler error: Segmentation fault
net/rxrpc/conn_event.c:499:1: internal compiler error: Segmentation fault
net/rxrpc/conn_object.c:486:1: internal compiler error: Segmentation fault
net/rxrpc/conn_service.c:203:1: internal compiler error: Segmentation fault
net/rxrpc/input.c:1468:1: internal compiler error: Segmentation fault
net/rxrpc/insecure.c:102:1: internal compiler error: Segmentation fault
net/rxrpc/key.c:695:1: internal compiler error: Segmentation fault
net/rxrpc/local_event.c:115:1: internal compiler error: Segmentation fault
net/rxrpc/local_object.c:467:1: internal compiler error: Segmentation fault
net/rxrpc/output.c:675:1: internal compiler error: Segmentation fault
net/rxrpc/peer_event.c:417:1: internal compiler error: Segmentation fault
net/rxrpc/peer_object.c:526:1: internal compiler error: Segmentation fault
net/rxrpc/recvmsg.c:818:1: internal compiler error: Segmentation fault
net/rxrpc/rtt.c:195:1: internal compiler error: Segmentation fault
net/rxrpc/sendmsg.c:860:1: internal compiler error: Segmentation fault
net/rxrpc/server_key.c:146:1: internal compiler error: Segmentation fault
net/rxrpc/skbuff.c:96:1: internal compiler error: Segmentation fault
net/rxrpc/utils.c:44:1: internal compiler error: Segmentation fault
net/sched/sch_fifo.c:271:1: internal compiler error: Segmentation fault
net/sched/sch_frag.c:152:1: internal compiler error: Segmentation fault
net/sctp/associola.c:1731:1: internal compiler error: Segmentation fault
net/sctp/auth.c:1079:1: internal compiler error: Segmentation fault
net/sctp/bind_addr.c:569:1: internal compiler error: Segmentation fault
net/sctp/chunk.c:353:1: internal compiler error: Segmentation fault
net/sctp/endpointola.c:417:1: internal compiler error: Segmentation fault
net/sctp/input.c:1347:1: internal compiler error: Segmentation fault
net/sctp/inqueue.c:237:1: internal compiler error: Segmentation fault
net/sctp/output.c:864:1: internal compiler error: Segmentation fault
net/sctp/outqueue.c:1919:1: internal compiler error: Segmentation fault
net/sctp/sm_make_chunk.c:3937:1: internal compiler error: Segmentation fault
net/sctp/sm_sideeffect.c:1818:1: internal compiler error: Segmentation fault
net/sctp/sm_statefuns.c:6679:1: internal compiler error: Segmentation fault
net/sctp/socket.c:9664:1: internal compiler error: Segmentation fault
net/sctp/stream.c:1089:1: internal compiler error: Segmentation fault
net/sctp/stream_interleave.c:1360:1: internal compiler error: Segmentation fault
net/sctp/stream_sched.c:273:1: internal compiler error: Segmentation fault
net/sctp/stream_sched_prio.c:337:1: internal compiler error: Segmentation fault
net/sctp/stream_sched_rr.c:191:1: internal compiler error: Segmentation fault
net/sctp/transport.c:853:1: internal compiler error: Segmentation fault
net/sctp/tsnmap.c:364:1: internal compiler error: Segmentation fault
net/sctp/ulpevent.c:1190:1: internal compiler error: Segmentation fault
net/sctp/ulpqueue.c:1136:1: internal compiler error: Segmentation fault
net/unix/scm.c:154:1: internal compiler error: Segmentation fault
net/vmw_vsock/af_vsock_tap.c:110:1: internal compiler error: Segmentation fault
net/vmw_vsock/virtio_transport_common.c:1352:1: internal compiler error: Segmentation fault
net/vmw_vsock/vsock_addr.c:69:1: internal compiler error: Segmentation fault
net/xfrm/xfrm_algo.c:866:1: internal compiler error: Segmentation fault
net/xfrm/xfrm_hash.c:40:1: internal compiler error: Segmentation fault
net/xfrm/xfrm_ipcomp.c:373:1: internal compiler error: Segmentation fault
net/xfrm/xfrm_output.c:909:1: internal compiler error: Segmentation fault
net/xfrm/xfrm_replay.c:791:1: internal compiler error: Segmentation fault
security/keys/request_key.c:805:1: internal compiler error: Segmentation fault
sound/core/control.c:2307:1: internal compiler error: Segmentation fault
sound/core/device.c:260:1: internal compiler error: Segmentation fault
sound/core/init.c:1094:1: internal compiler error: Segmentation fault
sound/core/memalloc.c:750:1: internal compiler error: Segmentation fault
sound/core/pcm_lib.c:2534:1: internal compiler error: Segmentation fault
sound/core/pcm_memory.c:530:1: internal compiler error: Segmentation fault
sound/core/pcm_misc.c:616:1: internal compiler error: Segmentation fault
sound/core/pcm_native.c:4132:1: internal compiler error: Segmentation fault
sound/core/seq/seq_fifo.c:283:1: internal compiler error: Segmentation fault
sound/core/seq/seq_lock.c:26:1: internal compiler error: Segmentation fault
sound/core/seq/seq_memory.c:504:1: internal compiler error: Segmentation fault
sound/core/seq/seq_midi_event.c:459:1: internal compiler error: Segmentation fault
sound/core/seq/seq_ports.c:711:1: internal compiler error: Segmentation fault
sound/core/seq/seq_queue.c:726:1: internal compiler error: Segmentation fault
sound/core/seq/seq_timer.c:471:1: internal compiler error: Segmentation fault
sound/usb/6fire/chip.c:130:2: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
sound/usb/line6/driver.c:770:2: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- alpha-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- include-uapi-linux-byteorder-big_endian.h:warning:passing-argument-of-__fswab64-makes-integer-from-pointer-without-a-cast
|   |-- include-uapi-linux-swab.h:warning:cast-from-pointer-to-integer-of-different-size
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- include-uapi-linux-byteorder-big_endian.h:warning:passing-argument-of-__fswab64-makes-integer-from-pointer-without-a-cast
|   |-- include-uapi-linux-swab.h:warning:cast-from-pointer-to-integer-of-different-size
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-buildonly-randconfig-r005-20220406
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- arc-defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
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
|-- arc-randconfig-r034-20220407
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- arc-vdk_hs38_smp_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- arm-allmodconfig
|   |-- ERROR:__aeabi_uldivmod-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- include-uapi-linux-swab.h:warning:cast-from-pointer-to-integer-of-different-size
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
|   |-- include-uapi-linux-swab.h:warning:cast-from-pointer-to-integer-of-different-size
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
|-- arm-buildonly-randconfig-r004-20220407
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
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
|-- arm-randconfig-c002-20220406
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm-realview_defconfig
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
|-- arm64-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm64-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm64-buildonly-randconfig-r005-20220407
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm64-defconfig
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm64-randconfig-r002-20220407
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm64-randconfig-r011-20220406
|   |-- include-uapi-linux-byteorder-big_endian.h:warning:passing-argument-of-__fswab64-makes-integer-from-pointer-without-a-cast
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm64-randconfig-r021-20220406
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm64-randconfig-r025-20220406
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- csky-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- include-uapi-linux-byteorder-little_endian.h:warning:cast-from-pointer-to-integer-of-different-size
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- csky-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- include-uapi-linux-byteorder-little_endian.h:warning:cast-from-pointer-to-integer-of-different-size
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
|-- h8300-randconfig-r022-20220407
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- i386-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn31-dcn31_hubp.c:warning:no-previous-prototype-for-hubp31_program_extended_blank
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
|   |-- include-uapi-linux-byteorder-little_endian.h:warning:cast-from-pointer-to-integer-of-different-size
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
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-s002
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- ia64-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- ia64-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- ia64-defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- ia64-randconfig-r001-20220406
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|-- ia64-randconfig-r022-20220406
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- ia64-randconfig-r026-20220406
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- ia64-randconfig-r032-20220406
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- m68k-allmodconfig
|   |-- drivers-counter-quad-.c:sparse:sparse:incompatible-types-in-conditional-expression-(different-base-types):
|   |-- drivers-counter-quad-.c:sparse:unsigned-char
|   |-- drivers-counter-quad-.c:sparse:void
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- include-uapi-linux-byteorder-big_endian.h:warning:passing-argument-of-__fswab64-makes-integer-from-pointer-without-a-cast
|   `-- include-uapi-linux-swab.h:warning:cast-from-pointer-to-integer-of-different-size
|-- m68k-allyesconfig
|   |-- drivers-counter-quad-.c:sparse:sparse:incompatible-types-in-conditional-expression-(different-base-types):
|   |-- drivers-counter-quad-.c:sparse:unsigned-char
|   |-- drivers-counter-quad-.c:sparse:void
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- include-uapi-linux-byteorder-big_endian.h:warning:passing-argument-of-__fswab64-makes-integer-from-pointer-without-a-cast
|   `-- include-uapi-linux-swab.h:warning:cast-from-pointer-to-integer-of-different-size
|-- m68k-buildonly-randconfig-r002-20220406
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- include-uapi-linux-byteorder-big_endian.h:warning:passing-argument-of-__fswab64-makes-integer-from-pointer-without-a-cast
|   `-- include-uapi-linux-swab.h:warning:cast-from-pointer-to-integer-of-different-size
|-- m68k-defconfig
|   |-- include-uapi-linux-byteorder-big_endian.h:warning:passing-argument-of-__fswab64-makes-integer-from-pointer-without-a-cast
|   `-- include-uapi-linux-swab.h:warning:cast-from-pointer-to-integer-of-different-size
|-- m68k-randconfig-c024-20220406
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- m68k-randconfig-r012-20220406
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- include-uapi-linux-byteorder-big_endian.h:warning:passing-argument-of-__fswab64-makes-integer-from-pointer-without-a-cast
|   `-- include-uapi-linux-swab.h:warning:cast-from-pointer-to-integer-of-different-size
|-- m68k-randconfig-r025-20220407
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- include-uapi-linux-byteorder-big_endian.h:warning:passing-argument-of-__fswab64-makes-integer-from-pointer-without-a-cast
|   `-- include-uapi-linux-swab.h:warning:cast-from-pointer-to-integer-of-different-size
|-- m68k-randconfig-r033-20220406
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- m68k-randconfig-s032-20220406
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- m68k-sun3x_defconfig
|   |-- include-uapi-linux-byteorder-big_endian.h:warning:passing-argument-of-__fswab64-makes-integer-from-pointer-without-a-cast
|   `-- include-uapi-linux-swab.h:warning:cast-from-pointer-to-integer-of-different-size
|-- microblaze-randconfig-c023-20220407
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- microblaze-randconfig-r016-20220406
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- microblaze-randconfig-r033-20220407
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- mips-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- include-uapi-linux-swab.h:warning:cast-from-pointer-to-integer-of-different-size
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
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- include-uapi-linux-swab.h:warning:cast-from-pointer-to-integer-of-different-size
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
|-- mips-ci20_defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- mips-maltasmvp_defconfig
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
|-- nios2-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- include-uapi-linux-byteorder-little_endian.h:warning:cast-from-pointer-to-integer-of-different-size
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- nios2-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- include-uapi-linux-byteorder-little_endian.h:warning:cast-from-pointer-to-integer-of-different-size
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- nios2-defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- nios2-randconfig-r003-20220406
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- nios2-randconfig-r003-20220407
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- nios2-randconfig-r006-20220406
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- nios2-randconfig-r014-20220406
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- nios2-randconfig-r026-20220407
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- nios2-randconfig-s031-20220406
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- openrisc-buildonly-randconfig-r006-20220406
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- openrisc-randconfig-c004-20220406
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- parisc-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- include-uapi-linux-byteorder-big_endian.h:warning:passing-argument-of-__fswab64-makes-integer-from-pointer-without-a-cast
|   |-- include-uapi-linux-swab.h:warning:cast-from-pointer-to-integer-of-different-size
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- parisc-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- include-uapi-linux-byteorder-big_endian.h:warning:passing-argument-of-__fswab64-makes-integer-from-pointer-without-a-cast
|   |-- include-uapi-linux-swab.h:warning:cast-from-pointer-to-integer-of-different-size
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
|-- parisc-randconfig-r004-20220406
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
|   |-- include-uapi-linux-swab.h:warning:cast-from-pointer-to-integer-of-different-size
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
|   |-- include-uapi-linux-swab.h:warning:cast-from-pointer-to-integer-of-different-size
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
|-- powerpc-currituck_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- powerpc-eiger_defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- powerpc-linkstation_defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- powerpc-randconfig-r015-20220406
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- powerpc64-randconfig-c003-20220406
|   |-- drivers-gpu-drm-drm_of.c:ERROR:probable-double-put.
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- riscv-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
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
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
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
|-- riscv-randconfig-r013-20220406
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
|-- riscv-randconfig-r031-20220407
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- riscv-randconfig-r042-20220406
|   |-- arch-riscv-kernel-cacheinfo.c:internal-compiler-error:Segmentation-fault
|   |-- arch-riscv-kernel-crash_dump.c:internal-compiler-error:Segmentation-fault
|   |-- arch-riscv-kernel-patch.c:internal-compiler-error:Segmentation-fault
|   |-- arch-riscv-kernel-signal.c:internal-compiler-error:Segmentation-fault
|   |-- arch-riscv-mm-extable.c:internal-compiler-error:Segmentation-fault
|   |-- crypto-acompress.c:internal-compiler-error:Segmentation-fault
|   |-- crypto-aead.c:internal-compiler-error:Segmentation-fault
|   |-- crypto-ahash.c:internal-compiler-error:Segmentation-fault
|   |-- crypto-akcipher.c:internal-compiler-error:Segmentation-fault
|   |-- crypto-api.c:internal-compiler-error:Segmentation-fault
|   |-- crypto-asymmetric_keys-public_key.c:internal-compiler-error:Segmentation-fault
|   |-- crypto-dh.c:internal-compiler-error:Segmentation-fault
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
|   |-- drivers-base-syscore.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-bluetooth-btbcm.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-bluetooth-btintel.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-bluetooth-btmrvl_debugfs.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-bluetooth-btmrvl_main.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-bluetooth-btrtl.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-char-ipmi-ipmi_bt_sm.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-char-ipmi-ipmi_kcs_sm.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-char-ipmi-ipmi_si_hotmod.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-char-ipmi-ipmi_si_mem_io.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-char-ipmi-ipmi_smic_sm.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-clk-clk-composite.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-clk-clk-fractional-divider.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-comedi-comedi_buf.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-comedi-drivers.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-comedi-range.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-connector-cn_queue.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-connector-connector.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-crypto-ccree-cc_aead.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-crypto-ccree-cc_buffer_mgr.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-crypto-ccree-cc_cipher.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-crypto-ccree-cc_hash.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-crypto-ccree-cc_request_mgr.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-crypto-ccree-cc_sram_mgr.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-dma-buf-dma-fence-array.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-dma-buf-dma-fence-chain.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-dma-buf-dma-fence.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-dma-buf-dma-heap.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpio-gpiolib-of.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-hid-hid-cmedia.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-hid-hid-debug.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-hid-hid-uclogic-params.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-hid-hid-uclogic-rdesc.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-hid-usbhid-hiddev.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-addr.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-agent.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-cache.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-cm_trace.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-counters.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-cq.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-ib_core_uverbs.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-iwpm_msg.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-iwpm_util.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-lag.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-mad_rmpp.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-mr_pool.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-multicast.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-netlink.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-packer.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-restrack.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-rw.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-sa_query.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-smi.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-sysfs.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-trace.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-ud_header.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-core-verbs.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-sw-siw-siw_cm.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-sw-siw-siw_cq.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-sw-siw-siw_mem.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-sw-siw-siw_qp.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-sw-siw-siw_qp_tx.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-infiniband-sw-siw-siw_verbs.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-input-matrix-keymap.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-input-rmi4-rmi_2d_sensor.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-input-rmi4-rmi_f01.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-input-rmi4-rmi_f03.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-input-rmi4-rmi_f55.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-input-touchscreen.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-leds-leds-ti-lmu-common.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-media-common-videobuf2-frame_vector.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-media-common-videobuf2-vb2-trace.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-media-common-videobuf2-videobuf2-memops.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-media-common-videobuf2-videobuf2-vmalloc.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-mfd-madera-core.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-mfd-mfd-core.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-mtd-chips-cfi_cmdset_0020.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-mtd-hyperbus-hyperbus-core.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-mtd-mtdsuper.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-mtd-nand-bbt.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-net-can-dev-bittiming.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-net-can-dev-length.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-net-can-dev-netlink.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-net-can-dev-rx-offload.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-net-can-dev-skb.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-net-can-flexcan-flexcan-ethtool.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-net-can-usb-etas_es58x-es581_4.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-net-can-usb-etas_es58x-es58x_fd.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-net-can-usb-kvaser_usb-kvaser_usb_hydra.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-net-can-usb-kvaser_usb-kvaser_usb_leaf.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-nfc-fdp-fdp.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-of-kobj.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-parport-ieee1284_ops.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-pci-of.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-ptp-ptp_vclock.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-ssb-driver_chipcommon.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-ssb-scan.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-usb-cdns3-drd.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-usb-chipidea-host.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-usb-core-config.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-usb-core-devices.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-usb-core-endpoint.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-usb-core-generic.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-usb-core-port.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-usb-core-quirks.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-usb-core-sysfs.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-usb-dwc3-debugfs.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-usb-dwc3-host.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-usb-host-xhci-dbg.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-usb-typec-bus.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-usb-usbip-usbip_event.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-video-fbdev-core-fb_defio.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-video-fbdev-core-fbcmap.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-video-fbdev-core-fbsysfs.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-virtio-virtio_ring.c:internal-compiler-error:Segmentation-fault
|   |-- drivers-w1-w1_family.c:internal-compiler-error:Segmentation-fault
|   |-- fs-afs-addr_list.c:internal-compiler-error:Segmentation-fault
|   |-- fs-afs-callback.c:internal-compiler-error:Segmentation-fault
|   |-- fs-afs-cmservice.c:internal-compiler-error:Segmentation-fault
|   |-- fs-afs-dir_edit.c:internal-compiler-error:Segmentation-fault
|   |-- fs-afs-dir_silly.c:internal-compiler-error:Segmentation-fault
|   |-- fs-afs-dynroot.c:internal-compiler-error:Segmentation-fault
|   |-- fs-afs-file.c:internal-compiler-error:Segmentation-fault
|   |-- fs-afs-flock.c:internal-compiler-error:Segmentation-fault
|   |-- fs-afs-fs_operation.c:internal-compiler-error:Segmentation-fault
|   |-- fs-afs-fs_probe.c:internal-compiler-error:Segmentation-fault
|   |-- fs-afs-mntpt.c:internal-compiler-error:Segmentation-fault
|   |-- fs-afs-server_list.c:internal-compiler-error:Segmentation-fault
|   |-- fs-afs-vl_alias.c:internal-compiler-error:Segmentation-fault
|   |-- fs-afs-vl_list.c:internal-compiler-error:Segmentation-fault
|   |-- fs-afs-vl_probe.c:internal-compiler-error:Segmentation-fault
|   |-- fs-afs-vl_rotate.c:internal-compiler-error:Segmentation-fault
|   |-- fs-afs-vlclient.c:internal-compiler-error:Segmentation-fault
|   |-- fs-afs-volume.c:internal-compiler-error:Segmentation-fault
|   |-- fs-afs-write.c:internal-compiler-error:Segmentation-fault
|   |-- fs-afs-xattr.c:internal-compiler-error:Segmentation-fault
|   |-- fs-ceph-addr.c:internal-compiler-error:Segmentation-fault
|   |-- fs-ceph-caps.c:internal-compiler-error:Segmentation-fault
|   |-- fs-ceph-debugfs.c:internal-compiler-error:Segmentation-fault
|   |-- fs-ceph-dir.c:internal-compiler-error:Segmentation-fault
|   |-- fs-ceph-export.c:internal-compiler-error:Segmentation-fault
|   |-- fs-ceph-file.c:internal-compiler-error:Segmentation-fault
|   |-- fs-ceph-inode.c:internal-compiler-error:Segmentation-fault
|   |-- fs-ceph-io.c:internal-compiler-error:Segmentation-fault
|   |-- fs-ceph-ioctl.c:internal-compiler-error:Segmentation-fault
|   |-- fs-ceph-mdsmap.c:internal-compiler-error:Segmentation-fault
|   |-- fs-ceph-metric.c:internal-compiler-error:Segmentation-fault
|   |-- fs-ceph-quota.c:internal-compiler-error:Segmentation-fault
|   |-- fs-ceph-snap.c:internal-compiler-error:Segmentation-fault
|   |-- fs-ceph-xattr.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-cifs_debug.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-cifs_dfs_ref.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-cifs_spnego.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-cifs_unicode.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-cifsacl.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-cifsencrypt.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-cifssmb.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-connect.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-dfs_cache.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-dir.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-file.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-fs_context.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-inode.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-ioctl.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-link.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-misc.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-netmisc.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-readdir.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-sess.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-smb1ops.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-smb2file.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-smb2inode.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-smb2maperror.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-smb2misc.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-smb2ops.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-smb2pdu.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-smb2transport.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-smbencrypt.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-trace.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-transport.c:internal-compiler-error:Segmentation-fault
|   |-- fs-cifs-unc.c:internal-compiler-error:Segmentation-fault
|   |-- fs-coda-cache.c:internal-compiler-error:Segmentation-fault
|   |-- fs-coda-cnode.c:internal-compiler-error:Segmentation-fault
|   |-- fs-coda-dir.c:internal-compiler-error:Segmentation-fault
|   |-- fs-coda-file.c:internal-compiler-error:Segmentation-fault
|   |-- fs-coda-pioctl.c:internal-compiler-error:Segmentation-fault
|   |-- fs-coda-symlink.c:internal-compiler-error:Segmentation-fault
|   |-- fs-coda-upcall.c:internal-compiler-error:Segmentation-fault
|   |-- fs-configfs-file.c:internal-compiler-error:Segmentation-fault
|   |-- fs-configfs-inode.c:internal-compiler-error:Segmentation-fault
|   |-- fs-configfs-symlink.c:internal-compiler-error:Segmentation-fault
|   |-- fs-crypto-fname.c:internal-compiler-error:Segmentation-fault
|   |-- fs-crypto-hkdf.c:internal-compiler-error:Segmentation-fault
|   |-- fs-crypto-hooks.c:internal-compiler-error:Segmentation-fault
|   |-- fs-crypto-keysetup.c:internal-compiler-error:Segmentation-fault
|   |-- fs-crypto-keysetup_v1.c:internal-compiler-error:Segmentation-fault
|   |-- fs-crypto-policy.c:internal-compiler-error:Segmentation-fault
|   |-- fs-d_path.c:internal-compiler-error:Segmentation-fault
|   |-- fs-dlm-dir.c:internal-compiler-error:Segmentation-fault
|   |-- fs-dlm-member.c:internal-compiler-error:Segmentation-fault
|   |-- fs-dlm-midcomms.c:internal-compiler-error:Segmentation-fault
|   |-- fs-dlm-rcom.c:internal-compiler-error:Segmentation-fault
|   |-- fs-dlm-recover.c:internal-compiler-error:Segmentation-fault
|   |-- fs-dlm-recoverd.c:internal-compiler-error:Segmentation-fault
|   |-- fs-dlm-requestqueue.c:internal-compiler-error:Segmentation-fault
|   |-- fs-eventfd.c:internal-compiler-error:Segmentation-fault
|   |-- fs-exportfs-expfs.c:internal-compiler-error:Segmentation-fault
|   |-- fs-fhandle.c:internal-compiler-error:Segmentation-fault
|   |-- fs-fs_context.c:internal-compiler-error:Segmentation-fault
|   |-- fs-fs_pin.c:internal-compiler-error:Segmentation-fault
|   |-- fs-fs_struct.c:internal-compiler-error:Segmentation-fault
|   |-- fs-fsopen.c:internal-compiler-error:Segmentation-fault
|   |-- fs-ioctl.c:internal-compiler-error:Segmentation-fault
|   |-- fs-kernfs-dir.c:internal-compiler-error:Segmentation-fault
|   |-- fs-kernfs-file.c:internal-compiler-error:Segmentation-fault
|   |-- fs-kernfs-inode.c:internal-compiler-error:Segmentation-fault
|   |-- fs-kernfs-symlink.c:internal-compiler-error:Segmentation-fault
|   |-- fs-namei.c:internal-compiler-error:Segmentation-fault
|   |-- fs-nls-nls_base.c:internal-compiler-error:Segmentation-fault
|   |-- fs-open.c:internal-compiler-error:Segmentation-fault
|   |-- fs-overlayfs-dir.c:internal-compiler-error:Segmentation-fault
|   |-- fs-overlayfs-export.c:internal-compiler-error:Segmentation-fault
|   |-- fs-overlayfs-inode.c:internal-compiler-error:Segmentation-fault
|   |-- fs-overlayfs-namei.c:internal-compiler-error:Segmentation-fault
|   |-- fs-overlayfs-readdir.c:internal-compiler-error:Segmentation-fault
|   |-- fs-overlayfs-util.c:internal-compiler-error:Segmentation-fault
|   |-- fs-pnode.c:internal-compiler-error:Segmentation-fault
|   |-- fs-posix_acl.c:internal-compiler-error:Segmentation-fault
|   |-- fs-pstore-pmsg.c:internal-compiler-error:Segmentation-fault
|   |-- fs-quota-quota.c:internal-compiler-error:Segmentation-fault
|   |-- fs-readdir.c:internal-compiler-error:Segmentation-fault
|   |-- fs-select.c:internal-compiler-error:Segmentation-fault
|   |-- fs-smbfs_common-cifs_md4.c:internal-compiler-error:Segmentation-fault
|   |-- fs-splice.c:internal-compiler-error:Segmentation-fault
|   |-- fs-statfs.c:internal-compiler-error:Segmentation-fault
|   |-- fs-sync.c:internal-compiler-error:Segmentation-fault
|   |-- fs-utimes.c:internal-compiler-error:Segmentation-fault
|   |-- fs-xattr.c:internal-compiler-error:Segmentation-fault
|   |-- ipc-msgutil.c:internal-compiler-error:Segmentation-fault
|   |-- kernel-cgroup-freezer.c:internal-compiler-error:Segmentation-fault
|   |-- kernel-dma-direct.c:internal-compiler-error:Segmentation-fault
|   |-- kernel-irq-chip.c:internal-compiler-error:Segmentation-fault
|   |-- kernel-printk-printk_ringbuffer.c:internal-compiler-error:Segmentation-fault
|   |-- kernel-printk-printk_safe.c:internal-compiler-error:Segmentation-fault
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
|   |-- lib-cmdline.c:internal-compiler-error:Segmentation-fault
|   |-- lib-crypto-aes.c:internal-compiler-error:Segmentation-fault
|   |-- lib-crypto-blake2s-generic.c:internal-compiler-error:Segmentation-fault
|   |-- lib-crypto-poly1305.c:internal-compiler-error:Segmentation-fault
|   |-- lib-dim-dim.c:internal-compiler-error:Segmentation-fault
|   |-- lib-dim-net_dim.c:internal-compiler-error:Segmentation-fault
|   |-- lib-dim-rdma_dim.c:internal-compiler-error:Segmentation-fault
|   |-- lib-dynamic_queue_limits.c:internal-compiler-error:Segmentation-fault
|   |-- lib-extable.c:internal-compiler-error:Segmentation-fault
|   |-- lib-fdt.c:internal-compiler-error:Segmentation-fault
|   |-- lib-fdt_ro.c:internal-compiler-error:Segmentation-fault
|   |-- lib-fdt_rw.c:internal-compiler-error:Segmentation-fault
|   |-- lib-fdt_sw.c:internal-compiler-error:Segmentation-fault
|   |-- lib-fdt_wip.c:internal-compiler-error:Segmentation-fault
|   |-- lib-flex_proportions.c:internal-compiler-error:Segmentation-fault
|   |-- lib-iov_iter.c:internal-compiler-error:Segmentation-fault
|   |-- lib-is_single_threaded.c:internal-compiler-error:Segmentation-fault
|   |-- lib-kunit-resource.c:internal-compiler-error:Segmentation-fault
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
|   |-- lib-nlattr.c:internal-compiler-error:Segmentation-fault
|   |-- lib-oid_registry.c:internal-compiler-error:Segmentation-fault
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
|   |-- net-ax25-ax25_iface.c:internal-compiler-error:Segmentation-fault
|   |-- net-ax25-ax25_in.c:internal-compiler-error:Segmentation-fault
|   |-- net-ax25-ax25_ip.c:internal-compiler-error:Segmentation-fault
|   |-- net-ax25-ax25_out.c:internal-compiler-error:Segmentation-fault
|   |-- net-ax25-ax25_std_in.c:internal-compiler-error:Segmentation-fault
|   |-- net-ax25-ax25_std_timer.c:internal-compiler-error:Segmentation-fault
|   |-- net-ax25-ax25_subr.c:internal-compiler-error:Segmentation-fault
|   |-- net-bluetooth-ecdh_helper.c:internal-compiler-error:Segmentation-fault
|   |-- net-bluetooth-eir.c:internal-compiler-error:Segmentation-fault
|   |-- net-bluetooth-hci_codec.c:internal-compiler-error:Segmentation-fault
|   |-- net-bluetooth-hci_conn.c:internal-compiler-error:Segmentation-fault
|   |-- net-bluetooth-hci_core.c:internal-compiler-error:Segmentation-fault
|   |-- net-bluetooth-hci_event.c:internal-compiler-error:Segmentation-fault
|   |-- net-bluetooth-hci_request.c:internal-compiler-error:Segmentation-fault
|   |-- net-bluetooth-hci_sync.c:internal-compiler-error:Segmentation-fault
|   |-- net-bluetooth-leds.c:internal-compiler-error:Segmentation-fault
|   |-- net-bluetooth-mgmt.c:internal-compiler-error:Segmentation-fault
|   |-- net-bluetooth-mgmt_config.c:internal-compiler-error:Segmentation-fault
|   |-- net-bluetooth-mgmt_util.c:internal-compiler-error:Segmentation-fault
|   |-- net-bluetooth-smp.c:internal-compiler-error:Segmentation-fault
|   |-- net-bridge-br_arp_nd_proxy.c:internal-compiler-error:Segmentation-fault
|   |-- net-bridge-br_device.c:internal-compiler-error:Segmentation-fault
|   |-- net-bridge-br_forward.c:internal-compiler-error:Segmentation-fault
|   |-- net-bridge-br_if.c:internal-compiler-error:Segmentation-fault
|   |-- net-bridge-br_input.c:internal-compiler-error:Segmentation-fault
|   |-- net-bridge-br_ioctl.c:internal-compiler-error:Segmentation-fault
|   |-- net-bridge-br_mrp.c:internal-compiler-error:Segmentation-fault
|   |-- net-bridge-br_mrp_netlink.c:internal-compiler-error:Segmentation-fault
|   |-- net-bridge-br_netlink_tunnel.c:internal-compiler-error:Segmentation-fault
|   |-- net-bridge-br_stp.c:internal-compiler-error:Segmentation-fault
|   |-- net-bridge-br_stp_bpdu.c:internal-compiler-error:Segmentation-fault
|   |-- net-bridge-br_stp_if.c:internal-compiler-error:Segmentation-fault
|   |-- net-bridge-br_stp_timer.c:internal-compiler-error:Segmentation-fault
|   |-- net-bridge-br_sysfs_br.c:internal-compiler-error:Segmentation-fault
|   |-- net-bridge-br_sysfs_if.c:internal-compiler-error:Segmentation-fault
|   |-- net-caif-cfcnfg.c:internal-compiler-error:Segmentation-fault
|   |-- net-caif-cfctrl.c:internal-compiler-error:Segmentation-fault
|   |-- net-caif-cfdgml.c:internal-compiler-error:Segmentation-fault
|   |-- net-caif-cffrml.c:internal-compiler-error:Segmentation-fault
|   |-- net-caif-cfmuxl.c:internal-compiler-error:Segmentation-fault
|   |-- net-caif-cfpkt_skbuff.c:internal-compiler-error:Segmentation-fault
|   |-- net-caif-cfrfml.c:internal-compiler-error:Segmentation-fault
|   |-- net-caif-cfserl.c:internal-compiler-error:Segmentation-fault
|   |-- net-caif-cfsrvl.c:internal-compiler-error:Segmentation-fault
|   |-- net-caif-cfutill.c:internal-compiler-error:Segmentation-fault
|   |-- net-caif-cfveil.c:internal-compiler-error:Segmentation-fault
|   |-- net-ceph-armor.c:internal-compiler-error:Segmentation-fault
|   |-- net-ceph-auth.c:internal-compiler-error:Segmentation-fault
|   |-- net-ceph-auth_none.c:internal-compiler-error:Segmentation-fault
|   |-- net-ceph-auth_x.c:internal-compiler-error:Segmentation-fault
|   |-- net-ceph-buffer.c:internal-compiler-error:Segmentation-fault
|   |-- net-ceph-cls_lock_client.c:internal-compiler-error:Segmentation-fault
|   |-- net-ceph-crush-crush.c:internal-compiler-error:Segmentation-fault
|   |-- net-ceph-crush-mapper.c:internal-compiler-error:Segmentation-fault
|   |-- net-ceph-decode.c:internal-compiler-error:Segmentation-fault
|   |-- net-ceph-messenger_v1.c:internal-compiler-error:Segmentation-fault
|   |-- net-ceph-messenger_v2.c:internal-compiler-error:Segmentation-fault
|   |-- net-ceph-mon_client.c:internal-compiler-error:Segmentation-fault
|   |-- net-ceph-msgpool.c:internal-compiler-error:Segmentation-fault
|   |-- net-ceph-osdmap.c:internal-compiler-error:Segmentation-fault
|   |-- net-ceph-pagelist.c:internal-compiler-error:Segmentation-fault
|   |-- net-ceph-pagevec.c:internal-compiler-error:Segmentation-fault
|   |-- net-ceph-snapshot.c:internal-compiler-error:Segmentation-fault
|   |-- net-ceph-string_table.c:internal-compiler-error:Segmentation-fault
|   |-- net-ceph-striper.c:internal-compiler-error:Segmentation-fault
|   |-- net-core-datagram.c:internal-compiler-error:Segmentation-fault
|   |-- net-core-dev_addr_lists.c:internal-compiler-error:Segmentation-fault
|   |-- net-core-dst.c:internal-compiler-error:Segmentation-fault
|   |-- net-core-dst_cache.c:internal-compiler-error:Segmentation-fault
|   |-- net-core-flow_offload.c:internal-compiler-error:Segmentation-fault
|   |-- net-core-gen_estimator.c:internal-compiler-error:Segmentation-fault
|   |-- net-core-gen_stats.c:internal-compiler-error:Segmentation-fault
|   |-- net-core-gro.c:internal-compiler-error:Segmentation-fault
|   |-- net-core-gro_cells.c:internal-compiler-error:Segmentation-fault
|   |-- net-core-link_watch.c:internal-compiler-error:Segmentation-fault
|   |-- net-core-lwtunnel.c:internal-compiler-error:Segmentation-fault
|   |-- net-core-net-traces.c:internal-compiler-error:Segmentation-fault
|   |-- net-core-of_net.c:internal-compiler-error:Segmentation-fault
|   |-- net-core-scm.c:internal-compiler-error:Segmentation-fault
|   |-- net-core-secure_seq.c:internal-compiler-error:Segmentation-fault
|   |-- net-core-sock.c:internal-compiler-error:Segmentation-fault
|   |-- net-core-sock_reuseport.c:internal-compiler-error:Segmentation-fault
|   |-- net-core-stream.c:internal-compiler-error:Segmentation-fault
|   |-- net-core-tso.c:internal-compiler-error:Segmentation-fault
|   |-- net-core-utils.c:internal-compiler-error:Segmentation-fault
|   |-- net-dccp-ccids-ccid2.c:internal-compiler-error:Segmentation-fault
|   |-- net-dccp-input.c:internal-compiler-error:Segmentation-fault
|   |-- net-dccp-output.c:internal-compiler-error:Segmentation-fault
|   |-- net-dccp-qpolicy.c:internal-compiler-error:Segmentation-fault
|   |-- net-devres.c:internal-compiler-error:Segmentation-fault
|   |-- net-dns_resolver-dns_query.c:internal-compiler-error:Segmentation-fault
|   |-- net-ethtool-common.c:internal-compiler-error:Segmentation-fault
|   |-- net-ethtool-ioctl.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv4-datagram.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv4-fib_semantics.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv4-inet_connection_sock.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv4-inet_timewait_sock.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv4-ip_forward.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv4-ip_input.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv4-ip_options.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv4-ip_sockglue.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv4-ip_tunnel.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv4-metrics.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv4-netlink.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv4-syncookies.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv4-tcp_fastopen.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv4-tcp_input.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv4-tcp_minisocks.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv4-tcp_rate.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv4-tcp_recovery.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv4-tcp_timer.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv4-tcp_ulp.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv4-udp_tunnel_core.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv4-xfrm4_input.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv6-addrconf_core.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv6-exthdrs_core.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv6-ip6_checksum.c:internal-compiler-error:Segmentation-fault
|   |-- net-ipv6-output_core.c:internal-compiler-error:Segmentation-fault
|   |-- net-llc-llc_input.c:internal-compiler-error:Segmentation-fault
|   |-- net-llc-llc_output.c:internal-compiler-error:Segmentation-fault
|   |-- net-netrom-nr_dev.c:internal-compiler-error:Segmentation-fault
|   |-- net-netrom-nr_in.c:internal-compiler-error:Segmentation-fault
|   |-- net-netrom-nr_out.c:internal-compiler-error:Segmentation-fault
|   |-- net-netrom-nr_route.c:internal-compiler-error:Segmentation-fault
|   |-- net-netrom-nr_subr.c:internal-compiler-error:Segmentation-fault
|   |-- net-netrom-nr_timer.c:internal-compiler-error:Segmentation-fault
|   |-- net-rxrpc-call_accept.c:internal-compiler-error:Segmentation-fault
|   |-- net-rxrpc-call_event.c:internal-compiler-error:Segmentation-fault
|   |-- net-rxrpc-call_object.c:internal-compiler-error:Segmentation-fault
|   |-- net-rxrpc-conn_client.c:internal-compiler-error:Segmentation-fault
|   |-- net-rxrpc-conn_event.c:internal-compiler-error:Segmentation-fault
|   |-- net-rxrpc-conn_object.c:internal-compiler-error:Segmentation-fault
|   |-- net-rxrpc-conn_service.c:internal-compiler-error:Segmentation-fault
|   |-- net-rxrpc-input.c:internal-compiler-error:Segmentation-fault
|   |-- net-rxrpc-insecure.c:internal-compiler-error:Segmentation-fault
|   |-- net-rxrpc-key.c:internal-compiler-error:Segmentation-fault
|   |-- net-rxrpc-local_event.c:internal-compiler-error:Segmentation-fault
|   |-- net-rxrpc-local_object.c:internal-compiler-error:Segmentation-fault
|   |-- net-rxrpc-output.c:internal-compiler-error:Segmentation-fault
|   |-- net-rxrpc-peer_event.c:internal-compiler-error:Segmentation-fault
|   |-- net-rxrpc-peer_object.c:internal-compiler-error:Segmentation-fault
|   |-- net-rxrpc-recvmsg.c:internal-compiler-error:Segmentation-fault
|   |-- net-rxrpc-rtt.c:internal-compiler-error:Segmentation-fault
|   |-- net-rxrpc-sendmsg.c:internal-compiler-error:Segmentation-fault
|   |-- net-rxrpc-server_key.c:internal-compiler-error:Segmentation-fault
|   |-- net-rxrpc-skbuff.c:internal-compiler-error:Segmentation-fault
|   |-- net-rxrpc-utils.c:internal-compiler-error:Segmentation-fault
|   |-- net-sched-sch_fifo.c:internal-compiler-error:Segmentation-fault
|   |-- net-sched-sch_frag.c:internal-compiler-error:Segmentation-fault
|   |-- net-sctp-associola.c:internal-compiler-error:Segmentation-fault
|   |-- net-sctp-auth.c:internal-compiler-error:Segmentation-fault
|   |-- net-sctp-bind_addr.c:internal-compiler-error:Segmentation-fault
|   |-- net-sctp-chunk.c:internal-compiler-error:Segmentation-fault
|   |-- net-sctp-endpointola.c:internal-compiler-error:Segmentation-fault
|   |-- net-sctp-input.c:internal-compiler-error:Segmentation-fault
|   |-- net-sctp-inqueue.c:internal-compiler-error:Segmentation-fault
|   |-- net-sctp-output.c:internal-compiler-error:Segmentation-fault
|   |-- net-sctp-outqueue.c:internal-compiler-error:Segmentation-fault
|   |-- net-sctp-sm_make_chunk.c:internal-compiler-error:Segmentation-fault
|   |-- net-sctp-sm_sideeffect.c:internal-compiler-error:Segmentation-fault
|   |-- net-sctp-sm_statefuns.c:internal-compiler-error:Segmentation-fault
|   |-- net-sctp-socket.c:internal-compiler-error:Segmentation-fault
|   |-- net-sctp-stream.c:internal-compiler-error:Segmentation-fault
|   |-- net-sctp-stream_interleave.c:internal-compiler-error:Segmentation-fault
|   |-- net-sctp-stream_sched.c:internal-compiler-error:Segmentation-fault
|   |-- net-sctp-stream_sched_prio.c:internal-compiler-error:Segmentation-fault
|   |-- net-sctp-stream_sched_rr.c:internal-compiler-error:Segmentation-fault
|   |-- net-sctp-transport.c:internal-compiler-error:Segmentation-fault
|   |-- net-sctp-tsnmap.c:internal-compiler-error:Segmentation-fault
|   |-- net-sctp-ulpevent.c:internal-compiler-error:Segmentation-fault
|   |-- net-sctp-ulpqueue.c:internal-compiler-error:Segmentation-fault
|   |-- net-stp.c:internal-compiler-error:Segmentation-fault
|   |-- net-unix-scm.c:internal-compiler-error:Segmentation-fault
|   |-- net-vmw_vsock-af_vsock_tap.c:internal-compiler-error:Segmentation-fault
|   |-- net-vmw_vsock-virtio_transport_common.c:internal-compiler-error:Segmentation-fault
|   |-- net-vmw_vsock-vsock_addr.c:internal-compiler-error:Segmentation-fault
|   |-- net-xfrm-xfrm_algo.c:internal-compiler-error:Segmentation-fault
|   |-- net-xfrm-xfrm_hash.c:internal-compiler-error:Segmentation-fault
|   |-- net-xfrm-xfrm_ipcomp.c:internal-compiler-error:Segmentation-fault
|   |-- net-xfrm-xfrm_output.c:internal-compiler-error:Segmentation-fault
|   |-- net-xfrm-xfrm_replay.c:internal-compiler-error:Segmentation-fault
|   |-- security-keys-request_key.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-control.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-device.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-init.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-memalloc.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-pcm_lib.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-pcm_memory.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-pcm_misc.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-pcm_native.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-seq-seq_fifo.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-seq-seq_lock.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-seq-seq_memory.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-seq-seq_midi_event.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-seq-seq_ports.c:internal-compiler-error:Segmentation-fault
|   |-- sound-core-seq-seq_queue.c:internal-compiler-error:Segmentation-fault
|   `-- sound-core-seq-seq_timer.c:internal-compiler-error:Segmentation-fault
|-- riscv-randconfig-s032-20220406
|   |-- kernel-module-strict_rwx.c:internal-compiler-error:Segmentation-fault
|   `-- kernel-module-sysfs.c:internal-compiler-error:Segmentation-fault
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
|-- s390-buildonly-randconfig-r004-20220406
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
|-- s390-randconfig-r006-20220407
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
|-- s390-randconfig-r044-20220406
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- sh-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- include-uapi-linux-byteorder-little_endian.h:warning:cast-from-pointer-to-integer-of-different-size
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sh-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- include-uapi-linux-byteorder-little_endian.h:warning:cast-from-pointer-to-integer-of-different-size
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sh-j2_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sh-randconfig-r002-20220406
|   |-- arch-sh-lib-mcount.S:undefined-reference-to-dump_stack
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sparc-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- include-uapi-linux-byteorder-big_endian.h:warning:passing-argument-of-__fswab64-makes-integer-from-pointer-without-a-cast
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
|   |-- include-uapi-linux-byteorder-big_endian.h:warning:passing-argument-of-__fswab64-makes-integer-from-pointer-without-a-cast
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
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- um-x86_64_defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-allnoconfig
|   `-- kernel-sched-sched.h:linux-static_key.h-is-included-more-than-once.
|-- x86_64-allyesconfig
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
|   |-- include-uapi-linux-byteorder-big_endian.h:warning:passing-argument-of-__fswab64-makes-integer-from-pointer-without-a-cast
|   |-- include-uapi-linux-swab.h:warning:cast-from-pointer-to-integer-of-different-size
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- xtensa-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_setup_stream_attribute
|   |-- include-uapi-linux-byteorder-big_endian.h:warning:passing-argument-of-__fswab64-makes-integer-from-pointer-without-a-cast
|   |-- include-uapi-linux-swab.h:warning:cast-from-pointer-to-integer-of-different-size
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- xtensa-nommu_kc705_defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- xtensa-randconfig-p001-20220406
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
`-- xtensa-randconfig-r032-20220407
    |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
    |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
    |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
    `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop

clang_recent_errors
|-- arm-mainstone_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- arm-multi_v5_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- arm-randconfig-c002-20220406
|   |-- drivers-clk-imx-clk-pll14xx.c:warning:Value-stored-to-pll_div_ctl1-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- drivers-firmware-turris-mox-rwtm.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-ana
|   |-- drivers-gpu-drm-selftests-test-drm_buddy.c:warning:Value-stored-to-err-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- drivers-hid-hid-core.c:warning:Although-the-value-stored-to-field-is-used-in-the-enclosing-expression-the-value-is-never-actually-read-from-field-clang-analyzer-deadcode.DeadStores
|   |-- drivers-hwmon-da9055-hwmon.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous
|   |-- drivers-hwmon-nsa320-hwmon.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous
|   |-- drivers-memory-brcmstb_dpfe.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogou
|   |-- drivers-mtd-nand-ecc-mxic.c:warning:Branch-condition-evaluates-to-a-garbage-value-clang-analyzer-core.uninitialized.Branch
|   |-- drivers-mtd-nand-ecc-mxic.c:warning:Value-stored-to-dev-during-its-initialization-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- drivers-phy-broadcom-phy-brcm-usb.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-an
|   |-- drivers-usb-chipidea-core.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-
|   |-- drivers-usb-gadget-configfs.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogou
|   |-- drivers-usb-gadget-function-storage_common.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replac
|   |-- drivers-usb-gadget-udc-core.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogou
|   |-- drivers-usb-typec-altmodes-displayport.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-wi
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|   |-- sound-usb-6fire-chip.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-funct
|   `-- sound-usb-line6-driver.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-fun
|-- arm-randconfig-r023-20220406
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- arm64-allmodconfig
|   |-- drivers-acpi-arm64-agdi.c:warning:no-previous-prototype-for-function-acpi_agdi_init
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- hexagon-randconfig-r005-20220406
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
|-- hexagon-randconfig-r031-20220406
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- hexagon-randconfig-r041-20220406
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- hexagon-randconfig-r045-20220406
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
|-- i386-allmodconfig
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
|   |-- drivers-hid-hid-core.c:warning:Although-the-value-stored-to-field-is-used-in-the-enclosing-expression-the-value-is-never-actually-read-from-field-clang-analyzer-deadcode.DeadStores
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|   |-- lib-vsprintf.c:warning:Dereference-of-null-pointer-(loaded-from-variable-str-)-clang-analyzer-core.NullDereference
|   `-- lib-vsprintf.c:warning:Null-pointer-passed-as-1st-argument-to-memory-copy-function-clang-analyzer-unix.cstring.NullArg
|-- mips-cu1830-neo_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- mips-randconfig-c004-20220406
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
|-- riscv-randconfig-c006-20220406
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
|-- riscv-randconfig-r001-20220406
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- s390-buildonly-randconfig-r006-20220407
|   |-- arch-s390-include-asm-spinlock.h:error:unexpected-token-in-.rept-directive
|   |-- arch-s390-include-asm-spinlock.h:error:unknown-directive
|   |-- arch-s390-include-asm-spinlock.h:error:unmatched-.endr-directive
|   |-- arch-s390-lib-spinlock.c:error:unexpected-token-in-.rept-directive
|   |-- arch-s390-lib-spinlock.c:error:unknown-directive
|   |-- arch-s390-lib-spinlock.c:error:unmatched-.endr-directive
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
|-- s390-randconfig-c005-20220406
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
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- s390-randconfig-r034-20220406
|   |-- arch-s390-include-asm-spinlock.h:error:unexpected-token-in-.rept-directive
|   |-- arch-s390-include-asm-spinlock.h:error:unknown-directive
|   |-- arch-s390-include-asm-spinlock.h:error:unmatched-.endr-directive
|   |-- arch-s390-lib-spinlock.c:error:unexpected-token-in-.rept-directive
|   |-- arch-s390-lib-spinlock.c:error:unknown-directive
|   |-- arch-s390-lib-spinlock.c:error:unmatched-.endr-directive
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
    |-- drivers-hid-hid-core.c:warning:Although-the-value-stored-to-field-is-used-in-the-enclosing-expression-the-value-is-never-actually-read-from-field-clang-analyzer-deadcode.DeadStores
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

elapsed time: 721m

configs tested: 121
configs skipped: 5

gcc tested configs:
arm                                 defconfig
arm                              allmodconfig
arm                              allyesconfig
arm64                            allyesconfig
arm64                               defconfig
um                             i386_defconfig
um                           x86_64_defconfig
mips                             allyesconfig
mips                             allmodconfig
riscv                            allyesconfig
riscv                            allmodconfig
m68k                             allyesconfig
s390                             allmodconfig
powerpc                          allmodconfig
powerpc                          allyesconfig
m68k                             allmodconfig
s390                             allyesconfig
sh                               allmodconfig
i386                          randconfig-c001
arc                              allyesconfig
alpha                            allyesconfig
nios2                            allyesconfig
mips                           ci20_defconfig
powerpc                        warp_defconfig
arm                             rpc_defconfig
powerpc                 linkstation_defconfig
arc                        nsim_700_defconfig
arc                    vdk_hs38_smp_defconfig
sh                     sh7710voipgw_defconfig
arc                              alldefconfig
m68k                          sun3x_defconfig
sparc                       sparc32_defconfig
sh                         ap325rxa_defconfig
powerpc                   currituck_defconfig
sh                               j2_defconfig
sh                        sh7763rdp_defconfig
powerpc                       eiger_defconfig
mips                      maltasmvp_defconfig
powerpc                     taishan_defconfig
powerpc                     tqm8541_defconfig
sh                          urquell_defconfig
arm                        realview_defconfig
xtensa                  nommu_kc705_defconfig
m68k                       m5475evb_defconfig
arc                 nsimosci_hs_smp_defconfig
x86_64                        randconfig-c001
arm                  randconfig-c002-20220406
ia64                                defconfig
ia64                             allmodconfig
ia64                             allyesconfig
m68k                                defconfig
alpha                               defconfig
csky                                defconfig
h8300                            allyesconfig
arc                                 defconfig
xtensa                           allyesconfig
parisc                              defconfig
parisc64                            defconfig
parisc                           allyesconfig
s390                                defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
i386                                defconfig
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
nios2                               defconfig
powerpc                           allnoconfig
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                        randconfig-a011
x86_64                        randconfig-a015
x86_64                        randconfig-a013
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
x86_64                        randconfig-a004
x86_64                        randconfig-a002
x86_64                        randconfig-a006
riscv                randconfig-r042-20220406
arc                  randconfig-r043-20220406
s390                 randconfig-r044-20220406
riscv                    nommu_k210_defconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                          rv32_defconfig
riscv                               defconfig
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                                  kexec
x86_64                          rhel-8.3-func
x86_64                               rhel-8.3
x86_64                         rhel-8.3-kunit

clang tested configs:
powerpc              randconfig-c003-20220406
mips                 randconfig-c004-20220406
s390                 randconfig-c005-20220406
x86_64                        randconfig-c007
riscv                randconfig-c006-20220406
arm                  randconfig-c002-20220406
i386                          randconfig-c001
arm                       mainstone_defconfig
mips                     cu1830-neo_defconfig
arm                        multi_v5_defconfig
powerpc                 mpc836x_rdk_defconfig
powerpc                     tqm5200_defconfig
powerpc                    gamecube_defconfig
mips                           ip28_defconfig
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
hexagon              randconfig-r041-20220406
hexagon              randconfig-r045-20220406

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
