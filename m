Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4042335017
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 21:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbfFDTA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 15:00:27 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39527 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFDTA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 15:00:26 -0400
Received: by mail-qt1-f196.google.com with SMTP id i34so1668528qta.6
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 12:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7g2C++z5L1B0b7jSoWsRL4W87Xloowa8K63ZnjfwCxk=;
        b=qo1X+Q0LfL0eiaDTlV0vGFQ9DA6nLW0/IKKUFREG6cPykpqkTDCABOIMiYUjbd6m6O
         xoOGifkOMeW4NeBnr8q4VRuaowLrKSuB+iP4eFyC08gvyTPRGBZJeZUeamU2aiYqAEuq
         kbstIpKyJEGQ8TFaijjmz2A2couBeWeJ9/iGxR2BU8zTGWTTcc6cTeN28mn3DYY1EUQU
         JTF5u6nLELkVwBXe+EmaVcOBnKXTkHabcwLBGVxucZb20sX6VVdGtKn3u/9YF3Zfrks3
         ve0fZ+oboUMJDULI5YoqB2smxxQKQtMvX1Wl7bm2t+qgBjiSwpncTwIvaZmEq08d3Ct5
         zbrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7g2C++z5L1B0b7jSoWsRL4W87Xloowa8K63ZnjfwCxk=;
        b=qH+XtAoZz7Ge7dJJkH5u6fZKe3AzlYyUq8dQ2E7Rg4xeynRv1FXq13ZIdgeXzcfii9
         i3lVuAIzKmodKrnURNHOM+snhHPSGVLHuwWcTXrav7vsMVhMlXgRI7BAzc4ak/T4IymN
         Tax43yBSfr73i01tqApYPIwu0oz5miIkbzagXGLxNOnG6IWNmLm0oW1vid2Cf0R5ZFCr
         leYRjA8Hai9dMO11jtcLBmsDV7iSGASpa5YxWodEQrGpPbqMuv1YCp80ru9JJralcUzC
         2OFTzk5g88eCERbJgv1JB+6NaEoWE6bl5qg/RvtNBSJmU4tU9fnML3uQE+VG3NCvzj7P
         up4A==
X-Gm-Message-State: APjAAAWhux5ICjV2sDIcOnBFtqn5DEX0sXh3WNpEiZkGgBZTkiZxeuIU
        4otpTS01uxyCMGmjpDpDP2BACg==
X-Google-Smtp-Source: APXvYqxp/U3a+2zbTrPxqA5zGiKKZvDE6Y4L361uk0KcUajoRyDC2WrCFpF7q4rpypaEbrgofUxhTA==
X-Received: by 2002:ac8:21dd:: with SMTP id 29mr10058000qtz.340.1559674825622;
        Tue, 04 Jun 2019 12:00:25 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e66sm11011893qtb.55.2019.06.04.12.00.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 12:00:25 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net v2 1/2] Revert "net/tls: avoid NULL-deref on resync during device removal"
Date:   Tue,  4 Jun 2019 12:00:11 -0700
Message-Id: <20190604190012.6327-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190604190012.6327-1-jakub.kicinski@netronome.com>
References: <20190604190012.6327-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 38030d7cb77963ba84cdbe034806e2b81245339f.
Unfortunately the RX resync may get called from soft IRQ,
so we can't take the rwsem to protect from the device
disappearing.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 net/tls/tls_device.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index b95c408fd771..49b3a2ff8ef3 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -553,8 +553,8 @@ void tls_device_write_space(struct sock *sk, struct tls_context *ctx)
 void handle_device_resync(struct sock *sk, u32 seq, u64 rcd_sn)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	struct net_device *netdev = tls_ctx->netdev;
 	struct tls_offload_context_rx *rx_ctx;
-	struct net_device *netdev;
 	u32 is_req_pending;
 	s64 resync_req;
 	u32 req_seq;
@@ -568,15 +568,10 @@ void handle_device_resync(struct sock *sk, u32 seq, u64 rcd_sn)
 	is_req_pending = resync_req;
 
 	if (unlikely(is_req_pending) && req_seq == seq &&
-	    atomic64_try_cmpxchg(&rx_ctx->resync_req, &resync_req, 0)) {
-		seq += TLS_HEADER_SIZE - 1;
-		down_read(&device_offload_lock);
-		netdev = tls_ctx->netdev;
-		if (netdev)
-			netdev->tlsdev_ops->tls_dev_resync_rx(netdev, sk, seq,
-							      rcd_sn);
-		up_read(&device_offload_lock);
-	}
+	    atomic64_try_cmpxchg(&rx_ctx->resync_req, &resync_req, 0))
+		netdev->tlsdev_ops->tls_dev_resync_rx(netdev, sk,
+						      seq + TLS_HEADER_SIZE - 1,
+						      rcd_sn);
 }
 
 static int tls_device_reencrypt(struct sock *sk, struct sk_buff *skb)
-- 
2.21.0

