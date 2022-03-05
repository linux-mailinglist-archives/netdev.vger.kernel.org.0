Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF8F4CE3BA
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 09:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiCEI4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 03:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiCEI4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 03:56:04 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A97255509
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 00:55:10 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id a5so9578832pfv.9
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 00:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Z/HgDuc364ySKXYOWhh7f+ayeLSSoP7piIi4XMOTYqg=;
        b=AUC+4O7ZEHa/olvD/fWTlqXzYIoCkKmpIRYkP9UzyY3jSNTXdxqeZF5BFukYjLufE9
         bZO/g2jefqBuxPz936h2kaK1bEmOwCC7O7W6h/Xa13dsqf0HJKot08ctXRdg3NHljFQe
         l+acMjzYu3vo0IL6pooEIfS9QKurWBO76fANI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Z/HgDuc364ySKXYOWhh7f+ayeLSSoP7piIi4XMOTYqg=;
        b=Ivp8IjKlvnABs66SqMrXa5qOHnjjiuLNfr4TJPp9rRu7LDHiqrMK6TuUlP/AIUFPlt
         6P7Y+dYn+ewnVdcNt7B6qBB7IlJN1u95PglQEFCVk8Ypi3+ZJEWc67dqJzC3xaXiOBI/
         aRKty3RaeY5UKaC/zCNisB0LOcdd11RLZJm/W+I9cScM4qEoRxzSextKpHReGPqBDPhO
         PNF7ljUm0ngq6CHvdNDVMgsafgXnyPx6qlQZS+byoDQ7R8FRgAd9muad/vrJLR3bPBbI
         4rpzT78WzurDqayp2FErU5GxNMFLaUob0mnnzsJSDu/ZDt58/zzpA+g+RtI5g4N5038c
         Glqw==
X-Gm-Message-State: AOAM532qzYlz9kW99LptBir3LwSHAlKwnlOUqTVWp0KW5OsyFzO3tt7h
        VyNthOH2WUEjOYfi7qOgBdoP+Q==
X-Google-Smtp-Source: ABdhPJz1HELyUd7h9fFJC62M91HlYHmYRmj6BkGqDaItdxmaGjV/azdAYNS444/zSSMjEXCpJdA2ig==
X-Received: by 2002:aa7:8d42:0:b0:4bd:265:def4 with SMTP id s2-20020aa78d42000000b004bd0265def4mr2939023pfe.24.1646470509358;
        Sat, 05 Mar 2022 00:55:09 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p28-20020a056a000a1c00b004f6519e61b7sm9213261pfh.21.2022.03.05.00.55.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Mar 2022 00:55:08 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 7/9] bnxt_en: Do not destroy health reporters during reset
Date:   Sat,  5 Mar 2022 03:54:40 -0500
Message-Id: <1646470482-13763-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1646470482-13763-1-git-send-email-michael.chan@broadcom.com>
References: <1646470482-13763-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000def5ff05d974c961"
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

--000000000000def5ff05d974c961

From: Edwin Peer <edwin.peer@broadcom.com>

Health reporter state should be maintained over resets. Previously
reporters were destroyed if the device capabilities changed, but
since none of the reporters depend on capabilities anymore, this
logic should be removed.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  7 +--
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 44 +++++++++----------
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.h |  2 +-
 3 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 2280b189f3d6..2de02950086f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12149,11 +12149,6 @@ int bnxt_fw_init_one(struct bnxt *bp)
 	if (rc)
 		return rc;
 
-	/* In case fw capabilities have changed, destroy the unneeded
-	 * reporters and create newly capable ones.
-	 */
-	bnxt_dl_fw_reporters_destroy(bp, false);
-	bnxt_dl_fw_reporters_create(bp);
 	bnxt_fw_init_one_p3(bp);
 	return 0;
 }
@@ -12982,7 +12977,7 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	cancel_delayed_work_sync(&bp->fw_reset_task);
 	bp->sp_event = 0;
 
-	bnxt_dl_fw_reporters_destroy(bp, true);
+	bnxt_dl_fw_reporters_destroy(bp);
 	bnxt_dl_unregister(bp);
 	bnxt_shutdown_tc(bp);
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index f6e21fac0e69..0c17f90d44a2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -241,37 +241,37 @@ static const struct devlink_health_reporter_ops bnxt_dl_fw_reporter_ops = {
 	.recover = bnxt_fw_recover,
 };
 
-void bnxt_dl_fw_reporters_create(struct bnxt *bp)
+static struct devlink_health_reporter *
+__bnxt_dl_reporter_create(struct bnxt *bp,
+			  const struct devlink_health_reporter_ops *ops)
 {
-	struct bnxt_fw_health *health = bp->fw_health;
-
-	if (!health || health->fw_reporter)
-		return;
+	struct devlink_health_reporter *reporter;
 
-	health->fw_reporter =
-		devlink_health_reporter_create(bp->dl, &bnxt_dl_fw_reporter_ops,
-					       0, bp);
-	if (IS_ERR(health->fw_reporter)) {
-		netdev_warn(bp->dev, "Failed to create FW health reporter, rc = %ld\n",
-			    PTR_ERR(health->fw_reporter));
-		health->fw_reporter = NULL;
-		bp->fw_cap &= ~BNXT_FW_CAP_ERROR_RECOVERY;
+	reporter = devlink_health_reporter_create(bp->dl, ops, 0, bp);
+	if (IS_ERR(reporter)) {
+		netdev_warn(bp->dev, "Failed to create %s health reporter, rc = %ld\n",
+			    ops->name, PTR_ERR(reporter));
+		return NULL;
 	}
+
+	return reporter;
 }
 
-void bnxt_dl_fw_reporters_destroy(struct bnxt *bp, bool all)
+void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 {
-	struct bnxt_fw_health *health = bp->fw_health;
+	struct bnxt_fw_health *fw_health = bp->fw_health;
 
-	if (!health)
-		return;
+	if (fw_health && !fw_health->fw_reporter)
+		fw_health->fw_reporter = __bnxt_dl_reporter_create(bp, &bnxt_dl_fw_reporter_ops);
+}
 
-	if ((bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY) && !all)
-		return;
+void bnxt_dl_fw_reporters_destroy(struct bnxt *bp)
+{
+	struct bnxt_fw_health *fw_health = bp->fw_health;
 
-	if (health->fw_reporter) {
-		devlink_health_reporter_destroy(health->fw_reporter);
-		health->fw_reporter = NULL;
+	if (fw_health && fw_health->fw_reporter) {
+		devlink_health_reporter_destroy(fw_health->fw_reporter);
+		fw_health->fw_reporter = NULL;
 	}
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
index a715458abc30..b8105065367b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -75,7 +75,7 @@ void bnxt_devlink_health_fw_report(struct bnxt *bp);
 void bnxt_dl_health_fw_status_update(struct bnxt *bp, bool healthy);
 void bnxt_dl_health_fw_recovery_done(struct bnxt *bp);
 void bnxt_dl_fw_reporters_create(struct bnxt *bp);
-void bnxt_dl_fw_reporters_destroy(struct bnxt *bp, bool all);
+void bnxt_dl_fw_reporters_destroy(struct bnxt *bp);
 int bnxt_dl_register(struct bnxt *bp);
 void bnxt_dl_unregister(struct bnxt *bp);
 
-- 
2.18.1


--000000000000def5ff05d974c961
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEII7/lHQGhpnv4Q/90tvvAjNJMNulC89S
RikYH3r0HavSMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMw
NTA4NTUwOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQC41EEDn4yAWTl3C6Lr2zFgS6t8X/NL7pGn+j7baeoKuL90A9PI
Kkev3E50v9t+1y44PQHqvJLIttfh+ZIS8dl7KalzINZe1lkuESfX18HkRcHvxxDMncAEHh95ztBf
UiUNYl8t05E6UMDPdWc/TlKvwFD8ed60GXkuq4UiIVfWNRSlXEmMSzCjoCJQ1cZFpKxiTvOy5oom
QC7P0FlZZx7g6cgwEgS6P+c3O12BuRtz9xZOkga7d1u0rjYRSuLdHawv3yvXJXop3W920Avh+wO2
hHs0mec4tb+4FfiPEIqrctQomM5Q2WGH7onG/zkJvDFY9ZtGL+QkpE31mdJ+xUIM
--000000000000def5ff05d974c961--
