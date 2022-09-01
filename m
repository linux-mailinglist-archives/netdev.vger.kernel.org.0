Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8781F5A8DD6
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 07:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbiIAF7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 01:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233299AbiIAF6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 01:58:51 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6CE1195C0
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 22:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662011896; x=1693547896;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PN3mAN2CSAFwAmgsUZ1jfaVrXne9gILIY3/98V55mr4=;
  b=EMs32WePYlToscLpkh05mGw4UWIMsPQzlAeCQFQgMIUFu/ZoXIuXIoma
   IktASAFx1Y8ZhVTmepc2Is7YWosRmV9WOJiPNLxeS9PyP5Gax0Jh5pKhO
   MscHqONgsM0EQZ8QuxB25y4/lo2oAQikOYq5mLgqTfJuiQuExiFusa3O8
   oJGDzyQYYeDLUBgu5dniSzYf+vb/+qDS3hm3/P55q5L9Df9fwmx8DjVpG
   5wh+6jtym6D+/QtIw2PqhcFG850JyVbUwi5515Jo2P52OKNWP/7tl238j
   OVp+8QV8PqbQRsp8rplYWq6ymfTzCveHGUL7CQxqivY4fg/3b4GfDl7Z0
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="278641730"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="278641730"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 22:57:51 -0700
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="642181667"
Received: from mckumar-mobl2.gar.corp.intel.com (HELO [10.213.103.117]) ([10.213.103.117])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 22:57:47 -0700
Message-ID: <bb89f636-0cc8-1a3d-ee92-31fde04bc8e6@linux.intel.com>
Date:   Thu, 1 Sep 2022 11:27:44 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next 1/5] net: wwan: t7xx: Add AP CLDMA
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Haijun Liu <haijun.liu@mediatek.com>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>,
        Moises Veleta <moises.veleta@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>,
        =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>
References: <20220816042328.2416926-1-m.chetan.kumar@intel.com>
 <CAHNKnsSUp=E0VMf8sjFoG7uoxdW_O_Lwu57NOiPj1it-mYZnNQ@mail.gmail.com>
 <aed8af81-852c-1e75-b522-76e52ca12a39@linux.intel.com>
 <CAHNKnsRc8Vrxqc22o3LXy17eArtCtTpX2D6Ti4_cJfumvBOe=Q@mail.gmail.com>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <CAHNKnsRc8Vrxqc22o3LXy17eArtCtTpX2D6Ti4_cJfumvBOe=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/2022 7:34 PM, Sergey Ryazanov wrote:
> On Wed, Aug 31, 2022 at 3:46 PM Kumar, M Chetan
> <m.chetan.kumar@linux.intel.com> wrote:
>> On 8/30/2022 7:23 AM, Sergey Ryazanov wrote:
>>> On Tue, Aug 16, 2022 at 7:11 AM <m.chetan.kumar@intel.com> wrote:
>>>> From: Haijun Liu <haijun.liu@mediatek.com>
>>>>
>>>> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
>>>> communicate with AP and Modem processors respectively. So far only
>>>> MD-CLDMA was being used, this patch enables AP-CLDMA.
>>>>
>>>> Rename small Application Processor (sAP) to AP.
>>>>
>>>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>>>> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>>>> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>>>> Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>
>>>> Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
>>>> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>>>> Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
>>>
>>> Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
>>>
>>> And just one nitpick/question below.
>>>
>>>> diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.c b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
>>>> index 3458af31e864..c5a3c95004bd 100644
>>>> --- a/drivers/net/wwan/t7xx/t7xx_modem_ops.c
>>>> +++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
>>>> @@ -44,6 +44,7 @@
>>>>    #include "t7xx_state_monitor.h"
>>>>
>>>>    #define RT_ID_MD_PORT_ENUM     0
>>>> +#define RT_ID_AP_PORT_ENUM     1
>>>>    /* Modem feature query identification code - "ICCC" */
>>>>    #define MD_FEATURE_QUERY_ID    0x49434343
>>>>
>>>> @@ -296,6 +297,7 @@ static void t7xx_md_exception(struct t7xx_modem *md, enum hif_ex_stage stage)
>>>>           }
>>>>
>>>>           t7xx_cldma_exception(md->md_ctrl[CLDMA_ID_MD], stage);
>>>> +       t7xx_cldma_exception(md->md_ctrl[CLDMA_ID_AP], stage);
>>>>
>>>>           if (stage == HIF_EX_INIT)
>>>>                   t7xx_mhccif_h2d_swint_trigger(t7xx_dev, H2D_CH_EXCEPTION_ACK);
>>>> @@ -424,7 +426,7 @@ static int t7xx_parse_host_rt_data(struct t7xx_fsm_ctl *ctl, struct t7xx_sys_inf
>>>>                   if (ft_spt_st != MTK_FEATURE_MUST_BE_SUPPORTED)
>>>>                           return -EINVAL;
>>>>
>>>> -               if (i == RT_ID_MD_PORT_ENUM)
>>>> +               if (i == RT_ID_MD_PORT_ENUM || i == RT_ID_AP_PORT_ENUM)
>>>>                           t7xx_port_enum_msg_handler(ctl->md, rt_feature->data);
>>>>           }
>>>>
>>>> @@ -454,12 +456,12 @@ static int t7xx_core_reset(struct t7xx_modem *md)
>>>>           return 0;
>>>>    }
>>>>
>>>> -static void t7xx_core_hk_handler(struct t7xx_modem *md, struct t7xx_fsm_ctl *ctl,
>>>> +static void t7xx_core_hk_handler(struct t7xx_modem *md, struct t7xx_sys_info *core_info,
>>>> +                                struct t7xx_fsm_ctl *ctl,
>>>>                                    enum t7xx_fsm_event_state event_id,
>>>>                                    enum t7xx_fsm_event_state err_detect)
>>>>    {
>>>>           struct t7xx_fsm_event *event = NULL, *event_next;
>>>> -       struct t7xx_sys_info *core_info = &md->core_md;
>>>>           struct device *dev = &md->t7xx_dev->pdev->dev;
>>>>           unsigned long flags;
>>>>           int ret;
>>>> @@ -529,19 +531,33 @@ static void t7xx_md_hk_wq(struct work_struct *work)
>>>>           t7xx_cldma_start(md->md_ctrl[CLDMA_ID_MD]);
>>>>           t7xx_fsm_broadcast_state(ctl, MD_STATE_WAITING_FOR_HS2);
>>>>           md->core_md.handshake_ongoing = true;
>>>> -       t7xx_core_hk_handler(md, ctl, FSM_EVENT_MD_HS2, FSM_EVENT_MD_HS2_EXIT);
>>>> +       t7xx_core_hk_handler(md, &md->core_md, ctl, FSM_EVENT_MD_HS2, FSM_EVENT_MD_HS2_EXIT);
>>>> +}
>>>> +
>>>> +static void t7xx_ap_hk_wq(struct work_struct *work)
>>>> +{
>>>> +       struct t7xx_modem *md = container_of(work, struct t7xx_modem, ap_handshake_work);
>>>> +       struct t7xx_fsm_ctl *ctl = md->fsm_ctl;
>>>> +
>>>> +        /* Clear the HS2 EXIT event appended in t7xx_core_reset(). */
>>>> +       t7xx_fsm_clr_event(ctl, FSM_EVENT_AP_HS2_EXIT);
>>>> +       t7xx_cldma_stop(md->md_ctrl[CLDMA_ID_AP]);
>>>> +       t7xx_cldma_switch_cfg(md->md_ctrl[CLDMA_ID_AP]);
>>>> +       t7xx_cldma_start(md->md_ctrl[CLDMA_ID_AP]);
>>>> +       md->core_ap.handshake_ongoing = true;
>>>> +       t7xx_core_hk_handler(md, &md->core_ap, ctl, FSM_EVENT_AP_HS2, FSM_EVENT_AP_HS2_EXIT);
>>>>    }
>>>>
>>>>    void t7xx_md_event_notify(struct t7xx_modem *md, enum md_event_id evt_id)
>>>>    {
>>>>           struct t7xx_fsm_ctl *ctl = md->fsm_ctl;
>>>> -       void __iomem *mhccif_base;
>>>>           unsigned int int_sta;
>>>>           unsigned long flags;
>>>>
>>>>           switch (evt_id) {
>>>>           case FSM_PRE_START:
>>>> -               t7xx_mhccif_mask_clr(md->t7xx_dev, D2H_INT_PORT_ENUM);
>>>> +               t7xx_mhccif_mask_clr(md->t7xx_dev, D2H_INT_PORT_ENUM | D2H_INT_ASYNC_MD_HK |
>>>> +                                                  D2H_INT_ASYNC_AP_HK);
>>>>                   break;
>>>>
>>>>           case FSM_START:
>>>> @@ -554,16 +570,26 @@ void t7xx_md_event_notify(struct t7xx_modem *md, enum md_event_id evt_id)
>>>>                           ctl->exp_flg = true;
>>>>                           md->exp_id &= ~D2H_INT_EXCEPTION_INIT;
>>>>                           md->exp_id &= ~D2H_INT_ASYNC_MD_HK;
>>>> +                       md->exp_id &= ~D2H_INT_ASYNC_AP_HK;
>>>>                   } else if (ctl->exp_flg) {
>>>>                           md->exp_id &= ~D2H_INT_ASYNC_MD_HK;
>>>> -               } else if (md->exp_id & D2H_INT_ASYNC_MD_HK) {
>>>> -                       queue_work(md->handshake_wq, &md->handshake_work);
>>>> -                       md->exp_id &= ~D2H_INT_ASYNC_MD_HK;
>>>> -                       mhccif_base = md->t7xx_dev->base_addr.mhccif_rc_base;
>>>> -                       iowrite32(D2H_INT_ASYNC_MD_HK, mhccif_base + REG_EP2RC_SW_INT_ACK);
>>>> -                       t7xx_mhccif_mask_set(md->t7xx_dev, D2H_INT_ASYNC_MD_HK);
>>>> +                       md->exp_id &= ~D2H_INT_ASYNC_AP_HK;
>>>>                   } else {
>>>> -                       t7xx_mhccif_mask_clr(md->t7xx_dev, D2H_INT_ASYNC_MD_HK);
>>>> +                       void __iomem *mhccif_base = md->t7xx_dev->base_addr.mhccif_rc_base;
>>>> +
>>>> +                       if (md->exp_id & D2H_INT_ASYNC_MD_HK) {
>>>> +                               queue_work(md->handshake_wq, &md->handshake_work);
>>>> +                               md->exp_id &= ~D2H_INT_ASYNC_MD_HK;
>>>> +                               iowrite32(D2H_INT_ASYNC_MD_HK, mhccif_base + REG_EP2RC_SW_INT_ACK);
>>>> +                               t7xx_mhccif_mask_set(md->t7xx_dev, D2H_INT_ASYNC_MD_HK);
>>>> +                       }
>>>> +
>>>> +                       if (md->exp_id & D2H_INT_ASYNC_AP_HK) {
>>>> +                               queue_work(md->ap_handshake_wq, &md->ap_handshake_work);
>>>> +                               md->exp_id &= ~D2H_INT_ASYNC_AP_HK;
>>>> +                               iowrite32(D2H_INT_ASYNC_AP_HK, mhccif_base + REG_EP2RC_SW_INT_ACK);
>>>> +                               t7xx_mhccif_mask_set(md->t7xx_dev, D2H_INT_ASYNC_AP_HK);
>>>> +                       }
>>>>                   }
>>>>                   spin_unlock_irqrestore(&md->exp_lock, flags);
>>>>
>>>> @@ -576,6 +602,7 @@ void t7xx_md_event_notify(struct t7xx_modem *md, enum md_event_id evt_id)
>>>>
>>>>           case FSM_READY:
>>>>                   t7xx_mhccif_mask_set(md->t7xx_dev, D2H_INT_ASYNC_MD_HK);
>>>> +               t7xx_mhccif_mask_set(md->t7xx_dev, D2H_INT_ASYNC_AP_HK);
>>>>                   break;
>>>>
>>>>           default:
>>>> @@ -627,6 +654,19 @@ static struct t7xx_modem *t7xx_md_alloc(struct t7xx_pci_dev *t7xx_dev)
>>>>           md->core_md.feature_set[RT_ID_MD_PORT_ENUM] &= ~FEATURE_MSK;
>>>>           md->core_md.feature_set[RT_ID_MD_PORT_ENUM] |=
>>>>                   FIELD_PREP(FEATURE_MSK, MTK_FEATURE_MUST_BE_SUPPORTED);
>>>> +
>>>> +       md->ap_handshake_wq = alloc_workqueue("%s", WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_HIGHPRI,
>>>> +                                             0, "ap_hk_wq");
>>>> +       if (!md->ap_handshake_wq) {
>>>> +               destroy_workqueue(md->handshake_wq);
>>>> +               return NULL;
>>>> +       }
>>>> +
>>>> +       INIT_WORK(&md->ap_handshake_work, t7xx_ap_hk_wq);
>>>> +       md->core_ap.feature_set[RT_ID_AP_PORT_ENUM] &= ~FEATURE_MSK;
>>>> +       md->core_ap.feature_set[RT_ID_AP_PORT_ENUM] |=
>>>> +               FIELD_PREP(FEATURE_MSK, MTK_FEATURE_MUST_BE_SUPPORTED);
>>>> +
>>>>           return md;
>>>>    }
>>>>
>>>> @@ -638,6 +678,7 @@ int t7xx_md_reset(struct t7xx_pci_dev *t7xx_dev)
>>>>           md->exp_id = 0;
>>>>           t7xx_fsm_reset(md);
>>>>           t7xx_cldma_reset(md->md_ctrl[CLDMA_ID_MD]);
>>>> +       t7xx_cldma_reset(md->md_ctrl[CLDMA_ID_AP]);
>>>>           t7xx_port_proxy_reset(md->port_prox);
>>>>           md->md_init_finish = true;
>>>>           return t7xx_core_reset(md);
>>>> @@ -667,6 +708,10 @@ int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev)
>>>>           if (ret)
>>>>                   goto err_destroy_hswq;
>>>>
>>>> +       ret = t7xx_cldma_alloc(CLDMA_ID_AP, t7xx_dev);
>>>> +       if (ret)
>>>> +               goto err_destroy_hswq;
>>>> +
>>>>           ret = t7xx_fsm_init(md);
>>>>           if (ret)
>>>>                   goto err_destroy_hswq;
>>>> @@ -679,12 +724,16 @@ int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev)
>>>>           if (ret)
>>>>                   goto err_uninit_ccmni;
>>>>
>>>> -       ret = t7xx_port_proxy_init(md);
>>>> +       ret = t7xx_cldma_init(md->md_ctrl[CLDMA_ID_AP]);
>>>>           if (ret)
>>>>                   goto err_uninit_md_cldma;
>>>>
>>>> +       ret = t7xx_port_proxy_init(md);
>>>> +       if (ret)
>>>> +               goto err_uninit_ap_cldma;
>>>> +
>>>>           ret = t7xx_fsm_append_cmd(md->fsm_ctl, FSM_CMD_START, 0);
>>>> -       if (ret) /* fsm_uninit flushes cmd queue */
>>>> +       if (ret) /* t7xx_fsm_uninit() flushes cmd queue */
>>>>                   goto err_uninit_proxy;
>>>>
>>>>           t7xx_md_sys_sw_init(t7xx_dev);
>>>> @@ -694,6 +743,9 @@ int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev)
>>>>    err_uninit_proxy:
>>>>           t7xx_port_proxy_uninit(md->port_prox);
>>>>
>>>> +err_uninit_ap_cldma:
>>>> +       t7xx_cldma_exit(md->md_ctrl[CLDMA_ID_AP]);
>>>> +
>>>>    err_uninit_md_cldma:
>>>>           t7xx_cldma_exit(md->md_ctrl[CLDMA_ID_MD]);
>>>>
>>>> @@ -705,6 +757,7 @@ int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev)
>>>>
>>>>    err_destroy_hswq:
>>>>           destroy_workqueue(md->handshake_wq);
>>>> +       destroy_workqueue(md->ap_handshake_wq);
>>>>           dev_err(&t7xx_dev->pdev->dev, "Modem init failed\n");
>>>>           return ret;
>>>>    }
>>>> @@ -720,8 +773,10 @@ void t7xx_md_exit(struct t7xx_pci_dev *t7xx_dev)
>>>>
>>>>           t7xx_fsm_append_cmd(md->fsm_ctl, FSM_CMD_PRE_STOP, FSM_CMD_FLAG_WAIT_FOR_COMPLETION);
>>>>           t7xx_port_proxy_uninit(md->port_prox);
>>>> +       t7xx_cldma_exit(md->md_ctrl[CLDMA_ID_AP]);
>>>>           t7xx_cldma_exit(md->md_ctrl[CLDMA_ID_MD]);
>>>>           t7xx_ccmni_exit(t7xx_dev);
>>>>           t7xx_fsm_uninit(md);
>>>>           destroy_workqueue(md->handshake_wq);
>>>> +       destroy_workqueue(md->ap_handshake_wq);
>>>>    }
>>>> diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.h b/drivers/net/wwan/t7xx/t7xx_modem_ops.h
>>>> index 7469ed636ae8..c93e870ce696 100644
>>>> --- a/drivers/net/wwan/t7xx/t7xx_modem_ops.h
>>>> +++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.h
>>>> @@ -66,10 +66,13 @@ struct t7xx_modem {
>>>>           struct cldma_ctrl               *md_ctrl[CLDMA_NUM];
>>>>           struct t7xx_pci_dev             *t7xx_dev;
>>>>           struct t7xx_sys_info            core_md;
>>>> +       struct t7xx_sys_info            core_ap;
>>>>           bool                            md_init_finish;
>>>>           bool                            rgu_irq_asserted;
>>>>           struct workqueue_struct         *handshake_wq;
>>>>           struct work_struct              handshake_work;
>>>> +       struct workqueue_struct         *ap_handshake_wq;
>>>
>>> Does the driver really need this dedicated workqueue for the AP
>>> handshake? Or can the existing handshake workqueue be reused for the
>>> AP handshake work scheduling too?
>>
>> It should be possible to reuse the existing handshake workqueue.
>> modified workqueue might look as below [1]. We could reuse the
>> md->exp_id inside the workqueue to decide MD or AP handshake flow.
>>
>> [1]
>> static void t7xx_hk_wq(struct work_struct *work)
>> {`
>>          struct t7xx_modem *md = container_of(work, struct t7xx_modem,
>> handshake_work);
>>          struct t7xx_fsm_ctl *ctl = md->fsm_ctl;
>>
>>          if (md->exp_id & D2H_INT_ASYNC_MD_HK) {
>>                  //modem handshake
>>                  ..
>>                  md->exp_id &= ~D2H_INT_ASYNC_MD_HK;
>>          }
>>
>>          if (md->exp_id & D2H_INT_ASYNC_AP_HK) {
>>                  //AP handshake
>>                  ..
>>                  md->exp_id &= ~D2H_INT_ASYNC_AP_HK;
>>          }
>> }
> 
> I did not mean reuse the _work_, I meant reuse the _workqueue_. Just replace
> 
> queue_work(md->ap_handshake_wq, &md->ap_handshake_work);
> 
> by
> 
> queue_work(md->handshake_wq, &md->ap_handshake_work);
> 
> to avoid creating ap_handshake_wq and simplify the driver
> initialization. Does it make sense?

Sorry i misinterpreted it and thanks for correcting.
I will do the necessary changes.

-- 
Chetan
