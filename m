Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D30A27A21C
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 19:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgI0Rm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 13:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgI0Rmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 13:42:52 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FEEC0613D3
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 10:42:51 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mm21so2302125pjb.4
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 10:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BTrwVidIVBjIAuME6wOs+IFAOL6/cBgnfZ2VImSxlts=;
        b=AXvuUK8lbGEOHVHPGSb/EwqTH9xn6YB59LjVA52hqb/TVYG5RJ6hm1DfJzx21B6e2K
         s8sclt8D0SGFbX2tfkX4hvNN/JscZj2tXS9YXsTlflOGFL2nl0r3rLs3+dAlSRmSX+oH
         rFEEY9aR1PfKFCtnkTdQxU221W+1ySob7juq4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BTrwVidIVBjIAuME6wOs+IFAOL6/cBgnfZ2VImSxlts=;
        b=a+DLA8ncWU86Brd/BtXqS98baJ5z1MWKNopWFcwGb68z2JrYrrs7yLC6FbiCQxkPRi
         n7CG6g2wirrbeUkTsA85IELzz5J3TtHtUMmkwlE6eW0YEhMfrhp9IsXtiov4IjheZTl+
         NC8fn68qHjK+gi5yu4Ue5S4OUY6MqhI/jCDoca/oDKL50L2HwwyMfrFYqeMfzaANmAJX
         aPgxvqrDB9ZWSN/E6SmMSNqeBH8OaiKuY/ivv32VVl9AAjBgxhVvd1ui/S1IMlGzmuLO
         StRP5FS82xPbwqLFbYn4T6GAcBrBKUr4SsRzjZYxJjVqH4eY0M52wUmHY6e4zHEmCeg5
         BQEQ==
X-Gm-Message-State: AOAM5307HBR7UEcWMwjs9iv4f/VsItKcdTO5IP80o7b9NNEX9UFJb37A
        grlEImw60/loE/unwoQwGLk8KRP4xpKPdw==
X-Google-Smtp-Source: ABdhPJxa2WJcLFxNRLafZgpQawQILyND8DOu6s5qiuciVcwa6Y7PJZFzR1ZuTxUG6B46QQ3znnconw==
X-Received: by 2002:a17:902:c14a:b029:d2:4345:72e with SMTP id 10-20020a170902c14ab02900d24345072emr8205403plj.75.1601228571201;
        Sun, 27 Sep 2020 10:42:51 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o19sm8765570pfp.64.2020.09.27.10.42.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Sep 2020 10:42:50 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: [PATCH net-next 05/11] bnxt_en: ethtool: support PAM4 link speeds up to 200G
Date:   Sun, 27 Sep 2020 13:42:14 -0400
Message-Id: <1601228540-20852-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601228540-20852-1-git-send-email-michael.chan@broadcom.com>
References: <1601228540-20852-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000037d21705b04f1428"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000037d21705b04f1428

From: Edwin Peer <edwin.peer@broadcom.com>

Add ethtool PAM4 link modes for:
        50000baseCR_Full
        100000baseCR2_Full
        200000baseCR4_Full

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 71 ++++++++++++++++---
 1 file changed, 63 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index ad6a5967ac21..2cb2495c2351 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1507,6 +1507,32 @@ u32 _bnxt_fw_to_ethtool_adv_spds(u16 fw_speeds, u8 fw_pause)
 		(fw_speeds) |= BNXT_LINK_SPEED_MSK_100GB;		\
 }
 
+#define BNXT_FW_TO_ETHTOOL_PAM4_SPDS(fw_speeds, lk_ksettings, name)	\
+{									\
+	if ((fw_speeds) & BNXT_LINK_PAM4_SPEED_MSK_50GB)		\
+		ethtool_link_ksettings_add_link_mode(lk_ksettings, name,\
+						     50000baseCR_Full);	\
+	if ((fw_speeds) & BNXT_LINK_PAM4_SPEED_MSK_100GB)		\
+		ethtool_link_ksettings_add_link_mode(lk_ksettings, name,\
+						     100000baseCR2_Full);\
+	if ((fw_speeds) & BNXT_LINK_PAM4_SPEED_MSK_200GB)		\
+		ethtool_link_ksettings_add_link_mode(lk_ksettings, name,\
+						     200000baseCR4_Full);\
+}
+
+#define BNXT_ETHTOOL_TO_FW_PAM4_SPDS(fw_speeds, lk_ksettings, name)	\
+{									\
+	if (ethtool_link_ksettings_test_link_mode(lk_ksettings, name,	\
+						  50000baseCR_Full))	\
+		(fw_speeds) |= BNXT_LINK_PAM4_SPEED_MSK_50GB;		\
+	if (ethtool_link_ksettings_test_link_mode(lk_ksettings, name,	\
+						  100000baseCR2_Full))	\
+		(fw_speeds) |= BNXT_LINK_PAM4_SPEED_MSK_100GB;		\
+	if (ethtool_link_ksettings_test_link_mode(lk_ksettings, name,	\
+						  200000baseCR4_Full))	\
+		(fw_speeds) |= BNXT_LINK_PAM4_SPEED_MSK_200GB;		\
+}
+
 static void bnxt_fw_to_ethtool_advertised_spds(struct bnxt_link_info *link_info,
 				struct ethtool_link_ksettings *lk_ksettings)
 {
@@ -1517,6 +1543,8 @@ static void bnxt_fw_to_ethtool_advertised_spds(struct bnxt_link_info *link_info,
 		fw_pause = link_info->auto_pause_setting;
 
 	BNXT_FW_TO_ETHTOOL_SPDS(fw_speeds, fw_pause, lk_ksettings, advertising);
+	fw_speeds = link_info->advertising_pam4;
+	BNXT_FW_TO_ETHTOOL_PAM4_SPDS(fw_speeds, lk_ksettings, advertising);
 }
 
 static void bnxt_fw_to_ethtool_lp_adv(struct bnxt_link_info *link_info,
@@ -1530,6 +1558,8 @@ static void bnxt_fw_to_ethtool_lp_adv(struct bnxt_link_info *link_info,
 
 	BNXT_FW_TO_ETHTOOL_SPDS(fw_speeds, fw_pause, lk_ksettings,
 				lp_advertising);
+	fw_speeds = link_info->lp_auto_pam4_link_speeds;
+	BNXT_FW_TO_ETHTOOL_PAM4_SPDS(fw_speeds, lk_ksettings, lp_advertising);
 }
 
 static void bnxt_fw_to_ethtool_support_spds(struct bnxt_link_info *link_info,
@@ -1538,12 +1568,15 @@ static void bnxt_fw_to_ethtool_support_spds(struct bnxt_link_info *link_info,
 	u16 fw_speeds = link_info->support_speeds;
 
 	BNXT_FW_TO_ETHTOOL_SPDS(fw_speeds, 0, lk_ksettings, supported);
+	fw_speeds = link_info->support_pam4_speeds;
+	BNXT_FW_TO_ETHTOOL_PAM4_SPDS(fw_speeds, lk_ksettings, supported);
 
 	ethtool_link_ksettings_add_link_mode(lk_ksettings, supported, Pause);
 	ethtool_link_ksettings_add_link_mode(lk_ksettings, supported,
 					     Asym_Pause);
 
-	if (link_info->support_auto_speeds)
+	if (link_info->support_auto_speeds ||
+	    link_info->support_pam4_auto_speeds)
 		ethtool_link_ksettings_add_link_mode(lk_ksettings, supported,
 						     Autoneg);
 }
@@ -1640,7 +1673,9 @@ static int bnxt_force_link_speed(struct net_device *dev, u32 ethtool_speed)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	struct bnxt_link_info *link_info = &bp->link_info;
+	u16 support_pam4_spds = link_info->support_pam4_speeds;
 	u16 support_spds = link_info->support_speeds;
+	u8 sig_mode = BNXT_SIG_MODE_NRZ;
 	u16 fw_speed = 0;
 
 	switch (ethtool_speed) {
@@ -1673,12 +1708,26 @@ static int bnxt_force_link_speed(struct net_device *dev, u32 ethtool_speed)
 			fw_speed = PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_40GB;
 		break;
 	case SPEED_50000:
-		if (support_spds & BNXT_LINK_SPEED_MSK_50GB)
+		if (support_spds & BNXT_LINK_SPEED_MSK_50GB) {
 			fw_speed = PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_50GB;
+		} else if (support_pam4_spds & BNXT_LINK_PAM4_SPEED_MSK_50GB) {
+			fw_speed = PORT_PHY_CFG_REQ_FORCE_PAM4_LINK_SPEED_50GB;
+			sig_mode = BNXT_SIG_MODE_PAM4;
+		}
 		break;
 	case SPEED_100000:
-		if (support_spds & BNXT_LINK_SPEED_MSK_100GB)
+		if (support_spds & BNXT_LINK_SPEED_MSK_100GB) {
 			fw_speed = PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_100GB;
+		} else if (support_pam4_spds & BNXT_LINK_PAM4_SPEED_MSK_100GB) {
+			fw_speed = PORT_PHY_CFG_REQ_FORCE_PAM4_LINK_SPEED_100GB;
+			sig_mode = BNXT_SIG_MODE_PAM4;
+		}
+		break;
+	case SPEED_200000:
+		if (support_pam4_spds & BNXT_LINK_PAM4_SPEED_MSK_200GB) {
+			fw_speed = PORT_PHY_CFG_REQ_FORCE_PAM4_LINK_SPEED_200GB;
+			sig_mode = BNXT_SIG_MODE_PAM4;
+		}
 		break;
 	}
 
@@ -1688,9 +1737,11 @@ static int bnxt_force_link_speed(struct net_device *dev, u32 ethtool_speed)
 	}
 
 	link_info->req_link_speed = fw_speed;
+	link_info->req_signal_mode = sig_mode;
 	link_info->req_duplex = BNXT_LINK_DUPLEX_FULL;
 	link_info->autoneg = 0;
 	link_info->advertising = 0;
+	link_info->advertising_pam4 = 0;
 
 	return 0;
 }
@@ -1724,7 +1775,6 @@ static int bnxt_set_link_ksettings(struct net_device *dev,
 	struct bnxt_link_info *link_info = &bp->link_info;
 	const struct ethtool_link_settings *base = &lk_ksettings->base;
 	bool set_pause = false;
-	u16 fw_advertising = 0;
 	u32 speed;
 	int rc = 0;
 
@@ -1733,13 +1783,18 @@ static int bnxt_set_link_ksettings(struct net_device *dev,
 
 	mutex_lock(&bp->link_lock);
 	if (base->autoneg == AUTONEG_ENABLE) {
-		BNXT_ETHTOOL_TO_FW_SPDS(fw_advertising, lk_ksettings,
+		link_info->advertising = 0;
+		link_info->advertising_pam4 = 0;
+		BNXT_ETHTOOL_TO_FW_SPDS(link_info->advertising, lk_ksettings,
 					advertising);
+		BNXT_ETHTOOL_TO_FW_PAM4_SPDS(link_info->advertising_pam4,
+					     lk_ksettings, advertising);
 		link_info->autoneg |= BNXT_AUTONEG_SPEED;
-		if (!fw_advertising)
+		if (!link_info->advertising && !link_info->advertising_pam4) {
 			link_info->advertising = link_info->support_auto_speeds;
-		else
-			link_info->advertising = fw_advertising;
+			link_info->advertising_pam4 =
+				link_info->support_pam4_auto_speeds;
+		}
 		/* any change to autoneg will cause link change, therefore the
 		 * driver should put back the original pause setting in autoneg
 		 */
-- 
2.18.1


--00000000000037d21705b04f1428
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ENt96uQJNu/QKZCsRxnu8bu9XkzIQTTFs7+NKghvf+h9ck5SSEvV5vlzS8HDlhKReyLBOxx5AgMB
AAGjggHQMIIBzDAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsGAQUFBwEBBIGRMIGOME0GCCsGAQUFBzAC
hkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc3BlcnNvbmFsc2lnbjJzaGEy
ZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL2dzcGVy
c29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYm
aHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBEBgNVHR8E
PTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWduMnNoYTJn
My5jcmwwJAYDVR0RBB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUyZbpLEwR
KZHEh+rXp6GbCZmMEwUwDQYJKoZIhvcNAQELBQADggEBADZsABrJEwqeVLJJcX+rKN/oFPl/Sb1f
4NQRqf0J5IHlqI7oSUUaSVHviPvq4QyTMh7P9KHkuTwANTnTPr4f4y1SirdtxgZKy1xDmt1KjL5u
nA4rBLSA+Kp/mo0DMxKKQY/LsZNS3Zn+HIAZpXTUEFotC5qgN35ua7sP0hTynKzfLG8Fi565tQkX
Si7Gzq+VM1jcLa3+kjHalTIlC7q7gkvVhgEwmztW1SuO7pJn0/GOncxYGQXEk3PIH3QbPNO8VMkx
3YeEtbaXosR5XLWchobv9S5HB9h4t0TUbZh2kX0HlGzgFLCPif27aL7ZpahFcoCS928kT+/V4tAj
BB+IwnkxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMC
DF5npqHWO504Sj4Q1TANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgH1w7LTPnmt/w
xm64kA6fPgKB8oU5SEKZxPBY/ZNcgb8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjAwOTI3MTc0MjUxWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAGtjy1nleUo3cmo0WNcTcQuEwMmB2+z6
O+CJnajvQL/vAnm4WUwNyuSqKh1kjJIc8BNPUdW6TYWYGmSCS7kT2os23bJZM0Ol0o0dkzG2TgO+
L3DXNBAVCr3dbF3pPxAhz/CtamPZzBgFiM2JsrwtGXQb1d2Y6+c28bwnRjgmhQ4u7ia8shpW8Twi
zSiTgyAVWGamXN0QlA0/GxWiWQ06QVEkASKI+Lhv57cKCFZl9yJYhPB5SlBFi5Wr6JdJAM/iIgOZ
F9oCDM8xch0TpZNJ+w+Aqa0X7MACRMIto1tgCSe9eJ5RavOYdj6xOltoqqYNIxhnxusl5RDjJtas
7uf5ht0=
--00000000000037d21705b04f1428--
