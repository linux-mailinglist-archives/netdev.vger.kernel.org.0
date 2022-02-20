Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4497D4BD23E
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 23:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244086AbiBTW0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 17:26:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236427AbiBTW0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 17:26:19 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D57C4B422
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 14:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645395958; x=1676931958;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=T/r4vfEwFPYk1j0gY9aoCW1I7CgawpxUlqZPqI7iB0A=;
  b=X8QUn4Wx2EpLEQGqKPjhGRG3IOOl7MJVP1mMJ4GAA9DJtvK300W4RW6I
   UX7jbPTN0m9hvs/S5yFh1vAw7mDkoNp500deKLPJ7BwpbJsD5p9DClh2U
   jSwtxlPJJGjrkt8CDMDYjbsv2FH8Citwr8H9EgTcGe6pZ3+KWOl8/ud4c
   H+yx0Y3zsyXcqWLJdFofs0cN67HzAHOYFyA2AbHe+zFzsc/KbeXDjVOtE
   TFe0oY8oTeiJaUk/kI9sUFQrAt4j12Q81PpCcI88W5IXruwQALswIb0tP
   /iRyX3JI2L6BDQ3WouBCkvNR9eqXqJ6ADFAScYKYrskmOEf+ahxmkQLUb
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="232027967"
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="232027967"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 14:25:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="778524954"
Received: from lkp-server01.sh.intel.com (HELO da3212ac2f54) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 20 Feb 2022 14:25:55 -0800
Received: from kbuild by da3212ac2f54 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nLueR-0000w9-1V; Sun, 20 Feb 2022 22:25:55 +0000
Date:   Mon, 21 Feb 2022 06:24:51 +0800
From:   kernel test robot <lkp@intel.com>
To:     Roopa Prabhu <roopa@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        stephen@networkplumber.org, nikolay@cumulusnetworks.com,
        idosch@nvidia.com, dsahern@gmail.com
Subject: Re: [PATCH net-next 08/12] vxlan: vni filtering support on collect
 metadata device
Message-ID: <202202210620.Qp46jPJO-lkp@intel.com>
References: <20220220140405.1646839-9-roopa@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220220140405.1646839-9-roopa@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roopa,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Roopa-Prabhu/vxlan-metadata-device-vnifiltering-support/20220220-220748
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 129c77b5692d4a95a00aa7d58075afe77179623e
config: m68k-randconfig-s032-20220220 (https://download.01.org/0day-ci/archive/20220221/202202210620.Qp46jPJO-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/5344344656a955610e1a596bf3de904d5c6647f4
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Roopa-Prabhu/vxlan-metadata-device-vnifiltering-support/20220220-220748
        git checkout 5344344656a955610e1a596bf3de904d5c6647f4
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=m68k SHELL=/bin/bash drivers/net/vxlan/ kernel/time/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

>> drivers/net/vxlan/vxlan_multicast.c:181:5: warning: no previous prototype for 'vxlan_multicast_join_vnigrp' [-Wmissing-prototypes]
     181 | int vxlan_multicast_join_vnigrp(struct vxlan_dev *vxlan)
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/vxlan/vxlan_multicast.c:218:5: warning: no previous prototype for 'vxlan_multicast_leave_vnigrp' [-Wmissing-prototypes]
     218 | int vxlan_multicast_leave_vnigrp(struct vxlan_dev *vxlan)
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from drivers/net/vxlan/vxlan_multicast.c:12:
   drivers/net/vxlan/vxlan_private.h:13:17: warning: 'all_zeros_mac' defined but not used [-Wunused-const-variable=]
      13 | static const u8 all_zeros_mac[ETH_ALEN + 2];
         |                 ^~~~~~~~~~~~~
--
>> drivers/net/vxlan/vxlan_vnifilter.c:20:6: warning: no previous prototype for 'vxlan_vs_add_del_vninode' [-Wmissing-prototypes]
      20 | void vxlan_vs_add_del_vninode(struct vxlan_dev *vxlan,
         |      ^~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/vxlan/vxlan_vnifilter.c: In function 'vxlan_vnifilter_dump_dev':
   drivers/net/vxlan/vxlan_vnifilter.c:202:39: warning: variable 'tmsg' set but not used [-Wunused-but-set-variable]
     202 |         struct tunnel_msg *new_tmsg, *tmsg;
         |                                       ^~~~
   drivers/net/vxlan/vxlan_vnifilter.c: In function 'vxlan_vni_alloc':
>> drivers/net/vxlan/vxlan_vnifilter.c:546:18: error: 'struct vxlan_vni_node' has no member named 'hlist6'; did you mean 'hlist4'?
     546 |         vninode->hlist6.vxlan = vxlan;
         |                  ^~~~~~
         |                  hlist4
   drivers/net/vxlan/vxlan_vnifilter.c: In function 'vxlan_vnigroup_uninit':
   drivers/net/vxlan/vxlan_vnifilter.c:731:40: error: 'struct vxlan_vni_node' has no member named 'hlist6'; did you mean 'hlist4'?
     731 |                 hlist_del_init_rcu(&v->hlist6.hlist);
         |                                        ^~~~~~
         |                                        hlist4


sparse warnings: (new ones prefixed by >>)
>> drivers/net/vxlan/vxlan_multicast.c:181:5: sparse: sparse: symbol 'vxlan_multicast_join_vnigrp' was not declared. Should it be static?
>> drivers/net/vxlan/vxlan_multicast.c:218:5: sparse: sparse: symbol 'vxlan_multicast_leave_vnigrp' was not declared. Should it be static?

vim +546 drivers/net/vxlan/vxlan_vnifilter.c

   535	
   536	static struct vxlan_vni_node *vxlan_vni_alloc(struct vxlan_dev *vxlan,
   537						      __be32 vni)
   538	{
   539		struct vxlan_vni_node *vninode;
   540	
   541		vninode = kzalloc(sizeof(*vninode), GFP_ATOMIC);
   542		if (!vninode)
   543			return NULL;
   544		vninode->vni = vni;
   545		vninode->hlist4.vxlan = vxlan;
 > 546		vninode->hlist6.vxlan = vxlan;
   547	
   548		return vninode;
   549	}
   550	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
