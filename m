Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56CA761E7D8
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 01:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiKGAQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 19:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbiKGAQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 19:16:51 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF396338
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 16:16:50 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id e15so7154293qvo.4
        for <netdev@vger.kernel.org>; Sun, 06 Nov 2022 16:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ARyHtJEnkviKQ/DcxnOAH02UabL1XbI/h1e+tXdCylI=;
        b=fgoxz2Ga81TOmSZMxxF5KKXHc/+Z1nWZ1gVi+60n4HvMwTKBgLAzT9/j5b2NLLHe3R
         nbhS0e47PAi7EaNnJr0HsPFUcwYKeY2B69vv9sfK3NTqbQgknOoC1vWLTK0IifqJ++nX
         PayAgr+brhIAg1cw90jULKxNs1TX8dkFyy6Pg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ARyHtJEnkviKQ/DcxnOAH02UabL1XbI/h1e+tXdCylI=;
        b=Pqqn1Dob89N/Q9ZxxT/x4V/a8hcVzg8fRXvzzIDpKwJwqEVd2eZfVbOzVYaqRS26sb
         VygEgAgBtIc6nX/FHldmCgmfdvR18UZlGmS7iCUUzdDJXLYQpEM23wihM6p3Lx/kJdR4
         ZyauT1c/W4f+BtyV/SipmcEj7CHH7/cW+gXAoU+C0F8tCmMpum3H7oYa1RRVi2QA+orE
         IMmts83j4aaj0cxL9jczuf8CIDGvNJnzbpQedKvVw1nwrv2dQT0B/kfa/Lyn8GyjEp8i
         BHQQVF2ega4T6pBqId8j8cpGJWr+6o7dy8TmVocMgDylH5Df0DwVupSBoYq/PtQIW4cf
         TKyA==
X-Gm-Message-State: ACrzQf2QfNPoek9HzHwojR4vrz+Y9BU5t1Xmb+pawarHAxDMp5UUD8/m
        1h6cWCDWD0qehaw1DfT3AWFy8g==
X-Google-Smtp-Source: AMsMyM4fyHLHemmTqZkFVGGzFnSwsf+JqRf9JlkmjzuR/L/V8IGzT2ZVfDk+cmRvVy4Sm47wCagTFg==
X-Received: by 2002:ad4:5dee:0:b0:4b4:b8a:78db with SMTP id jn14-20020ad45dee000000b004b40b8a78dbmr42705140qvb.12.1667780209334;
        Sun, 06 Nov 2022 16:16:49 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k2-20020ac80742000000b0035badb499c7sm4904079qth.21.2022.11.06.16.16.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Nov 2022 16:16:48 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, gospo@broadcom.com, pavan.chebbi@broadcom.com
Subject: [PATCH net-next 2/3] bnxt_en: update RSS config using difference algorithm
Date:   Sun,  6 Nov 2022 19:16:31 -0500
Message-Id: <1667780192-3700-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1667780192-3700-1-git-send-email-michael.chan@broadcom.com>
References: <1667780192-3700-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000f8189905ecd65681"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_TVD_MIME_NO_HEADERS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000f8189905ecd65681

From: Edwin Peer <edwin.peer@broadcom.com>

Hardware is unable to realize all legal firmware interface state values
for hash_type.  For example, if 4-tuple TCP_IPV4 hash is enabled,
4-tuple UDP_IPV4 hash must also be enabled.  By providing the bits the
user intended to change instead of the possible illegal intermediate
states, the firmware is able to make better compromises when deciding
which bits to ignore.

With this new mechansim, we can now report the actual configured hash
back to the user.  Add bnxt_hwrm_update_rss_hash_cfg() to report the
actual hash after user configuration.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 35 +++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  2 +
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h | 47 +++++++++++++++++++
 4 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 15edb6cb3656..d18e55b16375 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5294,7 +5294,15 @@ __bnxt_hwrm_vnic_set_rss(struct bnxt *bp, struct hwrm_vnic_rss_cfg_input *req,
 	else
 		bnxt_fill_hw_rss_tbl(bp, vnic);
 
-	req->hash_type = cpu_to_le32(bp->rss_hash_cfg);
+	if (bp->rss_hash_delta) {
+		req->hash_type = cpu_to_le32(bp->rss_hash_delta);
+		if (bp->rss_hash_cfg & bp->rss_hash_delta)
+			req->flags |= VNIC_RSS_CFG_REQ_FLAGS_HASH_TYPE_INCLUDE;
+		else
+			req->flags |= VNIC_RSS_CFG_REQ_FLAGS_HASH_TYPE_EXCLUDE;
+	} else {
+		req->hash_type = cpu_to_le32(bp->rss_hash_cfg);
+	}
 	req->hash_mode_flags = VNIC_RSS_CFG_REQ_HASH_MODE_FLAGS_DEFAULT;
 	req->ring_grp_tbl_addr = cpu_to_le64(vnic->rss_table_dma_addr);
 	req->hash_key_tbl_addr = cpu_to_le64(vnic->rss_hash_key_dma_addr);
@@ -5355,6 +5363,25 @@ static int bnxt_hwrm_vnic_set_rss_p5(struct bnxt *bp, u16 vnic_id, bool set_rss)
 	return rc;
 }
 
+static void bnxt_hwrm_update_rss_hash_cfg(struct bnxt *bp)
+{
+	struct bnxt_vnic_info *vnic = &bp->vnic_info[0];
+	struct hwrm_vnic_rss_qcfg_output *resp;
+	struct hwrm_vnic_rss_qcfg_input *req;
+
+	if (hwrm_req_init(bp, req, HWRM_VNIC_RSS_QCFG))
+		return;
+
+	/* all contexts configured to same hash_type, zero always exists */
+	req->rss_ctx_idx = cpu_to_le16(vnic->fw_rss_cos_lb_ctx[0]);
+	resp = hwrm_req_hold(bp, req);
+	if (!hwrm_req_send(bp, req)) {
+		bp->rss_hash_cfg = le32_to_cpu(resp->hash_type) ?: bp->rss_hash_cfg;
+		bp->rss_hash_delta = 0;
+	}
+	hwrm_req_drop(bp, req);
+}
+
 static int bnxt_hwrm_vnic_set_hds(struct bnxt *bp, u16 vnic_id)
 {
 	struct bnxt_vnic_info *vnic = &bp->vnic_info[vnic_id];
@@ -5612,6 +5639,8 @@ static int bnxt_hwrm_vnic_qcaps(struct bnxt *bp)
 		    (BNXT_CHIP_P5_THOR(bp) &&
 		     !(bp->fw_cap & BNXT_FW_CAP_EXT_HW_STATS_SUPPORTED)))
 			bp->fw_cap |= BNXT_FW_CAP_VLAN_RX_STRIP;
+		if (flags & VNIC_QCAPS_RESP_FLAGS_RSS_HASH_TYPE_DELTA_CAP)
+			bp->fw_cap |= BNXT_FW_CAP_RSS_HASH_TYPE_DELTA;
 		bp->max_tpa_v2 = le16_to_cpu(resp->max_aggs_supported);
 		if (bp->max_tpa_v2) {
 			if (BNXT_CHIP_P5_THOR(bp))
@@ -8806,6 +8835,8 @@ static int bnxt_init_chip(struct bnxt *bp, bool irq_re_init)
 	rc = bnxt_setup_vnic(bp, 0);
 	if (rc)
 		goto err_out;
+	if (bp->fw_cap & BNXT_FW_CAP_RSS_HASH_TYPE_DELTA)
+		bnxt_hwrm_update_rss_hash_cfg(bp);
 
 	if (bp->flags & BNXT_FLAG_RFS) {
 		rc = bnxt_alloc_rfs_vnics(bp);
@@ -12241,6 +12272,8 @@ static void bnxt_set_dflt_rss_hash_type(struct bnxt *bp)
 			   VNIC_RSS_CFG_REQ_HASH_TYPE_TCP_IPV4 |
 			   VNIC_RSS_CFG_REQ_HASH_TYPE_IPV6 |
 			   VNIC_RSS_CFG_REQ_HASH_TYPE_TCP_IPV6;
+	if (bp->fw_cap & BNXT_FW_CAP_RSS_HASH_TYPE_DELTA)
+		bp->rss_hash_delta = bp->rss_hash_cfg;
 	if (BNXT_CHIP_P4_PLUS(bp) && bp->hwrm_spec_code >= 0x10501) {
 		bp->flags |= BNXT_FLAG_UDP_RSS_CAP;
 		bp->rss_hash_cfg |= VNIC_RSS_CFG_REQ_HASH_TYPE_UDP_IPV4 |
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 91a1ba0a914d..7611bed4a196 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1900,6 +1900,7 @@ struct bnxt {
 	u16			*rss_indir_tbl;
 	u16			rss_indir_tbl_entries;
 	u32			rss_hash_cfg;
+	u32			rss_hash_delta;
 
 	u16			max_mtu;
 	u8			max_tc;
@@ -1965,6 +1966,7 @@ struct bnxt {
 	#define BNXT_FW_CAP_CFA_RFS_RING_TBL_IDX_V2	0x00010000
 	#define BNXT_FW_CAP_PCIE_STATS_SUPPORTED	0x00020000
 	#define BNXT_FW_CAP_EXT_STATS_SUPPORTED		0x00040000
+	#define BNXT_FW_CAP_RSS_HASH_TYPE_DELTA		0x00080000
 	#define BNXT_FW_CAP_ERR_RECOVER_RELOAD		0x00100000
 	#define BNXT_FW_CAP_HOT_RESET			0x00200000
 	#define BNXT_FW_CAP_PTP_RTC			0x00400000
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index cc89e5eabcb9..a841b0a47cfd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1234,6 +1234,8 @@ static int bnxt_srxfh(struct bnxt *bp, struct ethtool_rxnfc *cmd)
 	if (bp->rss_hash_cfg == rss_hash_cfg)
 		return 0;
 
+	if (bp->fw_cap & BNXT_FW_CAP_RSS_HASH_TYPE_DELTA)
+		bp->rss_hash_delta = bp->rss_hash_cfg ^ rss_hash_cfg;
 	bp->rss_hash_cfg = rss_hash_cfg;
 	if (netif_running(bp->dev)) {
 		bnxt_close_nic(bp, false, false);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
index 184dd8d11cd3..2686a714a59f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -6768,6 +6768,53 @@ struct hwrm_vnic_rss_cfg_cmd_err {
 	u8	unused_0[7];
 };
 
+/* hwrm_vnic_rss_qcfg_input (size:192b/24B) */
+struct hwrm_vnic_rss_qcfg_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le16	rss_ctx_idx;
+	__le16	vnic_id;
+	u8	unused_0[4];
+};
+
+/* hwrm_vnic_rss_qcfg_output (size:512b/64B) */
+struct hwrm_vnic_rss_qcfg_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	__le32	hash_type;
+	#define VNIC_RSS_QCFG_RESP_HASH_TYPE_IPV4                0x1UL
+	#define VNIC_RSS_QCFG_RESP_HASH_TYPE_TCP_IPV4            0x2UL
+	#define VNIC_RSS_QCFG_RESP_HASH_TYPE_UDP_IPV4            0x4UL
+	#define VNIC_RSS_QCFG_RESP_HASH_TYPE_IPV6                0x8UL
+	#define VNIC_RSS_QCFG_RESP_HASH_TYPE_TCP_IPV6            0x10UL
+	#define VNIC_RSS_QCFG_RESP_HASH_TYPE_UDP_IPV6            0x20UL
+	#define VNIC_RSS_QCFG_RESP_HASH_TYPE_IPV6_FLOW_LABEL     0x40UL
+	#define VNIC_RSS_QCFG_RESP_HASH_TYPE_AH_SPI_IPV4         0x80UL
+	#define VNIC_RSS_QCFG_RESP_HASH_TYPE_ESP_SPI_IPV4        0x100UL
+	#define VNIC_RSS_QCFG_RESP_HASH_TYPE_AH_SPI_IPV6         0x200UL
+	#define VNIC_RSS_QCFG_RESP_HASH_TYPE_ESP_SPI_IPV6        0x400UL
+	u8	unused_0[4];
+	__le32	hash_key[10];
+	u8	hash_mode_flags;
+	#define VNIC_RSS_QCFG_RESP_HASH_MODE_FLAGS_DEFAULT         0x1UL
+	#define VNIC_RSS_QCFG_RESP_HASH_MODE_FLAGS_INNERMOST_4     0x2UL
+	#define VNIC_RSS_QCFG_RESP_HASH_MODE_FLAGS_INNERMOST_2     0x4UL
+	#define VNIC_RSS_QCFG_RESP_HASH_MODE_FLAGS_OUTERMOST_4     0x8UL
+	#define VNIC_RSS_QCFG_RESP_HASH_MODE_FLAGS_OUTERMOST_2     0x10UL
+	u8	ring_select_mode;
+	#define VNIC_RSS_QCFG_RESP_RING_SELECT_MODE_TOEPLITZ          0x0UL
+	#define VNIC_RSS_QCFG_RESP_RING_SELECT_MODE_XOR               0x1UL
+	#define VNIC_RSS_QCFG_RESP_RING_SELECT_MODE_TOEPLITZ_CHECKSUM 0x2UL
+	#define VNIC_RSS_QCFG_RESP_RING_SELECT_MODE_LAST             VNIC_RSS_QCFG_RESP_RING_SELECT_MODE_TOEPLITZ_CHECKSUM
+	u8	unused_1[5];
+	u8	valid;
+};
+
 /* hwrm_vnic_plcmodes_cfg_input (size:320b/40B) */
 struct hwrm_vnic_plcmodes_cfg_input {
 	__le16	req_type;
-- 
2.18.1


--000000000000f8189905ecd65681
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPevFAhztnArS4kX4JoleKdmOD7CYTjS
0JtAARMIp5+0MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTEw
NzAwMTY0OVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBMOUBlMfoe7OV5IXQIAO9ftF6dlKXERIH95L4sk60OIbjo6cdM
OQjbRaQ397Pi246L2oU3fSC4+//dtokzSUz06R3q497kNpXBU4KsGYhHcKDuiSnNbRZL+wwA1iyx
gR/aQR87UnPrXq8BpoC4mBz0M5emh3090683O8/TK+UHxfk70zBXEcQrPrIpFAGFxBBg85cieU4W
TUoQJl04w5JBuKUX6mPZjgMSEP7D1KFlim2lgpBRXVlc/5CM38KbtGf3s6HmZ86aPI7B0rOdTMkO
bFBvghmw8AKHKtYdoQvGBXTu9e1rT0/gBgejACxSHiVmqMtg8VimFA7FGwcOcL4h
--000000000000f8189905ecd65681--
