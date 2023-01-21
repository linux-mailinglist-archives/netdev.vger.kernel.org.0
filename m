Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDEB6763DA
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 05:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjAUEnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 23:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjAUEnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 23:43:00 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C7F50853;
        Fri, 20 Jan 2023 20:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674276179; x=1705812179;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=arVUT2kp7AxZby4p5kBezOJfzOwcbkW2d3m7DdS4uug=;
  b=L4rWMAt1uSiG6IqYfegoq4KCgY72loitXXNDDLo+UcwzGoVIA80W+Op8
   B0JtGyldF4c+9GvaQVBT6I3H0PMbpTJtCcTMLfZdgsaOyj5i3Z2HiraXV
   TnTNmazcoDkJZ5ZnqDgpE+yAl6N356aRj6ZHcurMTU81SS1ZWLotFt459
   Cn5skRaRA/94uJuY+Tei54+jvpli2KmXxL/rrosf3W499K51UV9mPSJL1
   ddpz/hiT71AucGvF2olGzPZhkAxtNjEyKBUH09JWcRZgbIpl39RnrTi4A
   3dmItE7lV4VROjrfUgZ1opLj44eGFlfXyRnWgX7u409yzKY2WzNpW9Bqc
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="306117886"
X-IronPort-AV: E=Sophos;i="5.97,234,1669104000"; 
   d="scan'208";a="306117886"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 20:42:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="662767035"
X-IronPort-AV: E=Sophos;i="5.97,234,1669104000"; 
   d="scan'208";a="662767035"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 20 Jan 2023 20:42:52 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pJ5iN-0003Uc-0g;
        Sat, 21 Jan 2023 04:42:51 +0000
Date:   Sat, 21 Jan 2023 12:42:35 +0800
From:   kernel test robot <lkp@intel.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        pabeni@redhat.com, edumazet@google.com, toke@redhat.com,
        memxor@gmail.com, alardam@gmail.com, saeedm@nvidia.com,
        anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH bpf-next 1/7] netdev-genl: create a simple family for
 netdev stuff
Message-ID: <202301211259.eI8T3TMB-lkp@intel.com>
References: <272fa19f57de2d14e9666b4cd9b1ae8a61a94807.1674234430.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <272fa19f57de2d14e9666b4cd9b1ae8a61a94807.1674234430.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

I love your patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Bianconi/netdev-genl-create-a-simple-family-for-netdev-stuff/20230121-011957
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
patch link:    https://lore.kernel.org/r/272fa19f57de2d14e9666b4cd9b1ae8a61a94807.1674234430.git.lorenzo%40kernel.org
patch subject: [PATCH bpf-next 1/7] netdev-genl: create a simple family for netdev stuff
config: x86_64-rhel-8.3-syz (https://download.01.org/0day-ci/archive/20230121/202301211259.eI8T3TMB-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/bab8ed890888146e07283e2ae27174b3562b6931
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Lorenzo-Bianconi/netdev-genl-create-a-simple-family-for-netdev-stuff/20230121-011957
        git checkout bab8ed890888146e07283e2ae27174b3562b6931
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash net/core/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/core/netdev-genl.c: In function 'netdev_nl_dev_fill':
>> net/core/netdev-genl.c:16:13: warning: unused variable 'err' [-Wunused-variable]
      16 |         int err;
         |             ^~~


vim +/err +16 net/core/netdev-genl.c

    10	
    11	static int
    12	netdev_nl_dev_fill(struct net_device *netdev, struct sk_buff *rsp,
    13			   u32 portid, u32 seq, int flags, u32 cmd)
    14	{
    15		void *hdr;
  > 16		int err;
    17	
    18		hdr = genlmsg_put(rsp, portid, seq, &netdev_nl_family, flags, cmd);
    19		if (!hdr)
    20			return -EMSGSIZE;
    21	
    22		if (nla_put_u32(rsp, NETDEV_A_DEV_IFINDEX, netdev->ifindex) ||
    23		    nla_put_u64_64bit(rsp, NETDEV_A_DEV_XDP_FEATURES,
    24				      netdev->xdp_features, NETDEV_A_DEV_PAD)) {
    25			genlmsg_cancel(rsp, hdr);
    26			return -EINVAL;
    27		}
    28	
    29		genlmsg_end(rsp, hdr);
    30	
    31		return 0;
    32	}
    33	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
