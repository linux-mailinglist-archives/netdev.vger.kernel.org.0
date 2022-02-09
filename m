Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B154B0093
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 23:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbiBIWqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 17:46:06 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236164AbiBIWqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 17:46:05 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E67E01925B
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 14:46:08 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id r27so4117956oiw.4
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 14:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=THLcNbdENt4aYroTj0xpNFU+8l+/RBvoaz8UNTAmS3U=;
        b=aMby/tFaVQwjRMIClj+TZfsZ6cPQUgzicvS/524jQycP4uXfqxQ2gI1HBKVXMzo8x6
         V0FKeG39CJghT8gYCQSpoO/Z5bcnOkYTcVeRCo2+puEyYdtExnFV2vVaSXkJpCll4Hk0
         amk9IJ1qcvQx2rEfJddelTBmFTE99uwswVmtbj9dT7OAAg+ucMatXs4zOTYh69BiQSBp
         BtVhvPBaagLBY9rizMR04rWLxIgkHPHHBGhSDIKTO8FS8/KGjoyWUDuJWRtPHA5MBVWe
         TvIQxtbyWGNQ/WPkYa5UvkYa+L9G/fmSqokpEu31z2wZxPxc0V0R53alhZ/QI+7HHfha
         GJ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=THLcNbdENt4aYroTj0xpNFU+8l+/RBvoaz8UNTAmS3U=;
        b=PT0jnINigPXgrOwOKZJHXeFBOaqolPmZSmxxJlN+x4+Pd8Ku/wy8EQBmEFW5PgwcId
         gsV2Ox0tFUBiEnm5jUKLX3tlO1+oD4NscIG9PYRyBDhcGpSxkE5w6etVXnvZyASJw9j2
         Q01jA1eae0z5WRtY3B1D9VoK5KP7cqfxEh9fgaLVf/osKuUes4WwgUGNF7gbJ/GAuMrg
         IsBmfmVSNb2StGJJ/vbsMA8R76/n2tz8KxrFE5ojMTk3tw1pyiN01jbXsTLFkK1ba1BU
         /MQgPIdmyeh9+OvrJ6/FwGdDW2iVnTjnhzlT6d6hMWyQ/4agD8Bjc4nlN6CPdNMkEEKc
         CPrg==
X-Gm-Message-State: AOAM5316P4Jta5X6b1zpYgKnGiL4XT+K+/cKOd5L8VOiTJuftIwyQbjr
        tS0djfi+mJJFqzbshDPXmFvADiPvIeH5Og==
X-Google-Smtp-Source: ABdhPJzfAcx3wJMA7adsL0HZFbow21LnCCd9QdjiFhCdKgIPPdoOyY3+f2kGNTiFEbgvg9mRmqfAqQ==
X-Received: by 2002:a05:6808:1827:: with SMTP id bh39mr2070100oib.219.1644446767676;
        Wed, 09 Feb 2022 14:46:07 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id 21sm7132301otj.71.2022.02.09.14.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 14:46:07 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next] net: dsa: realtek: rtl8365mb: irq with realtek-mdio
Date:   Wed,  9 Feb 2022 19:45:38 -0300
Message-Id: <20220209224538.9028-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
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

realtek-smi creates a custom ds->slave_mii_bus and uses a mdio
device-tree subnode to associates the interrupt-controller to each port.
However, with realtek-mdio, ds->slave_mii_bus is created and configured
by the switch with no device-tree settings. With no interruptions, the
switch falls back to polling the port status.

This patch adds a new ds_ops->port_setup() to configure each phy_device
interruption. It is only used by realtek-mdio but it could probably be
used by realtek-smi as well, removing the need for a mdio subnode in the
realtek device-tree node.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 2ed592147c20..45afe57a5d31 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -1053,6 +1053,23 @@ static void rtl8365mb_phylink_mac_link_up(struct dsa_switch *ds, int port,
 	}
 }
 
+static int rtl8365mb_port_setup(struct dsa_switch *ds, int port)
+{
+	struct realtek_priv *priv = ds->priv;
+	struct phy_device *phydev;
+
+	if (priv->irqdomain && ds->slave_mii_bus->irq[port] == PHY_POLL) {
+		phydev = mdiobus_get_phy(ds->slave_mii_bus, port);
+		if (!phydev)
+			return 0;
+
+		phydev->irq = irq_find_mapping(priv->irqdomain, port);
+		ds->slave_mii_bus->irq[port] = phydev->irq;
+	}
+
+	return 0;
+}
+
 static void rtl8365mb_port_stp_state_set(struct dsa_switch *ds, int port,
 					 u8 state)
 {
@@ -2022,6 +2039,7 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
 	.phylink_mac_link_up = rtl8365mb_phylink_mac_link_up,
 	.phy_read = rtl8365mb_dsa_phy_read,
 	.phy_write = rtl8365mb_dsa_phy_write,
+	.port_setup = rtl8365mb_port_setup,
 	.port_stp_state_set = rtl8365mb_port_stp_state_set,
 	.get_strings = rtl8365mb_get_strings,
 	.get_ethtool_stats = rtl8365mb_get_ethtool_stats,
-- 
2.35.1

