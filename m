Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3F63BCD0C
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhGFLUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:20:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232789AbhGFLTb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:19:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75E0061C6E;
        Tue,  6 Jul 2021 11:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570212;
        bh=u0QFyRevTZr7p8yfLERK/B+mNVjUavYlRYsUcZXuM6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzP6/KfKbTHJJXQwOKWTvPwx/zisuA10C59fejN5PVXo/WssHoqkm6r/FA9Arl89l
         81LToiMacLTeCUl5SO1o0QI+93PG7w+0xTIJK4gEx61n+Bn3NnnoFjIuCZv/+3Z4aQ
         OWhGOjOlBFwDX76osFtXLgIdAQeIpUuHv7gH99lk5mQTXWAe4x2nD1XkkiTcgWx31h
         cSH6IV4jBk+NSawQRtTZtGH9B0tBa27FqOII0m0DSL3lD9UDZtCQzHDhvKmnWi/+5S
         kKcWdd7DBNq8du8LxRI5Q646ceAxs/5GZ5MUQtJPJo4L6UjxrpCeKM6/MebIYY/0yX
         ZBfuF1n1J6Yxw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 121/189] ice: mark PTYPE 2 as reserved
Date:   Tue,  6 Jul 2021 07:13:01 -0400
Message-Id: <20210706111409.2058071-121-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 0c526d440f76676733cb470b454db9d5507a3a50 ]

The entry for PTYPE 2 in the ice_ptype_lkup table incorrectly states
that this is an L2 packet with no payload. According to the datasheet,
this PTYPE is actually unused and reserved.

Fix the lookup entry to indicate this is an unused entry that is
reserved.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index fc3b56c13786..4238ab0433ee 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -630,7 +630,7 @@ static const struct ice_rx_ptype_decoded ice_ptype_lkup[] = {
 	/* L2 Packet types */
 	ICE_PTT_UNUSED_ENTRY(0),
 	ICE_PTT(1, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY2),
-	ICE_PTT(2, L2, NONE, NOF, NONE, NONE, NOF, NONE, NONE),
+	ICE_PTT_UNUSED_ENTRY(2),
 	ICE_PTT_UNUSED_ENTRY(3),
 	ICE_PTT_UNUSED_ENTRY(4),
 	ICE_PTT_UNUSED_ENTRY(5),
-- 
2.30.2

