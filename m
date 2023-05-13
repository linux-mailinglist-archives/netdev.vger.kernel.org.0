Return-Path: <netdev+bounces-2329-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C5F7701480
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 07:40:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF704281C2E
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 05:40:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABC7DED7;
	Sat, 13 May 2023 05:40:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91807ED5
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 05:40:15 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97965273A;
	Fri, 12 May 2023 22:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683956411; x=1715492411;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gk9jQWisQbrgedeuc/WFJtxZpDTaCuHHb1I2wjZ0MnA=;
  b=cNNZ+ppOxBmIPjXjBgKiaE+iXnM9Y/KcJc2IeUsqekItFvAzLX3J4oXU
   w3JNlDa+bQgmiB6Ig/mXgSNXkgCwf/q0cKcLH4b/OaPvy2InHGsZxpimy
   RahszV82Co6S0kxLttPe1QVHtfMaqaaulkiI0unoBtjCzDOkA7s6i1q7r
   Zs1JTW+axWBl3mAHRy1S5cTYa1wfOfe2r2LQImhDxHVfOzuKhKPK4+Qtb
   04zSp169wzRP02NekHtz2DNKUz7I+EELt0/9GSrywKzGohnclBKsCRY68
   4LhaRkcLnTgd0MhXva1P0qk6rLr6i7ujyFBFmaxx0mwXAw2bksuJ6Y15S
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="437265560"
X-IronPort-AV: E=Sophos;i="5.99,271,1677571200"; 
   d="scan'208";a="437265560"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 22:40:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="731052174"
X-IronPort-AV: E=Sophos;i="5.99,271,1677571200"; 
   d="scan'208";a="731052174"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 12 May 2023 22:40:06 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pxhzB-0005MF-2h;
	Sat, 13 May 2023 05:40:05 +0000
Date: Sat, 13 May 2023 13:39:07 +0800
From: kernel test robot <lkp@intel.com>
To: Rohit Agarwal <quic_rohiagar@quicinc.com>, agross@kernel.org,
	andersson@kernel.org, konrad.dybcio@linaro.org,
	linus.walleij@linaro.org, robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, richardcochran@gmail.com,
	manivannan.sadhasivam@linaro.org, andy.shevchenko@gmail.com
Cc: oe-kbuild-all@lists.linux.dev, linux-arm-msm@vger.kernel.org,
	linux-gpio@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Rohit Agarwal <quic_rohiagar@quicinc.com>
Subject: Re: [PATCH 2/2] pinctrl: qcom: Refactor generic qcom pinctrl driver
Message-ID: <202305131327.hT8CxYAe-lkp@intel.com>
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
config: arm-allyesconfig (https://download.01.org/0day-ci/archive/20230513/202305131327.hT8CxYAe-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/1894575a5b0f681fb8697a05ac2aa68ef97e48e8
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Rohit-Agarwal/pinctrl-qcom-Remove-the-msm_function-struct/20230512-195910
        git checkout 1894575a5b0f681fb8697a05ac2aa68ef97e48e8
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305131327.hT8CxYAe-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/pinctrl/qcom/pinctrl-sm7150.c:969:34: error: array type has incomplete element type 'struct msm_function'
     969 | static const struct msm_function sm7150_functions[] = {
         |                                  ^~~~~~~~~~~~~~~~
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:37:18: error: 'const struct msm_pingroup' has no member named 'name'
      37 |                 .name = "gpio" #id,                     \
         |                  ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1089:15: note: in expansion of macro 'PINGROUP'
    1089 |         [0] = PINGROUP(0, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:38:18: error: 'const struct msm_pingroup' has no member named 'pins'
      38 |                 .pins = gpio##id##_pins,                \
         |                  ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1089:15: note: in expansion of macro 'PINGROUP'
    1089 |         [0] = PINGROUP(0, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:38:25: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
      38 |                 .pins = gpio##id##_pins,                \
         |                         ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1089:15: note: in expansion of macro 'PINGROUP'
    1089 |         [0] = PINGROUP(0, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:39:18: error: 'const struct msm_pingroup' has no member named 'npins'
      39 |                 .npins = ARRAY_SIZE(gpio##id##_pins),   \
         |                  ^~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1089:15: note: in expansion of macro 'PINGROUP'
    1089 |         [0] = PINGROUP(0, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:40:26: warning: initialized field overwritten [-Woverride-init]
      40 |                 .funcs = (int[]){                       \
         |                          ^
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1089:15: note: in expansion of macro 'PINGROUP'
    1089 |         [0] = PINGROUP(0, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:40:26: note: (near initialization for 'sm7150_groups[0].funcs')
      40 |                 .funcs = (int[]){                       \
         |                          ^
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1089:15: note: in expansion of macro 'PINGROUP'
    1089 |         [0] = PINGROUP(0, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:52:27: warning: initialized field overwritten [-Woverride-init]
      52 |                 .nfuncs = 10,                           \
         |                           ^~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1089:15: note: in expansion of macro 'PINGROUP'
    1089 |         [0] = PINGROUP(0, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:52:27: note: (near initialization for 'sm7150_groups[0].nfuncs')
      52 |                 .nfuncs = 10,                           \
         |                           ^~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1089:15: note: in expansion of macro 'PINGROUP'
    1089 |         [0] = PINGROUP(0, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:37:18: error: 'const struct msm_pingroup' has no member named 'name'
      37 |                 .name = "gpio" #id,                     \
         |                  ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1090:15: note: in expansion of macro 'PINGROUP'
    1090 |         [1] = PINGROUP(1, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:38:18: error: 'const struct msm_pingroup' has no member named 'pins'
      38 |                 .pins = gpio##id##_pins,                \
         |                  ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1090:15: note: in expansion of macro 'PINGROUP'
    1090 |         [1] = PINGROUP(1, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:38:25: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
      38 |                 .pins = gpio##id##_pins,                \
         |                         ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1090:15: note: in expansion of macro 'PINGROUP'
    1090 |         [1] = PINGROUP(1, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:39:18: error: 'const struct msm_pingroup' has no member named 'npins'
      39 |                 .npins = ARRAY_SIZE(gpio##id##_pins),   \
         |                  ^~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1090:15: note: in expansion of macro 'PINGROUP'
    1090 |         [1] = PINGROUP(1, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:40:26: warning: initialized field overwritten [-Woverride-init]
      40 |                 .funcs = (int[]){                       \
         |                          ^
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1090:15: note: in expansion of macro 'PINGROUP'
    1090 |         [1] = PINGROUP(1, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:40:26: note: (near initialization for 'sm7150_groups[1].funcs')
      40 |                 .funcs = (int[]){                       \
         |                          ^
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1090:15: note: in expansion of macro 'PINGROUP'
    1090 |         [1] = PINGROUP(1, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:52:27: warning: initialized field overwritten [-Woverride-init]
      52 |                 .nfuncs = 10,                           \
         |                           ^~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1090:15: note: in expansion of macro 'PINGROUP'
    1090 |         [1] = PINGROUP(1, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:52:27: note: (near initialization for 'sm7150_groups[1].nfuncs')
      52 |                 .nfuncs = 10,                           \
         |                           ^~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1090:15: note: in expansion of macro 'PINGROUP'
    1090 |         [1] = PINGROUP(1, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:37:18: error: 'const struct msm_pingroup' has no member named 'name'
      37 |                 .name = "gpio" #id,                     \
         |                  ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1091:15: note: in expansion of macro 'PINGROUP'
    1091 |         [2] = PINGROUP(2, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:38:18: error: 'const struct msm_pingroup' has no member named 'pins'
      38 |                 .pins = gpio##id##_pins,                \
         |                  ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1091:15: note: in expansion of macro 'PINGROUP'
    1091 |         [2] = PINGROUP(2, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:38:25: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
      38 |                 .pins = gpio##id##_pins,                \
         |                         ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1091:15: note: in expansion of macro 'PINGROUP'
    1091 |         [2] = PINGROUP(2, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:39:18: error: 'const struct msm_pingroup' has no member named 'npins'
      39 |                 .npins = ARRAY_SIZE(gpio##id##_pins),   \
         |                  ^~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1091:15: note: in expansion of macro 'PINGROUP'
    1091 |         [2] = PINGROUP(2, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:40:26: warning: initialized field overwritten [-Woverride-init]
      40 |                 .funcs = (int[]){                       \
         |                          ^
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1091:15: note: in expansion of macro 'PINGROUP'
    1091 |         [2] = PINGROUP(2, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:40:26: note: (near initialization for 'sm7150_groups[2].funcs')
      40 |                 .funcs = (int[]){                       \
         |                          ^
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1091:15: note: in expansion of macro 'PINGROUP'
    1091 |         [2] = PINGROUP(2, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:52:27: warning: initialized field overwritten [-Woverride-init]
      52 |                 .nfuncs = 10,                           \
         |                           ^~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1091:15: note: in expansion of macro 'PINGROUP'
    1091 |         [2] = PINGROUP(2, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:52:27: note: (near initialization for 'sm7150_groups[2].nfuncs')
      52 |                 .nfuncs = 10,                           \
         |                           ^~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1091:15: note: in expansion of macro 'PINGROUP'
    1091 |         [2] = PINGROUP(2, SOUTH, qup01, _, phase_flag, _, _, _, _, _, _),
         |               ^~~~~~~~
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:37:18: error: 'const struct msm_pingroup' has no member named 'name'
      37 |                 .name = "gpio" #id,                     \
         |                  ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1092:15: note: in expansion of macro 'PINGROUP'
    1092 |         [3] = PINGROUP(3, SOUTH, qup01, dbg_out, _, _, _, _, _, _, _),
         |               ^~~~~~~~
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:38:18: error: 'const struct msm_pingroup' has no member named 'pins'
      38 |                 .pins = gpio##id##_pins,                \
         |                  ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1092:15: note: in expansion of macro 'PINGROUP'
    1092 |         [3] = PINGROUP(3, SOUTH, qup01, dbg_out, _, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:38:25: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
      38 |                 .pins = gpio##id##_pins,                \
         |                         ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1092:15: note: in expansion of macro 'PINGROUP'
    1092 |         [3] = PINGROUP(3, SOUTH, qup01, dbg_out, _, _, _, _, _, _, _),
         |               ^~~~~~~~
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:39:18: error: 'const struct msm_pingroup' has no member named 'npins'
      39 |                 .npins = ARRAY_SIZE(gpio##id##_pins),   \
         |                  ^~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1092:15: note: in expansion of macro 'PINGROUP'
    1092 |         [3] = PINGROUP(3, SOUTH, qup01, dbg_out, _, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:40:26: warning: initialized field overwritten [-Woverride-init]
      40 |                 .funcs = (int[]){                       \
         |                          ^
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1092:15: note: in expansion of macro 'PINGROUP'
    1092 |         [3] = PINGROUP(3, SOUTH, qup01, dbg_out, _, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:40:26: note: (near initialization for 'sm7150_groups[3].funcs')
      40 |                 .funcs = (int[]){                       \
         |                          ^
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1092:15: note: in expansion of macro 'PINGROUP'
    1092 |         [3] = PINGROUP(3, SOUTH, qup01, dbg_out, _, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:52:27: warning: initialized field overwritten [-Woverride-init]
      52 |                 .nfuncs = 10,                           \
         |                           ^~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1092:15: note: in expansion of macro 'PINGROUP'
    1092 |         [3] = PINGROUP(3, SOUTH, qup01, dbg_out, _, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:52:27: note: (near initialization for 'sm7150_groups[3].nfuncs')
      52 |                 .nfuncs = 10,                           \
         |                           ^~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1092:15: note: in expansion of macro 'PINGROUP'
    1092 |         [3] = PINGROUP(3, SOUTH, qup01, dbg_out, _, _, _, _, _, _, _),
         |               ^~~~~~~~
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:37:18: error: 'const struct msm_pingroup' has no member named 'name'
      37 |                 .name = "gpio" #id,                     \
         |                  ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1093:15: note: in expansion of macro 'PINGROUP'
    1093 |         [4] = PINGROUP(4, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
         |               ^~~~~~~~
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:38:18: error: 'const struct msm_pingroup' has no member named 'pins'
      38 |                 .pins = gpio##id##_pins,                \
         |                  ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1093:15: note: in expansion of macro 'PINGROUP'
    1093 |         [4] = PINGROUP(4, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:38:25: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
      38 |                 .pins = gpio##id##_pins,                \
         |                         ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1093:15: note: in expansion of macro 'PINGROUP'
    1093 |         [4] = PINGROUP(4, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
         |               ^~~~~~~~
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:39:18: error: 'const struct msm_pingroup' has no member named 'npins'
      39 |                 .npins = ARRAY_SIZE(gpio##id##_pins),   \
         |                  ^~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1093:15: note: in expansion of macro 'PINGROUP'
    1093 |         [4] = PINGROUP(4, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:40:26: warning: initialized field overwritten [-Woverride-init]
      40 |                 .funcs = (int[]){                       \
         |                          ^
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1093:15: note: in expansion of macro 'PINGROUP'
    1093 |         [4] = PINGROUP(4, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:40:26: note: (near initialization for 'sm7150_groups[4].funcs')
      40 |                 .funcs = (int[]){                       \
         |                          ^
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1093:15: note: in expansion of macro 'PINGROUP'
    1093 |         [4] = PINGROUP(4, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:52:27: warning: initialized field overwritten [-Woverride-init]
      52 |                 .nfuncs = 10,                           \
         |                           ^~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1093:15: note: in expansion of macro 'PINGROUP'
    1093 |         [4] = PINGROUP(4, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:52:27: note: (near initialization for 'sm7150_groups[4].nfuncs')
      52 |                 .nfuncs = 10,                           \
         |                           ^~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1093:15: note: in expansion of macro 'PINGROUP'
    1093 |         [4] = PINGROUP(4, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
         |               ^~~~~~~~
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:37:18: error: 'const struct msm_pingroup' has no member named 'name'
      37 |                 .name = "gpio" #id,                     \
         |                  ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1094:15: note: in expansion of macro 'PINGROUP'
    1094 |         [5] = PINGROUP(5, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
         |               ^~~~~~~~
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:38:18: error: 'const struct msm_pingroup' has no member named 'pins'
      38 |                 .pins = gpio##id##_pins,                \
         |                  ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1094:15: note: in expansion of macro 'PINGROUP'
    1094 |         [5] = PINGROUP(5, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:38:25: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
      38 |                 .pins = gpio##id##_pins,                \
         |                         ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1094:15: note: in expansion of macro 'PINGROUP'
    1094 |         [5] = PINGROUP(5, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
         |               ^~~~~~~~
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:39:18: error: 'const struct msm_pingroup' has no member named 'npins'
      39 |                 .npins = ARRAY_SIZE(gpio##id##_pins),   \
         |                  ^~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1094:15: note: in expansion of macro 'PINGROUP'
    1094 |         [5] = PINGROUP(5, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:40:26: warning: initialized field overwritten [-Woverride-init]
      40 |                 .funcs = (int[]){                       \
         |                          ^
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1094:15: note: in expansion of macro 'PINGROUP'
    1094 |         [5] = PINGROUP(5, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:40:26: note: (near initialization for 'sm7150_groups[5].funcs')
      40 |                 .funcs = (int[]){                       \
         |                          ^
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1094:15: note: in expansion of macro 'PINGROUP'
    1094 |         [5] = PINGROUP(5, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:52:27: warning: initialized field overwritten [-Woverride-init]
      52 |                 .nfuncs = 10,                           \
         |                           ^~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1094:15: note: in expansion of macro 'PINGROUP'
    1094 |         [5] = PINGROUP(5, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:52:27: note: (near initialization for 'sm7150_groups[5].nfuncs')
      52 |                 .nfuncs = 10,                           \
         |                           ^~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1094:15: note: in expansion of macro 'PINGROUP'
    1094 |         [5] = PINGROUP(5, NORTH, _, qdss_cti, _, _, _, _, _, _, _),
         |               ^~~~~~~~
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:37:18: error: 'const struct msm_pingroup' has no member named 'name'
      37 |                 .name = "gpio" #id,                     \
         |                  ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1095:15: note: in expansion of macro 'PINGROUP'
    1095 |         [6] = PINGROUP(6, NORTH, qup11, _, phase_flag, ddr_pxi0, _, _, _, _, _),
         |               ^~~~~~~~
>> drivers/pinctrl/qcom/pinctrl-sm7150.c:38:18: error: 'const struct msm_pingroup' has no member named 'pins'
      38 |                 .pins = gpio##id##_pins,                \
         |                  ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1095:15: note: in expansion of macro 'PINGROUP'
    1095 |         [6] = PINGROUP(6, NORTH, qup11, _, phase_flag, ddr_pxi0, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:38:25: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
      38 |                 .pins = gpio##id##_pins,                \
         |                         ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1095:15: note: in expansion of macro 'PINGROUP'
    1095 |         [6] = PINGROUP(6, NORTH, qup11, _, phase_flag, ddr_pxi0, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:39:18: error: 'const struct msm_pingroup' has no member named 'npins'
      39 |                 .npins = ARRAY_SIZE(gpio##id##_pins),   \
         |                  ^~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1095:15: note: in expansion of macro 'PINGROUP'
    1095 |         [6] = PINGROUP(6, NORTH, qup11, _, phase_flag, ddr_pxi0, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:40:26: warning: initialized field overwritten [-Woverride-init]
      40 |                 .funcs = (int[]){                       \
         |                          ^
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1095:15: note: in expansion of macro 'PINGROUP'
    1095 |         [6] = PINGROUP(6, NORTH, qup11, _, phase_flag, ddr_pxi0, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:40:26: note: (near initialization for 'sm7150_groups[6].funcs')
      40 |                 .funcs = (int[]){                       \
         |                          ^
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1095:15: note: in expansion of macro 'PINGROUP'
    1095 |         [6] = PINGROUP(6, NORTH, qup11, _, phase_flag, ddr_pxi0, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:52:27: warning: initialized field overwritten [-Woverride-init]
      52 |                 .nfuncs = 10,                           \
         |                           ^~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1095:15: note: in expansion of macro 'PINGROUP'
    1095 |         [6] = PINGROUP(6, NORTH, qup11, _, phase_flag, ddr_pxi0, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:52:27: note: (near initialization for 'sm7150_groups[6].nfuncs')
      52 |                 .nfuncs = 10,                           \
         |                           ^~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1095:15: note: in expansion of macro 'PINGROUP'
    1095 |         [6] = PINGROUP(6, NORTH, qup11, _, phase_flag, ddr_pxi0, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:37:18: error: 'const struct msm_pingroup' has no member named 'name'
      37 |                 .name = "gpio" #id,                     \
         |                  ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1096:15: note: in expansion of macro 'PINGROUP'
    1096 |         [7] = PINGROUP(7, NORTH, qup11, ddr_bist, _, phase_flag, atest_tsens2, vsense_trigger, atest_usb1, ddr_pxi0, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:38:18: error: 'const struct msm_pingroup' has no member named 'pins'
      38 |                 .pins = gpio##id##_pins,                \
         |                  ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1096:15: note: in expansion of macro 'PINGROUP'
    1096 |         [7] = PINGROUP(7, NORTH, qup11, ddr_bist, _, phase_flag, atest_tsens2, vsense_trigger, atest_usb1, ddr_pxi0, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:38:25: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
      38 |                 .pins = gpio##id##_pins,                \
         |                         ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1096:15: note: in expansion of macro 'PINGROUP'
    1096 |         [7] = PINGROUP(7, NORTH, qup11, ddr_bist, _, phase_flag, atest_tsens2, vsense_trigger, atest_usb1, ddr_pxi0, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:39:18: error: 'const struct msm_pingroup' has no member named 'npins'
      39 |                 .npins = ARRAY_SIZE(gpio##id##_pins),   \
         |                  ^~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1096:15: note: in expansion of macro 'PINGROUP'
    1096 |         [7] = PINGROUP(7, NORTH, qup11, ddr_bist, _, phase_flag, atest_tsens2, vsense_trigger, atest_usb1, ddr_pxi0, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:40:26: warning: initialized field overwritten [-Woverride-init]
      40 |                 .funcs = (int[]){                       \
         |                          ^
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1096:15: note: in expansion of macro 'PINGROUP'
    1096 |         [7] = PINGROUP(7, NORTH, qup11, ddr_bist, _, phase_flag, atest_tsens2, vsense_trigger, atest_usb1, ddr_pxi0, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:40:26: note: (near initialization for 'sm7150_groups[7].funcs')
      40 |                 .funcs = (int[]){                       \
         |                          ^
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1096:15: note: in expansion of macro 'PINGROUP'
    1096 |         [7] = PINGROUP(7, NORTH, qup11, ddr_bist, _, phase_flag, atest_tsens2, vsense_trigger, atest_usb1, ddr_pxi0, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:52:27: warning: initialized field overwritten [-Woverride-init]
      52 |                 .nfuncs = 10,                           \
         |                           ^~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1096:15: note: in expansion of macro 'PINGROUP'
    1096 |         [7] = PINGROUP(7, NORTH, qup11, ddr_bist, _, phase_flag, atest_tsens2, vsense_trigger, atest_usb1, ddr_pxi0, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:52:27: note: (near initialization for 'sm7150_groups[7].nfuncs')
      52 |                 .nfuncs = 10,                           \
         |                           ^~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1096:15: note: in expansion of macro 'PINGROUP'
    1096 |         [7] = PINGROUP(7, NORTH, qup11, ddr_bist, _, phase_flag, atest_tsens2, vsense_trigger, atest_usb1, ddr_pxi0, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:37:18: error: 'const struct msm_pingroup' has no member named 'name'
      37 |                 .name = "gpio" #id,                     \
         |                  ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1097:15: note: in expansion of macro 'PINGROUP'
    1097 |         [8] = PINGROUP(8, NORTH, qup11, gp_pdm1, ddr_bist, _, _, _, _, _, _),
         |               ^~~~~~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:38:18: error: 'const struct msm_pingroup' has no member named 'pins'
      38 |                 .pins = gpio##id##_pins,                \
         |                  ^~~~
   drivers/pinctrl/qcom/pinctrl-sm7150.c:1097:15: note: in expansion of macro 'PINGROUP'
    1097 |         [8] = PINGROUP(8, NORTH, qup11, gp_pdm1, ddr_bist, _, _, _, _, _, _),


vim +37 drivers/pinctrl/qcom/pinctrl-sm7150.c

b915395c9e0436 Danila Tikhonov 2023-03-12  34  
b915395c9e0436 Danila Tikhonov 2023-03-12  35  #define PINGROUP(id, _tile, f1, f2, f3, f4, f5, f6, f7, f8, f9) \
b915395c9e0436 Danila Tikhonov 2023-03-12  36  	{						\
b915395c9e0436 Danila Tikhonov 2023-03-12 @37  		.name = "gpio" #id,			\
b915395c9e0436 Danila Tikhonov 2023-03-12 @38  		.pins = gpio##id##_pins,		\
b915395c9e0436 Danila Tikhonov 2023-03-12 @39  		.npins = ARRAY_SIZE(gpio##id##_pins),	\
b915395c9e0436 Danila Tikhonov 2023-03-12  40  		.funcs = (int[]){			\
b915395c9e0436 Danila Tikhonov 2023-03-12  41  			msm_mux_gpio, /* gpio mode */	\
b915395c9e0436 Danila Tikhonov 2023-03-12  42  			msm_mux_##f1,			\
b915395c9e0436 Danila Tikhonov 2023-03-12  43  			msm_mux_##f2,			\
b915395c9e0436 Danila Tikhonov 2023-03-12  44  			msm_mux_##f3,			\
b915395c9e0436 Danila Tikhonov 2023-03-12  45  			msm_mux_##f4,			\
b915395c9e0436 Danila Tikhonov 2023-03-12  46  			msm_mux_##f5,			\
b915395c9e0436 Danila Tikhonov 2023-03-12  47  			msm_mux_##f6,			\
b915395c9e0436 Danila Tikhonov 2023-03-12  48  			msm_mux_##f7,			\
b915395c9e0436 Danila Tikhonov 2023-03-12  49  			msm_mux_##f8,			\
b915395c9e0436 Danila Tikhonov 2023-03-12  50  			msm_mux_##f9			\
b915395c9e0436 Danila Tikhonov 2023-03-12  51  		},					\
b915395c9e0436 Danila Tikhonov 2023-03-12  52  		.nfuncs = 10,				\
b915395c9e0436 Danila Tikhonov 2023-03-12  53  		.ctl_reg = REG_SIZE * id,		\
b915395c9e0436 Danila Tikhonov 2023-03-12  54  		.io_reg = 0x4 + REG_SIZE * id,		\
b915395c9e0436 Danila Tikhonov 2023-03-12  55  		.intr_cfg_reg = 0x8 + REG_SIZE * id,	\
b915395c9e0436 Danila Tikhonov 2023-03-12  56  		.intr_status_reg = 0xc + REG_SIZE * id,	\
b915395c9e0436 Danila Tikhonov 2023-03-12  57  		.intr_target_reg = 0x8 + REG_SIZE * id,	\
b915395c9e0436 Danila Tikhonov 2023-03-12  58  		.tile = _tile,				\
b915395c9e0436 Danila Tikhonov 2023-03-12  59  		.mux_bit = 2,				\
b915395c9e0436 Danila Tikhonov 2023-03-12  60  		.pull_bit = 0,				\
b915395c9e0436 Danila Tikhonov 2023-03-12  61  		.drv_bit = 6,				\
b915395c9e0436 Danila Tikhonov 2023-03-12  62  		.oe_bit = 9,				\
b915395c9e0436 Danila Tikhonov 2023-03-12  63  		.in_bit = 0,				\
b915395c9e0436 Danila Tikhonov 2023-03-12  64  		.out_bit = 1,				\
b915395c9e0436 Danila Tikhonov 2023-03-12  65  		.intr_enable_bit = 0,			\
b915395c9e0436 Danila Tikhonov 2023-03-12  66  		.intr_status_bit = 0,			\
b915395c9e0436 Danila Tikhonov 2023-03-12  67  		.intr_target_bit = 5,			\
b915395c9e0436 Danila Tikhonov 2023-03-12  68  		.intr_target_kpss_val = 3,		\
b915395c9e0436 Danila Tikhonov 2023-03-12  69  		.intr_raw_status_bit = 4,		\
b915395c9e0436 Danila Tikhonov 2023-03-12  70  		.intr_polarity_bit = 1,			\
b915395c9e0436 Danila Tikhonov 2023-03-12  71  		.intr_detection_bit = 2,		\
b915395c9e0436 Danila Tikhonov 2023-03-12  72  		.intr_detection_width = 2,		\
b915395c9e0436 Danila Tikhonov 2023-03-12  73  	}
b915395c9e0436 Danila Tikhonov 2023-03-12  74  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

