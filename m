Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC4C5951A6
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 07:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbiHPFFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 01:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbiHPFE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 01:04:26 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7478FCB5E9;
        Mon, 15 Aug 2022 14:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660597368; x=1692133368;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VmGl5Uf58OVl4vnbualwt0d6SOklcWUqb3Q8mIDSMf8=;
  b=lbVwMLrK9qRZN0NeaO6QvqR2xsGfumIJRcphoibcKl1mfRMKo3fCQsbQ
   +WTdx2gcleoAoaxbw/gLKJO9PghNTw1SmI1gcbdxWz1W7eFBCzGmKYqFG
   qSMv37ClVVwLHT1rtYEr3eS7+J/c0XPQS62GL4U4lIJoj3fb9JEWA7aHf
   +bJ25XTUxcx10O86I2wQtGyAhIbbv3awrRX1PLQm7rsXJEFWAsBCiu2BY
   AaHphbA588e7Eas+KBH+N9pYw9x+8TUtrJPv6N/xnUJWR+F+HyajxA28V
   3oDUs9Vc1gQxlSV4Mgz605psYs2fZFdYlJePX/TOzbdd4ktuJiQJj4HEY
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="292853641"
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="292853641"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 14:02:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="749063797"
Received: from lkp-server02.sh.intel.com (HELO 3d2a4d02a2a9) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 15 Aug 2022 14:02:42 -0700
Received: from kbuild by 3d2a4d02a2a9 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oNhEN-0001E1-1P;
        Mon, 15 Aug 2022 21:02:39 +0000
Date:   Tue, 16 Aug 2022 05:02:10 +0800
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
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] virtio/vsock: add support for dgram
Message-ID: <202208160405.cG02E3MZ-lkp@intel.com>
References: <3cb082f1c88f3f2ef1fc250dbc0745fb79c745c7.1660362668.git.bobby.eshleman@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cb082f1c88f3f2ef1fc250dbc0745fb79c745c7.1660362668.git.bobby.eshleman@bytedance.com>
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
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20220816/202208160405.cG02E3MZ-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/cbb332da78c86ac574688831ed6f404d04d506db
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Bobby-Eshleman/virtio-vsock-introduce-dgrams-sk_buff-and-qdisc/20220816-015812
        git checkout cbb332da78c86ac574688831ed6f404d04d506db
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash net/vmw_vsock/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/vmw_vsock/virtio_transport_common.c: In function 'virtio_transport_dgram_do_dequeue':
>> net/vmw_vsock/virtio_transport_common.c:605:13: warning: variable 'free_space' set but not used [-Wunused-but-set-variable]
     605 |         u32 free_space;
         |             ^~~~~~~~~~


vim +/free_space +605 net/vmw_vsock/virtio_transport_common.c

   597	
   598	static ssize_t
   599	virtio_transport_dgram_do_dequeue(struct vsock_sock *vsk,
   600					  struct msghdr *msg, size_t len)
   601	{
   602		struct virtio_vsock_sock *vvs = vsk->trans;
   603		struct sk_buff *skb;
   604		size_t total = 0;
 > 605		u32 free_space;
   606		int err = -EFAULT;
   607	
   608		spin_lock_bh(&vvs->rx_lock);
   609		if (total < len && !skb_queue_empty_lockless(&vvs->rx_queue)) {
   610			skb = __skb_dequeue(&vvs->rx_queue);
   611	
   612			total = len;
   613			if (total > skb->len - vsock_metadata(skb)->off)
   614				total = skb->len - vsock_metadata(skb)->off;
   615			else if (total < skb->len - vsock_metadata(skb)->off)
   616				msg->msg_flags |= MSG_TRUNC;
   617	
   618			/* sk_lock is held by caller so no one else can dequeue.
   619			 * Unlock rx_lock since memcpy_to_msg() may sleep.
   620			 */
   621			spin_unlock_bh(&vvs->rx_lock);
   622	
   623			err = memcpy_to_msg(msg, skb->data + vsock_metadata(skb)->off, total);
   624			if (err)
   625				return err;
   626	
   627			spin_lock_bh(&vvs->rx_lock);
   628	
   629			virtio_transport_dec_rx_pkt(vvs, skb);
   630			consume_skb(skb);
   631		}
   632	
   633		free_space = vvs->buf_alloc - (vvs->fwd_cnt - vvs->last_fwd_cnt);
   634	
   635		spin_unlock_bh(&vvs->rx_lock);
   636	
   637		if (total > 0 && msg->msg_name) {
   638			/* Provide the address of the sender. */
   639			DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
   640	
   641			vsock_addr_init(vm_addr, le64_to_cpu(vsock_hdr(skb)->src_cid),
   642					le32_to_cpu(vsock_hdr(skb)->src_port));
   643			msg->msg_namelen = sizeof(*vm_addr);
   644		}
   645		return total;
   646	}
   647	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
