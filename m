Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16FA6B21DB
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 11:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjCIKwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 05:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjCIKwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 05:52:12 -0500
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F64E5030
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 02:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1678359131; x=1709895131;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g3jkUG6ER0tUIhplV6bGuKeJ1UlcSWa/x/zBSApsFNk=;
  b=G6v4eCBiw8pbYCT/wr0mAuzuaArAnqCfv7FOSaiIqLcmbgiENT8FBQjp
   5LvWBCxIcpWWpLpy6DxcDvA6/SlOYs2Egqe6AMOpt+0BYtJ52an/rzzJU
   OacS95DA1dca2nFYxRBgG71Q7axmtAYCR5c1wJbLZAIg/gbGPk3lBkiAn
   rn7grHsrknC5vdEMslS3I6ZXPXwQUZgrvbZLqpodkKKWqmWv5jB95S9KD
   ksmUEwL2gF78WRnVrOd6mdtEvIfcB4U5AfF0PP8VWUDLmK8qCBlRfPuux
   p0Vm0eI4viAvoY6jlv0NbCuNfe5mIQHHqY+3pw+qQaz89UYpLcvkO01JS
   w==;
X-IronPort-AV: E=Sophos;i="5.98,246,1673910000"; 
   d="scan'208";a="29574766"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 09 Mar 2023 11:52:09 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Thu, 09 Mar 2023 11:52:09 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Thu, 09 Mar 2023 11:52:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1678359129; x=1709895129;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g3jkUG6ER0tUIhplV6bGuKeJ1UlcSWa/x/zBSApsFNk=;
  b=nOfUm1Xru0lNX6ympp6b+3Xir7vzRuMI53X07qLX5w6qAaGuCj/HXmM1
   KZ5NcuWrC4yMqpRxfYEP1i4ytkQnhcyUJOPQFWpSGHUIO9eIk66ELYB+D
   ptvx/r14YRNwPggu13SEIxnhwqEvYJWKfRJqT5ZZUe159bG0dEXAOPNpb
   9GgLn7nqnvInNJrmdtrHEuYdp5k1/1d7pRlsDTHWKaNyal4DRUn3ZgU4d
   uOfVGuBsWMH95stIIZbZPY8IznD7Et78txM5kasH+IAIH7t3WjbO9l1k7
   ePaNWusP7DnJPafCqDxufQP8+nnETi5A61hOwRAFHXKrSKvgpOEKZQcFu
   w==;
X-IronPort-AV: E=Sophos;i="5.98,246,1673910000"; 
   d="scan'208";a="29574765"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 09 Mar 2023 11:52:09 +0100
Received: from steina-w.localnet (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 53F90280056;
        Thu,  9 Mar 2023 11:52:09 +0100 (CET)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: phy: dp83867: Disable IRQs on suspend
Date:   Thu, 09 Mar 2023 11:52:06 +0100
Message-ID: <2156693.PYKUYFuaPT@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <Y/4YN+j19SZNEizu@lunn.ch>
References: <20230228133412.7662-1-alexander.stein@ew.tq-group.com> <Y/4YN+j19SZNEizu@lunn.ch>
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

Hi Andrew,

thanks for the response.

Am Dienstag, 28. Februar 2023, 16:05:27 CET schrieb Andrew Lunn:
> > +static int dp83867_suspend(struct phy_device *phydev)
> > +{
> > +	/* Disable PHY Interrupts */
> > +	if (phy_interrupt_is_valid(phydev)) {
> > +		phydev->interrupts =3D PHY_INTERRUPT_DISABLED;
> > +		if (phydev->drv->config_intr)
> > +			phydev->drv->config_intr(phydev);
>=20
> It seems odd going via phydev->drv inside the driver to call functions
> which are also inside the driver. Why do you not directly call
> dp83867_config_intr()?

I was going the same way kszphy_suspend() (micrel.c) is doing. Maybe that w=
as=20
a bad example and it should be changed as well.
There should be no reason to not call dp83867_config_intr directly.

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
>=20
> Is there a race here? Say the PHY is in a fixed mode, not
> autoneg. Could it be, that as soon as you clear the power down bit in
> genphy_resume() it signals a link up interrupt? dp83867_config_intr()
> then acknowledged and clears that interrupt, before enabling the
> interrupt, so the link up event never gets passed to phylib? Maybe the
> order needs reversing here?

Yes, your explanation sounds reasonable, unfortunately I can't test this ri=
ght=20
now, as there is some other error regarding PMIC power domains.
If your reasoning is true then micrel.c has the same issue.

Best regards,
Alexander
=2D-=20
TQ-Systems GmbH | M=FChlstra=DFe 2, Gut Delling | 82229 Seefeld, Germany
Amtsgericht M=FCnchen, HRB 105018
Gesch=E4ftsf=FChrer: Detlef Schneider, R=FCdiger Stahl, Stefan Schneider
http://www.tq-group.com/


