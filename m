Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE0C69F560
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 14:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbjBVN3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 08:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbjBVN3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 08:29:21 -0500
X-Greylist: delayed 8328 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 22 Feb 2023 05:29:19 PST
Received: from msg-1.mailo.com (msg-1.mailo.com [213.182.54.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7DC38B62;
        Wed, 22 Feb 2023 05:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailo.com; s=mailo;
        t=1677072533; bh=qzQ7zGo1k9UG+33W/lbFZI1jEkYE2HPHo78UU3v3tEc=;
        h=X-EA-Auth:Date:From:To:Cc:Subject:Message-ID:MIME-Version:
         Content-Type;
        b=GE9t7wY4PGLpX9EffPztoh49VdSYA6Hm6RLz0uUyxOXY8RbUQb7rZNnennFhY+crZ
         wMwve3JMo3Stp7Zi+nA1zJ9N4yFul4Nac+2zJBgtgiKL2XEsti5NKQfdOfQpe9rLzn
         35dccFDJvT40U2wWVaHGJ3mgLZvoh5YQyPiTF+CU=
Received: by b-3.in.mailobj.net [192.168.90.13] with ESMTP
        via ip-206.mailobj.net [213.182.55.206]
        Wed, 22 Feb 2023 14:28:53 +0100 (CET)
X-EA-Auth: 9M9dZCLC9Fz3Zj1NtYBscBMv9zQtOBfixsM7/nD77Wm7zZqthOAlfrb92N9UxssDmWAg3D2BnyiClBTlucwOw++9vQnnsNOI
Date:   Wed, 22 Feb 2023 18:58:48 +0530
From:   Deepak R Varma <drv@mailo.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Saurabh Singh Sengar <ssengar@microsoft.com>,
        Praveen Kumar <kumarpraveen@linux.microsoft.com>,
        Deepak R Varma <drv@mailo.com>
Subject: [PATCH v3] octeontx2-pf: Use correct struct reference in test
 condition
Message-ID: <Y/YYkKddeHOt80cO@ubun2204.myguest.virtualbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the typo/copy-paste error by replacing struct variable ah_esp_mask name
by ah_esp_hdr.
Issue identified using doublebitand.cocci Coccinelle semantic patch.

Fixes: b7cf966126eb ("octeontx2-pf: Add flow classification using IP next level protocol")
Link: https://lore.kernel.org/all/20210111112537.3277-1-naveenm@marvell.com/
Signed-off-by: Deepak R Varma <drv@mailo.com>
---
Please note: Proposed change is compile/build tested only.

Changes in v3:
   1. Include Fixes tag as suggested by Jakub Kicinski <kuba@kernel.org>

Changes in v2:
   1. The variable is not repeating but is typed in wrong. Use the correct
      variable instead. Correction provided by
      Subbaraya Sundeep Bhatta <sbhatta@marvell.com>

 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 684cb8ec9f21..10e11262d48a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -793,7 +793,7 @@ static int otx2_prepare_ipv6_flow(struct ethtool_rx_flow_spec *fsp,
 
 		/* NPC profile doesn't extract AH/ESP header fields */
 		if ((ah_esp_mask->spi & ah_esp_hdr->spi) ||
-		    (ah_esp_mask->tclass & ah_esp_mask->tclass))
+		    (ah_esp_mask->tclass & ah_esp_hdr->tclass))
 			return -EOPNOTSUPP;
 
 		if (flow_type == AH_V6_FLOW)
-- 
2.34.1



