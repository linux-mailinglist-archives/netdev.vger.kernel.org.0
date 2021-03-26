Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626B434AF58
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 20:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhCZT3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 15:29:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48586 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbhCZT2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 15:28:52 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lPs8W-0006Oo-3b; Fri, 26 Mar 2021 19:28:48 +0000
From:   Colin King <colin.king@canonical.com>
To:     Nicolas Pitre <nico@fluxnic.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: net: smc91x: remove redundant initialization of pointer gpio
Date:   Fri, 26 Mar 2021 19:28:47 +0000
Message-Id: <20210326192847.623376-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The pointer gpio is being initialized with a value that is
never read and it is being updated later with a new value. The
initialization is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/smsc/smc91x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index abd083efbfd7..bc19db2dbafb 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -2205,7 +2205,7 @@ static int try_toggle_control_gpio(struct device *dev,
 				   const char *name, int index,
 				   int value, unsigned int nsdelay)
 {
-	struct gpio_desc *gpio = *desc;
+	struct gpio_desc *gpio;
 	enum gpiod_flags flags = value ? GPIOD_OUT_LOW : GPIOD_OUT_HIGH;
 
 	gpio = devm_gpiod_get_index_optional(dev, name, index, flags);
-- 
2.30.2

