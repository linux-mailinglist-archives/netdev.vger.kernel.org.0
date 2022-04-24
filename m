Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B5450D37E
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 18:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235240AbiDXQdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 12:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235716AbiDXQdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 12:33:35 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACEFBE0E;
        Sun, 24 Apr 2022 09:30:14 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id A53BA30B2949;
        Sun, 24 Apr 2022 18:29:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:date:from
        :from:in-reply-to:message-id:mime-version:references:reply-to
        :subject:subject:to:to; s=felkmail; bh=+q6VIyeIbn04VjS0fK6OMIyMc
        +DxAivUYEWcD1hAWvk=; b=gVyx0VHZ7LXGVhv6lS5VBbPbjxBh6EDwfZLTFewcW
        QQSW8DIdVKwlo9ybhtS6I7ZOKnTjubjaY71R1K/DyNtlLtZCw16G25N47sBoMMD7
        AUEbFGuhV15CoMYUEXVvQNbUZFNSOsbJ+lGq8UnKMSm6vsOb9/k6SHudAxhWpzZl
        xGxdk3Bm0+ijHMQZc+LG1QzF/5SPgA39Wd+ErrE3Z7mpYzDMqx696z9mc+0suo6B
        lwLPUsT3IwH8qMueEEwbzfZmm0RyBAkE8H5RABvK69e8GRram40lq5bvCZlvYhlP
        4Xlxj1Sq3Gxju0XspXrMcyROgL/jRAVWzo5C3CmPot+lQ==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 4711630ADC00;
        Sun, 24 Apr 2022 18:29:42 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 23OGTfrx030956;
        Sun, 24 Apr 2022 18:29:41 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 23OGTfbR030955;
        Sun, 24 Apr 2022 18:29:41 +0200
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Carsten Emde <c.emde@osadl.org>,
        Drew Fustini <pdp7pdp7@gmail.com>,
        Matej Vasilevski <matej.vasilevski@gmail.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: [PATCH v1 2/4] can: ctucanfd: Remove unnecessary print function dev_err()
Date:   Sun, 24 Apr 2022 18:28:09 +0200
Message-Id: <901775368f2d34c83a5ebad4ad51c4554355c130.1650816929.git.pisa@cmp.felk.cvut.cz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1650816929.git.pisa@cmp.felk.cvut.cz>
References: <cover.1650816929.git.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

The print function dev_err() is redundant because platform_get_irq()
already prints an error.

Eliminate the follow coccicheck warnings:

./drivers/net/can/ctucanfd/ctucanfd_platform.c:67:2-9: line 67 is
redundant because platform_get_irq() already prints an error.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
---
 drivers/net/can/ctucanfd/ctucanfd_platform.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/ctucanfd/ctucanfd_platform.c b/drivers/net/can/ctucanfd/ctucanfd_platform.c
index 5e4806068662..89d54c2151e1 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_platform.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_platform.c
@@ -64,7 +64,6 @@ static int ctucan_platform_probe(struct platform_device *pdev)
 	}
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
-		dev_err(dev, "Cannot find interrupt.\n");
 		ret = irq;
 		goto err;
 	}
-- 
2.20.1


