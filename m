Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B5F530D49
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 12:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbiEWKFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 06:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233821AbiEWKFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 06:05:01 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592D017AAC;
        Mon, 23 May 2022 03:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653300299; x=1684836299;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ggL90ToVu7qh9RF4iy+2ZjsDqdtGnMx14duWRCjmabI=;
  b=eg2c45XEARSUDygpZHi3cpp28QACJtDWGaAQGdP9D1MuLDyyQ5N1zWY6
   OLczJCbwnY6pXjesErMekh5jN6qFOR61jf3EuULCfTAPMrAvn0IDiHWoh
   NSgKrnw7sjyJy1+5Q0c4SGSbvZ6n1/tMh+Wp7i/oDhc4JpTtNsXbZsTfh
   WUQfHLDuj1rrjC/PUN8NG0gqVv71SLVcseiN8Phc7WQSN9sId2wfbMVYL
   KDSj3FONQODu1EKY1w8FcdjA6jG9PW3XRpXq9QGxszIrmTnyxJUWN4ZTV
   Nr3DCNUgT/nhfSvMbk4kn4Fhc7hk+bs0BtmLsY0xefXci0tA0/LQbPtOX
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10355"; a="333814162"
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="333814162"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 03:04:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="675791641"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 23 May 2022 03:04:53 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nt4vk-00013a-WC;
        Mon, 23 May 2022 10:04:53 +0000
Date:   Mon, 23 May 2022 18:04:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Corentin Labbe <clabbe@baylibre.com>, andrew@lunn.ch,
        broonie@kernel.org, calvin.johnson@oss.nxp.com,
        davem@davemloft.net, edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, lgirdwood@gmail.com, linux@armlinux.org.uk,
        pabeni@redhat.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        netdev@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: Re: [PATCH v3 1/3] regulator: Add regulator_bulk_get_all
Message-ID: <202205231709.3Wo0pW9z-lkp@intel.com>
References: <20220523052807.4044800-2-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523052807.4044800-2-clabbe@baylibre.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Corentin,

I love your patch! Yet something to improve:

[auto build test ERROR on broonie-regulator/for-next]
[also build test ERROR on sunxi/sunxi/for-next linus/master v5.18 next-20220520]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Corentin-Labbe/arm64-add-ethernet-to-orange-pi-3/20220523-133344
base:   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git for-next
config: hexagon-buildonly-randconfig-r002-20220522 (https://download.01.org/0day-ci/archive/20220523/202205231709.3Wo0pW9z-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 768a1ca5eccb678947f4155e38a5f5744dcefb56)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/179be86f748a2cce87423bb16f4f967c97bf5d9b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Corentin-Labbe/arm64-add-ethernet-to-orange-pi-3/20220523-133344
        git checkout 179be86f748a2cce87423bb16f4f967c97bf5d9b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/regulator/core.c:4870:2: error: call to undeclared function 'for_each_property_of_node'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           for_each_property_of_node(np, prop) {
           ^
>> drivers/regulator/core.c:4870:37: error: expected ';' after expression
           for_each_property_of_node(np, prop) {
                                              ^
                                              ;
>> drivers/regulator/core.c:4873:4: error: 'continue' statement not in loop statement
                           continue;
                           ^
   drivers/regulator/core.c:4876:4: error: 'continue' statement not in loop statement
                           continue;
                           ^
   drivers/regulator/core.c:4887:4: error: 'continue' statement not in loop statement
                           continue;
                           ^
   5 errors generated.


vim +/for_each_property_of_node +4870 drivers/regulator/core.c

  4839	
  4840	/*
  4841	 * regulator_bulk_get_all - get multiple regulator consumers
  4842	 *
  4843	 * @dev:	Device to supply
  4844	 * @np:		device node to search for consumers
  4845	 * @consumers:  Configuration of consumers; clients are stored here.
  4846	 *
  4847	 * @return number of regulators on success, an errno on failure.
  4848	 *
  4849	 * This helper function allows drivers to get several regulator
  4850	 * consumers in one operation.  If any of the regulators cannot be
  4851	 * acquired then any regulators that were allocated will be freed
  4852	 * before returning to the caller.
  4853	 */
  4854	int regulator_bulk_get_all(struct device *dev, struct device_node *np,
  4855				   struct regulator_bulk_data **consumers)
  4856	{
  4857		int num_consumers = 0;
  4858		struct regulator *tmp;
  4859		struct property *prop;
  4860		int i, n = 0, ret;
  4861		char name[64];
  4862	
  4863		*consumers = NULL;
  4864	
  4865	/*
  4866	 * first pass: get numbers of xxx-supply
  4867	 * second pass: fill consumers
  4868	 * */
  4869	restart:
> 4870		for_each_property_of_node(np, prop) {
  4871			i = is_supply_name(prop->name);
  4872			if (i == 0)
> 4873				continue;
  4874			if (!*consumers) {
  4875				num_consumers++;
  4876				continue;
  4877			} else {
  4878				memcpy(name, prop->name, i);
  4879				name[i] = '\0';
  4880				tmp = regulator_get(dev, name);
  4881				if (!tmp) {
  4882					ret = -EINVAL;
  4883					goto error;
  4884				}
  4885				(*consumers)[n].consumer = tmp;
  4886				n++;
  4887				continue;
  4888			}
  4889		}
  4890		if (*consumers)
  4891			return num_consumers;
  4892		if (num_consumers == 0)
  4893			return 0;
  4894		*consumers = kmalloc_array(num_consumers,
  4895					   sizeof(struct regulator_bulk_data),
  4896					   GFP_KERNEL);
  4897		if (!*consumers)
  4898			return -ENOMEM;
  4899		goto restart;
  4900	
  4901	error:
  4902		while (--n >= 0)
  4903			regulator_put(consumers[n]->consumer);
  4904		return ret;
  4905	}
  4906	EXPORT_SYMBOL_GPL(regulator_bulk_get_all);
  4907	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
