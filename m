Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF1554CE3B7
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 09:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiCEI4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 03:56:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiCEIz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 03:55:56 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5549B254A94
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 00:55:07 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id v4so9217143pjh.2
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 00:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ONfaY1y7JV9ykUjb/mTdKQErQlaDTAgMAWo9KN+tU1w=;
        b=SSFuNtNXarfRSPDPS7PnGtNIPZfggdL56AI62smh/G3Bmci+6Hk4tabyoPAMPdXHzo
         ykMD9+NMFOmAKJdfl2eCraSqHveWyUjWDrulfHnVaSsH3h1YV/XdtsONk/i+F4rxBosB
         QDCzo54Oa5mBIQb4w6e4Es5KXtnaLxoEs5wWU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ONfaY1y7JV9ykUjb/mTdKQErQlaDTAgMAWo9KN+tU1w=;
        b=46Rz85DTIqt9fD+np4EH5O+yXCdvIF1TjFAj2KaXhodp52cCbBiHoV5+WcU0Ctr7PS
         0V8NBkVHiJVaMI177228MpHN/a4LT60baa95MIj1NNIVA7p/+s1kKFjZk2HX7oid+0lK
         AVKp7rYW9pHOrLzIgVghfNp4oK1mvTHSRvEi64N9WQfMEf/KDWj/LRshJ4MyPoL9jpB5
         X3oIv/Jk5LJM+lgdVnUl7e0mmjRvIHA31xCQHdKoWW+x5KzBUS95GGJ2M761GsQC1//8
         fOUWhHWkLWwFyxzZaT9LspZ7xhT0J9l5HE8IBPzeEp00UsYVZtpBcz9RhlfCefCNfU81
         q50A==
X-Gm-Message-State: AOAM53298vGeaQfzK+MKgV13vBFi3jMBFS6KTCuUlGfa/Tln5535vhgZ
        X7YFR40DZCvC9+69sTDXnFBsNQ==
X-Google-Smtp-Source: ABdhPJx1Aia0JDW+EVo8MtjYZ8Z0d1vl/rvv+iN0h7PFnO3sDKGUeN5rXfnA8ZR0t6ZWsPT6S2ZxQQ==
X-Received: by 2002:a17:903:22cb:b0:151:9f41:8738 with SMTP id y11-20020a17090322cb00b001519f418738mr2729205plg.46.1646470506290;
        Sat, 05 Mar 2022 00:55:06 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p28-20020a056a000a1c00b004f6519e61b7sm9213261pfh.21.2022.03.05.00.55.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Mar 2022 00:55:05 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 4/9] bnxt_en: introduce initial link state of unknown
Date:   Sat,  5 Mar 2022 03:54:37 -0500
Message-Id: <1646470482-13763-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1646470482-13763-1-git-send-email-michael.chan@broadcom.com>
References: <1646470482-13763-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000b45a4405d974c9a4"
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000b45a4405d974c9a4

From: Edwin Peer <edwin.peer@broadcom.com>

This will force link state to always be logged for initial NIC open.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 33 ++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  6 +++-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  4 +--
 3 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 37facef47846..1ed71b6fed8a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9300,7 +9300,7 @@ void bnxt_tx_enable(struct bnxt *bp)
 	/* Make sure napi polls see @dev_state change */
 	synchronize_net();
 	netif_tx_wake_all_queues(bp->dev);
-	if (bp->link_info.link_up)
+	if (BNXT_LINK_IS_UP(bp))
 		netif_carrier_on(bp->dev);
 }
 
@@ -9330,7 +9330,7 @@ static char *bnxt_report_fec(struct bnxt_link_info *link_info)
 
 void bnxt_report_link(struct bnxt *bp)
 {
-	if (bp->link_info.link_up) {
+	if (BNXT_LINK_IS_UP(bp)) {
 		const char *signal = "";
 		const char *flow_ctrl;
 		const char *duplex;
@@ -9466,7 +9466,7 @@ int bnxt_update_link(struct bnxt *bp, bool chng_link_state)
 	struct bnxt_link_info *link_info = &bp->link_info;
 	struct hwrm_port_phy_qcfg_output *resp;
 	struct hwrm_port_phy_qcfg_input *req;
-	u8 link_up = link_info->link_up;
+	u8 link_state = link_info->link_state;
 	bool support_changed = false;
 	int rc;
 
@@ -9567,14 +9567,14 @@ int bnxt_update_link(struct bnxt *bp, bool chng_link_state)
 	/* TODO: need to add more logic to report VF link */
 	if (chng_link_state) {
 		if (link_info->phy_link_status == BNXT_LINK_LINK)
-			link_info->link_up = 1;
+			link_info->link_state = BNXT_LINK_STATE_UP;
 		else
-			link_info->link_up = 0;
-		if (link_up != link_info->link_up)
+			link_info->link_state = BNXT_LINK_STATE_DOWN;
+		if (link_state != link_info->link_state)
 			bnxt_report_link(bp);
 	} else {
-		/* alwasy link down if not require to update link state */
-		link_info->link_up = 0;
+		/* always link down if not require to update link state */
+		link_info->link_state = BNXT_LINK_STATE_DOWN;
 	}
 	hwrm_req_drop(bp, req);
 
@@ -9774,7 +9774,18 @@ static int bnxt_hwrm_shutdown_link(struct bnxt *bp)
 		return rc;
 
 	req->flags = cpu_to_le32(PORT_PHY_CFG_REQ_FLAGS_FORCE_LINK_DWN);
-	return hwrm_req_send(bp, req);
+	rc = hwrm_req_send(bp, req);
+	if (!rc) {
+		mutex_lock(&bp->link_lock);
+		/* Device is not obliged link down in certain scenarios, even
+		 * when forced. Setting the state unknown is consistent with
+		 * driver startup and will force link state to be reported
+		 * during subsequent open based on PORT_PHY_QCFG.
+		 */
+		bp->link_info.link_state = BNXT_LINK_STATE_UNKNOWN;
+		mutex_unlock(&bp->link_lock);
+	}
+	return rc;
 }
 
 static int bnxt_fw_reset_via_optee(struct bnxt *bp)
@@ -10205,7 +10216,7 @@ static int bnxt_update_phy_setting(struct bnxt *bp)
 	/* The last close may have shutdown the link, so need to call
 	 * PHY_CFG to bring it back up.
 	 */
-	if (!bp->link_info.link_up)
+	if (!BNXT_LINK_IS_UP(bp))
 		update_link = true;
 
 	if (!bnxt_eee_config_ok(bp))
@@ -11437,7 +11448,7 @@ static void bnxt_timer(struct timer_list *t)
 	if (bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY)
 		bnxt_fw_health_check(bp);
 
-	if (bp->link_info.link_up && bp->stats_coal_ticks) {
+	if (BNXT_LINK_IS_UP(bp) && bp->stats_coal_ticks) {
 		set_bit(BNXT_PERIODIC_STATS_SP_EVENT, &bp->sp_event);
 		bnxt_queue_sp_work(bp);
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 802ec1e9956d..5d743976cb35 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1175,7 +1175,11 @@ struct bnxt_link_info {
 #define BNXT_PHY_STATE_ENABLED		0
 #define BNXT_PHY_STATE_DISABLED		1
 
-	u8			link_up;
+	u8			link_state;
+#define BNXT_LINK_STATE_UNKNOWN	0
+#define BNXT_LINK_STATE_DOWN	1
+#define BNXT_LINK_STATE_UP	2
+#define BNXT_LINK_IS_UP(bp)	((bp)->link_info.link_state == BNXT_LINK_STATE_UP)
 	u8			duplex;
 #define BNXT_LINK_DUPLEX_HALF	PORT_PHY_QCFG_RESP_DUPLEX_STATE_HALF
 #define BNXT_LINK_DUPLEX_FULL	PORT_PHY_QCFG_RESP_DUPLEX_STATE_FULL
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 3927ceb581da..519edad70f16 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2135,7 +2135,7 @@ static u32 bnxt_get_link(struct net_device *dev)
 	struct bnxt *bp = netdev_priv(dev);
 
 	/* TODO: handle MF, VF, driver close case */
-	return bp->link_info.link_up;
+	return BNXT_LINK_IS_UP(bp);
 }
 
 int bnxt_hwrm_nvm_get_dev_info(struct bnxt *bp,
@@ -3383,7 +3383,7 @@ static int bnxt_disable_an_for_lpbk(struct bnxt *bp,
 		return rc;
 
 	fw_speed = PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_1GB;
-	if (bp->link_info.link_up)
+	if (BNXT_LINK_IS_UP(bp))
 		fw_speed = bp->link_info.link_speed;
 	else if (fw_advertising & BNXT_LINK_SPEED_MSK_10GB)
 		fw_speed = PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_10GB;
-- 
2.18.1


--000000000000b45a4405d974c9a4
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIBswgYCgUs81+oCtCqY6N4NrHDhvGJwK
BaKDGVT4zdSUMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMw
NTA4NTUwN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCj5ox/9RZUnAU2XEq4Jj3Zypc/vhs97B2ONpNfoqBRXUnRekWT
mT+Cny9pmxLiSqMLdg5WPwmuSCIF38wI2FA9yLvYu7ZwtPil1I47G07AOG9pSPdpjAbHjozmhFNH
Me3t51oaG3PAA74+lMkBeSsMR/Xkzy1rjAVinqjgNC9UIJ9FaFKdvgAHk1d8YI5zvQEZsInxxipi
ANDEJvyifD9QspSJrRZJGc9p+XedTWXeYE/+S2FVk1PgXjiEmVSCteejuasm8odgf4UkqcRjsfYS
9zIPz5R2EcnND91DqFCO6VFRRlhM0PBNNAqrY3Btfjq4qS1il2Usx9jw3Rx8roqk
--000000000000b45a4405d974c9a4--
