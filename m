Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9896190578
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 07:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbgCXGD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 02:03:57 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:46370 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727290AbgCXGD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 02:03:56 -0400
Received: by mail-oi1-f196.google.com with SMTP id q204so9585556oia.13;
        Mon, 23 Mar 2020 23:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aXQM/Z3C9ha9QAmAw435ry6xAMlfP4zDG5mwMXzRu3g=;
        b=gNyrtl15zm/hO468YqsyQhJEAQyPObRHT8I0nVnAgRS0W9k0+BGmVnC4oL6ah2oZ9t
         6nHXrVkgY5pJGL/gyiwen7KZfyI0vp5wtyUJimFoEZ2In2OJWklpem2Sk0sBgopNzx0N
         w8hN3cn6T6LwjnqCK6DxmY3CsA4P0PkSUMrCzC9GRqyVOje+5/7wegQqXSbZ/c62L/II
         WrnMhgg6MredeAKtniUKBY8kMrGAS2qAsQg876Y54YM/0m88mMk55+fyrJx+TDrZLBMQ
         nBbk6DmHfu4C3NdgnK0nwF0NG0Jt/Ln03nHgfrFamkovOa9Os7Ud3dxz8DQ6HafiB50X
         /g2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aXQM/Z3C9ha9QAmAw435ry6xAMlfP4zDG5mwMXzRu3g=;
        b=c1SDqntxGhwB73NV9fpT0c4XDFJ9gLPPgPgmz+/KhgwGrrXgl628uDZ2PrZgMNkuU6
         GyDxNv5OTJkeWnvbAXK+VLe6IwaOW5KZI44oYA6cFxLx5UP6BL58QIichJ51aRi9LfBj
         4jlPG23CEfhtmQrjTl4+FUOVzGf9nmnFnacGQtT1LgM/+DpjH/Vkao6LaXNE2Q6m7BOW
         b3O+4ZFJJ7AoKykq9NaOBu6YGGptxR53xzpzXneaTsnw8O+CrBah5S8eJGGPDa33damq
         ErfQQvYh5E7gDbaelIYeCq2rMSoZnA96z6sMQYm9Y12Yk2ptqctYvlkfQMW70muc9CbN
         6Tow==
X-Gm-Message-State: ANhLgQ0a+G7nTvWSFHYud+zfKr6WIpEGeBoolfQKJPF35j5xZGutGxrk
        FT2vvxHlS3Ul5hhI9azDgc56TxJ5JJLwLi7FmQc=
X-Google-Smtp-Source: ADFU+vu7falTnsahQ3umrzlRN0AwhFE8EjYM5c+7pXlH9L9V86/xRBkpsnoUNyQUeg73t1CI2yMuRiVmOtIqGCbdqJo=
X-Received: by 2002:a54:4e13:: with SMTP id a19mr2343456oiy.108.1585029835381;
 Mon, 23 Mar 2020 23:03:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200320231928.137720-1-abhishekpandit@chromium.org>
 <20200320161922.v2.1.I17e2220fd0c0822c76a15ef89b882fb4cfe3fe89@changeid>
 <C09DCA09-A2C9-4675-B17B-05CE0B5DE172@holtmann.org> <CANFp7mXG1HXKNQKn2YTsEOX6puNz=8WY6AHWac4UOiVMVQyEkg@mail.gmail.com>
In-Reply-To: <CANFp7mXG1HXKNQKn2YTsEOX6puNz=8WY6AHWac4UOiVMVQyEkg@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 23 Mar 2020 23:03:43 -0700
Message-ID: <CABBYNZLBvyjDnLpH40u1Vq9DftyC0dty2NMf9QEsazas9Ktwvw@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] Bluetooth: Prioritize SCO traffic
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek, Marcel,

On Mon, Mar 23, 2020 at 12:12 PM Abhishek Pandit-Subedi
<abhishekpandit@chromium.org> wrote:
>
> On Mon, Mar 23, 2020 at 11:58 AM Marcel Holtmann <marcel@holtmann.org> wrote:
> >
> > Hi Abhishek,
> >
> > > When scheduling TX packets, send all SCO/eSCO packets first, check for
> > > pending SCO/eSCO packets after every ACL/LE packet and send them if any
> > > are pending.  This is done to make sure that we can meet SCO deadlines
> > > on slow interfaces like UART.
> > >
> > > If we were to queue up multiple ACL packets without checking for a SCO
> > > packet, we might miss the SCO timing. For example:
> > >
> > > The time it takes to send a maximum size ACL packet (1024 bytes):
> > > t = 10/8 * 1024 bytes * 8 bits/byte * 1 packet / baudrate
> > >        where 10/8 is uart overhead due to start/stop bits per byte
> > >
> > > Replace t = 3.75ms (SCO deadline), which gives us a baudrate of 2730666.
> > >
> > > At a baudrate of 3000000, if we didn't check for SCO packets within 1024
> > > bytes, we would miss the 3.75ms timing window.
> > >
> > > Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > > ---
> > >
> > > Changes in v2:
> > > * Refactor to check for SCO/eSCO after each ACL/LE packet sent
> > > * Enabled SCO priority all the time and removed the sched_limit variable
> > >
> > > net/bluetooth/hci_core.c | 111 +++++++++++++++++++++------------------
> > > 1 file changed, 61 insertions(+), 50 deletions(-)
> > >
> > > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > > index dbd2ad3a26ed..a29177e1a9d0 100644
> > > --- a/net/bluetooth/hci_core.c
> > > +++ b/net/bluetooth/hci_core.c
> > > @@ -4239,6 +4239,60 @@ static void __check_timeout(struct hci_dev *hdev, unsigned int cnt)
> > >       }
> > > }
> > >
> > > +/* Schedule SCO */
> > > +static void hci_sched_sco(struct hci_dev *hdev)
> > > +{
> > > +     struct hci_conn *conn;
> > > +     struct sk_buff *skb;
> > > +     int quote;
> > > +
> > > +     BT_DBG("%s", hdev->name);
> > > +
> > > +     if (!hci_conn_num(hdev, SCO_LINK))
> > > +             return;
> > > +
> > > +     while (hdev->sco_cnt && (conn = hci_low_sent(hdev, SCO_LINK, &quote))) {
> > > +             while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
> > > +                     BT_DBG("skb %p len %d", skb, skb->len);
> > > +                     hci_send_frame(hdev, skb);
> > > +
> > > +                     conn->sent++;
> > > +                     if (conn->sent == ~0)
> > > +                             conn->sent = 0;
> > > +             }
> > > +     }
> > > +}
> > > +
> > > +static void hci_sched_esco(struct hci_dev *hdev)
> > > +{
> > > +     struct hci_conn *conn;
> > > +     struct sk_buff *skb;
> > > +     int quote;
> > > +
> > > +     BT_DBG("%s", hdev->name);
> > > +
> > > +     if (!hci_conn_num(hdev, ESCO_LINK))
> > > +             return;
> > > +
> > > +     while (hdev->sco_cnt && (conn = hci_low_sent(hdev, ESCO_LINK,
> > > +                                                  &quote))) {
> > > +             while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
> > > +                     BT_DBG("skb %p len %d", skb, skb->len);
> > > +                     hci_send_frame(hdev, skb);
> > > +
> > > +                     conn->sent++;
> > > +                     if (conn->sent == ~0)
> > > +                             conn->sent = 0;
> > > +             }
> > > +     }
> > > +}
> > > +
> > > +static void hci_sched_sync(struct hci_dev *hdev)
> > > +{
> > > +     hci_sched_sco(hdev);
> > > +     hci_sched_esco(hdev);
> > > +}
> > > +
> >
> > scrap this function. It has almost zero benefit.
>
> Done.
>
> >
> > > static void hci_sched_acl_pkt(struct hci_dev *hdev)
> > > {
> > >       unsigned int cnt = hdev->acl_cnt;
> > > @@ -4270,6 +4324,9 @@ static void hci_sched_acl_pkt(struct hci_dev *hdev)
> > >                       hdev->acl_cnt--;
> > >                       chan->sent++;
> > >                       chan->conn->sent++;
> > > +
> > > +                     /* Send pending SCO packets right away */
> > > +                     hci_sched_sync(hdev);
> >
> >                         hci_sched_esco();
> >                         hci_sched_sco();
> >
> > >               }
> > >       }
> > >
> > > @@ -4354,54 +4411,6 @@ static void hci_sched_acl(struct hci_dev *hdev)
> > >       }
> > > }
> > >
> > > -/* Schedule SCO */
> > > -static void hci_sched_sco(struct hci_dev *hdev)
> > > -{
> > > -     struct hci_conn *conn;
> > > -     struct sk_buff *skb;
> > > -     int quote;
> > > -
> > > -     BT_DBG("%s", hdev->name);
> > > -
> > > -     if (!hci_conn_num(hdev, SCO_LINK))
> > > -             return;
> > > -
> > > -     while (hdev->sco_cnt && (conn = hci_low_sent(hdev, SCO_LINK, &quote))) {
> > > -             while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
> > > -                     BT_DBG("skb %p len %d", skb, skb->len);
> > > -                     hci_send_frame(hdev, skb);
> > > -
> > > -                     conn->sent++;
> > > -                     if (conn->sent == ~0)
> > > -                             conn->sent = 0;
> > > -             }
> > > -     }
> > > -}
> > > -
> > > -static void hci_sched_esco(struct hci_dev *hdev)
> > > -{
> > > -     struct hci_conn *conn;
> > > -     struct sk_buff *skb;
> > > -     int quote;
> > > -
> > > -     BT_DBG("%s", hdev->name);
> > > -
> > > -     if (!hci_conn_num(hdev, ESCO_LINK))
> > > -             return;
> > > -
> > > -     while (hdev->sco_cnt && (conn = hci_low_sent(hdev, ESCO_LINK,
> > > -                                                  &quote))) {
> > > -             while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
> > > -                     BT_DBG("skb %p len %d", skb, skb->len);
> > > -                     hci_send_frame(hdev, skb);
> > > -
> > > -                     conn->sent++;
> > > -                     if (conn->sent == ~0)
> > > -                             conn->sent = 0;
> > > -             }
> > > -     }
> > > -}
> > > -
> > > static void hci_sched_le(struct hci_dev *hdev)
> > > {
> > >       struct hci_chan *chan;
> > > @@ -4436,6 +4445,9 @@ static void hci_sched_le(struct hci_dev *hdev)
> > >                       cnt--;
> > >                       chan->sent++;
> > >                       chan->conn->sent++;
> > > +
> > > +                     /* Send pending SCO packets right away */
> > > +                     hci_sched_sync(hdev);
> >
> > Same as above. Just call the two functions.
>
> Done
>
> >
> > >               }
> > >       }
> > >
> > > @@ -4458,9 +4470,8 @@ static void hci_tx_work(struct work_struct *work)
> > >
> > >       if (!hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
> > >               /* Schedule queues and send stuff to HCI driver */
> > > +             hci_sched_sync(hdev);
> > >               hci_sched_acl(hdev);
> > > -             hci_sched_sco(hdev);
> > > -             hci_sched_esco(hdev);
> > >               hci_sched_le(hdev);
> >
> > I would actually just move _le up after _acl and then keep _sco and _esco at the bottom. The calls here are just for the case there are no ACL nor LE packets.
>
> Then we would send at least 1 ACL/LE packet before SCO even if there
> were SCO pending when we entered this function. I think it is still
> better to keep SCO/eSCO at the top.

I wonder it wouldn't be better to have such prioritization done by the
driver though, since this might just be spending extra cpu cycles in
case there is enough bandwidth at the transport chances are the
reordering here just doesn't make any difference in the end, you
probably don't even need any changes to the core in order for the
driver to detect what type of frame it is based on the skb, I recall
we do already have such information in the driver so it just a matter
to reorder the frames as needed there.

>
> >
> > Regards
> >
> > Marcel
> >



-- 
Luiz Augusto von Dentz
