Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11776BEEC6
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjCQQrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCQQrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:47:02 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0317C975;
        Fri, 17 Mar 2023 09:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679071603; x=1710607603;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mtstCQdXn38bkovo6+1oAkS250S6g+dn6FzQ5TgKIOc=;
  b=VvJ3FxK8fddK0u0R4zBzYnyprI1A9N2hATImP9iWECmcoQQ8lynb8WFe
   X2mixxS2xHltwh1y3co2Lg1wq2+e+qcvp+E7I8vcBktMFVTVBujwjlQL0
   K6a7MHqtPjfnfIDw4Yy4Mkw58ljk8QOYHr8vLHFTfLF32mFQEdbbJerUT
   DMyRMerzSmbn6AYxGdMcIXaicKDoVOxOTCLCyQGsxnFlv6BkHFwXVH0Ei
   juHKczSfsKv/VUqRlhyLuIyNbSgU7XTxPPxkEp9s3tjrYgC5+3tFETcsg
   w1ZQqbJAPvEaKOpH1pTJ4OgOaLfdKp+WElG+mAYrIZTCnXlNT0ME46qvQ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="317963335"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="317963335"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 09:46:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="682743908"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="682743908"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 17 Mar 2023 09:46:15 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pdDDa-0009Ug-2P;
        Fri, 17 Mar 2023 16:46:14 +0000
Date:   Sat, 18 Mar 2023 00:46:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Szymon Heidrich <szymon.heidrich@gmail.com>,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com
Cc:     oe-kbuild-all@lists.linux.dev, pabeni@redhat.com,
        szymon.heidrich@gmail.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: lan78xx: Limit packet length to skb->len
Message-ID: <202303180031.EsiDo4qY-lkp@intel.com>
References: <20230317153217.90145-1-szymon.heidrich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317153217.90145-1-szymon.heidrich@gmail.com>
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

url:    https://github.com/intel-lab-lkp/linux/commits/Szymon-Heidrich/net-usb-lan78xx-Limit-packet-length-to-skb-len/20230317-233602
patch link:    https://lore.kernel.org/r/20230317153217.90145-1-szymon.heidrich%40gmail.com
patch subject: [PATCH] net: usb: lan78xx: Limit packet length to skb->len
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20230318/202303180031.EsiDo4qY-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/0110af02bdfd214f5cd310013aa19163d6558a7d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Szymon-Heidrich/net-usb-lan78xx-Limit-packet-length-to-skb-len/20230317-233602
        git checkout 0110af02bdfd214f5cd310013aa19163d6558a7d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303180031.EsiDo4qY-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/net/usb/lan78xx.c: In function 'lan78xx_rx':
>> drivers/net/usb/lan78xx.c:3600:25: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
    3600 |                         u32 frame_len = size - ETH_FCS_LEN;
         |                         ^~~


vim +3600 drivers/net/usb/lan78xx.c

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
0110af02bdfd21 Szymon Heidrich           2023-03-17  3582  		if (unlikely(size > skb->len)) {
0110af02bdfd21 Szymon Heidrich           2023-03-17  3583  			netif_dbg(dev, rx_err, dev->net,
0110af02bdfd21 Szymon Heidrich           2023-03-17  3584  				  "size err rx_cmd_a=0x%08x\n",
0110af02bdfd21 Szymon Heidrich           2023-03-17  3585  				  rx_cmd_a);
0110af02bdfd21 Szymon Heidrich           2023-03-17  3586  			return 0;
0110af02bdfd21 Szymon Heidrich           2023-03-17  3587  		}
0110af02bdfd21 Szymon Heidrich           2023-03-17  3588  
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3589  		if (unlikely(rx_cmd_a & RX_CMD_A_RED_)) {
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3590  			netif_dbg(dev, rx_err, dev->net,
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3591  				  "Error rx_cmd_a=0x%08x", rx_cmd_a);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3592  		} else {
0110af02bdfd21 Szymon Heidrich           2023-03-17  3593  			if (unlikely(size < ETH_FCS_LEN)) {
0110af02bdfd21 Szymon Heidrich           2023-03-17  3594  				netif_dbg(dev, rx_err, dev->net,
0110af02bdfd21 Szymon Heidrich           2023-03-17  3595  					  "size err rx_cmd_a=0x%08x\n",
0110af02bdfd21 Szymon Heidrich           2023-03-17  3596  					  rx_cmd_a);
0110af02bdfd21 Szymon Heidrich           2023-03-17  3597  				return 0;
0110af02bdfd21 Szymon Heidrich           2023-03-17  3598  			}
0110af02bdfd21 Szymon Heidrich           2023-03-17  3599  
ec4c7e12396b1a John Efstathiades         2021-11-18 @3600  			u32 frame_len = size - ETH_FCS_LEN;
ec4c7e12396b1a John Efstathiades         2021-11-18  3601  			struct sk_buff *skb2;
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3602  
ec4c7e12396b1a John Efstathiades         2021-11-18  3603  			skb2 = napi_alloc_skb(&dev->napi, frame_len);
ec4c7e12396b1a John Efstathiades         2021-11-18  3604  			if (!skb2)
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3605  				return 0;
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3606  
ec4c7e12396b1a John Efstathiades         2021-11-18  3607  			memcpy(skb2->data, packet, frame_len);
ec4c7e12396b1a John Efstathiades         2021-11-18  3608  
ec4c7e12396b1a John Efstathiades         2021-11-18  3609  			skb_put(skb2, frame_len);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3610  
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3611  			lan78xx_rx_csum_offload(dev, skb2, rx_cmd_a, rx_cmd_b);
ec21ecf0aad279 Dave Stevenson            2018-06-25  3612  			lan78xx_rx_vlan_offload(dev, skb2, rx_cmd_a, rx_cmd_b);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3613  
ec4c7e12396b1a John Efstathiades         2021-11-18  3614  			/* Processing of the URB buffer must complete once
ec4c7e12396b1a John Efstathiades         2021-11-18  3615  			 * it has started. If the NAPI work budget is exhausted
ec4c7e12396b1a John Efstathiades         2021-11-18  3616  			 * while frames remain they are added to the overflow
ec4c7e12396b1a John Efstathiades         2021-11-18  3617  			 * queue for delivery in the next NAPI polling cycle.
ec4c7e12396b1a John Efstathiades         2021-11-18  3618  			 */
ec4c7e12396b1a John Efstathiades         2021-11-18  3619  			if (*work_done < budget) {
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3620  				lan78xx_skb_return(dev, skb2);
ec4c7e12396b1a John Efstathiades         2021-11-18  3621  				++(*work_done);
ec4c7e12396b1a John Efstathiades         2021-11-18  3622  			} else {
ec4c7e12396b1a John Efstathiades         2021-11-18  3623  				skb_queue_tail(&dev->rxq_overflow, skb2);
ec4c7e12396b1a John Efstathiades         2021-11-18  3624  			}
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3625  		}
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3626  
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3627  		skb_pull(skb, size);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3628  
ec4c7e12396b1a John Efstathiades         2021-11-18  3629  		/* skip padding bytes before the next frame starts */
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3630  		if (skb->len)
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3631  			skb_pull(skb, align_count);
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3632  	}
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3633  
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3634  	return 1;
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3635  }
55d7de9de6c30a Woojung.Huh@microchip.com 2015-07-30  3636  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
