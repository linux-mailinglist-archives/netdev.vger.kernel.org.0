Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDFF558BBD
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 01:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbiFWXbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 19:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbiFWXbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 19:31:51 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825DD4CD42
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 16:31:49 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id E03C4500583;
        Fri, 24 Jun 2022 02:30:15 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru E03C4500583
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1656027016; bh=o1JLwOmL2Z/wVltkZhoi1Xg3NW62y4VoVN9ODPWPVDw=;
        h=From:To:Cc:Subject:Date:From;
        b=k/ZnebWh3Abdtz0ekbwhSgmgit2Qwjeu+5kecDioggTOdiiVtRhiVa73X5QY8DZRU
         Mw1Trq729V2prqNJQCZLy6Ig0bIb8QsCCxstIuhuOmpyJJ5tyuGAJV0gHjX2NFBkWc
         l/IFO0AjANlt7MziAgDcFA5MRlg021nFjEE3qiA8=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org
Subject: [PATCH net] ptp: ocp: add EEPROM_AT24 dependency
Date:   Fri, 24 Jun 2022 02:31:41 +0300
Message-Id: <20220623233141.31251-1-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Various information which is provided via devlink is stored in
EEPROM and is not accessible unless at24 eeprom is supported.

Fixes: 773bda964921 ("ptp: ocp: Expose various resources on the timecard.")
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 drivers/ptp/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 458218f88c5e..c86be47e69ed 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -171,7 +171,7 @@ config PTP_1588_CLOCK_OCP
 	tristate "OpenCompute TimeCard as PTP clock"
 	depends on PTP_1588_CLOCK
 	depends on HAS_IOMEM && PCI
-	depends on I2C && MTD
+	depends on I2C && EEPROM_AT24 && MTD
 	depends on SERIAL_8250
 	depends on !S390
 	depends on COMMON_CLK
-- 
2.27.0

