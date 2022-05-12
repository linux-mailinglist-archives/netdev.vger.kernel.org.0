Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB2252483A
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 10:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351673AbiELIsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 04:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237092AbiELIsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 04:48:02 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6B55C765;
        Thu, 12 May 2022 01:47:58 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 26C271C0007;
        Thu, 12 May 2022 08:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652345277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MHDErb2Vw0nQ2xCx9+Ah6ILpUdH4/NR5Ddf2E2382Fk=;
        b=MgoOXadftUHvAdzKcmjzxqnUpzRTOXOZIopJD6Geg9pOcekSVQUTONqiY5IcSUD4CFg1qm
        q7FuXxRVCzusjZcNjyZWQv71h1PqxKjOruR5u+ZIQK0mQQIOCuwSbhfn/OvfNm8cCEuUzH
        T4HokJF0eJcnWhH/uWo8HmszoK4/jtZMFJkYirP5prEGVcrVoCzCKiyMI00N8J+bx+7nb7
        2K8FJ49w1DXjN9o86DFrASXO1F+epwwN0VLw9LrVo9AezcVl0pAg9O+ex3zJ9OVkP4/qgx
        hkh8CReYrSRfiZTWzYHdYrDFDlsFK/+oRzygdCHXgfAJBwUFg+6MWoty0CAHAg==
Date:   Thu, 12 May 2022 10:47:53 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>,
        Phil Edworthy <phil.edworthy@renesas.com>
Subject: Re: [PATCH net-next v4 06/12] net: dsa: rzn1-a5psw: add Renesas
 RZ/N1 advanced 5 port switch driver
Message-ID: <20220512104753.075f2120@xps-bootlin>
In-Reply-To: <20220511093638.kc32n6ldtaqfwupi@skbuf>
References: <20220509131900.7840-1-clement.leger@bootlin.com>
        <20220509131900.7840-7-clement.leger@bootlin.com>
        <20220509160813.stfqb4c2houmfn2g@skbuf>
        <20220510103458.381aaee2@xps-bootlin>
        <20220511093638.kc32n6ldtaqfwupi@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Wed, 11 May 2022 12:36:38 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Tue, May 10, 2022 at 10:34:58AM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > > By the way, does this switch pass
> > > tools/testing/selftests/drivers/net/dsa/no_forwarding.sh? =20
> >=20
> > Unfortunately, the board I have only has 2 ports availables and
> > thus, I can only test one bridge or two separated ports at a
> > time... I *should* receive a 4 ports one in a near future but that
> > not yet sure. =20
>=20
> 2 switch ports or 2 ports in total? h1 and h2 can be non-switch ports
> (should work with USB-Ethernet adapters etc).

2 switchs ports only but I now have a board with 2 switch ports + 2
non-switch ports so I'll try that on that new board.

Cl=C3=A9ment


