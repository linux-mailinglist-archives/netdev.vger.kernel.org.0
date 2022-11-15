Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0BA62A071
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 18:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiKORev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 12:34:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiKORet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 12:34:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163D22ED5C
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 09:34:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A67F5B81A42
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 17:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DB8C433D6;
        Tue, 15 Nov 2022 17:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668533685;
        bh=tdU1JsnEb2QzHwjmx/G+2WiUZY6BzPfwrF6VIgp3flo=;
        h=From:To:Cc:Subject:Date:From;
        b=NBz2Jn40x6vfuvqMC3/8IW1jb0/MQLmunIgLy7k7qD0TizvLTK4NmRYQZFHVHta6z
         GZbQZGUAXi+ap7tXKz2U+JOUFAB3a4uvPjdH9W/R8GE8XlPH72Y3MIpxIZbgpGAhXX
         OokZaW5OLBZMNTwguiTAbj2/PmNyTrFjULAMDNIXX1jLFA4XS0kemDZoNH5O5vqQPO
         AFAGp0F5AhkQi7Yh+1GkKsSisYyVpIoFNsC0yEoTleBNFfqwCm7YQ3w3OrZZ9prnyU
         J15YEAq5Cqe0DtLViQxJ+bB5fjxy0IJE2m3iD4Q1enk7TOcRCo6vlljbT8YipM/bq6
         l85UDybeCtKFw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Derek Chickles <dchickles@marvell.com>,
        Eric Dumazet <edumazet@google.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Satanand Burla <sburla@marvell.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>
Subject: [PATCH net] net: liquidio: simplify if expression
Date:   Tue, 15 Nov 2022 19:34:39 +0200
Message-Id: <9845cbd62721437f946035669381a9719240fc89.1668533583.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Fix the warning reported by kbuild:

cocci warnings: (new ones prefixed by >>)
>> drivers/net/ethernet/cavium/liquidio/lio_main.c:1797:54-56: WARNING !A || A && B is equivalent to !A || B
   drivers/net/ethernet/cavium/liquidio/lio_main.c:1827:54-56: WARNING !A || A && B is equivalent to !A || B

Fixes: 8979f428a4af ("net: liquidio: release resources when liquidio driver open failed")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
The fixed patch was in net, so sending the fix to net too.
---
 drivers/net/ethernet/cavium/liquidio/lio_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 75771825c3f9..98793b2ac2c7 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -1794,7 +1794,7 @@ static int liquidio_open(struct net_device *netdev)
 
 	ifstate_set(lio, LIO_IFSTATE_RUNNING);
 
-	if (!OCTEON_CN23XX_PF(oct) || (OCTEON_CN23XX_PF(oct) && !oct->msix_on)) {
+	if (!OCTEON_CN23XX_PF(oct) || !oct->msix_on) {
 		ret = setup_tx_poll_fn(netdev);
 		if (ret)
 			goto err_poll;
@@ -1824,7 +1824,7 @@ static int liquidio_open(struct net_device *netdev)
 	return 0;
 
 err_rx_ctrl:
-	if (!OCTEON_CN23XX_PF(oct) || (OCTEON_CN23XX_PF(oct) && !oct->msix_on))
+	if (!OCTEON_CN23XX_PF(oct) || !oct->msix_on)
 		cleanup_tx_poll_fn(netdev);
 err_poll:
 	if (lio->ptp_clock) {
-- 
2.38.1

