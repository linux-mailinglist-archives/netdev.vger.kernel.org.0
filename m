Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA3727A21A
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 19:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgI0Rm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 13:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgI0Rmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 13:42:50 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88799C0613CE
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 10:42:50 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q4so2302457pjh.5
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 10:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=P3NNQhxndiBpHHna0raNzUcTuYdH3fGgnBcvKXhVY9U=;
        b=Hs2K56vPH5X7usYrDnOvFzfpJGHWR+Dri48Iap0TPRCA0NHEqKzFYIMx07XLVpEShb
         P7dgG31vqmPOU4W6Z9l7WOTXPmKguQ6FoRo2uwQ/3CDYHVnWLQDmf8yHyWKbe2mxDwk+
         D6Ym8OYXDQNNnEQ0CBSIp56SbyQ0mKsoMP/UU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=P3NNQhxndiBpHHna0raNzUcTuYdH3fGgnBcvKXhVY9U=;
        b=H6m/WI2bkvNrRP7CcIO+l7pAsHEZejvVLb3njBkPnJfaHunWXbFlitgVwiOf+VyTuJ
         as3jccWUlpvJ2zpSkoSiO4bY/qapC/w7/SohuR3fbp/Y9uYjzkUTyD+cTOnkJYnKFUy/
         ygF6tDmum1k6s+Ova2T7ykREtzMKf0vCSHHFJ9RcmVrmqE6+UKMOsJbxrlM4qPdmpdbw
         XSqFcW0uvVIDkLUJDSyYYFrFJH06vygUdYs8xzPFzJlUymBu1cBOBU3RngWyGq2//bAt
         hfYzYC2LBkMyvWZY5WUMFUJF9dTpNLYcPNJZ8BqYnRN5RiOs1yRI5BwlAwWzzC48OhFX
         N9Sw==
X-Gm-Message-State: AOAM533jkXkrUcXQ0F5gAhqmU9hNKE9D+sFcofWpe6HoNh1bYHL9Kh0A
        oyKcIQA2fTZHwzDJa1gFMfh3vw==
X-Google-Smtp-Source: ABdhPJyWtwQzFiyCp6Zy2Xq1f58xhBwcEFiZrpWPtSTA2Eb+Kyqg7d+x6nUuyoTyH0DRjE6VGDyqnQ==
X-Received: by 2002:a17:902:9b8c:b029:d2:42fe:20ea with SMTP id y12-20020a1709029b8cb02900d242fe20eamr8411696plp.0.1601228569835;
        Sun, 27 Sep 2020 10:42:49 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o19sm8765570pfp.64.2020.09.27.10.42.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Sep 2020 10:42:49 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: [PATCH net-next 04/11] bnxt_en: add basic infrastructure to support PAM4 link speeds
Date:   Sun, 27 Sep 2020 13:42:13 -0400
Message-Id: <1601228540-20852-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601228540-20852-1-git-send-email-michael.chan@broadcom.com>
References: <1601228540-20852-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000233b2305b04f14a0"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000233b2305b04f14a0

From: Edwin Peer <edwin.peer@broadcom.com>

The firmware interface has added support for new link speeds using
PAM4 modulation.  Expand the bnxt_link_info structure to closely
mirror the new firmware structures.  Add logic to copy the PAM4
capabilities and settings from the firmware.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 74 ++++++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 12 ++++
 2 files changed, 65 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 0ca4f7a78c5d..f97b3ba8fc09 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8827,6 +8827,9 @@ static int bnxt_hwrm_phy_qcaps(struct bnxt *bp)
 	if (resp->supported_speeds_auto_mode)
 		link_info->support_auto_speeds =
 			le16_to_cpu(resp->supported_speeds_auto_mode);
+	if (resp->supported_pam4_speeds_auto_mode)
+		link_info->support_pam4_auto_speeds =
+			le16_to_cpu(resp->supported_pam4_speeds_auto_mode);
 
 	bp->port_count = resp->port_cnt;
 
@@ -8849,6 +8852,7 @@ static int bnxt_update_link(struct bnxt *bp, bool chng_link_state)
 	struct hwrm_port_phy_qcfg_input req = {0};
 	struct hwrm_port_phy_qcfg_output *resp = bp->hwrm_cmd_resp_addr;
 	u8 link_up = link_info->link_up;
+	bool support_changed = false;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_PORT_PHY_QCFG, -1, -1);
 
@@ -8875,10 +8879,17 @@ static int bnxt_update_link(struct bnxt *bp, bool chng_link_state)
 	else
 		link_info->link_speed = 0;
 	link_info->force_link_speed = le16_to_cpu(resp->force_link_speed);
+	link_info->force_pam4_link_speed =
+		le16_to_cpu(resp->force_pam4_link_speed);
 	link_info->support_speeds = le16_to_cpu(resp->support_speeds);
+	link_info->support_pam4_speeds = le16_to_cpu(resp->support_pam4_speeds);
 	link_info->auto_link_speeds = le16_to_cpu(resp->auto_link_speed_mask);
+	link_info->auto_pam4_link_speeds =
+		le16_to_cpu(resp->auto_pam4_link_speed_mask);
 	link_info->lp_auto_link_speeds =
 		le16_to_cpu(resp->link_partner_adv_speeds);
+	link_info->lp_auto_pam4_link_speeds =
+		resp->link_partner_pam4_adv_speeds;
 	link_info->preemphasis = le32_to_cpu(resp->preemphasis);
 	link_info->phy_ver[0] = resp->phy_maj;
 	link_info->phy_ver[1] = resp->phy_min;
@@ -8953,9 +8964,15 @@ static int bnxt_update_link(struct bnxt *bp, bool chng_link_state)
 	if (bnxt_support_dropped(link_info->advertising,
 				 link_info->support_auto_speeds)) {
 		link_info->advertising = link_info->support_auto_speeds;
-		if (link_info->autoneg & BNXT_AUTONEG_SPEED)
-			bnxt_hwrm_set_link_setting(bp, true, false);
+		support_changed = true;
 	}
+	if (bnxt_support_dropped(link_info->advertising_pam4,
+				 link_info->support_pam4_auto_speeds)) {
+		link_info->advertising_pam4 = link_info->support_pam4_auto_speeds;
+		support_changed = true;
+	}
+	if (support_changed && (link_info->autoneg & BNXT_AUTONEG_SPEED))
+		bnxt_hwrm_set_link_setting(bp, true, false);
 	return 0;
 }
 
@@ -9014,27 +9031,30 @@ bnxt_hwrm_set_pause_common(struct bnxt *bp, struct hwrm_port_phy_cfg_input *req)
 	}
 }
 
-static void bnxt_hwrm_set_link_common(struct bnxt *bp,
-				      struct hwrm_port_phy_cfg_input *req)
+static void bnxt_hwrm_set_link_common(struct bnxt *bp, struct hwrm_port_phy_cfg_input *req)
 {
-	u8 autoneg = bp->link_info.autoneg;
-	u16 fw_link_speed = bp->link_info.req_link_speed;
-	u16 advertising = bp->link_info.advertising;
-
-	if (autoneg & BNXT_AUTONEG_SPEED) {
-		req->auto_mode |=
-			PORT_PHY_CFG_REQ_AUTO_MODE_SPEED_MASK;
-
-		req->enables |= cpu_to_le32(
-			PORT_PHY_CFG_REQ_ENABLES_AUTO_LINK_SPEED_MASK);
-		req->auto_link_speed_mask = cpu_to_le16(advertising);
-
+	if (bp->link_info.autoneg & BNXT_AUTONEG_SPEED) {
+		req->auto_mode |= PORT_PHY_CFG_REQ_AUTO_MODE_SPEED_MASK;
+		if (bp->link_info.advertising) {
+			req->enables |= cpu_to_le32(PORT_PHY_CFG_REQ_ENABLES_AUTO_LINK_SPEED_MASK);
+			req->auto_link_speed_mask = cpu_to_le16(bp->link_info.advertising);
+		}
+		if (bp->link_info.advertising_pam4) {
+			req->enables |=
+				cpu_to_le32(PORT_PHY_CFG_REQ_ENABLES_AUTO_PAM4_LINK_SPEED_MASK);
+			req->auto_link_pam4_speed_mask =
+				cpu_to_le16(bp->link_info.advertising_pam4);
+		}
 		req->enables |= cpu_to_le32(PORT_PHY_CFG_REQ_ENABLES_AUTO_MODE);
-		req->flags |=
-			cpu_to_le32(PORT_PHY_CFG_REQ_FLAGS_RESTART_AUTONEG);
+		req->flags |= cpu_to_le32(PORT_PHY_CFG_REQ_FLAGS_RESTART_AUTONEG);
 	} else {
-		req->force_link_speed = cpu_to_le16(fw_link_speed);
 		req->flags |= cpu_to_le32(PORT_PHY_CFG_REQ_FLAGS_FORCE);
+		if (bp->link_info.req_signal_mode == BNXT_SIG_MODE_PAM4) {
+			req->force_pam4_link_speed = cpu_to_le16(bp->link_info.req_link_speed);
+			req->enables |= cpu_to_le32(PORT_PHY_CFG_REQ_ENABLES_FORCE_PAM4_LINK_SPEED);
+		} else {
+			req->force_link_speed = cpu_to_le16(bp->link_info.req_link_speed);
+		}
 	}
 
 	/* tell chimp that the setting takes effect immediately */
@@ -9430,14 +9450,19 @@ static int bnxt_update_phy_setting(struct bnxt *bp)
 	if (!(link_info->autoneg & BNXT_AUTONEG_SPEED)) {
 		if (BNXT_AUTO_MODE(link_info->auto_mode))
 			update_link = true;
-		if (link_info->req_link_speed != link_info->force_link_speed)
+		if (link_info->req_signal_mode == BNXT_SIG_MODE_NRZ &&
+		    link_info->req_link_speed != link_info->force_link_speed)
+			update_link = true;
+		else if (link_info->req_signal_mode == BNXT_SIG_MODE_PAM4 &&
+			 link_info->req_link_speed != link_info->force_pam4_link_speed)
 			update_link = true;
 		if (link_info->req_duplex != link_info->duplex_setting)
 			update_link = true;
 	} else {
 		if (link_info->auto_mode == BNXT_LINK_AUTO_NONE)
 			update_link = true;
-		if (link_info->advertising != link_info->auto_link_speeds)
+		if (link_info->advertising != link_info->auto_link_speeds ||
+		    link_info->advertising_pam4 != link_info->auto_pam4_link_speeds)
 			update_link = true;
 	}
 
@@ -10697,8 +10722,15 @@ static void bnxt_init_ethtool_link_settings(struct bnxt *bp)
 			link_info->autoneg |= BNXT_AUTONEG_FLOW_CTRL;
 		}
 		link_info->advertising = link_info->auto_link_speeds;
+		link_info->advertising_pam4 = link_info->auto_pam4_link_speeds;
 	} else {
 		link_info->req_link_speed = link_info->force_link_speed;
+		link_info->req_signal_mode = BNXT_SIG_MODE_NRZ;
+		if (link_info->force_pam4_link_speed) {
+			link_info->req_link_speed =
+				link_info->force_pam4_link_speed;
+			link_info->req_signal_mode = BNXT_SIG_MODE_PAM4;
+		}
 		link_info->req_duplex = link_info->duplex_setting;
 	}
 	if (link_info->autoneg & BNXT_AUTONEG_FLOW_CTRL)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 21f2b82287a9..8ba113622425 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1188,6 +1188,7 @@ struct bnxt_link_info {
 #define BNXT_LINK_SPEED_50GB	PORT_PHY_QCFG_RESP_LINK_SPEED_50GB
 #define BNXT_LINK_SPEED_100GB	PORT_PHY_QCFG_RESP_LINK_SPEED_100GB
 	u16			support_speeds;
+	u16			support_pam4_speeds;
 	u16			auto_link_speeds;	/* fw adv setting */
 #define BNXT_LINK_SPEED_MSK_100MB PORT_PHY_QCFG_RESP_SUPPORT_SPEEDS_100MB
 #define BNXT_LINK_SPEED_MSK_1GB PORT_PHY_QCFG_RESP_SUPPORT_SPEEDS_1GB
@@ -1199,9 +1200,16 @@ struct bnxt_link_info {
 #define BNXT_LINK_SPEED_MSK_40GB PORT_PHY_QCFG_RESP_SUPPORT_SPEEDS_40GB
 #define BNXT_LINK_SPEED_MSK_50GB PORT_PHY_QCFG_RESP_SUPPORT_SPEEDS_50GB
 #define BNXT_LINK_SPEED_MSK_100GB PORT_PHY_QCFG_RESP_SUPPORT_SPEEDS_100GB
+	u16			auto_pam4_link_speeds;
+#define BNXT_LINK_PAM4_SPEED_MSK_50GB PORT_PHY_QCFG_RESP_SUPPORT_PAM4_SPEEDS_50G
+#define BNXT_LINK_PAM4_SPEED_MSK_100GB PORT_PHY_QCFG_RESP_SUPPORT_PAM4_SPEEDS_100G
+#define BNXT_LINK_PAM4_SPEED_MSK_200GB PORT_PHY_QCFG_RESP_SUPPORT_PAM4_SPEEDS_200G
 	u16			support_auto_speeds;
+	u16			support_pam4_auto_speeds;
 	u16			lp_auto_link_speeds;
+	u16			lp_auto_pam4_link_speeds;
 	u16			force_link_speed;
+	u16			force_pam4_link_speed;
 	u32			preemphasis;
 	u8			module_status;
 	u16			fec_cfg;
@@ -1213,10 +1221,14 @@ struct bnxt_link_info {
 	u8			autoneg;
 #define BNXT_AUTONEG_SPEED		1
 #define BNXT_AUTONEG_FLOW_CTRL		2
+	u8			req_signal_mode;
+#define BNXT_SIG_MODE_NRZ	PORT_PHY_QCFG_RESP_SIGNAL_MODE_NRZ
+#define BNXT_SIG_MODE_PAM4	PORT_PHY_QCFG_RESP_SIGNAL_MODE_PAM4
 	u8			req_duplex;
 	u8			req_flow_ctrl;
 	u16			req_link_speed;
 	u16			advertising;	/* user adv setting */
+	u16			advertising_pam4;
 	bool			force_link_chng;
 
 	bool			phy_retry;
-- 
2.18.1


--000000000000233b2305b04f14a0
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
DF5npqHWO504Sj4Q1TANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgVe1kipmReo/q
syxiHY/O6ha+lPTWhpapoaKOesm94HwwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjAwOTI3MTc0MjUwWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAIS/08VF5fsZ3m6EutJbSpBL+LkOR9Ph
2bDmohCxYLD9G1DmMvS9osFbwrL3hgIIV0cECpMMq4EnSTCrk0Q8vrXpOu20dvQiMawRAQ5IxZFf
gL3z33cGsQR/kAvCwu9itBc5xYm//mg9P3Lo03LsXM0pRnHx5ryT0ODsI0LKqOwxSXba/H9hXx41
he8C2OUt9qx42OEjTTjLaPPy3Jw+hbulGs0qPC83WEiX4tWdZCDkiVzp8JqXLM8PqOmGGm0pvhnK
NefCrxJS+l+AI8fnYRR2pkQn+tB28lLIDiL4d2sxSkkTCLdQxl5obM/UnIYIQvXhoZy3VQw8+AFm
sKlM+oY=
--000000000000233b2305b04f14a0--
