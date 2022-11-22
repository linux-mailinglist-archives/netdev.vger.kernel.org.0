Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D716D634917
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 22:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234811AbiKVVUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 16:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233174AbiKVVUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 16:20:21 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EC18F3C3;
        Tue, 22 Nov 2022 13:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669152017; x=1700688017;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ads2cVRvZI8k8jJJ/EENd7OUJlc/7SM5FY/+3wbCKkk=;
  b=RbwD1C3BA7JaRZqFrOM/Ty1NNyWBKb4cMJM6DBscm3k6rG6z5FcyggF+
   JYxJ6YhtZOYq4nAyXEhC/H1jD15LuM8gKj+NTNszABb6KWq2ijk9c963u
   BCZWsb6aPxBuZhbXHGsZGHJYgoGg7Qhow/bTIM5bTbd9gBsZHoF76z7WX
   qZSYMFzFmXeFAmjtCyp+/HEJmVnOiBVRgZ5WGeef9XbIG64c81ka84BXU
   XTIio4mS26CiPH1sN0mdj0+OWg5gOxWXDfkvOZIxvKg9IE6raDzYqIKxg
   iShtMwfCguKHL9XyuHPvGaE2ePz0RhZ4Z3XLYrjzF7ceISZKhPpbEWVTt
   A==;
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="190134967"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Nov 2022 14:20:17 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 22 Nov 2022 14:20:14 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Tue, 22 Nov 2022 14:20:14 -0700
Date:   Tue, 22 Nov 2022 22:25:04 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v3 5/7] net: lan966x: Update dma_dir of
 page_pool_params
Message-ID: <20221122212504.nrwaucgab3lqqxpo@soft-dev3-1>
References: <20221121212850.3212649-1-horatiu.vultur@microchip.com>
 <20221121212850.3212649-6-horatiu.vultur@microchip.com>
 <20221122114339.419188-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221122114339.419188-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/22/2022 12:43, Alexander Lobakin wrote:
> 
> From: Horatiu Vultur <horatiu.vultur@microchip.com>
> Date: Mon, 21 Nov 2022 22:28:48 +0100
> 
> > To add support for XDP_TX it is required to be able to write to the DMA
> > area therefore it is required that the pages will be mapped using
> > DMA_BIDIRECTIONAL flag.
> > Therefore check if there are any xdp programs on the interfaces and in
> > that case set DMA_BIDRECTIONAL otherwise use DMA_FROM_DEVICE.
> > Therefore when a new XDP program is added it is required to redo the
> > page_pool.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  .../ethernet/microchip/lan966x/lan966x_fdma.c | 29 ++++++++++++++----
> >  .../ethernet/microchip/lan966x/lan966x_main.h |  2 ++
> >  .../ethernet/microchip/lan966x/lan966x_xdp.c  | 30 +++++++++++++++++++
> >  3 files changed, 55 insertions(+), 6 deletions(-)
> 
> [...]
> 
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> > index 8ebde1eb6a09c..05c5a28206558 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> > @@ -11,6 +11,8 @@ static int lan966x_xdp_setup(struct net_device *dev, struct netdev_bpf *xdp)
> >       struct lan966x_port *port = netdev_priv(dev);
> >       struct lan966x *lan966x = port->lan966x;
> >       struct bpf_prog *old_prog;
> > +     bool old_xdp, new_xdp;
> > +     int err;
> >
> >       if (!lan966x->fdma) {
> >               NL_SET_ERR_MSG_MOD(xdp->extack,
> > @@ -18,7 +20,20 @@ static int lan966x_xdp_setup(struct net_device *dev, struct netdev_bpf *xdp)
> >               return -EOPNOTSUPP;
> >       }
> >
> > +     old_xdp = lan966x_xdp_present(lan966x);
> >       old_prog = xchg(&port->xdp_prog, xdp->prog);
> > +     new_xdp = lan966x_xdp_present(lan966x);
> > +
> > +     if (old_xdp != new_xdp)
> > +             goto out;
> 
> Shouldn't it be the other way around? E.g. when there's no prog and
> you're installing it or there is a prog and we're removing it from
> the interface, DMA dir must be changed, so we reload the Pools, but
> if `old_xdp == new_xdp` we should just hotswap them and goto out?

Argh! Yes, it needs to be the other way around.
> 
> > +
> > +     err = lan966x_fdma_reload_page_pool(lan966x);
> > +     if (err) {
> > +             xchg(&port->xdp_prog, old_prog);
> > +             return err;
> > +     }
> > +
> > +out:
> >       if (old_prog)
> >               bpf_prog_put(old_prog);
> >
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
