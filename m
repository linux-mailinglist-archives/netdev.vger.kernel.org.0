Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D70595323
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 08:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbiHPG47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 02:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiHPG4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 02:56:39 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65D511520A;
        Mon, 15 Aug 2022 19:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660616270; x=1692152270;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ke6eAVC77C6+361d8UODTw/ZgPikvq+7bjNByHRqW9M=;
  b=ZhAHe5IGqFndRg1UE/VEok9zs8N0gC0gkavkhq1ttSgjWPf1k0ecnQFR
   x4BpB2gSKJSgcWhNVSru6bCGPe2iYPTyyOQJ+LA1+DSl1j3u1v7XBazmN
   II8kzhQIl6tlNUqnXUCqo9r+vLrL8H999PP3fg6tVpn17g/O62Bc1Yyd2
   C3J2yximMiQVbQ7w8MoeP/8HjUi6rqzrhdvxbQ2Gxtzv1ql1wXyHBmZ8X
   yb/ZtLQpls7lYdF7x557GS1CupCKOWH/Vc8nCBsrSobrZ1M1EKd2vaqNi
   qidHdFJu0g2tW+0qVU6dpUMMj0VKd+AefeJKr/YgZ5qz6z3RsOd+tgAsW
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="292901203"
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="292901203"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 19:17:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="696178385"
Received: from lkp-server02.sh.intel.com (HELO 3d2a4d02a2a9) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Aug 2022 19:17:43 -0700
Received: from kbuild by 3d2a4d02a2a9 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oNm9G-0001Mn-2I;
        Tue, 16 Aug 2022 02:17:42 +0000
Date:   Tue, 16 Aug 2022 10:16:59 +0800
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
Message-ID: <202208161059.GPIlPpvd-lkp@intel.com>
References: <d81818b868216c774613dd03641fcfe63cc55a45.1660362668.git.bobby.eshleman@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d81818b868216c774613dd03641fcfe63cc55a45.1660362668.git.bobby.eshleman@bytedance.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
config: i386-randconfig-s001-20220815 (https://download.01.org/0day-ci/archive/20220816/202208161059.GPIlPpvd-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/68c9c8216a573cdfe2170cad677854e2f4a34634
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Bobby-Eshleman/virtio-vsock-introduce-dgrams-sk_buff-and-qdisc/20220816-015812
        git checkout 68c9c8216a573cdfe2170cad677854e2f4a34634
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash fs/nilfs2/ net/vmw_vsock/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

sparse warnings: (new ones prefixed by >>)
>> net/vmw_vsock/virtio_transport.c:173:31: sparse: sparse: restricted __le16 degrades to integer
   net/vmw_vsock/virtio_transport.c:174:31: sparse: sparse: restricted __le16 degrades to integer

vim +173 net/vmw_vsock/virtio_transport.c

0ea9e1d3a9e3ef Asias He       2016-07-28  161  
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  162  static inline bool
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  163  virtio_transport_skbs_can_merge(struct sk_buff *old, struct sk_buff *new)
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  164  {
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  165  	return (new->len < GOOD_COPY_LEN &&
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  166  		skb_tailroom(old) >= new->len &&
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  167  		vsock_hdr(new)->src_cid == vsock_hdr(old)->src_cid &&
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  168  		vsock_hdr(new)->dst_cid == vsock_hdr(old)->dst_cid &&
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  169  		vsock_hdr(new)->src_port == vsock_hdr(old)->src_port &&
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  170  		vsock_hdr(new)->dst_port == vsock_hdr(old)->dst_port &&
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  171  		vsock_hdr(new)->type == vsock_hdr(old)->type &&
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  172  		vsock_hdr(new)->flags == vsock_hdr(old)->flags &&
93afaf2cdefaa9 Bobby Eshleman 2022-08-15 @173  		vsock_hdr(old)->op == VIRTIO_VSOCK_OP_RW &&
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  174  		vsock_hdr(new)->op == VIRTIO_VSOCK_OP_RW);
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  175  }
93afaf2cdefaa9 Bobby Eshleman 2022-08-15  176  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
