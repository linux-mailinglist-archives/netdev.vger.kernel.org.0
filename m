Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A87A523D07
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 21:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346579AbiEKTH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 15:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237377AbiEKTH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 15:07:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6760D69CF5
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 12:07:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F939B8260E
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 19:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8FBC340EE;
        Wed, 11 May 2022 19:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652296041;
        bh=vEQw8rze24M0LuBiXw33eFka3xyEZh8GMhVyPH3jZCw=;
        h=From:To:Cc:Subject:Date:From;
        b=bwVjgwDoXfUJy9AuKUncBDgEHmlJ5s/rqpObHZdsKvRXpw+AVaSD5LZuogQ8eMfT2
         twK1uNez83vgGcsWW6p2gYXheMEymB+adf6I/DTbARkGxh98QAT7Hu64vtwXa7pema
         wNkhe0Ht9mzS9IZNoete93gi8bnHsoL2C86wgCicWDEZb3W6IpnDOzuYxjef/rXshO
         n86rVyCu14v0Q5f6V3kqkk0u6JGwzXM59fJyBEor5JJpNWULvqpCpkvo5Ag7+j1ExE
         /ex8ceNmYcLjzBrgdz+/A+IUlxlpwC/GPRHzFfhhfd52NK8NLkmGuXtIOa25U7fOs/
         LQjV2n/gcPP1w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: update the register_netdevice() kdoc
Date:   Wed, 11 May 2022 12:07:20 -0700
Message-Id: <20220511190720.1401356-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BUGS section looks quite dated, the registration
is under rtnl lock. Remove some obvious information
while at it.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/dev.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 91b7e7784da9..a601da3b4a7c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9927,22 +9927,14 @@ void netif_tx_stop_all_queues(struct net_device *dev)
 EXPORT_SYMBOL(netif_tx_stop_all_queues);
 
 /**
- *	register_netdevice	- register a network device
- *	@dev: device to register
- *
- *	Take a completed network device structure and add it to the kernel
- *	interfaces. A %NETDEV_REGISTER message is sent to the netdev notifier
- *	chain. 0 is returned on success. A negative errno code is returned
- *	on a failure to set up the device, or if the name is a duplicate.
+ * register_netdevice() - register a network device
+ * @dev: device to register
  *
- *	Callers must hold the rtnl semaphore. You may want
- *	register_netdev() instead of this.
- *
- *	BUGS:
- *	The locking appears insufficient to guarantee two parallel registers
- *	will not get the same name.
+ * Take a prepared network device structure and make it externally accessible.
+ * A %NETDEV_REGISTER message is sent to the netdev notifier chain.
+ * Callers must hold the rtnl lock - you may want register_netdev()
+ * instead of this.
  */
-
 int register_netdevice(struct net_device *dev)
 {
 	int ret;
-- 
2.34.3

