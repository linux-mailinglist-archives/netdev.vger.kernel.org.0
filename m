Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96ED4E4D33
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 08:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242155AbiCWHSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 03:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241199AbiCWHSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 03:18:40 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E58972E0B;
        Wed, 23 Mar 2022 00:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648019829; x=1679555829;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IXsOZBoR4f0U9eReg1/3tbeiq3LtujYFsBJtuRYeVt0=;
  b=IBhebgWCmvMWDpEv1Su0UPxHL1cU9h60tdvDnZ0lanDRsZsNbgyMEkCO
   rnoAHNgPcuDqhli300Uu0GCx14RcbQBbal22PAtH0sY1pIYRBU8Be7gn5
   NsOpFr5BMLTzDk2QF5BowqWuxToKfpJ3PuS5cw7m8240rHezIKpLjitkM
   nNO8jAUc6GemGJVvuS3Apx7N0DtVSlg6zr6suSilcVruz6vusSOTmAI4+
   D1toEGV6iTPcw96ecD6YybmUifQGJY2r3wfsPlvYgrue6yRyc4d8XBpAN
   DsPJITh9ZRCCh+t1Ux6XlP4wD0sQF/VrCmW7E54orBvwY1R82YG8TDmIc
   w==;
X-IronPort-AV: E=Sophos;i="5.90,203,1643698800"; 
   d="scan'208";a="150104681"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Mar 2022 00:16:57 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 23 Mar 2022 00:16:56 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Wed, 23 Mar 2022 00:16:56 -0700
Date:   Wed, 23 Mar 2022 08:19:57 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <michael@walle.cc>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v2 3/4] net: lan966x: Add FDMA functionality
Message-ID: <20220323071957.4ufveau3wbjawsfv@soft-dev3-1.localhost>
References: <20220318204750.1864134-1-horatiu.vultur@microchip.com>
 <20220318204750.1864134-4-horatiu.vultur@microchip.com>
 <20220321230123.4d38ad5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220322210402.ebr2zghcisrqz4ju@soft-dev3-1.localhost>
 <20220322152536.4460aea2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220322152536.4460aea2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/22/2022 15:25, Jakub Kicinski wrote:
> On Tue, 22 Mar 2022 22:04:02 +0100 Horatiu Vultur wrote:
> > > > +static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
> > > > +{
> > > > +     struct lan966x *lan966x = rx->lan966x;
> > > > +     u64 src_port, timestamp;
> > > > +     struct sk_buff *new_skb;
> > > > +     struct lan966x_db *db;
> > > > +     struct sk_buff *skb;
> > > > +
> > > > +     /* Check if there is any data */
> > > > +     db = &rx->dcbs[rx->dcb_index].db[rx->db_index];
> > > > +     if (unlikely(!(db->status & FDMA_DCB_STATUS_DONE)))
> > > > +             return NULL;
> > > > +
> > > > +     /* Get the received frame and unmap it */
> > > > +     skb = rx->skb[rx->dcb_index][rx->db_index];
> > > > +     dma_unmap_single(lan966x->dev, (dma_addr_t)db->dataptr,
> > > > +                      FDMA_DCB_STATUS_BLOCKL(db->status),
> > > > +                      DMA_FROM_DEVICE);
> > > > +
> > > > +     /* Allocate a new skb and map it */
> > > > +     new_skb = lan966x_fdma_rx_alloc_skb(rx, db);
> > > > +     if (unlikely(!new_skb))
> > > > +             return NULL;
> > >
> > > So how is memory pressure handled, exactly? Looks like it's handled
> > > the same as if the ring was empty, so the IRQ is going to get re-raise
> > > immediately, or never raised again?
> >
> > That is correct, the IRQ is going to get re-raised.
> > But I am not sure that this is correct approach. Do you have any
> > suggestions how it should be?
> 
> In my experience it's better to let the ring drain and have a service
> task kick in some form of refill. Usually when machine is out of memory
> last thing it needs is getting stormed by network IRQs. Some form of
> back off would be good, at least?

OK. I will try to implement something like this in the next version.

> 
> > > > +     return counter;
> > > > +}
> > > > +
> > > > +irqreturn_t lan966x_fdma_irq_handler(int irq, void *args)
> > > > +{
> > > > +     struct lan966x *lan966x = args;
> > > > +     u32 db, err, err_type;
> > > > +
> > > > +     db = lan_rd(lan966x, FDMA_INTR_DB);
> > > > +     err = lan_rd(lan966x, FDMA_INTR_ERR);
> > >
> > > Hm, IIUC you request a threaded IRQ for this. Why?
> > > The register accesses can't sleep because you poke
> > > them from napi_poll as well...
> >
> > Good point. What about the WARN?
> 
> which one? Did something generate a warning without the threaded IRQ?

Ah.. no. I was talking about the WARN in case err is set.
---
if (err) {
	err_type = lan_rd(lan966x, FDMA_ERRORS);

	WARN(1, "Unexpected error: %d, error_type: %d\n", err, err_type);
	...
}
---
But that is fine. So I will change to non threaded irq.

> 
> > > > +int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
> > > > +{
> > > > +     struct lan966x_port *port = netdev_priv(dev);
> > > > +     struct lan966x *lan966x = port->lan966x;
> > > > +     struct lan966x_tx_dcb_buf *next_dcb_buf;
> > > > +     struct lan966x_tx_dcb *next_dcb, *dcb;
> > > > +     struct lan966x_tx *tx = &lan966x->tx;
> > > > +     struct lan966x_db *next_db;
> > > > +     int needed_headroom;
> > > > +     int needed_tailroom;
> > > > +     dma_addr_t dma_addr;
> > > > +     int next_to_use;
> > > > +     int err;
> > > > +
> > > > +     /* Get next index */
> > > > +     next_to_use = lan966x_fdma_get_next_dcb(tx);
> > > > +     if (next_to_use < 0) {
> > > > +             netif_stop_queue(dev);
> > > > +             err = NETDEV_TX_BUSY;
> > > > +             goto out;
> > > > +     }
> > > > +
> > > > +     if (skb_put_padto(skb, ETH_ZLEN)) {
> > > > +             dev->stats.tx_dropped++;
> > >
> > > It's preferred not to use the old dev->stats, but I guess you already
> > > do so :( This is under some locks, right? No chance for another queue
> > > or port to try to touch those stats at the same time?
> >
> > What is the preffered way of doing it?
> > Yes, it is under a lock.
> 
> Drivers can put counters they need in their own structures and then
> implement ndo_get_stats64 to copy it to the expected format.
> If you have locks and there's no risk of races - I guess it's fine.
> Unlikely we'll ever convert all the drivers, anyway.

OK, now I see.

I can create a different patch for this because then I should update the
statistics when injecting frames the other way(when writing each
word of the frame to HW).

-- 
/Horatiu
