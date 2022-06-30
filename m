Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9AB561B7D
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 15:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbiF3Nk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 09:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbiF3Nk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 09:40:56 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0371F615;
        Thu, 30 Jun 2022 06:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656596456; x=1688132456;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3tqDNzAvRt+iYSdl6PYwgkVAx/EfI7NU9igHBoFrI5Y=;
  b=Zl2QdcvHM5xUYJeyH7RFBoPKEm4bfnN3v67ePdeuUH2aqzhR+DnaXY2A
   VoMwlxEpbZznGM/a7+MCYv8Y6xaw3YU/t6Jf4M7lCIWc6GiR3puNPV3Go
   Fk4c4JmAxIxZlc/wziOH2RPCyHZ11wmStcUEVqHvYySx2kV76O1bN1z+C
   djFQa69DepkY5KbpHe0ctIvRUrLKctbbVjlbR4OqqFyqy9xk3v2Qf84W5
   1PIJy/aKsGL2cxX9tNsSjrrl1/IPAsWJA/zCYzeeTGcDGMCXkbfi/xY25
   h18qZmBXDmciPNir0K91mmWZJqHxlkm3hrDE2mRMpt8BfRnHw0MABmmtN
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="283083329"
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="283083329"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 06:40:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="718222089"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 30 Jun 2022 06:40:52 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o6uPc-000Co8-0I;
        Thu, 30 Jun 2022 13:40:52 +0000
Date:   Thu, 30 Jun 2022 21:40:01 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jgg@nvidia.com
Cc:     kbuild-all@lists.01.org, saeedm@nvidia.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, yishaih@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH vfio 08/13] vfio: Introduce the DMA logging feature
 support
Message-ID: <202206302140.XlWYhlXa-lkp@intel.com>
References: <20220630102545.18005-9-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630102545.18005-9-yishaih@nvidia.com>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yishai,

I love your patch! Perhaps something to improve:

[auto build test WARNING on awilliam-vfio/next]
[also build test WARNING on linus/master v5.19-rc4 next-20220630]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Yishai-Hadas/Add-device-DMA-logging-support-for-mlx5-driver/20220630-182957
base:   https://github.com/awilliam/linux-vfio.git next
config: i386-randconfig-a003 (https://download.01.org/0day-ci/archive/20220630/202206302140.XlWYhlXa-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/fea20efca2795fd8480cb0755c54062bad2ea322
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yishai-Hadas/Add-device-DMA-logging-support-for-mlx5-driver/20220630-182957
        git checkout fea20efca2795fd8480cb0755c54062bad2ea322
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/vfio/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/vfio/vfio_main.c: In function 'vfio_ioctl_device_feature_logging_start':
>> drivers/vfio/vfio_main.c:1640:18: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    1640 |         ranges = (struct vfio_device_feature_dma_logging_range __user *)
         |                  ^
   drivers/vfio/vfio_main.c: In function 'vfio_ioctl_device_feature_logging_report':
   drivers/vfio/vfio_main.c:1730:37: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    1730 |                                     (unsigned long __user *)report.bitmap);
         |                                     ^


vim +1640 drivers/vfio/vfio_main.c

  1607	
  1608	static int
  1609	vfio_ioctl_device_feature_logging_start(struct vfio_device *device,
  1610						u32 flags, void __user *arg,
  1611						size_t argsz)
  1612	{
  1613		size_t minsz =
  1614			offsetofend(struct vfio_device_feature_dma_logging_control,
  1615				    ranges);
  1616		struct vfio_device_feature_dma_logging_range __user *ranges;
  1617		struct vfio_device_feature_dma_logging_control control;
  1618		struct vfio_device_feature_dma_logging_range range;
  1619		struct rb_root_cached root = RB_ROOT_CACHED;
  1620		struct interval_tree_node *nodes;
  1621		u32 nnodes;
  1622		int i, ret;
  1623	
  1624		if (!device->log_ops)
  1625			return -ENOTTY;
  1626	
  1627		ret = vfio_check_feature(flags, argsz,
  1628					 VFIO_DEVICE_FEATURE_SET,
  1629					 sizeof(control));
  1630		if (ret != 1)
  1631			return ret;
  1632	
  1633		if (copy_from_user(&control, arg, minsz))
  1634			return -EFAULT;
  1635	
  1636		nnodes = control.num_ranges;
  1637		if (!nnodes || nnodes > LOG_MAX_RANGES)
  1638			return -EINVAL;
  1639	
> 1640		ranges = (struct vfio_device_feature_dma_logging_range __user *)
  1641									control.ranges;
  1642		nodes = kmalloc_array(nnodes, sizeof(struct interval_tree_node),
  1643				      GFP_KERNEL);
  1644		if (!nodes)
  1645			return -ENOMEM;
  1646	
  1647		for (i = 0; i < nnodes; i++) {
  1648			if (copy_from_user(&range, &ranges[i], sizeof(range))) {
  1649				ret = -EFAULT;
  1650				goto end;
  1651			}
  1652			if (!IS_ALIGNED(range.iova, control.page_size) ||
  1653			    !IS_ALIGNED(range.length, control.page_size)) {
  1654				ret = -EINVAL;
  1655				goto end;
  1656			}
  1657			nodes[i].start = range.iova;
  1658			nodes[i].last = range.iova + range.length - 1;
  1659			if (interval_tree_iter_first(&root, nodes[i].start,
  1660						     nodes[i].last)) {
  1661				/* Range overlapping */
  1662				ret = -EINVAL;
  1663				goto end;
  1664			}
  1665			interval_tree_insert(nodes + i, &root);
  1666		}
  1667	
  1668		ret = device->log_ops->log_start(device, &root, nnodes,
  1669						 &control.page_size);
  1670		if (ret)
  1671			goto end;
  1672	
  1673		if (copy_to_user(arg, &control, sizeof(control))) {
  1674			ret = -EFAULT;
  1675			device->log_ops->log_stop(device);
  1676		}
  1677	
  1678	end:
  1679		kfree(nodes);
  1680		return ret;
  1681	}
  1682	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
