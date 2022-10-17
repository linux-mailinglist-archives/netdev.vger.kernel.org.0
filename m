Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65813601E0F
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 02:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbiJRAAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 20:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbiJRAAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 20:00:22 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26862A265
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 17:00:05 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id 8so6689242ilj.4
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 17:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7AEOltKTnj3AYqdV+kk73L/nikucBbe6h7rxhauHzFg=;
        b=gPjThKzLAXlM6nXla4AeENuqqcVF8jR5NEJFXQg1KfGKXYa1V7exNaBgFm/Lq+Lf5n
         oI/VVGDH72oj9vQlTjsmPaKhjx3gKPPMppHGEkuZgWmozWE3sXyiwiChHFLQqI0Goygk
         JXIgPlwtigC0BN5stX7JYvQk+Vo9jtsiYamF1q2xPPSszUe2V2rk18SLs43m0k+r6zye
         Ki6ki4ug/3ritwFSUpSUnEWN5b2fOsAj798gGGxob7xfXNV/+n1km7VIbbVXSr0FqL+W
         0BLskP12VlWvCYDJyLM0WcuI84azk3SXypo0yaZmtBqkloQfa5KTjOZeqRjwF9R9gUV4
         0SUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7AEOltKTnj3AYqdV+kk73L/nikucBbe6h7rxhauHzFg=;
        b=mZBXuBjtz1L9i7+rJvHHfka25Y6y4YrDsJfyukogaU4q69hE0v7G5HxvioyoTQ1/u/
         0Ed4oxNCy6UZD61UiIEztak2LRTwSLbX1lFo+I8oklMCwYJylVCwmLsercYucZ/Zkphy
         3WF/r2s2rv6asVRcnvW35qhxcF0vzXC4NlSuU/K4tvtUl+Idkoknc2TC8Swr8lTZO+wJ
         QqPHXHoxB6u/dc5MYHQO9ydteorxf2g2Tp4D+5WNLmhwZRc6r17gZaSG9m9JdgryJB5h
         VNtlw0UFVwyspjUVxxi5VPMYel++detxSh9M3JTARObvyR3za8iZfpoXddPIgsdrUVTq
         s6cw==
X-Gm-Message-State: ACrzQf1005YVfRoA2kFdIxmYc6w4oKUBc5SsDItN36TcXtwIjFc1D3kL
        okaglmg0A1Z289Qc+2zQtyBREFlPCoBZ2+b4g1M=
X-Google-Smtp-Source: AMsMyM5pVzeY3CP9+CTrnoUU5CY655NZrpke68iFOew83yL/Fzyit5sCwGIFNwkCiR8QZFeDe3AmHCRaDuLv6tJ1bQ0=
X-Received: by 2002:a92:ca46:0:b0:2fa:e8dd:4c0f with SMTP id
 q6-20020a92ca46000000b002fae8dd4c0fmr334185ilo.3.1666051146219; Mon, 17 Oct
 2022 16:59:06 -0700 (PDT)
MIME-Version: 1.0
References: <20221003095725.978129-1-m.chetan.kumar@linux.intel.com>
 <CAHNKnsT9EpOCd2Rj=5dQO5a2JrsHuyZQUG9apbrxHTehe37yug@mail.gmail.com> <192037d6-3b4d-d059-283b-3fa5094d5465@linux.intel.com>
In-Reply-To: <192037d6-3b4d-d059-283b-3fa5094d5465@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 18 Oct 2022 03:59:04 +0400
Message-ID: <CAHNKnsSvQNwjttQQPjKJ5aEtm6rfddrjKjd1TafcoyH1L51m-w@mail.gmail.com>
Subject: Re: [PATCH V3 net-next] net: wwan: t7xx: Add port for modem logging
To:     "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, linuxwwan@intel.com,
        Moises Veleta <moises.veleta@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 On Mon, Oct 17, 2022 at 1:16 PM Kumar, M Chetan
<m.chetan.kumar@linux.intel.com> wrote:
> On 10/16/2022 9:35 PM, Sergey Ryazanov wrote:
>>>> On Mon, Oct 3, 2022 at 8:29 AM <m.chetan.kumar@linux.intel.com> wrote:
>>>>> The Modem Logging (MDL) port provides an interface to collect modem
>>>>> logs for debugging purposes. MDL is supported by the relay interface,
>>>>> and the mtk_t7xx port infrastructure. MDL allows user-space apps to
>>>>> control logging via mbim command and to collect logs via the relay
>>>>> interface, while port infrastructure facilitates communication between
>>>>> the driver and the modem.
>>>>
>>>> [skip]
>>>>
>>>>> diff --git a/drivers/net/wwan/t7xx/t7xx_port.h b/drivers/net/wwan/t7xx/t7xx_port.h
>>>>> index dc4133eb433a..702e7aa2ef31 100644
>>>>> --- a/drivers/net/wwan/t7xx/t7xx_port.h
>>>>> +++ b/drivers/net/wwan/t7xx/t7xx_port.h
>>>>> @@ -122,6 +122,11 @@ struct t7xx_port {
>>>>>          int                             rx_length_th;
>>>>>          bool                            chan_enable;
>>>>>          struct task_struct              *thread;
>>>>> +#ifdef CONFIG_WWAN_DEBUGFS
>>>>> +       void                            *relaych;
>>>>> +       struct dentry                   *debugfs_dir;
>>>>> +       struct dentry                   *debugfs_wwan_dir;
>>>>
>>>> Both of these debugfs directories are device-wide, why did you place
>>>> these pointers in the item port context?
>
> I guess it was kept inside port so that it could be accessed directly
> from port context.
>
> Thanks for pointing it out. I think we should move out the complete
> #ifdef CONFIG_WWAN_DEBUGFS block of port container.

Moving out debugfs directory pointers sounds like a good idea.
Introduction of any new debugfs knob will be a much easier if these
pointers are available in some device-wide state container. But the
relaych pointer looks like a logging port specific element. Why should
it be moved out?

> I am planning to add trace.h file and put changes under it.

The word 'trace' usually used for entities related to use of the
kernel tracing framework, i.e. driver itself tracing. If you really
need this dedicated header, can we entitle it like 'mdm_log' or
'logging' or something like that?

> Below is the new code changes [1]. I am yet to verify.
> Please share your comments.
>
> [1]
> --- a/drivers/net/wwan/t7xx/t7xx_pci.h
> +++ b/drivers/net/wwan/t7xx/t7xx_pci.h
> @@ -24,6 +24,7 @@
>   #include <linux/spinlock.h>
>   #include <linux/types.h>
>
> +#include "t7xx_port_trace.h"
>   #include "t7xx_reg.h"
>
>   /* struct t7xx_addr_base - holds base addresses
> @@ -59,6 +60,7 @@ typedef irqreturn_t (*t7xx_intr_callback)(int irq,
> void *param);
>    * @md_pm_lock: protects PCIe sleep lock
>    * @sleep_disable_count: PCIe L1.2 lock counter
>    * @sleep_lock_acquire: indicates that sleep has been disabled
> + * @trace: relayfs and debugfs data struct
>    */
>   struct t7xx_pci_dev {
>         t7xx_intr_callback      intr_handler[EXT_INT_NUM];
> @@ -78,6 +80,7 @@ struct t7xx_pci_dev {
>         spinlock_t              md_pm_lock;             /* Protects PCI resource lock */
>         unsigned int            sleep_disable_count;
>         struct completion       sleep_lock_acquire;
> +       struct t7xx_trace       trace;
>   };
>
>   enum t7xx_pm_id {
> diff --git a/drivers/net/wwan/t7xx/t7xx_port.h
> b/drivers/net/wwan/t7xx/t7xx_port.h
> index 702e7aa2ef31..dc4133eb433a 100644
> --- a/drivers/net/wwan/t7xx/t7xx_port.h
> +++ b/drivers/net/wwan/t7xx/t7xx_port.h
> @@ -122,11 +122,6 @@ struct t7xx_port {
>         int                             rx_length_th;
>         bool                            chan_enable;
>         struct task_struct              *thread;
> -#ifdef CONFIG_WWAN_DEBUGFS
> -       void                            *relaych;
> -       struct dentry                   *debugfs_dir;
> -       struct dentry                   *debugfs_wwan_dir;
> -#endif
>   };
>
>   struct sk_buff *t7xx_port_alloc_skb(int payload);
> diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
> b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
> index 894b1d11b2c9..3377573568c6 100644
> --- a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
> +++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
> @@ -35,6 +35,7 @@
>   #include "t7xx_modem_ops.h"
>   #include "t7xx_port.h"
>   #include "t7xx_port_proxy.h"
> +#include "t7xx_port_trace.h"
>   #include "t7xx_state_monitor.h"
>
>   #define Q_IDX_CTRL                    0
> diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.h
> b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
> index 81d059fbc0fb..c537f5b5ff60 100644
> --- a/drivers/net/wwan/t7xx/t7xx_port_proxy.h
> +++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
> @@ -87,9 +87,6 @@ struct ctrl_msg_header {
>   extern struct port_ops wwan_sub_port_ops;
>   extern struct port_ops ctl_port_ops;
>
> -#ifdef CONFIG_WWAN_DEBUGFS
> -extern struct port_ops t7xx_trace_port_ops;
> -#endif
>
>   void t7xx_port_proxy_reset(struct port_proxy *port_prox);
>   void t7xx_port_proxy_uninit(struct port_proxy *port_prox);
>
> +++ b/drivers/net/wwan/t7xx/t7xx_port_trace.h
> @@ -0,0 +1,21 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2022 Intel Corporation.
> + */
> +
> +#ifndef __T7XX_PORT_TRACE_H__
> +#define __T7XX_PORT_TRACE_H__
> +
> +struct t7xx_trace {
> +#ifdef CONFIG_WWAN_DEBUGFS
> +        void                            *relaych;
> +        struct dentry                   *debugfs_dir;
> +        struct dentry                   *debugfs_wwan_dir;
> +#endif
> +};

The relaych pointer is port specific, so it can be left in the port
structure. We do not need to keep the debugfs_dir pointer. It is only
needed during debugfs initialization to create the modem-specific
subdirectory. So it can be a local variable. There is only one
debugfs_wwan_dir pointer left, which can be placed somewhere in the
t7xx_modem structure.

> +#ifdef CONFIG_WWAN_DEBUGFS
> +extern struct port_ops t7xx_trace_port_ops;
> +#endif
> +
> +#endif /* __T7XX_PORT_TRACE_H__ */
>
> diff --git a/drivers/net/wwan/t7xx/t7xx_port_trace.c
> b/drivers/net/wwan/t7xx/t7xx_port_trace.c
> index 3f740db318a8..1f5224fb0e5d 100644
> --- a/drivers/net/wwan/t7xx/t7xx_port_trace.c
> +++ b/drivers/net/wwan/t7xx/t7xx_port_trace.c
> @@ -10,6 +10,7 @@
>
>   #include "t7xx_port.h"
>   #include "t7xx_port_proxy.h"
> +#include "t7xx_port_trace.h"
>   #include "t7xx_state_monitor.h"
>
>   #define T7XX_TRC_SUB_BUFF_SIZE                131072
> @@ -51,19 +52,19 @@ static struct rchan_callbacks relay_callbacks = {
>
>   static void t7xx_trace_port_uninit(struct t7xx_port *port)
>   {
> -       struct rchan *relaych = port->relaych;
> +       struct t7xx_trace *trace = &port->t7xx_dev->trace;
>
> -       if (!relaych)
> +       if (!trace->relaych)
>                 return;
>
> -       relay_close(relaych);
> -       debugfs_remove_recursive(port->debugfs_dir);
> -       wwan_put_debugfs_dir(port->debugfs_wwan_dir);
> +       relay_close(trace->relaych);
> +       debugfs_remove_recursive(trace->debugfs_dir);
> +       wwan_put_debugfs_dir(trace->debugfs_wwan_dir);
>   }
>
>   static int t7xx_trace_port_recv_skb(struct t7xx_port *port, struct
> sk_buff *skb)
>   {
> -       struct rchan *relaych = port->relaych;
> +       struct rchan *relaych = port->t7xx_dev->trace.relaych;
>
>         if (!relaych)
>                 return -EINVAL;
> @@ -75,33 +76,34 @@ static int t7xx_trace_port_recv_skb(struct t7xx_port
> *port, struct sk_buff *skb)
>
>   static void t7xx_port_trace_md_state_notify(struct t7xx_port *port,
> unsigned int state)
>   {
> +       struct t7xx_trace *trace = &port->t7xx_dev->trace;
>         struct rchan *relaych;
>
> -       if (state != MD_STATE_READY || port->relaych)
> +       if (state != MD_STATE_READY || trace->relaych)
>                 return;
>
> -       port->debugfs_wwan_dir = wwan_get_debugfs_dir(port->dev);
> -       if (IS_ERR(port->debugfs_wwan_dir))
> +       trace->debugfs_wwan_dir = wwan_get_debugfs_dir(port->dev);
> +       if (IS_ERR(trace->debugfs_wwan_dir))
>                 return;
>
> -       port->debugfs_dir = debugfs_create_dir(KBUILD_MODNAME,
> port->debugfs_wwan_dir);
> -       if (IS_ERR_OR_NULL(port->debugfs_dir)) {
> -               wwan_put_debugfs_dir(port->debugfs_wwan_dir);
> +       trace->debugfs_dir = debugfs_create_dir(KBUILD_MODNAME,
> trace->debugfs_wwan_dir);
> +       if (IS_ERR_OR_NULL(trace->debugfs_dir)) {
> +               wwan_put_debugfs_dir(trace->debugfs_wwan_dir);
>                 dev_err(port->dev, "Unable to create debugfs for trace");
>                 return;
>         }
>
> -       relaych = relay_open("relay_ch", port->debugfs_dir,
> T7XX_TRC_SUB_BUFF_SIZE,
> +       relaych = relay_open("relay_ch", trace->debugfs_dir,
> T7XX_TRC_SUB_BUFF_SIZE,
>                              T7XX_TRC_N_SUB_BUFF, &relay_callbacks, NULL);
>         if (!relaych)
>                 goto err_rm_debugfs_dir;
>
> -       port->relaych = relaych;
> +       trace->relaych = relaych;
>         return;
>
>   err_rm_debugfs_dir:
> -       debugfs_remove_recursive(port->debugfs_dir);
> -       wwan_put_debugfs_dir(port->debugfs_wwan_dir);
> +       debugfs_remove_recursive(trace->debugfs_dir);
> +       wwan_put_debugfs_dir(trace->debugfs_wwan_dir);
>         dev_err(port->dev, "Unable to create trace port %s",
> port->port_conf->name);
>   }

-- 
Sergey
