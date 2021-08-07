Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267933E355A
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 14:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbhHGMgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 08:36:38 -0400
Received: from smtp-35-i2.italiaonline.it ([213.209.12.35]:49523 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232170AbhHGMgh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 08:36:37 -0400
Received: from oxapps-35-162.iol.local ([10.101.8.208])
        by smtp-35.iol.local with ESMTPA
        id CLYmmoiQe8HOxCLYmmpRQL; Sat, 07 Aug 2021 14:36:18 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1628339778; bh=3V3l7i5/LxTvopvC+hXlPOoiT/wst+I7MPvJIRo+dUk=;
        h=From;
        b=lPwqQG7SxX6jlpTFh2FUjPywxdCGMrslxZEHxE1aD9IYL60Djux1SmZ5z1hvqTXMe
         CevlYfLEGSW/eDv6eP38TAH9nxs8dGdghkuSqee4sXJYlSnsqHljSerivAXGr1tOtf
         HVlQ8Hu60TO2QQaEpkUYLiRhJAzuj/Fvcn6IHUCEPiLEUT+PAWak06RiSP22ynHGXI
         F1A8gQeGr0PD5ica2Scgf8yqz4FBYoBthDzuCcujPKIkKGfHywlPw9x267fj2xm5YU
         tOAFqJf/lDAsKsDAzpWwkaz0ioLd2GYJ3RmXa6rX4yaKoSHcxLDNL/kWcv9ZC2QPYI
         yzFbBiojnLjeA==
X-CNFS-Analysis: v=2.4 cv=LfD5VhTi c=1 sm=1 tr=0 ts=610e7e42 cx=a_exe
 a=OCAZjQWm+uh9gf1btJle/A==:117 a=J7go-RGC33AA:10 a=IkcTkHD0fZMA:10
 a=nep-EciQ0nEA:10 a=VwQbUJbxAAAA:8 a=bGNZPXyTAAAA:8 a=lneh_w3DiUngg6D-LXoA:9
 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22 a=yL4RfsBhuEsimFDS2qtJ:22
Date:   Sat, 7 Aug 2021 14:36:15 +0200 (CEST)
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
Message-ID: <1265712151.254355.1628339776021@mail1.libero.it>
In-Reply-To: <20210806092523.hij5ejjq6wecbgfr@pengutronix.de>
References: <20210725161150.11801-1-dariobin@libero.it>
 <20210725161150.11801-5-dariobin@libero.it>
 <20210804094515.ariv7d24t2i4hic5@pengutronix.de>
 <1485600069.218377.1628194566441@mail1.libero.it>
 <20210806092523.hij5ejjq6wecbgfr@pengutronix.de>
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
x-libjamsun: V5Mpv/1xPgKjfbi1h4xDhLvgdQkMzdTz
x-libjamv: VPJ6QSya3cM=
X-CMAE-Envelope: MS4xfNWgmEuo1GkEGu+LRftwWn03HCw3gPrzT7PKUF7aePMx6I8w+iXB7XAAVLOAE/Gql13xzIOAwsJ9Wq6dZkqcDPLCbGNu/2Il+oziGFt4kFfEZNIoaVpX
 HDlK8osLTYv+YzEruAZUpO3b9IFG8ho0Tw459UcdfCBeJUcYTE2ks3KHSKKx3N4ewXMkZr/mGnw4xchPa3em2NtKq3Db5BYawvbV8D5rxVIYczDlowOfpmm4
 SAop+4FJX21kGGA+Dq5a+HnkJUXo5HWkwg0qou9XiDBFilMcBrnFAks3BimvCsa6K+MM3e39SN7n0SVYofFJ0PTUIKJPSOIEKztzsYwgvMxWuO6pOloYrDsN
 cnn2sk76zQRYsbo7m3ccQlG6WwWH9EVEjRW1Ujv8oXJ92Yso4r68s27QSlpGNfAp0X1Ta16YejoDnJ7PC3GyZG6pYVEbz/9nXZI1PHKEjwvGPULjvT5xqq9H
 Zhs6/YIAznkPn66/kSPl71Xifo/BFrOxxaT1UuF7641Oqbwes9NTf1lfrIHwOm2qRAU4oP3A5/Ue6jL/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Il 06/08/2021 11:25 Marc Kleine-Budde <mkl@pengutronix.de> ha scritto:
> 
>  
> On 05.08.2021 22:16:06, Dario Binacchi wrote:
> > > > --- a/drivers/net/can/c_can/c_can.h
> > > > +++ b/drivers/net/can/c_can/c_can.h
> > > > @@ -200,6 +200,7 @@ struct c_can_priv {
> > > >  	atomic_t sie_pending;
> > > >  	unsigned long tx_dir;
> > > >  	int last_status;
> > > > +	spinlock_t tx_lock;
> > > 
> > > What does the spin lock protect?
> [...]
> > > > @@ -483,7 +469,11 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
> > > >  	if (c_can_get_tx_free(tx_ring) == 0)
> > > >  		netif_stop_queue(dev);
> > > >  
> > > > -	obj = idx + priv->msg_obj_tx_first;
> > > > +	spin_lock_bh(&priv->tx_lock);
> > > 
> > > What does the spin_lock protect? The ndo_start_xmit function is properly
> > > serialized by the networking core.
> > > 
> > 
> > The spin_lock protects the access to the IF_TX interface.
> 
> How? You only use the spin_lock in c_can_start_xmit(), but not anywhere
> else.
> 
> > Enabling the transmission of cached messages occur inside interrupt
> 
> The call chain is c_can_poll() -> c_can_do_tx(), and c_can_poll() is
> called from NAPI, which is not the IRQ handler.
> 
> > and the use of the IF_RX interface, which would avoid the use of the
> > spinlock, has not been validated by the tests.
> 
> What do you mean be has not been validated?

It's been a while since I submitted the series and I certainly got confused.

> 
> The driver already uses IF_RX to avoid concurrent access in
> c_can_do_tx() for c_can_inval_tx_object() [1], why not use IF_RX for
> c_can_object_put(), too?
> 
> [1] https://lore.kernel.org/r/20210302215435.18286-4-dariobin@libero.it

Right!

Thanks and Regards,
Dario

> 
> Marc
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
