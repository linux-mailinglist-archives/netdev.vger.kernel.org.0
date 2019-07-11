Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21A246516D
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 07:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbfGKF2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 01:28:44 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44814 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbfGKF2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 01:28:44 -0400
Received: by mail-io1-f67.google.com with SMTP id s7so9779568iob.11
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 22:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vPpImF5Vqld0BhLorZ2UCiGiPMT4QstG+jkRU93BArE=;
        b=BXakk6i+B/mMk1ySsZ/qSH7ctqYMX1lGtyLprFUsVqXsqlzjkdwSL8qS4OZPWsze6I
         o3V51LLVzqNAFGO4TOH9ujPEFFBZrJeEAvfOBs6GWxT2fZz4C/XtbPhi7/373AcjrRXn
         nE7clX0bDFFqeP/0qnL19V0821T0Z8gDynmpQSpVbvm9O6MHxKHz3qBzs33M/JABp3nT
         o04BZT/eoUGJixfuXumycJIpVSY+9P0QtM7GwnzT+vG55y/HR7o8y+0+r5cZKhM2maN7
         X6pCUiBtEHGDT7dnk2GbKXK/L+MdCJZjpKkzkZvagfmlOwcsPuXfnSBvB5Yss+GBab+1
         GIaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vPpImF5Vqld0BhLorZ2UCiGiPMT4QstG+jkRU93BArE=;
        b=tPug+3B7SKlG3wbaUN6dVdhewpJMoOuMGkM6/ZzPecdJ77TFaUmQ2UkPUBITsiQSb9
         Oz+dW70U2vCVL98AVIMw901OtYxLvwxEgysK3YK00UCceraNV27FWhdpWsluT1if+bc/
         WClAoY+yCKe8JWyTNW9ihg/aS6Pwno1BDLF0g4RSzgILpabUD+PkUBnVPCKgvCb6+UGr
         234qBd31yE45ahek+Y3rBFX2q95cAWRTJUZQ2JNnth6Q42k2aC+CZywtWK7bYy6eQpTw
         w4pFDbIbyGZMtH59AbiGLRn+wTRI8y/qYQ5ilpZMVh/t/i8828XJmzlzljWr/jeAnzf2
         B3eA==
X-Gm-Message-State: APjAAAVORZ5ziL6cpGrSmVqxlN0tJxEgRJzWv/GUySZeOk2MXn2hg3MT
        kS2Vp+/w7s0hrPeA1oazJ4yUZCQK7NsqWOBYATmWOw==
X-Google-Smtp-Source: APXvYqyHmEbuz1Uj55NEuGO/TWtnoSaURWNYW+nMCYQIcZ52vGdo2OnUVAyO6h+soskohwMN93tfdQFAKxErBh4s0z8=
X-Received: by 2002:a02:b016:: with SMTP id p22mr1195853jah.121.1562822923206;
 Wed, 10 Jul 2019 22:28:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAPpJ_edDcaBq+0DocPmS-yYM10B4MkWvBn=f6wwbYdqzSGmp_g@mail.gmail.com>
 <20190711052427.5582-1-jian-hong@endlessm.com>
In-Reply-To: <20190711052427.5582-1-jian-hong@endlessm.com>
From:   Jian-Hong Pan <jian-hong@endlessm.com>
Date:   Thu, 11 Jul 2019 13:28:06 +0800
Message-ID: <CAPpJ_edQRMiBcdB-dTxhti8nK0eX4GPRUOgimzWW1JC3ZZjRHw@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] rtw88: pci: Rearrange the memory usage for skb in
 RX ISR
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        David Laight <David.Laight@aculab.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-wireless@vger.kernel.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Daniel Drake <drake@endlessm.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jian-Hong Pan <jian-hong@endlessm.com> =E6=96=BC 2019=E5=B9=B47=E6=9C=8811=
=E6=97=A5 =E9=80=B1=E5=9B=9B =E4=B8=8B=E5=8D=881:25=E5=AF=AB=E9=81=93=EF=BC=
=9A
>
> Testing with RTL8822BE hardware, when available memory is low, we
> frequently see a kernel panic and system freeze.
>
> First, rtw_pci_rx_isr encounters a memory allocation failure (trimmed):
>
> rx routine starvation
> WARNING: CPU: 7 PID: 9871 at drivers/net/wireless/realtek/rtw88/pci.c:822=
 rtw_pci_rx_isr.constprop.25+0x35a/0x370 [rtwpci]
> [ 2356.580313] RIP: 0010:rtw_pci_rx_isr.constprop.25+0x35a/0x370 [rtwpci]
>
> Then we see a variety of different error conditions and kernel panics,
> such as this one (trimmed):
>
> rtw_pci 0000:02:00.0: pci bus timeout, check dma status
> skbuff: skb_over_panic: text:00000000091b6e66 len:415 put:415 head:000000=
00d2880c6f data:000000007a02b1ea tail:0x1df end:0xc0 dev:<NULL>
> ------------[ cut here ]------------
> kernel BUG at net/core/skbuff.c:105!
> invalid opcode: 0000 [#1] SMP NOPTI
> RIP: 0010:skb_panic+0x43/0x45
>
> When skb allocation fails and the "rx routine starvation" is hit, the
> function returns immediately without updating the RX ring. At this
> point, the RX ring may continue referencing an old skb which was already
> handed off to ieee80211_rx_irqsafe(). When it comes to be used again,
> bad things happen.
>
> This patch allocates a new, data-sized skb first in RX ISR. After
> copying the data in, we pass it to the upper layers. However, if skb
> allocation fails, we effectively drop the frame. In both cases, the
> original, full size ring skb is reused.
>
> In addition, to fixing the kernel crash, the RX routine should now
> generally behave better under low memory conditions.
>
> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=3D204053
> Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> Cc: <stable@vger.kernel.org>
> ---

Sorry, I forget to place the version difference here.

v2:
 - Allocate new data-sized skb and put data into it, then pass it to
   mac80211. Reuse the original skb in RX ring by DMA sync.
 - Modify the commit message.
 - Introduce following [PATCH v3 2/2] rtw88: pci: Use DMA sync instead
   of remapping in RX ISR.

v3:
 - Same as v2.

v4:
 - Fix comment: allocate a new skb for this frame, discard the frame
if none available

>  drivers/net/wireless/realtek/rtw88/pci.c | 49 +++++++++++-------------
>  1 file changed, 22 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wirel=
ess/realtek/rtw88/pci.c
> index cfe05ba7280d..c415f5e94fed 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -763,6 +763,7 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, st=
ruct rtw_pci *rtwpci,
>         u32 pkt_offset;
>         u32 pkt_desc_sz =3D chip->rx_pkt_desc_sz;
>         u32 buf_desc_sz =3D chip->rx_buf_desc_sz;
> +       u32 new_len;
>         u8 *rx_desc;
>         dma_addr_t dma;
>
> @@ -790,40 +791,34 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, =
struct rtw_pci *rtwpci,
>                 pkt_offset =3D pkt_desc_sz + pkt_stat.drv_info_sz +
>                              pkt_stat.shift;
>
> -               if (pkt_stat.is_c2h) {
> -                       /* keep rx_desc, halmac needs it */
> -                       skb_put(skb, pkt_stat.pkt_len + pkt_offset);
> +               /* allocate a new skb for this frame,
> +                * discard the frame if none available
> +                */
> +               new_len =3D pkt_stat.pkt_len + pkt_offset;
> +               new =3D dev_alloc_skb(new_len);
> +               if (WARN_ONCE(!new, "rx routine starvation\n"))
> +                       goto next_rp;
> +
> +               /* put the DMA data including rx_desc from phy to new skb=
 */
> +               skb_put_data(new, skb->data, new_len);
>
> -                       /* pass offset for further operation */
> -                       *((u32 *)skb->cb) =3D pkt_offset;
> -                       skb_queue_tail(&rtwdev->c2h_queue, skb);
> +               if (pkt_stat.is_c2h) {
> +                        /* pass rx_desc & offset for further operation *=
/
> +                       *((u32 *)new->cb) =3D pkt_offset;
> +                       skb_queue_tail(&rtwdev->c2h_queue, new);
>                         ieee80211_queue_work(rtwdev->hw, &rtwdev->c2h_wor=
k);
>                 } else {
> -                       /* remove rx_desc, maybe use skb_pull? */
> -                       skb_put(skb, pkt_stat.pkt_len);
> -                       skb_reserve(skb, pkt_offset);
> -
> -                       /* alloc a smaller skb to mac80211 */
> -                       new =3D dev_alloc_skb(pkt_stat.pkt_len);
> -                       if (!new) {
> -                               new =3D skb;
> -                       } else {
> -                               skb_put_data(new, skb->data, skb->len);
> -                               dev_kfree_skb_any(skb);
> -                       }
> -                       /* TODO: merge into rx.c */
> -                       rtw_rx_stats(rtwdev, pkt_stat.vif, skb);
> +                       /* remove rx_desc */
> +                       skb_pull(new, pkt_offset);
> +
> +                       rtw_rx_stats(rtwdev, pkt_stat.vif, new);
>                         memcpy(new->cb, &rx_status, sizeof(rx_status));
>                         ieee80211_rx_irqsafe(rtwdev->hw, new);
>                 }
>
> -               /* skb delivered to mac80211, alloc a new one in rx ring =
*/
> -               new =3D dev_alloc_skb(RTK_PCI_RX_BUF_SIZE);
> -               if (WARN(!new, "rx routine starvation\n"))
> -                       return;
> -
> -               ring->buf[cur_rp] =3D new;
> -               rtw_pci_reset_rx_desc(rtwdev, new, ring, cur_rp, buf_desc=
_sz);
> +next_rp:
> +               /* new skb delivered to mac80211, re-enable original skb =
DMA */
> +               rtw_pci_reset_rx_desc(rtwdev, skb, ring, cur_rp, buf_desc=
_sz);
>
>                 /* host read next element in ring */
>                 if (++cur_rp >=3D ring->r.len)
> --
> 2.22.0
>
