Return-Path: <netdev+bounces-6451-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D9BE7165C6
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:03:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E166F281200
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:03:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DDAD23C8B;
	Tue, 30 May 2023 15:03:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0058917AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:03:18 +0000 (UTC)
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED98100;
	Tue, 30 May 2023 08:03:15 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 79ECF5C0103;
	Tue, 30 May 2023 11:03:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 30 May 2023 11:03:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to; s=fm2; t=1685458994; x=1685545394; bh=htsD3jYU33
	SJKqKaeiRne4+S4WH//xmAF5gjSTmgLW8=; b=TVce46oWpowOgz5QKnBolTeXOK
	W0+v80SGoYeQFxx55Rdw8ZZDpnPOBIGRoyJxTq05tJ2UP4FTC+xTOvnO7Wnn9nja
	yVAFbBGR5gyaNhq+dtd/ccT5l33O10vT1eAiIYVhHq5VFK+maWp0NLF9tK+ZjNKa
	KIC2Y8VaZOECAB/ra8wcVvJsuzGJfTk5zzaOW+c/1rUEFAtOqe4t+2myZuueAcrd
	XFRYJHw0v56M1wwvqEfKNtCCVLsZ3C0AEgcxOaWx31XiDyGb3dfzdmV9yYp12O52
	2DhYeZ/uSqwSVRpNHhTRXwJYsOmDcQlKVqXTUsbB9oexLOe7uE1Wv008a18Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1685458994; x=1685545394; bh=htsD3jYU33SJK
	qKaeiRne4+S4WH//xmAF5gjSTmgLW8=; b=kRK3/YsryImCd97MDTHV/CBQDKILm
	H9fk6yPi0Py6w+4QeSp3Z2zl9M6vwRXqMsApClr5UncgiP2/qg+7SV/rPE4o76CX
	6X9XmD7vuyOBAh6t7Fs/TEuRsh3cLSwihCVxXZ1mHt8RKmPdBysaDAsH6gyCbBGX
	KAeltlRNVzDpz7NCMeOqukp7TsWoEYaCgyDWdcddT1ptfWvg5NxqSzOSzofi3rXG
	42t8UDXpeoviBe/VpPvzAeHLthRohz2Rwtmh+SymuEKQIKbG5iXUf/qKoYSUNImh
	iLMB2DvONAxgU3vmSqcxPpIIqY30Nd5vrksJsDCFeXfaMKWSU50u/E7hw==
X-ME-Sender: <xms:MRB2ZGqEYA8yBn1bj5Ln-Mwh4ELC5Q3D3J6agc30wzxJj8YvWDD00g>
    <xme:MRB2ZEq5vYh2THZnuPEAXlYLzOWvszZu6PKvUogcWm6UQb05YrkX_G1dDVEkLtUxA
    eFTd93q8ehFPSkVQDI>
X-ME-Received: <xmr:MRB2ZLO42KD2Ar-9nixaRxOYfjP9hdwDcKw-2Ken9PZo7OZsh8J4YMtFvBvK>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeekjedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeflihgrgihunhcujggrnhhguceojhhirgiguhhnrdihrghnghes
    fhhlhihgohgrthdrtghomheqnecuggftrfgrthhtvghrnhephfetuddtudevieeljeejte
    ffheeujeduhefgffejudfhueelleduffefgfffveeknecuvehluhhsthgvrhfuihiivgep
    tdenucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgoh
    grthdrtghomh
X-ME-Proxy: <xmx:MRB2ZF7iHvYEoKIRs7bgLCjKtAeE8lsbzItHMh_0tXKCcezoAekM0g>
    <xmx:MRB2ZF6acvmRl2XkPwkz-zZpkUZKrfHun-Or-506uSeBV63bHU6cmA>
    <xmx:MRB2ZFjKCoCPP5Ei7Q7SSBZVpScLkRRUcbygKA4lB8pOetsOh03Mdw>
    <xmx:MhB2ZDQl_UH4vKGke_upE5-pb7u1nJwaSIaN2lVzV8XyJtwQQmghXQ>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 30 May 2023 11:03:11 -0400 (EDT)
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.or,
	pabeni@redhat.com,
	linux-kernel@vger.kernel.org,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH] net: pch_gbe: Allow build on MIPS_GENERIC kernel
Date: Tue, 30 May 2023 16:03:01 +0100
Message-Id: <20230530150301.9555-1-jiaxun.yang@flygoat.com>
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

Note that CONFIG_PCH_GBE is selected in arch/mips/configs/generic/
board-boston.config for a while, some how it's never wired up
in Kconfig.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
Netdev maintainers, is it possible to squeeze this tiny patch into
fixes tree?
---
 drivers/net/ethernet/oki-semi/pch_gbe/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
2.39.2 (Apple Git-143)


