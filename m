Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC92D650B3
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 05:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbfGKDv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 23:51:29 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:34740 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbfGKDv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 23:51:28 -0400
Received: by mail-io1-f65.google.com with SMTP id k8so9570773iot.1
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 20:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DcUphRJE8VDWWswonMjwWOgY+XW0K1YIqgJ7+SpeBD4=;
        b=saY8bvMHnYCBiCzIcn9nYBAa2oFai2VGDCb5sU0DOkA0z8eFKTf7FamhLNlObwGORt
         VR9zXgjgI1MgraHLdO/ByNu5qQILsQprOJiQYvRcFUa8+k+azErnFtCAN9KS8X4yIvwy
         nrsTNfQr4U1oTthVkRRaD61Pv/zr0NWhUDSZsCfIGNj2YjlxCUJew+UfzkkMj+F1VMAX
         kCYmdjj5nGuc6O8B3iyb44aBvwFcq851AXqdsV4AgSEOWl43wDH9xleDtLExgWNpXCx/
         n8sGe7OHuul7GGqwPWz8DAjgVFYKMvzh4Yw7nDzfERlDXMJEe7puicT2byJgaVeNfZ0L
         n/VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DcUphRJE8VDWWswonMjwWOgY+XW0K1YIqgJ7+SpeBD4=;
        b=QabuRLC2+LQEuagop8FgDndzN8zMLTIpgsuDHWphdQgmO1Uz1Beas9vb+LqIMC08T3
         Lcng+64G6OU2jGeChowc4V+sGklLJNtHSZxb0BU6ToLXf2rB2CtmpjsuJLmzgOCdeulu
         4XA3DfTSHNADOKqM8JuFb+4EBk4Jrrf5iR6w0Dt0ce2DkbmeTy6GkN/fbG0lD26c+o2F
         v34Ct38sW5uXfE8yGf8NFzEl8m9SF+0ZqN7ie4+GnhGmBc1WL3RI5WEC+RlhIBRIqd7C
         VVky4IW4jSLsvJatn/P/DN4u/Qik+sW6UCtA83v5GcgG4OutFn6yV9AUMFzj1BqOmgUi
         0DkA==
X-Gm-Message-State: APjAAAWK1hKwFYPI0oqD1gBi/cK0smSydPB05VMldaQRSLxG4vdkP9jK
        rjFGuEK3gFbTI29Y7APzKvS7/2s2x9tTP45K8jfqyQ==
X-Google-Smtp-Source: APXvYqwKB8Dp5TQtyW9x2EbGV/t1Ec8ya9ucu+Ar38Ip3ApPlTT9c2GRddxstUEIwOEc7etUK9RGbVuF+mI33ju2BaM=
X-Received: by 2002:a05:6602:2413:: with SMTP id s19mr1922145ioa.161.1562817087451;
 Wed, 10 Jul 2019 20:51:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190709161550.GA8703@infradead.org> <20190710083825.7115-1-jian-hong@endlessm.com>
 <81a2b91c4b084617bab8656fca932f6d@AcuMS.aculab.com>
In-Reply-To: <81a2b91c4b084617bab8656fca932f6d@AcuMS.aculab.com>
From:   Jian-Hong Pan <jian-hong@endlessm.com>
Date:   Thu, 11 Jul 2019 11:50:50 +0800
Message-ID: <CAPpJ_edDcaBq+0DocPmS-yYM10B4MkWvBn=f6wwbYdqzSGmp_g@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] rtw88: pci: Rearrange the memory usage for skb in
 RX ISR
To:     David Laight <David.Laight@aculab.com>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Christoph Hellwig <hch@infradead.org>,
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

David Laight <David.Laight@aculab.com> =E6=96=BC 2019=E5=B9=B47=E6=9C=8810=
=E6=97=A5 =E9=80=B1=E4=B8=89 =E4=B8=8B=E5=8D=884:57=E5=AF=AB=E9=81=93=EF=BC=
=9A
>
> From: Jian-Hong Pan
> > Sent: 10 July 2019 09:38
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
> > skbuff: skb_over_panic: text:00000000091b6e66 len:415 put:415 head:0000=
0000d2880c6f
> > data:000000007a02b1ea tail:0x1df end:0xc0 dev:<NULL>
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
> > In addition, by fixing the kernel crash, the RX routine should now
> > generally behave better under low memory conditions.
>
> A couple of minor nits (see below).
> You may want to do a followup patch that changes the rx buffers
> (used by the hardware) to by just memory buffers.
> Nothing (probably) relies on them being skb with all the accociated
> baggage.

It is a good idea for later commit.

>         David
>
> >
> > Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=3D204053
> > Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> > Cc: <stable@vger.kernel.org>
> > ---
> > v2:
> >  - Allocate new data-sized skb and put data into it, then pass it to
> >    mac80211. Reuse the original skb in RX ring by DMA sync.
> >  - Modify the commit message.
> >  - Introduce following [PATCH v3 2/2] rtw88: pci: Use DMA sync instead
> >    of remapping in RX ISR.
> >
> > v3:
> >  - Same as v2.
> >
> >  drivers/net/wireless/realtek/rtw88/pci.c | 49 +++++++++++-------------
> >  1 file changed, 22 insertions(+), 27 deletions(-)
> >
> > diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wir=
eless/realtek/rtw88/pci.c
> > index cfe05ba7280d..e9fe3ad896c8 100644
> > --- a/drivers/net/wireless/realtek/rtw88/pci.c
> > +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> > @@ -763,6 +763,7 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, =
struct rtw_pci *rtwpci,
> >       u32 pkt_offset;
> >       u32 pkt_desc_sz =3D chip->rx_pkt_desc_sz;
> >       u32 buf_desc_sz =3D chip->rx_buf_desc_sz;
> > +     u32 new_len;
> >       u8 *rx_desc;
> >       dma_addr_t dma;
> >
> > @@ -790,40 +791,34 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev=
, struct rtw_pci *rtwpci,
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
>
> That comment isn't quite right.
> maybe: "Allocate a new skb for this frame, discard if none available"

Thanks!  I will tweak it.

> > +             new_len =3D pkt_stat.pkt_len + pkt_offset;
> > +             new =3D dev_alloc_skb(new_len);
> > +             if (WARN_ONCE(!new, "rx routine starvation\n"))
>
> I think you should count these??

Larry has a different idea here. [1]
I agree with Larry that just need to know not enough memory here.

[1] https://lkml.org/lkml/2019/7/8/1049

Jian-Hong Pan

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
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1=
 1PT, UK
> Registration No: 1397386 (Wales)
>
