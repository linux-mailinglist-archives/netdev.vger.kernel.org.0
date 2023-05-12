Return-Path: <netdev+bounces-2253-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37B05700E75
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 20:16:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD9501C21291
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 18:16:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4D671DDEE;
	Fri, 12 May 2023 18:16:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90ADF200AE
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 18:16:02 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C86F1BD1;
	Fri, 12 May 2023 11:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683915358; x=1715451358;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Tn1mWva/Y5I20y2VeB+dMbNqm0pVSHgbGLyT2dlPp9U=;
  b=O029KawDsD8ZlsQXo2SmaxZCtD3oXkagD84461WAPj1ipsT76+5vsCrW
   PNJ2nhLB9VkIaZ/e5oT3SkTwEHt3eXvwrH5K4CX0NS/1q3ZQcED0keJnJ
   6G+2PTmL1dZQxI5EmpAyux6n/QWjRax+a5bqbOJV03I94Y/gHU00DCqeA
   3WgISOYlFFI9WmvperGeApCZ5raK83xc7D0LGiUqX4RAtEhb+SUUT6T0M
   x6pOCsN0zYvddbZEDeCQo60NQ7G51375VyBZzrmPRr9YVAY/d4h5Nc4lv
   Xa3I8kIBVlRi+f/xoNNJQ5YlJMMw8NtkwGAR3EUwgCfejQoSop58mOPT9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="353990620"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="353990620"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 11:15:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="844519043"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="844519043"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 12 May 2023 11:15:53 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pxXJ2-00051g-24;
	Fri, 12 May 2023 18:15:52 +0000
Date: Sat, 13 May 2023 02:15:46 +0800
From: kernel test robot <lkp@intel.com>
To: Rohit Agarwal <quic_rohiagar@quicinc.com>, agross@kernel.org,
	andersson@kernel.org, konrad.dybcio@linaro.org,
	linus.walleij@linaro.org, robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, richardcochran@gmail.com,
	manivannan.sadhasivam@linaro.org, andy.shevchenko@gmail.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, Rohit Agarwal <quic_rohiagar@quicinc.com>
Subject: Re: [PATCH 2/2] pinctrl: qcom: Refactor generic qcom pinctrl driver
Message-ID: <202305130211.tEiFmM2W-lkp@intel.com>
References: <1683892553-19882-3-git-send-email-quic_rohiagar@quicinc.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1683892553-19882-3-git-send-email-quic_rohiagar@quicinc.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Rohit,

kernel test robot noticed the following build errors:

[auto build test ERROR on linusw-pinctrl/devel]
[also build test ERROR on linusw-pinctrl/for-next linus/master v6.4-rc1 next-20230512]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Rohit-Agarwal/pinctrl-qcom-Remove-the-msm_function-struct/20230512-195910
base:   https://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git devel
patch link:    https://lore.kernel.org/r/1683892553-19882-3-git-send-email-quic_rohiagar%40quicinc.com
patch subject: [PATCH 2/2] pinctrl: qcom: Refactor generic qcom pinctrl driver
config: arm64-buildonly-randconfig-r006-20230511 (https://download.01.org/0day-ci/archive/20230513/202305130211.tEiFmM2W-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project b0fb98227c90adf2536c9ad644a74d5e92961111)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm64 cross compiling tool for clang build
        # apt-get install binutils-aarch64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/1894575a5b0f681fb8697a05ac2aa68ef97e48e8
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Rohit-Agarwal/pinctrl-qcom-Remove-the-msm_function-struct/20230512-195910
        git checkout 1894575a5b0f681fb8697a05ac2aa68ef97e48e8
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/pinctrl/qcom/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305130211.tEiFmM2W-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/pinctrl/qcom/pinctrl-sm7150.c:969:50: error: array has incomplete element type 'const struct msm_function'
   static const struct msm_function sm7150_functions[] = {
                                                    ^
   drivers/pinctrl/qcom/pinctrl-sm7150.c:969:21: note: forward declaration of 'struct msm_function'
   static const struct msm_function sm7150_functions[] = {
                       ^
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:1089:8: error: field designator 'name' does not refer to any field in type 'const struct msm_pingroup'
           [0] = PINGROUP(0, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:37:4: note: expanded from macro 'PINGROUP'
                   .name = "gpio" #id,                     \
                   ~^~~~~~~~~~~~~~~~~
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:1089:8: error: field designator 'pins' does not refer to any field in type 'const struct msm_pingroup'
           [0] = PINGROUP(0, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:38:4: note: expanded from macro 'PINGROUP'
                   .pins = gpio##id##_pins,                \
                   ~^~~~~~~~~~~~~~~~~~~~~~
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:1089:8: error: field designator 'npins' does not refer to any field in type 'const struct msm_pingroup'
           [0] = PINGROUP(0, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:39:4: note: expanded from macro 'PINGROUP'
                   .npins = ARRAY_SIZE(gpio##id##_pins),   \
                   ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1090:8: error: field designator 'name' does not refer to any field in type 'const struct msm_pingroup'
           [1] = PINGROUP(1, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:37:4: note: expanded from macro 'PINGROUP'
                   .name = "gpio" #id,                     \
                   ~^~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1090:8: error: field designator 'pins' does not refer to any field in type 'const struct msm_pingroup'
           [1] = PINGROUP(1, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:38:4: note: expanded from macro 'PINGROUP'
                   .pins = gpio##id##_pins,                \
                   ~^~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1090:8: error: field designator 'npins' does not refer to any field in type 'const struct msm_pingroup'
           [1] = PINGROUP(1, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:39:4: note: expanded from macro 'PINGROUP'
                   .npins = ARRAY_SIZE(gpio##id##_pins),   \
                   ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1091:8: error: field designator 'name' does not refer to any field in type 'const struct msm_pingroup'
           [2] = PINGROUP(2, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:37:4: note: expanded from macro 'PINGROUP'
                   .name = "gpio" #id,                     \
                   ~^~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1091:8: error: field designator 'pins' does not refer to any field in type 'const struct msm_pingroup'
           [2] = PINGROUP(2, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:38:4: note: expanded from macro 'PINGROUP'
                   .pins = gpio##id##_pins,                \
                   ~^~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1091:8: error: field designator 'npins' does not refer to any field in type 'const struct msm_pingroup'
           [2] = PINGROUP(2, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:39:4: note: expanded from macro 'PINGROUP'
                   .npins = ARRAY_SIZE(gpio##id##_pins),   \
                   ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1092:8: error: field designator 'name' does not refer to any field in type 'const struct msm_pingroup'
           [3] = PINGROUP(3, SOUTH, qup01, dbg_out, _, _, _, _, _, _, _),
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:37:4: note: expanded from macro 'PINGROUP'
                   .name = "gpio" #id,                     \
                   ~^~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1092:8: error: field designator 'pins' does not refer to any field in type 'const struct msm_pingroup'
           [3] = PINGROUP(3, SOUTH, qup01, dbg_out, _, _, _, _, _, _, _),
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:38:4: note: expanded from macro 'PINGROUP'
                   .pins = gpio##id##_pins,                \
                   ~^~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1092:8: error: field designator 'npins' does not refer to any field in type 'const struct msm_pingroup'
           [3] = PINGROUP(3, SOUTH, qup01, dbg_out, _, _, _, _, _, _, _),
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:39:4: note: expanded from macro 'PINGROUP'
                   .npins = ARRAY_SIZE(gpio##id##_pins),   \
                   ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1093:8: error: field designator 'name' does not refer to any field in type 'const struct msm_pingroup'
           [4] = PINGROUP(4, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:37:4: note: expanded from macro 'PINGROUP'
                   .name = "gpio" #id,                     \
                   ~^~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1093:8: error: field designator 'pins' does not refer to any field in type 'const struct msm_pingroup'
           [4] = PINGROUP(4, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:38:4: note: expanded from macro 'PINGROUP'
                   .pins = gpio##id##_pins,                \
                   ~^~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1093:8: error: field designator 'npins' does not refer to any field in type 'const struct msm_pingroup'
           [4] = PINGROUP(4, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:39:4: note: expanded from macro 'PINGROUP'
                   .npins = ARRAY_SIZE(gpio##id##_pins),   \
                   ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1094:8: error: field designator 'name' does not refer to any field in type 'const struct msm_pingroup'
           [5] = PINGROUP(5, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:37:4: note: expanded from macro 'PINGROUP'
                   .name = "gpio" #id,                     \
                   ~^~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1094:8: error: field designator 'pins' does not refer to any field in type 'const struct msm_pingroup'
           [5] = PINGROUP(5, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:38:4: note: expanded from macro 'PINGROUP'
                   .pins = gpio##id##_pins,                \
                   ~^~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1094:8: error: field designator 'npins' does not refer to any field in type 'const struct msm_pingroup'
           [5] = PINGROUP(5, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:39:4: note: expanded from macro 'PINGROUP'
                   .npins = ARRAY_SIZE(gpio##id##_pins),   \
                   ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fatal error: too many errors emitted, stopping now [-ferror-limit=]
   20 errors generated.


vim +1089 drivers/pinctrl/qcom/pinctrl-sm7150.c

b915395c9e0436 Danila Tikhonov 2023-03-12  1081  
b915395c9e0436 Danila Tikhonov 2023-03-12  1082  /*
b915395c9e0436 Danila Tikhonov 2023-03-12  1083   * Every pin is maintained as a single group, and missing or non-existing pin
b915395c9e0436 Danila Tikhonov 2023-03-12  1084   * would be maintained as dummy group to synchronize pin group index with
b915395c9e0436 Danila Tikhonov 2023-03-12  1085   * pin descriptor registered with pinctrl core.
b915395c9e0436 Danila Tikhonov 2023-03-12  1086   * Clients would not be able to request these dummy pin groups.
b915395c9e0436 Danila Tikhonov 2023-03-12  1087   */
b915395c9e0436 Danila Tikhonov 2023-03-12  1088  static const struct msm_pingroup sm7150_groups[] = {
b915395c9e0436 Danila Tikhonov 2023-03-12 @1089  	[0] = PINGROUP(0, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1090  	[1] = PINGROUP(1, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1091  	[2] = PINGROUP(2, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1092  	[3] = PINGROUP(3, SOUTH, qup01, dbg_out, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1093  	[4] = PINGROUP(4, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1094  	[5] = PINGROUP(5, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1095  	[6] = PINGROUP(6, NORTH, qup11, _, phase_flag, ddr_pxi0, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1096  	[7] = PINGROUP(7, NORTH, qup11, ddr_bist, _, phase_flag, atest_tsens2, vsense_trigger, atest_usb1, ddr_pxi0, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1097  	[8] = PINGROUP(8, NORTH, qup11, gp_pdm1, ddr_bist, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1098  	[9] = PINGROUP(9, NORTH, qup11, ddr_bist, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1099  	[10] = PINGROUP(10, NORTH, mdp_vsync, ddr_bist, _, phase_flag, wlan2_adc1, atest_usb1, ddr_pxi2, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1100  	[11] = PINGROUP(11, NORTH, mdp_vsync, edp_lcd, _, phase_flag, wlan2_adc0, atest_usb1, ddr_pxi2, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1101  	[12] = PINGROUP(12, SOUTH, mdp_vsync, m_voc, qup01, _, phase_flag, ddr_pxi3, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1102  	[13] = PINGROUP(13, SOUTH, cam_mclk, pll_bypassnl, _, phase_flag, qdss, ddr_pxi3, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1103  	[14] = PINGROUP(14, SOUTH, cam_mclk, pll_reset, _, phase_flag, qdss, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1104  	[15] = PINGROUP(15, SOUTH, cam_mclk, _, phase_flag, qdss, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1105  	[16] = PINGROUP(16, SOUTH, cam_mclk, _, phase_flag, qdss, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1106  	[17] = PINGROUP(17, SOUTH, cci_i2c, _, phase_flag, qdss, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1107  	[18] = PINGROUP(18, SOUTH, cci_i2c, qdss, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1108  	[19] = PINGROUP(19, SOUTH, cci_i2c, qdss, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1109  	[20] = PINGROUP(20, SOUTH, cci_i2c, qdss, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1110  	[21] = PINGROUP(21, SOUTH, cci_timer0, gcc_gp2, _, qdss, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1111  	[22] = PINGROUP(22, SOUTH, cci_timer1, gcc_gp3, _, qdss, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1112  	[23] = PINGROUP(23, SOUTH, cci_timer2, qdss, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1113  	[24] = PINGROUP(24, SOUTH, cci_timer3, cci_async, _, phase_flag, qdss, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1114  	[25] = PINGROUP(25, SOUTH, cci_timer4, cci_async, _, phase_flag, qdss, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1115  	[26] = PINGROUP(26, SOUTH, cci_async, jitter_bist, _, phase_flag, qdss, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1116  	[27] = PINGROUP(27, SOUTH, cci_i2c, pll_bist, _, phase_flag, qdss, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1117  	[28] = PINGROUP(28, SOUTH, cci_i2c, agera_pll, _, phase_flag, qdss, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1118  	[29] = PINGROUP(29, NORTH, _, _, phase_flag, qdss, atest_tsens, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1119  	[30] = PINGROUP(30, SOUTH, _, phase_flag, qdss, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1120  	[31] = PINGROUP(31, WEST, _, qdss, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1121  	[32] = PINGROUP(32, NORTH, qdss_cti, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1122  	[33] = PINGROUP(33, NORTH, sd_write, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1123  	[34] = PINGROUP(34, SOUTH, qup02, qdss, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1124  	[35] = PINGROUP(35, SOUTH, qup02, _, phase_flag, qdss, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1125  	[36] = PINGROUP(36, SOUTH, _, phase_flag, qdss, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1126  	[37] = PINGROUP(37, SOUTH, qup01, gp_pdm0, _, phase_flag, qdss, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1127  	[38] = PINGROUP(38, SOUTH, qup03, _, phase_flag, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1128  	[39] = PINGROUP(39, SOUTH, qup03, _, phase_flag, _, wlan1_adc0, atest_usb1, ddr_pxi1, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1129  	[40] = PINGROUP(40, SOUTH, qup03, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1130  	[41] = PINGROUP(41, SOUTH, qup03, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1131  	[42] = PINGROUP(42, NORTH, qup12, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1132  	[43] = PINGROUP(43, NORTH, qup12, _, phase_flag, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1133  	[44] = PINGROUP(44, NORTH, qup12, _, phase_flag, qdss_cti, _, wlan1_adc1, atest_usb1, ddr_pxi1, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1134  	[45] = PINGROUP(45, NORTH, qup12, qdss_cti, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1135  	[46] = PINGROUP(46, NORTH, qup13, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1136  	[47] = PINGROUP(47, NORTH, qup13, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1137  	[48] = PINGROUP(48, WEST, gcc_gp1, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1138  	[49] = PINGROUP(49, WEST, pri_mi2s, qup00, wsa_clk, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1139  	[50] = PINGROUP(50, WEST, pri_mi2s_ws, qup00, wsa_data, gp_pdm1, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1140  	[51] = PINGROUP(51, WEST, pri_mi2s, qup00, atest_usb2, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1141  	[52] = PINGROUP(52, WEST, pri_mi2s, qup00, atest_usb2, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1142  	[53] = PINGROUP(53, WEST, ter_mi2s, qup04, qdss, atest_usb2, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1143  	[54] = PINGROUP(54, WEST, ter_mi2s, qup04, qdss, atest_usb2, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1144  	[55] = PINGROUP(55, WEST, ter_mi2s, qup04, qdss, atest_usb2, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1145  	[56] = PINGROUP(56, WEST, ter_mi2s, qup04, gcc_gp1, _, phase_flag, qdss, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1146  	[57] = PINGROUP(57, WEST, sec_mi2s, qup00, gp_pdm2, _, phase_flag, qdss, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1147  	[58] = PINGROUP(58, WEST, qua_mi2s, qup00, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1148  	[59] = PINGROUP(59, NORTH, qup10, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1149  	[60] = PINGROUP(60, NORTH, qup10, tsif1_error, _, phase_flag, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1150  	[61] = PINGROUP(61, NORTH, qup10, tsif1_sync, _, phase_flag, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1151  	[62] = PINGROUP(62, NORTH, qup10, tsif1_clk, tgu_ch3, _, phase_flag, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1152  	[63] = PINGROUP(63, NORTH, tsif1_en, mdp_vsync0, qup10, mdp_vsync1, mdp_vsync2, mdp_vsync3, tgu_ch0, qdss_cti, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1153  	[64] = PINGROUP(64, NORTH, tsif1_data, sdc4_cmd, qup10, tgu_ch1, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1154  	[65] = PINGROUP(65, NORTH, tsif2_error, sdc43, qup10, vfr_1, tgu_ch2, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1155  	[66] = PINGROUP(66, NORTH, tsif2_clk, sdc4_clk, pci_e, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1156  	[67] = PINGROUP(67, NORTH, tsif2_en, sdc42, pci_e, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1157  	[68] = PINGROUP(68, NORTH, tsif2_data, sdc41, pci_e, gp_pdm0, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1158  	[69] = PINGROUP(69, NORTH, tsif2_sync, sdc40, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1159  	[70] = PINGROUP(70, NORTH, _, _, mdp_vsync, ldo_en, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1160  	[71] = PINGROUP(71, NORTH, _, mdp_vsync, ldo_update, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1161  	[72] = PINGROUP(72, NORTH, prng_rosc, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1162  	[73] = PINGROUP(73, NORTH, _, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1163  	[74] = PINGROUP(74, WEST, _, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1164  	[75] = PINGROUP(75, WEST, uim2_data, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1165  	[76] = PINGROUP(76, WEST, uim2_clk, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1166  	[77] = PINGROUP(77, WEST, uim2_reset, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1167  	[78] = PINGROUP(78, WEST, uim2_present, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1168  	[79] = PINGROUP(79, WEST, uim1_data, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1169  	[80] = PINGROUP(80, WEST, uim1_clk, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1170  	[81] = PINGROUP(81, WEST, uim1_reset, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1171  	[82] = PINGROUP(82, WEST, uim1_present, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1172  	[83] = PINGROUP(83, WEST, _, nav_pps_in, nav_pps_out, gps_tx, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1173  	[84] = PINGROUP(84, WEST, _, nav_pps_in, nav_pps_out, gps_tx, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1174  	[85] = PINGROUP(85, WEST, uim_batt, edp_hot, aoss_cti, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1175  	[86] = PINGROUP(86, NORTH, qdss, atest_char, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1176  	[87] = PINGROUP(87, NORTH, adsp_ext, qdss, atest_char, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1177  	[88] = PINGROUP(88, NORTH, qdss, atest_char, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1178  	[89] = PINGROUP(89, NORTH, qdss, atest_char, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1179  	[90] = PINGROUP(90, NORTH, qdss, atest_char, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1180  	[91] = PINGROUP(91, NORTH, qdss, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1181  	[92] = PINGROUP(92, NORTH, _, _, qup15, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1182  	[93] = PINGROUP(93, NORTH, qdss, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1183  	[94] = PINGROUP(94, SOUTH, _, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1184  	[95] = PINGROUP(95, WEST, _, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1185  	[96] = PINGROUP(96, WEST, qlink_request, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1186  	[97] = PINGROUP(97, WEST, qlink_enable, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1187  	[98] = PINGROUP(98, WEST, _, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1188  	[99] = PINGROUP(99, WEST, _, pa_indicator, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1189  	[100] = PINGROUP(100, WEST, _, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1190  	[101] = PINGROUP(101, NORTH, _, _, qup15, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1191  	[102] = PINGROUP(102, NORTH, _, _, qup15, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1192  	[103] = PINGROUP(103, NORTH, _, qup15, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1193  	[104] = PINGROUP(104, WEST, usb_phy, _, qdss, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1194  	[105] = PINGROUP(105, NORTH, _, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1195  	[106] = PINGROUP(106, NORTH, _, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1196  	[107] = PINGROUP(107, WEST, _, nav_pps_in, nav_pps_out, gps_tx, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1197  	[108] = PINGROUP(108, SOUTH, mss_lte, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1198  	[109] = PINGROUP(109, SOUTH, mss_lte, gps_tx, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1199  	[110] = PINGROUP(110, NORTH, _, _, qup14, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1200  	[111] = PINGROUP(111, NORTH, _, _, qup14, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1201  	[112] = PINGROUP(112, NORTH, _, qup14, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1202  	[113] = PINGROUP(113, NORTH, _, qup14, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1203  	[114] = PINGROUP(114, NORTH, _, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1204  	[115] = PINGROUP(115, NORTH, _, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1205  	[116] = PINGROUP(116, NORTH, _, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1206  	[117] = PINGROUP(117, NORTH, _, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1207  	[118] = PINGROUP(118, NORTH, _, _, _, _, _, _, _, _, _),
b915395c9e0436 Danila Tikhonov 2023-03-12  1208  	[119] = UFS_RESET(ufs_reset, 0x9f000),
b915395c9e0436 Danila Tikhonov 2023-03-12  1209  	[120] = SDC_QDSD_PINGROUP(sdc1_rclk, 0x9a000, 15, 0),
b915395c9e0436 Danila Tikhonov 2023-03-12  1210  	[121] = SDC_QDSD_PINGROUP(sdc1_clk, 0x9a000, 13, 6),
b915395c9e0436 Danila Tikhonov 2023-03-12  1211  	[122] = SDC_QDSD_PINGROUP(sdc1_cmd, 0x9a000, 11, 3),
b915395c9e0436 Danila Tikhonov 2023-03-12  1212  	[123] = SDC_QDSD_PINGROUP(sdc1_data, 0x9a000, 9, 0),
b915395c9e0436 Danila Tikhonov 2023-03-12  1213  	[124] = SDC_QDSD_PINGROUP(sdc2_clk, 0x98000, 14, 6),
b915395c9e0436 Danila Tikhonov 2023-03-12  1214  	[125] = SDC_QDSD_PINGROUP(sdc2_cmd, 0x98000, 11, 3),
b915395c9e0436 Danila Tikhonov 2023-03-12  1215  	[126] = SDC_QDSD_PINGROUP(sdc2_data, 0x98000, 9, 0),
b915395c9e0436 Danila Tikhonov 2023-03-12  1216  };
b915395c9e0436 Danila Tikhonov 2023-03-12  1217  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

