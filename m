Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF70D6D38CA
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 17:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjDBPjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 11:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjDBPjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 11:39:37 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1E45263;
        Sun,  2 Apr 2023 08:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1680449955; i=frank-w@public-files.de;
        bh=nQ/RpSBX5xYz/pvjTCzkDUPAT2jbDpPKgB5SdpTNr7o=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=fkRTelFmWBwVP+grHr9Ij5cGIKpvsi9vN+tSJ/XTTQzhS6epGhtmEymuICIswSqm2
         jQVPllagua9X5W+FCJPpm85IXTxkCleSpW1EHYWCbnDG1giWjDU5agGTQwHYRQD7Yr
         Y4TNyX5//v2VfSuE2i77yyxAKs1YrdfLeaSjb0wiotmlHUb4xaBlI7Cg8kEvBsRfz9
         c7W6pFIWM5x+w9fIJN4Q9tvPyPhtuAKqItFDfP0kmOnZpcu4xvSpD8lI80noeHiTYd
         MnYxjlALUnk1JEGTavurjy0FTwdmeW6y0fkR19iUNar9HCCJqOPgtaMImEcyKwia2d
         h1DU+yoUE3hHg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.149.201] ([217.61.149.201]) by web-mail.gmx.net
 (3c-app-gmx-bap07.server.lan [172.19.172.77]) (via HTTP); Sun, 2 Apr 2023
 17:39:14 +0200
MIME-Version: 1.0
Message-ID: <trinity-6b061b48-4cf9-4868-a2ad-21f01b1e36a4-1680449954840@3c-app-gmx-bap07>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, chowtom <chowtom@gmail.com>
Subject: Aw: [PATCH] net: sfp: add qurik enabling 2500Base-x for HG
 MXPD-483II
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 2 Apr 2023 17:39:14 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <5e9a87a3f4c1ccc30625c8092b057f0fbd8a9947.1680435823.git.daniel@makrotopia.org>
References: <5e9a87a3f4c1ccc30625c8092b057f0fbd8a9947.1680435823.git.daniel@makrotopia.org>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:hYYqje1aQDZX7Kb1vo6sKUz4Ni0JOp2a33b9G2oNCgpR4MLu1FqbdW0HJqBxqEVkkDz+Z
 8ZT4siNus5vOjIHFUhycNA022MXUsqou0DZPftMsnNxA5/4iDk89Ubxi12KC9Xc9Dhoal9ZxL6Os
 IjtR6ayhhpFtLAf6RK9FYHXVd/HMIPawO/iGMql9cIicIbbwuod/BZSfQKRhg7jqHKF1y2CSMTyh
 SHWtuZqTGGyB3Ao1Nepzdc9GZC4GCuCOPqZA8PIwtgCq+yaUhhzkkHAR5P846+192q1fqBGAMJud
 as=
UI-OutboundReport: notjunk:1;M01:P0:CEyg9GUmQSM=;VXHG0XBHjqUl5Pg34DeVVhmxKVo
 K97fDl2nJd21R7uOQMjld9cYcKxGBs5U9ooj/ou7AicTJeVqIh2YbHAEnv98w0zTbhNP93vPQ
 Fd2PU445XDbqOZuRjmaRgmWyd37pSS6Us7ArQR6k0DDJqf9Sgzmu2UFHX8x+2i51x9HrUuC9P
 sEphhMHNyDCFXnHR2rQWU6Yy8ChcnXsywM/XrQSzeXNfGZJ3LQ1O+HbakJ6jqzP7Wd3SuR5tS
 qJNAmVxxAwo8/AbDuBMtR4L9ry1ADumIdnuzA40LUH4gj4CXkJ9p64ucrAA19yJwIQndxSDnp
 N/kNAhDUPnyYj4S/y0pne5Wqs9BT8SjQFwRgELuE+xR8s4fjwVpVE4BjoiJlV9q3E0sCS0AVo
 z9V/mirMhz1K4rTPTg7a135b1VjMwxd3Kj4jXNv7KNUFhT70M5NTJbH0UvokKejqe8IkdtFvO
 G8XnsJKpDZ0jefv3hO3jz63eqE8AV7qOkytz1jvNAdMV/b/GGVmY7xel/jmseUVPTTpzu3Xzr
 UYsQ65516XtvpjgXHe6UtPtrDlZFHaYKMJcVmTqJ/KTk1vOFFw5vmT/euWbrG6jsn3jEOGZCc
 OROT4Dw2zMVsHs/3bljDAn8kKKEeLieMvAq/H69vc3iM8IhLklq5dWN2vzsVxThMGIwft4yRV
 Ougwmlg9e9IHdCZ/UwWxcVn7gG1Y9MjRd2v+BlOiZ0kiqrz4Pf1ppMTtUoSr4nA/7ZXaiYMnE
 eAxjpghyARCJrVAXUju1aAAtXy9kCz1E1NgQrv5oGfBEjFNwMJ3Xzmz+2np5rNFTq/jeEQrXT
 7OwQOg+KRQBDCKM3gXot7uYw==
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Sonntag, 02. April 2023 um 13:44 Uhr
> Von: "Daniel Golle" <daniel@makrotopia.org>
> Betreff: [PATCH] net: sfp: add qurik enabling 2500Base-x for HG MXPD-483II

just noted a small typo...s/qurik/quirk/

regards Frank
