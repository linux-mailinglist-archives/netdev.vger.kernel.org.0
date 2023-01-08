Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347A66615B8
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 15:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbjAHOHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 09:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjAHOHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 09:07:53 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B97F5A
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 06:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673186872; x=1704722872;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0JO44a6TP/Whpsx+Vpq0JEinNmF/qxJY8OAm9sasGMw=;
  b=m8g815PVITllUZaO2lECSlzX/yGMLQlJClTDRiT/QppZN2NLsOkLba2F
   KpKxh7oyhDZ/zDZBgJeDFQnIrS+r2OyR1Y+j72iwj5A8+ZIy/Onm/AvM9
   QjGkQj6fJ9tdedWZyzXlzI7Gw01tdCOfw6voq6siFn6T9MUJbv92xITCz
   QFwsdwjJCRK2wk6GRXQNF3y5j7I25nKUcRU3OckEh9cfevF1Lbu6lrori
   z4jEbNbeVRE1BRfAux5lGwKBtJQ5EatdiNZhjwtGKhrNfIzRpH7D3Ep8O
   YqYBSvPaPYNQWpXAZyVJRzpxE5gh7Zk2LtnDgFCuN8RsEeqH93jyRWtOL
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="306246928"
X-IronPort-AV: E=Sophos;i="5.96,310,1665471600"; 
   d="scan'208";a="306246928"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2023 06:07:45 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="649762467"
X-IronPort-AV: E=Sophos;i="5.96,310,1665471600"; 
   d="scan'208";a="649762467"
Received: from mckumar-mobl2.gar.corp.intel.com (HELO [10.213.110.20]) ([10.213.110.20])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2023 06:07:39 -0800
Message-ID: <e392d2df-48b3-fb7b-86d3-2ea22aa11467@linux.intel.com>
Date:   Sun, 8 Jan 2023 19:37:35 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 net-next 2/5] net: wwan: t7xx: Infrastructure for early
 port configuration
Content-Language: en-US
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        ilpo.jarvinen@linux.intel.com, ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com, linuxwwan@intel.com,
        linuxwwan_5g@intel.com, chandrashekar.devegowda@intel.com,
        matthias.bgg@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Madhusmita Sahu <madhusmita.sahu@intel.com>
References: <cover.1673016069.git.m.chetan.kumar@linux.intel.com>
 <cad74cd61423dbf01375a96432b3d1dbfcce0f1a.1673016069.git.m.chetan.kumar@linux.intel.com>
 <8b1bd24c-f14c-0244-d2fb-69d4f02b46d5@intel.com>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <8b1bd24c-f14c-0244-d2fb-69d4f02b46d5@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesse,
Thank you for the feedback.

On 1/7/2023 12:01 AM, Jesse Brandeburg wrote:
> On 1/6/2023 8:26 AM, m.chetan.kumar@linux.intel.com wrote:
>> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>>
>> To support cases such as FW update or Core dump, the t7xx
>> device is capable of signaling the host that a special port
>> needs to be created before the handshake phase.
>>
>> This patch adds the infrastructure required to create the
>> early ports which also requires a different configuration of
>> CLDMA queues.
> 
> nit: use imperative voice in your commit messages: no "this patch".
> instead:
> "Add the infrastructure..."

Sure. Will correct it.

> 
>>
>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>> Signed-off-by: Devegowda Chandrashekar 
>> <chandrashekar.devegowda@intel.com>
>> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>> -- 
>> v3:
>>   * No Change.
>> v2:
>>   * Move recv_skb handler to cldma_queue.
>>   * Drop cldma_queue_type.
>>   * Restore prototype of t7xx_port_send_raw_skb().
>>   * Remove PORT_CFG_ID_INVALID check in t7xx_port_proxy_set_cfg().
>>   * Add space before */.
>>   * Drop unnecessary logs.
>>   * Use WARN_ON on early port.
>>   * Use new MISC_DEV_STATUS_INVALID instead of MISC_DEV_STATUS.
>>   * Use macros instead of const identifiers.
>>   * Change ports member type from pointer to array type.
>>   * Prefix LK_EVENT_XX with MISC prefix.
>>   * Use t7xx prefix for device_stage enums.
>>   * Correct log messages.
>>   * Don’t override pkt_size for non-download port under dedicated Queue.
>>   * Drop cldma_txq_rxq_ids.
>>   * Use macro for txq/rxq index.
>>   * Use warn_on for rxq_idx comparison.
>>   * Drop t7xx_port_proxy_get_port_by_name().
>>   * Replace fsm poll with read_poll_timeout().
>>   * Use "\n" consistently across log message.
>>   * Remove local var _dev prefixes in fsm_routine_start().
>>   * Use max_t.
> 
> ...
> 
> 
>> diff --git a/drivers/net/wwan/t7xx/t7xx_reg.h 
>> b/drivers/net/wwan/t7xx/t7xx_reg.h
>> index c41d7d094c08..44352cd02460 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_reg.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_reg.h
>> @@ -102,10 +102,28 @@ enum t7xx_pm_resume_state {
>>   };
>>   #define T7XX_PCIE_MISC_DEV_STATUS        0x0d1c
>> -#define MISC_STAGE_MASK                GENMASK(2, 0)
>> -#define MISC_RESET_TYPE_PLDR            BIT(26)
>>   #define MISC_RESET_TYPE_FLDR            BIT(27)
>> -#define LINUX_STAGE                4
>> +#define MISC_RESET_TYPE_PLDR            BIT(26)
>> +#define MISC_DEV_STATUS_MASK            GENMASK(15, 0)
>> +#define MISC_DEV_STATUS_INVALID            GENMASK(15, 0)
> 
> I don't see any uses of this, even though it's mentioned in the commit 
> message. The only reason I looked was because it was weird to have 
> DEV_STATUS_MASK and STATUS_INVALID be the same values, is that correct?

Both are unused. Will drop it.

> 
> 
>> +#define MISC_LK_EVENT_MASK            GENMASK(11, 8)
>> +
>> +enum lk_event_id {
>> +    LK_EVENT_NORMAL = 0,
>> +    LK_EVENT_CREATE_PD_PORT = 1,
>> +    LK_EVENT_CREATE_POST_DL_PORT = 2,
>> +    LK_EVENT_RESET = 7,
>> +};
>> +
>> +#define MISC_STAGE_MASK                GENMASK(2, 0)
>> +
>> +enum t7xx_device_stage {
>> +    T7XX_DEV_STAGE_INIT = 0,
>> +    T7XX_DEV_STAGE_BROM_PRE = 1,
>> +    T7XX_DEV_STAGE_BROM_POST = 2,
>> +    T7XX_DEV_STAGE_LK = 3,
>> +    T7XX_DEV_STAGE_LINUX = 4,
>> +};
>>   #define T7XX_PCIE_RESOURCE_STATUS        0x0d28
>>   #define T7XX_PCIE_RESOURCE_STS_MSK        GENMASK(4, 0)
>> diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c 
>> b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
>> index 80edb8e75a6a..76fb5d57d4d7 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_state_monitor.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
>> @@ -206,6 +206,34 @@ static void fsm_routine_exception(struct 
>> t7xx_fsm_ctl *ctl, struct t7xx_fsm_comm
>>           fsm_finish_command(ctl, cmd, 0);
>>   }
>> +static void t7xx_lk_stage_event_handling(struct t7xx_fsm_ctl *ctl, 
>> unsigned int status)
>> +{
>> +    struct t7xx_modem *md = ctl->md;
>> +    struct cldma_ctrl *md_ctrl;
>> +    enum lk_event_id lk_event;
>> +    struct device *dev;
>> +
>> +    dev = &md->t7xx_dev->pdev->dev;
>> +    lk_event = FIELD_GET(MISC_LK_EVENT_MASK, status);
>> +    switch (lk_event) {
>> +    case LK_EVENT_NORMAL:
>> +    case LK_EVENT_RESET:
>> +        break;
>> +
>> +    case LK_EVENT_CREATE_PD_PORT:
>> +        md_ctrl = md->md_ctrl[CLDMA_ID_AP];
>> +        t7xx_cldma_hif_hw_init(md_ctrl);
>> +        t7xx_cldma_stop(md_ctrl);
>> +        t7xx_cldma_switch_cfg(md_ctrl, CLDMA_DEDICATED_Q_CFG);
>> +        t7xx_cldma_start(md_ctrl);
>> +        break;
>> +
>> +    default:
>> +        dev_err(dev, "Invalid LK event %d\n", lk_event);
>> +        break;
>> +    }
>> +}
>> +
>>   static int fsm_stopped_handler(struct t7xx_fsm_ctl *ctl)
>>   {
>>       ctl->curr_state = FSM_STATE_STOPPED;
>> @@ -317,8 +345,9 @@ static int fsm_routine_starting(struct 
>> t7xx_fsm_ctl *ctl)
>>   static void fsm_routine_start(struct t7xx_fsm_ctl *ctl, struct 
>> t7xx_fsm_command *cmd)
>>   {
>>       struct t7xx_modem *md = ctl->md;
>> -    u32 dev_status;
>> -    int ret;
>> +    struct device *dev;
>> +    u32 status, stage;
>> +    int ret = 0;
>>       if (!md)
>>           return;
>> @@ -329,23 +358,55 @@ static void fsm_routine_start(struct 
>> t7xx_fsm_ctl *ctl, struct t7xx_fsm_command
>>           return;
>>       }
>> +    dev = &md->t7xx_dev->pdev->dev;
>>       ctl->curr_state = FSM_STATE_PRE_START;
>>       t7xx_md_event_notify(md, FSM_PRE_START);
>> -    ret = read_poll_timeout(ioread32, dev_status,
>> -                (dev_status & MISC_STAGE_MASK) == LINUX_STAGE, 20000, 
>> 2000000,
>> -                false, IREG_BASE(md->t7xx_dev) + 
>> T7XX_PCIE_MISC_DEV_STATUS);
>> +    ret = read_poll_timeout(ioread32, status,
>> +                ((status & MISC_STAGE_MASK) == T7XX_DEV_STAGE_LINUX) ||
>> +                ((status & MISC_STAGE_MASK) == T7XX_DEV_STAGE_LK), 
>> 100000,
>> +                20000000, false, IREG_BASE(md->t7xx_dev) +
>> +                T7XX_PCIE_MISC_DEV_STATUS);
>> +
>>       if (ret) {
>> -        struct device *dev = &md->t7xx_dev->pdev->dev;
>> +        ret = -ETIMEDOUT;
>> +        dev_err(dev, "read poll %d\n", ret);
>> +        goto finish_command;
>> +    }
>> -        fsm_finish_command(ctl, cmd, -ETIMEDOUT);
>> -        dev_err(dev, "Invalid device status 0x%lx\n", dev_status & 
>> MISC_STAGE_MASK);
>> -        return;
>> +    if (status != ctl->prev_status) {
>> +        stage = FIELD_GET(MISC_STAGE_MASK, status);
> 
> if stage is only used down here you can declare it locally. cppcheck has 
> a check that will find these for you.

Ok. Will consider it.

> 
>> +        switch (stage) {
>> +        case T7XX_DEV_STAGE_INIT:
>> +        case T7XX_DEV_STAGE_BROM_PRE:
>> +        case T7XX_DEV_STAGE_BROM_POST:
>> +            dev_info(dev, "BROM_STAGE Entered\n");
>> +            ret = t7xx_fsm_append_cmd(ctl, FSM_CMD_START, 0);
>> +            break;
>> +
>> +        case T7XX_DEV_STAGE_LK:
>> +            dev_info(dev, "LK_STAGE Entered\n");
>> +            t7xx_lk_stage_event_handling(ctl, status);
>> +            break;
>> +
>> +        case T7XX_DEV_STAGE_LINUX:
>> +            dev_info(dev, "LINUX_STAGE Entered\n");
>> +            t7xx_cldma_hif_hw_init(md->md_ctrl[CLDMA_ID_AP]);
>> +            t7xx_cldma_hif_hw_init(md->md_ctrl[CLDMA_ID_MD]);
>> +            t7xx_mhccif_mask_clr(md->t7xx_dev, D2H_INT_PORT_ENUM |
>> +                         D2H_INT_ASYNC_MD_HK | D2H_INT_ASYNC_AP_HK);
>> +            t7xx_port_proxy_set_cfg(md, PORT_CFG_ID_NORMAL);
>> +            ret = fsm_routine_starting(ctl);
>> +            break;
>> +
>> +        default:
>> +            break;
>> +        }
>> +        ctl->prev_status = status;
>>       }
>> -    t7xx_cldma_hif_hw_init(md->md_ctrl[CLDMA_ID_AP]);
>> -    t7xx_cldma_hif_hw_init(md->md_ctrl[CLDMA_ID_MD]);
>> -    fsm_finish_command(ctl, cmd, fsm_routine_starting(ctl));
>> +finish_command:
>> +    fsm_finish_command(ctl, cmd, ret);
>>   }
>>   static int fsm_main_thread(void *data)
>> @@ -516,6 +577,7 @@ void t7xx_fsm_reset(struct t7xx_modem *md)
>>       fsm_flush_event_cmd_qs(ctl);
>>       ctl->curr_state = FSM_STATE_STOPPED;
>>       ctl->exp_flg = false;
>> +    ctl->prev_status = 0;
>>   }
>>   int t7xx_fsm_init(struct t7xx_modem *md)
>> diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.h 
>> b/drivers/net/wwan/t7xx/t7xx_state_monitor.h
>> index b6e76f3903c8..5e8012567ba1 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_state_monitor.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.h
>> @@ -96,6 +96,7 @@ struct t7xx_fsm_ctl {
>>       bool            exp_flg;
>>       spinlock_t        notifier_lock;        /* Protects notifier 
>> list */
>>       struct list_head    notifier_list;
>> +    u32                     prev_status;
>>   };
>>   struct t7xx_fsm_event {
> 

-- 
Chetan
