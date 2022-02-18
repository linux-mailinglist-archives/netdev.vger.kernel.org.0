Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC41A4BAF93
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 03:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbiBRCUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 21:20:49 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:51808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbiBRCUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 21:20:48 -0500
Received: from out203-205-221-190.mail.qq.com (out203-205-221-190.mail.qq.com [203.205.221.190])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFD5DFDF;
        Thu, 17 Feb 2022 18:20:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1645150825;
        bh=2Nogapx8uXur8++rLZNVYprk9IPSVpmOfgdj+M1+0+o=;
        h=From:To:Cc:Subject:Date;
        b=JRhGn0q/pD5tSUJTExYh+677VSKDeSn7qAW3PFPrfqkWDT8/mQkYWi2q7tpKCwmb6
         A0xYIokQgUEJLIshRZjPqP0H/pijS5hFPfRUZuFEfFBgRt7S4nVH8vwny12Jbp2LEv
         AjLxWl0n505dorsuYSLk7/t/0JNAzbNR9xyC1TSo=
Received: from localhost.localdomain ([43.227.138.48])
        by newxmesmtplogicsvrszc9.qq.com (NewEsmtp) with SMTP
        id 501B4CE5; Fri, 18 Feb 2022 10:20:01 +0800
X-QQ-mid: xmsmtpt1645150801th9wy6pu5
Message-ID: <tencent_CC2F97870384A231BC4689E51F04C4985905@qq.com>
X-QQ-XMAILINFO: NzOHSugmTg7X6cuVfVvdJZvETtUUWVsUj4SEODtPjoTUSYepSdnkuFVXkgO03P
         DpNP37RG3aS1Y54ZLJoptIQqo0Y81HsZ8g1VyA5Qyt9TrNlmXSvZ4qfYR4AAC9O7dajvo3Uwgq1c
         cgBFjz2IDVQpYfIV+C1GyzcriBfh9o3vJvPS6OozXMa8XGYX7sWhmQo57INSHM33+YAxdx/ckHwK
         Hvo+pj8BZRW1N5q2c+n3jlmaffT0vpgmYy5E5pYawWy5/HQHGjrXz/TT3wEdWKepSPyhAeflI8Qo
         FIeyuOzOvLMdKbc6LzBMney9djBgXhUMFvA9mWRLGBdRK34oWXV+udyAyh3OfYVtj6SS7VTgx1oT
         M/hhmb/TGq3d5HPVas5kpp8mZFgAKb+KQUtHNJPNn6GYwdYJIcB+SZMydLqVR3HGCGuQDze3LTCi
         iPAYxsnV/iIgUQ/8XtyqO88btySZZYwD+nFf8cIcr1EWOXN8skGOUiJtUFC2d0m768Mek+csXQ0f
         5r3AC7QcaWRMtuXk2wSCkhEL1WexttFyPEvSRSON+B9v9VlNubEkxCTykLcl7ojffBZaof2uu22M
         /b2vjhi+BOYCrP10M8BkAmWPvS8bghA67AuRxHDCnrOZz/rGJCqoCeU78x+C1liZ7rGvMTPFf2e5
         Ad/iCwQ/EC3fS6mHPqP2f4YyfQDVhrZTy0hJz8utW22mMQeVAjEH9OMlrA0uNFmnvOTQx0kfyEMj
         TC3WIo4jMbYsh9f1VIPrP9Mr12uJRWVX7VD/6mWpVb9lht1f4dJpcPYnOyD0uj0GisYG69rIzGKr
         JuNzZz+LU4m/UWTqJDy/hiNdEWVQI90UUjU6Xx6eQABSfKjzg+L7K03uzBKybRCp1bKj03Ka675f
         Ltv2trPY6NUKTEwqdK8X6cqn8mC9xa/shIIgQHo73J
From:   xkernel.wang@foxmail.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Xiaoke Wang <xkernel.wang@foxmail.com>
Subject: [PATCH v2] net: ll_temac: check the return value of devm_kmalloc()
Date:   Fri, 18 Feb 2022 10:19:39 +0800
X-OQ-MSGID: <20220218021939.1749-1-xkernel.wang@foxmail.com>
X-Mailer: git-send-email 2.33.0.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RDNS_DYNAMIC,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoke Wang <xkernel.wang@foxmail.com>

devm_kmalloc() returns a pointer to allocated memory on success, NULL
on failure. While lp->indirect_lock is allocated by devm_kmalloc()
without proper check. It is better to check the value of it to
prevent potential wrong memory access.

Fixes: f14f5c11f051 ("net: ll_temac: Support indirect_mutex share within TEMAC IP")
Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
---
Changelog
v1-v2: add Fixes tag and remove redundant err message.
 drivers/net/ethernet/xilinx/ll_temac_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 463094c..2ab29ef 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1427,6 +1427,8 @@ static int temac_probe(struct platform_device *pdev)
 		lp->indirect_lock = devm_kmalloc(&pdev->dev,
 						 sizeof(*lp->indirect_lock),
 						 GFP_KERNEL);
+		if (!lp->indirect_lock)
+			return -ENOMEM;
 		spin_lock_init(lp->indirect_lock);
 	}
 
-- 
