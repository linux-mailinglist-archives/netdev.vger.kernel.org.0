Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA0220B0B8
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgFZLl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgFZLl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:41:28 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FF9C08C5C1
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 04:41:28 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id o4so4984811lfi.7
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 04:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CCHg421KUhsy+nSn5wmRg7L3793Q0baKUacKDGsu3gU=;
        b=TJ9m+3NMu7HaCyqrKBRTHyxJLLeKI1Ja4CC9EZo9i1aPIEyB8Vci9fnzXEzljpjl9n
         SW9JY3Ce/1zKky5aBt2pT6hUmaizX5HrTNCFKpdJq2V0vyBGT5Ibyryaiej96PlEHUe6
         xsFzkX7RtH7Tn9pH6/m6b43w3x5jhQYzy8Fv+t3XyAtx/5422IdsnU1C0BzbBrjLfG24
         0OVaZBLr+ERfl3SQHefzGlEZh/M27Udy3rh3/35V6e5wyhWwSy5R3p1SIvg6mIBvu4a9
         eSl0YxOxmmocErLD04Q3XhqJrVzlldsgfm+0bHswBQTWPV/0/3UAQ0QLYvd5PSkS+V+R
         1s2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CCHg421KUhsy+nSn5wmRg7L3793Q0baKUacKDGsu3gU=;
        b=UycbuZlv241LWAdFhijReKrRCrdTxe5kktHxMe8lG4LlOqD+7do+aNY0xZPEdUGnmk
         bJt6xZ0FA19SiHQG3ipPmEszRIJo32adz6AtRcPxvfsaDLQe8/my0rz6XN21Mn53vE0Q
         eBJO4/3oQBM5jl0K6/VSDmD7Z2t6JSwQkGl2CiKIn/l/NqpyDFIky4JA1bM5O55Kd2+U
         77JMzeqO4Kv4buXqNO9Puoj0sEY23nTXRjeSbAxg4IvCoAXjln9OcmUMZL6feV6gZaqF
         s4pL4g845CdBAFg/hSZXHTiOhrgeLNHwcJSgZqDTbd3vJHu5LItsQwx1JEKXYIylFGYG
         /+lA==
X-Gm-Message-State: AOAM530MlYXnQAgIZ0WDEcxrp34yhXjQ1BYq30XtcjBfp0ZgUInAW9NH
        Q+/dYCSdeJ75o5irJXoe21VEkvUv/PAFBg==
X-Google-Smtp-Source: ABdhPJyc//W7IzCIJEQ8eHcXwPwx9Gr9FivXU/wcdO/vROJb0wa58UyHNphbr6PhESacHE1weIy9mw==
X-Received: by 2002:a05:6512:10c3:: with SMTP id k3mr1652306lfg.33.1593171686774;
        Fri, 26 Jun 2020 04:41:26 -0700 (PDT)
Received: from centos7-pv-guest.localdomain ([5.35.13.201])
        by smtp.gmail.com with ESMTPSA id v22sm5464237ljg.12.2020.06.26.04.41.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jun 2020 04:41:26 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     brouer@redhat.com, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org
Subject: [PATCH net-next v13 1/3] xen: netif.h: add a new extra type for XDP
Date:   Fri, 26 Jun 2020 14:40:37 +0300
Message-Id: <1593171639-8136-2-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593171639-8136-1-git-send-email-kda@linux-powerpc.org>
References: <1593171639-8136-1-git-send-email-kda@linux-powerpc.org>
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

