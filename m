Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A81A62F9A5
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 16:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242111AbiKRPpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 10:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241407AbiKRPp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 10:45:28 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14BA7CBA4;
        Fri, 18 Nov 2022 07:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668786325; x=1700322325;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QnYDsjDsDb4h9i3C9BaDBaDNlmHvoV9jV+GgiCQ7Q+A=;
  b=oY7MI3zRGbx1fp7mzpPwQ7nFry+hg4UcoN/X96vkxJuej9B71hLpgFy4
   KVRxNOlYaoKezLQNmwnJdM5OUH0tUR42DhhWTOvaK5pem0p2LjT6UdEDu
   TAh3IPWrorvOyHlJpaO1pZW51rXdN8EpeH5E3xpMwRHvpbEFwEBsVie4Z
   wAyAcEamb1F2XygPE4vBzhZzQZJVu6ZEkNXDksBN1tcEar2+xy7iWjsHf
   CrZc+EVBvaurC41YCyBBsqy0bHLen2LwBfcFKHU8bB1Hcwj9UR1TjDoCp
   ytxeoSqtSx/ttTEmHOR4TSnHRtxkcM5/MiuSTNX6pdRgxRRlVMBh6cMgZ
   A==;
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="124098261"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Nov 2022 08:45:23 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 18 Nov 2022 08:45:19 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Fri, 18 Nov 2022 08:45:19 -0700
Date:   Fri, 18 Nov 2022 16:50:08 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v2 4/5] net: lan966x: Add support for XDP_TX
Message-ID: <20221118155008.illvc66lrlm4orrx@soft-dev3-1>
References: <20221115214456.1456856-1-horatiu.vultur@microchip.com>
 <20221115214456.1456856-5-horatiu.vultur@microchip.com>
 <20221116153418.3389630-1-alexandr.lobakin@intel.com>
 <20221116205557.2syftn3jqx357myg@soft-dev3-1>
 <20221117153116.3447130-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221117153116.3447130-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/17/2022 16:31, Alexander Lobakin wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> From: Horatiu Vultur <horatiu.vultur@microchip.com>
> Date: Wed, 16 Nov 2022 21:55:57 +0100
> 
> > The 11/16/2022 16:34, Alexander Lobakin wrote:
> > >
> > > From: Horatiu Vultur <horatiu.vultur@microchip.com>
> > > Date: Tue, 15 Nov 2022 22:44:55 +0100
> >
> > Hi Olek,
> 
> Hi!
> 
> > > For %XDP_REDIRECT, as you don't know the source of the XDP frame,
> >
> > Why I don't know the source?
> > Will it not be from an RX page that is allocated by Page Pool?
> 
> Imagine some NIC which does not use Page Pool, for example, it does
> its own page allocation / splitting / recycling techniques, gets
> %XDP_REDIRECT when running XDP prog on Rx. devmap says it must
> redirect the frame to your NIC.
> Then, your ::ndo_xdp_xmit() will be run on a frame/page not
> belonging to any Page Pool.
> The example can be any of Intel drivers (there are plans to switch
> at least i40e and ice to Page Pool, but they're always deeply in
> the backlogs (clownface)).

Silly me, I was always thinking and trying only from one port of lan966x
to another port of lan966x. Of course it can come from other NICs.

> 
> >
> > > you need to unmap it (as it was previously mapped in
> > > ::ndo_xdp_xmit()), plus call xdp_return_frame{,_bulk} to free the
> > > XDP frame. Note that _rx_napi() variant is not applicable here.
> > >
> > > That description might be confusing, so you can take a look at the
> > > already existing code[0] to get the idea. I think this piece shows
> > > the expected logics rather well.
> >
> > I think you forgot to write the link to the code.
> > I looked also at different drivers but I didn't figure it out why the
> > frame needed to be mapped and where is happening that.
> 
> Ooof, really. Pls look at the end of this reply :D
> On ::ndo_xdp_xmit(), as I explained above, you can receive a frame
> from any driver or BPF core code (such as cpumap), and BPF prog
> there could be run on buffer of any kind: Page Pool page, just a
> page, a kmalloc() chunk and so on.
> 
> So, in the code[0], you can see the following set of operations:
> 
> * DMA unmap in all cases excluding frame coming from %XDP_TX (then
>   it was only synced);
> * updating statistics and freeing skb for skb cases;
> * xdp_return_frame_rx_napi() for %XDP_TX cases;
> * xdp_return_frame_bulk() for ::ndo_xdp_xmit() cases.

Thanks for a detail explanation and for the link :D
I will update all this in the next version.

> 
> > > +       ifh = page_address(page) + XDP_PACKET_HEADROOM;
> > > +       memset(ifh, 0x0, sizeof(__be32) * IFH_LEN);
> > > +       lan966x_ifh_set_bypass(ifh, 1);
> > > +       lan966x_ifh_set_port(ifh, BIT_ULL(port->chip_port));
> > > +
> > > +       dma_addr = page_pool_get_dma_addr(page);
> > > +       dma_sync_single_for_device(lan966x->dev, dma_addr + XDP_PACKET_HEADROOM,
> > > +                                  xdpf->len + IFH_LEN_BYTES,
> > > +                                  DMA_TO_DEVICE);
> > >
> > > Also not correct. This page was mapped with %DMA_FROM_DEVICE in the
> > > Rx code, now you sync it for the opposite.
> > > Most drivers in case of XDP enabled create Page Pools with ::dma_dir
> > > set to %DMA_BIDIRECTIONAL. Now you would need only to sync it here
> > > with the same direction (bidir) and that's it.
> >
> > That is a really good catch!
> > I was wondering why the things were working when I tested this. Because
> > definitely, I can see the right behaviour.
> 
> The reasons can be:
> 
> 1) your platform might have a DMA coherence engine, so that all
>    those DMA sync calls are no-ops;
> 2) on your platform, DMA writeback (TO_DEVICE) and DMA invalidate
>    (FROM_DEVICE) invoke the same operation/instruction. Some
>    hardware is designed that way, that any DMA sync is in fact a
>    bidir synchronization;
> 3) if there were no frame modification from the kernel, e.g. you
>    received it and immediately sent, cache was not polluted with
>    some pending modifications, so there was no work for writeback;
> 4) probably something else I might've missed.
> 
> >
> > >
> > > +
> > > +       /* Setup next dcb */
> > > +       lan966x_fdma_tx_setup_dcb(tx, next_to_use, xdpf->len + IFH_LEN_BYTES,
> > > +                                 dma_addr + XDP_PACKET_HEADROOM);
> > > +
> > > +       /* Fill up the buffer */
> > > +       next_dcb_buf = &tx->dcbs_buf[next_to_use];
> > > +       next_dcb_buf->skb = NULL;
> > > +       next_dcb_buf->page = page;
> > > +       next_dcb_buf->len = xdpf->len + IFH_LEN_BYTES;
> > > +       next_dcb_buf->dma_addr = dma_addr;
> > > +       next_dcb_buf->used = true;
> > > +       next_dcb_buf->ptp = false;
> > > +       next_dcb_buf->dev = port->dev;
> > > +
> > > +       /* Start the transmission */
> > > +       lan966x_fdma_tx_start(tx, next_to_use);
> > > +
> > > +out:
> > > +       spin_unlock(&lan966x->tx_lock);
> > > +
> > > +       return ret;
> > > +}
> > > +
> > >  int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
> > >  {
> > >         struct lan966x_port *port = netdev_priv(dev);
> > > @@ -709,6 +776,7 @@ int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
> > >         /* Fill up the buffer */
> > >         next_dcb_buf = &tx->dcbs_buf[next_to_use];
> > >         next_dcb_buf->skb = skb;
> > > +       next_dcb_buf->page = NULL;
> > >         next_dcb_buf->len = skb->len;
> > >         next_dcb_buf->dma_addr = dma_addr;
> > >         next_dcb_buf->used = true;
> > >
> > > [...]
> > >
> > > --
> > > 2.38.0
> > >
> > > Thanks,
> > > Olek
> >
> > --
> > /Horatiu
> 
> [0] https://elixir.bootlin.com/linux/v6.1-rc5/source/drivers/net/ethernet/marvell/mvneta.c#L1882
> 
> Thanks,
> Olek

-- 
/Horatiu
