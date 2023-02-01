Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A3E686276
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 10:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbjBAJIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 04:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbjBAJII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 04:08:08 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0A361D70
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 01:07:37 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id q5so16642567wrv.0
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 01:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fKEd+3h6AizDummX7ngTA+1fwq8K4zQk8zc4tgZzpnQ=;
        b=Pk/yCqvYjb9lKkJ5syfyap1et7fvZaC3UOY6LeMvvBYaTzeYEV1ag4M4yOc96r9YT/
         +qMN3E5sBDvpq4iFVNRJALeBvmONHDtdltLPODihgg9o5qY4R6s5AmLrMk1wIOqAsdpb
         LfKqC/wOz/ZJ0sDYgLAKBiu4g0416ecni3D8d0DLwcuvQb7Ww+Rwthsle7WHsJvsrHYm
         4FozFSlehAZS81IrhLrQnPXu5Ls6VSK1o/3Asg474lzF8J4VBBkDSladW9cFc8V1pv1F
         eP2jC2h4HlVe1zh8782gHN7ZI8udissAaIQQAYfa3UzqGxvQ9p8+l2Uz6aVGLCUnHJdx
         GsAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fKEd+3h6AizDummX7ngTA+1fwq8K4zQk8zc4tgZzpnQ=;
        b=0fgVMUIFfJQwsWvCxynqCPlCLz52E9LeYMn609Y32JkhpxDGvhGYUAK4c9bHALlsqS
         aG+Y30itJIT17iwHVY15WlnqYcl3XokRZV2sBNJJuOa11jI2rtK14o0BomordCMOrhFN
         bpSX0BpcotSR/gsyTaz7pU6hSu87xnut6iXZSS81J+sdjYeiWE9Err2bvyykfM+SdjMW
         GX6xddKowcfbD9mm+PNE6f7K1f6CLQkVNnT63NmRDb+DrLK0/nsSY6h27KAwkY75lc4X
         X8ugafAqeA5cPiSJiFuIhNnxfYcI8+8zreYrUqzzBfSKYZDw0c1YXQJLOIzmvwPiSbhR
         uyDg==
X-Gm-Message-State: AO0yUKUpJNhIF6dP4AM1pt0RB0So5RUfSSgVAZE0DnlnZGalKk+mNh4i
        ZFYUOqIRk/a4hbqwfbmwcboZtAE7jVvW40+MDgc=
X-Google-Smtp-Source: AK7set9AmHR/earZhkMJMruh+AcLTnfwnLEIJDXJNzKUjOsbtKCTKv8x0KMaRg/fFYepgHvl9q43iQ==
X-Received: by 2002:adf:9c8e:0:b0:2ab:78e2:864e with SMTP id d14-20020adf9c8e000000b002ab78e2864emr1510468wre.19.1675242455307;
        Wed, 01 Feb 2023 01:07:35 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id w10-20020adfcd0a000000b002bff7caa1c2sm5803698wrm.0.2023.02.01.01.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 01:07:34 -0800 (PST)
Date:   Wed, 1 Feb 2023 10:07:33 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH v4 net-next 1/8] sfc: add devlink support for ef100
Message-ID: <Y9or1SWlasbNIJpp@nanopsycho>
References: <20230131145822.36208-1-alejandro.lucero-palau@amd.com>
 <20230131145822.36208-2-alejandro.lucero-palau@amd.com>
 <Y9k7Ap4Irby7vnWg@nanopsycho>
 <44b02ac4-0f64-beb3-3af0-6b628e839620@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44b02ac4-0f64-beb3-3af0-6b628e839620@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Feb 01, 2023 at 09:49:52AM CET, alejandro.lucero-palau@amd.com wrote:
>
>
>On 1/31/23 16:00, Jiri Pirko wrote:
>> Tue, Jan 31, 2023 at 03:58:15PM CET, alejandro.lucero-palau@amd.com <mailto:alejandro.lucero-palau@amd.com> wrote:
>>> From: Alejandro Lucero <alejandro.lucero-palau@amd.com <mailto:alejandro.lucero-palau@amd.com>>
>>>
>>> Basic devlink infrastructure support.
>>>
>>> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com <mailto:alejandro.lucero-palau@amd.com>>
>>> ---
>>> drivers/net/ethernet/sfc/Kconfig | 1 +
>>> drivers/net/ethernet/sfc/Makefile | 3 +-
>>> drivers/net/ethernet/sfc/ef100_netdev.c | 12 +++++
>>> drivers/net/ethernet/sfc/ef100_nic.c | 3 +-
>>> drivers/net/ethernet/sfc/efx_devlink.c | 71 +++++++++++++++++++++++++
>>> drivers/net/ethernet/sfc/efx_devlink.h | 22 ++++++++
>>> drivers/net/ethernet/sfc/net_driver.h | 2 +
>>> 7 files changed, 111 insertions(+), 3 deletions(-)
>>> create mode 100644 drivers/net/ethernet/sfc/efx_devlink.c
>>> create mode 100644 drivers/net/ethernet/sfc/efx_devlink.h
>>>
>>> diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kconfig
>>> index 0950e6b0508f..4af36ba8906b 100644
>>> --- a/drivers/net/ethernet/sfc/Kconfig
>>> +++ b/drivers/net/ethernet/sfc/Kconfig
>>> @@ -22,6 +22,7 @@ config SFC
>>> depends on PTP_1588_CLOCK_OPTIONAL
>>> select MDIO
>>> select CRC32
>>> + select NET_DEVLINK
>>> help
>>> This driver supports 10/40-gigabit Ethernet cards based on
>>> the Solarflare SFC9100-family controllers.
>>> diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
>>> index 712a48d00069..55b9c73cd8ef 100644
>>> --- a/drivers/net/ethernet/sfc/Makefile
>>> +++ b/drivers/net/ethernet/sfc/Makefile
>>> @@ -6,7 +6,8 @@ sfc-y += efx.o efx_common.o efx_channels.o nic.o \
>>> mcdi.o mcdi_port.o mcdi_port_common.o \
>>> mcdi_functions.o mcdi_filters.o mcdi_mon.o \
>>> ef100.o ef100_nic.o ef100_netdev.o \
>>> - ef100_ethtool.o ef100_rx.o ef100_tx.o
>>> + ef100_ethtool.o ef100_rx.o ef100_tx.o \
>>> + efx_devlink.o
>>> sfc-$(CONFIG_SFC_MTD) += mtd.o
>>> sfc-$(CONFIG_SFC_SRIOV) += sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o \
>>> mae.o tc.o tc_bindings.o tc_counters.o
>>> diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
>>> index ddcc325ed570..b10a226f4a07 100644
>>> --- a/drivers/net/ethernet/sfc/ef100_netdev.c
>>> +++ b/drivers/net/ethernet/sfc/ef100_netdev.c
>>> @@ -24,6 +24,7 @@
>>> #include "rx_common.h"
>>> #include "ef100_sriov.h"
>>> #include "tc_bindings.h"
>>> +#include "efx_devlink.h"
>>>
>>> static void ef100_update_name(struct efx_nic *efx)
>>> {
>>> @@ -332,6 +333,8 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
>>> efx_ef100_pci_sriov_disable(efx, true);
>>> #endif
>>>
>>> + /* devlink lock */
>>> + efx_fini_devlink_start(efx);
>>> ef100_unregister_netdev(efx);
>>>
>>> #ifdef CONFIG_SFC_SRIOV
>>> @@ -345,6 +348,9 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
>>> kfree(efx->phy_data);
>>> efx->phy_data = NULL;
>>>
>>> + /* devlink unlock */
>>> + efx_fini_devlink(efx);
>>> +
>>> free_netdev(efx->net_dev);
>>> efx->net_dev = NULL;
>>> efx->state = STATE_PROBED;
>>> @@ -405,6 +411,10 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
>>> /* Don't fail init if RSS setup doesn't work. */
>>> efx_mcdi_push_default_indir_table(efx, efx->n_rx_channels);
>>>
>>> + /* devlink creation, registration and lock */
>>> + if (efx_probe_devlink(efx))
>> Use variable to store the return value and check that in if.
>>
>
>I'll do.
>
>>> + pci_info(efx->pci_dev, "devlink registration failed");
>>> +
>>> rc = ef100_register_netdev(efx);
>>> if (rc)
>>> goto fail;
>>> @@ -424,5 +434,7 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
>>> }
>>>
>>> fail:
>>> + /* devlink unlock */
>>> + efx_probe_devlink_done(efx);
>>> return rc;
>>> }
>>> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
>>> index ad686c671ab8..e4aacb4ec666 100644
>>> --- a/drivers/net/ethernet/sfc/ef100_nic.c
>>> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
>>> @@ -1120,11 +1120,10 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
>>> return rc;
>>>
>>> rc = efx_ef100_get_base_mport(efx);
>>> - if (rc) {
>>> + if (rc)
>>> netif_warn(efx, probe, net_dev,
>>> "Failed to probe base mport rc %d; representors will not function\n",
>>> rc);
>>> - }
>> I don't see how this hunk is related to this patch. Please remove.
>>
>>
>
>Running checkpatch on this specific patch triggered a warning about the 
>netif_warn requiring brackets.
>
>It is true it is not related to the patch itself, so I'll remove it.
>
>>> rc = efx_init_tc(efx);
>>> if (rc) {
>>> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
>>> new file mode 100644
>>> index 000000000000..fab06aaa4b8a
>>> --- /dev/null
>>> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
>>> @@ -0,0 +1,71 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/****************************************************************************
>>> + * Driver for AMD network controllers and boards
>>> + * Copyright (C) 2023, Advanced Micro Devices, Inc.
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify it
>>> + * under the terms of the GNU General Public License version 2 as published
>>> + * by the Free Software Foundation, incorporated herein by reference.
>>> + */
>>> +
>>> +#include <linux/rtc.h>
>>> +#include "net_driver.h"
>>> +#include "ef100_nic.h"
>>> +#include "efx_devlink.h"
>>> +#include "nic.h"
>>> +#include "mcdi.h"
>>> +#include "mcdi_functions.h"
>>> +#include "mcdi_pcol.h"
>>> +
>>> +struct efx_devlink {
>>> + struct efx_nic *efx;
>>> +};
>>> +
>>> +static const struct devlink_ops sfc_devlink_ops = {
>>> +};
>>> +
>>> +void efx_fini_devlink_start(struct efx_nic *efx)
>>> +{
>>> + if (efx->devlink)
>>> + devl_lock(efx->devlink);
>>> +}
>>> +
>>> +void efx_fini_devlink(struct efx_nic *efx)
>>> +{
>>> + if (efx->devlink) {
>>> + devl_unregister(efx->devlink);
>>> + devl_unlock(efx->devlink);
>>> + devlink_free(efx->devlink);
>>> + efx->devlink = NULL;
>>> + }
>>> +}
>>> +
>>> +int efx_probe_devlink(struct efx_nic *efx)
>>> +{
>>> + struct efx_devlink *devlink_private;
>>> +
>>> + if (efx->type->is_vf)
>>> + return 0;
>>> +
>>> + efx->devlink = devlink_alloc(&sfc_devlink_ops,
>>> + sizeof(struct efx_devlink),
>>> + &efx->pci_dev->dev);
>>> + if (!efx->devlink)
>>> + return -ENOMEM;
>>> +
>>> + devl_lock(efx->devlink);
>>> + devlink_private = devlink_priv(efx->devlink);
>>> + devlink_private->efx = efx;
>>> +
>>> + devl_register(efx->devlink);
>>> +
>>> + return 0;
>>> +}
>>> +
>>> +void efx_probe_devlink_done(struct efx_nic *efx)
>>> +{
>>> + if (!efx->devlink)
>>> + return;
>>> +
>>> + devl_unlock(efx->devlink);
>>> +}
>>> diff --git a/drivers/net/ethernet/sfc/efx_devlink.h b/drivers/net/ethernet/sfc/efx_devlink.h
>>> new file mode 100644
>>> index 000000000000..55d0d8aeca1e
>>> --- /dev/null
>>> +++ b/drivers/net/ethernet/sfc/efx_devlink.h
>>> @@ -0,0 +1,22 @@
>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>> +/****************************************************************************
>>> + * Driver for AMD network controllers and boards
>>> + * Copyright (C) 2023, Advanced Micro Devices, Inc.
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify it
>>> + * under the terms of the GNU General Public License version 2 as published
>>> + * by the Free Software Foundation, incorporated herein by reference.
>>> + */
>>> +
>>> +#ifndef _EFX_DEVLINK_H
>>> +#define _EFX_DEVLINK_H
>>> +
>>> +#include "net_driver.h"
>>> +#include <net/devlink.h>
>>> +
>>> +int efx_probe_devlink(struct efx_nic *efx);
>>> +void efx_probe_devlink_done(struct efx_nic *efx);
>>> +void efx_fini_devlink_start(struct efx_nic *efx);
>>> +void efx_fini_devlink(struct efx_nic *efx);
>> Odd naming... Just saying.
>>
>
>This is due to the recommended/required devlink lock/unlock during 
>driver initialization/removal.
>
>I think it is better to keep the lock/unlock inside the specific driver 
>devlink code, and the functions naming reflects a time window when 
>devlink related/dependent processing is being done.
>
>I'm not against changing this, maybe adding the lock/unlock suffix would 
>be preferable?:
>
>int efx_probe_devlink_and_lock(struct efx_nic *efx);
>void efx_probe_devlink_unlock(struct efx_nic *efx);
>void efx_fini_devlink_lock(struct efx_nic *efx);
>void efx_fini_devlink_and_unlock(struct efx_nic *efx);

Sounds better. Thanks!

>
>>> +
>>> +#endif /* _EFX_DEVLINK_H */
>>> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
>>> index 3b49e216768b..d036641dc043 100644
>>> --- a/drivers/net/ethernet/sfc/net_driver.h
>>> +++ b/drivers/net/ethernet/sfc/net_driver.h
>>> @@ -994,6 +994,7 @@ enum efx_xdp_tx_queues_mode {
>>> * xdp_rxq_info structures?
>>> * @netdev_notifier: Netdevice notifier.
>>> * @tc: state for TC offload (EF100).
>>> + * @devlink: reference to devlink structure owned by this device
>>> * @mem_bar: The BAR that is mapped into membase.
>>> * @reg_base: Offset from the start of the bar to the function control window.
>>> * @monitor_work: Hardware monitor workitem
>>> @@ -1179,6 +1180,7 @@ struct efx_nic {
>>> struct notifier_block netdev_notifier;
>>> struct efx_tc_state *tc;
>>>
>>> + struct devlink *devlink;
>>> unsigned int mem_bar;
>>> u32 reg_base;
>>>
>>> -- 
>>> 2.17.1
>>>
>
>
>
