Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E2B569DEC
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 10:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbiGGIpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 04:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbiGGIpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 04:45:09 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563D813F9F;
        Thu,  7 Jul 2022 01:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657183508; x=1688719508;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=edbKoKalbvq90CBmxogPesuIiDjl8rwJ49B+zZvetjQ=;
  b=BfVKisWKCdx8CvBHxqsYg7j9cXv26yoQXE72HrhvrsHZACMcDf+Q4QeE
   iezKOt76usGXV+kbwaKO7ucB7IaYA4gBUybR0oLB4xyC1Vm4hlMy3Mfqh
   9orF/TMUfYsnaA4siDN3OfNN2ZHi8li2Tg62mdzzqPrFaDG0JJbV+DRPP
   iwpbPp2cvvpvUZ62IKMOCHbcsc96XaEccZnOxR3WRawWvB7mbC3jKctJN
   8CAuCUDBdHrDFmaFdIMnnGGbzhA6JCPGgQiHYVbqMyi9DeZgOTiWpgxom
   oJhCT3UL+2okh6qNBEUcmQZZmIof0uguLdB3ImckLr4T46d5mInnCBOBg
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="345659129"
X-IronPort-AV: E=Sophos;i="5.92,252,1650956400"; 
   d="scan'208";a="345659129"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 01:45:06 -0700
X-IronPort-AV: E=Sophos;i="5.92,252,1650956400"; 
   d="scan'208";a="651047273"
Received: from rongch2-mobl.ccr.corp.intel.com (HELO [10.255.31.6]) ([10.255.31.6])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 01:44:45 -0700
Subject: Re: [linux-next:master] BUILD REGRESSION
 088b9c375534d905a4d337c78db3b3bfbb52c4a0
To:     Greg KH <gregkh@linuxfoundation.org>,
        kernel test robot <lkp@intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        virtualization@lists.linux-foundation.org,
        usbb2k-api-dev@nongnu.org, tipc-discussion@lists.sourceforge.net,
        target-devel@vger.kernel.org, sound-open-firmware@alsa-project.org,
        samba-technical@lists.samba.org, rds-devel@oss.oracle.com,
        patches@opensource.cirrus.com, osmocom-net-gprs@lists.osmocom.org,
        openipmi-developer@lists.sourceforge.net, nvdimm@lists.linux.dev,
        ntb@lists.linux.dev, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, mjpeg-users@lists.sourceforge.net,
        megaraidlinux.pdl@broadcom.com, linuxppc-dev@lists.ozlabs.org,
        linux1394-devel@lists.sourceforge.net, linux-x25@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-unionfs@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-staging@lists.linux.dev, linux-serial@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-perf-users@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-parport@lists.infradead.org,
        linux-parisc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-nfc@lists.01.org, linux-mtd@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-mm@kvack.org,
        linux-mediatek@lists.infradead.org, linux-media@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-input@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-fpga@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-cxl@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        legousb-devel@lists.sourceforge.net, kvm@vger.kernel.org,
        keyrings@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
        iommu@lists.linux.dev, iommu@lists.linux-foundation.org,
        intel-wired-lan@lists.osuosl.org, greybus-dev@lists.linaro.org,
        dri-devel@lists.freedesktop.org, dm-devel@redhat.com,
        devicetree@vger.kernel.org, dev@openvswitch.org,
        dccp@vger.kernel.org, damon@lists.linux.dev,
        coreteam@netfilter.org, cgroups@vger.kernel.org,
        ceph-devel@vger.kernel.org, ath11k@lists.infradead.org,
        apparmor@lists.ubuntu.com, amd-gfx@lists.freedesktop.org,
        alsa-devel@alsa-project.org,
        accessrunner-general@lists.sourceforge.net
References: <62c683a2.g1VSVt6BrQC6ZzOz%lkp@intel.com>
 <YsaUgfPbOg7WuBuB@kroah.com>
From:   "Chen, Rong A" <rong.a.chen@intel.com>
Message-ID: <c86816fd-aaba-01a9-5def-44868f0a46c9@intel.com>
Date:   Thu, 7 Jul 2022 16:44:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YsaUgfPbOg7WuBuB@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/7/2022 4:08 PM, Greg KH wrote:
> On Thu, Jul 07, 2022 at 02:56:34PM +0800, kernel test robot wrote:
>> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
>> branch HEAD: 088b9c375534d905a4d337c78db3b3bfbb52c4a0  Add linux-next specific files for 20220706
>>
>> Error/Warning reports:
>>
>> https://lore.kernel.org/linux-doc/202207070644.x48XOOvs-lkp@intel.com
>>
>> Error/Warning: (recently discovered and may have been fixed)
>>
>> Documentation/arm/google/chromebook-boot-flow.rst: WARNING: document isn't included in any toctree
>> arm-linux-gnueabi-ld: dc_dmub_srv.c:(.text+0x1108): undefined reference to `__aeabi_ddiv'
>> arm-linux-gnueabi-ld: dc_dmub_srv.c:(.text+0x1124): undefined reference to `__aeabi_ui2d'
>> arm-linux-gnueabi-ld: dc_dmub_srv.c:(.text+0x1164): undefined reference to `__aeabi_dmul'
>> arm-linux-gnueabi-ld: dc_dmub_srv.c:(.text+0x1170): undefined reference to `__aeabi_dadd'
>> arm-linux-gnueabi-ld: dc_dmub_srv.c:(.text+0x1180): undefined reference to `__aeabi_dsub'
>> arm-linux-gnueabi-ld: dc_dmub_srv.c:(.text+0x1190): undefined reference to `__aeabi_d2uiz'
>> arm-linux-gnueabi-ld: dc_dmub_srv.c:(.text+0x162c): undefined reference to `__aeabi_d2iz'
>> arm-linux-gnueabi-ld: dc_dmub_srv.c:(.text+0x16b0): undefined reference to `__aeabi_i2d'
>> dc_dmub_srv.c:(.text+0x10f8): undefined reference to `__aeabi_ui2d'
>> dc_dmub_srv.c:(.text+0x464): undefined reference to `__floatunsidf'
>> dc_dmub_srv.c:(.text.dc_dmub_setup_subvp_dmub_command+0x33c): undefined reference to `__floatunsidf'
>> drivers/pci/endpoint/functions/pci-epf-vntb.c:975:5: warning: no previous prototype for 'pci_read' [-Wmissing-prototypes]
>> drivers/pci/endpoint/functions/pci-epf-vntb.c:984:5: warning: no previous prototype for 'pci_write' [-Wmissing-prototypes]
>> drivers/vfio/vfio_iommu_type1.c:2141:35: warning: cast to smaller integer type 'enum iommu_cap' from 'void *' [-Wvoid-pointer-to-enum-cast]
>> mips-linux-ld: dc_dmub_srv.c:(.text.dc_dmub_setup_subvp_dmub_command+0x34c): undefined reference to `__floatunsidf'
>> mips-linux-ld: dc_dmub_srv.c:(.text.dc_dmub_setup_subvp_dmub_command+0x378): undefined reference to `__divdf3'
>> mips-linux-ld: dc_dmub_srv.c:(.text.dc_dmub_setup_subvp_dmub_command+0x38c): undefined reference to `__muldf3'
>> mips-linux-ld: dc_dmub_srv.c:(.text.dc_dmub_setup_subvp_dmub_command+0x3a0): undefined reference to `__adddf3'
>> mips-linux-ld: dc_dmub_srv.c:(.text.dc_dmub_setup_subvp_dmub_command+0x3b4): undefined reference to `__subdf3'
>> mips-linux-ld: dc_dmub_srv.c:(.text.dc_dmub_setup_subvp_dmub_command+0x3d4): undefined reference to `__fixunsdfsi'
>> mips-linux-ld: dc_dmub_srv.c:(.text.dc_dmub_setup_subvp_dmub_command+0x750): undefined reference to `__fixdfsi'
>> mips-linux-ld: dc_dmub_srv.c:(.text.dc_dmub_setup_subvp_dmub_command+0x7c0): undefined reference to `__floatsidf'
>> powerpc-linux-ld: drivers/pci/endpoint/functions/pci-epf-vntb.c:174: undefined reference to `ntb_link_event'
>> xtensa-linux-ld: dc_dmub_srv.c:(.text+0x468): undefined reference to `__divdf3'
>> xtensa-linux-ld: dc_dmub_srv.c:(.text+0x46c): undefined reference to `__muldf3'
>> xtensa-linux-ld: dc_dmub_srv.c:(.text+0x470): undefined reference to `__adddf3'
>> xtensa-linux-ld: dc_dmub_srv.c:(.text+0x474): undefined reference to `__subdf3'
>> xtensa-linux-ld: dc_dmub_srv.c:(.text+0x478): undefined reference to `__fixunsdfsi'
>> xtensa-linux-ld: dc_dmub_srv.c:(.text+0x47c): undefined reference to `__fixdfsi'
>> xtensa-linux-ld: dc_dmub_srv.c:(.text+0x480): undefined reference to `__floatsidf'
>> xtensa-linux-ld: dc_dmub_srv.c:(.text+0x60c): undefined reference to `__floatunsidf'
>>
>> Unverified Error/Warning (likely false positive, please contact us if interested):
>>
>> arch/x86/events/core.c:2114 init_hw_perf_events() warn: missing error code 'err'
>> drivers/android/binder.c:1481:19-23: ERROR: from is NULL but dereferenced.
>> drivers/android/binder.c:2920:29-33: ERROR: target_thread is NULL but dereferenced.
>> drivers/android/binder.c:353:25-35: ERROR: node -> proc is NULL but dereferenced.
>> drivers/android/binder.c:4888:16-20: ERROR: t is NULL but dereferenced.
>> drivers/base/regmap/regmap.c:1996:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9637
>> drivers/char/random.c:869:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9637
>> drivers/firmware/arm_scmi/clock.c:394:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9637
>> drivers/firmware/arm_scmi/powercap.c:376:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9637
>> drivers/gpu/drm/amd/amdgpu/../pm/powerplay/hwmgr/vega10_powertune.c:1214:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9637
>> drivers/gpu/drm/amd/display/dc/os_types.h: drm/drm_print.h is included more than once.
>> drivers/gpu/drm/bridge/ite-it66121.c:1398:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9637
>> drivers/greybus/operation.c:617:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9637
> 
> <snip>
> 
> When the compiler crashes, why are you blaming all of these different
> mailing lists?  Perhaps you need to fix your compiler :)
> 
> thanks,
> 
> greg k-h
> 

Hi Greg,

Sorry for the inconvience, we'll fix it ASAP.

Best Regards,
Rong Chen
