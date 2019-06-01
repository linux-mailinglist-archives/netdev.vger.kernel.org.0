Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B85A31933
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 05:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfFADMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 23:12:23 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43212 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbfFADMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 23:12:22 -0400
Received: by mail-qt1-f195.google.com with SMTP id z24so3327619qtj.10
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 20:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7g2C++z5L1B0b7jSoWsRL4W87Xloowa8K63ZnjfwCxk=;
        b=u/MFqPTvAALEafoDwRN2Zlw8y91EP/PXD6v661kHY7FLCqNidJaSFepeUEB7R3EGdX
         LI9H5dK26Rt3kJit3MfpXJ7F8+pOM/UIJRQPHiMhIw8Rnduq86482kDjihdFb6ev3b0Q
         HF1ywp8GB5U6d8xIP1VV98hjBI4iaNhfNHxkEybnUr1glBx/jj+7c35Od9UUMpiNRR27
         tAfeT7TyHk22LLsxQ+OGwC0XUrxsb25xNJ771FDgzRh7M1tyYOCzSmOWMx6wM+dxwmkT
         jUaJyWpY4H6i7PnVJiRdWnMcQcacJq2Sie4MJ+WxWAZynqi426Xo47lazTpIf3L4ED6D
         NyJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7g2C++z5L1B0b7jSoWsRL4W87Xloowa8K63ZnjfwCxk=;
        b=iFHpvSsJ+7CRyN4Ui2Pc67zcZwjm2qb3FkNSmJqBjU5IY8yaMDlR2flGvGs201Ahtk
         SYyYxRrkHejz6t/MiTGKlkJ2AxZJXqtmHLK6NCBHRWxoPz4qgf0Pc93a9yOC9LJO0QQ8
         NliI4KhThBZRNRHGQkXiSGHyH0cBuLMmyJ74otFKDOz+m0TXfSDT+IGOcp1HuOcMYBnU
         /79OBgefUvYHWa7SxUyhJyIQ8RREZQ3zeNrxgSxmA5LxS9Elch3I/mVsZi0riIG1ZK0l
         cvWgUuYQSRFv/7bumgqL82tG/BNYvZANrqKVEV9PMkGM58l+yjgYI3Nl9flhYkyXqLWY
         7Wvw==
X-Gm-Message-State: APjAAAUgOmeQNsX/fmaXhfxrIpyp+uVcmgBCOfdiAByxJJTizISXuNIH
        2YRpnioazD3Yhvd7v5jdPQ4C3Q==
X-Google-Smtp-Source: APXvYqy+TkdVz8zj4eNkXg9pw2GkISMUiDdSmd2+272G8Fwof5PFUWQ1c4VAu13XSxt+U85qroWpyg==
X-Received: by 2002:ac8:2d08:: with SMTP id n8mr12378789qta.383.1559358741931;
        Fri, 31 May 2019 20:12:21 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j26sm5354267qtj.70.2019.05.31.20.12.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 20:12:21 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net 1/2] Revert "net/tls: avoid NULL-deref on resync during device removal"
Date:   Fri, 31 May 2019 20:12:00 -0700
Message-Id: <20190601031201.32027-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190601031201.32027-1-jakub.kicinski@netronome.com>
References: <20190601031201.32027-1-jakub.kicinski@netronome.com>
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

