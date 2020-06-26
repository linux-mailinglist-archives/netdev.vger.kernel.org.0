Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9703F20B06A
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgFZL1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728493AbgFZL1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:27:36 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E012C08C5DB
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 04:27:36 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id c21so4963599lfb.3
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 04:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CCHg421KUhsy+nSn5wmRg7L3793Q0baKUacKDGsu3gU=;
        b=04ur9nz/ck77+xTe7Nl9Kg/fnT5Dfbkuq92CGERICHFGXrBYOBh5lHhuYQwA+L3VVb
         hAfWlXfXcRVOMECKO8Ve/ftzb9S6ZWK3p/g/Ccrow8AX0DLD/jNsrEkN1s98+DIUuOLr
         McmYwz6NhB2l8HhQegSCm6Oe0g7tcTEEiJe+FYOBYlCZaTToUQF9OiG6a2cCxnX0R02K
         JJ4HI6xjSNeRNZAZRy2LgaHFshPMTEFaqo1objbo7kF2OzDwO496ufBkEtjDSfrT6PRf
         YvEwKypnS3t+XodOtCl70/B3IrelRLTdQR8LX1anE5cJYeB+Mid9PjAuB3mhM4D+4rfq
         YGQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CCHg421KUhsy+nSn5wmRg7L3793Q0baKUacKDGsu3gU=;
        b=H5l6N09lcOOKxUXU78QBNwDEn54niPN2GaN1uNVeoAyAgmrQ0wiEL3l53FvSVdyqzf
         EjOZEepj3pz8vjdMKgOsnb9CqIQUzFHpStp1PNVsJEDHnZ6HZ6FDfD65+O1p53KVT9lc
         Ex7Fnw3fJYt7nspV2gydpxWDjUdj6zQjq2gt5z4FSyM0HIT2UxlVNb9JeX3xZCzogG6t
         gtxffb+9IYrcnqke/zj37Q90+56dpDnojMQuwbA5ZDCkW0gN9vdyQ2SY2IIgNMaeyIpE
         rZyy41RSzA1b3gZpOZs/iFIzykqCrgQIga0WaxzxQ+FyNNyIDs15RRNN9+6fv2CtQOZr
         kx4A==
X-Gm-Message-State: AOAM533KzGJ3X1blgs/thYLCgJJ9uSiNNzS5KtzsCIvkDaaalK9ribyx
        1j7WIzB0MV1rz2ObBecpMmMArtqlZ6BFew==
X-Google-Smtp-Source: ABdhPJyyL9J8h4xCQO3jnUQW0gcP6Z07S8xD7HSfY7DY3XHhojsOJUoLUKBWf50ZEL5QRjnowNPqvQ==
X-Received: by 2002:ac2:5a50:: with SMTP id r16mr1657729lfn.170.1593170854693;
        Fri, 26 Jun 2020 04:27:34 -0700 (PDT)
Received: from centos7-pv-guest.localdomain ([5.35.13.201])
        by smtp.gmail.com with ESMTPSA id j4sm4476893lfb.94.2020.06.26.04.27.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jun 2020 04:27:34 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     brouer@redhat.com, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org
Subject: [PATCH net-next v12 1/3] xen: netif.h: add a new extra type for XDP
Date:   Fri, 26 Jun 2020 14:27:04 +0300
Message-Id: <1593170826-1600-2-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593170826-1600-1-git-send-email-kda@linux-powerpc.org>
References: <1593170826-1600-1-git-send-email-kda@linux-powerpc.org>
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

