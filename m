Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C4E6CB510
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 05:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbjC1Drx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 23:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjC1Drw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 23:47:52 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033ABB5;
        Mon, 27 Mar 2023 20:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679975271; x=1711511271;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=laGA85k+Kf/WqioNRDgrAcWIOYhv10Jf0ZFrkxiLn5c=;
  b=KUy1UVTVS4zvVHQx48Qg4uSMZ9+IeMLP553SLpn7W1FX+XHOPjG/jdF0
   n/7gWKTHJBqUQhSAe+2q7fY+cUf7oOTCY6izPFt3XlmdeEp3CjlZULITb
   PyrD+WgZLp1KKaHZFEipgS+Q3SdDtwsEF5c2SY+2gcodOLmoMne+Ig37n
   bUWpabVNJSKtS+5IVemVrucyjwYUwOT+FQeP6zM8I5Hy4FFbaduoBH8Qy
   CdBu6jsPxQVKClrYXbPJ5qeRu2cxOiYZgHzZfsqnRIgZej1LwRTLJGhTY
   tXdGze6TNv1mL1hFuRha3Swmv82WUPev5v5T08sKWQN6d/gbYSfNUbUP0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="339185961"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="339185961"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 20:47:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="772976612"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="772976612"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Mar 2023 20:47:47 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1ph0JG-000IFw-30;
        Tue, 28 Mar 2023 03:47:46 +0000
Date:   Tue, 28 Mar 2023 11:46:56 +0800
From:   kernel test robot <lkp@intel.com>
To:     Manish Mandlik <mmandlik@google.com>, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     oe-kbuild-all@lists.linux.dev,
        chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Manish Mandlik <mmandlik@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v9 1/4] Bluetooth: Add support for hci devcoredump
Message-ID: <202303281102.Wu5F8pYw-lkp@intel.com>
References: <20230327181825.v9.1.I9b4e4818bab450657b19cda3497d363c9baa616e@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327181825.v9.1.I9b4e4818bab450657b19cda3497d363c9baa616e@changeid>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bluetooth/master]
[also build test WARNING on bluetooth-next/master linus/master v6.3-rc4 next-20230327]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Manish-Mandlik/Bluetooth-Add-vhci-devcoredump-support/20230328-092008
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git master
patch link:    https://lore.kernel.org/r/20230327181825.v9.1.I9b4e4818bab450657b19cda3497d363c9baa616e%40changeid
patch subject: [PATCH v9 1/4] Bluetooth: Add support for hci devcoredump
config: loongarch-allyesconfig (https://download.01.org/0day-ci/archive/20230328/202303281102.Wu5F8pYw-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/40f9e7a85c5d41006c8a1b416c6e283ba4035aeb
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Manish-Mandlik/Bluetooth-Add-vhci-devcoredump-support/20230328-092008
        git checkout 40f9e7a85c5d41006c8a1b416c6e283ba4035aeb
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch SHELL=/bin/bash net/bluetooth/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303281102.Wu5F8pYw-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/bluetooth/coredump.c:181:6: warning: no previous prototype for 'hci_devcd_handle_pkt_init' [-Wmissing-prototypes]
     181 | void hci_devcd_handle_pkt_init(struct hci_dev *hdev, struct sk_buff *skb)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~
>> net/bluetooth/coredump.c:211:6: warning: no previous prototype for 'hci_devcd_handle_pkt_skb' [-Wmissing-prototypes]
     211 | void hci_devcd_handle_pkt_skb(struct hci_dev *hdev, struct sk_buff *skb)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~
>> net/bluetooth/coredump.c:222:6: warning: no previous prototype for 'hci_devcd_handle_pkt_pattern' [-Wmissing-prototypes]
     222 | void hci_devcd_handle_pkt_pattern(struct hci_dev *hdev, struct sk_buff *skb)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> net/bluetooth/coredump.c:242:6: warning: no previous prototype for 'hci_devcd_handle_pkt_complete' [-Wmissing-prototypes]
     242 | void hci_devcd_handle_pkt_complete(struct hci_dev *hdev, struct sk_buff *skb)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> net/bluetooth/coredump.c:260:6: warning: no previous prototype for 'hci_devcd_handle_pkt_abort' [-Wmissing-prototypes]
     260 | void hci_devcd_handle_pkt_abort(struct hci_dev *hdev, struct sk_buff *skb)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/hci_devcd_handle_pkt_init +181 net/bluetooth/coredump.c

   180	
 > 181	void hci_devcd_handle_pkt_init(struct hci_dev *hdev, struct sk_buff *skb)
   182	{
   183		u32 *dump_size;
   184	
   185		if (hdev->dump.state != HCI_DEVCOREDUMP_IDLE) {
   186			DBG_UNEXPECTED_STATE();
   187			return;
   188		}
   189	
   190		if (skb->len != sizeof(*dump_size)) {
   191			bt_dev_dbg(hdev, "Invalid dump init pkt");
   192			return;
   193		}
   194	
   195		dump_size = skb_pull_data(skb, sizeof(*dump_size));
   196		if (!*dump_size) {
   197			bt_dev_err(hdev, "Zero size dump init pkt");
   198			return;
   199		}
   200	
   201		if (hci_devcd_prepare(hdev, *dump_size)) {
   202			bt_dev_err(hdev, "Failed to prepare for dump");
   203			return;
   204		}
   205	
   206		hci_devcd_update_state(hdev, HCI_DEVCOREDUMP_ACTIVE);
   207		queue_delayed_work(hdev->workqueue, &hdev->dump.dump_timeout,
   208				   DEVCOREDUMP_TIMEOUT);
   209	}
   210	
 > 211	void hci_devcd_handle_pkt_skb(struct hci_dev *hdev, struct sk_buff *skb)
   212	{
   213		if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
   214			DBG_UNEXPECTED_STATE();
   215			return;
   216		}
   217	
   218		if (!hci_devcd_copy(hdev, skb->data, skb->len))
   219			bt_dev_dbg(hdev, "Failed to insert skb");
   220	}
   221	
 > 222	void hci_devcd_handle_pkt_pattern(struct hci_dev *hdev, struct sk_buff *skb)
   223	{
   224		struct hci_devcoredump_skb_pattern *pattern;
   225	
   226		if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
   227			DBG_UNEXPECTED_STATE();
   228			return;
   229		}
   230	
   231		if (skb->len != sizeof(*pattern)) {
   232			bt_dev_dbg(hdev, "Invalid pattern skb");
   233			return;
   234		}
   235	
   236		pattern = skb_pull_data(skb, sizeof(*pattern));;
   237	
   238		if (!hci_devcd_memset(hdev, pattern->pattern, pattern->len))
   239			bt_dev_dbg(hdev, "Failed to set pattern");
   240	}
   241	
 > 242	void hci_devcd_handle_pkt_complete(struct hci_dev *hdev, struct sk_buff *skb)
   243	{
   244		u32 dump_size;
   245	
   246		if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
   247			DBG_UNEXPECTED_STATE();
   248			return;
   249		}
   250	
   251		hci_devcd_update_state(hdev, HCI_DEVCOREDUMP_DONE);
   252		dump_size = hdev->dump.tail - hdev->dump.head;
   253	
   254		bt_dev_info(hdev, "Devcoredump complete with size %u (expect %zu)",
   255			    dump_size, hdev->dump.alloc_size);
   256	
   257		dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size, GFP_KERNEL);
   258	}
   259	
 > 260	void hci_devcd_handle_pkt_abort(struct hci_dev *hdev, struct sk_buff *skb)
   261	{
   262		u32 dump_size;
   263	
   264		if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
   265			DBG_UNEXPECTED_STATE();
   266			return;
   267		}
   268	
   269		hci_devcd_update_state(hdev, HCI_DEVCOREDUMP_ABORT);
   270		dump_size = hdev->dump.tail - hdev->dump.head;
   271	
   272		bt_dev_info(hdev, "Devcoredump aborted with size %u (expect %zu)",
   273			    dump_size, hdev->dump.alloc_size);
   274	
   275		/* Emit a devcoredump with the available data */
   276		dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size, GFP_KERNEL);
   277	}
   278	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
