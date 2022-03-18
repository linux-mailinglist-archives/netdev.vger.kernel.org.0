Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A6F4DE478
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 00:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241491AbiCRXZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 19:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238224AbiCRXZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 19:25:15 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26807CB02;
        Fri, 18 Mar 2022 16:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647645835; x=1679181835;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fw5CouShSdBsa1NlwiPhlJnkwyVroPMYx6gZHCqRoXI=;
  b=LUvLdZiFu7dMq7u5NoweMbG95MC0BC6pDhG1FLVul5Dgrz2MIGnynOcr
   i3QOB68vgwK37nH00hnpmUzm9sjttn1nIrb3SHWZWEXQCLOfB+Cn2dgCS
   iKyLVSqDljkNrtxebN6O0UVcI5tAnL7RiqraG/+ItFgeiMJh95vZtNwsC
   y23VrwrH7uR1b0bg1My5wk64aTiLvZG3PIkTe/2KU6Jhmmq9PueS82jpk
   EddnkujWnvgOpyhgVv8A5vlfC2FMrjyQ3krTZ/ugVQ8kWEaSIlofjxpmb
   0JMJa2KdbRjxfsc+VWCjqUXLXQMqEBsaVu9rkpn6eJVs1WEsWeAuhSa66
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="237188681"
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="237188681"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 16:23:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="581952226"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 18 Mar 2022 16:23:52 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nVLwl-000FHT-IT; Fri, 18 Mar 2022 23:23:51 +0000
Date:   Sat, 19 Mar 2022 07:23:05 +0800
From:   kernel test robot <lkp@intel.com>
To:     Edmond Gagnon <egagnon@squareup.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     kbuild-all@lists.01.org, Edmond Gagnon <egagnon@squareup.com>,
        Benjamin Li <benl@squareup.com>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] wcn36xx: Implement tx_rate reporting
Message-ID: <202203190720.E8jZHrLo-lkp@intel.com>
References: <20220318195804.4169686-3-egagnon@squareup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318195804.4169686-3-egagnon@squareup.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Edmond,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on wireless-next/main]
[also build test WARNING on kvalo-ath/ath-next next-20220318]
[cannot apply to wireless/main kvalo-wireless-drivers/master v5.17-rc8]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Edmond-Gagnon/wcn36xx-Implement-tx_rate-reporting/20220319-040030
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
config: i386-randconfig-a005 (https://download.01.org/0day-ci/archive/20220319/202203190720.E8jZHrLo-lkp@intel.com/config)
compiler: gcc-9 (Ubuntu 9.4.0-1ubuntu1~20.04) 9.4.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/ec06272b313bdabd805efd65a0a6c2a74b82803f
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Edmond-Gagnon/wcn36xx-Implement-tx_rate-reporting/20220319-040030
        git checkout ec06272b313bdabd805efd65a0a6c2a74b82803f
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/wireless/ath/wcn36xx/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/wireless/ath/wcn36xx/main.c:1604:6: warning: no previous prototype for 'wcn36xx_get_stats_work' [-Wmissing-prototypes]
    1604 | void wcn36xx_get_stats_work(struct work_struct *work)
         |      ^~~~~~~~~~~~~~~~~~~~~~
   drivers/net/wireless/ath/wcn36xx/main.c: In function 'wcn36xx_get_stats_work':
>> drivers/net/wireless/ath/wcn36xx/main.c:1608:6: warning: variable 'stats_status' set but not used [-Wunused-but-set-variable]
    1608 |  int stats_status;
         |      ^~~~~~~~~~~~


vim +/wcn36xx_get_stats_work +1604 drivers/net/wireless/ath/wcn36xx/main.c

  1603	
> 1604	void wcn36xx_get_stats_work(struct work_struct *work)
  1605	{
  1606		struct delayed_work *delayed_work = container_of(work, struct delayed_work, work);
  1607		struct wcn36xx *wcn = container_of(delayed_work, struct wcn36xx, get_stats_work);
> 1608		int stats_status;
  1609	
  1610		stats_status = wcn36xx_smd_get_stats(wcn, HAL_GLOBAL_CLASS_A_STATS_INFO);
  1611	
  1612		schedule_delayed_work(&wcn->get_stats_work, msecs_to_jiffies(WCN36XX_HAL_STATS_INTERVAL));
  1613	}
  1614	

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
