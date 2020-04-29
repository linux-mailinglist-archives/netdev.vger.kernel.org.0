Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247B81BD360
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 06:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgD2EEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 00:04:33 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49545 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726669AbgD2EEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 00:04:33 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id EF0225C0392;
        Wed, 29 Apr 2020 00:04:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 29 Apr 2020 00:04:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rylan.coffee; h=
        date:from:to:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=kHapGOq7KW9N0TnNYVQtbnV2HjZ
        ViclYwhrcnJjGpMI=; b=sutUTfGmDne65YZdufylKbT2c227tir34T9o7CYcVv4
        LpOIfWRVb+AKWaHupdBrwT7etOVqI3e5VKFMloBva1u+mv1T21gGs1iLFWWSSgBg
        b50C6vewk8ITYLWn/OfVP3u+oEb/53qjEO878G9H/x+s60LxQb8rbthqN1l7U92k
        uf7ue/OxvUN4PKFSFzDcMDvMd5CNXvvX+yspXexbybrWJaree3DhTV+Am3J4s810
        uGRnwh+FGubotj6B8IvmGpEGbRMFAzM28p/KcEtiLraCSh1M5M2eKMCltDyF/wXB
        BXv9dWyVHHc8RlGtaiTE9z/Mhtja1DxI0lNNPFZ9owQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=kHapGO
        q7KW9N0TnNYVQtbnV2HjZViclYwhrcnJjGpMI=; b=PJL9cRdRAbs0EtJuJEMIBR
        zBMtwIjdCf6ATsPA8IYlDLufn80ApaB9WoLe68z0SrrGnD0Z5SIcgd725kFYnqGL
        e6Ic4iLslGgAprLUp5N7kW6Kpcjub3JNijWpnSCOp8lAsDrRW54Yu+PR60dFTxLD
        hO5veoquEujwsI0clIl/SO/wb+G//oLPj57nxDqEGA6c4XDse0B8e7sALy0Uh9ly
        RZkzVIQvXUG+INp8pbHfX5u7LssnRcjGsdm5nnyNcSgWjUgrbYPOTz5jVlqO2HvI
        x5yd4iFm3e2n27psxuYl1MRpBwBJFhT5sZPF4v5O80Z1B8Wlsnr+vEv6nKKqCxoA
        ==
X-ME-Sender: <xms:z_yoXjnaYOXgBVdRN1zmXOgsplegzSEQFnbQK0Fpln0nGXMbH0BY6w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedriedvgdejjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtjeenucfhrhhomheptfihlhgrnhcu
    ffhmvghllhhouceomhgrihhlsehrhihlrghnrdgtohhffhgvvgeqnecukfhppedutdekrd
    egledrudehkedrkeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepmhgrihhlsehrhihlrghnrdgtohhffhgvvg
X-ME-Proxy: <xmx:z_yoXvcequtGXlXDDlFQNa22qccYJZo_tEnfUbr62i0OtA1KP34uPA>
    <xmx:z_yoXuHuNgfne2PE1fMsIdaUDgQP4bJRRBRlyFiE71mZqLVGiMR08w>
    <xmx:z_yoXvEGPVcc7UGHTqcwhhAL6Ca6Aq8mS1jnUb5YqZYdJ4gFxcsFjw>
    <xmx:z_yoXpSm3SczGgIgXFz5NRcbk1sIys5lFE5kAfhEkpIzPrmJAKV0sg>
Received: from athena (pool-108-49-158-84.bstnma.fios.verizon.net [108.49.158.84])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8DB603065EDF;
        Wed, 29 Apr 2020 00:04:31 -0400 (EDT)
Date:   Wed, 29 Apr 2020 00:04:30 -0400
From:   Rylan Dmello <mail@rylan.coffee>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] staging: qlge: Fix suspect indentation warning in
 qlge_main.c
Message-ID: <eafcda7509c7904fc1624833c69cca349156d555.1588132908.git.mail@rylan.coffee>
References: <aae9feb569c60758ab09c923c09b600295f4cb32.1588132908.git.mail@rylan.coffee>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aae9feb569c60758ab09c923c09b600295f4cb32.1588132908.git.mail@rylan.coffee>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix checkpatch.pl warning:

  WARNING: suspect code indent for conditional statements (16, 23)

Signed-off-by: Rylan Dmello <mail@rylan.coffee>
---
 drivers/staging/qlge/qlge_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 10daae025790..0edeea525fef 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4436,7 +4436,8 @@ static int ql_init_device(struct pci_dev *pdev, struct net_device *ndev,
 	} else {
 		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 		if (!err)
-		       err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+			err = dma_set_coherent_mask(&pdev->dev,
+						    DMA_BIT_MASK(32));
 	}
 
 	if (err) {
-- 
2.26.2

