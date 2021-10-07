Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21834259EC
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 19:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243319AbhJGRwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 13:52:34 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:60872
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242977AbhJGRwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 13:52:32 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 2D71F3F0FD;
        Thu,  7 Oct 2021 17:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633629037;
        bh=sHODJwADaBNkGBnpJ4b1p+n+qG3uJ7pQmsmBlz9KB0c=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=vu1kGcRxqibo5xSGOPO85gojCaMHXQqDmLbA52gEbtZt0yvPSbCLCFlMOe/yfvX4E
         2qGobZnUcAVtkwjNb8+kNMHutQHFjje14A/N7Fi3zuNoONQ/CBmBy3QHoK+WvRgo9M
         o6GC2eUeu2JDWUVvZwvquMi+UxemzwQCSCoKNvyT5EOavezhNq1RJzpjFsv10hDWFQ
         XahLa0005FPa+RCu9FXq+jkZvFLWf94CByDW0zPtUZpXVjd/YM5i4Khq35UqWkYm2B
         MthVWEFZPwVfc3eShLFwjFDoU8fNeV4cchautuNu0l94I33NXAcUyh/ly1yb/zIosP
         8/9InCJVX8uMg==
From:   Colin King <colin.king@canonical.com>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sfc: Remove redundant assignment of variable rc
Date:   Thu,  7 Oct 2021 18:50:36 +0100
Message-Id: <20211007175036.22309-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable rc is being assigned a value that is never read, it is
never accessed after the assignment. The assignment is redundant and
can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/sfc/ptp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index a39c5143b386..f5198d6a3d43 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1141,8 +1141,6 @@ static void efx_ptp_xmit_skb_mc(struct efx_nic *efx, struct sk_buff *skb)
 
 	skb_tstamp_tx(skb, &timestamps);
 
-	rc = 0;
-
 fail:
 	dev_kfree_skb_any(skb);
 
-- 
2.32.0

