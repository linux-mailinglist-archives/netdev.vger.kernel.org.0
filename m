Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D651526146
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 13:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378165AbiEMLon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 07:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345668AbiEMLol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 07:44:41 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43605FF08;
        Fri, 13 May 2022 04:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652442280; x=1683978280;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=b57vSAPzKx+7+zmpE1DDjKWcW89L6UeLoYaHwv1Ix9A=;
  b=PoRiZDcroWh8waylnism6hO+4hXDHpexjMQCRIEe6Pn4rT4J173SGYEK
   BA4RzzXNPts0ir5wDkycima4fdWQLzYMF82GT5hLaLwYzgt61sz11S6RJ
   cLoVJbvtn+QlTqoRrDKXW6jve+z6vATWI2VbCf3I47KvN66c1EBSHR96n
   lHbkxmLQyqs4/H/SN/ip4+SEnPoE410IAWgC+q/728CJHQSjL6g5uk8wM
   NcMwcGxPpag7Dyy3nWt4qSlEtWgEwhEbZ9Oedyhwfl3PHw5uS7ZTDRTOT
   1x5Oh0O45mGng/VHL2eBRMuy59+DFHjy2U79yacoxsfx9Jmjrc1u1mZ0x
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="252333152"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="252333152"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 04:44:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="572945975"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 13 May 2022 04:44:37 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1npTin-000LhQ-7z;
        Fri, 13 May 2022 11:44:37 +0000
Date:   Fri, 13 May 2022 19:44:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        kgraul@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     kbuild-all@lists.01.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net/smc: rdma write inline if qp has
 sufficient inline space
Message-ID: <202205131912.bHaVZP7f-lkp@intel.com>
References: <20220513071551.22065-3-guangguan.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513071551.22065-3-guangguan.wang@linux.alibaba.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Guangguan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Guangguan-Wang/net-smc-send-and-write-inline-optimization-for-smc/20220513-151715
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git b67fd3d9d94223b424674f45eeadeff58b4b03ef
config: nios2-allyesconfig (https://download.01.org/0day-ci/archive/20220513/202205131912.bHaVZP7f-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/1e1003898ecdb92b0339075c7501e486bda2d8e8
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Guangguan-Wang/net-smc-send-and-write-inline-optimization-for-smc/20220513-151715
        git checkout 1e1003898ecdb92b0339075c7501e486bda2d8e8
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=nios2 SHELL=/bin/bash net/smc/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/smc/smc_tx.c: In function 'smcr_tx_rdma_writes':
>> net/smc/smc_tx.c:399:37: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     399 |                         base_addr = (u64)conn->sndbuf_desc->cpu_addr;
         |                                     ^


vim +399 net/smc/smc_tx.c

   376	
   377	/* SMC-R helper for smc_tx_rdma_writes() */
   378	static int smcr_tx_rdma_writes(struct smc_connection *conn, size_t len,
   379				       size_t src_off, size_t src_len,
   380				       size_t dst_off, size_t dst_len,
   381				       struct smc_rdma_wr *wr_rdma_buf)
   382	{
   383		struct smc_link *link = conn->lnk;
   384	
   385		dma_addr_t dma_addr =
   386			sg_dma_address(conn->sndbuf_desc->sgt[link->link_idx].sgl);
   387		int src_len_sum = src_len, dst_len_sum = dst_len;
   388		int sent_count = src_off;
   389		int srcchunk, dstchunk;
   390		int num_sges;
   391		int rc;
   392	
   393		for (dstchunk = 0; dstchunk < 2; dstchunk++) {
   394			struct ib_rdma_wr *wr = &wr_rdma_buf->wr_tx_rdma[dstchunk];
   395			struct ib_sge *sge = wr->wr.sg_list;
   396			u64 base_addr = dma_addr;
   397	
   398			if (dst_len <= link->qp_attr.cap.max_inline_data) {
 > 399				base_addr = (u64)conn->sndbuf_desc->cpu_addr;
   400				wr->wr.send_flags |= IB_SEND_INLINE;
   401			} else {
   402				wr->wr.send_flags &= ~IB_SEND_INLINE;
   403			}
   404	
   405			num_sges = 0;
   406			for (srcchunk = 0; srcchunk < 2; srcchunk++) {
   407				sge[srcchunk].addr = base_addr + src_off;
   408				sge[srcchunk].length = src_len;
   409				num_sges++;
   410	
   411				src_off += src_len;
   412				if (src_off >= conn->sndbuf_desc->len)
   413					src_off -= conn->sndbuf_desc->len;
   414							/* modulo in send ring */
   415				if (src_len_sum == dst_len)
   416					break; /* either on 1st or 2nd iteration */
   417				/* prepare next (== 2nd) iteration */
   418				src_len = dst_len - src_len; /* remainder */
   419				src_len_sum += src_len;
   420			}
   421			rc = smc_tx_rdma_write(conn, dst_off, num_sges, wr);
   422			if (rc)
   423				return rc;
   424			if (dst_len_sum == len)
   425				break; /* either on 1st or 2nd iteration */
   426			/* prepare next (== 2nd) iteration */
   427			dst_off = 0; /* modulo offset in RMBE ring buffer */
   428			dst_len = len - dst_len; /* remainder */
   429			dst_len_sum += dst_len;
   430			src_len = min_t(int, dst_len, conn->sndbuf_desc->len -
   431					sent_count);
   432			src_len_sum = src_len;
   433		}
   434		return 0;
   435	}
   436	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
