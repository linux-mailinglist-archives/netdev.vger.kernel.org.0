Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D685B3D9511
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 20:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbhG1SMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 14:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhG1SMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 14:12:08 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6A3C061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 11:12:06 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id ca5so6365166pjb.5
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 11:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JiBsds8o2Lj0F8SccTwWun5I3n6wZM5I4fHmjuefKhc=;
        b=FBab3qU+oidojM3h8N54xFZ1reMJMsN4L7qModPlhQDeGvEx/Jg9RJAZITXnX6ojwY
         6MC51mkCM8qW1YJapI04syn2Zcb178JF4WFRXSZPrnmgewm8P1qv2ipEDd29IlaipH9K
         VCop3kyDdezWD/4jMlv08W9kPy4IsF5So+EJw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JiBsds8o2Lj0F8SccTwWun5I3n6wZM5I4fHmjuefKhc=;
        b=XmBs80L4vlVBzqYY5LXKrcOpJCdt4DUnCQ0HidoNmIqXdeR2kIm8qQFy9Tz/WDCDeC
         CbRxRa7eFPzLE51wYrnNrZSjZtTXG1T+pybr0fMtp+LtI01M3PBnVtEyymuwUiHRVa2V
         WweH9/XEhXf1WWT5voIZXmVgJu3CFxtC5ZwmZjWb/hIsL4dIPQxIK+6js1Jgh/psEBYv
         c8lZxAy9QcISwOg45AkqjFWwPjTquIodz5/4mSECw+y39nnrx6JYBcB/DXiYv9w1+pZO
         /QyqihKbs6E/sROHJQ/D/4QVarmZNxgC4PhdrvS6R3xvP+YM34XHS2AylclWZZ/oy4H4
         yCgg==
X-Gm-Message-State: AOAM5311ECfF0u6yf4/FITaQdRSU6La+QeFtDNjaGK7sI4vlXnk0/kgl
        dG8TPKBrpAkf8bCUJPrfeI+/U0m4DYx4sA==
X-Google-Smtp-Source: ABdhPJyGs1kuS+AfHhdPIoKWJ/BJIv+43A40fdHRFCiAPzmYXxgmztY6FlpGvcRn2B3Lk0GrGfVeqQ==
X-Received: by 2002:a62:7d16:0:b029:32d:cfc4:279c with SMTP id y22-20020a627d160000b029032dcfc4279cmr1052505pfc.8.1627495926104;
        Wed, 28 Jul 2021 11:12:06 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a16sm678901pfo.66.2021.07.28.11.12.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Jul 2021 11:12:05 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com,
        edwin.peer@broadcom.com
Subject: [PATCH net-next 5/6] bnxt_en: Event handler for PPS events
Date:   Wed, 28 Jul 2021 14:11:44 -0400
Message-Id: <1627495905-17396-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1627495905-17396-1-git-send-email-michael.chan@broadcom.com>
References: <1627495905-17396-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000094ff2805c832ec25"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000094ff2805c832ec25

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

Once the PPS pins are configured, the FW can report
PPS values using ASYNC event. This patch adds the
ASYNC event handler and subsequent reporting of the
events to kernel.

Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  5 ++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 27 +++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h | 26 ++++++++++++++++++
 3 files changed, 58 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 13e44ce3963f..f3b606bccfb0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -277,6 +277,7 @@ static const u16 bnxt_async_events_arr[] = {
 	ASYNC_EVENT_CMPL_EVENT_ID_DEBUG_NOTIFICATION,
 	ASYNC_EVENT_CMPL_EVENT_ID_RING_MONITOR_MSG,
 	ASYNC_EVENT_CMPL_EVENT_ID_ECHO_REQUEST,
+	ASYNC_EVENT_CMPL_EVENT_ID_PPS_TIMESTAMP,
 };
 
 static struct workqueue_struct *bnxt_pf_wq;
@@ -2202,6 +2203,10 @@ static int bnxt_async_event_process(struct bnxt *bp,
 		}
 		goto async_event_process_exit;
 	}
+	case ASYNC_EVENT_CMPL_EVENT_ID_PPS_TIMESTAMP: {
+		bnxt_ptp_pps_event(bp, data1, data2);
+		goto async_event_process_exit;
+	}
 	default:
 		goto async_event_process_exit;
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index c389a2a65a90..e33e311e2341 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -155,6 +155,33 @@ static int bnxt_ptp_adjfreq(struct ptp_clock_info *ptp_info, s32 ppb)
 	return rc;
 }
 
+void bnxt_ptp_pps_event(struct bnxt *bp, u32 data1, u32 data2)
+{
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+	struct ptp_clock_event event;
+	u64 ns, pps_ts;
+
+	pps_ts = EVENT_PPS_TS(data2, data1);
+	spin_lock_bh(&ptp->ptp_lock);
+	ns = timecounter_cyc2time(&ptp->tc, pps_ts);
+	spin_unlock_bh(&ptp->ptp_lock);
+
+	switch (EVENT_DATA2_PPS_EVENT_TYPE(data2)) {
+	case ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_EVENT_TYPE_INTERNAL:
+		event.pps_times.ts_real = ns_to_timespec64(ns);
+		event.type = PTP_CLOCK_PPSUSR;
+		event.index = EVENT_DATA2_PPS_PIN_NUM(data2);
+		break;
+	case ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_EVENT_TYPE_EXTERNAL:
+		event.timestamp = ns;
+		event.type = PTP_CLOCK_EXTTS;
+		event.index = EVENT_DATA2_PPS_PIN_NUM(data2);
+		break;
+	}
+
+	ptp_clock_event(bp->ptp_cfg->ptp_clock, &event);
+}
+
 static int bnxt_ptp_cfg_pin(struct bnxt *bp, u8 pin, u8 usage)
 {
 	struct hwrm_func_ptp_pin_cfg_input req = {0};
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
index 84f2b06ed79a..88923346ab50 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -29,6 +29,31 @@ struct pps_pin {
 
 #define TSIO_PIN_VALID(pin) ((pin) < (BNXT_MAX_TSIO_PINS))
 
+#define EVENT_DATA2_PPS_EVENT_TYPE(data2)				\
+	((data2) & ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_EVENT_TYPE)
+
+#define EVENT_DATA2_PPS_PIN_NUM(data2)					\
+	(((data2) &							\
+	  ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_PIN_NUMBER_MASK) >>\
+	 ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_PIN_NUMBER_SFT)
+
+#define BNXT_DATA2_UPPER_MSK						\
+	ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_PPS_TIMESTAMP_UPPER_MASK
+
+#define BNXT_DATA2_UPPER_SFT						\
+	(32 -								\
+	 ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_PPS_TIMESTAMP_UPPER_SFT)
+
+#define BNXT_DATA1_LOWER_MSK						\
+	ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA1_PPS_TIMESTAMP_LOWER_MASK
+
+#define BNXT_DATA1_LOWER_SFT						\
+	  ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA1_PPS_TIMESTAMP_LOWER_SFT
+
+#define EVENT_PPS_TS(data2, data1)					\
+	(((u64)((data2) & BNXT_DATA2_UPPER_MSK) << BNXT_DATA2_UPPER_SFT) |\
+	 (((data1) & BNXT_DATA1_LOWER_MSK) >> BNXT_DATA1_LOWER_SFT))
+
 #define BNXT_PPS_PIN_DISABLE	0
 #define BNXT_PPS_PIN_ENABLE	1
 #define BNXT_PPS_PIN_NONE	0
@@ -97,6 +122,7 @@ do {						\
 #endif
 
 int bnxt_ptp_parse(struct sk_buff *skb, u16 *seq_id);
+void bnxt_ptp_pps_event(struct bnxt *bp, u32 data1, u32 data2);
 void bnxt_ptp_reapply_pps(struct bnxt *bp);
 int bnxt_hwtstamp_set(struct net_device *dev, struct ifreq *ifr);
 int bnxt_hwtstamp_get(struct net_device *dev, struct ifreq *ifr);
-- 
2.18.1


--00000000000094ff2805c832ec25
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEICx2hPqMDil/1GOPsg6ITkKFflt+oBTe
veMPJx+0ho7gMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDcy
ODE4MTIwNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQA2TR0cYPRst7AvW0w4ZfDMb8372XKHKlKdqZp98vG5g/AyQD7H
qkh02c34vVoe89FPOw/GkBaiGjMAOYmw3OTE9rXi2by3vxeT/3f9Dni1JuamrOQuGONx40mXp8bJ
54Mpb1n00Tabgg/gyADEehoj1E8lAg9z9J6nWOsIkDR9dSVkpuUe3fdWLE1/Tt+6iJEAHwsNbicY
1ggySwqtXDjqd+ckr9ufnIpkZ7r98rak9mBqrfx90bJ5agybvCk0jnHZg7h0n8gP/frWZHd0G0Us
e9Ob2gs5SWKaTL4pPRCwzP+G4qfTXySbsh2N9343szGN6nFi7UN2b7yCfXONUgeu
--00000000000094ff2805c832ec25--
