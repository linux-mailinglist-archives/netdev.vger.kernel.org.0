Return-Path: <netdev+bounces-2162-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 331D3700944
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:37:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D567D281B96
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 13:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E39F1E513;
	Fri, 12 May 2023 13:37:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F2ABE4E
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:37:56 +0000 (UTC)
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598B011DAB;
	Fri, 12 May 2023 06:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1683898673; x=1715434673;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u3IuZcL72YfgHjbQtg6PAgQgvupTHpRlXa6SzN4Wjn0=;
  b=GuS5hUOaOazn1DkFZzjm4BbEWgZRnVANn+c/7ZP1XqE7BnxDFRnwgXCN
   acitXDaA/wlrCtCdIPK62n0/Sq1W2ONqCymLwPZIahafN8yuRHBSNmHpx
   n4YQKUFwU8S4PCf9zOnBOXr5SsZaTS+Pmhi0xAAE2Pu9/iXzMct9EqRzQ
   GZjzSISN0CaASK204iMzQ1u21kXjyJrpse8n5jDCjljk3g3P6Eu1LVS4z
   RQK/tYpX+SrbFMFTv69YkUM2DIWRW8F2jcQel8p458U0n/VQfW5J4lf/3
   4wvmCh6xZAw8Ied/FIfQYZp/3rI67hE1OuLvpg0eyGBzQwPaw5DUILBas
   g==;
X-IronPort-AV: E=Sophos;i="5.99,269,1677538800"; 
   d="scan'208";a="30880990"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 12 May 2023 15:37:51 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Fri, 12 May 2023 15:37:51 +0200
X-PGP-Universal: processed;
	by tq-pgp-pr1.tq-net.de on Fri, 12 May 2023 15:37:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1683898671; x=1715434671;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u3IuZcL72YfgHjbQtg6PAgQgvupTHpRlXa6SzN4Wjn0=;
  b=kMz2hCK22SRYEJOZpkMZ+L+uKZyijezzJ4v98g0WN2ffbyGLC5ez6u4D
   WHvAU8nr+xguQ67tjXMCGut1CXKXxvZa+wTM0zybwheyO3vnzhNlEikoK
   e4yOhUAywAKyqWygyXGIiW0lpBAsIFgVyeFLabUTxSZ354OYLDPjXbYGG
   I8FSBM/YuM/sJgAQUzZD6Q2nV6431CSlYtCYQb7KYjfYu1PErwxE8PopP
   yTOUsLL+emaw/3dxdiz/7+GJKVYTeiPXatOKjwm6FZyFxMyyIWQOO/xtQ
   /+oSAni5R3GXd/WxOkYcnUcJIWj9X+zIZPx2a7PTIIUKUWuPoCAgYqXdL
   w==;
X-IronPort-AV: E=Sophos;i="5.99,269,1677538800"; 
   d="scan'208";a="30880989"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 12 May 2023 15:37:51 +0200
Received: from steina-w.localnet (unknown [10.123.53.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 0261F280056;
	Fri, 12 May 2023 15:37:50 +0200 (CEST)
From: Alexander Stein <alexander.stein@ew.tq-group.com>
To: Yan Wang <rk.code@outlook.com>, "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] net: mdiobus: Add a function to deassert reset
Date: Fri, 12 May 2023 15:37:51 +0200
Message-ID: <1828875.atdPhlSkOF@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <ZF4J1VqEqbnE6JG9@shell.armlinux.org.uk>
References: <KL1PR01MB54486A247214CC72CAB5A433E6759@KL1PR01MB5448.apcprd01.prod.exchangelabs.com> <KL1PR01MB54488021E5650ED8A203057FE6759@KL1PR01MB5448.apcprd01.prod.exchangelabs.com> <ZF4J1VqEqbnE6JG9@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Russel,

Am Freitag, 12. Mai 2023, 11:41:41 CEST schrieb Russell King (Oracle):
> On Fri, May 12, 2023 at 05:28:47PM +0800, Yan Wang wrote:
> > On 5/12/2023 5:02 PM, Russell King (Oracle) wrote:
> > > On Fri, May 12, 2023 at 03:08:53PM +0800, Yan Wang wrote:
> > > > +	gpiod_set_value_cansleep(reset, gpiod_is_active_low(reset));
> > > > +	fsleep(reset_assert_delay);
> > > > +	gpiod_set_value_cansleep(reset, !gpiod_is_active_low(reset));
> > >=20
> > > Andrew, one of the phylib maintainers and thus is responsible for code
> > > in the area you are touching. Andrew has complained about the above
> > > which asserts and then deasserts reset on two occasions now, explained
> > > why it is wrong, but still the code persists in doing this.
> > >=20
> > > I am going to add my voice as another phylib maintainer to this and s=
ay
> > > NO to this code, for the exact same reasons that Andrew has given.
> > >=20
> > > You now have two people responsible for the code in question telling
> > > you that this is the wrong approach.
> > >=20
> > > Until this is addressed in some way, it is pointless you posting
> > > another version of this patch.
> > >=20
> > > Thanks.
> >=20
> > I'm very sorry, I didn't have their previous intention.
> > The meaning of the two assertions is reset and reset release.
> > If you believe this is the wrong method, please ignore it.
>=20
> As Andrew has told you twice:
>=20
> We do not want to be resetting the PHY while we are probing the bus,
> and he has given one reason for it.
>=20
> The reason Andrew gave is that hardware resetting a PHY that was not
> already in reset means that any link is immediately terminated, and
> the PHY has to renegotiate with its link partner when your code
> subsequently releases the reset signal. This is *not* the behaviour
> that phylib maintainers want to see.
>=20
> The second problem that Andrew didn't mention is that always hardware
> resetting the PHY will clear out any firmware setup that has happened
> before the kernel has been booted. Again, that's a no-no.

I am a bit confused by your statement regarding always resetting a PHY is a=
=20
no-no. Isn't mdiobus_register_device() exactly doing this for PHYs? Using=20
either a GPIO or reset-controller.
Thats's also what I see on our boards. During startup while device probing=
=20
there is a PHY reset, including the link reset.
And yes, that clears settings done by the firmware, e.g. setting PHY's LED=
=20
configuration.

Best
Alexander

> The final issue I have is that your patch is described as "add a
> function do *DEASSERT* reset" not "add a function to *ALWAYS* *RESET*"
> which is what you are actually doing here. So the commit message and
> the code disagree with what's going on - the summary line is at best
> misleading.
>=20
> If your hardware case is that the PHY is already in reset, then of
> course you don't see any of the above as a problem, but that is not
> universally true - and that is exactly why Andrew is bringing this
> up. There are platforms out there where the reset is described in
> the firmware hardware description, *but* when the kernel boots, the
> reset signal is already deasserted. Raising it during kernel boot as
> you are doing will terminate the PHY's link with the remote end,
> and then deasserting it will cause it to renegotiate.
>=20
> Thanks.


=2D-=20
TQ-Systems GmbH | M=FChlstra=DFe 2, Gut Delling | 82229 Seefeld, Germany
Amtsgericht M=FCnchen, HRB 105018
Gesch=E4ftsf=FChrer: Detlef Schneider, R=FCdiger Stahl, Stefan Schneider
http://www.tq-group.com/



