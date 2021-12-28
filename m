Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D476D480A9E
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 16:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234870AbhL1PBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 10:01:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:21728 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232601AbhL1PBK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 10:01:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640703670; x=1672239670;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rcNpKB1llm2B0gb8gi5xUfCyAetOvaC5FJnKSR6tyRM=;
  b=Ym5fLwGP6YTtt8vyjNCSkj3JsGeyBgDh/Rscgiw5upYWgaFC4RIbzW3m
   rf8gf2BXJ9EXsxhoMsQnIb1zLPbxALuxCqXL+HwNFGUj+uIouf6bMxF9N
   vQsViuVnNkTeieqSuP3xRWUl1X4vu73Qv8pYsOvejqL0ROCv+NIlXURo+
   BcYxlU9QAICrZ90mF7nzCLwJk4I/5pC+q0KS5MuWS2FJGMcrrAuzz0u5E
   d4z8dmCGI/TeZJHcc3uQ/oxkWH2Hi2Fspt0Vdzf5CJmJqPcPhca0enxZu
   dbjTzZ7gDhLWEjuybn8e9sh5XWcHQGS/I3WGdgedTT5uGmQpuUkIynePu
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10210"; a="238920236"
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="238920236"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2021 07:01:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="554233377"
Received: from lkp-server01.sh.intel.com (HELO e357b3ef1427) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 28 Dec 2021 07:01:07 -0800
Received: from kbuild by e357b3ef1427 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n2DyM-0007f6-Mb; Tue, 28 Dec 2021 15:01:06 +0000
Date:   Tue, 28 Dec 2021 23:00:20 +0800
From:   kernel test robot <lkp@intel.com>
To:     David Mosberger-Tang <davidm@egauge.net>,
        Ajay Singh <ajay.kathat@microchip.com>
Cc:     kbuild-all@lists.01.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
Subject: Re: [PATCH v2 37/50] wilc1000: introduce set_header() function
Message-ID: <202112282213.rH4qGL7z-lkp@intel.com>
References: <20211223011358.4031459-38-davidm@egauge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211223011358.4031459-38-davidm@egauge.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvalo-wireless-drivers-next/master]
[also build test WARNING on kvalo-wireless-drivers/master v5.16-rc7 next-20211224]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/David-Mosberger-Tang/wilc1000-rework-tx-path-to-use-sk_buffs-throughout/20211223-091915
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
config: sparc-randconfig-s031-20211228 (https://download.01.org/0day-ci/archive/20211228/202112282213.rH4qGL7z-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 11.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/65a4186b405c72cc6e1a405db7ed0145a28a372f
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review David-Mosberger-Tang/wilc1000-rework-tx-path-to-use-sk_buffs-throughout/20211223-091915
        git checkout 65a4186b405c72cc6e1a405db7ed0145a28a372f
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=sparc SHELL=/bin/bash drivers/net/wireless/microchip/wilc1000/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
   drivers/net/wireless/microchip/wilc1000/wlan.c:640:16: sparse: sparse: incorrect type in return expression (different base types) @@     expected unsigned int @@     got restricted __le32 [usertype] @@
   drivers/net/wireless/microchip/wilc1000/wlan.c:640:16: sparse:     expected unsigned int
   drivers/net/wireless/microchip/wilc1000/wlan.c:640:16: sparse:     got restricted __le32 [usertype]
>> drivers/net/wireless/microchip/wilc1000/wlan.c:660:17: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] vmm_hdr @@     got restricted __le32 [usertype] @@
   drivers/net/wireless/microchip/wilc1000/wlan.c:660:17: sparse:     expected unsigned int [usertype] vmm_hdr
   drivers/net/wireless/microchip/wilc1000/wlan.c:660:17: sparse:     got restricted __le32 [usertype]
>> drivers/net/wireless/microchip/wilc1000/wlan.c:668:22: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] prio @@     got restricted __le32 [usertype] @@
   drivers/net/wireless/microchip/wilc1000/wlan.c:668:22: sparse:     expected unsigned int [usertype] prio
   drivers/net/wireless/microchip/wilc1000/wlan.c:668:22: sparse:     got restricted __le32 [usertype]

vim +660 drivers/net/wireless/microchip/wilc1000/wlan.c

   642	
   643	/**
   644	 * set_header() - set WILC-specific header
   645	 * @wilc: Pointer to the wilc structure.
   646	 * @tqe: The packet to add to the chip queue.
   647	 * @vmm_sz: The final size of the packet, including VMM header and padding.
   648	 * @hdr: Pointer to the header to set
   649	 */
   650	static void set_header(struct wilc *wilc, struct sk_buff *tqe,
   651			       u32 vmm_sz, void *hdr)
   652	{
   653		struct wilc_skb_tx_cb *tx_cb = WILC_SKB_TX_CB(tqe);
   654		u32 mgmt_pkt = 0, vmm_hdr, prio, data_len = tqe->len;
   655		struct wilc_vif *vif;
   656	
   657		/* add the VMM header word: */
   658		if (tx_cb->type == WILC_MGMT_PKT)
   659			mgmt_pkt = FIELD_PREP(WILC_VMM_HDR_MGMT_FIELD, 1);
 > 660		vmm_hdr = cpu_to_le32(mgmt_pkt |
   661				      FIELD_PREP(WILC_VMM_HDR_TYPE, tx_cb->type) |
   662				      FIELD_PREP(WILC_VMM_HDR_PKT_SIZE, data_len) |
   663				      FIELD_PREP(WILC_VMM_HDR_BUFF_SIZE, vmm_sz));
   664		memcpy(hdr, &vmm_hdr, 4);
   665	
   666		if (tx_cb->type == WILC_NET_PKT) {
   667			vif = netdev_priv(tqe->dev);
 > 668			prio = cpu_to_le32(tx_cb->q_num);
   669			memcpy(hdr + 4, &prio, sizeof(prio));
   670			memcpy(hdr + 8, vif->bssid, ETH_ALEN);
   671		}
   672	}
   673	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
