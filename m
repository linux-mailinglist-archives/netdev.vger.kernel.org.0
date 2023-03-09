Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52C86B217F
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 11:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjCIKeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 05:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjCIKeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 05:34:10 -0500
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E77468D
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 02:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1678358047; x=1709894047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5AEt7TutRPstKOvQA8s0bXhDciveTaAzyyzvA5agFHI=;
  b=bqfo8DXI9RCaYR1ErlqPIbL+XJN+IQ800wXK4PmNVdDyGJ5an02WsNV+
   My5Moikauc2GdRvquiLoz5oQFXPeyyBekSh7TZa+n6aEps2yWmZOeqcgo
   FkOX2V1xFFeGzk5Begw4Rq5MJgniLVD8EHeqj1/E02drdV+9EY0kkW05U
   YhQSlfTfNZYw85Z1kJDPyODY0TaTCk5pkEMIVMCCzYa79bFwhiCxE3bxP
   eYY4x8nHJNpUz5h3UcDAxJHwuWnQGhQajkFUmO8JgW2ug1LrkuW4WfVp8
   iI4tqHSH2HgtEpimfhzen6X8cY1082eANGp7+yJhIa1v519Ks4p/BOuf6
   w==;
X-IronPort-AV: E=Sophos;i="5.98,246,1673910000"; 
   d="scan'208";a="29574074"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 09 Mar 2023 11:34:05 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Thu, 09 Mar 2023 11:34:05 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Thu, 09 Mar 2023 11:34:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1678358045; x=1709894045;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5AEt7TutRPstKOvQA8s0bXhDciveTaAzyyzvA5agFHI=;
  b=UweYHEBsFIcwY9c/RVM+jwnXzt9BdzKFHqaMMLkwDlNPZZjVk4gU7ltW
   MiOf3cWkJOBk0gMXEVcBbCwymCv3c7m9avLQ+9Ywbh6W9luZwybhJZe0y
   b9mGkeJF96rHzvW2Rt20EKUhlseagmoy+Pu0w+0E6jFjBQ0fKb7FOkPeQ
   rKKXG+yBMoBbXjuEPUJZo9QjYtvH/7fK5hc5S2jIYxdc/5+6fqERgTr6J
   VcsZz8KdqIX+Qrp50y9O3aSWIWe6P0WYTI4xJwUnZIK/jTB1V5vmYo9fG
   0T0/+EfbimbQJMejp/Wez6AIEUdWUKWDJufqKqdevB6S1mvAzi2d2MmBA
   w==;
X-IronPort-AV: E=Sophos;i="5.98,246,1673910000"; 
   d="scan'208";a="29574073"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 09 Mar 2023 11:34:05 +0100
Received: from steina-w.localnet (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 5D5FC280056;
        Thu,  9 Mar 2023 11:34:05 +0100 (CET)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lukas Wunner <lukas@wunner.de>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: phy: dp83867: Disable IRQs on suspend
Date:   Thu, 09 Mar 2023 11:34:02 +0100
Message-ID: <10470264.nUPlyArG6x@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <1489eb86-908f-88ac-8f6f-c895a32a8c23@gmail.com>
References: <20230228133412.7662-1-alexander.stein@ew.tq-group.com> <1489eb86-908f-88ac-8f6f-c895a32a8c23@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Heiner,

Am Mittwoch, 1. M=E4rz 2023, 07:29:04 CET schrieb Heiner Kallweit:
> On 28.02.2023 14:34, Alexander Stein wrote:
> > Before putting the PHY into IEEE power down mode, disable IRQs to
> > prevent accessing the PHY once MDIO has already been shutdown.
> >=20
> > Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> > ---
> > I get this backtrace when trying to put the system into 'mem' powersavi=
ng
> > state.
>=20
> I would have expected the following commit to prevent this scenario:
> 1758bde2e4aa ("net: phy: Don't trigger state machine while in suspend")
>=20
> Can you check whether phydev->irq_suspended gets set in
> mdio_bus_phy_suspend() in your case?

No, this is not getting set, because mac_managed_pm is true.

> Which MAC driver do you use with this PHY?

This platform uses drivers/net/ethernet/freescale/fec_main.c

Best regards,
Alexander

> > [   31.355468] ------------[ cut here ]------------
> > [   31.360089] WARNING: CPU: 1 PID: 77 at drivers/net/phy/phy.c:1183
> > phy_error+0x10/0x54 [   31.367932] Modules linked in: bluetooth 8021q
> > garp stp mrp llc snd_soc_tlv320aic32x4_spi hantro_vpu snd_soc_fsl_
> > asoc_card snd_soc_fsl_sai snd_soc_imx_audmux snd_soc_fsl_utils
> > snd_soc_tlv320aic32x4_i2c snd_soc_simple_card_utils i mx_pcm_dma
> > snd_soc_tlv320aic32x4 snd_soc_core v4l2_vp9 snd_pcm_dmaengine v4l2_h264
> > videobuf2_dma_contig v4l2_mem2mem>=20
> >  videobuf2_memops videobuf2_v4l2 videobuf2_common snd_pcm crct10dif_ce
> >  governor_userspace snd_timer imx_bus snd cfg8>=20
> > 0211 soundcore pwm_imx27 imx_sdma virt_dma qoriq_thermal pwm_beeper fuse
> > ipv6 [   31.372014] PM: suspend devices took 0.184 seconds
> > [   31.415246] CPU: 1 PID: 77 Comm: irq/39-0-0025 Not tainted
> > 6.2.0-next-20230228+ #1425 2e0329a68388c493d090f81d406 77fb8aeac52cf
> > [   31.415257] Hardware name: TQ-Systems GmbH i.MX8MQ TQMa8MQ on MBa8Mx
> > (DT) [   31.415261] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SS=
BS
> > BTYPE=3D--) [   31.445168] pc : phy_error+0x10/0x54
> > [   31.448749] lr : dp83867_handle_interrupt+0x78/0x88
> > [   31.453633] sp : ffff80000a353cb0
> > [   31.456947] x29: ffff80000a353cb0 x28: 0000000000000000 x27:
> > 0000000000000000 [   31.464091] x26: 0000000000000000 x25:
> > ffff800008dbb408 x24: ffff800009885568 [   31.471235] x23:
> > ffff0000c0e4b860 x22: ffff0000c0e4b8dc x21: ffff0000c0a46d18 [ =20
> > 31.478380] x20: ffff8000098d18a8 x19: ffff0000c0a46800 x18:
> > 0000000000000007 [   31.485525] x17: 6f63657320313030 x16:
> > 2e30206465737061 x15: 6c65282064657465 [   31.492669] x14:
> > 6c706d6f6320736b x13: 2973646e6f636573 x12: 0000000000000000 [ =20
> > 31.499815] x11: ffff800009362180 x10: 0000000000000a80 x9 :
> > ffff80000a3537a0 [   31.506959] x8 : 0000000000000000 x7 :
> > 0000000000000930 x6 : ffff0000c1494700 [   31.514104] x5 :
> > 0000000000000000 x4 : 0000000000000000 x3 : ffff0000c0a3d480 [ =20
> > 31.521248] x2 : 0000000000000000 x1 : ffff0000c0f3d700 x0 :
> > ffff0000c0a46800 [   31.528393] Call trace:
> > [   31.530840]  phy_error+0x10/0x54
> > [   31.534071]  dp83867_handle_interrupt+0x78/0x88
> > [   31.538605]  phy_interrupt+0x98/0xd8
> > [   31.542183]  handle_nested_irq+0xcc/0x148
> > [   31.546199]  pca953x_irq_handler+0xc8/0x154
> > [   31.550389]  irq_thread_fn+0x28/0xa0
> > [   31.553966]  irq_thread+0xcc/0x180
> > [   31.557371]  kthread+0xf4/0xf8
> > [   31.560429]  ret_from_fork+0x10/0x20
> > [   31.564009] ---[ end trace 0000000000000000 ]---
> >=20
> > $ ./scripts/faddr2line build_arm64/vmlinux
> > dp83867_handle_interrupt+0x78/0x88 dp83867_handle_interrupt+0x78/0x88:
> > dp83867_handle_interrupt at drivers/net/phy/dp83867.c:332
> >=20
> >  drivers/net/phy/dp83867.c | 30 ++++++++++++++++++++++++++++--
> >  1 file changed, 28 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> > index 89cd821f1f46..ed7e3df7dfd1 100644
> > --- a/drivers/net/phy/dp83867.c
> > +++ b/drivers/net/phy/dp83867.c
> > @@ -693,6 +693,32 @@ static int dp83867_of_init(struct phy_device *phyd=
ev)
> >=20
> >  }
> >  #endif /* CONFIG_OF_MDIO */
> >=20
> > +static int dp83867_suspend(struct phy_device *phydev)
> > +{
> > +	/* Disable PHY Interrupts */
> > +	if (phy_interrupt_is_valid(phydev)) {
> > +		phydev->interrupts =3D PHY_INTERRUPT_DISABLED;
> > +		if (phydev->drv->config_intr)
> > +			phydev->drv->config_intr(phydev);
> > +	}
> > +
> > +	return genphy_suspend(phydev);
> > +}
> > +
> > +static int dp83867_resume(struct phy_device *phydev)
> > +{
> > +	genphy_resume(phydev);
> > +
> > +	/* Enable PHY Interrupts */
> > +	if (phy_interrupt_is_valid(phydev)) {
> > +		phydev->interrupts =3D PHY_INTERRUPT_ENABLED;
> > +		if (phydev->drv->config_intr)
> > +			phydev->drv->config_intr(phydev);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >=20
> >  static int dp83867_probe(struct phy_device *phydev)
> >  {
> > =20
> >  	struct dp83867_private *dp83867;
> >=20
> > @@ -968,8 +994,8 @@ static struct phy_driver dp83867_driver[] =3D {
> >=20
> >  		.config_intr	=3D dp83867_config_intr,
> >  		.handle_interrupt =3D dp83867_handle_interrupt,
> >=20
> > -		.suspend	=3D genphy_suspend,
> > -		.resume		=3D genphy_resume,
> > +		.suspend	=3D dp83867_suspend,
> > +		.resume		=3D dp83867_resume,
> >=20
> >  		.link_change_notify =3D dp83867_link_change_notify,
> >  		.set_loopback	=3D dp83867_loopback,


=2D-=20
TQ-Systems GmbH | M=FChlstra=DFe 2, Gut Delling | 82229 Seefeld, Germany
Amtsgericht M=FCnchen, HRB 105018
Gesch=E4ftsf=FChrer: Detlef Schneider, R=FCdiger Stahl, Stefan Schneider
http://www.tq-group.com/


