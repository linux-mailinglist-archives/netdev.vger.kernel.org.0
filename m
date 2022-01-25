Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66A349AF4E
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345429AbiAYJIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455335AbiAYJE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:04:26 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F85C061353
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 00:47:25 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id z7so11378798ljj.4
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 00:47:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UtVU5Ioannj5lFzXA15MNhoL0jZF5uZA66JN5wY/VHo=;
        b=z1PVhkYnURa8uk4TdLAjmi4ey/+drh7NOxm8j5ND/n779yDew1YHn/TF1jSwclCBNz
         aExTGYGyghejwUs2hNWH+nYD08V+6xE6xa9k3FvihZgFRyQhDqgUNyWRjKuGBUU2UwEH
         q/SMJMs8GRd06V8oHMqLFnZsM74NV2Oc7IRvEkxixGzFVkyyLU8O7n5ef0vSET7gfXuv
         Eaqko63J/8AeudSImrul4ef25S9Vtr6a4tHVIoxmzTvfuHzDeiBXBZXsB9SEbGiDs703
         ChOXRRz2i7aT/wwqwgOrbR6ziolJ3xFET6e8Y6A2aFvx09YMk8ZoqJ7T6/usZsZeU/1C
         nFUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UtVU5Ioannj5lFzXA15MNhoL0jZF5uZA66JN5wY/VHo=;
        b=3tpStKIjTUwzHXu4XWuhqHosYkeL6reI56rkCvxv6DniYEq+Y1gtnC7HHOnEDfkruK
         q4AESHUFkor9+oXzv7UfVpeBN+jomREoUe2x//nHyZLirn5VM4kObVir/qwy93twwMnT
         +WPL2ItcSjWvSXH766MNKTMJeHOmKdfSRy0JRH81wVpKuSPuFax9+6DLiQIN4lix2OzE
         iJ4OTIVWKkjCQSsUQlLHsTKpDOA7Svl6m2eI3wNUvxYnxq65h452eMt6CaR2PaB6N0fr
         0AwwncsZlTkzRHtCPKmuljomX/Q4T+dJIw8cUVajLzLZGr8TCYEm+HriGgzV8GvVf1iy
         Iwgw==
X-Gm-Message-State: AOAM531jODhYI64NcNx+5E0bUahnEEMtdNZSIU8J7FwjisWbkTYIrsOJ
        +Ky5+iCxNwnnyR8lMDDkZydPkA==
X-Google-Smtp-Source: ABdhPJwyonKvuxlj8x8ao+iZgQDBoPXfdR2ybG7ru6rdG/cLdX4fw/FgGqWs+2hNx2lMu2DLvmkRLA==
X-Received: by 2002:a2e:9654:: with SMTP id z20mr14066133ljh.526.1643100443571;
        Tue, 25 Jan 2022 00:47:23 -0800 (PST)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id q5sm1418944lfe.279.2022.01.25.00.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 00:47:23 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        jasowang@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yuri.benditovich@daynix.com, yan@daynix.com
Subject: [RFC PATCH 3/5] uapi/linux/virtio_net.h: Added USO types.
Date:   Tue, 25 Jan 2022 10:47:00 +0200
Message-Id: <20220125084702.3636253-4-andrew@daynix.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125084702.3636253-1-andrew@daynix.com>
References: <20220125084702.3636253-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added new GSO type for USO: VIRTIO_NET_HDR_GSO_UDP_L4.
Feature VIRTIO_NET_F_HOST_USO allows to enable NETIF_F_GSO_UDP_L4.
Separated VIRTIO_NET_F_GUEST_USO4 & VIRTIO_NET_F_GUEST_USO6 features
required for Windows guests.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 include/uapi/linux/virtio_net.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index 3f55a4215f11..620addc5767b 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -56,6 +56,9 @@
 #define VIRTIO_NET_F_MQ	22	/* Device supports Receive Flow
 					 * Steering */
 #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
+#define VIRTIO_NET_F_GUEST_USO4	54	/* Guest can handle USOv4 in. */
+#define VIRTIO_NET_F_GUEST_USO6	55	/* Guest can handle USOv6 in. */
+#define VIRTIO_NET_F_HOST_USO	56	/* Host can handle USO in. */
 
 #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
 #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
@@ -130,6 +133,7 @@ struct virtio_net_hdr_v1 {
 #define VIRTIO_NET_HDR_GSO_TCPV4	1	/* GSO frame, IPv4 TCP (TSO) */
 #define VIRTIO_NET_HDR_GSO_UDP		3	/* GSO frame, IPv4 UDP (UFO) */
 #define VIRTIO_NET_HDR_GSO_TCPV6	4	/* GSO frame, IPv6 TCP */
+#define VIRTIO_NET_HDR_GSO_UDP_L4	5	/* GSO frame, IPv4 & IPv6 UDP (USO) */
 #define VIRTIO_NET_HDR_GSO_ECN		0x80	/* TCP has ECN set */
 	__u8 gso_type;
 	__virtio16 hdr_len;	/* Ethernet + IP + tcp/udp hdrs */
-- 
2.34.1

