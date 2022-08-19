Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1018D59A67D
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 21:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350761AbiHSTjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 15:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350555AbiHSTjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 15:39:12 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAE69AFF9
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 12:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660937951; x=1692473951;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ytvF1n5qVzij9G8x4w7gv3aYKYnhqhIuHdQxhIzguuk=;
  b=XtyBsQ4RS6qjMrliLAJsNYjkRMw48LQD+eXVG5AVA4vmu9wgB6Ac9Sxv
   58+n9Enlsv8XHr33h6hM/rPv2MVq1aJOLHtkB74xWs9zQaCR4xnAIECCK
   T8Qxbo6/sgR9wUZg+kpSjjg20TwzxYI1E7FU2jww23CeYqkZGHLvA5HIU
   vdz7XJQ0hvRCYSPHmXhJ54VBv+zjoSS3Q0lCJipTBr+ArGqQezNJXah50
   EcMUjKe6LKBAq/p85rmnoKntRIEpEY5U5+YkRfvMNNCqvM/PL6ZTEUhwx
   EJfRjACLpSy5eVUXpcf4YFg184Q3irx7UndKVyd7zu8blkd2/0ON6Dnk1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="273476026"
X-IronPort-AV: E=Sophos;i="5.93,248,1654585200"; 
   d="scan'208";a="273476026"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 12:39:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,248,1654585200"; 
   d="scan'208";a="641364595"
Received: from lkp-server01.sh.intel.com (HELO 44b6dac04a33) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 19 Aug 2022 12:39:08 -0700
Received: from kbuild by 44b6dac04a33 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oP7pk-0001kD-0Y;
        Fri, 19 Aug 2022 19:39:08 +0000
Date:   Sat, 20 Aug 2022 03:38:16 +0800
From:   kernel test robot <lkp@intel.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     kbuild-all@lists.01.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Subject: Re: [PATCH net-next v2 1/3] sfc: allow more flexible way of adding
 filters for PTP
Message-ID: <202208200349.DAfcHJLZ-lkp@intel.com>
References: <20220819082001.15439-2-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220819082001.15439-2-ihuguet@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi "Íñigo,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/igo-Huguet/sfc-allow-more-flexible-way-of-adding-filters-for-PTP/20220819-172020
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 268603d79cc48dba671e9caf108fab32315b86a2
config: riscv-randconfig-s032-20220820 (https://download.01.org/0day-ci/archive/20220820/202208200349.DAfcHJLZ-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/b2ecd6ff1d511bc31dbb222211226ce141b0852b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review igo-Huguet/sfc-allow-more-flexible-way-of-adding-filters-for-PTP/20220819-172020
        git checkout b2ecd6ff1d511bc31dbb222211226ce141b0852b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=riscv SHELL=/bin/bash drivers/net/ethernet/sfc/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

sparse warnings: (new ones prefixed by >>)
   WARNING: invalid argument to '-march': '_zihintpause'
>> drivers/net/ethernet/sfc/ptp.c:1636:39: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned short [usertype] val @@     got restricted __be16 [usertype] @@
   drivers/net/ethernet/sfc/ptp.c:1636:39: sparse:     expected unsigned short [usertype] val
   drivers/net/ethernet/sfc/ptp.c:1636:39: sparse:     got restricted __be16 [usertype]
   drivers/net/ethernet/sfc/ptp.c:1636:39: sparse: sparse: cast from restricted __be16
   drivers/net/ethernet/sfc/ptp.c:1636:39: sparse: sparse: cast from restricted __be16
   drivers/net/ethernet/sfc/ptp.c:1697:58: sparse: sparse: restricted __be16 degrades to integer
   drivers/net/ethernet/sfc/ptp.c:1736:36: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned short [usertype] val @@     got restricted __be16 [usertype] @@
   drivers/net/ethernet/sfc/ptp.c:1736:36: sparse:     expected unsigned short [usertype] val
   drivers/net/ethernet/sfc/ptp.c:1736:36: sparse:     got restricted __be16 [usertype]
   drivers/net/ethernet/sfc/ptp.c:1736:36: sparse: sparse: cast from restricted __be16
   drivers/net/ethernet/sfc/ptp.c:1736:36: sparse: sparse: cast from restricted __be16

vim +1636 drivers/net/ethernet/sfc/ptp.c

7c236c43b83822 Stuart Hodgson 2012-09-03  1620  
7c236c43b83822 Stuart Hodgson 2012-09-03  1621  /* Determine whether this packet should be processed by the PTP module
7c236c43b83822 Stuart Hodgson 2012-09-03  1622   * or transmitted conventionally.
7c236c43b83822 Stuart Hodgson 2012-09-03  1623   */
7c236c43b83822 Stuart Hodgson 2012-09-03  1624  bool efx_ptp_is_ptp_tx(struct efx_nic *efx, struct sk_buff *skb)
7c236c43b83822 Stuart Hodgson 2012-09-03  1625  {
7c236c43b83822 Stuart Hodgson 2012-09-03  1626  	return efx->ptp_data &&
7c236c43b83822 Stuart Hodgson 2012-09-03  1627  		efx->ptp_data->enabled &&
7c236c43b83822 Stuart Hodgson 2012-09-03  1628  		skb->len >= PTP_MIN_LENGTH &&
7c236c43b83822 Stuart Hodgson 2012-09-03  1629  		skb->len <= MC_CMD_PTP_IN_TRANSMIT_PACKET_MAXNUM &&
7c236c43b83822 Stuart Hodgson 2012-09-03  1630  		likely(skb->protocol == htons(ETH_P_IP)) &&
e5a498e943fbc4 Ben Hutchings  2013-12-06  1631  		skb_transport_header_was_set(skb) &&
e5a498e943fbc4 Ben Hutchings  2013-12-06  1632  		skb_network_header_len(skb) >= sizeof(struct iphdr) &&
7c236c43b83822 Stuart Hodgson 2012-09-03  1633  		ip_hdr(skb)->protocol == IPPROTO_UDP &&
e5a498e943fbc4 Ben Hutchings  2013-12-06  1634  		skb_headlen(skb) >=
e5a498e943fbc4 Ben Hutchings  2013-12-06  1635  		skb_transport_offset(skb) + sizeof(struct udphdr) &&
7c236c43b83822 Stuart Hodgson 2012-09-03 @1636  		udp_hdr(skb)->dest == htons(PTP_EVENT_PORT);
7c236c43b83822 Stuart Hodgson 2012-09-03  1637  }
7c236c43b83822 Stuart Hodgson 2012-09-03  1638  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
