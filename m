Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C704F7705
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241532AbiDGHQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241528AbiDGHQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:16:37 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739D4EBACA;
        Thu,  7 Apr 2022 00:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649315677; x=1680851677;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bAC8aL9e/0LILDQFClOv/cegcCjwM75fiVQah+k2yEQ=;
  b=Xan8vT5ozby/qaykeJc0rLt7IQpeJSqZJlesNegamvSxpPxzEuGN6sQU
   6JD58MhfEnVSRMtpDNmLqLWQkDdl1GP6VJNFxINd8RLDV8SMb7O/7TLt8
   CNablCmuCyM3wQM7E+uMRsWRN1evSvSNh1Q+fAuceU0EPp1yWBi5ap0O6
   0hPv2/fS0aZZnOD/SOmyim+hr1rdnskCpHUD545/vUVDJX/JLGuaBC5Rj
   9MHCzOsz7KjhsZulxdRNJbPopNGGDD82APHJgRFXJ2W85hLaRBs5/4KsZ
   0DZme4yJB8Cd738Zk8Pq2yeg/ZhlyFCptw8zEpUQnag/v2P/gfHaQ41jv
   g==;
X-IronPort-AV: E=Sophos;i="5.90,241,1643698800"; 
   d="scan'208";a="151841252"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Apr 2022 00:14:36 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 7 Apr 2022 00:14:35 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 7 Apr 2022 00:14:34 -0700
Date:   Thu, 7 Apr 2022 09:17:43 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <michael@walle.cc>
Subject: Re: [PATCH net-next v3 3/4] net: lan966x: Add FDMA functionality
Message-ID: <20220407071743.rsipmaq6xnucrlcw@soft-dev3-1.localhost>
References: <20220404130655.4004204-1-horatiu.vultur@microchip.com>
 <20220404130655.4004204-4-horatiu.vultur@microchip.com>
 <20220405211230.4a1a868d@kernel.org>
 <20220406112115.6kira24azizz6z2b@soft-dev3-1.localhost>
 <20220406103738.42a37033@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220406103738.42a37033@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/06/2022 10:37, Jakub Kicinski wrote:
> 
> On Wed, 6 Apr 2022 13:21:15 +0200 Horatiu Vultur wrote:
> > > > +static int lan966x_fdma_tx_alloc(struct lan966x_tx *tx)
> > > > +{
> > > > +     struct lan966x *lan966x = tx->lan966x;
> > > > +     struct lan966x_tx_dcb *dcb;
> > > > +     struct lan966x_db *db;
> > > > +     int size;
> > > > +     int i, j;
> > > > +
> > > > +     tx->dcbs_buf = kcalloc(FDMA_DCB_MAX, sizeof(struct lan966x_tx_dcb_buf),
> > > > +                            GFP_ATOMIC);
> > > > +     if (!tx->dcbs_buf)
> > > > +             return -ENOMEM;
> > > > +
> > > > +     /* calculate how many pages are needed to allocate the dcbs */
> > > > +     size = sizeof(struct lan966x_tx_dcb) * FDMA_DCB_MAX;
> > > > +     size = ALIGN(size, PAGE_SIZE);
> > > > +     tx->dcbs = dma_alloc_coherent(lan966x->dev, size, &tx->dma, GFP_ATOMIC);
> > >
> > > This functions seems to only be called from probe, so GFP_KERNEL
> > > is better.
> >
> > But in the next patch of this series will be called while holding
> > the lan966x->tx_lock. Should I still change it to GFP_KERNEL and then
> > in the next one will change to GFP_ATOMIC?
> 
> Ah, I missed that. You can keep the GFP_ATOMIC then.
> 
> But I think the reconfig path may be racy. You disable Rx, but don't
> disable napi. NAPI may still be running and doing Rx while you're
> trying to free the rx skbs, no?

Yes, it is possible to have race conditions there. Even though I disable
the HW and make sure the RX FDMA is disabled. It could be that a frame
is received and then we get an interrupt and we just call napi_schedule.
At this point we change the MTU, and once we disable the HW and the RX
FDMA, then the napi_poll is called.
So I will make sure call napi_synchronize and napi_disable.

> 
> Once napi is disabled you can disable Tx and then you have full
> ownership of the Tx side, no need to hold the lock during
> lan966x_fdma_tx_alloc(), I'd think.

I can do that. The only thing is that I need to disable the Tx for all
the ports. Because the FDMA is shared by all the ports.

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
> > > > +             return NETDEV_TX_BUSY;
> > > > +     }
> > > > +
> > > > +     if (skb_put_padto(skb, ETH_ZLEN)) {
> > > > +             dev->stats.tx_dropped++;
> > > > +             return NETDEV_TX_OK;
> > > > +     }
> > > > +
> > > > +     /* skb processing */
> > > > +     needed_headroom = max_t(int, IFH_LEN * sizeof(u32) - skb_headroom(skb), 0);
> > > > +     needed_tailroom = max_t(int, ETH_FCS_LEN - skb_tailroom(skb), 0);
> > > > +     if (needed_headroom || needed_tailroom || skb_header_cloned(skb)) {
> > > > +             err = pskb_expand_head(skb, needed_headroom, needed_tailroom,
> > > > +                                    GFP_ATOMIC);
> > > > +             if (unlikely(err)) {
> > > > +                     dev->stats.tx_dropped++;
> > > > +                     err = NETDEV_TX_OK;
> > > > +                     goto release;
> > > > +             }
> > > > +     }
> > > > +
> > > > +     skb_tx_timestamp(skb);
> > >
> > > This could move down after the dma mapping, so it's closer to when
> > > the devices gets ownership.
> >
> > The problem is that, if I move this lower, then the SKB is changed
> > because the IFH is added to the frame. So now if we do timestamping in
> > the PHY then when we call classify inside 'skb_clone_tx_timestamp'
> > will always return PTP_CLASS_NONE so the PHY will never get the frame.
> > That is the reason why I have move it back.
> 
> Oh, I see, makes sense!

-- 
/Horatiu
