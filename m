Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9202E49BBF5
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 20:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiAYTSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 14:18:39 -0500
Received: from mga17.intel.com ([192.55.52.151]:47821 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229835AbiAYTSU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 14:18:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643138299; x=1674674299;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FwntuYkMFyXC8A/fT+dSEYw/mEXLQW02at8ETMVlkJY=;
  b=ThmMtzwF3Z0JTRyWVZauJkTCKzTQCT7fdKKbA6+LE7okohkGvpSljU9W
   ymQLfDajq+38VksM6soXksmYNLtYhSimXytiT7zYhXCh0pCWNs6f468Rh
   xo75pbr9+bFkuSsj6ZrdH5E3j8/30YB6TNCwzdz+2vmkdESFOBYf/H5zG
   ITDtl9eFSh9ZHS+NsqBFLG7m5e5tniAh5uWPuAqj83d1aSOn+PIDL0ozG
   TpA+A44mIPeoUT2Bhk+Fdc8ZRq42lCjNwWZISl6lwxlrmL9Fjp3rbsnJG
   aVqaNGSjyvGkXvMUmgZwi8Ft9KKL7mD9biVPZUvxD5kO2kj6NfU9IzrrJ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="227066539"
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="227066539"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 11:18:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="624579555"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 25 Jan 2022 11:18:17 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nCRKa-000KMG-Dn; Tue, 25 Jan 2022 19:18:16 +0000
Date:   Wed, 26 Jan 2022 03:17:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        jasowang@redhat.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: Re: [PATCH V2 3/4] vhost_vdpa: don't setup irq offloading when
 irq_num < 0
Message-ID: <202201260245.1yTB6YwE-lkp@intel.com>
References: <20220125091744.115996-4-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125091744.115996-4-lingshan.zhu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Zhu,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mst-vhost/linux-next]
[also build test WARNING on horms-ipvs/master linus/master v5.17-rc1 next-20220125]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Zhu-Lingshan/vDPA-ifcvf-implement-shared-IRQ-feature/20220125-174020
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
config: arm-randconfig-c002-20220124 (https://download.01.org/0day-ci/archive/20220126/202201260245.1yTB6YwE-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 997e128e2a78f5a5434fc75997441ae1ee76f8a4)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://github.com/0day-ci/linux/commit/9242eae873643db8562d24857da7d05a2950ecfe
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Zhu-Lingshan/vDPA-ifcvf-implement-shared-IRQ-feature/20220125-174020
        git checkout 9242eae873643db8562d24857da7d05a2950ecfe
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash drivers/vhost/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/vhost/vdpa.c:99:6: warning: variable 'irq' is uninitialized when used here [-Wuninitialized]
           if (irq < 0)
               ^~~
   drivers/vhost/vdpa.c:94:14: note: initialize the variable 'irq' to silence this warning
           int ret, irq;
                       ^
                        = 0
   1 warning generated.


vim +/irq +99 drivers/vhost/vdpa.c

    88	
    89	static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
    90	{
    91		struct vhost_virtqueue *vq = &v->vqs[qid];
    92		const struct vdpa_config_ops *ops = v->vdpa->config;
    93		struct vdpa_device *vdpa = v->vdpa;
    94		int ret, irq;
    95	
    96		if (!ops->get_vq_irq)
    97			return;
    98	
  > 99		if (irq < 0)
   100			return;
   101	
   102		irq = ops->get_vq_irq(vdpa, qid);
   103		irq_bypass_unregister_producer(&vq->call_ctx.producer);
   104		if (!vq->call_ctx.ctx || irq < 0)
   105			return;
   106	
   107		vq->call_ctx.producer.token = vq->call_ctx.ctx;
   108		vq->call_ctx.producer.irq = irq;
   109		ret = irq_bypass_register_producer(&vq->call_ctx.producer);
   110		if (unlikely(ret))
   111			dev_info(&v->dev, "vq %u, irq bypass producer (token %p) registration fails, ret =  %d\n",
   112				 qid, vq->call_ctx.producer.token, ret);
   113	}
   114	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
