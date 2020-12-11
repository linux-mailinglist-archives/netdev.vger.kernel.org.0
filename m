Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC192D7088
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 08:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436684AbgLKHFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 02:05:22 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:12488 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436664AbgLKHFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 02:05:11 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607670285; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=vTSJJj/mqYlqSjy1P4jPSBlecvXpEXbz9kGAuxBK598=; b=E/bkESiLJaPr7d03yp2z8tWOJlFe6bsdLWpMEM/hXeOuEbvGAgb30ya5FtsE5VMew5F/ozbo
 Vz585RuAaA06vf3bt3RWIJEKkmaD63QLHuP27L4rpLxaT1a6yv2UN7O5dVlJhLOF0HMO3moZ
 sTK8Nu5WwBpzSByQCSKEJsmUQ1s=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5fd319f4962b2f3cb71cc009 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 11 Dec 2020 07:04:20
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 53C19C43462; Fri, 11 Dec 2020 07:04:20 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1FFDCC433CA;
        Fri, 11 Dec 2020 07:04:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1FFDCC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
From:   Hemant Kumar <hemantk@codeaurora.org>
To:     manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org,
        Hemant Kumar <hemantk@codeaurora.org>
Subject: [PATCH v17 1/3] bus: mhi: core: Move MHI_MAX_MTU to external header file
Date:   Thu, 10 Dec 2020 23:04:09 -0800
Message-Id: <1607670251-31733-2-git-send-email-hemantk@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607670251-31733-1-git-send-email-hemantk@codeaurora.org>
References: <1607670251-31733-1-git-send-email-hemantk@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently this macro is defined in internal MHI header as
a TRE length mask. Moving it to external header allows MHI
client drivers to set this upper bound for the transmit
buffer size.

Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
Reviewed-by: Jeffrey Hugo <jhugo@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/core/internal.h | 1 -
 include/linux/mhi.h             | 3 +++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/core/internal.h b/drivers/bus/mhi/core/internal.h
index 6f80ec3..2b9c063 100644
--- a/drivers/bus/mhi/core/internal.h
+++ b/drivers/bus/mhi/core/internal.h
@@ -453,7 +453,6 @@ enum mhi_pm_state {
 #define CMD_EL_PER_RING			128
 #define PRIMARY_CMD_RING		0
 #define MHI_DEV_WAKE_DB			127
-#define MHI_MAX_MTU			0xffff
 #define MHI_RANDOM_U32_NONZERO(bmsk)	(prandom_u32_max(bmsk) + 1)
 
 enum mhi_er_type {
diff --git a/include/linux/mhi.h b/include/linux/mhi.h
index e36d575..f072605 100644
--- a/include/linux/mhi.h
+++ b/include/linux/mhi.h
@@ -15,6 +15,9 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 
+/* MHI client drivers to set this upper bound for tx buffer */
+#define MHI_MAX_MTU 0xffff
+
 #define MHI_MAX_OEM_PK_HASH_SEGMENTS 16
 
 struct mhi_chan;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

