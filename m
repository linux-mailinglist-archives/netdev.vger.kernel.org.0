Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E0536A89F
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 19:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhDYRqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 13:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbhDYRqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 13:46:30 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9804AC061756
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 10:45:50 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id q2so5486273pfk.9
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 10:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OoIIcI3z0U3CwAZDYr4PsXNqfhgoa74h/DJ2AZ2Bpjc=;
        b=ECIELGrYfr3f24IeyUrQJEtnuK6HzPpAicC1J4k5PqlO7DymuMaSOUGY5f0NmCEdTc
         1adZPP72MvtWdY8ogVx18AH01bkDLg5i+pJdqCbI8k1PMVolqA4c0RLjzd6/nczWRc1v
         Ot0p4wkMNBplLrqZu2v2AalxjhelkcGWwrjGY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OoIIcI3z0U3CwAZDYr4PsXNqfhgoa74h/DJ2AZ2Bpjc=;
        b=FmE0qh/gQylrGzN2BUpSdXBo/E7f92Ho1yMbY5ugC2/sBiHuSmYJpZv/AO2JxxJm7R
         MERTIgJ1eBcos2zMzG8EKWkjLurHMoIhKpT20QvicMH0zf/vF5HrAnj+lH+tiWPpMhCB
         fDUTvGJ2wqBLx6lcF2L/SOOtOY1s6CViOSSNmfm292kU+nKK2igJwRq1RYyzhQ8+hp0A
         rG0lDX3QQy5xw7J/ovdYdTgwSDzlGYcLSP/8WMrj7CWYrVpP1vAc68EheIk+ugi7MVJ5
         DHJ+x0IZE06SYjc5V6E1C5BOfWW6sI+pM1v7JFyCWT6d3Qt+/AIbpswoJPSxKYWH84Pq
         HsUA==
X-Gm-Message-State: AOAM532eMJyFia+2NkxHYUfC4qohTH3zDOg2qSlmG1nX+6haxpz0XLmR
        GqtbuZ//CaIUwOfi/gw6p0RzFA==
X-Google-Smtp-Source: ABdhPJzlZzLa1M70rgq+4ZdFvtbhUuP4qNg/rV0CK+jsvjOKVtP0DLza5XlrrKvHmCdNFtCX1n6dFw==
X-Received: by 2002:a63:6f8e:: with SMTP id k136mr13747840pgc.326.1619372749723;
        Sun, 25 Apr 2021 10:45:49 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm14733553pjs.1.2021.04.25.10.45.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Apr 2021 10:45:49 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next v2 06/10] bnxt_en: Move bnxt_approve_mac().
Date:   Sun, 25 Apr 2021 13:45:23 -0400
Message-Id: <1619372727-19187-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619372727-19187-1-git-send-email-michael.chan@broadcom.com>
References: <1619372727-19187-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008c290205c0cf9903"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000008c290205c0cf9903

Move it before bnxt_update_vf_mac().  In the next patch, we need to call
bnxt_approve_mac() from bnxt_update_mac() under some conditions.  This
will avoid forward declaration.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_sriov.c   | 53 ++++++++++---------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index 67856dbf9ce9..e65093f4aa7a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -1116,6 +1116,33 @@ void bnxt_hwrm_exec_fwd_req(struct bnxt *bp)
 	}
 }
 
+int bnxt_approve_mac(struct bnxt *bp, u8 *mac, bool strict)
+{
+	struct hwrm_func_vf_cfg_input req = {0};
+	int rc = 0;
+
+	if (!BNXT_VF(bp))
+		return 0;
+
+	if (bp->hwrm_spec_code < 0x10202) {
+		if (is_valid_ether_addr(bp->vf.mac_addr))
+			rc = -EADDRNOTAVAIL;
+		goto mac_done;
+	}
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_VF_CFG, -1, -1);
+	req.enables = cpu_to_le32(FUNC_VF_CFG_REQ_ENABLES_DFLT_MAC_ADDR);
+	memcpy(req.dflt_mac_addr, mac, ETH_ALEN);
+	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+mac_done:
+	if (rc && strict) {
+		rc = -EADDRNOTAVAIL;
+		netdev_warn(bp->dev, "VF MAC address %pM not approved by the PF\n",
+			    mac);
+		return rc;
+	}
+	return 0;
+}
+
 void bnxt_update_vf_mac(struct bnxt *bp)
 {
 	struct hwrm_func_qcaps_input req = {0};
@@ -1145,32 +1172,6 @@ void bnxt_update_vf_mac(struct bnxt *bp)
 	mutex_unlock(&bp->hwrm_cmd_lock);
 }
 
-int bnxt_approve_mac(struct bnxt *bp, u8 *mac, bool strict)
-{
-	struct hwrm_func_vf_cfg_input req = {0};
-	int rc = 0;
-
-	if (!BNXT_VF(bp))
-		return 0;
-
-	if (bp->hwrm_spec_code < 0x10202) {
-		if (is_valid_ether_addr(bp->vf.mac_addr))
-			rc = -EADDRNOTAVAIL;
-		goto mac_done;
-	}
-	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_VF_CFG, -1, -1);
-	req.enables = cpu_to_le32(FUNC_VF_CFG_REQ_ENABLES_DFLT_MAC_ADDR);
-	memcpy(req.dflt_mac_addr, mac, ETH_ALEN);
-	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-mac_done:
-	if (rc && strict) {
-		rc = -EADDRNOTAVAIL;
-		netdev_warn(bp->dev, "VF MAC address %pM not approved by the PF\n",
-			    mac);
-		return rc;
-	}
-	return 0;
-}
 #else
 
 int bnxt_cfg_hw_sriov(struct bnxt *bp, int *num_vfs, bool reset)
-- 
2.18.1


--0000000000008c290205c0cf9903
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIEEWY23hhIhHq/nx8qAFzJ+au8B9OLr8
8BTg9YJaL0R7MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDQy
NTE3NDU1MFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQClwzyb9uyJN5MTusqmLuazjQ3ba7X5clW/Frv1EaRqx+OWfnlL
UuyJNL16jfic+jFjPVDzs9e9AchVbXISWJQMLedqucWoHKCCMAQ7SsDeN+0JWbNmr6cjLUKcRGHS
8advzgp/QRcSEV7M9GDTnyZHe5U5JFhdVgRA/lklRAnmhrHJ09rj8V80kIkBlayK8jz89UGfWjYc
Zwhx70qmG5mwes6weGtGxtRDpv5pYAi4vahuUAPnQfOPkjlrGyy8lq+u1qWsvSTVfuQ+0MqbvVzv
XOE0pk4CuIo95wQBj3tqdnrsTiqZtxo/ywFCbZnyWetS3jqYFurjAiEdjbWyLrLt
--0000000000008c290205c0cf9903--
