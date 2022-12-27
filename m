Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 211A365671A
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 04:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbiL0DUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 22:20:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbiL0DU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 22:20:29 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052AEF48
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 19:20:27 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id c11so9650011qtn.11
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 19:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qDHQY1jECbTIktLSU8D2ICoxwBl+JWDmII5H2DK8pGg=;
        b=cgjJH+vqR6iuCpmIesjy761XgbSBTPb7KArYLyUQa/NZMSeqNTOQjw8tOdt6V666XZ
         QAegC7XkfPkGT52CgMCqWlb4Dj3Svxh4Ee4UGDVDJKT2WqSKET7tkesUZcRZ6Hk0W36z
         Z9WSsNJDxe1/9N3Vch/epm+iNbA56nlYxJFPY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qDHQY1jECbTIktLSU8D2ICoxwBl+JWDmII5H2DK8pGg=;
        b=y7+WpeSiK/+iFGCIKqMjtgmuCck7Ilr0rVgNY/bhdBfGV5BpQwO54WYBXVw+xAHeb2
         PaQ+SdO6mhVBwtuEMfVYQuOmFF6YTjGaLM6YE4etzZCtrZC8sA2/UbVAufhbOv/cGKKu
         23FCA04oB1fMyjOLTdADdi+rMMNo/2JP4hKvcAXTflkFAR2grPICQpNRNrx/P8gQxOAy
         hxVGU/6u1JN5eL05AdYHu5N4NdGCNTtBhp8i3G5FK8uMSRvnsz2jxURxk64DnU056BlQ
         SZXS70rSggUF7N8rNw4QOUDsY+dSfc0lFiDLEuaGHkPFS2IKP2ebTHPKQh8A4pR1YsQg
         9b2A==
X-Gm-Message-State: AFqh2kqBsezHb4TOioEtPDCzN0cPb9aeNANvFAP+72tIcwngYQIf20oS
        Z/h5Rj4xTNrPzOIlN23cbCWLkg==
X-Google-Smtp-Source: AMrXdXvFIPFkx+yW03Oq+y5mlAOXXHT7xdZUhi5KWyehMv74qDVIcmuC2897u3qCSx/BoQOvhZuchg==
X-Received: by 2002:ac8:4656:0:b0:3a8:4b7:5bcb with SMTP id f22-20020ac84656000000b003a804b75bcbmr25869324qto.62.1672111226452;
        Mon, 26 Dec 2022 19:20:26 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id fa11-20020a05622a4ccb00b003a68fe872a5sm7751262qtb.96.2022.12.26.19.20.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Dec 2022 19:20:25 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, bpf@vger.kernel.org, gospo@broadcom.com
Subject: [PATCH net 4/5] bnxt_en: Fix first buffer size calculations for XDP multi-buffer
Date:   Mon, 26 Dec 2022 22:19:39 -0500
Message-Id: <1672111180-19463-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1672111180-19463-1-git-send-email-michael.chan@broadcom.com>
References: <1672111180-19463-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000b4501a05f0c6bb19"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_TVD_MIME_NO_HEADERS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000b4501a05f0c6bb19

The size of the first buffer is always page size, and the useable
space is the page size minus the offset and the skb_shared_info size.
Make sure SKB and XDP buf sizes match so that the skb_shared_info
is at the same offset seen from the SKB and XDP_BUF.

build_skb() should be passed PAGE_SIZE.  xdp_init_buff() should
be passed PAGE_SIZE as well.  xdp_get_shared_info_from_buff() will
automatically deduct the skb_shared_info size if the XDP buffer
has frags.  There is no need to keep bp->xdp_has_frags.

Change BNXT_PAGE_MODE_BUF_SIZE to BNXT_MAX_PAGE_MODE_MTU_SBUF
since this constant is really the MTU with ethernet header size
subtracted.

Also fix the BNXT_MAX_PAGE_MODE_MTU macro with proper parentheses.

Fixes: 32861236190b ("bnxt: change receive ring space parameters")
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  9 +++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     | 15 +++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  7 +------
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 1acabfe26db1..a21c6829e301 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -991,8 +991,7 @@ static struct sk_buff *bnxt_rx_multi_page_skb(struct bnxt *bp,
 	dma_addr -= bp->rx_dma_offset;
 	dma_unmap_page_attrs(&bp->pdev->dev, dma_addr, PAGE_SIZE, bp->rx_dir,
 			     DMA_ATTR_WEAK_ORDERING);
-	skb = build_skb(page_address(page), BNXT_PAGE_MODE_BUF_SIZE +
-					    bp->rx_dma_offset);
+	skb = build_skb(page_address(page), PAGE_SIZE);
 	if (!skb) {
 		__free_page(page);
 		return NULL;
@@ -3969,8 +3968,10 @@ void bnxt_set_ring_params(struct bnxt *bp)
 		bp->rx_agg_ring_mask = (bp->rx_agg_nr_pages * RX_DESC_CNT) - 1;
 
 		if (BNXT_RX_PAGE_MODE(bp)) {
-			rx_space = BNXT_PAGE_MODE_BUF_SIZE;
-			rx_size = BNXT_MAX_PAGE_MODE_MTU;
+			rx_space = PAGE_SIZE;
+			rx_size = PAGE_SIZE -
+				  ALIGN(max(NET_SKB_PAD, XDP_PACKET_HEADROOM), 8) -
+				  SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 		} else {
 			rx_size = SKB_DATA_ALIGN(BNXT_RX_COPY_THRESH + NET_IP_ALIGN);
 			rx_space = rx_size + NET_SKB_PAD +
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 41c6dd0ae447..5163ef4a49ea 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -591,12 +591,20 @@ struct nqe_cn {
 #define BNXT_RX_PAGE_SIZE (1 << BNXT_RX_PAGE_SHIFT)
 
 #define BNXT_MAX_MTU		9500
-#define BNXT_PAGE_MODE_BUF_SIZE \
+
+/* First RX buffer page in XDP multi-buf mode
+ *
+ * +-------------------------------------------------------------------------+
+ * | XDP_PACKET_HEADROOM | bp->rx_buf_use_size              | skb_shared_info|
+ * | (bp->rx_dma_offset) |                                  |                |
+ * +-------------------------------------------------------------------------+
+ */
+#define BNXT_MAX_PAGE_MODE_MTU_SBUF \
 	((unsigned int)PAGE_SIZE - VLAN_ETH_HLEN - NET_IP_ALIGN -	\
 	 XDP_PACKET_HEADROOM)
 #define BNXT_MAX_PAGE_MODE_MTU	\
-	BNXT_PAGE_MODE_BUF_SIZE - \
-	SKB_DATA_ALIGN((unsigned int)sizeof(struct skb_shared_info))
+	(BNXT_MAX_PAGE_MODE_MTU_SBUF - \
+	 SKB_DATA_ALIGN((unsigned int)sizeof(struct skb_shared_info)))
 
 #define BNXT_MIN_PKT_SIZE	52
 
@@ -2134,7 +2142,6 @@ struct bnxt {
 #define BNXT_DUMP_CRASH		1
 
 	struct bpf_prog		*xdp_prog;
-	u8			xdp_has_frags;
 
 	struct bnxt_ptp_cfg	*ptp_cfg;
 	u8			ptp_all_rx_tstamp;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 2ceeaa818c1c..36d5202c0aee 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -193,9 +193,6 @@ void bnxt_xdp_buff_init(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 	mapping = rx_buf->mapping - bp->rx_dma_offset;
 	dma_sync_single_for_cpu(&pdev->dev, mapping + offset, len, bp->rx_dir);
 
-	if (bp->xdp_has_frags)
-		buflen = BNXT_PAGE_MODE_BUF_SIZE + offset;
-
 	xdp_init_buff(xdp, buflen, &rxr->xdp_rxq);
 	xdp_prepare_buff(xdp, data_ptr - offset, offset, len, false);
 }
@@ -404,10 +401,8 @@ static int bnxt_xdp_set(struct bnxt *bp, struct bpf_prog *prog)
 		netdev_warn(dev, "ethtool rx/tx channels must be combined to support XDP.\n");
 		return -EOPNOTSUPP;
 	}
-	if (prog) {
+	if (prog)
 		tx_xdp = bp->rx_nr_rings;
-		bp->xdp_has_frags = prog->aux->xdp_has_frags;
-	}
 
 	tc = netdev_get_num_tc(dev);
 	if (!tc)
-- 
2.18.1


--000000000000b4501a05f0c6bb19
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFpKLeYdIwPfXiwII4wWW4ysg3JoArOL
BgtTdEuZkCwUMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTIy
NzAzMjAyNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCC7lGZu1UrYm51w1z7VsVq4YoOQw1G4C6fYF97YiFb0IrGZaaF
hnklTlaAQdS3h5wsPxsJ0F0cpCrN3iQQC13QSCetnd8/EQLw6BBT+1/YfwKpJj6IJ6d1RnUqxAMe
bRo3gPnPcdW2vM7apWa5CWZz8yyBklPP5yN7mbH5yzKD9iH3mp/zzGRSIBq3NGPdMePkTsgyIdji
pe4JfUIX8T20NYM+9Rr7NOfDn+bK9AS1w43CrZ2p1FON741u//OAXss8ZC71mc2W3gP7RFwEvGXV
y1gbeUtlPWE1bG2F22bdbVJepWIgW3hUDvaBtRtZpuIe2xG1KBnCaO+PaDnjNNvg
--000000000000b4501a05f0c6bb19--
