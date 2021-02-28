Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BF93271E5
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 11:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhB1KgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 05:36:17 -0500
Received: from smtp-16-i2.italiaonline.it ([213.209.12.16]:51483 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230393AbhB1KgO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Feb 2021 05:36:14 -0500
Received: from oxapps-31-138.iol.local ([10.101.8.184])
        by smtp-16.iol.local with ESMTPA
        id GJQBlDtyRf2ANGJQBlYPxt; Sun, 28 Feb 2021 11:35:31 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614508531; bh=NULIkYeOU4BLtqTrd/JisnRnJK17Ka3rz6+/RjLJu1E=;
        h=From;
        b=XlBgs/DbEu+yzqG7MVn3XEM4GofJHYbTXAgLceb//gy1GwfHBKuKKbUE58SWk0z4g
         lgjc7zXBtJJ8MstLKi40unP3EalXxoggRq3rlyPhL6jHckX50Z0Dpqb+43Z+rTOsDK
         +xm18/IcqZrAO8EV5ChZ1raALiWYwHg+qaZlHqedwqhPKWZeMNQFBYzhTldAWaM3O4
         abHsT3f4VQchjCRm+9DG5+DJF2gycde1NHbPQE47gVDMxS9AvLbLx14GJpJS/tGdlY
         wm9QSbxvWOmCyHJfQcN4Z4BAV4vu75PJjLzlz3Ks4gOJpJqWf+7xr46YmKEJV2S3eb
         72QDH/xsyXKRw==
X-CNFS-Analysis: v=2.4 cv=Adt0o1bG c=1 sm=1 tr=0 ts=603b71f3 cx=a_exe
 a=SkAuTGSu9wVn7tcq8ZjrZA==:117 a=UPWQtH3J-JgA:10 a=IkcTkHD0fZMA:10
 a=_gZzKa99_6AA:10 a=bGNZPXyTAAAA:8 a=bAF_0_vCazFOC95qmekA:9 a=QEXdDO2ut3YA:10
 a=yL4RfsBhuEsimFDS2qtJ:22
Date:   Sun, 28 Feb 2021 11:35:31 +0100 (CET)
From:   Dario Binacchi <dariobin@libero.it>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Federico Vaga <federico.vaga@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <942251933.544595.1614508531322@mail1.libero.it>
In-Reply-To: <20210226084456.l2oztlesjzl6t2nm@pengutronix.de>
References: <20210225215155.30509-1-dariobin@libero.it>
 <20210225215155.30509-4-dariobin@libero.it>
 <20210226084456.l2oztlesjzl6t2nm@pengutronix.de>
Subject: Re: [PATCH v2 3/6] can: c_can: fix control interface used by
 c_can_do_tx
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.3-Rev27
X-Originating-IP: 87.20.116.197
X-Originating-Client: open-xchange-appsuite
x-libjamsun: +PaVVzVYPsxtI6fuW52eUtkgvkZv4krf
x-libjamv: tKu69u0FWKo=
X-CMAE-Envelope: MS4xfCq2BupWIOcmOjxc/q9eTplgcRRy+xMPwEufQ0d542+HiWMee4f6K6biashIngg0bOfcMPHzRUfKLFwFeY3rbjHVdgfs7V4B4LvJKZXzv5GiZXez9OBj
 CDsIlK8WGY69XyPLJd2OYH4ADNiQuXrj+D1nFuHxwH2kw40qLohHw5KlSGQBwpfcgjaCHnFDcGuwYEC7KYuktnlwzrZFH0M4SZFoESdxRj/azWE278ZRheAd
 G3VvKFKN/f+4ZcGHJhmDcgZC9v0FNmT9iFjQzO6D0RPOHFzMpEVHEuOiv0ZOfqRNCNHr7wzgiksfUAt0vI6WW9+7Tj/thWqKX+v0yd4sJTl0N6P9Dm2Dqmpk
 c66A4L8T9Uo+A4OMJ5ONbBliZxn4xwq2d8cDns5VqHpH94MkWAQ7i9tMdsL5hUp8Ty8V5PR9dQ7kD4jtgsXRTcvgAHPsD6PIs07cF60yPmLciG3DvXm+i46U
 nMZhmqcq+F+OlT4xhIkyus+pupVGCGGWU+84uyXAJ91M8CltI8bY7EOwJEWAvQtF1/mKBJrTjcujPvufyfOA30YdSjWZNaC8w6vaZ3OjPDx8vKnWn3JadZhZ
 YFHV0okst8+psoY7v9ieO2Ef3m6B+gfzk4atRkwpm3qRPg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> Il 26/02/2021 09:44 Marc Kleine-Budde <mkl@pengutronix.de> ha scritto:
> 
>  
> On 25.02.2021 22:51:52, Dario Binacchi wrote:
> > According to commit 640916db2bf7 ("can: c_can: Make it SMP safe") let RX use
> > IF1 (i.e. IF_RX) and TX use IF2 (i.e. IF_TX).
> 
> Is this a fix?
> 

I think that If I consider what is described in the 640916db2bf7 commit, using 
the IF_RX interface in a tx routine is wrong.

Thanks and regards
Dario

> Marc
> 
> > 
> > Signed-off-by: Dario Binacchi <dariobin@libero.it>
> > ---
> > 
> > (no changes since v1)
> > 
> >  drivers/net/can/c_can/c_can.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
> > index dbcc1c1c92d6..69526c3a671c 100644
> > --- a/drivers/net/can/c_can/c_can.c
> > +++ b/drivers/net/can/c_can/c_can.c
> > @@ -732,7 +732,7 @@ static void c_can_do_tx(struct net_device *dev)
> >  		idx--;
> >  		pend &= ~(1 << idx);
> >  		obj = idx + C_CAN_MSG_OBJ_TX_FIRST;
> > -		c_can_inval_tx_object(dev, IF_RX, obj);
> > +		c_can_inval_tx_object(dev, IF_TX, obj);
> >  		can_get_echo_skb(dev, idx, NULL);
> >  		bytes += priv->dlc[idx];
> >  		pkts++;
> > -- 
> > 2.17.1
> > 
> > 
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
