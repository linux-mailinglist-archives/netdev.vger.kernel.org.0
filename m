Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7F35A6846
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 18:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiH3QWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 12:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiH3QVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 12:21:55 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7D81037E1;
        Tue, 30 Aug 2022 09:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661876467; x=1693412467;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kcY8QzwCjMOuM4pU32QkMTmdxwa9mfmSIyR2QWNSgqQ=;
  b=BMyotyZe5DugbYRSKKmKYn2AW8CjhUm3k0bcogS/nbOeMd8NBWRS/LD1
   jOSceRfII3pWwe7v+dXfJ+7bTkazG6ghjT8n45nb9dLifcKI+9vhhpmvy
   j/vrTLZORGV7N0/zbge3Kjx9cxFRIVqR30wWr9Ufrp31QwEBfV62CbAJL
   E68FPDDcD8UppDZTMDJndecLtquQ5hOr49L7PhUZ5Nbzp53D8HJRb7Wez
   jB96mRE6oFmrCCf9DhdSVFYBf0/G1YIuw+ziqYaTdmH/SOyEGBaNnVAPi
   xlRVvv6vth8T9445uZUJ/KPUkQKHa5GJVf2iYw9oku+L509mphro5Yj0n
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="293966201"
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="293966201"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 09:11:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="611757769"
Received: from lkp-server02.sh.intel.com (HELO 77b6d4e16fc5) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 30 Aug 2022 09:11:28 -0700
Received: from kbuild by 77b6d4e16fc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oT3pj-0000OP-0x;
        Tue, 30 Aug 2022 16:11:23 +0000
Date:   Wed, 31 Aug 2022 00:10:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     liuyacan@corp.netease.com, kgraul@linux.ibm.com,
        davem@davemloft.net, wenjia@linux.ibm.com, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, liuyacan <liuyacan@corp.netease.com>
Subject: Re: [PATCH net] net/smc: Fix possible access to freed memory in link
 clear
Message-ID: <202208310048.0GtZuOsl-lkp@intel.com>
References: <20220829145435.2756430-1-liuyacan@corp.netease.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829145435.2756430-1-liuyacan@corp.netease.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net/master]

url:    https://github.com/intel-lab-lkp/linux/commits/liuyacan-corp-netease-com/net-smc-Fix-possible-access-to-freed-memory-in-link-clear/20220829-231821
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git cb10b0f91c5f76de981ef927e7dadec60c5a5d96
config: i386-randconfig-a013 (https://download.01.org/0day-ci/archive/20220831/202208310048.0GtZuOsl-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/f8be00c954c559c7ae24f34abade4faebc350ec9
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review liuyacan-corp-netease-com/net-smc-Fix-possible-access-to-freed-memory-in-link-clear/20220829-231821
        git checkout f8be00c954c559c7ae24f34abade4faebc350ec9
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/smc/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> net/smc/smc_wr.c:468:32: error: member reference type 'struct ib_wc' is not a pointer; did you mean to use '.'?
                                   if (link->clearing && wc[i]->wr_id == link->wr_rx_id) {
                                                         ~~~~~^~
                                                              .
>> net/smc/smc_wr.c:641:13: error: no member named 'drained' in 'struct smc_link'
                                            (lnk->drained == 1),
                                             ~~~  ^
   include/linux/wait.h:534:28: note: expanded from macro 'wait_event_interruptible_timeout'
           if (!___wait_cond_timeout(condition))                                   \
                                     ^~~~~~~~~
   include/linux/wait.h:276:17: note: expanded from macro '___wait_cond_timeout'
           bool __cond = (condition);                                              \
                          ^~~~~~~~~
>> net/smc/smc_wr.c:641:13: error: no member named 'drained' in 'struct smc_link'
                                            (lnk->drained == 1),
                                             ~~~  ^
   include/linux/wait.h:536:7: note: expanded from macro 'wait_event_interruptible_timeout'
                                                   condition, timeout);            \
                                                   ^~~~~~~~~
   include/linux/wait.h:506:46: note: expanded from macro '__wait_event_interruptible_timeout'
           ___wait_event(wq_head, ___wait_cond_timeout(condition),                 \
                                                       ^~~~~~~~~
   include/linux/wait.h:276:17: note: expanded from macro '___wait_cond_timeout'
           bool __cond = (condition);                                              \
                          ^~~~~~~~~
   include/linux/wait.h:310:7: note: expanded from macro '___wait_event'
                   if (condition)                                                  \
                       ^~~~~~~~~
   3 errors generated.


vim +468 net/smc/smc_wr.c

   449	
   450	static inline void smc_wr_rx_process_cqes(struct ib_wc wc[], int num)
   451	{
   452		struct smc_link *link;
   453		int i;
   454	
   455		for (i = 0; i < num; i++) {
   456			link = wc[i].qp->qp_context;
   457			if (wc[i].status == IB_WC_SUCCESS) {
   458				link->wr_rx_tstamp = jiffies;
   459				smc_wr_rx_demultiplex(&wc[i]);
   460				smc_wr_rx_post(link); /* refill WR RX */
   461			} else {
   462				/* handle status errors */
   463				switch (wc[i].status) {
   464				case IB_WC_RETRY_EXC_ERR:
   465				case IB_WC_RNR_RETRY_EXC_ERR:
   466				case IB_WC_WR_FLUSH_ERR:
   467					smcr_link_down_cond_sched(link);
 > 468					if (link->clearing && wc[i]->wr_id == link->wr_rx_id) {
   469						link->rx_drained = 1;
   470						wake_up(&link->wr_rx_drain_wait);
   471					}
   472					break;
   473				default:
   474					smc_wr_rx_post(link); /* refill WR RX */
   475					break;
   476				}
   477			}
   478		}
   479	}
   480	
   481	static void smc_wr_rx_tasklet_fn(struct tasklet_struct *t)
   482	{
   483		struct smc_ib_device *dev = from_tasklet(dev, t, recv_tasklet);
   484		struct ib_wc wc[SMC_WR_MAX_POLL_CQE];
   485		int polled = 0;
   486		int rc;
   487	
   488	again:
   489		polled++;
   490		do {
   491			memset(&wc, 0, sizeof(wc));
   492			rc = ib_poll_cq(dev->roce_cq_recv, SMC_WR_MAX_POLL_CQE, wc);
   493			if (polled == 1) {
   494				ib_req_notify_cq(dev->roce_cq_recv,
   495						 IB_CQ_SOLICITED_MASK
   496						 | IB_CQ_REPORT_MISSED_EVENTS);
   497			}
   498			if (!rc)
   499				break;
   500			smc_wr_rx_process_cqes(&wc[0], rc);
   501		} while (rc > 0);
   502		if (polled == 1)
   503			goto again;
   504	}
   505	
   506	void smc_wr_rx_cq_handler(struct ib_cq *ib_cq, void *cq_context)
   507	{
   508		struct smc_ib_device *dev = (struct smc_ib_device *)cq_context;
   509	
   510		tasklet_schedule(&dev->recv_tasklet);
   511	}
   512	
   513	int smc_wr_rx_post_init(struct smc_link *link)
   514	{
   515		u32 i;
   516		int rc = 0;
   517	
   518		for (i = 0; i < link->wr_rx_cnt; i++)
   519			rc = smc_wr_rx_post(link);
   520		return rc;
   521	}
   522	
   523	/***************************** init, exit, misc ******************************/
   524	
   525	void smc_wr_remember_qp_attr(struct smc_link *lnk)
   526	{
   527		struct ib_qp_attr *attr = &lnk->qp_attr;
   528		struct ib_qp_init_attr init_attr;
   529	
   530		memset(attr, 0, sizeof(*attr));
   531		memset(&init_attr, 0, sizeof(init_attr));
   532		ib_query_qp(lnk->roce_qp, attr,
   533			    IB_QP_STATE |
   534			    IB_QP_CUR_STATE |
   535			    IB_QP_PKEY_INDEX |
   536			    IB_QP_PORT |
   537			    IB_QP_QKEY |
   538			    IB_QP_AV |
   539			    IB_QP_PATH_MTU |
   540			    IB_QP_TIMEOUT |
   541			    IB_QP_RETRY_CNT |
   542			    IB_QP_RNR_RETRY |
   543			    IB_QP_RQ_PSN |
   544			    IB_QP_ALT_PATH |
   545			    IB_QP_MIN_RNR_TIMER |
   546			    IB_QP_SQ_PSN |
   547			    IB_QP_PATH_MIG_STATE |
   548			    IB_QP_CAP |
   549			    IB_QP_DEST_QPN,
   550			    &init_attr);
   551	
   552		lnk->wr_tx_cnt = min_t(size_t, SMC_WR_BUF_CNT,
   553				       lnk->qp_attr.cap.max_send_wr);
   554		lnk->wr_rx_cnt = min_t(size_t, SMC_WR_BUF_CNT * 3,
   555				       lnk->qp_attr.cap.max_recv_wr);
   556	}
   557	
   558	static void smc_wr_init_sge(struct smc_link *lnk)
   559	{
   560		int sges_per_buf = (lnk->lgr->smc_version == SMC_V2) ? 2 : 1;
   561		bool send_inline = (lnk->qp_attr.cap.max_inline_data > SMC_WR_TX_SIZE);
   562		u32 i;
   563	
   564		for (i = 0; i < lnk->wr_tx_cnt; i++) {
   565			lnk->wr_tx_sges[i].addr = send_inline ? (uintptr_t)(&lnk->wr_tx_bufs[i]) :
   566				lnk->wr_tx_dma_addr + i * SMC_WR_BUF_SIZE;
   567			lnk->wr_tx_sges[i].length = SMC_WR_TX_SIZE;
   568			lnk->wr_tx_sges[i].lkey = lnk->roce_pd->local_dma_lkey;
   569			lnk->wr_tx_rdma_sges[i].tx_rdma_sge[0].wr_tx_rdma_sge[0].lkey =
   570				lnk->roce_pd->local_dma_lkey;
   571			lnk->wr_tx_rdma_sges[i].tx_rdma_sge[0].wr_tx_rdma_sge[1].lkey =
   572				lnk->roce_pd->local_dma_lkey;
   573			lnk->wr_tx_rdma_sges[i].tx_rdma_sge[1].wr_tx_rdma_sge[0].lkey =
   574				lnk->roce_pd->local_dma_lkey;
   575			lnk->wr_tx_rdma_sges[i].tx_rdma_sge[1].wr_tx_rdma_sge[1].lkey =
   576				lnk->roce_pd->local_dma_lkey;
   577			lnk->wr_tx_ibs[i].next = NULL;
   578			lnk->wr_tx_ibs[i].sg_list = &lnk->wr_tx_sges[i];
   579			lnk->wr_tx_ibs[i].num_sge = 1;
   580			lnk->wr_tx_ibs[i].opcode = IB_WR_SEND;
   581			lnk->wr_tx_ibs[i].send_flags =
   582				IB_SEND_SIGNALED | IB_SEND_SOLICITED;
   583			if (send_inline)
   584				lnk->wr_tx_ibs[i].send_flags |= IB_SEND_INLINE;
   585			lnk->wr_tx_rdmas[i].wr_tx_rdma[0].wr.opcode = IB_WR_RDMA_WRITE;
   586			lnk->wr_tx_rdmas[i].wr_tx_rdma[1].wr.opcode = IB_WR_RDMA_WRITE;
   587			lnk->wr_tx_rdmas[i].wr_tx_rdma[0].wr.sg_list =
   588				lnk->wr_tx_rdma_sges[i].tx_rdma_sge[0].wr_tx_rdma_sge;
   589			lnk->wr_tx_rdmas[i].wr_tx_rdma[1].wr.sg_list =
   590				lnk->wr_tx_rdma_sges[i].tx_rdma_sge[1].wr_tx_rdma_sge;
   591		}
   592	
   593		if (lnk->lgr->smc_version == SMC_V2) {
   594			lnk->wr_tx_v2_sge->addr = lnk->wr_tx_v2_dma_addr;
   595			lnk->wr_tx_v2_sge->length = SMC_WR_BUF_V2_SIZE;
   596			lnk->wr_tx_v2_sge->lkey = lnk->roce_pd->local_dma_lkey;
   597	
   598			lnk->wr_tx_v2_ib->next = NULL;
   599			lnk->wr_tx_v2_ib->sg_list = lnk->wr_tx_v2_sge;
   600			lnk->wr_tx_v2_ib->num_sge = 1;
   601			lnk->wr_tx_v2_ib->opcode = IB_WR_SEND;
   602			lnk->wr_tx_v2_ib->send_flags =
   603				IB_SEND_SIGNALED | IB_SEND_SOLICITED;
   604		}
   605	
   606		/* With SMC-Rv2 there can be messages larger than SMC_WR_TX_SIZE.
   607		 * Each ib_recv_wr gets 2 sges, the second one is a spillover buffer
   608		 * and the same buffer for all sges. When a larger message arrived then
   609		 * the content of the first small sge is copied to the beginning of
   610		 * the larger spillover buffer, allowing easy data mapping.
   611		 */
   612		for (i = 0; i < lnk->wr_rx_cnt; i++) {
   613			int x = i * sges_per_buf;
   614	
   615			lnk->wr_rx_sges[x].addr =
   616				lnk->wr_rx_dma_addr + i * SMC_WR_BUF_SIZE;
   617			lnk->wr_rx_sges[x].length = SMC_WR_TX_SIZE;
   618			lnk->wr_rx_sges[x].lkey = lnk->roce_pd->local_dma_lkey;
   619			if (lnk->lgr->smc_version == SMC_V2) {
   620				lnk->wr_rx_sges[x + 1].addr =
   621						lnk->wr_rx_v2_dma_addr + SMC_WR_TX_SIZE;
   622				lnk->wr_rx_sges[x + 1].length =
   623						SMC_WR_BUF_V2_SIZE - SMC_WR_TX_SIZE;
   624				lnk->wr_rx_sges[x + 1].lkey =
   625						lnk->roce_pd->local_dma_lkey;
   626			}
   627			lnk->wr_rx_ibs[i].next = NULL;
   628			lnk->wr_rx_ibs[i].sg_list = &lnk->wr_rx_sges[x];
   629			lnk->wr_rx_ibs[i].num_sge = sges_per_buf;
   630		}
   631		lnk->wr_reg.wr.next = NULL;
   632		lnk->wr_reg.wr.num_sge = 0;
   633		lnk->wr_reg.wr.send_flags = IB_SEND_SIGNALED;
   634		lnk->wr_reg.wr.opcode = IB_WR_REG_MR;
   635		lnk->wr_reg.access = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE;
   636	}
   637	
   638	void smc_wr_drain_cq(struct smc_link *lnk)
   639	{
   640		wait_event_interruptible_timeout(lnk->wr_rx_drain_wait,
 > 641						 (lnk->drained == 1),
   642						 SMC_WR_RX_WAIT_DRAIN_TIME);
   643	}
   644	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
