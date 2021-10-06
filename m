Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1A542459C
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 20:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239291AbhJFSHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 14:07:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238900AbhJFSHO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 14:07:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F65161037;
        Wed,  6 Oct 2021 18:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633543522;
        bh=zAoSc1i6mv5/gTnn3bk3dl79yJmSsZSrmw6QPxKK9/4=;
        h=Date:From:To:Cc:Subject:From;
        b=sXP4On1fd3PFCo9KT1k6D5mG5h9iM0ZwYucSxs2L75+lygO6sVxDv863qGE3nAjDS
         ZWlwD2NSKyiyoZZ2uIr8hattFmYnpP3lUBzJn/iJpOf6xF817/MPsvdxheiir4Cip+
         6hp89Dx26i30uPizwwLVzxzbp0Y3krrm+MYPL4eu/eHmEuqZ+2C9+9joXL1l1YDkNH
         z6A96hCYjYbL473/SQP269QeVDG/GPOUKU+v8xyJ9y76mHUmTvm0E0fLDJMmXwAvGE
         GAX2Yoaoh/bpflzy9hFw7a6WaxqM16H0LmkFlZ0DbWc04iPzVadBobF61t39jWgVgg
         +qOJTf5PLzAiw==
Date:   Wed, 6 Oct 2021 13:09:27 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net: mana: Use kcalloc() instead of kzalloc()
Message-ID: <20211006180927.GA913456@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use 2-factor multiplication argument form kcalloc() instead
of kzalloc().

Link: https://github.com/KSPP/linux/issues/162
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/hw_channel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index d5c485a6d284..7c7a5fb91f79 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -363,7 +363,7 @@ static int mana_hwc_create_cq(struct hw_channel_context *hwc, u16 q_depth,
 	}
 	hwc_cq->gdma_cq = cq;
 
-	comp_buf = kcalloc(q_depth, sizeof(struct gdma_comp), GFP_KERNEL);
+	comp_buf = kcalloc(q_depth, sizeof(*comp_buf), GFP_KERNEL);
 	if (!comp_buf) {
 		err = -ENOMEM;
 		goto out;
@@ -580,7 +580,7 @@ static int mana_hwc_test_channel(struct hw_channel_context *hwc, u16 q_depth,
 			return err;
 	}
 
-	ctx = kzalloc(q_depth * sizeof(struct hwc_caller_ctx), GFP_KERNEL);
+	ctx = kcalloc(q_depth, sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
-- 
2.27.0

