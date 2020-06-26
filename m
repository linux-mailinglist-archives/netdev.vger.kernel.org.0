Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3DC20AFD3
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 12:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgFZKe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 06:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgFZKe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 06:34:57 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF08C08C5C1
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 03:34:57 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id n24so9765618lji.10
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 03:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CCHg421KUhsy+nSn5wmRg7L3793Q0baKUacKDGsu3gU=;
        b=RaJtOd06tejhtMnJTI4hSfYVJKq3+dsmua7AuHA/tGNN6CJvocGYOew4CYhfZE4cac
         i7TaF3m0jU3HT4QwtCA+woEFwbbwex9mC6GEgiSMjD0Fdf/ZctltYYI5vWTY5n5zhWJk
         iEO2kwqycpvmhRpePLWHVIBGX11I/nBKPdL9lfE/qIlYqw/c4gIHAIdpXsYsyZahQ3Xt
         5edgUqUfamZieSIuINuanhCAPiqf6vNwXoD0mlNRGPD/n0D3uQ0IVJJPKP+4hX2y+GK0
         wCBI5UPbDmSW3LaRBA73mWHf8QQ2QyOo7cuM0wy+2YRCoT/qgumHgUSz76hSf/VguLSB
         soQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CCHg421KUhsy+nSn5wmRg7L3793Q0baKUacKDGsu3gU=;
        b=Q3HOneUGyRTeQWWi87TNuVayOqwUTHjPQO03xnt7hoHppFlhqPcpavmo1Usl2G5JrK
         F/ASmYNY5UlUYqNdxNp8pM0ySwbDnDqS+xNI7xY4aEIYBP1Olliz9VCL1QSldPKiJRgb
         gmgZhfXqwQ93nVe+g3DCDwyfI6dVsOzpK8Y4Q1uEvK195iBL1BIhiK9NQne9Ef1AzoZP
         mriG/jpOILls1NmwjA7p+ZNNburC0V+IMu59akbV5kDEktkBx0P9aM3vwJE8oxmyoID8
         quI0Jniv05HIjhqyJfl0sHYJVTOhVi+mZcw3AUe0s5Xq8DOeaNCO60QaRV7Xki6Ef7co
         /50w==
X-Gm-Message-State: AOAM532lPxO9lYcu7048F0CgTyxmuSux6xLRBjFEg8XVkMqeK4eIdHTo
        73dot33egYHG2iC3RHztNNDyjGBYCxzZJA==
X-Google-Smtp-Source: ABdhPJw+7T1XDcXCqIr9cVsu38qGqRrvTHRCh0lwPojGQZL4ZJH/BxtFZDolN6eArIv6e9ESAMI9DA==
X-Received: by 2002:a2e:8107:: with SMTP id d7mr1184638ljg.363.1593167695548;
        Fri, 26 Jun 2020 03:34:55 -0700 (PDT)
Received: from centos7-pv-guest.localdomain ([5.35.13.201])
        by smtp.gmail.com with ESMTPSA id l1sm166124ljc.65.2020.06.26.03.34.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jun 2020 03:34:55 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     brouer@redhat.com, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org
Subject: [PATCH net-next v11 1/3] xen: netif.h: add a new extra type for XDP
Date:   Fri, 26 Jun 2020 13:34:32 +0300
Message-Id: <1593167674-1065-2-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593167674-1065-1-git-send-email-kda@linux-powerpc.org>
References: <1593167674-1065-1-git-send-email-kda@linux-powerpc.org>
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

