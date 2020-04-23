Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82DBC1B5259
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 04:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgDWCXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 22:23:21 -0400
Received: from mga12.intel.com ([192.55.52.136]:4311 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgDWCXV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 22:23:21 -0400
IronPort-SDR: /a/kzSfbsm+l5PzNHm74shu/QIJt2wdB16iVojNNXOT9pH21lxJEc/1xYe88Mh36emJl3NyDuG
 6EbYf+Bd0Mjg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 19:23:21 -0700
IronPort-SDR: Ob0aUKH7JqfPp7JKqsrWXJhdEpv6XIhQlyshzG7rvSPbaozZ74l+a+O5tczK9EI7/InPYRDAwS
 4lhSDzxMCTpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,305,1583222400"; 
   d="scan'208";a="291036364"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 22 Apr 2020 19:23:18 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jRRWH-0009Ey-K0; Thu, 23 Apr 2020 10:23:17 +0800
Date:   Thu, 23 Apr 2020 10:23:08 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, idosch@idosch.org,
        allan.nielsen@microchip.com, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, antoine.tenart@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com
Subject: Re: [PATCH net-next 2/3] net: mscc: ocelot: refine the
 ocelot_ace_is_problematic_mac_etype function
Message-ID: <202004231032.OE8Eii2x%lkp@intel.com>
References: <20200420162743.15847-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420162743.15847-3-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on next-20200421]
[cannot apply to net/master linus/master sparc-next/master v5.7-rc2]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Vladimir-Oltean/Ocelot-MAC_ETYPE-tc-flower-key-improvements/20200422-113906
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git b6246f4d8d0778fd045b84dbd7fc5aadd8f3136e
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-191-gc51a0382-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/mscc/ocelot_ace.c:747:17: sparse: sparse: cast to restricted __be16
>> drivers/net/ethernet/mscc/ocelot_ace.c:747:17: sparse: sparse: cast to restricted __be16
>> drivers/net/ethernet/mscc/ocelot_ace.c:747:17: sparse: sparse: cast to restricted __be16
>> drivers/net/ethernet/mscc/ocelot_ace.c:747:17: sparse: sparse: cast to restricted __be16
   drivers/net/ethernet/mscc/ocelot_ace.c:748:16: sparse: sparse: cast to restricted __be16
   drivers/net/ethernet/mscc/ocelot_ace.c:748:16: sparse: sparse: cast to restricted __be16
   drivers/net/ethernet/mscc/ocelot_ace.c:748:16: sparse: sparse: cast to restricted __be16
   drivers/net/ethernet/mscc/ocelot_ace.c:748:16: sparse: sparse: cast to restricted __be16

vim +747 drivers/net/ethernet/mscc/ocelot_ace.c

   739	
   740	static bool ocelot_ace_is_problematic_mac_etype(struct ocelot_ace_rule *ace)
   741	{
   742		u16 proto, mask;
   743	
   744		if (ace->type != OCELOT_ACE_TYPE_ETYPE)
   745			return false;
   746	
 > 747		proto = ntohs(*(u16 *)ace->frame.etype.etype.value);
   748		mask = ntohs(*(u16 *)ace->frame.etype.etype.mask);
   749	
   750		/* ETH_P_ALL match, so all protocols below are included */
   751		if (mask == 0)
   752			return true;
   753		if (proto == ETH_P_ARP)
   754			return true;
   755		if (proto == ETH_P_IP)
   756			return true;
   757		if (proto == ETH_P_IPV6)
   758			return true;
   759	
   760		return false;
   761	}
   762	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
