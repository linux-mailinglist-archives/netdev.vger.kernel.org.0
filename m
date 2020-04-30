Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80CAC1BED97
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 03:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgD3BcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 21:32:18 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52573 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726291AbgD3BcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 21:32:17 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 3BC845C00A0;
        Wed, 29 Apr 2020 21:32:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 29 Apr 2020 21:32:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rylan.coffee; h=
        date:from:to:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=xz3mRUUiSRTWNRhEtbEIScUIML6
        Spu5Ed03IWtKwZRY=; b=myWsFO+wg0rdCf7su944CazFOf2uERYU/WAtJ2Kmo3f
        Jo/qM4yFz1QWvUk8tvl5jYxkBFBiJbnQQxgefxDePVGHvo00EuyHBQlEaaVVqxKS
        Uqpj7cfW0G29vutCupxjspEvVlkcdRmVgYecw3AfHUUUBKvdKmmDqvE0Ijzhte3c
        j6Z6z5EqxeE9/wZyip4KAT/AFyWtghTcDNjF3dsNDB/FfdvQ9UQUmvOhHUJZuRUV
        sU3/y6BE4Nl24XzRwHTI+fOQYC5+gtvFHzUGRWWauKl1dn0T5XlNlzz4EfjKGjHA
        n5t/KSr3ZS3TzhEmVhEIBar99roiTIjdect6WoHB9Yw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xz3mRU
        UiSRTWNRhEtbEIScUIML6Spu5Ed03IWtKwZRY=; b=sxDoiZxjB5Q+QW0lWdM3Cz
        6cqQnguc5yxaAqdg8R3JGyCeVq+/YjjpFcIm06QL5jo9IJURTOIfwe4l0UWaGamB
        f1cEPR/USI6XEvVsFus9PnwHe8ekNICptu8GrF54ZvUmZj8wnief846wY2EEXqHD
        GFkMEwNPZNz8rw0YA+5Ejy1NXBMialQ+Rh7Cx/Gf9YJKXX6ul8sLfdVBKeKC0MWL
        YBewX8KlG1kmYvmp85hlxJ7ybMdgp12T6A6gcOhC/0ddYNx697CmdL81+ROu0bKb
        VNN/2UczrG1I9x4uwy3aaQkpMKV/OuI2Uf5uk4oinHxsyJOUsWOCxSMF68bsAIkQ
        ==
X-ME-Sender: <xms:oCqqXmhK1vMYVHHcUskyYxb4dNugtfKPE8nm_tjdPK5cUAayylbzJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrieeggdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtjeenucfhrhhomheptfihlhgrnhcu
    ffhmvghllhhouceomhgrihhlsehrhihlrghnrdgtohhffhgvvgeqnecuggftrfgrthhtvg
    hrnhepjeffvefffeevgfdtteegudffieduveeuhfettddvueehveethfffgeetfeeghfeu
    necukfhppedutdekrdegledrudehkedrkeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepmhgrihhlsehrhihlrghnrdgtohhffhgvvg
X-ME-Proxy: <xmx:oCqqXmVMIELrf2kwDaZsmKEgTwVYssnNjdbxaGgweP2Q6bMLG7FoJQ>
    <xmx:oCqqXlD_x2P0hFuzPOx2Xyx7B7ToSgSqavXdh5jQATz5inQmfzR04A>
    <xmx:oCqqXqla7gi-eXFhwVS9-IAnDYemY9ufAbE1dXy-BoiBleL4hPf4Uw>
    <xmx:oCqqXlCzk91rK8i4cjQ5t2m8KxFaSBta68ECuQgF87D4Ft1GmlNcgw>
Received: from athena (pool-108-49-158-84.bstnma.fios.verizon.net [108.49.158.84])
        by mail.messagingengine.com (Postfix) with ESMTPA id CA3DD3280068;
        Wed, 29 Apr 2020 21:32:15 -0400 (EDT)
Date:   Wed, 29 Apr 2020 21:32:15 -0400
From:   Rylan Dmello <mail@rylan.coffee>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: [PATCH v2 1/7] staging: qlge: Fix indentation in ql_set_mac_addr_reg
Message-ID: <299f2cb3b7d4efa30b44d4d1defbcd5f54bd7eaf.1588209862.git.mail@rylan.coffee>
References: <cover.1588209862.git.mail@rylan.coffee>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1588209862.git.mail@rylan.coffee>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on Joe Perches' feedback, fix the indentation throughout
ql_set_mac_addr_reg. This helps fix several "line over 80 characters"
warnings along with the original "multiple line dereference" warning.

Fix checkpatch.pl warnings:

  WARNING: Avoid multiple line dereference - prefer 'qdev->func'
  WARNING: line over 80 characters

Signed-off-by: Rylan Dmello <mail@rylan.coffee>
---
 drivers/staging/qlge/qlge_main.c | 167 +++++++++++++++----------------
 1 file changed, 78 insertions(+), 89 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index d7e4dfafc1a3..29610618c7c0 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -329,100 +329,89 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
 	int status = 0;
 
 	switch (type) {
-	case MAC_ADDR_TYPE_MULTI_MAC:
-		{
-			u32 upper = (addr[0] << 8) | addr[1];
-			u32 lower = (addr[2] << 24) | (addr[3] << 16) |
-					(addr[4] << 8) | (addr[5]);
+	case MAC_ADDR_TYPE_MULTI_MAC: {
+		u32 upper = (addr[0] << 8) | addr[1];
+		u32 lower = (addr[2] << 24) | (addr[3] << 16) | (addr[4] << 8) |
+			    (addr[5]);
 
-			status =
-				ql_wait_reg_rdy(qdev,
-						MAC_ADDR_IDX, MAC_ADDR_MW, 0);
-			if (status)
-				goto exit;
-			ql_write32(qdev, MAC_ADDR_IDX, (offset++) |
-				(index << MAC_ADDR_IDX_SHIFT) |
-				type | MAC_ADDR_E);
-			ql_write32(qdev, MAC_ADDR_DATA, lower);
-			status =
-				ql_wait_reg_rdy(qdev,
-						MAC_ADDR_IDX, MAC_ADDR_MW, 0);
-			if (status)
-				goto exit;
-			ql_write32(qdev, MAC_ADDR_IDX, (offset++) |
-				(index << MAC_ADDR_IDX_SHIFT) |
-				type | MAC_ADDR_E);
+		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+		if (status)
+			goto exit;
+		ql_write32(qdev, MAC_ADDR_IDX,
+			   (offset++) | (index << MAC_ADDR_IDX_SHIFT) | type |
+				   MAC_ADDR_E);
+		ql_write32(qdev, MAC_ADDR_DATA, lower);
+		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+		if (status)
+			goto exit;
+		ql_write32(qdev, MAC_ADDR_IDX,
+			   (offset++) | (index << MAC_ADDR_IDX_SHIFT) | type |
+				   MAC_ADDR_E);
 
-			ql_write32(qdev, MAC_ADDR_DATA, upper);
-			status =
-				ql_wait_reg_rdy(qdev,
-						MAC_ADDR_IDX, MAC_ADDR_MW, 0);
-			if (status)
-				goto exit;
-			break;
-		}
-	case MAC_ADDR_TYPE_CAM_MAC:
-		{
-			u32 cam_output;
-			u32 upper = (addr[0] << 8) | addr[1];
-			u32 lower =
-			    (addr[2] << 24) | (addr[3] << 16) | (addr[4] << 8) |
+		ql_write32(qdev, MAC_ADDR_DATA, upper);
+		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+		if (status)
+			goto exit;
+		break;
+	}
+	case MAC_ADDR_TYPE_CAM_MAC: {
+		u32 cam_output;
+		u32 upper = (addr[0] << 8) | addr[1];
+		u32 lower = (addr[2] << 24) | (addr[3] << 16) | (addr[4] << 8) |
 			    (addr[5]);
-			status =
-			    ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
-			if (status)
-				goto exit;
-			ql_write32(qdev, MAC_ADDR_IDX, (offset++) | /* offset */
+		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+		if (status)
+			goto exit;
+		ql_write32(qdev, MAC_ADDR_IDX,
+			   (offset++) | /* offset */
 				   (index << MAC_ADDR_IDX_SHIFT) | /* index */
-				   type);	/* type */
-			ql_write32(qdev, MAC_ADDR_DATA, lower);
-			status =
-			    ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
-			if (status)
-				goto exit;
-			ql_write32(qdev, MAC_ADDR_IDX, (offset++) | /* offset */
+				   type); /* type */
+		ql_write32(qdev, MAC_ADDR_DATA, lower);
+		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+		if (status)
+			goto exit;
+		ql_write32(qdev, MAC_ADDR_IDX,
+			   (offset++) | /* offset */
 				   (index << MAC_ADDR_IDX_SHIFT) | /* index */
-				   type);	/* type */
-			ql_write32(qdev, MAC_ADDR_DATA, upper);
-			status =
-			    ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
-			if (status)
-				goto exit;
-			ql_write32(qdev, MAC_ADDR_IDX, (offset) |	/* offset */
-				   (index << MAC_ADDR_IDX_SHIFT) |	/* index */
-				   type);	/* type */
-			/* This field should also include the queue id
-			 * and possibly the function id.  Right now we hardcode
-			 * the route field to NIC core.
-			 */
-			cam_output = (CAM_OUT_ROUTE_NIC |
-				      (qdev->
-				       func << CAM_OUT_FUNC_SHIFT) |
-					(0 << CAM_OUT_CQ_ID_SHIFT));
-			if (qdev->ndev->features & NETIF_F_HW_VLAN_CTAG_RX)
-				cam_output |= CAM_OUT_RV;
-			/* route to NIC core */
-			ql_write32(qdev, MAC_ADDR_DATA, cam_output);
-			break;
-		}
-	case MAC_ADDR_TYPE_VLAN:
-		{
-			u32 enable_bit = *((u32 *) &addr[0]);
-			/* For VLAN, the addr actually holds a bit that
-			 * either enables or disables the vlan id we are
-			 * addressing. It's either MAC_ADDR_E on or off.
-			 * That's bit-27 we're talking about.
-			 */
-			status =
-			    ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
-			if (status)
-				goto exit;
-			ql_write32(qdev, MAC_ADDR_IDX, offset |	/* offset */
-				   (index << MAC_ADDR_IDX_SHIFT) |	/* index */
-				   type |	/* type */
-				   enable_bit);	/* enable/disable */
-			break;
-		}
+				   type); /* type */
+		ql_write32(qdev, MAC_ADDR_DATA, upper);
+		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+		if (status)
+			goto exit;
+		ql_write32(qdev, MAC_ADDR_IDX,
+			   (offset) | /* offset */
+				   (index << MAC_ADDR_IDX_SHIFT) | /* index */
+				   type); /* type */
+		/* This field should also include the queue id
+		 * and possibly the function id.  Right now we hardcode
+		 * the route field to NIC core.
+		 */
+		cam_output = (CAM_OUT_ROUTE_NIC |
+			      (qdev->func << CAM_OUT_FUNC_SHIFT) |
+			      (0 << CAM_OUT_CQ_ID_SHIFT));
+		if (qdev->ndev->features & NETIF_F_HW_VLAN_CTAG_RX)
+			cam_output |= CAM_OUT_RV;
+		/* route to NIC core */
+		ql_write32(qdev, MAC_ADDR_DATA, cam_output);
+		break;
+	}
+	case MAC_ADDR_TYPE_VLAN: {
+		u32 enable_bit = *((u32 *)&addr[0]);
+		/* For VLAN, the addr actually holds a bit that
+		 * either enables or disables the vlan id we are
+		 * addressing. It's either MAC_ADDR_E on or off.
+		 * That's bit-27 we're talking about.
+		 */
+		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+		if (status)
+			goto exit;
+		ql_write32(qdev, MAC_ADDR_IDX,
+			   offset | /* offset */
+				   (index << MAC_ADDR_IDX_SHIFT) | /* index */
+				   type | /* type */
+				   enable_bit); /* enable/disable */
+		break;
+	}
 	case MAC_ADDR_TYPE_MULTI_FLTR:
 	default:
 		netif_crit(qdev, ifup, qdev->ndev,
-- 
2.26.2

