Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582536D27BE
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 20:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbjCaSYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 14:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbjCaSX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 14:23:58 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585321D2DD;
        Fri, 31 Mar 2023 11:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680287036; x=1711823036;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RfULin+IQkEIXF2U8/tMLOvTdsd0rNfXguvY06ABEEY=;
  b=OlehgERxMqxiKS5DrK+I39W5yfZEY268Gx8vnQJlmUSXHr4A4wkI1trj
   Ra0NEfY5yxj5E6uhskqiTZNvHyDLKcMyVftElSSj3MSzzmNT5ClIMWGsV
   kr1IYuZTAkF22kXOUfqsR5UiAyNRSWSpMmeqZ0KvlYM5kL2+rlHAvFi79
   0ljUGd1+Rjq9GKen/RHLrUWSGqiFt85tXyqKGfTrzlUr0apoXxsO5Hd+a
   1TWVh0d4NwJFrDYLn9ZMNV26k9Q4XDXQhCjflUlYO58Qy3DL7PJWe2OPT
   X0UQ9jB/JSENgZGVPK+2dglrdEUqo8/FB7xNaibgybBTzaDyNVp7kPaXB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10666"; a="406551718"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="406551718"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2023 11:23:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10666"; a="717827064"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="717827064"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 31 Mar 2023 11:23:50 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1piJPh-000M2G-1G;
        Fri, 31 Mar 2023 18:23:49 +0000
Date:   Sat, 1 Apr 2023 02:23:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        yoong.siang.song@intel.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, kuba@kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, hawk@kernel.org, davem@davemloft.net,
        tariqt@nvidia.com
Subject: Re: [PATCH bpf V4 1/5] xdp: rss hash types representation
Message-ID: <202304010239.Jw6bKkWC-lkp@intel.com>
References: <168027498690.3941176.99100635661990098.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168027498690.3941176.99100635661990098.stgit@firesoul>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesper,

I love your patch! Yet something to improve:

[auto build test ERROR on bpf/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Jesper-Dangaard-Brouer/xdp-rss-hash-types-representation/20230331-230552
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git master
patch link:    https://lore.kernel.org/r/168027498690.3941176.99100635661990098.stgit%40firesoul
patch subject: [PATCH bpf V4 1/5] xdp: rss hash types representation
config: ia64-allyesconfig (https://download.01.org/0day-ci/archive/20230401/202304010239.Jw6bKkWC-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/9fcbbefa76e6e88a86426d13ed79ea24aacffe76
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jesper-Dangaard-Brouer/xdp-rss-hash-types-representation/20230331-230552
        git checkout 9fcbbefa76e6e88a86426d13ed79ea24aacffe76
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 SHELL=/bin/bash drivers/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304010239.Jw6bKkWC-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/net/veth.c:1685:43: error: initialization of 'int (*)(const struct xdp_md *, u32 *, enum xdp_rss_hash_type *)' {aka 'int (*)(const struct xdp_md *, unsigned int *, enum xdp_rss_hash_type *)'} from incompatible pointer type 'int (*)(const struct xdp_md *, u32 *)' {aka 'int (*)(const struct xdp_md *, unsigned int *)'} [-Werror=incompatible-pointer-types]
    1685 |         .xmo_rx_hash                    = veth_xdp_rx_hash,
         |                                           ^~~~~~~~~~~~~~~~
   drivers/net/veth.c:1685:43: note: (near initialization for 'veth_xdp_metadata_ops.xmo_rx_hash')
   cc1: some warnings being treated as errors


vim +1685 drivers/net/veth.c

4456e7bdf74c9f Stephen Hemminger  2008-11-19  1682  
306531f0249f4e Stanislav Fomichev 2023-01-19  1683  static const struct xdp_metadata_ops veth_xdp_metadata_ops = {
306531f0249f4e Stanislav Fomichev 2023-01-19  1684  	.xmo_rx_timestamp		= veth_xdp_rx_timestamp,
306531f0249f4e Stanislav Fomichev 2023-01-19 @1685  	.xmo_rx_hash			= veth_xdp_rx_hash,
306531f0249f4e Stanislav Fomichev 2023-01-19  1686  };
306531f0249f4e Stanislav Fomichev 2023-01-19  1687  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
