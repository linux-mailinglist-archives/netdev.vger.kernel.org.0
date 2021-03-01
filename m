Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098FB32888F
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 18:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238438AbhCARmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 12:42:40 -0500
Received: from smtp-17-i2.italiaonline.it ([213.209.12.17]:55737 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238755AbhCARir (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 12:38:47 -0500
Received: from oxapps-35-162.iol.local ([10.101.8.208])
        by smtp-17.iol.local with ESMTPA
        id GmUdlsF91lChfGmUdl1Eu9; Mon, 01 Mar 2021 18:38:03 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614620283; bh=FVbl+Y44UhVS7waCZVt+Dbv2JBd4H0UEoz219RNGc10=;
        h=From;
        b=ajJEZOhnsf3mDvtl5EakHn63FoaWkHONgswabXq710qILkIPbcxu43in2iTnHCpOz
         jzolWfOyyMwMPjl98VTY9XU+dopibtTgwwL26aDu82yHIbGIcmYhyick8KRodhH08O
         uDNe7bbNk2V0EyfGIGzbXg7FuNOXbKMiczYdmowgalfD2PA0QTe2i6MMxoC/R8fvkC
         7C0flUW7+5+Kux3gxOXvhwooFTO9rkR2BiB8Gs3q/yjSB+fyMI/LY+cU+MNSOXsOVv
         i4vRLCEfTyBhr5QtP+zhyVzoVjr3sFAzPX54FmQ7wrqyJHEYrKOmSQF0I930K80TWq
         dSnAisaYhCH5Q==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=603d267b cx=a_exe
 a=OCAZjQWm+uh9gf1btJle/A==:117 a=UPWQtH3J-JgA:10 a=IkcTkHD0fZMA:10
 a=_gZzKa99_6AA:10 a=bGNZPXyTAAAA:8 a=bAF_0_vCazFOC95qmekA:9 a=QEXdDO2ut3YA:10
 a=yL4RfsBhuEsimFDS2qtJ:22
Date:   Mon, 1 Mar 2021 18:38:03 +0100 (CET)
From:   Dario Binacchi <dariobin@libero.it>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Federico Vaga <federico.vaga@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <1729787135.578206.1614620283639@mail1.libero.it>
In-Reply-To: <20210301113612.rvbjnqacqstseokm@pengutronix.de>
References: <20210225215155.30509-1-dariobin@libero.it>
 <20210225215155.30509-4-dariobin@libero.it>
 <20210226084456.l2oztlesjzl6t2nm@pengutronix.de>
 <942251933.544595.1614508531322@mail1.libero.it>
 <20210301113612.rvbjnqacqstseokm@pengutronix.de>
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
x-libjamsun: NCOLpVhTJdj3Uf99jpm3M5t5Srhr1anV
x-libjamv: p6zJ+EtlKqk=
X-CMAE-Envelope: MS4xfIHSKXnQkT6jgfg1GlXLQRy6sMpwMADz3N6UBeMzYA6AbEM4vY8B67Fe4ur+HUzTHP5zYq/0KLrRV8ThasiZwOA5G1LLbi+4jBpPmiubftUDGx3IScRg
 2ZC6EeMo3CDsCIwo7pmMwmLntrZDBB4xwlipRWqCZmjeP74d2I6Yfy0aVRJW7G2F2JgQPOHaf3QNBglOiDfQP6FSfe4wb315WLS+YWBhNvly6g9ku0uFSEqZ
 wKgYO9DShhGwdHClYUniRfOnqqCDjxV7XlzYGIe2JaMUeuNQsrk2pPul7ShFHzO9n/bHCC5UW9GOyxDenX2DRhK5fexk1EMFUxY0j7nZEl143VJp3nILU55Z
 MYo4MBiBXyQLQY4sy8a2ZkkvuOKfecFLGMegTNXNkAE69pV770MGYaHtakXD7b0re62sd5QPM/5fRPpeOR4YQXaylY2wExJmvr3/4dD/D1qlK+NO0afXgg+H
 UbUH29qOq8sMwJIE
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Il 01/03/2021 12:36 Marc Kleine-Budde <mkl@pengutronix.de> ha scritto:
> 
>  
> On 28.02.2021 11:35:31, Dario Binacchi wrote:
> > > On 25.02.2021 22:51:52, Dario Binacchi wrote:
> > > > According to commit 640916db2bf7 ("can: c_can: Make it SMP safe") let RX use
> > > > IF1 (i.e. IF_RX) and TX use IF2 (i.e. IF_TX).
> > > 
> > > Is this a fix?
> > > 
> > 
> > I think that If I consider what is described in the 640916db2bf7
> > commit, using the IF_RX interface in a tx routine is wrong.
> 
> Yes, IF_RX is used in c_can_do_tx(), but that's called from
> c_can_poll(), which runs ins NAPI.

Yes, you are right. I was misled by the name of the function.

> 
> As far as I understand 640916db2bf7 ("can: c_can: Make it SMP safe")
> fixes the race condition that c_can_poll() and c_can_start_xmit() both
> access the same IF. See again the patch description:
> 
> | The hardware has two message control interfaces, but the code only uses the
> | first one. So on SMP the following can be observed:
> | 
> | CPU0            CPU1
> | rx_poll()
> |   write IF1     xmit()
> |                 write IF1
> |   write IF1
> 
> It's not 100% accurate, as the race condition is not just
> c_can_do_rx_poll() against the c_can_start_xmit(), but the whole
> c_can_poll() against c_can_start_xmit().
> 
> If you think my analysis is correct, please update the patch and add a
> comment to clarify why IF_RX is used instead of changing it to IF_TX.

I agree with you, I'll do it.

Thanks and regards,
Dario

> 
> regards,
> Marc
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
