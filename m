Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A56D68E943
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 08:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjBHHqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 02:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjBHHqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 02:46:53 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7913C652;
        Tue,  7 Feb 2023 23:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1675842373;
        bh=lJZsJu6FE/m8RkUXLIqO4+l2gX1b3XV9offgkGavorA=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Z1XqmXIrzpSMAkZ+Q0XE5W/aaZ0b3GDmOv9Uu1iprRwYmrXmGDDIA1nxIBDjyuzI3
         cdoIt1KRcWqN7baNK4TcI+yi7ZVr+Teprx2VIpIqXlpCYm34Dm3ZfxcIZePlDfRTdV
         Uj602Lf1KZsQpKmk2+jDr6+YSk9YQRlxeqOh6jiCIBJZSLpJi8cB0fEV+zaS+fxbNu
         DoGYCbY7bHbDPw2a5OGDNDARN+lqF+CysamJq1PyTQBcAofPV2fpdQPXOXcS1DZPYL
         Ft6tsaS789xJmM2kE1qv7Bsps/jp2oCXDIDKXuHCtO5vtc9hLjx4ML52OzYKPiDcAI
         FpAA/GVACFpRg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [157.180.227.18] ([157.180.227.18]) by web-mail.gmx.net
 (3c-app-gmx-bap61.server.lan [172.19.172.131]) (via HTTP); Wed, 8 Feb 2023
 08:46:13 +0100
MIME-Version: 1.0
Message-ID: <trinity-e1125c6e-9b6c-4e34-82fd-d99d34661cb6-1675842373343@3c-app-gmx-bap61>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     =?UTF-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>
Cc:     Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        erkin.bozoglu@xeront.com
Subject: Aw: Re: [PATCH net v3 4/5] net: ethernet: mtk_eth_soc: drop generic
 vlan rx offload, only use DSA untagging
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 8 Feb 2023 08:46:13 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <79506b27-d71a-c341-48fd-0e6d3a973f2e@arinc9.com>
References: <20221230073145.53386-1-nbd@nbd.name>
 <20221230073145.53386-4-nbd@nbd.name>
 <79506b27-d71a-c341-48fd-0e6d3a973f2e@arinc9.com>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:be3w77Hl6YYRLG2Pfygnosn9NFEWYnMi66wjxQ4iLMaU706Pu0SKotAM8rWVzb05/cgeb
 UjMHM1GFVDZ82M7mSaTRl8PWr2yByQuuDJvFP/rhSniukSrojFgxOG/DSCdxcOW8Q1qU3IpOE7MC
 ASw5EGGWNjhysiJsZNs34RM8wO2/8Vh7o/8kUNsdH0eAz0Eoa7/Edvtv4WRkmatEVRwZDPa2p45u
 JB1CYxMlOSgZlQZpEIAhakF5W4XFdKu/hr66QUq22PfeJ1M3LdZTZPV3NiaaFZYpBXqzKPQGpwpe
 Kg=
UI-OutboundReport: notjunk:1;M01:P0:yDiaRCpQi1g=;6amzwCNFap286wCSTAXysO5Rhpp
 O+UUFM2v/aTS8UCc0eVw8RHuIwGelQ76CmlCScX5w/kULvrbwzqdV6HfM8aX2HaLSJB8PVgOy
 V6QcEFHKSbhTK6PUxFDNTj34PNgNkS7I8acI40s2ppYdCpNWvQc1Em7rF2OBnpTtOSAo8VJPD
 ypNQeFMkP8JKKYBFnU3m8VIYq3dUzejVljBgnwcbe8NUgLZF1gzpYbtLUmIHgY2CwNmEGYGMF
 /1opsI8tiz5liYMHa8mvThM7yN3bVl/A4wqjQBUwYdZzk/BvAt/buJYqj2YjZdDiebTYaxLhF
 iWVrZLVzepCgUjz+eqcwta37aeMirJacjU/UogMkR5J/AqMXEY3HtCU3V8cL0uoGfGlUaiMYd
 kRAr+NyTfuxCuVUJjxxYHwGDXAvaMsR5BX1gqjTpdLly6zin+B0xxG6mnkoyp6/GZcdtn4UjN
 YALJ47I9/nf097nYqxAGQXiFPgnK+uLi167IyZ4YruTTNDuoaMdy+DfIvPrEsIUfJtxxCQYba
 i1oMbvEjg78akZJmkMOUnXPZY3B1jGZN3GzHyrlW68Z7yLqe1li3hb1CKh9L/28YhBA/w3RC2
 tR+J6IMcgssUzO94Ru2lehxVwaHBAkQdGzHqsJhEpjjOHQ9ZijgQxuuCcxs0RiSC4M3Tsf07I
 jFzDgHqgJ0lE0iFApc6YXXqsyeAewIAHT7B3UsqV3sJnZjhuel1Tqq4ZBcsIwyKrHeRvjc/YE
 Z1zw8RSUeEPuq9ZVqOllCtEeXRjZnf7zPJvfP5UmnRpfgLpStnlRux1bmpuav0Nhs4JFLBz0F
 d5PXOnVpwE0jW0gNT9iPTSqQ==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

just to confirm, my issues were not caused by this series, it was there before and now fixed with [1]

at least one issue arinc is mention is fixed with [2]

so please apply

regards Frank

[1] https://patchwork.kernel.org/project/linux-mediatek/patch/20230205140713.1609281-1-vladimir.oltean@nxp.com/
[2] https://patchwork.kernel.org/project/linux-mediatek/patch/20230207103027.1203344-1-vladimir.oltean@nxp.com/
