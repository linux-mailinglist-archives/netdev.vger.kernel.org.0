Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9AD52E6C7
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 09:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346748AbiETH73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 03:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346738AbiETH71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 03:59:27 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD8615D325;
        Fri, 20 May 2022 00:59:24 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id F1E85100017;
        Fri, 20 May 2022 07:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1653033563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jUrOb7gzDfqcjgGGnV3qddsGrV2m84KgsE5E1hxmOQo=;
        b=GGtq16fx0ICa1YTJHlP+y+ItSHWaMLcKTJ4U3FvZ2cV/IiKmp1XgxBlQuZyCeQh5he0fZj
        cgwSCI8AYLvrICnV8Jd1LCsycV7nycaX2t1cD0j2q6IBy4i7QhZmcIwWy/PKLzmR0K+gOE
        6u5SnJAPG9RcK3P6pnYWJlkhmlEX8NJfUQPgvGvH04Xt32g5krPn13Yzzfl+McDVYXaRhE
        5n6wPT8KxAHmO4pBJLnjhrXGo29jxxtgodgWrcZ51rEaCCzG55iqTTtbm1grCyeOLnZs1j
        WpNAIQrvcH/Iqli0EnQ9zTbfNCOEGAlclT1iKTsUxdYHMaGxWZQfneluY/YOcA==
Date:   Fri, 20 May 2022 09:58:10 +0200
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
Subject: Re: [PATCH net-next v5 07/13] net: dsa: rzn1-a5psw: add Renesas
 RZ/N1 advanced 5 port switch driver
Message-ID: <20220520095810.0b0c29ef@fixe.home>
In-Reply-To: <20220519180851.chpqhou7ykt45oty@skbuf>
References: <20220519153107.696864-1-clement.leger@bootlin.com>
        <20220519153107.696864-8-clement.leger@bootlin.com>
        <20220519180851.chpqhou7ykt45oty@skbuf>
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

Le Thu, 19 May 2022 21:08:51 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> I think when you exit the for_each_available_child_of_node() loop you
> need to manually call of_node_put(port).

Yes you are right on that point. I'll fix that.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
