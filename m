Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E648607026
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 08:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiJUGiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 02:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJUGiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 02:38:11 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A91237F87
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 23:38:09 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id z30so1440754qkz.13
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 23:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=U+iVmIr+zItQBrRBzpnTykUWCPKSc2XKzhGq7Oa0NvI=;
        b=VhED6Kry97gbzZWvsJ7iu5sHLZ3GS1mz+hD1F0Cv5jL3XbMsJRSebWvPX2MOk3gV/8
         jGrY9KeZZ3j/a1dYtXy5eR1nej+VjIC60glKvfDbEFh6o6pXgNBl23wfLGLJow1lIrAM
         qxo8WljIAuGLN7dLhpXfasIy26VALQlCA4iy8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U+iVmIr+zItQBrRBzpnTykUWCPKSc2XKzhGq7Oa0NvI=;
        b=xPbTp/Q1qgYVbRuOJmEPqTzEgT1cf9D0RAFCzLYkkdiQBruzOGK9tpV3fQYUjUuEte
         e9lrNQ1A8d4S9zefvZiVGYv3LC2qhTU/S1xv1ejBcZbuj4FcVBNPDdalbPydTgS/vq3N
         0S16kEPvK7E5fn/QieAUMyL7+Mb4lZ+tZ+woOzA4Ny6q9cDtdteDLExhyWFWSo8CYAX3
         TLvSfhjWjHMq+YqAqkZgaTF98jWyDJkPAfMp+GWvjZjhtgYldb3noUWwdRmA3bSEgKhx
         s2IfqL4FumzvRIK1FOL+uQOMfYcMNY+5fjgdSxWZAxcfnXUJ3n17/zeagbHLUnTDFP6C
         ZUJg==
X-Gm-Message-State: ACrzQf279TPbtGlqA6QFz9tP65/SAHErLPS00+rFjOgPYdNa5AWMZp/c
        LxlgPeSltmRhONEWTwz2rzjmYg==
X-Google-Smtp-Source: AMsMyM5O/s3Be2sw0DaarqXqwkBxf9t1ucgoOjAfcsus9AkT7jyrHvJFClhI6HT1JM+CrZx3Q0vaBg==
X-Received: by 2002:a05:620a:4510:b0:6ee:e598:a185 with SMTP id t16-20020a05620a451000b006eee598a185mr11626755qkp.765.1666334288095;
        Thu, 20 Oct 2022 23:38:08 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t12-20020ac8588c000000b0039cd4d87aacsm7688401qta.15.2022.10.20.23.38.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Oct 2022 23:38:07 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, gospo@broadcom.com, vikas.gupta@broadcom.com,
        Ido Schimmel <idosch@idosch.org>
Subject: [PATCH net-next v3 2/3] bnxt_en: add .get_module_eeprom_by_page() support
Date:   Fri, 21 Oct 2022 02:37:22 -0400
Message-Id: <1666334243-23866-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1666334243-23866-1-git-send-email-michael.chan@broadcom.com>
References: <1666334243-23866-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000575d2305eb85af9e"
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000575d2305eb85af9e

From: Vikas Gupta <vikas.gupta@broadcom.com>

Add support for .get_module_eeprom_by_page() callback which
implements generic solution for module`s eeprom access.

v3: Add bnxt_get_module_status() to get a more specific extack error
    string.
    Return -EINVAL from bnxt_get_module_eeprom_by_page() when we
    don't want to fallback to old method.
v2: Simplification suggested by Ido Schimmel

Link: https://lore.kernel.org/netdev/YzVJ%2FvKJugoz15yV@shredder/
Cc: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  1 +
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 77 +++++++++++++++++--
 2 files changed, 71 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index b1b17f911300..91a1ba0a914d 100644
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
index f57e524c7e30..44b715c4e19e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3146,8 +3146,9 @@ static int bnxt_get_eee(struct net_device *dev, struct ethtool_eee *edata)
 }
 
 static int bnxt_read_sfp_module_eeprom_info(struct bnxt *bp, u16 i2c_addr,
-					    u16 page_number, u16 start_addr,
-					    u16 data_length, u8 *buf)
+					    u16 page_number, u8 bank,
+					    u16 start_addr, u16 data_length,
+					    u8 *buf)
 {
 	struct hwrm_port_phy_i2c_read_output *output;
 	struct hwrm_port_phy_i2c_read_input *req;
@@ -3168,8 +3169,13 @@ static int bnxt_read_sfp_module_eeprom_info(struct bnxt *bp, u16 i2c_addr,
 		data_length -= xfer_size;
 		req->page_offset = cpu_to_le16(start_addr + byte_offset);
 		req->data_length = xfer_size;
-		req->enables = cpu_to_le32(start_addr + byte_offset ?
-				 PORT_PHY_I2C_READ_REQ_ENABLES_PAGE_OFFSET : 0);
+		req->enables =
+			cpu_to_le32((start_addr + byte_offset ?
+				     PORT_PHY_I2C_READ_REQ_ENABLES_PAGE_OFFSET :
+				     0) |
+				    (bank ?
+				     PORT_PHY_I2C_READ_REQ_ENABLES_BANK_NUMBER :
+				     0));
 		rc = hwrm_req_send(bp, req);
 		if (!rc)
 			memcpy(buf + byte_offset, output->data, xfer_size);
@@ -3199,7 +3205,7 @@ static int bnxt_get_module_info(struct net_device *dev,
 	if (bp->hwrm_spec_code < 0x10202)
 		return -EOPNOTSUPP;
 
-	rc = bnxt_read_sfp_module_eeprom_info(bp, I2C_DEV_ADDR_A0, 0, 0,
+	rc = bnxt_read_sfp_module_eeprom_info(bp, I2C_DEV_ADDR_A0, 0, 0, 0,
 					      SFF_DIAG_SUPPORT_OFFSET + 1,
 					      data);
 	if (!rc) {
@@ -3244,7 +3250,7 @@ static int bnxt_get_module_eeprom(struct net_device *dev,
 	if (start < ETH_MODULE_SFF_8436_LEN) {
 		if (start + eeprom->len > ETH_MODULE_SFF_8436_LEN)
 			length = ETH_MODULE_SFF_8436_LEN - start;
-		rc = bnxt_read_sfp_module_eeprom_info(bp, I2C_DEV_ADDR_A0, 0,
+		rc = bnxt_read_sfp_module_eeprom_info(bp, I2C_DEV_ADDR_A0, 0, 0,
 						      start, length, data);
 		if (rc)
 			return rc;
@@ -3256,12 +3262,68 @@ static int bnxt_get_module_eeprom(struct net_device *dev,
 	/* Read A2 portion of the EEPROM */
 	if (length) {
 		start -= ETH_MODULE_SFF_8436_LEN;
-		rc = bnxt_read_sfp_module_eeprom_info(bp, I2C_DEV_ADDR_A2, 0,
+		rc = bnxt_read_sfp_module_eeprom_info(bp, I2C_DEV_ADDR_A2, 0, 0,
 						      start, length, data);
 	}
 	return rc;
 }
 
+static int bnxt_get_module_status(struct bnxt *bp, struct netlink_ext_ack *extack)
+{
+	if (bp->link_info.module_status <=
+	    PORT_PHY_QCFG_RESP_MODULE_STATUS_WARNINGMSG)
+		return 0;
+
+	switch (bp->link_info.module_status) {
+	case PORT_PHY_QCFG_RESP_MODULE_STATUS_PWRDOWN:
+		NL_SET_ERR_MSG_MOD(extack, "Transceiver module is powering down");
+		break;
+	case PORT_PHY_QCFG_RESP_MODULE_STATUS_NOTINSERTED:
+		NL_SET_ERR_MSG_MOD(extack, "Transceiver module not inserted");
+		break;
+	case PORT_PHY_QCFG_RESP_MODULE_STATUS_CURRENTFAULT:
+		NL_SET_ERR_MSG_MOD(extack, "Transceiver module disabled due to current fault");
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "Unknown error");
+		break;
+	}
+	return -EINVAL;
+}
+
+static int bnxt_get_module_eeprom_by_page(struct net_device *dev,
+					  const struct ethtool_module_eeprom *page_data,
+					  struct netlink_ext_ack *extack)
+{
+	struct bnxt *bp = netdev_priv(dev);
+	int rc;
+
+	rc = bnxt_get_module_status(bp, extack);
+	if (rc)
+		return rc;
+
+	if (bp->hwrm_spec_code < 0x10202) {
+		NL_SET_ERR_MSG_MOD(extack, "Firmware version too old");
+		return -EINVAL;
+	}
+
+	if (page_data->bank && !(bp->phy_flags & BNXT_PHY_FL_BANK_SEL)) {
+		NL_SET_ERR_MSG_MOD(extack, "Firmware not capable for bank selection");
+		return -EINVAL;
+	}
+
+	rc = bnxt_read_sfp_module_eeprom_info(bp, page_data->i2c_address << 1,
+					      page_data->page, page_data->bank,
+					      page_data->offset,
+					      page_data->length,
+					      page_data->data);
+	if (rc) {
+		NL_SET_ERR_MSG_MOD(extack, "Module`s eeprom read failed");
+		return rc;
+	}
+	return page_data->length;
+}
+
 static int bnxt_nway_reset(struct net_device *dev)
 {
 	int rc = 0;
@@ -4071,6 +4133,7 @@ const struct ethtool_ops bnxt_ethtool_ops = {
 	.set_eee		= bnxt_set_eee,
 	.get_module_info	= bnxt_get_module_info,
 	.get_module_eeprom	= bnxt_get_module_eeprom,
+	.get_module_eeprom_by_page = bnxt_get_module_eeprom_by_page,
 	.nway_reset		= bnxt_nway_reset,
 	.set_phys_id		= bnxt_set_phys_id,
 	.self_test		= bnxt_self_test,
-- 
2.18.1


--000000000000575d2305eb85af9e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQbQYJKoZIhvcNAQcCoIIQXjCCEFoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3EMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBUwwggQ0oAMCAQICDF5AaMOe0cZvaJpCQjANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAwODIxMzhaFw0yNTA5MTAwODIxMzhaMIGO
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFTATBgNVBAMTDE1pY2hhZWwgQ2hhbjEoMCYGCSqGSIb3DQEJ
ARYZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBALhEmG7egFWvPKcrDxuNhNcn2oHauIHc8AzGhPyJxU4S6ZUjHM/psoNo5XxlMSRpYE7g7vLx
J4NBefU36XTEWVzbEkAuOSuJTuJkm98JE3+wjeO+aQTbNF3mG2iAe0AZbAWyqFxZulWitE8U2tIC
9mttDjSN/wbltcwuti7P57RuR+WyZstDlPJqUMm1rJTbgDqkF2pnvufc4US2iexnfjGopunLvioc
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIBZ2oQqNA+Lk10UghKg2jc0jNAEk4kXL
EVTZ8LhfcrBZMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTAy
MTA2MzgwOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCyjJnV4zl2DAmqERn8na1OnST2aSXtKaCBepR1mxffQZl9X0Am
+huZTJs1lu7r1wJ5d5KJIj7Dwo45fuxLcPMzMFDR1rcTzYEt6k++I3E9JSgEmIVP1voQUz4UzOFY
N9DDDSsJeXG7jJt4CrpMJyj3QiHFFRbJXsIvxiIoh4mMUMyWE1DTYhwlSL+MTYTt8VM7sjS48pl3
7oUB0zpKK0jVRWFNt6MjX9VTwk/8lEbJ0nrUv7gmr/sp/cUybGKvTh2JXlcbRYul6063U205vo0/
JPLlhrQ8Q2dynVpLaPVLXSEz/WobYdFL9E+sy7M+JFZqPw7jViYTw88DPjAW9LIc
--000000000000575d2305eb85af9e--
