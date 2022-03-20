Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B2A4E1DA9
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 20:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343637AbiCTUAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 16:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343621AbiCTT7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 15:59:55 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCF636B46
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 12:58:31 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id c2so8898569pga.10
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 12:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vXwKl0hJ8UxJdPWcuV1zuggAEwb0Wv4WszfUSBBYtoE=;
        b=Gg1iB2pGlcRAPd+ks3oa6q0gfeTfwCVFbx0ObD4jQ+N8xmYKKP30ICMaSTrBEmicOp
         eqE+pfS/aViSlfpI03ZnQKtYnVwlK86yYfugqDcBf+6oXpoSoJoa5fR+kqps7KJemcSP
         nJHez2w6wwcqhTsoTz0zaDjZn6ijQMm+xu3hE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vXwKl0hJ8UxJdPWcuV1zuggAEwb0Wv4WszfUSBBYtoE=;
        b=w2R3hqggZIB/t7vFMLfLAttFW+FbpCPDPXqgl7Mab6WAmOcZIw5/PSI6ZAg+oDqCfM
         LIPtKlRine3HZYBWiQ9JExVq6cyCY/uxPdxQEe0efAqaHWrFWuCbJdjp7TfUvzt4GUCx
         SH4PrvO9vkNGRXaR+O6pEH/l1tb05QOeMnsebafxmPGSpCeY7btPAXCOXmE+UXI/qDDX
         nWp0bHvLXXEOm51M5XZN8XCsnAHaxLNk9Afa1V5ib0BzeCN7FjXzh4YG4/MxdqP7+vCX
         lqif1P+uKPaliiydHxiInYVp4CyiqHuH3eOHP6971yNTRqZfCPrqshtKgST0sBRtcmF4
         H6ow==
X-Gm-Message-State: AOAM531co1xeMSKBGa4YDes/O68UluwDVay2xxef2MopyX/lkT7JjC0a
        UIjt7MkbN31u2lsFBo1yCpzxZA==
X-Google-Smtp-Source: ABdhPJxhTrkBbg7CT4Jv68P37TsD6P/YTK++qy3RHATEpaE265PsOCO8o5ItJTU+5CARwysgXX802g==
X-Received: by 2002:a05:6a00:2295:b0:4f7:9bf8:57cc with SMTP id f21-20020a056a00229500b004f79bf857ccmr19914633pfe.79.1647806310416;
        Sun, 20 Mar 2022 12:58:30 -0700 (PDT)
Received: from localhost.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a001a4a00b004f7c76f29c3sm16418335pfv.24.2022.03.20.12.58.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Mar 2022 12:58:30 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next v2 07/11] bnxt: change receive ring space parameters
Date:   Sun, 20 Mar 2022 15:58:00 -0400
Message-Id: <1647806284-8529-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1647806284-8529-1-git-send-email-michael.chan@broadcom.com>
References: <1647806284-8529-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d1922d05daabcd0d"
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

--000000000000d1922d05daabcd0d

From: Andy Gospodarek <gospo@broadcom.com>

Modify ring header data split and jumbo parameters to account
for the fact that the design for XDP multibuffer puts close to
the first 4k of data in a page and the remaining portions of
the packet go in the aggregation ring.

Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 44 +++++++++++++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 05f4b3fbf2e3..b635b7ce6ba3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -56,6 +56,7 @@
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 #include <net/page_pool.h>
+#include <linux/align.h>
 
 #include "bnxt_hsi.h"
 #include "bnxt.h"
@@ -1933,11 +1934,13 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	}
 
 	if (agg_bufs) {
-		skb = bnxt_rx_agg_pages_skb(bp, cpr, skb, cp_cons, agg_bufs, false);
-		if (!skb) {
-			cpr->sw_stats.rx.rx_oom_discards += 1;
-			rc = -ENOMEM;
-			goto next_rx;
+		if (!xdp_active) {
+			skb = bnxt_rx_agg_pages_skb(bp, cpr, skb, cp_cons, agg_bufs, false);
+			if (!skb) {
+				cpr->sw_stats.rx.rx_oom_discards += 1;
+				rc = -ENOMEM;
+				goto next_rx;
+			}
 		}
 	}
 
@@ -3853,7 +3856,7 @@ void bnxt_set_ring_params(struct bnxt *bp)
 	/* 8 for CRC and VLAN */
 	rx_size = SKB_DATA_ALIGN(bp->dev->mtu + ETH_HLEN + NET_IP_ALIGN + 8);
 
-	rx_space = rx_size + NET_SKB_PAD +
+	rx_space = rx_size + ALIGN(max(NET_SKB_PAD, XDP_PACKET_HEADROOM), 8) +
 		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
 	bp->rx_copy_thresh = BNXT_RX_COPY_THRESH;
@@ -3894,9 +3897,17 @@ void bnxt_set_ring_params(struct bnxt *bp)
 		}
 		bp->rx_agg_ring_size = agg_ring_size;
 		bp->rx_agg_ring_mask = (bp->rx_agg_nr_pages * RX_DESC_CNT) - 1;
-		rx_size = SKB_DATA_ALIGN(BNXT_RX_COPY_THRESH + NET_IP_ALIGN);
-		rx_space = rx_size + NET_SKB_PAD +
-			SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+
+		if (BNXT_RX_PAGE_MODE(bp)) {
+			rx_space = PAGE_SIZE;
+			rx_size = rx_space - SKB_DATA_ALIGN(ETH_HLEN + NET_IP_ALIGN + 8) -
+				  ALIGN(max(NET_SKB_PAD, XDP_PACKET_HEADROOM), 8) -
+				  2 * SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+		} else {
+			rx_size = SKB_DATA_ALIGN(BNXT_RX_COPY_THRESH + NET_IP_ALIGN);
+			rx_space = rx_size + NET_SKB_PAD +
+				SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+		}
 	}
 
 	bp->rx_buf_use_size = rx_size;
@@ -5286,12 +5297,15 @@ static int bnxt_hwrm_vnic_set_hds(struct bnxt *bp, u16 vnic_id)
 	if (rc)
 		return rc;
 
-	req->flags = cpu_to_le32(VNIC_PLCMODES_CFG_REQ_FLAGS_JUMBO_PLACEMENT |
-				 VNIC_PLCMODES_CFG_REQ_FLAGS_HDS_IPV4 |
-				 VNIC_PLCMODES_CFG_REQ_FLAGS_HDS_IPV6);
-	req->enables =
-		cpu_to_le32(VNIC_PLCMODES_CFG_REQ_ENABLES_JUMBO_THRESH_VALID |
-			    VNIC_PLCMODES_CFG_REQ_ENABLES_HDS_THRESHOLD_VALID);
+	req->flags = cpu_to_le32(VNIC_PLCMODES_CFG_REQ_FLAGS_JUMBO_PLACEMENT);
+	req->enables = cpu_to_le32(VNIC_PLCMODES_CFG_REQ_ENABLES_JUMBO_THRESH_VALID);
+
+	if (BNXT_RX_PAGE_MODE(bp) && !BNXT_RX_JUMBO_MODE(bp)) {
+		req->flags |= cpu_to_le32(VNIC_PLCMODES_CFG_REQ_FLAGS_HDS_IPV4 |
+					  VNIC_PLCMODES_CFG_REQ_FLAGS_HDS_IPV6);
+		req->enables |=
+			cpu_to_le32(VNIC_PLCMODES_CFG_REQ_ENABLES_HDS_THRESHOLD_VALID);
+	}
 	/* thresholds not implemented in firmware yet */
 	req->jumbo_thresh = cpu_to_le16(bp->rx_copy_thresh);
 	req->hds_threshold = cpu_to_le16(bp->rx_copy_thresh);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 447a9406b8a2..9e2dabb58519 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1814,6 +1814,7 @@ struct bnxt {
 #define BNXT_SUPPORTS_TPA(bp)	(!BNXT_CHIP_TYPE_NITRO_A0(bp) &&	\
 				 (!((bp)->flags & BNXT_FLAG_CHIP_P5) ||	\
 				  (bp)->max_tpa_v2) && !is_kdump_kernel())
+#define BNXT_RX_JUMBO_MODE(bp)	((bp)->flags & BNXT_FLAG_JUMBO)
 
 #define BNXT_CHIP_SR2(bp)			\
 	((bp)->chip_num == CHIP_NUM_58818)
-- 
2.18.1


--000000000000d1922d05daabcd0d
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILxf1jauKqqC37E2O07AOfCHDpoxzut5
E7PwmBJRo3JFMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMy
MDE5NTgzMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCv1OVHol8brsQrUMyPq9ONCs3rxAogZMjqKAUJqoFqCUmLMLhx
RZJCbT9Sw9kS+yo4jdI3KqcDJe5CS7RQLbOS50s57iohrrRFzDOH56SMaDXdICsSPZJaBVsBncqW
lWUzNk4II336G4wjave9u2Uoe5JtRk5oxzKFqBWdfFTFkpVYb6qaZEpIUuiDT95MHEZb5fW8wAw6
y/ykg4WRVAiVc8Z9PbIhCrhYk9rScRZjwpF4psSks83Dd9k/zpHv70dy+P7QG4jorr6TmhhhNrwo
S0VAv4rmX7C3ZN2gT/foB+Oi3L7uO9HvWLQflUM1k8e09CPwGkA3fJ3wKy6w5QXK
--000000000000d1922d05daabcd0d--
