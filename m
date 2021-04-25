Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3EB36A8A3
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 19:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhDYRqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 13:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbhDYRqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 13:46:34 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC035C061343
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 10:45:53 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id f29so1472782pgm.8
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 10:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=O0DgEQgiV9uHjNOx+zVysSmGekJkEFhquaqvVj8e8VQ=;
        b=SCq9UC4Z6m63f9Q5hQnlKkdlXl7CAEONxOX319PaqYcLCmKOSmXEBn4deFHlX0FD3h
         0h7GwB3l/05G6DgLRgfJmkqhntRfE8IQuqudKr2PYErJW0I/3yZl460glps7Sb9VGi/a
         uJc9eJkuiCVIHn/Zhrskp+E8otzmBFi6zI8NM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=O0DgEQgiV9uHjNOx+zVysSmGekJkEFhquaqvVj8e8VQ=;
        b=Yy1UjVdTeFdzMiw3JUTTld9f0S55Q8zm5oKGRgKJzF/ID4JgHE5dPTnF5M95T6N51H
         umSBH9IzLLOuXj2D9aK8WREb+P0xEi/tz7ah2We0lgzzhPSQ/hbdK287OlPNlvuO5PMm
         1QZrEZmtI7tmiRZyvpm02bG3gKh/qLxoibDnFWvRzieegsMTxsmdQk7mtnLZ/9vNRfdH
         QPOTUVlV4LftzQJmXG4NYYNpbay22lAMtP8wrfEur12ItdJmaEdk1HkfVhnxph0icLme
         LYiSHoS/SEVINnGwqJOl1ZpjV1AQYezhscsNlQfwAOtmsMvVamuYLV+dqIpo08yNE3YN
         g/Jg==
X-Gm-Message-State: AOAM533xZMSSQf6KF/I+lR7fcAHuOqDjXR4S1XE9y+GJlSlVer3IASo5
        no9rylZ9wRsuvsFSaJwQ7bLtkQ==
X-Google-Smtp-Source: ABdhPJycaaVUzGbFlN9Gn245ajKa1TqBPe6GvXp+Vz+D8yKGRwl+PlkMYkWCKfNA+Rfmt7VCqLZ3Rw==
X-Received: by 2002:a63:b915:: with SMTP id z21mr13166021pge.424.1619372752939;
        Sun, 25 Apr 2021 10:45:52 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm14733553pjs.1.2021.04.25.10.45.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Apr 2021 10:45:52 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next v2 09/10] bnxt_en: Support IFF_SUPP_NOFCS feature to transmit without ethernet FCS.
Date:   Sun, 25 Apr 2021 13:45:26 -0400
Message-Id: <1619372727-19187-10-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619372727-19187-1-git-send-email-michael.chan@broadcom.com>
References: <1619372727-19187-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000bd97ed05c0cf9944"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000bd97ed05c0cf9944

If firmware is capable, set the IFF_SUPP_NOFCS flag to support the
sockets option to transmit packets without FCS.  This is mainly used
for testing.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 16 +++++++++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 77ebafbd2dce..53db073b457c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -375,6 +375,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct pci_dev *pdev = bp->pdev;
 	struct bnxt_tx_ring_info *txr;
 	struct bnxt_sw_tx_bd *tx_buf;
+	__le32 lflags = 0;
 
 	i = skb_get_queue_mapping(skb);
 	if (unlikely(i >= bp->tx_nr_rings)) {
@@ -416,6 +417,11 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			vlan_tag_flags |= 1 << TX_BD_CFA_META_TPID_SHIFT;
 	}
 
+	if (unlikely(skb->no_fcs)) {
+		lflags |= cpu_to_le32(TX_BD_FLAGS_NO_CRC);
+		goto normal_tx;
+	}
+
 	if (free_size == bp->tx_ring_size && length <= bp->tx_push_thresh) {
 		struct tx_push_buffer *tx_push_buf = txr->tx_push;
 		struct tx_push_bd *tx_push = &tx_push_buf->push_bd;
@@ -517,7 +523,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	txbd1 = (struct tx_bd_ext *)
 		&txr->tx_desc_ring[TX_RING(prod)][TX_IDX(prod)];
 
-	txbd1->tx_bd_hsize_lflags = 0;
+	txbd1->tx_bd_hsize_lflags = lflags;
 	if (skb_is_gso(skb)) {
 		u32 hdr_len;
 
@@ -529,14 +535,14 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			hdr_len = skb_transport_offset(skb) +
 				tcp_hdrlen(skb);
 
-		txbd1->tx_bd_hsize_lflags = cpu_to_le32(TX_BD_FLAGS_LSO |
+		txbd1->tx_bd_hsize_lflags |= cpu_to_le32(TX_BD_FLAGS_LSO |
 					TX_BD_FLAGS_T_IPID |
 					(hdr_len << (TX_BD_HSIZE_SHIFT - 1)));
 		length = skb_shinfo(skb)->gso_size;
 		txbd1->tx_bd_mss = cpu_to_le32(length);
 		length += hdr_len;
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		txbd1->tx_bd_hsize_lflags =
+		txbd1->tx_bd_hsize_lflags |=
 			cpu_to_le32(TX_BD_FLAGS_TCP_UDP_CHKSUM);
 		txbd1->tx_bd_mss = 0;
 	}
@@ -12460,6 +12466,10 @@ static int bnxt_probe_phy(struct bnxt *bp, bool fw_dflt)
 			   rc);
 		return rc;
 	}
+	if (bp->phy_flags & BNXT_PHY_FL_NO_FCS)
+		bp->dev->priv_flags |= IFF_SUPP_NOFCS;
+	else
+		bp->dev->priv_flags &= ~IFF_SUPP_NOFCS;
 	if (!fw_dflt)
 		return 0;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 5835d8ca8c22..a3744247740b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2015,6 +2015,7 @@ struct bnxt {
 #define BNXT_PHY_FL_PORT_STATS_NO_RESET	PORT_PHY_QCAPS_RESP_FLAGS_CUMULATIVE_COUNTERS_ON_RESET
 #define BNXT_PHY_FL_NO_PHY_LPBK		PORT_PHY_QCAPS_RESP_FLAGS_LOCAL_LPBK_NOT_SUPPORTED
 #define BNXT_PHY_FL_FW_MANAGED_LKDN	PORT_PHY_QCAPS_RESP_FLAGS_FW_MANAGED_LINK_DOWN
+#define BNXT_PHY_FL_NO_FCS		PORT_PHY_QCAPS_RESP_FLAGS_NO_FCS
 
 	u8			num_tests;
 	struct bnxt_test_info	*test_info;
-- 
2.18.1


--000000000000bd97ed05c0cf9944
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIDoh0LEpClfeQ9cUDRhGiqeBsGL+C7Le
SOn1f4N85HEHMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDQy
NTE3NDU1M1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAY2wtW/yWPwJDxnIIbrQ/w+bSe8BcOArkR5yhbRi1ZBNHwPolC
LohVlG2Pzop9P5vyfgCeBSn36c7D5Dxb+3Mh7PNXuzRSuGafsgAIhSZgax5ql3E6HKyfIRS3y9il
aICF1CLajmozgbHyg+Os+Ldnk++MRAtaUKKfmdE6M8KpLTYoQ6+0suctqN3ZGnkYeOkas33ABKOY
x4EZeJOMbynNK8yfwS66DSvGwuttTi3tPxM8pQkXMKeRpyfrfH6qNXbDIpGr8sA1B3Fi1mcMkXBP
/7171wA2LCDXN2tYZKo4fL4eJpVgi1XF18RF4yNjw5RVZasDD7G8xQqzKtFfjTNV
--000000000000bd97ed05c0cf9944--
