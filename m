Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFF452DF20
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 23:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245098AbiESVWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 17:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245117AbiESVWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 17:22:00 -0400
Received: from smtp8.emailarray.com (smtp8.emailarray.com [65.39.216.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB35ED796
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 14:21:59 -0700 (PDT)
Received: (qmail 11265 invoked by uid 89); 19 May 2022 21:21:58 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 19 May 2022 21:21:58 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next v4 03/10] ptp: ocp: add Celestica timecard PCI ids
Date:   Thu, 19 May 2022 14:21:46 -0700
Message-Id: <20220519212153.450437-4-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220519212153.450437-1-jonathan.lemon@gmail.com>
References: <20220519212153.450437-1-jonathan.lemon@gmail.com>
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
 drivers/ptp/ptp_ocp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index d2cdb2a05c36..b5f2b7769028 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -23,6 +23,9 @@
 #define PCI_VENDOR_ID_FACEBOOK			0x1d9b
 #define PCI_DEVICE_ID_FACEBOOK_TIMECARD		0x0400
 
+#define PCI_VENDOR_ID_CELESTICA			0x18d4
+#define PCI_DEVICE_ID_CELESTICA_TIMECARD	0x1008
+
 static struct class timecard_class = {
 	.owner		= THIS_MODULE,
 	.name		= "timecard",
@@ -629,7 +632,8 @@ static struct ocp_resource ocp_fb_resource[] = {
 
 static const struct pci_device_id ptp_ocp_pcidev_id[] = {
 	{ PCI_DEVICE_DATA(FACEBOOK, TIMECARD, &ocp_fb_resource) },
-	{ 0 }
+	{ PCI_DEVICE_DATA(CELESTICA, TIMECARD, &ocp_fb_resource) },
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, ptp_ocp_pcidev_id);
 
-- 
2.31.1

