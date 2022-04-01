Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77414EEF97
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346979AbiDAO2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346974AbiDAO23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:28:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0917E28256B;
        Fri,  1 Apr 2022 07:26:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9E82B8240F;
        Fri,  1 Apr 2022 14:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E9EC340EE;
        Fri,  1 Apr 2022 14:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823195;
        bh=iJAefKwV0vXB8+ooJfoNg3L+br/xXcmwSH/DsOucH7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nOGggC4ga4e+BajblFD6kG9nYBqlPEQc1qlaPq26MtTcJMsPAC1aP7iEt9G7gVR78
         mHzxGVxW4vHspPLK4NkSs+d1AohOS2X3lwyykBW88wpuwLRhEXpqrnCHgrHeLn8HEl
         HELbign2LzxCAULwGWl/qH7EZsSrrTeH6l9blHzlnEgolWx7LjcV0VqBIU9rFie0f0
         Phw71kW4xIh6H8eiHIdMe9Br9UqzPE+iPIqp8Bsw6e6fE/OTrfGujEKtbnaKVXFhVX
         eZrd1XxaM5aq9K/gjdMr9n9IdsJSZj77Pql0MnGY0Av/MqpORBJxDntCagBgNeK9E1
         q0nmplwTeKXwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        David Yang <davidcomponentone@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 017/149] ptp: replace snprintf with sysfs_emit
Date:   Fri,  1 Apr 2022 10:23:24 -0400
Message-Id: <20220401142536.1948161-17-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Guang <yang.guang5@zte.com.cn>

[ Upstream commit e2cf07654efb0fd7bbcb475c6f74be7b5755a8fd ]

coccinelle report:
./drivers/ptp/ptp_sysfs.c:17:8-16:
WARNING: use scnprintf or sprintf
./drivers/ptp/ptp_sysfs.c:390:8-16:
WARNING: use scnprintf or sprintf

Use sysfs_emit instead of scnprintf or sprintf makes more sense.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
Signed-off-by: David Yang <davidcomponentone@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 41b92dc2f011..9233bfedeb17 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -14,7 +14,7 @@ static ssize_t clock_name_show(struct device *dev,
 			       struct device_attribute *attr, char *page)
 {
 	struct ptp_clock *ptp = dev_get_drvdata(dev);
-	return snprintf(page, PAGE_SIZE-1, "%s\n", ptp->info->name);
+	return sysfs_emit(page, "%s\n", ptp->info->name);
 }
 static DEVICE_ATTR_RO(clock_name);
 
@@ -387,7 +387,7 @@ static ssize_t ptp_pin_show(struct device *dev, struct device_attribute *attr,
 
 	mutex_unlock(&ptp->pincfg_mux);
 
-	return snprintf(page, PAGE_SIZE, "%u %u\n", func, chan);
+	return sysfs_emit(page, "%u %u\n", func, chan);
 }
 
 static ssize_t ptp_pin_store(struct device *dev, struct device_attribute *attr,
-- 
2.34.1

