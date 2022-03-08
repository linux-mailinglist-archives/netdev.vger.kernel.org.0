Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87DCF4D0C6A
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 01:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbiCHAF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 19:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233412AbiCHAF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 19:05:56 -0500
Received: from smtp8.emailarray.com (smtp8.emailarray.com [65.39.216.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A34C34BA8
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 16:05:00 -0800 (PST)
Received: (qmail 97133 invoked by uid 89); 8 Mar 2022 00:04:59 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 8 Mar 2022 00:04:59 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        kernel-team@fb.com
Subject: [PATCH net-next v2] ptp: ocp: correct label for error path
Date:   Mon,  7 Mar 2022 16:04:58 -0800
Message-Id: <20220308000458.2166-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
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
index aaefca6c2422..5e3e06acaf87 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -2608,7 +2608,7 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	err = pci_enable_device(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "pci_enable_device\n");
-		goto out_unregister;
+		goto out_free;
 	}
 
 	bp = devlink_priv(devlink);
@@ -2654,7 +2654,7 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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

