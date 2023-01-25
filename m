Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842B867A7ED
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 01:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbjAYAoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 19:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjAYAoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 19:44:37 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCFF37F38;
        Tue, 24 Jan 2023 16:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674607473; x=1706143473;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QM2+POLX0q7xcehfBUAPRbRSsX9KORGrbBZHP2QA5B4=;
  b=O4GwL7D/ILhQO5gWJIRepYIt246TNpqi36W31B9FgeoxDuFx+G+LQDaK
   kQDHEI42L5ztwWWZlJxwq3r5X9Jc8wjXZ2IRxxUBZ3Z6DSNTxuwwTn4DM
   V1TNoG9jPxpBZGdqNvbFPYr0fjxAOCVts5+igtb8iSrlEHhQa+ErkLIoC
   xldLJow1OED4wLXtC7cLaa+tZBt8yDTtoRpmqZx7H4xhaD/AxqXDh0UGJ
   VyjIVyj7Q4//PJIOa0+OZR48jak5qvk4Jd/0GiJcOoxMGf3vlJ0mRACP0
   GBprQ2+wXfjzoEQJzSozrmPZ1Y7lKcXd3d8x17kfg6VQVDou2ejW2gLPv
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="412684651"
X-IronPort-AV: E=Sophos;i="5.97,243,1669104000"; 
   d="scan'208";a="412684651"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 16:44:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="804816336"
X-IronPort-AV: E=Sophos;i="5.97,243,1669104000"; 
   d="scan'208";a="804816336"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 24 Jan 2023 16:44:28 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pKTtr-0006uW-1S;
        Wed, 25 Jan 2023 00:44:27 +0000
Date:   Wed, 25 Jan 2023 08:44:22 +0800
From:   kernel test robot <lkp@intel.com>
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-serial@vger.kernel.org,
        amitkumar.karwar@nxp.com, rohit.fule@nxp.com, sherry.sun@nxp.com,
        neeraj.sanjaykale@nxp.com
Subject: Re: [PATCH v1 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Message-ID: <202301250824.iVWBIZts-lkp@intel.com>
References: <20230124174714.2775680-4-neeraj.sanjaykale@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124174714.2775680-4-neeraj.sanjaykale@nxp.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Neeraj,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bluetooth-next/master]
[also build test WARNING on bluetooth/master tty/tty-testing tty/tty-next tty/tty-linus linus/master v6.2-rc5 next-20230124]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Neeraj-Sanjay-Kale/serdev-Add-method-to-assert-break/20230125-015108
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git master
patch link:    https://lore.kernel.org/r/20230124174714.2775680-4-neeraj.sanjaykale%40nxp.com
patch subject: [PATCH v1 3/3] Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets
config: sparc-allyesconfig (https://download.01.org/0day-ci/archive/20230125/202301250824.iVWBIZts-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/e5f775c45ec84de38a4cadfb115c488cb44e5943
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Neeraj-Sanjay-Kale/serdev-Add-method-to-assert-break/20230125-015108
        git checkout e5f775c45ec84de38a4cadfb115c488cb44e5943
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc SHELL=/bin/bash drivers/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/bluetooth/btnxp.c: In function 'nxp_load_fw_params_for_chip_id':
>> drivers/bluetooth/btnxp.c:439:25: warning: 'strncpy' specified bound 50 equals destination size [-Wstringop-truncation]
     439 |                         strncpy(nxpdev->fw_name, fw_mod_params[i].fw_name, MAX_FW_FILE_NAME_LEN);
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/strncpy +439 drivers/bluetooth/btnxp.c

   431	
   432	static int nxp_load_fw_params_for_chip_id(u16 chip_id, struct hci_dev *hdev)
   433	{
   434		struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
   435		int i;
   436	
   437		for (i = 0; i < MAX_NO_OF_CHIPS_SUPPORT; i++) {
   438			if (chip_id == fw_mod_params[i].chip_id) {
 > 439				strncpy(nxpdev->fw_name, fw_mod_params[i].fw_name, MAX_FW_FILE_NAME_LEN);
   440				nxpdev->oper_speed = fw_mod_params[i].oper_speed;
   441				nxpdev->fw_dnld_pri_baudrate = fw_mod_params[i].fw_dnld_pri_baudrate;
   442				nxpdev->fw_dnld_sec_baudrate = fw_mod_params[i].fw_dnld_sec_baudrate;
   443				nxpdev->fw_init_baudrate = fw_mod_params[i].fw_init_baudrate;
   444				break;
   445			}
   446		}
   447		if (i == MAX_NO_OF_CHIPS_SUPPORT) {
   448			if (chip_id == 0xffff)
   449				BT_ERR("%s does not contain entry for 'legacy_chip'", BT_FW_CONF_FILE);
   450			else
   451				BT_ERR("Unsupported chip signature: %04X", chip_id);
   452			clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
   453			return -ENOENT;
   454		}
   455		return 0;
   456	}
   457	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
