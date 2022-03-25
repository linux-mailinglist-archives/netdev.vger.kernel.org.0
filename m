Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7014E6F18
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 08:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347659AbiCYHnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 03:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235096AbiCYHnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 03:43:39 -0400
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BC4CA0C7
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 00:42:05 -0700 (PDT)
X-QQ-mid: bizesmtp69t1648194111t8ehr1sc
Received: from localhost.localdomain ( [58.240.82.166])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 25 Mar 2022 15:41:43 +0800 (CST)
X-QQ-SSF: 01400000002000D0I000B00A0000000
X-QQ-FEAT: rn/rQ7Qm5gWG7MK9OzE7viXDPDOXIZ6A7HRPLtLB+8P2biRmSSlRLDutLf3BE
        CvA92F+Mz5HxWCyPtVWWqMWpo8tO8FRx0BCGrdO6bOOXWPr3Uyj1ZtUg6P1iJfUx2AnAOvj
        P/U5rQAsuIwwU5qqyRasSkMKwKWFhgXM9sXusVjxRLTeSWLwsG0Q42BLrMuyksU1gV7qgLz
        JbDrl0f2m46gyH6vx5NA4BGGYrv05fXNQm8MYuE2t1hnVCzxEDFXd0onjfc6PoOssMPKjxP
        rzy4e1WxZ4ztI0RixKuhXhcTwbvybhWWAPRazXo5SI68CYsZcp5IECiVyhN72+9XZwOTTjT
        0tm5J56hkc5XbmlJUfon8VYCi/aPQ==
X-QQ-GoodBg: 2
From:   Meng Tang <tangmeng@uniontech.com>
To:     stas.yakovlev@gmail.com, kvalo@kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Meng Tang <tangmeng@uniontech.com>
Subject: [PATCH] ipw2200: Fix permissions setted by DEVICE_ATTR
Date:   Fri, 25 Mar 2022 15:41:41 +0800
Message-Id: <20220325074141.17446-1-tangmeng@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign10
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because xcode_version and rtc only implement the show function
and do not provide the store function, so ucode_version and rtc
only need the read permission, not need the write permission more.

So, remove the write permission from xcode_version and rtc.

Signed-off-by: Meng Tang <tangmeng@uniontech.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 6830e88c4ed6..fa4f38d54d0a 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -1578,7 +1578,7 @@ static ssize_t show_ucode_version(struct device *d,
 	return sprintf(buf, "0x%08x\n", tmp);
 }
 
-static DEVICE_ATTR(ucode_version, 0644, show_ucode_version, NULL);
+static DEVICE_ATTR(ucode_version, 0444, show_ucode_version, NULL);
 
 static ssize_t show_rtc(struct device *d, struct device_attribute *attr,
 			char *buf)
@@ -1592,7 +1592,7 @@ static ssize_t show_rtc(struct device *d, struct device_attribute *attr,
 	return sprintf(buf, "0x%08x\n", tmp);
 }
 
-static DEVICE_ATTR(rtc, 0644, show_rtc, NULL);
+static DEVICE_ATTR(rtc, 0444, show_rtc, NULL);
 
 /*
  * Add a device attribute to view/control the delay between eeprom
-- 
2.20.1



