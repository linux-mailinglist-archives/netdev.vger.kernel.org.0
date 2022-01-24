Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B784983B6
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 16:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239036AbiAXPm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 10:42:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:23174 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231167AbiAXPm4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 10:42:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643038976; x=1674574976;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=o374rmsG+xD0MCUkRz8aZ3tGXmyq3kmBCir4r7b5GiQ=;
  b=D4fzWCB99saGwxZHUybdqgMH79hQHrlaDTEgl5gLgHsqs4e3vpvOykng
   FCyZaLsgLpX2cXENiEFyE/XfKF2pDaE5TKQHzosUqDwX1wIYB+FcBb9eA
   DMcdCU/0v1CTphVRNiaU/QVV9Jj5w8ZPI1cOFv9oTEBUWVrLl8Yyg51he
   KwOWrTBygO6Z+QrAGibxG4sJjMlKAKNIyq4fKP4DO1L2amPvkkSfQkii5
   /xUNihyFW8kMH/4PRahaNB7CRfh02TYHO1APN8lznZZdUfdPZXbQ+qUgG
   Ruv9HRiEKhdiMzCiA2KTflAENgxDKHS6GRzfLhTqDfSyz1UM96Sy1iVfc
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="233432624"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="233432624"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 07:42:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="494659476"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 24 Jan 2022 07:42:53 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nC1Ua-000IXl-Id; Mon, 24 Jan 2022 15:42:52 +0000
Date:   Mon, 24 Jan 2022 23:42:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, netdev@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH 3/3] io_uring: zerocopy receive
Message-ID: <202201242307.INcQOwqz-lkp@intel.com>
References: <20220124094320.900713-4-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124094320.900713-4-haoxu@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hao,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.17-rc1 next-20220124]
[cannot apply to horms-ipvs/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Hao-Xu/io_uring-zerocopy-receive/20220124-174546
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git dd81e1c7d5fb126e5fbc5c9e334d7b3ec29a16a0
config: h8300-randconfig-r026-20220124 (https://download.01.org/0day-ci/archive/20220124/202201242307.INcQOwqz-lkp@intel.com/config)
compiler: h8300-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/295704165d394635876364522d3ac1451b62da66
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Hao-Xu/io_uring-zerocopy-receive/20220124-174546
        git checkout 295704165d394635876364522d3ac1451b62da66
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=h8300 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/kernel.h:20,
                    from fs/io_uring.c:42:
   include/linux/scatterlist.h: In function 'sg_set_buf':
   include/asm-generic/page.h:89:51: warning: ordered comparison of pointer with null pointer [-Wextra]
      89 | #define virt_addr_valid(kaddr)  (((void *)(kaddr) >= (void *)PAGE_OFFSET) && \
         |                                                   ^~
   include/linux/compiler.h:78:45: note: in definition of macro 'unlikely'
      78 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
   include/linux/scatterlist.h:160:9: note: in expansion of macro 'BUG_ON'
     160 |         BUG_ON(!virt_addr_valid(buf));
         |         ^~~~~~
   include/linux/scatterlist.h:160:17: note: in expansion of macro 'virt_addr_valid'
     160 |         BUG_ON(!virt_addr_valid(buf));
         |                 ^~~~~~~~~~~~~~~
   fs/io_uring.c: In function '__io_submit_flush_completions':
   fs/io_uring.c:2537:40: warning: variable 'prev' set but not used [-Wunused-but-set-variable]
    2537 |         struct io_wq_work_node *node, *prev;
         |                                        ^~~~
   fs/io_uring.c: In function 'io_req_prep':
>> fs/io_uring.c:6639:24: error: implicit declaration of function 'io_recvzc_prep'; did you mean 'io_recvmsg_prep'? [-Werror=implicit-function-declaration]
    6639 |                 return io_recvzc_prep(req, sqe);
         |                        ^~~~~~~~~~~~~~
         |                        io_recvmsg_prep
   fs/io_uring.c: In function 'io_issue_sqe':
>> fs/io_uring.c:6924:23: error: implicit declaration of function 'io_recvzc'; did you mean 'io_recv'? [-Werror=implicit-function-declaration]
    6924 |                 ret = io_recvzc(req, issue_flags);
         |                       ^~~~~~~~~
         |                       io_recv
   cc1: some warnings being treated as errors


vim +6639 fs/io_uring.c

  6560	
  6561	static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
  6562	{
  6563		switch (req->opcode) {
  6564		case IORING_OP_NOP:
  6565			return 0;
  6566		case IORING_OP_READV:
  6567		case IORING_OP_READ_FIXED:
  6568		case IORING_OP_READ:
  6569			return io_read_prep(req, sqe);
  6570		case IORING_OP_WRITEV:
  6571		case IORING_OP_WRITE_FIXED:
  6572		case IORING_OP_WRITE:
  6573			return io_write_prep(req, sqe);
  6574		case IORING_OP_POLL_ADD:
  6575			return io_poll_add_prep(req, sqe);
  6576		case IORING_OP_POLL_REMOVE:
  6577			return io_poll_update_prep(req, sqe);
  6578		case IORING_OP_FSYNC:
  6579			return io_fsync_prep(req, sqe);
  6580		case IORING_OP_SYNC_FILE_RANGE:
  6581			return io_sfr_prep(req, sqe);
  6582		case IORING_OP_SENDMSG:
  6583		case IORING_OP_SEND:
  6584			return io_sendmsg_prep(req, sqe);
  6585		case IORING_OP_RECVMSG:
  6586		case IORING_OP_RECV:
  6587			return io_recvmsg_prep(req, sqe);
  6588		case IORING_OP_CONNECT:
  6589			return io_connect_prep(req, sqe);
  6590		case IORING_OP_TIMEOUT:
  6591			return io_timeout_prep(req, sqe, false);
  6592		case IORING_OP_TIMEOUT_REMOVE:
  6593			return io_timeout_remove_prep(req, sqe);
  6594		case IORING_OP_ASYNC_CANCEL:
  6595			return io_async_cancel_prep(req, sqe);
  6596		case IORING_OP_LINK_TIMEOUT:
  6597			return io_timeout_prep(req, sqe, true);
  6598		case IORING_OP_ACCEPT:
  6599			return io_accept_prep(req, sqe);
  6600		case IORING_OP_FALLOCATE:
  6601			return io_fallocate_prep(req, sqe);
  6602		case IORING_OP_OPENAT:
  6603			return io_openat_prep(req, sqe);
  6604		case IORING_OP_CLOSE:
  6605			return io_close_prep(req, sqe);
  6606		case IORING_OP_FILES_UPDATE:
  6607			return io_rsrc_update_prep(req, sqe);
  6608		case IORING_OP_STATX:
  6609			return io_statx_prep(req, sqe);
  6610		case IORING_OP_FADVISE:
  6611			return io_fadvise_prep(req, sqe);
  6612		case IORING_OP_MADVISE:
  6613			return io_madvise_prep(req, sqe);
  6614		case IORING_OP_OPENAT2:
  6615			return io_openat2_prep(req, sqe);
  6616		case IORING_OP_EPOLL_CTL:
  6617			return io_epoll_ctl_prep(req, sqe);
  6618		case IORING_OP_SPLICE:
  6619			return io_splice_prep(req, sqe);
  6620		case IORING_OP_PROVIDE_BUFFERS:
  6621			return io_provide_buffers_prep(req, sqe);
  6622		case IORING_OP_REMOVE_BUFFERS:
  6623			return io_remove_buffers_prep(req, sqe);
  6624		case IORING_OP_TEE:
  6625			return io_tee_prep(req, sqe);
  6626		case IORING_OP_SHUTDOWN:
  6627			return io_shutdown_prep(req, sqe);
  6628		case IORING_OP_RENAMEAT:
  6629			return io_renameat_prep(req, sqe);
  6630		case IORING_OP_UNLINKAT:
  6631			return io_unlinkat_prep(req, sqe);
  6632		case IORING_OP_MKDIRAT:
  6633			return io_mkdirat_prep(req, sqe);
  6634		case IORING_OP_SYMLINKAT:
  6635			return io_symlinkat_prep(req, sqe);
  6636		case IORING_OP_LINKAT:
  6637			return io_linkat_prep(req, sqe);
  6638		case IORING_OP_RECVZC:
> 6639			return io_recvzc_prep(req, sqe);
  6640		}
  6641	
  6642		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
  6643				req->opcode);
  6644		return -EINVAL;
  6645	}
  6646	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
