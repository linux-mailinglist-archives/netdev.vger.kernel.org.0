Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92BF4675A5D
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 17:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbjATQp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 11:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbjATQp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 11:45:58 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15ACCDF5;
        Fri, 20 Jan 2023 08:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1674233135;
        bh=WfMSZdfQolErM+0e74L1yzl/TbFZTw+0cNrSZbCgakI=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=jxTkn1GRepZtIEabmd4RzwesxAcjiHeIVo4Q41qluyT3g57qIPCglzNVwKupHWXCi
         bpA3Pid6c0tY+YV6Kcb/r/Hfan3wzed/fiGNI+0AB9VHJxksbce6YSmtS5828MurS7
         ynFGxAkZR3IFAbgNMfy/644AFt6a6UcyQmNvwE4iqpCMAyixO2KK0ppYcKhf3NSqQG
         MtrNP/OsVAjhHOZte2srB8Fy6tZXk+B3P7vLmDbHOuNWpvt6fEeFuQ6fwCllggF7j1
         TIUROZsTmY+3o4xpIa6JVFqutvoY694mfnnmw4vRHj2d0lU6EKVj0DejX+guc5AoUm
         TlmdryubkRO7Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [80.245.73.105] ([80.245.73.105]) by web-mail.gmx.net
 (3c-app-gmx-bs36.server.lan [172.19.170.88]) (via HTTP); Fri, 20 Jan 2023
 17:45:35 +0100
MIME-Version: 1.0
Message-ID: <trinity-e6294d28-636c-4c40-bb8b-b523521b00be-1674233135062@3c-app-gmx-bs36>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>
Subject: [BUG] vlan-aware bridge breaks vlan on another port on same gmac
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 20 Jan 2023 17:45:35 +0100
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K1:aRp7yu1CPG/xMwTFGHW9JtvW//jraNeSPpULCcV9wEWX11dYSN+2nQtyS62xemvvcZKs7
 Ltnlt/Bx2I1yjrCku+iXUM7+5emUzAyzIcGY3i/KGAGr4+K1jFZM+JvjqEBbxfGq5whv0WNKfbcd
 zrgXYurrhliZnAgGqgQZPSWD50utKUGNZh4ZSuLIA3Ko3pZU3HfJCQQ696Z2AkzcqNWy00Lu1NrV
 QHziUw4sd1C7xDZCKWKj2Wg1CYg6WQQURzMwqKdQj3TgMtC/whiHRfdvOWZkSGn9vizofEgwudAe
 wU=
UI-OutboundReport: notjunk:1;M01:P0:elitiHtASuA=;RYl8TBFPL2V9K4GG9HUXCrQDwRK
 TyZuqLysx1U0E+4dIN5Rw/3f0lP7q7jYD8UlOio+o60PMlhra8oFoiQbKRukXf+H4F8d5Joj/
 Hxg1nx1iUAMKlg6fMLojj2inXW9AFL6Smtd2jCN+SzdH1AxnCTPA39aEX1lnIVX2IGdgbiqkF
 HJeCbJMK839bafjYm9xH7a6RxaRBQTGtbfaHsBGMEWL+AfVVmiu/2r27b3Mh/aQzERWikFlgd
 Bb23BN3lpwE0Os6PYioeTuZHnSwX9uHQg/oi/XA2oK4acoH/seM8bmTdcUsHdpAw4yn3RbVyb
 RJP+Nx41qqs/D58HupVvbzYJQm+nzyoyDAmqmD3H8NXqrTHBCaoW9+vklNJ0Kgj2flOQ1k1P4
 5oe7ZalwT2g8ygWKnuHXtbbZj7nz+WhGc/A9zOKCJ4yFlHpoPlB0woylpxhTfAVyMPq5DU3rY
 B5WA9HMvUyhxlXNNiewt6JZZ/o9qbzOpzEzpv6Vz9oVghtZ0oYmfllTrnfhsMkUGXDlGqwHWC
 c3SavlxdaTVUzONSCCHq1+dO7kV5nK1V9zd6Q7ZWu5X3YXXVihxasTidqM4GYNgQu2H4ru0kq
 JPAOwuyEZNDj0AC9R3KGs3176wSzF5lafhizNTO1lRPR35RxKAAVL9+2lecb+OSfNqw9UI/No
 j432P/Al+8JqdADh7uVhxjoPlz6glVRNKJFD3ppNpVap5pOQunIrZoc9EEivCpWO+TuuYXmA5
 FImrjqrquCNjYJYH7DBPrpQDcxpDB5nZDRCsCprLGnJnfKe3PQCEP1DGsoj84NPngXfjE3WiD
 haUo5QoAHkD2OxoWwg+nWgLA==
Content-Transfer-Encoding: quoted-printable
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

noticed a bug while testing systemd, but it is reproducable with iproute2

tested on bananapi-r2 with kernel 5.15.80 and bananapi-r3 with kernel 6.2-=
rc1,
both use mt7530 dsa driver but different configs (mt7530 vs. mt7531).
have no other devices to test.

first create vlan on wan-port (wan and lan0 are dsa-user-ports on same gma=
c)

netif=3Dwan
ip link set $netif up
ip link add link $netif name vlan110 type vlan id 110
ip link set vlan110 up
ip addr add 192.168.110.1/24 dev vlan110

vlan works now, other side pingable, vlan-tagged packets visible in tcpdum=
p on both sides

now create the vlan-sware bridge (without vlan_filtering it works in my te=
st)

BRIDGE=3Dlanbr0
ip link add name ${BRIDGE} type bridge vlan_filtering 1 vlan_default_pvid =
1
ip link set ${BRIDGE} up
ip link set lan0 master ${BRIDGE}
ip link set lan0 up

takes some time before it is applied and ping got lost

packets are received by other end but without vlan-tag

regards Frank

