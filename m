Return-Path: <netdev+bounces-9016-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B58AF7268ED
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:36:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E78F1C20F83
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB157370E3;
	Wed,  7 Jun 2023 18:35:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99485154B2
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 18:35:29 +0000 (UTC)
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2D61BF0
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:35:22 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1b011cffe7fso35861895ad.1
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 11:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1686162921; x=1688754921;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=m8FWFscsK98eHJgkzcfoHPhLFlJbDxjHHQzQurqGzs4=;
        b=Teae8jQIMgG0mAiL42LmvILvXvFt/UzGVbFumcUoxvoyfkUH3rq+nhxYRhgAtd2onC
         Z2v+otxwI/UsFp7u4Iqjx8PEUTy+hM7lJ7criVjrc5lfwX+btHhRHRDmu5hZmvRSRU1Z
         kwRHQDeVbljexb1SapBmzq7qE8laFjHqsONRI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686162921; x=1688754921;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m8FWFscsK98eHJgkzcfoHPhLFlJbDxjHHQzQurqGzs4=;
        b=ICczrguwuM7J8oib10TiTrOPWN/E4qF31HdNirwUHG7ppB4QQJs41d4aiOb5hJInYx
         bIa4yyIsQul9cHdWFcQMzz339JusgGPz5j0qanNA5kSmnHjI+AqKY96XULsBpFEba887
         fOcHsfvi0e5s+dDoea0n+h7wVteQ/z6tcREK1nmnzNoQm62auBwr7MS+8gPvxxDpZoi6
         qFvgEAMYfeuhOtl6fMK66y0qMK1gGLOKyh1vK3vd28ikXu3TVIL15R78CGBw5tUS/6TY
         HD4adcDtWT7dj7OlLlJfqh1KofZwi+BARtOAQdQ5Yjue8jgXMGvPgn6y7H4wgMlh2zVp
         1FNg==
X-Gm-Message-State: AC+VfDxCS/70EXjed4frkbUfdRR4AcpXIo9y0vvggblt/vwNNJfIPLY2
	E8uOT39N1Tyr2+pt6olOdmKy3G9ymQzQkdE1HThomRfe1vztg36ubAJjltIw/sNC0g5oCIpD8o3
	CwDGT0c2euhjshkg/4HxC4j42LPjCcILAfUGJS7PIyo1lqDUWhBoSf07LudQxJuzaNVvli06ued
	3fg9m/pYV2Ig==
X-Google-Smtp-Source: ACHHUZ5Vbu7utgT0DjLDbMONNgmpUnwWq4D1FnR9dQBYr0iKqweFiM5C37CVCqusXR35MvzvdbTw7A==
X-Received: by 2002:a17:902:ecc5:b0:1b0:5425:216f with SMTP id a5-20020a170902ecc500b001b05425216fmr3185535plh.34.1686162921347;
        Wed, 07 Jun 2023 11:35:21 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id je12-20020a170903264c00b001addf547a6esm10746876plb.17.2023.06.07.11.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 11:35:20 -0700 (PDT)
From: Florian Fainelli <florian.fainelli@broadcom.com>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <florian.fainelli@broadcom.com>,
	Doug Berger <opendmb@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] net: phy: broadcom: Add support for setting LED brightness
Date: Wed,  7 Jun 2023 11:34:53 -0700
Message-Id: <20230607183453.2587726-3-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230607183453.2587726-1-florian.fainelli@broadcom.com>
References: <20230607183453.2587726-1-florian.fainelli@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000fc69cc05fd8e65cb"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--000000000000fc69cc05fd8e65cb
Content-Transfer-Encoding: 8bit

Broadcom PHYs have two LEDs selector registers which allow us to control
the LED assignment, including how to turn them on/off.

Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
---
 drivers/net/phy/bcm-phy-lib.c | 27 +++++++++++++++++++++++++++
 drivers/net/phy/bcm-phy-lib.h |  3 +++
 drivers/net/phy/broadcom.c    | 15 +++++++++++++++
 include/linux/brcmphy.h       |  3 +++
 4 files changed, 48 insertions(+)

diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
index c6e2e5f636d4..876f28fd8256 100644
--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -1039,6 +1039,33 @@ irqreturn_t bcm_phy_wol_isr(int irq, void *dev_id)
 }
 EXPORT_SYMBOL_GPL(bcm_phy_wol_isr);
 
+int bcm_phy_led_brightness_set(struct phy_device *phydev,
+			       u8 index, enum led_brightness value)
+{
+	u8 led_num;
+	int ret;
+	u16 reg;
+
+	if (index >= 4)
+		return -EINVAL;
+
+	/* Two LEDS per register */
+	led_num = index % 2;
+	reg = index >= 2 ? BCM54XX_SHD_LEDS2 : BCM54XX_SHD_LEDS1;
+
+	ret = bcm_phy_read_shadow(phydev, reg);
+	if (ret < 0)
+		return ret;
+
+	ret &= ~(BCM_LED_SRC_MASK << BCM54XX_SHD_LEDS_SHIFT(led_num));
+	if (value == LED_OFF)
+		ret |= BCM_LED_SRC_OFF << BCM54XX_SHD_LEDS_SHIFT(led_num);
+	else
+		ret |= BCM_LED_SRC_ON << BCM54XX_SHD_LEDS_SHIFT(led_num);
+	return bcm_phy_write_shadow(phydev, reg, ret);
+}
+EXPORT_SYMBOL_GPL(bcm_phy_led_brightness_set);
+
 MODULE_DESCRIPTION("Broadcom PHY Library");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Broadcom Corporation");
diff --git a/drivers/net/phy/bcm-phy-lib.h b/drivers/net/phy/bcm-phy-lib.h
index 2f30ce0cab0e..b52189e45a84 100644
--- a/drivers/net/phy/bcm-phy-lib.h
+++ b/drivers/net/phy/bcm-phy-lib.h
@@ -118,4 +118,7 @@ int bcm_phy_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol);
 void bcm_phy_get_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol);
 irqreturn_t bcm_phy_wol_isr(int irq, void *dev_id);
 
+int bcm_phy_led_brightness_set(struct phy_device *phydev,
+			       u8 index, enum led_brightness value);
+
 #endif /* _LINUX_BCM_PHY_LIB_H */
diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 57a865aa1fe5..9f0a9c575bd7 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -1031,6 +1031,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.resume		= bcm54xx_resume,
 	.get_wol	= bcm54xx_phy_get_wol,
 	.set_wol	= bcm54xx_phy_set_wol,
+	.led_brightness_set	= bcm_phy_led_brightness_set,
 }, {
 	.phy_id		= PHY_ID_BCM5461,
 	.phy_id_mask	= 0xfffffff0,
@@ -1044,6 +1045,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 	.link_change_notify	= bcm54xx_link_change_notify,
+	.led_brightness_set	= bcm_phy_led_brightness_set,
 }, {
 	.phy_id		= PHY_ID_BCM54612E,
 	.phy_id_mask	= 0xfffffff0,
@@ -1057,6 +1059,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 	.link_change_notify	= bcm54xx_link_change_notify,
+	.led_brightness_set	= bcm_phy_led_brightness_set,
 }, {
 	.phy_id		= PHY_ID_BCM54616S,
 	.phy_id_mask	= 0xfffffff0,
@@ -1070,6 +1073,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.read_status	= bcm54616s_read_status,
 	.probe		= bcm54616s_probe,
 	.link_change_notify	= bcm54xx_link_change_notify,
+	.led_brightness_set	= bcm_phy_led_brightness_set,
 }, {
 	.phy_id		= PHY_ID_BCM5464,
 	.phy_id_mask	= 0xfffffff0,
@@ -1085,6 +1089,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 	.link_change_notify	= bcm54xx_link_change_notify,
+	.led_brightness_set	= bcm_phy_led_brightness_set,
 }, {
 	.phy_id		= PHY_ID_BCM5481,
 	.phy_id_mask	= 0xfffffff0,
@@ -1099,6 +1104,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 	.link_change_notify	= bcm54xx_link_change_notify,
+	.led_brightness_set	= bcm_phy_led_brightness_set,
 }, {
 	.phy_id         = PHY_ID_BCM54810,
 	.phy_id_mask    = 0xfffffff0,
@@ -1115,6 +1121,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.suspend	= bcm54xx_suspend,
 	.resume		= bcm54xx_resume,
 	.link_change_notify	= bcm54xx_link_change_notify,
+	.led_brightness_set	= bcm_phy_led_brightness_set,
 }, {
 	.phy_id         = PHY_ID_BCM54811,
 	.phy_id_mask    = 0xfffffff0,
@@ -1131,6 +1138,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.suspend	= bcm54xx_suspend,
 	.resume		= bcm54xx_resume,
 	.link_change_notify	= bcm54xx_link_change_notify,
+	.led_brightness_set	= bcm_phy_led_brightness_set,
 }, {
 	.phy_id		= PHY_ID_BCM5482,
 	.phy_id_mask	= 0xfffffff0,
@@ -1144,6 +1152,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 	.link_change_notify	= bcm54xx_link_change_notify,
+	.led_brightness_set	= bcm_phy_led_brightness_set,
 }, {
 	.phy_id		= PHY_ID_BCM50610,
 	.phy_id_mask	= 0xfffffff0,
@@ -1159,6 +1168,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.link_change_notify	= bcm54xx_link_change_notify,
 	.suspend	= bcm54xx_suspend,
 	.resume		= bcm54xx_resume,
+	.led_brightness_set	= bcm_phy_led_brightness_set,
 }, {
 	.phy_id		= PHY_ID_BCM50610M,
 	.phy_id_mask	= 0xfffffff0,
@@ -1174,6 +1184,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.link_change_notify	= bcm54xx_link_change_notify,
 	.suspend	= bcm54xx_suspend,
 	.resume		= bcm54xx_resume,
+	.led_brightness_set	= bcm_phy_led_brightness_set,
 }, {
 	.phy_id		= PHY_ID_BCM57780,
 	.phy_id_mask	= 0xfffffff0,
@@ -1187,6 +1198,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 	.link_change_notify	= bcm54xx_link_change_notify,
+	.led_brightness_set	= bcm_phy_led_brightness_set,
 }, {
 	.phy_id		= PHY_ID_BCMAC131,
 	.phy_id_mask	= 0xfffffff0,
@@ -1218,6 +1230,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.get_stats	= bcm54xx_get_stats,
 	.probe		= bcm54xx_phy_probe,
 	.link_change_notify	= bcm54xx_link_change_notify,
+	.led_brightness_set	= bcm_phy_led_brightness_set,
 }, {
 	.phy_id		= PHY_ID_BCM53125,
 	.phy_id_mask	= 0xfffffff0,
@@ -1232,6 +1245,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 	.link_change_notify	= bcm54xx_link_change_notify,
+	.led_brightness_set	= bcm_phy_led_brightness_set,
 }, {
 	.phy_id		= PHY_ID_BCM53128,
 	.phy_id_mask	= 0xfffffff0,
@@ -1246,6 +1260,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 	.link_change_notify	= bcm54xx_link_change_notify,
+	.led_brightness_set	= bcm_phy_led_brightness_set,
 }, {
 	.phy_id         = PHY_ID_BCM89610,
 	.phy_id_mask    = 0xfffffff0,
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index ab21b8a1b2c8..5d732f48f787 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -161,6 +161,7 @@
 #define BCM_LED_SRC_OPENSHORT	0xb
 #define BCM_LED_SRC_OFF		0xe	/* Tied high */
 #define BCM_LED_SRC_ON		0xf	/* Tied low */
+#define BCM_LED_SRC_MASK	GENMASK(3, 0)
 
 /*
  * Broadcom Multicolor LED configurations (expansion register 4)
@@ -208,9 +209,11 @@
 
 #define BCM54XX_SHD_LEDS1	0x0d	/* 01101: LED Selector 1 */
 					/* LED3 / ~LINKSPD[2] selector */
+#define BCM54XX_SHD_LEDS_SHIFT(led)	(4 * (led))
 #define BCM54XX_SHD_LEDS1_LED3(src)	((src & 0xf) << 4)
 					/* LED1 / ~LINKSPD[1] selector */
 #define BCM54XX_SHD_LEDS1_LED1(src)	((src & 0xf) << 0)
+#define BCM54XX_SHD_LEDS2	0x0e	/* 01110: LED Selector 2 */
 #define BCM54XX_SHD_RGMII_MODE	0x0b	/* 01011: RGMII Mode Selector */
 #define BCM5482_SHD_SSD		0x14	/* 10100: Secondary SerDes control */
 #define BCM5482_SHD_SSD_LEDM	0x0008	/* SSD LED Mode enable */
-- 
2.34.1


--000000000000fc69cc05fd8e65cb
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
/D/YSkVckoN0L+QwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJ5uTuzn4eQtFz9t
e7TRFcmNl1P7wCmhQsLnLQ5b/6AeMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIzMDYwNzE4MzUyMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBq8ZZluzgROZZWX3f1M6VoYQJt+plwlEvj
ZUMAdr1uMp69dbqH0cd+yaWbmVcUhXrjligTnvFy6fRTcn90ua0q/hXDix9Cz/TN4DOmAAfifgoI
m9hI0SNbvhkq5/2OoqW7YO3wg7FukYbN1WSnviLqFVZsncbRf7z0uGTDJR0qRbZBzOuvtp+ORBuX
X+Exra7wYZvRQrEjkZyeHnR3LwKICeU19tZTNfA/x/NRFQDvgte8cvm7YIOOZsigLQaQCpGE4CkD
q4/r5b8mpGE7J+OojzWkCYNHpbldAG2+bIQZ/kG7IBk1XEd9Ne7UrtL073laE8P2/fVFbizUk8w2
x4pa
--000000000000fc69cc05fd8e65cb--

