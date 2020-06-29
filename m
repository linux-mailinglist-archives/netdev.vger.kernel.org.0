Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63E020E8E6
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 01:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgF2Wo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 18:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgF2Woy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 18:44:54 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5828FC061755;
        Mon, 29 Jun 2020 15:44:54 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id n5so16967037otj.1;
        Mon, 29 Jun 2020 15:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7oxBdkThoZ1TkjR6dUJctYFBuF3kzU/IvmlghstoKAo=;
        b=IQ3+1y9hvM2eG3u0XY+/pIyzn0x7/ySFzMcpLzzwbK/3a0c4CoRj2hzCRN3sTRsbrU
         o0OvIGNb/9IaMd/fwnb8d4UZKasJaDCHfvF36OCxUVdFWCbUS5S4tPZp/5rNVmzPsMqw
         7/kQG1FFj020zL0HiadbKbhgjvyK0kPk+GVYhsNSfiGVm+eB54WzNlwtR0Chpz+F2CxS
         bGq+X0YL7xXijSTI1Zw8Rtmy1+VUjJv3dC7ReQh2YrlUoqlsD1jWdGc/CaH2igLRsvtl
         4t8DEQbPb9DmBlSR0zbE/+oQK8vjDHaFhbwpZPwMM+Y2YxsC3kuyCE22D4nUWH0bNOmL
         suxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7oxBdkThoZ1TkjR6dUJctYFBuF3kzU/IvmlghstoKAo=;
        b=QQMF0crSx8lHHk8C7ktqiK+RUrRm2nBKc2B3wQ/rtxeOvBIK1nISRMdBQ1WNZelrvB
         DLMrP5gztwugcbzF7rIySus5Zv3bcVBHJpC/xjGTmxSyGNm8wLXZs6UAVk8MJzZ8VPoc
         Erj2JA7ybPq+J8p9gt8QLwb2YyILTl+PhAhUTOKgWA+RoM4i5o/uHjCK1Huo06xI+UeO
         HuenLsXCNrkHQXjfRd26nrRZIxmM2NOKKuQaMGZBPwlQZ63ScUirpmG5EmBT8b4rruOc
         14iGFti3cJ4mXh69sdNe/ecOBn37wvIbHy2SRPAbDlZ9AScj57uhd/aydqnxVXWXupub
         QcNQ==
X-Gm-Message-State: AOAM531UBJtZeKteajPYzaCmwh5+4iBIaaB1oNgVZbfGIJrq27PiZIbQ
        O9mQnhUPrdTOSfKoaubJTqK/uxh544rfF7Uyqu4=
X-Google-Smtp-Source: ABdhPJwSXoZozCe1Z14W8NgofZZRiG1n/f2HoRwgJnrw0Ml9nuCoGaUtEh9vPrpJV73L6Sru3yAjRoAPvtciSIsvqgo=
X-Received: by 2002:a05:6830:1e85:: with SMTP id n5mr14971517otr.362.1593470693571;
 Mon, 29 Jun 2020 15:44:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200627105437.453053-1-apusaka@google.com> <20200627185320.RFC.v1.2.I7363a6e528433d88c5240b67cbda5a88a107f56c@changeid>
 <9117B008-7B6C-48E1-B6B6-087531652C70@holtmann.org> <CABBYNZ+jbOJGutuP_4B8YFaysiR6pGa-pCE65AEFZAXg_EV9Kg@mail.gmail.com>
 <3860C10A-DA02-49F0-9EDF-13BFF3C6C197@holtmann.org>
In-Reply-To: <3860C10A-DA02-49F0-9EDF-13BFF3C6C197@holtmann.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 29 Jun 2020 15:44:42 -0700
Message-ID: <CABBYNZ+tYaUiCqO9n33OiXLyxKGbgfbZCvXHQ39U-77yT+_WXQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 2/2] Bluetooth: queue L2CAP conn req if encryption
 is needed
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Archie Pusaka <apusaka@google.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

On Mon, Jun 29, 2020 at 1:21 PM Marcel Holtmann <marcel@holtmann.org> wrote=
:
>
> Hi Luiz,
>
> >>> It is possible to receive an L2CAP conn req for an encrypted
> >>> connection, before actually receiving the HCI change encryption
> >>> event. If this happened, the received L2CAP packet will be ignored.
> >
> > How is this possible? Or you are referring to a race between the ACL
> > and Event endpoint where the Encryption Change is actually pending to
> > be processed but we end up processing the ACL data first.
>
> you get the ACL packet with the L2CAP_Connect_Req in it and then the HCI =
Encryption Change event. However over the air they go in the different orde=
r. It is specific to the USB transport and nothing is going to fix this. Th=
e USB transport design is borked. You can only do bandaids.
>
> >>> This patch queues the L2CAP packet and process them after the
> >>> expected HCI event is received. If after 2 seconds we still don't
> >>> receive it, then we assume something bad happened and discard the
> >>> queued packets.
> >>
> >> as with the other patch, this should be behind the same quirk and expe=
rimental setting for exactly the same reasons.
> >>
> >>>
> >>> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> >>> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> >>>
> >>> ---
> >>>
> >>> include/net/bluetooth/bluetooth.h |  6 +++
> >>> include/net/bluetooth/l2cap.h     |  6 +++
> >>> net/bluetooth/hci_event.c         |  3 ++
> >>> net/bluetooth/l2cap_core.c        | 87 +++++++++++++++++++++++++++---=
-
> >>> 4 files changed, 91 insertions(+), 11 deletions(-)
> >>>
> >>> diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetoot=
h/bluetooth.h
> >>> index 7ee8041af803..e64278401084 100644
> >>> --- a/include/net/bluetooth/bluetooth.h
> >>> +++ b/include/net/bluetooth/bluetooth.h
> >>> @@ -335,7 +335,11 @@ struct l2cap_ctrl {
> >>>      u16     reqseq;
> >>>      u16     txseq;
> >>>      u8      retries;
> >>> +     u8      rsp_code;
> >>> +     u8      amp_id;
> >>> +     __u8    ident;
> >>>      __le16  psm;
> >>> +     __le16  scid;
> >>>      bdaddr_t bdaddr;
> >>>      struct l2cap_chan *chan;
> >>> };
> >>
> >> I would not bother trying to make this work with CREATE_CHAN_REQ. That=
 is if you want to setup a L2CAP channel that can be moved between BR/EDR a=
nd AMP controllers and in that case you have to read the L2CAP information =
and features first. Meaning there will have been unencrypted ACL packets. T=
his problem only exists if the remote side doesn=E2=80=99t request any vers=
ion information first.
> >>
> >>> @@ -374,6 +378,8 @@ struct bt_skb_cb {
> >>>              struct hci_ctrl hci;
> >>>      };
> >>> };
> >>> +static_assert(sizeof(struct bt_skb_cb) <=3D sizeof(((struct sk_buff =
*)0)->cb));
> >>> +
> >>> #define bt_cb(skb) ((struct bt_skb_cb *)((skb)->cb))
> >>>
> >>> #define hci_skb_pkt_type(skb) bt_cb((skb))->pkt_type
> >>> diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2=
cap.h
> >>> index 8f1e6a7a2df8..f8f6dec96f12 100644
> >>> --- a/include/net/bluetooth/l2cap.h
> >>> +++ b/include/net/bluetooth/l2cap.h
> >>> @@ -58,6 +58,7 @@
> >>> #define L2CAP_MOVE_ERTX_TIMEOUT               msecs_to_jiffies(60000)
> >>> #define L2CAP_WAIT_ACK_POLL_PERIOD    msecs_to_jiffies(200)
> >>> #define L2CAP_WAIT_ACK_TIMEOUT                msecs_to_jiffies(10000)
> >>> +#define L2CAP_PEND_ENC_CONN_TIMEOUT  msecs_to_jiffies(2000)
> >>>
> >>> #define L2CAP_A2MP_DEFAULT_MTU                670
> >>>
> >>> @@ -700,6 +701,9 @@ struct l2cap_conn {
> >>>      struct mutex            chan_lock;
> >>>      struct kref             ref;
> >>>      struct list_head        users;
> >>> +
> >>> +     struct delayed_work     remove_pending_encrypt_conn;
> >>> +     struct sk_buff_head     pending_conn_q;
> >>> };
> >>>
> >>> struct l2cap_user {
> >>> @@ -1001,4 +1005,6 @@ void l2cap_conn_put(struct l2cap_conn *conn);
> >>> int l2cap_register_user(struct l2cap_conn *conn, struct l2cap_user *u=
ser);
> >>> void l2cap_unregister_user(struct l2cap_conn *conn, struct l2cap_user=
 *user);
> >>>
> >>> +void l2cap_process_pending_encrypt_conn(struct hci_conn *hcon);
> >>> +
> >>> #endif /* __L2CAP_H */
> >>> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> >>> index 108c6c102a6a..8cefc51a5ca4 100644
> >>> --- a/net/bluetooth/hci_event.c
> >>> +++ b/net/bluetooth/hci_event.c
> >>> @@ -3136,6 +3136,9 @@ static void hci_encrypt_change_evt(struct hci_d=
ev *hdev, struct sk_buff *skb)
> >>>
> >>> unlock:
> >>>      hci_dev_unlock(hdev);
> >>> +
> >>> +     if (conn && !ev->status && ev->encrypt)
> >>> +             l2cap_process_pending_encrypt_conn(conn);
> >>> }
> >>>
> >>> static void hci_change_link_key_complete_evt(struct hci_dev *hdev,
> >>> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> >>> index 35d2bc569a2d..fc6fe2c80c46 100644
> >>> --- a/net/bluetooth/l2cap_core.c
> >>> +++ b/net/bluetooth/l2cap_core.c
> >>> @@ -62,6 +62,10 @@ static void l2cap_send_disconn_req(struct l2cap_ch=
an *chan, int err);
> >>> static void l2cap_tx(struct l2cap_chan *chan, struct l2cap_ctrl *cont=
rol,
> >>>                   struct sk_buff_head *skbs, u8 event);
> >>>
> >>> +static struct l2cap_chan *l2cap_connect(struct l2cap_conn *conn,
> >>> +                                     u8 ident, u8 *data, u8 rsp_code=
,
> >>> +                                     u8 amp_id, bool queue_if_fail);
> >>> +
> >>> static inline u8 bdaddr_type(u8 link_type, u8 bdaddr_type)
> >>> {
> >>>      if (link_type =3D=3D LE_LINK) {
> >>> @@ -1902,6 +1906,8 @@ static void l2cap_conn_del(struct hci_conn *hco=
n, int err)
> >>>      if (conn->info_state & L2CAP_INFO_FEAT_MASK_REQ_SENT)
> >>>              cancel_delayed_work_sync(&conn->info_timer);
> >>>
> >>> +     cancel_delayed_work_sync(&conn->remove_pending_encrypt_conn);
> >>> +
> >>>      hcon->l2cap_data =3D NULL;
> >>>      conn->hchan =3D NULL;
> >>>      l2cap_conn_put(conn);
> >>> @@ -2023,6 +2029,55 @@ static void l2cap_retrans_timeout(struct work_=
struct *work)
> >>>      l2cap_chan_put(chan);
> >>> }
> >>>
> >>> +static void l2cap_add_pending_encrypt_conn(struct l2cap_conn *conn,
> >>> +                                        struct l2cap_conn_req *req,
> >>> +                                        u8 ident, u8 rsp_code, u8 am=
p_id)
> >>> +{
> >>> +     struct sk_buff *skb =3D bt_skb_alloc(0, GFP_KERNEL);
> >>> +
> >>> +     bt_cb(skb)->l2cap.psm =3D req->psm;
> >>> +     bt_cb(skb)->l2cap.scid =3D req->scid;
> >>> +     bt_cb(skb)->l2cap.ident =3D ident;
> >>> +     bt_cb(skb)->l2cap.rsp_code =3D rsp_code;
> >>> +     bt_cb(skb)->l2cap.amp_id =3D amp_id;
> >>> +
> >>> +     skb_queue_tail(&conn->pending_conn_q, skb);
> >>> +     queue_delayed_work(conn->hcon->hdev->workqueue,
> >>> +                        &conn->remove_pending_encrypt_conn,
> >>> +                        L2CAP_PEND_ENC_CONN_TIMEOUT);
> >>> +}
> >>> +
> >>> +void l2cap_process_pending_encrypt_conn(struct hci_conn *hcon)
> >>> +{
> >>> +     struct sk_buff *skb;
> >>> +     struct l2cap_conn *conn =3D hcon->l2cap_data;
> >>> +
> >>> +     if (!conn)
> >>> +             return;
> >>> +
> >>> +     while ((skb =3D skb_dequeue(&conn->pending_conn_q))) {
> >>> +             struct l2cap_conn_req req;
> >>> +             u8 ident, rsp_code, amp_id;
> >>> +
> >>> +             req.psm =3D bt_cb(skb)->l2cap.psm;
> >>> +             req.scid =3D bt_cb(skb)->l2cap.scid;
> >>> +             ident =3D bt_cb(skb)->l2cap.ident;
> >>> +             rsp_code =3D bt_cb(skb)->l2cap.rsp_code;
> >>> +             amp_id =3D bt_cb(skb)->l2cap.amp_id;
> >>> +
> >>> +             l2cap_connect(conn, ident, (u8 *)&req, rsp_code, amp_id=
, false);
> >>> +             kfree_skb(skb);
> >>> +     }
> >>> +}
> >>> +
> >>> +static void l2cap_remove_pending_encrypt_conn(struct work_struct *wo=
rk)
> >>> +{
> >>> +     struct l2cap_conn *conn =3D container_of(work, struct l2cap_con=
n,
> >>> +                                         remove_pending_encrypt_conn=
.work);
> >>> +
> >>> +     l2cap_process_pending_encrypt_conn(conn->hcon);
> >>> +}
> >>> +
> >>> static void l2cap_streaming_send(struct l2cap_chan *chan,
> >>>                               struct sk_buff_head *skbs)
> >>> {
> >>> @@ -4076,8 +4131,8 @@ static inline int l2cap_command_rej(struct l2ca=
p_conn *conn,
> >>> }
> >>>
> >>> static struct l2cap_chan *l2cap_connect(struct l2cap_conn *conn,
> >>> -                                     struct l2cap_cmd_hdr *cmd,
> >>> -                                     u8 *data, u8 rsp_code, u8 amp_i=
d)
> >>> +                                     u8 ident, u8 *data, u8 rsp_code=
,
> >>> +                                     u8 amp_id, bool queue_if_fail)
> >>> {
> >>>      struct l2cap_conn_req *req =3D (struct l2cap_conn_req *) data;
> >>>      struct l2cap_conn_rsp rsp;
> >>> @@ -4103,8 +4158,15 @@ static struct l2cap_chan *l2cap_connect(struct=
 l2cap_conn *conn,
> >>>      /* Check if the ACL is secure enough (if not SDP) */
> >>>      if (psm !=3D cpu_to_le16(L2CAP_PSM_SDP) &&
> >>>          !hci_conn_check_link_mode(conn->hcon)) {
> >>> -             conn->disc_reason =3D HCI_ERROR_AUTH_FAILURE;
> >>> -             result =3D L2CAP_CR_SEC_BLOCK;
> >>> +             if (!queue_if_fail) {
> >>> +                     conn->disc_reason =3D HCI_ERROR_AUTH_FAILURE;
> >>> +                     result =3D L2CAP_CR_SEC_BLOCK;
> >>> +                     goto response;
> >>> +             }
> >>> +
> >>> +             l2cap_add_pending_encrypt_conn(conn, req, ident, rsp_co=
de,
> >>> +                                            amp_id);
> >>> +             result =3D L2CAP_CR_PEND;
> >>>              goto response;
> >>>      }
> >>
> >> So I am actually wondering if the approach is not better to send back =
a pending to the connect request like we do for everything else. And then p=
roceed with getting our remote L2CAP information. If these come back in enc=
rypted, then we can assume that we actually had encryption enabled and proc=
eed with a L2CAP connect response saying that all is fine.
> >
> > I wonder if we should resolve this by having different queues in
> > hci_recv_frame (e.g. hdev->evt_rx), that way we can dequeue the HCI
> > events before ACL so we first update the HCI states before start
> > processing the L2CAP data, thoughts? Something like this:
> >
> > https://gist.github.com/Vudentz/464fb0065a73e5c99bdb66cd2c5a1a2d
>
> No. We need to keep things serialized. We actually have to reject unencry=
pted packets.
>
> So whatever we do needs to be behind a quirk and an explicit opt-in.

While I agree we are just working around the real issue, Id guess
processing the event before ACL would work (I haven't tested it yet)
much better than leaving this up to the L2CAP layer since that
requires a timer in order for us to e.g. accept/reject the connection
request, also since this problem is known to affect other events as
well (e.g. data for ATT coming before Connection Complete) I guess
using the time the kernel takes to schedule the rx_work as the window
where we would assume the packets arrived 'at same time' so we can
resolve the conflicts between endpoints. On top of this we could
perhaps consider using a delayed work for rx_work so the driver can
actually tune up what is the time window (perhaps for USB that should
be the polling interval) where we would consider events and data that
have arrived at same time.

Or are you saying that the conflict resolution I proposed would
actually break things? I could picture any event that if it were
processed before the data at such a short time window would, note here
I'm talking about miliseconds not seconds so it is not that this will
be doing much reordering and if we go with delayed work it should be
relatively simple to add a Kconfig option(build-time)/module(runtime)
parameter to btusb to configure the interface were we would do such
reordering which the default could be 0 in which case we can just keep
queuing everything on rx_q.

> Regards
>
> Marcel
>


--=20
Luiz Augusto von Dentz
