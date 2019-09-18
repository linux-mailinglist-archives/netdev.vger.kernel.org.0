Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9E5B5DF7
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 09:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728781AbfIRHZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 03:25:39 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:60542 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbfIRHZj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 03:25:39 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E8B75205CB;
        Wed, 18 Sep 2019 09:25:37 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4mhEu0JMXLHL; Wed, 18 Sep 2019 09:25:37 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 836B020422;
        Wed, 18 Sep 2019 09:25:37 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 18 Sep 2019
 09:25:35 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 2F8B8318001E;
 Wed, 18 Sep 2019 09:25:37 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <netdev@vger.kernel.org>
CC:     Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH RFC v3 2/5] net: Add NETIF_F_GRO_LIST feature
Date:   Wed, 18 Sep 2019 09:25:14 +0200
Message-ID: <20190918072517.16037-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190918072517.16037-1-steffen.klassert@secunet.com>
References: <20190918072517.16037-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a new NETIF_F_GRO_LIST feature flag. I will be used
to configure listfyed GRO what will be implemented with some
followup paches.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/linux/netdev_features.h | 2 ++
 net/core/ethtool.c              | 1 +
 2 files changed, 3 insertions(+)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 4b19c544c59a..1b6baa1b6fe9 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -80,6 +80,7 @@ enum {
 
 	NETIF_F_GRO_HW_BIT,		/* Hardware Generic receive offload */
 	NETIF_F_HW_TLS_RECORD_BIT,	/* Offload TLS record */
+	NETIF_F_GRO_LIST_BIT,		/* Listifyed GRO */
 
 	/*
 	 * Add your fresh new feature above and remember to update
@@ -150,6 +151,7 @@ enum {
 #define NETIF_F_GSO_UDP_L4	__NETIF_F(GSO_UDP_L4)
 #define NETIF_F_HW_TLS_TX	__NETIF_F(HW_TLS_TX)
 #define NETIF_F_HW_TLS_RX	__NETIF_F(HW_TLS_RX)
+#define NETIF_F_GRO_LIST	__NETIF_F(GRO_LIST)
 
 /* Finds the next feature with the highest number of the range of start till 0.
  */
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 6288e69e94fc..ee8d2b58c2d7 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -111,6 +111,7 @@ static const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN]
 	[NETIF_F_HW_TLS_RECORD_BIT] =	"tls-hw-record",
 	[NETIF_F_HW_TLS_TX_BIT] =	 "tls-hw-tx-offload",
 	[NETIF_F_HW_TLS_RX_BIT] =	 "tls-hw-rx-offload",
+	[NETIF_F_GRO_LIST_BIT] =         "rx-gro-list",
 };
 
 static const char
-- 
2.17.1

