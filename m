Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F174C0A0C
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 04:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237591AbiBWDPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 22:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236490AbiBWDPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 22:15:19 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D091E11C04;
        Tue, 22 Feb 2022 19:14:52 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=guoheyi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V5Fxg9P_1645586078;
Received: from fdadf40dcbca.tbsite.net(mailfrom:guoheyi@linux.alibaba.com fp:SMTPD_---0V5Fxg9P_1645586078)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 23 Feb 2022 11:14:49 +0800
From:   Heyi Guo <guoheyi@linux.alibaba.com>
To:     linux-kernel@vger.kernel.org
Cc:     Heyi Guo <guoheyi@linux.alibaba.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dylan Hung <dylan_hung@aspeedtech.com>, netdev@vger.kernel.org
Subject: [PATCH 0/3] drivers/net/ftgmac100: fix occasional DHCP failure
Date:   Wed, 23 Feb 2022 11:14:33 +0800
Message-Id: <20220223031436.124858-1-guoheyi@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is to fix the issues discussed in the mail thread:
https://lore.kernel.org/netdev/51f5b7a7-330f-6b3c-253d-10e45cdb6805@linux.alibaba.com/
and follows the advice from Andrew Lunn.

The first 2 patches refactors the code to enable adjust_link calling reset
function directly.

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Guangbin Huang <huangguangbin2@huawei.com>
Cc: Hao Chen <chenhao288@hisilicon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dylan Hung <dylan_hung@aspeedtech.com>
Cc: netdev@vger.kernel.org


Heyi Guo (3):
  drivers/net/ftgmac100: refactor ftgmac100_reset_task to enable direct
    function call
  drivers/net/ftgmac100: adjust code place for function call dependency
  drivers/net/ftgmac100: fix DHCP potential failure with systemd

 drivers/net/ethernet/faraday/ftgmac100.c | 243 ++++++++++++-----------
 1 file changed, 129 insertions(+), 114 deletions(-)

-- 
2.17.1

