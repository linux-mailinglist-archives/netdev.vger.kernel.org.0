Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965D152605A
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 12:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379586AbiEMKni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 06:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379580AbiEMKnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 06:43:37 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4771078A0;
        Fri, 13 May 2022 03:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652438616; x=1683974616;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BdqrzcXRZKOAVCmDpevsRh9iA39ZHGPnaSUGJajxz/E=;
  b=a7VhJFbiNHcZw/bjqQJqH+F+xDR1rmULBRpAG2O8lUYYuAON5+eHD6zA
   9BZb+BFZLuu9UCkCHD3zj9zXOrJHzQFn6hXnPABbWWo6K+yQ9tBcdFtJo
   PE+b+inQZUb1AI2Xd+zqAJIT61cbSxw2GXN5JbS/lv2Uua7HFEnjqR1i9
   SXv4btaDNsfP+UOxFLlCpe0LeIGO0N1FVI+DkiquC+PwhgvOzlVCHWaP+
   1t/fw8JlMV1Mk1bttsuUSC+9e/yCX2RZd9C6e1HW4j6LfJUKav2hUreiK
   uBsjPlOTJzLo65tZZKb8S2H08WOKNKVuDqd9OJiiolHaB3G10cM2YI81J
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="250807313"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="250807313"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 03:43:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="712350022"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 13 May 2022 03:43:33 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1npSlg-000Lds-Nu;
        Fri, 13 May 2022 10:43:32 +0000
Date:   Fri, 13 May 2022 18:42:56 +0800
From:   kernel test robot <lkp@intel.com>
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        kgraul@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     kbuild-all@lists.01.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net/smc: send cdc msg inline if qp has
 sufficient inline space
Message-ID: <202205131842.j3oh7PXI-lkp@intel.com>
References: <20220513071551.22065-2-guangguan.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513071551.22065-2-guangguan.wang@linux.alibaba.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
config: nios2-allyesconfig (https://download.01.org/0day-ci/archive/20220513/202205131842.j3oh7PXI-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/bac726bf950dac20959af52c6884b7bb07772dac
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Guangguan-Wang/net-smc-send-and-write-inline-optimization-for-smc/20220513-151715
        git checkout bac726bf950dac20959af52c6884b7bb07772dac
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=nios2 SHELL=/bin/bash net/smc/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/smc/smc_wr.c: In function 'smc_wr_init_sge':
>> net/smc/smc_wr.c:561:57: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     561 |                 lnk->wr_tx_sges[i].addr = send_inline ? (u64)(&lnk->wr_tx_bufs[i]) :
         |                                                         ^


vim +561 net/smc/smc_wr.c

   553	
   554	static void smc_wr_init_sge(struct smc_link *lnk)
   555	{
   556		int sges_per_buf = (lnk->lgr->smc_version == SMC_V2) ? 2 : 1;
   557		bool send_inline = (lnk->qp_attr.cap.max_inline_data >= SMC_WR_TX_SIZE);
   558		u32 i;
   559	
   560		for (i = 0; i < lnk->wr_tx_cnt; i++) {
 > 561			lnk->wr_tx_sges[i].addr = send_inline ? (u64)(&lnk->wr_tx_bufs[i]) :
   562				lnk->wr_tx_dma_addr + i * SMC_WR_BUF_SIZE;
   563			lnk->wr_tx_sges[i].length = SMC_WR_TX_SIZE;
   564			lnk->wr_tx_sges[i].lkey = lnk->roce_pd->local_dma_lkey;
   565			lnk->wr_tx_rdma_sges[i].tx_rdma_sge[0].wr_tx_rdma_sge[0].lkey =
   566				lnk->roce_pd->local_dma_lkey;
   567			lnk->wr_tx_rdma_sges[i].tx_rdma_sge[0].wr_tx_rdma_sge[1].lkey =
   568				lnk->roce_pd->local_dma_lkey;
   569			lnk->wr_tx_rdma_sges[i].tx_rdma_sge[1].wr_tx_rdma_sge[0].lkey =
   570				lnk->roce_pd->local_dma_lkey;
   571			lnk->wr_tx_rdma_sges[i].tx_rdma_sge[1].wr_tx_rdma_sge[1].lkey =
   572				lnk->roce_pd->local_dma_lkey;
   573			lnk->wr_tx_ibs[i].next = NULL;
   574			lnk->wr_tx_ibs[i].sg_list = &lnk->wr_tx_sges[i];
   575			lnk->wr_tx_ibs[i].num_sge = 1;
   576			lnk->wr_tx_ibs[i].opcode = IB_WR_SEND;
   577			lnk->wr_tx_ibs[i].send_flags =
   578				IB_SEND_SIGNALED | IB_SEND_SOLICITED;
   579			if (send_inline)
   580				lnk->wr_tx_ibs[i].send_flags |= IB_SEND_INLINE;
   581			lnk->wr_tx_rdmas[i].wr_tx_rdma[0].wr.opcode = IB_WR_RDMA_WRITE;
   582			lnk->wr_tx_rdmas[i].wr_tx_rdma[1].wr.opcode = IB_WR_RDMA_WRITE;
   583			lnk->wr_tx_rdmas[i].wr_tx_rdma[0].wr.sg_list =
   584				lnk->wr_tx_rdma_sges[i].tx_rdma_sge[0].wr_tx_rdma_sge;
   585			lnk->wr_tx_rdmas[i].wr_tx_rdma[1].wr.sg_list =
   586				lnk->wr_tx_rdma_sges[i].tx_rdma_sge[1].wr_tx_rdma_sge;
   587		}
   588	
   589		if (lnk->lgr->smc_version == SMC_V2) {
   590			lnk->wr_tx_v2_sge->addr = lnk->wr_tx_v2_dma_addr;
   591			lnk->wr_tx_v2_sge->length = SMC_WR_BUF_V2_SIZE;
   592			lnk->wr_tx_v2_sge->lkey = lnk->roce_pd->local_dma_lkey;
   593	
   594			lnk->wr_tx_v2_ib->next = NULL;
   595			lnk->wr_tx_v2_ib->sg_list = lnk->wr_tx_v2_sge;
   596			lnk->wr_tx_v2_ib->num_sge = 1;
   597			lnk->wr_tx_v2_ib->opcode = IB_WR_SEND;
   598			lnk->wr_tx_v2_ib->send_flags =
   599				IB_SEND_SIGNALED | IB_SEND_SOLICITED;
   600		}
   601	
   602		/* With SMC-Rv2 there can be messages larger than SMC_WR_TX_SIZE.
   603		 * Each ib_recv_wr gets 2 sges, the second one is a spillover buffer
   604		 * and the same buffer for all sges. When a larger message arrived then
   605		 * the content of the first small sge is copied to the beginning of
   606		 * the larger spillover buffer, allowing easy data mapping.
   607		 */
   608		for (i = 0; i < lnk->wr_rx_cnt; i++) {
   609			int x = i * sges_per_buf;
   610	
   611			lnk->wr_rx_sges[x].addr =
   612				lnk->wr_rx_dma_addr + i * SMC_WR_BUF_SIZE;
   613			lnk->wr_rx_sges[x].length = SMC_WR_TX_SIZE;
   614			lnk->wr_rx_sges[x].lkey = lnk->roce_pd->local_dma_lkey;
   615			if (lnk->lgr->smc_version == SMC_V2) {
   616				lnk->wr_rx_sges[x + 1].addr =
   617						lnk->wr_rx_v2_dma_addr + SMC_WR_TX_SIZE;
   618				lnk->wr_rx_sges[x + 1].length =
   619						SMC_WR_BUF_V2_SIZE - SMC_WR_TX_SIZE;
   620				lnk->wr_rx_sges[x + 1].lkey =
   621						lnk->roce_pd->local_dma_lkey;
   622			}
   623			lnk->wr_rx_ibs[i].next = NULL;
   624			lnk->wr_rx_ibs[i].sg_list = &lnk->wr_rx_sges[x];
   625			lnk->wr_rx_ibs[i].num_sge = sges_per_buf;
   626		}
   627		lnk->wr_reg.wr.next = NULL;
   628		lnk->wr_reg.wr.num_sge = 0;
   629		lnk->wr_reg.wr.send_flags = IB_SEND_SIGNALED;
   630		lnk->wr_reg.wr.opcode = IB_WR_REG_MR;
   631		lnk->wr_reg.access = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE;
   632	}
   633	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
