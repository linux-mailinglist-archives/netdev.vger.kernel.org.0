Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACF75A7DD1
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 14:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiHaMrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 08:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbiHaMra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 08:47:30 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F549C1CE
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 05:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661950049; x=1693486049;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=ImZah5BJH83X1Jo7wzun+451dRRRWagRwY+4x9beCPU=;
  b=T5juV51LYvkZbxoYiVgWDN4YJmmMf3fFf786UszehSLqpc+BDCv8AVQF
   rEm3wxKRGTIbDkSTE4BxXFrv2g9df1EK3gA99Ivbn/jRs0M0YIEyxFedA
   GvBQgmFsTI0DdRtwKUZOPUo7gOwU7s10rGPQlMvqOR65ZXmqC2LjwNX+H
   Aw5+j9Cy/vR/uTkShgK6lLoeAf6Uy4b6SMBermql6tpDkFcUsJPA4ccTB
   88TxP2VAIdYbBBpINrQelT/A2PhKcvTB2yYGlFMaHgbJbiCnpfsoiq4dm
   Xnn2fR+2NCTpc3RWYgCmsO/pbfMGQcAJddPrRB3mzBiY79ACmnS8LJtWo
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="275839569"
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="275839569"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 05:47:28 -0700
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="940423320"
Received: from mckumar-mobl2.gar.corp.intel.com (HELO [10.215.122.26]) ([10.215.122.26])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 05:47:25 -0700
Message-ID: <f5e8f36a-b32f-c834-ec58-080d28e5d474@linux.intel.com>
Date:   Wed, 31 Aug 2022 18:17:23 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
Subject: Re: [PATCH net-next 2/5] net: wwan: t7xx: Infrastructure for early
 port configuration
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Haijun Liu <haijun.liu@mediatek.com>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
References: <20220816042340.2416941-1-m.chetan.kumar@intel.com>
 <CAHNKnsSQP84gwe2aBsMKwp1PasbR18fouBbhyjQ4=NWZnnXw6A@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAHNKnsSQP84gwe2aBsMKwp1PasbR18fouBbhyjQ4=NWZnnXw6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/2022 7:29 AM, Sergey Ryazanov wrote:
> On Tue, Aug 16, 2022 at 7:12 AM <m.chetan.kumar@intel.com> wrote:
>> From: Haijun Liu <haijun.liu@mediatek.com>
>>
>> To support cases such as FW update or Core dump, the t7xx device
>> is capable of signaling the host that a special port needs
>> to be created before the handshake phase.
>>
>> This patch adds the infrastructure required to create the
>> early ports which also requires a different configuration of
>> CLDMA queues.
>>
>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>> Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
>> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>> ---
>>   drivers/net/wwan/t7xx/t7xx_hif_cldma.c     |  38 +++++--
>>   drivers/net/wwan/t7xx/t7xx_hif_cldma.h     |  24 ++++-
>>   drivers/net/wwan/t7xx/t7xx_modem_ops.c     |   4 +-
>>   drivers/net/wwan/t7xx/t7xx_port.h          |   3 +
>>   drivers/net/wwan/t7xx/t7xx_port_proxy.c    | 118 +++++++++++++++++++--
>>   drivers/net/wwan/t7xx/t7xx_port_proxy.h    |  11 +-
>>   drivers/net/wwan/t7xx/t7xx_port_wwan.c     |   3 +-
>>   drivers/net/wwan/t7xx/t7xx_reg.h           |  23 +++-
>>   drivers/net/wwan/t7xx/t7xx_state_monitor.c | 109 ++++++++++++++++---
>>   drivers/net/wwan/t7xx/t7xx_state_monitor.h |   2 +
>>   10 files changed, 294 insertions(+), 41 deletions(-)
>>
>> diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
>> index 37cd63d20b45..f26e6138f187 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
>> @@ -57,8 +57,6 @@
>>   #define CHECK_Q_STOP_TIMEOUT_US                1000000
>>   #define CHECK_Q_STOP_STEP_US           10000
>>
>> -#define CLDMA_JUMBO_BUFF_SZ            (63 * 1024 + sizeof(struct ccci_header))
>> -
>>   static void md_cd_queue_struct_reset(struct cldma_queue *queue, struct cldma_ctrl *md_ctrl,
>>                                       enum mtk_txrx tx_rx, unsigned int index)
>>   {
>> @@ -993,6 +991,34 @@ int t7xx_cldma_send_skb(struct cldma_ctrl *md_ctrl, int qno, struct sk_buff *skb
>>          return ret;
>>   }
>>
>> +static void t7xx_cldma_adjust_config(struct cldma_ctrl *md_ctrl, enum cldma_cfg cfg_id)
>> +{
>> +       int qno;
>> +
>> +       for (qno = 0; qno < CLDMA_RXQ_NUM; qno++) {
>> +               md_ctrl->rx_ring[qno].pkt_size = CLDMA_SHARED_Q_BUFF_SZ;
>> +               md_ctrl->rxq[qno].q_type = CLDMA_SHARED_Q;
>> +       }
>> +
>> +       md_ctrl->rx_ring[CLDMA_RXQ_NUM - 1].pkt_size = CLDMA_JUMBO_BUFF_SZ;
>> +
>> +       for (qno = 0; qno < CLDMA_TXQ_NUM; qno++) {
>> +               md_ctrl->tx_ring[qno].pkt_size = CLDMA_SHARED_Q_BUFF_SZ;
>> +               md_ctrl->txq[qno].q_type = CLDMA_SHARED_Q;
>> +       }
>> +
>> +       if (cfg_id == CLDMA_DEDICATED_Q_CFG) {
>> +               md_ctrl->rxq[DOWNLOAD_PORT_ID].q_type = CLDMA_DEDICATED_Q;
>> +               md_ctrl->txq[DOWNLOAD_PORT_ID].q_type = CLDMA_DEDICATED_Q;
>> +               md_ctrl->tx_ring[DOWNLOAD_PORT_ID].pkt_size = CLDMA_DEDICATED_Q_BUFF_SZ;
>> +               md_ctrl->rx_ring[DOWNLOAD_PORT_ID].pkt_size = CLDMA_DEDICATED_Q_BUFF_SZ;
>> +               md_ctrl->rxq[DUMP_PORT_ID].q_type = CLDMA_DEDICATED_Q;
>> +               md_ctrl->txq[DUMP_PORT_ID].q_type = CLDMA_DEDICATED_Q;
>> +               md_ctrl->tx_ring[DUMP_PORT_ID].pkt_size = CLDMA_DEDICATED_Q_BUFF_SZ;
>> +               md_ctrl->rx_ring[DUMP_PORT_ID].pkt_size = CLDMA_DEDICATED_Q_BUFF_SZ;
>> +       }
>> +}
>> +
>>   static int t7xx_cldma_late_init(struct cldma_ctrl *md_ctrl)
>>   {
>>          char dma_pool_name[32];
>> @@ -1021,11 +1047,6 @@ static int t7xx_cldma_late_init(struct cldma_ctrl *md_ctrl)
>>          }
>>
>>          for (j = 0; j < CLDMA_RXQ_NUM; j++) {
>> -               md_ctrl->rx_ring[j].pkt_size = CLDMA_MTU;
>> -
>> -               if (j == CLDMA_RXQ_NUM - 1)
>> -                       md_ctrl->rx_ring[j].pkt_size = CLDMA_JUMBO_BUFF_SZ;
>> -
>>                  ret = t7xx_cldma_rx_ring_init(md_ctrl, &md_ctrl->rx_ring[j]);
>>                  if (ret) {
>>                          dev_err(md_ctrl->dev, "Control RX ring init fail\n");
>> @@ -1329,9 +1350,10 @@ int t7xx_cldma_init(struct cldma_ctrl *md_ctrl)
>>          return -ENOMEM;
>>   }
>>
>> -void t7xx_cldma_switch_cfg(struct cldma_ctrl *md_ctrl)
>> +void t7xx_cldma_switch_cfg(struct cldma_ctrl *md_ctrl, enum cldma_cfg cfg_id)
>>   {
>>          t7xx_cldma_late_release(md_ctrl);
>> +       t7xx_cldma_adjust_config(md_ctrl, cfg_id);
>>          t7xx_cldma_late_init(md_ctrl);
>>   }
>>
>> diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.h b/drivers/net/wwan/t7xx/t7xx_hif_cldma.h
>> index 4410bac6993a..da3aa21c01eb 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.h
>> @@ -31,6 +31,10 @@
>>   #include "t7xx_cldma.h"
>>   #include "t7xx_pci.h"
>>
>> +#define CLDMA_JUMBO_BUFF_SZ            (63 * 1024 + sizeof(struct ccci_header))
>> +#define CLDMA_SHARED_Q_BUFF_SZ         3584
>> +#define CLDMA_DEDICATED_Q_BUFF_SZ      2048
>> +
>>   /**
>>    * enum cldma_id - Identifiers for CLDMA HW units.
>>    * @CLDMA_ID_MD: Modem control channel.
>> @@ -55,6 +59,16 @@ struct cldma_gpd {
>>          __le16 not_used2;
>>   };
>>
>> +enum cldma_queue_type {
>> +       CLDMA_SHARED_Q,
>> +       CLDMA_DEDICATED_Q,
>> +};
>> +
>> +enum cldma_cfg {
>> +       CLDMA_SHARED_Q_CFG,
>> +       CLDMA_DEDICATED_Q_CFG,
>> +};
> 
> Why do we need these identical enums? Can one of them be dropped in
> favor of the other?

queue_type will be dropped.

> 
>>   struct cldma_request {
>>          struct cldma_gpd *gpd;  /* Virtual address for CPU */
>>          dma_addr_t gpd_addr;    /* Physical address for DMA */
>> @@ -77,6 +91,7 @@ struct cldma_queue {
>>          struct cldma_request *tr_done;
>>          struct cldma_request *rx_refill;
>>          struct cldma_request *tx_next;
>> +       enum cldma_queue_type q_type;
>>          int budget;                     /* Same as ring buffer size by default */
>>          spinlock_t ring_lock;
>>          wait_queue_head_t req_wq;       /* Only for TX */
>> @@ -104,17 +119,20 @@ struct cldma_ctrl {
>>          int (*recv_skb)(struct cldma_queue *queue, struct sk_buff *skb);
>>   };
>>
>> +enum cldma_txq_rxq_port_id {
>> +       DOWNLOAD_PORT_ID = 0,
>> +       DUMP_PORT_ID = 1
>> +};
> 
> It is rather surprising to see a port indexing constant that is used
> for queue selection. Should this be something like this:
> 
> enum cldma_txq_rxq_ids {
>      CLDMA_Q_IDX_DOWNLOAD = 0,
>      CLDMA_Q_IDX_DUMP = 1,
> };
> 
> Just curious, am I missing something or is this Download queue never used?

Both dump and download is using same tx/rx[1] queue.
rx_port_ids will be dropped.

> 
>>   #define GPD_FLAGS_HWO          BIT(0)
>>   #define GPD_FLAGS_IOC          BIT(7)
>>   #define GPD_DMAPOOL_ALIGN      16
>>
>> -#define CLDMA_MTU              3584    /* 3.5kB */
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
>> diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.c b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
>> index c5a3c95004bd..ec2269dfaf2c 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_modem_ops.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
>> @@ -527,7 +527,7 @@ static void t7xx_md_hk_wq(struct work_struct *work)
>>
>>          /* Clear the HS2 EXIT event appended in core_reset() */
>>          t7xx_fsm_clr_event(ctl, FSM_EVENT_MD_HS2_EXIT);
>> -       t7xx_cldma_switch_cfg(md->md_ctrl[CLDMA_ID_MD]);
>> +       t7xx_cldma_switch_cfg(md->md_ctrl[CLDMA_ID_MD], CLDMA_SHARED_Q_CFG);
>>          t7xx_cldma_start(md->md_ctrl[CLDMA_ID_MD]);
>>          t7xx_fsm_broadcast_state(ctl, MD_STATE_WAITING_FOR_HS2);
>>          md->core_md.handshake_ongoing = true;
>> @@ -542,7 +542,7 @@ static void t7xx_ap_hk_wq(struct work_struct *work)
>>           /* Clear the HS2 EXIT event appended in t7xx_core_reset(). */
>>          t7xx_fsm_clr_event(ctl, FSM_EVENT_AP_HS2_EXIT);
>>          t7xx_cldma_stop(md->md_ctrl[CLDMA_ID_AP]);
>> -       t7xx_cldma_switch_cfg(md->md_ctrl[CLDMA_ID_AP]);
>> +       t7xx_cldma_switch_cfg(md->md_ctrl[CLDMA_ID_AP], CLDMA_SHARED_Q_CFG);
>>          t7xx_cldma_start(md->md_ctrl[CLDMA_ID_AP]);
>>          md->core_ap.handshake_ongoing = true;
>>          t7xx_core_hk_handler(md, &md->core_ap, ctl, FSM_EVENT_AP_HS2, FSM_EVENT_AP_HS2_EXIT);
> 
> [skipped]
> 
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>> index 62305d59da90..7582777cf94d 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>> @@ -88,6 +88,20 @@ static const struct t7xx_port_conf t7xx_md_port_conf[] = {
>>          },
>>   };
>>
>> +static struct t7xx_port_conf t7xx_early_port_conf[] = {
>> +       {
>> +               .tx_ch = 0xffff,
>> +               .rx_ch = 0xffff,
> 
> Maybe
> 
> #define PORT_CH_ID_UNIMPORTANT 0xffff

Ok. will change it.

> 
> .tx_ch = PORT_CH_ID_UNIMPORTANT,
> .rx_ch = PORT_CH_ID_UNIMPORTANT,
> 
>> +               .txq_index = 1,
>> +               .rxq_index = 1,
>> +               .txq_exp_index = 1,
>> +               .rxq_exp_index = 1,
> 
> Maybe this should be:
> 
> .txq_index = CLDMA_Q_IDX_DUMP,
> .rxq_index = CLDMA_Q_IDX_DUMP,
> .txq_exp_index = CLDMA_Q_IDX_DUMP,
> .rxq_exp_index = CLDMA_Q_IDX_DUMP,

Ok. will change it.

> 
>> +               .path_id = CLDMA_ID_AP,
>> +               .is_early_port = true,
>> +               .name = "ttyDUMP",
> 
> There are no more TTY devices in the driver. Should the 'tty' prefix be dropped?

Sure. will drop tty prefix.
> 
>> +       },
>> +};
>> +
>>   static struct t7xx_port *t7xx_proxy_get_port_by_ch(struct port_proxy *port_prox, enum port_ch ch)
>>   {
>>          const struct t7xx_port_conf *port_conf;
>> @@ -202,7 +216,17 @@ int t7xx_port_enqueue_skb(struct t7xx_port *port, struct sk_buff *skb)
>>          return 0;
>>   }
>>
>> -static int t7xx_port_send_raw_skb(struct t7xx_port *port, struct sk_buff *skb)
>> +int t7xx_get_port_mtu(struct t7xx_port *port)
>> +{
>> +       enum cldma_id path_id = port->port_conf->path_id;
>> +       int tx_qno = t7xx_port_get_queue_no(port);
>> +       struct cldma_ctrl *md_ctrl;
>> +
>> +       md_ctrl = port->t7xx_dev->md->md_ctrl[path_id];
>> +       return md_ctrl->tx_ring[tx_qno].pkt_size;
>> +}
>> +
>> +int t7xx_port_send_raw_skb(struct t7xx_port *port, struct sk_buff *skb)
>>   {
>>          enum cldma_id path_id = port->port_conf->path_id;
>>          struct cldma_ctrl *md_ctrl;
>> @@ -317,6 +341,26 @@ static void t7xx_proxy_setup_ch_mapping(struct port_proxy *port_prox)
>>          }
>>   }
>>
>> +static int t7xx_port_proxy_recv_skb_from_queue(struct t7xx_pci_dev *t7xx_dev,
>> +                                              struct cldma_queue *queue, struct sk_buff *skb)
>> +{
>> +       struct port_proxy *port_prox = t7xx_dev->md->port_prox;
>> +       const struct t7xx_port_conf *port_conf;
>> +       struct t7xx_port *port;
>> +       int ret;
>> +
>> +       port = port_prox->ports;
> 
> Should this be:
> 
> port = &port_prox->ports[0];
> if (WARN_ON(port->rxq_idx != queue->index)) {
>      dev_kfree_skb_any(skb);
>      return -EINVAL;
> }
> 
> ?

Ya. Will correct it.

> 
>> +       port_conf = port->port_conf;
>> +
>> +       ret = port_conf->ops->recv_skb(port, skb);
>> +       if (ret < 0 && ret != -ENOBUFS) {
>> +               dev_err(port->dev, "drop on RX ch %d, %d\n", port_conf->rx_ch, ret);
>> +               dev_kfree_skb_any(skb);
>> +       }
>> +
>> +       return ret;
>> +}
>> +
>>   static struct t7xx_port *t7xx_port_proxy_find_port(struct t7xx_pci_dev *t7xx_dev,
>>                                                     struct cldma_queue *queue, u16 channel)
>>   {
>> @@ -338,6 +382,22 @@ static struct t7xx_port *t7xx_port_proxy_find_port(struct t7xx_pci_dev *t7xx_dev
>>          return NULL;
>>   }
>>
>> +struct t7xx_port *t7xx_port_proxy_get_port_by_name(struct port_proxy *port_prox, char *port_name)
>> +{
>> +       const struct t7xx_port_conf *port_conf;
>> +       struct t7xx_port *port;
>> +       int i;
>> +
>> +       for_each_proxy_port(i, port, port_prox) {
>> +               port_conf = port->port_conf;
>> +
>> +               if (!strncmp(port_conf->name, port_name, strlen(port_conf->name)))
>> +                       return port;
>> +       }
>> +
>> +       return NULL;
>> +}
>> +
>>   /**
>>    * t7xx_port_proxy_recv_skb() - Dispatch received skb.
>>    * @queue: CLDMA queue.
>> @@ -358,6 +418,9 @@ static int t7xx_port_proxy_recv_skb(struct cldma_queue *queue, struct sk_buff *s
>>          u16 seq_num, channel;
>>          int ret;
>>
>> +       if (queue->q_type == CLDMA_DEDICATED_Q)
>> +               return t7xx_port_proxy_recv_skb_from_queue(t7xx_dev, queue, skb);
> 
> Does it worth to reuse the ports layer to communicate with hardware in
> the fastboot mode?
> 
> It may be easier to communicate with the hardware directly via the
> CLDMA layer, completely bypassing the ports. It seems that if we will
> communicate directly with the CLDMA layer, then we will not need these
> hooks and hacks at the ports layer that are just implement some kind
> of bypass.

recv_skb() implementation will be revisited. At present recv_skb() is 
set at CLDMA so we had to touch port layer to take different path for rx 
packet in fastboot mode. It will be handled at queue level so we should 
get rid of such checks.

> 
>>          channel = FIELD_GET(CCCI_H_CHN_FLD, le32_to_cpu(ccci_h->status));
>>          if (t7xx_fsm_get_md_state(ctl) == MD_STATE_INVALID) {
>>                  dev_err_ratelimited(dev, "Packet drop on channel 0x%x, modem not ready\n", channel);
>> @@ -372,7 +435,8 @@ static int t7xx_port_proxy_recv_skb(struct cldma_queue *queue, struct sk_buff *s
>>
>>          seq_num = t7xx_port_next_rx_seq_num(port, ccci_h);
>>          port_conf = port->port_conf;
>> -       skb_pull(skb, sizeof(*ccci_h));
>> +       if (!port->port_conf->is_early_port)
>> +               skb_pull(skb, sizeof(*ccci_h));
>>
>>          ret = port_conf->ops->recv_skb(port, skb);
>>          /* Error indicates to try again later */
>> @@ -439,26 +503,58 @@ static void t7xx_proxy_init_all_ports(struct t7xx_modem *md)
>>          t7xx_proxy_setup_ch_mapping(port_prox);
>>   }
>>
>> +void t7xx_port_proxy_set_cfg(struct t7xx_modem *md, enum port_cfg_id cfg_id)
>> +{
>> +       struct port_proxy *port_prox = md->port_prox;
>> +       const struct t7xx_port_conf *port_conf;
>> +       struct device *dev = port_prox->dev;
>> +       unsigned int port_count;
>> +       struct t7xx_port *port;
>> +       int i;
>> +
>> +       if (port_prox->cfg_id == cfg_id)
>> +               return;
>> +
>> +       if (port_prox->cfg_id != PORT_CFG_ID_INVALID) {
>> +               for_each_proxy_port(i, port, port_prox)
>> +                       port->port_conf->ops->uninit(port);
>> +
>> +               devm_kfree(dev, port_prox->ports);
>> +       }
>> +
>> +       if (cfg_id == PORT_CFG_ID_EARLY) {
>> +               port_conf = t7xx_early_port_conf;
>> +               port_count = ARRAY_SIZE(t7xx_early_port_conf);
>> +       } else {
>> +               port_conf = t7xx_md_port_conf;
>> +               port_count = ARRAY_SIZE(t7xx_md_port_conf);
>> +       }
>> +
>> +       port_prox->ports = devm_kzalloc(dev, sizeof(struct t7xx_port) * port_count, GFP_KERNEL);
>> +       if (!port_prox->ports)
>> +               return;
>> +
>> +       for (i = 0; i < port_count; i++)
>> +               port_prox->ports[i].port_conf = &port_conf[i];
>> +
>> +       port_prox->cfg_id = cfg_id;
>> +       port_prox->port_count = port_count;
>> +       t7xx_proxy_init_all_ports(md);
>> +}
>> +
>>   static int t7xx_proxy_alloc(struct t7xx_modem *md)
>>   {
>> -       unsigned int port_count = ARRAY_SIZE(t7xx_md_port_conf);
>>          struct device *dev = &md->t7xx_dev->pdev->dev;
>>          struct port_proxy *port_prox;
>> -       int i;
>>
>> -       port_prox = devm_kzalloc(dev, sizeof(*port_prox) + sizeof(struct t7xx_port) * port_count,
>> -                                GFP_KERNEL);
>> +       port_prox = devm_kzalloc(dev, sizeof(*port_prox), GFP_KERNEL);
> 
> Just allocate enough space for largest set of ports:
> 
> max_port_count = ARRAY_SIZE(t7xx_md_port_conf);
> max_port_count = max(max_port_count, ARRAY_SIZE(t7xx_early_port_conf));
> port_prox = devm_kzalloc(dev, struct_size(port_prox, ports,
> max_port_count), GFP_KERNEL);
> 
> And the ports array allocation on each (re-)configuration is gone.
> 
>>          if (!port_prox)
>>                  return -ENOMEM;
>>
>>          md->port_prox = port_prox;
>>          port_prox->dev = dev;
>> +       t7xx_port_proxy_set_cfg(md, PORT_CFG_ID_EARLY);
>>
>> -       for (i = 0; i < port_count; i++)
>> -               port_prox->ports[i].port_conf = &t7xx_md_port_conf[i];
>> -
>> -       port_prox->port_count = port_count;
>> -       t7xx_proxy_init_all_ports(md);
>>          return 0;
>>   }
>>
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.h b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
>> index bc1ff5c6c700..33caf85f718a 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_port_proxy.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
>> @@ -31,12 +31,19 @@
>>   #define RX_QUEUE_MAXLEN                32
>>   #define CTRL_QUEUE_MAXLEN      16
>>
>> +enum port_cfg_id {
>> +       PORT_CFG_ID_INVALID,
>> +       PORT_CFG_ID_NORMAL,
>> +       PORT_CFG_ID_EARLY,
>> +};
>> +
>>   struct port_proxy {
>>          int                     port_count;
>>          struct list_head        rx_ch_ports[PORT_CH_ID_MASK + 1];
>>          struct list_head        queue_ports[CLDMA_NUM][MTK_QUEUES];
>>          struct device           *dev;
>> -       struct t7xx_port        ports[];
>> +       enum port_cfg_id        cfg_id;
>> +       struct t7xx_port        *ports;
> 
> It is still possible to keep the ports array a part of the port_proxy
> struct. Just allocate enough space to hold a biggest set of ports (see
> comment in the t7xx_proxy_alloc()). This will make the code a bit
> simpler.

Sure. will fix it.

> 
>>   };
>>
>>   struct ccci_header {
> 
> [skipped]
> 
>> diff --git a/drivers/net/wwan/t7xx/t7xx_reg.h b/drivers/net/wwan/t7xx/t7xx_reg.h
>> index c41d7d094c08..60e025e57baa 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_reg.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_reg.h
>> @@ -102,10 +102,27 @@ enum t7xx_pm_resume_state {
>>   };
>>
>>   #define T7XX_PCIE_MISC_DEV_STATUS              0x0d1c
>> -#define MISC_STAGE_MASK                                GENMASK(2, 0)
>> -#define MISC_RESET_TYPE_PLDR                   BIT(26)
>>   #define MISC_RESET_TYPE_FLDR                   BIT(27)
>> -#define LINUX_STAGE                            4
>> +#define MISC_RESET_TYPE_PLDR                   BIT(26)
>> +#define MISC_DEV_STATUS_MASK                   GENMASK(15, 0)
>> +#define LK_EVENT_MASK                          GENMASK(11, 8)
> 
> MISC_LK_EVENT_MASK for consistency?

Sure. will rename it.

> 
>> +
>> +enum lk_event_id {
>> +       LK_EVENT_NORMAL = 0,
>> +       LK_EVENT_CREATE_PD_PORT = 1,
>> +       LK_EVENT_CREATE_POST_DL_PORT = 2,
>> +       LK_EVENT_RESET = 7,
>> +};
>> +
>> +#define MISC_STAGE_MASK                                GENMASK(2, 0)
>> +
>> +enum t7xx_device_stage {
>> +       INIT_STAGE = 0,
>> +       PRE_BROM_STAGE = 1,
>> +       POST_BROM_STAGE = 2,
>> +       LK_STAGE = 3,
>> +       LINUX_STAGE = 4,
> 
> Can these stage names be reworded by placing a common prefix first? E.g.
> 
> T7XX_DEV_STAGE_INIT = 0,
> T7XX_DEV_STAGE_BROM_PRE = 1,
> T7XX_DEV_STAGE_BROM_POST = 2,
> T7XX_DEV_STAGE_LK = 3,
> ....

Sure. will change it.

> 
>> +};
>>
>>   #define T7XX_PCIE_RESOURCE_STATUS              0x0d28
>>   #define T7XX_PCIE_RESOURCE_STS_MSK             GENMASK(4, 0)
>> diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
>> index 80edb8e75a6a..c1789a558c9d 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_state_monitor.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
>> @@ -47,6 +47,10 @@
>>   #define FSM_MD_EX_PASS_TIMEOUT_MS              45000
>>   #define FSM_CMD_TIMEOUT_MS                     2000
>>
>> +/* As per MTK, AP to MD Handshake time is ~15s*/
>> +#define DEVICE_STAGE_POLL_INTERVAL_MS          100
>> +#define DEVICE_STAGE_POLL_COUNT                        150
>> +
>>   void t7xx_fsm_notifier_register(struct t7xx_modem *md, struct t7xx_fsm_notifier *notifier)
>>   {
>>          struct t7xx_fsm_ctl *ctl = md->fsm_ctl;
>> @@ -206,6 +210,46 @@ static void fsm_routine_exception(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_comm
>>                  fsm_finish_command(ctl, cmd, 0);
>>   }
>>
>> +static void t7xx_lk_stage_event_handling(struct t7xx_fsm_ctl *ctl, unsigned int dev_status)
>> +{
>> +       struct t7xx_modem *md = ctl->md;
>> +       struct cldma_ctrl *md_ctrl;
>> +       enum lk_event_id lk_event;
>> +       struct t7xx_port *port;
>> +       struct device *dev;
>> +
>> +       dev = &md->t7xx_dev->pdev->dev;
>> +       lk_event = FIELD_GET(LK_EVENT_MASK, dev_status);
>> +       dev_info(dev, "Device enter next stage from LK stage/n");
>> +       switch (lk_event) {
>> +       case LK_EVENT_NORMAL:
>> +               break;
>> +
>> +       case LK_EVENT_CREATE_PD_PORT:
>> +               md_ctrl = md->md_ctrl[CLDMA_ID_AP];
>> +               t7xx_cldma_hif_hw_init(md_ctrl);
>> +               t7xx_cldma_stop(md_ctrl);
>> +               t7xx_cldma_switch_cfg(md_ctrl, CLDMA_DEDICATED_Q_CFG);
>> +               dev_info(dev, "creating the ttyDUMP port\n");
>> +               port = t7xx_port_proxy_get_port_by_name(md->port_prox, "ttyDUMP");
> 
> The 'DUMP' port is special and directly accessible via
> ctl->md->t7xx_dev->dl->port. Why do we need this
> t7xx_port_proxy_get_port_by_name() function, which is called only
> here?

Not required we can directly access it.
Will clean it up.

> 
>> +               if (!port) {
>> +                       dev_err(dev, "ttyDUMP port not found\n");
>> +                       return;
>> +               }
>> +
>> +               port->port_conf->ops->enable_chl(port);
>> +               t7xx_cldma_start(md_ctrl);
>> +               break;
>> +
>> +       case LK_EVENT_RESET:
>> +               break;
>> +
>> +       default:
>> +               dev_err(dev, "Invalid BROM event\n");
> 
> Maybe this should be "Invalid LK event" or even "Invalid LK event %d"?

Ok. Will change it to "Invalid LK event %d".

> 
>> +               break;
>> +       }
>> +}
>> +
>>   static int fsm_stopped_handler(struct t7xx_fsm_ctl *ctl)
>>   {
>>          ctl->curr_state = FSM_STATE_STOPPED;
>> @@ -317,8 +361,10 @@ static int fsm_routine_starting(struct t7xx_fsm_ctl *ctl)
>>   static void fsm_routine_start(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_command *cmd)
>>   {
>>          struct t7xx_modem *md = ctl->md;
>> +       unsigned int device_stage;
>> +       struct device *dev;
>>          u32 dev_status;
>> -       int ret;
>> +       int ret = 0;
>>
>>          if (!md)
>>                  return;
>> @@ -329,23 +375,60 @@ static void fsm_routine_start(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_command
>>                  return;
>>          }
>>
>> +       dev = &md->t7xx_dev->pdev->dev;
>> +       dev_status = ioread32(IREG_BASE(md->t7xx_dev) + T7XX_PCIE_MISC_DEV_STATUS);
>> +       dev_status &= MISC_DEV_STATUS_MASK;
>> +       dev_dbg(dev, "dev_status = %x modem state = %d\n", dev_status, ctl->md_state);
>> +
>> +       if (dev_status == MISC_DEV_STATUS_MASK) {
>> +               dev_err(dev, "invalid device status\n");
>> +               ret = -EINVAL;
>> +               goto finish_command;
>> +       }
>> +
>>          ctl->curr_state = FSM_STATE_PRE_START;
>>          t7xx_md_event_notify(md, FSM_PRE_START);
>>
>> -       ret = read_poll_timeout(ioread32, dev_status,
>> -                               (dev_status & MISC_STAGE_MASK) == LINUX_STAGE, 20000, 2000000,
>> -                               false, IREG_BASE(md->t7xx_dev) + T7XX_PCIE_MISC_DEV_STATUS);
>> -       if (ret) {
>> -               struct device *dev = &md->t7xx_dev->pdev->dev;
>> +       device_stage = FIELD_GET(MISC_STAGE_MASK, dev_status);
>> +       if (dev_status == ctl->prev_dev_status) {
>> +               if (ctl->device_stage_check_cnt++ >= DEVICE_STAGE_POLL_COUNT) {
>> +                       dev_err(dev, "Timeout at device stage 0x%x\n", device_stage);
>> +                       ctl->device_stage_check_cnt = 0;
>> +                       ret = -ETIMEDOUT;
>> +               } else {
>> +                       msleep(DEVICE_STAGE_POLL_INTERVAL_MS);
>> +                       ret = t7xx_fsm_append_cmd(ctl, FSM_CMD_START, 0);
> 
> Just another interesting decision. What is the reason for respining
> the register read by finishing the current START command and placing
> another START command to the queue? Would not it be clearer to use the
> busy-loop polling like before? At least, this will remove the need to
> preserve the register value between invocations and reduce a number of
> FSM_PRE_START events.

I think we found what the problem was. Will rollback to earlier 
implementation (read_poll_timeout) and add new cond for fastboot/lk 
stage & handle it.


> 
>> +               }
>>
>> -               fsm_finish_command(ctl, cmd, -ETIMEDOUT);
>> -               dev_err(dev, "Invalid device status 0x%lx\n", dev_status & MISC_STAGE_MASK);
>> -               return;
>> +               goto finish_command;
>> +       }
>> +
>> +       switch (device_stage) {
>> +       case INIT_STAGE:
>> +       case PRE_BROM_STAGE:
>> +       case POST_BROM_STAGE:
>> +               ret = t7xx_fsm_append_cmd(ctl, FSM_CMD_START, 0);
>> +               break;
>> +
>> +       case LK_STAGE:
>> +               dev_info(dev, "LK_STAGE Entered");
>> +               t7xx_lk_stage_event_handling(ctl, dev_status);
>> +               break;
>> +
>> +       case LINUX_STAGE:
>> +               t7xx_cldma_hif_hw_init(md->md_ctrl[CLDMA_ID_AP]);
>> +               t7xx_cldma_hif_hw_init(md->md_ctrl[CLDMA_ID_MD]);
>> +               t7xx_port_proxy_set_cfg(md, PORT_CFG_ID_NORMAL);
>> +               ret = fsm_routine_starting(ctl);
>> +               break;
>> +
>> +       default:
>> +               break;
>>          }
>>
>> -       t7xx_cldma_hif_hw_init(md->md_ctrl[CLDMA_ID_AP]);
>> -       t7xx_cldma_hif_hw_init(md->md_ctrl[CLDMA_ID_MD]);
>> -       fsm_finish_command(ctl, cmd, fsm_routine_starting(ctl));
>> +finish_command:
>> +       ctl->prev_dev_status = dev_status;
>> +       fsm_finish_command(ctl, cmd, ret);
>>   }
>>
>>   static int fsm_main_thread(void *data)
>> @@ -516,6 +599,8 @@ void t7xx_fsm_reset(struct t7xx_modem *md)
>>          fsm_flush_event_cmd_qs(ctl);
>>          ctl->curr_state = FSM_STATE_STOPPED;
>>          ctl->exp_flg = false;
>> +       ctl->prev_dev_status = 0;
>> +       ctl->device_stage_check_cnt = 0;
>>   }
>>
>>   int t7xx_fsm_init(struct t7xx_modem *md)
> 
> --
> Sergey

-- 
Chetan
