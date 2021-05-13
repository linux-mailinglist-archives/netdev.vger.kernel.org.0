Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402E537F6CB
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbhEMLc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:32:59 -0400
Received: from smtp-35-i2.italiaonline.it ([213.209.12.35]:48050 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232660AbhEMLc4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 07:32:56 -0400
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 May 2021 07:32:55 EDT
Received: from oxapps-15-086.iol.local ([10.101.8.96])
        by smtp-35.iol.local with ESMTPA
        id h9RDla74apK9wh9RDl9TCH; Thu, 13 May 2021 13:23:31 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1620905011; bh=WOgoY8/LAB0nyFGWSAnRMCy3MHmckZrV+4bY4yJvUBE=;
        h=From;
        b=Qzf5TJkL6A5Ccnzeyd0qpITWG9zuwKddm4Wkjbs2EEpckaQ2KY0tM8Ma4XViIq5Yd
         O6Ah7aUA14kqpjM1jUPvpVkVZSAiy9T+Xarvs2Mp5bzDiXKaRcIcAf1ZcOwMEYZ7mg
         S0690CmXN+T59H2SzqzDIjyBz4oVaPqPNYZB9Tl5mWDGNbBN19J1rbRDKLaQNbP1I+
         c60ZBPt/coKuwukMcZnKyJXaOQGlKJTPZDtAwHwuZgoahvsAeIyWFFND3Ik4NOrQhr
         3aBe/M1uJMIGUWbl4MSHYJ9Y8KnuGLLNyP4maayzmxTdALgll8YiAfRarDoOZNw90l
         Ur18YMR8im1TQ==
X-CNFS-Analysis: v=2.4 cv=A9ipg4aG c=1 sm=1 tr=0 ts=609d0c33 cx=a_exe
 a=v+7NFWUWLAxl90LcUtT8lA==:117 a=C-c6dMTymFoA:10 a=IkcTkHD0fZMA:10
 a=vesc6bHxzc4A:10 a=bGNZPXyTAAAA:8 a=wn1pJw0M0rjdo80TUYYA:9
 a=qVAXYMN7La3Y-hfU:21 a=DukbQzopxqIU8XLG:21 a=QEXdDO2ut3YA:10
 a=yL4RfsBhuEsimFDS2qtJ:22
Date:   Thu, 13 May 2021 13:23:31 +0200 (CEST)
From:   Dario Binacchi <dariobin@libero.it>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Gianluca Falavigna <gianluca.falavigna@inwind.it>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <434926916.298425.1620905011355@mail1.libero.it>
In-Reply-To: <20210510123608.wywx3bb3vrgkzq2o@pengutronix.de>
References: <20210509124309.30024-1-dariobin@libero.it>
 <20210509124309.30024-4-dariobin@libero.it>
 <20210510122512.5lcvvvwzk6ujamzb@pengutronix.de>
 <20210510123608.wywx3bb3vrgkzq2o@pengutronix.de>
Subject: Re: [PATCH 3/3] can: c_can: cache frames to operate as a true FIFO
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.3-Rev34
X-Originating-IP: 185.33.57.41
X-Originating-Client: open-xchange-appsuite
x-libjamsun: XzH5u9jq99NX4od7nxgeKsNPlzXQ8dBq
x-libjamv: mhMvMv7o5XE=
X-CMAE-Envelope: MS4xfGQ5Om7oJwdC3MVFnBmyX6LdXNhOleC6Qc/QB9BTz7Sn6uu2mOPvhGn+2atHH1UKPFo8TtR3ffZW7ErWPktjRAkDyxf/hSD6n/+GQRsmSVdf+Pb0McgU
 doGxJCOF5nTizrPbff1StvkFTTP1SRLV38m+JR0Z4b9C5V6Dy0Qfb0nR/kSNwMLHyFq4x7twb6vt8JtzoM6jPgzdME3vl1iIzsa6hbg16G7M2gB1nDdIoVLG
 Qee4uenIquALwWcIBSj3n5br4FYEHkHR0ugHf+gJ122qmF9Zx7DsYzWjPS0dA3yRlw9pzTGOzLyr3OWGh9l9De1XNRy4pik8GetHmqX+ubyXV4M42Jma2ZX1
 FRyBXaTP3rVIxVJjUUVHpZsjzHza5DrL+iB+cwGYuwG87jj3kXlcbJ21QPDnkOnpd62kme+WWR0l+z2mFLIQtdz0AL5bKskbUljDGXzHyK5kn18wIxFcBp1V
 bH/4+/a9Uv4GThFIIB6hMkYKsVr1Zb3ZZrGh+w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> Il 10/05/2021 14:36 Marc Kleine-Budde <mkl@pengutronix.de> ha scritto:
> 
>  
> On 10.05.2021 14:25:15, Marc Kleine-Budde wrote:
> > On 09.05.2021 14:43:09, Dario Binacchi wrote:
> > > As reported by a comment in the c_can_start_xmit() this was not a FIFO.
> > > C/D_CAN controller sends out the buffers prioritized so that the lowest
> > > buffer number wins.
> > > 
> > > What did c_can_start_xmit() do if it found tx_active = 0x80000000 ? It
> > > waited until the only frame of the FIFO was actually transmitted by the
> > > controller. Only one message in the FIFO but we had to wait for it to
> > > empty completely to ensure that the messages were transmitted in the
> > > order in which they were loaded.
> > > 
> > > By storing the frames in the FIFO without requiring its transmission, we
> > > will be able to use the full size of the FIFO even in cases such as the
> > > one described above. The transmission interrupt will trigger their
> > > transmission only when all the messages previously loaded but stored in
> > > less priority positions of the buffers have been transmitted.
> > 
> > The algorithm you implemented looks a bit too complicated to me. Let me
> > sketch the algorithm that's implemented by several other drivers.
> > 
> > - have a power of two number of TX objects
> > - add a number of objects to struct priv (tx_num)
> >   (or make it a define, if the number of tx objects is compile time fixed)
> > - add two "unsigned int" variables to your struct priv,
> >   one "tx_head", one "tx_tail"
> > - the hard_start_xmit() writes to priv->tx_head & (priv->tx_num - 1)
> > - increment tx_head
> > - stop the tx_queue if there is no space or if the object with the
> >   lowest prio has been written
> > - in TX complete IRQ, handle priv->tx_tail object
> > - increment tx_tail
> > - wake queue if there is space but don't wake if we wait for the lowest
> >   prio object to be TX completed.
> > 
> > Special care needs to be taken to implement that lock-less and race
> > free. I suggest to look the the mcp251xfd driver.
> 
> After converting the driver to the above outlined implementation it
> should be more straight forward to add the caching you implemented.  
> 

I took some time to think about your suggestions.
The submitted patch was developed trying to improve the
CAN transmission using the current driver design for minimize
the creation of bugs.
If I'm not missing something you suggest me to change the
driver design as a pre-condition to apply an updated version
of my patch. IMHO this would increase the possibility of generating
bugs, even for parts of the code that are considered stable.
If the algorithm I have implemented is a bit too complicated,
let's try to simplify it starting from the submitted patch.

Waiting for your reply, thanks and regards
Dario

> regards,
> Marc
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
