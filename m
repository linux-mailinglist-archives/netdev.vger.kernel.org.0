Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3DB1364AF5
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 22:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbhDSUEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 16:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233575AbhDSUES (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 16:04:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD52861363;
        Mon, 19 Apr 2021 20:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618862628;
        bh=tWrU8S8Z4iKOl5bQa1q00VydfNPYDByYgGN3c0wCnR4=;
        h=From:To:Cc:Subject:Date:From;
        b=Pl0DXrH9L08D5qKVPlgkvvaC7o/x8oxCAtEZHk4wpD6aiMYGuIAxLB9huE9ujOc6D
         SgVk4CYrUsn+MK7OprWdq/OHD2oTarsthu+n54dkYR5QFIQ+nayiSs6d+EMcMFqbM7
         UUrLcSzjXOFMCxunGtbNrSzIxbt1KUsFQZMg3AGIvQCPwN34Kfr05Yp5tJzSDq0Mt1
         xS9DWxB87K8HzYNQzYa9QNy9dmDsYc/VsePicbrqlJsHklks1WkcflQT/U+p47qafa
         AcxoVvHgV3ei5v92WzSE06Uj2ZSkmyQtWqBX52K/2Pe3c/qAfvGVFQ0zNFzHKG1tpV
         IvxVzrtu2pSTA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, idosch@idosch.org,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next] ethtool: stats: clarify the initialization to ETHTOOL_STAT_NOT_SET
Date:   Mon, 19 Apr 2021 13:03:45 -0700
Message-Id: <20210419200345.2984715-1-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ido suggests we add a comment about the init of stats to -1.
This is unlikely to be clear to first time readers.

Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/stats.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ethtool/stats.c b/net/ethtool/stats.c
index acb2b080c358..b7642dc96d50 100644
--- a/net/ethtool/stats.c
+++ b/net/ethtool/stats.c
@@ -114,6 +114,9 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 	if (ret < 0)
 		return ret;
 
+	/* Mark all stats as unset (see ETHTOOL_STAT_NOT_SET) to prevent them
+	 * from being reported to user space in case driver did not set them.
+	 */
 	memset(&data->phy_stats, 0xff, sizeof(data->phy_stats));
 	memset(&data->mac_stats, 0xff, sizeof(data->mac_stats));
 	memset(&data->ctrl_stats, 0xff, sizeof(data->mac_stats));
-- 
2.30.2

