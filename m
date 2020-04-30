Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BC01BED9E
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 03:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgD3Bdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 21:33:33 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44109 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726309AbgD3Bdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 21:33:33 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id AC7D45C0076;
        Wed, 29 Apr 2020 21:33:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 29 Apr 2020 21:33:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rylan.coffee; h=
        date:from:to:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=866EUhhl02ATxe+Ni9RioUHWCNy
        6rpkgxyOZFwaTNlE=; b=QFuuG32pi1HbQfBaqv1y7Zu3pVeTy2ymCaJZfw5utYe
        aOJCEl8Ql4Fbe95BN+nU6u3fVcrkZ5RI7mO6Ii0cc0gzN2E3ckO6VJhux6zYNJq3
        P8oK8eCcN8qvZ4gzAx4wb40eEuW7rczH8clZwzEgZMAtTzbDedPnmTYiNYwrgta/
        oSUEdtW3rnqWmzTolc6uw3vl6Zhxzj0FFoTUJG5onnyZ2UB570iG5JC1Po8uIgYw
        N8hUYedpupGVzhK5oN4InajRoKY55oCqK3lPAxr26VJoqguLJMN12OD8s7i0HnNJ
        FiXPocf52brArdwR9dmr0/AydEZuCwHRLsI/8tW6n9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=866EUh
        hl02ATxe+Ni9RioUHWCNy6rpkgxyOZFwaTNlE=; b=yXNLZJWClVX9FUflynGRK/
        VdVrDMijK+s1HCfzLMS/S+X9mpyfAc1ydxetdssEqSmCAUc4hlIP2SX7zEHxLK3N
        0VUOrTWSN6VsG4trnSLgg5P4RxaCstRQdZBREeYeuIhr2j8eGj/ccFju3XFqe5ua
        Z9EfXciXOEtxl8w0qRVWTJMFqjmdGqy6Z82s4qY2cmHRuyTCtyyHQQFr7HUqBq03
        Kh4IrcipIyHK5js48i/U/QxlB16A3wW0kCVwmhQC2b2Af60Wrxu1i1ZN95SxRsjI
        LP64sCIOtJrJg+a4uF4zXeStb9YatRSXiJF4MC/NeS2fjLVSjwI0M47ABUvs9XYw
        ==
X-ME-Sender: <xms:6iqqXkE9jxlsPfAJcxqA2l5DKPlNhWGx5JCyh2aXXEsiyqaejMd_3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrieeggdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtjeenucfhrhhomheptfihlhgrnhcu
    ffhmvghllhhouceomhgrihhlsehrhihlrghnrdgtohhffhgvvgeqnecuggftrfgrthhtvg
    hrnhepjeffvefffeevgfdtteegudffieduveeuhfettddvueehveethfffgeetfeeghfeu
    necukfhppedutdekrdegledrudehkedrkeegnecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepmhgrihhlsehrhihlrghnrdgtohhffhgvvg
X-ME-Proxy: <xmx:6iqqXpBRPgT33q-QiD9au0si5H8gSMxYsLH244JT7r45bL9til5LDQ>
    <xmx:6iqqXlASAqkBz0Jd7mAHOEkgW8rmvQUh9cDIDOY7G3pjK4xv7oqV1g>
    <xmx:6iqqXq5sAmKk_bT-0STQDnUSnIv-cqhoJxtNL7juHIwirh7_AQO9Uw>
    <xmx:6iqqXkuewziOdeVWVnLm0WsksT816gOd8V_pZrXMhOx2afH-5iSfpg>
Received: from athena (pool-108-49-158-84.bstnma.fios.verizon.net [108.49.158.84])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6238D3280066;
        Wed, 29 Apr 2020 21:33:30 -0400 (EDT)
Date:   Wed, 29 Apr 2020 21:33:29 -0400
From:   Rylan Dmello <mail@rylan.coffee>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: [PATCH v2 3/7] staging: qlge: Fix indentation in ql_get_mac_addr_reg
Message-ID: <b51f21b20514dc5197266a5a52d31c7b85f16741.1588209862.git.mail@rylan.coffee>
References: <cover.1588209862.git.mail@rylan.coffee>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1588209862.git.mail@rylan.coffee>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This has similar indentation style issues as ql_set_mac_addr_reg, so I
thought I'd re-indent this too.

Fix several checkpatch.pl warnings:

  WARNING: line over 80 characters

Signed-off-by: Rylan Dmello <mail@rylan.coffee>
---
 drivers/staging/qlge/qlge_main.c | 76 ++++++++++++++++----------------
 1 file changed, 37 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index f2b4a54fc4c0..844c2c6df38d 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -262,52 +262,50 @@ int ql_get_mac_addr_reg(struct ql_adapter *qdev, u32 type, u16 index,
 
 	switch (type) {
 	case MAC_ADDR_TYPE_MULTI_MAC:
-	case MAC_ADDR_TYPE_CAM_MAC:
-		{
-			status =
-			    ql_wait_reg_rdy(qdev,
-					    MAC_ADDR_IDX, MAC_ADDR_MW, 0);
-			if (status)
-				goto exit;
-			ql_write32(qdev, MAC_ADDR_IDX, (offset++) | /* offset */
+	case MAC_ADDR_TYPE_CAM_MAC: {
+		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+		if (status)
+			goto exit;
+		ql_write32(qdev, MAC_ADDR_IDX,
+			   (offset++) | /* offset */
 				   (index << MAC_ADDR_IDX_SHIFT) | /* index */
-				   MAC_ADDR_ADR | MAC_ADDR_RS | type); /* type */
-			status =
-			    ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MR, 0);
-			if (status)
-				goto exit;
-			*value++ = ql_read32(qdev, MAC_ADDR_DATA);
-			status =
-			    ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+				   MAC_ADDR_ADR | MAC_ADDR_RS |
+				   type); /* type */
+		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MR, 0);
+		if (status)
+			goto exit;
+		*value++ = ql_read32(qdev, MAC_ADDR_DATA);
+		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+		if (status)
+			goto exit;
+		ql_write32(qdev, MAC_ADDR_IDX,
+			   (offset++) | /* offset */
+				   (index << MAC_ADDR_IDX_SHIFT) | /* index */
+				   MAC_ADDR_ADR | MAC_ADDR_RS |
+				   type); /* type */
+		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MR, 0);
+		if (status)
+			goto exit;
+		*value++ = ql_read32(qdev, MAC_ADDR_DATA);
+		if (type == MAC_ADDR_TYPE_CAM_MAC) {
+			status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX,
+						 MAC_ADDR_MW, 0);
 			if (status)
 				goto exit;
-			ql_write32(qdev, MAC_ADDR_IDX, (offset++) | /* offset */
-				   (index << MAC_ADDR_IDX_SHIFT) | /* index */
-				   MAC_ADDR_ADR | MAC_ADDR_RS | type); /* type */
-			status =
-			    ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MR, 0);
+			ql_write32(qdev, MAC_ADDR_IDX,
+				   (offset++) | /* offset */
+					   (index
+					    << MAC_ADDR_IDX_SHIFT) | /* index */
+					   MAC_ADDR_ADR |
+					   MAC_ADDR_RS | type); /* type */
+			status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX,
+						 MAC_ADDR_MR, 0);
 			if (status)
 				goto exit;
 			*value++ = ql_read32(qdev, MAC_ADDR_DATA);
-			if (type == MAC_ADDR_TYPE_CAM_MAC) {
-				status =
-				    ql_wait_reg_rdy(qdev,
-						    MAC_ADDR_IDX, MAC_ADDR_MW,
-						    0);
-				if (status)
-					goto exit;
-				ql_write32(qdev, MAC_ADDR_IDX, (offset++) | /* offset */
-					   (index << MAC_ADDR_IDX_SHIFT) | /* index */
-					   MAC_ADDR_ADR | MAC_ADDR_RS | type); /* type */
-				status =
-				    ql_wait_reg_rdy(qdev, MAC_ADDR_IDX,
-						    MAC_ADDR_MR, 0);
-				if (status)
-					goto exit;
-				*value++ = ql_read32(qdev, MAC_ADDR_DATA);
-			}
-			break;
 		}
+		break;
+	}
 	case MAC_ADDR_TYPE_VLAN:
 	case MAC_ADDR_TYPE_MULTI_FLTR:
 	default:
-- 
2.26.2

