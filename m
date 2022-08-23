Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB9459F005
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 01:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbiHWXxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 19:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiHWXxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 19:53:15 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A00486FFC;
        Tue, 23 Aug 2022 16:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661298794; x=1692834794;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/kIfUypIaJTB3fQr1hbYqzYmt4onZmUWZYyjmU75ekM=;
  b=gIqiBakmWfKV78lPjRsr5+nFTIqCXzG1VkKG6DJjq0ZBi5I8mQT0yu7f
   TmCOJ1APbktK/vfVp1i00eH+skSyZNI0N0gpda442n5NUzNOcCkjJ1rsc
   RUe891/uXSzXV35ZRcTAWoxzXjEZCxdRxbn8ZXi/Awz9aYIYraWk/yKlG
   0yV880vOX/lnfIBf2zsF9Sx6J1F1e2sJrUMfHKZQDpfbTF35wZ5tNDWC9
   vwBN/ntbCvQ+I6IIz1Mdac4XYjPa9YGuu8eAXkHo9c0RuKsC6NoGoJ2ua
   6L6X8HDZ9U4wvXwUe57n5aaKE77gdAMCiFJ5RJ0A8u30p2mFOpomsXxuZ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="276847907"
X-IronPort-AV: E=Sophos;i="5.93,259,1654585200"; 
   d="scan'208";a="276847907"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 16:53:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,259,1654585200"; 
   d="scan'208";a="586197176"
Received: from lkp-server02.sh.intel.com (HELO 9bbcefcddf9f) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 23 Aug 2022 16:53:11 -0700
Received: from kbuild by 9bbcefcddf9f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oQdhm-0000jK-2k;
        Tue, 23 Aug 2022 23:53:10 +0000
Date:   Wed, 24 Aug 2022 07:53:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joanne Koong <joannelkoong@gmail.com>, bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, andrii@kernel.org, daniel@iogearbox.net,
        ast@kernel.org, kafai@fb.com, kuba@kernel.org,
        netdev@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: Re: [PATCH bpf-next v4 1/3] bpf: Add skb dynptrs
Message-ID: <202208240751.BRPS1SoF-lkp@intel.com>
References: <20220822235649.2218031-2-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822235649.2218031-2-joannelkoong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joanne,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/Add-skb-xdp-dynptrs/20220823-080022
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: csky-randconfig-r022-20220823 (https://download.01.org/0day-ci/archive/20220824/202208240751.BRPS1SoF-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/a2c8a74d8f0b7fd0b0008dc9bc5ccf9887317f36
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Joanne-Koong/Add-skb-xdp-dynptrs/20220823-080022
        git checkout a2c8a74d8f0b7fd0b0008dc9bc5ccf9887317f36
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=csky SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   csky-linux-ld: kernel/bpf/helpers.o: in function `____bpf_dynptr_read':
>> kernel/bpf/helpers.c:1543: undefined reference to `__bpf_skb_load_bytes'
   csky-linux-ld: kernel/bpf/helpers.o: in function `bpf_dynptr_read':
   kernel/bpf/helpers.c:1522: undefined reference to `__bpf_skb_load_bytes'
   csky-linux-ld: kernel/bpf/helpers.o: in function `____bpf_dynptr_write':
>> kernel/bpf/helpers.c:1584: undefined reference to `__bpf_skb_store_bytes'
   csky-linux-ld: kernel/bpf/helpers.o: in function `bpf_dynptr_write':
   kernel/bpf/helpers.c:1561: undefined reference to `__bpf_skb_store_bytes'


vim +1543 kernel/bpf/helpers.c

  1521	
  1522	BPF_CALL_5(bpf_dynptr_read, void *, dst, u32, len, struct bpf_dynptr_kern *, src,
  1523		   u32, offset, u64, flags)
  1524	{
  1525		enum bpf_dynptr_type type;
  1526		int err;
  1527	
  1528		if (!src->data || flags)
  1529			return -EINVAL;
  1530	
  1531		err = bpf_dynptr_check_off_len(src, offset, len);
  1532		if (err)
  1533			return err;
  1534	
  1535		type = bpf_dynptr_get_type(src);
  1536	
  1537		switch (type) {
  1538		case BPF_DYNPTR_TYPE_LOCAL:
  1539		case BPF_DYNPTR_TYPE_RINGBUF:
  1540			memcpy(dst, src->data + src->offset + offset, len);
  1541			return 0;
  1542		case BPF_DYNPTR_TYPE_SKB:
> 1543			return __bpf_skb_load_bytes(src->data, src->offset + offset, dst, len);
  1544		default:
  1545			WARN(true, "bpf_dynptr_read: unknown dynptr type %d\n", type);
  1546			return -EFAULT;
  1547		}
  1548	}
  1549	
  1550	static const struct bpf_func_proto bpf_dynptr_read_proto = {
  1551		.func		= bpf_dynptr_read,
  1552		.gpl_only	= false,
  1553		.ret_type	= RET_INTEGER,
  1554		.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
  1555		.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
  1556		.arg3_type	= ARG_PTR_TO_DYNPTR,
  1557		.arg4_type	= ARG_ANYTHING,
  1558		.arg5_type	= ARG_ANYTHING,
  1559	};
  1560	
  1561	BPF_CALL_5(bpf_dynptr_write, struct bpf_dynptr_kern *, dst, u32, offset, void *, src,
  1562		   u32, len, u64, flags)
  1563	{
  1564		enum bpf_dynptr_type type;
  1565		int err;
  1566	
  1567		if (!dst->data || bpf_dynptr_is_rdonly(dst))
  1568			return -EINVAL;
  1569	
  1570		err = bpf_dynptr_check_off_len(dst, offset, len);
  1571		if (err)
  1572			return err;
  1573	
  1574		type = bpf_dynptr_get_type(dst);
  1575	
  1576		switch (type) {
  1577		case BPF_DYNPTR_TYPE_LOCAL:
  1578		case BPF_DYNPTR_TYPE_RINGBUF:
  1579			if (flags)
  1580				return -EINVAL;
  1581			memcpy(dst->data + dst->offset + offset, src, len);
  1582			return 0;
  1583		case BPF_DYNPTR_TYPE_SKB:
> 1584			return __bpf_skb_store_bytes(dst->data, dst->offset + offset, src, len,
  1585						     flags);
  1586		default:
  1587			WARN(true, "bpf_dynptr_write: unknown dynptr type %d\n", type);
  1588			return -EFAULT;
  1589		}
  1590	}
  1591	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
