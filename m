Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5AD93B5479
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 19:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhF0RWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 13:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhF0RWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 13:22:45 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91759C061574
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 10:20:21 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id a7so2505879pga.1
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 10:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QJwSRJB3WvL/r+rJVolomgKsryKna49pAgmJHaVBzFA=;
        b=LvXJXdpz+LV6/CaoHY/pSq9m+vuO+PWH+9VdShYC42q0y/NG6GctJtU1+wZqqgPmHy
         aOWaSmIACxRU1L8ZvxAxeulpf52VxNyNHoja7QE3pIyYq9ejvKhs3SKWgRQHETJWgJpC
         okP6NMLUFGaIwIwYs6VaRAUhgodf+aw/hiLuU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QJwSRJB3WvL/r+rJVolomgKsryKna49pAgmJHaVBzFA=;
        b=t6eiWd8ZzysgbUiFbvD4ZOTQf8YNsv+XIlnWmFkQfruR2zOJ1ahwEkELtxF2E6uVFa
         /JipjOJ6/wpnn1QPlkimzjwR5bf6HwlocpcPWuzbUTxMsBv6933KBImCDMPl6MufrZ3k
         CcbCdAZazww2A+kvcTbOzRUpjNnckeRAiwxrrXIAyzGbbDAKhtcEHh52vGVZfCizAePY
         egLe3xwsH4l08w4SDkYxyTKBCBBY8gNLJVqoMcSrSpAdWlF4uMGAenhVjDNfgFF17OSR
         3YWajxwJxLz44YYASYLNFI0wVVcdSM/30o2Lr07sn0bvMUsrqO74k6mkcgtjDwkV8Jgj
         OOlg==
X-Gm-Message-State: AOAM532WM3TbX/n98G6CR9NxL66XPjS7bi4IMBrtJV2GLW+wXjsWIJrb
        DglCHnpyPvTmW4x8yEr24ciANw==
X-Google-Smtp-Source: ABdhPJzLgXw+dN7eO1105kFDxRiewCdig913q2TQxAbU2uNJ5b3hH+YIwiMuTi7WvpP8kjd3WGu7CQ==
X-Received: by 2002:aa7:8b56:0:b029:2b9:77be:d305 with SMTP id i22-20020aa78b560000b02902b977bed305mr20782200pfd.61.1624814420891;
        Sun, 27 Jun 2021 10:20:20 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j8sm11011584pfu.60.2021.06.27.10.20.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Jun 2021 10:20:20 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com,
        edwin.peer@broadcom.com
Subject: [PATCH net-next v2 2/7] bnxt_en: Get PTP hardware capability from firmware
Date:   Sun, 27 Jun 2021 13:19:45 -0400
Message-Id: <1624814390-1300-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1624814390-1300-1-git-send-email-michael.chan@broadcom.com>
References: <1624814390-1300-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000696c3405c5c29618"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000696c3405c5c29618

Store PTP hardware info in a structure if hardware and firmware support PTP.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 59 +++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  5 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h | 49 +++++++++++++++
 3 files changed, 113 insertions(+)
 create mode 100644 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index aef3fccc27a9..081cdcb02b48 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -49,6 +49,8 @@
 #include <linux/log2.h>
 #include <linux/aer.h>
 #include <linux/bitmap.h>
+#include <linux/ptp_clock_kernel.h>
+#include <linux/timecounter.h>
 #include <linux/cpu_rmap.h>
 #include <linux/cpumask.h>
 #include <net/pkt_cls.h>
@@ -63,6 +65,7 @@
 #include "bnxt_ethtool.h"
 #include "bnxt_dcb.h"
 #include "bnxt_xdp.h"
+#include "bnxt_ptp.h"
 #include "bnxt_vfr.h"
 #include "bnxt_tc.h"
 #include "bnxt_devlink.h"
@@ -7391,6 +7394,56 @@ int bnxt_hwrm_func_resc_qcaps(struct bnxt *bp, bool all)
 	return rc;
 }
 
+/* bp->hwrm_cmd_lock already held. */
+static int __bnxt_hwrm_ptp_qcfg(struct bnxt *bp)
+{
+	struct hwrm_port_mac_ptp_qcfg_output *resp = bp->hwrm_cmd_resp_addr;
+	struct hwrm_port_mac_ptp_qcfg_input req = {0};
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+	u8 flags;
+	int rc;
+
+	if (bp->hwrm_spec_code < 0x10801) {
+		rc = -ENODEV;
+		goto no_ptp;
+	}
+
+	req.port_id = cpu_to_le16(bp->pf.port_id);
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_PORT_MAC_PTP_QCFG, -1, -1);
+	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (rc)
+		goto no_ptp;
+
+	flags = resp->flags;
+	if (!(flags & PORT_MAC_PTP_QCFG_RESP_FLAGS_HWRM_ACCESS)) {
+		rc = -ENODEV;
+		goto no_ptp;
+	}
+	if (!ptp) {
+		ptp = kzalloc(sizeof(*ptp), GFP_KERNEL);
+		if (!ptp)
+			return -ENOMEM;
+		ptp->bp = bp;
+		bp->ptp_cfg = ptp;
+	}
+	if (flags & PORT_MAC_PTP_QCFG_RESP_FLAGS_PARTIAL_DIRECT_ACCESS_REF_CLOCK) {
+		ptp->refclk_regs[0] = le32_to_cpu(resp->ts_ref_clock_reg_lower);
+		ptp->refclk_regs[1] = le32_to_cpu(resp->ts_ref_clock_reg_upper);
+	} else if (bp->flags & BNXT_FLAG_CHIP_P5) {
+		ptp->refclk_regs[0] = BNXT_TS_REG_TIMESYNC_TS0_LOWER;
+		ptp->refclk_regs[1] = BNXT_TS_REG_TIMESYNC_TS0_UPPER;
+	} else {
+		rc = -ENODEV;
+		goto no_ptp;
+	}
+	return 0;
+
+no_ptp:
+	kfree(ptp);
+	bp->ptp_cfg = NULL;
+	return rc;
+}
+
 static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 {
 	int rc = 0;
@@ -7462,6 +7515,8 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 		bp->flags &= ~BNXT_FLAG_WOL_CAP;
 		if (flags & FUNC_QCAPS_RESP_FLAGS_WOL_MAGICPKT_SUPPORTED)
 			bp->flags |= BNXT_FLAG_WOL_CAP;
+		if (flags & FUNC_QCAPS_RESP_FLAGS_PTP_SUPPORTED)
+			__bnxt_hwrm_ptp_qcfg(bp);
 	} else {
 #ifdef CONFIG_BNXT_SRIOV
 		struct bnxt_vf_info *vf = &bp->vf;
@@ -12571,6 +12626,8 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	bnxt_dcb_free(bp);
 	kfree(bp->edev);
 	bp->edev = NULL;
+	kfree(bp->ptp_cfg);
+	bp->ptp_cfg = NULL;
 	kfree(bp->fw_health);
 	bp->fw_health = NULL;
 	bnxt_cleanup_pci(bp);
@@ -13161,6 +13218,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	bnxt_free_hwrm_short_cmd_req(bp);
 	bnxt_free_hwrm_resources(bp);
 	bnxt_ethtool_free(bp);
+	kfree(bp->ptp_cfg);
+	bp->ptp_cfg = NULL;
 	kfree(bp->fw_health);
 	bp->fw_health = NULL;
 	bnxt_cleanup_pci(bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 30e47ea343f9..696163559b64 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1362,6 +1362,9 @@ struct bnxt_test_info {
 #define BNXT_GRC_REG_CHIP_NUM			0x48
 #define BNXT_GRC_REG_BASE			0x260000
 
+#define BNXT_TS_REG_TIMESYNC_TS0_LOWER		0x640180c
+#define BNXT_TS_REG_TIMESYNC_TS0_UPPER		0x6401810
+
 #define BNXT_GRC_BASE_MASK			0xfffff000
 #define BNXT_GRC_OFFSET_MASK			0x00000ffc
 
@@ -2042,6 +2045,8 @@ struct bnxt {
 
 	struct bpf_prog		*xdp_prog;
 
+	struct bnxt_ptp_cfg	*ptp_cfg;
+
 	/* devlink interface and vf-rep structs */
 	struct devlink		*dl;
 	struct devlink_port	dl_port;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
new file mode 100644
index 000000000000..603f0fdb71c2
--- /dev/null
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -0,0 +1,49 @@
+/* Broadcom NetXtreme-C/E network driver.
+ *
+ * Copyright (c) 2021 Broadcom Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+#ifndef BNXT_PTP_H
+#define BNXT_PTP_H
+
+struct bnxt_ptp_cfg {
+	struct ptp_clock_info	ptp_info;
+	struct ptp_clock	*ptp_clock;
+	struct cyclecounter	cc;
+	struct timecounter	tc;
+	/* serialize timecounter access */
+	spinlock_t		ptp_lock;
+	struct sk_buff		*tx_skb;
+	u64			current_time;
+	u64			old_time;
+	unsigned long		next_period;
+	u16			tx_seqid;
+	struct bnxt		*bp;
+	atomic_t		tx_avail;
+#define BNXT_MAX_TX_TS	1
+	u16			rxctl;
+#define BNXT_PTP_MSG_SYNC			(1 << 0)
+#define BNXT_PTP_MSG_DELAY_REQ			(1 << 1)
+#define BNXT_PTP_MSG_PDELAY_REQ			(1 << 2)
+#define BNXT_PTP_MSG_PDELAY_RESP		(1 << 3)
+#define BNXT_PTP_MSG_FOLLOW_UP			(1 << 8)
+#define BNXT_PTP_MSG_DELAY_RESP			(1 << 9)
+#define BNXT_PTP_MSG_PDELAY_RESP_FOLLOW_UP	(1 << 10)
+#define BNXT_PTP_MSG_ANNOUNCE			(1 << 11)
+#define BNXT_PTP_MSG_SIGNALING			(1 << 12)
+#define BNXT_PTP_MSG_MANAGEMENT			(1 << 13)
+#define BNXT_PTP_MSG_EVENTS		(BNXT_PTP_MSG_SYNC |		\
+					 BNXT_PTP_MSG_DELAY_REQ |	\
+					 BNXT_PTP_MSG_PDELAY_REQ |	\
+					 BNXT_PTP_MSG_PDELAY_RESP)
+	u8			tx_tstamp_en:1;
+	int			rx_filter;
+
+	u32			refclk_regs[2];
+	u32			refclk_mapped_regs[2];
+};
+#endif
-- 
2.18.1


--000000000000696c3405c5c29618
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJOj9kJ6v8llhrbmr5Da3XJL8XFKKx1B
ST0YcztUgyUHMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDYy
NzE3MjAyMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCNfYt42tFbz/CqfSXSS58mOtocLZzRaybOz5aD5eMdjEhimhPn
7eoaFOVee8Ez7BvFrHzPDm0XRqFPmTm1iSQlfzE+RHV2MOJjg45m3NHewqNerDzpesYET8ucMMBD
wVbIpfjHqyOO9RgyabUzLfVH0U7Jrynni0Rhts8Z2bnWNZA7v72ZgbNwUUaEY81FyIEzIyP7u8An
gIzmZs3tY3cuGEWqZa14HDUgiTXFNrEM1zYYcCv41wRG2f202TWAKwZ7KVNVcbg37PU4Od6D9pwM
MTbjRcvz40ggBTPwnfsyraXq4DXvRiP6bpTyfHxgz5gPKivFN53R93rZxJ0LQAGx
--000000000000696c3405c5c29618--
