Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D6E5915B6
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 21:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239139AbiHLTAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 15:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238125AbiHLS77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 14:59:59 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D594E792C3;
        Fri, 12 Aug 2022 11:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660330797; x=1691866797;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4Ow1W24xlj9rqqWThweUCQ6rtXxfqSuZQ7o+V2zW394=;
  b=geHbo7czP3E1deKqquocTkOiLa4hYQC7VyL2sd5rRLrGcjSuWPcZRZd5
   x1neq6P0K68MqRps0UiaNXpbjEiwHWk9DNI1Imv8cNz1207nNBvApQp24
   5dmq8MIslc3JX30eX6i57qXREe+jCfhlVlomFIlQIsc6AZbRKiKvC/iDP
   8dwltM9J1iAQD1SDwwamHr515TpenV1jUO4fgno9S9JQzwbsV/FMHEN2V
   kz3ysRUHlJoZ4omjRf6JXcL9R58TktaPyA3OVBiSttsBmLCHCCg8xiFJP
   iJ+Ga+VWyBQNBf/4xxPcyByAUy/R+gUM2eEYg6w0XT4w15kcPsoqz32pp
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10437"; a="292934092"
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="292934092"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 11:59:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="695362258"
Received: from lkp-server02.sh.intel.com (HELO 8745164cafc7) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Aug 2022 11:59:52 -0700
Received: from kbuild by 8745164cafc7 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oMZsu-0000qF-01;
        Fri, 12 Aug 2022 18:59:52 +0000
Date:   Sat, 13 Aug 2022 02:59:20 +0800
From:   kernel test robot <lkp@intel.com>
To:     Manish Mandlik <mmandlik@google.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     kbuild-all@lists.01.org, Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Signed-off-by : Manish Mandlik" <mmandlik@google.com>,
        linux-bluetooth@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        chromeos-bluetooth-upstreaming@chromium.org,
        Won Chung <wonchung@google.com>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v5 3/5] Bluetooth: Add support for hci devcoredump
Message-ID: <202208130238.wyNvbcE7-lkp@intel.com>
References: <20220810085753.v5.3.Iaf638bb9f885f5880ab1b4e7ae2f73dd53a54661@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810085753.v5.3.Iaf638bb9f885f5880ab1b4e7ae2f73dd53a54661@changeid>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bluetooth/master]
[also build test WARNING on bluetooth-next/master driver-core/driver-core-testing linus/master next-20220812]
[cannot apply to v5.19]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Manish-Mandlik/sysfs-Add-attribute-info-for-sys-devices-coredump_disabled/20220811-000313
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git master
config: loongarch-randconfig-r022-20220811 (https://download.01.org/0day-ci/archive/20220813/202208130238.wyNvbcE7-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/6fe2192077ebdca91aef91e907f79d9e38960a21
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Manish-Mandlik/sysfs-Add-attribute-info-for-sys-devices-coredump_disabled/20220811-000313
        git checkout 6fe2192077ebdca91aef91e907f79d9e38960a21
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch SHELL=/bin/bash net/bluetooth/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from net/bluetooth/coredump.c:8:
   net/bluetooth/coredump.c: In function 'hci_devcoredump_rx':
>> include/net/bluetooth/bluetooth.h:255:17: warning: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'size_t' {aka 'long unsigned int'} [-Wformat=]
     255 |         BT_INFO("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
         |                 ^~~~~~
   include/net/bluetooth/bluetooth.h:242:41: note: in definition of macro 'BT_INFO'
     242 | #define BT_INFO(fmt, ...)       bt_info(fmt "\n", ##__VA_ARGS__)
         |                                         ^~~
   net/bluetooth/coredump.c:298:25: note: in expansion of macro 'bt_dev_info'
     298 |                         bt_dev_info(hdev,
         |                         ^~~~~~~~~~~
>> include/net/bluetooth/bluetooth.h:255:17: warning: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'size_t' {aka 'long unsigned int'} [-Wformat=]
     255 |         BT_INFO("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
         |                 ^~~~~~
   include/net/bluetooth/bluetooth.h:242:41: note: in definition of macro 'BT_INFO'
     242 | #define BT_INFO(fmt, ...)       bt_info(fmt "\n", ##__VA_ARGS__)
         |                                         ^~~
   net/bluetooth/coredump.c:317:25: note: in expansion of macro 'bt_dev_info'
     317 |                         bt_dev_info(hdev,
         |                         ^~~~~~~~~~~
   net/bluetooth/coredump.c: In function 'hci_devcoredump_timeout':
>> include/net/bluetooth/bluetooth.h:255:17: warning: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'size_t' {aka 'long unsigned int'} [-Wformat=]
     255 |         BT_INFO("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
         |                 ^~~~~~
   include/net/bluetooth/bluetooth.h:242:41: note: in definition of macro 'BT_INFO'
     242 | #define BT_INFO(fmt, ...)       bt_info(fmt "\n", ##__VA_ARGS__)
         |                                         ^~~
   net/bluetooth/coredump.c:364:9: note: in expansion of macro 'bt_dev_info'
     364 |         bt_dev_info(hdev, "Devcoredump timeout with size %u (expect %u)",
         |         ^~~~~~~~~~~


vim +255 include/net/bluetooth/bluetooth.h

9b392e0e0b6d02 Luiz Augusto von Dentz 2022-03-03  253  
6f558b70fb39fc Loic Poulain           2015-08-30  254  #define bt_dev_info(hdev, fmt, ...)				\
9b392e0e0b6d02 Luiz Augusto von Dentz 2022-03-03 @255  	BT_INFO("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
594b31ea7dc610 Frederic Danis         2015-09-23  256  #define bt_dev_warn(hdev, fmt, ...)				\
9b392e0e0b6d02 Luiz Augusto von Dentz 2022-03-03  257  	BT_WARN("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
6f558b70fb39fc Loic Poulain           2015-08-30  258  #define bt_dev_err(hdev, fmt, ...)				\
9b392e0e0b6d02 Luiz Augusto von Dentz 2022-03-03  259  	BT_ERR("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
6f558b70fb39fc Loic Poulain           2015-08-30  260  #define bt_dev_dbg(hdev, fmt, ...)				\
9b392e0e0b6d02 Luiz Augusto von Dentz 2022-03-03  261  	BT_DBG("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
6f558b70fb39fc Loic Poulain           2015-08-30  262  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
