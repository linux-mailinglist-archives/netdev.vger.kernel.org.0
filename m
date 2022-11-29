Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB30963B9C5
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 07:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235674AbiK2GY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 01:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235214AbiK2GYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 01:24:25 -0500
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91B74875F;
        Mon, 28 Nov 2022 22:24:23 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VVzIEqb_1669703050;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VVzIEqb_1669703050)
          by smtp.aliyun-inc.com;
          Tue, 29 Nov 2022 14:24:20 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     stas.yakovlev@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] ipw2x00: Remove some unused functions
Date:   Tue, 29 Nov 2022 14:24:07 +0800
Message-Id: <20221129062407.83157-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Functions write_nic_auto_inc_address() and write_nic_dword_auto_inc() are
defined in the ipw2100.c file, but not called elsewhere, so remove these
unused functions.

drivers/net/wireless/intel/ipw2x00/ipw2100.c:427:20: warning: unused function 'write_nic_dword_auto_inc'.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3285
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index b0f23cf1a621..0812db8936f1 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -418,17 +418,6 @@ static inline void write_nic_byte(struct net_device *dev, u32 addr, u8 val)
 	write_register_byte(dev, IPW_REG_INDIRECT_ACCESS_DATA, val);
 }
 
-static inline void write_nic_auto_inc_address(struct net_device *dev, u32 addr)
-{
-	write_register(dev, IPW_REG_AUTOINCREMENT_ADDRESS,
-		       addr & IPW_REG_INDIRECT_ADDR_MASK);
-}
-
-static inline void write_nic_dword_auto_inc(struct net_device *dev, u32 val)
-{
-	write_register(dev, IPW_REG_AUTOINCREMENT_DATA, val);
-}
-
 static void write_nic_memory(struct net_device *dev, u32 addr, u32 len,
 				    const u8 * buf)
 {
-- 
2.20.1.7.g153144c

