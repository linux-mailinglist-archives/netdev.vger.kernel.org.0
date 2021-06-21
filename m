Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA63E3AE523
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 10:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhFUIpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 04:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhFUIpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 04:45:10 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE363C061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 01:42:55 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id u13so9534426lfk.2
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 01:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eYxepnqXocH86ZjwWxWsEqGKv7salNxoXep/ZiBvWEs=;
        b=AQDxq9X+qWeWBTzWdPS34hMyAi2N3nJIb7yxZ3tJE6XPi7poE161pdbkNe82bapLKq
         bCEIzjd0Yidoh9hOzS5shON3rEz3LMP8O4rou/TJ6GuslEzvBUqnce4BLmjun5D12qk/
         WKo+BaToAAeeTOzcp8l0hccs+rGBFz9Zlziv26Q7kLxeuIwUxtPJMp+qcdkqvKG0LGFt
         gTqzghoqufC+FMDDLxD/hsKP5W7rW02EcJWS116UztVtfZVZgjGbInLohO8tYEm3uHD6
         OzQXgOopQTQt6i9rQ4gC0leImO65WuvZUd+3w/ytUF/pQRRNNe7DeNHqE7H9AV8KWsQn
         Qy1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eYxepnqXocH86ZjwWxWsEqGKv7salNxoXep/ZiBvWEs=;
        b=OikPZ46JM5WsQ1x0FI19ke1cNt1JmVM1BLhMOp0uUTSUIrPaakRS9FrW/zNc9+aLpk
         ZqWFlVEhX0KXQ3WpQ2rNBLTE6RAA0+FKzRLWPasIMLO5xHUde5TW40J2qUi/pvvE46m4
         B+boTXtkzNkft0caoV1UStAXlG/IWVIMiPQgw6aow/UwTWYl3MLMwX6vAH4Ux8uIdqYT
         G2eNLJ6KYVPVKrhvaUKNKbcwoRHBg7xYOglhgkriSo79ZELu+W+v+bnP/S2a+PVbKib1
         XWC3gJ9ePSIu+K7ZX60JK0nZv+19IaZYT2uaFzNtllHmCfzuIUX7uMV4pKxgXXOJdVa5
         CW1A==
X-Gm-Message-State: AOAM532UVHq/SEZjC4Ev5JV1xk8z7HdfsLjzCr53O/onPxUbGv+UcFVT
        lyj+RQsMhdT6ExLhWjqe32UDWZWgirXvGg==
X-Google-Smtp-Source: ABdhPJzF7pbrghzoTHbu8aZ9aqFdu00juK+aso863Ts6fFBWjwMoR5G1O/NCjoGsYh05PYVWUalrYA==
X-Received: by 2002:ac2:46f0:: with SMTP id q16mr12989928lfo.293.1624264974042;
        Mon, 21 Jun 2021 01:42:54 -0700 (PDT)
Received: from localhost.localdomain ([185.6.236.169])
        by smtp.googlemail.com with ESMTPSA id g2sm1338038ljn.131.2021.06.21.01.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 01:42:53 -0700 (PDT)
From:   Eldar Gasanov <eldargasanov2@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] mv88e6xxx: fixed adding vlan 0
Date:   Mon, 21 Jun 2021 11:41:59 +0300
Message-Id: <20210621084159.24907-1-eldargasanov2@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

8021q module adds vlan 0 to all interfaces when it starts.
When 8021q module is loaded it isn't possible to create bond
with mv88e6xxx interfaces, bonding module dipslay error
"Couldn't add bond vlan ids", because it tries to add vlan 0
to slave interfaces.

There is unexpected behavior in the switch. When a PVID
is assigned to a port the switch changes VID to PVID
in ingress frames with VID 0 on the port. Expected
that the switch doesn't assign PVID to tagged frames
with VID 0. But there isn't a way to change this behavior
in the switch.
---
 drivers/net/dsa/mv88e6xxx/chip.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index eca285aaf72f..3c6ca9028251 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1618,9 +1618,6 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_vtu_entry vlan;
 	int i, err;
 
-	if (!vid)
-		return -EOPNOTSUPP;
-
 	/* DSA and CPU ports have to be members of multiple vlans */
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
 		return 0;
@@ -2109,6 +2106,9 @@ static int mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
 	u8 member;
 	int err;
 
+	if (!vlan->vid)
+		return 0;
+
 	err = mv88e6xxx_port_vlan_prepare(ds, port, vlan);
 	if (err)
 		return err;
@@ -6355,7 +6355,7 @@ static const struct of_device_id mv88e6xxx_of_match[] = {
 		.data = &mv88e6xxx_table[MV88E6085],
 	},
 	{
-		.compatible = "marvell,mv88e6190",
+		.compatible = "marvell,mv88e6190",mv88e6xxx_g1_vtu_vid_write
 		.data = &mv88e6xxx_table[MV88E6190],
 	},
 	{
-- 
2.25.1

