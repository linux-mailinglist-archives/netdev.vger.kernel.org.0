Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D620547C5F
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 23:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbiFLVPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 17:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235817AbiFLVPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 17:15:18 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 17DC8590B1;
        Sun, 12 Jun 2022 14:15:14 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id D5FEB20C14CC; Sun, 12 Jun 2022 14:15:13 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D5FEB20C14CC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1655068513;
        bh=p5GKtvBJepK5tUtAWUPKm2bLu7UNy3ry5F9qIJzPzOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=gd2jH72ij8G2Y2JDUU2XptVOJTLqQzurkEe1SE5BIqh6wWoyHk6TdzWq10Sfceejg
         12bHmRHBuLleVTxvkooLtLxJbHgxhyyvsnCWmqEsqMijBoUoPYjISFR2AKPmorChku
         mH6OJJTSQT1J5O4Oxlu0sqYDnU7mj/P+1Xg+JQTk=
From:   longli@linuxonhyperv.com
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, edumazet@google.com,
        shiraz.saleem@intel.com, Ajay Sharma <sharmaajay@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Long Li <longli@microsoft.com>
Subject: [Patch v3 08/12] net: mana: Record port number in netdev
Date:   Sun, 12 Jun 2022 14:14:50 -0700
Message-Id: <1655068494-16440-9-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1655068494-16440-1-git-send-email-longli@linuxonhyperv.com>
References: <1655068494-16440-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
X-Spam-Status: No, score=-11.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Long Li <longli@microsoft.com>

The port number is useful for user-mode application to identify this
net device based on port index. Set to the correct value in ndev.

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index d530de74e554..a977975c69dd 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1962,6 +1962,7 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	ndev->max_mtu = ndev->mtu;
 	ndev->min_mtu = ndev->mtu;
 	ndev->needed_headroom = MANA_HEADROOM;
+	ndev->dev_port = port_idx;
 	SET_NETDEV_DEV(ndev, gc->dev);
 
 	netif_carrier_off(ndev);
-- 
2.17.1

