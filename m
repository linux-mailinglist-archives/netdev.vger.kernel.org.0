Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 593E0542446
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiFHDgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 23:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232879AbiFHDc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 23:32:28 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E6821565C;
        Tue,  7 Jun 2022 14:11:39 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id j7so16732119pjn.4;
        Tue, 07 Jun 2022 14:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OFqjbQ0WVJHtsLGTvFGqrNfz2sEOKXmqVkER4ai/huU=;
        b=lq6cMV7LJCBZHV/e9Je+1aBNVy3wAyGFdWo3Z6NYnUOS2k69k5PBEFVyZqv01x4PpR
         ukiKSuI2IXqXPfK+g61q53IuBFRRUfn3wBiaQdXBBZEhqDa4kAlcmzUs+4eS/hCkq1A1
         BS4zHGb5i9N472uHIzS7I/pjx5WN+Lg5SNi59QiDcojQ3/Z7VgnS5nEsaA2tLJuFUWVb
         57LnQASJxx4gxVN3QyEqj/yFZoUMgr90FCRmQAADHd4Lj/eHMD14lFULl589+jdO0IgH
         acWBUfNIxud1qAEdQrojgUIfesPc2L4WP92aNFzEs7i0l9EbYl9i/3jkh7vmvPsg4wtH
         vSMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OFqjbQ0WVJHtsLGTvFGqrNfz2sEOKXmqVkER4ai/huU=;
        b=maGzulmJeaHNhY7gt3IXqOE5V6MfPPICpS+WzvbIKb+yeXkO1+5zU2lml03fIEmQ9A
         jruccyOLase0kojUlJiBImyrzp7iUF5KNbYVzY/0ebeJ4qI8DNkS4qkejvD8bJREmISO
         qBa8wcpCEJlywI8NBqlqn49MgtTptcTqkWX6K/O1ppg/3lCkVmM4StPhIXusoEdOmp9I
         s6176q8PJNBN1anY4TSo1VNblSB53n2VYJ09Gq6ltV25bPz3MmaraZ+zYAnAv+wWAeUt
         nBEqjhXMo3qy9Si8+JvMCs1ry4lZD2iDBqgjQhuQSML4c1p4KZlCnQ9B4jLepzJKGGfi
         1bqA==
X-Gm-Message-State: AOAM5311fzmVr/+cQRnUABzXfoO5anSO5Vq2Hz1Gt7DXbrtpCgZW72QV
        KOwi2STaDaYGp+onCRSbKH92xR2FDc9wU0+GKTpX5TvTFu5bIQ==
X-Google-Smtp-Source: ABdhPJzN/xUuigvYHIBkx91N+cCHMdOHd9UyXwY1DAnSyZvqcHYOIAfO1yKAqFU/Ppgtes2IOvhvcjtrBP9uCsx6Wl4=
X-Received: by 2002:a17:902:f791:b0:167:8f4d:a13b with SMTP id
 q17-20020a170902f79100b001678f4da13bmr6587550pln.34.1654636298353; Tue, 07
 Jun 2022 14:11:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220524131406.1.If745ed1d05d98c002fc84ba60cef99eb786b7caa@changeid>
 <CABBYNZ+Z7j0VjNQitBRwpJDTGv=sJoj9jgKECtGEcQA2h3FUWg@mail.gmail.com>
 <CAGPPCLAf6BvtEvXotPfr4xgj8pPnRw5eHd7dK=z0N3jr1nr+Cg@mail.gmail.com> <CAGPPCLDeDpxX0avO_266CHc9XfYWEaRXN=9vQ29=sgw8cMRN5w@mail.gmail.com>
In-Reply-To: <CAGPPCLDeDpxX0avO_266CHc9XfYWEaRXN=9vQ29=sgw8cMRN5w@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 7 Jun 2022 14:11:25 -0700
Message-ID: <CABBYNZLKbTKkD7y_F+jSCt0bKkTpPVJ_X1NY9h8VJGrf8Nb9ag@mail.gmail.com>
Subject: Re: [PATCH 1/2] Bluetooth: hci_sync: Refactor add Adv Monitor
To:     Manish Mandlik <mmandlik@google.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Miao-chen Chou <mcchou@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
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

Hi Manish,

On Tue, Jun 7, 2022 at 9:57 AM Manish Mandlik <mmandlik@google.com> wrote:
>
> Hi Luiz,
>
> On Thu, May 26, 2022 at 7:01 PM Manish Mandlik <mmandlik@google.com> wrot=
e:
>>
>> Hi Luiz,
>>
>>
>> On Wed, May 25, 2022 at 5:46 PM Luiz Augusto von Dentz <luiz.dentz@gmail=
.com> wrote:
>>>
>>> Hi Manish,
>>>
>>> On Tue, May 24, 2022 at 1:14 PM Manish Mandlik <mmandlik@google.com> wr=
ote:
>>> >
>>> > Make use of hci_cmd_sync_queue for adding an advertisement monitor.
>>>
>>> Im a little lost here, it seems you end up not really using
>>> hci_cmd_sync_queue are you assuming these functions are already run
>>> from a safe context?
>>
>> Not sure if I understand the question. But I am using msft_add_monitor_s=
ync() to send a monitor to the controller which uses hci_cmd_sync_queue. It=
 requires the caller to hold hci_req_sync_lock, which I have used at the ap=
propriate places. Let me know if that looks correct.

It sounds like you are doing the hci_req_sync_lock from any thread
instead of using hci_cmd_sync_queue and then from its callback call
msft_add_monitor_sync, that way we guarantee only one task is
scheduling HCI traffic.

>>
>>>
>>> > Signed-off-by: Manish Mandlik <mmandlik@google.com>
>>> > Reviewed-by: Miao-chen Chou <mcchou@google.com>
>>> > ---
>>> >
>>> >  include/net/bluetooth/hci_core.h |   5 +-
>>> >  net/bluetooth/hci_core.c         |  47 ++++-----
>>> >  net/bluetooth/mgmt.c             | 121 +++++++----------------
>>> >  net/bluetooth/msft.c             | 161 ++++++++---------------------=
--
>>> >  4 files changed, 98 insertions(+), 236 deletions(-)
>>> >
>>> > diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth=
/hci_core.h
>>> > index 5a52a2018b56..59953a7a6328 100644
>>> > --- a/include/net/bluetooth/hci_core.h
>>> > +++ b/include/net/bluetooth/hci_core.h
>>> > @@ -1410,10 +1410,8 @@ bool hci_adv_instance_is_scannable(struct hci_=
dev *hdev, u8 instance);
>>> >
>>> >  void hci_adv_monitors_clear(struct hci_dev *hdev);
>>> >  void hci_free_adv_monitor(struct hci_dev *hdev, struct adv_monitor *=
monitor);
>>> > -int hci_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 s=
tatus);
>>> >  int hci_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status)=
;
>>> > -bool hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *m=
onitor,
>>> > -                       int *err);
>>> > +int hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *mo=
nitor);
>>> >  bool hci_remove_single_adv_monitor(struct hci_dev *hdev, u16 handle,=
 int *err);
>>> >  bool hci_remove_all_adv_monitor(struct hci_dev *hdev, int *err);
>>> >  bool hci_is_adv_monitoring(struct hci_dev *hdev);
>>> > @@ -1875,7 +1873,6 @@ void mgmt_advertising_removed(struct sock *sk, =
struct hci_dev *hdev,
>>> >                               u8 instance);
>>> >  void mgmt_adv_monitor_removed(struct hci_dev *hdev, u16 handle);
>>> >  int mgmt_phy_configuration_changed(struct hci_dev *hdev, struct sock=
 *skip);
>>> > -int mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 =
status);
>>> >  int mgmt_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status=
);
>>> >  void mgmt_adv_monitor_device_lost(struct hci_dev *hdev, u16 handle,
>>> >                                   bdaddr_t *bdaddr, u8 addr_type);
>>> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
>>> > index 5abb2ca5b129..bbbbe3203130 100644
>>> > --- a/net/bluetooth/hci_core.c
>>> > +++ b/net/bluetooth/hci_core.c
>>> > @@ -1873,11 +1873,6 @@ void hci_free_adv_monitor(struct hci_dev *hdev=
, struct adv_monitor *monitor)
>>> >         kfree(monitor);
>>> >  }
>>> >
>>> > -int hci_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 s=
tatus)
>>> > -{
>>> > -       return mgmt_add_adv_patterns_monitor_complete(hdev, status);
>>> > -}
>>> > -
>>> >  int hci_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status)
>>> >  {
>>> >         return mgmt_remove_adv_monitor_complete(hdev, status);
>>> > @@ -1885,49 +1880,49 @@ int hci_remove_adv_monitor_complete(struct hc=
i_dev *hdev, u8 status)
>>> >
>>> >  /* Assigns handle to a monitor, and if offloading is supported and p=
ower is on,
>>> >   * also attempts to forward the request to the controller.
>>> > - * Returns true if request is forwarded (result is pending), false o=
therwise.
>>> > - * This function requires the caller holds hdev->lock.
>>> >   */
>>> > -bool hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *m=
onitor,
>>> > -                        int *err)
>>> > +int hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *mo=
nitor)
>>> >  {
>>> >         int min, max, handle;
>>> > +       int status =3D 0;
>>> >
>>> > -       *err =3D 0;
>>> > +       if (!monitor)
>>> > +               return -EINVAL;
>>> >
>>> > -       if (!monitor) {
>>> > -               *err =3D -EINVAL;
>>> > -               return false;
>>> > -       }
>>> > +       hci_dev_lock(hdev);
>>> >
>>> >         min =3D HCI_MIN_ADV_MONITOR_HANDLE;
>>> >         max =3D HCI_MIN_ADV_MONITOR_HANDLE + HCI_MAX_ADV_MONITOR_NUM_=
HANDLES;
>>> >         handle =3D idr_alloc(&hdev->adv_monitors_idr, monitor, min, m=
ax,
>>> >                            GFP_KERNEL);
>>> > -       if (handle < 0) {
>>> > -               *err =3D handle;
>>> > -               return false;
>>> > -       }
>>> > +
>>> > +       hci_dev_unlock(hdev);
>>> > +
>>> > +       if (handle < 0)
>>> > +               return handle;
>>> >
>>> >         monitor->handle =3D handle;
>>> >
>>> >         if (!hdev_is_powered(hdev))
>>> > -               return false;
>>> > +               return status;
>>> >
>>> >         switch (hci_get_adv_monitor_offload_ext(hdev)) {
>>> >         case HCI_ADV_MONITOR_EXT_NONE:
>>> > -               hci_update_passive_scan(hdev);
>>> > -               bt_dev_dbg(hdev, "%s add monitor status %d", hdev->na=
me, *err);
>>> > +               bt_dev_dbg(hdev, "%s add monitor %d status %d", hdev-=
>name,
>>> > +                          monitor->handle, status);
>>> >                 /* Message was not forwarded to controller - not an e=
rror */
>>> > -               return false;
>>> > +               break;
>>> > +
>>> >         case HCI_ADV_MONITOR_EXT_MSFT:
>>> > -               *err =3D msft_add_monitor_pattern(hdev, monitor);
>>> > -               bt_dev_dbg(hdev, "%s add monitor msft status %d", hde=
v->name,
>>> > -                          *err);
>>> > +               hci_req_sync_lock(hdev);
>>> > +               status =3D msft_add_monitor_pattern(hdev, monitor);
>>> > +               hci_req_sync_unlock(hdev);
>>> > +               bt_dev_dbg(hdev, "%s add monitor %d msft status %d", =
hdev->name,
>>> > +                          monitor->handle, status);
>>> >                 break;
>>> >         }
>>> >
>>> > -       return (*err =3D=3D 0);
>>> > +       return status;
>>> >  }
>>> >
>>> >  /* Attempts to tell the controller and free the monitor. If somehow =
the
>>> > diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
>>> > index 74937a834648..d04f90698a87 100644
>>> > --- a/net/bluetooth/mgmt.c
>>> > +++ b/net/bluetooth/mgmt.c
>>> > @@ -4653,75 +4653,21 @@ static int read_adv_mon_features(struct sock =
*sk, struct hci_dev *hdev,
>>> >         return err;
>>> >  }
>>> >
>>> > -int mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 =
status)
>>> > -{
>>> > -       struct mgmt_rp_add_adv_patterns_monitor rp;
>>> > -       struct mgmt_pending_cmd *cmd;
>>> > -       struct adv_monitor *monitor;
>>> > -       int err =3D 0;
>>> > -
>>> > -       hci_dev_lock(hdev);
>>> > -
>>> > -       cmd =3D pending_find(MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI, h=
dev);
>>> > -       if (!cmd) {
>>> > -               cmd =3D pending_find(MGMT_OP_ADD_ADV_PATTERNS_MONITOR=
, hdev);
>>> > -               if (!cmd)
>>> > -                       goto done;
>>> > -       }
>>> > -
>>> > -       monitor =3D cmd->user_data;
>>> > -       rp.monitor_handle =3D cpu_to_le16(monitor->handle);
>>> > -
>>> > -       if (!status) {
>>> > -               mgmt_adv_monitor_added(cmd->sk, hdev, monitor->handle=
);
>>> > -               hdev->adv_monitors_cnt++;
>>> > -               if (monitor->state =3D=3D ADV_MONITOR_STATE_NOT_REGIS=
TERED)
>>> > -                       monitor->state =3D ADV_MONITOR_STATE_REGISTER=
ED;
>>> > -               hci_update_passive_scan(hdev);
>>> > -       }
>>> > -
>>> > -       err =3D mgmt_cmd_complete(cmd->sk, cmd->index, cmd->opcode,
>>> > -                               mgmt_status(status), &rp, sizeof(rp))=
;
>>> > -       mgmt_pending_remove(cmd);
>>> > -
>>> > -done:
>>> > -       hci_dev_unlock(hdev);
>>> > -       bt_dev_dbg(hdev, "add monitor %d complete, status %u",
>>> > -                  rp.monitor_handle, status);
>>> > -
>>> > -       return err;
>>> > -}
>>> > -
>>> >  static int __add_adv_patterns_monitor(struct sock *sk, struct hci_de=
v *hdev,
>>> > -                                     struct adv_monitor *m, u8 statu=
s,
>>> > -                                     void *data, u16 len, u16 op)
>>> > +                                     struct adv_monitor *m, void *da=
ta,
>>> > +                                     u16 len, u16 op)
>>> >  {
>>> >         struct mgmt_rp_add_adv_patterns_monitor rp;
>>> > -       struct mgmt_pending_cmd *cmd;
>>> > +       u8 status =3D MGMT_STATUS_SUCCESS;
>>> >         int err;
>>> > -       bool pending;
>>> > -
>>> > -       hci_dev_lock(hdev);
>>> > -
>>> > -       if (status)
>>> > -               goto unlock;
>>> >
>>> >         if (pending_find(MGMT_OP_SET_LE, hdev) ||
>>> > -           pending_find(MGMT_OP_ADD_ADV_PATTERNS_MONITOR, hdev) ||
>>> > -           pending_find(MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI, hdev)=
 ||
>>> >             pending_find(MGMT_OP_REMOVE_ADV_MONITOR, hdev)) {
>>> >                 status =3D MGMT_STATUS_BUSY;
>>> > -               goto unlock;
>>> > -       }
>>> > -
>>> > -       cmd =3D mgmt_pending_add(sk, op, hdev, data, len);
>>> > -       if (!cmd) {
>>> > -               status =3D MGMT_STATUS_NO_RESOURCES;
>>> > -               goto unlock;
>>> > +               goto done;
>>> >         }
>>> >
>>> > -       cmd->user_data =3D m;
>>> > -       pending =3D hci_add_adv_monitor(hdev, m, &err);
>>> > +       err =3D hci_add_adv_monitor(hdev, m);
>>> >         if (err) {
>>> >                 if (err =3D=3D -ENOSPC || err =3D=3D -ENOMEM)
>>> >                         status =3D MGMT_STATUS_NO_RESOURCES;
>>> > @@ -4730,30 +4676,29 @@ static int __add_adv_patterns_monitor(struct =
sock *sk, struct hci_dev *hdev,
>>> >                 else
>>> >                         status =3D MGMT_STATUS_FAILED;
>>> >
>>> > -               mgmt_pending_remove(cmd);
>>> > -               goto unlock;
>>> > +               goto done;
>>> >         }
>>> >
>>> > -       if (!pending) {
>>> > -               mgmt_pending_remove(cmd);
>>> > -               rp.monitor_handle =3D cpu_to_le16(m->handle);
>>> > -               mgmt_adv_monitor_added(sk, hdev, m->handle);
>>> > -               m->state =3D ADV_MONITOR_STATE_REGISTERED;
>>> > -               hdev->adv_monitors_cnt++;
>>> > +       hci_dev_lock(hdev);
>>> >
>>> > -               hci_dev_unlock(hdev);
>>> > -               return mgmt_cmd_complete(sk, hdev->id, op, MGMT_STATU=
S_SUCCESS,
>>> > -                                        &rp, sizeof(rp));
>>> > -       }
>>> > +       rp.monitor_handle =3D cpu_to_le16(m->handle);
>>> > +       mgmt_adv_monitor_added(sk, hdev, m->handle);
>>> > +       if (m->state =3D=3D ADV_MONITOR_STATE_NOT_REGISTERED)
>>> > +               m->state =3D ADV_MONITOR_STATE_REGISTERED;
>>> > +       hdev->adv_monitors_cnt++;
>>> > +       hci_update_passive_scan(hdev);
>>> >
>>> >         hci_dev_unlock(hdev);
>>> >
>>> > -       return 0;
>>> > +done:
>>> > +       bt_dev_dbg(hdev, "add monitor %d complete, status %u", m->han=
dle,
>>> > +                  status);
>>> >
>>> > -unlock:
>>> > -       hci_free_adv_monitor(hdev, m);
>>> > -       hci_dev_unlock(hdev);
>>> > -       return mgmt_cmd_status(sk, hdev->id, op, status);
>>> > +       if (status)
>>> > +               return mgmt_cmd_status(sk, hdev->id, op, status);
>>> > +
>>> > +       return mgmt_cmd_complete(sk, hdev->id, op, MGMT_STATUS_SUCCES=
S, &rp,
>>> > +                                sizeof(rp));
>>> >  }
>>> >
>>> >  static void parse_adv_monitor_rssi(struct adv_monitor *m,
>>> > @@ -4817,7 +4762,7 @@ static int add_adv_patterns_monitor(struct sock=
 *sk, struct hci_dev *hdev,
>>> >  {
>>> >         struct mgmt_cp_add_adv_patterns_monitor *cp =3D data;
>>> >         struct adv_monitor *m =3D NULL;
>>> > -       u8 status =3D MGMT_STATUS_SUCCESS;
>>> > +       int status =3D MGMT_STATUS_SUCCESS;
>>> >         size_t expected_size =3D sizeof(*cp);
>>> >
>>> >         BT_DBG("request for %s", hdev->name);
>>> > @@ -4843,10 +4788,14 @@ static int add_adv_patterns_monitor(struct so=
ck *sk, struct hci_dev *hdev,
>>> >
>>> >         parse_adv_monitor_rssi(m, NULL);
>>> >         status =3D parse_adv_monitor_pattern(m, cp->pattern_count, cp=
->patterns);
>>> > +       if (status)
>>> > +               goto done;
>>> > +
>>> > +       status =3D __add_adv_patterns_monitor(sk, hdev, m, data, len,
>>> > +                                           MGMT_OP_ADD_ADV_PATTERNS_=
MONITOR);
>>> >
>>> >  done:
>>> > -       return __add_adv_patterns_monitor(sk, hdev, m, status, data, =
len,
>>> > -                                         MGMT_OP_ADD_ADV_PATTERNS_MO=
NITOR);
>>> > +       return status;
>>> >  }
>>> >
>>> >  static int add_adv_patterns_monitor_rssi(struct sock *sk, struct hci=
_dev *hdev,
>>> > @@ -4854,7 +4803,7 @@ static int add_adv_patterns_monitor_rssi(struct=
 sock *sk, struct hci_dev *hdev,
>>> >  {
>>> >         struct mgmt_cp_add_adv_patterns_monitor_rssi *cp =3D data;
>>> >         struct adv_monitor *m =3D NULL;
>>> > -       u8 status =3D MGMT_STATUS_SUCCESS;
>>> > +       int status =3D MGMT_STATUS_SUCCESS;
>>> >         size_t expected_size =3D sizeof(*cp);
>>> >
>>> >         BT_DBG("request for %s", hdev->name);
>>> > @@ -4880,10 +4829,14 @@ static int add_adv_patterns_monitor_rssi(stru=
ct sock *sk, struct hci_dev *hdev,
>>> >
>>> >         parse_adv_monitor_rssi(m, &cp->rssi);
>>> >         status =3D parse_adv_monitor_pattern(m, cp->pattern_count, cp=
->patterns);
>>> > +       if (status)
>>> > +               goto done;
>>> >
>>> > -done:
>>> > -       return __add_adv_patterns_monitor(sk, hdev, m, status, data, =
len,
>>> > +       status =3D __add_adv_patterns_monitor(sk, hdev, m, data, len,
>>> >                                          MGMT_OP_ADD_ADV_PATTERNS_MON=
ITOR_RSSI);
>>> > +
>>> > +done:
>>> > +       return status;
>>> >  }
>>> >
>>> >  int mgmt_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status=
)
>>> > @@ -4933,9 +4886,7 @@ static int remove_adv_monitor(struct sock *sk, =
struct hci_dev *hdev,
>>> >         hci_dev_lock(hdev);
>>> >
>>> >         if (pending_find(MGMT_OP_SET_LE, hdev) ||
>>> > -           pending_find(MGMT_OP_REMOVE_ADV_MONITOR, hdev) ||
>>> > -           pending_find(MGMT_OP_ADD_ADV_PATTERNS_MONITOR, hdev) ||
>>> > -           pending_find(MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI, hdev)=
) {
>>> > +           pending_find(MGMT_OP_REMOVE_ADV_MONITOR, hdev)) {
>>> >                 status =3D MGMT_STATUS_BUSY;
>>> >                 goto unlock;
>>> >         }
>>> > diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
>>> > index f43994523b1f..9abea16c4305 100644
>>> > --- a/net/bluetooth/msft.c
>>> > +++ b/net/bluetooth/msft.c
>>> > @@ -106,8 +106,6 @@ struct msft_data {
>>> >         __u8 filter_enabled;
>>> >  };
>>> >
>>> > -static int __msft_add_monitor_pattern(struct hci_dev *hdev,
>>> > -                                     struct adv_monitor *monitor);
>>> >  static int __msft_remove_monitor(struct hci_dev *hdev,
>>> >                                  struct adv_monitor *monitor, u16 han=
dle);
>>> >
>>> > @@ -164,34 +162,6 @@ static bool read_supported_features(struct hci_d=
ev *hdev,
>>> >         return false;
>>> >  }
>>> >
>>> > -static void reregister_monitor(struct hci_dev *hdev, int handle)
>>> > -{
>>> > -       struct adv_monitor *monitor;
>>> > -       struct msft_data *msft =3D hdev->msft_data;
>>> > -       int err;
>>> > -
>>> > -       while (1) {
>>> > -               monitor =3D idr_get_next(&hdev->adv_monitors_idr, &ha=
ndle);
>>> > -               if (!monitor) {
>>> > -                       /* All monitors have been resumed */
>>> > -                       msft->resuming =3D false;
>>> > -                       hci_update_passive_scan(hdev);
>>> > -                       return;
>>> > -               }
>>> > -
>>> > -               msft->pending_add_handle =3D (u16)handle;
>>> > -               err =3D __msft_add_monitor_pattern(hdev, monitor);
>>> > -
>>> > -               /* If success, we return and wait for monitor added c=
allback */
>>> > -               if (!err)
>>> > -                       return;
>>> > -
>>> > -               /* Otherwise remove the monitor and keep registering =
*/
>>> > -               hci_free_adv_monitor(hdev, monitor);
>>> > -               handle++;
>>> > -       }
>>> > -}
>>> > -
>>> >  /* is_mgmt =3D true matches the handle exposed to userspace via mgmt=
.
>>> >   * is_mgmt =3D false matches the handle used by the msft controller.
>>> >   * This function requires the caller holds hdev->lock
>>> > @@ -243,14 +213,14 @@ static int msft_monitor_device_del(struct hci_d=
ev *hdev, __u16 mgmt_handle,
>>> >         return count;
>>> >  }
>>> >
>>> > -static void msft_le_monitor_advertisement_cb(struct hci_dev *hdev,
>>> > -                                            u8 status, u16 opcode,
>>> > -                                            struct sk_buff *skb)
>>> > +static int msft_le_monitor_advertisement_cb(struct hci_dev *hdev, u1=
6 opcode,
>>> > +                                           struct sk_buff *skb)
>>> >  {
>>> >         struct msft_rp_le_monitor_advertisement *rp;
>>> >         struct adv_monitor *monitor;
>>> >         struct msft_monitor_advertisement_handle_data *handle_data;
>>> >         struct msft_data *msft =3D hdev->msft_data;
>>> > +       int status =3D 0;
>>> >
>>> >         hci_dev_lock(hdev);
>>> >
>>> > @@ -262,15 +232,16 @@ static void msft_le_monitor_advertisement_cb(st=
ruct hci_dev *hdev,
>>> >                 goto unlock;
>>> >         }
>>> >
>>> > -       if (status)
>>> > -               goto unlock;
>>> > -
>>> >         rp =3D (struct msft_rp_le_monitor_advertisement *)skb->data;
>>> >         if (skb->len < sizeof(*rp)) {
>>> >                 status =3D HCI_ERROR_UNSPECIFIED;
>>> >                 goto unlock;
>>> >         }
>>> >
>>> > +       status =3D rp->status;
>>> > +       if (status)
>>> > +               goto unlock;
>>> > +
>>> >         handle_data =3D kmalloc(sizeof(*handle_data), GFP_KERNEL);
>>> >         if (!handle_data) {
>>> >                 status =3D HCI_ERROR_UNSPECIFIED;
>>> > @@ -290,8 +261,7 @@ static void msft_le_monitor_advertisement_cb(stru=
ct hci_dev *hdev,
>>> >
>>> >         hci_dev_unlock(hdev);
>>> >
>>> > -       if (!msft->resuming)
>>> > -               hci_add_adv_patterns_monitor_complete(hdev, status);
>>> > +       return status;
>>> >  }
>>> >
>>> >  static void msft_le_cancel_monitor_advertisement_cb(struct hci_dev *=
hdev,
>>> > @@ -463,7 +433,7 @@ static int msft_add_monitor_sync(struct hci_dev *=
hdev,
>>> >         ptrdiff_t offset =3D 0;
>>> >         u8 pattern_count =3D 0;
>>> >         struct sk_buff *skb;
>>> > -       u8 status;
>>> > +       struct msft_data *msft =3D hdev->msft_data;
>>> >
>>> >         if (!msft_monitor_pattern_valid(monitor))
>>> >                 return -EINVAL;
>>> > @@ -505,20 +475,40 @@ static int msft_add_monitor_sync(struct hci_dev=
 *hdev,
>>> >         if (IS_ERR(skb))
>>> >                 return PTR_ERR(skb);
>>> >
>>> > -       status =3D skb->data[0];
>>> > -       skb_pull(skb, 1);
>>> > +       msft->pending_add_handle =3D monitor->handle;
>>> >
>>> > -       msft_le_monitor_advertisement_cb(hdev, status, hdev->msft_opc=
ode, skb);
>>> > +       return msft_le_monitor_advertisement_cb(hdev, hdev->msft_opco=
de, skb);
>>> > +}
>>> >
>>> > -       return status;
>>> > +static void reregister_monitor(struct hci_dev *hdev)
>>> > +{
>>> > +       struct adv_monitor *monitor;
>>> > +       struct msft_data *msft =3D hdev->msft_data;
>>> > +       int handle =3D 0;
>>> > +
>>> > +       if (!msft)
>>> > +               return;
>>> > +
>>> > +       msft->resuming =3D true;
>>> > +
>>> > +       while (1) {
>>> > +               monitor =3D idr_get_next(&hdev->adv_monitors_idr, &ha=
ndle);
>>> > +               if (!monitor)
>>> > +                       break;
>>> > +
>>> > +               msft_add_monitor_sync(hdev, monitor);
>>> > +
>>> > +               handle++;
>>> > +       }
>>> > +
>>> > +       /* All monitors have been reregistered */
>>> > +       msft->resuming =3D false;
>>> >  }
>>> >
>>> >  /* This function requires the caller holds hci_req_sync_lock */
>>> >  int msft_resume_sync(struct hci_dev *hdev)
>>> >  {
>>> >         struct msft_data *msft =3D hdev->msft_data;
>>> > -       struct adv_monitor *monitor;
>>> > -       int handle =3D 0;
>>> >
>>> >         if (!msft || !msft_monitor_supported(hdev))
>>> >                 return 0;
>>> > @@ -533,24 +523,12 @@ int msft_resume_sync(struct hci_dev *hdev)
>>> >
>>> >         hci_dev_unlock(hdev);
>>> >
>>> > -       msft->resuming =3D true;
>>> > -
>>> > -       while (1) {
>>> > -               monitor =3D idr_get_next(&hdev->adv_monitors_idr, &ha=
ndle);
>>> > -               if (!monitor)
>>> > -                       break;
>>> > -
>>> > -               msft_add_monitor_sync(hdev, monitor);
>>> > -
>>> > -               handle++;
>>> > -       }
>>> > -
>>> > -       /* All monitors have been resumed */
>>> > -       msft->resuming =3D false;
>>> > +       reregister_monitor(hdev);
>>> >
>>> >         return 0;
>>> >  }
>>> >
>>> > +/* This function requires the caller holds hci_req_sync_lock */
>>> >  void msft_do_open(struct hci_dev *hdev)
>>> >  {
>>> >         struct msft_data *msft =3D hdev->msft_data;
>>> > @@ -583,7 +561,7 @@ void msft_do_open(struct hci_dev *hdev)
>>> >                 /* Monitors get removed on power off, so we need to e=
xplicitly
>>> >                  * tell the controller to re-monitor.
>>> >                  */
>>> > -               reregister_monitor(hdev, 0);
>>> > +               reregister_monitor(hdev);
>>> >         }
>>> >  }
>>> >
>>> > @@ -829,66 +807,7 @@ static void msft_le_set_advertisement_filter_ena=
ble_cb(struct hci_dev *hdev,
>>> >         hci_dev_unlock(hdev);
>>> >  }
>>> >
>>> > -/* This function requires the caller holds hdev->lock */
>>> > -static int __msft_add_monitor_pattern(struct hci_dev *hdev,
>>> > -                                     struct adv_monitor *monitor)
>>> > -{
>>> > -       struct msft_cp_le_monitor_advertisement *cp;
>>> > -       struct msft_le_monitor_advertisement_pattern_data *pattern_da=
ta;
>>> > -       struct msft_le_monitor_advertisement_pattern *pattern;
>>> > -       struct adv_pattern *entry;
>>> > -       struct hci_request req;
>>> > -       struct msft_data *msft =3D hdev->msft_data;
>>> > -       size_t total_size =3D sizeof(*cp) + sizeof(*pattern_data);
>>> > -       ptrdiff_t offset =3D 0;
>>> > -       u8 pattern_count =3D 0;
>>> > -       int err =3D 0;
>>> > -
>>> > -       if (!msft_monitor_pattern_valid(monitor))
>>> > -               return -EINVAL;
>>> > -
>>> > -       list_for_each_entry(entry, &monitor->patterns, list) {
>>> > -               pattern_count++;
>>> > -               total_size +=3D sizeof(*pattern) + entry->length;
>>> > -       }
>>> > -
>>> > -       cp =3D kmalloc(total_size, GFP_KERNEL);
>>> > -       if (!cp)
>>> > -               return -ENOMEM;
>>> > -
>>> > -       cp->sub_opcode =3D MSFT_OP_LE_MONITOR_ADVERTISEMENT;
>>> > -       cp->rssi_high =3D monitor->rssi.high_threshold;
>>> > -       cp->rssi_low =3D monitor->rssi.low_threshold;
>>> > -       cp->rssi_low_interval =3D (u8)monitor->rssi.low_threshold_tim=
eout;
>>> > -       cp->rssi_sampling_period =3D monitor->rssi.sampling_period;
>>> > -
>>> > -       cp->cond_type =3D MSFT_MONITOR_ADVERTISEMENT_TYPE_PATTERN;
>>> > -
>>> > -       pattern_data =3D (void *)cp->data;
>>> > -       pattern_data->count =3D pattern_count;
>>> > -
>>> > -       list_for_each_entry(entry, &monitor->patterns, list) {
>>> > -               pattern =3D (void *)(pattern_data->data + offset);
>>> > -               /* the length also includes data_type and offset */
>>> > -               pattern->length =3D entry->length + 2;
>>> > -               pattern->data_type =3D entry->ad_type;
>>> > -               pattern->start_byte =3D entry->offset;
>>> > -               memcpy(pattern->pattern, entry->value, entry->length)=
;
>>> > -               offset +=3D sizeof(*pattern) + entry->length;
>>> > -       }
>>> > -
>>> > -       hci_req_init(&req, hdev);
>>> > -       hci_req_add(&req, hdev->msft_opcode, total_size, cp);
>>> > -       err =3D hci_req_run_skb(&req, msft_le_monitor_advertisement_c=
b);
>>> > -       kfree(cp);
>>> > -
>>> > -       if (!err)
>>> > -               msft->pending_add_handle =3D monitor->handle;
>>> > -
>>> > -       return err;
>>> > -}
>>> > -
>>> > -/* This function requires the caller holds hdev->lock */
>>> > +/* This function requires the caller holds hci_req_sync_lock */
>>> >  int msft_add_monitor_pattern(struct hci_dev *hdev, struct adv_monito=
r *monitor)
>>> >  {
>>> >         struct msft_data *msft =3D hdev->msft_data;
>>> > @@ -899,7 +818,7 @@ int msft_add_monitor_pattern(struct hci_dev *hdev=
, struct adv_monitor *monitor)
>>> >         if (msft->resuming || msft->suspending)
>>> >                 return -EBUSY;
>>> >
>>> > -       return __msft_add_monitor_pattern(hdev, monitor);
>>> > +       return msft_add_monitor_sync(hdev, monitor);
>>> >  }
>>> >
>>> >  /* This function requires the caller holds hdev->lock */
>>> > --
>>> > 2.36.1.124.g0e6072fb45-goog
>>> >
>>>
>>>
>>> --
>>> Luiz Augusto von Dentz
>>
>>
>> Regards,
>> Manish.
>
>
> Friendly ping to review this..
>
> Regards,
> Manish.



--=20
Luiz Augusto von Dentz
