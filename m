Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732BA53E0EA
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 08:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiFFF1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 01:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiFFF1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 01:27:15 -0400
Received: from condef-04.nifty.com (condef-04.nifty.com [202.248.20.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE7110F35E;
        Sun,  5 Jun 2022 22:05:24 -0700 (PDT)
Received: from conuserg-10.nifty.com ([10.126.8.73])by condef-04.nifty.com with ESMTP id 2564uDGo012764;
        Mon, 6 Jun 2022 13:56:33 +0900
Received: from grover.sesame (133-32-177-133.west.xps.vectant.ne.jp [133.32.177.133]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id 2564rxU8026256;
        Mon, 6 Jun 2022 13:54:00 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com 2564rxU8026256
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1654491241;
        bh=9wnl63tAeNHwFnP9ncmY25Nut3frLpWSI46zwtOP0Gg=;
        h=From:To:Cc:Subject:Date:From;
        b=kYYPHvlD0X+P6H+J2qC9NTxd5enM1Nom4JAHumhi1Qj0lLzEl9ifpikstjYm6qFuh
         D0mOZ8VvKfjngpaYanARXXRGAVIUb0kp/SzICcGQZxHM8AN/QdmHwUWGlld9wcEsCH
         nvLtGOr5Pb+kn74/O44lzE6s77jscca4tFZbCui8oAbg4+EQB7LdhKUN9oTuQvK/Z4
         1SXTjlHojbJT7x2/SnTka9WWTJx8V+x8XEE8EhFxmJjILC3/oPS5pEyRKSdIx+hQ/c
         fYZ4nhvCeqHkYWJe7FhAtNGTbyHrpagQUdDvArNQtieuAW5ElcETuGJrfjpmDSHvnq
         DqMeJu2Dln0ZQ==
X-Nifty-SrcIP: [133.32.177.133]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, David Ahern <dsahern@kernel.org>,
        David Lebrun <david.lebrun@uclouvain.be>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Russell King <linux@armlinux.org.uk>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] net: unexport some symbols that are annotated __init
Date:   Mon,  6 Jun 2022 13:53:52 +0900
Message-Id: <20220606045355.4160711-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This patch set fixes odd combinations
of EXPORT_SYMBOL and __init.

Checking this in modpost is a good thing and I really wanted to do it,
but Linus Torvalds imposes a very strict rule, "No new warning".

I'd like the maintainer to kindly pick this up and send a fixes pull request.

Unless I eliminate all the sites of warnings beforehand,
Linus refuses to re-enable the modpost check.   [1]

[1]: https://lore.kernel.org/linux-kbuild/CAK7LNATmd0bigp7HQ4fTzHw5ugZMkSb3UXG7L4fxpGbqkRKESA@mail.gmail.com/T/#m5e50cc2da17491ba210c72b5efdbc0ce76e0217f



Masahiro Yamada (3):
  net: mdio: unexport __init-annotated mdio_bus_init()
  net: xfrm: unexport __init-annotated xfrm4_protocol_init()
  net: ipv6: unexport __init-annotated seg6_hmac_init()

 drivers/net/phy/mdio_bus.c | 1 -
 net/ipv4/xfrm4_protocol.c  | 1 -
 net/ipv6/seg6_hmac.c       | 1 -
 3 files changed, 3 deletions(-)

-- 
2.32.0

