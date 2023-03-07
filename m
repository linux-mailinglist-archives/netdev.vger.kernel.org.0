Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5205E6AF40F
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 20:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbjCGTMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 14:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbjCGTM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 14:12:26 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E0CACB8E;
        Tue,  7 Mar 2023 10:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1678215368; i=frank-w@public-files.de;
        bh=6PwA0h1qZLuhuoZ4NUTsAvcwTuRFj66q2WPa+dKxE10=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=VSYNgnuJD/bL8dEcbW+NdQ3PafH53Ibg13qE/F1SlHk5Fq9JWCyW3PQbDzr5CXNNP
         tVhwxVq4k/2B9Q8q0JWBHMMsE7dDn28xvQgLoLdcLoe7pZLmmnDMTxtsthh4nLdW01
         7gRrHIzHNXTgDD8fIelEq6A8QdLYNX3PlNq7H9/+IyMF1cBgadFPH8/pjd4CcR2DmG
         BVSSWjySiXpnwDHYUg6KwhGQrxxnFICsdl+0Ovm8RepMH/BggqdUjs+t2+3wzL2pTu
         eYrYzjjG0mTKmpRZvooWNkHejEPjxichhZ5Ngf9GeXct7MNqxJdsceuJOerPG0J71u
         sPUyDV2BQDFWQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.156.24] ([217.61.156.24]) by web-mail.gmx.net
 (3c-app-gmx-bs16.server.lan [172.19.170.68]) (via HTTP); Tue, 7 Mar 2023
 19:49:47 +0100
MIME-Version: 1.0
Message-ID: <trinity-ed437b5e-2949-4a45-9dff-73cbefc0835a-1678214986988@3c-app-gmx-bs16>
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
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Aw: [PATCH net-next v12 06/18] net: ethernet: mtk_eth_soc: reset
 PCS state
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 7 Mar 2023 19:49:47 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <0105ba8db974bca74846d605b18dcf948a7ab3d9.1678201958.git.daniel@makrotopia.org>
References: <cover.1678201958.git.daniel@makrotopia.org>
 <0105ba8db974bca74846d605b18dcf948a7ab3d9.1678201958.git.daniel@makrotopia.org>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:RhX0TPvkWegrZOa+oeIK8QoIIXSR4k63trcaLclg7gV0U5IdcSHf0rQnjgVgbghob/H7j
 DCqn+fl7K/mPiiFiHXa97DHM41d24dgRlzSoQPFWJYsgogNbfI561PFe6aemrwMn7lMPAQLKCRzQ
 hBBlXb1DOZGnKMOsoe7Z8WODgyyvV39+Pnc6TSII9f8MqVgepgrEaxKGRNAHs7948NvZNuIh0zON
 P3PJelnBLUNohQeCYLK3Cemvg7DWHPWXQUQZ+kOYwzZX+04aqDssu8nH03uLv/zKpm/kP+149mQn
 qw=
UI-OutboundReport: notjunk:1;M01:P0:bqOYuHtBtxM=;Dt0Cv4XN+FzRgoZJkapFC9WxsKW
 v9/9IZs1GBLpST0lQi/5PH75nBUqKNJubexG7OZHiWgK7EEGCn1o3vHFJF3yv+2PmY5wIBXJD
 ErAIOJdDu2FXnX4efjJ+rY13cCWznGgejk3AzkdYmMvv3m26JGxtXxYeeG4hYh81lzo9m0Cqi
 WTxsRA6JSQfo4accJmTmT/dBs0hbcXwbbXTShmbNQdBnLmgFRR3ZPUnNqClditagA7FobUepv
 tJ+w1F2uYbMXeSHM+jJxZ1mI9YnxEBlmYk03ciBALkgZ4z0VH1VjCGhjyLTuRQXvRYzo7SC5S
 KZtKBlhZ1kw1q3kwG4Fm8mUnuWBb3fRQEmjoP0EnL2W09A0WL+1OSpFUoZkAGJakmODYqZ1Lf
 MFO0pK4d1/0PYFiUUZMn9AGO/Mrj5ALnL75V9Y6ugtVmGCsZOZGAN51pULRrcdA4+ZEgmv5VR
 lTTfpNTI5yF0ghcamOY1gRq6bZuLkLA5CWNCBlBi1pzbaKS427burIx6ADFAaGbgMYI/SjysQ
 m1DTc36kZRP/IUyPp79hr6i8uiiIyNTDMfoGe5nsHMyheHz5JWiJsMaFB1TbC/dzVKzSqTePq
 CXG8NC4ypOsfoTrwQEVvWbCEL42vnJqxZ3QePJrf+/5BXemorlo4SFtiMsX83u15/e5qpCWLk
 vUD1IkVLPIUKirLYtLxD6enWtZbI7bbH6QtknXsppnizxJ2NVEy6HXz1Ajk+KTcqCwr366EAw
 UeeMSfu8deIzvMMO6LbdxCgINLSWjwi1VBzMkwWSi4GTQx53gg2qtJzYoG/JallCv3Pcb1/Ia
 U/jL5EW8cfUVjyNAkLy0frww==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Dienstag, 07=2E M=C3=A4rz 2023 um 16:53 Uhr
> Von: "Daniel Golle" <daniel@makrotopia=2Eorg>
>
> Reset the internal PCS state machine when changing interface mode=2E
> This prevents confusing the state machine when changing interface
> modes, e=2Eg=2E from SGMII to 2500Base-X or vice-versa=2E
>=20
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux=2Eorg=2Euk>
> Tested-by: Bj=C3=B8rn Mork <bjorn@mork=2Eno>
> Signed-off-by: Daniel Golle <daniel@makrotopia=2Eorg>

Hi,

have tested Parts 1-12 this on bananapi-r3 (mt7986) with 1G Fiber SFP (no =
2g5 available yet) on gmac1 and lan4 (mt7531 p5)

Tested-by: Frank Wunderlich <frank-w@public-files=2Ede>

Thx Daniel for working on SFP support :)

regards Frank
