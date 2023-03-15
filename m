Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A21C6BA470
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 02:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjCOBGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 21:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjCOBGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 21:06:03 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39F22CC51;
        Tue, 14 Mar 2023 18:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678842361; x=1710378361;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bf0cITO4GwyotSgqh8OBywPfEL29aNWqkchlvVro+RA=;
  b=f0JMO0CvTrk+JA34bM5mADMu2Cq7+raQUXBT44W3QE7FZ2Z72CWBvHOJ
   Y9xN+JJzuq8exg3bD+ufDFGi9OwBXVs72ERhS8DO6QG2fkQa/RdU37NWZ
   ddOK680mFBfZHxe1QqIholjm+s5LASGoozBSFX5zVmZKVTK7nt21YEiMi
   HeO20NUVtnvxF4BseRaNW/f8kAKvf6hAtO3pX03wboBv0wdJxeZgR3Mld
   HwUehPUJnhpnmdEDL4gOHRekWSJbdE7FpAggayCWeeJC1fR11fEJwboot
   in8m9T/06mHpzzNvm+WXaJ1vMDsM9DQnTvTZQJrzETbhjKrNoD/jlarUp
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="337604592"
X-IronPort-AV: E=Sophos;i="5.98,261,1673942400"; 
   d="scan'208";a="337604592"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 18:06:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="681641909"
X-IronPort-AV: E=Sophos;i="5.98,261,1673942400"; 
   d="scan'208";a="681641909"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 14 Mar 2023 18:05:58 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pcFaX-0007J9-27;
        Wed, 15 Mar 2023 01:05:57 +0000
Date:   Wed, 15 Mar 2023 09:05:25 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v6 1/1] net: dsa: hellcreek: Get rid of custom
 led_init_default_state_get()
Message-ID: <202303150831.vgyKe8FD-lkp@intel.com>
References: <20230314181824.56881-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314181824.56881-1-andriy.shevchenko@linux.intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Andy-Shevchenko/net-dsa-hellcreek-Get-rid-of-custom-led_init_default_state_get/20230315-021931
patch link:    https://lore.kernel.org/r/20230314181824.56881-1-andriy.shevchenko%40linux.intel.com
patch subject: [PATCH net-next v6 1/1] net: dsa: hellcreek: Get rid of custom led_init_default_state_get()
config: i386-randconfig-a015-20230313 (https://download.01.org/0day-ci/archive/20230315/202303150831.vgyKe8FD-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/fdd54417a75386e7ad47065c21403835b7fda94a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Andy-Shevchenko/net-dsa-hellcreek-Get-rid-of-custom-led_init_default_state_get/20230315-021931
        git checkout fdd54417a75386e7ad47065c21403835b7fda94a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/dsa/hirschmann/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303150831.vgyKe8FD-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/net/dsa/hirschmann/hellcreek_ptp.c:322:10: error: implicit declaration of function 'led_init_default_state_get' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
           state = led_init_default_state_get(of_fwnode_handle(led));
                   ^
   1 error generated.


vim +/led_init_default_state_get +322 drivers/net/dsa/hirschmann/hellcreek_ptp.c

   292	
   293	/* There two available LEDs internally called sync_good and is_gm. However, the
   294	 * user might want to use a different label and specify the default state. Take
   295	 * those properties from device tree.
   296	 */
   297	static int hellcreek_led_setup(struct hellcreek *hellcreek)
   298	{
   299		struct device_node *leds, *led = NULL;
   300		enum led_default_state state;
   301		const char *label;
   302		int ret = -EINVAL;
   303	
   304		of_node_get(hellcreek->dev->of_node);
   305		leds = of_find_node_by_name(hellcreek->dev->of_node, "leds");
   306		if (!leds) {
   307			dev_err(hellcreek->dev, "No LEDs specified in device tree!\n");
   308			return ret;
   309		}
   310	
   311		hellcreek->status_out = 0;
   312	
   313		led = of_get_next_available_child(leds, led);
   314		if (!led) {
   315			dev_err(hellcreek->dev, "First LED not specified!\n");
   316			goto out;
   317		}
   318	
   319		ret = of_property_read_string(led, "label", &label);
   320		hellcreek->led_sync_good.name = ret ? "sync_good" : label;
   321	
 > 322		state = led_init_default_state_get(of_fwnode_handle(led));
   323		switch (state) {
   324		case LEDS_DEFSTATE_ON:
   325			hellcreek->led_sync_good.brightness = 1;
   326			break;
   327		case LEDS_DEFSTATE_KEEP:
   328			hellcreek->led_sync_good.brightness =
   329				hellcreek_get_brightness(hellcreek, STATUS_OUT_SYNC_GOOD);
   330			break;
   331		default:
   332			hellcreek->led_sync_good.brightness = 0;
   333		}
   334	
   335		hellcreek->led_sync_good.max_brightness = 1;
   336		hellcreek->led_sync_good.brightness_set = hellcreek_led_sync_good_set;
   337		hellcreek->led_sync_good.brightness_get = hellcreek_led_sync_good_get;
   338	
   339		led = of_get_next_available_child(leds, led);
   340		if (!led) {
   341			dev_err(hellcreek->dev, "Second LED not specified!\n");
   342			ret = -EINVAL;
   343			goto out;
   344		}
   345	
   346		ret = of_property_read_string(led, "label", &label);
   347		hellcreek->led_is_gm.name = ret ? "is_gm" : label;
   348	
   349		state = led_init_default_state_get(of_fwnode_handle(led));
   350		switch (state) {
   351		case LEDS_DEFSTATE_ON:
   352			hellcreek->led_is_gm.brightness = 1;
   353			break;
   354		case LEDS_DEFSTATE_KEEP:
   355			hellcreek->led_is_gm.brightness =
   356				hellcreek_get_brightness(hellcreek, STATUS_OUT_IS_GM);
   357			break;
   358		default:
   359			hellcreek->led_is_gm.brightness = 0;
   360		}
   361	
   362		hellcreek->led_is_gm.max_brightness = 1;
   363		hellcreek->led_is_gm.brightness_set = hellcreek_led_is_gm_set;
   364		hellcreek->led_is_gm.brightness_get = hellcreek_led_is_gm_get;
   365	
   366		/* Set initial state */
   367		if (hellcreek->led_sync_good.brightness == 1)
   368			hellcreek_set_brightness(hellcreek, STATUS_OUT_SYNC_GOOD, 1);
   369		if (hellcreek->led_is_gm.brightness == 1)
   370			hellcreek_set_brightness(hellcreek, STATUS_OUT_IS_GM, 1);
   371	
   372		/* Register both leds */
   373		led_classdev_register(hellcreek->dev, &hellcreek->led_sync_good);
   374		led_classdev_register(hellcreek->dev, &hellcreek->led_is_gm);
   375	
   376		ret = 0;
   377	
   378	out:
   379		of_node_put(leds);
   380	
   381		return ret;
   382	}
   383	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
