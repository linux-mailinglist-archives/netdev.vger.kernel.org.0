Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9AAE68627E
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 10:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbjBAJJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 04:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjBAJJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 04:09:17 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3FA5BA2
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 01:08:45 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id t18so16629981wro.1
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 01:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CJYwJDKmCVh8t6et+qevBP93NhjETNWIkHOFSC0i81g=;
        b=TnzG6wJ6vP/UN99ciaCBtml9aRNFuPqPN50jYXy7fCQWsCO37lYsx24r2eqRlMW/Jb
         od1JWanXRnymhsKruFXxIM17tQPP4ekeCQvhUqBqRc01oL1WIlSRFNWoDNcTTffSZSvZ
         npn00B4e/kz971CYxaIFH5imCsTg2NtiZH7kJsFHJomQaTe87biJMHiynxbwqewVz8QE
         5lTv/yrqZDbjshGAP6GzrOXN6gILK1U974pVB+OU9uEe+21vI+tvMfjbvfEmy8wMvIhl
         +fnXvPE5W27xFzgR5im6osjT5hWsZXiStPSRtLO1nhaAgLgF3+bkxNE5RisnFb9+8o65
         CD8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CJYwJDKmCVh8t6et+qevBP93NhjETNWIkHOFSC0i81g=;
        b=zUUOVqX20LUMjHn3dLvhQIa9HRrU3G76aVdYLpgRQYUIJbZyycIHXRJFpJiSk8jqHZ
         QQVNzzfvG47dThOimymlpm0KEZI0iD2z4PYcmEEeg7GRV99E83v5rE9nsm2JUVd+prCS
         mOgSgQj9R52Aqi/nlL1uv04BoR3MTf0vfwhUVR3jHf+glbBQ5XyhNN6JNW2imRAZ5uUS
         BvD5oFf7wV0aAlhcOe7+8dGOhr/aE+suc2P7wXktVD2XQbjLnUiFPRPpUBokSzss3B9X
         Cc2GqCSPnpxaCbzH66Oys2xd3Hc7LD6EU6zdrFbxhk4RyZ7V0PsYL/sp5SAenkMppLul
         /fMw==
X-Gm-Message-State: AO0yUKV5ZobDKAArDV2uLHlC3NW8ZmvOxT9mFjWQrAWRUtWmwFA5bTRg
        3AKptkuGzbz/c8KlS9IBoUo9uQ==
X-Google-Smtp-Source: AK7set/ZjYZA0QEElgk0g06dFAKqOJzCYncu7OO8jKUw6AKtRc63kRshQEaa3+8i4IjOad3YcRxH2w==
X-Received: by 2002:adf:e64c:0:b0:2bf:d0b4:2ccf with SMTP id b12-20020adfe64c000000b002bfd0b42ccfmr1695035wrn.37.1675242520953;
        Wed, 01 Feb 2023 01:08:40 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id p17-20020a05600c05d100b003dc521f336esm1093902wmd.14.2023.02.01.01.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 01:08:40 -0800 (PST)
Date:   Wed, 1 Feb 2023 10:08:39 +0100
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
Subject: Re: [PATCH v4 net-next 5/8] sfc: add devlink port support for ef100
Message-ID: <Y9osFz6wWtxPqp49@nanopsycho>
References: <20230131145822.36208-1-alejandro.lucero-palau@amd.com>
 <20230131145822.36208-6-alejandro.lucero-palau@amd.com>
 <Y9k921b19TF6KDPE@nanopsycho>
 <abdae94d-10f6-4a31-4131-916606c60363@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abdae94d-10f6-4a31-4131-916606c60363@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Feb 01, 2023 at 10:03:10AM CET, alejandro.lucero-palau@amd.com wrote:
>
>
>On 1/31/23 16:12, Jiri Pirko wrote:
>> Tue, Jan 31, 2023 at 03:58:19PM CET, alejandro.lucero-palau@amd.com <mailto:alejandro.lucero-palau@amd.com> wrote:
>>> From: Alejandro Lucero <alejandro.lucero-palau@amd.com <mailto:alejandro.lucero-palau@amd.com>>
>>>
>>> Using the data when enumerating mports, create devlink ports just before
>>> netdevs are registered and remove those devlink ports after netdev has
>>> been unregistered.
>>>
>>> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com <mailto:alejandro.lucero-palau@amd.com>>
>>> ---
>>> drivers/net/ethernet/sfc/ef100_netdev.c | 9 +++
>>> drivers/net/ethernet/sfc/ef100_rep.c | 22 ++++++
>>> drivers/net/ethernet/sfc/ef100_rep.h | 7 ++
>>> drivers/net/ethernet/sfc/efx_devlink.c | 97 +++++++++++++++++++++++++
>>> drivers/net/ethernet/sfc/efx_devlink.h | 6 ++
>>> drivers/net/ethernet/sfc/mae.h | 2 +
>>> drivers/net/ethernet/sfc/net_driver.h | 2 +
>>> 7 files changed, 145 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
>>> index b10a226f4a07..36774b55d413 100644
>>> --- a/drivers/net/ethernet/sfc/ef100_netdev.c
>>> +++ b/drivers/net/ethernet/sfc/ef100_netdev.c
>>> @@ -335,7 +335,9 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
>>>
>>> /* devlink lock */
>>> efx_fini_devlink_start(efx);
>>> +
>> Does not seem related to the patch.
>>
>>
>>
>>> ef100_unregister_netdev(efx);
>>> + ef100_pf_unset_devlink_port(efx);
>>>
>>> #ifdef CONFIG_SFC_SRIOV
>>> efx_fini_tc(efx);
>>> @@ -423,6 +425,8 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
>>> rc = ef100_probe_netdev_pf(efx);
>>> if (rc)
>>> goto fail;
>>> +
>>> + ef100_pf_set_devlink_port(efx);
>>> }
>>>
>>> efx->netdev_notifier.notifier_call = ef100_netdev_event;
>>> @@ -433,7 +437,12 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
>>> goto fail;
>>> }
>>>
>>> + /* devlink unlock */
>>> + efx_probe_devlink_done(efx);
>>> + return rc;
>>> fail:
>>> + /* remove devlink port if does exist */
>>> + ef100_pf_unset_devlink_port(efx);
>>> /* devlink unlock */
>>> efx_probe_devlink_done(efx);
>>> return rc;
>>> diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
>>> index 9cd1a3ac67e0..6b5bc5d6955d 100644
>>> --- a/drivers/net/ethernet/sfc/ef100_rep.c
>>> +++ b/drivers/net/ethernet/sfc/ef100_rep.c
>>> @@ -16,6 +16,7 @@
>>> #include "mae.h"
>>> #include "rx_common.h"
>>> #include "tc_bindings.h"
>>> +#include "efx_devlink.h"
>>>
>>> #define EFX_EF100_REP_DRIVER "efx_ef100_rep"
>>>
>>> @@ -297,6 +298,7 @@ int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i)
>>> i, rc);
>>> goto fail1;
>>> }
>>> + ef100_rep_set_devlink_port(efv);
>>> rc = register_netdev(efv->net_dev);
>>> if (rc) {
>>> pci_err(efx->pci_dev,
>>> @@ -308,6 +310,7 @@ int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i)
>>> efv->net_dev->name);
>>> return 0;
>>> fail2:
>>> + ef100_rep_unset_devlink_port(efv);
>>> efx_ef100_deconfigure_rep(efv);
>>> fail1:
>>> efx_ef100_rep_destroy_netdev(efv);
>>> @@ -323,6 +326,7 @@ void efx_ef100_vfrep_destroy(struct efx_nic *efx, struct efx_rep *efv)
>>> return;
>>> netif_dbg(efx, drv, rep_dev, "Removing VF representor\n");
>>> unregister_netdev(rep_dev);
>>> + ef100_rep_unset_devlink_port(efv);
>>> efx_ef100_deconfigure_rep(efv);
>>> efx_ef100_rep_destroy_netdev(efv);
>>> }
>>> @@ -339,6 +343,24 @@ void efx_ef100_fini_vfreps(struct efx_nic *efx)
>>> efx_ef100_vfrep_destroy(efx, efv);
>>> }
>>>
>>> +static bool ef100_mport_is_pcie_vnic(struct mae_mport_desc *mport_desc)
>>> +{
>>> + return mport_desc->mport_type == MAE_MPORT_DESC_MPORT_TYPE_VNIC &&
>>> + mport_desc->vnic_client_type == MAE_MPORT_DESC_VNIC_CLIENT_TYPE_FUNCTION;
>>> +}
>>> +
>>> +bool ef100_mport_on_local_intf(struct efx_nic *efx,
>>> + struct mae_mport_desc *mport_desc)
>>> +{
>>> + struct ef100_nic_data *nic_data = efx->nic_data;
>>> + bool pcie_func;
>>> +
>>> + pcie_func = ef100_mport_is_pcie_vnic(mport_desc);
>>> +
>>> + return nic_data->have_local_intf && pcie_func &&
>>> + mport_desc->interface_idx == nic_data->local_mae_intf;
>>> +}
>>> +
>>> void efx_ef100_init_reps(struct efx_nic *efx)
>>> {
>>> struct ef100_nic_data *nic_data = efx->nic_data;
>>> diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
>>> index 328ac0cbb532..ae6add4b0855 100644
>>> --- a/drivers/net/ethernet/sfc/ef100_rep.h
>>> +++ b/drivers/net/ethernet/sfc/ef100_rep.h
>>> @@ -22,6 +22,8 @@ struct efx_rep_sw_stats {
>>> atomic64_t rx_dropped, tx_errors;
>>> };
>>>
>>> +struct devlink_port;
>>> +
>>> /**
>>> * struct efx_rep - Private data for an Efx representor
>>> *
>>> @@ -39,6 +41,7 @@ struct efx_rep_sw_stats {
>>> * @rx_lock: protects @rx_list
>>> * @napi: NAPI control structure
>>> * @stats: software traffic counters for netdev stats
>>> + * @dl_port: devlink port associated to this netdev representor
>>> */
>>> struct efx_rep {
>>> struct efx_nic *parent;
>>> @@ -54,6 +57,7 @@ struct efx_rep {
>>> spinlock_t rx_lock;
>>> struct napi_struct napi;
>>> struct efx_rep_sw_stats stats;
>>> + struct devlink_port *dl_port;
>>> };
>>>
>>> int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i);
>>> @@ -69,4 +73,7 @@ struct efx_rep *efx_ef100_find_rep_by_mport(struct efx_nic *efx, u16 mport);
>>> extern const struct net_device_ops efx_ef100_rep_netdev_ops;
>>> void efx_ef100_init_reps(struct efx_nic *efx);
>>> void efx_ef100_fini_reps(struct efx_nic *efx);
>>> +struct mae_mport_desc;
>>> +bool ef100_mport_on_local_intf(struct efx_nic *efx,
>>> + struct mae_mport_desc *mport_desc);
>>> #endif /* EF100_REP_H */
>>> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
>>> index ff5adfe3905e..b1637eb372ad 100644
>>> --- a/drivers/net/ethernet/sfc/efx_devlink.c
>>> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
>>> @@ -16,11 +16,48 @@
>>> #include "mcdi.h"
>>> #include "mcdi_functions.h"
>>> #include "mcdi_pcol.h"
>>> +#include "mae.h"
>>> +#include "ef100_rep.h"
>>>
>>> struct efx_devlink {
>>> struct efx_nic *efx;
>>> };
>>>
>>> +static void efx_devlink_del_port(struct devlink_port *dl_port)
>>> +{
>>> + if (!dl_port)
>>> + return;
>>> + devl_port_unregister(dl_port);
>>> +}
>>> +
>>> +static int efx_devlink_add_port(struct efx_nic *efx,
>>> + struct mae_mport_desc *mport)
>>> +{
>>> + bool external = false;
>>> +
>>> + if (!ef100_mport_on_local_intf(efx, mport))
>>> + external = true;
>>> +
>>> + switch (mport->mport_type) {
>>> + case MAE_MPORT_DESC_MPORT_TYPE_VNIC:
>>> + if (mport->vf_idx != MAE_MPORT_DESC_VF_IDX_NULL)
>>> + devlink_port_attrs_pci_vf_set(&mport->dl_port, 0, mport->pf_idx,
>>> + mport->vf_idx,
>>> + external);
>>> + else
>>> + devlink_port_attrs_pci_pf_set(&mport->dl_port, 0, mport->pf_idx,
>>> + external);
>>> + break;
>>> + default:
>>> + /* MAE_MPORT_DESC_MPORT_ALIAS and UNDEFINED */
>>> + return 0;
>>> + }
>>> +
>>> + mport->dl_port.index = mport->mport_id;
>>> +
>>> + return devl_port_register(efx->devlink, &mport->dl_port, mport->mport_id);
>>> +}
>>> +
>>> static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
>>> struct devlink_info_req *req,
>>> unsigned int partition_type,
>>> @@ -428,6 +465,66 @@ static const struct devlink_ops sfc_devlink_ops = {
>>> .info_get = efx_devlink_info_get,
>>> };
>>>
>>> +static struct devlink_port *ef100_set_devlink_port(struct efx_nic *efx, u32 idx)
>>> +{
>>> + struct mae_mport_desc *mport;
>>> + u32 id;
>>> +
>>> + if (efx_mae_lookup_mport(efx, idx, &id)) {
>>> + /* This should not happen. */
>>> + if (idx == MAE_MPORT_DESC_VF_IDX_NULL)
>>> + pci_warn(efx->pci_dev, "No mport ID found for PF.\n");
>>> + else
>>> + pci_warn(efx->pci_dev, "No mport ID found for VF %u.\n",
>>> + idx);
>>> + return NULL;
>>> + }
>>> +
>>> + mport = efx_mae_get_mport(efx, id);
>>> + if (!mport) {
>>> + /* This should not happen. */
>> Should not happen? WARN_ON?
>
>It makes sense.
>
>I will change it.
>
>>
>>> + if (idx == MAE_MPORT_DESC_VF_IDX_NULL)
>>> + pci_warn(efx->pci_dev, "No mport found for PF.\n");
>>> + else
>>> + pci_warn(efx->pci_dev, "No mport found for VF %u.\n",
>>> + idx);
>>> + return NULL;
>>> + }
>>> +
>>> + if (efx_devlink_add_port(efx, mport)) {
>> Store the return value into variable please.
>>
>
>OK
>
>>> + if (idx == MAE_MPORT_DESC_VF_IDX_NULL)
>>> + pci_warn(efx->pci_dev,
>>> + "devlink port creation for PF failed.\n");
>>> + else
>>> + pci_warn(efx->pci_dev,
>>> + "devlink_port creationg for VF %u failed.\n",
>>> + idx);
>>> + return NULL;
>>> + }
>>> +
>>> + return &mport->dl_port;
>>> +}
>>> +
>>> +void ef100_rep_set_devlink_port(struct efx_rep *efv)
>>> +{
>>> + efv->dl_port = ef100_set_devlink_port(efv->parent, efv->idx);
>>> +}
>>> +
>>> +void ef100_pf_set_devlink_port(struct efx_nic *efx)
>>> +{
>>> + efx->dl_port = ef100_set_devlink_port(efx, MAE_MPORT_DESC_VF_IDX_NULL);
>>> +}
>>> +
>>> +void ef100_rep_unset_devlink_port(struct efx_rep *efv)
>>> +{
>>> + efx_devlink_del_port(efv->dl_port);
>>> +}
>>> +
>>> +void ef100_pf_unset_devlink_port(struct efx_nic *efx)
>>> +{
>>> + efx_devlink_del_port(efx->dl_port);
>>> +}
>>> +
>>> void efx_fini_devlink_start(struct efx_nic *efx)
>>> {
>>> if (efx->devlink)
>>> diff --git a/drivers/net/ethernet/sfc/efx_devlink.h b/drivers/net/ethernet/sfc/efx_devlink.h
>>> index 8bcd077d8d8d..d453a180c44c 100644
>>> --- a/drivers/net/ethernet/sfc/efx_devlink.h
>>> +++ b/drivers/net/ethernet/sfc/efx_devlink.h
>>> @@ -36,4 +36,10 @@ void efx_probe_devlink_done(struct efx_nic *efx);
>>> void efx_fini_devlink_start(struct efx_nic *efx);
>>> void efx_fini_devlink(struct efx_nic *efx);
>>>
>>> +struct efx_rep;
>>> +
>>> +void ef100_pf_set_devlink_port(struct efx_nic *efx);
>>> +void ef100_rep_set_devlink_port(struct efx_rep *efv);
>>> +void ef100_pf_unset_devlink_port(struct efx_nic *efx);
>>> +void ef100_rep_unset_devlink_port(struct efx_rep *efv);
>>> #endif /* _EFX_DEVLINK_H */
>>> diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
>>> index d9adeafc0654..e1b7967132ad 100644
>>> --- a/drivers/net/ethernet/sfc/mae.h
>>> +++ b/drivers/net/ethernet/sfc/mae.h
>>> @@ -13,6 +13,7 @@
>>> #define EF100_MAE_H
>>> /* MCDI interface for the ef100 Match-Action Engine */
>>>
>>> +#include <net/devlink.h>
>>> #include "net_driver.h"
>>> #include "tc.h"
>>> #include "mcdi_pcol.h" /* needed for various MC_CMD_MAE_*_NULL defines */
>>> @@ -44,6 +45,7 @@ struct mae_mport_desc {
>>> };
>>> struct rhash_head linkage;
>>> struct efx_rep *efv;
>>> + struct devlink_port dl_port;
>> This is quite odd to store the devlink port struct in something called
>> "match action engine"... Why don't you put it to struct efx_nic
>> directly? Much more suitable.
>>
>
>Well, it is not called just mae but mae_mport_desc. And mae ports are 
>obviously related to devlink ports.
>
>We need to keep mae ports, and not always a mae port/devlink port will 
>be related to an efx_nic structure.
>
>If I'm not wrong, devlink was created because not everything in today's 
>networking devices can map smoothly to kernel networking structures, not 
>because kernel implementation is lacking such representation but because 
>it does not make sense semantically. Of course, efx_nic is not a generic kernel
>one, but again, we could need devlink ports but not such driver's struct.

Okay, that's fair.


>
>>> };
>>>
>>> int efx_mae_enumerate_mports(struct efx_nic *efx);
>>> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
>>> index bc9efbfb3d6b..fcd51d3992fa 100644
>>> --- a/drivers/net/ethernet/sfc/net_driver.h
>>> +++ b/drivers/net/ethernet/sfc/net_driver.h
>>> @@ -998,6 +998,7 @@ struct efx_mae;
>>> * @netdev_notifier: Netdevice notifier.
>>> * @tc: state for TC offload (EF100).
>>> * @devlink: reference to devlink structure owned by this device
>>> + * @dl_port: devlink port associated with the PF
>>> * @mem_bar: The BAR that is mapped into membase.
>>> * @reg_base: Offset from the start of the bar to the function control window.
>>> * @monitor_work: Hardware monitor workitem
>>> @@ -1185,6 +1186,7 @@ struct efx_nic {
>>> struct efx_tc_state *tc;
>>>
>>> struct devlink *devlink;
>>> + struct devlink_port *dl_port;
>>> unsigned int mem_bar;
>>> u32 reg_base;
>>>
>>> -- 
>>> 2.17.1
>>>
>
>
>
