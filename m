Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDCF1FD632
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 22:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgFQUm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 16:42:56 -0400
Received: from mail-40134.protonmail.ch ([185.70.40.134]:11589 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgFQUm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 16:42:56 -0400
Date:   Wed, 17 Jun 2020 20:42:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1592426573; bh=JND/l7786kUSxBbLYRdesoUGCzeCMfI9KPapF/3Xlpc=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=dJZ7V534yULCAFDaMjso/tGN1Mu2yzIoGM5AJ4Jwsx2x4Xbb3Ov+wRxaYrCHItsg+
         NFAvdoGvqmpXjovGLS6aQHY5YmeNOTNndxvLfSb/d1qXNny29sBVYS1Lr7kY62jM4F
         SUZd0yKoGZ1t6suodCLBNViuHT7v7ys2C1iH1Zc99gvywXwXBqVVJAxowleqHyvM9Q
         gYRczrM6Fmx2LgDCbw8Z+2cHE4XI+Eu3mQi2RkU5ERfXmW7lLdNkTBe+Zpg+p6IX62
         xoMAEv3gD43N18HozALjoM15KsN7ArWl1HlhdqCrxvs/ReSdToy+fPC35ZPkb6BBuI
         Y02PCUsuMi1YQ==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Aya Levin <ayal@mellanox.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH resend net] net: ethtool: add missing NETIF_F_GSO_FRAGLIST feature string
Message-ID: <9oPfKdiVuoDf251VBJXgNs-Hv-HWPnIJk52x-SQc1frfg8QSf9z3rCL-CBSafkp9SO0CjNzU8QvUv9Abe4SvoUpejeob9OImDPbflzRC-0Y=@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 3b33583265ed ("net: Add fraglist GRO/GSO feature flags") missed
an entry for NETIF_F_GSO_FRAGLIST in netdev_features_strings array. As
a result, fraglist GSO feature is not shown in 'ethtool -k' output and
can't be toggled on/off.
The fix is trivial.

Fixes: 3b33583265ed ("net: Add fraglist GRO/GSO feature flags")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/ethtool/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 423e640e3876..47f63526818e 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -43,6 +43,7 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][=
ETH_GSTRING_LEN] =3D {
 =09[NETIF_F_GSO_SCTP_BIT] =3D=09 "tx-sctp-segmentation",
 =09[NETIF_F_GSO_ESP_BIT] =3D=09=09 "tx-esp-segmentation",
 =09[NETIF_F_GSO_UDP_L4_BIT] =3D=09 "tx-udp-segmentation",
+=09[NETIF_F_GSO_FRAGLIST_BIT] =3D=09 "tx-gso-list",
=20
 =09[NETIF_F_FCOE_CRC_BIT] =3D         "tx-checksum-fcoe-crc",
 =09[NETIF_F_SCTP_CRC_BIT] =3D        "tx-checksum-sctp",
--=20
2.27.0


