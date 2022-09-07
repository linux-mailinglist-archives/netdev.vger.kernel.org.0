Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4D225B0CEE
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 21:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiIGTMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 15:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiIGTMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 15:12:51 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BE2BBA58;
        Wed,  7 Sep 2022 12:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662577969; x=1694113969;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3zy6M8QkCJjBXQedcYlPk/BRgB9EsK3lxB77sfemVLg=;
  b=OeGfTd36Z4ZO6OqNc8DTpiaHiWdHi4FbpaxpF4ph1+fOkn3cudcGWC+E
   hPRqMFCJ0OaqBgg7Xqqypndk7t6EXGo/n6HND3mzCta/wC0n1ivJ4mfO1
   n7B1iZfNbeflOEzTNKLc1sMElaKfKDrN64Ku01ddmuDzEnRX+WVpPOZbK
   sKAIHzzu/tsIkwUeJML5v5GGZydfL0u1TAU4Ikk7lCzmjKfI4wRY9MzCj
   FjB63RReZyJKvKX9r1uN8cfELFKEU4DeM3LRDe405eouX5ThIQuBag8wI
   4zRv4Uy4duOpuujR77JOTRjr8j+ZTRBdh8KVmJJnEU7xSEoq5bORfUTLa
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10463"; a="295709013"
X-IronPort-AV: E=Sophos;i="5.93,297,1654585200"; 
   d="scan'208";a="295709013"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2022 12:12:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,297,1654585200"; 
   d="scan'208";a="943030796"
Received: from lkp-server02.sh.intel.com (HELO 95dfd251caa2) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 07 Sep 2022 12:12:26 -0700
Received: from kbuild by 95dfd251caa2 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oW0TJ-0006sf-2l;
        Wed, 07 Sep 2022 19:12:25 +0000
Date:   Thu, 8 Sep 2022 03:11:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>,
        netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, bryan.whitehead@microchip.com,
        UNGLinuxDriver@microchip.com, Ian.Saturley@microchip.com
Subject: Re: [PATCH net-next V1 2/2] net: lan743x: Add support for Rx IP &
 TCP checksum offload
Message-ID: <202209080357.QlM4jMJx-lkp@intel.com>
References: <20220907062127.15473-3-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220907062127.15473-3-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Raju,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Raju-Lakkaraju/net-lan743x-Fix-to-use-multiqueue-start-stop-APIs/20220907-143456
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 2786bcff28bd88955fc61adf9cb7370fbc182bad
config: sparc-randconfig-s043-20220907 (https://download.01.org/0day-ci/archive/20220908/202209080357.QlM4jMJx-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/d965e2dd24f617d68ded6f3cbeb69aa8271d5221
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Raju-Lakkaraju/net-lan743x-Fix-to-use-multiqueue-start-stop-APIs/20220907-143456
        git checkout d965e2dd24f617d68ded6f3cbeb69aa8271d5221
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=sparc SHELL=/bin/bash drivers/net/ethernet/microchip/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

sparse warnings: (new ones prefixed by >>)
>> drivers/net/ethernet/microchip/lan743x_main.c:2600:28: sparse: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/microchip/lan743x_main.c:2601:28: sparse: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/microchip/lan743x_main.c:2602:29: sparse: sparse: restricted __le32 degrades to integer

vim +2600 drivers/net/ethernet/microchip/lan743x_main.c

  2544	
  2545	static int lan743x_rx_process_buffer(struct lan743x_rx *rx)
  2546	{
  2547		int current_head_index = le32_to_cpu(*rx->head_cpu_ptr);
  2548		struct lan743x_rx_descriptor *descriptor, *desc_ext;
  2549		struct net_device *netdev = rx->adapter->netdev;
  2550		int result = RX_PROCESS_RESULT_NOTHING_TO_DO;
  2551		struct lan743x_rx_buffer_info *buffer_info;
  2552		int frame_length, buffer_length;
  2553		bool is_ice, is_tce, is_icsm;
  2554		int extension_index = -1;
  2555		bool is_last, is_first;
  2556		struct sk_buff *skb;
  2557	
  2558		if (current_head_index < 0 || current_head_index >= rx->ring_size)
  2559			goto done;
  2560	
  2561		if (rx->last_head < 0 || rx->last_head >= rx->ring_size)
  2562			goto done;
  2563	
  2564		if (rx->last_head == current_head_index)
  2565			goto done;
  2566	
  2567		descriptor = &rx->ring_cpu_ptr[rx->last_head];
  2568		if (le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_OWN_)
  2569			goto done;
  2570		buffer_info = &rx->buffer_info[rx->last_head];
  2571	
  2572		is_last = le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_LS_;
  2573		is_first = le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_FS_;
  2574	
  2575		if (is_last && le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_EXT_) {
  2576			/* extension is expected to follow */
  2577			int index = lan743x_rx_next_index(rx, rx->last_head);
  2578	
  2579			if (index == current_head_index)
  2580				/* extension not yet available */
  2581				goto done;
  2582			desc_ext = &rx->ring_cpu_ptr[index];
  2583			if (le32_to_cpu(desc_ext->data0) & RX_DESC_DATA0_OWN_)
  2584				/* extension not yet available */
  2585				goto done;
  2586			if (!(le32_to_cpu(desc_ext->data0) & RX_DESC_DATA0_EXT_))
  2587				goto move_forward;
  2588			extension_index = index;
  2589		}
  2590	
  2591		/* Only the last buffer in a multi-buffer frame contains the total frame
  2592		 * length. The chip occasionally sends more buffers than strictly
  2593		 * required to reach the total frame length.
  2594		 * Handle this by adding all buffers to the skb in their entirety.
  2595		 * Once the real frame length is known, trim the skb.
  2596		 */
  2597		frame_length =
  2598			RX_DESC_DATA0_FRAME_LENGTH_GET_(le32_to_cpu(descriptor->data0));
  2599		buffer_length = buffer_info->buffer_length;
> 2600		is_ice = descriptor->data1 & RX_DESC_DATA1_STATUS_ICE_;
  2601		is_tce = descriptor->data1 & RX_DESC_DATA1_STATUS_TCE_;
  2602		is_icsm = descriptor->data1 & RX_DESC_DATA1_STATUS_ICSM_;
  2603	
  2604		netdev_dbg(netdev, "%s%schunk: %d/%d",
  2605			   is_first ? "first " : "      ",
  2606			   is_last  ? "last  " : "      ",
  2607			   frame_length, buffer_length);
  2608	
  2609		/* save existing skb, allocate new skb and map to dma */
  2610		skb = buffer_info->skb;
  2611		if (lan743x_rx_init_ring_element(rx, rx->last_head,
  2612						 GFP_ATOMIC | GFP_DMA)) {
  2613			/* failed to allocate next skb.
  2614			 * Memory is very low.
  2615			 * Drop this packet and reuse buffer.
  2616			 */
  2617			lan743x_rx_reuse_ring_element(rx, rx->last_head);
  2618			/* drop packet that was being assembled */
  2619			dev_kfree_skb_irq(rx->skb_head);
  2620			rx->skb_head = NULL;
  2621			goto process_extension;
  2622		}
  2623	
  2624		/* add buffers to skb via skb->frag_list */
  2625		if (is_first) {
  2626			skb_reserve(skb, RX_HEAD_PADDING);
  2627			skb_put(skb, buffer_length - RX_HEAD_PADDING);
  2628			if (rx->skb_head)
  2629				dev_kfree_skb_irq(rx->skb_head);
  2630			rx->skb_head = skb;
  2631		} else if (rx->skb_head) {
  2632			skb_put(skb, buffer_length);
  2633			if (skb_shinfo(rx->skb_head)->frag_list)
  2634				rx->skb_tail->next = skb;
  2635			else
  2636				skb_shinfo(rx->skb_head)->frag_list = skb;
  2637			rx->skb_tail = skb;
  2638			rx->skb_head->len += skb->len;
  2639			rx->skb_head->data_len += skb->len;
  2640			rx->skb_head->truesize += skb->truesize;
  2641		} else {
  2642			/* packet to assemble has already been dropped because one or
  2643			 * more of its buffers could not be allocated
  2644			 */
  2645			netdev_dbg(netdev, "drop buffer intended for dropped packet");
  2646			dev_kfree_skb_irq(skb);
  2647		}
  2648	
  2649	process_extension:
  2650		if (extension_index >= 0) {
  2651			u32 ts_sec;
  2652			u32 ts_nsec;
  2653	
  2654			ts_sec = le32_to_cpu(desc_ext->data1);
  2655			ts_nsec = (le32_to_cpu(desc_ext->data2) &
  2656				  RX_DESC_DATA2_TS_NS_MASK_);
  2657			if (rx->skb_head)
  2658				skb_hwtstamps(rx->skb_head)->hwtstamp =
  2659					ktime_set(ts_sec, ts_nsec);
  2660			lan743x_rx_reuse_ring_element(rx, extension_index);
  2661			rx->last_head = extension_index;
  2662			netdev_dbg(netdev, "process extension");
  2663		}
  2664	
  2665		if (is_last && rx->skb_head)
  2666			rx->skb_head = lan743x_rx_trim_skb(rx->skb_head, frame_length);
  2667	
  2668		if (is_last && rx->skb_head) {
  2669			rx->skb_head->protocol = eth_type_trans(rx->skb_head,
  2670								rx->adapter->netdev);
  2671			if (rx->adapter->netdev->features & NETIF_F_RXCSUM) {
  2672				if (!is_ice && !is_tce && !is_icsm)
  2673					skb->ip_summed = CHECKSUM_UNNECESSARY;
  2674			}
  2675			netdev_dbg(netdev, "sending %d byte frame to OS",
  2676				   rx->skb_head->len);
  2677			napi_gro_receive(&rx->napi, rx->skb_head);
  2678			rx->skb_head = NULL;
  2679		}
  2680	
  2681	move_forward:
  2682		/* push tail and head forward */
  2683		rx->last_tail = rx->last_head;
  2684		rx->last_head = lan743x_rx_next_index(rx, rx->last_head);
  2685		result = RX_PROCESS_RESULT_BUFFER_RECEIVED;
  2686	done:
  2687		return result;
  2688	}
  2689	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
