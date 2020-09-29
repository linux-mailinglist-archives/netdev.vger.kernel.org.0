Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CE927C031
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgI2I4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:56:51 -0400
Received: from z5.mailgun.us ([104.130.96.5]:32346 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgI2I4r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 04:56:47 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601369806; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=KQpZEG0OKWPAvzpKPFBQIJ7O1U66uQTA+gBp9ugCrxg=; b=sVaDi0k7SVMsa0XzaoxSxRPNENwgTnI5/vN1xYH+MoMelu2aUddCLO0tD55goNS/0Haqd94/
 3li76nliP1G0KKeVt+EW8XK8jTyBVD9dnZBYq2co/0DxuPMzSxU1yuiYImOj1riXCZqz+hMA
 Ytiuo5YpH++25lep5NMgT8OYRu0=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5f72f6cdcc21f6157a7b1e06 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 29 Sep 2020 08:56:45
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A06ECC433FF; Tue, 29 Sep 2020 08:56:44 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BE92AC433CB;
        Tue, 29 Sep 2020 08:56:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BE92AC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath11k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, sfr@canb.auug.org.au,
        govinds@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        davem@davemloft.net
Subject: [PATCH v2] ath11k: remove auto_start from channel config struct
Date:   Tue, 29 Sep 2020 11:56:39 +0300
Message-Id: <1601369799-22328-1-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Recent change in MHI bus removed the option to auto start the channels
during MHI driver probe. The channel will only be started when the MHI
client driver like QRTR gets probed. So, remove the option from ath11k
channel config struct.

Fixes: 1399fb87ea3e ("ath11k: register MHI controller device for QCA6390")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---

v2

* cc also linux-wireless so that this goes to patchwork

 drivers/net/wireless/ath/ath11k/mhi.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index aded9a719d51..47a1ce1bee4f 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -24,7 +24,6 @@ static struct mhi_channel_config ath11k_mhi_channels[] = {
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
 		.auto_queue = false,
-		.auto_start = false,
 	},
 	{
 		.num = 1,
@@ -39,7 +38,6 @@ static struct mhi_channel_config ath11k_mhi_channels[] = {
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
 		.auto_queue = false,
-		.auto_start = false,
 	},
 	{
 		.num = 20,
@@ -54,7 +52,6 @@ static struct mhi_channel_config ath11k_mhi_channels[] = {
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
 		.auto_queue = false,
-		.auto_start = true,
 	},
 	{
 		.num = 21,
@@ -69,7 +66,6 @@ static struct mhi_channel_config ath11k_mhi_channels[] = {
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
 		.auto_queue = true,
-		.auto_start = true,
 	},
 };
 
-- 
2.7.4

