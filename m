Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F1755359D
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 17:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352374AbiFUPOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 11:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352770AbiFUPNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 11:13:38 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527552CDFA;
        Tue, 21 Jun 2022 08:12:31 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z11so13653656edp.9;
        Tue, 21 Jun 2022 08:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LU/OkmDAL+vY/i1/LTdgZ8fR3Suk3NR9q9oRePr0Tbg=;
        b=K4y0cJ8ttDzz/9xM67cbuUDZf7b81dbH6VmKSWMXgWKDMc5ZtvCa7PJGPxeMeY9Br+
         eLDLhVgDRoWLqg1+tw2JqOUAPLAxFgb+jKudFlh+KflFmZQWn2UMwriCJUjI7yhmvmq9
         dPyr4Xga14qlMWcUG6Sspzj7EBscefmbnzUvdIC/wWiJXDaX1aKFgFZSYQrPwNC5f9Nw
         5PLnxNV+SEsnrOUVWWDNj1cRE/IWgyUJ3Gzjjqbj7mXe2FAup2/Y2lfISzgU88IIpxfT
         BoKHrt824YPyKPfexhkncfa6LRqhtmvcwsSmPooUh3xqbo0H4Hvvxmva3buAC5CHi3SG
         BJgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LU/OkmDAL+vY/i1/LTdgZ8fR3Suk3NR9q9oRePr0Tbg=;
        b=ctt8M6cSeY+vly5WJhw88WU8VlfE3uZH3NcP3FLJ6nzfWouzwMLTMcnMXPRcGeJOMa
         RbcNJIgu1Ss8YpTSD99Gr5/ZdAi3Gyir+PZBiJI76YLBadwRlmeR2b9LVRh9aNqGBXk3
         BOulw1XPaz5pGNGlmcwtaVBBUcpqEPLk0mkhGR38hZUb6536pfs5WMidW8JZLkDH8PqW
         L6Hhg19hcrNyWJH0OQefKri7Bto6D8kb+VeqZ2WHPy1MOqx59Jwvh3GEWJX2uSZLDXqx
         WQReWzzt93pvC/1Oae5v2TMv1jZTLRexiLffpLf2Og2RpNHCS7HC7OOx12Rj35mrqstU
         Wh8A==
X-Gm-Message-State: AJIora/Oc5QFMg3RaO5E40d2z5xRDIc7dDb9hnGXUmnDaTnZi8h1/Bg0
        Qc98nEt+3h5+Q7Dn6CAf3iU=
X-Google-Smtp-Source: AGRyM1ujwkeb9wGg4k+jngzeJaKTh4TUZEbqd1al5yboqQIniK7hzUuvDLzXS5hhEJh6BA5VqxF1Hw==
X-Received: by 2002:aa7:dbd7:0:b0:433:55a6:e3c4 with SMTP id v23-20020aa7dbd7000000b0043355a6e3c4mr36980333edt.74.1655824349229;
        Tue, 21 Jun 2022 08:12:29 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id ky20-20020a170907779400b006f4cb79d9a8sm7835731ejc.75.2022.06.21.08.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 08:12:28 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan McDowell <noodles@earth.li>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Christian Marangi <ansuelsmth@gmail.com>, stable@vger.kernel.org
Subject: [PATCH net v2] net: dsa: qca8k: reset cpu port on MTU change
Date:   Tue, 21 Jun 2022 17:11:22 +0200
Message-Id: <20220621151122.10220-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was discovered that the Documentation lacks of a fundamental detail
on how to correctly change the MAX_FRAME_SIZE of the switch.

In fact if the MAX_FRAME_SIZE is changed while the cpu port is on, the
switch panics and cease to send any packet. This cause the mgmt ethernet
system to not receive any packet (the slow fallback still works) and
makes the device not reachable. To recover from this a switch reset is
required.

To correctly handle this, turn off the cpu ports before changing the
MAX_FRAME_SIZE and turn on again after the value is applied.

Fixes: f58d2598cf70 ("net: dsa: qca8k: implement the port MTU callbacks")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
v2:
- Split from original series sent to net-next and rebased
- Added the stable cc tag

 drivers/net/dsa/qca8k.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 2727d3169c25..1cbb05b0323f 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2334,6 +2334,7 @@ static int
 qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct qca8k_priv *priv = ds->priv;
+	int ret;
 
 	/* We have only have a general MTU setting.
 	 * DSA always set the CPU port's MTU to the largest MTU of the slave
@@ -2344,8 +2345,27 @@ qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 	if (!dsa_is_cpu_port(ds, port))
 		return 0;
 
+	/* To change the MAX_FRAME_SIZE the cpu ports must be off or
+	 * the switch panics.
+	 * Turn off both cpu ports before applying the new value to prevent
+	 * this.
+	 */
+	if (priv->port_enabled_map & BIT(0))
+		qca8k_port_set_status(priv, 0, 0);
+
+	if (priv->port_enabled_map & BIT(6))
+		qca8k_port_set_status(priv, 6, 0);
+
 	/* Include L2 header / FCS length */
-	return qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, new_mtu + ETH_HLEN + ETH_FCS_LEN);
+	ret = qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, new_mtu + ETH_HLEN + ETH_FCS_LEN);
+
+	if (priv->port_enabled_map & BIT(0))
+		qca8k_port_set_status(priv, 0, 1);
+
+	if (priv->port_enabled_map & BIT(6))
+		qca8k_port_set_status(priv, 6, 1);
+
+	return ret;
 }
 
 static int
-- 
2.36.1

