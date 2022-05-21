Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF5C52F8E0
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 07:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237505AbiEUFVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 01:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiEUFVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 01:21:40 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0CB2B197;
        Fri, 20 May 2022 22:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653110497; x=1684646497;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AxY0/ZwmUN9083vJCm9KBOmh71p8D4zqbsXHhQnXUxI=;
  b=jZ7dETym7jN8kKGOojoE8fgY3aXW97Fuxh/Pj8blEoMaYuZgWAINIa+H
   6YhK2F8C5T8Hmx/6w1dULfv+S0FvHtvMPS+47lW2AI0xFHH+aD6M1y3Uz
   jUJVqCzIJNOaDhA3mUAnDY7EgXH04qJoyOqjR6vmaxDdJBRJAYWfsN5x1
   jemHL/MPk+MhOHBGpR5Ma0myWkLKkeAMONGPYfjU6JgulsaPoEwZ8oBnp
   CiKm66Hqy0mwfFjE41E+6TvXZ1TtiqNpJlCmkFU+dtMyPr9BQlxG5XbBu
   YltctikUbnckqIXNKX25Z2MQeVBMm+Wqj50IoT/4lW5SvC+BoBg9/taoD
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10353"; a="252695462"
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; 
   d="scan'208";a="252695462"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 22:21:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; 
   d="scan'208";a="547020986"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 20 May 2022 22:21:30 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nsHYP-0005y2-TN;
        Sat, 21 May 2022 05:21:29 +0000
Date:   Sat, 21 May 2022 13:20:52 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, martinh@xilinx.com,
        hanand@xilinx.com, Si-Wei Liu <si-wei.liu@oracle.com>,
        dinang@xilinx.com, Eli Cohen <elic@nvidia.com>, lvivier@redhat.com,
        pabloc@xilinx.com, gautam.dawar@amd.com,
        Xie Yongji <xieyongji@bytedance.com>, habetsm.xilinx@gmail.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tanuj.kamde@amd.com, eperezma@redhat.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        martinpo@xilinx.com, lulu@redhat.com, ecree.xilinx@gmail.com,
        Parav Pandit <parav@nvidia.com>,
        Dan Carpenter <error27@gmail.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: Re: [PATCH 3/4] vhost-vdpa: uAPI to stop the device
Message-ID: <202205211317.rqYkIW8B-lkp@intel.com>
References: <20220520172325.980884-4-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520172325.980884-4-eperezma@redhat.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi "Eugenio,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mst-vhost/linux-next]
[also build test WARNING on next-20220520]
[cannot apply to horms-ipvs/master linus/master v5.18-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Eugenio-P-rez/Implement-vdpasim-stop-operation/20220521-012742
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
config: hexagon-randconfig-r041-20220519 (https://download.01.org/0day-ci/archive/20220521/202205211317.rqYkIW8B-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project e00cbbec06c08dc616a0d52a20f678b8fbd4e304)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/bd6562e0d85e8d689d30226bcc0f43246e27e4b5
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Eugenio-P-rez/Implement-vdpasim-stop-operation/20220521-012742
        git checkout bd6562e0d85e8d689d30226bcc0f43246e27e4b5
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/vhost/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/vhost/vdpa.c:493:25: warning: variable 'stop' is uninitialized when used here [-Wuninitialized]
           return ops->stop(vdpa, stop);
                                  ^~~~
   drivers/vhost/vdpa.c:485:10: note: initialize the variable 'stop' to silence this warning
           int stop;
                   ^
                    = 0
   1 warning generated.


vim +/stop +493 drivers/vhost/vdpa.c

   480	
   481	static long vhost_vdpa_stop(struct vhost_vdpa *v, u32 __user *argp)
   482	{
   483		struct vdpa_device *vdpa = v->vdpa;
   484		const struct vdpa_config_ops *ops = vdpa->config;
   485		int stop;
   486	
   487		if (!ops->stop)
   488			return -EOPNOTSUPP;
   489	
   490		if (copy_to_user(argp, &stop, sizeof(stop)))
   491			return -EFAULT;
   492	
 > 493		return ops->stop(vdpa, stop);
   494	}
   495	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
