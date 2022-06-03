Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130CE53CA42
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 14:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244444AbiFCM4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 08:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbiFCM4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 08:56:52 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA059DD8;
        Fri,  3 Jun 2022 05:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654261010; x=1685797010;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iHvWelEz+kZnPb6N3D7Tq7OPEoo6lTW/H9Qskkfqi1g=;
  b=VL2vQMAfSs2i+9+NG6/KcoE+jW9CneLRuZrLqj8Ixw9gezwQLRVJz3lW
   tfgbeC/7ROh3kS2EeipjrqA/7ZxlY3FTeNIjZLZw4+Aut6Sk8lCHn0Vfq
   7KGTbcCTEVRyawQB4c7jGvxBQccTeYSNh3kGHC5MateCsG0648ropdvO3
   x6hmv6R1Oz5t8iTXw5fvpjyMfiNMfMe4WZyc30ZHwDSquBgijQ/kaB8EU
   hA1TtnTteCQd52/suuvapIzpIHf5TTSczUNqw7bxQ4/8lcMZlf6vOOXSa
   mk/iPd321jysEENZyTJhO6mXgqBPhxd9Hj1N+fu2kUjMAjk4e6ezmsip5
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10366"; a="256720822"
X-IronPort-AV: E=Sophos;i="5.91,274,1647327600"; 
   d="scan'208";a="256720822"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2022 05:56:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,274,1647327600"; 
   d="scan'208";a="905446738"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 03 Jun 2022 05:56:47 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 4B5DEF8; Fri,  3 Jun 2022 15:56:50 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Ping-Ke Shih <pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] rtw88: use %*ph to print small buffer
Date:   Fri,  3 Jun 2022 15:56:48 +0300
Message-Id: <20220603125648.46873-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use %*ph format to print small buffer as hex string.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wireless/realtek/rtw88/debug.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index 1a52ff585fbc..7cde6bcf253b 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -269,11 +269,7 @@ static int rtw_debugfs_get_rsvd_page(struct seq_file *m, void *v)
 	for (i = 0 ; i < buf_size ; i += 8) {
 		if (i % page_size == 0)
 			seq_printf(m, "PAGE %d\n", (i + offset) / page_size);
-		seq_printf(m, "%2.2x %2.2x %2.2x %2.2x %2.2x %2.2x %2.2x %2.2x\n",
-			   *(buf + i), *(buf + i + 1),
-			   *(buf + i + 2), *(buf + i + 3),
-			   *(buf + i + 4), *(buf + i + 5),
-			   *(buf + i + 6), *(buf + i + 7));
+		seq_printf(m, "%8ph\n", buf + i);
 	}
 	vfree(buf);
 
-- 
2.35.1

