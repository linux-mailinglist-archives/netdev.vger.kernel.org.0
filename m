Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A91AA51FB4A
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 13:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbiEILbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 07:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbiEILbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 07:31:07 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02908DCF;
        Mon,  9 May 2022 04:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652095633; x=1683631633;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ya1pIm6vZbBNzSqJeY65qthxy/T3x9Rl6SrCFaTGnYo=;
  b=KLzsPcKvLJumb91OkJg9jync2y2nIcLR20AGON05uMXeDGrkiz4nA7yo
   SjXWDra0zZl50BmlZC2qk0zhC9shmG/JoeinDfuymQCgToZdqCNBAvArg
   wKJgiDerKQwMbbiOqsxvRA96FKh9IhAlG2SRfLjNbhgRBzlc7207kpJEF
   vkuzswAcZ2mFjDV+I66xPEiMjfqggLjdw1sC1YK0kc0bw9hAF59GGdnl4
   hUPXmdbnT04r7D9hagxZ57btrp7qetbBBFVMJd1Q33+PhSM8v/toNWjis
   YJs5wMlJVLNDd7OqZvQDpmnzbMzQXn6CKJW7uaRUe1u2W2IS45uextPmK
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10341"; a="268685193"
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="268685193"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 04:27:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="622923821"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 09 May 2022 04:27:09 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1no1Xg-000GTA-Fj;
        Mon, 09 May 2022 11:27:08 +0000
Date:   Mon, 9 May 2022 19:26:31 +0800
From:   kernel test robot <lkp@intel.com>
To:     Cindy Lu <lulu@redhat.com>, jasowang@redhat.com, mst@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH v1] vdpa: Do not count the pages that were already pinned
 in the vhost-vDPA
Message-ID: <202205091928.dheTGNAt-lkp@intel.com>
References: <20220509071426.155941-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509071426.155941-1-lulu@redhat.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Cindy,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mst-vhost/linux-next]
[also build test WARNING on linux/master linus/master v5.18-rc6]
[cannot apply to next-20220506]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Cindy-Lu/vdpa-Do-not-count-the-pages-that-were-already-pinned-in-the-vhost-vDPA/20220509-152644
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
config: s390-randconfig-r044-20220509 (https://download.01.org/0day-ci/archive/20220509/202205091928.dheTGNAt-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/4225cc2a756b75d1e0ff7ca2a593bada42def380
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Cindy-Lu/vdpa-Do-not-count-the-pages-that-were-already-pinned-in-the-vhost-vDPA/20220509-152644
        git checkout 4225cc2a756b75d1e0ff7ca2a593bada42def380
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash drivers/vhost/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/vhost/vdpa.c:542:5: warning: no previous prototype for 'vhost_vdpa_add_range_ctx' [-Wmissing-prototypes]
     542 | int vhost_vdpa_add_range_ctx(struct rb_root_cached *root, u64 start, u64 last)
         |     ^~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/vhost/vdpa.c:571:6: warning: no previous prototype for 'vhost_vdpa_del_range' [-Wmissing-prototypes]
     571 | void vhost_vdpa_del_range(struct rb_root_cached *root, u64 start, u64 last)
         |      ^~~~~~~~~~~~~~~~~~~~
>> drivers/vhost/vdpa.c:581:28: warning: no previous prototype for 'vhost_vdpa_search_range' [-Wmissing-prototypes]
     581 | struct interval_tree_node *vhost_vdpa_search_range(struct rb_root_cached *root,
         |                            ^~~~~~~~~~~~~~~~~~~~~~~


vim +/vhost_vdpa_add_range_ctx +542 drivers/vhost/vdpa.c

   464	
   465	static long vhost_vdpa_unlocked_ioctl(struct file *filep,
   466					      unsigned int cmd, unsigned long arg)
   467	{
   468		struct vhost_vdpa *v = filep->private_data;
   469		struct vhost_dev *d = &v->vdev;
   470		void __user *argp = (void __user *)arg;
   471		u64 __user *featurep = argp;
   472		u64 features;
   473		long r = 0;
   474	
   475		if (cmd == VHOST_SET_BACKEND_FEATURES) {
   476			if (copy_from_user(&features, featurep, sizeof(features)))
   477				return -EFAULT;
   478			if (features & ~VHOST_VDPA_BACKEND_FEATURES)
   479				return -EOPNOTSUPP;
   480			vhost_set_backend_features(&v->vdev, features);
   481			return 0;
   482		}
   483	
   484		mutex_lock(&d->mutex);
   485	
   486		switch (cmd) {
   487		case VHOST_VDPA_GET_DEVICE_ID:
   488			r = vhost_vdpa_get_device_id(v, argp);
   489			break;
   490		case VHOST_VDPA_GET_STATUS:
   491			r = vhost_vdpa_get_status(v, argp);
   492			break;
   493		case VHOST_VDPA_SET_STATUS:
   494			r = vhost_vdpa_set_status(v, argp);
   495			break;
   496		case VHOST_VDPA_GET_CONFIG:
   497			r = vhost_vdpa_get_config(v, argp);
   498			break;
   499		case VHOST_VDPA_SET_CONFIG:
   500			r = vhost_vdpa_set_config(v, argp);
   501			break;
   502		case VHOST_GET_FEATURES:
   503			r = vhost_vdpa_get_features(v, argp);
   504			break;
   505		case VHOST_SET_FEATURES:
   506			r = vhost_vdpa_set_features(v, argp);
   507			break;
   508		case VHOST_VDPA_GET_VRING_NUM:
   509			r = vhost_vdpa_get_vring_num(v, argp);
   510			break;
   511		case VHOST_SET_LOG_BASE:
   512		case VHOST_SET_LOG_FD:
   513			r = -ENOIOCTLCMD;
   514			break;
   515		case VHOST_VDPA_SET_CONFIG_CALL:
   516			r = vhost_vdpa_set_config_call(v, argp);
   517			break;
   518		case VHOST_GET_BACKEND_FEATURES:
   519			features = VHOST_VDPA_BACKEND_FEATURES;
   520			if (copy_to_user(featurep, &features, sizeof(features)))
   521				r = -EFAULT;
   522			break;
   523		case VHOST_VDPA_GET_IOVA_RANGE:
   524			r = vhost_vdpa_get_iova_range(v, argp);
   525			break;
   526		case VHOST_VDPA_GET_CONFIG_SIZE:
   527			r = vhost_vdpa_get_config_size(v, argp);
   528			break;
   529		case VHOST_VDPA_GET_VQS_COUNT:
   530			r = vhost_vdpa_get_vqs_count(v, argp);
   531			break;
   532		default:
   533			r = vhost_dev_ioctl(&v->vdev, cmd, argp);
   534			if (r == -ENOIOCTLCMD)
   535				r = vhost_vdpa_vring_ioctl(v, cmd, argp);
   536			break;
   537		}
   538	
   539		mutex_unlock(&d->mutex);
   540		return r;
   541	}
 > 542	int vhost_vdpa_add_range_ctx(struct rb_root_cached *root, u64 start, u64 last)
   543	{
   544		struct interval_tree_node *new_node;
   545	
   546		if (last < start)
   547			return -EFAULT;
   548	
   549		/* If the range being mapped is [0, ULONG_MAX], split it into two entries
   550		 * otherwise its size would overflow u64.
   551		 */
   552		if (start == 0 && last == ULONG_MAX) {
   553			u64 mid = last / 2;
   554	
   555			vhost_vdpa_add_range_ctx(root, start, mid);
   556			start = mid + 1;
   557		}
   558	
   559		new_node = kmalloc(sizeof(struct interval_tree_node), GFP_ATOMIC);
   560		if (!new_node)
   561			return -ENOMEM;
   562	
   563		new_node->start = start;
   564		new_node->last = last;
   565	
   566		interval_tree_insert(new_node, root);
   567	
   568		return 0;
   569	}
   570	
 > 571	void vhost_vdpa_del_range(struct rb_root_cached *root, u64 start, u64 last)
   572	{
   573		struct interval_tree_node *new_node;
   574	
   575		while ((new_node = interval_tree_iter_first(root, start, last))) {
   576			interval_tree_remove(new_node, root);
   577			kfree(new_node);
   578		}
   579	}
   580	
 > 581	struct interval_tree_node *vhost_vdpa_search_range(struct rb_root_cached *root,
   582							   u64 start, u64 last)
   583	{
   584		return interval_tree_iter_first(root, start, last);
   585	}
   586	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
