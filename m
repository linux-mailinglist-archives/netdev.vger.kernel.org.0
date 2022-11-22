Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD73634951
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 22:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235107AbiKVVcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 16:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235069AbiKVVcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 16:32:46 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6B67640;
        Tue, 22 Nov 2022 13:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669152757; x=1700688757;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ISteiEafnpwfxSB+bh7FKbXTjSTCofLvMskNHi+6Jts=;
  b=niki0MW8zySgQId4KQJ0TaRx7tzE3ydkYA3Aeph16YmJsCLQSuu0etg+
   nggM0G4A/sXdu19qPQIv+mlixWjsJTtPxWmof39W1NW37c+/WwLbRuzZL
   qfHEdZ3rY9RogWk+HufSt9TvmXKgP0PERhWnm48bEvECo/9/C90y3ld6k
   uylANtJljdfHocqWuXuo1A5wWO5rTY0ACBO6rEs1rzT2N4aRr4ZMj4sW9
   Lf7WAOHReo7vrrh9V9RA8BegLgdax5oNfRWpv96oCkHTslE6+8qGedyr0
   4i+LxBRTBJLP08PlblfHvS2ZzdBK3PTQOLWJhxNofIk3IphADRL3jj7s4
   A==;
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="190136597"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Nov 2022 14:32:34 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 22 Nov 2022 14:32:33 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Tue, 22 Nov 2022 14:32:33 -0700
Date:   Tue, 22 Nov 2022 22:37:24 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v3 7/7] net: lan966x: Add support for
 XDP_REDIRECT
Message-ID: <20221122213724.exqdhdxujvgtojxq@soft-dev3-1>
References: <20221121212850.3212649-1-horatiu.vultur@microchip.com>
 <20221121212850.3212649-8-horatiu.vultur@microchip.com>
 <20221122120430.419770-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221122120430.419770-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/22/2022 13:04, Alexander Lobakin wrote:
> 
> From: Horatiu Vultur <horatiu.vultur@microchip.com>
> Date: Mon, 21 Nov 2022 22:28:50 +0100
> 
> > Extend lan966x XDP support with the action XDP_REDIRECT. This is similar
> > with the XDP_TX, so a lot of functionality can be reused.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  .../ethernet/microchip/lan966x/lan966x_fdma.c | 83 +++++++++++++++----
> >  .../ethernet/microchip/lan966x/lan966x_main.c |  1 +
> >  .../ethernet/microchip/lan966x/lan966x_main.h | 10 ++-
> >  .../ethernet/microchip/lan966x/lan966x_xdp.c  | 31 ++++++-
> >  4 files changed, 109 insertions(+), 16 deletions(-)
> 
> [...]
> 
> > @@ -558,6 +575,10 @@ static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
> >               case FDMA_TX:
> >                       lan966x_fdma_rx_advance_dcb(rx);
> >                       continue;
> > +             case FDMA_REDIRECT:
> > +                     lan966x_fdma_rx_advance_dcb(rx);
> > +                     redirect = true;
> > +                     continue;
> 
> I think you can save a couple lines here and avoid small code dup:
> 
> +               case FDMA_REDIRECT:
> +                       redirect = true;
> +                       fallthrough;
>                 case FDMA_TX:
>                         lan966x_fdma_rx_advance_dcb(rx);
>                         continue;

I will save only a line but I will add this change in the next version
as I like it more than what I wrote.

> 
> The logics stays the same.
> 
> >               case FDMA_DROP:
> >                       lan966x_fdma_rx_free_page(rx);
> >                       lan966x_fdma_rx_advance_dcb(rx);
> 
> [...]
> 
> > @@ -178,6 +180,7 @@ struct lan966x_tx_dcb_buf {
> >       struct net_device *dev;
> >       struct sk_buff *skb;
> >       struct xdp_frame *xdpf;
> > +     bool xdp_ndo;
> 
> I suggest carefully inspecting this struct with pahole (or by just
> printkaying its layout/sizes/offsets at runtime) and see if there's
> any holes and how it could be optimized.
> Also, it's just my personal preference, but it's not that unpopular:
> I don't trust bools inside structures as they may surprise with
> their sizes or alignment depending on the architercture. Considering
> all the blah I wrote, I'd define it as:
> 
> struct lan966x_tx_dcb_buf {
>         dma_addr_t dma_addr;            // can be 8 bytes on 32-bit plat
>         struct net_device *dev;         // ensure natural alignment
>         struct sk_buff *skb;
>         struct xdp_frame *xdpf;
>         u32 len;
>         u32 xdp_ndo:1;                  // put all your booleans here in
>         u32 used:1;                     // one u32
>         ...
> };

Thanks for the suggestion. I make sure not that this struct will not
have any holes.
Can it be a rule of thumb, that every time when a new member is added to
a struct, to make sure that it doesn't introduce any holes?

> 
> BTW, we usually do union { skb, xdpf } since they're mutually
> exclusive. And to distinguish between XDP and regular Tx you can use
> one more bit/bool. This can also come handy later when you add XSk
> support (you will be adding it, right? Please :P).

I think I will take this battle at later point when I will add XSK :)
After I finish with this patch series, I will need to focus on some VCAP
support for lan966x.
And maybe after that I will be able to add XSK. Because I need to look
more at this XSK topic as I have looked too much on it before but I heard
a lot of great things about it :)

> 
> >       int len;
> >       dma_addr_t dma_addr;
> >       bool used;
> 
> [...]
> 
> > --
> > 2.38.0
> 
> Thanks,
> Olek

-- 
/Horatiu
