Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7BC1BEDAA
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 03:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgD3BfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 21:35:18 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38471 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726337AbgD3BfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 21:35:17 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 52EC15C012E;
        Wed, 29 Apr 2020 21:35:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 29 Apr 2020 21:35:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rylan.coffee; h=
        date:from:to:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=XX5ohvsksBkQGH5jbDa4t+EQwah
        gIjz54VbrjjxbWJY=; b=r9gRGvtScYbH5in9aalUzwkJr/sKf1BncihRT0mNAHT
        gaEJ3V12kbplqnc+7COsqikx8Qv0X6Hb+uXMW6LTWbU23tsA9F7yL0LBbjsHVyMy
        ToewGhdtZop2zlTSBYaQjCRP5k73Q/DhMFpJur5XzAc6enZQTeuhn3ZVxMm/QNw6
        bFaBmTpwdK0ToGK4rc7LtSw4Wpwsni7jOhumeAKL7jAkM2n0zItJnqHnThZlvfbU
        iTScQhVqBoewR+8H72MvcsC76aAxjsjMrnwy5ktVdNSEsOtrVZL8mvJpQ+XBrmuK
        jR6Qsru3JDh7wwuTBaRTc696q4PoTYg3Iy47ij7Yabw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=XX5ohv
        sksBkQGH5jbDa4t+EQwahgIjz54VbrjjxbWJY=; b=4WJhQ8eXa13H7Byw6ikUXH
        D1RpSw38kXM2q26mmlPBLIzDw5h9iT3O5x7rylGnlA5Glcr+86JQWRVYDTjVwQK0
        HGM+KWdfD2nfPx8lJfl4JqzD1KRv6AvGOb8VS7o4ZFQ+sMkkkyp9duX/jjmIdLZ8
        xTzMQC71FGqnUPNomsK+7nwIbH87yaYh/dUVwBg6l4IusE5aDEVYPHIuPD0RAr3+
        oxmBuBXajzJTLUWEtE9+Isj7TBdPyz7gs33EZaL4jdPZCL5TiYeCdYLdnXlGm9el
        i1K2m6jUkBe1aJ577hlRGr1bLhp1S5kmH44JqR6/rPyUG3hmRAfKnvlMZ111HX+g
        ==
X-ME-Sender: <xms:VCuqXtY90SDK0St5lHn7_oAvpZhxHLArDg0rGLNkVSW-ThNal22prg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrieeggdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtjeenucfhrhhomheptfihlhgrnhcu
    ffhmvghllhhouceomhgrihhlsehrhihlrghnrdgtohhffhgvvgeqnecuggftrfgrthhtvg
    hrnhepjeffvefffeevgfdtteegudffieduveeuhfettddvueehveethfffgeetfeeghfeu
    necukfhppedutdekrdegledrudehkedrkeegnecuvehluhhsthgvrhfuihiivgepheenuc
    frrghrrghmpehmrghilhhfrhhomhepmhgrihhlsehrhihlrghnrdgtohhffhgvvg
X-ME-Proxy: <xmx:VCuqXtvEoL6it9M_qxN7xt5qz1FIcJKZ8lQAoe13oY32aMyHgmk6bQ>
    <xmx:VCuqXuvdsW2Mc_1fzxFvmOhnNEESF9IDLyh6C2iRLUAFymfxutwe_w>
    <xmx:VCuqXmrvnd5C4B4FY99qPLAk02TUEFVeh7RPxWPO2YA2T8WvbFN1LQ>
    <xmx:VCuqXmrakKYuK6fgDUbYgSaPYo_OOZOr3Wm-hN5nIkC5xHdT_kPuGw>
Received: from athena (pool-108-49-158-84.bstnma.fios.verizon.net [108.49.158.84])
        by mail.messagingengine.com (Postfix) with ESMTPA id E66533065EFE;
        Wed, 29 Apr 2020 21:35:15 -0400 (EDT)
Date:   Wed, 29 Apr 2020 21:35:15 -0400
From:   Rylan Dmello <mail@rylan.coffee>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: [PATCH v2 7/7] staging: qlge: Fix function argument alignment
 warning in ql_init_device
Message-ID: <12c7c34330b410e4ee8b9b5634f1a50ceb9c3590.1588209862.git.mail@rylan.coffee>
References: <cover.1588209862.git.mail@rylan.coffee>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1588209862.git.mail@rylan.coffee>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix checkpatch.pl check:

  CHECK: Alignment should match open parenthesis

Signed-off-by: Rylan Dmello <mail@rylan.coffee>
---
 drivers/staging/qlge/qlge_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index fa708c722033..93df4f79b21d 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4433,8 +4433,7 @@ static int ql_init_device(struct pci_dev *pdev, struct net_device *ndev,
 	pdev->needs_freset = 1;
 	pci_save_state(pdev);
 	qdev->reg_base =
-	    ioremap(pci_resource_start(pdev, 1),
-			    pci_resource_len(pdev, 1));
+		ioremap(pci_resource_start(pdev, 1), pci_resource_len(pdev, 1));
 	if (!qdev->reg_base) {
 		dev_err(&pdev->dev, "Register mapping failed.\n");
 		err = -ENOMEM;
@@ -4443,8 +4442,7 @@ static int ql_init_device(struct pci_dev *pdev, struct net_device *ndev,
 
 	qdev->doorbell_area_size = pci_resource_len(pdev, 3);
 	qdev->doorbell_area =
-	    ioremap(pci_resource_start(pdev, 3),
-			    pci_resource_len(pdev, 3));
+		ioremap(pci_resource_start(pdev, 3), pci_resource_len(pdev, 3));
 	if (!qdev->doorbell_area) {
 		dev_err(&pdev->dev, "Doorbell register mapping failed.\n");
 		err = -ENOMEM;
-- 
2.26.2

