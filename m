Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C544B2156AC
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 13:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbgGFLrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 07:47:14 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:50705 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728845AbgGFLrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 07:47:14 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 846375803CA;
        Mon,  6 Jul 2020 07:47:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 06 Jul 2020 07:47:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=2
        j5XHM8eiIAtdQDxQdQP6yCaAAsGGZ2pUNXQED85J7g=; b=Zzs66ifjtoAR5TI2a
        tCf7OIEx92ai/QD7cSp0uedZvsK8UTWbCHjYxNr/z36PyKgM1pctOeTGulfGFUsM
        91YgsL7gY0B+On1Rgpc3N+37WpUA6Qb8BZUOCgde0ik0vXiD7kWot0VeEyQ0vknZ
        wQBIsBuOdBAif9XmzN+JNVaAqe00F+P7q4hBI5BUYwzUfKiKUmBSjKiOGxW3lUEz
        ArJVteF2X1ifaUbcLS198iDYVvlED8Oln13Ku5h4Qtn8XOJQk/C4LO/YgVIKvqcu
        bzaxpi7yaFW8NeekoC3vDhgfrd7MlHOuzVLNUE2RctGUgxNcSuDlXO8chLU3JQ0E
        vgW7A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=2j5XHM8eiIAtdQDxQdQP6yCaAAsGGZ2pUNXQED85J
        7g=; b=SZ4cYbHKTKhaqeOfZUDYAWuZ6oY6YVQapo04+2pcJsRnP/k+si0WCkSSC
        HIj1iQeGPdwFH9+0YSSTJ866051WiSWrrCOYau/UQowMy9hk7Ivm+QrVOA59ewiS
        /xVZDtxhEX1ZwROmgJdrxcKOpT0KfHzwk9O3TTzKyHLDy/jUfgobWRXj6V6VFRc5
        q1Gh3gUpyi5uj2fdNDrHX2Xp0Xn4Xz+QsPwZXn73Mb4i0NqOvrG0oWHGyMveFOse
        8sozd7xbl1AZOF5IzHshSB64dyGcMSWO335MduOHKlkKtYk3KzC+PqlnzQTwO5om
        Mt1Qfwv5SA9rbrIceM76Zo+c7I1CQ==
X-ME-Sender: <xms:Pg8DX8ACshx8OXih7Tsx8To0gB270QzKuS2_NCU1p5fEf9o2R97m9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefgdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtqhertddttddvnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhepgfejtedtjefggfffvdetuedthedtheegheeuteekfeeghfdtteejkeeludeg
    vddunecukfhppeeltddrkeelrdeikedrjeeinecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepmhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:Pg8DX-jHOXcfJ2sJoTl9jBNLiEym-N_hLdoBzSvpOVY4gudaPo0mBw>
    <xmx:Pg8DX_nldB4L1GipaM69hGsaqzA7AiKazJRLfHQR_rBGczPC-Ys6Zg>
    <xmx:Pg8DXywN0zJgmX6ntjFlltpOrwOipOZDa6Em-HoTVms3kpbDSPYJIQ>
    <xmx:QA8DX-_QtSLuvFTsL3EvWkyB-2jqWDHQRXEhzvRph5PhJiuKwZ_yKA>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id 774E830653ED;
        Mon,  6 Jul 2020 07:47:10 -0400 (EDT)
Date:   Mon, 6 Jul 2020 13:47:09 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Vasily Khoruzhick <anarsoul@gmail.com>
Cc:     Rob Herring <robh+dt@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Ondrej Jirman <megous@megous.com>
Subject: Re: [PATCH 3/3] arm64: allwinner: a64: enable Bluetooth On Pinebook
Message-ID: <20200706114709.l6poszepqsmg5p5r@gilmour.lan>
References: <20200705195110.405139-1-anarsoul@gmail.com>
 <20200705195110.405139-4-anarsoul@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200705195110.405139-4-anarsoul@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Jul 05, 2020 at 12:51:10PM -0700, Vasily Khoruzhick wrote:
> Pinebook has an RTL8723CS WiFi + BT chip, BT is connected to UART1
> and uses PL5 as device wake GPIO, PL6 as host wake GPIO the I2C
> controlling signals are connected to R_I2C bus.
>=20
> Enable it in the device tree.
>=20
> Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> ---
>  .../arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>=20
> diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts b/arch=
/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
> index 64b1c54f87c0..e63ff271be4e 100644
> --- a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
> +++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
> @@ -408,6 +408,18 @@ &uart0 {
>  	status =3D "okay";
>  };
> =20
> +&uart1 {
> +	pinctrl-names =3D "default";
> +	pinctrl-0 =3D <&uart1_pins>, <&uart1_rts_cts_pins>;
> +	status =3D "okay";

You probably need uart-has-rtscts here

> +
> +	bluetooth {
> +		compatible =3D "realtek,rtl8723cs-bt";
> +		device-wake-gpios =3D <&r_pio 0 5 GPIO_ACTIVE_LOW>; /* PL5 */
> +		host-wake-gpios =3D <&r_pio 0 6 GPIO_ACTIVE_HIGH>; /* PL6 */
> +	};

And max-speed I guess?

Maxime
>
