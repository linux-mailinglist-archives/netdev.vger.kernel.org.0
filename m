Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28AA2581BF5
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 00:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239684AbiGZWGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 18:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiGZWGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 18:06:08 -0400
Received: from smtp2.emailarray.com (smtp.emailarray.com [69.28.212.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F631834D
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 15:06:07 -0700 (PDT)
Received: (qmail 35964 invoked by uid 89); 26 Jul 2022 22:06:06 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE1My43Mw==) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 26 Jul 2022 22:06:06 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, kernel-team@fb.com,
        kernel test robot <lkp@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>
Subject: [PATCH net] ptp: ocp: Select CRC16 in the Kconfig.
Date:   Tue, 26 Jul 2022 15:06:04 -0700
Message-Id: <20220726220604.1339972-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The crc16() function is used to check the firmware validity, but
the library was not explicitly selected.

Fixes: 3c3673bde50c ("ptp: ocp: Add firmware header checks")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
CC: Richard Cochran <richardcochran@gmail.com>
CC: Vadim Fedorenko <vadfed@fb.com>
---
 drivers/ptp/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 458218f88c5e..fe4971b65c64 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -176,6 +176,7 @@ config PTP_1588_CLOCK_OCP
 	depends on !S390
 	depends on COMMON_CLK
 	select NET_DEVLINK
+	select CRC16
 	help
 	  This driver adds support for an OpenCompute time card.
 
-- 
2.34.3

