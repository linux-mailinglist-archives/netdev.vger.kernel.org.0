Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56632BB352
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730716AbgKTScm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:32:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:51612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730039AbgKTScl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:32:41 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9EE124182;
        Fri, 20 Nov 2020 18:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897160;
        bh=A4kM/XSagZ64MlUZJqitZJrBUL3ol3A0OkGTUAPnE38=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZmoQeqpktsfoNzQ2E7bLwLmMdkviXWhlSZE4P2rlvERaKyGTjn8zPAx8PeK9yoKL8
         XHLQRejYi6A6ASdmZuH/fRCAeALLuQbz4GnhnjFmii+WM2h8sQfbv86C7ELU93RzbJ
         I/T8hvsffF3TxilEdq8kyjWgj3rWrd0tmBEtrF5E=
Date:   Fri, 20 Nov 2020 12:32:46 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jon Mason <jdmason@kudzu.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 056/141] vxge: Fix fall-through warnings for Clang
Message-ID: <1371a35e2c9a605d23eccc89fead0bfdf2ded327.1605896059.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a return statement instead of letting the code fall
through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/neterion/vxge/vxge-config.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-config.c b/drivers/net/ethernet/neterion/vxge/vxge-config.c
index f5d48d7c4ce2..34c10ee086eb 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-config.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-config.c
@@ -3784,6 +3784,7 @@ vxge_hw_rts_rth_data0_data1_get(u32 j, u64 *data0, u64 *data1,
 			VXGE_HW_RTS_ACCESS_STEER_DATA1_RTH_ITEM1_ENTRY_EN |
 			VXGE_HW_RTS_ACCESS_STEER_DATA1_RTH_ITEM1_BUCKET_DATA(
 			itable[j]);
+		return;
 	default:
 		return;
 	}
-- 
2.27.0

