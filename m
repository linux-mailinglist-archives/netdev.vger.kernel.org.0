Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8C159A785
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 23:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352393AbiHSVUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 17:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352384AbiHSVUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 17:20:17 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B7110445B
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 14:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660944015; x=1692480015;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=l+cG62wo6/G7kQeZrjfBUq8k1ebBKwrp+OJvv/OSAGQ=;
  b=n7RR0BD9+OQdIRlb03/W6eGbWm7X+PxiuM3H6OwQ4Mlhc6FQ+MB3/GkV
   Zc5YuaWmSdDCzLFDWiK2Vx3q27lO83cblioJSS5LnDWDMDhi9ItJbysqi
   HCVUNlWwgQoJ73xyIBVwb69K+EUYhqW4vfk30QYzGW/THlf06S+o8DitT
   6DtYsSl+yoLhLFyHC2ceSORISNRBUNIP+ps6U4SmRfWshOshvtl72kY/f
   dsi67pGQl7V1DsqbrGzb9MuyrjnjlwQzud+f53d9BYWARsHVzgtCnUuNU
   dwToZBsSdcyOkSju+1ceizZAslGYD86MgJoUn6HJT2Udmlrm4ZIbtUfM6
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="290668865"
X-IronPort-AV: E=Sophos;i="5.93,249,1654585200"; 
   d="scan'208";a="290668865"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 14:20:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,249,1654585200"; 
   d="scan'208";a="734530407"
Received: from lkp-server01.sh.intel.com (HELO 44b6dac04a33) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 19 Aug 2022 14:20:12 -0700
Received: from kbuild by 44b6dac04a33 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oP9PX-0001oq-22;
        Fri, 19 Aug 2022 21:20:11 +0000
Date:   Sat, 20 Aug 2022 05:19:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     kbuild-all@lists.01.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Subject: Re: [PATCH net-next v2 1/3] sfc: allow more flexible way of adding
 filters for PTP
Message-ID: <202208200516.VBfWImxe-lkp@intel.com>
References: <20220819082001.15439-2-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220819082001.15439-2-ihuguet@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
config: sparc-randconfig-s043-20220820 (https://download.01.org/0day-ci/archive/20220820/202208200516.VBfWImxe-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 12.1.0
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
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=sparc SHELL=/bin/bash drivers/net/ethernet/sfc/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

sparse warnings: (new ones prefixed by >>)
>> drivers/net/ethernet/sfc/ptp.c:1636:39: sparse: sparse: cast from restricted __be16
>> drivers/net/ethernet/sfc/ptp.c:1697:58: sparse: sparse: restricted __be16 degrades to integer
   drivers/net/ethernet/sfc/ptp.c:1736:36: sparse: sparse: cast from restricted __be16

vim +1636 drivers/net/ethernet/sfc/ptp.c

7c236c43b838221 Stuart Hodgson  2012-09-03  1620  
7c236c43b838221 Stuart Hodgson  2012-09-03  1621  /* Determine whether this packet should be processed by the PTP module
7c236c43b838221 Stuart Hodgson  2012-09-03  1622   * or transmitted conventionally.
7c236c43b838221 Stuart Hodgson  2012-09-03  1623   */
7c236c43b838221 Stuart Hodgson  2012-09-03  1624  bool efx_ptp_is_ptp_tx(struct efx_nic *efx, struct sk_buff *skb)
7c236c43b838221 Stuart Hodgson  2012-09-03  1625  {
7c236c43b838221 Stuart Hodgson  2012-09-03  1626  	return efx->ptp_data &&
7c236c43b838221 Stuart Hodgson  2012-09-03  1627  		efx->ptp_data->enabled &&
7c236c43b838221 Stuart Hodgson  2012-09-03  1628  		skb->len >= PTP_MIN_LENGTH &&
7c236c43b838221 Stuart Hodgson  2012-09-03  1629  		skb->len <= MC_CMD_PTP_IN_TRANSMIT_PACKET_MAXNUM &&
7c236c43b838221 Stuart Hodgson  2012-09-03  1630  		likely(skb->protocol == htons(ETH_P_IP)) &&
e5a498e943fbc49 Ben Hutchings   2013-12-06  1631  		skb_transport_header_was_set(skb) &&
e5a498e943fbc49 Ben Hutchings   2013-12-06  1632  		skb_network_header_len(skb) >= sizeof(struct iphdr) &&
7c236c43b838221 Stuart Hodgson  2012-09-03  1633  		ip_hdr(skb)->protocol == IPPROTO_UDP &&
e5a498e943fbc49 Ben Hutchings   2013-12-06  1634  		skb_headlen(skb) >=
e5a498e943fbc49 Ben Hutchings   2013-12-06  1635  		skb_transport_offset(skb) + sizeof(struct udphdr) &&
7c236c43b838221 Stuart Hodgson  2012-09-03 @1636  		udp_hdr(skb)->dest == htons(PTP_EVENT_PORT);
7c236c43b838221 Stuart Hodgson  2012-09-03  1637  }
7c236c43b838221 Stuart Hodgson  2012-09-03  1638  
7c236c43b838221 Stuart Hodgson  2012-09-03  1639  /* Receive a PTP packet.  Packets are queued until the arrival of
7c236c43b838221 Stuart Hodgson  2012-09-03  1640   * the receive timestamp from the MC - this will probably occur after the
7c236c43b838221 Stuart Hodgson  2012-09-03  1641   * packet arrival because of the processing in the MC.
7c236c43b838221 Stuart Hodgson  2012-09-03  1642   */
4a74dc65e3ad825 Ben Hutchings   2013-03-05  1643  static bool efx_ptp_rx(struct efx_channel *channel, struct sk_buff *skb)
7c236c43b838221 Stuart Hodgson  2012-09-03  1644  {
7c236c43b838221 Stuart Hodgson  2012-09-03  1645  	struct efx_nic *efx = channel->efx;
7c236c43b838221 Stuart Hodgson  2012-09-03  1646  	struct efx_ptp_data *ptp = efx->ptp_data;
7c236c43b838221 Stuart Hodgson  2012-09-03  1647  	struct efx_ptp_match *match = (struct efx_ptp_match *)skb->cb;
c939a316459783e Laurence Evans  2012-11-15  1648  	u8 *match_data_012, *match_data_345;
7c236c43b838221 Stuart Hodgson  2012-09-03  1649  	unsigned int version;
ce320f44d677549 Ben Hutchings   2014-02-12  1650  	u8 *data;
7c236c43b838221 Stuart Hodgson  2012-09-03  1651  
7c236c43b838221 Stuart Hodgson  2012-09-03  1652  	match->expiry = jiffies + msecs_to_jiffies(PKT_EVENT_LIFETIME_MS);
7c236c43b838221 Stuart Hodgson  2012-09-03  1653  
7c236c43b838221 Stuart Hodgson  2012-09-03  1654  	/* Correct version? */
7c236c43b838221 Stuart Hodgson  2012-09-03  1655  	if (ptp->mode == MC_CMD_PTP_MODE_V1) {
97d48a10c670f87 Alexandre Rames 2013-01-11  1656  		if (!pskb_may_pull(skb, PTP_V1_MIN_LENGTH)) {
4a74dc65e3ad825 Ben Hutchings   2013-03-05  1657  			return false;
7c236c43b838221 Stuart Hodgson  2012-09-03  1658  		}
ce320f44d677549 Ben Hutchings   2014-02-12  1659  		data = skb->data;
ce320f44d677549 Ben Hutchings   2014-02-12  1660  		version = ntohs(*(__be16 *)&data[PTP_V1_VERSION_OFFSET]);
7c236c43b838221 Stuart Hodgson  2012-09-03  1661  		if (version != PTP_VERSION_V1) {
4a74dc65e3ad825 Ben Hutchings   2013-03-05  1662  			return false;
7c236c43b838221 Stuart Hodgson  2012-09-03  1663  		}
c939a316459783e Laurence Evans  2012-11-15  1664  
c939a316459783e Laurence Evans  2012-11-15  1665  		/* PTP V1 uses all six bytes of the UUID to match the packet
c939a316459783e Laurence Evans  2012-11-15  1666  		 * to the timestamp
c939a316459783e Laurence Evans  2012-11-15  1667  		 */
ce320f44d677549 Ben Hutchings   2014-02-12  1668  		match_data_012 = data + PTP_V1_UUID_OFFSET;
ce320f44d677549 Ben Hutchings   2014-02-12  1669  		match_data_345 = data + PTP_V1_UUID_OFFSET + 3;
7c236c43b838221 Stuart Hodgson  2012-09-03  1670  	} else {
97d48a10c670f87 Alexandre Rames 2013-01-11  1671  		if (!pskb_may_pull(skb, PTP_V2_MIN_LENGTH)) {
4a74dc65e3ad825 Ben Hutchings   2013-03-05  1672  			return false;
7c236c43b838221 Stuart Hodgson  2012-09-03  1673  		}
ce320f44d677549 Ben Hutchings   2014-02-12  1674  		data = skb->data;
ce320f44d677549 Ben Hutchings   2014-02-12  1675  		version = data[PTP_V2_VERSION_OFFSET];
7c236c43b838221 Stuart Hodgson  2012-09-03  1676  		if ((version & PTP_VERSION_V2_MASK) != PTP_VERSION_V2) {
4a74dc65e3ad825 Ben Hutchings   2013-03-05  1677  			return false;
7c236c43b838221 Stuart Hodgson  2012-09-03  1678  		}
c939a316459783e Laurence Evans  2012-11-15  1679  
c939a316459783e Laurence Evans  2012-11-15  1680  		/* The original V2 implementation uses bytes 2-7 of
c939a316459783e Laurence Evans  2012-11-15  1681  		 * the UUID to match the packet to the timestamp. This
c939a316459783e Laurence Evans  2012-11-15  1682  		 * discards two of the bytes of the MAC address used
c939a316459783e Laurence Evans  2012-11-15  1683  		 * to create the UUID (SF bug 33070).  The PTP V2
c939a316459783e Laurence Evans  2012-11-15  1684  		 * enhanced mode fixes this issue and uses bytes 0-2
c939a316459783e Laurence Evans  2012-11-15  1685  		 * and byte 5-7 of the UUID.
c939a316459783e Laurence Evans  2012-11-15  1686  		 */
ce320f44d677549 Ben Hutchings   2014-02-12  1687  		match_data_345 = data + PTP_V2_UUID_OFFSET + 5;
c939a316459783e Laurence Evans  2012-11-15  1688  		if (ptp->mode == MC_CMD_PTP_MODE_V2) {
ce320f44d677549 Ben Hutchings   2014-02-12  1689  			match_data_012 = data + PTP_V2_UUID_OFFSET + 2;
c939a316459783e Laurence Evans  2012-11-15  1690  		} else {
ce320f44d677549 Ben Hutchings   2014-02-12  1691  			match_data_012 = data + PTP_V2_UUID_OFFSET + 0;
c939a316459783e Laurence Evans  2012-11-15  1692  			BUG_ON(ptp->mode != MC_CMD_PTP_MODE_V2_ENHANCED);
c939a316459783e Laurence Evans  2012-11-15  1693  		}
7c236c43b838221 Stuart Hodgson  2012-09-03  1694  	}
7c236c43b838221 Stuart Hodgson  2012-09-03  1695  
7c236c43b838221 Stuart Hodgson  2012-09-03  1696  	/* Does this packet require timestamping? */
ce320f44d677549 Ben Hutchings   2014-02-12 @1697  	if (ntohs(*(__be16 *)&data[PTP_DPORT_OFFSET]) == PTP_EVENT_PORT) {
7c236c43b838221 Stuart Hodgson  2012-09-03  1698  		match->state = PTP_PACKET_STATE_UNMATCHED;
7c236c43b838221 Stuart Hodgson  2012-09-03  1699  
c939a316459783e Laurence Evans  2012-11-15  1700  		/* We expect the sequence number to be in the same position in
c939a316459783e Laurence Evans  2012-11-15  1701  		 * the packet for PTP V1 and V2
c939a316459783e Laurence Evans  2012-11-15  1702  		 */
c939a316459783e Laurence Evans  2012-11-15  1703  		BUILD_BUG_ON(PTP_V1_SEQUENCE_OFFSET != PTP_V2_SEQUENCE_OFFSET);
c939a316459783e Laurence Evans  2012-11-15  1704  		BUILD_BUG_ON(PTP_V1_SEQUENCE_LENGTH != PTP_V2_SEQUENCE_LENGTH);
c939a316459783e Laurence Evans  2012-11-15  1705  
7c236c43b838221 Stuart Hodgson  2012-09-03  1706  		/* Extract UUID/Sequence information */
c939a316459783e Laurence Evans  2012-11-15  1707  		match->words[0] = (match_data_012[0]         |
c939a316459783e Laurence Evans  2012-11-15  1708  				   (match_data_012[1] << 8)  |
c939a316459783e Laurence Evans  2012-11-15  1709  				   (match_data_012[2] << 16) |
c939a316459783e Laurence Evans  2012-11-15  1710  				   (match_data_345[0] << 24));
c939a316459783e Laurence Evans  2012-11-15  1711  		match->words[1] = (match_data_345[1]         |
c939a316459783e Laurence Evans  2012-11-15  1712  				   (match_data_345[2] << 8)  |
ce320f44d677549 Ben Hutchings   2014-02-12  1713  				   (data[PTP_V1_SEQUENCE_OFFSET +
7c236c43b838221 Stuart Hodgson  2012-09-03  1714  					 PTP_V1_SEQUENCE_LENGTH - 1] <<
7c236c43b838221 Stuart Hodgson  2012-09-03  1715  				    16));
7c236c43b838221 Stuart Hodgson  2012-09-03  1716  	} else {
7c236c43b838221 Stuart Hodgson  2012-09-03  1717  		match->state = PTP_PACKET_STATE_MATCH_UNWANTED;
7c236c43b838221 Stuart Hodgson  2012-09-03  1718  	}
7c236c43b838221 Stuart Hodgson  2012-09-03  1719  
7c236c43b838221 Stuart Hodgson  2012-09-03  1720  	skb_queue_tail(&ptp->rxq, skb);
7c236c43b838221 Stuart Hodgson  2012-09-03  1721  	queue_work(ptp->workwq, &ptp->work);
4a74dc65e3ad825 Ben Hutchings   2013-03-05  1722  
4a74dc65e3ad825 Ben Hutchings   2013-03-05  1723  	return true;
7c236c43b838221 Stuart Hodgson  2012-09-03  1724  }
7c236c43b838221 Stuart Hodgson  2012-09-03  1725  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
