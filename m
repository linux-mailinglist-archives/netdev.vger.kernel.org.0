Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B705AC878
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 03:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbiIEBTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 21:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiIEBTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 21:19:09 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672B827FFF;
        Sun,  4 Sep 2022 18:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662340748; x=1693876748;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ll9tO925T9xsodBipO9e3UrxjRbk99kbcxC/Fg87W2A=;
  b=EsoTzrfevMiJfZLZRJBAP56/SkBgbKa3wOA/jRLOLsDuFM+uEVKrCgFk
   mIAmsKzqYI/iC+ZaAfwqBbmHaySaGWsGYoUfSnt1KfCNmASHGuK9Z25pT
   Ey4iJ2YQaQVZbEDMUpTdEQKA4TlV3Ova+7u0PTXUhAvrRZymhurMlNKCR
   BjIuBDgfgipatc06IUMuuiCcYHJpmKkl2yehtmLxhW/UR7PsiS9bp6Th/
   +PjD6pJb25fy9fMPFnUrgo/HD4X/jVhmy6CUXT6YQRhDCneibJNKWTANy
   6hxLVhFCFBijGL3JhZ3OIH6rte5vyAIIxqgkovYzu6Xdk523TIhRZhocV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10460"; a="360238493"
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="360238493"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2022 18:19:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="702719901"
Received: from lkp-server02.sh.intel.com (HELO 95dfd251caa2) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Sep 2022 18:19:05 -0700
Received: from kbuild by 95dfd251caa2 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oV0lV-0003ex-0R;
        Mon, 05 Sep 2022 01:19:05 +0000
Date:   Mon, 5 Sep 2022 09:18:42 +0800
From:   kernel test robot <lkp@intel.com>
To:     Olliver Schinagl <oliver@schinagl.nl>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        inux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Olliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCH] phy: Add helpers for setting/clearing bits in paged
 registers
Message-ID: <202209050910.t87wLY38-lkp@intel.com>
References: <20220904225555.1994290-1-oliver@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220904225555.1994290-1-oliver@schinagl.nl>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Olliver,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.0-rc4 next-20220901]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Olliver-Schinagl/phy-Add-helpers-for-setting-clearing-bits-in-paged-registers/20220905-070318
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 7e18e42e4b280c85b76967a9106a13ca61c16179
config: hexagon-randconfig-r045-20220905 (https://download.01.org/0day-ci/archive/20220905/202209050910.t87wLY38-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project c55b41d5199d2394dd6cdb8f52180d8b81d809d4)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/342260cb7603ad567f4799836ad4ed390ccedf2a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Olliver-Schinagl/phy-Add-helpers-for-setting-clearing-bits-in-paged-registers/20220905-070318
        git checkout 342260cb7603ad567f4799836ad4ed390ccedf2a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/phy/microchip/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from drivers/phy/microchip/lan966x_serdes.c:7:
>> include/linux/phy.h:1275:9: error: call to undeclared function 'phy_modify_paged'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           return phy_modify_paged(phydev, page, regnum, 0, val);
                  ^
   include/linux/phy.h:1275:9: note: did you mean 'phy_modify_changed'?
   include/linux/phy.h:1142:5: note: 'phy_modify_changed' declared here
   int phy_modify_changed(struct phy_device *phydev, u32 regnum, u16 mask,
       ^
   include/linux/phy.h:1288:9: error: call to undeclared function 'phy_modify_paged'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           return phy_modify_paged(phydev, page, regnum, val, 0);
                  ^
   include/linux/phy.h:1447:5: error: conflicting types for 'phy_modify_paged'
   int phy_modify_paged(struct phy_device *phydev, int page, u32 regnum,
       ^
   include/linux/phy.h:1275:9: note: previous implicit declaration is here
           return phy_modify_paged(phydev, page, regnum, 0, val);
                  ^
   3 errors generated.


vim +/phy_modify_paged +1275 include/linux/phy.h

  1264	
  1265	/**
  1266	 * phy_set_bits_paged - Convenience function for setting bits in a paged register
  1267	 * @phydev: the phy_device struct
  1268	 * @page: the page for the phy
  1269	 * @regnum: register number to write
  1270	 * @val: bits to set
  1271	 */
  1272	static inline int phy_set_bits_paged(struct phy_device *phydev, int page,
  1273					     u32 regnum, u16 val)
  1274	{
> 1275		return phy_modify_paged(phydev, page, regnum, 0, val);
  1276	}
  1277	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
