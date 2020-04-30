Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDD91BEDA0
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 03:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgD3Bd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 21:33:58 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48883 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726291AbgD3Bd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 21:33:58 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 5105F5C00C3;
        Wed, 29 Apr 2020 21:33:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 29 Apr 2020 21:33:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rylan.coffee; h=
        date:from:to:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=ySxQisW9kHtwSVU91GJSicfHBRQ
        rowkBqQjchwvXJwY=; b=HF7WrO6+gKioaXq8/TOC3OBPlcrtEWSXoHnTUFDsJi2
        VBoK2qjFBX2E+UtTl53//Zp6/BTik9cj3Pvveh7CSbND6Av7T+jPac60ROYbE4YE
        U4LLX+jrt1Dpjo4xRBDcYCEjJza5bTkAROtLuJ9HEQBgIclhgV8jZAVXUMraaNWb
        IGo+yFHIQKHITko+IAvyDJvml3c1KNG94dZE1jTz1eygrF/msPF+M/BUv+Ii8hdx
        e5NGsrGIXi40AxZuXeVHKGoYUGqFSJvtWqMfvgbDmLn6hWIAo/ToWfw5udbparAk
        ymTiHEhe2qXlc36+yIs3TxpN79n740DTrMHF55DZMgA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ySxQis
        W9kHtwSVU91GJSicfHBRQrowkBqQjchwvXJwY=; b=4co//xgNOQkpPuJnnYaR1M
        99l2SL5EIj8AbASqcrCnCpFjS6Xt9LNSQ7MUCVA5yMapQmSYRkp0MEM3521xgbW/
        Keazlv3aKtuXP1mU2/AtOJXp7WB3zMS+Xi/fVCNN6Dvb9x/UJzliqPPbi4xHESwY
        /XAv0G3n88yAOO0PUBTFpb3HmdDrivfY59lpq60AyaBd6Lqp7RyqH0DXFCGeFyjU
        tIC0moqjNd4xufy/0o8S0VNsLd3Zpk3h0LZM/8bW7g9kmwH5m4SxLgl7DcSnADhe
        1mNIqCoqMvbRYH18OfpiBoGVVXvPZDkW3MBQVaj9sgF+ziToYkq2xVEvnEdEH+AA
        ==
X-ME-Sender: <xms:BSuqXv5maBR2InpApd9WoaSIwku6R-j0X9UtgCnjQP9TJLN0k2p11g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrieeggdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtjeenucfhrhhomheptfihlhgrnhcu
    ffhmvghllhhouceomhgrihhlsehrhihlrghnrdgtohhffhgvvgeqnecuggftrfgrthhtvg
    hrnhepjeffvefffeevgfdtteegudffieduveeuhfettddvueehveethfffgeetfeeghfeu
    necukfhppedutdekrdegledrudehkedrkeegnecuvehluhhsthgvrhfuihiivgepvdenuc
    frrghrrghmpehmrghilhhfrhhomhepmhgrihhlsehrhihlrghnrdgtohhffhgvvg
X-ME-Proxy: <xmx:BSuqXhP7znTpWVVArFs_4o0PKjzH9smPvGlVhTZnwo5XodW9X0ZYzw>
    <xmx:BSuqXpMCN7AkwaM-ZW0bzV3znQgC0jYP90g4YQZaCBCkQy0CJw9uJA>
    <xmx:BSuqXh_K0yVLG3sniXHsgyGqWUNfeLsD-JV7wymd7NZ6uzfUoyKa7w>
    <xmx:BSuqXmbUu1spvbvAgv2TP2b3vvr6Ot0nU4gvcw-xoRYxGRrvcFaE_Q>
Received: from athena (pool-108-49-158-84.bstnma.fios.verizon.net [108.49.158.84])
        by mail.messagingengine.com (Postfix) with ESMTPA id E509E3065F06;
        Wed, 29 Apr 2020 21:33:56 -0400 (EDT)
Date:   Wed, 29 Apr 2020 21:33:56 -0400
From:   Rylan Dmello <mail@rylan.coffee>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: [PATCH v2 4/7] staging: qlge: Remove goto statements from
 ql_get_mac_addr_reg
Message-ID: <9339ea49c4f943411adae3b9b5b278ae8bf062e1.1588209862.git.mail@rylan.coffee>
References: <cover.1588209862.git.mail@rylan.coffee>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1588209862.git.mail@rylan.coffee>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to ql_set_mac_addr_reg, ql_get_mac_addr_reg also has several
goto statements that can be trivially replaced with a break statement.

Signed-off-by: Rylan Dmello <mail@rylan.coffee>
---
 drivers/staging/qlge/qlge_main.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 844c2c6df38d..bb6c198a0130 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -265,7 +265,7 @@ int ql_get_mac_addr_reg(struct ql_adapter *qdev, u32 type, u16 index,
 	case MAC_ADDR_TYPE_CAM_MAC: {
 		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 		if (status)
-			goto exit;
+			break;
 		ql_write32(qdev, MAC_ADDR_IDX,
 			   (offset++) | /* offset */
 				   (index << MAC_ADDR_IDX_SHIFT) | /* index */
@@ -273,11 +273,11 @@ int ql_get_mac_addr_reg(struct ql_adapter *qdev, u32 type, u16 index,
 				   type); /* type */
 		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MR, 0);
 		if (status)
-			goto exit;
+			break;
 		*value++ = ql_read32(qdev, MAC_ADDR_DATA);
 		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 		if (status)
-			goto exit;
+			break;
 		ql_write32(qdev, MAC_ADDR_IDX,
 			   (offset++) | /* offset */
 				   (index << MAC_ADDR_IDX_SHIFT) | /* index */
@@ -285,13 +285,13 @@ int ql_get_mac_addr_reg(struct ql_adapter *qdev, u32 type, u16 index,
 				   type); /* type */
 		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MR, 0);
 		if (status)
-			goto exit;
+			break;
 		*value++ = ql_read32(qdev, MAC_ADDR_DATA);
 		if (type == MAC_ADDR_TYPE_CAM_MAC) {
 			status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX,
 						 MAC_ADDR_MW, 0);
 			if (status)
-				goto exit;
+				break;
 			ql_write32(qdev, MAC_ADDR_IDX,
 				   (offset++) | /* offset */
 					   (index
@@ -301,7 +301,7 @@ int ql_get_mac_addr_reg(struct ql_adapter *qdev, u32 type, u16 index,
 			status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX,
 						 MAC_ADDR_MR, 0);
 			if (status)
-				goto exit;
+				break;
 			*value++ = ql_read32(qdev, MAC_ADDR_DATA);
 		}
 		break;
@@ -313,7 +313,6 @@ int ql_get_mac_addr_reg(struct ql_adapter *qdev, u32 type, u16 index,
 			   "Address type %d not yet supported.\n", type);
 		status = -EPERM;
 	}
-exit:
 	return status;
 }
 
-- 
2.26.2

