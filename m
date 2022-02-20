Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF564BCD8E
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 11:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243479AbiBTJGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 04:06:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243482AbiBTJGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 04:06:44 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2865631935
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 01:06:24 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id a11-20020a17090a740b00b001b8b506c42fso16237075pjg.0
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 01:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VIhQRHjajsSQXDo77s/MyTmBOFb2ebVTKmCwDrvspBo=;
        b=TxA/86dcRNbSsCLwJXdjaXT0ecWMybylwDFhq/dOFAA2eQbB+S0/uaQkkOHQzibztv
         s7rJbJZWwaSKkBCt2gimNXgejAP1xNH2mKsJxQMkI6ZUTeRuIoXdxYLB5Y/zTGrJq4ar
         lS8BKYnPhkGWOvQlDQEZfGV2ZmHJoXzc4zhxo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VIhQRHjajsSQXDo77s/MyTmBOFb2ebVTKmCwDrvspBo=;
        b=RLwS22v1eoVSf7BxIdH1vczvlTp4xjcvDUCOQEuDYi5WDS3qN9flFRhL8eMuL19sHg
         s7nZbS1HP5gODvIU3Fe66ihTh4fG+oFEFnkFf19htjn8cJDI+5cIDlmetgoKk1TZY1OM
         qpnfbLdslzQBye97dfj7LhMj3zwflQcFcWjg3w3W9ChiBWIpcULZw7VM5Qz4hEVaLDls
         /wGKqp43wAtoS2bSHFCGp0HZmPlU/kpnj6nDewNANFvMqYVEwYnJqMDZ5+Ucf5l5yEAo
         eQLv1nWLX536BzF/ejIUKBIK1dICifgEo/4vgOaZYtWFHtnZ1hjpot6qE94bw2QLpSVS
         ji9Q==
X-Gm-Message-State: AOAM532S4BkhFvWfEK0EnheySpy3AF66q4qX8kSdwXzVH2lrv6uS5d4p
        RXIkk0uOqwPJD6ZF9PoFNBAMVA==
X-Google-Smtp-Source: ABdhPJyX+fj8E8W9q+DbWyqRQsEvV+3UGPMNPls1G8X3YS5unPaivjMAnEOjHbA0jEx/J8xnmf3cZg==
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id d22-20020a170902729600b0014b4bc60e81mr14494957pll.132.1645347983377;
        Sun, 20 Feb 2022 01:06:23 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m5-20020a17090b068500b001b9bef22bf5sm4061865pjz.5.2022.02.20.01.06.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Feb 2022 01:06:23 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net 6/7] bnxt_en: Increase firmware message response DMA wait time
Date:   Sun, 20 Feb 2022 04:05:52 -0500
Message-Id: <1645347953-27003-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1645347953-27003-1-git-send-email-michael.chan@broadcom.com>
References: <1645347953-27003-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001d211705d86f6e56"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000001d211705d86f6e56

When polling for the firmware message response, we first poll for the
response message header.  Once the valid length is detected in the
header, we poll for the valid bit at the end of the message which
signals DMA completion.  Normally, this poll time for DMA completion
is extremely short (0 to a few usec).  But on some devices under some
rare conditions, it can be up to about 20 msec.

Increase this delay to 50 msec and use udelay() for the first 10 usec
for the common case, and usleep_range() beyond that.

Also, change the error message to include the above delay time when
printing the timeout value.

Fixes: 3c8c20db769c ("bnxt_en: move HWRM API implementation into separate file")
Reviewed-by: Vladimir Olovyannikov <vladimir.olovyannikov@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c | 12 +++++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h |  2 +-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
index 566c9487ef55..b01d42928a53 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
@@ -644,17 +644,23 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 
 		/* Last byte of resp contains valid bit */
 		valid = ((u8 *)ctx->resp) + len - 1;
-		for (j = 0; j < HWRM_VALID_BIT_DELAY_USEC; j++) {
+		for (j = 0; j < HWRM_VALID_BIT_DELAY_USEC; ) {
 			/* make sure we read from updated DMA memory */
 			dma_rmb();
 			if (*valid)
 				break;
-			usleep_range(1, 5);
+			if (j < 10) {
+				udelay(1);
+				j++;
+			} else {
+				usleep_range(20, 30);
+				j += 20;
+			}
 		}
 
 		if (j >= HWRM_VALID_BIT_DELAY_USEC) {
 			hwrm_err(bp, ctx, "Error (timeout: %u) msg {0x%x 0x%x} len:%d v:%d\n",
-				 hwrm_total_timeout(i), req_type,
+				 hwrm_total_timeout(i) + j, req_type,
 				 le16_to_cpu(ctx->req->seq_id), len, *valid);
 			goto exit;
 		}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
index d52bd2d63aec..c98032e38188 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
@@ -90,7 +90,7 @@ static inline unsigned int hwrm_total_timeout(unsigned int n)
 }
 
 
-#define HWRM_VALID_BIT_DELAY_USEC	150
+#define HWRM_VALID_BIT_DELAY_USEC	50000
 
 static inline bool bnxt_cfa_hwrm_message(u16 req_type)
 {
-- 
2.18.1


--0000000000001d211705d86f6e56
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIEGBhvRRcu8KIu7s26tgAiAeF9X5jYmD
7VSJF/wa1ERxMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDIy
MDA5MDYyM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAFpLkJMrLbZJt4x2MGlzWFaB1sDm42bjFxbaMrkdos3jm8+XnT
SeYBHuXcXzJ5fPHeE5eSWgQC0AqwFMRKBtZ9ONIFIXi1ve5PkfF0g72NCqvxlue4u9om8FwF2NY5
OtwcXR8v1wmynFRNAq3NtZ0UhcIC7OvUbb3a6fPqec7yhwGDeRpp6l4BhRf1Vuw6iechqZDEd3yy
i2c0Vea/30B9JzwlANYujqV7Ole1SegjMqFJyNQaJvT4YxyFcPMq7k+jeiv0gdULFn4l5PhOLaWO
dODlq1IyMO56llPHquk+FfDQ6MmiTtIbA6s5Sl1YX49b0HTAVcu8AnPyd3ce2+SW
--0000000000001d211705d86f6e56--
