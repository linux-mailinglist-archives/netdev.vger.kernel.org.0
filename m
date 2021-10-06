Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD05B424593
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 20:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239177AbhJFSGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 14:06:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238578AbhJFSGb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 14:06:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0798961027;
        Wed,  6 Oct 2021 18:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633543478;
        bh=Jy892AFSmazu4mAAzfSOgIUzUcYHpF2xDlOZsQe3o3A=;
        h=Date:From:To:Cc:Subject:From;
        b=fuon3O+dYzcjxjZV7WjV/GK8kq9yE0jPhrqc3EnEisinBSfjZRrQN5UiFQEPsuJen
         RE7snRvSekj9fAuhpoLRuK6la7imhImJ0UtEsQPCbM6lHzk45u83C1TGV1XHzv+gH5
         +ibgswXOiT96pH8c4QSkapN2hFYaAgcYq0FrETxb3MvJObe/AWEuW3oa0wrpylWuaV
         7YMg/TtrTUwIyO8bDmzDtG8psqrPDFGnifm3gGxSmiSPW7MVP7zHNzNbPLDqAW/2mr
         qfbIUnx7LHoT0ns6IHztaSJywpA+TLuj4zOrqaKnr6mPZtHENDsfLOuZk3csGJgO44
         UxbP/4KYPnVTQ==
Date:   Wed, 6 Oct 2021 13:08:43 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net: broadcom: bcm4908_enet: use kcalloc() instead of
 kzalloc()
Message-ID: <20211006180843.GA913399@embeddedor>
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
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 02a569500234..a4726114be9e 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -170,7 +170,7 @@ static int bcm4908_dma_alloc_buf_descs(struct bcm4908_enet *enet,
 		goto err_free_buf_descs;
 	}
 
-	ring->slots = kzalloc(ring->length * sizeof(*ring->slots), GFP_KERNEL);
+	ring->slots = kcalloc(ring->length, sizeof(*ring->slots), GFP_KERNEL);
 	if (!ring->slots)
 		goto err_free_buf_descs;
 
-- 
2.27.0

