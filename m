Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C269FAA215
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 13:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387669AbfIEL45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 07:56:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731817AbfIEL45 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 07:56:57 -0400
Received: from localhost (unknown [82.195.192.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8881122CEC;
        Thu,  5 Sep 2019 11:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567684616;
        bh=wdTqBGzZQ4leglhr36XMdYedhNTdJDdwpiQCNXzkJDI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H55l7QnkZ69A7MNWrWBau7Dhg05/2syJeQI/Q8uksMOXbsdGsMv680/B9iw6Y61pL
         bl9m3A5v6iPbOpGjCnNbpcHDuGoGnFd1nE2WyOYvR+bc8WEQcBP3jzSSbL2tfjxCmT
         RlBxBpvL8l7bA8gBXgxCjgEnixHlMDm/26kIqFzo=
Date:   Thu, 5 Sep 2019 14:56:53 +0300
From:   Maxime Ripard <mripard@kernel.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     megous@megous.com, Chen-Yu Tsai <wens@csie.org>,
        Rob Herring <robh+dt@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: Re: [RESEND PATCH 0/5] Add bluetooth support for Orange Pi 3
Message-ID: <20190905115653.o2w7eyl4hvqegucv@flea>
References: <20190823103139.17687-1-megous@megous.com>
 <5524D5E9-FA82-4244-A91F-78CF1C3FB3FB@holtmann.org>
 <20190830092104.odipmbflounqpffo@flea>
 <D02B89FB-F8C0-40AD-A99A-6C1B4FEB72A0@holtmann.org>
 <20190830132034.u65arlv7umh64lx6@flea>
 <76FD40C7-10C5-4818-8EF9-60326ECA4243@holtmann.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="66mhhep6w5jiiqrl"
Content-Disposition: inline
In-Reply-To: <76FD40C7-10C5-4818-8EF9-60326ECA4243@holtmann.org>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--66mhhep6w5jiiqrl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 04, 2019 at 04:19:37PM +0200, Marcel Holtmann wrote:
> Hi Maxime,
>
> >>>>> (Resend to add missing lists, sorry for the noise.)
> >>>>>
> >>>>> This series implements bluetooth support for Xunlong Orange Pi 3 board.
> >>>>>
> >>>>> The board uses AP6256 WiFi/BT 5.0 chip.
> >>>>>
> >>>>> Summary of changes:
> >>>>>
> >>>>> - add more delay to let initialize the chip
> >>>>> - let the kernel detect firmware file path
> >>>>> - add new compatible and update dt-bindings
> >>>>> - update Orange Pi 3 / H6 DTS
> >>>>>
> >>>>> Please take a look.
> >>>>>
> >>>>> thank you and regards,
> >>>>> Ondrej Jirman
> >>>>>
> >>>>> Ondrej Jirman (5):
> >>>>> dt-bindings: net: Add compatible for BCM4345C5 bluetooth device
> >>>>> bluetooth: bcm: Add support for loading firmware for BCM4345C5
> >>>>> bluetooth: hci_bcm: Give more time to come out of reset
> >>>>> arm64: dts: allwinner: h6: Add pin configs for uart1
> >>>>> arm64: dts: allwinner: orange-pi-3: Enable UART1 / Bluetooth
> >>>>>
> >>>>> .../bindings/net/broadcom-bluetooth.txt       |  1 +
> >>>>> .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 19 +++++++++++++++++++
> >>>>> arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi  | 10 ++++++++++
> >>>>> drivers/bluetooth/btbcm.c                     |  3 +++
> >>>>> drivers/bluetooth/hci_bcm.c                   |  3 ++-
> >>>>> 5 files changed, 35 insertions(+), 1 deletion(-)
> >>>>
> >>>> all 5 patches have been applied to bluetooth-next tree.
> >>>
> >>> The DTS patches (last 2) should go through the arm-soc tree, can you
> >>> drop them?
> >>
> >> why is that? We have included DTS changes for Bluetooth devices
> >> directly all the time. What is different with this hardware?
> >
> > I guess some maintainers are more relaxed with it than we are then,
> > but for the why, well, it's the usual reasons, the most immediate one
> > being that it reduces to a minimum the conflicts between trees.
> >
> > The other being that it's not really usual to merge patches supposed
> > to be handled by another maintainer without (at least) his
> > consent. I'm pretty sure you would have asked the same request if I
> > would have merged the bluetooth patches through my tree without
> > notice.
>
> I took the two DTS patches out now and let the submitter deal with
> getting these merged.

Thanks!
Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--66mhhep6w5jiiqrl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXXD4BQAKCRDj7w1vZxhR
xRuEAQD4NBPiyuvLlo3LM5wXaUbunkvUUCDpAZ3nIkj1OvPjIgD8Da8U574V2FaU
aFSxv34yqbNn72v/P/KP/9zxT3Y40g8=
=SOn6
-----END PGP SIGNATURE-----

--66mhhep6w5jiiqrl--
