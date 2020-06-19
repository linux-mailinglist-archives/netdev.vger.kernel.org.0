Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEB0201ABA
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 20:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388199AbgFSSty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 14:49:54 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:16392 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726993AbgFSSty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 14:49:54 -0400
X-Greylist: delayed 4477 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Jun 2020 14:49:52 EDT
Date:   Fri, 19 Jun 2020 18:49:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1592592591; bh=xt9FcSDY9Nl6m6FCtdnFPbr4ruQnPLHweIaO3/bHk1k=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=HkhM+Nby1w/55hDva2vkgVpsPydhfO7hd/A5dktc9helG+5XziviKVkl/QXCuRIg6
         tCMLAeuAUD/EkLy25+bDdH1zrNUE5x7F7lqyeIEJnR79shG3VJjKMKFUm/cis7hKRe
         PhjO3KP3OuZ8vOMXveyTVPyDKvwujv7X+KkZtkmntw5s4u3KTQkuX/v7cQ68oEOIe6
         CnlOM/OJbG4Rp5oJBJ/WDxyPWx3Vt9N2hiqwMLEDLXSBzXTCeFkl4plPWV/6ekJL1E
         8LQsC2/lLqSqdmwT5T/tLYA9tQ7h2tu4C8FEhYS/3EOKBZjjzPJLZG2LYJrJbdRN8w
         PRLlaquhkYuVg==
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
Subject: [PATCH net 1/3] net: ethtool: add missing string for NETIF_F_GSO_TUNNEL_REMCSUM
Message-ID: <zFTHRjNWlu4eUUW2ctoeitCl16HlqxNz83PXnzZU-JKukUxUlXl_jpYe8H8tWNgKP1cTbxEogXn3YHD9rmYj3v5h8vLvaQFYePM56sQrrzw=@pm.me>
In-Reply-To: <x6AQUs_HEHFh9N-5HYIEIDvv9krP6Fg6OgEuqUBC6jHmWwaeXSkyLVi05uelpCPAZXlXKlJqbJk8ox3xkIs33KVna41w5es0wJlc-cQhb8g=@pm.me>
References: <x6AQUs_HEHFh9N-5HYIEIDvv9krP6Fg6OgEuqUBC6jHmWwaeXSkyLVi05uelpCPAZXlXKlJqbJk8ox3xkIs33KVna41w5es0wJlc-cQhb8g=@pm.me>
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

Fixes: e585f2363637 ("udp: Changes to udp_offload to support remote
checksum offload")
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


