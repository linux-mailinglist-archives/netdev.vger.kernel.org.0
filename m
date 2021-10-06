Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11A14245AC
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 20:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238972AbhJFSJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 14:09:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229633AbhJFSJC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 14:09:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29BB461037;
        Wed,  6 Oct 2021 18:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633543629;
        bh=hK7tcElURjdk1VtQDOMC4EE85ZwjiEEH/WqXEYfbd0g=;
        h=Date:From:To:Cc:Subject:From;
        b=WPbklxCSIVEdVwErZQU+6NhIWqUMwXaIit92xb/Twxqj8qOBfrF76I6LQnTADaYRD
         wKQ+VUpgY/Y70zC1hhdOKc2ZbthD+e8X/kfrMZAZOuQ7ex/S7M3a/KBqiU4pLpcuzI
         7MMjN7eBxK8EckawObo0o2ZbtKLV3puPZdDFrB6Lt5uY7wKctBHnb3HuSqKbxUE/ny
         SWkmYbK9d3xh5IjqmrV7uVx6WPFKENzX8EOMmjKxUmAPeC3VL3aeD94RKi09pdIq6D
         FuS6vDKpQONriIdZxWrEQR4b9uX20C/so644qLbDAxpSKKrGGUiMzYBDhOQF7zJsyW
         c9N9diE/fLmhQ==
Date:   Wed, 6 Oct 2021 13:11:15 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] ethernet: ti: cpts: Use devm_kcalloc() instead of
 devm_kzalloc()
Message-ID: <20211006181115.GA913499@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use 2-factor multiplication argument form devm_kcalloc() instead
of devm_kzalloc().

Link: https://github.com/KSPP/linux/issues/162
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/ti/cpts.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index 43222a34cba0..dc70a6bfaa6a 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -669,10 +669,10 @@ static int cpts_of_mux_clk_setup(struct cpts *cpts, struct device_node *node)
 		goto mux_fail;
 	}
 
-	parent_names = devm_kzalloc(cpts->dev, (sizeof(char *) * num_parents),
-				    GFP_KERNEL);
+	parent_names = devm_kcalloc(cpts->dev, num_parents,
+				    sizeof(*parent_names), GFP_KERNEL);
 
-	mux_table = devm_kzalloc(cpts->dev, sizeof(*mux_table) * num_parents,
+	mux_table = devm_kcalloc(cpts->dev, num_parents, sizeof(*mux_table),
 				 GFP_KERNEL);
 	if (!mux_table || !parent_names) {
 		ret = -ENOMEM;
-- 
2.27.0

