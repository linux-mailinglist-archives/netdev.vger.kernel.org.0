Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D186C0287
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 16:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbjCSPAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 11:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjCSPAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 11:00:16 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A921F5F3;
        Sun, 19 Mar 2023 08:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1679237974; i=frank-w@public-files.de;
        bh=FaY0Xl4jfnqhSvRMHOlCX3MBxMkltd1/bLTF73k4weg=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=m+78KDG7Mmcwc7gj18tQBa5KlnttrpkmTbH5ILg4BO57oA/iIFDrmKTGogVyvT0At
         3NXfJtLhYF08QYSW58FIVQilQLC6uEN860tc7QQ0HNONXFVUF/SU5ZnxudwUmctBlA
         1dzbg+GY1aUSTqPNFbWzy4nCgEu59+hILd8JJ0XcAdK/4jOyV7G9TweEKRFrFLXxk8
         L/0samKM+ZUHOs2piwAUOUFUlBDYV4xQjH9ZfmnZZFivYPEaukRvU5FKw8M+JUe0Qv
         gVafW+DOXWiz/Rx5SGvuCVKjBDBNqfIMfvXaWEz7URPR6lSwOg+M0zbRHvnSYMNyXG
         tV03zE+CicDgw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.158.68] ([217.61.158.68]) by web-mail.gmx.net
 (3c-app-gmx-bs27.server.lan [172.19.170.79]) (via HTTP); Sun, 19 Mar 2023
 15:59:34 +0100
MIME-Version: 1.0
Message-ID: <trinity-0a0531c9-44c0-4171-9d5b-3607df6175d4-1679237974351@3c-app-gmx-bs27>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Aw: [PATCH net-next v14 8/9] net: ethernet: mtk_eth_soc: switch to
 external PCS driver
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 19 Mar 2023 15:59:34 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <3979b99300067c595a4406dbb0dec3ca9ba14952.1679230025.git.daniel@makrotopia.org>
References: <cover.1679230025.git.daniel@makrotopia.org>
 <3979b99300067c595a4406dbb0dec3ca9ba14952.1679230025.git.daniel@makrotopia.org>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:sU97e+lgcCfTk1IjrHuZB3vZAMLNfgAeGL8Gt84Pf1cml7G8cpK40yiE5ipilxbyng1/N
 Mgsp56itmfUxpBaGUbCJhbnTtPcUEpk9qwGxhGvYfEwKlxip/NqrxQc8qNpqhFpQlvdIrehVd0Wl
 J+2YTMELPeGRjBw6j/y+/EuD1GnG3BdM7DIgqFDcQLytk38JmOVNp/TTM5wc7CsbCUyBE9IsI168
 TV0FSDv4Go74vG9Q/w6oZg9uiy568Sjd/3G2B/qvfBFS7xCBVsIXZu0Hvz9rvNrg+H1Ah1oN+jro
 sc=
UI-OutboundReport: notjunk:1;M01:P0:F+KgMaH38GA=;QHG/JQQ7xTXbN5KWA50Q7bm/nls
 UmA8y9ZKTD+xKs3Zgq8yKQgg1V7m7dYVxUulOqVHyfaJ6OUWHjMo8EEt4XsmwOTHW5Vf5EuJH
 0wDqQrruFU+U8m7q+RvWeS8uZy9kQc+gNIGaRGyrIG4VY7CyA+Juc6NKZ7vy3N2TKBlLcvG7k
 PDNUr1mPa0/MxCQ6GNtVeRzrmfnXf+ACOhgUaL789SROQlrGcnWtoBHY0iJ6JWxj9MlbGZlGX
 gccYchrjZSSzDCbyTjcmPX5IQ5Hj2tQEd+EO887fFh85jcsKzjQAcRCmVcZjKGS+xVrIXdgPA
 jc+bYaI+Hnpxz1LxAfp0JGQYIE9glaqWfZ/W0b5QY7+TNRACjEZ075+dbBQdw+clC5fQNanOC
 m1z8W6mRIVvYCPQSE7c0CxCsplJ6QcQi6pJCMevdZOXWvXW3Oo7tLqNUiRAZjQyw1edCFw5Yk
 BKXf4msGfffE1horaTG+mXrKgaijbtcGvg2g2vCpCPLeuyqpQoPSGsBUSYW1m55yReUTlksCe
 pjppl/Ww/EctJFjBwTlgwN0FEfG/FFhwvSCo0O5mu/NQHcU0+ahO9HyZVWqLQ+W/ahRpF+YDr
 BxJK3fCN9Fe9BIC66iJ8PQ8l9YQ9CMQSWuIkulftmgjaZFo0+8L48ITdC1zzTrH9COPsh/DFG
 SXnMlVHemBigLD1E1ROzpfMqlBc8m4Oq3S0QDF3fW0UMXMOgdL64Zvgn+3FaZ+VsP62WHB+/y
 HIcl4cVM7og24z9TuYNcLsQb0cIBg814K7nssCSl8+JlkzBbeQyYFj6uGm25/TrV3oFxK/Fnh
 V8VqpqRHPqFA4SpyPda4wFBA==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

as Patches are the same as v13

Tested-By: Frank Wunderlich <frank-w@public-files.de>

regards Frank
