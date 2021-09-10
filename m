Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3487406B02
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 13:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbhIJLwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 07:52:15 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:32772
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232613AbhIJLwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 07:52:15 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id E6A2840198;
        Fri, 10 Sep 2021 11:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631274661;
        bh=+RWGL6GMLleMJEJELE6w/v8VzwjFlxKfUcLYDwXNzNY=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=nd9Zb/uQMTIQ+I6GT5Tzp6wkA3/qoCGMBdDWW0JxJVHAhrgr7TJRAGYrIF1uRwqJQ
         ghsg1ueNDHWyJJhiUamDe7RY5FIPYPWALUL3ZGexl1niiUIqsdiFmuraHK9PG4inyU
         0SNpwHi4JoNYGGV1S4ALKcMbZLLyG7ERiVwGLF9dyaX8CzXTfV4DMxGoCXZ9SZfNri
         mH86nigsF78WZXZ2i85BPeZGfqHdzYuiiz6+pKKE1B+sRv6NMfoCXxOHngAziFfa95
         OlGcTGdqg1ZfqyCJb7QzHAarHcP01ExggUJqAK6s6ogdq4KdOiKHc/SLtSFWQUekdR
         OEKAg6R+bhQCQ==
From:   Colin King <colin.king@canonical.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ixgbevf: Remove redundant initialization of variable ret_val
Date:   Fri, 10 Sep 2021 12:51:00 +0100
Message-Id: <20210910115100.45429-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable ret_val is being initialized with a value that is never
read, it is being updated later on. The assignment is redundant and
can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/intel/ixgbevf/vf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/vf.c b/drivers/net/ethernet/intel/ixgbevf/vf.c
index 5fc347abab3c..d459f5c8e98f 100644
--- a/drivers/net/ethernet/intel/ixgbevf/vf.c
+++ b/drivers/net/ethernet/intel/ixgbevf/vf.c
@@ -66,9 +66,9 @@ static s32 ixgbevf_reset_hw_vf(struct ixgbe_hw *hw)
 {
 	struct ixgbe_mbx_info *mbx = &hw->mbx;
 	u32 timeout = IXGBE_VF_INIT_TIMEOUT;
-	s32 ret_val = IXGBE_ERR_INVALID_MAC_ADDR;
 	u32 msgbuf[IXGBE_VF_PERMADDR_MSG_LEN];
 	u8 *addr = (u8 *)(&msgbuf[1]);
+	s32 ret_val;
 
 	/* Call adapter stop to disable tx/rx and clear interrupts */
 	hw->mac.ops.stop_adapter(hw);
-- 
2.32.0

