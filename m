Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB545BA648
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 07:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiIPFNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 01:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiIPFNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 01:13:41 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5D37755D;
        Thu, 15 Sep 2022 22:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663305220; x=1694841220;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=05dIEm6EDE/FGH5eEhbfF7ohwoCb4JD1+C6lIYEl0D4=;
  b=PWCm1SGYy2kOr7Q43BM6Drkt7hmk71/QxRDkCIwrPXnnmvPc6EkIyF5Y
   XaQFgaYzLKhgoXsCXN7jNXJvLWIMlgdN5WJoJGVnooVmYpW7jxUFdXIPm
   adCtaiIozDJq/ffTrGQFqhvf74ylQwbnUqAJTzWYpQJyjlpdiLykKXXmk
   v7h1uW/727/63UnXit7MO6SiwA0iwN0QK6M83G+GCpV7vzt4mhLfhiVRF
   cGe00thH2ulqY1ccLW60uoQMvACrqH5aweyN46VUrhgPPSgF3expz2AxG
   YJRTEAT+WbhbzqDbd08sJdIAXwNH+I7tYUUtuSsVwa2FFEx80C7HMm0+d
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="281942393"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="281942393"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 22:13:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="706628953"
Received: from lkp-server02.sh.intel.com (HELO 41300c7200ea) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Sep 2022 22:13:36 -0700
Received: from kbuild by 41300c7200ea with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oZ3fT-0001So-22;
        Fri, 16 Sep 2022 05:13:35 +0000
Date:   Fri, 16 Sep 2022 13:13:01 +0800
From:   kernel test robot <lkp@intel.com>
To:     cgel.zte@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hayeswang@realtek.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        aaron.ma@canonical.com, jflf_kernel@gmx.com, dober6023@gmail.com,
        svenva@chromium.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] r8152: Replace conditional statement with
 min() function
Message-ID: <202209161313.2l3pzgCV-lkp@intel.com>
References: <20220914162326.23880-1-cui.jinpeng2@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914162326.23880-1-cui.jinpeng2@zte.com.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on next-20220914]

url:    https://github.com/intel-lab-lkp/linux/commits/cgel-zte-gmail-com/r8152-Replace-conditional-statement-with-min-function/20220915-002537
base:    f117c01187301a087412bd6697fcf5463cb427d8
config: x86_64-randconfig-a003 (https://download.01.org/0day-ci/archive/20220916/202209161313.2l3pzgCV-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/9b5f2fbac752d4608affde065cf64573bdd09564
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review cgel-zte-gmail-com/r8152-Replace-conditional-statement-with-min-function/20220915-002537
        git checkout 9b5f2fbac752d4608affde065cf64573bdd09564
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/usb/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/usb/r8152.c:4832:10: warning: comparison of distinct pointer types ('typeof (2048) *' (aka 'int *') and 'typeof (len) *' (aka 'unsigned int *')) [-Wcompare-distinct-pointer-types]
                   size = min(2048, len);
                          ^~~~~~~~~~~~~~
   include/linux/minmax.h:45:19: note: expanded from macro 'min'
   #define min(x, y)       __careful_cmp(x, y, <)
                           ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:36:24: note: expanded from macro '__careful_cmp'
           __builtin_choose_expr(__safe_cmp(x, y), \
                                 ^~~~~~~~~~~~~~~~
   include/linux/minmax.h:26:4: note: expanded from macro '__safe_cmp'
                   (__typecheck(x, y) && __no_side_effects(x, y))
                    ^~~~~~~~~~~~~~~~~
   include/linux/minmax.h:20:28: note: expanded from macro '__typecheck'
           (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
                      ~~~~~~~~~~~~~~ ^  ~~~~~~~~~~~~~~
   1 warning generated.


vim +4832 drivers/net/usb/r8152.c

  4808	
  4809	static void rtl_ram_code_speed_up(struct r8152 *tp, struct fw_phy_speed_up *phy, bool wait)
  4810	{
  4811		u32 len;
  4812		u8 *data;
  4813	
  4814		rtl_reset_ocp_base(tp);
  4815	
  4816		if (sram_read(tp, SRAM_GPHY_FW_VER) >= __le16_to_cpu(phy->version)) {
  4817			dev_dbg(&tp->intf->dev, "PHY firmware has been the newest\n");
  4818			return;
  4819		}
  4820	
  4821		len = __le32_to_cpu(phy->blk_hdr.length);
  4822		len -= __le16_to_cpu(phy->fw_offset);
  4823		data = (u8 *)phy + __le16_to_cpu(phy->fw_offset);
  4824	
  4825		if (rtl_phy_patch_request(tp, true, wait))
  4826			return;
  4827	
  4828		while (len) {
  4829			u32 ocp_data, size;
  4830			int i;
  4831	
> 4832			size = min(2048, len);
  4833	
  4834			ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_GPHY_CTRL);
  4835			ocp_data |= GPHY_PATCH_DONE | BACKUP_RESTRORE;
  4836			ocp_write_word(tp, MCU_TYPE_USB, USB_GPHY_CTRL, ocp_data);
  4837	
  4838			generic_ocp_write(tp, __le16_to_cpu(phy->fw_reg), 0xff, size, data, MCU_TYPE_USB);
  4839	
  4840			data += size;
  4841			len -= size;
  4842	
  4843			ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_POL_GPIO_CTRL);
  4844			ocp_data |= POL_GPHY_PATCH;
  4845			ocp_write_word(tp, MCU_TYPE_PLA, PLA_POL_GPIO_CTRL, ocp_data);
  4846	
  4847			for (i = 0; i < 1000; i++) {
  4848				if (!(ocp_read_word(tp, MCU_TYPE_PLA, PLA_POL_GPIO_CTRL) & POL_GPHY_PATCH))
  4849					break;
  4850			}
  4851	
  4852			if (i == 1000) {
  4853				dev_err(&tp->intf->dev, "ram code speedup mode timeout\n");
  4854				break;
  4855			}
  4856		}
  4857	
  4858		rtl_reset_ocp_base(tp);
  4859	
  4860		rtl_phy_patch_request(tp, false, wait);
  4861	
  4862		if (sram_read(tp, SRAM_GPHY_FW_VER) == __le16_to_cpu(phy->version))
  4863			dev_dbg(&tp->intf->dev, "successfully applied %s\n", phy->info);
  4864		else
  4865			dev_err(&tp->intf->dev, "ram code speedup mode fail\n");
  4866	}
  4867	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
