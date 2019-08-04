Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31733809EF
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 10:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfHDIIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 04:08:19 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:14327 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfHDIIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 04:08:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1564906098; x=1596442098;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FIN2taldKWEt2pP9NpPZWMTKJRTjL9lQCOBlSBd8ByM=;
  b=XB4ErKgDsLOMWmTaE+VozLl/5VuKTT6glw8axqEoSXh/zZAKvw+hk2g1
   lwh40BCEqLoN1MWSJraiNwzGSCXfD6RXi4GVMUdYFFNFE9l6wWd7f/dsY
   NXoyH3Zh90RpUJ7zEAkf8Vxzx2dm0+YukkeeLEe3cjjxCEof01MvXc9Ul
   Y=;
X-IronPort-AV: E=Sophos;i="5.64,345,1559520000"; 
   d="scan'208";a="816428103"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2a-8549039f.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 04 Aug 2019 08:08:16 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-8549039f.us-west-2.amazon.com (Postfix) with ESMTPS id A54F7A2E12;
        Sun,  4 Aug 2019 08:08:16 +0000 (UTC)
Received: from EX13D19EUA004.ant.amazon.com (10.43.165.28) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 4 Aug 2019 08:08:16 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D19EUA004.ant.amazon.com (10.43.165.28) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 4 Aug 2019 08:08:15 +0000
Received: from 8c85908914bf.ant.amazon.com (10.218.69.135) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Sun, 4 Aug 2019 08:08:12 +0000
From:   Gal Pressman <galpress@amazon.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Gal Pressman <galpress@amazon.com>
Subject: [PATCH iproute2-next] rdma: Add driver QP type string
Date:   Sun, 4 Aug 2019 11:07:56 +0300
Message-ID: <20190804080756.58364-1-galpress@amazon.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RDMA resource tracker now tracks driver QPs as well, add driver QP type
string to qp_types_to_str function.

Signed-off-by: Gal Pressman <galpress@amazon.com>
---
 rdma/res.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/rdma/res.c b/rdma/res.c
index ef863f142eca..97a7b9640185 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -148,9 +148,11 @@ const char *qp_types_to_str(uint8_t idx)
 						     "UC", "UD", "RAW_IPV6",
 						     "RAW_ETHERTYPE",
 						     "UNKNOWN", "RAW_PACKET",
-						     "XRC_INI", "XRC_TGT" };
+						     "XRC_INI", "XRC_TGT",
+						     [0xFF] = "DRIVER",
+	};
 
-	if (idx < ARRAY_SIZE(qp_types_str))
+	if (idx < ARRAY_SIZE(qp_types_str) && qp_types_str[idx])
 		return qp_types_str[idx];
 	return "UNKNOWN";
 }
-- 
2.22.0

