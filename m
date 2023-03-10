Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20A296B3D44
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 12:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjCJLJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 06:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCJLJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 06:09:24 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A65DF1476;
        Fri, 10 Mar 2023 03:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1678446518; i=frank-w@public-files.de;
        bh=p4Ry1+Uz7XRykXg/u62aElBzE539gslTt4tQPn8JGKY=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=kybU4HAuBHObpWV3Gov/u71hhW7EtHvQATKuyLgWYHUoxqf8uzAq68kXlUmADPbxC
         CRjbfQYg0p/D3whBrgw205MJ6E2hTDgMdv/o5MKMCv+rCk5xsya3sNBhxXXg7KfBwh
         c8/lz6XQ2D/qFIm23aspA5cikz8hvX5puFydVtZ8ca/lYukLqAvQyAOgmG03IBY1mq
         qrUelreYRHTrQk9gzPGADoA3L15ZPBYBKkbKprIQAQZS823B/RnKAymgQi/KWhzWZ3
         HCkeEh1uOa3+nKVDGjyPv9bTSHxe9Sou0GqQI9pNeqSCJDV1GkKwS+C+8Al+qkhm6/
         jMA6IPRT/f5Pg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [157.180.224.176] ([157.180.224.176]) by web-mail.gmx.net
 (3c-app-gmx-bs21.server.lan [172.19.170.73]) (via HTTP); Fri, 10 Mar 2023
 12:08:38 +0100
MIME-Version: 1.0
Message-ID: <trinity-875b4841-0e54-4370-8021-6b0534e421b4-1678446518590@3c-app-gmx-bs21>
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
Subject: Aw: [PATCH net-next v13 11/16] net: dsa: mt7530: use external PCS
 driver
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 10 Mar 2023 12:08:38 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <2ac2ee40d3b0e705461b50613fda6a7edfdbc4b3.1678357225.git.daniel@makrotopia.org>
References: <cover.1678357225.git.daniel@makrotopia.org>
 <2ac2ee40d3b0e705461b50613fda6a7edfdbc4b3.1678357225.git.daniel@makrotopia.org>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:jMnlX6H99gmtYbWVz0id357SLJcq0FXh9uVeicjq6deWbmX30NoSTwmz82nRxxdjnnF4f
 MW1izpHVkdf5lHo+yYMzyKlIiPp1emhL6OrVn9glZRlwvWbEj9MAuzbtWssEO1mrctpJ9tSDGW3W
 bqsZnxaJSr4Py9J0/ri2vCyUH//VxnA0ugoNhGujT2kvNu+7+vbsJL4D/55bvVZHV1kLmpT9jIOq
 PTpKW8IUiVCHAQS+kWY1VYj28WsSo3QYYkASSQuH8y3J/1nmxUfWD8V3bMUrckB4HyvgnDbtW/Yy
 yA=
UI-OutboundReport: notjunk:1;M01:P0:7F1ySXjLVBA=;YIrriYjuMhKxZYMF4yrIBczPUSn
 uMNfbPiv0EdwiGyehnU3vXLRoC7IT0Pq4B0aNCDnGcLlwiy6+P3ylsZQ/CsnjZbYgh3fLKuKA
 VCWz5B6+8ene+gapEn1yqa3tsisEga/7xucLMliSpou5MgJ5Sy2JVGHm4Bum+X49afkNZpxYE
 SRsVkANXohT/FCbdsZMmP4ZB/iRCAaQ3EXft6BNla8M9JDncWtvqgdtaoW30M+oHsvtHLB6Kr
 ITTmeqrLrV7vkvxH4SgayNK+bANAGKNNmuTUgWqaz57pL9KZsFqqnRD0C+EraOVxF2fpZH9cL
 rkkPYXsOHrENZv+jYsUPObXJNBLFli/kVqHCOy2ZrWNK4Kgn5uozsM8e7BdP+mgv0NPhcS5ii
 cg0cg81PeopsI4pPkmdMY0KPtTZc6ZN+mjPXQz1jHYuEwikDK7k+mHAjvipFBTUwWiHu09KuJ
 RjILdl3BbOQWbRpeJfOxFDiL6weeT3grafP9DVnS4Qpt9x5Uk2jjMXssq4ur27F2lZ4/IBt1C
 ZP5csVBY3oguluvDRQAGn1KGRRumVuVbG4Zw8NTTILT0FUEK7evYx4cZxBKTMT0yw0NH77Wo3
 hp/c0j5EZtYmlyKgp88ixBscNDD8nbZaN8R/E3yeIdeA3xfHCGQvyXyavg2Olig269XP4V7Nq
 Nj/dAJ2SBILZJslQall58Z0/TmpZq86oCoPXdbmImJvpfTS7wPElnfM4erVi5PcWtFx/pKcQK
 IOh5576kMSAgVE6J3u71Rfali4RrEkT7J38uWg52RdxpBp1pKM9Qgba5zq9JEy40SUEhkPm2D
 F/m07UonWPFv2oo/BOvlw0kKtBavJpU0oLitu7A0gvEhg=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

have tested Parts 1-11 this on BananaPi-R3 (mt7986) with 1000Base-X Fibre SFP (no 2g5 available yet) on gmac1 and lan4 (mt7531 p5)

Tested-by: Frank Wunderlich <frank-w@public-files.de>

Thx Daniel for working on SFP support :)

regards Frank
