Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E0D51CCF1
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 01:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386949AbiEEXxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 19:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386947AbiEEXxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 19:53:13 -0400
Received: from smtp4.emailarray.com (smtp4.emailarray.com [65.39.216.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE59260AA8
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 16:49:26 -0700 (PDT)
Received: (qmail 30376 invoked by uid 89); 5 May 2022 23:49:25 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 5 May 2022 23:49:25 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Subject: [PATCH net-next v1 02/10] ptp: ocp: add Celestica timecard PCI ids
Date:   Thu,  5 May 2022 16:49:13 -0700
Message-Id: <20220505234921.3728-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220505234921.3728-1-jonathan.lemon@gmail.com>
References: <20220505234921.3728-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
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
index 9bd83ee8b93f..b02822316e96 100644
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

