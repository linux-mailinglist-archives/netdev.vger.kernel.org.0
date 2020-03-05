Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB77179F07
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 06:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgCEFQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 00:16:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:56830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725861AbgCEFQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 00:16:39 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD0822166E;
        Thu,  5 Mar 2020 05:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583385398;
        bh=h73SkZqGZAdtqP86T3oRUbRi0Uqo0N8Y1WImllCeDoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=utd8oNGm/0JoFlVE/GaXHeDzFbUcWVGkUPT5pD83dBUCs0Vb/To1u6AcCW56TCXhS
         xRvihJ4mm1we7oVF0zB762c7mdPmTtMOlOPEuoLRY6q3ybsOwHFwfqMZ6ms93M3fTq
         SLK3i7zXwDgpDw5vC2Xg35oDmVpuzeDQDndKl6cM=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, ecree@solarflare.com, mkubecek@suse.cz,
        thomas.lendacky@amd.com, benve@cisco.com, _govind@gmx.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, snelson@pensando.io, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, alexander.h.duyck@linux.intel.com,
        michael.chan@broadcom.com, saeedm@mellanox.com, leon@kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 09/12] bnxt: reject unsupported coalescing params
Date:   Wed,  4 Mar 2020 21:15:39 -0800
Message-Id: <20200305051542.991898-10-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305051542.991898-1-kuba@kernel.org>
References: <20200305051542.991898-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ethtool_ops->supported_coalesce_params to let
the core reject unsupported coalescing parameters.

This driver did not previously reject unsupported parameters.

v3: adjust commit message for new member name

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 7e84f1dc9d87..1fa3a12b5196 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3472,6 +3472,12 @@ void bnxt_ethtool_free(struct bnxt *bp)
 }
 
 const struct ethtool_ops bnxt_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES |
+				     ETHTOOL_COALESCE_USECS_IRQ |
+				     ETHTOOL_COALESCE_MAX_FRAMES_IRQ |
+				     ETHTOOL_COALESCE_STATS_BLOCK_USECS |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
 	.get_link_ksettings	= bnxt_get_link_ksettings,
 	.set_link_ksettings	= bnxt_set_link_ksettings,
 	.get_pauseparam		= bnxt_get_pauseparam,
-- 
2.24.1

