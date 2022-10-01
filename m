Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3775F1E99
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 20:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiJAS1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 14:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiJAS12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 14:27:28 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD3A5C9D6
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 11:27:27 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id i3so4654423qkl.3
        for <netdev@vger.kernel.org>; Sat, 01 Oct 2022 11:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date;
        bh=AXCTHbBM3xy5mO2JxnEAE9h4oLwYFoZPkYVZQMX59X8=;
        b=iE3Zw8AtvHyTSo7yjZ5TTZfVdsni3QUcVgtD3eK1ctc9SR5ugX9C6dXx0/G50K9qsn
         bX2oWqY2ovdpruGCmz8YPVm4lDzhgoj8oQD1sr+ZTvYcYxCeQ60tIJ9Nw3OnKTiaYU1F
         M68Iax9PXCrGQYvhpxt2HXFu260lh7AuLWPdE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=AXCTHbBM3xy5mO2JxnEAE9h4oLwYFoZPkYVZQMX59X8=;
        b=POSk8IkCusRrRO8THA+74A2Ga22WgZuVZO4dRLJTiAVNUahcsbwN2Stf/xkemg37TN
         mfSXotSS46+B/3KpzeqlJgJdWAyRIbyqcEXzyszdHBqT0hGEI/AoI0+4l46gSpIkoOM0
         Rrj7coa9xQDgWgDbpB/UBq8hSAFkl4yIj0tF5MV3K3iGjb3EsrjNB52++1X5GVcLUxWH
         lMX9QGTcr5TrdllDYH6lb5g7CN1fN6FmMr+Lz5AV9WRE/NVc9ZxjigaFBwfZDEvzlpIs
         JpZnDnwl/VyixQ1FgqILqFyDtY8lVLKxMkX3nkSCvLdbusPiMD76yz8NsT1az+WWTwIi
         inEg==
X-Gm-Message-State: ACrzQf0GI32/5f4GMMAjQ0PFQO9i/9vLpQKKdd+oDcTOA4vuCZwWGqCp
        IrWu3nTauUgtZ6sawHnHs8/y7Q==
X-Google-Smtp-Source: AMsMyM6LPL1pnCl/DUK66Qy1LDXMpiG8RZ9o07C7/W1DKidVlAdRPcHl1aN95ECt0bOnnvibBCPyaA==
X-Received: by 2002:a05:620a:4447:b0:6c6:c438:1ced with SMTP id w7-20020a05620a444700b006c6c4381cedmr10215496qkp.658.1664648846871;
        Sat, 01 Oct 2022 11:27:26 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h14-20020a05620a400e00b006ce3f1af120sm6652830qko.44.2022.10.01.11.27.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Oct 2022 11:27:26 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, gospo@broadcom.com, vikas.gupta@broadcom.com
Subject: [PATCH net-next v2 3/3] bnxt_en: check and resize NVRAM UPDATE entry before flashing
Date:   Sat,  1 Oct 2022 14:27:11 -0400
Message-Id: <1664648831-7965-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1664648831-7965-1-git-send-email-michael.chan@broadcom.com>
References: <1664648831-7965-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000373c3e05e9fd43d0"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_TVD_MIME_NO_HEADERS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000373c3e05e9fd43d0

From: Vikas Gupta <vikas.gupta@broadcom.com>

Resize of the UPDATE entry is required if the image to
be flashed is larger than the available space. Add this step,
otherwise flashing larger firmware images by ethtool or devlink
may fail.

Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 092cd4f98a6d..6dc3c3279acf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2514,6 +2514,7 @@ static int bnxt_flash_firmware_from_file(struct net_device *dev,
 #define MSG_INTERNAL_ERR "PKG install error : Internal error"
 #define MSG_NO_PKG_UPDATE_AREA_ERR "PKG update area not created in nvram"
 #define MSG_NO_SPACE_ERR "PKG insufficient update area in nvram"
+#define MSG_RESIZE_UPDATE_ERR "Resize UPDATE entry error"
 #define MSG_ANTI_ROLLBACK_ERR "HWRM_NVM_INSTALL_UPDATE failure due to Anti-rollback detected"
 #define MSG_GENERIC_FAILURE_ERR "HWRM_NVM_INSTALL_UPDATE failure"
 
@@ -2564,6 +2565,32 @@ static int nvm_update_err_to_stderr(struct net_device *dev, u8 result,
 #define BNXT_NVM_MORE_FLAG	(cpu_to_le16(NVM_MODIFY_REQ_FLAGS_BATCH_MODE))
 #define BNXT_NVM_LAST_FLAG	(cpu_to_le16(NVM_MODIFY_REQ_FLAGS_BATCH_LAST))
 
+static int bnxt_resize_update_entry(struct net_device *dev, size_t fw_size,
+				    struct netlink_ext_ack *extack)
+{
+	u32 item_len;
+	int rc;
+
+	rc = bnxt_find_nvram_item(dev, BNX_DIR_TYPE_UPDATE,
+				  BNX_DIR_ORDINAL_FIRST, BNX_DIR_EXT_NONE, NULL,
+				  &item_len, NULL);
+	if (rc) {
+		BNXT_NVM_ERR_MSG(dev, extack, MSG_NO_PKG_UPDATE_AREA_ERR);
+		return rc;
+	}
+
+	if (fw_size > item_len) {
+		rc = bnxt_flash_nvram(dev, BNX_DIR_TYPE_UPDATE,
+				      BNX_DIR_ORDINAL_FIRST, 0, 1,
+				      round_up(fw_size, 4096), NULL, 0);
+		if (rc) {
+			BNXT_NVM_ERR_MSG(dev, extack, MSG_RESIZE_UPDATE_ERR);
+			return rc;
+		}
+	}
+	return 0;
+}
+
 int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware *fw,
 				   u32 install_type, struct netlink_ext_ack *extack)
 {
@@ -2580,6 +2607,11 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 	u16 index;
 	int rc;
 
+	/* resize before flashing larger image than available space */
+	rc = bnxt_resize_update_entry(dev, fw->size, extack);
+	if (rc)
+		return rc;
+
 	bnxt_hwrm_fw_set_time(bp);
 
 	rc = hwrm_req_init(bp, modify, HWRM_NVM_MODIFY);
-- 
2.18.1


--000000000000373c3e05e9fd43d0
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
OnaLEot1MoQO7BIe5S9H4AcCEXXcrJJiAtMCl47ARpyHmvQFQFFTrHgUYEd9V+9bOzY7MBIGSV1N
/JfsT1sZw6HT0lJkSQefhPGpBniAob62DJP3qr11tu8CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU31rAyTdZweIF0tJTFYwfOv2w
L4QwDQYJKoZIhvcNAQELBQADggEBACcuyaGmk0NSZ7Kio7O7WSZ0j0f9xXcBnLbJvQXFYM7JI5uS
kw5ozATEN5gfmNIe0AHzqwoYjAf3x8Dv2w7HgyrxWdpjTKQFv5jojxa3A5LVuM8mhPGZfR/L5jSk
5xc3llsKqrWI4ov4JyW79p0E99gfPA6Waixoavxvv1CZBQ4Stu7N660kTu9sJrACf20E+hdKLoiU
hd5wiQXo9B2ncm5P3jFLYLBmPltIn/uzdiYpFj+E9kS9XYDd+boBZhN1Vh0296zLQZobLfKFzClo
E6IFyTTANonrXvCRgodKS+QJEH8Syu2jSKe023aVemkuZjzvPK7o9iU7BKkPG2pzLPgxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxeQGjDntHGb2iaQkIw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEINZcTcKpxUrnhS1EVl0Pbk57cRm+JPBO
PVn6Rz48hAJXMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTAw
MTE4MjcyN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQB70ATF7Lqit9UUF2xUFfpbY4OwH+igStYoM2bk+1hR2ft03J2n
HJkWUfSw3QznXPUocTZzSdjJn+1lh33uM/KC/H9AQxsc675xPlCNsZCWmzZQCfveBuXlz1iN3HM9
uktlXDjy/8nTik6IulfyYerwh1GB9OAvgbPMmWqvCMEBjOK4/99U56jA051N/V9xNC1GCeHuZwVm
WEvhb7ORohd+otEQy/LRPRdjLC1Qc/8E7F8dzPpSZt+JXjhqld4INLGOcDNFxGC1GLlGrmJyKj/i
VqLK7a/swkRQoYw3md1zNx6ZbJnE4Kmy8w9fIV6WG9YsYVNBOIglLQtkWA0OlHMh
--000000000000373c3e05e9fd43d0--
