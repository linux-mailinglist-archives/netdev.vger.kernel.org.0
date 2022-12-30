Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD346597DE
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 12:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234985AbiL3LsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 06:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235103AbiL3Lre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 06:47:34 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52ACD15F1E;
        Fri, 30 Dec 2022 03:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1672400818;
        bh=SCjTfzTmeWy9n8dw4GQW7kp4u3L3AAf/DvNOBU2t9cE=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=TCZgW7Jz2UMLmD1MvJS6LSHAcB66OPer/q7uju6GiGdk8LcQp9j0Jio99KmybXOdy
         BF0710uw0BeOWcY3uAyQLcOmGKkwkpYU00v9hcks1n60XP+uv5pkf9jel9PSSPU8Qh
         qQIjxbF5tF5GWQNjb6g6ntqTkO4kMWGU9ljbiMWwRh2H4bm57N7Yj6dQ/2dkLZRSN8
         V4ZR+PAvBsgF36rnm0LmIRt9QSsgKIKHfZf3+M1DvuIDHkusEjtMjw7t0W4rxs4DcC
         JQ5CX79VY4tyJJw00afd00hIgFyvCMRKXZJ3gDlla/kBO04aGRneE+ODbVgEDgPONL
         9vpDAyNGxB1Zg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.149.221] ([217.61.149.221]) by web-mail.gmx.net
 (3c-app-gmx-bap18.server.lan [172.19.172.88]) (via HTTP); Fri, 30 Dec 2022
 12:46:58 +0100
MIME-Version: 1.0
Message-ID: <trinity-a07d48f4-11cf-4a24-a797-03ad4b1150d9-1672400818371@3c-app-gmx-bap18>
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
Subject: Aw: [PATCH net v3 4/5] net: ethernet: mtk_eth_soc: drop generic
 vlan rx offload, only use DSA untagging
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 30 Dec 2022 12:46:58 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <20221230073145.53386-4-nbd@nbd.name>
References: <20221230073145.53386-1-nbd@nbd.name>
 <20221230073145.53386-4-nbd@nbd.name>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:pBNX6Fm1zCmCsuMmsd1KSJ5HZYIqM0xAkIkqg2IFo2qZR7S6v3CdQN4iioTk9cBQFBIM2
 NG2WoYifTmk82CZEkXlsSpNNdrr9dzS0svrYVuFUFFf4PUGZfgOH9K358SuF+TatXMpr7NGE51oO
 Sq+nuKq39CEgTBTLblkL2dn2pXy6MVVc6CCUqIuZnvJJ5OvyiQ+kux0+kPI3Ha/qh7Fvs6Rnygje
 WJAlu2zIuQE44I0N7WrPlr5nBXDghvR7abfXc8uTiQ/qKJi3RJrNPuf38w7x064KN7oTQ5V00uDI
 DY=
UI-OutboundReport: notjunk:1;M01:P0:s55aR2gjtdA=;MoY7pO6ZbycU6xxZxfaR/brva33
 7eL872kep8tdBUIoc4USr2MnC3XvpnKVTvuzumL8rmH175hu/mOA0s1Nc6ltGIzqyUdJhDi4P
 zRMyVSOiHDZ8YVFK6LC0NE0rqnrMCBh+Myu+ajV3K8UsqwntNMNXLAB7k5UGbUKQWHdJjoTrA
 /prcZJlwDyRnLrRs4pQU6UwVUNVf+jyrH/0Ix5LW7wsf/m+Pquyax7N3HfldP4H/SK8a95P8o
 xrImIyU7zozpM+uxBgkNK4BjlAgqy2TXMHFOfbkXccUF+UsiKGkS7Z3is9GFqv20Ytnytlpf7
 lkiGMJLU32H1GfLL2lV8/zaqngjXD4NMz3n1kDdNLfCZmNMntfAPYO9ZBKEYZyGIWe9W3wIvZ
 4VHVOi6rCDwvBWhekeBNg4uHkXAyo9FB1O/9W4wdlPIh70zOaJoHTrwsrJdeSnnXYRsmKUndU
 9a6F2xLcKaUIl/QPvR+b0QFBSiqvW0cVzO5n+MiIwbyLF9JyM4ejOFxBq4YYMq0hURjN3wMkG
 dOmoWqBaXTX7UwcHf10wlMUfyvqeK2hd9T0gDdKyJrGBH/Til3dteI41yyR2RnCTpPywo5PxF
 Z1+l0gnFXFRDeZCz/2009y4sVZFU8zQVVWibHHVOMdZzNzArhSfFLFGV1oogj2Nu0XR7sYVFU
 ekRhSSd6rIFCJqCPoj08FyLNyCq+4T2skuKjn55yjXGazLPnrmcLZKsPtLn5vnB5KlujQpTc/
 jP6tAcIQBIgF12oSKl1ukKKCulwghowd1BFI869uFLcFIE+e1rGjhIeEYWXtjXyXpUxqFi8Ot
 tQy7pZ+PZxtJSAC2WX7K9wyg==
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

v2 or v3 seems to break vlan on mt7986 over eth0 (mt7531 switch). v1 was working on next from end of November. But my rebased tree with v1 on 6.2-rc1 has same issue, so something after next 2711 was added which break vlan over mt7531.

Directly over eth1 it works (was not working before).

if i made no mistake there is still something wrong.

btw. mt7622/r64 can also use second gmac (over vlan aware bridge with aux-port of switch to wan-port) it is only not default in mainline. But maybe this should not be used as decision for dropping "dsa-tag" (wrongly vlan-tag).

regards Frank
