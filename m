Return-Path: <netdev+bounces-732-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 589A06F9685
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 04:01:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE35A2811C0
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 02:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22EB915B4;
	Sun,  7 May 2023 02:01:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050CA15B3
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 02:01:29 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E1819D5A;
	Sat,  6 May 2023 19:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683424888; x=1714960888;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ptf4unfeFKQSxu7srKXgXN9GXz/RarIXfXvuJ0CcTjc=;
  b=l6DS42VBNdU4Y61TMCXy3GYTsdosuyRMf5dyLSIuiZF0iDpUr41RExXi
   Ak+jyCvymTWb8NlPSZVcY+lPrQNGhEE1gmwLzF/ioCzIHdY2QDx6dHerf
   gOru8OHKGATvMeR0VmRnjQ48pufCwTDKBNrm+A1T/oy+fJckJHyn/4NsG
   pCu6xnUdJ2WdhhPIL8hSYq4JV+8QIxj98P6bX9vDoiMiAzwunIsA2W1nw
   91iHXBHNMX1BqPoWMqxBtlmFA3VUF10XFhuGGrU4GixoXkGNlJtMLrf/B
   tPSg5/P3ESbIJ1DVyixg26ioHTCLHmSrvhQ6CntM+0qenXKp+H8GS4YRg
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10702"; a="414991602"
X-IronPort-AV: E=Sophos;i="5.99,256,1677571200"; 
   d="scan'208";a="414991602"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2023 19:01:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10702"; a="675620276"
X-IronPort-AV: E=Sophos;i="5.99,256,1677571200"; 
   d="scan'208";a="675620276"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 06 May 2023 19:01:26 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pvTiH-0000Z5-1Y;
	Sun, 07 May 2023 02:01:25 +0000
Date: Sun, 7 May 2023 10:01:20 +0800
From: kernel test robot <lkp@intel.com>
To: Chris Leech <cleech@redhat.com>, Lee Duncan <lduncan@suse.com>,
	linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
	netdev@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Chris Leech <cleech@redhat.com>
Subject: Re: [PATCH 06/11] iscsi: set netns for tcp and iser hosts
Message-ID: <202305070951.jhFIquOM-lkp@intel.com>
References: <20230506232930.195451-7-cleech@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230506232930.195451-7-cleech@redhat.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Chris,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next horms-ipvs/master linus/master v6.3 next-20230505]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Chris-Leech/iscsi-create-per-net-iscsi-netlink-kernel-sockets/20230507-073308
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20230506232930.195451-7-cleech%40redhat.com
patch subject: [PATCH 06/11] iscsi: set netns for tcp and iser hosts
config: i386-randconfig-a005 (https://download.01.org/0day-ci/archive/20230507/202305070951.jhFIquOM-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-12) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/a287abe6fb8da0c4af44c1d83fad9ca4fcb7184f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Chris-Leech/iscsi-create-per-net-iscsi-netlink-kernel-sockets/20230507-073308
        git checkout a287abe6fb8da0c4af44c1d83fad9ca4fcb7184f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 olddefconfig
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/scsi/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305070951.jhFIquOM-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/scsi_transport_iscsi.c:234:1: warning: no previous prototype for '__iscsi_create_endpoint' [-Wmissing-prototypes]
     234 | __iscsi_create_endpoint(struct Scsi_Host *shost, int dd_size, struct net *net)
         | ^~~~~~~~~~~~~~~~~~~~~~~


vim +/__iscsi_create_endpoint +234 drivers/scsi/scsi_transport_iscsi.c

   232	
   233	struct iscsi_endpoint *
 > 234	__iscsi_create_endpoint(struct Scsi_Host *shost, int dd_size, struct net *net)
   235	{
   236		struct iscsi_endpoint *ep;
   237		int err, id;
   238	
   239		ep = kzalloc(sizeof(*ep) + dd_size, GFP_KERNEL);
   240		if (!ep)
   241			return NULL;
   242	
   243		mutex_lock(&iscsi_ep_idr_mutex);
   244	
   245		/*
   246		 * First endpoint id should be 1 to comply with user space
   247		 * applications (iscsid).
   248		 */
   249		id = idr_alloc(&iscsi_ep_idr, ep, 1, -1, GFP_NOIO);
   250		if (id < 0) {
   251			mutex_unlock(&iscsi_ep_idr_mutex);
   252			printk(KERN_ERR "Could not allocate endpoint ID. Error %d.\n",
   253			       id);
   254			goto free_ep;
   255		}
   256		mutex_unlock(&iscsi_ep_idr_mutex);
   257	
   258		ep->id = id;
   259		ep->dev.class = &iscsi_endpoint_class;
   260		if (shost)
   261			ep->dev.parent = &shost->shost_gendev;
   262		if (net)
   263			ep->netns = net;
   264		dev_set_name(&ep->dev, "ep-%d", id);
   265		err = device_register(&ep->dev);
   266	        if (err)
   267			goto put_dev;
   268	
   269		err = sysfs_create_group(&ep->dev.kobj, &iscsi_endpoint_group);
   270		if (err)
   271			goto unregister_dev;
   272	
   273		if (dd_size)
   274			ep->dd_data = &ep[1];
   275		return ep;
   276	
   277	unregister_dev:
   278		device_unregister(&ep->dev);
   279		return NULL;
   280	
   281	put_dev:
   282		mutex_lock(&iscsi_ep_idr_mutex);
   283		idr_remove(&iscsi_ep_idr, id);
   284		mutex_unlock(&iscsi_ep_idr_mutex);
   285		put_device(&ep->dev);
   286		return NULL;
   287	free_ep:
   288		kfree(ep);
   289		return NULL;
   290	}
   291	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

