Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEE66A295B
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 12:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjBYLpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 06:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjBYLpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 06:45:21 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61DA51B2F1
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 03:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1677325497; i=frank-w@public-files.de;
        bh=ZBwnWDFUpmNDuVjhJA93U/OavHRXBe8vwR9SfxpLdr0=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=I+JSRGGXRrCM6qFN29Jd6FmRzLhwxVQHxnU9KW3Z6YB/JqDPi42p1l8J+pMmtnuOd
         GtLT7hzQ4TR7KNSityesoVtppZrHRHx3BHx+WDY1grYCLB4DmYW74o/5KO5wMvUx/y
         dEsFMgAVmTSMFW3O+Peo5TEww6RESa2VVS6v4Lmro7tr1Rk31ILaTbBBZ/EuYdxqs1
         eGouobdZsAzouxVU4gEss4Bq7xosQ+k1wCFKKws2P8Qts+nqq6B1BG8QOkQ+J0+KPl
         idJ5B7c8BBcAdTCqiWDvfgZgKbbQ7wu1QKK4UHHe+5wayDFRuYOWOewAwSrftTfEff
         AHwIp3L6Mh2FQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.154.5] ([217.61.154.5]) by web-mail.gmx.net
 (3c-app-gmx-bap06.server.lan [172.19.172.76]) (via HTTP); Sat, 25 Feb 2023
 12:44:57 +0100
MIME-Version: 1.0
Message-ID: <trinity-6fce9a50-21ec-4abf-b4a1-a06556afe4ae-1677325497563@3c-app-gmx-bap06>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     =?UTF-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Aw: Re: Choose a default DSA CPU port
Content-Type: text/plain; charset=UTF-8
Date:   Sat, 25 Feb 2023 12:44:57 +0100
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K1:erSvvNh/twjyLBBj4fXvVv558LlBmkxpZKMNMwKv7mukqeRqZ3XfKDbqRiMjHxn3WW57X
 GP+yqyecmVm7C4J2+56BoycFbSLt4qAc3PJBX5PJUySiciRD11ftQHopWeLWaFxPB7lrBNzVY+jm
 UGOVljCEYXWkp+9iZRN+kMdEhO3qboZzav79ifVGw7HWHJo57T+Whw2hZpsbaWQE9JcjSAjoFzge
 CuMipKs3jGKDP2hLga6Q5fYy/lDNJRsmoKwITgVHAQmIvET01ZFg4A6rFjyqIzqOBxfK2i1PQ/0o
 nQ=
UI-OutboundReport: notjunk:1;M01:P0:qYO/A0aSyJs=;3Fh+r+XdhhgHp1xLN08f5iSLDwJ
 7mybMTJU7tlWKuMtp/3xv/J6ifT3OZLWNbtV4/WmOYEYFbiGENK/RQyMC53QtUKiMBU8X+HBp
 4jYIDLQb3XbjkoETmzdXLhP15XA2eL4BRZ2asFR7FecxRu5mK9L2lxEW0AQ4jE1GhHqFJjZGL
 0X7SkE6BQpMCmS2laI0rVWE+QHAeEa7jST+7qdHfC8HKNHqfB7Aa40eskdyzyBFgAmgDPNrv2
 i0qwjKPhECnJ/iY9yoU/ZZwM6fKs49w1ImhMuKeTDfqxa3dcnas5qUPTwNZ03jeMXiOkRTAWT
 92C4RQ7KJ+iVMtzp+FEE8CK/fvqn+0ZzHBL846bK7RYeu/tpbNEpJ1oM6nmvVIEjezQr9kHd1
 hsIyAgeRsjpmBkEv/CaKm39tpCMelPzWRpN0lNEsU+y9ULZfWbaoKQjHCVxd9tJWy14AMg6y2
 fpYkHPLsJEIkiqGshEYc1kh1dIxRSKavo0CdbrfB/OeLnyXyUj20rOxd/3fH73P5dLHV5VC4F
 0eKEQmHT/hz/9+7KiiASCUA0DEaxMqwxQKnR5TkU0yZxK64HTqoxL+GXWtXIxcSSD13Yxr1kA
 5tAg7IY4oV+1R9/wUiNUYKWoDADjK4dXq3i13BHF6w3VP76MQQUwr3CFT1asL/awFyYlpS5LH
 TEiiSxQ9SOavRfs6SlnIpHv7kgJXPwxzrxln2hkJ8WBOn+D0xcxcvTGqLOghYa6DijSrLYE1z
 Mvm0tH68z/O2MC4fVK3ESanB9cPsua4etlZq6OVIbiX9sNqx8uYeWx1SijDDgAAWxf8l1xQ1v
 8fMTNqsT44c+d4MYpX3XwEUWgYnWuegfGx0Gg0I8dFB5I=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fixed the broken network by applying this patch on top of the current position

1a3245fe0cf8 net: ethernet: mtk_eth_soc: fix DSA TX tag hwaccel for switch port 0

now ping works again but throughput is now 620Mbit/s

i try to continue the bisect (have to apply the change on each step i guess)
