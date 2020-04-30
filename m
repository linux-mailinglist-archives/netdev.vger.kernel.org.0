Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205C21BED9A
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 03:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgD3BdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 21:33:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41237 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726291AbgD3BdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 21:33:06 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id C2B1C5C00A0;
        Wed, 29 Apr 2020 21:33:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 29 Apr 2020 21:33:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rylan.coffee; h=
        date:from:to:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=5BQ8TWBbFrZMRutXSFgLkUsDRiN
        OqjDvGB6YDIdGUuY=; b=jWqtVYpeuvHKj0qeawG8tpDIbMMPay5i1yl658tlLte
        5o7er518CaEyYqyAe2FUnu9gNHgV6hBSRqphS0Lwzrtcm7aBYJRxQ2dJhNprtJcS
        yVVAEd2pxg7Zy5mVxMDErzjRRoKcaYAWDStVsFLf95HwIRFYdqN9yMSjkDCXVkul
        SPVf8rIoUTJwCQbRolMwan5/ejePnYkFpVZgZGMlBiICRrN7BPZeAIWQhL204bYy
        JzisZAHw2d0jGyIW6+d1UZXJHM+hIoMZPeVrHp8Q4xM5ZcO+pMyjVJZAhbPUNgY2
        uUY8TJTklQeTQeLMfeyMfbj5ryzDJHTxYnRub1sU+qg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=5BQ8TW
        BbFrZMRutXSFgLkUsDRiNOqjDvGB6YDIdGUuY=; b=NDNZiNAncl+LhI6FhtGxu9
        CGFUq0I4T9Wiu8K/IMr2XMt9uS+tvG0D2rUc4D3MKtXBNtVGQEtLs76dZImWBExX
        ue1YOu8oquyHrr2GzRt6tKRoJ5ZPEIThgqqdjUn15hstwzVsoUa3OIol79ljJIFs
        lpwdP1uqHu1C8gndU802nMFvQ5/oNFF5ceFzv5Skx3/peFngU+fiosHRkF5lu07U
        Yre9NE8VI2wB8LEYER7YKZCWraEakDTd/Db2JIDzHImqeHeJqMRJiGBTJnLqhaKn
        7pqTDKCkrx4mcdRO99h4PhM2vBWgXAyvg1GbanD7aZhZ/8hXBUUFAzC2uutiKuwQ
        ==
X-ME-Sender: <xms:0SqqXsaMOKmmaQ6ZMLKlzW_9CmRJ3s2KAocYOYOAbKTbOg8LpzpkHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrieeggdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtjeenucfhrhhomheptfihlhgrnhcu
    ffhmvghllhhouceomhgrihhlsehrhihlrghnrdgtohhffhgvvgeqnecuggftrfgrthhtvg
    hrnhepjeffvefffeevgfdtteegudffieduveeuhfettddvueehveethfffgeetfeeghfeu
    necukfhppedutdekrdegledrudehkedrkeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepmhgrihhlsehrhihlrghnrdgtohhffhgvvg
X-ME-Proxy: <xmx:0SqqXmPg3KeAqzu_CUPmq5iwcVb3lD9SyhoHnlmQr9HUGHi_WPZuZQ>
    <xmx:0SqqXhr32wzs6lGnR8jP6VbAMimdODdpAE1N-gGe7nkGYVSshGkWbA>
    <xmx:0SqqXtsE_HDjI2BPeY1R2kiKXrj4sJqAJziqx5-hcEK-pa32P-y4Bg>
    <xmx:0SqqXlATXbFtLYHRKpRDaGDpjMIyiXZPrluLb3HTUS2IRwgJCLTXOw>
Received: from athena (pool-108-49-158-84.bstnma.fios.verizon.net [108.49.158.84])
        by mail.messagingengine.com (Postfix) with ESMTPA id 627D3328005E;
        Wed, 29 Apr 2020 21:33:05 -0400 (EDT)
Date:   Wed, 29 Apr 2020 21:33:04 -0400
From:   Rylan Dmello <mail@rylan.coffee>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: [PATCH v2 2/7] staging: qlge: Remove gotos from ql_set_mac_addr_reg
Message-ID: <a6f485e43eb55e8fdc64a7a346cb0419b55c3cb6.1588209862.git.mail@rylan.coffee>
References: <cover.1588209862.git.mail@rylan.coffee>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1588209862.git.mail@rylan.coffee>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As suggested by Joe Perches, this patch removes the 'exit' label
from the ql_set_mac_addr_reg function and replaces the goto
statements with break statements.

Signed-off-by: Rylan Dmello <mail@rylan.coffee>
---
 drivers/staging/qlge/qlge_main.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 29610618c7c0..f2b4a54fc4c0 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -336,22 +336,20 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
 
 		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 		if (status)
-			goto exit;
+			break;
 		ql_write32(qdev, MAC_ADDR_IDX,
 			   (offset++) | (index << MAC_ADDR_IDX_SHIFT) | type |
 				   MAC_ADDR_E);
 		ql_write32(qdev, MAC_ADDR_DATA, lower);
 		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 		if (status)
-			goto exit;
+			break;
 		ql_write32(qdev, MAC_ADDR_IDX,
 			   (offset++) | (index << MAC_ADDR_IDX_SHIFT) | type |
 				   MAC_ADDR_E);
 
 		ql_write32(qdev, MAC_ADDR_DATA, upper);
 		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
-		if (status)
-			goto exit;
 		break;
 	}
 	case MAC_ADDR_TYPE_CAM_MAC: {
@@ -361,7 +359,7 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
 			    (addr[5]);
 		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 		if (status)
-			goto exit;
+			break;
 		ql_write32(qdev, MAC_ADDR_IDX,
 			   (offset++) | /* offset */
 				   (index << MAC_ADDR_IDX_SHIFT) | /* index */
@@ -369,7 +367,7 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
 		ql_write32(qdev, MAC_ADDR_DATA, lower);
 		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 		if (status)
-			goto exit;
+			break;
 		ql_write32(qdev, MAC_ADDR_IDX,
 			   (offset++) | /* offset */
 				   (index << MAC_ADDR_IDX_SHIFT) | /* index */
@@ -377,7 +375,7 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
 		ql_write32(qdev, MAC_ADDR_DATA, upper);
 		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 		if (status)
-			goto exit;
+			break;
 		ql_write32(qdev, MAC_ADDR_IDX,
 			   (offset) | /* offset */
 				   (index << MAC_ADDR_IDX_SHIFT) | /* index */
@@ -404,7 +402,7 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
 		 */
 		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 		if (status)
-			goto exit;
+			break;
 		ql_write32(qdev, MAC_ADDR_IDX,
 			   offset | /* offset */
 				   (index << MAC_ADDR_IDX_SHIFT) | /* index */
@@ -418,7 +416,6 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
 			   "Address type %d not yet supported.\n", type);
 		status = -EPERM;
 	}
-exit:
 	return status;
 }
 
-- 
2.26.2

