Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7DBE1D1995
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 17:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731154AbgEMPhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 11:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729483AbgEMPhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 11:37:25 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193AFC061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 08:37:25 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q24so11149895pjd.1
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 08:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=teVaLV/rr2slg0+EE8xbo9pK+8YB5TTaKHnzrY09DfE=;
        b=QBgky68X2CAvUfLAoG58SWnKsRC6xFLSBnKtqe1hQLrtMoYLr4TR8Dj7nfwQEO4UAB
         h4vnfEjCbPq5cNiKe58Y5Vj4DVYTYobOf4YerhAuiXRV8OHS0SeYIO38I7KNjoD2spoR
         CZLYX1sLHl56OZCZ9xwedg74wjnZBLrAFip3kR2s01LXCChHTy3RY+tkgPniFxYxb9Me
         e4aXpOwAdb3M+5llZ6eO94xQqR5pcNM5ATxeS44b9DlyW3pQUhdUv6F3HRakiCgX/zi2
         XOrDTj04XaWqC/UWsqGSwceT3NIa9XozmZgXenLPiaviRh5tNiQ2YaosBPkhoPyXAwri
         r4Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=teVaLV/rr2slg0+EE8xbo9pK+8YB5TTaKHnzrY09DfE=;
        b=UQv+xt2xT6JAssL+YjFLuklqok6d7pvsusMpRTPEnq7sAjd+XXf9A/ttT9BQ9RMaLR
         YJHa/eRMD8i0vLL1JVr02CCal/jg0gvLDD+6j4JPRCIcKbgwnsKy8pZQzLdoweQcHl4s
         D2Zv7tSvTAxB8F5uJ4H9/V5D2ymD8UsjV1uBImgzo6kWWrQDdlGgVGTnTMiuGjAZ2zkL
         o5qBrk35yU82UWCohpGSB1pQ6IpqcREFeaVxJxpKts+c+ZVZ6MjgyHvQBaz9S7wC4O+6
         D5EIZOr00fTXHQMi2qOhAT1a/4vXiz8D8YGx0k15ig8lqdIeED2MO87I63ob90ggmYAC
         R8qQ==
X-Gm-Message-State: AGi0PubV3GzlkH23R1FqfxmgHFeYe1E2Z81NR3+3xSPRuVeOSLf0rHk2
        aUZz6ssNS38ZW223D2lHDJuwnkRKXFRvNDPY
X-Google-Smtp-Source: APiQypJ3HbUlQmpqmlmjUyLbRSwbSw0eGc0fMQFI2WHl7yRl0sxIRbSlR+4TVJ01O9zuQXKYZCgzBQ==
X-Received: by 2002:a17:90a:cb8c:: with SMTP id a12mr35397540pju.153.1589384244328;
        Wed, 13 May 2020 08:37:24 -0700 (PDT)
Received: from P65xSA.lan ([2402:f000:1:1501::3b2a:1e89])
        by smtp.gmail.com with ESMTPSA id bj6sm11254816pjb.47.2020.05.13.08.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 08:37:23 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-mediatek@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Tom James <tj17@me.com>,
        Stijn Segers <foss@volatilesystems.org>,
        riddlariddla@hotmail.com, Szabolcs Hubai <szab.hu@gmail.com>,
        Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH net-next] net: dsa: mt7530: set CPU port to fallback mode
Date:   Wed, 13 May 2020 23:37:17 +0800
Message-Id: <20200513153717.15599-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, setting a bridge's self PVID to other value and deleting
the default VID 1 renders untagged ports of that VLAN unable to talk to
the CPU port:

	bridge vlan add dev br0 vid 2 pvid untagged self
	bridge vlan del dev br0 vid 1 self
	bridge vlan add dev sw0p0 vid 2 pvid untagged
	bridge vlan del dev sw0p0 vid 1
	# br0 cannot send untagged frames out of sw0p0 anymore

That is because the CPU port is set to security mode and its PVID is
still 1, and untagged frames are dropped due to VLAN member violation.

Set the CPU port to fallback mode so untagged frames can pass through.

Fixes: 83163f7dca56 ("net: dsa: mediatek: add VLAN support for MT7530")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 11 ++++++++---
 drivers/net/dsa/mt7530.h |  6 ++++++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 5c444cd722bd..a063d914c23f 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -810,10 +810,15 @@ mt7530_port_set_vlan_aware(struct dsa_switch *ds, int port)
 		   PCR_MATRIX_MASK, PCR_MATRIX(MT7530_ALL_MEMBERS));
 
 	/* Trapped into security mode allows packet forwarding through VLAN
-	 * table lookup.
+	 * table lookup. CPU port is set to fallback mode to let untagged
+	 * frames pass through.
 	 */
-	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
-		   MT7530_PORT_SECURITY_MODE);
+	if (dsa_is_cpu_port(ds, port))
+		mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
+			   MT7530_PORT_FALLBACK_MODE);
+	else
+		mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
+			   MT7530_PORT_SECURITY_MODE);
 
 	/* Set the port as a user port which is to be able to recognize VID
 	 * from incoming packets before fetching entry within the VLAN table.
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 979bb6374678..d45eb7540703 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -152,6 +152,12 @@ enum mt7530_port_mode {
 	/* Port Matrix Mode: Frames are forwarded by the PCR_MATRIX members. */
 	MT7530_PORT_MATRIX_MODE = PORT_VLAN(0),
 
+	/* Fallback Mode: Forward received frames with ingress ports that do
+	 * not belong to the VLAN member. Frames whose VID is not listed on
+	 * the VLAN table are forwarded by the PCR_MATRIX members.
+	 */
+	MT7530_PORT_FALLBACK_MODE = PORT_VLAN(1),
+
 	/* Security Mode: Discard any frame due to ingress membership
 	 * violation or VID missed on the VLAN table.
 	 */
-- 
2.26.2

