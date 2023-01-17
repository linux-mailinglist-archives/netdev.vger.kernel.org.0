Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5D066D5BA
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 06:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbjAQFot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 00:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235440AbjAQFoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 00:44:46 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310E81EFDA
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 21:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673934284; x=1705470284;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/QDYe6uJLK2WdPCfDcOh5enK7iSESoxtrxwSXA/lDec=;
  b=VI9u4CHaz+BNUUuh02qywGz+LEuVm3/gLbAOgwr4Sr5d8QYUWvrJdAbz
   K5drwyZWUXU5S3mGQH1RhpJWXpPcCu/J+gl0lf/fUNKU1vAcW9CFQaf/2
   OiQk7daezEKzW+AiLh9/vpsOW9dq0pnJjKqnlWDmYZSF2TtXfRAy/fR/B
   sjm+q9U1VnSDLJSIX+Ck1yniQAs/b+oSvbcbH7ter0QLSGCbEyAsXhmrM
   8Mr+jrvAxqNyyTeYP6wWfmpWI2UQ3qCTy+AR6nVHTvMlnqeiSesNBq+CC
   4452QX2qzSPutSiAhpLciO2O9WDBzOL/IledUmEhGK7q/bd1GlcT7sK21
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="304303848"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="304303848"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 21:44:43 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="727674471"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="727674471"
Received: from mckumar-mobl2.gar.corp.intel.com (HELO [10.213.106.241]) ([10.213.106.241])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 21:44:38 -0800
Message-ID: <5350028b-dcd9-a3ae-78d4-33d5aa96d1b5@linux.intel.com>
Date:   Tue, 17 Jan 2023 11:14:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 net-next 2/5] net: wwan: t7xx: Infrastructure for early
 port configuration
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, kuba@kernel.org,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        linuxwwan_5g@intel.com, Madhusmita Sahu <madhusmita.sahu@intel.com>
References: <cover.1673842618.git.m.chetan.kumar@linux.intel.com>
 <565d5f166b88ae2b7377ba6beb31dc9b6b2bc431.1673842618.git.m.chetan.kumar@linux.intel.com>
 <a62fb192-d587-7d59-cd7-30ebf8a7f0@linux.intel.com>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <a62fb192-d587-7d59-cd7-30ebf8a7f0@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ilpo,
Thank you for the feedback.


On 1/16/2023 6:26 PM, Ilpo Järvinen wrote:
> On Mon, 16 Jan 2023, m.chetan.kumar@linux.intel.com wrote:
> 
>> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>>
>> To support cases such as FW update or Core dump, the t7xx
>> device is capable of signaling the host that a special port
>> needs to be created before the handshake phase.
>>
>> Adds the infrastructure required to create the early ports
>> which also requires a different configuration of CLDMA queues.
> 
> This doesn't go into details why CLDMA_MTU -> CLDMA_SHARED_Q_BUFF_SZ
> rename was done (if it wouldn't have been in the same change at all, I
> could have immediately seen that, ah, it was just moving code around but
> now I had to go to check if the defines yield same values).
> 
>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>> Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
>> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>> --
>> v4:
>>   * Remove "this patch" in commit message.
>>   * MISC_DEV_STATUS_MASK & MISC_DEV_STATUS_INVALID is unused, drop it.
>>   * Drop unnecessary assignement for ret var inside fsm_routine_start.
>>   * cppcheck - reduce variableScope for stage var in fsm_routine_start.
>> v3:
>>   * No Change.
>> v2:
>>   * Move recv_skb handler to cldma_queue.
>>   * Drop cldma_queue_type.
>>   * Restore prototype of t7xx_port_send_raw_skb().
>>   * Remove PORT_CFG_ID_INVALID check in t7xx_port_proxy_set_cfg().
>>   * Add space before */.
>>   * Drop unnecessary logs.
>>   * Use WARN_ON on early port.
>>   * Use new MISC_DEV_STATUS_INVALID instead of MISC_DEV_STATUS.
>>   * Use macros instead of const identifiers.
>>   * Change ports member type from pointer to array type.
>>   * Prefix LK_EVENT_XX with MISC prefix.
>>   * Use t7xx prefix for device_stage enums.
>>   * Correct log messages.
>>   * Dont override pkt_size for non-download port under dedicated Queue.
>>   * Drop cldma_txq_rxq_ids.
>>   * Use macro for txq/rxq index.
>>   * Use warn_on for rxq_idx comparison.
>>   * Drop t7xx_port_proxy_get_port_by_name().
>>   * Replace fsm poll with read_poll_timeout().
>>   * Use "\n" consistently across log message.
>>   * Remove local var _dev prefixes in fsm_routine_start().
>>   * Use max_t.
>> ---
>>   drivers/net/wwan/t7xx/t7xx_hif_cldma.c     | 47 ++++++++----
>>   drivers/net/wwan/t7xx/t7xx_hif_cldma.h     | 18 +++--
>>   drivers/net/wwan/t7xx/t7xx_modem_ops.c     |  4 +-
>>   drivers/net/wwan/t7xx/t7xx_port.h          |  4 +
>>   drivers/net/wwan/t7xx/t7xx_port_proxy.c    | 89 +++++++++++++++++++---
>>   drivers/net/wwan/t7xx/t7xx_port_proxy.h    | 12 ++-
>>   drivers/net/wwan/t7xx/t7xx_port_wwan.c     |  3 +-
>>   drivers/net/wwan/t7xx/t7xx_reg.h           | 22 +++++-
>>   drivers/net/wwan/t7xx/t7xx_state_monitor.c | 85 ++++++++++++++++++---
>>   drivers/net/wwan/t7xx/t7xx_state_monitor.h |  1 +
>>   10 files changed, 235 insertions(+), 50 deletions(-)
>>
>> diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
>> index 4f56d8cc0aea..12c9e9cba74a 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
>> @@ -57,8 +57,6 @@
>>   #define CHECK_Q_STOP_TIMEOUT_US		1000000
>>   #define CHECK_Q_STOP_STEP_US		10000
>>   
>> -#define CLDMA_JUMBO_BUFF_SZ		(63 * 1024 + sizeof(struct ccci_header))
>> -
>>   static void md_cd_queue_struct_reset(struct cldma_queue *queue, struct cldma_ctrl *md_ctrl,
>>   				     enum mtk_txrx tx_rx, unsigned int index)
>>   {
>> @@ -161,7 +159,7 @@ static int t7xx_cldma_gpd_rx_from_q(struct cldma_queue *queue, int budget, bool
>>   		skb_reset_tail_pointer(skb);
>>   		skb_put(skb, le16_to_cpu(gpd->data_buff_len));
>>   
>> -		ret = md_ctrl->recv_skb(queue, skb);
>> +		ret = queue->recv_skb(queue, skb);
>>   		/* Break processing, will try again later */
>>   		if (ret < 0)
>>   			return ret;
>> @@ -897,13 +895,13 @@ static void t7xx_cldma_hw_start_send(struct cldma_ctrl *md_ctrl, int qno,
>>   
>>   /**
>>    * t7xx_cldma_set_recv_skb() - Set the callback to handle RX packets.
>> - * @md_ctrl: CLDMA context structure.
>> + * @queue: CLDMA queue.
>>    * @recv_skb: Receiving skb callback.
>>    */
>> -void t7xx_cldma_set_recv_skb(struct cldma_ctrl *md_ctrl,
>> +void t7xx_cldma_set_recv_skb(struct cldma_queue *queue,
>>   			     int (*recv_skb)(struct cldma_queue *queue, struct sk_buff *skb))
>>   {
>> -	md_ctrl->recv_skb = recv_skb;
>> +	queue->recv_skb = recv_skb;
>>   }
>>   
>>   /**
>> @@ -993,6 +991,28 @@ int t7xx_cldma_send_skb(struct cldma_ctrl *md_ctrl, int qno, struct sk_buff *skb
>>   	return ret;
>>   }
>>   
>> +static void t7xx_cldma_adjust_config(struct cldma_ctrl *md_ctrl, enum cldma_cfg cfg_id)
>> +{
>> +	int qno;
>> +
>> +	for (qno = 0; qno < CLDMA_RXQ_NUM; qno++) {
>> +		md_ctrl->rx_ring[qno].pkt_size = CLDMA_SHARED_Q_BUFF_SZ;
>> +		t7xx_cldma_set_recv_skb(&md_ctrl->rxq[qno], t7xx_port_proxy_recv_skb);
>> +	}
>> +
>> +	md_ctrl->rx_ring[CLDMA_RXQ_NUM - 1].pkt_size = CLDMA_JUMBO_BUFF_SZ;
>> +
>> +	for (qno = 0; qno < CLDMA_TXQ_NUM; qno++)
>> +		md_ctrl->tx_ring[qno].pkt_size = CLDMA_SHARED_Q_BUFF_SZ;
>> +
>> +	if (cfg_id == CLDMA_DEDICATED_Q_CFG) {
>> +		md_ctrl->tx_ring[CLDMA_Q_IDX_DUMP].pkt_size = CLDMA_DEDICATED_Q_BUFF_SZ;
>> +		md_ctrl->rx_ring[CLDMA_Q_IDX_DUMP].pkt_size = CLDMA_DEDICATED_Q_BUFF_SZ;
>> +		t7xx_cldma_set_recv_skb(&md_ctrl->rxq[CLDMA_Q_IDX_DUMP],
>> +					t7xx_port_proxy_recv_skb_from_dedicated_queue);
>> +	}
>> +}
>> +
>>   static int t7xx_cldma_late_init(struct cldma_ctrl *md_ctrl)
>>   {
>>   	char dma_pool_name[32];
>> @@ -1018,16 +1038,9 @@ static int t7xx_cldma_late_init(struct cldma_ctrl *md_ctrl)
>>   			dev_err(md_ctrl->dev, "control TX ring init fail\n");
>>   			goto err_free_tx_ring;
>>   		}
>> -
>> -		md_ctrl->tx_ring[i].pkt_size = CLDMA_MTU;
>>   	}
>>   
>>   	for (j = 0; j < CLDMA_RXQ_NUM; j++) {
>> -		md_ctrl->rx_ring[j].pkt_size = CLDMA_MTU;
>> -
>> -		if (j == CLDMA_RXQ_NUM - 1)
>> -			md_ctrl->rx_ring[j].pkt_size = CLDMA_JUMBO_BUFF_SZ;
>> -
>>   		ret = t7xx_cldma_rx_ring_init(md_ctrl, &md_ctrl->rx_ring[j]);
>>   		if (ret) {
>>   			dev_err(md_ctrl->dev, "Control RX ring init fail\n");
>> @@ -1094,6 +1107,7 @@ int t7xx_cldma_alloc(enum cldma_id hif_id, struct t7xx_pci_dev *t7xx_dev)
>>   {
>>   	struct device *dev = &t7xx_dev->pdev->dev;
>>   	struct cldma_ctrl *md_ctrl;
>> +	int qno;
>>   
>>   	md_ctrl = devm_kzalloc(dev, sizeof(*md_ctrl), GFP_KERNEL);
>>   	if (!md_ctrl)
>> @@ -1102,7 +1116,9 @@ int t7xx_cldma_alloc(enum cldma_id hif_id, struct t7xx_pci_dev *t7xx_dev)
>>   	md_ctrl->t7xx_dev = t7xx_dev;
>>   	md_ctrl->dev = dev;
>>   	md_ctrl->hif_id = hif_id;
>> -	md_ctrl->recv_skb = t7xx_cldma_default_recv_skb;
>> +	for (qno = 0; qno < CLDMA_RXQ_NUM; qno++)
>> +		md_ctrl->rxq[qno].recv_skb = t7xx_cldma_default_recv_skb;
>> +
>>   	t7xx_hw_info_init(md_ctrl);
>>   	t7xx_dev->md->md_ctrl[hif_id] = md_ctrl;
>>   	return 0;
>> @@ -1331,9 +1347,10 @@ int t7xx_cldma_init(struct cldma_ctrl *md_ctrl)
>>   	return -ENOMEM;
>>   }
>>   
>> -void t7xx_cldma_switch_cfg(struct cldma_ctrl *md_ctrl)
>> +void t7xx_cldma_switch_cfg(struct cldma_ctrl *md_ctrl, enum cldma_cfg cfg_id)
>>   {
>>   	t7xx_cldma_late_release(md_ctrl);
>> +	t7xx_cldma_adjust_config(md_ctrl, cfg_id);
>>   	t7xx_cldma_late_init(md_ctrl);
>>   }
>>   
>> diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.h b/drivers/net/wwan/t7xx/t7xx_hif_cldma.h
>> index 4410bac6993a..5453cfecbe19 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.h
>> @@ -31,6 +31,10 @@
>>   #include "t7xx_cldma.h"
>>   #include "t7xx_pci.h"
>>   
>> +#define CLDMA_JUMBO_BUFF_SZ		(63 * 1024 + sizeof(struct ccci_header))
>> +#define CLDMA_SHARED_Q_BUFF_SZ		3584
>> +#define CLDMA_DEDICATED_Q_BUFF_SZ	2048
>> +
>>   /**
>>    * enum cldma_id - Identifiers for CLDMA HW units.
>>    * @CLDMA_ID_MD: Modem control channel.
>> @@ -55,6 +59,11 @@ struct cldma_gpd {
>>   	__le16 not_used2;
>>   };
>>   
>> +enum cldma_cfg {
>> +	CLDMA_SHARED_Q_CFG,
>> +	CLDMA_DEDICATED_Q_CFG,
>> +};
>> +
>>   struct cldma_request {
>>   	struct cldma_gpd *gpd;	/* Virtual address for CPU */
>>   	dma_addr_t gpd_addr;	/* Physical address for DMA */
>> @@ -82,6 +91,7 @@ struct cldma_queue {
>>   	wait_queue_head_t req_wq;	/* Only for TX */
>>   	struct workqueue_struct *worker;
>>   	struct work_struct cldma_work;
>> +	int (*recv_skb)(struct cldma_queue *queue, struct sk_buff *skb);
>>   };
>>   
>>   struct cldma_ctrl {
>> @@ -101,24 +111,22 @@ struct cldma_ctrl {
>>   	struct md_pm_entity *pm_entity;
>>   	struct t7xx_cldma_hw hw_info;
>>   	bool is_late_init;
>> -	int (*recv_skb)(struct cldma_queue *queue, struct sk_buff *skb);
>>   };
>>   
>> +#define CLDMA_Q_IDX_DUMP 1
>>   #define GPD_FLAGS_HWO		BIT(0)
>>   #define GPD_FLAGS_IOC		BIT(7)
>>   #define GPD_DMAPOOL_ALIGN	16
>>   
>> -#define CLDMA_MTU		3584	/* 3.5kB */
>> -
>>   int t7xx_cldma_alloc(enum cldma_id hif_id, struct t7xx_pci_dev *t7xx_dev);
>>   void t7xx_cldma_hif_hw_init(struct cldma_ctrl *md_ctrl);
>>   int t7xx_cldma_init(struct cldma_ctrl *md_ctrl);
>>   void t7xx_cldma_exit(struct cldma_ctrl *md_ctrl);
>> -void t7xx_cldma_switch_cfg(struct cldma_ctrl *md_ctrl);
>> +void t7xx_cldma_switch_cfg(struct cldma_ctrl *md_ctrl, enum cldma_cfg cfg_id);
>>   void t7xx_cldma_start(struct cldma_ctrl *md_ctrl);
>>   int t7xx_cldma_stop(struct cldma_ctrl *md_ctrl);
>>   void t7xx_cldma_reset(struct cldma_ctrl *md_ctrl);
>> -void t7xx_cldma_set_recv_skb(struct cldma_ctrl *md_ctrl,
>> +void t7xx_cldma_set_recv_skb(struct cldma_queue *queue,
>>   			     int (*recv_skb)(struct cldma_queue *queue, struct sk_buff *skb));
>>   int t7xx_cldma_send_skb(struct cldma_ctrl *md_ctrl, int qno, struct sk_buff *skb);
>>   void t7xx_cldma_stop_all_qs(struct cldma_ctrl *md_ctrl, enum mtk_txrx tx_rx);
>> diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.c b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
>> index 24e7d491468e..cbd65aa48721 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_modem_ops.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
>> @@ -529,7 +529,7 @@ static void t7xx_md_hk_wq(struct work_struct *work)
>>   
>>   	/* Clear the HS2 EXIT event appended in core_reset() */
>>   	t7xx_fsm_clr_event(ctl, FSM_EVENT_MD_HS2_EXIT);
>> -	t7xx_cldma_switch_cfg(md->md_ctrl[CLDMA_ID_MD]);
>> +	t7xx_cldma_switch_cfg(md->md_ctrl[CLDMA_ID_MD], CLDMA_SHARED_Q_CFG);
>>   	t7xx_cldma_start(md->md_ctrl[CLDMA_ID_MD]);
>>   	t7xx_fsm_broadcast_state(ctl, MD_STATE_WAITING_FOR_HS2);
>>   	md->core_md.handshake_ongoing = true;
>> @@ -544,7 +544,7 @@ static void t7xx_ap_hk_wq(struct work_struct *work)
>>   	 /* Clear the HS2 EXIT event appended in t7xx_core_reset(). */
>>   	t7xx_fsm_clr_event(ctl, FSM_EVENT_AP_HS2_EXIT);
>>   	t7xx_cldma_stop(md->md_ctrl[CLDMA_ID_AP]);
>> -	t7xx_cldma_switch_cfg(md->md_ctrl[CLDMA_ID_AP]);
>> +	t7xx_cldma_switch_cfg(md->md_ctrl[CLDMA_ID_AP], CLDMA_SHARED_Q_CFG);
>>   	t7xx_cldma_start(md->md_ctrl[CLDMA_ID_AP]);
>>   	md->core_ap.handshake_ongoing = true;
>>   	t7xx_core_hk_handler(md, &md->core_ap, ctl, FSM_EVENT_AP_HS2, FSM_EVENT_AP_HS2_EXIT);
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port.h b/drivers/net/wwan/t7xx/t7xx_port.h
>> index 4ae8a00a8532..09acb1ef144d 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_port.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_port.h
>> @@ -75,6 +75,8 @@ enum port_ch {
>>   	PORT_CH_DSS6_TX = 0x20df,
>>   	PORT_CH_DSS7_RX = 0x20e0,
>>   	PORT_CH_DSS7_TX = 0x20e1,
>> +
>> +	PORT_CH_ID_UNIMPORTANT = 0xffff,
>>   };
>>   
>>   struct t7xx_port;
>> @@ -135,9 +137,11 @@ struct t7xx_port {
>>   	};
>>   };
>>   
>> +int t7xx_get_port_mtu(struct t7xx_port *port);
>>   struct sk_buff *t7xx_port_alloc_skb(int payload);
>>   struct sk_buff *t7xx_ctrl_alloc_skb(int payload);
>>   int t7xx_port_enqueue_skb(struct t7xx_port *port, struct sk_buff *skb);
>> +int t7xx_port_send_raw_skb(struct t7xx_port *port, struct sk_buff *skb);
>>   int t7xx_port_send_skb(struct t7xx_port *port, struct sk_buff *skb, unsigned int pkt_header,
>>   		       unsigned int ex_msg);
>>   int t7xx_port_send_ctl_skb(struct t7xx_port *port, struct sk_buff *skb, unsigned int msg,
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>> index 274846d39fbf..b457e8da098e 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>> @@ -100,6 +100,18 @@ static const struct t7xx_port_conf t7xx_port_conf[] = {
>>   	},
>>   };
>>   
>> +static struct t7xx_port_conf t7xx_early_port_conf[] = {
>> +	{
>> +		.tx_ch = PORT_CH_ID_UNIMPORTANT,
>> +		.rx_ch = PORT_CH_ID_UNIMPORTANT,
>> +		.txq_index = CLDMA_Q_IDX_DUMP,
>> +		.rxq_index = CLDMA_Q_IDX_DUMP,
>> +		.txq_exp_index = CLDMA_Q_IDX_DUMP,
>> +		.rxq_exp_index = CLDMA_Q_IDX_DUMP,
>> +		.path_id = CLDMA_ID_AP,
>> +	},
>> +};
>> +
>>   static struct t7xx_port *t7xx_proxy_get_port_by_ch(struct port_proxy *port_prox, enum port_ch ch)
>>   {
>>   	const struct t7xx_port_conf *port_conf;
>> @@ -214,7 +226,17 @@ int t7xx_port_enqueue_skb(struct t7xx_port *port, struct sk_buff *skb)
>>   	return 0;
>>   }
>>   
>> -static int t7xx_port_send_raw_skb(struct t7xx_port *port, struct sk_buff *skb)
>> +int t7xx_get_port_mtu(struct t7xx_port *port)
>> +{
>> +	enum cldma_id path_id = port->port_conf->path_id;
>> +	int tx_qno = t7xx_port_get_queue_no(port);
>> +	struct cldma_ctrl *md_ctrl;
>> +
>> +	md_ctrl = port->t7xx_dev->md->md_ctrl[path_id];
>> +	return md_ctrl->tx_ring[tx_qno].pkt_size;
>> +}
>> +
>> +int t7xx_port_send_raw_skb(struct t7xx_port *port, struct sk_buff *skb)
>>   {
>>   	enum cldma_id path_id = port->port_conf->path_id;
>>   	struct cldma_ctrl *md_ctrl;
>> @@ -329,6 +351,30 @@ static void t7xx_proxy_setup_ch_mapping(struct port_proxy *port_prox)
>>   	}
>>   }
>>   
>> +int t7xx_port_proxy_recv_skb_from_dedicated_queue(struct cldma_queue *queue, struct sk_buff *skb)
>> +{
>> +	struct t7xx_pci_dev *t7xx_dev = queue->md_ctrl->t7xx_dev;
>> +	struct port_proxy *port_prox = t7xx_dev->md->port_prox;
>> +	const struct t7xx_port_conf *port_conf;
>> +	struct t7xx_port *port;
>> +	int ret;
>> +
>> +	port = &port_prox->ports[0];
>> +	if (WARN_ON(port->port_conf->rxq_index != queue->index)) {
> 
> WARN_ON_ONCE would seem enough to alert to this problem and not as spammy?

Will change it to WARN_ON_ONCE.

> 
>> +		dev_kfree_skb_any(skb);
>> +		return -EINVAL;
>> +	}
>> +
>> +	port_conf = port->port_conf;
>> +	ret = port_conf->ops->recv_skb(port, skb);
>> +	if (ret < 0 && ret != -ENOBUFS) {
>> +		dev_err(port->dev, "drop on RX ch %d, %d\n", port_conf->rx_ch, ret);
>> +		dev_kfree_skb_any(skb);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>>   static struct t7xx_port *t7xx_port_proxy_find_port(struct t7xx_pci_dev *t7xx_dev,
>>   						   struct cldma_queue *queue, u16 channel)
>>   {
>> @@ -359,7 +405,7 @@ static struct t7xx_port *t7xx_port_proxy_find_port(struct t7xx_pci_dev *t7xx_dev
>>    ** 0		- Packet consumed.
>>    ** -ERROR	- Failed to process skb.
>>    */
>> -static int t7xx_port_proxy_recv_skb(struct cldma_queue *queue, struct sk_buff *skb)
>> +int t7xx_port_proxy_recv_skb(struct cldma_queue *queue, struct sk_buff *skb)
>>   {
>>   	struct ccci_header *ccci_h = (struct ccci_header *)skb->data;
>>   	struct t7xx_pci_dev *t7xx_dev = queue->md_ctrl->t7xx_dev;
>> @@ -451,26 +497,47 @@ static void t7xx_proxy_init_all_ports(struct t7xx_modem *md)
>>   	t7xx_proxy_setup_ch_mapping(port_prox);
>>   }
>>   
>> +void t7xx_port_proxy_set_cfg(struct t7xx_modem *md, enum port_cfg_id cfg_id)
>> +{
>> +	struct port_proxy *port_prox = md->port_prox;
>> +	const struct t7xx_port_conf *port_conf;
>> +	u32 port_count;
>> +	int i;
>> +
>> +	t7xx_port_proxy_uninit(port_prox);
>> +
>> +	if (cfg_id == PORT_CFG_ID_EARLY) {
>> +		port_conf = t7xx_early_port_conf;
>> +		port_count = ARRAY_SIZE(t7xx_early_port_conf);
>> +	} else {
>> +		port_conf = t7xx_port_conf;
>> +		port_count = ARRAY_SIZE(t7xx_port_conf);
>> +	}
>> +
>> +	for (i = 0; i < port_count; i++)
>> +		port_prox->ports[i].port_conf = &port_conf[i];
>> +
>> +	port_prox->cfg_id = cfg_id;
>> +	port_prox->port_count = port_count;
>> +	t7xx_proxy_init_all_ports(md);
>> +}
>> +
>>   static int t7xx_proxy_alloc(struct t7xx_modem *md)
>>   {
>> +	u32 early_port_count = ARRAY_SIZE(t7xx_early_port_conf);
>>   	unsigned int port_count = ARRAY_SIZE(t7xx_port_conf);
> 
> Why these are of different types?

Will keep type of early_port_count same as port_count.

> 
>>   	struct device *dev = &md->t7xx_dev->pdev->dev;
>>   	struct port_proxy *port_prox;
>> -	int i;
>>   
>> -	port_prox = devm_kzalloc(dev, sizeof(*port_prox) + sizeof(struct t7xx_port) * port_count,
>> -				 GFP_KERNEL);
>> +	port_count = max_t(u32, port_count, early_port_count);
> 
> If vars are using same type, you could do just max()
> 
>> +	port_prox = devm_kzalloc(dev, struct_size(port_prox, ports, port_count), GFP_KERNEL);
> 
> include <linux/overflow.h> missing?
> 
> This opencoding -> struct_size() seems independent change, no? If so, it
> should be in a separate patch. (It's a good change still and should be
> done.)

Ya. this is an independent change.
I will drop it from this patch and push it as a seperate patch.

> 
>>   	if (!port_prox)
>>   		return -ENOMEM;
>>   
>>   	md->port_prox = port_prox;
>>   	port_prox->dev = dev;
>> +	t7xx_port_proxy_set_cfg(md, PORT_CFG_ID_EARLY);
>>   
>> -	for (i = 0; i < port_count; i++)
>> -		port_prox->ports[i].port_conf = &t7xx_port_conf[i];
>> -
>> -	port_prox->port_count = port_count;
>> -	t7xx_proxy_init_all_ports(md);
>>   	return 0;
>>   }
>>   
>> @@ -492,8 +559,6 @@ int t7xx_port_proxy_init(struct t7xx_modem *md)
>>   	if (ret)
>>   		return ret;
>>   
>> -	t7xx_cldma_set_recv_skb(md->md_ctrl[CLDMA_ID_AP], t7xx_port_proxy_recv_skb);
>> -	t7xx_cldma_set_recv_skb(md->md_ctrl[CLDMA_ID_MD], t7xx_port_proxy_recv_skb);
>>   	return 0;
>>   }
>>   
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.h b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
>> index 81d059fbc0fb..0f3fb53259b7 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_port_proxy.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
>> @@ -31,12 +31,19 @@
>>   #define RX_QUEUE_MAXLEN		32
>>   #define CTRL_QUEUE_MAXLEN	16
>>   
>> +enum port_cfg_id {
>> +	PORT_CFG_ID_INVALID,
>> +	PORT_CFG_ID_NORMAL,
>> +	PORT_CFG_ID_EARLY,
>> +};
>> +
>>   struct port_proxy {
>>   	int			port_count;
>>   	struct list_head	rx_ch_ports[PORT_CH_ID_MASK + 1];
>>   	struct list_head	queue_ports[CLDMA_NUM][MTK_QUEUES];
>>   	struct device		*dev;
>> -	struct t7xx_port	ports[];
>> +	enum port_cfg_id	cfg_id;
>> +	struct t7xx_port        ports[];
> 
> Spurious space change.

Will check and fix it.

> 
>>   };
>>   
>>   struct ccci_header {
>> @@ -98,5 +105,8 @@ void t7xx_port_proxy_md_status_notify(struct port_proxy *port_prox, unsigned int
>>   int t7xx_port_enum_msg_handler(struct t7xx_modem *md, void *msg);
>>   int t7xx_port_proxy_chl_enable_disable(struct port_proxy *port_prox, unsigned int ch_id,
>>   				       bool en_flag);
>> +void t7xx_port_proxy_set_cfg(struct t7xx_modem *md, enum port_cfg_id cfg_id);
>> +int t7xx_port_proxy_recv_skb(struct cldma_queue *queue, struct sk_buff *skb);
>> +int t7xx_port_proxy_recv_skb_from_dedicated_queue(struct cldma_queue *queue, struct sk_buff *skb);
>>   
>>   #endif /* __T7XX_PORT_PROXY_H__ */
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port_wwan.c b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
>> index 24bd21942403..33fa8c22598a 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_port_wwan.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
>> @@ -54,7 +54,7 @@ static void t7xx_port_ctrl_stop(struct wwan_port *port)
>>   static int t7xx_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
>>   {
>>   	struct t7xx_port *port_private = wwan_port_get_drvdata(port);
>> -	size_t len, offset, chunk_len = 0, txq_mtu = CLDMA_MTU;
>> +	size_t len, offset, chunk_len = 0, txq_mtu;
>>   	const struct t7xx_port_conf *port_conf;
>>   	struct t7xx_fsm_ctl *ctl;
>>   	enum md_state md_state;
>> @@ -72,6 +72,7 @@ static int t7xx_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
>>   		return -ENODEV;
>>   	}
>>   
>> +	txq_mtu = t7xx_get_port_mtu(port_private);
>>   	for (offset = 0; offset < len; offset += chunk_len) {
>>   		struct sk_buff *skb_ccci;
>>   		int ret;
>> diff --git a/drivers/net/wwan/t7xx/t7xx_reg.h b/drivers/net/wwan/t7xx/t7xx_reg.h
>> index c41d7d094c08..3b665c6116fe 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_reg.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_reg.h
>> @@ -102,10 +102,26 @@ enum t7xx_pm_resume_state {
>>   };
>>   
>>   #define T7XX_PCIE_MISC_DEV_STATUS		0x0d1c
>> -#define MISC_STAGE_MASK				GENMASK(2, 0)
>> -#define MISC_RESET_TYPE_PLDR			BIT(26)
>>   #define MISC_RESET_TYPE_FLDR			BIT(27)
>> -#define LINUX_STAGE				4
>> +#define MISC_RESET_TYPE_PLDR			BIT(26)
>> +#define MISC_LK_EVENT_MASK			GENMASK(11, 8)
>> +
>> +enum lk_event_id {
>> +	LK_EVENT_NORMAL = 0,
>> +	LK_EVENT_CREATE_PD_PORT = 1,
>> +	LK_EVENT_CREATE_POST_DL_PORT = 2,
>> +	LK_EVENT_RESET = 7,
>> +};
>> +
>> +#define MISC_STAGE_MASK				GENMASK(2, 0)
>> +enum t7xx_device_stage {
>> +	T7XX_DEV_STAGE_INIT = 0,
>> +	T7XX_DEV_STAGE_BROM_PRE = 1,
>> +	T7XX_DEV_STAGE_BROM_POST = 2,
>> +	T7XX_DEV_STAGE_LK = 3,
>> +	T7XX_DEV_STAGE_LINUX = 4,
>> +};
>>   
>>   #define T7XX_PCIE_RESOURCE_STATUS		0x0d28
>>   #define T7XX_PCIE_RESOURCE_STS_MSK		GENMASK(4, 0)
>> diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
>> index 80edb8e75a6a..6e957d3c0490 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_state_monitor.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
>> @@ -206,6 +206,34 @@ static void fsm_routine_exception(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_comm
>>   		fsm_finish_command(ctl, cmd, 0);
>>   }
>>   
>> +static void t7xx_lk_stage_event_handling(struct t7xx_fsm_ctl *ctl, unsigned int status)
>> +{
>> +	struct t7xx_modem *md = ctl->md;
>> +	struct cldma_ctrl *md_ctrl;
>> +	enum lk_event_id lk_event;
>> +	struct device *dev;
>> +
>> +	dev = &md->t7xx_dev->pdev->dev;
>> +	lk_event = FIELD_GET(MISC_LK_EVENT_MASK, status);
>> +	switch (lk_event) {
>> +	case LK_EVENT_NORMAL:
>> +	case LK_EVENT_RESET:
>> +		break;
>> +
>> +	case LK_EVENT_CREATE_PD_PORT:
>> +		md_ctrl = md->md_ctrl[CLDMA_ID_AP];
>> +		t7xx_cldma_hif_hw_init(md_ctrl);
>> +		t7xx_cldma_stop(md_ctrl);
>> +		t7xx_cldma_switch_cfg(md_ctrl, CLDMA_DEDICATED_Q_CFG);
>> +		t7xx_cldma_start(md_ctrl);
>> +		break;
>> +
>> +	default:
>> +		dev_err(dev, "Invalid LK event %d\n", lk_event);
>> +		break;
>> +	}
>> +}
>> +
>>   static int fsm_stopped_handler(struct t7xx_fsm_ctl *ctl)
>>   {
>>   	ctl->curr_state = FSM_STATE_STOPPED;
>> @@ -317,7 +345,8 @@ static int fsm_routine_starting(struct t7xx_fsm_ctl *ctl)
>>   static void fsm_routine_start(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_command *cmd)
>>   {
>>   	struct t7xx_modem *md = ctl->md;
>> -	u32 dev_status;
>> +	struct device *dev;
>> +	u32 status;
>>   	int ret;
>>   
>>   	if (!md)
>> @@ -329,23 +358,56 @@ static void fsm_routine_start(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_command
>>   		return;
>>   	}
>>   
>> +	dev = &md->t7xx_dev->pdev->dev;
>>   	ctl->curr_state = FSM_STATE_PRE_START;
>>   	t7xx_md_event_notify(md, FSM_PRE_START);
>>   
>> -	ret = read_poll_timeout(ioread32, dev_status,
>> -				(dev_status & MISC_STAGE_MASK) == LINUX_STAGE, 20000, 2000000,
>> -				false, IREG_BASE(md->t7xx_dev) + T7XX_PCIE_MISC_DEV_STATUS);
>> +	ret = read_poll_timeout(ioread32, status,
>> +				((status & MISC_STAGE_MASK) == T7XX_DEV_STAGE_LINUX) ||
>> +				((status & MISC_STAGE_MASK) == T7XX_DEV_STAGE_LK), 100000,
>> +				20000000, false, IREG_BASE(md->t7xx_dev) +
>> +				T7XX_PCIE_MISC_DEV_STATUS);
>> +
>>   	if (ret) {
>> -		struct device *dev = &md->t7xx_dev->pdev->dev;
>> +		ret = -ETIMEDOUT;
> 
> Is this necessary? Can read_poll_timeout() return anything else than
> -ETIMEDOUT??

Not required will use return of read_poll_timeout().

> 
>> +		dev_err(dev, "read poll %d\n", ret);
> 
> read poll timeout ?

Will change it to "read poll timeout".

> 
>> +		goto finish_command;
>> +	}
>>   
>> -		fsm_finish_command(ctl, cmd, -ETIMEDOUT);
>> -		dev_err(dev, "Invalid device status 0x%lx\n", dev_status & MISC_STAGE_MASK);
>> -		return;
>> +	if (status != ctl->prev_status) {
>> +		u32 stage = FIELD_GET(MISC_STAGE_MASK, status);
>> +
>> +		switch (stage) {
>> +		case T7XX_DEV_STAGE_INIT:
>> +		case T7XX_DEV_STAGE_BROM_PRE:
>> +		case T7XX_DEV_STAGE_BROM_POST:
>> +			dev_info(dev, "BROM_STAGE Entered\n");
> 
> Somewhat questionable if info level is really desirable for these?

Will change it dev_dbg.

> 
>> +			ret = t7xx_fsm_append_cmd(ctl, FSM_CMD_START, 0);
>> +			break;
>> +
>> +		case T7XX_DEV_STAGE_LK:
>> +			dev_info(dev, "LK_STAGE Entered\n");
>> +			t7xx_lk_stage_event_handling(ctl, status);
>> +			break;
>> +
>> +		case T7XX_DEV_STAGE_LINUX:
>> +			dev_info(dev, "LINUX_STAGE Entered\n");
>> +			t7xx_cldma_hif_hw_init(md->md_ctrl[CLDMA_ID_AP]);
>> +			t7xx_cldma_hif_hw_init(md->md_ctrl[CLDMA_ID_MD]);
>> +			t7xx_mhccif_mask_clr(md->t7xx_dev, D2H_INT_PORT_ENUM |
>> +					     D2H_INT_ASYNC_MD_HK | D2H_INT_ASYNC_AP_HK);
>> +			t7xx_port_proxy_set_cfg(md, PORT_CFG_ID_NORMAL);
>> +			ret = fsm_routine_starting(ctl);
>> +			break;
>> +
>> +		default:
>> +			break;
>> +		}
>> +		ctl->prev_status = status;
>>   	}
>>   
>> -	t7xx_cldma_hif_hw_init(md->md_ctrl[CLDMA_ID_AP]);
>> -	t7xx_cldma_hif_hw_init(md->md_ctrl[CLDMA_ID_MD]);
>> -	fsm_finish_command(ctl, cmd, fsm_routine_starting(ctl));
>> +finish_command:
>> +	fsm_finish_command(ctl, cmd, ret);
>>   }
>>   
>>   static int fsm_main_thread(void *data)
>> @@ -516,6 +578,7 @@ void t7xx_fsm_reset(struct t7xx_modem *md)
>>   	fsm_flush_event_cmd_qs(ctl);
>>   	ctl->curr_state = FSM_STATE_STOPPED;
>>   	ctl->exp_flg = false;
>> +	ctl->prev_status = 0;
>>   }
>>   
>>   int t7xx_fsm_init(struct t7xx_modem *md)
>> diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.h b/drivers/net/wwan/t7xx/t7xx_state_monitor.h
>> index b6e76f3903c8..5e8012567ba1 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_state_monitor.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.h
>> @@ -96,6 +96,7 @@ struct t7xx_fsm_ctl {
>>   	bool			exp_flg;
>>   	spinlock_t		notifier_lock;		/* Protects notifier list */
>>   	struct list_head	notifier_list;
>> +	u32                     prev_status;
>>   };
>>   
>>   struct t7xx_fsm_event {
>>
> 

-- 
Chetan
