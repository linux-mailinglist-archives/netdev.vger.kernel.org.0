Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE8524C01E4
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 20:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbiBVTQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 14:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235165AbiBVTQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 14:16:20 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA4615E6D4;
        Tue, 22 Feb 2022 11:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645557355; x=1677093355;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=G+u1GVMAA5AenTmPkcf2A62IVjXLsOKGaaxomIJ91iw=;
  b=IbtkdahH8aP+DzoD/UBvDGbtLa6fUOfq0QCTRXp8ou64ALYU9luT57XR
   /afK8IzcOEolYGlCjkmhHfQVu5c9g5VUe20pi7OA42ZSQtazzepkMkmq+
   jmvQDzDqypcatJocWyJhnp9T6Igsu4te9peX6Q5Fg5Ah3zh2924rqeMaH
   RDxcaD3LjaalSf042dDkT8sUSdGDlOdu3/Pv4CMtbuAycUe2xr47VZgvz
   f/0Mh38dhyfztz+LGEtW+mI83QwuDNtjWtE7rxgx8iavRhy562PaW/JhM
   oI9MNC6onyPuT5C3QoBtMAujuRh1Rn46YGdyhEvqjLn8UZY5w3xgLLWZk
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="231763257"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="231763257"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 11:15:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="683627455"
Received: from lkp-server01.sh.intel.com (HELO 788b1cd46f0d) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 22 Feb 2022 11:15:52 -0800
Received: from kbuild by 788b1cd46f0d with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nMadb-0000Wn-Dz; Tue, 22 Feb 2022 19:15:51 +0000
Date:   Wed, 23 Feb 2022 03:15:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Melnychenko <andrew@daynix.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, mst@redhat.com
Cc:     kbuild-all@lists.01.org, yan@daynix.com,
        yuri.benditovich@daynix.com
Subject: Re: [PATCH v4 3/4] drivers/net/virtio_net: Added RSS hash report.
Message-ID: <202202230342.HPYe6dHA-lkp@intel.com>
References: <20220222120054.400208-4-andrew@daynix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222120054.400208-4-andrew@daynix.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mst-vhost/linux-next]
[also build test WARNING on net/master horms-ipvs/master net-next/master linus/master v5.17-rc5 next-20220217]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Andrew-Melnychenko/RSS-support-for-VirtioNet/20220222-200334
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
config: i386-randconfig-s002-20220221 (https://download.01.org/0day-ci/archive/20220223/202202230342.HPYe6dHA-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/4fda71c17afd24d8afb675baa0bb14dbbc6cd23c
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Andrew-Melnychenko/RSS-support-for-VirtioNet/20220222-200334
        git checkout 4fda71c17afd24d8afb675baa0bb14dbbc6cd23c
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
   drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
>> drivers/net/virtio_net.c:1178:35: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected unsigned int [usertype] hash @@     got restricted __le32 const [usertype] hash_value @@
   drivers/net/virtio_net.c:1178:35: sparse:     expected unsigned int [usertype] hash
   drivers/net/virtio_net.c:1178:35: sparse:     got restricted __le32 const [usertype] hash_value

vim +1178 drivers/net/virtio_net.c

  1151	
  1152	static void virtio_skb_set_hash(const struct virtio_net_hdr_v1_hash *hdr_hash,
  1153					struct sk_buff *skb)
  1154	{
  1155		enum pkt_hash_types rss_hash_type;
  1156	
  1157		if (!hdr_hash || !skb)
  1158			return;
  1159	
  1160		switch (hdr_hash->hash_report) {
  1161		case VIRTIO_NET_HASH_REPORT_TCPv4:
  1162		case VIRTIO_NET_HASH_REPORT_UDPv4:
  1163		case VIRTIO_NET_HASH_REPORT_TCPv6:
  1164		case VIRTIO_NET_HASH_REPORT_UDPv6:
  1165		case VIRTIO_NET_HASH_REPORT_TCPv6_EX:
  1166		case VIRTIO_NET_HASH_REPORT_UDPv6_EX:
  1167			rss_hash_type = PKT_HASH_TYPE_L4;
  1168			break;
  1169		case VIRTIO_NET_HASH_REPORT_IPv4:
  1170		case VIRTIO_NET_HASH_REPORT_IPv6:
  1171		case VIRTIO_NET_HASH_REPORT_IPv6_EX:
  1172			rss_hash_type = PKT_HASH_TYPE_L3;
  1173			break;
  1174		case VIRTIO_NET_HASH_REPORT_NONE:
  1175		default:
  1176			rss_hash_type = PKT_HASH_TYPE_NONE;
  1177		}
> 1178		skb_set_hash(skb, hdr_hash->hash_value, rss_hash_type);
  1179	}
  1180	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
