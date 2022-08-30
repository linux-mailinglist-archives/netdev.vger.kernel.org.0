Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9870C5A590B
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 03:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiH3ByG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 21:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiH3ByF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 21:54:05 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D95A61DE
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 18:54:03 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id h78so8111471iof.13
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 18:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=giWg1eZeTWVm1xz0eBs4adiD8yJeMhnzZPNJy1zbU10=;
        b=Yk8F4ZBPHlcuv5KnXsHUlXVSaftvlpk710B7Qt/PlK4UG1au/2j6BvLT9SOE+eBl/I
         g2MJadgtktnvTqYozBiAZtThHDMY2Fnv76CJjAoSDxiypYkrLZCNPKt/wv9+dYXZG0qd
         0qywWzucEif7T5FFGqr65094N8TfhdBrXocvz/Z9rzL32HCkDcdNPLiyPRUPl4Q2GlxB
         6qAnyEQbRkAVQmcnC+64MNuk6FlAoJBuNMJqOLOjKnhIObRLYjkAK+jaUwaTfmtTW3Up
         pnmTAAeHG3RsgdKHzpXqdLIjX25kEvl0t3CsHhncx32RGJAZdmpab7lDow6TphO/sFHu
         3N8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=giWg1eZeTWVm1xz0eBs4adiD8yJeMhnzZPNJy1zbU10=;
        b=sdRSzh9GspZekspKQlg9vCT3o8szBVIClvMfxHjESfYnx2Cve27zAM7j2k7ct57JPn
         CGdCKHJ6Wn4bci4HISqamKcuIwfWwWguwKtqZaB5Ga0lAgFf+NP2igz7picYwvDokYjX
         dab1hXMraFKcmzzS178Oa0Ad4QCmRxMoAkj8U+vtttFxVH9kLH+RDSWSG8pMYzz1SBMD
         L9L6cuzGAFfGaQOozuIokHpcYsMrWGtq6mn/69/7C/dCRltOGfZBRtr4JEarFpbThqW8
         7gEBd9w/0icDXclyrsFFW+yUYpbvklcmjL0TvWqXl/coY+pV1dgpWtQt/qs2ROJ9DOC1
         jjxQ==
X-Gm-Message-State: ACgBeo00i5eOoTVhGiObFyJzsqwkuVTXvqF+42+whY2/sD2bSi+nGpkP
        BMr/wjtMHzGMDGNR7RxoxjBjQITkLqBaHT1S/JQItKTs
X-Google-Smtp-Source: AA6agR7IncUNJQneFlnkFswPwL7yGFnVKp6qhNUm84jfX6zlL6rVfpd4GgI8AzafHNWp6DeVkbBdyvVSHtN/wvjN2Fo=
X-Received: by 2002:a02:a711:0:b0:349:db96:7708 with SMTP id
 k17-20020a02a711000000b00349db967708mr11811254jam.36.1661824443125; Mon, 29
 Aug 2022 18:54:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220816042328.2416926-1-m.chetan.kumar@intel.com>
In-Reply-To: <20220816042328.2416926-1-m.chetan.kumar@intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 30 Aug 2022 04:53:07 +0300
Message-ID: <CAHNKnsSUp=E0VMf8sjFoG7uoxdW_O_Lwu57NOiPj1it-mYZnNQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] net: wwan: t7xx: Add AP CLDMA
To:     M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Haijun Liu <haijun.liu@mediatek.com>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>,
        Moises Veleta <moises.veleta@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>,
        =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 7:11 AM <m.chetan.kumar@intel.com> wrote:
> From: Haijun Liu <haijun.liu@mediatek.com>
>
> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
> communicate with AP and Modem processors respectively. So far only
> MD-CLDMA was being used, this patch enables AP-CLDMA.
>
> Rename small Application Processor (sAP) to AP.
>
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
> Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>
> Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com=
>
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>

And just one nitpick/question below.

> diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.c b/drivers/net/wwan/t7=
xx/t7xx_modem_ops.c
> index 3458af31e864..c5a3c95004bd 100644
> --- a/drivers/net/wwan/t7xx/t7xx_modem_ops.c
> +++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
> @@ -44,6 +44,7 @@
>  #include "t7xx_state_monitor.h"
>
>  #define RT_ID_MD_PORT_ENUM     0
> +#define RT_ID_AP_PORT_ENUM     1
>  /* Modem feature query identification code - "ICCC" */
>  #define MD_FEATURE_QUERY_ID    0x49434343
>
> @@ -296,6 +297,7 @@ static void t7xx_md_exception(struct t7xx_modem *md, =
enum hif_ex_stage stage)
>         }
>
>         t7xx_cldma_exception(md->md_ctrl[CLDMA_ID_MD], stage);
> +       t7xx_cldma_exception(md->md_ctrl[CLDMA_ID_AP], stage);
>
>         if (stage =3D=3D HIF_EX_INIT)
>                 t7xx_mhccif_h2d_swint_trigger(t7xx_dev, H2D_CH_EXCEPTION_=
ACK);
> @@ -424,7 +426,7 @@ static int t7xx_parse_host_rt_data(struct t7xx_fsm_ct=
l *ctl, struct t7xx_sys_inf
>                 if (ft_spt_st !=3D MTK_FEATURE_MUST_BE_SUPPORTED)
>                         return -EINVAL;
>
> -               if (i =3D=3D RT_ID_MD_PORT_ENUM)
> +               if (i =3D=3D RT_ID_MD_PORT_ENUM || i =3D=3D RT_ID_AP_PORT=
_ENUM)
>                         t7xx_port_enum_msg_handler(ctl->md, rt_feature->d=
ata);
>         }
>
> @@ -454,12 +456,12 @@ static int t7xx_core_reset(struct t7xx_modem *md)
>         return 0;
>  }
>
> -static void t7xx_core_hk_handler(struct t7xx_modem *md, struct t7xx_fsm_=
ctl *ctl,
> +static void t7xx_core_hk_handler(struct t7xx_modem *md, struct t7xx_sys_=
info *core_info,
> +                                struct t7xx_fsm_ctl *ctl,
>                                  enum t7xx_fsm_event_state event_id,
>                                  enum t7xx_fsm_event_state err_detect)
>  {
>         struct t7xx_fsm_event *event =3D NULL, *event_next;
> -       struct t7xx_sys_info *core_info =3D &md->core_md;
>         struct device *dev =3D &md->t7xx_dev->pdev->dev;
>         unsigned long flags;
>         int ret;
> @@ -529,19 +531,33 @@ static void t7xx_md_hk_wq(struct work_struct *work)
>         t7xx_cldma_start(md->md_ctrl[CLDMA_ID_MD]);
>         t7xx_fsm_broadcast_state(ctl, MD_STATE_WAITING_FOR_HS2);
>         md->core_md.handshake_ongoing =3D true;
> -       t7xx_core_hk_handler(md, ctl, FSM_EVENT_MD_HS2, FSM_EVENT_MD_HS2_=
EXIT);
> +       t7xx_core_hk_handler(md, &md->core_md, ctl, FSM_EVENT_MD_HS2, FSM=
_EVENT_MD_HS2_EXIT);
> +}
> +
> +static void t7xx_ap_hk_wq(struct work_struct *work)
> +{
> +       struct t7xx_modem *md =3D container_of(work, struct t7xx_modem, a=
p_handshake_work);
> +       struct t7xx_fsm_ctl *ctl =3D md->fsm_ctl;
> +
> +        /* Clear the HS2 EXIT event appended in t7xx_core_reset(). */
> +       t7xx_fsm_clr_event(ctl, FSM_EVENT_AP_HS2_EXIT);
> +       t7xx_cldma_stop(md->md_ctrl[CLDMA_ID_AP]);
> +       t7xx_cldma_switch_cfg(md->md_ctrl[CLDMA_ID_AP]);
> +       t7xx_cldma_start(md->md_ctrl[CLDMA_ID_AP]);
> +       md->core_ap.handshake_ongoing =3D true;
> +       t7xx_core_hk_handler(md, &md->core_ap, ctl, FSM_EVENT_AP_HS2, FSM=
_EVENT_AP_HS2_EXIT);
>  }
>
>  void t7xx_md_event_notify(struct t7xx_modem *md, enum md_event_id evt_id=
)
>  {
>         struct t7xx_fsm_ctl *ctl =3D md->fsm_ctl;
> -       void __iomem *mhccif_base;
>         unsigned int int_sta;
>         unsigned long flags;
>
>         switch (evt_id) {
>         case FSM_PRE_START:
> -               t7xx_mhccif_mask_clr(md->t7xx_dev, D2H_INT_PORT_ENUM);
> +               t7xx_mhccif_mask_clr(md->t7xx_dev, D2H_INT_PORT_ENUM | D2=
H_INT_ASYNC_MD_HK |
> +                                                  D2H_INT_ASYNC_AP_HK);
>                 break;
>
>         case FSM_START:
> @@ -554,16 +570,26 @@ void t7xx_md_event_notify(struct t7xx_modem *md, en=
um md_event_id evt_id)
>                         ctl->exp_flg =3D true;
>                         md->exp_id &=3D ~D2H_INT_EXCEPTION_INIT;
>                         md->exp_id &=3D ~D2H_INT_ASYNC_MD_HK;
> +                       md->exp_id &=3D ~D2H_INT_ASYNC_AP_HK;
>                 } else if (ctl->exp_flg) {
>                         md->exp_id &=3D ~D2H_INT_ASYNC_MD_HK;
> -               } else if (md->exp_id & D2H_INT_ASYNC_MD_HK) {
> -                       queue_work(md->handshake_wq, &md->handshake_work)=
;
> -                       md->exp_id &=3D ~D2H_INT_ASYNC_MD_HK;
> -                       mhccif_base =3D md->t7xx_dev->base_addr.mhccif_rc=
_base;
> -                       iowrite32(D2H_INT_ASYNC_MD_HK, mhccif_base + REG_=
EP2RC_SW_INT_ACK);
> -                       t7xx_mhccif_mask_set(md->t7xx_dev, D2H_INT_ASYNC_=
MD_HK);
> +                       md->exp_id &=3D ~D2H_INT_ASYNC_AP_HK;
>                 } else {
> -                       t7xx_mhccif_mask_clr(md->t7xx_dev, D2H_INT_ASYNC_=
MD_HK);
> +                       void __iomem *mhccif_base =3D md->t7xx_dev->base_=
addr.mhccif_rc_base;
> +
> +                       if (md->exp_id & D2H_INT_ASYNC_MD_HK) {
> +                               queue_work(md->handshake_wq, &md->handsha=
ke_work);
> +                               md->exp_id &=3D ~D2H_INT_ASYNC_MD_HK;
> +                               iowrite32(D2H_INT_ASYNC_MD_HK, mhccif_bas=
e + REG_EP2RC_SW_INT_ACK);
> +                               t7xx_mhccif_mask_set(md->t7xx_dev, D2H_IN=
T_ASYNC_MD_HK);
> +                       }
> +
> +                       if (md->exp_id & D2H_INT_ASYNC_AP_HK) {
> +                               queue_work(md->ap_handshake_wq, &md->ap_h=
andshake_work);
> +                               md->exp_id &=3D ~D2H_INT_ASYNC_AP_HK;
> +                               iowrite32(D2H_INT_ASYNC_AP_HK, mhccif_bas=
e + REG_EP2RC_SW_INT_ACK);
> +                               t7xx_mhccif_mask_set(md->t7xx_dev, D2H_IN=
T_ASYNC_AP_HK);
> +                       }
>                 }
>                 spin_unlock_irqrestore(&md->exp_lock, flags);
>
> @@ -576,6 +602,7 @@ void t7xx_md_event_notify(struct t7xx_modem *md, enum=
 md_event_id evt_id)
>
>         case FSM_READY:
>                 t7xx_mhccif_mask_set(md->t7xx_dev, D2H_INT_ASYNC_MD_HK);
> +               t7xx_mhccif_mask_set(md->t7xx_dev, D2H_INT_ASYNC_AP_HK);
>                 break;
>
>         default:
> @@ -627,6 +654,19 @@ static struct t7xx_modem *t7xx_md_alloc(struct t7xx_=
pci_dev *t7xx_dev)
>         md->core_md.feature_set[RT_ID_MD_PORT_ENUM] &=3D ~FEATURE_MSK;
>         md->core_md.feature_set[RT_ID_MD_PORT_ENUM] |=3D
>                 FIELD_PREP(FEATURE_MSK, MTK_FEATURE_MUST_BE_SUPPORTED);
> +
> +       md->ap_handshake_wq =3D alloc_workqueue("%s", WQ_UNBOUND | WQ_MEM=
_RECLAIM | WQ_HIGHPRI,
> +                                             0, "ap_hk_wq");
> +       if (!md->ap_handshake_wq) {
> +               destroy_workqueue(md->handshake_wq);
> +               return NULL;
> +       }
> +
> +       INIT_WORK(&md->ap_handshake_work, t7xx_ap_hk_wq);
> +       md->core_ap.feature_set[RT_ID_AP_PORT_ENUM] &=3D ~FEATURE_MSK;
> +       md->core_ap.feature_set[RT_ID_AP_PORT_ENUM] |=3D
> +               FIELD_PREP(FEATURE_MSK, MTK_FEATURE_MUST_BE_SUPPORTED);
> +
>         return md;
>  }
>
> @@ -638,6 +678,7 @@ int t7xx_md_reset(struct t7xx_pci_dev *t7xx_dev)
>         md->exp_id =3D 0;
>         t7xx_fsm_reset(md);
>         t7xx_cldma_reset(md->md_ctrl[CLDMA_ID_MD]);
> +       t7xx_cldma_reset(md->md_ctrl[CLDMA_ID_AP]);
>         t7xx_port_proxy_reset(md->port_prox);
>         md->md_init_finish =3D true;
>         return t7xx_core_reset(md);
> @@ -667,6 +708,10 @@ int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev)
>         if (ret)
>                 goto err_destroy_hswq;
>
> +       ret =3D t7xx_cldma_alloc(CLDMA_ID_AP, t7xx_dev);
> +       if (ret)
> +               goto err_destroy_hswq;
> +
>         ret =3D t7xx_fsm_init(md);
>         if (ret)
>                 goto err_destroy_hswq;
> @@ -679,12 +724,16 @@ int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev)
>         if (ret)
>                 goto err_uninit_ccmni;
>
> -       ret =3D t7xx_port_proxy_init(md);
> +       ret =3D t7xx_cldma_init(md->md_ctrl[CLDMA_ID_AP]);
>         if (ret)
>                 goto err_uninit_md_cldma;
>
> +       ret =3D t7xx_port_proxy_init(md);
> +       if (ret)
> +               goto err_uninit_ap_cldma;
> +
>         ret =3D t7xx_fsm_append_cmd(md->fsm_ctl, FSM_CMD_START, 0);
> -       if (ret) /* fsm_uninit flushes cmd queue */
> +       if (ret) /* t7xx_fsm_uninit() flushes cmd queue */
>                 goto err_uninit_proxy;
>
>         t7xx_md_sys_sw_init(t7xx_dev);
> @@ -694,6 +743,9 @@ int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev)
>  err_uninit_proxy:
>         t7xx_port_proxy_uninit(md->port_prox);
>
> +err_uninit_ap_cldma:
> +       t7xx_cldma_exit(md->md_ctrl[CLDMA_ID_AP]);
> +
>  err_uninit_md_cldma:
>         t7xx_cldma_exit(md->md_ctrl[CLDMA_ID_MD]);
>
> @@ -705,6 +757,7 @@ int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev)
>
>  err_destroy_hswq:
>         destroy_workqueue(md->handshake_wq);
> +       destroy_workqueue(md->ap_handshake_wq);
>         dev_err(&t7xx_dev->pdev->dev, "Modem init failed\n");
>         return ret;
>  }
> @@ -720,8 +773,10 @@ void t7xx_md_exit(struct t7xx_pci_dev *t7xx_dev)
>
>         t7xx_fsm_append_cmd(md->fsm_ctl, FSM_CMD_PRE_STOP, FSM_CMD_FLAG_W=
AIT_FOR_COMPLETION);
>         t7xx_port_proxy_uninit(md->port_prox);
> +       t7xx_cldma_exit(md->md_ctrl[CLDMA_ID_AP]);
>         t7xx_cldma_exit(md->md_ctrl[CLDMA_ID_MD]);
>         t7xx_ccmni_exit(t7xx_dev);
>         t7xx_fsm_uninit(md);
>         destroy_workqueue(md->handshake_wq);
> +       destroy_workqueue(md->ap_handshake_wq);
>  }
> diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.h b/drivers/net/wwan/t7=
xx/t7xx_modem_ops.h
> index 7469ed636ae8..c93e870ce696 100644
> --- a/drivers/net/wwan/t7xx/t7xx_modem_ops.h
> +++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.h
> @@ -66,10 +66,13 @@ struct t7xx_modem {
>         struct cldma_ctrl               *md_ctrl[CLDMA_NUM];
>         struct t7xx_pci_dev             *t7xx_dev;
>         struct t7xx_sys_info            core_md;
> +       struct t7xx_sys_info            core_ap;
>         bool                            md_init_finish;
>         bool                            rgu_irq_asserted;
>         struct workqueue_struct         *handshake_wq;
>         struct work_struct              handshake_work;
> +       struct workqueue_struct         *ap_handshake_wq;

Does the driver really need this dedicated workqueue for the AP
handshake? Or can the existing handshake workqueue be reused for the
AP handshake work scheduling too?

> +       struct work_struct              ap_handshake_work;
>         struct t7xx_fsm_ctl             *fsm_ctl;
>         struct port_proxy               *port_prox;
>         unsigned int                    exp_id;

--
Sergey
