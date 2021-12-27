Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E9947FADA
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 09:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhL0IA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 03:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbhL0IA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 03:00:56 -0500
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF764C061401
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 00:00:55 -0800 (PST)
Received: by mail-ua1-x935.google.com with SMTP id p2so25467188uad.11
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 00:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nnqV4ObCCLDtcS4bKq1q29Z32WjO6VcN+IcwORBLa/0=;
        b=YYpLZAj46C5SIsmmz1FSBxgTWhpcx6Ls90hhGp2WEPS6s+Wq6smQFZeBPzNZDSWPAD
         GPPwc8p64D1YAzGD9n8b3UUrTMKxmPpRmoQjlTmZcxYFqLBGG7rxaB6bMLYCrfjea96Z
         J2eHOsA+t3BOf8V4Qbg9onILSICW9SvXsWCx8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nnqV4ObCCLDtcS4bKq1q29Z32WjO6VcN+IcwORBLa/0=;
        b=6+bgDrZZMhVX8EidcZmEDq3t1xq5Ix+GtsRhct1DBcPg+NrhgLkwy45sjwFJE76HWh
         7Opgc4zDJGFEvMVLVmCaSIUxdec90o+3Bm9aSagk9x79ZM4bWKejDt0reu4uv4oxBCeM
         e1u3Qal+ny5FOOKBlj+YX8pqLzibNsWOxnIp8gTkMngAlpD/GrHxC+GUfhMXjeTDUqu9
         fobYPvugQvBRQpMmgL4S0+h6YgPWueaP6cjhUbqCuYqRYR9V1QKDwct89MJCB8Xeq1ZC
         Uq9t1JMiU9l7rSWntJOd+5QlI7+Iwn6D1jREw5NJqJZwLfrUdBFRF9TYlNFMtts20/8l
         LCrg==
X-Gm-Message-State: AOAM5319dmkZHYtCOHFotgx0XZxfNn0iTMMTQvmlbQWDIwvA6vVjmvPK
        AYbgiWUqWZ/cBPVJajNOqJqnxQ==
X-Google-Smtp-Source: ABdhPJwoZYUD1Xll9wr1BmBINyTRcUd+OeY55AwXGqfxNsKLcArmDl7mJlqJcLbKmo9uwH5RJBEHYA==
X-Received: by 2002:a05:6102:dc9:: with SMTP id e9mr4104368vst.17.1640592054754;
        Mon, 27 Dec 2021 00:00:54 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o1sm2907587vkc.35.2021.12.27.00.00.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Dec 2021 00:00:54 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 5/7] bnxt_en: Support CQE coalescing mode in ethtool
Date:   Mon, 27 Dec 2021 03:00:30 -0500
Message-Id: <1640592032-8927-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1640592032-8927-1-git-send-email-michael.chan@broadcom.com>
References: <1640592032-8927-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000aa176305d41c1ac9"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000aa176305d41c1ac9

Support showing and setting the CQE mode in ethtool.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 24 ++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 15253396096a..46859d9a01eb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -68,6 +68,9 @@ static int bnxt_get_coalesce(struct net_device *dev,
 	coal->rx_max_coalesced_frames = hw_coal->coal_bufs / mult;
 	coal->rx_coalesce_usecs_irq = hw_coal->coal_ticks_irq;
 	coal->rx_max_coalesced_frames_irq = hw_coal->coal_bufs_irq / mult;
+	if (hw_coal->flags &
+	    RING_CMPL_RING_CFG_AGGINT_PARAMS_REQ_FLAGS_TIMER_RESET)
+		kernel_coal->use_cqe_mode_rx = true;
 
 	hw_coal = &bp->tx_coal;
 	mult = hw_coal->bufs_per_record;
@@ -75,6 +78,9 @@ static int bnxt_get_coalesce(struct net_device *dev,
 	coal->tx_max_coalesced_frames = hw_coal->coal_bufs / mult;
 	coal->tx_coalesce_usecs_irq = hw_coal->coal_ticks_irq;
 	coal->tx_max_coalesced_frames_irq = hw_coal->coal_bufs_irq / mult;
+	if (hw_coal->flags &
+	    RING_CMPL_RING_CFG_AGGINT_PARAMS_REQ_FLAGS_TIMER_RESET)
+		kernel_coal->use_cqe_mode_tx = true;
 
 	coal->stats_block_coalesce_usecs = bp->stats_coal_ticks;
 
@@ -101,12 +107,22 @@ static int bnxt_set_coalesce(struct net_device *dev,
 		}
 	}
 
+	if ((kernel_coal->use_cqe_mode_rx || kernel_coal->use_cqe_mode_tx) &&
+	    !(bp->coal_cap.cmpl_params &
+	      RING_AGGINT_QCAPS_RESP_CMPL_PARAMS_TIMER_RESET))
+		return -EOPNOTSUPP;
+
 	hw_coal = &bp->rx_coal;
 	mult = hw_coal->bufs_per_record;
 	hw_coal->coal_ticks = coal->rx_coalesce_usecs;
 	hw_coal->coal_bufs = coal->rx_max_coalesced_frames * mult;
 	hw_coal->coal_ticks_irq = coal->rx_coalesce_usecs_irq;
 	hw_coal->coal_bufs_irq = coal->rx_max_coalesced_frames_irq * mult;
+	hw_coal->flags &=
+		~RING_CMPL_RING_CFG_AGGINT_PARAMS_REQ_FLAGS_TIMER_RESET;
+	if (kernel_coal->use_cqe_mode_rx)
+		hw_coal->flags |=
+			RING_CMPL_RING_CFG_AGGINT_PARAMS_REQ_FLAGS_TIMER_RESET;
 
 	hw_coal = &bp->tx_coal;
 	mult = hw_coal->bufs_per_record;
@@ -114,6 +130,11 @@ static int bnxt_set_coalesce(struct net_device *dev,
 	hw_coal->coal_bufs = coal->tx_max_coalesced_frames * mult;
 	hw_coal->coal_ticks_irq = coal->tx_coalesce_usecs_irq;
 	hw_coal->coal_bufs_irq = coal->tx_max_coalesced_frames_irq * mult;
+	hw_coal->flags &=
+		~RING_CMPL_RING_CFG_AGGINT_PARAMS_REQ_FLAGS_TIMER_RESET;
+	if (kernel_coal->use_cqe_mode_tx)
+		hw_coal->flags |=
+			RING_CMPL_RING_CFG_AGGINT_PARAMS_REQ_FLAGS_TIMER_RESET;
 
 	if (bp->stats_coal_ticks != coal->stats_block_coalesce_usecs) {
 		u32 stats_ticks = coal->stats_block_coalesce_usecs;
@@ -3921,7 +3942,8 @@ const struct ethtool_ops bnxt_ethtool_ops = {
 				     ETHTOOL_COALESCE_USECS_IRQ |
 				     ETHTOOL_COALESCE_MAX_FRAMES_IRQ |
 				     ETHTOOL_COALESCE_STATS_BLOCK_USECS |
-				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
+				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX |
+				     ETHTOOL_COALESCE_USE_CQE,
 	.get_link_ksettings	= bnxt_get_link_ksettings,
 	.set_link_ksettings	= bnxt_set_link_ksettings,
 	.get_fec_stats		= bnxt_get_fec_stats,
-- 
2.18.1


--000000000000aa176305d41c1ac9
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIGrw1vCHxsSD2zojP7I3ESE4te/FzCV0
FJPqBgg7Zu2oMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMTIy
NzA4MDA1NVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBZ3XOHg5vKDRSr7rSwivF5hbSNeUxsrujAMw8ZVRbBBhLhLQF9
gSsWURPrRhnkPSSZT2quj86M2584ZPXy6ztT6gM8pDW9O3O/h45RawxXOb9kXc3JpyiS1J6TGckd
isM26ZMjZ9LyqILuyW/AHbh6MGKJ4VddXhLHwd8DKYohOiz//WuLGuQEhqhpljdvuilWDruEKUr6
4EpG/jHzNRY79jqNc7tEnR+9nUL0JXEw22dfPjsxskj9Xrv8uh+65KSaT1mryPk9JR0bqN5MOuio
LOB/m0KMwm1Z/iCXVgRPR0CsPYytmzcKFu8fGT9OrgyPPZ7IXCsx8ssivSuvR9tA
--000000000000aa176305d41c1ac9--
