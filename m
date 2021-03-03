Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F029232C3EB
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236175AbhCDAJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:09:03 -0500
Received: from smtp-16-i2.italiaonline.it ([213.209.12.16]:50737 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345371AbhCCHYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 02:24:17 -0500
Received: from oxapps-13-073.iol.local ([10.101.8.83])
        by smtp-16.iol.local with ESMTPA
        id HLqHlh1k8f2ANHLqHlsrls; Wed, 03 Mar 2021 08:22:46 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614756166; bh=QJcBdYO/0I9MwVLIbtdpqhadKDYr8uo6v7fShrjNVOY=;
        h=From;
        b=CcXR4Gb+90GDLfsjnSRHZ+xmJNuI+Yk6uN7QG1YKXFtUKwXGKJ61EpMWopoO+WqqK
         KK0BB84q0yiB0JZYH40C68M4KeiZcfpPkIOeE7ZSXFvN6UQod+iKMa6ddR/4HB8dvH
         gArUzkXWSPIEjJ/hFIRoToiVxZ/OAntTCYBvqBuU/eGzZDE1iK7e+CM+zavdrII2hK
         ftyKjrzH1aDopsTe11W1OCDlr2v6Rai1wYU/qh7XvJVAHyFc+tSVjMagn/XegGWAXX
         E7Z3aSUDyLYtrGY5svV7ZJVJjI/dSgeq0SCN+b8vcA4rBP7Jvcgm9FBPV5QNU/taNZ
         WyAsYuaX2rIwQ==
X-CNFS-Analysis: v=2.4 cv=Adt0o1bG c=1 sm=1 tr=0 ts=603f3946 cx=a_exe
 a=w+zvPzfS58/fxdOpREFJIQ==:117 a=C-c6dMTymFoA:10 a=IkcTkHD0fZMA:10
 a=vesc6bHxzc4A:10 a=VwQbUJbxAAAA:8 a=SIyDddvurb8hmoSH9n0A:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=BPzZvq435JnGatEyYwdK:22
Date:   Wed, 3 Mar 2021 08:22:45 +0100 (CET)
From:   Dario Binacchi <dariobin@libero.it>
To:     Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
Cc:     linux-kernel@vger.kernel.org,
        Federico Vaga <federico.vaga@gmail.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <431497521.23578.1614756165933@mail1.libero.it>
In-Reply-To: <20210302184451.GC26930@x1.vandijck-laurijssen.be>
References: <20210228103856.4089-1-dariobin@libero.it>
 <20210228103856.4089-4-dariobin@libero.it>
 <20210302184451.GC26930@x1.vandijck-laurijssen.be>
Subject: Re: [PATCH v3 3/6] can: c_can: fix control interface used by
 c_can_do_tx
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.3-Rev27
X-Originating-IP: 185.33.57.41
X-Originating-Client: open-xchange-appsuite
x-libjamsun: TDghmEpNsl1kzDDdlh5MJLZ+dOyjbiBd
x-libjamv: AjczAB1oGAU=
X-CMAE-Envelope: MS4xfCv1TYbXL5RSjKCVuB+MimNHn0kxtjf4jvMX6Qj+4hwJ9/N8/RsGC0fG5JxVvRC5siuJlDQfk2CrdKnbVwAn9kGMEc+sbVbf9SWKfgZuyeSIT7JsL/Ec
 NR71UeEtIIOYOSAnnVZGZ5nF2jutOgOUe6L+valOBYTLqa5zk7fwaFNbUbL/yQgy7PY5vsdvPV3fBY6AZIgUukGnje+B8Ka8TXO/hbQi5/7bR9pgWSCcQALF
 EaVcXCS1Mhggp/aW/30q7/1LEnt2pZq4/0EA/qqaSm8W7NKTRWa/kmtCZcxe9Zr74wvOePf3+pJdI3cJnlekfckUlJ20NO2Pw3lUKpBs/Ppu6ojiLYd4Ez+u
 A3GJnoPik8VdnWHu6/vkG6WIGFUwxrWWDB4//lRT6Y5TL8C/LjWbnvoiaZnsH1Knh0LK8/mnfQCm1vU1bZKOGZqMs7T/GhM2HDcSoeLxJmzmnb336HZjClxJ
 YJKrOKXAVMA/ReZy+NdOYaJNDZVlDLk/TowohBo0EuQKsLDUfAWPCXKk81LYCvjsm0R7bVQoVNrhluKu/Et4b5FQ9f9xpgNJDz3FslPjNAvUwVRVIy62WJ3n
 kkGt68AH/H3NIOltpYLjngg9aLODwOhioyotU6KGiuWWqIy+rTuTEwtutk2ba6zpV+v+qqWXPwY/ofdctUsFq78B
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kurt,

> Il 02/03/2021 19:44 Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be> ha scritto:
> 
>  
> On Sun, 28 Feb 2021 11:38:52 +0100, Dario Binacchi wrote:
> > According to commit 640916db2bf7 ("can: c_can: Make it SMP safe") let RX use
> > IF1 (i.e. IF_RX) and TX use IF2 (i.e. IF_TX).
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
> 
> Right. I had a similar effort last year to increase the reception
> throughput, but I ended with some sporadic strange tx echo problems.
> This fix may have fixed my problem as well.

Take a look at https://lore.kernel.org/patchwork/patch/1384649/

Thanks and regards,
Dario
> 
> >  		can_get_echo_skb(dev, idx, NULL);
> >  		bytes += priv->dlc[idx];
> >  		pkts++;
> > -- 
> > 2.17.1
> >
