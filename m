Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD675915DF
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 21:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbiHLTVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 15:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbiHLTVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 15:21:01 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8CF26ADA;
        Fri, 12 Aug 2022 12:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660332059; x=1691868059;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=X86N0nV9+nnd+RlOJabsYI8N21x/2z/Ujtbmr0Rz6VU=;
  b=SdW7SZJSv8aZdPBLIy012/uwAXbGP8shXfI3+FD7pmWMZKj8O3zptgib
   viLM1Cs0bF8PsvmeYw0A0NVurNFWfy28p9Q/ozQOWqRCaG01HqHdRpPww
   cLSlDD1o1ZsJUkJavYiV4IzE7uOTmxhUwBmq250CKrJD+b0TY8Vc5Vs9H
   5EV566e9e0pjvRM4mcd5rduzQz2WDH+QOzxDtT+IerZnt+NGTtAxdo5d/
   nvm6jVN8zVMkepsA5mkuxtMpHXs0D+pWINmSeKZE5x0hAIl9UsZgYAEq2
   JrMgQ+2cTpF+PzS7BH2IEN7KlgOnVNjLcqrkLgw5FMJT3zaqgtsF+fuYV
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10437"; a="353414115"
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="353414115"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 12:20:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="695368011"
Received: from lkp-server02.sh.intel.com (HELO 8745164cafc7) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Aug 2022 12:20:53 -0700
Received: from kbuild by 8745164cafc7 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oMaDE-0000r5-1F;
        Fri, 12 Aug 2022 19:20:52 +0000
Date:   Sat, 13 Aug 2022 03:19:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     Manish Mandlik <mmandlik@google.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Johannes Berg <johannes@sipsolutions.net>,
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
Message-ID: <202208130346.2UmF05bO-lkp@intel.com>
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
config: x86_64-randconfig-a003 (https://download.01.org/0day-ci/archive/20220813/202208130346.2UmF05bO-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 5f1c7e2cc5a3c07cbc2412e851a7283c1841f520)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/6fe2192077ebdca91aef91e907f79d9e38960a21
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Manish-Mandlik/sysfs-Add-attribute-info-for-sys-devices-coredump_disabled/20220811-000313
        git checkout 6fe2192077ebdca91aef91e907f79d9e38960a21
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash net/bluetooth/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/bluetooth/coredump.c:301:20: warning: format specifies type 'unsigned int' but the argument has type 'size_t' (aka 'unsigned long') [-Wformat]
                                       dump_size, hdev->dump.alloc_size);
                                                  ^~~~~~~~~~~~~~~~~~~~~
   include/net/bluetooth/bluetooth.h:255:43: note: expanded from macro 'bt_dev_info'
           BT_INFO("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
                          ~~~                       ^~~~~~~~~~~
   include/net/bluetooth/bluetooth.h:242:47: note: expanded from macro 'BT_INFO'
   #define BT_INFO(fmt, ...)       bt_info(fmt "\n", ##__VA_ARGS__)
                                           ~~~         ^~~~~~~~~~~
   net/bluetooth/coredump.c:320:20: warning: format specifies type 'unsigned int' but the argument has type 'size_t' (aka 'unsigned long') [-Wformat]
                                       dump_size, hdev->dump.alloc_size);
                                                  ^~~~~~~~~~~~~~~~~~~~~
   include/net/bluetooth/bluetooth.h:255:43: note: expanded from macro 'bt_dev_info'
           BT_INFO("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
                          ~~~                       ^~~~~~~~~~~
   include/net/bluetooth/bluetooth.h:242:47: note: expanded from macro 'BT_INFO'
   #define BT_INFO(fmt, ...)       bt_info(fmt "\n", ##__VA_ARGS__)
                                           ~~~         ^~~~~~~~~~~
   net/bluetooth/coredump.c:365:18: warning: format specifies type 'unsigned int' but the argument has type 'size_t' (aka 'unsigned long') [-Wformat]
                       dump_size, hdev->dump.alloc_size);
                                  ^~~~~~~~~~~~~~~~~~~~~
   include/net/bluetooth/bluetooth.h:255:43: note: expanded from macro 'bt_dev_info'
           BT_INFO("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
                          ~~~                       ^~~~~~~~~~~
   include/net/bluetooth/bluetooth.h:242:47: note: expanded from macro 'BT_INFO'
   #define BT_INFO(fmt, ...)       bt_info(fmt "\n", ##__VA_ARGS__)
                                           ~~~         ^~~~~~~~~~~
   3 warnings generated.


vim +301 net/bluetooth/coredump.c

   182	
   183	/* Bluetooth devcoredump state machine.
   184	 *
   185	 * Devcoredump states:
   186	 *
   187	 *      HCI_DEVCOREDUMP_IDLE: The default state.
   188	 *
   189	 *      HCI_DEVCOREDUMP_ACTIVE: A devcoredump will be in this state once it has
   190	 *              been initialized using hci_devcoredump_init(). Once active, the
   191	 *              driver can append data using hci_devcoredump_append() or insert
   192	 *              a pattern using hci_devcoredump_append_pattern().
   193	 *
   194	 *      HCI_DEVCOREDUMP_DONE: Once the dump collection is complete, the drive
   195	 *              can signal the completion using hci_devcoredump_complete(). A
   196	 *              devcoredump is generated indicating the completion event and
   197	 *              then the state machine is reset to the default state.
   198	 *
   199	 *      HCI_DEVCOREDUMP_ABORT: The driver can cancel ongoing dump collection in
   200	 *              case of any error using hci_devcoredump_abort(). A devcoredump
   201	 *              is still generated with the available data indicating the abort
   202	 *              event and then the state machine is reset to the default state.
   203	 *
   204	 *      HCI_DEVCOREDUMP_TIMEOUT: A timeout timer for HCI_DEVCOREDUMP_TIMEOUT sec
   205	 *              is started during devcoredump initialization. Once the timeout
   206	 *              occurs, the driver is notified, a devcoredump is generated with
   207	 *              the available data indicating the timeout event and then the
   208	 *              state machine is reset to the default state.
   209	 *
   210	 * The driver must register using hci_devcoredump_register() before using the
   211	 * hci devcoredump APIs.
   212	 */
   213	void hci_devcoredump_rx(struct work_struct *work)
   214	{
   215		struct hci_dev *hdev = container_of(work, struct hci_dev, dump.dump_rx);
   216		struct sk_buff *skb;
   217		struct hci_devcoredump_skb_pattern *pattern;
   218		u32 dump_size;
   219		int start_state;
   220	
   221	#define DBG_UNEXPECTED_STATE() \
   222			bt_dev_dbg(hdev, \
   223				   "Unexpected packet (%d) for state (%d). ", \
   224				   hci_dmp_cb(skb)->pkt_type, hdev->dump.state)
   225	
   226		while ((skb = skb_dequeue(&hdev->dump.dump_q))) {
   227			hci_dev_lock(hdev);
   228			start_state = hdev->dump.state;
   229	
   230			switch (hci_dmp_cb(skb)->pkt_type) {
   231			case HCI_DEVCOREDUMP_PKT_INIT:
   232				if (hdev->dump.state != HCI_DEVCOREDUMP_IDLE) {
   233					DBG_UNEXPECTED_STATE();
   234					goto loop_continue;
   235				}
   236	
   237				if (skb->len != sizeof(dump_size)) {
   238					bt_dev_dbg(hdev, "Invalid dump init pkt");
   239					goto loop_continue;
   240				}
   241	
   242				dump_size = *((u32 *)skb->data);
   243				if (!dump_size) {
   244					bt_dev_err(hdev, "Zero size dump init pkt");
   245					goto loop_continue;
   246				}
   247	
   248				if (hci_devcoredump_prepare(hdev, dump_size)) {
   249					bt_dev_err(hdev, "Failed to prepare for dump");
   250					goto loop_continue;
   251				}
   252	
   253				hci_devcoredump_update_state(hdev,
   254							     HCI_DEVCOREDUMP_ACTIVE);
   255				queue_delayed_work(hdev->workqueue,
   256						   &hdev->dump.dump_timeout,
   257						   DEVCOREDUMP_TIMEOUT);
   258				break;
   259	
   260			case HCI_DEVCOREDUMP_PKT_SKB:
   261				if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
   262					DBG_UNEXPECTED_STATE();
   263					goto loop_continue;
   264				}
   265	
   266				if (!hci_devcoredump_copy(hdev, skb->data, skb->len))
   267					bt_dev_dbg(hdev, "Failed to insert skb");
   268				break;
   269	
   270			case HCI_DEVCOREDUMP_PKT_PATTERN:
   271				if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
   272					DBG_UNEXPECTED_STATE();
   273					goto loop_continue;
   274				}
   275	
   276				if (skb->len != sizeof(*pattern)) {
   277					bt_dev_dbg(hdev, "Invalid pattern skb");
   278					goto loop_continue;
   279				}
   280	
   281				pattern = (void *)skb->data;
   282	
   283				if (!hci_devcoredump_memset(hdev, pattern->pattern,
   284							    pattern->len))
   285					bt_dev_dbg(hdev, "Failed to set pattern");
   286				break;
   287	
   288			case HCI_DEVCOREDUMP_PKT_COMPLETE:
   289				if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
   290					DBG_UNEXPECTED_STATE();
   291					goto loop_continue;
   292				}
   293	
   294				hci_devcoredump_update_state(hdev,
   295							     HCI_DEVCOREDUMP_DONE);
   296				dump_size = hdev->dump.tail - hdev->dump.head;
   297	
   298				bt_dev_info(hdev,
   299					    "Devcoredump complete with size %u "
   300					    "(expect %u)",
 > 301					    dump_size, hdev->dump.alloc_size);
   302	
   303				dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size,
   304					      GFP_KERNEL);
   305				break;
   306	
   307			case HCI_DEVCOREDUMP_PKT_ABORT:
   308				if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
   309					DBG_UNEXPECTED_STATE();
   310					goto loop_continue;
   311				}
   312	
   313				hci_devcoredump_update_state(hdev,
   314							     HCI_DEVCOREDUMP_ABORT);
   315				dump_size = hdev->dump.tail - hdev->dump.head;
   316	
   317				bt_dev_info(hdev,
   318					    "Devcoredump aborted with size %u "
   319					    "(expect %u)",
   320					    dump_size, hdev->dump.alloc_size);
   321	
   322				/* Emit a devcoredump with the available data */
   323				dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size,
   324					      GFP_KERNEL);
   325				break;
   326	
   327			default:
   328				bt_dev_dbg(hdev,
   329					   "Unknown packet (%d) for state (%d). ",
   330					   hci_dmp_cb(skb)->pkt_type, hdev->dump.state);
   331				break;
   332			}
   333	
   334	loop_continue:
   335			kfree_skb(skb);
   336			hci_dev_unlock(hdev);
   337	
   338			if (start_state != hdev->dump.state)
   339				hci_devcoredump_notify(hdev, hdev->dump.state);
   340	
   341			hci_dev_lock(hdev);
   342			if (hdev->dump.state == HCI_DEVCOREDUMP_DONE ||
   343			    hdev->dump.state == HCI_DEVCOREDUMP_ABORT)
   344				hci_devcoredump_reset(hdev);
   345			hci_dev_unlock(hdev);
   346		}
   347	}
   348	EXPORT_SYMBOL(hci_devcoredump_rx);
   349	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
