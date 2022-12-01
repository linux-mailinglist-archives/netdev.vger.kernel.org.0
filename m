Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD07763EE1C
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 11:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbiLAKmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 05:42:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiLAKmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 05:42:17 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3222F9F4AC;
        Thu,  1 Dec 2022 02:42:16 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NNCLc4QCXz4xFy;
        Thu,  1 Dec 2022 21:42:00 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1669891334;
        bh=4hif7EODqPU9RIQoNSM7f4kViT96m8PqRMy1FOSRqmw=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=XMDViV6CFDY+O8nTTE8IlEWWvY7H8YPqwD0Tn3KS84kUAblouGGNC2+Nia8sW2MYv
         qiQITUGJnoNf2rF8FqcIgIFTtKJlyIpcKBWiNrEakO5NLQ+ickTPEjtr01+GlyanLx
         mzZ9YX/t1jp5UON6rpZmvdKzHLeuceJXW2c99G//FjEB6EQyCPN8TlRw5ClPGntYn1
         1lstUDxUIwXt5rogz0qwgKe9XH3/+5CPLNT6DZ3ksaq4/yXNeIe6xOWsdnc3/9h44G
         yfuCxdwdv4chZHzuDDmEcJxiTEJT36pr3DPrHlRrFjnXSjff4fqmP4a9zPs8OfNA43
         pIMyXosyZ93DA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        soc@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?utf-8?Q?Rafa?= =?utf-8?Q?=C5=82_Mi=C5=82ecki?= 
        <zajec5@gmail.com>, Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Stefan Agner <stefan@agner.ch>,
        Heiko Stuebner <heiko@sntech.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Tim Harvey <tharvey@gateworks.com>,
        Peng Fan <peng.fan@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Frank Wunderlich <frank-w@public-files.de>,
        Michael Riesch <michael.riesch@wolfvision.net>,
        Oleksij Rempel <linux@rempel-privat.de>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-sunxi@lists.linux.dev, linux-rockchip@lists.infradead.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 0/5] remove label = "cpu" from DSA dt-binding
In-Reply-To: <32638470-b074-3b14-bfb2-10b49307b9e3@arinc9.com>
References: <20221130141040.32447-1-arinc.unal@arinc9.com>
 <Y4d9B7VSHvqJn0iS@lunn.ch>
 <32638470-b074-3b14-bfb2-10b49307b9e3@arinc9.com>
Date:   Thu, 01 Dec 2022 21:42:00 +1100
Message-ID: <877czbs8w7.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com> writes:
> On 30.11.2022 18:55, Andrew Lunn wrote:
>> On Wed, Nov 30, 2022 at 05:10:35PM +0300, Ar=C4=B1n=C3=A7 =C3=9CNAL wrot=
e:
>>> Hello folks,
>>>
>>> With this patch series, we're completely getting rid of 'label =3D "cpu=
";'
>>> which is not used by the DSA dt-binding at all.
>>>
>>> Information for taking the patches for maintainers:
>>> Patch 1: netdev maintainers (based off netdev/net-next.git main)
>>> Patch 2-3: SoC maintainers (based off soc/soc.git soc/dt)
>>> Patch 4: MIPS maintainers (based off mips/linux.git mips-next)
>>> Patch 5: PowerPC maintainers (based off powerpc/linux.git next-test)
>>=20
>> Hi Ar=C4=B1n=C3=A7
>>=20
>> So your plan is that each architecture maintainer merges one patch?
>
> Initially, I sent this series to soc@kernel.org to take it all but Rob=20
> said it must be this way instead.
>
>>=20
>> That is fine, but it is good to be explicit, otherwise patches will
>> fall through the cracks because nobody picks them up. I generally use
>> To: to indicate who i expect to merge a patch, and everybody else in
>> the Cc:
>
> Thanks for this, I'll follow suit if I don't see any activity for a few=20
> weeks.

IMHO the best solution if the patches are truly independent is to send
them independantly to each maintainer. That way there's no confusion
about whether someone else will take the series.

It's also simpler for maintainers to apply a single standalone patch vs
pick a single patch from a larger series.

cheers
