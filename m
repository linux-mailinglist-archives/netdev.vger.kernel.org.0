Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA7E4CCD69
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 06:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbiCDFrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 00:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235925AbiCDFrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 00:47:19 -0500
Received: from smtp8.emailarray.com (smtp8.emailarray.com [65.39.216.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88744179A1E
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 21:46:31 -0800 (PST)
Received: (qmail 38993 invoked by uid 89); 4 Mar 2022 05:46:29 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 4 Mar 2022 05:46:29 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kernel-team@fb.com
Subject: [RESEND PATCH net-next] ptp: ocp: correct label for error path
Date:   Thu,  3 Mar 2022 21:46:29 -0800
Message-Id: <20220304054629.1795-1-jonathan.lemon@gmail.com>
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
index 608d1a0eb141..cfe744b80407 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -2600,7 +2600,7 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	err = pci_enable_device(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "pci_enable_device\n");
-		gto out_unregister;
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

