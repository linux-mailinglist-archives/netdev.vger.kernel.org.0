Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A815ED259
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 02:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbiI1A73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 20:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiI1A7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 20:59:17 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC356133CB9
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 17:59:16 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id d1so7323957qvs.0
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 17:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date;
        bh=YiOiyM1L1O+Ly/EJcn4Ens4K01PieDn8TFMxXwOUKx0=;
        b=Tnmh3uYTW4ujUoaTIz2HGJENzKdshu/JYlE6B7sDmW+QS6Ipn+jH+oovAsmoGq7/Bi
         Nt/KQsT/wmNI90mXqi3at294+4jOQOx9yFRqvBQpySSK80yrEkbC+iGp2Tv1W7g2UsDJ
         vBadMEAGYm2WnGXnGjtVYqJaPDJAqzyL4KgjY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=YiOiyM1L1O+Ly/EJcn4Ens4K01PieDn8TFMxXwOUKx0=;
        b=DPbsG4Wo9w6eY1LjZCKjihPJfJ5JF10swZqW86SvI8fg06kAKrU7a+IZMaBPZiDOkq
         kfA+c74/LFeLX2BSX3jJ1qyYT/4xEUvJAOaiYJ7zjYW6qViDgm0b7ORl7BWJ2gI1Pgo2
         kXoJ1BoefOu1vHOg0bebzIhgfNImZieMD5JgqbPxZ+/s6GyQAQLZy9v6lThlcyyWaZvr
         QjqceaoAHBP135fzeMdsZkhXrq8WRDNtlW51ygbGzdATWhefWcT6d5hM6uU57Q7p/MN9
         kLRBd6j9FG0r2wD8K3+E7WjLjgDmueK3onNY/b85H6hhRobQMOhUL8e1kuheQswL0sM2
         wdwQ==
X-Gm-Message-State: ACrzQf2djVAjFIfI1QcQnRMN7LuTdqb+8g6kzweFcF96lWsv7nWeAE3N
        g03LnrAEMLqZ8MYi0HCfICRgfA==
X-Google-Smtp-Source: AMsMyM4uYzg1tmfKueiTD8Bthel8ou1zBEODj7yT8D2qR7BJPKBk11Vo401Bh+pW5kDwPpM8DwKv8g==
X-Received: by 2002:a05:6214:19e7:b0:4aa:216f:5ab5 with SMTP id q7-20020a05621419e700b004aa216f5ab5mr23598655qvc.66.1664326755446;
        Tue, 27 Sep 2022 17:59:15 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i11-20020a05620a248b00b006cbb8ca04f8sm2078668qkn.40.2022.09.27.17.59.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Sep 2022 17:59:14 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, gospo@broadcom.com, vikas.gupta@broadcom.com
Subject: [PATCH net-next 3/6] bnxt_en: Add bank parameter to bnxt_read_sfp_module_eeprom_info()
Date:   Tue, 27 Sep 2022 20:58:41 -0400
Message-Id: <1664326724-1415-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1664326724-1415-1-git-send-email-michael.chan@broadcom.com>
References: <1664326724-1415-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000012316f05e9b24513"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_TVD_MIME_NO_HEADERS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000012316f05e9b24513

From: Vikas Gupta <vikas.gupta@broadcom.com>

Newer firmware supports the bank number parameter in the
HWRM_PORT_PHY_I2C_READ command.  Modify the function to pass in
the optional bank number for eeprom.  Existing callers will not use the
new bank number.  It will be used in subsequent patches.

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  1 +
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 24 ++++++++++++-------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index c54f8c9ab3ad..0209f7caf490 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2116,6 +2116,7 @@ struct bnxt {
 #define BNXT_PHY_FL_NO_FCS		PORT_PHY_QCAPS_RESP_FLAGS_NO_FCS
 #define BNXT_PHY_FL_NO_PAUSE		(PORT_PHY_QCAPS_RESP_FLAGS2_PAUSE_UNSUPPORTED << 8)
 #define BNXT_PHY_FL_NO_PFC		(PORT_PHY_QCAPS_RESP_FLAGS2_PFC_UNSUPPORTED << 8)
+#define BNXT_PHY_FL_BANK_SEL		(PORT_PHY_QCAPS_RESP_FLAGS2_BANK_ADDR_SUPPORTED << 8)
 
 	u8			num_tests;
 	struct bnxt_test_info	*test_info;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 6596dca94c3d..1c8a92fa2f2c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3146,7 +3146,8 @@ static int bnxt_get_eee(struct net_device *dev, struct ethtool_eee *edata)
 }
 
 static int bnxt_read_sfp_module_eeprom_info(struct bnxt *bp, u16 i2c_addr,
-					    u16 page_number, u16 start_addr,
+					    u16 page_number, u8 bank,
+					    bool bank_sel_en, u16 start_addr,
 					    u16 data_length, u8 *buf)
 {
 	struct hwrm_port_phy_i2c_read_output *output;
@@ -3168,8 +3169,11 @@ static int bnxt_read_sfp_module_eeprom_info(struct bnxt *bp, u16 i2c_addr,
 		data_length -= xfer_size;
 		req->page_offset = cpu_to_le16(start_addr + byte_offset);
 		req->data_length = xfer_size;
-		req->enables = cpu_to_le32(start_addr + byte_offset ?
-				 PORT_PHY_I2C_READ_REQ_ENABLES_PAGE_OFFSET : 0);
+		req->bank_number = bank;
+		req->enables = cpu_to_le32((start_addr + byte_offset ?
+				PORT_PHY_I2C_READ_REQ_ENABLES_PAGE_OFFSET : 0) |
+				(bank_sel_en ?
+				PORT_PHY_I2C_READ_REQ_ENABLES_BANK_NUMBER : 0));
 		rc = hwrm_req_send(bp, req);
 		if (!rc)
 			memcpy(buf + byte_offset, output->data, xfer_size);
@@ -3199,8 +3203,8 @@ static int bnxt_get_module_info(struct net_device *dev,
 	if (bp->hwrm_spec_code < 0x10202)
 		return -EOPNOTSUPP;
 
-	rc = bnxt_read_sfp_module_eeprom_info(bp, I2C_DEV_ADDR_A0, 0, 0,
-					      SFF_DIAG_SUPPORT_OFFSET + 1,
+	rc = bnxt_read_sfp_module_eeprom_info(bp, I2C_DEV_ADDR_A0, 0, 0, false,
+					      0, SFF_DIAG_SUPPORT_OFFSET + 1,
 					      data);
 	if (!rc) {
 		u8 module_id = data[0];
@@ -3244,8 +3248,8 @@ static int bnxt_get_module_eeprom(struct net_device *dev,
 	u8 max_pages = 2;
 	int rc = 0;
 
-	rc = bnxt_read_sfp_module_eeprom_info(bp, I2C_DEV_ADDR_A0, 0, 0,
-					      SFF_DIAG_SUPPORT_OFFSET + 1,
+	rc = bnxt_read_sfp_module_eeprom_info(bp, I2C_DEV_ADDR_A0, 0, 0, false,
+					      0, SFF_DIAG_SUPPORT_OFFSET + 1,
 					      module_info);
 	if (rc)
 		return rc;
@@ -3261,7 +3265,8 @@ static int bnxt_get_module_eeprom(struct net_device *dev,
 	case SFF_MODULE_ID_QSFP28: {
 		u8 opt_pages;
 
-		rc = bnxt_read_sfp_module_eeprom_info(bp, I2C_DEV_ADDR_A0, 0,
+		rc = bnxt_read_sfp_module_eeprom_info(bp, I2C_DEV_ADDR_A0, 0, 0,
+						      false,
 						      SFF8636_OPT_PAGES_OFFSET,
 						      1, &opt_pages);
 		if (rc)
@@ -3330,7 +3335,8 @@ static int bnxt_get_module_eeprom(struct net_device *dev,
 
 		if (pg_addr[page]) {
 			rc = bnxt_read_sfp_module_eeprom_info(bp, pg_addr[page],
-							      raw_page, offset,
+							      raw_page, 0,
+							      false, offset,
 							      chunk, data);
 			if (rc)
 				return rc;
-- 
2.18.1


--00000000000012316f05e9b24513
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILIEH3is5VyTFdqN1pOV5fVBj8Pi4nEU
9ltKZVt9cMqGMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDky
ODAwNTkxNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQC0yj9M1vTi3VdYzBOADx3U6W8IDbPH4M5xngkecQSQQyy8V/+P
I6DMudhiahpUI6hkhKI39+77BqMcx7f+h2Q4XdBAO/MKqxh3vf0uzqYXGG2ujTuRnubQK5ahbam8
TYyXWqbKJE8oyqZaKWf4QVvmQjuywY6Nvn7D1A2iU2uA2A+NVlfrkx9cFi33WkLQ66Tgz3hRd62n
Ni7c8uEowfI6M3NRXSdRZrrG02060TlPhgBSH2sXrvOxYTVEP+eaODCS4qWH/RGSu94QAafY1dGa
KbOFb2v1AqLyqnl47qZ3/zpA9IcQ+u/C+bJwLkUxxB7lSCmGptnL21D7s30TulqT
--00000000000012316f05e9b24513--
