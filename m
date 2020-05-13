Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1DD1D0362
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 02:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731700AbgEMACk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 20:02:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:37006 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726031AbgEMACk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 20:02:40 -0400
IronPort-SDR: NITnP8lm0JFkjVCJrRc58QtT+7qUkwJiI9oigjWTIL1aBDdLHN/h0UPMNZmMBZ7sSNVo/uGQYm
 HXW4T0k2/c+Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2020 17:02:39 -0700
IronPort-SDR: DZMLCHPObSPyG/QW5dCr+LNTU4Z5RDAgklvTgIqQ51bXLc1mduBy6gLVxgKvrpMfDt347/S3Ek
 EeXDg1DaatAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,385,1583222400"; 
   d="scan'208";a="262292657"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 12 May 2020 17:02:36 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jYer6-000DQ0-44; Wed, 13 May 2020 08:02:36 +0800
Date:   Wed, 13 May 2020 08:02:30 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     kbuild-all@lists.01.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next 08/15] net: dsa: sja1105: prepare tagger for
 handling DSA tags and VLAN simultaneously
Message-ID: <202005130724.KFjVH0Y9%lkp@intel.com>
References: <20200512172039.14136-9-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512172039.14136-9-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on next-20200512]
[cannot apply to linus/master v5.7-rc5]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Vladimir-Oltean/Traffic-support-for-dsa_8021q-in-vlan_filtering-1-mode/20200513-012422
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 3242956bd610af40e884b530b6c6f76f5bf85f3b
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-191-gc51a0382-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> net/dsa/tag_sja1105.c:76:34: sparse: sparse: cast to restricted __be16
>> net/dsa/tag_sja1105.c:76:34: sparse: sparse: cast to restricted __be16
>> net/dsa/tag_sja1105.c:76:34: sparse: sparse: cast to restricted __be16
>> net/dsa/tag_sja1105.c:76:34: sparse: sparse: cast to restricted __be16
>> net/dsa/tag_sja1105.c:76:16: sparse: sparse: restricted __be16 degrades to integer
   net/dsa/tag_sja1105.c:79:34: sparse: sparse: cast to restricted __be16
   net/dsa/tag_sja1105.c:79:34: sparse: sparse: cast to restricted __be16
   net/dsa/tag_sja1105.c:79:34: sparse: sparse: cast to restricted __be16
   net/dsa/tag_sja1105.c:79:34: sparse: sparse: cast to restricted __be16
   net/dsa/tag_sja1105.c:79:16: sparse: sparse: restricted __be16 degrades to integer

vim +76 net/dsa/tag_sja1105.c

    71	
    72	static bool sja1105_can_use_vlan_as_tags(const struct sk_buff *skb)
    73	{
    74		struct vlan_ethhdr *hdr = vlan_eth_hdr(skb);
    75	
  > 76		if (hdr->h_vlan_proto == ntohs(ETH_P_SJA1105))
    77			return true;
    78	
    79		if (hdr->h_vlan_proto != ntohs(ETH_P_8021Q))
    80			return false;
    81	
    82		return vid_is_dsa_8021q(ntohs(hdr->h_vlan_TCI) & VLAN_VID_MASK);
    83	}
    84	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
