Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB18345080
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhCVUMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:12:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230358AbhCVULw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:11:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F42276196C;
        Mon, 22 Mar 2021 20:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616443912;
        bh=SUjHYsJBeIJrPqPO5nxHKyATiHgntMMjbecPWDGKyk4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hyxbV7vH/BkAFfvdS+YlHp7E/locQouO+IWAOziL2PH4u9gAtndlRVwQVhDJR2EmA
         h5l4OTvD5KPoNqd+0qNjuqyCjBzgPkXIZjfwlg40vOOSXpniCtYlRv1FkIa3/xq6+X
         3xB6OmDf8oX0qEoBP4WLM9YAv1mePWhPq9HlVlQwo1p/VgSMYTtH61nL/wejP2yj1x
         rZwlatCJ2Pfjyglzz2TNgmM01memM6+RxI4MBvQp0Rcgyojd92n8Y4tB6IxsL8yv9j
         0J1JvF4F4WLCr5JbYj6JStdJK+RWo9XFjDqIO/75CKAtBKu/xwORUE0WcCq1eUrTm/
         cqyyppkR86tVw==
Date:   Mon, 22 Mar 2021 21:11:47 +0000
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [RFC net-next 2/2] dt-bindings: ethernet-phy: define
 `unsupported-mac-connection-types` property
Message-ID: <20210322211147.56642804@thinkpad>
In-Reply-To: <20210322195605.GA1463@shell.armlinux.org.uk>
References: <20210322195001.28036-1-kabel@kernel.org>
        <20210322195001.28036-2-kabel@kernel.org>
        <20210322195605.GA1463@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Mar 2021 19:56:05 +0000
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Mon, Mar 22, 2021 at 08:49:59PM +0100, Marek Beh=C3=BAn wrote:
> > diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/=
Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > index 2766fe45bb98..4c5b8fabbec3 100644
> > --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > @@ -136,6 +136,20 @@ properties:
> >        used. The absence of this property indicates the muxers
> >        should be configured so that the external PHY is used.
> > =20
> > +  unsupported-mac-connection-types:
> > +    $ref: "ethernet-controller.yaml#/$defs/phy-connection-type-array"
> > +    description:
> > +      The PHY device may support different interface types for
> > +      connecting the Ethernet MAC device to the PHY device (i.e.
> > +      rgmii, sgmii, xaui, ...), but not all of these interface
> > +      types must necessarily be supported for a specific board
> > +      (either not all of them are wired, or there is a known bug
> > +      for a specific mode).
> > +      This property specifies a list of interface modes are not
> > +      supported on the board. =20
>=20
> I think this needs to be clearer. "This property specifies a list
> of interface modes supported by the PHY hardware but are not
> supported on the board."
>=20
> I would also suggest having a think about a PHY that supports some
> interface types that we don't have support in the kernel for, but
> which also are not part of the board. Should these be listed
> somehow as well? If not, how do we deal with the kernel later gaining
> support for those interface modes, potentially the PHY driver as well,
> and then having a load of boards not listing this?
>=20
> My feeling is that listing negative properties presents something of
> a problem, and we ought to stick with boards specifying what they
> support, rather than what they don't.

That is a good point. And if this alternative `supported-modes` property
is missing, we can just assume that all modes are supported, in order
to be backward compatible.
