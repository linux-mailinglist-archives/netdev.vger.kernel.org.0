Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D56B2E8E81
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 22:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbhACVji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 16:39:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:37162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbhACVji (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Jan 2021 16:39:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FDD7207C9;
        Sun,  3 Jan 2021 21:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609709937;
        bh=w4batz0nh1oVczn/sJwpikel/u/aABuBR+vdrU8Y3k4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbXM9gIWabEyaHNNIzuBreGBGvUDBvxSQbCf7MY6njFQLc89UeH8Ia6NbfdHoADGp
         QiD3dtd8eaSVa8LDm4DOTXwEosNq8k+EFuS3e/Ep8IUZop9ssy176SnmUgCl/FePh2
         l1A3hhYpVHVS8sGnYDhrzI41bXP6eUF6OXjE3moiFs6owlEfM4UqEH4cUqUnVnlDM7
         XxKmmKSCcDp0VDh4lpi4FvPREbvpaS+4Yd5Z8doXQkHv2NYJfJn11l/Oq3dweqtahs
         B/fSbQJ2VAGvsNfzawezHVDXrSA/BAKM505NcxJRfETteA3955RWnQ0zT6mUB0B2WB
         7UA5IUfIfPXMQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Karsten Keil <isdn@linux-pingi.de>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] misdn: dsp: select CONFIG_BITREVERSE
Date:   Sun,  3 Jan 2021 22:36:22 +0100
Message-Id: <20210103213645.1994783-6-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210103213645.1994783-1-arnd@kernel.org>
References: <20210103213645.1994783-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Without this, we run into a link error

arm-linux-gnueabi-ld: drivers/isdn/mISDN/dsp_audio.o: in function `dsp_audio_generate_law_tables':
(.text+0x30c): undefined reference to `byte_rev_table'
arm-linux-gnueabi-ld: drivers/isdn/mISDN/dsp_audio.o:(.text+0x5e4): more undefined references to `byte_rev_table' follow

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/isdn/mISDN/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/isdn/mISDN/Kconfig b/drivers/isdn/mISDN/Kconfig
index 26cf0ac9c4ad..c9a53c222472 100644
--- a/drivers/isdn/mISDN/Kconfig
+++ b/drivers/isdn/mISDN/Kconfig
@@ -13,6 +13,7 @@ if MISDN != n
 config MISDN_DSP
 	tristate "Digital Audio Processing of transparent data"
 	depends on MISDN
+	select BITREVERSE
 	help
 	  Enable support for digital audio processing capability.
 
-- 
2.29.2

