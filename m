Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A6C25EED0
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 17:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728946AbgIFPpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 11:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728991AbgIFPhp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 11:37:45 -0400
Received: from localhost.localdomain (unknown [194.230.155.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C1D72080A;
        Sun,  6 Sep 2020 15:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599406664;
        bh=zplVVIgMQojsbwVzaG1n4QTE3TMlBcAZb0xfKeub8eE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gM4O+hP07ABQ3OZHrIxBfLvCcF0ZYd26PkkTUQ+rorh3Xx91bwMDTtNFD8RkxIK+1
         z/Qkl5EAQlzG9TfC1U7bzfUPncpacZNX/zSMpP4FScdUctxBXzf3WjQqWVVn9LGpAd
         rbeUWmBvFw3pIvloB4BL/jt3hQo6g9hWh8x+ZTvM=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-nfc@lists.01.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 4/9] nfc: s3fwrn5: Remove unneeded 'ret' variable
Date:   Sun,  6 Sep 2020 17:36:49 +0200
Message-Id: <20200906153654.2925-5-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200906153654.2925-1-krzk@kernel.org>
References: <20200906153654.2925-1-krzk@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The local variable 'ret' can be removed:

  drivers/nfc/s3fwrn5/i2c.c:167:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/nfc/s3fwrn5/i2c.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index 557279492503..dc995286be84 100644
--- a/drivers/nfc/s3fwrn5/i2c.c
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -164,7 +164,6 @@ static int s3fwrn5_i2c_read(struct s3fwrn5_i2c_phy *phy)
 static irqreturn_t s3fwrn5_i2c_irq_thread_fn(int irq, void *phy_id)
 {
 	struct s3fwrn5_i2c_phy *phy = phy_id;
-	int ret = 0;
 
 	if (!phy || !phy->ndev) {
 		WARN_ON_ONCE(1);
@@ -179,10 +178,9 @@ static irqreturn_t s3fwrn5_i2c_irq_thread_fn(int irq, void *phy_id)
 	switch (phy->mode) {
 	case S3FWRN5_MODE_NCI:
 	case S3FWRN5_MODE_FW:
-		ret = s3fwrn5_i2c_read(phy);
+		s3fwrn5_i2c_read(phy);
 		break;
 	case S3FWRN5_MODE_COLD:
-		ret = -EREMOTEIO;
 		break;
 	}
 
-- 
2.17.1

