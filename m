Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68C81C7524
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 17:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729613AbgEFPlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 11:41:12 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:52748 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729391AbgEFPlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 11:41:12 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 046Ff8dl104430;
        Wed, 6 May 2020 10:41:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588779668;
        bh=6nWDbJgIfHVMYHr00BNhoOQF9D8Xop5E0as19GqWrzc=;
        h=From:To:Subject:Date;
        b=bAatsS2zxkUhlHOrAa+kuNuAejsyF4BSbED039TamP4Bd5qNC09UFPaHaqGzIN6XJ
         DVicJ4l/rT9/OwS37MOO+eAflVyBzpZFRLmzipXnog8U5JVa3QO82GRM695nd5CwM/
         XNTEY94iZ9X7/VymsKUTe0yyy44Bzcth89zKoD0E=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 046Ff86L022647
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 May 2020 10:41:08 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 6 May
 2020 10:41:08 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 6 May 2020 10:41:08 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046Ff8k7028145;
        Wed, 6 May 2020 10:41:08 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [net-next PATCH] net: hsr: fix incorrect type usage for protocol variable
Date:   Wed, 6 May 2020 11:41:07 -0400
Message-ID: <20200506154107.575-1-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following sparse checker warning:-

net/hsr/hsr_slave.c:38:18: warning: incorrect type in assignment (different base types)
net/hsr/hsr_slave.c:38:18:    expected unsigned short [unsigned] [usertype] protocol
net/hsr/hsr_slave.c:38:18:    got restricted __be16 [usertype] h_proto
net/hsr/hsr_slave.c:39:25: warning: restricted __be16 degrades to integer
net/hsr/hsr_slave.c:39:57: warning: restricted __be16 degrades to integer

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 net/hsr/hsr_slave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index f4b9f7a3ce51..25b6ffba26cd 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -18,7 +18,7 @@ static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
 {
 	struct sk_buff *skb = *pskb;
 	struct hsr_port *port;
-	u16 protocol;
+	__be16 protocol;
 
 	if (!skb_mac_header_was_set(skb)) {
 		WARN_ONCE(1, "%s: skb invalid", __func__);
-- 
2.17.1

