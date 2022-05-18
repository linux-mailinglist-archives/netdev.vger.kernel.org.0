Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2CD552C099
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 19:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240576AbiERQ5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 12:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240573AbiERQ5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 12:57:11 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBA1B8BE8;
        Wed, 18 May 2022 09:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652893030; x=1684429030;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Z/CTK7bNBAIerAtCFC6veGQRng0kyr18RgfO+QSHa/g=;
  b=Y9l53pMFDiTdYdDYE6FL2tJC4axgvYfJ9aQ7EcFl+q2IFybBaJAmOzZd
   mdTg2Xrmdhp5YHZBIicidP0eUkMviPda+Y42k/5E94Dgjs+0qQNfr14fg
   zLr9WrkqoO9W7vsxmb3oDtHG8/RL5uDRCw0Xv4XFwZejp4tMEpK1JJlE5
   6UM2XQ1TWQ3QgthwOxsWUWv2mYU/jp99Z05znctVuP9gPyslEr9V/16/I
   Qy5Pt+Et20WAFcdCYVIdyIcaXe2tAcQCTILmgE02YBZwNzdPm763ZML8E
   ww4fFR9i3mkk59f2lHW1JHGgvhPGNvIcuKvGAAqzSTisQ3rhr9z66/GZs
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="271468778"
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="271468778"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 09:56:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="639365223"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 18 May 2022 09:56:41 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nrMyX-0002QL-2k;
        Wed, 18 May 2022 16:56:41 +0000
Date:   Thu, 19 May 2022 00:55:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        linux-wireless@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Neo Jou <neojou@gmail.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 07/10] rtw88: Add rtw8723du chipset support
Message-ID: <202205190028.z15SPbJx-lkp@intel.com>
References: <20220518082318.3898514-8-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518082318.3898514-8-s.hauer@pengutronix.de>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sascha,

I love your patch! Perhaps something to improve:

[auto build test WARNING on wireless-next/main]
[also build test WARNING on wireless/main v5.18-rc7 next-20220518]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Sascha-Hauer/RTW88-Add-support-for-USB-variants/20220518-162621
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20220519/202205190028.z15SPbJx-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/0a06adba364ef264404e3c7ae111a71f0d74c5a9
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Sascha-Hauer/RTW88-Add-support-for-USB-variants/20220518-162621
        git checkout 0a06adba364ef264404e3c7ae111a71f0d74c5a9
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash drivers/net/wireless/realtek/rtw88/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/wireless/realtek/rtw88/util.c:119:6: warning: no previous prototype for 'rtw_collect_sta_iter' [-Wmissing-prototypes]
     119 | void rtw_collect_sta_iter(void *data, struct ieee80211_sta *sta)
         |      ^~~~~~~~~~~~~~~~~~~~
>> drivers/net/wireless/realtek/rtw88/util.c:165:6: warning: no previous prototype for 'rtw_collect_vif_iter' [-Wmissing-prototypes]
     165 | void rtw_collect_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
         |      ^~~~~~~~~~~~~~~~~~~~


vim +/rtw_collect_sta_iter +119 drivers/net/wireless/realtek/rtw88/util.c

1c99f6652d3fbb Sascha Hauer 2022-05-18  118  
1c99f6652d3fbb Sascha Hauer 2022-05-18 @119  void rtw_collect_sta_iter(void *data, struct ieee80211_sta *sta)
1c99f6652d3fbb Sascha Hauer 2022-05-18  120  {
1c99f6652d3fbb Sascha Hauer 2022-05-18  121  	struct rtw_iter_stas_data *iter_stas = data;
1c99f6652d3fbb Sascha Hauer 2022-05-18  122  	struct rtw_stas_entry *stas_entry;
1c99f6652d3fbb Sascha Hauer 2022-05-18  123  
1c99f6652d3fbb Sascha Hauer 2022-05-18  124  	stas_entry = kmalloc(sizeof(*stas_entry), GFP_ATOMIC);
1c99f6652d3fbb Sascha Hauer 2022-05-18  125  	if (!stas_entry)
1c99f6652d3fbb Sascha Hauer 2022-05-18  126  		return;
1c99f6652d3fbb Sascha Hauer 2022-05-18  127  
1c99f6652d3fbb Sascha Hauer 2022-05-18  128  	stas_entry->sta = sta;
1c99f6652d3fbb Sascha Hauer 2022-05-18  129  	list_add_tail(&stas_entry->list, &iter_stas->list);
1c99f6652d3fbb Sascha Hauer 2022-05-18  130  }
1c99f6652d3fbb Sascha Hauer 2022-05-18  131  
1c99f6652d3fbb Sascha Hauer 2022-05-18  132  void rtw_iterate_stas(struct rtw_dev *rtwdev,
1c99f6652d3fbb Sascha Hauer 2022-05-18  133  		      void (*iterator)(void *data,
1c99f6652d3fbb Sascha Hauer 2022-05-18  134  				       struct ieee80211_sta *sta),
1c99f6652d3fbb Sascha Hauer 2022-05-18  135  				       void *data)
1c99f6652d3fbb Sascha Hauer 2022-05-18  136  {
1c99f6652d3fbb Sascha Hauer 2022-05-18  137  	struct rtw_iter_stas_data iter_data;
1c99f6652d3fbb Sascha Hauer 2022-05-18  138  	struct rtw_stas_entry *sta_entry, *tmp;
1c99f6652d3fbb Sascha Hauer 2022-05-18  139  
1c99f6652d3fbb Sascha Hauer 2022-05-18  140  	iter_data.rtwdev = rtwdev;
1c99f6652d3fbb Sascha Hauer 2022-05-18  141  	INIT_LIST_HEAD(&iter_data.list);
1c99f6652d3fbb Sascha Hauer 2022-05-18  142  
1c99f6652d3fbb Sascha Hauer 2022-05-18  143  	ieee80211_iterate_stations_atomic(rtwdev->hw, rtw_collect_sta_iter,
1c99f6652d3fbb Sascha Hauer 2022-05-18  144  					  &iter_data);
1c99f6652d3fbb Sascha Hauer 2022-05-18  145  
1c99f6652d3fbb Sascha Hauer 2022-05-18  146  	list_for_each_entry_safe(sta_entry, tmp, &iter_data.list,
1c99f6652d3fbb Sascha Hauer 2022-05-18  147  				 list) {
1c99f6652d3fbb Sascha Hauer 2022-05-18  148  		list_del_init(&sta_entry->list);
1c99f6652d3fbb Sascha Hauer 2022-05-18  149  		iterator(data, sta_entry->sta);
1c99f6652d3fbb Sascha Hauer 2022-05-18  150  		kfree(sta_entry);
1c99f6652d3fbb Sascha Hauer 2022-05-18  151  	}
1c99f6652d3fbb Sascha Hauer 2022-05-18  152  }
1c99f6652d3fbb Sascha Hauer 2022-05-18  153  
1c99f6652d3fbb Sascha Hauer 2022-05-18  154  struct rtw_vifs_entry {
1c99f6652d3fbb Sascha Hauer 2022-05-18  155  	struct list_head list;
1c99f6652d3fbb Sascha Hauer 2022-05-18  156  	struct ieee80211_vif *vif;
1c99f6652d3fbb Sascha Hauer 2022-05-18  157  	u8 mac[ETH_ALEN];
1c99f6652d3fbb Sascha Hauer 2022-05-18  158  };
1c99f6652d3fbb Sascha Hauer 2022-05-18  159  
1c99f6652d3fbb Sascha Hauer 2022-05-18  160  struct rtw_iter_vifs_data {
1c99f6652d3fbb Sascha Hauer 2022-05-18  161  	struct rtw_dev *rtwdev;
1c99f6652d3fbb Sascha Hauer 2022-05-18  162  	struct list_head list;
1c99f6652d3fbb Sascha Hauer 2022-05-18  163  };
1c99f6652d3fbb Sascha Hauer 2022-05-18  164  
1c99f6652d3fbb Sascha Hauer 2022-05-18 @165  void rtw_collect_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
1c99f6652d3fbb Sascha Hauer 2022-05-18  166  {
1c99f6652d3fbb Sascha Hauer 2022-05-18  167  	struct rtw_iter_vifs_data *iter_stas = data;
1c99f6652d3fbb Sascha Hauer 2022-05-18  168  	struct rtw_vifs_entry *vifs_entry;
1c99f6652d3fbb Sascha Hauer 2022-05-18  169  
1c99f6652d3fbb Sascha Hauer 2022-05-18  170  	vifs_entry = kmalloc(sizeof(*vifs_entry), GFP_ATOMIC);
1c99f6652d3fbb Sascha Hauer 2022-05-18  171  	if (!vifs_entry)
1c99f6652d3fbb Sascha Hauer 2022-05-18  172  		return;
1c99f6652d3fbb Sascha Hauer 2022-05-18  173  
1c99f6652d3fbb Sascha Hauer 2022-05-18  174  	vifs_entry->vif = vif;
1c99f6652d3fbb Sascha Hauer 2022-05-18  175  	ether_addr_copy(vifs_entry->mac, mac);
1c99f6652d3fbb Sascha Hauer 2022-05-18  176  	list_add_tail(&vifs_entry->list, &iter_stas->list);
1c99f6652d3fbb Sascha Hauer 2022-05-18  177  }
1c99f6652d3fbb Sascha Hauer 2022-05-18  178  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
