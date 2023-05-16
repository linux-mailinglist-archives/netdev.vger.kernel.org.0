Return-Path: <netdev+bounces-3128-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C278C705ADB
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 00:56:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC9561C20C3F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 22:56:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB6D4C8C4;
	Tue, 16 May 2023 22:56:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990F7882B
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 22:56:46 +0000 (UTC)
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21163C00
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 15:56:44 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6436e075166so41998b3a.0
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 15:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1684277804; x=1686869804;
        h=mime-version:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4w2iqCQzxSfzXI9Yrm6XV9ozcJuorVyE8xFVyxGnGfo=;
        b=RhWtdAQxUklz4SqxSlvBL/eHhBpH+zhEk5T8xt3pFuSneQpvFePozgGa6UMsy56YaI
         nIsXIxN4E5sGGLyrNaUs4/IqQ/tFIdMkzaucn/Giyf0Pifz4CYCRMG0PFcjc0dOEWENn
         lgEYHiyAXB252T6AuIGpcdR6cKQSV8wRUxC6g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684277804; x=1686869804;
        h=mime-version:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4w2iqCQzxSfzXI9Yrm6XV9ozcJuorVyE8xFVyxGnGfo=;
        b=DrzL8wTuxACOKhM9acnBVKSyN/DMd5osOKvhFfojXQjoFap+yB62U13fB/hnCc5aSC
         u3zXLKt2gAcKfJE3ilxg0GhZeljAEwi6d6PdrbR1kDW9aeGilD3GaeZUGmARt7oj7WsA
         /k8t/nmlIdcKyPozalTgLx6eJzCwReISSF67fPfWj21meocuL0otyhOez2W/yEnUdPFX
         jsafMkG7Sv10/+CX5HraluIZxvWZYsg5hMsTOqwEzZpiqeRYjXO5hz3kHTnjNdE+ngQh
         8TwJWHeJjAixxPdpxWtN9gM/lAFcAfbwA4XFZZT+FbYYTu5zi3lxeiq31ottlX38aqgR
         EkTw==
X-Gm-Message-State: AC+VfDxWGadBn4j5DXvfLNN6tHif9AK4qvuoZy41g0OPr5JajiKeFtv8
	yJzTmq6zD0dfrgxI3pSWe+cR+s1SpXRIttWsAcBrUdwrB2Tz+pbptjEjlEsdqqpkWp5Yoc8/0Kk
	tEAmIKkMHeWDHo9/aRDMKzoHrup9n+A/4l5qlRCkJV9LbPCWR25lYCUqqiJv4g0Dmfq0/1qmp3E
	BvqJig1xWxgA==
X-Google-Smtp-Source: ACHHUZ4WqAnc/jb+IoDdS7kTof7spcrI5sA+fDZNBL9n/Ibp1K9rGXvbpDSbrFpCyZweJd7w74vtuQ==
X-Received: by 2002:a05:6a00:218a:b0:640:defd:a6d5 with SMTP id h10-20020a056a00218a00b00640defda6d5mr45765652pfi.12.1684277803751;
        Tue, 16 May 2023 15:56:43 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f13-20020aa782cd000000b0062e63cdfcb6sm14340426pfn.94.2023.05.16.15.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 15:56:43 -0700 (PDT)
From: Florian Fainelli <florian.fainelli@broadcom.com>
X-Google-Original-From: Florian Fainelli <f.fainelli@gmail.com>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <florian.fainelli@broadcom.com>,
	Doug Berger <doug.berger@broadcom.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <simon.horman@corigine.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: phy: broadcom: Register dummy IRQ handler
Date: Tue, 16 May 2023 15:56:39 -0700
Message-Id: <20230516225640.2858994-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000039e6be05fbd77cbc"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MIME_NO_TEXT,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--00000000000039e6be05fbd77cbc
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <florian.fainelli@broadcom.com>

In order to have our interrupt descriptor fully setup, and in particular
the action, ensure that we register a full fledged interrupt handler.
This is in particular necessary for the kernel to properly manage early
wake-up scenarios and arm the wake-up interrupt, otherwise there would
be risks of missing the interrupt and leaving it in a state where it
would not be handled correctly at all, including for wake-up purposes.

Fixes: 8baddaa9d4ba ("net: phy: broadcom: Add support for Wake-on-LAN")
Suggested-by: Doug Berger <doug.berger@broadcom.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
---
 drivers/net/phy/bcm-phy-lib.c | 6 ++++++
 drivers/net/phy/bcm-phy-lib.h | 2 ++
 drivers/net/phy/broadcom.c    | 9 ++++++++-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
index 27c57f6ab211..5603d0a9ce96 100644
--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -1028,6 +1028,12 @@ void bcm_phy_get_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
 }
 EXPORT_SYMBOL_GPL(bcm_phy_get_wol);
 
+irqreturn_t bcm_phy_wol_isr(int irq, void *dev_id)
+{
+	return IRQ_HANDLED;
+}
+EXPORT_SYMBOL_GPL(bcm_phy_wol_isr);
+
 MODULE_DESCRIPTION("Broadcom PHY Library");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Broadcom Corporation");
diff --git a/drivers/net/phy/bcm-phy-lib.h b/drivers/net/phy/bcm-phy-lib.h
index c6fed43ec913..2f30ce0cab0e 100644
--- a/drivers/net/phy/bcm-phy-lib.h
+++ b/drivers/net/phy/bcm-phy-lib.h
@@ -8,6 +8,7 @@
 
 #include <linux/brcmphy.h>
 #include <linux/phy.h>
+#include <linux/interrupt.h>
 
 struct ethtool_wolinfo;
 
@@ -115,5 +116,6 @@ static inline void bcm_ptp_stop(struct bcm_ptp_private *priv)
 
 int bcm_phy_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol);
 void bcm_phy_get_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol);
+irqreturn_t bcm_phy_wol_isr(int irq, void *dev_id);
 
 #endif /* _LINUX_BCM_PHY_LIB_H */
diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 418e6bc0e998..822c8b01dc53 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -927,7 +927,14 @@ static int bcm54xx_phy_probe(struct phy_device *phydev)
 
 	if (!IS_ERR(wakeup_gpio)) {
 		priv->wake_irq = gpiod_to_irq(wakeup_gpio);
-		ret = irq_set_irq_type(priv->wake_irq, IRQ_TYPE_LEVEL_LOW);
+
+		/* Dummy interrupt handler which is not enabled but is provided
+		 * in order for the interrupt descriptor to be fully set-up.
+		 */
+		ret = devm_request_irq(&phydev->mdio.dev, priv->wake_irq,
+				       bcm_phy_wol_isr,
+				       IRQF_TRIGGER_LOW | IRQF_NO_AUTOEN,
+				       dev_name(&phydev->mdio.dev), phydev);
 		if (ret)
 			return ret;
 	}
-- 
2.34.1


--00000000000039e6be05fbd77cbc
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
/D/YSkVckoN0L+QwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHKNsG9ahi5X4Ap/
f0huQERImD4sBqW5XtFWT/MY36bEMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIzMDUxNjIyNTY0NFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQC2VAyrPRngOaBu+T+PIKwMzEqRccwti/NQ
daVt7ebWvPWR4IBsbp85lCwUCN51aEepvfYgvuEOYX9Xshm1HlSx9Evtan8K8ilul2LJy+bnUvs2
OxTKhpItpUjd3d9Ge5SK1JZwwSRf3yo+64xLNru/t9XbMdxS2f9jWzYGyS1Po0RUVQ0Rb8FY/jcV
fjPyTz2ipwv33ZFHdi0JScwvAgp7sPVqxoy11Nc43zsQi40nhaVs3FOjhqy7Oxb0kBK8olmGsCAg
mWWrlUcGY+Ymp9e8pr52PFIJxEldL43sy+YOhnyDW63sFBhbXKnochoR2uY/3Y+poDDhcWtOUn2y
ND/K
--00000000000039e6be05fbd77cbc--

