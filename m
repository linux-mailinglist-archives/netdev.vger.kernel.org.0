Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09D13A70F6
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 23:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbhFNVGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 17:06:21 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:17668 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229771AbhFNVGU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 17:06:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623704657; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=0NG5HR9zJUTc96RcRnbevGTBmj7adgQx5I8At6k2bKg=; b=Zkub+rppEsbltoz/Dm8NBPSKAJo0QfWTdREG3nubrWakj6wAPUjAUGizQP2Nf4wF/FrT8ydm
 1TZfbmov0mWjATA7FNE6lkMCZMRtxa1wEUdK9U8QBAnGlqbnwbKULAcycoVGvFXYbh5igjD0
 Lq1Ge/WsMNfLwYUwL/f4ufGhwlw=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 60c7c4508491191eb3f0793f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 14 Jun 2021 21:04:16
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D8496C433D3; Mon, 14 Jun 2021 21:04:15 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from subashab-lnx.qualcomm.com (unknown [129.46.15.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5F3AEC433F1;
        Mon, 14 Jun 2021 21:04:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5F3AEC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     stranche@codeaurora.org, hemantk@codeaurora.org,
        manivannan.sadhasivam@linaro.org, loic.poulain@linaro.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH net] net: mhi_net: Update the transmit handler prototype
Date:   Mon, 14 Jun 2021 15:03:25 -0600
Message-Id: <1623704605-22913-1-git-send-email-subashab@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the function prototype of mhi_ndo_xmit to match
ndo_start_xmit. This otherwise leads to run time failures when
CFI is enabled in kernel.

Fixes: 3ffec6a14f24 ("net: Add mhi-net driver")
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 drivers/net/mhi/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index 64af1e5..bbbbf6c 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -56,7 +56,7 @@ static int mhi_ndo_stop(struct net_device *ndev)
 	return 0;
 }
 
-static int mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
 	const struct mhi_net_proto *proto = mhi_netdev->proto;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

