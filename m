Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7AD413E33
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 02:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhIVADn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 20:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbhIVADm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 20:03:42 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F38C061574;
        Tue, 21 Sep 2021 17:02:13 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id l19so1107596vst.7;
        Tue, 21 Sep 2021 17:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ebij2fY1uyJsQGq2/Tf4Yu7akjWm+sdGeOmeRxcgXyg=;
        b=hgRXGp3Qwuime21zs6j7D31R4EyjSRTE7dDMNzVNSZgSyLIkDTJgB40jujT1thWBrd
         I1dXgYqL6ZSZg/Di3zYIidhpxXjspVu96DGW2TPO2VF1MizrWBpzkE3SwmQ8wt69liHF
         /VcmAH5HTC82QX7dAWz0yt2yewCwC2MubthTU9TD9RxFfiaxHfuKBGwWhg+ZfRHIcup4
         mi2YuJS5r9aRIUpARilBvZNBBM19r+CE2jtB7A7jQo6tHXpqcKcge2Df53b5+TMbGlyy
         RadqabGxhL0cV50uu8e+34zrGQPHwygTuAJXzArly52sfLrfoYhKNIkv/LGhfBp/p+mm
         ORCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ebij2fY1uyJsQGq2/Tf4Yu7akjWm+sdGeOmeRxcgXyg=;
        b=NYYFxx9nVwFtKQJrxRkHeLsumbUJbWl4UDOVF2so4/dPMgHfJwmsIhIby9q/DhUSOM
         WQredY3BGeuvDqgZ3Un8AM6Cjt/+KBMq64iBkZ39iqa9WAPtzZSe51aIzzSfsMva/MJj
         RrY4zWF7PLmVjWeKD+3g+FiMWqqfRUIxLyqek5Z3HAzcNwh8knoPGSd2VR0nTJ/xZpBR
         NpiXiiW3nJyDVXa5Wx8J460AJNaG+rx/U2f/BjzqzDRj96L0Hz1EP79QrVKixAac1kEx
         S2Ve6HfrLgZ0OavsFIC657HlROWFDfVSEMb5/5IcLNAFdGfRP7AA6+8wRDJtQsiu25MX
         /4jQ==
X-Gm-Message-State: AOAM533hgH+nQX1LuojgVjZKs7eN9uh8hO8dzt4zFUL9wUX6uVbvLRw9
        2i1rrSztJDaCKASLKVLvyZEx3Tf9PFK6FAgTOUGK4kQxr4c=
X-Google-Smtp-Source: ABdhPJyIdCErTqdAInoVFlVZgdoiYPtaxjzxBT+6j/+tLDPh6+pt2hz95l24WFsNrlsPGTf4MTztVVFClOxmEs4uEn4=
X-Received: by 2002:a67:ea83:: with SMTP id f3mr23168553vso.39.1632268931140;
 Tue, 21 Sep 2021 17:02:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210921085652.v2.1.Ib31940aba2253e3f25cbca09a2d977d27170e163@changeid>
 <CABBYNZLkMp1qLgwBVyU-V82W=M7MSPkZpsOFDGj1GKH=DB=5Ag@mail.gmail.com> <CAGPPCLDnfVZvhTyKZqS0J=LFUfzxkv2_23kcwrGGW4-145mM2Q@mail.gmail.com>
In-Reply-To: <CAGPPCLDnfVZvhTyKZqS0J=LFUfzxkv2_23kcwrGGW4-145mM2Q@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 21 Sep 2021 17:02:00 -0700
Message-ID: <CABBYNZJ5iYF_Y3ez_RQbZ5s70e750W0QU7DpaSXOV4eFi0aFng@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

On Tue, Sep 21, 2021 at 3:02 PM Manish Mandlik <mmandlik@google.com> wrote:
>
> Hi Luiz,
>
> On Tue, Sep 21, 2021 at 10:56 AM Luiz Augusto von Dentz <luiz.dentz@gmail=
.com> wrote:
>>
>> Hi Manish,
>>
>> On Tue, Sep 21, 2021 at 8:57 AM Manish Mandlik <mmandlik@google.com> wro=
te:
>> >
>> > During system suspend, advertisement monitoring is disabled by setting
>> > the HCI_VS_MSFT_LE_Set_Advertisement_Filter_Enable to False. This
>> > disables the monitoring during suspend, however, if the controller is
>> > monitoring a device, it sends HCI_VS_MSFT_LE_Monitor_Device_Event to
>> > indicate that the monitoring has been stopped for that particular
>> > device. This event may occur after suspend depending on the
>> > low_threshold_timeout and peer device advertisement frequency, which
>> > causes early wake up.
>> >
>> > Right way to disable the monitoring for suspend is by removing all the
>> > monitors before suspend and re-monitor after resume to ensure no event=
s
>> > are received during suspend. This patch fixes this suspend/resume issu=
e.
>> >
>> > Following tests are performed:
>> > - Add monitors before suspend and make sure DeviceFound gets triggered
>> > - Suspend the system and verify that all monitors are removed by kerne=
l
>> >   but not Released by bluetoothd
>> > - Wake up and verify that all monitors are added again and DeviceFound
>> >   gets triggered
>> >
>> > Signed-off-by: Manish Mandlik <mmandlik@google.com>
>> > Reviewed-by: Archie Pusaka <apusaka@google.com>
>> > Reviewed-by: Miao-chen Chou <mcchou@google.com>
>> > ---
>> >
>> > Changes in v2:
>> > - Updated the Reviewd-by names
>> >
>> >  net/bluetooth/hci_request.c |  15 +++--
>> >  net/bluetooth/msft.c        | 117 +++++++++++++++++++++++++++++++----=
-
>> >  net/bluetooth/msft.h        |   5 ++
>> >  3 files changed, 116 insertions(+), 21 deletions(-)
>> >
>> > diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
>> > index 47fb665277d4..c018a172ced3 100644
>> > --- a/net/bluetooth/hci_request.c
>> > +++ b/net/bluetooth/hci_request.c
>> > @@ -1281,21 +1281,24 @@ static void suspend_req_complete(struct hci_de=
v *hdev, u8 status, u16 opcode)
>> >         }
>> >  }
>> >
>> > -static void hci_req_add_set_adv_filter_enable(struct hci_request *req=
,
>> > -                                             bool enable)
>> > +static void hci_req_prepare_adv_monitor_suspend(struct hci_request *r=
eq,
>> > +                                               bool suspending)
>> >  {
>> >         struct hci_dev *hdev =3D req->hdev;
>> >
>> >         switch (hci_get_adv_monitor_offload_ext(hdev)) {
>> >         case HCI_ADV_MONITOR_EXT_MSFT:
>> > -               msft_req_add_set_filter_enable(req, enable);
>> > +               if (suspending)
>> > +                       msft_remove_all_monitors_on_suspend(hdev);
>> > +               else
>> > +                       msft_reregister_monitors_on_resume(hdev);
>> >                 break;
>> >         default:
>> >                 return;
>> >         }
>> >
>> >         /* No need to block when enabling since it's on resume path */
>> > -       if (hdev->suspended && !enable)
>> > +       if (hdev->suspended && suspending)
>> >                 set_bit(SUSPEND_SET_ADV_FILTER, hdev->suspend_tasks);
>> >  }
>> >
>> > @@ -1362,7 +1365,7 @@ void hci_req_prepare_suspend(struct hci_dev *hde=
v, enum suspended_state next)
>> >                 }
>> >
>> >                 /* Disable advertisement filters */
>> > -               hci_req_add_set_adv_filter_enable(&req, false);
>> > +               hci_req_prepare_adv_monitor_suspend(&req, true);
>> >
>> >                 /* Prevent disconnects from causing scanning to be re-=
enabled */
>> >                 hdev->scanning_paused =3D true;
>> > @@ -1404,7 +1407,7 @@ void hci_req_prepare_suspend(struct hci_dev *hde=
v, enum suspended_state next)
>> >                 /* Reset passive/background scanning to normal */
>> >                 __hci_update_background_scan(&req);
>> >                 /* Enable all of the advertisement filters */
>> > -               hci_req_add_set_adv_filter_enable(&req, true);
>> > +               hci_req_prepare_adv_monitor_suspend(&req, false);
>> >
>> >                 /* Unpause directed advertising */
>> >                 hdev->advertising_paused =3D false;
>> > diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
>> > index 21b1787e7893..328d5e341f9a 100644
>> > --- a/net/bluetooth/msft.c
>> > +++ b/net/bluetooth/msft.c
>> > @@ -94,11 +94,14 @@ struct msft_data {
>> >         __u16 pending_add_handle;
>> >         __u16 pending_remove_handle;
>> >         __u8 reregistering;
>> > +       __u8 suspending;
>> >         __u8 filter_enabled;
>> >  };
>> >
>> >  static int __msft_add_monitor_pattern(struct hci_dev *hdev,
>> >                                       struct adv_monitor *monitor);
>> > +static int __msft_remove_monitor(struct hci_dev *hdev,
>> > +                                struct adv_monitor *monitor, u16 hand=
le);
>> >
>> >  bool msft_monitor_supported(struct hci_dev *hdev)
>> >  {
>> > @@ -154,7 +157,7 @@ static bool read_supported_features(struct hci_dev=
 *hdev,
>> >  }
>> >
>> >  /* This function requires the caller holds hdev->lock */
>> > -static void reregister_monitor_on_restart(struct hci_dev *hdev, int h=
andle)
>> > +static void reregister_monitor(struct hci_dev *hdev, int handle)
>> >  {
>> >         struct adv_monitor *monitor;
>> >         struct msft_data *msft =3D hdev->msft_data;
>> > @@ -182,6 +185,69 @@ static void reregister_monitor_on_restart(struct =
hci_dev *hdev, int handle)
>> >         }
>> >  }
>> >
>> > +/* This function requires the caller holds hdev->lock */
>> > +static void remove_monitor_on_suspend(struct hci_dev *hdev, int handl=
e)
>> > +{
>> > +       struct adv_monitor *monitor;
>> > +       struct msft_data *msft =3D hdev->msft_data;
>> > +       int err;
>> > +
>> > +       while (1) {
>> > +               monitor =3D idr_get_next(&hdev->adv_monitors_idr, &han=
dle);
>> > +               if (!monitor) {
>> > +                       /* All monitors have been removed */
>> > +                       msft->suspending =3D false;
>> > +                       hci_update_background_scan(hdev);
>> > +                       return;
>> > +               }
>> > +
>> > +               msft->pending_remove_handle =3D (u16)handle;
>> > +               err =3D __msft_remove_monitor(hdev, monitor, handle);
>> > +
>> > +               /* If success, return and wait for monitor removed cal=
lback */
>> > +               if (!err)
>> > +                       return;
>>
>> Not sure I follow this one, why you are not continuing removing the
>> other ones? Also doesn't adv monitor have a way to clear all monitors
>> at once?
>
> If the remove command is sent to the controller successfully, we wait for=
 the command complete and removal of the remaining monitors is continued in=
 the callback function msft_le_cancel_monitor_advertisement_cb(). Monitors =
are removed one by one.

I'm afraid you would say that, we are currently attempting to move
away from this type of design when the context can block since in that
case we can just use a blocking/synchronous call we can deal with
errors, otherwise this get all over the place and this will just
contribute it, so if you guys could please focus on getting the
cmd-sync changes tested so we can have these changes on top of rather
than I have to cleanup after.

> MSFT extension doesn't support clearing all monitors at once. Although th=
ey have a way to disable monitoring, but, in that case, the controller stil=
l continues monitoring the devices that are currently being monitored and g=
enerates an HCI_VS_MSFT_LE_Monitor_Device_Event with Monitor_state set to 0=
 if the device is no longer being monitored. This event may arrive after th=
e system suspend and thus cause early wake up. So, to avoid this, we need t=
o remove all monitors before suspend and re-add them after resume.

This should probably be documented properly so we know in the future
why it was done this way, Im also confusion when you say the is a way
to disable monitoring but it actually doesn't disable the events, that
sounds either a bug or there is not really meant to disabling anything
in which case the naming is probably confusing. Also can't we mask out
the monitor events during suspend? Or perhaps that is due to not have
a bit for HCI_EV_VENDOR? Id said this would be very useful, not only
for things like msft but any other vendor event we don't seem to be
able to mask out which can potentially wakeup the host.

Btw, what is the deal with msft_vendor_evt, it doesn't seem to be
doing anything with the events received, it just prints the vendor
event and that's it, how are we processing
HCI_VS_MSFT_LE_Monitor_Device_Event, etc?

>>
>>
>> > +
>> > +               /* Otherwise free the monitor and keep removing */
>> > +               hci_free_adv_monitor(hdev, monitor);
>> > +               handle++;
>> > +       }
>> > +}
>> > +
>> > +/* This function requires the caller holds hdev->lock */
>> > +void msft_remove_all_monitors_on_suspend(struct hci_dev *hdev)
>> > +{
>> > +       struct msft_data *msft =3D hdev->msft_data;
>> > +
>> > +       if (!msft)
>> > +               return;
>> > +
>> > +       if (msft_monitor_supported(hdev)) {
>> > +               msft->suspending =3D true;
>> > +               /* Quitely remove all monitors on suspend to avoid wak=
ing up
>> > +                * the system.
>> > +                */
>>
>> The above comment suggests it would remove all monitors, not just one.
>
> Yes, as explained above, monitors will be removed one by one. The removal=
 process is continued in the msft_le_cancel_monitor_advertisement_cb() call=
back function.
>>
>>
>> > +               remove_monitor_on_suspend(hdev, 0);
>> > +       }
>> > +}
>> > +
>> > +/* This function requires the caller holds hdev->lock */
>> > +void msft_reregister_monitors_on_resume(struct hci_dev *hdev)
>> > +{
>> > +       struct msft_data *msft =3D hdev->msft_data;
>> > +
>> > +       if (!msft)
>> > +               return;
>> > +
>> > +       if (msft_monitor_supported(hdev)) {
>> > +               msft->reregistering =3D true;
>> > +               /* Monitors are removed on suspend, so we need to add =
all
>> > +                * monitors on resume.
>> > +                */
>> > +               reregister_monitor(hdev, 0);
>> > +       }
>> > +}
>> > +
>> >  void msft_do_open(struct hci_dev *hdev)
>> >  {
>> >         struct msft_data *msft =3D hdev->msft_data;
>> > @@ -214,7 +280,7 @@ void msft_do_open(struct hci_dev *hdev)
>> >                 /* Monitors get removed on power off, so we need to ex=
plicitly
>> >                  * tell the controller to re-monitor.
>> >                  */
>> > -               reregister_monitor_on_restart(hdev, 0);
>> > +               reregister_monitor(hdev, 0);
>> >         }
>> >  }
>> >
>> > @@ -382,8 +448,7 @@ static void msft_le_monitor_advertisement_cb(struc=
t hci_dev *hdev,
>> >
>> >         /* If in restart/reregister sequence, keep registering. */
>> >         if (msft->reregistering)
>> > -               reregister_monitor_on_restart(hdev,
>> > -                                             msft->pending_add_handle=
 + 1);
>> > +               reregister_monitor(hdev, msft->pending_add_handle + 1)=
;
>> >
>> >         hci_dev_unlock(hdev);
>> >
>> > @@ -420,13 +485,25 @@ static void msft_le_cancel_monitor_advertisement=
_cb(struct hci_dev *hdev,
>> >         if (handle_data) {
>> >                 monitor =3D idr_find(&hdev->adv_monitors_idr,
>> >                                    handle_data->mgmt_handle);
>> > -               if (monitor)
>> > +
>> > +               if (monitor && monitor->state =3D=3D ADV_MONITOR_STATE=
_OFFLOADED)
>> > +                       monitor->state =3D ADV_MONITOR_STATE_REGISTERE=
D;
>> > +
>> > +               /* Do not free the monitor if it is being removed due =
to
>> > +                * suspend. It will be re-monitored on resume.
>> > +                */
>> > +               if (monitor && !msft->suspending)
>> >                         hci_free_adv_monitor(hdev, monitor);
>> >
>> >                 list_del(&handle_data->list);
>> >                 kfree(handle_data);
>> >         }
>> >
>> > +       /* If in suspend/remove sequence, keep removing. */
>> > +       if (msft->suspending)
>> > +               remove_monitor_on_suspend(hdev,
>> > +                                         msft->pending_remove_handle =
+ 1);
>> > +
>> >         /* If remove all monitors is required, we need to continue the=
 process
>> >          * here because the earlier it was paused when waiting for the
>> >          * response from controller.
>> > @@ -445,7 +522,8 @@ static void msft_le_cancel_monitor_advertisement_c=
b(struct hci_dev *hdev,
>> >         hci_dev_unlock(hdev);
>> >
>> >  done:
>> > -       hci_remove_adv_monitor_complete(hdev, status);
>> > +       if (!msft->suspending)
>> > +               hci_remove_adv_monitor_complete(hdev, status);
>> >  }
>> >
>> >  static void msft_le_set_advertisement_filter_enable_cb(struct hci_dev=
 *hdev,
>> > @@ -578,15 +656,15 @@ int msft_add_monitor_pattern(struct hci_dev *hde=
v, struct adv_monitor *monitor)
>> >         if (!msft)
>> >                 return -EOPNOTSUPP;
>> >
>> > -       if (msft->reregistering)
>> > +       if (msft->reregistering || msft->suspending)
>> >                 return -EBUSY;
>> >
>> >         return __msft_add_monitor_pattern(hdev, monitor);
>> >  }
>> >
>> >  /* This function requires the caller holds hdev->lock */
>> > -int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *mon=
itor,
>> > -                       u16 handle)
>> > +static int __msft_remove_monitor(struct hci_dev *hdev,
>> > +                                struct adv_monitor *monitor, u16 hand=
le)
>> >  {
>> >         struct msft_cp_le_cancel_monitor_advertisement cp;
>> >         struct msft_monitor_advertisement_handle_data *handle_data;
>> > @@ -594,12 +672,6 @@ int msft_remove_monitor(struct hci_dev *hdev, str=
uct adv_monitor *monitor,
>> >         struct msft_data *msft =3D hdev->msft_data;
>> >         int err =3D 0;
>> >
>> > -       if (!msft)
>> > -               return -EOPNOTSUPP;
>> > -
>> > -       if (msft->reregistering)
>> > -               return -EBUSY;
>> > -
>> >         handle_data =3D msft_find_handle_data(hdev, monitor->handle, t=
rue);
>> >
>> >         /* If no matched handle, just remove without telling controlle=
r */
>> > @@ -619,6 +691,21 @@ int msft_remove_monitor(struct hci_dev *hdev, str=
uct adv_monitor *monitor,
>> >         return err;
>> >  }
>> >
>> > +/* This function requires the caller holds hdev->lock */
>> > +int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *mon=
itor,
>> > +                       u16 handle)
>> > +{
>> > +       struct msft_data *msft =3D hdev->msft_data;
>> > +
>> > +       if (!msft)
>> > +               return -EOPNOTSUPP;
>> > +
>> > +       if (msft->reregistering || msft->suspending)
>> > +               return -EBUSY;
>> > +
>> > +       return __msft_remove_monitor(hdev, monitor, handle);
>> > +}
>> > +
>> >  void msft_req_add_set_filter_enable(struct hci_request *req, bool ena=
ble)
>> >  {
>> >         struct hci_dev *hdev =3D req->hdev;
>> > diff --git a/net/bluetooth/msft.h b/net/bluetooth/msft.h
>> > index 8018948c5975..6ec843b94d16 100644
>> > --- a/net/bluetooth/msft.h
>> > +++ b/net/bluetooth/msft.h
>> > @@ -24,6 +24,8 @@ int msft_remove_monitor(struct hci_dev *hdev, struct=
 adv_monitor *monitor,
>> >                         u16 handle);
>> >  void msft_req_add_set_filter_enable(struct hci_request *req, bool ena=
ble);
>> >  int msft_set_filter_enable(struct hci_dev *hdev, bool enable);
>> > +void msft_remove_all_monitors_on_suspend(struct hci_dev *hdev);
>> > +void msft_reregister_monitors_on_resume(struct hci_dev *hdev);
>>
>> I'd go with msft_suspend and msft_resume, that should be enough to
>> indicate what their intent are.
>
> Ack. Updated in the v3 patch.
>>
>>
>> >  bool msft_curve_validity(struct hci_dev *hdev);
>> >
>> >  #else
>> > @@ -59,6 +61,9 @@ static inline int msft_set_filter_enable(struct hci_=
dev *hdev, bool enable)
>> >         return -EOPNOTSUPP;
>> >  }
>> >
>> > +void msft_remove_all_monitors_on_suspend(struct hci_dev *hdev) {}
>> > +void msft_reregister_monitors_on_resume(struct hci_dev *hdev) {}
>> > +
>> >  static inline bool msft_curve_validity(struct hci_dev *hdev)
>> >  {
>> >         return false;
>> > --
>> > 2.33.0.464.g1972c5931b-goog
>> >
>>
>>
>> --
>> Luiz Augusto von Dentz
>
>
> Thanks,
> Manish.



--=20
Luiz Augusto von Dentz
