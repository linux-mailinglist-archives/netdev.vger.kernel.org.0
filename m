Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06C7490A77
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 15:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240266AbiAQObw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 09:31:52 -0500
Received: from marcansoft.com ([212.63.210.85]:56182 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239675AbiAQOb2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jan 2022 09:31:28 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 3F33C4219F;
        Mon, 17 Jan 2022 14:31:19 +0000 (UTC)
From:   Hector Martin <marcan@marcan.st>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: [PATCH v3 8/9] brcmfmac: fwil: Constify iovar name arguments
Date:   Mon, 17 Jan 2022 23:29:18 +0900
Message-Id: <20220117142919.207370-9-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220117142919.207370-1-marcan@marcan.st>
References: <20220117142919.207370-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make all the iovar name arguments const char * instead of just char *.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../broadcom/brcm80211/brcmfmac/fwil.c        | 34 +++++++++----------
 .../broadcom/brcm80211/brcmfmac/fwil.h        | 28 +++++++--------
 2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
index d5578ca681bb..72fe8bce6eaf 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
@@ -192,7 +192,7 @@ brcmf_fil_cmd_int_get(struct brcmf_if *ifp, u32 cmd, u32 *data)
 }
 
 static u32
-brcmf_create_iovar(char *name, const char *data, u32 datalen,
+brcmf_create_iovar(const char *name, const char *data, u32 datalen,
 		   char *buf, u32 buflen)
 {
 	u32 len;
@@ -213,7 +213,7 @@ brcmf_create_iovar(char *name, const char *data, u32 datalen,
 
 
 s32
-brcmf_fil_iovar_data_set(struct brcmf_if *ifp, char *name, const void *data,
+brcmf_fil_iovar_data_set(struct brcmf_if *ifp, const char *name, const void *data,
 			 u32 len)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
@@ -241,7 +241,7 @@ brcmf_fil_iovar_data_set(struct brcmf_if *ifp, char *name, const void *data,
 }
 
 s32
-brcmf_fil_iovar_data_get(struct brcmf_if *ifp, char *name, void *data,
+brcmf_fil_iovar_data_get(struct brcmf_if *ifp, const char *name, void *data,
 			 u32 len)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
@@ -272,7 +272,7 @@ brcmf_fil_iovar_data_get(struct brcmf_if *ifp, char *name, void *data,
 }
 
 s32
-brcmf_fil_iovar_int_set(struct brcmf_if *ifp, char *name, u32 data)
+brcmf_fil_iovar_int_set(struct brcmf_if *ifp, const char *name, u32 data)
 {
 	__le32 data_le = cpu_to_le32(data);
 
@@ -280,7 +280,7 @@ brcmf_fil_iovar_int_set(struct brcmf_if *ifp, char *name, u32 data)
 }
 
 s32
-brcmf_fil_iovar_int_get(struct brcmf_if *ifp, char *name, u32 *data)
+brcmf_fil_iovar_int_get(struct brcmf_if *ifp, const char *name, u32 *data)
 {
 	__le32 data_le = cpu_to_le32(*data);
 	s32 err;
@@ -292,7 +292,7 @@ brcmf_fil_iovar_int_get(struct brcmf_if *ifp, char *name, u32 *data)
 }
 
 static u32
-brcmf_create_bsscfg(s32 bsscfgidx, char *name, char *data, u32 datalen,
+brcmf_create_bsscfg(s32 bsscfgidx, const char *name, char *data, u32 datalen,
 		    char *buf, u32 buflen)
 {
 	const s8 *prefix = "bsscfg:";
@@ -337,7 +337,7 @@ brcmf_create_bsscfg(s32 bsscfgidx, char *name, char *data, u32 datalen,
 }
 
 s32
-brcmf_fil_bsscfg_data_set(struct brcmf_if *ifp, char *name,
+brcmf_fil_bsscfg_data_set(struct brcmf_if *ifp, const char *name,
 			  void *data, u32 len)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
@@ -366,7 +366,7 @@ brcmf_fil_bsscfg_data_set(struct brcmf_if *ifp, char *name,
 }
 
 s32
-brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, char *name,
+brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, const char *name,
 			  void *data, u32 len)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
@@ -396,7 +396,7 @@ brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, char *name,
 }
 
 s32
-brcmf_fil_bsscfg_int_set(struct brcmf_if *ifp, char *name, u32 data)
+brcmf_fil_bsscfg_int_set(struct brcmf_if *ifp, const char *name, u32 data)
 {
 	__le32 data_le = cpu_to_le32(data);
 
@@ -405,7 +405,7 @@ brcmf_fil_bsscfg_int_set(struct brcmf_if *ifp, char *name, u32 data)
 }
 
 s32
-brcmf_fil_bsscfg_int_get(struct brcmf_if *ifp, char *name, u32 *data)
+brcmf_fil_bsscfg_int_get(struct brcmf_if *ifp, const char *name, u32 *data)
 {
 	__le32 data_le = cpu_to_le32(*data);
 	s32 err;
@@ -417,7 +417,7 @@ brcmf_fil_bsscfg_int_get(struct brcmf_if *ifp, char *name, u32 *data)
 	return err;
 }
 
-static u32 brcmf_create_xtlv(char *name, u16 id, char *data, u32 len,
+static u32 brcmf_create_xtlv(const char *name, u16 id, char *data, u32 len,
 			     char *buf, u32 buflen)
 {
 	u32 iolen;
@@ -438,7 +438,7 @@ static u32 brcmf_create_xtlv(char *name, u16 id, char *data, u32 len,
 	return iolen;
 }
 
-s32 brcmf_fil_xtlv_data_set(struct brcmf_if *ifp, char *name, u16 id,
+s32 brcmf_fil_xtlv_data_set(struct brcmf_if *ifp, const char *name, u16 id,
 			    void *data, u32 len)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
@@ -466,7 +466,7 @@ s32 brcmf_fil_xtlv_data_set(struct brcmf_if *ifp, char *name, u16 id,
 	return err;
 }
 
-s32 brcmf_fil_xtlv_data_get(struct brcmf_if *ifp, char *name, u16 id,
+s32 brcmf_fil_xtlv_data_get(struct brcmf_if *ifp, const char *name, u16 id,
 			    void *data, u32 len)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
@@ -495,7 +495,7 @@ s32 brcmf_fil_xtlv_data_get(struct brcmf_if *ifp, char *name, u16 id,
 	return err;
 }
 
-s32 brcmf_fil_xtlv_int_set(struct brcmf_if *ifp, char *name, u16 id, u32 data)
+s32 brcmf_fil_xtlv_int_set(struct brcmf_if *ifp, const char *name, u16 id, u32 data)
 {
 	__le32 data_le = cpu_to_le32(data);
 
@@ -503,7 +503,7 @@ s32 brcmf_fil_xtlv_int_set(struct brcmf_if *ifp, char *name, u16 id, u32 data)
 					 sizeof(data_le));
 }
 
-s32 brcmf_fil_xtlv_int_get(struct brcmf_if *ifp, char *name, u16 id, u32 *data)
+s32 brcmf_fil_xtlv_int_get(struct brcmf_if *ifp, const char *name, u16 id, u32 *data)
 {
 	__le32 data_le = cpu_to_le32(*data);
 	s32 err;
@@ -514,12 +514,12 @@ s32 brcmf_fil_xtlv_int_get(struct brcmf_if *ifp, char *name, u16 id, u32 *data)
 	return err;
 }
 
-s32 brcmf_fil_xtlv_int8_get(struct brcmf_if *ifp, char *name, u16 id, u8 *data)
+s32 brcmf_fil_xtlv_int8_get(struct brcmf_if *ifp, const char *name, u16 id, u8 *data)
 {
 	return brcmf_fil_xtlv_data_get(ifp, name, id, data, sizeof(*data));
 }
 
-s32 brcmf_fil_xtlv_int16_get(struct brcmf_if *ifp, char *name, u16 id, u16 *data)
+s32 brcmf_fil_xtlv_int16_get(struct brcmf_if *ifp, const char *name, u16 id, u16 *data)
 {
 	__le16 data_le = cpu_to_le16(*data);
 	s32 err;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
index cb26f8c59c21..bc693157c4b1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
@@ -84,26 +84,26 @@ s32 brcmf_fil_cmd_data_get(struct brcmf_if *ifp, u32 cmd, void *data, u32 len);
 s32 brcmf_fil_cmd_int_set(struct brcmf_if *ifp, u32 cmd, u32 data);
 s32 brcmf_fil_cmd_int_get(struct brcmf_if *ifp, u32 cmd, u32 *data);
 
-s32 brcmf_fil_iovar_data_set(struct brcmf_if *ifp, char *name, const void *data,
+s32 brcmf_fil_iovar_data_set(struct brcmf_if *ifp, const char *name, const void *data,
 			     u32 len);
-s32 brcmf_fil_iovar_data_get(struct brcmf_if *ifp, char *name, void *data,
+s32 brcmf_fil_iovar_data_get(struct brcmf_if *ifp, const char *name, void *data,
 			     u32 len);
-s32 brcmf_fil_iovar_int_set(struct brcmf_if *ifp, char *name, u32 data);
-s32 brcmf_fil_iovar_int_get(struct brcmf_if *ifp, char *name, u32 *data);
+s32 brcmf_fil_iovar_int_set(struct brcmf_if *ifp, const char *name, u32 data);
+s32 brcmf_fil_iovar_int_get(struct brcmf_if *ifp, const char *name, u32 *data);
 
-s32 brcmf_fil_bsscfg_data_set(struct brcmf_if *ifp, char *name, void *data,
+s32 brcmf_fil_bsscfg_data_set(struct brcmf_if *ifp, const char *name, void *data,
 			      u32 len);
-s32 brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, char *name, void *data,
+s32 brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, const char *name, void *data,
 			      u32 len);
-s32 brcmf_fil_bsscfg_int_set(struct brcmf_if *ifp, char *name, u32 data);
-s32 brcmf_fil_bsscfg_int_get(struct brcmf_if *ifp, char *name, u32 *data);
-s32 brcmf_fil_xtlv_data_set(struct brcmf_if *ifp, char *name, u16 id,
+s32 brcmf_fil_bsscfg_int_set(struct brcmf_if *ifp, const char *name, u32 data);
+s32 brcmf_fil_bsscfg_int_get(struct brcmf_if *ifp, const char *name, u32 *data);
+s32 brcmf_fil_xtlv_data_set(struct brcmf_if *ifp, const char *name, u16 id,
 			    void *data, u32 len);
-s32 brcmf_fil_xtlv_data_get(struct brcmf_if *ifp, char *name, u16 id,
+s32 brcmf_fil_xtlv_data_get(struct brcmf_if *ifp, const char *name, u16 id,
 			    void *data, u32 len);
-s32 brcmf_fil_xtlv_int_set(struct brcmf_if *ifp, char *name, u16 id, u32 data);
-s32 brcmf_fil_xtlv_int_get(struct brcmf_if *ifp, char *name, u16 id, u32 *data);
-s32 brcmf_fil_xtlv_int8_get(struct brcmf_if *ifp, char *name, u16 id, u8 *data);
-s32 brcmf_fil_xtlv_int16_get(struct brcmf_if *ifp, char *name, u16 id, u16 *data);
+s32 brcmf_fil_xtlv_int_set(struct brcmf_if *ifp, const char *name, u16 id, u32 data);
+s32 brcmf_fil_xtlv_int_get(struct brcmf_if *ifp, const char *name, u16 id, u32 *data);
+s32 brcmf_fil_xtlv_int8_get(struct brcmf_if *ifp, const char *name, u16 id, u8 *data);
+s32 brcmf_fil_xtlv_int16_get(struct brcmf_if *ifp, const char *name, u16 id, u16 *data);
 
 #endif /* _fwil_h_ */
-- 
2.33.0

