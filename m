Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1077B4CCA21
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 00:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237237AbiCCXiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 18:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbiCCXix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 18:38:53 -0500
Received: from smtp6.emailarray.com (smtp6.emailarray.com [65.39.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DF13F31C
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 15:38:04 -0800 (PST)
Received: (qmail 73788 invoked by uid 89); 3 Mar 2022 23:38:03 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 3 Mar 2022 23:38:03 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kernel-team@fb.com
Subject: [PATCH net-next] ptp: ocp: correct label for error path
Date:   Thu,  3 Mar 2022 15:37:58 -0800
Message-Id: <20220303233801.242870-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220303233801.242870-1-jonathan.lemon@gmail.com>
References: <20220303233801.242870-1-jonathan.lemon@gmail.com>
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

When devlink_register() was removed from the error path, the
corresponding label was not updated.   Rename the label for
readability puposes, no functional change.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 608d1a0eb141..cfe744b80407 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -2600,7 +2600,7 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	err = pci_enable_device(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "pci_enable_device\n");
-		goto out_unregister;
+		goto out_free;
 	}
 
 	bp = devlink_priv(devlink);
@@ -2646,7 +2646,7 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_drvdata(pdev, NULL);
 out_disable:
 	pci_disable_device(pdev);
-out_unregister:
+out_free:
 	devlink_free(devlink);
 	return err;
 }
-- 
2.31.1

