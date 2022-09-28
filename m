Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1272D5ED256
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 02:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiI1A7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 20:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbiI1A7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 20:59:16 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E98125792
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 17:59:14 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id j8so7249950qvt.13
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 17:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date;
        bh=OHwAI3nnJ9ivn9YDdN080Pfup4Gs6WWT6rGnbUcF1Ro=;
        b=Dg9W8x8lQUG0wqb1+lmTKI2cRvFz9tuEPppS85xBjFXQwHdB0r3yEz/8JeKiIUlyVI
         i3/A7wuP0xjcPhNCSu7zjO+cOu+3fARYKyrP0rMVCw+u9uxPOxWLfkpmC1jcjnPb+wva
         FTE8gNPwGmeA1vHUFHSZC+UraEY3pYrlzFOjc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=OHwAI3nnJ9ivn9YDdN080Pfup4Gs6WWT6rGnbUcF1Ro=;
        b=rMkyQFgjthxKkWj/o3RPxVnqU/ROcHGdk80kcTlL4FNHesHEPWPnMxwWdy0nKQAAhH
         nwF6RHJ2z2XUNfZArRwGx5mna3Kmt0kxnNzUKFLKGMwKnnSv0uJxkNisuLtZL+87oS2q
         btoiKCdr0x0cYnvlJLCkESYlDrEbSp53hGNmFMembDwCN5CQgR6bJlKxOMqgzn4LZwas
         FbuZPQ5uzQw3uZyxdkn2DacgIc4VE/oX3mJyeevpw2lA1MbZTFofK0FXchZ1+rdoAb+9
         rvGPR9hiEN/yhAmaFmh3JU+Z53+nPK7ntzd9UztTbX3piMzU9InwHH1danDz3YxZjSPe
         MS1g==
X-Gm-Message-State: ACrzQf38tjWT4oeEWxYwEfWS0mjsdBgU0t4p3lCOqLdP4ePoJNqPMRVB
        /j7akCR6+cJXa/8zy++7/Vnd0g==
X-Google-Smtp-Source: AMsMyM7KnOHr3BVsfSg1/evOBm0gRk47o8ca7u5o6apB3IlMP5e0QI+oUfpLHoTIUdk6wNiYybeijA==
X-Received: by 2002:ad4:4eae:0:b0:4af:9a04:ae3d with SMTP id ed14-20020ad44eae000000b004af9a04ae3dmr170100qvb.49.1664326753871;
        Tue, 27 Sep 2022 17:59:13 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i11-20020a05620a248b00b006cbb8ca04f8sm2078668qkn.40.2022.09.27.17.59.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Sep 2022 17:59:13 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, gospo@broadcom.com, vikas.gupta@broadcom.com
Subject: [PATCH net-next 2/6] bnxt_en: add support for QSFP optional EEPROM data
Date:   Tue, 27 Sep 2022 20:58:40 -0400
Message-Id: <1664326724-1415-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1664326724-1415-1-git-send-email-michael.chan@broadcom.com>
References: <1664326724-1415-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000f9f59205e9b24498"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_TVD_MIME_NO_HEADERS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000f9f59205e9b24498

From: Edwin Peer <edwin.peer@broadcom.com>

SFF 8636 defines several optional pages. This patch adds support up to
and including page 3. The ethtool offset needs to be mapped onto the
appropriate device page and I2C address, which is handled differently
depending on module type. The necessary linear offset to raw page
mapping is performed based on a table that is configured according to
the module capabilities.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   5 +
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 120 +++++++++++++++---
 2 files changed, 108 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index b1b17f911300..c54f8c9ab3ad 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2206,6 +2206,11 @@ struct bnxt {
 #define SFF_MODULE_ID_QSFP			0xc
 #define SFF_MODULE_ID_QSFP_PLUS			0xd
 #define SFF_MODULE_ID_QSFP28			0x11
+#define SFF8636_FLATMEM_OFFSET			0x2
+#define SFF8636_FLATMEM_MASK			0x4
+#define SFF8636_OPT_PAGES_OFFSET		0xc3
+#define SFF8636_PAGE1_MASK			0x40
+#define SFF8636_PAGE2_MASK			0x80
 #define BNXT_MAX_PHY_I2C_RESP_SIZE		64
 
 static inline u32 bnxt_tx_avail(struct bnxt *bp, struct bnxt_tx_ring_info *txr)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index f57e524c7e30..6596dca94c3d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3220,7 +3220,9 @@ static int bnxt_get_module_info(struct net_device *dev,
 			break;
 		case SFF_MODULE_ID_QSFP28:
 			modinfo->type = ETH_MODULE_SFF_8636;
-			modinfo->eeprom_len = ETH_MODULE_SFF_8636_LEN;
+			modinfo->eeprom_len = ETH_MODULE_SFF_8636_MAX_LEN;
+			if (data[SFF8636_FLATMEM_OFFSET] & SFF8636_FLATMEM_MASK)
+				modinfo->eeprom_len = ETH_MODULE_SFF_8636_LEN;
 			break;
 		default:
 			rc = -EOPNOTSUPP;
@@ -3234,32 +3236,116 @@ static int bnxt_get_module_eeprom(struct net_device *dev,
 				  struct ethtool_eeprom *eeprom,
 				  u8 *data)
 {
+	u8 pg_addr[5] = { I2C_DEV_ADDR_A0, I2C_DEV_ADDR_A0 };
+	u16 offset = eeprom->offset, length = eeprom->len;
+	u8 module_info[SFF_DIAG_SUPPORT_OFFSET + 1];
 	struct bnxt *bp = netdev_priv(dev);
-	u16  start = eeprom->offset, length = eeprom->len;
+	u8 page = offset >> 7;
+	u8 max_pages = 2;
 	int rc = 0;
 
-	memset(data, 0, eeprom->len);
+	rc = bnxt_read_sfp_module_eeprom_info(bp, I2C_DEV_ADDR_A0, 0, 0,
+					      SFF_DIAG_SUPPORT_OFFSET + 1,
+					      module_info);
+	if (rc)
+		return rc;
+
+	switch (module_info[0]) {
+	case SFF_MODULE_ID_SFP:
+		if (module_info[SFF_DIAG_SUPPORT_OFFSET]) {
+			pg_addr[2] = I2C_DEV_ADDR_A2;
+			pg_addr[3] = I2C_DEV_ADDR_A2;
+			max_pages = 4;
+		}
+		break;
+	case SFF_MODULE_ID_QSFP28: {
+		u8 opt_pages;
 
-	/* Read A0 portion of the EEPROM */
-	if (start < ETH_MODULE_SFF_8436_LEN) {
-		if (start + eeprom->len > ETH_MODULE_SFF_8436_LEN)
-			length = ETH_MODULE_SFF_8436_LEN - start;
 		rc = bnxt_read_sfp_module_eeprom_info(bp, I2C_DEV_ADDR_A0, 0,
-						      start, length, data);
+						      SFF8636_OPT_PAGES_OFFSET,
+						      1, &opt_pages);
 		if (rc)
 			return rc;
-		start += length;
-		data += length;
-		length = eeprom->len - length;
+
+		if (opt_pages & SFF8636_PAGE1_MASK) {
+			pg_addr[2] = I2C_DEV_ADDR_A0;
+			max_pages = 3;
+		}
+		if (opt_pages & SFF8636_PAGE2_MASK) {
+			pg_addr[3] = I2C_DEV_ADDR_A0;
+			max_pages = 4;
+		}
+		if (~module_info[SFF8636_FLATMEM_OFFSET] & SFF8636_FLATMEM_MASK) {
+			pg_addr[4] = I2C_DEV_ADDR_A0;
+			max_pages = 5;
+		}
+		break;
 	}
+	default:
+		break;
+	}
+
+	memset(data, 0, eeprom->len);
 
-	/* Read A2 portion of the EEPROM */
-	if (length) {
-		start -= ETH_MODULE_SFF_8436_LEN;
-		rc = bnxt_read_sfp_module_eeprom_info(bp, I2C_DEV_ADDR_A2, 0,
-						      start, length, data);
+	/* Read the two 128B base pages in a single pass, since they are
+	 * always supported and both sourced from I2C_DEV_ADDR_A0. Then,
+	 * read individual 128B or 256B chunks as appropriate, according
+	 * to the mappings defined in pg_addr[], which is setup based on
+	 * module capabilities.
+	 *
+	 * The first two pages are both numbered page zero, lower page 0
+	 * and upper page 0 respectively. Raw device pages are numbered
+	 * sequentially thereafter. For SFP modules, reads are always
+	 * from page zero. In this case, the A2 base address is used in
+	 * lieu of the page number to signal reading the upper 256B, with
+	 * offsets relative to the base of this larger I2C region.
+	 *
+	 * Note there may be gaps in the linear ethtool mapping that are
+	 * not backed by raw module pages. Reads to such pages should not
+	 * be attempted because the HWRM call would fail. The caller will
+	 * simply see the preinitialized zeroes in these holes.
+	 *
+	 * Also note, the implementation below depends on pages mapped as
+	 * I2C_DEV_ADDR_A2 in pg_addr[] appearing as 256B aligned pairs.
+	 * This constraint means that it doesn't matter whether the even
+	 * or odd page is used in determining the I2C base address of a
+	 * given region. This allows for larger chunk sizes to be read
+	 * for A2 pages and happens to correspond nicely with the memory
+	 * maps of all currently supported modules. The optional 128B
+	 * A0 pages need to be read relative to an offset of 128B, which
+	 * is where they appear in module memory maps, while the 256B A2
+	 * page pair regions are interpreted by firmware relative to
+	 * offset 0.
+	 */
+	offset &= 0xff;
+	while (length && page < max_pages) {
+		u8 raw_page = page ? page - 1 : 0;
+		u16 chunk;
+
+		if (pg_addr[page] == I2C_DEV_ADDR_A2)
+			raw_page = 0;
+		else if (page)
+			offset |= 0x80;
+		chunk = min_t(u16, length, 256 - offset);
+
+		if (pg_addr[page]) {
+			rc = bnxt_read_sfp_module_eeprom_info(bp, pg_addr[page],
+							      raw_page, offset,
+							      chunk, data);
+			if (rc)
+				return rc;
+		}
+
+		data += chunk;
+		length -= chunk;
+		offset = 0;
+		page += 1 + (chunk > 128);
 	}
-	return rc;
+
+	if (length)
+		return -EINVAL;
+
+	return 0;
 }
 
 static int bnxt_nway_reset(struct net_device *dev)
-- 
2.18.1


--000000000000f9f59205e9b24498
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIN03mSmeLRSTM8c+zzdQFuGPPn3wiGJU
eQeZMZrll8bXMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDky
ODAwNTkxNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBG8eHMOt+imvH4vgSN2h0/XB0iKpqq7Ku+Fogye4DP4G5yLzMH
HJKaPsuj1djnMJCnuVs5cYEYLS4ZBlqXIRNa4TQyg8da/3g5PYCJmd7iLo2Qz+syL5KF4MaB9bNc
hSscyVmiRI1dcemlM02Pqzbt3g4hha4Obk7PtSjhDha2YscowEorStMm19dgijftpVsi/dSW+DGR
Q90NAJWEAMkBQCYzuv82nhb/J2eNPoIgUwcOOQ6ygJp7gZCsquGCs+DKsnjIR7JweBSEHf2xebgm
2ExzhVcYpE+YPBt+ncHkGXgd2SWtHPu9fBdKOdPS5OB7pNW8hrWDrUbIZV+cfeND
--000000000000f9f59205e9b24498--
