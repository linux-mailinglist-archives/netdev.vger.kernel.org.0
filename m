Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4F816EA582
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 10:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbjDUIDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 04:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbjDUIDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 04:03:47 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E1A9004;
        Fri, 21 Apr 2023 01:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682064225; x=1713600225;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uaalytOD7E9KTAxWb0CBOWck+EskKmiavYRIJcVqFvs=;
  b=ZdJVX5PmC8E6JvOq8ZsNx444i87GFrRhfCgJFsh6pXgw7QqlI7vzqGes
   L7FHpEU2hKkxGPf1Ei+agi+KyFdler94/W96mVotnwe1DPDx6eKn327XM
   7Qgj92QUpTKf4u7b99uivmP/xdI/TlpUg2dgwK4UqOmXAC9sOtbByb9ub
   SwmcKzb1ZBIi5comdRvwc2oP7WeCT/94jnQwfe4WIuEeIGbjTYbLLMVUI
   /a0IJdLvdhRlXvIVyKlOxk+IEYJLBqeVL6ccPspyzsm8xn6kVOwZtZUsO
   TP5JpT0EI6ketHdQzzYiuOfuaHgc7kMu5j7PWKkpSVOSnzfXYvWSIzL23
   A==;
X-IronPort-AV: E=Sophos;i="5.99,214,1677567600"; 
   d="scan'208";a="148255781"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Apr 2023 01:03:44 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 21 Apr 2023 01:03:40 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 21 Apr 2023 01:03:40 -0700
Date:   Fri, 21 Apr 2023 10:03:39 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <alexandr.lobakin@intel.com>
Subject: Re: [PATCH net-next] net: lan966x: Don't use xdp_frame when action
 is XDP_TX
Message-ID: <20230421080339.x2fllg65qmcrk6vk@soft-dev3-1>
References: <20230420121152.2737625-1-horatiu.vultur@microchip.com>
 <ZEGmHe2pyxwWiYRL@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <ZEGmHe2pyxwWiYRL@boxer>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/20/2023 22:52, Maciej Fijalkowski wrote:
> [Some people who received this message don't often get email from maciej.fijalkowski@intel.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 

Hi Maciej,

> 
> On Thu, Apr 20, 2023 at 02:11:52PM +0200, Horatiu Vultur wrote:
> 
> 'net: ' in patch subject is excessive to me

I usually have set this in the subject. I can remove this in the next
version and I will try to keep in mind for other patches for lan966x.

> 
> > When the action of an xdp program was XDP_TX, lan966x was creating
> > a xdp_frame and use this one to send the frame back. But it is also
> > possible to send back the frame without needing a xdp_frame, because
> > it possible to send it back using the page.
> 
> s/it/it is
> 
> > And then once the frame is transmitted is possible to use directly
> > page_pool_recycle_direct as lan966x is using page pools.
> > This would save some CPU usage on this path.
> 
> i remember this optimization gave me noticeable perf improvement, would
> you mind sharing it in % on your side?

The way I have done the measurements, is to measure actually how much
more traffic can be send back. I tried with different frame sizes,
frame size     improvement
64                ~8%
256              ~11%
512               ~8%
1000              ~0%
1500              ~0%

I will make sure do add this to the comments in the next version.

> 
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  .../ethernet/microchip/lan966x/lan966x_fdma.c | 35 +++++++++++--------
> >  .../ethernet/microchip/lan966x/lan966x_main.h |  2 ++
> >  .../ethernet/microchip/lan966x/lan966x_xdp.c  | 11 +++---
> >  3 files changed, 27 insertions(+), 21 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> > index 2ed76bb61a731..7947259e67e4e 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> > @@ -390,6 +390,7 @@ static void lan966x_fdma_stop_netdev(struct lan966x *lan966x)
> >  static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
> >  {
> >       struct lan966x_tx *tx = &lan966x->tx;
> > +     struct lan966x_rx *rx = &lan966x->rx;
> >       struct lan966x_tx_dcb_buf *dcb_buf;
> >       struct xdp_frame_bulk bq;
> >       struct lan966x_db *db;
> > @@ -432,7 +433,8 @@ static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
> >                       if (dcb_buf->xdp_ndo)
> >                               xdp_return_frame_bulk(dcb_buf->data.xdpf, &bq);
> >                       else
> > -                             xdp_return_frame_rx_napi(dcb_buf->data.xdpf);
> > +                             page_pool_recycle_direct(rx->page_pool,
> > +                                                      dcb_buf->data.page);
> >               }
> >
> >               clear = true;
> > @@ -702,6 +704,7 @@ static void lan966x_fdma_tx_start(struct lan966x_tx *tx, int next_to_use)
> >  int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
> >                          struct xdp_frame *xdpf,
> >                          struct page *page,
> > +                        u32 len,
> 
> agreed with Olek regarding arguments reduction here

Yes, I will change this in the next version.

> 
> >                          bool dma_map)
> >  {
> >       struct lan966x *lan966x = port->lan966x;
> > @@ -722,6 +725,15 @@ int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
> >               goto out;
> >       }
> >
> > +     /* Fill up the buffer */
> > +     next_dcb_buf = &tx->dcbs_buf[next_to_use];
> > +     next_dcb_buf->use_skb = false;
> > +     next_dcb_buf->xdp_ndo = dma_map;
> 
> a bit misleading that xdp_ndo is a bool :P

There are few other variables that are misleading :), I need to get to
this and clean it a little bit.

> 
> > +     next_dcb_buf->len = len + IFH_LEN_BYTES;
> > +     next_dcb_buf->used = true;
> > +     next_dcb_buf->ptp = false;
> > +     next_dcb_buf->dev = port->dev;
> > +
> >       /* Generate new IFH */
> >       if (dma_map) {
> >               if (xdpf->headroom < IFH_LEN_BYTES) {
-- 
/Horatiu
