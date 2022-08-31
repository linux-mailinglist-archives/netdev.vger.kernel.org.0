Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76DE5A7DCB
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 14:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbiHaMq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 08:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbiHaMqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 08:46:22 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15B98A6E2
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 05:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661949980; x=1693485980;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=Y7Cfz/6w9MvoNguxp2CzNpFupv3K4PMaoltdML5r66c=;
  b=MnJSh8d8B3Mv0vAyT93o2ehfVI4fRj5Gdf4wfU26qpHKxu2ezuXFDE0b
   mJgVDISie//TezL8mtSBASk+oAtCfHi1DWI2HSTs0CoDzolY/6rPRJw6b
   zres0pZgK5Elext67i3ZUv68R6RATIVMuk8KM2sGR1410ZvTl/i2krgl2
   MtxON2eAUrRYj9kTK+VnLe/WmT+nbiO25A718Ge7SJ0+WRnYHRgW1W5/2
   eNDCJWvPfogji5uuCiMbLRrZU94HjK4Xqw0P6gqEHB0YgCgoin/cihBTP
   qJfBvRSubFbMtWbcx9263n3v31nXDJ/yGPjvlVa90yIUos/A0oCkqoEQA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="381733808"
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="381733808"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 05:46:20 -0700
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="940423093"
Received: from mckumar-mobl2.gar.corp.intel.com (HELO [10.215.122.26]) ([10.215.122.26])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 05:46:17 -0700
Message-ID: <aed8af81-852c-1e75-b522-76e52ca12a39@linux.intel.com>
Date:   Wed, 31 Aug 2022 18:16:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
Subject: Re: [PATCH net-next 1/5] net: wwan: t7xx: Add AP CLDMA
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
Content-Language: en-US
In-Reply-To: <CAHNKnsSUp=E0VMf8sjFoG7uoxdW_O_Lwu57NOiPj1it-mYZnNQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/2022 7:23 AM, Sergey Ryazanov wrote:
> On Tue, Aug 16, 2022 at 7:11 AM <m.chetan.kumar@intel.com> wrote:
>> From: Haijun Liu <haijun.liu@mediatek.com>
>>
>> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
>> communicate with AP and Modem processors respectively. So far only
>> MD-CLDMA was being used, this patch enables AP-CLDMA.
>>
>> Rename small Application Processor (sAP) to AP.
>>
>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>> Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>
>> Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
>> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>> Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> 
> Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> 
> And just one nitpick/question below.
> 
>> diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.c b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
>> index 3458af31e864..c5a3c95004bd 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_modem_ops.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
>> @@ -44,6 +44,7 @@
>>   #include "t7xx_state_monitor.h"
>>
>>   #define RT_ID_MD_PORT_ENUM     0
>> +#define RT_ID_AP_PORT_ENUM     1
>>   /* Modem feature query identification code - "ICCC" */
>>   #define MD_FEATURE_QUERY_ID    0x49434343
>>
>> @@ -296,6 +297,7 @@ static void t7xx_md_exception(struct t7xx_modem *md, enum hif_ex_stage stage)
>>          }
>>
>>          t7xx_cldma_exception(md->md_ctrl[CLDMA_ID_MD], stage);
>> +       t7xx_cldma_exception(md->md_ctrl[CLDMA_ID_AP], stage);
>>
>>          if (stage == HIF_EX_INIT)
>>                  t7xx_mhccif_h2d_swint_trigger(t7xx_dev, H2D_CH_EXCEPTION_ACK);
>> @@ -424,7 +426,7 @@ static int t7xx_parse_host_rt_data(struct t7xx_fsm_ctl *ctl, struct t7xx_sys_inf
>>                  if (ft_spt_st != MTK_FEATURE_MUST_BE_SUPPORTED)
>>                          return -EINVAL;
>>
>> -               if (i == RT_ID_MD_PORT_ENUM)
>> +               if (i == RT_ID_MD_PORT_ENUM || i == RT_ID_AP_PORT_ENUM)
>>                          t7xx_port_enum_msg_handler(ctl->md, rt_feature->data);
>>          }
>>
>> @@ -454,12 +456,12 @@ static int t7xx_core_reset(struct t7xx_modem *md)
>>          return 0;
>>   }
>>
>> -static void t7xx_core_hk_handler(struct t7xx_modem *md, struct t7xx_fsm_ctl *ctl,
>> +static void t7xx_core_hk_handler(struct t7xx_modem *md, struct t7xx_sys_info *core_info,
>> +                                struct t7xx_fsm_ctl *ctl,
>>                                   enum t7xx_fsm_event_state event_id,
>>                                   enum t7xx_fsm_event_state err_detect)
>>   {
>>          struct t7xx_fsm_event *event = NULL, *event_next;
>> -       struct t7xx_sys_info *core_info = &md->core_md;
>>          struct device *dev = &md->t7xx_dev->pdev->dev;
>>          unsigned long flags;
>>          int ret;
>> @@ -529,19 +531,33 @@ static void t7xx_md_hk_wq(struct work_struct *work)
>>          t7xx_cldma_start(md->md_ctrl[CLDMA_ID_MD]);
>>          t7xx_fsm_broadcast_state(ctl, MD_STATE_WAITING_FOR_HS2);
>>          md->core_md.handshake_ongoing = true;
>> -       t7xx_core_hk_handler(md, ctl, FSM_EVENT_MD_HS2, FSM_EVENT_MD_HS2_EXIT);
>> +       t7xx_core_hk_handler(md, &md->core_md, ctl, FSM_EVENT_MD_HS2, FSM_EVENT_MD_HS2_EXIT);
>> +}
>> +
>> +static void t7xx_ap_hk_wq(struct work_struct *work)
>> +{
>> +       struct t7xx_modem *md = container_of(work, struct t7xx_modem, ap_handshake_work);
>> +       struct t7xx_fsm_ctl *ctl = md->fsm_ctl;
>> +
>> +        /* Clear the HS2 EXIT event appended in t7xx_core_reset(). */
>> +       t7xx_fsm_clr_event(ctl, FSM_EVENT_AP_HS2_EXIT);
>> +       t7xx_cldma_stop(md->md_ctrl[CLDMA_ID_AP]);
>> +       t7xx_cldma_switch_cfg(md->md_ctrl[CLDMA_ID_AP]);
>> +       t7xx_cldma_start(md->md_ctrl[CLDMA_ID_AP]);
>> +       md->core_ap.handshake_ongoing = true;
>> +       t7xx_core_hk_handler(md, &md->core_ap, ctl, FSM_EVENT_AP_HS2, FSM_EVENT_AP_HS2_EXIT);
>>   }
>>
>>   void t7xx_md_event_notify(struct t7xx_modem *md, enum md_event_id evt_id)
>>   {
>>          struct t7xx_fsm_ctl *ctl = md->fsm_ctl;
>> -       void __iomem *mhccif_base;
>>          unsigned int int_sta;
>>          unsigned long flags;
>>
>>          switch (evt_id) {
>>          case FSM_PRE_START:
>> -               t7xx_mhccif_mask_clr(md->t7xx_dev, D2H_INT_PORT_ENUM);
>> +               t7xx_mhccif_mask_clr(md->t7xx_dev, D2H_INT_PORT_ENUM | D2H_INT_ASYNC_MD_HK |
>> +                                                  D2H_INT_ASYNC_AP_HK);
>>                  break;
>>
>>          case FSM_START:
>> @@ -554,16 +570,26 @@ void t7xx_md_event_notify(struct t7xx_modem *md, enum md_event_id evt_id)
>>                          ctl->exp_flg = true;
>>                          md->exp_id &= ~D2H_INT_EXCEPTION_INIT;
>>                          md->exp_id &= ~D2H_INT_ASYNC_MD_HK;
>> +                       md->exp_id &= ~D2H_INT_ASYNC_AP_HK;
>>                  } else if (ctl->exp_flg) {
>>                          md->exp_id &= ~D2H_INT_ASYNC_MD_HK;
>> -               } else if (md->exp_id & D2H_INT_ASYNC_MD_HK) {
>> -                       queue_work(md->handshake_wq, &md->handshake_work);
>> -                       md->exp_id &= ~D2H_INT_ASYNC_MD_HK;
>> -                       mhccif_base = md->t7xx_dev->base_addr.mhccif_rc_base;
>> -                       iowrite32(D2H_INT_ASYNC_MD_HK, mhccif_base + REG_EP2RC_SW_INT_ACK);
>> -                       t7xx_mhccif_mask_set(md->t7xx_dev, D2H_INT_ASYNC_MD_HK);
>> +                       md->exp_id &= ~D2H_INT_ASYNC_AP_HK;
>>                  } else {
>> -                       t7xx_mhccif_mask_clr(md->t7xx_dev, D2H_INT_ASYNC_MD_HK);
>> +                       void __iomem *mhccif_base = md->t7xx_dev->base_addr.mhccif_rc_base;
>> +
>> +                       if (md->exp_id & D2H_INT_ASYNC_MD_HK) {
>> +                               queue_work(md->handshake_wq, &md->handshake_work);
>> +                               md->exp_id &= ~D2H_INT_ASYNC_MD_HK;
>> +                               iowrite32(D2H_INT_ASYNC_MD_HK, mhccif_base + REG_EP2RC_SW_INT_ACK);
>> +                               t7xx_mhccif_mask_set(md->t7xx_dev, D2H_INT_ASYNC_MD_HK);
>> +                       }
>> +
>> +                       if (md->exp_id & D2H_INT_ASYNC_AP_HK) {
>> +                               queue_work(md->ap_handshake_wq, &md->ap_handshake_work);
>> +                               md->exp_id &= ~D2H_INT_ASYNC_AP_HK;
>> +                               iowrite32(D2H_INT_ASYNC_AP_HK, mhccif_base + REG_EP2RC_SW_INT_ACK);
>> +                               t7xx_mhccif_mask_set(md->t7xx_dev, D2H_INT_ASYNC_AP_HK);
>> +                       }
>>                  }
>>                  spin_unlock_irqrestore(&md->exp_lock, flags);
>>
>> @@ -576,6 +602,7 @@ void t7xx_md_event_notify(struct t7xx_modem *md, enum md_event_id evt_id)
>>
>>          case FSM_READY:
>>                  t7xx_mhccif_mask_set(md->t7xx_dev, D2H_INT_ASYNC_MD_HK);
>> +               t7xx_mhccif_mask_set(md->t7xx_dev, D2H_INT_ASYNC_AP_HK);
>>                  break;
>>
>>          default:
>> @@ -627,6 +654,19 @@ static struct t7xx_modem *t7xx_md_alloc(struct t7xx_pci_dev *t7xx_dev)
>>          md->core_md.feature_set[RT_ID_MD_PORT_ENUM] &= ~FEATURE_MSK;
>>          md->core_md.feature_set[RT_ID_MD_PORT_ENUM] |=
>>                  FIELD_PREP(FEATURE_MSK, MTK_FEATURE_MUST_BE_SUPPORTED);
>> +
>> +       md->ap_handshake_wq = alloc_workqueue("%s", WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_HIGHPRI,
>> +                                             0, "ap_hk_wq");
>> +       if (!md->ap_handshake_wq) {
>> +               destroy_workqueue(md->handshake_wq);
>> +               return NULL;
>> +       }
>> +
>> +       INIT_WORK(&md->ap_handshake_work, t7xx_ap_hk_wq);
>> +       md->core_ap.feature_set[RT_ID_AP_PORT_ENUM] &= ~FEATURE_MSK;
>> +       md->core_ap.feature_set[RT_ID_AP_PORT_ENUM] |=
>> +               FIELD_PREP(FEATURE_MSK, MTK_FEATURE_MUST_BE_SUPPORTED);
>> +
>>          return md;
>>   }
>>
>> @@ -638,6 +678,7 @@ int t7xx_md_reset(struct t7xx_pci_dev *t7xx_dev)
>>          md->exp_id = 0;
>>          t7xx_fsm_reset(md);
>>          t7xx_cldma_reset(md->md_ctrl[CLDMA_ID_MD]);
>> +       t7xx_cldma_reset(md->md_ctrl[CLDMA_ID_AP]);
>>          t7xx_port_proxy_reset(md->port_prox);
>>          md->md_init_finish = true;
>>          return t7xx_core_reset(md);
>> @@ -667,6 +708,10 @@ int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev)
>>          if (ret)
>>                  goto err_destroy_hswq;
>>
>> +       ret = t7xx_cldma_alloc(CLDMA_ID_AP, t7xx_dev);
>> +       if (ret)
>> +               goto err_destroy_hswq;
>> +
>>          ret = t7xx_fsm_init(md);
>>          if (ret)
>>                  goto err_destroy_hswq;
>> @@ -679,12 +724,16 @@ int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev)
>>          if (ret)
>>                  goto err_uninit_ccmni;
>>
>> -       ret = t7xx_port_proxy_init(md);
>> +       ret = t7xx_cldma_init(md->md_ctrl[CLDMA_ID_AP]);
>>          if (ret)
>>                  goto err_uninit_md_cldma;
>>
>> +       ret = t7xx_port_proxy_init(md);
>> +       if (ret)
>> +               goto err_uninit_ap_cldma;
>> +
>>          ret = t7xx_fsm_append_cmd(md->fsm_ctl, FSM_CMD_START, 0);
>> -       if (ret) /* fsm_uninit flushes cmd queue */
>> +       if (ret) /* t7xx_fsm_uninit() flushes cmd queue */
>>                  goto err_uninit_proxy;
>>
>>          t7xx_md_sys_sw_init(t7xx_dev);
>> @@ -694,6 +743,9 @@ int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev)
>>   err_uninit_proxy:
>>          t7xx_port_proxy_uninit(md->port_prox);
>>
>> +err_uninit_ap_cldma:
>> +       t7xx_cldma_exit(md->md_ctrl[CLDMA_ID_AP]);
>> +
>>   err_uninit_md_cldma:
>>          t7xx_cldma_exit(md->md_ctrl[CLDMA_ID_MD]);
>>
>> @@ -705,6 +757,7 @@ int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev)
>>
>>   err_destroy_hswq:
>>          destroy_workqueue(md->handshake_wq);
>> +       destroy_workqueue(md->ap_handshake_wq);
>>          dev_err(&t7xx_dev->pdev->dev, "Modem init failed\n");
>>          return ret;
>>   }
>> @@ -720,8 +773,10 @@ void t7xx_md_exit(struct t7xx_pci_dev *t7xx_dev)
>>
>>          t7xx_fsm_append_cmd(md->fsm_ctl, FSM_CMD_PRE_STOP, FSM_CMD_FLAG_WAIT_FOR_COMPLETION);
>>          t7xx_port_proxy_uninit(md->port_prox);
>> +       t7xx_cldma_exit(md->md_ctrl[CLDMA_ID_AP]);
>>          t7xx_cldma_exit(md->md_ctrl[CLDMA_ID_MD]);
>>          t7xx_ccmni_exit(t7xx_dev);
>>          t7xx_fsm_uninit(md);
>>          destroy_workqueue(md->handshake_wq);
>> +       destroy_workqueue(md->ap_handshake_wq);
>>   }
>> diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.h b/drivers/net/wwan/t7xx/t7xx_modem_ops.h
>> index 7469ed636ae8..c93e870ce696 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_modem_ops.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.h
>> @@ -66,10 +66,13 @@ struct t7xx_modem {
>>          struct cldma_ctrl               *md_ctrl[CLDMA_NUM];
>>          struct t7xx_pci_dev             *t7xx_dev;
>>          struct t7xx_sys_info            core_md;
>> +       struct t7xx_sys_info            core_ap;
>>          bool                            md_init_finish;
>>          bool                            rgu_irq_asserted;
>>          struct workqueue_struct         *handshake_wq;
>>          struct work_struct              handshake_work;
>> +       struct workqueue_struct         *ap_handshake_wq;
> 
> Does the driver really need this dedicated workqueue for the AP
> handshake? Or can the existing handshake workqueue be reused for the
> AP handshake work scheduling too?

It should be possible to reuse the existing handshake workqueue.
modified workqueue might look as below [1]. We could reuse the 
md->exp_id inside the workqueue to decide MD or AP handshake flow.

[1]
static void t7xx_hk_wq(struct work_struct *work)
{`
	struct t7xx_modem *md = container_of(work, struct t7xx_modem, 
handshake_work);
	struct t7xx_fsm_ctl *ctl = md->fsm_ctl;

	if (md->exp_id & D2H_INT_ASYNC_MD_HK) {
		//modem handshake
		..
		md->exp_id &= ~D2H_INT_ASYNC_MD_HK;
	}

	if (md->exp_id & D2H_INT_ASYNC_AP_HK) {
		//AP handshake
		..
		md->exp_id &= ~D2H_INT_ASYNC_AP_HK;
	}	
}

-- 
Chetan
