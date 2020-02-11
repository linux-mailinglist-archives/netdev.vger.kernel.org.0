Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C26AF1592C7
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 16:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730346AbgBKPS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 10:18:29 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:1810 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730335AbgBKPS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 10:18:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581434307; x=1612970307;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b5jCMkLqVFCE07IFnAAE3Cc/F6D9TCcWqccJECueyao=;
  b=DwYitieVg3NiM7SIs0XzSxPKiS7m/SSXSnNacmJ76PIxy4Zcr9wpONV7
   5EDnV/UFXhKuoRFtPYP8CNfqrcE5gitBarbwJ/En39IXf50J92FRKYq27
   KfVapK4+u66WJfCIApKYFf3au1yBLoptLZM8vin0YsM2D00T7TEexqwud
   U=;
IronPort-SDR: AjQDqZltVLG3wUE1qr2AeiK3xsCunoZaUQVMu1Uyct5eFCb6Dh9kH5/3UC+kfPM06BQbgMtkA6
 PYmIU+nhUWiQ==
X-IronPort-AV: E=Sophos;i="5.70,428,1574121600"; 
   d="scan'208";a="17206444"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 11 Feb 2020 15:18:08 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 9578FA26A2;
        Tue, 11 Feb 2020 15:18:07 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Feb 2020 15:17:57 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Feb 2020 15:17:57 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 11 Feb 2020 15:17:57 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id BBD8781D43; Tue, 11 Feb 2020 15:17:56 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net 11/12] net: ena: ethtool: use correct value for crc32 hash
Date:   Tue, 11 Feb 2020 15:17:50 +0000
Message-ID: <20200211151751.29718-12-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200211151751.29718-1-sameehj@amazon.com>
References: <20200211151751.29718-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

Up till kernel 4.11 there was no enum defined for crc32 hash in ethtool,
thus the xor enum was used for supporting crc32.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index b8ce7adb2..971f02ea5 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -693,7 +693,7 @@ static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 		func = ETH_RSS_HASH_TOP;
 		break;
 	case ENA_ADMIN_CRC32:
-		func = ETH_RSS_HASH_XOR;
+		func = ETH_RSS_HASH_CRC32;
 		break;
 	default:
 		netif_err(adapter, drv, netdev,
@@ -742,7 +742,7 @@ static int ena_set_rxfh(struct net_device *netdev, const u32 *indir,
 	case ETH_RSS_HASH_TOP:
 		func = ENA_ADMIN_TOEPLITZ;
 		break;
-	case ETH_RSS_HASH_XOR:
+	case ETH_RSS_HASH_CRC32:
 		func = ENA_ADMIN_CRC32;
 		break;
 	default:
-- 
2.24.1.AMZN

