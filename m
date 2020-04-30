Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5238E1BEDA6
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 03:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgD3Ber (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 21:34:47 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35951 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726338AbgD3Ber (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 21:34:47 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 1D8965C0129;
        Wed, 29 Apr 2020 21:34:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 29 Apr 2020 21:34:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rylan.coffee; h=
        date:from:to:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=Ap62E9FkHJTqhnbxmGojLA3qLN5
        +5l3/L8sbJ+VpUqE=; b=X6SEIOqcJQ55Mh1dwrloTTvvNyhEaNQDD3hUTk6m77/
        ecgZlhseqjpwW72yvDxu3EhWvMBAgPnb8YVSGE71nFA/2lfLkfNeAcI7ak6OF3wr
        8mJBDYUTSKVsJGcx5VxgHSuRpJOZZFwwn7yuwZdMv0cs5/tZSVpAH5oRQWMvSvcr
        0uYPDiCEop13gRcthKd1Y8Uov2teptKsGEZyuJmwN9ZVLoF5c64iv5qE9pBF6a9m
        JRTEGNfw0LNnSPbCEQkm5ruQ8rZCnpAg+kR4O4sT8m0JoNyaBF8AUdXHyfYt/sSI
        3p0AYRgudLbGhUFGstXjC1kvYZapfCoh+/W3o0t22Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Ap62E9
        FkHJTqhnbxmGojLA3qLN5+5l3/L8sbJ+VpUqE=; b=Ny7yhuP3FwmL9hv73Xup9A
        1eEjDj4xCEIBL23F6cxxG0at2Zlh0R+IA443xgigNbe2jLIoZ7K5jj5o9OEb5pp3
        1MjaQhW1bKJDh8hX69y3dl4vRst3AO9wCWWibcyJ2S6G/97VH7lWr8rfWs93XlPa
        kdVjaQpViHEmhyMeeI6TMkIPfQEFitVlZGG3luno42ZuJdltz2IjKCqgDWCfLmlO
        EbY+hH+qPeAbtKY9J88JY4Lmzc6oHdzBI/QU25/0g5tNxBD0l3ymbSEpG6k/YGN7
        vRg/a69LrMTzZ+C9OoPtd5u4JsvkRvvUdIkoqDi/qTCxGC3ynmdXvQPV2kbMw3zw
        ==
X-ME-Sender: <xms:NSuqXiwXAqRwnfiUGH1XYR6wfhWL4EzUSxQgxI6mjWkDwBUiytUOtg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrieeggdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtjeenucfhrhhomheptfihlhgrnhcu
    ffhmvghllhhouceomhgrihhlsehrhihlrghnrdgtohhffhgvvgeqnecuggftrfgrthhtvg
    hrnhepjeffvefffeevgfdtteegudffieduveeuhfettddvueehveethfffgeetfeeghfeu
    necukfhppedutdekrdegledrudehkedrkeegnecuvehluhhsthgvrhfuihiivgepgeenuc
    frrghrrghmpehmrghilhhfrhhomhepmhgrihhlsehrhihlrghnrdgtohhffhgvvg
X-ME-Proxy: <xmx:NSuqXjhvREmYHmSMYi9Xg-hewnnN64042JLhRzWRY9kw70oLC4KOQg>
    <xmx:NSuqXmBKQ57ohuHSsTGWwserAXumEvCscXfIxlSfXHWVcFxt2qZUng>
    <xmx:NSuqXgvhQdzNOGNiLl7n-9-r6eXkuzjGovaf-CsK0JYpAnjPma2AHA>
    <xmx:NiuqXtn4l49uXxdnDj3j5zvKx1SWE8lhBPElZquY18Qw7B1rjLIDBw>
Received: from athena (pool-108-49-158-84.bstnma.fios.verizon.net [108.49.158.84])
        by mail.messagingengine.com (Postfix) with ESMTPA id A9DD43065EF9;
        Wed, 29 Apr 2020 21:34:45 -0400 (EDT)
Date:   Wed, 29 Apr 2020 21:34:44 -0400
From:   Rylan Dmello <mail@rylan.coffee>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: [PATCH v2 6/7] staging: qlge: Fix suspect code indent warning in
 ql_init_device
Message-ID: <7c07400dbce98d0c4c84aa941da8f34e32616159.1588209862.git.mail@rylan.coffee>
References: <cover.1588209862.git.mail@rylan.coffee>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1588209862.git.mail@rylan.coffee>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix checkpatch.pl warnings:

  WARNING: suspect code indent for conditional statements (16, 23)
  WARNING: line over 80 characters

Signed-off-by: Rylan Dmello <mail@rylan.coffee>
---
 drivers/staging/qlge/qlge_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 9aa62d146d97..fa708c722033 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4420,7 +4420,8 @@ static int ql_init_device(struct pci_dev *pdev, struct net_device *ndev,
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

