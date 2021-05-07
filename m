Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7A53769C8
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 20:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhEGSD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 14:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhEGSDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 14:03:23 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6408C061763
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 11:02:22 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id k4-20020a7bc4040000b02901331d89fb83so5361610wmi.5
        for <netdev@vger.kernel.org>; Fri, 07 May 2021 11:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6WaY4pVAVSE7k5sWek9O02LRoiCnBednbccg5OutEtk=;
        b=o8Ia9SB3K0JITQ6zeDDI/TLmIyHmniuv5hb7HD+J2MUG/Sl20tTOpa/HOENrhDlveh
         zBk78kfEPl0qN5AgGc1HquPwVJgyaP48EyhhkpBmWhJMA9uS0kf71k2CvH2BTP8YGNR9
         g/NEuyk/r/B4zvEoJhGfn1qyIHfv/0nuuIP090SAky+CfTGXbVGVodDkGIVvI7KDgwU4
         UPIfm32MWYpR1rlRbh7vbbKN8w6pel21k3KCiQgJ9ITK+j1TjW8KDWJdGry82I+5qaeI
         XHKY4XSTtiFXrkDans8ianFUV0U9C6bC0e/XIAa0vFui+Mdjare6eLu7+rn8XGcWaRMh
         qvEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6WaY4pVAVSE7k5sWek9O02LRoiCnBednbccg5OutEtk=;
        b=AEle3RiPy0SAIP3SXrhB1rxbfBvhnre1v/4zkld3WHzvWxFlvTe+1M8vvmHDlEYQ1f
         v1saD9xwfmSWTBhmYbzR1nmMv7Rmf7VYDCw3vJn9LFZVARNt9o8YQecTtrX4+EPscfRN
         nRfTiEH7ptF7kx03pRx7H/bjCSIOd4ftte6pWVz1PY/suoQx5UE+KEAWV3QbpsJYIBwy
         12d78USFcnNLihIhD+xRerUBZOnb+3Pm4Jn7sXZmagIuX6Os1W29FV1oiqMj/n8iyP+Z
         MwQJzDgNwlZYM824cUOElTyB9fLs60Ny9N/OtOqgfSp1+63y2Hkkv2DHCHiuUNHYmLhh
         utiA==
X-Gm-Message-State: AOAM532MXOP7FiLgDozxOXChWbPbI4N8O+ekjjKAk+LW01lpyqRpMgVW
        KZ+XNhDPEmSSR6UQ55PMJ/AkY97a9h7jXCYozekBifhV912LMw==
X-Google-Smtp-Source: ABdhPJxPTUgyinlPAJ/TRIzVHgI+iG0RLQ5iMDQPozOfgrtqz0iDspAucw05ISx6Xc9BTyAKs0y/vm+KRvHjnuvtB7Y=
X-Received: by 2002:a05:600c:3643:: with SMTP id y3mr22148743wmq.159.1620410541567;
 Fri, 07 May 2021 11:02:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210507174755.98849-1-cforno12@linux.ibm.com>
In-Reply-To: <20210507174755.98849-1-cforno12@linux.ibm.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Fri, 7 May 2021 13:02:10 -0500
Message-ID: <CAOhMmr7AZ_9X+XJDgakjx_p5ZGFyinCnQgkju31+mPYW2Dy5tQ@mail.gmail.com>
Subject: Re: [PATCH, net-next, v2] ibmvnic: Allow device probe if the device
 is not ready at boot
To:     Cristobal Forno <cforno12@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 7, 2021 at 12:53 PM Cristobal Forno <cforno12@linux.ibm.com> wrote:
>
> Allow the device to be initialized at a later time if
> it is not available at boot. The device will be allowed to probe but
> will be given a "down" state. After completing device probe and
> registering the net device, the driver will await an interrupt signal
> from its partner device, indicating that it is ready for boot. The
> driver will schedule a work event to perform the necessary procedure
> and begin operation.
>
> Co-developed-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> Signed-off-by: Cristobal Forno <cforno12@linux.ibm.com>
>
> ---
> v2:
>  - Correctly format the Co-developed-by tag
>  - CC all the maintainers
>  - tag patch as net-next
> ---

Hi Cris,

I think this is a good feature to be enabled. It looks good to me.
Please repost when net-next is reopened, around next Tuesday or so.
http://vger.kernel.org/~davem/net-next.html

Acked-by: Lijun Pan <lijunp213@gmail.com>

>  drivers/net/ethernet/ibm/ibmvnic.c | 153 ++++++++++++++++++++++++-----
>  drivers/net/ethernet/ibm/ibmvnic.h |   6 +-
>  2 files changed, 132 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index 5788bb956d73..b12f0beb4892 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -141,6 +141,29 @@ static const struct ibmvnic_stat ibmvnic_stats[] = {
>         {"internal_mac_rx_errors", IBMVNIC_STAT_OFF(internal_mac_rx_errors)},
>  };
>
> +static int send_crq_init_complete(struct ibmvnic_adapter *adapter)
> +{
> +       union ibmvnic_crq crq;
> +
> +       memset(&crq, 0, sizeof(crq));
> +       crq.generic.first = IBMVNIC_CRQ_INIT_CMD;
> +       crq.generic.cmd = IBMVNIC_CRQ_INIT_COMPLETE;
> +
> +       return ibmvnic_send_crq(adapter, &crq);
> +}
> +
> +static int send_version_xchg(struct ibmvnic_adapter *adapter)
> +{
> +       union ibmvnic_crq crq;
> +
> +       memset(&crq, 0, sizeof(crq));
> +       crq.version_exchange.first = IBMVNIC_CRQ_CMD;
> +       crq.version_exchange.cmd = VERSION_EXCHANGE;
> +       crq.version_exchange.version = cpu_to_be16(ibmvnic_version);
> +
> +       return ibmvnic_send_crq(adapter, &crq);
> +}
> +
>  static long h_reg_sub_crq(unsigned long unit_address, unsigned long token,
>                           unsigned long length, unsigned long *number,
>                           unsigned long *irq)
> @@ -2085,10 +2108,10 @@ static int do_reset(struct ibmvnic_adapter *adapter,
>                         goto out;
>                 }
>
> -               /* If the adapter was in PROBE state prior to the reset,
> +               /* If the adapter was in PROBE or DOWN state prior to the reset,
>                  * exit here.
>                  */
> -               if (reset_state == VNIC_PROBED) {
> +               if (reset_state == VNIC_PROBED || reset_state == VNIC_DOWN) {
>                         rc = 0;
>                         goto out;
>                 }
> @@ -2214,10 +2237,10 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
>         if (rc)
>                 goto out;
>
> -       /* If the adapter was in PROBE state prior to the reset,
> +       /* If the adapter was in PROBE or DOWN state prior to the reset,
>          * exit here.
>          */
> -       if (reset_state == VNIC_PROBED)
> +       if (reset_state == VNIC_PROBED || reset_state == VNIC_DOWN)
>                 goto out;
>
>         rc = ibmvnic_login(netdev);
> @@ -2270,6 +2293,76 @@ static struct ibmvnic_rwi *get_next_rwi(struct ibmvnic_adapter *adapter)
>         return rwi;
>  }
>
> +/**
> + * do_passive_init - complete probing when partner device is detected.
> + * @adapter: ibmvnic_adapter struct
> + *
> + * If the ibmvnic device does not have a partner device to communicate with at boot
> + * and that partner device comes online at a later time, this function is called
> + * to complete the initialization process of ibmvnic device.
> + * Caller is expected to hold rtnl_lock().
> + *
> + * Returns non-zero if sub-CRQs are not initialized properly leaving the device
> + * in the down state.
> + * Returns 0 upon success and the device is in PROBED state.
> + */
> +
> +static int do_passive_init(struct ibmvnic_adapter *adapter)
> +{
> +       unsigned long timeout = msecs_to_jiffies(30000);
> +       struct net_device *netdev = adapter->netdev;
> +       struct device *dev = &adapter->vdev->dev;
> +       int rc;
> +
> +       netdev_dbg(netdev, "Partner device found, probing.\n");
> +
> +       adapter->state = VNIC_PROBING;
> +       reinit_completion(&adapter->init_done);
> +       adapter->init_done_rc = 0;
> +       adapter->crq.active = true;
> +
> +       rc = send_crq_init_complete(adapter);
> +       if (rc)
> +               goto out;
> +
> +       rc = send_version_xchg(adapter);
> +       if (rc)
> +               netdev_dbg(adapter->netdev, "send_version_xchg failed, rc=%d\n", rc);
> +
> +       if (!wait_for_completion_timeout(&adapter->init_done, timeout)) {
> +               dev_err(dev, "Initialization sequence timed out\n");
> +               rc = -ETIMEDOUT;
> +               goto out;
> +       }
> +
> +       rc = init_sub_crqs(adapter);
> +       if (rc) {
> +               dev_err(dev, "Initialization of sub crqs failed, rc=%d\n", rc);
> +               goto out;
> +       }
> +
> +       rc = init_sub_crq_irqs(adapter);
> +       if (rc) {
> +               dev_err(dev, "Failed to initialize sub crq irqs\n, rc=%d", rc);
> +               goto init_failed;
> +       }
> +
> +       netdev->mtu = adapter->req_mtu - ETH_HLEN;
> +       netdev->min_mtu = adapter->min_mtu - ETH_HLEN;
> +       netdev->max_mtu = adapter->max_mtu - ETH_HLEN;
> +
> +       adapter->state = VNIC_PROBED;
> +       netdev_dbg(netdev, "Probed successfully. Waiting for signal from partner device.\n");
> +
> +       return 0;
> +
> +init_failed:
> +       release_sub_crqs(adapter, 1);
> +out:
> +       adapter->state = VNIC_DOWN;
> +       return rc;
> +}
> +
>  static void __ibmvnic_reset(struct work_struct *work)
>  {
>         struct ibmvnic_rwi *rwi;
> @@ -2306,7 +2399,13 @@ static void __ibmvnic_reset(struct work_struct *work)
>                 }
>                 spin_unlock_irqrestore(&adapter->state_lock, flags);
>
> -               if (adapter->force_reset_recovery) {
> +               if (rwi->reset_reason == VNIC_RESET_PASSIVE_INIT) {
> +                       rtnl_lock();
> +                       rc = do_passive_init(adapter);
> +                       rtnl_unlock();
> +                       if (!rc)
> +                               netif_carrier_on(adapter->netdev);
> +               } else if (adapter->force_reset_recovery) {
>                         /* Since we are doing a hard reset now, clear the
>                          * failover_pending flag so we don't ignore any
>                          * future MOBILITY or other resets.
> @@ -3776,18 +3875,6 @@ static int ibmvnic_send_crq_init(struct ibmvnic_adapter *adapter)
>         return 0;
>  }
>
> -static int send_version_xchg(struct ibmvnic_adapter *adapter)
> -{
> -       union ibmvnic_crq crq;
> -
> -       memset(&crq, 0, sizeof(crq));
> -       crq.version_exchange.first = IBMVNIC_CRQ_CMD;
> -       crq.version_exchange.cmd = VERSION_EXCHANGE;
> -       crq.version_exchange.version = cpu_to_be16(ibmvnic_version);
> -
> -       return ibmvnic_send_crq(adapter, &crq);
> -}
> -
>  struct vnic_login_client_data {
>         u8      type;
>         __be16  len;
> @@ -4907,7 +4994,12 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
>                                 complete(&adapter->init_done);
>                                 adapter->init_done_rc = -EIO;
>                         }
> -                       rc = ibmvnic_reset(adapter, VNIC_RESET_FAILOVER);
> +
> +                       if (adapter->state == VNIC_DOWN)
> +                               rc = ibmvnic_reset(adapter, VNIC_RESET_PASSIVE_INIT);
> +                       else
> +                               rc = ibmvnic_reset(adapter, VNIC_RESET_FAILOVER);
> +
>                         if (rc && rc != -EBUSY) {
>                                 /* We were unable to schedule the failover
>                                  * reset either because the adapter was still
> @@ -5330,6 +5422,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
>         struct ibmvnic_adapter *adapter;
>         struct net_device *netdev;
>         unsigned char *mac_addr_p;
> +       bool init_success;
>         int rc;
>
>         dev_dbg(&dev->dev, "entering ibmvnic_probe for UA 0x%x\n",
> @@ -5376,6 +5469,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
>         init_completion(&adapter->stats_done);
>         clear_bit(0, &adapter->resetting);
>
> +       init_success = false;
>         do {
>                 rc = init_crq_queue(adapter);
>                 if (rc) {
> @@ -5385,10 +5479,16 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
>                 }
>
>                 rc = ibmvnic_reset_init(adapter, false);
> -               if (rc && rc != EAGAIN)
> -                       goto ibmvnic_init_fail;
>         } while (rc == EAGAIN);
>
> +       /* We are ignoring the error from ibmvnic_reset_init() assuming that the
> +        * partner is not ready. CRQ is not active. When the partner becomes
> +        * ready, we will do the passive init reset.
> +        */
> +
> +       if (!rc)
> +               init_success = true;
> +
>         rc = init_stats_buffers(adapter);
>         if (rc)
>                 goto ibmvnic_init_fail;
> @@ -5397,10 +5497,6 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
>         if (rc)
>                 goto ibmvnic_stats_fail;
>
> -       netdev->mtu = adapter->req_mtu - ETH_HLEN;
> -       netdev->min_mtu = adapter->min_mtu - ETH_HLEN;
> -       netdev->max_mtu = adapter->max_mtu - ETH_HLEN;
> -
>         rc = device_create_file(&dev->dev, &dev_attr_failover);
>         if (rc)
>                 goto ibmvnic_dev_file_err;
> @@ -5413,7 +5509,14 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
>         }
>         dev_info(&dev->dev, "ibmvnic registered\n");
>
> -       adapter->state = VNIC_PROBED;
> +       if (init_success) {
> +               adapter->state = VNIC_PROBED;
> +               netdev->mtu = adapter->req_mtu - ETH_HLEN;
> +               netdev->min_mtu = adapter->min_mtu - ETH_HLEN;
> +               netdev->max_mtu = adapter->max_mtu - ETH_HLEN;
> +       } else {
> +               adapter->state = VNIC_DOWN;
> +       }
>
>         adapter->wait_for_reset = false;
>         adapter->last_reset_time = jiffies;
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
> index c1d39a748546..22df602323bc 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.h
> +++ b/drivers/net/ethernet/ibm/ibmvnic.h
> @@ -851,14 +851,16 @@ enum vnic_state {VNIC_PROBING = 1,
>                  VNIC_CLOSING,
>                  VNIC_CLOSED,
>                  VNIC_REMOVING,
> -                VNIC_REMOVED};
> +                VNIC_REMOVED,
> +                VNIC_DOWN};
>
>  enum ibmvnic_reset_reason {VNIC_RESET_FAILOVER = 1,
>                            VNIC_RESET_MOBILITY,
>                            VNIC_RESET_FATAL,
>                            VNIC_RESET_NON_FATAL,
>                            VNIC_RESET_TIMEOUT,
> -                          VNIC_RESET_CHANGE_PARAM};
> +                          VNIC_RESET_CHANGE_PARAM,
> +                          VNIC_RESET_PASSIVE_INIT};
>
>  struct ibmvnic_rwi {
>         enum ibmvnic_reset_reason reset_reason;
> --
> 2.30.0
>
