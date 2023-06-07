Return-Path: <netdev+bounces-8695-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D7187253C6
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 07:59:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28DDF280A93
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 05:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 852452108;
	Wed,  7 Jun 2023 05:59:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791681385
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 05:59:50 +0000 (UTC)
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2DA83;
	Tue,  6 Jun 2023 22:59:48 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.nyi.internal (Postfix) with ESMTP id 251AA5C01E7;
	Wed,  7 Jun 2023 01:59:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 07 Jun 2023 01:59:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to; s=fm2; t=1686117588; x=1686203988; bh=fl3ejIANYM
	wphGOpTaZIWtY9rHRJ/IGNetQKrBgr9cI=; b=IiTF6Qe5l/O3XvAjnZXNpfCEEk
	tKdC9TRPsgKQQugtRI8wl2LqekVBTyjnWDfKdNSyBHLGeWW82P0t9183gSTfCRKu
	NRZz4+QlCJWS/nPjeGEOOm/wR1xKJvs9+knHzpinecqdEL3ELsGZF9nkd9qkc62b
	voEfRqEjrMcEuxNEPfZu3/IsiXPN8sF9t2CafU28SwV0tUwmOPtVbL2ubhcNUI5u
	Msy5JqrOvilllqw4sXasgMTGJQjUziVX0s4k62yMnvKhK/bbbYCBdmX2Gi76TER5
	iiMN04MTADTYgMpT3GQycfYJuuYzBgfQQrvJjcov7IcxWuMzzauRrvJXXpQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1686117588; x=1686203988; bh=fl3ejIANYMwph
	GOpTaZIWtY9rHRJ/IGNetQKrBgr9cI=; b=oDsscVxaeTld1Z1a7Vxlc+IWbKsPg
	MkuqXqpMRW178RwiGnZU8EsDeiGS3Paw+a6ljz97iimsi9eiS3DGcjunXIGp0tNd
	eKg10MwcMe6Gyw6H5TqBhbTfT1SAWUVSh8Ia9xUpEGokrJbB8aAmQWmNXEX1s8bd
	M+/1myJs0ZGhZ5B5nvyBQ2yflpCsIN0kvnlEGSnXGaO5jdSjQJTMozhdg1r5C4yN
	u+jxaMeyL/KjPUrsEt+uO3w512Z0/YrJNC+AcvBc7Jhm33HoSm6GNu15AApwhu+6
	26fw6wR/ECEFqLKDGywyN0HkN3zToTeU/RF33twsYe7dmkqdcb0KX3UQQ==
X-ME-Sender: <xms:0xyAZLlN5zF2B77ykTCAJmg6zG3ZYGAv-BB73Q6liqJBYRlGL_xaHg>
    <xme:0xyAZO1p0muuYYBAhFEmyFPKfL4icrn-9r0LwbUvbj9HXZObpLKGV9yeA1h9sjvVt
    RXlXUkqti4Fn53-8JE>
X-ME-Received: <xmr:0xyAZBpgnhf5UGaS_brd22RrwjsvkArVHlo2l_vYCSF13ZsvzMYK2dbP0pRBLnF7tBdIFspoAPaFB6ALfCY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedtfedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeflihgrgihunhcujggrnhhguceojhhirgiguhhnrdihrghnghes
    fhhlhihgohgrthdrtghomheqnecuggftrfgrthhtvghrnhephfetuddtudevieeljeejte
    ffheeujeduhefgffejudfhueelleduffefgfffveeknecuvehluhhsthgvrhfuihiivgep
    tdenucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgoh
    grthdrtghomh
X-ME-Proxy: <xmx:0xyAZDmzocHV-c7dShGSPl_63D1LOsUCnBuzh9r8VT2dZTjZyvmJbQ>
    <xmx:0xyAZJ1JrpucIAE-xactPBEtdbAJEYWZzPeCGaaNiOYDvqNszkmwlg>
    <xmx:0xyAZCsC-2LfEHO4iMFvW2Z0UgXOK8d-qHZb294Mfl0_KaxN1FLRoA>
    <xmx:1ByAZB8PoRc2r0FNQwGEKXTp_wPJwuKVvx4hc6NACW9pVKqsh3Nwfg>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Jun 2023 01:59:45 -0400 (EDT)
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux-kernel@vger.kernel.org,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH v2] net: pch_gbe: Allow build on MIPS_GENERIC kernel
Date: Wed,  7 Jun 2023 13:59:40 +0800
Message-Id: <20230607055940.34064-1-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
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


