Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04C64982D8
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 16:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243207AbiAXPCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 10:02:44 -0500
Received: from mga12.intel.com ([192.55.52.136]:5547 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240105AbiAXPCd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 10:02:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643036553; x=1674572553;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QfWyV+HXtcs6rILaxpwLONmm+UzDSrHuA/oNh1yavC0=;
  b=hJ4DA+v6VOrYtnC7REwEKDh4vUtys4WpBNm6kxRrklPWGxyfHDxrUn8n
   Nf+w+qBLm6y67GCYrSblQUSn8NW9sznQeKohdYKJfVF9zv1YGUfn61+TX
   X9j7vo1anHhNa9YW4D4JFmhlMcgviM6pUZ2+FLX1fgOG6H1l2leFCqD1c
   YqSLhIY+3iWFrys90XVvRi2MLuhhRvtRQTuqPCQ0gn7ZOZa8lbNU/zn8f
   wYJntJBbqdd2mwi7vjRicxC00/qlSd/kDbwkU+zEdO74pvQ2BXZLPROby
   r/I/JYVkVRgbLCjLXTHq20vHuarxPI0MgTmhceHHce+Lex4oxC5tJn2mi
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="226042904"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="226042904"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 07:01:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="596809947"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 24 Jan 2022 07:01:47 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nC0qo-000IUh-Iq; Mon, 24 Jan 2022 15:01:46 +0000
Date:   Mon, 24 Jan 2022 23:01:26 +0800
From:   kernel test robot <lkp@intel.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, netdev@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH 3/3] io_uring: zerocopy receive
Message-ID: <202201242233.64QOWQZ1-lkp@intel.com>
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
config: s390-buildonly-randconfig-r004-20220124 (https://download.01.org/0day-ci/archive/20220124/202201242233.64QOWQZ1-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 2e58a18910867ba6795066e044293e6daf89edf5)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/0day-ci/linux/commit/295704165d394635876364522d3ac1451b62da66
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Hao-Xu/io_uring-zerocopy-receive/20220124-174546
        git checkout 295704165d394635876364522d3ac1451b62da66
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from fs/io_uring.c:60:
   In file included from include/linux/blk-mq.h:8:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:464:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:477:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:37:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from fs/io_uring.c:60:
   In file included from include/linux/blk-mq.h:8:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:35:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from fs/io_uring.c:60:
   In file included from include/linux/blk-mq.h:8:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:501:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:511:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:521:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:609:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsb(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:617:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsw(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:625:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsl(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:634:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesb(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:643:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesw(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:652:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesl(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
>> fs/io_uring.c:6639:10: error: implicit declaration of function 'io_recvzc_prep' [-Werror,-Wimplicit-function-declaration]
                   return io_recvzc_prep(req, sqe);
                          ^
   fs/io_uring.c:6639:10: note: did you mean 'io_recvmsg_prep'?
   fs/io_uring.c:5462:1: note: 'io_recvmsg_prep' declared here
   IO_NETOP_PREP_ASYNC(recvmsg);
   ^
   fs/io_uring.c:5454:38: note: expanded from macro 'IO_NETOP_PREP_ASYNC'
   #define IO_NETOP_PREP_ASYNC(op)                                         \
                                                                           ^
   fs/io_uring.c:5449:12: note: expanded from macro '\
   IO_NETOP_PREP'
   static int io_##op##_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe) \
              ^
   <scratch space>:22:1: note: expanded from here
   io_recvmsg_prep
   ^
>> fs/io_uring.c:6924:9: error: implicit declaration of function 'io_recvzc' [-Werror,-Wimplicit-function-declaration]
                   ret = io_recvzc(req, issue_flags);
                         ^
   fs/io_uring.c:6924:9: note: did you mean 'io_recv'?
   fs/io_uring.c:5466:1: note: 'io_recv' declared here
   IO_NETOP_FN(recv);
   ^
   fs/io_uring.c:5442:12: note: expanded from macro 'IO_NETOP_FN'
   static int io_##op(struct io_kiocb *req, unsigned int issue_flags)      \
              ^
   <scratch space>:34:1: note: expanded from here
   io_recv
   ^
   12 warnings and 2 errors generated.


vim +/io_recvzc_prep +6639 fs/io_uring.c

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
