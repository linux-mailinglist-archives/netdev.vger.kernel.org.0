Return-Path: <netdev+bounces-3133-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 450FF705B2C
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 01:18:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD1131C20CBE
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 23:17:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D02E1078E;
	Tue, 16 May 2023 23:17:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36687101E2
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 23:17:28 +0000 (UTC)
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE69E72AA
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 16:17:22 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id af79cd13be357-7590aa05af6so22793585a.0
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 16:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1684279042; x=1686871042;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=k7Rhh/CZipU9oP0MynKUlXVUrhnbO/Qff00LqX71mrE=;
        b=Vto05JusPBiUAHVcBLBJBtpwI5P8pwNwXc0vb0sHfSidIJKQVZ419cqenoXDHcGvbT
         bXC48rdITIkiPjWPPfN5RsKZd9c7ZIHijaSgoTbm9UmPZLyj5o9VGOzFuqWc1OmzEUxY
         VcigDm0TfmndkoXJkCZYEfWWJGLkyxJimWYq4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684279042; x=1686871042;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k7Rhh/CZipU9oP0MynKUlXVUrhnbO/Qff00LqX71mrE=;
        b=lpwfwQc8EaX6DKPEDPtfLBWLMrwYJCzm40VIiRGQZT/P6UziveySi+0nuw2Cssu7KN
         i4PBO2M+kJ0/0eBEhi7qyHNbzCLJSISFeWcqJx7HPFy4XY1nHLq4XOXLCUSQO2COLQhl
         ONNWirGTjY2H4KVSNtZNdr1R96typ+OeYblkisz9wY636zWiHYwmrx/Wu6b+t+16rFi7
         T1sY6DERChLiElZ0dP4Zrw3bdUgRSi5XDMBiNvyyzkSShF+o+6/pGSo3c9po6C4AfGep
         c7YYX/NtUSIzJhlGod6voPH5x9H+nsHOw/Wbpv6nA9XkV56cLtgWMHsW/zT98AJ7Bmha
         lgcw==
X-Gm-Message-State: AC+VfDyUL9OK/YGUsAkqy0J/LQZqmTWLEi1Wk9u6Uxow9wVbR6Dhjjz5
	KyK2jsVxXVhuN2XrHk9bRlpLj9Td+zamQU8ovNUs7kDJVJ5b2j8Oe32z0vhyG7Vap/FMDSrmkS4
	e6coVdw8stAQpb/YOEvt6U1252wd3SGRwRO/CUt7XR4bao9dfAEbsHAePv+ybCQnx6G+/4Kx+tW
	Lu1WT27fW3Qw==
X-Google-Smtp-Source: ACHHUZ6qvLQ1W1kJf5bqtkPYf1y2R5JktigxOdsOb4Rp/9eNx7LJtd700CFxOKuxRJigbvkoT+WDyA==
X-Received: by 2002:ad4:5bca:0:b0:5ef:519:b1a with SMTP id t10-20020ad45bca000000b005ef05190b1amr51748448qvt.24.1684279041586;
        Tue, 16 May 2023 16:17:21 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g17-20020a0cf851000000b0061b7784b3basm5495427qvo.84.2023.05.16.16.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 16:17:21 -0700 (PDT)
From: Florian Fainelli <florian.fainelli@broadcom.com>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <florian.fainelli@broadcom.com>,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 2/3] net: phy: broadcom: Add support for WAKE_FILTER
Date: Tue, 16 May 2023 16:17:12 -0700
Message-Id: <20230516231713.2882879-3-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230516231713.2882879-1-florian.fainelli@broadcom.com>
References: <20230516231713.2882879-1-florian.fainelli@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000000049ef05fbd7c6c5"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--0000000000000049ef05fbd7c6c5
Content-Transfer-Encoding: 8bit

Since the PHY is capable of matching any arbitrary Ethernet MAC
destination as a programmable wake-up pattern, add support for doing
that using the WAKE_FILTER and ethtool::rxnfc API. For instance, in
order to wake-up from the Ethernet MAC address corresponding to the IPv4
multicast IP address of 224.0.0.1, one could do:

ethtool -N eth0 flow-type ether dst 01:00:5e:00:00:fb loc 0 action -2
ethtool -n eth0
Total 1 rules

Filter: 0
        Flow Type: Raw Ethernet
        Src MAC addr: 00:00:00:00:00:00 mask: FF:FF:FF:FF:FF:FF
        Dest MAC addr: 01:00:5E:00:00:FB mask: 00:00:00:00:00:00
        Ethertype: 0x0 mask: 0xFFFF
        Action: Wake-on-LAN
ethtool -s eth0 wol f

Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
---
 drivers/net/phy/bcm-phy-lib.c | 147 +++++++++++++++++++++++++++++++++-
 drivers/net/phy/bcm-phy-lib.h |   6 ++
 drivers/net/phy/broadcom.c    |  15 ++++
 3 files changed, 167 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
index 5603d0a9ce96..546c21ce9775 100644
--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -822,7 +822,8 @@ EXPORT_SYMBOL_GPL(bcm_phy_cable_test_get_status_rdb);
 					 WAKE_MCAST | \
 					 WAKE_BCAST | \
 					 WAKE_MAGIC | \
-					 WAKE_MAGICSECURE)
+					 WAKE_MAGICSECURE | \
+					 WAKE_FILTER)
 
 int bcm_phy_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
 {
@@ -876,6 +877,12 @@ int bcm_phy_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
 	ctl &= ~BCM54XX_WOL_DIR_PKT_EN;
 	ctl &= ~(BCM54XX_WOL_SECKEY_OPT_MASK << BCM54XX_WOL_SECKEY_OPT_SHIFT);
 
+	/* For WAKE_FILTER, we have already programmed the desired MAC DA
+	 * and associated mask by the time we get there.
+	 */
+	if (wol->wolopts & WAKE_FILTER)
+		goto program_ctl;
+
 	/* When using WAKE_MAGIC, we program the magic pattern filter to match
 	 * the device's MAC address and we accept any MAC DA in the Ethernet
 	 * frame.
@@ -930,6 +937,7 @@ int bcm_phy_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
 			return ret;
 	}
 
+program_ctl:
 	if (wol->wolopts & WAKE_MAGICSECURE) {
 		ctl |= BCM54XX_WOL_SECKEY_OPT_6B <<
 		       BCM54XX_WOL_SECKEY_OPT_SHIFT;
@@ -1034,6 +1042,143 @@ irqreturn_t bcm_phy_wol_isr(int irq, void *dev_id)
 }
 EXPORT_SYMBOL_GPL(bcm_phy_wol_isr);
 
+static int bcm_phy_get_rule(struct phy_device *phydev,
+			    struct ethtool_rxnfc *nfc,
+			    int loc)
+{
+	u8 da[ETH_ALEN];
+	unsigned int i;
+	int ret;
+
+	if (loc != 0)
+		return -EINVAL;
+
+	memset(nfc, 0, sizeof(*nfc));
+	nfc->flow_type = ETHER_FLOW;
+	nfc->fs.flow_type = ETHER_FLOW;
+
+	for (i = 0; i < sizeof(da) / 2; i++) {
+		ret = bcm_phy_read_exp(phydev,
+				       BCM54XX_WOL_MPD_DATA2(2 - i));
+		if (ret < 0)
+			return ret;
+
+		da[i * 2] = ret >> 8;
+		da[i * 2 + 1] = ret & 0xff;
+	}
+	ether_addr_copy(nfc->fs.h_u.ether_spec.h_dest, da);
+
+	for (i = 0; i < sizeof(da) / 2; i++) {
+		ret = bcm_phy_read_exp(phydev,
+				       BCM54XX_WOL_MASK(2 - i));
+		if (ret < 0)
+			return ret;
+
+		da[i * 2] = ret >> 8;
+		da[i * 2 + 1] = ret & 0xff;
+	}
+	ether_addr_copy(nfc->fs.m_u.ether_spec.h_dest, da);
+
+	nfc->fs.ring_cookie = RX_CLS_FLOW_WAKE;
+	nfc->fs.location = 0;
+
+	return 0;
+}
+
+static int bcm_phy_set_rule(struct phy_device *phydev,
+			    struct ethtool_rxnfc *nfc)
+{
+	int ret = -EOPNOTSUPP;
+	unsigned int i;
+	const u8 *da;
+
+	/* We support only matching on the MAC DA, reject anything else */
+	if (nfc->fs.ring_cookie != RX_CLS_FLOW_WAKE ||
+	    nfc->fs.location != 0 ||
+	    nfc->fs.flow_type != ETHER_FLOW ||
+	    nfc->fs.h_u.ether_spec.h_proto ||
+	    !is_zero_ether_addr(nfc->fs.h_u.ether_spec.h_source) ||
+	    nfc->fs.m_u.ether_spec.h_proto ||
+	    !is_zero_ether_addr(nfc->fs.m_u.ether_spec.h_source))
+		return ret;
+
+	da = nfc->fs.h_u.ether_spec.h_dest;
+	for (i = 0; i < ETH_ALEN / 2; i++) {
+		ret = bcm_phy_write_exp(phydev,
+					BCM54XX_WOL_MPD_DATA2(2 - i),
+					da[i * 2] << 8 | da[i * 2 + 1]);
+		if (ret < 0)
+			return ret;
+	}
+
+	da = nfc->fs.m_u.ether_spec.h_dest;
+	for (i = 0; i < ETH_ALEN / 2; i++) {
+		ret = bcm_phy_write_exp(phydev,
+					BCM54XX_WOL_MASK(2 - i),
+					da[i * 2] << 8 | da[i * 2 + 1]);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+int bcm_phy_get_rxnfc(struct phy_device *phydev,
+		      struct ethtool_rxnfc *cmd, u32 *rule_locs)
+{
+	int err = 0;
+
+	switch (cmd->cmd) {
+	case ETHTOOL_GRXCLSRLCNT:
+		cmd->rule_cnt = 1;
+		cmd->data = 1 | RX_CLS_LOC_SPECIAL;
+		break;
+	case ETHTOOL_GRXCLSRULE:
+		err = bcm_phy_get_rule(phydev, cmd, cmd->fs.location);
+		break;
+	case ETHTOOL_GRXCLSRLALL:
+		rule_locs[0] = 0;
+		cmd->rule_cnt = 1;
+		cmd->data = 1;
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(bcm_phy_get_rxnfc);
+
+int bcm_phy_set_rxnfc(struct phy_device *phydev,
+		      struct ethtool_rxnfc *cmd,
+		      bool *installed)
+{
+	int err = 0;
+
+	switch (cmd->cmd) {
+	case ETHTOOL_SRXCLSRLINS:
+		err = bcm_phy_set_rule(phydev, cmd);
+		if (err)
+			return err;
+
+		*installed = true;
+		break;
+	case ETHTOOL_SRXCLSRLDEL:
+		if (cmd->fs.location != 0)
+			return err;
+
+		*installed = false;
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(bcm_phy_set_rxnfc);
+
 MODULE_DESCRIPTION("Broadcom PHY Library");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Broadcom Corporation");
diff --git a/drivers/net/phy/bcm-phy-lib.h b/drivers/net/phy/bcm-phy-lib.h
index 2f30ce0cab0e..4881ea34e99c 100644
--- a/drivers/net/phy/bcm-phy-lib.h
+++ b/drivers/net/phy/bcm-phy-lib.h
@@ -118,4 +118,10 @@ int bcm_phy_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol);
 void bcm_phy_get_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol);
 irqreturn_t bcm_phy_wol_isr(int irq, void *dev_id);
 
+int bcm_phy_get_rxnfc(struct phy_device *phydev,
+		      struct ethtool_rxnfc *nfc, u32 *rule_locs);
+int bcm_phy_set_rxnfc(struct phy_device *phydev,
+		      struct ethtool_rxnfc *nfc,
+		      bool *installed);
+
 #endif /* _LINUX_BCM_PHY_LIB_H */
diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 822c8b01dc53..b4a8aba7d5ef 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -36,6 +36,7 @@ struct bcm54xx_phy_priv {
 	struct bcm_ptp_private *ptp;
 	int	wake_irq;
 	bool	wake_irq_enabled;
+	bool	wake_filter_installed;
 };
 
 static bool bcm54xx_phy_can_wakeup(struct phy_device *phydev)
@@ -860,6 +861,8 @@ static int brcm_fet_suspend(struct phy_device *phydev)
 static void bcm54xx_phy_get_wol(struct phy_device *phydev,
 				struct ethtool_wolinfo *wol)
 {
+	struct bcm54xx_phy_priv *priv = phydev->priv;
+
 	/* We cannot wake-up if we do not have a dedicated PHY interrupt line
 	 * or an out of band GPIO descriptor for wake-up. Zeroing
 	 * wol->supported allows the caller (MAC driver) to play through and
@@ -871,6 +874,8 @@ static void bcm54xx_phy_get_wol(struct phy_device *phydev,
 	}
 
 	bcm_phy_get_wol(phydev, wol);
+	if (priv->wake_filter_installed)
+		wol->wolopts |= WAKE_FILTER;
 }
 
 static int bcm54xx_phy_set_wol(struct phy_device *phydev,
@@ -893,6 +898,14 @@ static int bcm54xx_phy_set_wol(struct phy_device *phydev,
 	return 0;
 }
 
+static int bcm54xx_phy_set_rxnfc(struct phy_device *phydev,
+				 struct ethtool_rxnfc *cmd)
+{
+	struct bcm54xx_phy_priv *priv = phydev->priv;
+
+	return bcm_phy_set_rxnfc(phydev, cmd, &priv->wake_filter_installed);
+}
+
 static int bcm54xx_phy_probe(struct phy_device *phydev)
 {
 	struct bcm54xx_phy_priv *priv;
@@ -1031,6 +1044,8 @@ static struct phy_driver broadcom_drivers[] = {
 	.resume		= bcm54xx_resume,
 	.get_wol	= bcm54xx_phy_get_wol,
 	.set_wol	= bcm54xx_phy_set_wol,
+	.get_rxnfc	= bcm_phy_get_rxnfc,
+	.set_rxnfc	= bcm54xx_phy_set_rxnfc,
 }, {
 	.phy_id		= PHY_ID_BCM5461,
 	.phy_id_mask	= 0xfffffff0,
-- 
2.34.1


--0000000000000049ef05fbd7c6c5
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBVgwggRAoAMCAQICDBP8P9hKRVySg3Qv5DANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAxMjE4MTFaFw0yNTA5MTAxMjE4MTFaMIGW
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGTAXBgNVBAMTEEZsb3JpYW4gRmFpbmVsbGkxLDAqBgkqhkiG
9w0BCQEWHWZsb3JpYW4uZmFpbmVsbGlAYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEA+oi3jMmHltY4LMUy8Up5+1zjd1iSgUBXhwCJLj1GJQF+GwP8InemBbk5rjlC
UwbQDeIlOfb8xGqHoQFGSW8p9V1XUw+cthISLkycex0AJ09ufePshLZygRLREU0H4ecNPMejxCte
KdtB4COST4uhBkUCo9BSy1gkl8DJ8j/BQ1KNUx6oYe0CntRag+EnHv9TM9BeXBBLfmMRnWNhvOSk
nSmRX0J3d9/G2A3FIC6WY2XnLW7eAZCQPa1Tz3n2B5BGOxwqhwKLGLNu2SRCPHwOdD6e0drURF7/
Vax85/EqkVnFNlfxtZhS0ugx5gn2pta7bTdBm1IG4TX+A3B1G57rVwIDAQABo4IB3jCCAdowDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAoBgNVHREEITAfgR1mbG9yaWFuLmZhaW5lbGxpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUUwwfJ6/F
KL0fRdVROal/Lp4lAF0wDQYJKoZIhvcNAQELBQADggEBAKBgfteDc1mChZjKBY4xAplC6uXGyBrZ
kNGap1mHJ+JngGzZCz+dDiHRQKGpXLxkHX0BvEDZLW6LGOJ83ImrW38YMOo3ZYnCYNHA9qDOakiw
2s1RH00JOkO5SkYdwCHj4DB9B7KEnLatJtD8MBorvt+QxTuSh4ze96Jz3kEIoHMvwGFkgObWblsc
3/YcLBmCgaWpZ3Ksev1vJPr5n8riG3/N4on8gO5qinmmr9Y7vGeuf5dmZrYMbnb+yCBalkUmZQwY
NxADYvcRBA0ySL6sZpj8BIIhWiXiuusuBmt2Mak2eEv0xDbovE6Z6hYyl/ZnRadbgK/ClgbY3w+O
AfUXEZ0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwT
/D/YSkVckoN0L+QwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEINQPoyl6f4t1rERw
rmtOc3cJUeFngyhPYDeIullzRRu/MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIzMDUxNjIzMTcyMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQDpswV/znbbf5VYZipT9MbKILqNIHUixgUZ
s60pE5GywiLz+Mji9AmfPWqnXl1iRUa/3sFW8ZETlxE81SOVoGgHO2TrP5u/KXvuQEnvr9OfBDJE
hVk3NOuT3RyCx3lcmLbPUN0Q4nPwnxg3CIyl92faFmufIXvDYWxvSgr717CWrHBdCUuGvIUTcfRX
clm9TQZzdhju5RQyXjYu1Lg/he3Rr8szJnaSAvNpo+JqeOjk725u2j+MOCVWc1LpbZ8wZMsH1eG8
70v2nTTmtZjgcn0DBuiIjoNBPkvoEXcwu20kfLtJ38eCkGI/yq4gv/FVV60j1ICAqu5OXA183mSN
6J21
--0000000000000049ef05fbd7c6c5--

