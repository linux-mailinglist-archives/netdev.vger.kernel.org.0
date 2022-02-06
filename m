Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204284AB115
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 18:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345285AbiBFRyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 12:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbiBFRyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 12:54:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D86C06173B;
        Sun,  6 Feb 2022 09:54:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A74C9611F0;
        Sun,  6 Feb 2022 17:54:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B57C340E9;
        Sun,  6 Feb 2022 17:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644170059;
        bh=ZgaaGrymrJfoXt8JUPDmsicwkZeVuhH1bTY9PINlWGM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CwoZzWfre3xS6bYEeuSlgihY9EssoXepaxlG2CPrCXxQOazcqPbmhfpHz/eKyQCVZ
         0KGU4ACZLaFycbkMW4JDKtQ/jM5v+/7aXnuNMiHWdXT0jlWHvGcArGVz7bajQe+OkE
         hfIoWQfJ0benPdtTPav/M66vr62Lh7SAS0V3V4J9ImlZu7FWRVDjXqi5m7P6Lh1xaO
         asq40fb8A1mmNq00bhoMGR0/cF8zLRVz19xiAsxyxqQl3puXuFsfPoASzOPHFEr2/g
         IevfAEzivBGDbIuZQnMxawRwWaL3fKzJnLTJrFV0neH9gmIAbCpiLa503d5d/QsnLn
         Tputwj+ZsuADg==
Date:   Sun, 6 Feb 2022 18:54:13 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-phy@lists.infradead.org, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH devicetree v3] dt-bindings: phy: Add `tx-p2p-microvolt`
 property binding
Message-ID: <20220206185413.4c1ac00d@thinkpad>
In-Reply-To: <Yf3egEVYyyXUkklM@robh.at.kernel.org>
References: <20220119131117.30245-1-kabel@kernel.org>
        <74566284-ff3f-8e69-5b7d-d8ede75b78ad@gmail.com>
        <Yf3egEVYyyXUkklM@robh.at.kernel.org>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Feb 2022 20:18:40 -0600
Rob Herring <robh@kernel.org> wrote:

> On Fri, Jan 21, 2022 at 11:18:09AM -0800, Florian Fainelli wrote:
> > On 1/19/22 5:11 AM, Marek Beh=C3=BAn wrote: =20
> > > Common PHYs and network PCSes often have the possibility to specify
> > > peak-to-peak voltage on the differential pair - the default voltage
> > > sometimes needs to be changed for a particular board.
> > >=20
> > > Add properties `tx-p2p-microvolt` and `tx-p2p-microvolt-names` for th=
is
> > > purpose. The second property is needed to specify the mode for the
> > > corresponding voltage in the `tx-p2p-microvolt` property, if the volt=
age
> > > is to be used only for speficic mode. More voltage-mode pairs can be
> > > specified.
> > >=20
> > > Example usage with only one voltage (it will be used for all supported
> > > PHY modes, the `tx-p2p-microvolt-names` property is not needed in this
> > > case):
> > >=20
> > >   tx-p2p-microvolt =3D <915000>;
> > >=20
> > > Example usage with voltages for multiple modes:
> > >=20
> > >   tx-p2p-microvolt =3D <915000>, <1100000>, <1200000>;
> > >   tx-p2p-microvolt-names =3D "2500base-x", "usb", "pcie";
> > >=20
> > > Add these properties into a separate file phy/transmit-amplitude.yaml,
> > > which should be referenced by any binding that uses it. =20
> >=20
> > p2p commonly means peer to peer which incidentally could be confusing,
> > can you spell out the property entire:
> >=20
> > tx-peaktopeak-microvolt or:
> >=20
> > tx-pk2pk-microvolt for a more compact name maybe? =20
>=20
> Peer to peer makes little sense in terms of a voltage. I think this is=20
> fine as-is.

Cool. Should this get merged via devicetree, or via phy maintainers?
Or should I resend this together with patches that make use of this
property? (In that case can you add your Ack?)

Thanks.

Marek
