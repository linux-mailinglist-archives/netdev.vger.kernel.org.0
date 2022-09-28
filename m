Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E47075ED25B
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 02:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbiI1A7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 20:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbiI1A71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 20:59:27 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9C815EF8C
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 17:59:20 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id ay9so7174434qtb.0
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 17:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date;
        bh=dXgzPooGk4oqaL9KEhjoxsvVh87wIf1K1w/56HGIIHk=;
        b=DVYZ2e63G/JB8DdigcEE1LTLq198k10EwaUUfYZHGZwHZHxjNozWugjQb1QoNZqFdM
         fVPukfevJcTzDeoW5O3Mnsmu0F4KMnhUNgnjWNL37P5PfVqh+6UPTSr2oPqwf4d6W03i
         yaeTqD9o/KjmT4YLLv57PTpOF06I/HTlYFpr8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=dXgzPooGk4oqaL9KEhjoxsvVh87wIf1K1w/56HGIIHk=;
        b=5TINW28dw2ZmHlB/COHFzXXSQC9jJiPJqSEenD72RZfImFEhwDVugKHGsqleDvxgKr
         Ud6EEwRMzhOJmCOj1F4gOpqGZKICTKkphUQYEhaPUnf7Sv73ee9/Cytc55gr2u2/8gSc
         VDrBBfWP+EmdeiWVn7/efXRQS2udrelEz3Ir6SJaCQ1HeYbo1XnWD5OoHhFoMkCMgPHQ
         zjtiltzvWZMh/Qri96QDSDg4NOCFenXJwXhAOpOPLec5GRr3bsMOqk6QUSEky69hvYtG
         EdyX8KemdRn1D31k5Gz6URV+gbG8AV18v0uvGh12b7DvzFiueXlRFy6yrf13+gaHQMXi
         zDwA==
X-Gm-Message-State: ACrzQf0SXZTg6C/ym+HkIUCCIL3abp75G+GxU9Hq+R72ScNnATOsU3J3
        6sOBcnOdIjpkQyEvXn2Tbq/1qA==
X-Google-Smtp-Source: AMsMyM7tjysYVrW7oRy+IbZ1GXmJML9hS+cyreT1uzKUI7XO2ZxTCTqt8J3Z97nhwo0w+1cvUC6Htg==
X-Received: by 2002:a05:622a:174d:b0:35c:bf34:fc7 with SMTP id l13-20020a05622a174d00b0035cbf340fc7mr25146802qtk.13.1664326759109;
        Tue, 27 Sep 2022 17:59:19 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i11-20020a05620a248b00b006cbb8ca04f8sm2078668qkn.40.2022.09.27.17.59.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Sep 2022 17:59:18 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, gospo@broadcom.com, vikas.gupta@broadcom.com
Subject: [PATCH net-next 5/6] bnxt_en: add .get_module_eeprom_by_page() support
Date:   Tue, 27 Sep 2022 20:58:43 -0400
Message-Id: <1664326724-1415-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1664326724-1415-1-git-send-email-michael.chan@broadcom.com>
References: <1664326724-1415-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000049d1af05e9b24514"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_TVD_MIME_NO_HEADERS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000049d1af05e9b24514

From: Vikas Gupta <vikas.gupta@broadcom.com>

Add support for .get_module_eeprom_by_page() callback
which enables CMIS for pluggable modules.
In the case that bank select is not enabled by f/w then
all the requests fallback to .get_module_eeprom() callback.

Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  9 +++
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 55 +++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 0209f7caf490..03b1a0301a46 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2207,6 +2207,15 @@ struct bnxt {
 #define SFF_MODULE_ID_QSFP			0xc
 #define SFF_MODULE_ID_QSFP_PLUS			0xd
 #define SFF_MODULE_ID_QSFP28			0x11
+#define SFF_MODULE_ID_QSFP_DD			0x18
+#define SFF_MODULE_ID_DSFP			0x1b
+#define SFF_MODULE_ID_QSFP_PLUS_CMIS		0x1e
+
+#define BNXT_SFF_MODULE_BANK_SUPPORTED(module_id)	\
+	((module_id) == SFF_MODULE_ID_QSFP_DD ||	\
+	 (module_id) == SFF_MODULE_ID_QSFP28 ||		\
+	 (module_id) == SFF_MODULE_ID_QSFP_PLUS_CMIS)
+
 #define SFF8636_FLATMEM_OFFSET			0x2
 #define SFF8636_FLATMEM_MASK			0x4
 #define SFF8636_OPT_PAGES_OFFSET		0xc3
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 379afa670494..2b18af95aacb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3363,6 +3363,60 @@ static int bnxt_get_module_eeprom(struct net_device *dev,
 	return 0;
 }
 
+static int bnxt_get_module_eeprom_by_page(struct net_device *dev,
+					  const struct ethtool_module_eeprom *page_data,
+					  struct netlink_ext_ack *extack)
+{
+	struct bnxt *bp = netdev_priv(dev);
+	u16 length = page_data->length;
+	u8 *data = page_data->data;
+	u8 page = page_data->page;
+	u8 bank = page_data->bank;
+	u16 bytes_copied = 0;
+	u8 module_id;
+	int rc;
+
+	/* Return -EOPNOTSUPP to fallback on .get_module_eeprom */
+	if (!(bp->phy_flags & BNXT_PHY_FL_BANK_SEL))
+		return -EOPNOTSUPP;
+
+	rc = bnxt_module_status_check(bp);
+	if (rc)
+		return rc;
+
+	rc = bnxt_read_sfp_module_eeprom_info(bp, I2C_DEV_ADDR_A0, 0, 0, false,
+					      0, 1, &module_id);
+	if (rc)
+		return rc;
+
+	if (!BNXT_SFF_MODULE_BANK_SUPPORTED(module_id))
+		return -EOPNOTSUPP;
+
+	while (length > 0) {
+		u16 chunk = ETH_MODULE_EEPROM_PAGE_LEN;
+		int rc;
+
+		/* Do not access more than required */
+		if (length < ETH_MODULE_EEPROM_PAGE_LEN)
+			chunk = length;
+
+		rc = bnxt_read_sfp_module_eeprom_info(bp,
+						      I2C_DEV_ADDR_A0,
+						      page, bank,
+						      true, page_data->offset,
+						      chunk, data);
+		if (rc)
+			return rc;
+
+		data += chunk;
+		length -= chunk;
+		bytes_copied += chunk;
+		page++;
+	}
+
+	return bytes_copied;
+}
+
 static int bnxt_nway_reset(struct net_device *dev)
 {
 	int rc = 0;
@@ -4172,6 +4226,7 @@ const struct ethtool_ops bnxt_ethtool_ops = {
 	.set_eee		= bnxt_set_eee,
 	.get_module_info	= bnxt_get_module_info,
 	.get_module_eeprom	= bnxt_get_module_eeprom,
+	.get_module_eeprom_by_page = bnxt_get_module_eeprom_by_page,
 	.nway_reset		= bnxt_nway_reset,
 	.set_phys_id		= bnxt_set_phys_id,
 	.self_test		= bnxt_self_test,
-- 
2.18.1


--00000000000049d1af05e9b24514
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIBgwH23y3iDRKmqh6INsBVFuywNhc5Fi
v7DcEx23H9PJMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDky
ODAwNTkxOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQA5G172PScN5yuMcm/eFH1xhhx/b5McKD+7SYzqed9HCxyByXhx
Udd0R658+vf5ppqmLfqNuJqKT+M4MWwAh+swrP3/XUFMbXl/jaGB5FsHhzFHzI8a/IL6QNDNjRnh
9fFBLsAqjphS5SBAF0ldj01euYFBu21xMBIqAv7lr6g1nWQUtG8r8IohtSKxzh6LwypDw9audQAM
bOTxfXGim2+fEhxA0yhBHbXTIA4vrAXHJU2TwmHYcSsSILx7xaY/mKXDLK3Q0oyQ9yEtHY6rHOuL
oNU91lNVd12s/0ZVfvnXKqggpSoUfWXcKxGIadgAZNxWlE7sZsihkfAZZ6scwjAh
--00000000000049d1af05e9b24514--
