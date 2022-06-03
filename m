Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBDA953CD6C
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 18:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344057AbiFCQoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 12:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237520AbiFCQoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 12:44:17 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0A6517E3;
        Fri,  3 Jun 2022 09:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654274656; x=1685810656;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5dZ0TAoqzidlvbyB70vmcetMzuDC9HuzxlinyJlmwKs=;
  b=f5z0B86gzQkGBSVzmLw7orrZhSTh73rhiGDx2N/p5TTK1q3Sm3no+kLr
   /8SLllvhfTaB7XfDAOX4KzMWgdiGZIc2NjUMudywkasvqOWS69Sb96dWV
   qbe+ETBUDW6a2k6TXU84aBe34NUlLlo0pA8tECl5CzfuGEM+L0H/JqLue
   4MDIPah6rhLqGZLDPetn7jM9W/v3KscAxnnmGppdMBWSWwUdpPpIRSFWt
   FiQ7wRSUAxu4040dFW7NuLEvn+yVNR6cyMSPrluznXVW1I5B0wlyz8AsV
   ivW9/47+luhrTjrLIJTcoo2PQpEEtwYq59ncqxVqFz8kx8MsFyg1xMtQ8
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10367"; a="276040912"
X-IronPort-AV: E=Sophos;i="5.91,275,1647327600"; 
   d="scan'208";a="276040912"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2022 09:44:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,275,1647327600"; 
   d="scan'208";a="668520232"
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Jun 2022 09:44:13 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 72D625D3; Fri,  3 Jun 2022 19:44:16 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v1 2/2] wireless: ray_cs: Drop useless status variable in parse_addr()
Date:   Fri,  3 Jun 2022 19:44:14 +0300
Message-Id: <20220603164414.48436-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220603164414.48436-1-andriy.shevchenko@linux.intel.com>
References: <20220603164414.48436-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The status variable assigned only once and used also only once.
Replace it's usage by actual value.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wireless/ray_cs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 9ac371d6cd6c..1f57a0055bbd 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -1645,7 +1645,6 @@ static int parse_addr(char *in_str, UCHAR *out)
 {
 	int i, k;
 	int len;
-	int status;
 
 	if (in_str == NULL)
 		return 0;
@@ -1654,7 +1653,6 @@ static int parse_addr(char *in_str, UCHAR *out)
 		return 0;
 	memset(out, 0, ADDRLEN);
 
-	status = 1;
 	i = 5;
 
 	while (len > 0) {
@@ -1672,7 +1670,7 @@ static int parse_addr(char *in_str, UCHAR *out)
 		if (!i--)
 			break;
 	}
-	return status;
+	return 1;
 }
 
 /*===========================================================================*/
-- 
2.35.1

