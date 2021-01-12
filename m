Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AFB2F301C
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbhALNC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:02:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:53866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405418AbhALM6i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE3BF23123;
        Tue, 12 Jan 2021 12:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456298;
        bh=K5UVOAFSVMpxnx58cB+TImbkULMojURm5Eon9UXNVrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+rwGUk7jgKKzoZEsvu6FuinvKAPXGZC9aB10YDCaJEDXzAMYH7fg2qJKoGqhM/nY
         f7e15GmF+d1dlLnAO5JjvyUa4DVu6MQlMvupdizgZSGAXGnLbIXNz74vpFA5HNAOSm
         znyn13cVdOukTbmRaux2dcTw7iu7mRBlw44geTtidHmp8Q4ljy7dLM3gIB7EhimtpT
         MHcykvIz5CWCmA9S8dgyvlW2hHlk4TG25a/ffTa2Y7GV+v879h+51IwVz6EgCl8Q34
         00WjXwskQWxRD8cSVwWlHHEzMoJX835Cx71nYdQ2qoWZlGkGdU0/CK7y33u0UfSYNE
         fuRmsJspd9LxA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 5/8] misdn: dsp: select CONFIG_BITREVERSE
Date:   Tue, 12 Jan 2021 07:58:06 -0500
Message-Id: <20210112125810.71348-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125810.71348-1-sashal@kernel.org>
References: <20210112125810.71348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 51049bd903a81307f751babe15a1df8d197884e8 ]

Without this, we run into a link error

arm-linux-gnueabi-ld: drivers/isdn/mISDN/dsp_audio.o: in function `dsp_audio_generate_law_tables':
(.text+0x30c): undefined reference to `byte_rev_table'
arm-linux-gnueabi-ld: drivers/isdn/mISDN/dsp_audio.o:(.text+0x5e4): more undefined references to `byte_rev_table' follow

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/mISDN/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/isdn/mISDN/Kconfig b/drivers/isdn/mISDN/Kconfig
index c0730d5c734d6..fb61181a5c4f7 100644
--- a/drivers/isdn/mISDN/Kconfig
+++ b/drivers/isdn/mISDN/Kconfig
@@ -12,6 +12,7 @@ if MISDN != n
 config MISDN_DSP
 	tristate "Digital Audio Processing of transparent data"
 	depends on MISDN
+	select BITREVERSE
 	help
 	  Enable support for digital audio processing capability.
 
-- 
2.27.0

