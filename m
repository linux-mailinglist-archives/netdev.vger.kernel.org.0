Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D993BCFBD
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbhGFLbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:31:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235167AbhGFL3l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:29:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8731561D80;
        Tue,  6 Jul 2021 11:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570440;
        bh=aAtpwhKuMZGDxNZ3FqxdQXfUEParfME5aHdCkcyIr3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iy2UWrtLmCbQQags30F6mNT0dw09pcS2ROezDNSY+Sn1o+Fnx0qL5RKv1pAcG388S
         5n0tycDcp9RN5DcmuqXGWxL9ye50NTBkbrHreAuUTqf7TpxRcdTEKDG32hyfF0lz4x
         3HHt7LULYcPVtAmeFr+sSw9XN7Dqw5jjv0S32xbHADT2Bizg4g/T/dC+HpRAFNjyo9
         FALx5U+Zr3oKQyt4372km6hvtE1OYGB8kVkI4+7sydjPhUCL/2eLZCh2AMLxcU3eK6
         o4X3fvk65c4kcSX5uRyck3IPX04JlFjsVplusujdcWkyVFZLF3hSoYWAvy5gor6ca7
         2LMCUbQvW1WeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 100/160] ice: mark PTYPE 2 as reserved
Date:   Tue,  6 Jul 2021 07:17:26 -0400
Message-Id: <20210706111827.2060499-100-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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

