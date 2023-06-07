Return-Path: <netdev+bounces-8696-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 266E87253C9
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:00:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 882A21C20C93
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 06:00:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12BDB3FEC;
	Wed,  7 Jun 2023 06:00:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078991845
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 06:00:06 +0000 (UTC)
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5BA19BB;
	Tue,  6 Jun 2023 23:00:03 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.west.internal (Postfix) with ESMTP id F08FF32009B8;
	Wed,  7 Jun 2023 02:00:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 07 Jun 2023 02:00:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to; s=fm2; t=1686117601; x=1686204001; bh=fl3ejIANYM
	wphGOpTaZIWtY9rHRJ/IGNetQKrBgr9cI=; b=IyaG89PQugO1w2NUuNNIszSOT0
	L716qr1iWi+QMiWveShe1Qc7pCMmiqD6O20Ig3Xwvun2ugVtPkZM1S4zxVoKp47Z
	ev+maMM3Y0VvQr9jUopk7EsGyHgUopTEQjbcIc0Obt7DuK+nYzgtt+WBKaz8xnvu
	yUqUf+YMU2nn+TSmRuwt1C64UdRdXkCr7czIbCwaT/JhZ5k5KKuCycXqzA1413Zc
	DcXXly1gaNeE57eE08HnO3D2lg5ARKcW0BfGX4vO4Xxpa77DpJPbvy6M3nHWvSOw
	SuUWxldpZXTej11yE7hfEZ7tEQFOCb6xJX21aoVbCfrtjyX6FYfYUxCRJhvg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1686117601; x=1686204001; bh=fl3ejIANYMwph
	GOpTaZIWtY9rHRJ/IGNetQKrBgr9cI=; b=yV0kxtIOLFKuF9M2FpWfZhQVJar6P
	tsGGJtj/BM0EBn9edXczKmhj9eMY95TFfHdAMWXzOfIM3qJFcP2f+avg8jfvuH2q
	luD5CkPZ9svTqtgg3dDKOytfT3xWfI12HEWB65Gb6zaWNmtJ6iX1gxkkVoe0AGYQ
	zjXQGJ8tIrppfciVl5cchHTi33TcyuA5uyI078paz9NGeU15Ta+HJjFmDNPS5/Zv
	/G3dgyDh2mpYq6AbNATYyVCrPL7bSUDr2mlcsjmxc0ZNqYe07HnpGSQ2E90NnjHw
	1vWzTl2X3RHWg6czPoaaYpHY4yqjGRPURsJZdiRECb6VKRwb9ePAPJ+5A==
X-ME-Sender: <xms:4RyAZOU0pt5TFGXonQfqLoF-fhrZfgrIKX6o3aylfSAj5I_UGyTcew>
    <xme:4RyAZKlfXME8SnIXar6euZ1b2TgzpXulR6nxcCdbC_tEj1utwZTPsjxWZhRrJrs2M
    dASTVf2FOhi3O6dGcw>
X-ME-Received: <xmr:4RyAZCbpcgfCmR9Hh6xC8p_iq0O4Ggs0YNA5zntY5ZXNBd7YIxuW3QgnVJx84qO5rzOieBUmfzMvrMwLY8s>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedtfedgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeflihgrgihunhcujggrnhhguceojhhirgiguhhnrdihrghnghes
    fhhlhihgohgrthdrtghomheqnecuggftrfgrthhtvghrnhephfetuddtudevieeljeejte
    ffheeujeduhefgffejudfhueelleduffefgfffveeknecuvehluhhsthgvrhfuihiivgep
    tdenucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgoh
    grthdrtghomh
X-ME-Proxy: <xmx:4RyAZFXVUJGZrGhUWPCUcWS1SDHL1AE06mYn3-ZvxvixihqHeGLsIw>
    <xmx:4RyAZIn3tBuLxkxpiB8R6_4DeK678JKqIX7osEF3jXNPX-EHCq09uQ>
    <xmx:4RyAZKcXpeOC-pHuSLRzxtlJ5w6mmW8xcmEwrfvkKP_gQhwHQklcYg>
    <xmx:4RyAZHtW_bmQTHd9H65H_T_sEROnRWy2VLwPSftRfef-DSL9s-Pe_Q>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Jun 2023 01:59:58 -0400 (EDT)
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux-kernel@vger.kernel.org,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH net v2] net: pch_gbe: Allow build on MIPS_GENERIC kernel
Date: Wed,  7 Jun 2023 13:59:53 +0800
Message-Id: <20230607055953.34110-1-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

MIPS Boston board, which is using MIPS_GENERIC kernel is using
EG20T PCH and thus need this driver.

Dependency of PCH_GBE, PTP_1588_CLOCK_PCH is also fixed for
MIPS_GENERIC.

Note that CONFIG_PCH_GBE is selected in arch/mips/configs/generic/
board-boston.config for a while, some how it's never wired up
in Kconfig.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
v2: Add PTP_1588_CLOCK_PCH dependency.

Netdev maintainers, is it possible to squeeze this tiny patch into
fixes tree?
---
 drivers/net/ethernet/oki-semi/pch_gbe/Kconfig | 2 +-
 drivers/ptp/Kconfig                           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig b/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig
index 4e18b64dceb9..9651cc714ef2 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig
@@ -5,7 +5,7 @@
 
 config PCH_GBE
 	tristate "OKI SEMICONDUCTOR IOH(ML7223/ML7831) GbE"
-	depends on PCI && (X86_32 || COMPILE_TEST)
+	depends on PCI && (MIPS_GENERIC || X86_32 || COMPILE_TEST)
 	depends on PTP_1588_CLOCK
 	select MII
 	select PTP_1588_CLOCK_PCH
diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index b00201d81313..32dff1b4f891 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -102,7 +102,7 @@ config PTP_1588_CLOCK_INES
 
 config PTP_1588_CLOCK_PCH
 	tristate "Intel PCH EG20T as PTP clock"
-	depends on X86_32 || COMPILE_TEST
+	depends on MIPS_GENERIC || X86_32 || COMPILE_TEST
 	depends on HAS_IOMEM && PCI
 	depends on NET
 	depends on PTP_1588_CLOCK
-- 
2.39.2 (Apple Git-143)


