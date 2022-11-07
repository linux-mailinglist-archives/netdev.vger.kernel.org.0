Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C3061E7D9
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 01:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbiKGAQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 19:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiKGAQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 19:16:53 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C39634D
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 16:16:52 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id j6so7132755qvn.12
        for <netdev@vger.kernel.org>; Sun, 06 Nov 2022 16:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bevCrzZXqcPKAC/Hy4f6+ang0XXXFn6gZ93R2HmoZ2M=;
        b=gRyBhQf+ziqR62sOHCY4haIzWxMPle2khbN2KNzDcyr8PcUUdrs13+MjKR6CEQcj/f
         gUxeyr82O8vpgfX6czlBovrxIm9JQs6sfoNSivxkZi4VGizkQrGyB/AimZdeW7PlDd/9
         88FAvktwQPljj/RqfVcU0jHw+vQUUgsD+uNWY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bevCrzZXqcPKAC/Hy4f6+ang0XXXFn6gZ93R2HmoZ2M=;
        b=1Gnv/Yo3QFu63JCr6p+2HRnb1szoem0tMZJjkjBYmbV/rI1h/KVWegWTPazRyQWolL
         iCpplUsyYARZoHVbg3rYzp756TCgo4wYIfpwOr0WyIiFdYd0gag1+GPpg4cLfeowOBHQ
         xn88VIWC6Y9Xu8ofDsLcNrY1RXBQ0mZp+TbMfhz3XYjKE2oMseBtjhFmznYLAp4hcF7r
         d3B4/3SeogcWL0znf7eoLY7anJgusBsxdzIQCmf/6c8XNkfmkU66jI31dHlwvgYslJbz
         mS5hS414Lhp9MuNj9jLpQi20sD13hhiuxJZ0+FNOjWBYIYqLQF/YMMJJ3Hu4W6Bydqd3
         ESzA==
X-Gm-Message-State: ACrzQf10MEeEtqoYB4deT09JsNPOMmqoCWs/NY/tYN9nLU/wH2HAgc9P
        fsBLpoIG/2ee4e5Jg251VnIRqtMoqwNvEw==
X-Google-Smtp-Source: AMsMyM7MJdhUUjtw7ziref2f1kL/UqzUTe9y3yZlBNpwP4G+lzvkgzjE7iTjDPtgz2NGXCVnqRhsEw==
X-Received: by 2002:a05:6214:1c44:b0:4bb:5fab:3af with SMTP id if4-20020a0562141c4400b004bb5fab03afmr42472717qvb.23.1667780211192;
        Sun, 06 Nov 2022 16:16:51 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k2-20020ac80742000000b0035badb499c7sm4904079qth.21.2022.11.06.16.16.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Nov 2022 16:16:50 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, gospo@broadcom.com, pavan.chebbi@broadcom.com
Subject: [PATCH net-next 3/3] bnxt_en: Add a non-real time mode to access NIC clock
Date:   Sun,  6 Nov 2022 19:16:32 -0500
Message-Id: <1667780192-3700-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1667780192-3700-1-git-send-email-michael.chan@broadcom.com>
References: <1667780192-3700-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000012ff0105ecd65741"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_TVD_MIME_NO_HEADERS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000012ff0105ecd65741

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

When using a PHC that is shared between multiple hosts,
in order to achieve consistent timestamps across all hosts,
we need to isolate the PHC from any host making frequency
adjustments.

This patch adds a non-real time mode for this purpose.
The implementation is based on a free running NIC hardware timer
which is used as the timestamper time-base. Each host implements
individual adjustments to a local timecounter based on the NIC free
running timer.

Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  5 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 45 ++++++++++++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h |  7 ++-
 3 files changed, 42 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d18e55b16375..d9ad325f7840 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6985,8 +6985,11 @@ static int bnxt_hwrm_func_qcfg(struct bnxt *bp)
 		if (flags & FUNC_QCFG_RESP_FLAGS_FW_DCBX_AGENT_ENABLED)
 			bp->fw_cap |= BNXT_FW_CAP_DCBX_AGENT;
 	}
-	if (BNXT_PF(bp) && (flags & FUNC_QCFG_RESP_FLAGS_MULTI_HOST))
+	if (BNXT_PF(bp) && (flags & FUNC_QCFG_RESP_FLAGS_MULTI_HOST)) {
 		bp->flags |= BNXT_FLAG_MULTI_HOST;
+		if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
+			bp->fw_cap &= ~BNXT_FW_CAP_PTP_RTC;
+	}
 	if (flags & FUNC_QCFG_RESP_FLAGS_RING_MONITOR_ENABLED)
 		bp->fw_cap |= BNXT_FW_CAP_RING_MONITOR;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 2132ce63193c..460cb20599f6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -14,6 +14,7 @@
 #include <linux/net_tstamp.h>
 #include <linux/timekeeping.h>
 #include <linux/ptp_classify.h>
+#include <linux/clocksource.h>
 #include "bnxt_hsi.h"
 #include "bnxt.h"
 #include "bnxt_hwrm.h"
@@ -210,18 +211,37 @@ static int bnxt_ptp_adjfreq(struct ptp_clock_info *ptp_info, s32 ppb)
 						ptp_info);
 	struct hwrm_port_mac_cfg_input *req;
 	struct bnxt *bp = ptp->bp;
-	int rc;
+	int rc = 0;
 
-	rc = hwrm_req_init(bp, req, HWRM_PORT_MAC_CFG);
-	if (rc)
-		return rc;
+	if (!(ptp->bp->fw_cap & BNXT_FW_CAP_PTP_RTC)) {
+		int neg_adj = 0;
+		u32 diff;
+		u64 adj;
 
-	req->ptp_freq_adj_ppb = cpu_to_le32(ppb);
-	req->enables = cpu_to_le32(PORT_MAC_CFG_REQ_ENABLES_PTP_FREQ_ADJ_PPB);
-	rc = hwrm_req_send(ptp->bp, req);
-	if (rc)
-		netdev_err(ptp->bp->dev,
-			   "ptp adjfreq failed. rc = %d\n", rc);
+		if (ppb < 0) {
+			neg_adj = 1;
+			ppb = -ppb;
+		}
+		adj = ptp->cmult;
+		adj *= ppb;
+		diff = div_u64(adj, 1000000000ULL);
+
+		spin_lock_bh(&ptp->ptp_lock);
+		timecounter_read(&ptp->tc);
+		ptp->cc.mult = neg_adj ? ptp->cmult - diff : ptp->cmult + diff;
+		spin_unlock_bh(&ptp->ptp_lock);
+	} else {
+		rc = hwrm_req_init(bp, req, HWRM_PORT_MAC_CFG);
+		if (rc)
+			return rc;
+
+		req->ptp_freq_adj_ppb = cpu_to_le32(ppb);
+		req->enables = cpu_to_le32(PORT_MAC_CFG_REQ_ENABLES_PTP_FREQ_ADJ_PPB);
+		rc = hwrm_req_send(ptp->bp, req);
+		if (rc)
+			netdev_err(ptp->bp->dev,
+				   "ptp adjfreq failed. rc = %d\n", rc);
+	}
 	return rc;
 }
 
@@ -846,8 +866,9 @@ static void bnxt_ptp_timecounter_init(struct bnxt *bp, bool init_tc)
 		memset(&ptp->cc, 0, sizeof(ptp->cc));
 		ptp->cc.read = bnxt_cc_read;
 		ptp->cc.mask = CYCLECOUNTER_MASK(48);
-		ptp->cc.shift = 0;
-		ptp->cc.mult = 1;
+		ptp->cc.shift = BNXT_CYCLES_SHIFT;
+		ptp->cc.mult = clocksource_khz2mult(BNXT_DEVCLK_FREQ, ptp->cc.shift);
+		ptp->cmult = ptp->cc.mult;
 		ptp->next_overflow_check = jiffies + BNXT_PHC_OVERFLOW_PERIOD;
 	}
 	if (init_tc)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
index 4ce0a14c1e23..34162e07a119 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -17,6 +17,8 @@
 #define BNXT_PTP_GRC_WIN_BASE	0x6000
 
 #define BNXT_MAX_PHC_DRIFT	31000000
+#define BNXT_CYCLES_SHIFT	23
+#define BNXT_DEVCLK_FREQ	1000000
 #define BNXT_LO_TIMER_MASK	0x0000ffffffffUL
 #define BNXT_HI_TIMER_MASK	0xffff00000000UL
 
@@ -88,8 +90,9 @@ struct bnxt_ptp_cfg {
 	u64			old_time;
 	unsigned long		next_period;
 	unsigned long		next_overflow_check;
-	/* 48-bit PHC overflows in 78 hours.  Check overflow every 19 hours. */
-	#define BNXT_PHC_OVERFLOW_PERIOD	(19 * 3600 * HZ)
+	u32			cmult;
+	/* a 23b shift cyclecounter will overflow in ~36 mins.  Check overflow every 18 mins. */
+	#define BNXT_PHC_OVERFLOW_PERIOD	(18 * 60 * HZ)
 
 	u16			tx_seqid;
 	u16			tx_hdr_off;
-- 
2.18.1


--00000000000012ff0105ecd65741
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPg4Ctg3X8M3kFEP7w13dlOTgUCPy/tK
qjNIf4WFNUOUMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTEw
NzAwMTY1MVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQADlMaK6bPkV09bbMJ4aLAMBFlp1MkZvr55yr5sq3X6IlyrcFlG
z19QCvb4h6jvHHCZH7CZLMKYDpeEZkVlb6lLOncg+ffsmp2gotEPDTXbTufaYz/LpZhnwbaGzEmC
wXd5FughxErOTjjik2eCACJCv6YSdbF8YkyZwmhK2KC+5E4W47xP5CA1V+SUj06o8R5B45I5JPPv
VeE78h4PZ3RtHZfuBbOZ7dpjjDI37xAypZRVU5CNETAdkF5aOcEt7znm4/7wJWtAx1gHvepwESrh
yIDEFy6AzWUrOx4EdfW60jWlvZeEd5IC8b7CGL0w2RSDuS/mbW0BJcp/RZgrCw+K
--00000000000012ff0105ecd65741--
