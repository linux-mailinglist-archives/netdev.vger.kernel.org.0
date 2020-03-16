Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B88218743A
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 21:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732598AbgCPUr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 16:47:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732537AbgCPUrZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 16:47:25 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A64CC20719;
        Mon, 16 Mar 2020 20:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584391645;
        bh=5X7W6p75pe8eZkmudCnrya0wvM5uYOzxEjom2C2CMRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clI8eblxcsPNOP4tRfSqf1RMWtpNX6dgd5zEtKq1JlHBkgWy/U+6lWcSRc41q+NhW
         jtUE2pKIfRkRhDfXOl7m3ZVTmzNFSjqNF2uTLYOCt9HLoO7a+3lGb4ebQ/QKQcw1Pd
         t3AylPU/ii7qO0z9wqs0lI9bafdjCz45GBdNYHwQ=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-net-drivers@solarflare.com,
        ecree@solarflare.com, mhabets@solarflare.com,
        jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        Jose.Abreu@synopsys.com, andy@greyhouse.net,
        grygorii.strashko@ti.com, andrew@lunn.ch, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/9] net: tehuti: reject unsupported coalescing params
Date:   Mon, 16 Mar 2020 13:47:07 -0700
Message-Id: <20200316204712.3098382-5-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200316204712.3098382-1-kuba@kernel.org>
References: <20200316204712.3098382-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ethtool_ops->supported_coalesce_params to let
the core reject unsupported coalescing parameters.

This driver did not previously reject unsupported parameters.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/tehuti/tehuti.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index 0f8a924fc60c..40a2ce0ca808 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -2373,6 +2373,8 @@ static void bdx_get_ethtool_stats(struct net_device *netdev,
 static void bdx_set_ethtool_ops(struct net_device *netdev)
 {
 	static const struct ethtool_ops bdx_ethtool_ops = {
+		.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+					     ETHTOOL_COALESCE_MAX_FRAMES,
 		.get_drvinfo = bdx_get_drvinfo,
 		.get_link = ethtool_op_get_link,
 		.get_coalesce = bdx_get_coalesce,
-- 
2.24.1

