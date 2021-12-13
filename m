Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51F24732CD
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 18:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240216AbhLMRVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 12:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236018AbhLMRVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 12:21:10 -0500
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B62C061574;
        Mon, 13 Dec 2021 09:21:10 -0800 (PST)
Received: by mail-ua1-x92f.google.com with SMTP id n6so30469232uak.1;
        Mon, 13 Dec 2021 09:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0wJeJrSF9Mra0gCsmyTZmFusMoi1eRBEtRdMCYndmKo=;
        b=iaK/AIvhlQL9v9NK6cmbiG44uZnl2jk4+C98eP8aEqLSE+8/H+XtHXJ5yUZCrZq+/u
         PMe50c7tFFG8qSckZy+aEHnHS5Cb5uNkUzaatYiNypkk8HFroBVg5lqo8p4JmBkDeNJ4
         OLmXwDKJ5E1XQ36xPL6nDv/YdNKPJwFtGgtoCdQyQ/MSnxC5cxUf2ISfrL7DlEJ6ijf+
         K5juseNzPVcsn+MuV+g3WQP/J7wUxj9hxtZj8fk3WFVFUlaPWkAST7z3EqXesDKIRIRy
         aoVAPs8UAFW0N0HvGpzqVzKRqWROly8feDvruoG6xXEKLP3W5x0JMkzrLRgIkiycQwGI
         KFKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0wJeJrSF9Mra0gCsmyTZmFusMoi1eRBEtRdMCYndmKo=;
        b=Sjbc/VaFec+fXGV7pNIvGt8yTTQy6lmwiUCZK8Ywt9+tKLl/9SSjO0tM+KH2f92lEw
         waYtkY54fQ8Han8LuwyuiDL3X/PB1PaXKbBP6QbqZV3/8AWoFQCiVkd68Jv1ePAtNr5p
         34c0RpCElZsq+bvMfX9iBPBm2SAMlZS1OxnzmHdAQ+liVv/hZxbdlFJBQHHW+WHGjWDs
         OpLtfTuuQkd0kGS1MPPaUDwzg0l5PYWpfc1KbsCa8f+dklfBr0O/oliAu9U0T4ybMUXS
         dKNsYuIrgrh3+lzmK6F5DPMRbC5idQK1QRpehZWwmE7P8tAzM0C2Z2SAYWoic3Jsok9g
         25Wg==
X-Gm-Message-State: AOAM530prqe8tEpTWGx8Kxv1CcFyaSUJYzc0EzvIXWLWEGG1VSyUuM3m
        3GsECLg7fuSB4m6+YMk/nIa7QyDU6UndN9+jMwg=
X-Google-Smtp-Source: ABdhPJw4EvbNTlJviy0T8PvZmLVL9xI6zB6kyh3Vapljc21/dsvg0nhrsA9kah1XuNpNPZN8WbO44Y/iauHmvI+sxOY=
X-Received: by 2002:a67:e0d6:: with SMTP id m22mr28970882vsl.15.1639416067450;
 Mon, 13 Dec 2021 09:21:07 -0800 (PST)
MIME-Version: 1.0
References: <20211202231123.v7.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
 <20211202231123.v7.2.I9eda306e4c542010535dc49b5488946af592795e@changeid>
 <CABBYNZJPEhALUyevLAAP9Nhzda8M0emmsPwaXCcQWOSD+ytm5A@mail.gmail.com> <CAGPPCLDreZm2m_ZmymVumu5s1tDeXi7-UGFDFnxd8ZuzW6oVPA@mail.gmail.com>
In-Reply-To: <CAGPPCLDreZm2m_ZmymVumu5s1tDeXi7-UGFDFnxd8ZuzW6oVPA@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 13 Dec 2021 09:20:56 -0800
Message-ID: <CABBYNZKxaKtHYyAjxHVOqiKqLDhULtJAwa+AwgbT3_32ceho6g@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] bluetooth: Add MGMT Adv Monitor Device Found/Lost events
To:     Manish Mandlik <mmandlik@google.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
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

On Mon, Dec 6, 2021 at 8:39 AM Manish Mandlik <mmandlik@google.com> wrote:
>
> Hi Luiz,
>
> On Fri, Dec 3, 2021 at 5:19 PM Luiz Augusto von Dentz <luiz.dentz@gmail.com> wrote:
>>
>> Hi Manish,
>>
>> On Thu, Dec 2, 2021 at 11:16 PM Manish Mandlik <mmandlik@google.com> wrote:
>> >
>> > This patch introduces two new MGMT events for notifying the bluetoothd
>> > whenever the controller starts/stops monitoring a device.
>> >
>> > Test performed:
>> > - Verified by logs that the MSFT Monitor Device is received from the
>> >   controller and the bluetoothd is notified whenever the controller
>> >   starts/stops monitoring a device.
>> >
>> > Signed-off-by: Manish Mandlik <mmandlik@google.com>
>> > Reviewed-by: Miao-chen Chou <mcchou@google.com>
>> >
>> > ---
>> >
>> > Changes in v7:
>> > - Refactor mgmt_device_found() to fix stack frame size limit
>> >
>> > Changes in v6:
>> > - Fix compiler warning for mgmt_adv_monitor_device_found().
>> >
>> > Changes in v5:
>> > - New patch in the series. Split previous patch into two.
>> > - Update the Device Found logic to send existing Device Found event or
>> >   Adv Monitor Device Found event depending on the active scanning state.
>> >
>> >  include/net/bluetooth/hci_core.h |   3 +
>> >  include/net/bluetooth/mgmt.h     |  16 +++++
>> >  net/bluetooth/mgmt.c             | 106 +++++++++++++++++++++++++++++--
>> >  net/bluetooth/msft.c             |  15 ++++-
>> >  4 files changed, 134 insertions(+), 6 deletions(-)
>> >
>> > diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
>> > index 5ccd19dec77c..3b53214ff49f 100644
>> > --- a/include/net/bluetooth/hci_core.h
>> > +++ b/include/net/bluetooth/hci_core.h
>> > @@ -599,6 +599,7 @@ struct hci_dev {
>> >         struct delayed_work     interleave_scan;
>> >
>> >         struct list_head        monitored_devices;
>> > +       bool                    advmon_pend_notify;
>> >
>> >  #if IS_ENABLED(CONFIG_BT_LEDS)
>> >         struct led_trigger      *power_led;
>> > @@ -1847,6 +1848,8 @@ void mgmt_adv_monitor_removed(struct hci_dev *hdev, u16 handle);
>> >  int mgmt_phy_configuration_changed(struct hci_dev *hdev, struct sock *skip);
>> >  int mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status);
>> >  int mgmt_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status);
>> > +void mgmt_adv_monitor_device_lost(struct hci_dev *hdev, u16 handle,
>> > +                                 bdaddr_t *bdaddr, u8 addr_type);
>> >
>> >  u8 hci_le_conn_update(struct hci_conn *conn, u16 min, u16 max, u16 latency,
>> >                       u16 to_multiplier);
>> > diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
>> > index 107b25deae68..99266f7aebdc 100644
>> > --- a/include/net/bluetooth/mgmt.h
>> > +++ b/include/net/bluetooth/mgmt.h
>> > @@ -1104,3 +1104,19 @@ struct mgmt_ev_controller_resume {
>> >  #define MGMT_WAKE_REASON_NON_BT_WAKE           0x0
>> >  #define MGMT_WAKE_REASON_UNEXPECTED            0x1
>> >  #define MGMT_WAKE_REASON_REMOTE_WAKE           0x2
>> > +
>> > +#define MGMT_EV_ADV_MONITOR_DEVICE_FOUND       0x002f
>> > +struct mgmt_ev_adv_monitor_device_found {
>> > +       __le16 monitor_handle;
>> > +       struct mgmt_addr_info addr;
>> > +       __s8   rssi;
>> > +       __le32 flags;
>> > +       __le16 eir_len;
>> > +       __u8   eir[0];
>> > +} __packed;
>> > +
>> > +#define MGMT_EV_ADV_MONITOR_DEVICE_LOST                0x0030
>> > +struct mgmt_ev_adv_monitor_device_lost {
>> > +       __le16 monitor_handle;
>> > +       struct mgmt_addr_info addr;
>> > +} __packed;
>> > diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
>> > index bf989ae03f9f..06e0769f350d 100644
>> > --- a/net/bluetooth/mgmt.c
>> > +++ b/net/bluetooth/mgmt.c
>> > @@ -174,6 +174,8 @@ static const u16 mgmt_events[] = {
>> >         MGMT_EV_ADV_MONITOR_REMOVED,
>> >         MGMT_EV_CONTROLLER_SUSPEND,
>> >         MGMT_EV_CONTROLLER_RESUME,
>> > +       MGMT_EV_ADV_MONITOR_DEVICE_FOUND,
>> > +       MGMT_EV_ADV_MONITOR_DEVICE_LOST,
>> >  };
>> >
>> >  static const u16 mgmt_untrusted_commands[] = {
>> > @@ -9524,6 +9526,100 @@ static bool is_filter_match(struct hci_dev *hdev, s8 rssi, u8 *eir,
>> >         return true;
>> >  }
>> >
>> > +void mgmt_adv_monitor_device_lost(struct hci_dev *hdev, u16 handle,
>> > +                                 bdaddr_t *bdaddr, u8 addr_type)
>> > +{
>> > +       struct mgmt_ev_adv_monitor_device_lost ev;
>> > +
>> > +       ev.monitor_handle = cpu_to_le16(handle);
>> > +       bacpy(&ev.addr.bdaddr, bdaddr);
>> > +       ev.addr.type = addr_type;
>> > +
>> > +       mgmt_event(MGMT_EV_ADV_MONITOR_DEVICE_LOST, hdev, &ev, sizeof(ev),
>> > +                  NULL);
>> > +}
>> > +
>> > +static void mgmt_adv_monitor_device_found(struct hci_dev *hdev,
>> > +                                         struct mgmt_ev_device_found *ev,
>> > +                                         size_t ev_size, bool discovering)
>> > +{
>> > +       char buf[518];
>>
>> We should try to avoid declaring such big stack variable, instead Im
>> working on a set the should enable you to use skb_put/skb_put_data
>> directly into the skb, here are the current changes I have for
>> device_found:
>>
>> https://gist.github.com/Vudentz/ffce584912eb7dc4add9c3bb25466fa5
>>
>> I'm addressing Marcel's comments and will send the set to the list later today.
>
> Please let me know once these changes land bluetooth-next, I'll update my patch and send out the new revision.

Those changes are already in bluetooth-next.

>>
>>
>> > +       struct mgmt_ev_adv_monitor_device_found *advmon_ev = (void *)buf;
>> > +       size_t advmon_ev_size;
>> > +       struct monitored_device *dev, *tmp;
>> > +       bool matched = false;
>> > +       bool notified = false;
>> > +
>> > +       /* We have received the Advertisement Report because:
>> > +        * 1. the kernel has initiated active discovery
>> > +        * 2. if not, we have pend_le_reports > 0 in which case we are doing
>> > +        *    passive scanning
>> > +        * 3. if none of the above is true, we have one or more active
>> > +        *    Advertisement Monitor
>> > +        *
>> > +        * For case 1 and 2, report all advertisements via MGMT_EV_DEVICE_FOUND
>> > +        * and report ONLY one advertisement per device for the matched Monitor
>> > +        * via MGMT_EV_ADV_MONITOR_DEVICE_FOUND event.
>> > +        *
>> > +        * For case 3, since we are not active scanning and all advertisements
>> > +        * received are due to a matched Advertisement Monitor, report all
>> > +        * advertisements ONLY via MGMT_EV_ADV_MONITOR_DEVICE_FOUND event.
>> > +        */
>> > +       if (discovering) {
>> > +               mgmt_event(MGMT_EV_DEVICE_FOUND, hdev, ev, ev_size, NULL);
>> > +
>> > +               if (!hdev->advmon_pend_notify)
>> > +                       return;
>> > +       }
>> > +
>> > +       /* Make sure that the buffer is big enough */
>> > +       advmon_ev_size = ev_size + (sizeof(*advmon_ev) - sizeof(*ev));
>> > +       if (advmon_ev_size > sizeof(buf))
>> > +               return;
>> > +
>> > +       /* ADV_MONITOR_DEVICE_FOUND is similar to DEVICE_FOUND event except
>> > +        * that it also has 'monitor_handle'. Make a copy of DEVICE_FOUND and
>> > +        * store monitor_handle of the matched monitor.
>> > +        */
>> > +       memcpy(&advmon_ev->addr, ev, ev_size);
>> > +
>> > +       hdev->advmon_pend_notify = false;
>> > +
>> > +       list_for_each_entry_safe(dev, tmp, &hdev->monitored_devices, list) {
>> > +               if (!bacmp(&dev->bdaddr, &advmon_ev->addr.bdaddr)) {
>> > +                       matched = true;
>> > +
>> > +                       if (!dev->notified) {
>> > +                               advmon_ev->monitor_handle =
>> > +                                               cpu_to_le16(dev->handle);
>> > +
>> > +                               mgmt_event(MGMT_EV_ADV_MONITOR_DEVICE_FOUND,
>> > +                                          hdev, advmon_ev, advmon_ev_size,
>> > +                                          NULL);
>> > +
>> > +                               notified = true;
>> > +                               dev->notified = true;
>> > +                       }
>> > +               }
>> > +
>> > +               if (!dev->notified)
>> > +                       hdev->advmon_pend_notify = true;
>> > +       }
>> > +
>> > +       if (!discovering &&
>> > +           ((matched && !notified) || !msft_monitor_supported(hdev))) {
>> > +               /* Handle 0 indicates that we are not active scanning and this
>> > +                * is a subsequent advertisement report for an already matched
>> > +                * Advertisement Monitor or the controller offloading support
>> > +                * is not available.
>> > +                */
>> > +               advmon_ev->monitor_handle = 0;
>> > +
>> > +               mgmt_event(MGMT_EV_ADV_MONITOR_DEVICE_FOUND, hdev, advmon_ev,
>> > +                          advmon_ev_size, NULL);
>> > +       }
>> > +}
>> > +
>> >  void mgmt_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
>> >                        u8 addr_type, u8 *dev_class, s8 rssi, u32 flags,
>> >                        u8 *eir, u16 eir_len, u8 *scan_rsp, u8 scan_rsp_len)
>> > @@ -9531,6 +9627,7 @@ void mgmt_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
>> >         char buf[512];
>> >         struct mgmt_ev_device_found *ev = (void *)buf;
>> >         size_t ev_size;
>> > +       bool report_device_found = hci_discovery_active(hdev);
>> >
>> >         /* Don't send events for a non-kernel initiated discovery. With
>> >          * LE one exception is if we have pend_le_reports > 0 in which
>> > @@ -9539,11 +9636,10 @@ void mgmt_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
>> >         if (!hci_discovery_active(hdev)) {
>> >                 if (link_type == ACL_LINK)
>> >                         return;
>> > -               if (link_type == LE_LINK &&
>> > -                   list_empty(&hdev->pend_le_reports) &&
>> > -                   !hci_is_adv_monitoring(hdev)) {
>> > +               if (link_type == LE_LINK && !list_empty(&hdev->pend_le_reports))
>> > +                       report_device_found = true;
>> > +               else if (!hci_is_adv_monitoring(hdev))
>> >                         return;
>> > -               }
>> >         }
>> >
>> >         if (hdev->discovery.result_filtering) {
>> > @@ -9606,7 +9702,7 @@ void mgmt_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
>> >         ev->eir_len = cpu_to_le16(eir_len + scan_rsp_len);
>> >         ev_size = sizeof(*ev) + eir_len + scan_rsp_len;
>> >
>> > -       mgmt_event(MGMT_EV_DEVICE_FOUND, hdev, ev, ev_size, NULL);
>> > +       mgmt_adv_monitor_device_found(hdev, ev, ev_size, report_device_found);
>> >  }
>> >
>> >  void mgmt_remote_name(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
>> > diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
>> > index aadabe78baf6..3e2385562d2b 100644
>> > --- a/net/bluetooth/msft.c
>> > +++ b/net/bluetooth/msft.c
>> > @@ -579,8 +579,16 @@ void msft_do_close(struct hci_dev *hdev)
>> >
>> >         hci_dev_lock(hdev);
>> >
>> > -       /* Clear any devices that are being monitored */
>> > +       /* Clear any devices that are being monitored and notify device lost */
>> > +
>> > +       hdev->advmon_pend_notify = false;
>> > +
>> >         list_for_each_entry_safe(dev, tmp_dev, &hdev->monitored_devices, list) {
>> > +               if (dev->notified)
>> > +                       mgmt_adv_monitor_device_lost(hdev, dev->handle,
>> > +                                                    &dev->bdaddr,
>> > +                                                    dev->addr_type);
>> > +
>> >                 list_del(&dev->list);
>> >                 kfree(dev);
>> >         }
>> > @@ -639,6 +647,7 @@ static void msft_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr,
>> >
>> >         INIT_LIST_HEAD(&dev->list);
>> >         list_add(&dev->list, &hdev->monitored_devices);
>> > +       hdev->advmon_pend_notify = true;
>> >  }
>> >
>> >  /* This function requires the caller holds hdev->lock */
>> > @@ -649,6 +658,10 @@ static void msft_device_lost(struct hci_dev *hdev, bdaddr_t *bdaddr,
>> >
>> >         list_for_each_entry_safe(dev, tmp, &hdev->monitored_devices, list) {
>> >                 if (dev->handle == mgmt_handle) {
>> > +                       if (dev->notified)
>> > +                               mgmt_adv_monitor_device_lost(hdev, mgmt_handle,
>> > +                                                            bdaddr, addr_type);
>> > +
>> >                         list_del(&dev->list);
>> >                         kfree(dev);
>> >
>> > --
>> > 2.34.0.384.gca35af8252-goog
>> >
>>
>>
>> --
>> Luiz Augusto von Dentz
>
>
> Thanks,
> Manish.



-- 
Luiz Augusto von Dentz
