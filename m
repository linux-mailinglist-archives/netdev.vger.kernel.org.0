Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2EA2210DB
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgGOP0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgGOP0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:26:12 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF99DC061755;
        Wed, 15 Jul 2020 08:26:11 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id 12so2509573oir.4;
        Wed, 15 Jul 2020 08:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4u0MYE5Hv4MZlWDF0+ytXg/Vh8b5Piy9y2hJOynhogo=;
        b=YBmd4Z/FA3zV0n93TF3jJ85Cupe79N4fRRDu3keVic1IjVfEC2I2qRO1URuvKUxh81
         uPXcz/CNeRcvb4Jlg+Ujq59fbYcXe86CQTAJrhJf838Z5ZQT4p/fbZnX0iDId0UX+70G
         VT4w6MPcUPZg1Qs7DfliKEbO2u/1vORQFraIRU2/SGxil8Ni5Tg/qnLCb3t7Gl7PAveq
         TixNPVrmORBGYetOV4E2wRlKko0Kp+rCAcYU2guLnJY7dg0Npmm7rODq+FOW+DWplPlt
         LJK/C7Q4Kl2aj/bm4mGa7njGcQdhtx48alzGH/eYYhus8Xek6vFoTVuako2jo6/5gItE
         GsnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4u0MYE5Hv4MZlWDF0+ytXg/Vh8b5Piy9y2hJOynhogo=;
        b=OX0sex9V4OMjYcmFsCGG4yAogbKuCvOYEkx+334WnQ3P98KmfdmqNuMdqqJ7T0OtN5
         D4fQ06tDfzzOCu319EW1gWEDj7sm69XJp3PLWxK8RxRM3qmPQUvoXdpTKmY1IFye1BzB
         0AVK5zmDM18zWls9hbVadGXexORv2xSzECcNSBg9w5wmnad62TPsrPBXd50FewP3/LOZ
         3AgJ5JiVAS7YVI12wiOfV8xqC5VYrvLEKSBKm64xui1xqXHr5l3KjWlGe+eZ7Ua4iRR/
         pL/+cl4geTiWRFU9yzv2Yuvs91IegTUgrBwm+J7vqrVr98JjvEPxcZbgpDinYGy50bb3
         cmew==
X-Gm-Message-State: AOAM530h9sOS+lgHSwH7zKvSueKeEUsxclakhGa51Xe7kVpyZIU3GAIV
        WsLUIjwNsZlLwRxSypY9wEHa9ChJxGMF2s+QYtY=
X-Google-Smtp-Source: ABdhPJyvP5/WOrJAQhh5gAFgy3OCO1l0+YuNhb0lE44rireuqmPWrg9uu4/Zd/ksXagftdMRIRBf2ykLxj9iBGqHWJc=
X-Received: by 2002:aca:4a04:: with SMTP id x4mr205534oia.152.1594826770975;
 Wed, 15 Jul 2020 08:26:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200627105437.453053-1-apusaka@google.com> <20200627185320.RFC.v1.1.Icea550bb064a24b89f2217cf19e35b4480a31afd@changeid>
 <91CFE951-262A-4E83-8550-25445AE84B5A@holtmann.org> <CAJQfnxFSfbUbPLVC-be41TqNXzr_6hLq2z=u521HL+BqxLHn_Q@mail.gmail.com>
 <7BBB55E0-FBD9-40C0-80D9-D5E7FC9F80D2@holtmann.org> <CALWDO_Vrn_pXMbkXifKFazha7BYPqLpCthqHOb9ZmVE3wDRMfA@mail.gmail.com>
 <CALWDO_X5JuDaugE-s2uaBu9DCn2gBxq22JBmq+HxmKhznFoPdA@mail.gmail.com>
In-Reply-To: <CALWDO_X5JuDaugE-s2uaBu9DCn2gBxq22JBmq+HxmKhznFoPdA@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 15 Jul 2020 08:25:54 -0700
Message-ID: <CABBYNZ+nF+2hn2HmEep7v-iUN-Ezh=NRg2bwJULFWT8q83iGwA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 1/2] Bluetooth: queue ACL packets if no handle is found
To:     Alain Michaud <alainmichaud@google.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Archie Pusaka <apusaka@google.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alain,

On Wed, Jul 15, 2020 at 8:10 AM Alain Michaud <alainmichaud@google.com> wro=
te:
>
> Resending in plain text.

I've sent a RFC to work out the ordering, that should work out for any
race where it process ACL before Events during a polling interval
(1ms) so I hope that is enough to catch all these races, if that is
not perhaps we could make the interval configurable.

>
> On Wed, Jul 15, 2020 at 9:56 AM Alain Michaud <alainmichaud@google.com> w=
rote:
> >
> > Hi Marcel,
> >
> > Sorry, just got around to this.
> >
> > On Tue, Jun 30, 2020 at 2:55 AM Marcel Holtmann <marcel@holtmann.org> w=
rote:
> >>
> >> Hi Archie,
> >>
> >> >>> There is a possibility that an ACL packet is received before we
> >> >>> receive the HCI connect event for the corresponding handle. If thi=
s
> >> >>> happens, we discard the ACL packet.
> >> >>>
> >> >>> Rather than just ignoring them, this patch provides a queue for
> >> >>> incoming ACL packet without a handle. The queue is processed when
> >> >>> receiving a HCI connection event. If 2 seconds elapsed without
> >> >>> receiving the HCI connection event, assume something bad happened
> >> >>> and discard the queued packet.
> >> >>>
> >> >>> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> >> >>> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> >> >>
> >> >> so two things up front. I want to hide this behind a HCI_QUIRK_OUT_=
OF_ORDER_ACL that a transport driver has to set first. Frankly if this kind=
 of out-of-order happens on UART or SDIO transports, then something is obvi=
ously going wrong. I have no plan to fix up after a fully serialized transp=
ort.
> >> >>
> >> >> Secondly, if a transport sets HCI_QUIRK_OUT_OF_ORDER_ACL, then I wa=
nt this off by default. You can enable it via an experimental setting. The =
reason here is that we have to make it really hard and fail as often as pos=
sible so that hardware manufactures and spec writers realize that something=
 is fundamentally broken here.
> >
> > I don't have any objection to making this explicit enable to non serial=
ized transports.  However, I do wonder what the intention is around making =
this off by default.  We already know there is a race condition between the=
 interupt and bulk endpoints over USB, so this can and does happen.  Hardwa=
re manufaturers can't relly do much about this other than trying to pull th=
e interupt endpoint more often, but that's only a workaround, it can't avoi=
d it all together.
> >
> > IMO, this seems like a legitimate fix at the host level and I don't see=
 any obvious benefits to hide this fix under an experimental feature and ma=
ke it more difficult for the customers and system integrators to discover.
> >
> >>
> >> >>
> >> >> I have no problem in running the code and complaining loudly in cas=
e the quirk has been set. Just injecting the packets can only happen if blu=
etoothd explicitly enabled it.
> >> >
> >> > Got it.
> >> >
> >> >>
> >> >>
> >> >>>
> >> >>> ---
> >> >>>
> >> >>> include/net/bluetooth/hci_core.h |  8 +++
> >> >>> net/bluetooth/hci_core.c         | 84 ++++++++++++++++++++++++++++=
+---
> >> >>> net/bluetooth/hci_event.c        |  2 +
> >> >>> 3 files changed, 88 insertions(+), 6 deletions(-)
> >> >>>
> >> >>> diff --git a/include/net/bluetooth/hci_core.h b/include/net/blueto=
oth/hci_core.h
> >> >>> index 836dc997ff94..b69ecdd0d15a 100644
> >> >>> --- a/include/net/bluetooth/hci_core.h
> >> >>> +++ b/include/net/bluetooth/hci_core.h
> >> >>> @@ -270,6 +270,9 @@ struct adv_monitor {
> >> >>> /* Default authenticated payload timeout 30s */
> >> >>> #define DEFAULT_AUTH_PAYLOAD_TIMEOUT   0x0bb8
> >> >>>
> >> >>> +/* Time to keep ACL packets without a corresponding handle queued=
 (2s) */
> >> >>> +#define PENDING_ACL_TIMEOUT          msecs_to_jiffies(2000)
> >> >>> +
> >> >>
> >> >> Do we have some btmon traces with timestamps. Isn=E2=80=99t a secon=
d enough? Actually 2 seconds is an awful long time.
> >> >
> >> > When this happens in the test lab, the HCI connect event is about
> >> > 0.002 second behind the first ACL packet. We can change this if
> >> > required.
> >> >
> >> >>
> >> >>> struct amp_assoc {
> >> >>>      __u16   len;
> >> >>>      __u16   offset;
> >> >>> @@ -538,6 +541,9 @@ struct hci_dev {
> >> >>>      struct delayed_work     rpa_expired;
> >> >>>      bdaddr_t                rpa;
> >> >>>
> >> >>> +     struct delayed_work     remove_pending_acl;
> >> >>> +     struct sk_buff_head     pending_acl_q;
> >> >>> +
> >> >>
> >> >> can we name this ooo_q and move it to the other queues in this stru=
ct. Unless we want to add a Kconfig option around it, we don=E2=80=99t need=
 to keep it here.
> >> >
> >> > Ack.
> >> >
> >> >>
> >> >>> #if IS_ENABLED(CONFIG_BT_LEDS)
> >> >>>      struct led_trigger      *power_led;
> >> >>> #endif
> >> >>> @@ -1773,6 +1779,8 @@ void hci_le_start_enc(struct hci_conn *conn,=
 __le16 ediv, __le64 rand,
> >> >>> void hci_copy_identity_address(struct hci_dev *hdev, bdaddr_t *bda=
ddr,
> >> >>>                             u8 *bdaddr_type);
> >> >>>
> >> >>> +void hci_process_pending_acl(struct hci_dev *hdev, struct hci_con=
n *conn);
> >> >>> +
> >> >>> #define SCO_AIRMODE_MASK       0x0003
> >> >>> #define SCO_AIRMODE_CVSD       0x0000
> >> >>> #define SCO_AIRMODE_TRANSP     0x0003
> >> >>> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> >> >>> index 7959b851cc63..30780242c267 100644
> >> >>> --- a/net/bluetooth/hci_core.c
> >> >>> +++ b/net/bluetooth/hci_core.c
> >> >>> @@ -1786,6 +1786,7 @@ int hci_dev_do_close(struct hci_dev *hdev)
> >> >>>      skb_queue_purge(&hdev->rx_q);
> >> >>>      skb_queue_purge(&hdev->cmd_q);
> >> >>>      skb_queue_purge(&hdev->raw_q);
> >> >>> +     skb_queue_purge(&hdev->pending_acl_q);
> >> >>>
> >> >>>      /* Drop last sent command */
> >> >>>      if (hdev->sent_cmd) {
> >> >>> @@ -3518,6 +3519,78 @@ static int hci_suspend_notifier(struct noti=
fier_block *nb, unsigned long action,
> >> >>>      return NOTIFY_STOP;
> >> >>> }
> >> >>>
> >> >>> +static void hci_add_pending_acl(struct hci_dev *hdev, struct sk_b=
uff *skb)
> >> >>> +{
> >> >>> +     skb_queue_tail(&hdev->pending_acl_q, skb);
> >> >>> +
> >> >>> +     queue_delayed_work(hdev->workqueue, &hdev->remove_pending_ac=
l,
> >> >>> +                        PENDING_ACL_TIMEOUT);
> >> >>> +}
> >> >>> +
> >> >>> +void hci_process_pending_acl(struct hci_dev *hdev, struct hci_con=
n *conn)
> >> >>> +{
> >> >>> +     struct sk_buff *skb, *tmp;
> >> >>> +     struct hci_acl_hdr *hdr;
> >> >>> +     u16 handle, flags;
> >> >>> +     bool reset_timer =3D false;
> >> >>> +
> >> >>> +     skb_queue_walk_safe(&hdev->pending_acl_q, skb, tmp) {
> >> >>> +             hdr =3D (struct hci_acl_hdr *)skb->data;
> >> >>> +             handle =3D __le16_to_cpu(hdr->handle);
> >> >>> +             flags  =3D hci_flags(handle);
> >> >>> +             handle =3D hci_handle(handle);
> >> >>> +
> >> >>> +             if (handle !=3D conn->handle)
> >> >>> +                     continue;
> >> >>> +
> >> >>> +             __skb_unlink(skb, &hdev->pending_acl_q);
> >> >>> +             skb_pull(skb, HCI_ACL_HDR_SIZE);
> >> >>> +
> >> >>> +             l2cap_recv_acldata(conn, skb, flags);
> >> >>> +             reset_timer =3D true;
> >> >>> +     }
> >> >>> +
> >> >>> +     if (reset_timer)
> >> >>> +             mod_delayed_work(hdev->workqueue, &hdev->remove_pend=
ing_acl,
> >> >>> +                              PENDING_ACL_TIMEOUT);
> >> >>> +}
> >> >>> +
> >> >>> +/* Remove the oldest pending ACL, and all pending ACLs with the s=
ame handle */
> >> >>> +static void hci_remove_pending_acl(struct work_struct *work)
> >> >>> +{
> >> >>> +     struct hci_dev *hdev;
> >> >>> +     struct sk_buff *skb, *tmp;
> >> >>> +     struct hci_acl_hdr *hdr;
> >> >>> +     u16 handle, oldest_handle;
> >> >>> +
> >> >>> +     hdev =3D container_of(work, struct hci_dev, remove_pending_a=
cl.work);
> >> >>> +     skb =3D skb_dequeue(&hdev->pending_acl_q);
> >> >>> +
> >> >>> +     if (!skb)
> >> >>> +             return;
> >> >>> +
> >> >>> +     hdr =3D (struct hci_acl_hdr *)skb->data;
> >> >>> +     oldest_handle =3D hci_handle(__le16_to_cpu(hdr->handle));
> >> >>> +     kfree_skb(skb);
> >> >>> +
> >> >>> +     bt_dev_err(hdev, "ACL packet for unknown connection handle %=
d",
> >> >>> +                oldest_handle);
> >> >>> +
> >> >>> +     skb_queue_walk_safe(&hdev->pending_acl_q, skb, tmp) {
> >> >>> +             hdr =3D (struct hci_acl_hdr *)skb->data;
> >> >>> +             handle =3D hci_handle(__le16_to_cpu(hdr->handle));
> >> >>> +
> >> >>> +             if (handle =3D=3D oldest_handle) {
> >> >>> +                     __skb_unlink(skb, &hdev->pending_acl_q);
> >> >>> +                     kfree_skb(skb);
> >> >>> +             }
> >> >>> +     }
> >> >>> +
> >> >>> +     if (!skb_queue_empty(&hdev->pending_acl_q))
> >> >>> +             queue_delayed_work(hdev->workqueue, &hdev->remove_pe=
nding_acl,
> >> >>> +                                PENDING_ACL_TIMEOUT);
> >> >>> +}
> >> >>> +
> >> >>
> >> >> So I am wondering if we make this too complicated. Since generally =
speaking we can only have a single HCI connect complete anyway at a time. N=
o matter if the controller serializes it for us or we do it for the control=
ler. So hci_conn_add could just process the queue for packets with its hand=
le and then flush it. And it can flush it no matter what since whatever oth=
er packets are in the queue, they can not be valid.
> >> >>
> >> >> That said, we wouldn=E2=80=99t even need to check the packet handle=
s at all. We just needed to flag them as already out-of-order queued once a=
nd hand them back into the rx_q at the top. Then the would be processed as =
usual. Already ooo packets would cause the same error as before if it is fo=
r a non-existing handle and others would end up being processed.
> >> >>
> >> >> For me this means we just need another queue to park the packets un=
til hci_conn_add gets called. I might have missed something, but I am looki=
ng for the least invasive option for this and least code duplication.
> >> >
> >> > I'm not aware of the fact that we can only have a single HCI connect
> >> > complete event at any time. Is this also true even if two / more
> >> > peripherals connect at the same time?
> >> > I was under the impression that if we have device A and B both are
> >> > connecting to us at the same time, we might receive the packets in
> >> > this order:
> >> > (1) ACL A
> >> > (2) ACL B
> >> > (3) HCI conn evt B
> >> > (4) HCI conn evt A
> >> > Hence the queue and the handle check.
> >>
> >> my reading from the LL state machine is that once the first LL_Connect=
_Req is processes, the controller moves out of the advertising state. So no=
 other LL_Connect_Req can be processed. So that means that connection attem=
pts are serialized.
> >>
> >> Now if you run AE and multiple instances, that might be different, but=
 then again, these instances are also offset in time and so I don=E2=80=99t=
 see how we can get more than one HCI_Connection_Complete event at a time (=
and with that a leading ACL packet).
> >>
> >> Regards
> >>
> >> Marcel
> >>
> >> --
> >> You received this message because you are subscribed to the Google Gro=
ups "ChromeOS Bluetooth Upstreaming" group.
> >> To unsubscribe from this group and stop receiving emails from it, send=
 an email to chromeos-bluetooth-upstreaming+unsubscribe@chromium.org.
> >> To post to this group, send email to chromeos-bluetooth-upstreaming@ch=
romium.org.
> >> To view this discussion on the web visit https://groups.google.com/a/c=
hromium.org/d/msgid/chromeos-bluetooth-upstreaming/7BBB55E0-FBD9-40C0-80D9-=
D5E7FC9F80D2%40holtmann.org.



--=20
Luiz Augusto von Dentz
