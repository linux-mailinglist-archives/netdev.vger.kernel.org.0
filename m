Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60FE3E1D2F
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 22:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240541AbhHEUMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 16:12:37 -0400
Received: from smtp-31-i2.italiaonline.it ([213.209.12.31]:34457 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235633AbhHEUMg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 16:12:36 -0400
Received: from oxapps-35-162.iol.local ([10.101.8.208])
        by smtp-31.iol.local with ESMTPA
        id Bjj1m5S9tzHnRBjj1mO1JO; Thu, 05 Aug 2021 22:12:20 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1628194340; bh=1J5aPU1fgy/RfqWkhF1b2fqgF1PKccxV9uZUSHRwS/M=;
        h=From;
        b=xx/QPmJ1ilp5UnX9CSNfhClMIFSWubXddyKFAHW+HiP1Wr4i1ZdQdvIWJf8GbTSTx
         5Wtre3yam9MdgyolHxg4ofylJNY1GjD2fFaFaw8NGF5/e+Z88JhnwXZ1Wrm4u9Fja9
         Hz7QOu5LYF/OhcjkQXfVwIXl5mdkMB53qOD10RQI/jNBmltx8X5DUK6Mqgz3JGUIeN
         Y8t4y9eoYAUsjbLIYM0GDoL0fmcWjXZ2wmcz0wDf4NukeY/AblD8YF+IeXoVTsZwmw
         Vh13XXDZJ2oZiQw2wJagAzfBOXAZ+WeXFBlWSaXfEMTbVvlSND9NaEItidQglWwvDw
         SY0OZcROabgvA==
X-CNFS-Analysis: v=2.4 cv=L6DY/8f8 c=1 sm=1 tr=0 ts=610c4624 cx=a_exe
 a=OCAZjQWm+uh9gf1btJle/A==:117 a=J7go-RGC33AA:10 a=IkcTkHD0fZMA:10
 a=nep-EciQ0nEA:10 a=bGNZPXyTAAAA:8 a=wn1pJw0M0rjdo80TUYYA:9
 a=S33eJTiIa1C7FzhL:21 a=cSzkvvT6OTDMtG98:21 a=QEXdDO2ut3YA:10
 a=yL4RfsBhuEsimFDS2qtJ:22
Date:   Thu, 5 Aug 2021 22:12:18 +0200 (CEST)
From:   Dario Binacchi <dariobin@libero.it>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Gianluca Falavigna <gianluca.falavigna@inwind.it>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <1172393027.218339.1628194339000@mail1.libero.it>
In-Reply-To: <20210804093423.ms2p245f5oiw4xn4@pengutronix.de>
References: <20210725161150.11801-1-dariobin@libero.it>
 <20210725161150.11801-5-dariobin@libero.it>
 <20210804093423.ms2p245f5oiw4xn4@pengutronix.de>
Subject: Re: [RESEND PATCH 4/4] can: c_can: cache frames to operate as a
 true FIFO
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.3-Rev34
X-Originating-IP: 82.60.87.158
X-Originating-Client: open-xchange-appsuite
x-libjamsun: bxvGk6IQYMshaJt8Lq3yzglMBGdMK7FO
x-libjamv: +8bcFj4z+iY=
X-CMAE-Envelope: MS4xfIJvIiDBn5RyDY/2gszC1bv8IJM3R/HAKPpLM6XmOaWj6r9fGFRniG+h54c4oXjCNTvE0LUUC8I2zeIyabUC1R+K71mq3usl9sJfbwEDVWtHpLJxQh8f
 h6+aqsHQdNFx6RQfVrrdMnvJAZh12wsynJuY1k8dvN3gU2GO6xw6cXtvfN1KzohFETO/gUDNXtzsEZmP5YTGDojO8J8eW8yVwErmAMvXAfAWAaKGCt3uSKt+
 GqVAwm9iD4d0CCcRj1t+7xVj+bDGfKLvB8/W0vXwuNzZPK+pl/UOhuGEHhCTlqo54pTHhmBuUw75U9uP8nPlnyd45oKlkAIR87hKv/YJbGs2wckU12xclPMc
 ilHNNqLNJrqPIAiXBDR9Pxf7cfLWC6AOZ3Qig15OhSl8IeOmRkXmDkWj1LoY4K4iTkcO0AQ0VErpqhkrTQiiMlidMYs8le7WV3fW9df5kgsSS4AXPiTr+12p
 PbHAeMsGcvXPve7O8CqrI64Lj17Q48HueoeZSr1Z19gO6euYPNU09JJqsB+NJGymq0j0e6rcWhllH//m
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> Il 04/08/2021 11:34 Marc Kleine-Budde <mkl@pengutronix.de> ha scritto:
> 
>  
> On 25.07.2021 18:11:50, Dario Binacchi wrote:
> > As reported by a comment in the c_can_start_xmit() this was not a FIFO.
> > C/D_CAN controller sends out the buffers prioritized so that the lowest
> > buffer number wins.
> > 
> > What did c_can_start_xmit() do if head was less tail in the tx ring ? It
> > waited until all the frames queued in the FIFO was actually transmitted
> > by the controller before accepting a new CAN frame to transmit, even if
> > the FIFO was not full, to ensure that the messages were transmitted in
> > the order in which they were loaded.
> > 
> > By storing the frames in the FIFO without requiring its transmission, we
> > will be able to use the full size of the FIFO even in cases such as the
> > one described above. The transmission interrupt will trigger their
> > transmission only when all the messages previously loaded but stored in
> > less priority positions of the buffers have been transmitted.
> > 
> > Suggested-by: Gianluca Falavigna <gianluca.falavigna@inwind.it>
> > Signed-off-by: Dario Binacchi <dariobin@libero.it>
> > 
> > ---
> > 
> >  drivers/net/can/c_can/c_can.h      |  6 +++++
> >  drivers/net/can/c_can/c_can_main.c | 42 +++++++++++++++++-------------
> >  2 files changed, 30 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
> > index 8fe7e2138620..fc499a70b797 100644
> > --- a/drivers/net/can/c_can/c_can.h
> > +++ b/drivers/net/can/c_can/c_can.h
> > +static inline u8 c_can_get_tx_free(const struct c_can_tx_ring *ring)
> > +{
> > +	return ring->obj_num - (ring->head - ring->tail);
> > +}
> > +
> >  #endif /* C_CAN_H */
> > diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c_can_main.c
> > index 451ac9a9586a..4c061fef002c 100644
> > --- a/drivers/net/can/c_can/c_can_main.c
> > +++ b/drivers/net/can/c_can/c_can_main.c
> > @@ -427,20 +427,6 @@ static void c_can_setup_receive_object(struct net_device *dev, int iface,
> >  	c_can_object_put(dev, iface, obj, IF_COMM_RCV_SETUP);
> >  }
> >  
> > -static u8 c_can_get_tx_free(const struct c_can_tx_ring *ring)
> > -{
> > -	u8 head = c_can_get_tx_head(ring);
> > -	u8 tail = c_can_get_tx_tail(ring);
> > -
> > -	/* This is not a FIFO. C/D_CAN sends out the buffers
> > -	 * prioritized. The lowest buffer number wins.
> > -	 */
> > -	if (head < tail)
> > -		return 0;
> > -
> > -	return ring->obj_num - head;
> > -}
> > -
> 
> Can you move that change into patch 3?

Patch 3 adds the ring transmission algorithm without compromising the
message transmission order. This is not a FIFO. C/D_CAN controller sends
out the buffers prioritized. The lowest buffer number wins, so moving the
change into patch 3 may not guarantee the transmission order.
In patch 3, however, I will move c_can_get_tx_free() from c_can_main.c to 
c_can.h, so that in patch 4 it will be clearer how the routine has changed.

Thanks and regards,
Dario

> 
> Marc
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
