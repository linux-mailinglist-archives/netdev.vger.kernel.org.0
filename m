Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52C03E1D39
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 22:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239712AbhHEUQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 16:16:23 -0400
Received: from smtp-31-i2.italiaonline.it ([213.209.12.31]:59037 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232931AbhHEUQW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 16:16:22 -0400
Received: from oxapps-35-162.iol.local ([10.101.8.208])
        by smtp-31.iol.local with ESMTPA
        id Bjmgm5TujzHnRBjmgmO1r6; Thu, 05 Aug 2021 22:16:06 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1628194566; bh=VpohMvBfsZqbfNbBMTVaNf8bFAKmlnd6RyJI3PigMS0=;
        h=From;
        b=e383E/s3/nkklTiY7s3DUW0vGCOy3KDF6A4jyra1LG/8ecHM5AvivwB4R4ligQAqO
         0u8miRhi6c7xB5l0Kqt06WQJzpmiu4z9tSRwg9K0YNxyYhd6UjnOq/roKWauulWLFp
         p6ZkYj0zPUVoVM48xOBQEgFB3A1DnPtFRa/K0osUBIledAQwp6Pcn5tTeKZZaJkDV1
         usY7ELCTyjoSL684/SszQKSAQqGkNf03jNtF6eHX303brXTurPTygbG2vM5GXrnDeb
         MqxZZv81LpM18LASSk2GMHlToHmF+3ZAJBiHeWeFJFLJg3lSnZD4doc8xCdnbIWbl2
         p0QdfijDZB4VQ==
X-CNFS-Analysis: v=2.4 cv=L6DY/8f8 c=1 sm=1 tr=0 ts=610c4706 cx=a_exe
 a=OCAZjQWm+uh9gf1btJle/A==:117 a=J7go-RGC33AA:10 a=IkcTkHD0fZMA:10
 a=nep-EciQ0nEA:10 a=bGNZPXyTAAAA:8 a=wn1pJw0M0rjdo80TUYYA:9 a=QEXdDO2ut3YA:10
 a=yL4RfsBhuEsimFDS2qtJ:22
Date:   Thu, 5 Aug 2021 22:16:06 +0200 (CEST)
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
Message-ID: <1485600069.218377.1628194566441@mail1.libero.it>
In-Reply-To: <20210804094515.ariv7d24t2i4hic5@pengutronix.de>
References: <20210725161150.11801-1-dariobin@libero.it>
 <20210725161150.11801-5-dariobin@libero.it>
 <20210804094515.ariv7d24t2i4hic5@pengutronix.de>
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
x-libjamsun: WyJBSNMH9kkd8tqUyBiVLSk9X7CgnRUG
x-libjamv: SgYUR9btM7M=
X-CMAE-Envelope: MS4xfOvJk5+0VcReNnxjPbprZydZvfc/h79Lj17mJlHQGb8bhqaF+hIxSGjJiExPt5qV11Woh2U4bmqa0Yd3sXC63y1JQFXrHwoRc3iYxmbkYazZD+ji1lni
 cNlbXgyWAHzG+gF2OoMHXaqsarzBLhBWHokpVyrNf0m0BYI2pHe7SfxGSI/Gw5d8gFaRxGcOZxutGlPkq/XxBYkTQvivRZ9ZCSC/NDjhHg8fBA5UwNzH5Cyn
 GY1aWtCEqNVzs4p7VTRYjpGi9g8hRg3v2zxi4ih5YMlkV5nOvoJb+tum+zfviUgIwCY/2+1rSW2LtsFBc3n7dzDQVs0i3ugoT9CI9nuKPmMsVaY8nvoKsCCO
 b4XXnWxlA1Yv0bdJKxmta3DDiMYIKzTqvB4WgWFsS/WtwoHvscaRDfEFToeMfUnzgiXqIkr5Ddd5hjQP7XBGGKaJALjsro/9xMjig3YUpNRVGnp9yVJabBCf
 ABHhZsSiMMe/zMDT35gfsrBNRjehea7C8AEE2ZpweEa/N2/ih8S0o2Vs/PEVdRAoJv5qPzjOSfLMWhmv
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> Il 04/08/2021 11:45 Marc Kleine-Budde <mkl@pengutronix.de> ha scritto:
> 
>  
> On 25.07.2021 18:11:50, Dario Binacchi wrote:
> > diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
> > index 8fe7e2138620..fc499a70b797 100644
> > --- a/drivers/net/can/c_can/c_can.h
> > +++ b/drivers/net/can/c_can/c_can.h
> > @@ -200,6 +200,7 @@ struct c_can_priv {
> >  	atomic_t sie_pending;
> >  	unsigned long tx_dir;
> >  	int last_status;
> > +	spinlock_t tx_lock;
> 
> What does the spin lock protect?
> 
> >  	struct c_can_tx_ring tx;
> >  	u16 (*read_reg)(const struct c_can_priv *priv, enum reg index);
> >  	void (*write_reg)(const struct c_can_priv *priv, enum reg index, u16 val);
> > @@ -236,4 +237,9 @@ static inline u8 c_can_get_tx_tail(const struct c_can_tx_ring *ring)
> >  	return ring->tail & (ring->obj_num - 1);
> >  }
> >  
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
> >  static bool c_can_tx_busy(const struct c_can_priv *priv,
> >  			  const struct c_can_tx_ring *tx_ring)
> >  {
> > @@ -470,7 +456,7 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
> >  	struct can_frame *frame = (struct can_frame *)skb->data;
> >  	struct c_can_priv *priv = netdev_priv(dev);
> >  	struct c_can_tx_ring *tx_ring = &priv->tx;
> > -	u32 idx, obj;
> > +	u32 idx, obj, cmd = IF_COMM_TX;
> >  
> >  	if (can_dropped_invalid_skb(dev, skb))
> >  		return NETDEV_TX_OK;
> > @@ -483,7 +469,11 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
> >  	if (c_can_get_tx_free(tx_ring) == 0)
> >  		netif_stop_queue(dev);
> >  
> > -	obj = idx + priv->msg_obj_tx_first;
> > +	spin_lock_bh(&priv->tx_lock);
> 
> What does the spin_lock protect? The ndo_start_xmit function is properly
> serialized by the networking core.
> 

The spin_lock protects the access to the IF_TX interface. Enabling the transmission 
of cached messages occur inside interrupt and the use of the IF_RX interface,
which would avoid the use of the spinlock, has not been validated by
the tests.

Thanks and regards,
Dario

> Otherwise the patch looks good!
> 
> Marc
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
