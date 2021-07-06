Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A3A3BD1E6
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239196AbhGFLkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236648AbhGFLfe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CB8C61DFD;
        Tue,  6 Jul 2021 11:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570639;
        bh=aAtpwhKuMZGDxNZ3FqxdQXfUEParfME5aHdCkcyIr3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFvRzh67DU/PDB8cFE2Oxr5znnAWAcNJO9JWDR/40taqSa6GApGEo1IXskLJzGizL
         W0tHmMZFpuGSU2CMRxq0Ow2cbGbdFfS/52lkUPOYuvxaYGk5OqZoQ7EC2sXVy2gRB9
         l9x5BZQVVByYQdZ2TfJI9iii8dKpZ+AeqS8Oln58ZkFIa8MKkMvrV8r5hK8srrGU2m
         vn/yC+mvstTkY56emyIUNi7bDdjqGFY6ky/3SAGx9MwF7C7xho2+lXWZ1jexSCxzcL
         +SBSBxf8XBZZbXsqc/bmnrHq8ybd/6U3JpvQuq88fU2P90hPPL335nVLB3TWr3TrMs
         cXvN+G3gUjy5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 089/137] ice: mark PTYPE 2 as reserved
Date:   Tue,  6 Jul 2021 07:21:15 -0400
Message-Id: <20210706112203.2062605-89-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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
index 98a7f27c532b..c0ee0541e53f 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -608,7 +608,7 @@ static const struct ice_rx_ptype_decoded ice_ptype_lkup[] = {
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

