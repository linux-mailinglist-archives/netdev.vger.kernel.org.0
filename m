Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3333F4EF663
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350474AbiDAPeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 11:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350128AbiDAO7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:59:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92AC750B2E;
        Fri,  1 Apr 2022 07:46:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 437ACB824D5;
        Fri,  1 Apr 2022 14:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD17C34111;
        Fri,  1 Apr 2022 14:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824385;
        bh=DNvn4b9fu3RCVHGswno86lZheUJya2hTl9UEbDl8Meg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JmTtq5UTplWoPvSOuwMa4/+rejIVGiYvgtI62ocD5OGaxMd9pBMcNglphYtepqw0Q
         bAlRwDE6POJvaO+kA5RF6//G9WEoczJLfCKsR7tMNioJJXnMzLoNz/vB+d0e8K/7Gu
         Opj1LtSsMOgF7GVDPXtMIhr52/b2KlINV/0mGcW47Xex8T0Ajq9JQwR5Ro36oRaRsc
         oKEArV9ceFsSm+d2Z/p4AgCNXBS1RoPv6JaUxPZbSe8is3ZFruZOmgb/Mb4KlrdkIW
         kZjUoKC2YICQK3KuZz4PXwVLClirhAY5E9V6jcOZh6BHm1/EHHa6DOu6N2RFVFBW9v
         GLzVjwPGbjfBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        David Yang <davidcomponentone@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/29] ptp: replace snprintf with sysfs_emit
Date:   Fri,  1 Apr 2022 10:45:47 -0400
Message-Id: <20220401144612.1955177-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144612.1955177-1-sashal@kernel.org>
References: <20220401144612.1955177-1-sashal@kernel.org>
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
index 48401dfcd999..f97a5eefa2e2 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -26,7 +26,7 @@ static ssize_t clock_name_show(struct device *dev,
 			       struct device_attribute *attr, char *page)
 {
 	struct ptp_clock *ptp = dev_get_drvdata(dev);
-	return snprintf(page, PAGE_SIZE-1, "%s\n", ptp->info->name);
+	return sysfs_emit(page, "%s\n", ptp->info->name);
 }
 static DEVICE_ATTR_RO(clock_name);
 
@@ -240,7 +240,7 @@ static ssize_t ptp_pin_show(struct device *dev, struct device_attribute *attr,
 
 	mutex_unlock(&ptp->pincfg_mux);
 
-	return snprintf(page, PAGE_SIZE, "%u %u\n", func, chan);
+	return sysfs_emit(page, "%u %u\n", func, chan);
 }
 
 static ssize_t ptp_pin_store(struct device *dev, struct device_attribute *attr,
-- 
2.34.1

