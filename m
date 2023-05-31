Return-Path: <netdev+bounces-6947-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BD9D0718F00
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 01:17:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 132661C20F8F
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 23:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82DE74077A;
	Wed, 31 May 2023 23:17:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C0318C3B
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 23:17:45 +0000 (UTC)
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E73512B
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 16:17:43 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id 6a1803df08f44-5ed99ebe076so3445906d6.2
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 16:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1685575061; x=1688167061;
        h=mime-version:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aUonyLPu3YJU3XbzrJgT5gjhvSnZcuCAmhSI8TzMarA=;
        b=eVn7kDDtUHsJW3ZKsBNLUmR5kPLb4ec+3TUpSLKABq8UjiedJjBmUrIeAR24I423Kk
         1GxfY7B0p4YdEr93Ren4SzaogwdKPS9aIK5vMBRmsaNnNWFiTjIQANaLBXIAfKOo694m
         /ufKCcCfh7YALESpXwLgqQ/pP6aNP5clK0W1M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685575061; x=1688167061;
        h=mime-version:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aUonyLPu3YJU3XbzrJgT5gjhvSnZcuCAmhSI8TzMarA=;
        b=e9/F2eLrLk87FOzATfjAGD3Kweig99E0NzsoQIuk3fQrdHZxAYU3RuZPifrMhsQD8+
         R1zOg4GPZhvuiWexthy/8F7SUNrYCw2jEu9BViy+FehbF+uaqkkWKU1mLwyYxo1RcKFH
         w3sXhmDLTcbJG98LqleoOOvTxEHeGMCPDYaSaK4ISvFjPYL7QHLdoBd47fbPeTgaKCq+
         oSpoi8wK9UkoJCGgpwVq2QJB5z1IifvTlV7zVeAYJh7y8PVVcf/0VqwcCJuC1Uias6wK
         BW41Ytbv/t3760fwr/VDo/5OxY92dNHzlxKczh2WUuLq2x43tV7tnFAhRpOvq5FTiv/e
         Q3jg==
X-Gm-Message-State: AC+VfDygnuAqSJDRpzUxajwstqmofNZjTFd1sa73WIFAZNENjNfpYBV1
	7/yjGXFyiNdqHnZ8YTM4zthxTpTvyP4jcGXIQiUFoTbK+0mkn/YSWmxwcYqqy/+EZdZyPRvYRqT
	yBKVntOzkLXLj2r/jo1laz+lc3VdsT2BkbioD5rNWfil7j3zJ5F8JihlM1gJ756f9VPXjMlZs9k
	E6n1KX/+KJ8Q==
X-Google-Smtp-Source: ACHHUZ4v8BvRZ9BbOZOpc8ntSkjNkfjpV+9oejGtrcgtaFfB/jq18PhjwddnwDfvccIrWjOLMHzXiA==
X-Received: by 2002:a05:6214:d87:b0:621:7d4:e059 with SMTP id e7-20020a0562140d8700b0062107d4e059mr7460996qve.10.1685575061540;
        Wed, 31 May 2023 16:17:41 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c8-20020a0cfb08000000b00627a6fd04ddsm1551795qvp.122.2023.05.31.16.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 16:17:39 -0700 (PDT)
From: Florian Fainelli <florian.fainelli@broadcom.com>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <florian.fainelli@broadcom.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: phy: broadcom: Add LPI counter
Date: Wed, 31 May 2023 16:17:29 -0700
Message-Id: <20230531231729.1873932-1-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000ceecfd05fd0586c5"
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MIME_NO_TEXT,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--000000000000ceecfd05fd0586c5
Content-Transfer-Encoding: 8bit

Add the ability to read the PHY maintained LPI counter which is in the
Clause 45 vendor space, device address 7, offset 0x803F. The counter is
cleared on read.

Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
---
 drivers/net/phy/bcm-phy-lib.c | 19 ++++++++++++-------
 include/linux/brcmphy.h       |  2 ++
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
index 5603d0a9ce96..c6e2e5f636d4 100644
--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -496,18 +496,20 @@ EXPORT_SYMBOL_GPL(bcm_phy_downshift_set);
 
 struct bcm_phy_hw_stat {
 	const char *string;
-	u8 reg;
+	int devad;
+	u16 reg;
 	u8 shift;
 	u8 bits;
 };
 
 /* Counters freeze at either 0xffff or 0xff, better than nothing */
 static const struct bcm_phy_hw_stat bcm_phy_hw_stats[] = {
-	{ "phy_receive_errors", MII_BRCM_CORE_BASE12, 0, 16 },
-	{ "phy_serdes_ber_errors", MII_BRCM_CORE_BASE13, 8, 8 },
-	{ "phy_false_carrier_sense_errors", MII_BRCM_CORE_BASE13, 0, 8 },
-	{ "phy_local_rcvr_nok", MII_BRCM_CORE_BASE14, 8, 8 },
-	{ "phy_remote_rcv_nok", MII_BRCM_CORE_BASE14, 0, 8 },
+	{ "phy_receive_errors", -1, MII_BRCM_CORE_BASE12, 0, 16 },
+	{ "phy_serdes_ber_errors", -1, MII_BRCM_CORE_BASE13, 8, 8 },
+	{ "phy_false_carrier_sense_errors", -1, MII_BRCM_CORE_BASE13, 0, 8 },
+	{ "phy_local_rcvr_nok", -1, MII_BRCM_CORE_BASE14, 8, 8 },
+	{ "phy_remote_rcv_nok", -1, MII_BRCM_CORE_BASE14, 0, 8 },
+	{ "phy_lpi_count", MDIO_MMD_AN, BRCM_CL45VEN_EEE_LPI_CNT, 0, 16 },
 };
 
 int bcm_phy_get_sset_count(struct phy_device *phydev)
@@ -536,7 +538,10 @@ static u64 bcm_phy_get_stat(struct phy_device *phydev, u64 *shadow,
 	int val;
 	u64 ret;
 
-	val = phy_read(phydev, stat.reg);
+	if (stat.devad < 0)
+		val = phy_read(phydev, stat.reg);
+	else
+		val = phy_read_mmd(phydev, stat.devad, stat.reg);
 	if (val < 0) {
 		ret = U64_MAX;
 	} else {
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index e9afbfb6d7a5..251833ab271f 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -359,6 +359,8 @@
 #define LPI_FEATURE_EN			0x8000
 #define LPI_FEATURE_EN_DIG1000X		0x4000
 
+#define BRCM_CL45VEN_EEE_LPI_CNT	0x803f
+
 /* Core register definitions*/
 #define MII_BRCM_CORE_BASE12	0x12
 #define MII_BRCM_CORE_BASE13	0x13
-- 
2.34.1


--000000000000ceecfd05fd0586c5
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
/D/YSkVckoN0L+QwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIgl7mGA7yNUVDU/
A0XEdq3oUf+qjAVbC5GFUe82bjILMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIzMDUzMTIzMTc0MVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQDff+5S8dHXTHGhXtAss0VbhIj5Ld5XY2El
JfTfReGMvQAPDF6sEklg1RqX+sV5u4mtv/SrhuVcWUlI+MVWWZGAz/0KNbdUbfw3Mce1lKAzlnIa
L478xpC8Oid/ncLDbXnUh38aLt2w+UB+yZz8S68BuC3J/GQ99Z2AtfreA0AxbDg1YK1W9gugoTSH
5sVJo4XplLtG5pbf1v8g/AVrFFe9danx6NplJpk6KwraPMwuRFJ+NWDRV/Vff5PePUUp9zl5aUam
F13RY2hBXxi5M47RJ3zN8Pi+UJ9WEK8LhhvWVwxuttTcxh+oqyDywqnID6ILkl14+IzKke+DHNWc
3gfl
--000000000000ceecfd05fd0586c5--

