Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4054D643D9
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 10:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbfGJIy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 04:54:58 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:34443 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfGJIy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 04:54:57 -0400
Received: by mail-io1-f66.google.com with SMTP id k8so3114386iot.1
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 01:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6btS87boNqG1W/9Ztpa2IpNskVJOh6JYgS9t3inEIQI=;
        b=KMlYx9EOkoY8Qy/PDR4ey635CnLrzEeFzu2f9fIL5n1fifS9gS8a1BkIkyU31MnjiM
         Y3nz80EheAksIOa13APe2tRja5415pH7L5g5lEo41gMjbs9pP3JgbBNq+h9gTE8zSjBv
         rmYvAck4xvjmpWCOMDGXtQqInmhZtJ0dulXOs/yqW9QDzmu578ULxBUex3izQ/Vudti+
         leN8v/A+HVewkXLG8ycgF6WvQ/9J/Z+2I9myzqHeA5cXITUrWiiuay3Tjsvh+0n8kdOp
         j7LEOhW7cuhaZBsZGIclq/X0Huql21CWkgL4DdRYBtAMEkgaP1Pq2PxBFR1Pwvtqs5rH
         AVsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6btS87boNqG1W/9Ztpa2IpNskVJOh6JYgS9t3inEIQI=;
        b=TzQxnDbeoZfGaLUCDeVwnFeknmMbzyKe22Pz8PVtJQ3ujuNaklSIQdYkb+nN1a6BIz
         c1xX/p6kMlKzxiHGlvIFxpHgdTYhc4OAkS+8uGBy+TNxks0iEwW2aGGSqcpUttLzLUvc
         T3Lm5YLmm0wJMIyL0xdWHcp1nRvByFZ3vre5Xp9nCvshc9rsSuFyt3XMOSRich7GXW87
         eavN07mqwO5jCKAIEGDU3BbXVJFRGHSRJ8Toksenncvx6mThoXcXkKNcaNFjE1KCqUY1
         fTaydd7s5M0ao++1bizaKA6lXW5vXoWvt6NF8sHHRlr7vTymymtk1erHTSsalnLB7qmM
         0RfQ==
X-Gm-Message-State: APjAAAXx5l8XDM2EbwwREi/iBMVaTcCw7zJxmMNa3VBhbEdXBQUVe+TX
        KqTfP3lkY0ijf1+pxQrTLYCONdR/DJvhYlzoEpfxrQ==
X-Google-Smtp-Source: APXvYqzd0nxeZ9lB5IZ76B3/bU7p8OUZW8Srs3S5MbtTinl4Liud6ku3Tq/DVCe/x6WFKpP5lVM6DWxlctD43KSfvXE=
X-Received: by 2002:a02:b10b:: with SMTP id r11mr6018114jah.140.1562748896251;
 Wed, 10 Jul 2019 01:54:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190708063252.4756-1-jian-hong@endlessm.com> <20190709102059.7036-1-jian-hong@endlessm.com>
 <F7CD281DE3E379468C6D07993EA72F84D1864779@RTITMBSVM04.realtek.com.tw>
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D1864779@RTITMBSVM04.realtek.com.tw>
From:   Jian-Hong Pan <jian-hong@endlessm.com>
Date:   Wed, 10 Jul 2019 16:54:19 +0800
Message-ID: <CAPpJ_ee+CVCu5uUK_Ki6s+yxqrJ_fS5Wm=7y1cDV2MQ8+XyNkA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] rtw88: pci: Rearrange the memory usage for skb in
 RX ISR
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        David Laight <David.Laight@aculab.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>,
        Daniel Drake <drake@endlessm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> =E6=96=BC 2019=E5=B9=B47=E6=9C=8810=E6=
=97=A5 =E9=80=B1=E4=B8=89 =E4=B8=8B=E5=8D=884:37=E5=AF=AB=E9=81=93=EF=BC=9A
>
> > Subject: [PATCH v2 1/2] rtw88: pci: Rearrange the memory usage for skb =
in
> > RX ISR
> >
> > Testing with RTL8822BE hardware, when available memory is low, we
> > frequently see a kernel panic and system freeze.
> >
> > First, rtw_pci_rx_isr encounters a memory allocation failure (trimmed):
> >
> > rx routine starvation
> > WARNING: CPU: 7 PID: 9871 at drivers/net/wireless/realtek/rtw88/pci.c:8=
22
> > rtw_pci_rx_isr.constprop.25+0x35a/0x370 [rtwpci]
> > [ 2356.580313] RIP: 0010:rtw_pci_rx_isr.constprop.25+0x35a/0x370 [rtwpc=
i]
> >
> > Then we see a variety of different error conditions and kernel panics,
> > such as this one (trimmed):
> >
> > rtw_pci 0000:02:00.0: pci bus timeout, check dma status
> > skbuff: skb_over_panic: text:00000000091b6e66 len:415 put:415
> > head:00000000d2880c6f data:000000007a02b1ea tail:0x1df end:0xc0
> > dev:<NULL>
> > ------------[ cut here ]------------
> > kernel BUG at net/core/skbuff.c:105!
> > invalid opcode: 0000 [#1] SMP NOPTI
> > RIP: 0010:skb_panic+0x43/0x45
> >
> > When skb allocation fails and the "rx routine starvation" is hit, the
> > function returns immediately without updating the RX ring. At this
> > point, the RX ring may continue referencing an old skb which was alread=
y
> > handed off to ieee80211_rx_irqsafe(). When it comes to be used again,
> > bad things happen.
> >
> > This patch allocates a new, data-sized skb first in RX ISR. After
> > copying the data in, we pass it to the upper layers. However, if skb
> > allocation fails, we effectively drop the frame. In both cases, the
> > original, full size ring skb is reused.
> >
> > In addition, to fixing the kernel crash, the RX routine should now
> > generally behave better under low memory conditions.
> >
> > Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=3D204053
> > Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> > Cc: <stable@vger.kernel.org>
> > ---
> >  drivers/net/wireless/realtek/rtw88/pci.c | 49 +++++++++++-------------
> >  1 file changed, 22 insertions(+), 27 deletions(-)
> >
> > diff --git a/drivers/net/wireless/realtek/rtw88/pci.c
> > b/drivers/net/wireless/realtek/rtw88/pci.c
> > index cfe05ba7280d..e9fe3ad896c8 100644
> > --- a/drivers/net/wireless/realtek/rtw88/pci.c
> > +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> > @@ -763,6 +763,7 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev,
> > struct rtw_pci *rtwpci,
> >       u32 pkt_offset;
> >       u32 pkt_desc_sz =3D chip->rx_pkt_desc_sz;
> >       u32 buf_desc_sz =3D chip->rx_buf_desc_sz;
> > +     u32 new_len;
> >       u8 *rx_desc;
> >       dma_addr_t dma;
> >
> > @@ -790,40 +791,34 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev=
,
> > struct rtw_pci *rtwpci,
> >               pkt_offset =3D pkt_desc_sz + pkt_stat.drv_info_sz +
> >                            pkt_stat.shift;
> >
> > -             if (pkt_stat.is_c2h) {
> > -                     /* keep rx_desc, halmac needs it */
> > -                     skb_put(skb, pkt_stat.pkt_len + pkt_offset);
> > +             /* discard current skb if the new skb cannot be allocated=
 as a
> > +              * new one in rx ring later
> > +              */
> > +             new_len =3D pkt_stat.pkt_len + pkt_offset;
> > +             new =3D dev_alloc_skb(new_len);
> > +             if (WARN_ONCE(!new, "rx routine starvation\n"))
> > +                     goto next_rp;
> > +
> > +             /* put the DMA data including rx_desc from phy to new skb=
 */
> > +             skb_put_data(new, skb->data, new_len);
> >
> > -                     /* pass offset for further operation */
> > -                     *((u32 *)skb->cb) =3D pkt_offset;
> > -                     skb_queue_tail(&rtwdev->c2h_queue, skb);
> > +             if (pkt_stat.is_c2h) {
> > +                      /* pass rx_desc & offset for further operation *=
/
> > +                     *((u32 *)new->cb) =3D pkt_offset;
> > +                     skb_queue_tail(&rtwdev->c2h_queue, new);
> >                       ieee80211_queue_work(rtwdev->hw, &rtwdev->c2h_wor=
k);
> >               } else {
> > -                     /* remove rx_desc, maybe use skb_pull? */
> > -                     skb_put(skb, pkt_stat.pkt_len);
> > -                     skb_reserve(skb, pkt_offset);
> > -
> > -                     /* alloc a smaller skb to mac80211 */
> > -                     new =3D dev_alloc_skb(pkt_stat.pkt_len);
> > -                     if (!new) {
> > -                             new =3D skb;
> > -                     } else {
> > -                             skb_put_data(new, skb->data, skb->len);
> > -                             dev_kfree_skb_any(skb);
> > -                     }
> > -                     /* TODO: merge into rx.c */
> > -                     rtw_rx_stats(rtwdev, pkt_stat.vif, skb);
> > +                     /* remove rx_desc */
> > +                     skb_pull(new, pkt_offset);
> > +
> > +                     rtw_rx_stats(rtwdev, pkt_stat.vif, new);
> >                       memcpy(new->cb, &rx_status, sizeof(rx_status));
> >                       ieee80211_rx_irqsafe(rtwdev->hw, new);
> >               }
> >
> > -             /* skb delivered to mac80211, alloc a new one in rx ring =
*/
> > -             new =3D dev_alloc_skb(RTK_PCI_RX_BUF_SIZE);
> > -             if (WARN(!new, "rx routine starvation\n"))
> > -                     return;
> > -
> > -             ring->buf[cur_rp] =3D new;
> > -             rtw_pci_reset_rx_desc(rtwdev, new, ring, cur_rp, buf_desc=
_sz);
> > +next_rp:
> > +             /* new skb delivered to mac80211, re-enable original skb =
DMA */
> > +             rtw_pci_reset_rx_desc(rtwdev, skb, ring, cur_rp, buf_desc=
_sz);
> >
> >               /* host read next element in ring */
> >               if (++cur_rp >=3D ring->r.len)
> > --
> > 2.22.0
>
> Now it looks good to me. Thanks.
>
> Acked-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
>
> Yan-Hsuan

Uh!  Thanks for your ack.
But I just sent version 3 patches (including [PATCH v3 2/2] rtw88:
pci: Use DMA sync instead of remapping in RX ISR) by following
Christoph's comment. [1]

Could you please also review the 2 patches of version 3?  Thank you.

[1]: https://lkml.org/lkml/2019/7/9/507

Jian-Hong Pan
