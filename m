Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4125B3EFF70
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 10:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238939AbhHRIqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 04:46:22 -0400
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:51009 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229474AbhHRIqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 04:46:20 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id C56B62B00B95;
        Wed, 18 Aug 2021 04:45:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 18 Aug 2021 04:45:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=gVF8x9/os7Hq80f5jXn4NGfCz4z
        I9Ggl0mz751t0VxY=; b=HMVFEgsFZb0/aAsUkFKNAYZ2aGpyUAvFqTjlgXRSssM
        PfyVJVq2zKqPjbZXG1+vhMi34Psu0Ob31N/p0hc69+KmIQ8p79Llao1EXlR+QTAB
        Q6QK4J4EYgoaPbCTSOmKH2lt0XN4yGbShulofooITBH1WWG9CODQN8qbFNvjGn2P
        U0h4WTi+VRhNPLwMN0v3mnWGnGt0KLAbzQl8xWsF6/YE2uTpl4ijH0ByhMzGEd20
        PM8uJ8vgycJE2Gs1GhCS2kfBGxR3Yzh1W53x2VIVJAzcnXXjCjo2kSPDcH0i7Pvc
        kCISgu2o5jWUr9bXwOdS6wlseyHryV0b1EXvmcBywZg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=gVF8x9
        /os7Hq80f5jXn4NGfCz4zI9Ggl0mz751t0VxY=; b=Z9cXy/ZYbei0ZKf8W0hqzf
        91LbYgxbs/TinjVIo7HKFfYdRs4aoTUnFKaebSJXAppdlUR3DYAPUGnACdiWkTxV
        LNlmLh07rr4SblqOSjforLbxMe43/lEAFwIUcJQW1+K+MBtU1uU8cVz09YrKghIK
        7jdhux7Xi0tJecHSM70w3MY5iPYsWG+eDjW6njxwIrUveagMqI52xV8CgljrfLsI
        lTrwdVvA3hHWy94Z5oR3FShuQ31RbVMQcE4eMsJrE1UUK9bw3JSlUwgtwnOc+Cuw
        Iu0jdIgvZdsMpY6quIEYIeZJV2ABm+cL1qqzva7JyWroWPgFqR1zVlzdX9mdwyNg
        ==
X-ME-Sender: <xms:tsgcYWq-CO3B-5R0JP82K3vxmNqxfnGhcADWF1jev60HwCb6maPP6Q>
    <xme:tsgcYUpreoVRzdcBk8Viykq84CDU-Jg2IzopUs6nEFrPfpC6poIkjJe8oJq8AnKMy
    5139BAH3W9UOgQB8zg>
X-ME-Received: <xmr:tsgcYbOCHN3UHDimLlsNrwVOzraPmfqdPu9FenKnzmvkUd3YPhzLlCoFR3nza8Keh5XeKOQGF-mhc-8jzv89gxDMwWFPoioTsTlb>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleehgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesghdtreertddtvdenucfhrhhomhepofgrgihimhgv
    ucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrghtth
    gvrhhnpeelkeeghefhuddtleejgfeljeffheffgfeijefhgfeufefhtdevteegheeiheeg
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrg
    igihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:tsgcYV7kd765tzB4qEfvDR2COzE_7yZ-uTV3TH-V8vMxxM2cWBa0Vg>
    <xmx:tsgcYV50JBellncZaf7aE9M_BlypVGNI_aidSOMOiH_l2RQiBCrWKQ>
    <xmx:tsgcYVicoOaeXzVMoBaUcmJ8Cxb-d1t69W8KybhLNMkDop1qP5eV5Q>
    <xmx:uMgcYRh1duafOHGA--YDvrBi9OTkP5fGUwd3Av1rI06jmJV-nttl96_xZIE>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Aug 2021 04:45:42 -0400 (EDT)
Date:   Wed, 18 Aug 2021 10:45:39 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        "David S. Miller" <davem@davemloft.net>,
        de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 27/54] dt-bindings: net: wireless: Convert ESP ESP8089
 binding to a schema
Message-ID: <20210818084539.kw267o4dc5nqk2qt@gilmour>
References: <20210721140424.725744-28-maxime@cerno.tech>
 <20210806084709.0C279C4338A@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4hpn24w3x2mvdec6"
Content-Disposition: inline
In-Reply-To: <20210806084709.0C279C4338A@smtp.codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4hpn24w3x2mvdec6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

On Fri, Aug 06, 2021 at 08:47:09AM +0000, Kalle Valo wrote:
> Maxime Ripard <maxime@cerno.tech> wrote:
>=20
> > The ESP8089 Wireless Chip is supported by Linux (through an out-of-tree
> > driver) thanks to its device tree binding.
> >=20
> > Now that we have the DT validation in place, let's convert the device
> > tree bindings for that driver over to a YAML schema.
> >=20
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: de Goede <hdegoede@redhat.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Maxime Ripard <maxime@cerno.tech>
> > Reviewed-by: Rob Herring <robh@kernel.org>
>=20
> We support out-of-tree drivers in DT?

Yeah, as long as the binding is stable we can merge it. This controller
is one of these examples, but we supported multiple GPU that way too.

> Via which tree is this supposed to go? I guess not via
> wireless-drivers-next as this is an out-of-tree driver.

It's up to you I guess. It was already part of the dt-bindings wireless
directory, so either your tree or the DT maintainers if you'd prefer not
to.

Maxime

--4hpn24w3x2mvdec6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCYRzIswAKCRDj7w1vZxhR
xeimAP9lnyCRsmUlFyHaAGKuDn/+dex3GP0IDQ3vJG4AV1E8gwEA4YPJVG80H85C
fzFKnYkQugjE0pe/nvOnLDggi2q4/gY=
=v1V8
-----END PGP SIGNATURE-----

--4hpn24w3x2mvdec6--
