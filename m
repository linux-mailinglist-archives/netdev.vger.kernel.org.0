Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE42541394C
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 19:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbhIUR5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 13:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbhIUR5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 13:57:36 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3C8C061574;
        Tue, 21 Sep 2021 10:56:07 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id g16so14012813uam.7;
        Tue, 21 Sep 2021 10:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y176f/MYPWiy0hfSgFjuU3HZBrQ4ARfzzGQrSozSjxY=;
        b=SqiSQPDHLS5TENHsj/WxWGXCSwiFfvMOUdhXOONM7tPBwrc26Pup3/q8Tt8YT1AaFL
         hwA78OEYVD/eRvMwW0hAZdUNIFuQB92AcAtfDEDnMKCJiDoXB1jnMf4oSwmk+bOxQTFF
         SRBa8LQtvw8gJ9kO7I16S+ap5/3jOLMbhLCJzt1FFml/y8ceOU5jFP+Tzn0R6bFXREYx
         KMy0B/vrQf/NLfLjR/W6zma1SxKxCnvAToklaLyhKbyGstYHMvcVLjq170+RxZOGpY6c
         SZl2hEXJlEduUd4ts/lX2TTbK8Hos9CgN2zXrJI2WI+MRAb5uwQbTRoB2se7TB3fKBDi
         xJSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y176f/MYPWiy0hfSgFjuU3HZBrQ4ARfzzGQrSozSjxY=;
        b=XwqxzkJ6agCl01yOXwf2r7fQd9yJOf3gT0xTcHRd9Pfh0bj+/wc42LxO73AKJIUvBg
         hhk0xTLCzvMxMlKAinGIJnh8OpMjIZ2IwFzJtMLq3p8OPzxIy7h3w0CUHSFTQPUSbcFd
         vKuVtwLxdrMiVC9NwoE1jyo6OgLoKB5LsHzv7W4G5ShcsqJ8o6pdYE3bdFSR+WNxXYpK
         cj3iADMTvgAbgUFgl5Q4+peHP9QMvUgYnWF0UrM1/GJ/6uKlzsFzdAsLKRoxxtCIZDhR
         kMeV/P8YpqYiNLzO+r+p2UuHwWjIUivW3CAWAzXUyF5tAtYvfXYt6O2b9H+pf9jcZwVg
         r4Kg==
X-Gm-Message-State: AOAM533Mwm4Ce2U8jC9m6g3sGTz1Zt8z4EsJvqteHi7tK2P+vX9dX4Bt
        mDqXqAa+VmCMjNWff6QvN+8VFh3q6Ugivh5Zg7pVudoy
X-Google-Smtp-Source: ABdhPJx4cNeD0eI+AxQUDx5y8hIoSFmkv9KxX2AcKEvDD00dI0yj3i0dWGsmPpEysz1FIyWnZs5pk1ewa/47mcu8wuA=
X-Received: by 2002:ab0:6616:: with SMTP id r22mr17308714uam.129.1632246966380;
 Tue, 21 Sep 2021 10:56:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210921085652.v2.1.Ib31940aba2253e3f25cbca09a2d977d27170e163@changeid>
In-Reply-To: <20210921085652.v2.1.Ib31940aba2253e3f25cbca09a2d977d27170e163@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 21 Sep 2021 10:55:55 -0700
Message-ID: <CABBYNZLkMp1qLgwBVyU-V82W=M7MSPkZpsOFDGj1GKH=DB=5Ag@mail.gmail.com>
Subject: Re: [PATCH v2] bluetooth: Fix Advertisement Monitor Suspend/Resume
To:     Manish Mandlik <mmandlik@google.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Archie Pusaka <apusaka@google.com>,
        Miao-chen Chou <mcchou@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

On Tue, Sep 21, 2021 at 8:57 AM Manish Mandlik <mmandlik@google.com> wrote:
>
> During system suspend, advertisement monitoring is disabled by setting
> the HCI_VS_MSFT_LE_Set_Advertisement_Filter_Enable to False. This
> disables the monitoring during suspend, however, if the controller is
> monitoring a device, it sends HCI_VS_MSFT_LE_Monitor_Device_Event to
> indicate that the monitoring has been stopped for that particular
> device. This event may occur after suspend depending on the
> low_threshold_timeout and peer device advertisement frequency, which
> causes early wake up.
>
> Right way to disable the monitoring for suspend is by removing all the
> monitors before suspend and re-monitor after resume to ensure no events
> are received during suspend. This patch fixes this suspend/resume issue.
>
> Following tests are performed:
> - Add monitors before suspend and make sure DeviceFound gets triggered
> - Suspend the system and verify that all monitors are removed by kernel
>   but not Released by bluetoothd
> - Wake up and verify that all monitors are added again and DeviceFound
>   gets triggered
>
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> Reviewed-by: Archie Pusaka <apusaka@google.com>
> Reviewed-by: Miao-chen Chou <mcchou@google.com>
> ---
>
> Changes in v2:
> - Updated the Reviewd-by names
>
>  net/bluetooth/hci_request.c |  15 +++--
>  net/bluetooth/msft.c        | 117 +++++++++++++++++++++++++++++++-----
>  net/bluetooth/msft.h        |   5 ++
>  3 files changed, 116 insertions(+), 21 deletions(-)
>
> diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
> index 47fb665277d4..c018a172ced3 100644
> --- a/net/bluetooth/hci_request.c
> +++ b/net/bluetooth/hci_request.c
> @@ -1281,21 +1281,24 @@ static void suspend_req_complete(struct hci_dev *hdev, u8 status, u16 opcode)
>         }
>  }
>
> -static void hci_req_add_set_adv_filter_enable(struct hci_request *req,
> -                                             bool enable)
> +static void hci_req_prepare_adv_monitor_suspend(struct hci_request *req,
> +                                               bool suspending)
>  {
>         struct hci_dev *hdev = req->hdev;
>
>         switch (hci_get_adv_monitor_offload_ext(hdev)) {
>         case HCI_ADV_MONITOR_EXT_MSFT:
> -               msft_req_add_set_filter_enable(req, enable);
> +               if (suspending)
> +                       msft_remove_all_monitors_on_suspend(hdev);
> +               else
> +                       msft_reregister_monitors_on_resume(hdev);
>                 break;
>         default:
>                 return;
>         }
>
>         /* No need to block when enabling since it's on resume path */
> -       if (hdev->suspended && !enable)
> +       if (hdev->suspended && suspending)
>                 set_bit(SUSPEND_SET_ADV_FILTER, hdev->suspend_tasks);
>  }
>
> @@ -1362,7 +1365,7 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
>                 }
>
>                 /* Disable advertisement filters */
> -               hci_req_add_set_adv_filter_enable(&req, false);
> +               hci_req_prepare_adv_monitor_suspend(&req, true);
>
>                 /* Prevent disconnects from causing scanning to be re-enabled */
>                 hdev->scanning_paused = true;
> @@ -1404,7 +1407,7 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
>                 /* Reset passive/background scanning to normal */
>                 __hci_update_background_scan(&req);
>                 /* Enable all of the advertisement filters */
> -               hci_req_add_set_adv_filter_enable(&req, true);
> +               hci_req_prepare_adv_monitor_suspend(&req, false);
>
>                 /* Unpause directed advertising */
>                 hdev->advertising_paused = false;
> diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
> index 21b1787e7893..328d5e341f9a 100644
> --- a/net/bluetooth/msft.c
> +++ b/net/bluetooth/msft.c
> @@ -94,11 +94,14 @@ struct msft_data {
>         __u16 pending_add_handle;
>         __u16 pending_remove_handle;
>         __u8 reregistering;
> +       __u8 suspending;
>         __u8 filter_enabled;
>  };
>
>  static int __msft_add_monitor_pattern(struct hci_dev *hdev,
>                                       struct adv_monitor *monitor);
> +static int __msft_remove_monitor(struct hci_dev *hdev,
> +                                struct adv_monitor *monitor, u16 handle);
>
>  bool msft_monitor_supported(struct hci_dev *hdev)
>  {
> @@ -154,7 +157,7 @@ static bool read_supported_features(struct hci_dev *hdev,
>  }
>
>  /* This function requires the caller holds hdev->lock */
> -static void reregister_monitor_on_restart(struct hci_dev *hdev, int handle)
> +static void reregister_monitor(struct hci_dev *hdev, int handle)
>  {
>         struct adv_monitor *monitor;
>         struct msft_data *msft = hdev->msft_data;
> @@ -182,6 +185,69 @@ static void reregister_monitor_on_restart(struct hci_dev *hdev, int handle)
>         }
>  }
>
> +/* This function requires the caller holds hdev->lock */
> +static void remove_monitor_on_suspend(struct hci_dev *hdev, int handle)
> +{
> +       struct adv_monitor *monitor;
> +       struct msft_data *msft = hdev->msft_data;
> +       int err;
> +
> +       while (1) {
> +               monitor = idr_get_next(&hdev->adv_monitors_idr, &handle);
> +               if (!monitor) {
> +                       /* All monitors have been removed */
> +                       msft->suspending = false;
> +                       hci_update_background_scan(hdev);
> +                       return;
> +               }
> +
> +               msft->pending_remove_handle = (u16)handle;
> +               err = __msft_remove_monitor(hdev, monitor, handle);
> +
> +               /* If success, return and wait for monitor removed callback */
> +               if (!err)
> +                       return;

Not sure I follow this one, why you are not continuing removing the
other ones? Also doesn't adv monitor have a way to clear all monitors
at once?

> +
> +               /* Otherwise free the monitor and keep removing */
> +               hci_free_adv_monitor(hdev, monitor);
> +               handle++;
> +       }
> +}
> +
> +/* This function requires the caller holds hdev->lock */
> +void msft_remove_all_monitors_on_suspend(struct hci_dev *hdev)
> +{
> +       struct msft_data *msft = hdev->msft_data;
> +
> +       if (!msft)
> +               return;
> +
> +       if (msft_monitor_supported(hdev)) {
> +               msft->suspending = true;
> +               /* Quitely remove all monitors on suspend to avoid waking up
> +                * the system.
> +                */

The above comment suggests it would remove all monitors, not just one.

> +               remove_monitor_on_suspend(hdev, 0);
> +       }
> +}
> +
> +/* This function requires the caller holds hdev->lock */
> +void msft_reregister_monitors_on_resume(struct hci_dev *hdev)
> +{
> +       struct msft_data *msft = hdev->msft_data;
> +
> +       if (!msft)
> +               return;
> +
> +       if (msft_monitor_supported(hdev)) {
> +               msft->reregistering = true;
> +               /* Monitors are removed on suspend, so we need to add all
> +                * monitors on resume.
> +                */
> +               reregister_monitor(hdev, 0);
> +       }
> +}
> +
>  void msft_do_open(struct hci_dev *hdev)
>  {
>         struct msft_data *msft = hdev->msft_data;
> @@ -214,7 +280,7 @@ void msft_do_open(struct hci_dev *hdev)
>                 /* Monitors get removed on power off, so we need to explicitly
>                  * tell the controller to re-monitor.
>                  */
> -               reregister_monitor_on_restart(hdev, 0);
> +               reregister_monitor(hdev, 0);
>         }
>  }
>
> @@ -382,8 +448,7 @@ static void msft_le_monitor_advertisement_cb(struct hci_dev *hdev,
>
>         /* If in restart/reregister sequence, keep registering. */
>         if (msft->reregistering)
> -               reregister_monitor_on_restart(hdev,
> -                                             msft->pending_add_handle + 1);
> +               reregister_monitor(hdev, msft->pending_add_handle + 1);
>
>         hci_dev_unlock(hdev);
>
> @@ -420,13 +485,25 @@ static void msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
>         if (handle_data) {
>                 monitor = idr_find(&hdev->adv_monitors_idr,
>                                    handle_data->mgmt_handle);
> -               if (monitor)
> +
> +               if (monitor && monitor->state == ADV_MONITOR_STATE_OFFLOADED)
> +                       monitor->state = ADV_MONITOR_STATE_REGISTERED;
> +
> +               /* Do not free the monitor if it is being removed due to
> +                * suspend. It will be re-monitored on resume.
> +                */
> +               if (monitor && !msft->suspending)
>                         hci_free_adv_monitor(hdev, monitor);
>
>                 list_del(&handle_data->list);
>                 kfree(handle_data);
>         }
>
> +       /* If in suspend/remove sequence, keep removing. */
> +       if (msft->suspending)
> +               remove_monitor_on_suspend(hdev,
> +                                         msft->pending_remove_handle + 1);
> +
>         /* If remove all monitors is required, we need to continue the process
>          * here because the earlier it was paused when waiting for the
>          * response from controller.
> @@ -445,7 +522,8 @@ static void msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
>         hci_dev_unlock(hdev);
>
>  done:
> -       hci_remove_adv_monitor_complete(hdev, status);
> +       if (!msft->suspending)
> +               hci_remove_adv_monitor_complete(hdev, status);
>  }
>
>  static void msft_le_set_advertisement_filter_enable_cb(struct hci_dev *hdev,
> @@ -578,15 +656,15 @@ int msft_add_monitor_pattern(struct hci_dev *hdev, struct adv_monitor *monitor)
>         if (!msft)
>                 return -EOPNOTSUPP;
>
> -       if (msft->reregistering)
> +       if (msft->reregistering || msft->suspending)
>                 return -EBUSY;
>
>         return __msft_add_monitor_pattern(hdev, monitor);
>  }
>
>  /* This function requires the caller holds hdev->lock */
> -int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
> -                       u16 handle)
> +static int __msft_remove_monitor(struct hci_dev *hdev,
> +                                struct adv_monitor *monitor, u16 handle)
>  {
>         struct msft_cp_le_cancel_monitor_advertisement cp;
>         struct msft_monitor_advertisement_handle_data *handle_data;
> @@ -594,12 +672,6 @@ int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
>         struct msft_data *msft = hdev->msft_data;
>         int err = 0;
>
> -       if (!msft)
> -               return -EOPNOTSUPP;
> -
> -       if (msft->reregistering)
> -               return -EBUSY;
> -
>         handle_data = msft_find_handle_data(hdev, monitor->handle, true);
>
>         /* If no matched handle, just remove without telling controller */
> @@ -619,6 +691,21 @@ int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
>         return err;
>  }
>
> +/* This function requires the caller holds hdev->lock */
> +int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
> +                       u16 handle)
> +{
> +       struct msft_data *msft = hdev->msft_data;
> +
> +       if (!msft)
> +               return -EOPNOTSUPP;
> +
> +       if (msft->reregistering || msft->suspending)
> +               return -EBUSY;
> +
> +       return __msft_remove_monitor(hdev, monitor, handle);
> +}
> +
>  void msft_req_add_set_filter_enable(struct hci_request *req, bool enable)
>  {
>         struct hci_dev *hdev = req->hdev;
> diff --git a/net/bluetooth/msft.h b/net/bluetooth/msft.h
> index 8018948c5975..6ec843b94d16 100644
> --- a/net/bluetooth/msft.h
> +++ b/net/bluetooth/msft.h
> @@ -24,6 +24,8 @@ int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
>                         u16 handle);
>  void msft_req_add_set_filter_enable(struct hci_request *req, bool enable);
>  int msft_set_filter_enable(struct hci_dev *hdev, bool enable);
> +void msft_remove_all_monitors_on_suspend(struct hci_dev *hdev);
> +void msft_reregister_monitors_on_resume(struct hci_dev *hdev);

I'd go with msft_suspend and msft_resume, that should be enough to
indicate what their intent are.

>  bool msft_curve_validity(struct hci_dev *hdev);
>
>  #else
> @@ -59,6 +61,9 @@ static inline int msft_set_filter_enable(struct hci_dev *hdev, bool enable)
>         return -EOPNOTSUPP;
>  }
>
> +void msft_remove_all_monitors_on_suspend(struct hci_dev *hdev) {}
> +void msft_reregister_monitors_on_resume(struct hci_dev *hdev) {}
> +
>  static inline bool msft_curve_validity(struct hci_dev *hdev)
>  {
>         return false;
> --
> 2.33.0.464.g1972c5931b-goog
>


-- 
Luiz Augusto von Dentz
