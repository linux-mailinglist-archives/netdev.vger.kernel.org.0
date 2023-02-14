Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44645696AC6
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 18:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjBNRGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 12:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbjBNRGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 12:06:31 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDF32B280;
        Tue, 14 Feb 2023 09:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676394381; x=1707930381;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JlJlccPPsCKSMrUu0LtHuZVJfasNtUfNxGXSsBatVqE=;
  b=nJB4C1y2UO0m9KNtwUoE2xEMUvmZSFyjRhZaj5wCqnvMmAoCvUcIfn5M
   BanSBubnDyHCvyzH6ICUE+UbBk8X0fObIBK6tM1IkgippWz9npO4ezQJU
   nTYh4EWYkc1dD9iGAcGYtLv0KYy09hkel8NugXyjVIm3Tz9CpIPoiw8JL
   XzEciQ+YWo8l5DaFNC60KFd+EvhoWFfkRYVlO/0NRhFDbH4XVZYnmGjZY
   HUBkOACCm/L/tnHFb5G4PLTmTaGM6vh+jvUOpkwmL9tyDRw9/9xAtX0KO
   cRFTKG89M5ZL57hwIgiJbbNRHt2zkYsQAIGqFOmNXwpNYPtVymCKVboVw
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="393610999"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="393610999"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 09:06:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="671276516"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="671276516"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 14 Feb 2023 09:06:17 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pRyky-0008fD-2h;
        Tue, 14 Feb 2023 17:06:16 +0000
Date:   Wed, 15 Feb 2023 01:05:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v3] xsk: support use vaddr as ring
Message-ID: <202302150059.M0lYLPTa-lkp@intel.com>
References: <20230214015112.12094-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214015112.12094-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xuan,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Xuan-Zhuo/xsk-support-use-vaddr-as-ring/20230214-095210
patch link:    https://lore.kernel.org/r/20230214015112.12094-1-xuanzhuo%40linux.alibaba.com
patch subject: [PATCH net-next v3] xsk: support use vaddr as ring
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20230215/202302150059.M0lYLPTa-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/a2f7f17c84b0f4af1d0a8903b2b5e8e558f8359a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Xuan-Zhuo/xsk-support-use-vaddr-as-ring/20230214-095210
        git checkout a2f7f17c84b0f4af1d0a8903b2b5e8e558f8359a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh SHELL=/bin/bash net/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302150059.M0lYLPTa-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/xdp/xsk.c: In function 'xsk_mmap':
>> net/xdp/xsk.c:1323:16: error: implicit declaration of function 'remap_vmalloc_range'; did you mean 'ida_alloc_range'? [-Werror=implicit-function-declaration]
    1323 |         return remap_vmalloc_range(vma, q->ring, 0);
         |                ^~~~~~~~~~~~~~~~~~~
         |                ida_alloc_range
   cc1: some warnings being treated as errors


vim +1323 net/xdp/xsk.c

  1290	
  1291	static int xsk_mmap(struct file *file, struct socket *sock,
  1292			    struct vm_area_struct *vma)
  1293	{
  1294		loff_t offset = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
  1295		unsigned long size = vma->vm_end - vma->vm_start;
  1296		struct xdp_sock *xs = xdp_sk(sock->sk);
  1297		struct xsk_queue *q = NULL;
  1298	
  1299		if (READ_ONCE(xs->state) != XSK_READY)
  1300			return -EBUSY;
  1301	
  1302		if (offset == XDP_PGOFF_RX_RING) {
  1303			q = READ_ONCE(xs->rx);
  1304		} else if (offset == XDP_PGOFF_TX_RING) {
  1305			q = READ_ONCE(xs->tx);
  1306		} else {
  1307			/* Matches the smp_wmb() in XDP_UMEM_REG */
  1308			smp_rmb();
  1309			if (offset == XDP_UMEM_PGOFF_FILL_RING)
  1310				q = READ_ONCE(xs->fq_tmp);
  1311			else if (offset == XDP_UMEM_PGOFF_COMPLETION_RING)
  1312				q = READ_ONCE(xs->cq_tmp);
  1313		}
  1314	
  1315		if (!q)
  1316			return -EINVAL;
  1317	
  1318		/* Matches the smp_wmb() in xsk_init_queue */
  1319		smp_rmb();
  1320		if (size > PAGE_ALIGN(q->ring_size))
  1321			return -EINVAL;
  1322	
> 1323		return remap_vmalloc_range(vma, q->ring, 0);
  1324	}
  1325	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
