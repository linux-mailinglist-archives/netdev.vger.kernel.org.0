Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C6F20E045
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389723AbgF2Uo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731604AbgF2TOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:00 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC83C02A55B
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 06:13:56 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id 9so17963955ljv.5
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 06:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CCHg421KUhsy+nSn5wmRg7L3793Q0baKUacKDGsu3gU=;
        b=fctEZfRkcc1OVCKtSsfxjUB5UPqITfJ2aixSWWatkYlO7PTB8ag0Jdb9/Bsc+2P8bA
         8ELtHRw7O+ijJkWB6KL7bGfJDzPNYDDIwaC5e0J5eRGo4ke0MbKN1XlovSpfmZQ5tPJf
         tDyPdQuKevZk02kegBrsdek4J23mLmC5jx9+ignQdxLfZBqswDA3+LHfYuCsL3W44Oib
         k2/iBXsgooT/INsw5EgXbEKdxdH1WVdDy/UhnUe0x+O5x4blaeKr+Wm8AMBigjS4Wvup
         fJp/iE+Z2qUyUcPhtQgLErtyog9Y3GaRfW1ZhaFCrdJd0p6WVW6Hh6/Qwh1ngIM8h7Ib
         IRqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CCHg421KUhsy+nSn5wmRg7L3793Q0baKUacKDGsu3gU=;
        b=Up56X5iMOMAq6IyOutb+lvBvHv72as+6TdL1j4hPhmKRCNLEba8bH611Xq0rCqnUOr
         3P89JeVoRNA8XzJv/AFsFJEGo3f+DLB6Cqpllr6aeIGMcknKPvMDiElWWdmYoaaht9Y0
         DxTvpMtERv/0MI8s8jgPqXGeVVP2Fp/8oc0vURuh5ovnG6Qy6SObAgLHWkYOLJSScqOO
         LwVhQ7NmGsOCotpE3tYhVKOcnhIa9QLGus7RzrA5nJywS8kiDu5vkmfu2+xFmztym3bL
         qNW1jdnJDAKq78HTuqfFi2BNxxw2hGMvg4CcKc9PNhI3uzY0yXznsR9dcu20aX5nYWIw
         Fk6A==
X-Gm-Message-State: AOAM532UXNgX4B6j+2kzuYQNUirhcFUry2yxVaZamgkxee9QFUBeZk2z
        JT1slq2pt6mCNDrsJpaZ1tzLFuDqi7GnLw==
X-Google-Smtp-Source: ABdhPJyh6Lw4SQXnnbnwpxNgMt2T5awwRrB10JBqJYb08GQQl24ZkD4Vd7yNMlBSGCOMShqJS35tvg==
X-Received: by 2002:a05:651c:106f:: with SMTP id y15mr8405335ljm.32.1593436434403;
        Mon, 29 Jun 2020 06:13:54 -0700 (PDT)
Received: from centos7-pv-guest.localdomain ([5.35.13.201])
        by smtp.gmail.com with ESMTPSA id 16sm647916ljw.127.2020.06.29.06.13.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jun 2020 06:13:53 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     brouer@redhat.com, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org
Subject: [PATCH net-next v14 1/3] xen: netif.h: add a new extra type for XDP
Date:   Mon, 29 Jun 2020 16:13:27 +0300
Message-Id: <1593436409-1101-2-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593436409-1101-1-git-send-email-kda@linux-powerpc.org>
References: <1593436409-1101-1-git-send-email-kda@linux-powerpc.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch adds a new extra type to be able to diffirentiate
between RX responses on xen-netfront side with the adjusted offset
required for XDP processing.

The offset value from a guest is passed via xenstore.

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 include/xen/interface/io/netif.h | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/xen/interface/io/netif.h b/include/xen/interface/io/netif.h
index 4f20dbc..2194322 100644
--- a/include/xen/interface/io/netif.h
+++ b/include/xen/interface/io/netif.h
@@ -161,6 +161,19 @@
  */
 
 /*
+ * "xdp-headroom" is used to request that extra space is added
+ * for XDP processing.  The value is measured in bytes and passed by
+ * the frontend to be consistent between both ends.
+ * If the value is greater than zero that means that
+ * an RX response is going to be passed to an XDP program for processing.
+ * XEN_NETIF_MAX_XDP_HEADROOM defines the maximum headroom offset in bytes
+ *
+ * "feature-xdp-headroom" is set to "1" by the netback side like other features
+ * so a guest can check if an XDP program can be processed.
+ */
+#define XEN_NETIF_MAX_XDP_HEADROOM 0x7FFF
+
+/*
  * Control ring
  * ============
  *
@@ -846,7 +859,8 @@ struct xen_netif_tx_request {
 #define XEN_NETIF_EXTRA_TYPE_MCAST_ADD (2)	/* u.mcast */
 #define XEN_NETIF_EXTRA_TYPE_MCAST_DEL (3)	/* u.mcast */
 #define XEN_NETIF_EXTRA_TYPE_HASH      (4)	/* u.hash */
-#define XEN_NETIF_EXTRA_TYPE_MAX       (5)
+#define XEN_NETIF_EXTRA_TYPE_XDP       (5)	/* u.xdp */
+#define XEN_NETIF_EXTRA_TYPE_MAX       (6)
 
 /* xen_netif_extra_info_t flags. */
 #define _XEN_NETIF_EXTRA_FLAG_MORE (0)
@@ -879,6 +893,10 @@ struct xen_netif_extra_info {
 			uint8_t algorithm;
 			uint8_t value[4];
 		} hash;
+		struct {
+			uint16_t headroom;
+			uint16_t pad[2];
+		} xdp;
 		uint16_t pad[3];
 	} u;
 };
-- 
1.8.3.1

