Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FF2327445
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 20:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhB1TzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 14:55:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:49958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230386AbhB1TzD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Feb 2021 14:55:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7E4660C41;
        Sun, 28 Feb 2021 19:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614542063;
        bh=cKtE31HFNB8ZBcWmsLR1+pRpbPBcFL2odifW40lmBmk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HivyyI1YErTf65QQslwLRbFfI0qLj5v6R2gIJig6S9NXtp71wqJmKRaMkred2f6V4
         4u7ntoFQ3AFly4PFF/I/zqUh5BC7CgZFGzqRr3o3ce20kAA3C+jL74AsvKYMsFrzQj
         tTsWU9D9+j8HHrWESPq/2llbhHYB5wuFJlirAzOk4xqY4X3VpOB4QOgZpFPpnVm9z8
         6IX234F8dfndcxC5V4c15TcsljHoDBxbhuAzYUO1XBPW711wo5iKspltTBlmrElmqQ
         O35Wj7l6VDoEsysv9Tm8G0HHdU+VRX4m9S8PP7OvgIqr7wkLAcl9AVID+3WRQl4+Yw
         WttL/V/rsbU3Q==
Date:   Sun, 28 Feb 2021 11:54:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJl?= =?UTF-8?B?Y2tp?= <zajec5@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH net] net: broadcom: bcm4908_enet: enable RX after
 processing packets
Message-ID: <20210228115422.490b7e5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f85294f6-be06-5cc1-b307-f2c5d6ce7ffe@gmail.com>
References: <20210226132038.29849-1-zajec5@gmail.com>
        <f85294f6-be06-5cc1-b307-f2c5d6ce7ffe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 27 Feb 2021 08:38:24 -0800 Florian Fainelli wrote:
> On 2/26/2021 5:20 AM, Rafa=C5=82 Mi=C5=82ecki wrote:
> > From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> >=20
> > When receiving a lot of packets hardware may run out of free
> > descriptiors and stop RX ring. Enable it every time after handling
> > received packets.
> >=20
> > Fixes: 4feffeadbcb2 ("net: broadcom: bcm4908enet: add BCM4908 controlle=
r driver")
> > Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl> =20
>=20
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thanks!

Out of curiosity - is the performance not impacted by this change?
bcm4908_enet_dma_rx_ring_enable() does an RMW, the read could possibly
removed by caching the expected value.
