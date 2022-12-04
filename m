Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4DAE641CEB
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 13:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiLDMgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 07:36:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiLDMgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 07:36:17 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8477014D17;
        Sun,  4 Dec 2022 04:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1670157335;
        bh=QKmgSryl+fWz7W3RkCUzclzCEhaa4WImtJO0zq+15Zw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Vwbzr/DWKYPnydhgSYw+CDy+dtOp8pTitcy0QkA0kQ+44cfktbPft7nNYT1bfaKUH
         ttyGGZno6+taom0zUiz1s4SEXnZoH2WMyOFJqSYPHULCfQPThLBqLGVUt91fXKVmbS
         vDOvDXFDv5qVEA/Wy7W97IpWT8stZ9qcZO47t0efffO/z+jvxurzrWEit3DLWKJ1GY
         S1Mt6SpNZIPwjlseQ4ImEeCiPNm2D50RBjI8mWNQLu9Gg1a8v0NndNChRWVK32rXu2
         WCev+WKAaCSr3K6aRpSFGBMXIQRx0lsSHjoovn40ZR40c3xVTydN4v1UYXtFwlmE0R
         vYK0/b9wqvFtA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.148.219] ([217.61.148.219]) by web-mail.gmx.net
 (3c-app-gmx-bap34.server.lan [172.19.172.104]) (via HTTP); Sun, 4 Dec 2022
 13:35:35 +0100
MIME-Version: 1.0
Message-ID: <trinity-4e4e0da1-db81-4a48-986c-a68328a84b45-1670157335627@3c-app-gmx-bap34>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
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
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Aw: [PATCH 5/5] net: ethernet: mtk_eth_soc: drop generic vlan rx
 offload, only use DSA untagging
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 4 Dec 2022 13:35:35 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <20221123095754.36821-5-nbd@nbd.name>
References: <20221123095754.36821-1-nbd@nbd.name>
 <20221123095754.36821-5-nbd@nbd.name>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:hPIsZNZBUMYLcObVTy2iqrd05dLeAn6ye5PtJjxYLRR03vcKJkhDpnXrmwaDGyofxU0c5
 o9cbE6jjXfIEgLuTQjJXXT7h7f7ccS0DZFngMbVKHIW35osKA7kcZYQiHPB/3GeoXnT4XEYPYmGX
 j1s6B1a2oERrbkSNTw/nMAq3UFNbKIuiiBsWHVwZ3YKWvcgnjOx+sN9dEAnh0blkx1B2Aa0LfCwf
 sWSI9AAMf4m5zMR8GnS15OxMuLjAnurt5nZqTQRgtp39TEQ2C2p/zImUkqMzyjrxTHvhKvgD3p9m
 mk=
UI-OutboundReport: notjunk:1;M01:P0:gQi/31dsW8M=;wsNvnjdfBkK61ftkq6/PG12X12G
 mjZYuCjTYuk/86SK+iGDbmcuCk/p/U1vP0+RXWAH0KPxPaikWw0S2sm/87K8AFIE06DF+Gf0d
 m5nmRUu+We//cJs+43AXTfMnNsClKZSfC7GRW9SUev2u6HXqtDsR5T8BRf0pJPD4MDvfxVuug
 2cr6JDMJ40/wGT4IW18lTuUV0Xtd9fWLMp4S5+GYuFDWff8sTPorHq6ZO+2sMZmKUHNDUgoM0
 dyglzt+EyCy7mc460SpIi/jQ/GZQXsyT34z+bS8uAzqqi9Pct1p1U0W5bxz3lyoibcNbjA5oj
 8saeHCBj+zyNHiVO4mCz8fmiUgFlL78D5BpvBgTP2bsrhj4acgy4LpRH9uauuT6Ew3MKjLiz4
 pBmjfonmwxWgGX2qgB4S4626wZo3cSblMg3aoSApQYN3lOOoFlOSXFKmkYk37ZitykRYrNxMH
 L5xc9tFK3j0vYon9dUJYalySUbMQpJSMvjh7YiB3cj/S0vZRTzy/Pry4ra/91ilNpby4P0k2I
 Uyq3M5SPe8kB106OH/qW+pBDZX6tBNu4tvKhKZkXk3VjEs2xEriLN06dhqN7Co+xFtjaILeGR
 mmyICQoHyFfOwo8c+1fFmfnj2QMUSG5meCiTlIQpcWSbJLZ156RJGBHaglrseqQ+1sxboC+Rt
 rCosEOZMcxom8cBdPMsL3XDrhLwx6WQ7m/Cnzqlkoo+81NGcTsM18ToGDJd9sNmAOkJY9uN8i
 nPiK9sV8pH6/2Xb0iHBkJgOpghgApqwpHL2+sNro7VAaI5jmFbJEkq25iy9RKW+nsOw6gHFq8
 uJiTwzWwEhIC9sUpbiUIObU2ZQ/PhUZTG+cZj1Ilrv9hQ=
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

tested this series on 6.1-next and it fixes my vlan-issues on gmac (Bananapi-R3 sfp-wan). maybe it can be
backported including depencies to 6.1 as this becomes the next lts?

this series on 6.1 is not enough to fix vlan-issue...so i miss anything there

but for next

Tested-By: Frank Wunderlich <frank-w@public-files.de>

regards Frank
