Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1B16BF78E
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 04:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjCRDci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 23:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjCRDcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 23:32:36 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9803F3E1E5;
        Fri, 17 Mar 2023 20:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679110354; x=1710646354;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/34gP1m3GUDw/lE35+PjvOtPorw7XhDAvcNT/mG0n4E=;
  b=AEuDkNJqPXu1tyrCIhYf757pRsc6JEVZ749lUT7/DWkNgBlaz+6azR3M
   p2ULNfhgIaqLCzuYsCNoSkYmRNkcNmHJOKZxIQgLFeQ8MmmBEukLvsJsK
   K9C3QaPUQBX9hSB64rjD2GNoWbzefxiIv+rDkyCF2mX85ezX8HMEIsvqG
   97glDz+fWZXxAWqKUKjND2L6t9r8mZAWLEu2dDankY+BHxGz09D1pyLHv
   kY5NncplALWWYeZq1XKnVg/AuW6xxuZBhsLH8xqxZBCR5od5c2mVMs7pm
   7+JQtkCgB+wjceLZm1ly7dzXlwklA9obYsEG8jCT4/FHCfU4wQy3EeDnG
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="318059238"
X-IronPort-AV: E=Sophos;i="5.98,270,1673942400"; 
   d="scan'208";a="318059238"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 20:32:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="804325816"
X-IronPort-AV: E=Sophos;i="5.98,270,1673942400"; 
   d="scan'208";a="804325816"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 17 Mar 2023 20:32:30 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pdNJ0-0009m1-0T;
        Sat, 18 Mar 2023 03:32:30 +0000
Date:   Sat, 18 Mar 2023 11:32:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Szymon Heidrich <szymon.heidrich@gmail.com>,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com
Cc:     oe-kbuild-all@lists.linux.dev, pabeni@redhat.com,
        szymon.heidrich@gmail.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2] net: usb: lan78xx: Limit packet length to skb->len
Message-ID: <202303181127.Phif6jvW-lkp@intel.com>
References: <20230317173606.91426-1-szymon.heidrich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317173606.91426-1-szymon.heidrich@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Szymon,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/main]
[also build test WARNING on net/main linus/master v6.3-rc2 next-20230317]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Szymon-Heidrich/net-usb-lan78xx-Limit-packet-length-to-skb-len/20230318-013659
patch link:    https://lore.kernel.org/r/20230317173606.91426-1-szymon.heidrich%40gmail.com
patch subject: [PATCH v2] net: usb: lan78xx: Limit packet length to skb->len
config: i386-randconfig-a005 (https://download.01.org/0day-ci/archive/20230318/202303181127.Phif6jvW-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/17c060ef752f4a1366ed7d8e62ba5f64f654eced
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Szymon-Heidrich/net-usb-lan78xx-Limit-packet-length-to-skb-len/20230318-013659
        git checkout 17c060ef752f4a1366ed7d8e62ba5f64f654eced
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 olddefconfig
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/usb/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303181127.Phif6jvW-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/net/usb/lan78xx.c: In function 'lan78xx_rx':
>> drivers/net/usb/lan78xx.c:3603:25: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
    3603 |                         struct sk_buff *skb2;
         |                         ^~~~~~


vim +3603 drivers/net/usb/lan78xx.c

55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3552  
ec4c7e12396b1a John Efstathiades         2021-11-18  3553  static int lan78xx_rx(struct lan78xx_net *dev, struct sk_buff *skb,
ec4c7e12396b1a John Efstathiades         2021-11-18  3554  		      int budget, int *work_done)
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3555  {
0dd87266c1337d John Efstathiades         2021-11-18  3556  	if (skb->len < RX_SKB_MIN_LEN)
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3557  		return 0;
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3558  
ec4c7e12396b1a John Efstathiades         2021-11-18  3559  	/* Extract frames from the URB buffer and pass each one to
ec4c7e12396b1a John Efstathiades         2021-11-18  3560  	 * the stack in a new NAPI SKB.
ec4c7e12396b1a John Efstathiades         2021-11-18  3561  	 */
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3562  	while (skb->len > 0) {
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3563  		u32 rx_cmd_a, rx_cmd_b, align_count, size;
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3564  		u16 rx_cmd_c;
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3565  		unsigned char *packet;
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3566  
bb448f8a60ea93 Chuhong Yuan              2019-07-19  3567  		rx_cmd_a = get_unaligned_le32(skb->data);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3568  		skb_pull(skb, sizeof(rx_cmd_a));
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3569  
bb448f8a60ea93 Chuhong Yuan              2019-07-19  3570  		rx_cmd_b = get_unaligned_le32(skb->data);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3571  		skb_pull(skb, sizeof(rx_cmd_b));
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3572  
bb448f8a60ea93 Chuhong Yuan              2019-07-19  3573  		rx_cmd_c = get_unaligned_le16(skb->data);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3574  		skb_pull(skb, sizeof(rx_cmd_c));
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3575  
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3576  		packet = skb->data;
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3577  
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3578  		/* get the packet length */
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3579  		size = (rx_cmd_a & RX_CMD_A_LEN_MASK_);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3580  		align_count = (4 - ((size + RXW_PADDING) % 4)) % 4;
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3581  
17c060ef752f4a Szymon Heidrich           2023-03-17  3582  		if (unlikely(size > skb->len)) {
17c060ef752f4a Szymon Heidrich           2023-03-17  3583  			netif_dbg(dev, rx_err, dev->net,
17c060ef752f4a Szymon Heidrich           2023-03-17  3584  				  "size err rx_cmd_a=0x%08x\n",
17c060ef752f4a Szymon Heidrich           2023-03-17  3585  				  rx_cmd_a);
17c060ef752f4a Szymon Heidrich           2023-03-17  3586  			return 0;
17c060ef752f4a Szymon Heidrich           2023-03-17  3587  		}
17c060ef752f4a Szymon Heidrich           2023-03-17  3588  
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3589  		if (unlikely(rx_cmd_a & RX_CMD_A_RED_)) {
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3590  			netif_dbg(dev, rx_err, dev->net,
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3591  				  "Error rx_cmd_a=0x%08x", rx_cmd_a);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3592  		} else {
17c060ef752f4a Szymon Heidrich           2023-03-17  3593  			u32 frame_len;
17c060ef752f4a Szymon Heidrich           2023-03-17  3594  
17c060ef752f4a Szymon Heidrich           2023-03-17  3595  			if (unlikely(size < ETH_FCS_LEN)) {
17c060ef752f4a Szymon Heidrich           2023-03-17  3596  				netif_dbg(dev, rx_err, dev->net,
17c060ef752f4a Szymon Heidrich           2023-03-17  3597  					  "size err rx_cmd_a=0x%08x\n",
17c060ef752f4a Szymon Heidrich           2023-03-17  3598  					  rx_cmd_a);
17c060ef752f4a Szymon Heidrich           2023-03-17  3599  				return 0;
17c060ef752f4a Szymon Heidrich           2023-03-17  3600  			}
17c060ef752f4a Szymon Heidrich           2023-03-17  3601  
17c060ef752f4a Szymon Heidrich           2023-03-17  3602  			frame_len = size - ETH_FCS_LEN;
ec4c7e12396b1a John Efstathiades         2021-11-18 @3603  			struct sk_buff *skb2;
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3604  
ec4c7e12396b1a John Efstathiades         2021-11-18  3605  			skb2 = napi_alloc_skb(&dev->napi, frame_len);
ec4c7e12396b1a John Efstathiades         2021-11-18  3606  			if (!skb2)
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3607  				return 0;
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3608  
ec4c7e12396b1a John Efstathiades         2021-11-18  3609  			memcpy(skb2->data, packet, frame_len);
ec4c7e12396b1a John Efstathiades         2021-11-18  3610  
ec4c7e12396b1a John Efstathiades         2021-11-18  3611  			skb_put(skb2, frame_len);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3612  
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3613  			lan78xx_rx_csum_offload(dev, skb2, rx_cmd_a, rx_cmd_b);
ec21ecf0aad279 Dave Stevenson            2018-06-25  3614  			lan78xx_rx_vlan_offload(dev, skb2, rx_cmd_a, rx_cmd_b);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3615  
ec4c7e12396b1a John Efstathiades         2021-11-18  3616  			/* Processing of the URB buffer must complete once
ec4c7e12396b1a John Efstathiades         2021-11-18  3617  			 * it has started. If the NAPI work budget is exhausted
ec4c7e12396b1a John Efstathiades         2021-11-18  3618  			 * while frames remain they are added to the overflow
ec4c7e12396b1a John Efstathiades         2021-11-18  3619  			 * queue for delivery in the next NAPI polling cycle.
ec4c7e12396b1a John Efstathiades         2021-11-18  3620  			 */
ec4c7e12396b1a John Efstathiades         2021-11-18  3621  			if (*work_done < budget) {
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3622  				lan78xx_skb_return(dev, skb2);
ec4c7e12396b1a John Efstathiades         2021-11-18  3623  				++(*work_done);
ec4c7e12396b1a John Efstathiades         2021-11-18  3624  			} else {
ec4c7e12396b1a John Efstathiades         2021-11-18  3625  				skb_queue_tail(&dev->rxq_overflow, skb2);
ec4c7e12396b1a John Efstathiades         2021-11-18  3626  			}
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3627  		}
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3628  
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3629  		skb_pull(skb, size);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3630  
ec4c7e12396b1a John Efstathiades         2021-11-18  3631  		/* skip padding bytes before the next frame starts */
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3632  		if (skb->len)
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3633  			skb_pull(skb, align_count);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3634  	}
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3635  
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3636  	return 1;
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3637  }
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3638  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
