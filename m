Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB3160175F
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 21:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbiJQTVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 15:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiJQTVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 15:21:01 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 21DBA5006E;
        Mon, 17 Oct 2022 12:20:55 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 086F320FDA84; Mon, 17 Oct 2022 12:20:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 086F320FDA84
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1666034454;
        bh=rxJ1l3XZAaUy7L0ulivQTclU3lx9TfDBngKUNfhY9VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=PePY3trNGguiL0s+ienaQOB/u9ao4YFoyvpE/JtzLb+f7C/r9Ff2+QTqcmOSlrz7k
         KugDJMN5BY1tZoZMsNRyu8T4WCkpocMEGnirh2BUuoAFSdMdgWvd6p+MBdL28ADdlr
         KIkGcbkUUMrqDCW756gxk1R862zHeC7mRZLqAghg=
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
Subject: [Patch v7 06/12] net: mana: Record port number in netdev
Date:   Mon, 17 Oct 2022 12:20:35 -0700
Message-Id: <1666034441-15424-7-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1666034441-15424-1-git-send-email-longli@linuxonhyperv.com>
References: <1666034441-15424-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
X-Spam-Status: No, score=-11.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Long Li <longli@microsoft.com>

The port number is useful for user-mode application to identify this
net device based on port index. Set to the correct value in ndev.

Reviewed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Long Li <longli@microsoft.com>
Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 6ad4bc8cbc99..b6303a43fa7c 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2133,6 +2133,7 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	ndev->max_mtu = ndev->mtu;
 	ndev->min_mtu = ndev->mtu;
 	ndev->needed_headroom = MANA_HEADROOM;
+	ndev->dev_port = port_idx;
 	SET_NETDEV_DEV(ndev, gc->dev);
 
 	netif_carrier_off(ndev);
-- 
2.17.1

