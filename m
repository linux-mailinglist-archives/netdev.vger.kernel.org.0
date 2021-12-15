Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACBF475E80
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 18:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245290AbhLORWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 12:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245280AbhLORWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 12:22:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B2AC061574;
        Wed, 15 Dec 2021 09:22:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DF56B81D3F;
        Wed, 15 Dec 2021 17:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3A3C36AE3;
        Wed, 15 Dec 2021 17:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639588949;
        bh=VE31AO0Y6HSFW19USLM3ndbP3bk8jXc4yVGR74QSJyI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WDQZgNHg21BAH+k1U4s5WXQAuvFlLYKpVq/MCL+YXkDAHjL+GKX5kMDazKzo9E0vN
         hxY+HIWzPorm2wxBOTR1i1IfyfKL8SfjE4n3Dc2SjCO6Nqe9+N1blCxRuoho9L7wWx
         Ub8TUyz9hKaNlW3vnCsN/+iIJeMZc5gu01TbMnxBiX43HHpIPFZmll94KyPicoqDOC
         Sw6+hFNVZlhHGrT26rJ6sW8o+HqDzVY6KDCyS0KUnTOkxUqN9a4fkODjC7ZeGUjKEr
         iJnpl7JF5j4wBFOf4m50H5YwEDAOz1b0pMbCOsALiXlvk3SJkDiwiyRuI1MGUhFBwU
         H8H06fqTgQHlQ==
Date:   Wed, 15 Dec 2021 18:22:22 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-phy@lists.infradead.org, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH devicetree 2/2] dt-bindings: phy: Add
 `tx-amplitude-microvolt` property binding
Message-ID: <20211215182222.620606a0@thinkpad>
In-Reply-To: <YbnJhI2Z3lwC3vF9@lunn.ch>
References: <20211214233432.22580-1-kabel@kernel.org>
        <20211214233432.22580-3-kabel@kernel.org>
        <YbnJhI2Z3lwC3vF9@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Dec 2021 11:55:00 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> On Wed, Dec 15, 2021 at 12:34:32AM +0100, Marek Beh=C3=BAn wrote:
> > Common PHYs often have the possibility to specify peak-to-peak voltage
> > on the differential pair - the default voltage sometimes needs to be
> > changed for a particular board. =20
>=20
> Hi Marek
>=20
> Common PHYs are not the only user of this. Ethernet PHYs can also use
> it, as well as SERDESes embedded within Ethernet switches.
>=20
> That is why i suggested these properties go into something like
> serdes.yaml. That can then be included into Common PHY, Ethernet PHYs,
> switch drivers etc.
>=20
> Please could you make such a split?
>=20
>        Andrew

Hi Andrew,

and where (into which directory) should this serdes.yaml file go?

My idea was to put the properties into common PHY and then refer to
them from other places, so for example this would be put into ethernet
PHY binding:

  serdes-tx-amplitude-microvolt:
    $ref: '/schemas/phy/phy.yaml#/properties/tx-amplitude-microvolt'

Marek
