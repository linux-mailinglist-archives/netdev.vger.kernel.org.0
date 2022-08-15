Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E71594ED7
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 04:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbiHPCte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 22:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbiHPCtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 22:49:20 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6200F2B63B0;
        Mon, 15 Aug 2022 16:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660605287; x=1692141287;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gymUZdI4Zmk7S6OzFKoQtBE8+Fa1MVe79gGq0K3OHDA=;
  b=UexT5kxawgdxLIEf7dOO+gsdPpN49Kqq+aSpCssKlGvXDUYQOB1MJGRj
   tuku0qtpDiq25ezr7rzVrPPrLKZzntfb/koLdq7Fa6ZXwYdIaXQtEeniK
   1mUUw7QojFSQENk50JnSmvyDfaUfZm4xfpjdJRw0bhdDMqMJCY2IUKVmA
   cSD4IQHAdhUnG/lguA8HdDjJnOL3K2xrhrjCib0lTTHt6PHHP4OzENsrc
   T54anNaOWTF8pI5V2+izvq9y6ALunYZ8Fx7npzNnBHuxXRZFNjTn19BJj
   TaxG43HPGci9N3WENUAXOYM7SQbEXmajHtX80wBap0oam9HToPcuN38zb
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="356081466"
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="356081466"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 16:14:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="674992473"
Received: from lkp-server02.sh.intel.com (HELO 3d2a4d02a2a9) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 15 Aug 2022 16:14:41 -0700
Received: from kbuild by 3d2a4d02a2a9 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oNjI8-0001Gb-1I;
        Mon, 15 Aug 2022 23:14:40 +0000
Date:   Tue, 16 Aug 2022 07:13:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     Bobby Eshleman <bobby.eshleman@gmail.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Bobby Eshleman <bobbyeshleman@gmail.com>,
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
Message-ID: <202208160737.gXXFmPbY-lkp@intel.com>
References: <d81818b868216c774613dd03641fcfe63cc55a45.1660362668.git.bobby.eshleman@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d81818b868216c774613dd03641fcfe63cc55a45.1660362668.git.bobby.eshleman@bytedance.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bobby,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mst-vhost/linux-next]
[also build test WARNING on linus/master v6.0-rc1]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bobby-Eshleman/virtio-vsock-introduce-dgrams-sk_buff-and-qdisc/20220816-015812
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
config: i386-randconfig-a014-20220815 (https://download.01.org/0day-ci/archive/20220816/202208160737.gXXFmPbY-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 6afcc4a459ead8809a0d6d9b4bf7b64bcc13582b)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/68c9c8216a573cdfe2170cad677854e2f4a34634
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Bobby-Eshleman/virtio-vsock-introduce-dgrams-sk_buff-and-qdisc/20220816-015812
        git checkout 68c9c8216a573cdfe2170cad677854e2f4a34634
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/vmw_vsock/

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
