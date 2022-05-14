Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A188B526D3B
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 00:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351711AbiEMW7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 18:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbiEMW7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 18:59:31 -0400
Received: from smtp8.emailarray.com (smtp8.emailarray.com [65.39.216.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9011B1A07F
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 15:59:29 -0700 (PDT)
Received: (qmail 78569 invoked by uid 89); 13 May 2022 22:59:28 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 13 May 2022 22:59:28 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, kernel-team@fb.com
Subject: [PATCH net-next v3 02/10] ptp: ocp: add Celestica timecard PCI ids
Date:   Fri, 13 May 2022 15:59:16 -0700
Message-Id: <20220513225924.1655-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220513225924.1655-1-jonathan.lemon@gmail.com>
References: <20220513225924.1655-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@fb.com>

Celestica is producing card with their own vendor id and device id.
Add these ids to driver to support this card.

Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index e02a0fd70d3d..d8d80138c629 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -28,6 +28,14 @@
 #define PCI_DEVICE_ID_FACEBOOK_TIMECARD 0x0400
 #endif
 
+#ifndef PCI_VENDOR_ID_CELESTICA
+#define PCI_VENDOR_ID_CELESTICA 0x18d4
+#endif
+
+#ifndef PCI_DEVICE_ID_CELESTICA_TIMECARD
+#define PCI_DEVICE_ID_CELESTICA_TIMECARD 0x1008
+#endif
+
 static struct class timecard_class = {
 	.owner		= THIS_MODULE,
 	.name		= "timecard",
@@ -634,7 +642,8 @@ static struct ocp_resource ocp_fb_resource[] = {
 
 static const struct pci_device_id ptp_ocp_pcidev_id[] = {
 	{ PCI_DEVICE_DATA(FACEBOOK, TIMECARD, &ocp_fb_resource) },
-	{ 0 }
+	{ PCI_DEVICE_DATA(CELESTICA, TIMECARD, &ocp_fb_resource) },
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, ptp_ocp_pcidev_id);
 
-- 
2.31.1

