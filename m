Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 692714E1DB1
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 20:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343638AbiCTUAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 16:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343627AbiCTT74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 15:59:56 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8473C36E25
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 12:58:32 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id t187so8904143pgb.1
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 12:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Nkux6K8D2N0KzkeTeO7biUJw+8VehVM2FBf9QijE0w8=;
        b=X4XJn2MlFK9ZoXoL23zBknpMxflUXksLWUqSpWtvt5DcDOjcxmyrvitFc7e1e9fnFU
         b7nnBb6hLKi0JYvk3dbA2xrOwZd0MblQv0nhhRkAHbiDV/DqB4XrVP4DVmeDhSZIwsio
         kYzKkS6Q0TdHGTYCKpDU4DyzaZ4LJgt6sdeF4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Nkux6K8D2N0KzkeTeO7biUJw+8VehVM2FBf9QijE0w8=;
        b=tgCRsU99JXN1qHYChPP3R5fYBXnjHEEEEplrM6d6WrErLW6v8ICC1JVMKLTegYA75k
         whw9zbsPbnJNdLgMfvyvh7r0H1t7UTmfXbpwyw6TzZKwUcisnk47HnJtr7Zb/tNUqkZn
         Vntz5XWPdlBEnONwtyCMK/qtxgZ9GP/ScYNXGYtbqU/YHUtcemCY+QWLQP59o6ga8ELP
         KZbBgq3s/YvHIHV3SiMl+jyyQLU8PujI+/hIq+IitFe4zcVQ1mopegnCNrMRwNGIYdHx
         4aIMamC/N+OSJSeDm+/Orj0yIb6/ubFcdf8nSDAM1DJaOM73GSrpLBIlEbs6vVWXmKaN
         u+hQ==
X-Gm-Message-State: AOAM533MH2Uqi2sCzRItCyFdvirDjH2i1nBWzOq4SleZx8IneVIOiYvt
        jgA0gFZtKB4K6bQkmbMlKvA48yQvVsANZg==
X-Google-Smtp-Source: ABdhPJx1V2YJbpF8PLkSAoyCajTzW4TkY37it/3BeoqcXNlec8pavlHr3NMMYoAjT9I9hHYtxSrj/w==
X-Received: by 2002:a05:6a00:140c:b0:4e1:530c:edc0 with SMTP id l12-20020a056a00140c00b004e1530cedc0mr20437566pfu.18.1647806311620;
        Sun, 20 Mar 2022 12:58:31 -0700 (PDT)
Received: from localhost.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a001a4a00b004f7c76f29c3sm16418335pfv.24.2022.03.20.12.58.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Mar 2022 12:58:31 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next v2 08/11] bnxt: add page_pool support for aggregation ring when using xdp
Date:   Sun, 20 Mar 2022 15:58:01 -0400
Message-Id: <1647806284-8529-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1647806284-8529-1-git-send-email-michael.chan@broadcom.com>
References: <1647806284-8529-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e4f40f05daabcd1a"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000e4f40f05daabcd1a

From: Andy Gospodarek <gospo@broadcom.com>

If we are using aggregation rings with XDP enabled, allocate page
buffers for the aggregation rings from the page_pool.

Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 77 ++++++++++++++---------
 1 file changed, 47 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b635b7ce6ba3..980c176d7c88 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -739,7 +739,6 @@ static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
 		page_pool_recycle_direct(rxr->page_pool, page);
 		return NULL;
 	}
-	*mapping += bp->rx_dma_offset;
 	return page;
 }
 
@@ -781,6 +780,7 @@ int bnxt_alloc_rx_data(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 		if (!page)
 			return -ENOMEM;
 
+		mapping += bp->rx_dma_offset;
 		rx_buf->data = page;
 		rx_buf->data_ptr = page_address(page) + bp->rx_offset;
 	} else {
@@ -841,33 +841,41 @@ static inline int bnxt_alloc_rx_page(struct bnxt *bp,
 	u16 sw_prod = rxr->rx_sw_agg_prod;
 	unsigned int offset = 0;
 
-	if (PAGE_SIZE > BNXT_RX_PAGE_SIZE) {
-		page = rxr->rx_page;
-		if (!page) {
+	if (BNXT_RX_PAGE_MODE(bp)) {
+		page = __bnxt_alloc_rx_page(bp, &mapping, rxr, gfp);
+
+		if (!page)
+			return -ENOMEM;
+
+	} else {
+		if (PAGE_SIZE > BNXT_RX_PAGE_SIZE) {
+			page = rxr->rx_page;
+			if (!page) {
+				page = alloc_page(gfp);
+				if (!page)
+					return -ENOMEM;
+				rxr->rx_page = page;
+				rxr->rx_page_offset = 0;
+			}
+			offset = rxr->rx_page_offset;
+			rxr->rx_page_offset += BNXT_RX_PAGE_SIZE;
+			if (rxr->rx_page_offset == PAGE_SIZE)
+				rxr->rx_page = NULL;
+			else
+				get_page(page);
+		} else {
 			page = alloc_page(gfp);
 			if (!page)
 				return -ENOMEM;
-			rxr->rx_page = page;
-			rxr->rx_page_offset = 0;
 		}
-		offset = rxr->rx_page_offset;
-		rxr->rx_page_offset += BNXT_RX_PAGE_SIZE;
-		if (rxr->rx_page_offset == PAGE_SIZE)
-			rxr->rx_page = NULL;
-		else
-			get_page(page);
-	} else {
-		page = alloc_page(gfp);
-		if (!page)
-			return -ENOMEM;
-	}
 
-	mapping = dma_map_page_attrs(&pdev->dev, page, offset,
-				     BNXT_RX_PAGE_SIZE, DMA_FROM_DEVICE,
-				     DMA_ATTR_WEAK_ORDERING);
-	if (dma_mapping_error(&pdev->dev, mapping)) {
-		__free_page(page);
-		return -EIO;
+		mapping = dma_map_page_attrs(&pdev->dev, page, offset,
+					     BNXT_RX_PAGE_SIZE, DMA_FROM_DEVICE,
+					     DMA_ATTR_WEAK_ORDERING);
+		if (dma_mapping_error(&pdev->dev, mapping)) {
+			__free_page(page);
+			return -EIO;
+		}
 	}
 
 	if (unlikely(test_bit(sw_prod, rxr->rx_agg_bmap)))
@@ -1105,7 +1113,7 @@ static u32 __bnxt_rx_agg_pages(struct bnxt *bp,
 		}
 
 		dma_unmap_page_attrs(&pdev->dev, mapping, BNXT_RX_PAGE_SIZE,
-				     DMA_FROM_DEVICE,
+				     bp->rx_dir,
 				     DMA_ATTR_WEAK_ORDERING);
 
 		total_frag_len += frag_len;
@@ -2936,14 +2944,23 @@ static void bnxt_free_one_rx_ring_skbs(struct bnxt *bp, int ring_nr)
 		if (!page)
 			continue;
 
-		dma_unmap_page_attrs(&pdev->dev, rx_agg_buf->mapping,
-				     BNXT_RX_PAGE_SIZE, DMA_FROM_DEVICE,
-				     DMA_ATTR_WEAK_ORDERING);
+		if (BNXT_RX_PAGE_MODE(bp)) {
+			dma_unmap_page_attrs(&pdev->dev, rx_agg_buf->mapping,
+					     BNXT_RX_PAGE_SIZE, bp->rx_dir,
+					     DMA_ATTR_WEAK_ORDERING);
+			rx_agg_buf->page = NULL;
+			__clear_bit(i, rxr->rx_agg_bmap);
 
-		rx_agg_buf->page = NULL;
-		__clear_bit(i, rxr->rx_agg_bmap);
+			page_pool_recycle_direct(rxr->page_pool, page);
+		} else {
+			dma_unmap_page_attrs(&pdev->dev, rx_agg_buf->mapping,
+					     BNXT_RX_PAGE_SIZE, DMA_FROM_DEVICE,
+					     DMA_ATTR_WEAK_ORDERING);
+			rx_agg_buf->page = NULL;
+			__clear_bit(i, rxr->rx_agg_bmap);
 
-		__free_page(page);
+			__free_page(page);
+		}
 	}
 
 skip_rx_agg_free:
-- 
2.18.1


--000000000000e4f40f05daabcd1a
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFMolila4rw+wpVk0naNQxowGmbpQNSW
WScz1EawDmU3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMy
MDE5NTgzMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBlNs+J5vnImEgPEwplcPthpN7XymiHKmtoP4pcoSbgyTLkh9C6
kVQ/GmeQ5/IgmnLB+uDWOFokhun+gR2xpYeVi1O7QAdnPku0ooxMGbOQg6HNHvFwo6lnwaQJz9WN
2EDGMbhT8TTQyxvZ7ABdywpzv/Ah2UMi6CZgkcSJnIl+QMyU7WCIsQ7H1qaJ/exWGaJZ+J63pFgV
rOFn0//agd113Gdnmbf2OUUIwO8Qdc44yudJc6eBGLPD0zAyeLtAKSiHCE8Vzz+PFZ/5gFiYVV4F
mSxCz2OfQyx/kesTcf0QvODzIlzdcNnZzvoAXMfUzLDTrOuA3rBcHctL+dGU5OIO
--000000000000e4f40f05daabcd1a--
