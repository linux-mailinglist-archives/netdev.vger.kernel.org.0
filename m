Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD065947CC
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 02:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343737AbiHOXRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 19:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343585AbiHOXO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 19:14:28 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C487AC3D;
        Mon, 15 Aug 2022 13:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660593705; x=1692129705;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=f9d9eqiD8o/ztmd1nw5JG1/VrtylCPBmHS3YYXPs1Dg=;
  b=l1vd7czmxZtStYji/cOGqlpq0P/bIdQp6RlgL0dr5ZrkIlCvm5XLAPcH
   Q0e6Styh/kqOGIlqcH+yyYN3Mg6qESP2tUE8qL8SIv47QdCipNOKKgnIr
   ECG83/lSdgvBQH9iBU0aiBqDNe0NMDaAfbI6qsL3ZMqLqj8H1WFlYSys7
   bdhoScklrK56to2/AAa/Dkhc8nYwvVXB0nTG78s9umjO1g9KTn0IQwd/0
   Pcg8kXZi9LkdVpuKWZ2epYy4bH69W7w1kke3+RmYAWMY0hRBmVrAOLZoZ
   sMGeP2SSGtcVcVrEeDa/UdJ5XE1mkGzfZZnVbFwu+B445cDvvToVuiOVc
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="318036701"
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="318036701"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 13:01:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="606768941"
Received: from lkp-server02.sh.intel.com (HELO 3d2a4d02a2a9) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 15 Aug 2022 13:01:39 -0700
Received: from kbuild by 3d2a4d02a2a9 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oNgHL-0001Cj-06;
        Mon, 15 Aug 2022 20:01:39 +0000
Date:   Tue, 16 Aug 2022 04:01:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Bobby Eshleman <bobby.eshleman@gmail.com>
Cc:     kbuild-all@lists.01.org, Bobby Eshleman <bobbyeshleman@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH 2/6] vsock: return errors other than -ENOMEM to socket
Message-ID: <202208160300.HYFUSTbF-lkp@intel.com>
References: <d81818b868216c774613dd03641fcfe63cc55a45.1660362668.git.bobby.eshleman@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d81818b868216c774613dd03641fcfe63cc55a45.1660362668.git.bobby.eshleman@bytedance.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bobby,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mst-vhost/linux-next]
[also build test WARNING on linus/master v6.0-rc1 next-20220815]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bobby-Eshleman/virtio-vsock-introduce-dgrams-sk_buff-and-qdisc/20220816-015812
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20220816/202208160300.HYFUSTbF-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/68c9c8216a573cdfe2170cad677854e2f4a34634
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Bobby-Eshleman/virtio-vsock-introduce-dgrams-sk_buff-and-qdisc/20220816-015812
        git checkout 68c9c8216a573cdfe2170cad677854e2f4a34634
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash net/vmw_vsock/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/vmw_vsock/virtio_transport.c:178: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
    * Merge the two most recent skbs together if possible.


vim +178 net/vmw_vsock/virtio_transport.c

93afaf2cdefaa9 Bobby Eshleman 2022-08-15  176  
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  177  /**
93afaf2cdefaa9 Bobby Eshleman 2022-08-15 @178   * Merge the two most recent skbs together if possible.
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  179   *
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  180   * Caller must hold the queue lock.
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  181   */
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  182  static void
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  183  virtio_transport_add_to_queue(struct sk_buff_head *queue, struct sk_buff *new)
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  184  {
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  185  	struct sk_buff *old;
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  186  
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  187  	spin_lock_bh(&queue->lock);
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  188  	/* In order to reduce skb memory overhead, we merge new packets with
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  189  	 * older packets if they pass virtio_transport_skbs_can_merge().
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  190  	 */
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  191  	if (skb_queue_empty_lockless(queue)) {
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  192  		__skb_queue_tail(queue, new);
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  193  		goto out;
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  194  	}
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  195  
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  196  	old = skb_peek_tail(queue);
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  197  
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  198  	if (!virtio_transport_skbs_can_merge(old, new)) {
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  199  		__skb_queue_tail(queue, new);
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  200  		goto out;
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  201  	}
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  202  
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  203  	memcpy(skb_put(old, new->len), new->data, new->len);
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  204  	vsock_hdr(old)->len = cpu_to_le32(old->len);
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  205  	vsock_hdr(old)->buf_alloc = vsock_hdr(new)->buf_alloc;
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  206  	vsock_hdr(old)->fwd_cnt = vsock_hdr(new)->fwd_cnt;
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  207  	dev_kfree_skb_any(new);
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  208  
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  209  out:
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  210  	spin_unlock_bh(&queue->lock);
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  211  }
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  212  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
