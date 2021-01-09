Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC1E2EFD33
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 03:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbhAICvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 21:51:25 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:46565 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725970AbhAICvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 21:51:25 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 391591807;
        Fri,  8 Jan 2021 21:50:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 08 Jan 2021 21:50:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=TKxLOk0ITfiW1ObEdccDY/hqYVDKnZJrGqHUBvg9iyI=; b=MHf/AVhn
        5dB90+rQojhg+v3QEKjTOuFwqQzknKgan2aEuH8UJ8rnhvjh/H+HrO3kYST/6Ftp
        uajSUr29l8UHiTClxjXf6tkybp4AoQZPzRhBz7zUGMQELjULK+I3Eder+YMxbw4N
        VNu01O9NM2oTGrIKuEJowma2uaVszu3qaa8U5SZr6Mbf4T0HfP1d2qgwuv14o+yY
        hR5NhmhyM4P60b2JgmKLeImWkYF6N+OAYU5kZTgTqnhvBOHTLEzi5WfYXCq2Qsqx
        OaD0QJkCJrB1F/3kSn3NUj+2UyBZXPHNN4HVXX7H8C37tCQCgbvXZjoLYFr/OMsj
        rKH/LGdgGHSBbg==
X-ME-Sender: <xms:6hn5XyBvhHxoa_ZDXCXNG6JAuLhAzF4Q1h3ylr19AcN3vphW0_jtow>
    <xme:6hn5X8eRL5rQSSHKZybeqSDhMG5jn7YaLL2N9iYUOsyf7rBWnv3a1GWoh-qt_MkAC
    vyMda_8HApGGwR7pw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdeghedgudegjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeevhhgrrhhlihgvucfuohhmvghrvhhilhhlvgcuoegthhgr
    rhhlihgvsegthhgrrhhlihgvrdgsiieqnecuggftrfgrthhtvghrnhepkedtleduudehhe
    dvfeehvefgvdehffdvveeftdevhfejfffhteelffevueduteeunecukfhppedvtddvrddu
    heefrddvvddtrdejudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpegthhgrrhhlihgvsegthhgrrhhlihgvrdgsii
X-ME-Proxy: <xmx:6hn5XyfR0vnxYdn6BJjdfOD4iu1rFljO6uH-s2s-xXAaKCgHh8VS_Q>
    <xmx:6hn5X4gESyoNgywx_mVWKO_eYq1GJj0PSPeVxG-C1rhwZmXVPSX_aQ>
    <xmx:6hn5X2QnYpTbHyYHeETwzkENuHv-a5mSOos85vHUYqsunnpyUeEVXw>
    <xmx:6hn5X0tLJSCZ6qtlqOwLvxbb1QRSS9n91GXOFjpnL0AHlPlln1z-LA>
Received: from charlie-arch.home.charlie.bz (202-153-220-71.ca99dc.mel.static.aussiebb.net [202.153.220.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id A5B31240057;
        Fri,  8 Jan 2021 21:50:16 -0500 (EST)
From:   Charlie Somerville <charlie@charlie.bz>
To:     davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        jasowang@redhat.com
Cc:     netdev@vger.kernel.org, Charlie Somerville <charlie@charlie.bz>
Subject: [PATCH net-next 1/2] xdp: Add XDP_FLAGS_NO_TX flag
Date:   Sat,  9 Jan 2021 13:49:49 +1100
Message-Id: <20210109024950.4043819-2-charlie@charlie.bz>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210109024950.4043819-1-charlie@charlie.bz>
References: <20210109024950.4043819-1-charlie@charlie.bz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some network interfaces must allocate additional hardware resources to
support XDP filters retransmitting packets with XDP_TX.

However not all XDP filters do use XDP_TX, and there may not be any
additional send queues available for use.

XDP filters can indicate that they will never transmit by setting the
XDP_FLAGS_NO_TX flag in the IFLA_XDP_FLAGS attribute. This flag is
only advisory - some network drivers may still allocate send queues.

Signed-off-by: Charlie Somerville <charlie@charlie.bz>
---
 include/uapi/linux/if_link.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 874cc12a34d9..b4ba4427cd98 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1168,11 +1168,14 @@ enum {
 #define XDP_FLAGS_DRV_MODE		(1U << 2)
 #define XDP_FLAGS_HW_MODE		(1U << 3)
 #define XDP_FLAGS_REPLACE		(1U << 4)
+#define XDP_FLAGS_NO_TX			(1U << 5)
 #define XDP_FLAGS_MODES			(XDP_FLAGS_SKB_MODE | \
 					 XDP_FLAGS_DRV_MODE | \
 					 XDP_FLAGS_HW_MODE)
 #define XDP_FLAGS_MASK			(XDP_FLAGS_UPDATE_IF_NOEXIST | \
-					 XDP_FLAGS_MODES | XDP_FLAGS_REPLACE)
+					 XDP_FLAGS_MODES | \
+					 XDP_FLAGS_REPLACE | \
+					 XDP_FLAGS_NO_TX)
 
 /* These are stored into IFLA_XDP_ATTACHED on dump. */
 enum {
-- 
2.30.0

