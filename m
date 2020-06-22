Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA56203332
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgFVJVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbgFVJVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:21:39 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3DAC061794
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:21:39 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id t9so255597lfl.5
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8Xd8fjc2sytIoCLdCRtbCKa1enjojI1vaikKj8znuu4=;
        b=y9xdjtlisCrMkHjIYBoJ/6SSf2SeBUiBpvVT8rBkK3JBSnxCQ3j5egARScGhTrMsTn
         LoeLhlw3g8i0MF0Ewo3Bn4HkALaIMv2S/ksq+P93wx4X0OWbRoWOLUmwny1T/Pcy0pMA
         j1hNBGTFELvU+yrESDMphMwawxacsqLV/hxClvyqGKa5c75Wme0KB7GbytPdLNR3ejhl
         cnILPnt1LhBOMP4m59LrL0SLXa9qDEWtZaFA7IUStaoIDPdIV1FaBE5gEAsGW6a/InGD
         rrwcme7P9qtrdKgXXTS+NC4uH6AG/035VvvRvI756mjIkZ/BgPxCooADi+3Pa7T3q+L6
         MK2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8Xd8fjc2sytIoCLdCRtbCKa1enjojI1vaikKj8znuu4=;
        b=rLcYa0JJ9dFkqMHIZAM9SY5R5jRZRl6OGjGJbxFMWtWsIJixxny99QsNSadweHCOVt
         tHuh5auUgz4+ke/VDVFU0sbw9dJZNy8d61p2r46ODgyGrN4VCJ4rtA/wpvW+J4V8Y79S
         yXn9snW3h8LxAgW0QLCT1ZLfifFHpg/3L/PjZ7mu+RpOZWiCAKV51LVkMuA2qpje4zXg
         QzVFZj6b2332RcCur0d1RlK7mp2swqRKOAuChn6+fk7tNNsGraKoZIlp4NvQKJbHzIdH
         hMFcLMUsaiEizBuz/IAal9/Twk6n/S2fuLsxjPGebvG9170BCw+IxUG+vpXZeLhzXfSR
         uXZw==
X-Gm-Message-State: AOAM5331Z8WcugG1BieMjVUq5xzehd97VQlHECG75TyrePv/j6ZMi48G
        MX1W08gw4NpNw5IrwiEk2n1oxXhi9nFgiQ==
X-Google-Smtp-Source: ABdhPJwkPq1XWHryaeq27HSTI+FjUBbHAMWa/sPsv+KaX6qEFWcdnWH2cly5Yl+P88Mgk/7o93tZSQ==
X-Received: by 2002:a19:8b8a:: with SMTP id n132mr9135245lfd.45.1592817697389;
        Mon, 22 Jun 2020 02:21:37 -0700 (PDT)
Received: from centos7-pv-guest.localdomain ([5.35.13.201])
        by smtp.gmail.com with ESMTPSA id w17sm3048028ljj.108.2020.06.22.02.21.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jun 2020 02:21:37 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     brouer@redhat.com, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org
Subject: [PATCH net-next v10 1/3] xen: netif.h: add a new extra type for XDP
Date:   Mon, 22 Jun 2020 12:21:10 +0300
Message-Id: <1592817672-2053-2-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592817672-2053-1-git-send-email-kda@linux-powerpc.org>
References: <1592817672-2053-1-git-send-email-kda@linux-powerpc.org>
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
 include/xen/interface/io/netif.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/xen/interface/io/netif.h b/include/xen/interface/io/netif.h
index 4f20dbc..c35a5165 100644
--- a/include/xen/interface/io/netif.h
+++ b/include/xen/interface/io/netif.h
@@ -161,6 +161,17 @@
  */
 
 /*
+ * "xdp-headroom" is used to request that extra space is added
+ * for XDP processing.  The value is measured in bytes and passed by
+ * the frontend to be consistent between both ends.
+ * If the value is greater than zero that means that
+ * an RX response is going to be passed to an XDP program for processing.
+ *
+ * "feature-xdp-headroom" is set to "1" by the netback side like other features
+ * so a guest can check if an XDP program can be processed.
+ */
+
+/*
  * Control ring
  * ============
  *
@@ -846,7 +857,8 @@ struct xen_netif_tx_request {
 #define XEN_NETIF_EXTRA_TYPE_MCAST_ADD (2)	/* u.mcast */
 #define XEN_NETIF_EXTRA_TYPE_MCAST_DEL (3)	/* u.mcast */
 #define XEN_NETIF_EXTRA_TYPE_HASH      (4)	/* u.hash */
-#define XEN_NETIF_EXTRA_TYPE_MAX       (5)
+#define XEN_NETIF_EXTRA_TYPE_XDP       (5)	/* u.xdp */
+#define XEN_NETIF_EXTRA_TYPE_MAX       (6)
 
 /* xen_netif_extra_info_t flags. */
 #define _XEN_NETIF_EXTRA_FLAG_MORE (0)
@@ -879,6 +891,10 @@ struct xen_netif_extra_info {
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

