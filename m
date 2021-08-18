Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8888F3F0B7E
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 21:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbhHRTIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 15:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233496AbhHRTIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 15:08:05 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1EDC0613A3;
        Wed, 18 Aug 2021 12:07:25 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id c129-20020a1c35870000b02902e6b6135279so2476508wma.0;
        Wed, 18 Aug 2021 12:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LDIfWEhWO8mVudTFuw38niuUgR6UGRnl4p6utnT37F4=;
        b=UvzolmWpYEyJzarXLllRnqJ9qRIjTu/H5jojxM9143e7AthN4ECQwqTBsQx/4ZyKHx
         IItSbEB5UNZbi9dL5W0+9wvVNF1j2i050BJ6aaIQm264QM3uv14iq9tIB28PGMjiaPgm
         JqaBkQL5/mwvAXaa2b2+ujSXNsaQ2y4o4/CaSfeIWeuP8DcTr/0eUT075PlvMfw4Frss
         iGFWUwmap1Ujlg2jvIPtC9RwmAnPI9TWjJfOyow+Olq30E4CsjsmXFYOvR9CdDtjqJ+Q
         TtlUyqIHBuqf79NxH5rdpfhnLor4Qp6JrDCBhIKNvsu8YA9/vbXqhVgoa2YuNC+Y553G
         DrXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LDIfWEhWO8mVudTFuw38niuUgR6UGRnl4p6utnT37F4=;
        b=izoJyANs8WbBdgeqpzGS7RkleT3FrxURkudAQPAxLu4+H69vTiEY5B1HhWaUwEgxdB
         xAvupAuoZ8k3cXeFCGDECJB69x6uvSnUTI9x32LLxbchqDdysEMyEV43XL/kcctxAQuz
         apBSAQT1wb4t2Za6neb3SpJS4LnVJyS4/P+CFdh6yXk8R30GT4MZo98svwbYPYh4x9hB
         Sdz4al8wilk+R6kzU9ogC4BADnxGaEp2vIdarfvwBUgmzQf24Ka3mI8p7j+8g13LI4A/
         oGK45VfLxYf8KL72b1UPKxE9Odjuxv9Dyt1O7cyVUFN/0Zt5y9hSxFR/YZ8C7qCwK1Nk
         aHtQ==
X-Gm-Message-State: AOAM5337pN3uqByl6NG26jY1hjIM+DJc4J0dE5cb7sw1dIHVlxMFPbYU
        bbevxTj4DsO9Ocxr2QCqgmIrhSBmW4pafA==
X-Google-Smtp-Source: ABdhPJzbczZWhLAF3ylgWjegsy80xxr46YwXW/f9gHPD38R3XLN1AUEBQQ+aJmwYzXcLaIG7PPv+ng==
X-Received: by 2002:a7b:c5d2:: with SMTP id n18mr9990022wmk.97.1629313643865;
        Wed, 18 Aug 2021 12:07:23 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:5c16:403a:870d:fceb? (p200300ea8f0845005c16403a870dfceb.dip0.t-ipconnect.de. [2003:ea:8f08:4500:5c16:403a:870d:fceb])
        by smtp.googlemail.com with ESMTPSA id 7sm6043999wmk.39.2021.08.18.12.07.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 12:07:23 -0700 (PDT)
Subject: [PATCH 8/8] tg3: Use new function pci_vpd_find_ro_info_keyword
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f693b1ae-447c-0eb1-7a9a-d1aaf9a26641@gmail.com>
Message-ID: <0ae9d4c0-590d-682a-a0af-2272e5f71630@gmail.com>
Date:   Wed, 18 Aug 2021 21:06:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <f693b1ae-447c-0eb1-7a9a-d1aaf9a26641@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new VPD API function pci_vpd_find_ro_info_keyword() to simplify
the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 59 ++++++++---------------------
 1 file changed, 16 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 309aec742..6637a97d7 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -15592,63 +15592,36 @@ static int tg3_phy_probe(struct tg3 *tp)
 static void tg3_read_vpd(struct tg3 *tp)
 {
 	u8 *vpd_data;
-	unsigned int block_end, rosize, len, vpdlen;
-	int j, i = 0;
+	unsigned int len, vpdlen;
+	int i;
 
 	vpd_data = (u8 *)tg3_vpd_readblock(tp, &vpdlen);
 	if (!vpd_data)
 		goto out_no_vpd;
 
-	i = pci_vpd_find_tag(vpd_data, vpdlen, PCI_VPD_LRDT_RO_DATA);
+	i = pci_vpd_find_ro_info_keyword(vpd_data, vpdlen,
+					 PCI_VPD_RO_KEYWORD_MFR_ID, &len);
 	if (i < 0)
-		goto out_not_found;
-
-	rosize = pci_vpd_lrdt_size(&vpd_data[i]);
-	block_end = i + PCI_VPD_LRDT_TAG_SIZE + rosize;
-	i += PCI_VPD_LRDT_TAG_SIZE;
-
-	if (block_end > vpdlen)
-		goto out_not_found;
-
-	j = pci_vpd_find_info_keyword(vpd_data, i, rosize,
-				      PCI_VPD_RO_KEYWORD_MFR_ID);
-	if (j > 0) {
-		len = pci_vpd_info_field_size(&vpd_data[j]);
+		goto partno;
 
-		j += PCI_VPD_INFO_FLD_HDR_SIZE;
-		if (j + len > block_end || len != 4 ||
-		    memcmp(&vpd_data[j], "1028", 4))
-			goto partno;
+	if (len != 4 || memcmp(vpd_data + i, "1028", 4))
+		goto partno;
 
-		j = pci_vpd_find_info_keyword(vpd_data, i, rosize,
-					      PCI_VPD_RO_KEYWORD_VENDOR0);
-		if (j < 0)
-			goto partno;
-
-		len = pci_vpd_info_field_size(&vpd_data[j]);
+	i = pci_vpd_find_ro_info_keyword(vpd_data, vpdlen,
+					 PCI_VPD_RO_KEYWORD_VENDOR0, &len);
+	if (i < 0)
+		goto partno;
 
-		j += PCI_VPD_INFO_FLD_HDR_SIZE;
-		if (j + len > block_end)
-			goto partno;
-
-		if (len >= sizeof(tp->fw_ver))
-			len = sizeof(tp->fw_ver) - 1;
-		memset(tp->fw_ver, 0, sizeof(tp->fw_ver));
-		snprintf(tp->fw_ver, sizeof(tp->fw_ver), "%.*s bc ", len,
-			 &vpd_data[j]);
-	}
+	memset(tp->fw_ver, 0, sizeof(tp->fw_ver));
+	snprintf(tp->fw_ver, sizeof(tp->fw_ver), "%.*s bc ", len, vpd_data + i);
 
 partno:
-	i = pci_vpd_find_info_keyword(vpd_data, i, rosize,
-				      PCI_VPD_RO_KEYWORD_PARTNO);
+	i = pci_vpd_find_ro_info_keyword(vpd_data, vpdlen,
+					 PCI_VPD_RO_KEYWORD_PARTNO, &len);
 	if (i < 0)
 		goto out_not_found;
 
-	len = pci_vpd_info_field_size(&vpd_data[i]);
-
-	i += PCI_VPD_INFO_FLD_HDR_SIZE;
-	if (len > TG3_BPN_SIZE ||
-	    (len + i) > vpdlen)
+	if (len > TG3_BPN_SIZE)
 		goto out_not_found;
 
 	memcpy(tp->board_part_number, &vpd_data[i], len);
-- 
2.32.0


