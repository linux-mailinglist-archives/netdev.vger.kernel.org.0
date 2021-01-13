Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4127B2F4BCA
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbhAMMzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:55:51 -0500
Received: from mail.savoirfairelinux.com ([208.88.110.44]:39112 "EHLO
        mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727179AbhAMMzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 07:55:50 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 52CB19C0DD1;
        Wed, 13 Jan 2021 07:45:40 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id NpDf8A8lalEm; Wed, 13 Jan 2021 07:45:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id EBFBC9C0DCD;
        Wed, 13 Jan 2021 07:45:39 -0500 (EST)
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id AltUp2Rc3SPk; Wed, 13 Jan 2021 07:45:39 -0500 (EST)
Received: from gdo-desktop.home (pop.92-184-98-96.mobile.abo.orange.fr [92.184.98.96])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id EFEAD9C0DCC;
        Wed, 13 Jan 2021 07:45:37 -0500 (EST)
From:   Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
To:     netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net 3/6] net: dsa: ksz: insert tag on ks8795 ingress packets
Date:   Wed, 13 Jan 2021 13:45:19 +0100
Message-Id: <bc79946d1dafded91729ee1674c1b88a3beea110.1610540603.git.gilles.doffe@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1610540603.git.gilles.doffe@savoirfairelinux.com>
References: <cover.1610540603.git.gilles.doffe@savoirfairelinux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If 802.1q VLAN tag is removed from egress traffic, ingress
traffic should by logic be tagged.

Signed-off-by: Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
---
 drivers/net/dsa/microchip/ksz8795.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microc=
hip/ksz8795.c
index 4b060503b2e8..193f03ef9160 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -874,6 +874,7 @@ static void ksz8795_port_vlan_add(struct dsa_switch *=
ds, int port,
 	}
=20
 	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
+	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_INSERT_TAG, !untagged);
 }
=20
 static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
--=20
2.25.1

