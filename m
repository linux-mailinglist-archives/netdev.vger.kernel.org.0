Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C0164AC98
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 01:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbiLMAsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 19:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiLMAsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 19:48:01 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1EA2291;
        Mon, 12 Dec 2022 16:47:59 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8A4425C0167;
        Mon, 12 Dec 2022 19:47:56 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 12 Dec 2022 19:47:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pjd.dev; h=cc:cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1670892476; x=1670978876; bh=b/6U3Dsyg/OAcTxM7FPRAqkwl
        KpPSObmH5aoZ/TKCSA=; b=SP1iddR05wcYU3fqLMeztGxYBEElhSNOud4h49Xx0
        DngHBJ+32WY14wRUNMA6h/sMipPu+TFJEU3aLyY+O+F5pRtft4T147fVGJQP2ztK
        e5kQ4hHd5CcW+aL8OqYJDx+2rfl4QKp3XuuJy3PG7gHb2OHjBH9kWvlatt0P8A6/
        9CKUy6icKwsbMEiEQg62r5QseXWY5b+I9U+ZJ+Zw1kIKZBDhuew+0SD6jCBTEEgR
        V6sIahJNEmadWo1tfmhtmfHW7hT96HdM/xMQYVrsVS3QL2UZTN5UPzCOtVDwqUI5
        5vnfu0GDs/jdQiv2YbT5KwK13rRMuL1F7tga+PM4BK0gg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1670892476; x=1670978876; bh=b/6U3Dsyg/OAcTxM7FPRAqkwlKpPSObmH5a
        oZ/TKCSA=; b=XriSMC0URg6AyIdk38qrITSp9/NhY60KNflAgnb+gMaDVIFWgi0
        NEBfBdV4VDVMCMqMGylhQBY6g9R5C3ZropXi/isW7hcGNEWvXyIJ3A+g21lxyT6Q
        IuxtCwQj7ecERVFDGPRvT1rKPJPxAMi9nOnxO7t1BaMMqHVfNMyOfkhIArOwiKCN
        ET15S/a6UvqH+VPkFZJPw2lAMWXFxtjaCwBCJuCO1scUDFDhhh35kcDz6UxTocvA
        0W214HqzhwmqhvPQD5kfds33ZwJ2jegPLCaZPhvKBbo4VBZOAn9BvsMdBDwzHnBY
        NPW3jS4nbHJgVlJM6JMZvvdp1gz/tlOsqSQ==
X-ME-Sender: <xms:vMuXY26v_zwZN74j0lN-mQp8FHuYzSYYKDSV0xperwR-iOvPZxXsgQ>
    <xme:vMuXY_6h2BUPXGz2XgHUgO-SrK3l2WTxqvdVyZic0VNL5uCsMTSPhUCI7skIdHP9T
    DuIwd1kP7ZBqB-dSpg>
X-ME-Received: <xmr:vMuXY1eFT4BG121lIG-G8FEKsb8BG8TH2ThV0YGzfPPJJ3nOMLCGas-BpNAcwkbZopRsgD6Yc4M1oeemgg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdelgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecuogfuuhhsphgvtghtffhomhgrihhnucdlgeelmdenmh
    hishhsihhnghcuvffquchfihgvlhguucdlfedtmdenogetfedtuddqtdduucdludehmden
    ucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefrvghtvghruc
    ffvghlvghvohhrhigrshcuoehpvghtvghrsehpjhgurdguvghvqeenucggtffrrghtthgv
    rhhnpeegveeivdefgedvteevvdeugfeuffeuhfelueffgfdvtedugfetvdegkeekledutd
    enucffohhmrghinhepthhinhihuhhrlhdrtghomhenucevlhhushhtvghrufhiiigvpedt
    necurfgrrhgrmhepmhgrihhlfhhrohhmpehpvghtvghrsehpjhgurdguvghv
X-ME-Proxy: <xmx:vMuXYzJcv7aKq3gXC_mT1Hc685oLVVxXWk0u75TZJk_ZJBEjjG6KJw>
    <xmx:vMuXY6LxqlJv_Z2FJ6PcZLHnR1S4X-xQziFTabNL8TaMbgtVtC11sA>
    <xmx:vMuXY0wKH4bvP0g9SrSC0p1YPWFvX4oQ5li7l6oQifPiLQYbUG33zw>
    <xmx:vMuXYy_Mj-VcjlS0noNz950RJWNwp_o9F-jEFVxM581_2ee49wWu1w>
Feedback-ID: i9e814621:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 12 Dec 2022 19:47:55 -0500 (EST)
From:   Peter Delevoryas <peter@pjd.dev>
Cc:     peter@pjd.dev, sam@mendozajonas.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/ncsi: Always use unicast source MAC address
Date:   Mon, 12 Dec 2022 16:47:54 -0800
Message-Id: <20221213004754.2633429-1-peter@pjd.dev>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I use QEMU for development, and I noticed that NC-SI packets get dropped by
the Linux software bridge[1] because we use a broadcast source MAC address
for the first few NC-SI packets.

The spec requires that the destination MAC address is FF:FF:FF:FF:FF:FF,
but it doesn't require anything about the source MAC address as far as I
know. From testing on a few different NC-SI NIC's (Broadcom 57502, Nvidia
CX4, CX6) I don't think it matters to the network card. I mean, Meta has
been using this in mass production with millions of BMC's [2].

In general, I think it's probably just a good idea to use a unicast MAC.

This might have the effect of causing the NIC to learn 2 MAC addresses from
an NC-SI link if the BMC uses OEM Get MAC Address commands to change its
initial MAC address, but it shouldn't really matter. Who knows if NIC's
even have MAC learning enabled from the out-of-band BMC link, lol.

[1]: https://tinyurl.com/4933mhaj
[2]: https://tinyurl.com/mr3tyadb

Signed-off-by: Peter Delevoryas <peter@pjd.dev>
---
 net/ncsi/ncsi-cmd.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
index dda8b76b7798..fd090156cf0d 100644
--- a/net/ncsi/ncsi-cmd.c
+++ b/net/ncsi/ncsi-cmd.c
@@ -377,15 +377,7 @@ int ncsi_xmit_cmd(struct ncsi_cmd_arg *nca)
 	eh = skb_push(nr->cmd, sizeof(*eh));
 	eh->h_proto = htons(ETH_P_NCSI);
 	eth_broadcast_addr(eh->h_dest);
-
-	/* If mac address received from device then use it for
-	 * source address as unicast address else use broadcast
-	 * address as source address
-	 */
-	if (nca->ndp->gma_flag == 1)
-		memcpy(eh->h_source, nca->ndp->ndev.dev->dev_addr, ETH_ALEN);
-	else
-		eth_broadcast_addr(eh->h_source);
+	memcpy(eh->h_source, nca->ndp->ndev.dev->dev_addr, ETH_ALEN);
 
 	/* Start the timer for the request that might not have
 	 * corresponding response. Given NCSI is an internal
-- 
2.30.2

