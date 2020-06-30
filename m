Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABDF420EEC8
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 08:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730481AbgF3Gs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 02:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730367AbgF3Gs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 02:48:27 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276FAC03E979
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 23:48:27 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id b6so18892581wrs.11
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 23:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XLMDo1UsxYJMELotpDQ5hxq+PK7DJHzcb1+KFvP8aG0=;
        b=RW58M7OS7OlArVG0kvfUEakS2s5DQF2UyPiSnvoqoWFzkI9MOXX2LqKxVSAex0N/pd
         YSwfgrU3vEo3/E1r2s0cCuclbQWayqu6bo1pDLXfV10T/BTp69V/js6AY0dVpbZZb+FX
         +hr6o9+cjzIchZ1TF3glX0unPfcIQPTX6i/Be5GOFmxe+XP8YhbCpDwH/kQgdj9NQXMA
         18zwOSPbADnMs4HbkNHkuY0xmLnqV1dVUkNeJD+rdHQYZq5C3fCmYvFmf9WOskxO56xJ
         ondtmjKbGKkc5SOb/sJnijswm2WRDh3K8xA+EuWG7uAVGTDeWPqkLlKv9V9JdX6x5cfu
         e7ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XLMDo1UsxYJMELotpDQ5hxq+PK7DJHzcb1+KFvP8aG0=;
        b=dlHdAncRkaJR0Kc2CDrxsIqlRr9/ElVzrqiTvJb6x0BoOLldShqGLXIK+qlnjLmm6c
         jg2gyuAwdz2Zfrp3sM8XB9CrQBvtbQKq/aGm2Wa7RI6juUK57ZJGK6KIh+tpkvBcq7Kg
         m3pZ0m++lBMioQQBAqYRNLho94DUQUDyJ58js26st8sg67j3MgtxFwwsGVT9Qn+Yr7Z1
         PgzVoae3YZpmmHlsTvV6HzAfmldi8Ci3Unww9G7sE7rW+za5UGiv/MwnvtCBT1nzcY7i
         OWlt2z3X2cwNduWJqVwp/96IXkugXueUUYXp6e/543kxEhEiceamYeNnry6m1TFTBfsw
         gsxA==
X-Gm-Message-State: AOAM532L6vz7r4AEltYUWm2kcJfXqdMFFT5c12GbfC0YbmYG06p5jLaz
        cIEV6Tw9NKh0xo4JmLeANdpyIhxC+ADqLQvOBYIxGw==
X-Google-Smtp-Source: ABdhPJxiGj2ce46YgeKfjo94LZhKWI+q485fKc5qIAWiIvNhlJ340b0LY5hRzmpr5wIz0Dofd/lpkoZQ/Feh/YDnlNA=
X-Received: by 2002:adf:828b:: with SMTP id 11mr21950031wrc.58.1593499705514;
 Mon, 29 Jun 2020 23:48:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200627105437.453053-1-apusaka@google.com> <20200627185320.RFC.v1.1.Icea550bb064a24b89f2217cf19e35b4480a31afd@changeid>
 <91CFE951-262A-4E83-8550-25445AE84B5A@holtmann.org>
In-Reply-To: <91CFE951-262A-4E83-8550-25445AE84B5A@holtmann.org>
From:   Archie Pusaka <apusaka@google.com>
Date:   Tue, 30 Jun 2020 14:48:14 +0800
Message-ID: <CAJQfnxFSfbUbPLVC-be41TqNXzr_6hLq2z=u521HL+BqxLHn_Q@mail.gmail.com>
Subject: Re: [RFC PATCH v1 1/2] Bluetooth: queue ACL packets if no handle is found
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

On Mon, 29 Jun 2020 at 14:40, Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Archie,
>
> > There is a possibility that an ACL packet is received before we
> > receive the HCI connect event for the corresponding handle. If this
> > happens, we discard the ACL packet.
> >
> > Rather than just ignoring them, this patch provides a queue for
> > incoming ACL packet without a handle. The queue is processed when
> > receiving a HCI connection event. If 2 seconds elapsed without
> > receiving the HCI connection event, assume something bad happened
> > and discard the queued packet.
> >
> > Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> > Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
>
> so two things up front. I want to hide this behind a HCI_QUIRK_OUT_OF_ORD=
ER_ACL that a transport driver has to set first. Frankly if this kind of ou=
t-of-order happens on UART or SDIO transports, then something is obviously =
going wrong. I have no plan to fix up after a fully serialized transport.
>
> Secondly, if a transport sets HCI_QUIRK_OUT_OF_ORDER_ACL, then I want thi=
s off by default. You can enable it via an experimental setting. The reason=
 here is that we have to make it really hard and fail as often as possible =
so that hardware manufactures and spec writers realize that something is fu=
ndamentally broken here.
>
> I have no problem in running the code and complaining loudly in case the =
quirk has been set. Just injecting the packets can only happen if bluetooth=
d explicitly enabled it.

Got it.

>
>
> >
> > ---
> >
> > include/net/bluetooth/hci_core.h |  8 +++
> > net/bluetooth/hci_core.c         | 84 +++++++++++++++++++++++++++++---
> > net/bluetooth/hci_event.c        |  2 +
> > 3 files changed, 88 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/h=
ci_core.h
> > index 836dc997ff94..b69ecdd0d15a 100644
> > --- a/include/net/bluetooth/hci_core.h
> > +++ b/include/net/bluetooth/hci_core.h
> > @@ -270,6 +270,9 @@ struct adv_monitor {
> > /* Default authenticated payload timeout 30s */
> > #define DEFAULT_AUTH_PAYLOAD_TIMEOUT   0x0bb8
> >
> > +/* Time to keep ACL packets without a corresponding handle queued (2s)=
 */
> > +#define PENDING_ACL_TIMEOUT          msecs_to_jiffies(2000)
> > +
>
> Do we have some btmon traces with timestamps. Isn=E2=80=99t a second enou=
gh? Actually 2 seconds is an awful long time.

When this happens in the test lab, the HCI connect event is about
0.002 second behind the first ACL packet. We can change this if
required.

>
> > struct amp_assoc {
> >       __u16   len;
> >       __u16   offset;
> > @@ -538,6 +541,9 @@ struct hci_dev {
> >       struct delayed_work     rpa_expired;
> >       bdaddr_t                rpa;
> >
> > +     struct delayed_work     remove_pending_acl;
> > +     struct sk_buff_head     pending_acl_q;
> > +
>
> can we name this ooo_q and move it to the other queues in this struct. Un=
less we want to add a Kconfig option around it, we don=E2=80=99t need to ke=
ep it here.

Ack.

>
> > #if IS_ENABLED(CONFIG_BT_LEDS)
> >       struct led_trigger      *power_led;
> > #endif
> > @@ -1773,6 +1779,8 @@ void hci_le_start_enc(struct hci_conn *conn, __le=
16 ediv, __le64 rand,
> > void hci_copy_identity_address(struct hci_dev *hdev, bdaddr_t *bdaddr,
> >                              u8 *bdaddr_type);
> >
> > +void hci_process_pending_acl(struct hci_dev *hdev, struct hci_conn *co=
nn);
> > +
> > #define SCO_AIRMODE_MASK       0x0003
> > #define SCO_AIRMODE_CVSD       0x0000
> > #define SCO_AIRMODE_TRANSP     0x0003
> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > index 7959b851cc63..30780242c267 100644
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -1786,6 +1786,7 @@ int hci_dev_do_close(struct hci_dev *hdev)
> >       skb_queue_purge(&hdev->rx_q);
> >       skb_queue_purge(&hdev->cmd_q);
> >       skb_queue_purge(&hdev->raw_q);
> > +     skb_queue_purge(&hdev->pending_acl_q);
> >
> >       /* Drop last sent command */
> >       if (hdev->sent_cmd) {
> > @@ -3518,6 +3519,78 @@ static int hci_suspend_notifier(struct notifier_=
block *nb, unsigned long action,
> >       return NOTIFY_STOP;
> > }
> >
> > +static void hci_add_pending_acl(struct hci_dev *hdev, struct sk_buff *=
skb)
> > +{
> > +     skb_queue_tail(&hdev->pending_acl_q, skb);
> > +
> > +     queue_delayed_work(hdev->workqueue, &hdev->remove_pending_acl,
> > +                        PENDING_ACL_TIMEOUT);
> > +}
> > +
> > +void hci_process_pending_acl(struct hci_dev *hdev, struct hci_conn *co=
nn)
> > +{
> > +     struct sk_buff *skb, *tmp;
> > +     struct hci_acl_hdr *hdr;
> > +     u16 handle, flags;
> > +     bool reset_timer =3D false;
> > +
> > +     skb_queue_walk_safe(&hdev->pending_acl_q, skb, tmp) {
> > +             hdr =3D (struct hci_acl_hdr *)skb->data;
> > +             handle =3D __le16_to_cpu(hdr->handle);
> > +             flags  =3D hci_flags(handle);
> > +             handle =3D hci_handle(handle);
> > +
> > +             if (handle !=3D conn->handle)
> > +                     continue;
> > +
> > +             __skb_unlink(skb, &hdev->pending_acl_q);
> > +             skb_pull(skb, HCI_ACL_HDR_SIZE);
> > +
> > +             l2cap_recv_acldata(conn, skb, flags);
> > +             reset_timer =3D true;
> > +     }
> > +
> > +     if (reset_timer)
> > +             mod_delayed_work(hdev->workqueue, &hdev->remove_pending_a=
cl,
> > +                              PENDING_ACL_TIMEOUT);
> > +}
> > +
> > +/* Remove the oldest pending ACL, and all pending ACLs with the same h=
andle */
> > +static void hci_remove_pending_acl(struct work_struct *work)
> > +{
> > +     struct hci_dev *hdev;
> > +     struct sk_buff *skb, *tmp;
> > +     struct hci_acl_hdr *hdr;
> > +     u16 handle, oldest_handle;
> > +
> > +     hdev =3D container_of(work, struct hci_dev, remove_pending_acl.wo=
rk);
> > +     skb =3D skb_dequeue(&hdev->pending_acl_q);
> > +
> > +     if (!skb)
> > +             return;
> > +
> > +     hdr =3D (struct hci_acl_hdr *)skb->data;
> > +     oldest_handle =3D hci_handle(__le16_to_cpu(hdr->handle));
> > +     kfree_skb(skb);
> > +
> > +     bt_dev_err(hdev, "ACL packet for unknown connection handle %d",
> > +                oldest_handle);
> > +
> > +     skb_queue_walk_safe(&hdev->pending_acl_q, skb, tmp) {
> > +             hdr =3D (struct hci_acl_hdr *)skb->data;
> > +             handle =3D hci_handle(__le16_to_cpu(hdr->handle));
> > +
> > +             if (handle =3D=3D oldest_handle) {
> > +                     __skb_unlink(skb, &hdev->pending_acl_q);
> > +                     kfree_skb(skb);
> > +             }
> > +     }
> > +
> > +     if (!skb_queue_empty(&hdev->pending_acl_q))
> > +             queue_delayed_work(hdev->workqueue, &hdev->remove_pending=
_acl,
> > +                                PENDING_ACL_TIMEOUT);
> > +}
> > +
>
> So I am wondering if we make this too complicated. Since generally speaki=
ng we can only have a single HCI connect complete anyway at a time. No matt=
er if the controller serializes it for us or we do it for the controller. S=
o hci_conn_add could just process the queue for packets with its handle and=
 then flush it. And it can flush it no matter what since whatever other pac=
kets are in the queue, they can not be valid.
>
> That said, we wouldn=E2=80=99t even need to check the packet handles at a=
ll. We just needed to flag them as already out-of-order queued once and han=
d them back into the rx_q at the top. Then the would be processed as usual.=
 Already ooo packets would cause the same error as before if it is for a no=
n-existing handle and others would end up being processed.
>
> For me this means we just need another queue to park the packets until hc=
i_conn_add gets called. I might have missed something, but I am looking for=
 the least invasive option for this and least code duplication.

I'm not aware of the fact that we can only have a single HCI connect
complete event at any time. Is this also true even if two / more
peripherals connect at the same time?
I was under the impression that if we have device A and B both are
connecting to us at the same time, we might receive the packets in
this order:
(1) ACL A
(2) ACL B
(3) HCI conn evt B
(4) HCI conn evt A
Hence the queue and the handle check.

>
> > /* Alloc HCI device */
> > struct hci_dev *hci_alloc_dev(void)
> > {
> > @@ -3610,10 +3683,12 @@ struct hci_dev *hci_alloc_dev(void)
> >       INIT_WORK(&hdev->suspend_prepare, hci_prepare_suspend);
> >
> >       INIT_DELAYED_WORK(&hdev->power_off, hci_power_off);
> > +     INIT_DELAYED_WORK(&hdev->remove_pending_acl, hci_remove_pending_a=
cl);
> >
> >       skb_queue_head_init(&hdev->rx_q);
> >       skb_queue_head_init(&hdev->cmd_q);
> >       skb_queue_head_init(&hdev->raw_q);
> > +     skb_queue_head_init(&hdev->pending_acl_q);
> >
> >       init_waitqueue_head(&hdev->req_wait_q);
> >       init_waitqueue_head(&hdev->suspend_wait_q);
> > @@ -4662,8 +4737,6 @@ static void hci_acldata_packet(struct hci_dev *hd=
ev, struct sk_buff *skb)
> >       struct hci_conn *conn;
> >       __u16 handle, flags;
> >
> > -     skb_pull(skb, HCI_ACL_HDR_SIZE);
> > -
> >       handle =3D __le16_to_cpu(hdr->handle);
> >       flags  =3D hci_flags(handle);
> >       handle =3D hci_handle(handle);
> > @@ -4678,17 +4751,16 @@ static void hci_acldata_packet(struct hci_dev *=
hdev, struct sk_buff *skb)
> >       hci_dev_unlock(hdev);
> >
> >       if (conn) {
> > +             skb_pull(skb, HCI_ACL_HDR_SIZE);
> > +
> >               hci_conn_enter_active_mode(conn, BT_POWER_FORCE_ACTIVE_OF=
F);
> >
> >               /* Send to upper protocol */
> >               l2cap_recv_acldata(conn, skb, flags);
> >               return;
> >       } else {
> > -             bt_dev_err(hdev, "ACL packet for unknown connection handl=
e %d",
> > -                        handle);
> > +             hci_add_pending_acl(hdev, skb);
>
> So here I want to keep being verbose. If no quirk is set, then this has t=
o stay as an error. In case the quirk is set, then this should still warn t=
hat we are queuing up a packet. It is not an expected behavior.

Ack.

>
> >       }
> > -
> > -     kfree_skb(skb);
> > }
> >
> > /* SCO data packet */
> > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > index e060fc9ebb18..108c6c102a6a 100644
> > --- a/net/bluetooth/hci_event.c
> > +++ b/net/bluetooth/hci_event.c
> > @@ -2627,6 +2627,8 @@ static void hci_conn_complete_evt(struct hci_dev =
*hdev, struct sk_buff *skb)
> >                       hci_send_cmd(hdev, HCI_OP_CHANGE_CONN_PTYPE, size=
of(cp),
> >                                    &cp);
> >               }
> > +
> > +             hci_process_pending_acl(hdev, conn);
>
> Can we just do this in hci_conn_add() when we create the connection objec=
t?

Yes, we can.

>
> >       } else {
> >               conn->state =3D BT_CLOSED;
> >               if (conn->type =3D=3D ACL_LINK)
> > --
> > 2.27.0.212.ge8ba1cc988-goog
> >
>
> Regards
>
> Marcel
>

Thanks,
Archie
