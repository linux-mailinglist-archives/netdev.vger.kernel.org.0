Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC87204F6C
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 12:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732233AbgFWKn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 06:43:56 -0400
Received: from mail-40136.protonmail.ch ([185.70.40.136]:55548 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732189AbgFWKn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 06:43:56 -0400
Date:   Tue, 23 Jun 2020 10:43:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1592909033; bh=LxhQtbSeiWbbxxDfDbRt6BCldu7riEbst4uIy5bgtvo=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=ASLJ3jgXPTW7SmAkk5DGVSQF06v5Jfbn/94tmeiVBG79evb2cbehX7P43it5BQXny
         UeU17AYKJ2xvLGrUIOuMd9Pm9Tq6BOW0r5CbVNcT+K0k3abCSUJeXiPuRJsYGBZz+c
         F3mCYMXDC+eZ96ipEA2MCbRLKwu89IjAV3L393JrLLKq8MhIb+8wu6T6XAHNpds6Ot
         WTWi44Pb6sWcoY409ybfHvrkaN8ReJn3ORpFbUqDMs/ZpyPHo/7dS9IhOeJNPDAw5K
         BfLHVxLldqLf/ZHsyYyQfqIWX2WugQaHz8Ge+gI6ye0Ho1e8RNCFMnuoJ9T7qopvLM
         oPqLzljrjcK1Q==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@mellanox.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Aya Levin <ayal@mellanox.com>,
        Tom Herbert <therbert@google.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v3 net] net: ethtool: add missing string for NETIF_F_GSO_TUNNEL_REMCSUM
Message-ID: <C_D5pdWhThP15fmS3ndY6GxGStCPm5YVuBeR2FoVIEv4_kEoTSW-8gQ7W04kSxy0WCoIAvtjyeF_PERcT6IGj8KAmOn3EY7jrXVxVC0Wqhs=@pm.me>
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

Commit e585f2363637 ("udp: Changes to udp_offload to support remote
checksum offload") added new GSO type and a corresponding netdev
feature, but missed Ethtool's 'netdev_features_strings' table.
Give it a name so it will be exposed to userspace and become available
for manual configuration.

v3:
 - decouple from "netdev_features_strings[] cleanup" series;
 - no functional changes.

v2:
 - don't split the "Fixes:" tag across lines;
 - no functional changes.

Fixes: e585f2363637 ("udp: Changes to udp_offload to support remote checksu=
m offload")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/ethtool/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 47f63526818e..aaecfc916a4d 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -40,6 +40,7 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][=
ETH_GSTRING_LEN] =3D {
 =09[NETIF_F_GSO_UDP_TUNNEL_BIT] =3D=09 "tx-udp_tnl-segmentation",
 =09[NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT] =3D "tx-udp_tnl-csum-segmentation",
 =09[NETIF_F_GSO_PARTIAL_BIT] =3D=09 "tx-gso-partial",
+=09[NETIF_F_GSO_TUNNEL_REMCSUM_BIT] =3D "tx-tunnel-remcsum-segmentation",
 =09[NETIF_F_GSO_SCTP_BIT] =3D=09 "tx-sctp-segmentation",
 =09[NETIF_F_GSO_ESP_BIT] =3D=09=09 "tx-esp-segmentation",
 =09[NETIF_F_GSO_UDP_L4_BIT] =3D=09 "tx-udp-segmentation",
--=20
2.27.0


