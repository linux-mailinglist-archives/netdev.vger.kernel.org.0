Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C415B5A81
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 14:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiILMxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 08:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiILMxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 08:53:45 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A64D3869B
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 05:53:44 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q3so7957396pjg.3
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 05:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=IlU4AFqnsLfpYO4evoBZQELw51u7fmxRFk82xPBXPmk=;
        b=rig9h6Vdhh9zJqwwXoJHJTRmYOX6DgREDxkX3JCnmKtSj6O097zUvgsFDdMX+YNLK7
         6ERBIrGnqmIr98q2aVvtKpll0KP8XUrSL96zg5Mn9DPPmDyNURa+wXJ6rONCeWRSbXpG
         2B1/eWNZkyjbgPdL4M7QanzpEFhtOoRkhVpek7IecVVd0OpZ5ltpVaxC1Pe6Qqt8y2tW
         8ZGMdP+X93fDBWGbCyJJhnWdwKXkuwe7ApEXmqV8q5AC4CTwcttmPeo8DE99VHVvFtTe
         4+d8r2OvafjBF5Y2FA+cCNT7kA463KwEo4iE12JTkF1jUs+/pW5zFKaWoahyrkOiGROj
         MBsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=IlU4AFqnsLfpYO4evoBZQELw51u7fmxRFk82xPBXPmk=;
        b=QjExv6bvPRG/dojgtMcxUA2R76hkZEXTNKEgEuc4v56J6GqIqoL607GzhccMzoK95R
         s7gVZ9GrC2mQG/PngYM/bkrnaelxuxqIkM0y6dsRHBQ3FEikLB1+fZmc+Mu/va8Mt2+i
         MfkEMt/P8nigXeWuHaw4694WJzom0abl2BuVA70k2HJlK7jc8gBcGoiuyenRiciVBpNZ
         qK56dpgAwLZLlxgK7qATocg5GB76Zc5ubY2Sfggi9OgOx3LdbYRHqgBnfo4UITtIDOAs
         wtWIlax8ZgYkFNSY5ClRnuYzh2AH0Of4bbVG1m6c60cbnmLAmTKDF/Uy53+uJqWbmYRH
         4u4g==
X-Gm-Message-State: ACgBeo3Fg7OYl/enPk6MFzXD/oXm30bUGO28/fbdr4ifsem+60cUXk00
        HS8aMk+5kXh4Ny6/hXnW7I6+aaKPHk8ukQBVxyLspQ==
X-Google-Smtp-Source: AA6agR63XJTZ1ONPDjClvd6nEk5N9pZrWjFAj9Ea+lJibRNLuAQicOzyRI9uSqi9azcjxCT+XpG+HzV2Ek4w2glmkJ0=
X-Received: by 2002:a17:902:ab5e:b0:178:99a:4f1 with SMTP id
 ij30-20020a170902ab5e00b00178099a04f1mr15620504plb.6.1662987223861; Mon, 12
 Sep 2022 05:53:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220909163500.5389-1-sreehari.kancharla@linux.intel.com> <20220909163500.5389-2-sreehari.kancharla@linux.intel.com>
In-Reply-To: <20220909163500.5389-2-sreehari.kancharla@linux.intel.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 12 Sep 2022 14:53:07 +0200
Message-ID: <CAMZdPi8KdWCke5s03Bvy_4NZcDsgp+jPW5dqvCHyiU2C==tsmw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: wwan: t7xx: Add NAPI support
To:     Sreehari Kancharla <sreehari.kancharla@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, ricardo.martinez@linux.intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        ilpo.jarvinen@linux.intel.com, moises.veleta@intel.com,
        sreehari.kancharla@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sreehari,


On Fri, 9 Sept 2022 at 18:40, Sreehari Kancharla
<sreehari.kancharla@linux.intel.com> wrote:
>
> From: Haijun Liu <haijun.liu@mediatek.com>
>
> Replace the work queue based RX flow with a NAPI implementation
> Remove rx_thread and dpmaif_rxq_work.
> Introduce dummy network device. its responsibility is
>     - Binds one NAPI object for each DL HW queue and acts as
>       the agent of all those network devices.
>     - Use NAPI object to poll DL packets.
>     - Helps to dispatch each packet to the network interface.
>
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Co-developed-by: Sreehari Kancharla <sreehari.kancharla@linux.intel.com>
> Signed-off-by: Sreehari Kancharla <sreehari.kancharla@linux.intel.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Acked-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Acked-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> ---
>  drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h    |  14 +-
>  drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c | 220 +++++++--------------
>  drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.h |   1 +
>  drivers/net/wwan/t7xx/t7xx_netdev.c        |  93 ++++++++-
>  drivers/net/wwan/t7xx/t7xx_netdev.h        |   5 +
>  5 files changed, 167 insertions(+), 166 deletions(-)
>
> diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h
> index 1225ca0ed51e..0ce4505e813d 100644
> --- a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h
> +++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h
> @@ -20,6 +20,7 @@

[...]

> -static void t7xx_dpmaif_rxq_work(struct work_struct *work)
> +int t7xx_dpmaif_napi_rx_poll(struct napi_struct *napi, const int budget)
>  {
> -       struct dpmaif_rx_queue *rxq = container_of(work, struct dpmaif_rx_queue, dpmaif_rxq_work);
> -       struct dpmaif_ctrl *dpmaif_ctrl = rxq->dpmaif_ctrl;
> -       int ret;
> +       struct dpmaif_rx_queue *rxq = container_of(napi, struct dpmaif_rx_queue, napi);
> +       struct t7xx_pci_dev *t7xx_dev = rxq->dpmaif_ctrl->t7xx_dev;
> +       int ret, once_more = 0, work_done = 0;
>
>         atomic_set(&rxq->rx_processing, 1);
>         /* Ensure rx_processing is changed to 1 before actually begin RX flow */
> @@ -917,22 +840,54 @@ static void t7xx_dpmaif_rxq_work(struct work_struct *work)
>
>         if (!rxq->que_started) {
>                 atomic_set(&rxq->rx_processing, 0);
> -               dev_err(dpmaif_ctrl->dev, "Work RXQ: %d has not been started\n", rxq->index);
> -               return;
> +               dev_err(rxq->dpmaif_ctrl->dev, "Work RXQ: %d has not been started\n", rxq->index);
> +               return work_done;
>         }
>
> -       ret = pm_runtime_resume_and_get(dpmaif_ctrl->dev);
> -       if (ret < 0 && ret != -EACCES)
> -               return;
> +       if (!rxq->sleep_lock_pending) {
> +               ret = pm_runtime_resume_and_get(rxq->dpmaif_ctrl->dev);

AFAIK, polling is not called in a context allowing you to sleep (e.g.
performing a synced pm runtime operation).

> +               if (ret < 0 && ret != -EACCES)
> +                       return work_done;
>
> -       t7xx_pci_disable_sleep(dpmaif_ctrl->t7xx_dev);
> -       if (t7xx_pci_sleep_disable_complete(dpmaif_ctrl->t7xx_dev))
> -               t7xx_dpmaif_do_rx(dpmaif_ctrl, rxq);
> +               t7xx_pci_disable_sleep(t7xx_dev);
> +       }
>
> -       t7xx_pci_enable_sleep(dpmaif_ctrl->t7xx_dev);
> -       pm_runtime_mark_last_busy(dpmaif_ctrl->dev);
> -       pm_runtime_put_autosuspend(dpmaif_ctrl->dev);
> +       ret = try_wait_for_completion(&t7xx_dev->sleep_lock_acquire);

The logic seems odd, why not simply scheduling napi polling when you
are really ready to handle it, i.e when you have awake condition & rx
ready.

> +       if (!ret) {
> +               napi_complete_done(napi, work_done);
> +               rxq->sleep_lock_pending = true;
> +               napi_reschedule(napi);
> +               return work_done;
> +       }
> +

[...]

Regards,
Loic
