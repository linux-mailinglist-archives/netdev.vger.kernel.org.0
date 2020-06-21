Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729772029E4
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 11:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbgFUJ4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 05:56:49 -0400
Received: from mail2.protonmail.ch ([185.70.40.22]:63556 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729573AbgFUJ4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 05:56:48 -0400
Date:   Sun, 21 Jun 2020 09:56:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1592733407; bh=MDwLDc1JoR9QRgmmBefl/3rYHq3pLxsGdgTUQ1vf5S8=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=KkoxG0sNgBOw4fFiATyanWWZZcuee8CGTyEb+go31NvUDln3WjesTfeV4XrI4MsyI
         F9ciAokBepwrgtxRwssrOsQg94CydPqGeEAQjYdHASSUwS8XzvX3rZ75jbUOV0vQbf
         eAYNK8IuipbOWeSk7u+h/Xfdv13D85027CyaF3bJGpCE2Lae6X8LScoNphoy72GfTD
         u85rkFDcnWGbUGTjHJXBJ32qfbUFFozKubN6FCfVuXSNCvDpVBTBIGR41ipUrzKD1E
         z/prrP3wD1ZpJMr22ZT1g+05ZE9dQIrox1jqjhvtYz36k32xKIwi3H/O2qmLi2hq5m
         SHde3IZEQFt2w==
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
Subject: [PATCH v2 net 1/3] net: ethtool: add missing string for NETIF_F_GSO_TUNNEL_REMCSUM
Message-ID: <ie96EMBWosqn2rSY71TZPFyuZoHHp_4r6ka8sT98tS0yKUuQp9r-lcBPxTfPm_Q2PS9eonqh04Kwu1S6bryuZOKS8ksodJ1QRbNY9rKXEZA=@pm.me>
In-Reply-To: <HPTrw9hrtm3e5151oH8oQfbr0HWTlzQ1n68bZn1hfd6yag38Tem57b4eTH-bhlaJgBxyhZb9U-qFFOafJoQqxcY-VX5fh5ZktTrnWhYeNB0=@pm.me>
References: <HPTrw9hrtm3e5151oH8oQfbr0HWTlzQ1n68bZn1hfd6yag38Tem57b4eTH-bhlaJgBxyhZb9U-qFFOafJoQqxcY-VX5fh5ZktTrnWhYeNB0=@pm.me>
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


