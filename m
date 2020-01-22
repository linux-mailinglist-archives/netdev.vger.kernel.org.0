Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EABDC145CB1
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 20:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgAVTvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 14:51:05 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51139 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgAVTvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 14:51:04 -0500
Received: by mail-wm1-f67.google.com with SMTP id a5so20535wmb.0
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 11:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UUWEQnj6ocpoUF6imtkh5Cyk0Eqj7fSIEggNqCMRbbo=;
        b=VKQb0eX4dFgUK0F6KCMse0GkaIploddSqUaD6lLVI/j2bKhm+6zCWTfUw7suGidCxU
         sCiRgDYAES+q1vy9EobDO5O0Eh88NIoLLfcXaYDGC5fEH8dzb2ekZ/W8jx8F+Nl8Jlpq
         KmdtoCk9mmCnVetCvtBrpIbECLR0MkWBnvjqGossKavsLCBHakI7ILD5UrdY61RLFHsu
         yP6hOdmSF7DWaXU0O6n2OUXyj58CaYCWgymrng5WhrEAaBqt85VZ23FPcs9pDBEf0zOZ
         xr8exSRHLpKcNhjY8V/twv0vprGuWkJxFfRtgwI17Kp59ZzKktQIvrYhtRPLBpNoq4K4
         h8VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UUWEQnj6ocpoUF6imtkh5Cyk0Eqj7fSIEggNqCMRbbo=;
        b=Vb8A159azutWgaQD52HJvtbwm40nq9EF+txlMH9Rvenq3VNY7JZu2lXRYcLwHCNnRZ
         TkoWuj48Y1EaoQAX6OyFzsevRfdeVcZpAobjJq4fE3bdyytX1tTgcrZ9ZfO7LRhtkZLF
         VfyExf0R6cX0aExsk39kux02GuTPNPB3AOsPDchVSR+SzW0iFGT7p3pBkjFgL2+S0eb/
         V5fmla3WlEjXc8yBTdz155jlBT0w3fUK/LfG2mR3W2QWCOJ5F/0oyY+/a6Qjvac+/n0M
         J9R5noy8s6LjNkeaUPZXLyGKhAngJ+zjOYTgfd60ZjIZNiMHAn/RFFIZs+XRW/3ZQTOS
         VcEQ==
X-Gm-Message-State: APjAAAViVgfapoD/bBYJkZ2WbUIQowHnYSrgW3VP/zYHLlMI4HxMf76K
        wSLm4oKkCt2Oa+BGaFGyM7IXjQ4mxCt/HaqVfCOK8iEd
X-Google-Smtp-Source: APXvYqxRCqbY7bF9C+l/xzbXoXQCkQ5MmvfsDGEEpCYSC5EtALrAgVW6RSaFLmtIGF2nfIwh47PnNLUxxSrmdGO7SzE=
X-Received: by 2002:a7b:cc97:: with SMTP id p23mr4485000wma.89.1579722663004;
 Wed, 22 Jan 2020 11:51:03 -0800 (PST)
MIME-Version: 1.0
References: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
 <1579612911-24497-8-git-send-email-sunil.kovvuri@gmail.com> <20200121085425.652eae8c@cakuba>
In-Reply-To: <20200121085425.652eae8c@cakuba>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Thu, 23 Jan 2020 01:20:51 +0530
Message-ID: <CA+sq2CdX31cqsSc=qRhbcZ5fOk2zGOrhTMGqhsPddbhW=YQPCQ@mail.gmail.com>
Subject: Re: [PATCH v4 07/17] octeontx2-pf: Add packet transmission support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 10:24 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 21 Jan 2020 18:51:41 +0530, sunil.kovvuri@gmail.com wrote:
> > From: Sunil Goutham <sgoutham@marvell.com>
> >
> > This patch adds the packet transmission support.
> > For a given skb prepares send queue descriptors (SQEs) and pushes them
> > to HW. Here driver doesn't maintain it's own SQ rings, SQEs are pushed
> > to HW using a silicon specific operations called LMTST. From the
> > instuction HW derives the transmit queue number and queues the SQE to
> > that queue. These LMTST instructions are designed to avoid queue
> > maintenance in SW and lockless behavior ie when multiple cores are trying
> > to add SQEs to same queue then HW will takecare of serialization, no need
> > for SW to hold locks.
> >
> > Also supports scatter/gather.
> >
> > Co-developed-by: Geetha sowjanya <gakula@marvell.com>
> > Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
>
> > +static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
> > +
>
> Spurious new line
>
> > +{
> > +     struct otx2_nic *pf = netdev_priv(netdev);
> > +     int qidx = skb_get_queue_mapping(skb);
> > +     struct otx2_snd_queue *sq;
> > +     struct netdev_queue *txq;
> > +
> > +     /* Check for minimum and maximum packet length */
>
> You only check for min

Hmm.. will fix the comment.

>
> > +     if (skb->len <= ETH_HLEN) {
> > +             dev_kfree_skb(skb);
> > +             return NETDEV_TX_OK;
> > +     }
> > +
> > +     sq = &pf->qset.sq[qidx];
> > +     txq = netdev_get_tx_queue(netdev, qidx);
> > +
> > +     if (netif_tx_queue_stopped(txq)) {
> > +             dev_kfree_skb(skb);
>
> This should never happen.
>
> > +     } else if (!otx2_sq_append_skb(netdev, sq, skb, qidx)) {
> > +             netif_tx_stop_queue(txq);
> > +
> > +             /* Check again, incase SQBs got freed up */
> > +             smp_mb();
> > +             if (((sq->num_sqbs - *sq->aura_fc_addr) * sq->sqe_per_sqb)
> > +                                                     > sq->sqe_thresh)
> > +                     netif_tx_wake_queue(txq);
> > +
> > +             return NETDEV_TX_BUSY;
> > +     }
> > +
> > +     return NETDEV_TX_OK;
> > +}
>
> > +/* NIX send memory subdescriptor structure */
> > +struct nix_sqe_mem_s {
> > +#if defined(__BIG_ENDIAN_BITFIELD)  /* W0 */
> > +     u64 subdc         : 4;
> > +     u64 alg           : 4;
> > +     u64 dsz           : 2;
> > +     u64 wmem          : 1;
> > +     u64 rsvd_52_16    : 37;
> > +     u64 offset        : 16;
> > +#else
> > +     u64 offset        : 16;
> > +     u64 rsvd_52_16    : 37;
> > +     u64 wmem          : 1;
> > +     u64 dsz           : 2;
> > +     u64 alg           : 4;
> > +     u64 subdc         : 4;
> > +#endif
>
> Traditionally we prefer to extract the bitfields with masks and shifts
> manually in the kernel, rather than having those (subjectively) ugly
> and finicky bitfield structs. But I guess if nobody else complains this
> can stay :/
>
> > +     u64 addr;
>
> Why do you care about big endian bitfields tho, if you don't care about
> endianness of the data itself?

At this point of time we are not addressing big endian functionality,
so few things
might be broken in that aspect. If it's preferred to remove, i will remove it.

>
> > +};
> > +
> >  #endif /* OTX2_STRUCT_H */
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> > index e6be18d..f416603 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> > @@ -32,6 +32,78 @@ static struct nix_cqe_hdr_s *otx2_get_next_cqe(struct otx2_cq_queue *cq)
> >       return cqe_hdr;
> >  }
> >
>> > +static void otx2_sqe_flush(struct otx2_snd_queue *sq, int size)
> > +{
> > +     u64 status;
> > +
> > +     /* Packet data stores should finish before SQE is flushed to HW */
>
> Packet data is synced by the dma operations the barrier shouldn't be
> needed AFAIK (and if it would be, dma_wmb() would not be the one, as it
> only works for iomem AFAIU).
>
> > +     dma_wmb();


Due to out of order execution by CPU, HW folks have suggested add a barrier
to avoid scenarios where packet is transmitted before all stores from
CPU are committed.
On arm64 a dmb() is less costlier than a dsb() barrier and as per HW
folks a dmb(st)
is sufficient to ensure all stores from CPU are committed. And
dma_wmb() uses dmb(st)
hence it is used. It's more of choice of architecture specific
instruction rather than the API.

Thanks,
Sunil.
