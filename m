Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632F56B5DAB
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 17:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjCKQLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 11:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjCKQLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 11:11:12 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A83513D4C;
        Sat, 11 Mar 2023 08:11:11 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id g3so7702245wri.6;
        Sat, 11 Mar 2023 08:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678551070;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wTwVrHUwJuxo2nAv8WcWBTbXbikVuPU2S0IixEuBaf4=;
        b=NjrXETXbZlcsvTNNCs9yzV/6PY+CmmQAxqPMkiNPO7QnMj6ytAX2MO60sgp2paNr9c
         Hj4btjqwVQYF5lLso0uID3MzUxTkZWfLMIEk6fajBsPgnH07UIpVWC04WKT6L+qzzwUq
         2eXh/JXic2jrLs7bRYweE2xFP9A4hvZVloIFsATIbYE4tZvjdNUE217s5/7sS8Ayn3zb
         4y5cNUEUaXO/9Dhavli5sH+hB6hWTXJUzqrvs4t9pQSV8bj/6cuUmzVIvHIr6ii3bG3z
         GHvtgjEuloh0lGRfs2aBA6ScgOF2GeGe5cr4k2ApsqReCT35clKNcoVw3C+8ofih80pf
         cBug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678551070;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wTwVrHUwJuxo2nAv8WcWBTbXbikVuPU2S0IixEuBaf4=;
        b=LoyHxUGa/vDeJQ46VutuvsB7ouuYFr7F0/vmrRoku0KCD6CDXeGkB3y+Q1CXBVLJGG
         iuq+qwBtehVvT2FM4Hv6hYOb/5D+R9FCD0RyDwMjhWGLRa29yBAITK91Pd/iu3YqKlAi
         oD58N5hTG/YNOxcXSvt8oCLZu0RFKV5fNNF3z4QZUpmplJclb8E43qCFhdEo18YdEpeu
         FlUr4E8VgIGVb20WqPvPUEO9q6tyIRAIKhu1VB7tnduBYYNDT8nNNMvuujGRfoey//q9
         0ABhVSzBsLH3bciYpVlD4VqF73wNquHOkA9dZuIHlllnWNUPgp2wP0PihLQFKVoXpbl1
         PNvQ==
X-Gm-Message-State: AO0yUKXnEgBYegmBPm2enK4nobH+uYJD/wzXrEnMhmwM04QOEFONOy6y
        Sh5ZhEvqxVmIwQnZ0AHLwr0=
X-Google-Smtp-Source: AK7set9VyJg+v0ZGE7y65i5aFyOLU9IOZOR0GJb9hHZKpkI2ykj3H4fHVqW+NtUo6nKqBhqI6frrGw==
X-Received: by 2002:adf:e302:0:b0:2c7:851:c0bf with SMTP id b2-20020adfe302000000b002c70851c0bfmr19781176wrj.0.1678551069607;
        Sat, 11 Mar 2023 08:11:09 -0800 (PST)
Received: from ?IPv6:2a02:168:6806:0:cb1:a328:ee29:2bd6? ([2a02:168:6806:0:cb1:a328:ee29:2bd6])
        by smtp.gmail.com with ESMTPSA id b18-20020a05600010d200b002cea8f07813sm346294wrx.81.2023.03.11.08.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 08:11:09 -0800 (PST)
Message-ID: <2f64385a350359c5755eb4d2479e2efef7a96216.camel@gmail.com>
Subject: Re: [PATCH net-next v2 4/6] net: mdio: scan bus based on bus
 capabilities for C22 and C45
From:   Klaus Kudielka <klaus.kudielka@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-aspeed@lists.ozlabs.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Date:   Sat, 11 Mar 2023 17:11:08 +0100
In-Reply-To: <a57a216d-ff5a-46e6-9780-e53772dcefc8@lunn.ch>
References: <100c439a-2a4d-4cb2-96f2-5bf273e2121a@lunn.ch>
         <712bc92ca6d576f33f63f1e9c2edf0030b10d3ae.camel@gmail.com>
         <db6b8a09-b680-4baa-8963-d355ad29eb09@lunn.ch>
         <0e10aa8492eadb587949d8744b56fccaabbd183b.camel@gmail.com>
         <72530e86-9ba9-4a01-9cd2-68835ecae7a0@lunn.ch>
         <09d65e1ee0679e1e74b4f3a5a4c55bd48332f043.camel@gmail.com>
         <70f5bca0-322c-4bae-b880-742e56365abe@lunn.ch>
         <10da10caea22a8f5da8f1779df3e13b948e8a363.camel@gmail.com>
         <4abd56aa-5b9f-4e16-b0ca-11989bb8c764@lunn.ch>
         <bff0e542b8c04980e9e3af1d3e6bf739c87eb514.camel@gmail.com>
         <a57a216d-ff5a-46e6-9780-e53772dcefc8@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2023-03-11 at 16:39 +0100, Andrew Lunn wrote:
>=20
> I have one more idea which can speed things up. The scanning of the
> MDIO bus works in two different ways depending on if there is a DT
> node, describing what should be found on the bus. For mv88e6xxx, using
> DT is optional. Some boards do, some don't.
>=20
> If there is a DT node, only the addresses listed in DT are scanned.

Here's the definition of the switch in the Turris Omnia device tree.

	/* Switch MV88E6176 at address 0x10 */
	switch@10 {
		pinctrl-names =3D "default";
		pinctrl-0 =3D <&swint_pins>;
		compatible =3D "marvell,mv88e6085";
		#address-cells =3D <1>;
		#size-cells =3D <0>;

		dsa,member =3D <0 0>;
		reg =3D <0x10>;

		interrupt-parent =3D <&gpio1>;
		interrupts =3D <13 IRQ_TYPE_LEVEL_LOW>;

		ports {
			#address-cells =3D <1>;
			#size-cells =3D <0>;

			ports@0 {
				reg =3D <0>;
				label =3D "lan0";
			};

			ports@1 {
				reg =3D <1>;
				label =3D "lan1";
			};

			ports@2 {
				reg =3D <2>;
				label =3D "lan2";
			};

			ports@3 {
				reg =3D <3>;
				label =3D "lan3";
			};

			ports@4 {
				reg =3D <4>;
				label =3D "lan4";
			};

			ports@5 {
				reg =3D <5>;
				label =3D "cpu";
				ethernet =3D <&eth1>;
				phy-mode =3D "rgmii-id";

				fixed-link {
					speed =3D <1000>;
					full-duplex;
				};
			};

			ports@6 {
				reg =3D <6>;
				label =3D "cpu";
				ethernet =3D <&eth0>;
				phy-mode =3D "rgmii-id";

				fixed-link {
					speed =3D <1000>;
					full-duplex;
				};
			};
		};

>=20
> If there is no DT node, by default, all 32 addresses on the bus are
> scanned. However, DSA makes another assumption. There is a one to one
> mapping between port number and PHY address on the MDIO bus. Port 0
> uses MDIO address 0. Port 7 uses MDIO address 7 etc. If you have an 8
> port switch, there is no point scanning addresses 8 to 31, they will
> never be used.
>=20
> The mdio bus structure has a member phy_mask. This is a bitmap. If bit
> N is set, address N is not scanned. So i suggest you extend
> mv88e6xxx_mdio_register() to set phy_mask based on
> mv88e6xxx_num_ports(chip).
>=20

What you are proposing here would not show any improvement on the
Omnia, as only the 6 ports would be scanned - right?=20

> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Andrew

