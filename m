Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68135325CF
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 10:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbiEXI4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 04:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234144AbiEXI4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 04:56:35 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EED506C57F;
        Tue, 24 May 2022 01:56:32 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id B37C120B8952; Tue, 24 May 2022 01:56:32 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B37C120B8952
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1653382592;
        bh=S9zCpOj+eWgpuG0Rji4kZS90yBYpl24mDiXbxRGMI/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=MRlCkOrsbUoMjgpZ+qHu5Q1v6SUi/tQBdwoYnc4j9TTCLBBMunCiCjLijq99nEqjr
         tomhCIUaQFsoxy23EoC0sotLLrfJQurdHc+Ey3lxWyFSxkJiiZOzHv9xxPATfq/daB
         SkQUg9HpjuSQkL4b84j6SGedmfVJBWT2v2/hkivY=
From:   longli@linuxonhyperv.com
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Long Li <longli@microsoft.com>
Subject: [Patch v2 08/12] net: mana: Record port number in netdev
Date:   Tue, 24 May 2022 01:56:08 -0700
Message-Id: <1653382572-14788-9-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1653382572-14788-1-git-send-email-longli@linuxonhyperv.com>
References: <1653382572-14788-1-git-send-email-longli@linuxonhyperv.com>
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
index 15d3b68d7c41..067a2939d0d7 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1953,6 +1953,7 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	ndev->max_mtu = ndev->mtu;
 	ndev->min_mtu = ndev->mtu;
 	ndev->needed_headroom = MANA_HEADROOM;
+	ndev->dev_port = port_idx;
 	SET_NETDEV_DEV(ndev, gc->dev);
 
 	netif_carrier_off(ndev);
-- 
2.17.1

