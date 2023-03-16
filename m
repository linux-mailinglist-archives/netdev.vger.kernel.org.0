Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6440A6BD5B4
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 17:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjCPQdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 12:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbjCPQdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 12:33:05 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0692E4C62;
        Thu, 16 Mar 2023 09:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678984374; x=1710520374;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=f3CiC2QaSsYUVd8b13hI0y9f5nq5N4yNeInHX5rBGGY=;
  b=ZUjZhOOc5UhlW+bNa/1w5driFIwRqWd7dIMf53hp4mqXjTMbJTpJ9c1T
   URc2PQ96Q2sgnZktJ7AjleZ+mmpJhc4cdiO4MEwlRFpOeHcHu2cNjCnyP
   FSAfuFjDyjKbjBghwU7vOXNKuAFhISWtrEx7wUHGyurUVKBRYi/Y82Djc
   JBik8fYCt2K4kuvTibtjLQYR1huuvJqWL0ZbPiKyv6cbm/M5EWonxxnQY
   Z4NKE6u5Da5z92wYUVzeoEbu5R/sltt986Oy9v0xOjw46lyaFTgi+VKu8
   9VSfabEZt/EkYl0SR2hnR0O5pQtro3VbU5Kp2y9MchGzze65Ds1FVvAyE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="338060669"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="338060669"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 09:31:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="854117073"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="854117073"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 16 Mar 2023 09:31:35 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pcqVr-0008d0-15;
        Thu, 16 Mar 2023 16:31:35 +0000
Date:   Fri, 17 Mar 2023 00:30:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     hildawu@realtek.com, marcel@holtmann.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, apusaka@chromium.org,
        mmandlik@google.com, yinghsu@chromium.org, max.chou@realtek.com,
        alex_lu@realsil.com.cn, kidman@realtek.com
Subject: Re: [PATCH] Bluetooth: msft: Extended monitor tracking by address
 filter
Message-ID: <202303170056.UsZ6RDV4-lkp@intel.com>
References: <20230316090729.14572-1-hildawu@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316090729.14572-1-hildawu@realtek.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bluetooth/master]
[also build test WARNING on bluetooth-next/master net-next/main net/main linus/master v6.3-rc2 next-20230316]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/hildawu-realtek-com/Bluetooth-msft-Extended-monitor-tracking-by-address-filter/20230316-170950
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git master
patch link:    https://lore.kernel.org/r/20230316090729.14572-1-hildawu%40realtek.com
patch subject: [PATCH] Bluetooth: msft: Extended monitor tracking by address filter
config: i386-randconfig-a016-20230313 (https://download.01.org/0day-ci/archive/20230317/202303170056.UsZ6RDV4-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/cee47af4605a9e5cba61be1ab1d92e8748d92e1e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review hildawu-realtek-com/Bluetooth-msft-Extended-monitor-tracking-by-address-filter/20230316-170950
        git checkout cee47af4605a9e5cba61be1ab1d92e8748d92e1e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/bluetooth/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303170056.UsZ6RDV4-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/bluetooth/msft.c:521:43: warning: variable 'rp' set but not used [-Wunused-but-set-variable]
           struct msft_rp_le_monitor_advertisement *rp;
                                                    ^
   1 warning generated.


vim +/rp +521 net/bluetooth/msft.c

   507	
   508	static int msft_add_monitor_sync(struct hci_dev *hdev,
   509					 struct adv_monitor *monitor)
   510	{
   511		struct msft_cp_le_monitor_advertisement *cp;
   512		struct msft_le_monitor_advertisement_pattern_data *pattern_data;
   513		struct msft_le_monitor_advertisement_pattern *pattern;
   514		struct adv_pattern *entry;
   515		size_t total_size = sizeof(*cp) + sizeof(*pattern_data);
   516		ptrdiff_t offset = 0;
   517		u8 pattern_count = 0;
   518		struct sk_buff *skb;
   519		int err;
   520		struct msft_monitor_advertisement_handle_data *handle_data;
 > 521		struct msft_rp_le_monitor_advertisement *rp;
   522	
   523		if (!msft_monitor_pattern_valid(monitor))
   524			return -EINVAL;
   525	
   526		list_for_each_entry(entry, &monitor->patterns, list) {
   527			pattern_count++;
   528			total_size += sizeof(*pattern) + entry->length;
   529		}
   530	
   531		cp = kmalloc(total_size, GFP_KERNEL);
   532		if (!cp)
   533			return -ENOMEM;
   534	
   535		cp->sub_opcode = MSFT_OP_LE_MONITOR_ADVERTISEMENT;
   536		cp->rssi_high = monitor->rssi.high_threshold;
   537		cp->rssi_low = monitor->rssi.low_threshold;
   538		cp->rssi_low_interval = (u8)monitor->rssi.low_threshold_timeout;
   539		cp->rssi_sampling_period = monitor->rssi.sampling_period;
   540	
   541		cp->cond_type = MSFT_MONITOR_ADVERTISEMENT_TYPE_PATTERN;
   542	
   543		pattern_data = (void *)cp->data;
   544		pattern_data->count = pattern_count;
   545	
   546		list_for_each_entry(entry, &monitor->patterns, list) {
   547			pattern = (void *)(pattern_data->data + offset);
   548			/* the length also includes data_type and offset */
   549			pattern->length = entry->length + 2;
   550			pattern->data_type = entry->ad_type;
   551			pattern->start_byte = entry->offset;
   552			memcpy(pattern->pattern, entry->value, entry->length);
   553			offset += sizeof(*pattern) + entry->length;
   554		}
   555	
   556		skb = __hci_cmd_sync(hdev, hdev->msft_opcode, total_size, cp,
   557				     HCI_CMD_TIMEOUT);
   558	
   559		if (IS_ERR_OR_NULL(skb)) {
   560			kfree(cp);
   561			return PTR_ERR(skb);
   562		}
   563	
   564		err = msft_le_monitor_advertisement_cb(hdev, hdev->msft_opcode,
   565						       monitor, skb);
   566		if (!err) {
   567			rp = (struct msft_rp_le_monitor_advertisement *)skb->data;
   568			handle_data = msft_find_handle_data(hdev, monitor->handle,
   569							    true);
   570			if (handle_data) {
   571				handle_data->rssi_high   = cp->rssi_high;
   572				handle_data->rssi_low    = cp->rssi_low;
   573				handle_data->rssi_low_interval    =
   574							cp->rssi_low_interval;
   575				handle_data->rssi_sampling_period =
   576							cp->rssi_sampling_period;
   577			}
   578		}
   579		kfree(cp);
   580	
   581		return err;
   582	}
   583	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
