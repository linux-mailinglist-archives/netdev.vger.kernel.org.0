Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7483D67C842
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 11:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236819AbjAZKRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 05:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236601AbjAZKRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 05:17:18 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7A134311;
        Thu, 26 Jan 2023 02:16:47 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 5AE475C013F;
        Thu, 26 Jan 2023 05:16:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 26 Jan 2023 05:16:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=umbraculum.org;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1674728207; x=
        1674814607; bh=j1DjTIMxlexzPaQjT5v9wphlTdFzrI3hxKFv78KoM+A=; b=b
        ze5jwaG6JBjVrKlQK3lNzpc1VpuCqwlwZveskHIvNTqCZhnmwNy1tRV/l2HrVAyu
        nIVi6WHXIlSLQaJEMO8jL4bMueMXMfk9NhGBy8MGZBKo4bmvEd2Z1amTywW58+K9
        PmN72HDouqDUOM4l5BmWjxNmtmX1OH74guKqWAsRRZ9iNro3c7fTERpB0BJZD1yn
        W0/N7vb2hQPV3lPwmrirh/wfzmYRIhDPpm8UZ9b3M3+E6inqu4urhiKd5pNCD9u+
        kWKQ4FByWaWGPp8Dy5nJFDC6PS7OtSoHbOzkQGe5yxkEvSvO7FhGFfzYU9VSmfM9
        MlqkItyE1ekBZ2rvv7UhA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1674728207; x=1674814607; bh=j1DjTIMxlexzP
        aQjT5v9wphlTdFzrI3hxKFv78KoM+A=; b=lIixVRIBPkiHjEPKKEEgyNlZhgayX
        igCC/TJWJERLmo+bCUK7atHDtpXT/zytxO7XNb2NVdasR2uB7sBPPvLqQbm/6BTo
        Es9m493UTEssH2E5KXUVw4xE0wG0zzwddDA5i58HhsvOFmdBS2hC2p4hvcJwfdvT
        kvFgxu6sCqVaPA31FP71gXT7srkOX06VQAH73+xTpvLA55Mt4jD2ejX4vpZYBuqZ
        wDco43OtGkML6JvGpmisUFstr5F0sHlobFhp/QWpgFXClttikDG/uEG/uA46D3xN
        21y1yvk+qfjgun0PR980md1XU2knRPw/vKxiF/ialkHDPNXUaJ06hlJYw==
X-ME-Sender: <xms:D1PSY5bhBy-uW6kfc_XyIa6Nwb6d5yxzqLt4KbQS2beUbBCBoxgjhg>
    <xme:D1PSYwbtRW1PwybgT5-HR0Zb4X-6JuxV3WDwwA9ZJYCjIiCs4jqAZqZ2ZNR-M2Kos
    mo0jck98CrMdIgaBkc>
X-ME-Received: <xmr:D1PSY7-noQYEQ878jxjS1Ol_if5pbkz9DeQpeudw9V4mJFX5lYiZ5UNz630ri8SVC2GUa2dR3cnKd-jhC1oUwmjs095jwatD5jsDpQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddvgedgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeflohhnrghsucfuuhhhrhcuvehhrhhishhtvghnshgvnhcu
    oehjshgtsehumhgsrhgrtghulhhumhdrohhrgheqnecuggftrfgrthhtvghrnhepieevle
    eguedviefgfedtjeeuuddtjeekheffueffhfejieevleffffekjeffgedunecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepjhhstgesuhhmsghrrg
    gtuhhluhhmrdhorhhg
X-ME-Proxy: <xmx:D1PSY3pygZqUAJLcLp22XXYi7FRf33D5DNmlc8ZaXKHzl6A3SXCRgQ>
    <xmx:D1PSY0oes6aQKQU9GS5pJGlnJQUkDIOaJUXKWIXgvvg7oZlv8nmq6Q>
    <xmx:D1PSY9T9mIBHqKZQaNEtJGQ3_0jfoSUsRufC65aC29ox_w8cSHt5Pg>
    <xmx:D1PSYwf-lczXWXZVb2xSVyAQUtguZdzyYPlDOrqozlKmjdjGoL5ojA>
Feedback-ID: i06314781:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 Jan 2023 05:16:44 -0500 (EST)
From:   Jonas Suhr Christensen <jsc@umbraculum.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, michal.simek@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        esben@geanix.com, Jonas Suhr Christensen <jsc@umbraculum.org>
Subject: [PATCH 2/2] net: ll_temac: improve reset of buffer on dma mapping
Date:   Thu, 26 Jan 2023 11:16:07 +0100
Message-Id: <20230126101607.88407-2-jsc@umbraculum.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230126101607.88407-1-jsc@umbraculum.org>
References: <20230126101607.88407-1-jsc@umbraculum.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Free buffer and set pointer to null on dma mapping error.

Signed-off-by: Jonas Suhr Christensen <jsc@umbraculum.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 66c04027f230..5595ba57a126 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -376,8 +376,11 @@ static int temac_dma_bd_init(struct net_device *ndev)
 		skb_dma_addr = dma_map_single(ndev->dev.parent, skb->data,
 					      XTE_MAX_JUMBO_FRAME_SIZE,
 					      DMA_FROM_DEVICE);
-		if (dma_mapping_error(ndev->dev.parent, skb_dma_addr))
+		if (dma_mapping_error(ndev->dev.parent, skb_dma_addr)) {
+			dev_kfree_skb(lp->rx_skb[i]);
+			lp->rx_skb[i] = NULL;
 			goto out;
+		}
 		lp->rx_bd_v[i].phys = cpu_to_be32(skb_dma_addr);
 		lp->rx_bd_v[i].len = cpu_to_be32(XTE_MAX_JUMBO_FRAME_SIZE);
 		lp->rx_bd_v[i].app0 = cpu_to_be32(STS_CTRL_APP0_IRQONEND);
-- 
2.39.1

