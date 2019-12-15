Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBF7C11FB60
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 22:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfLOVIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 16:08:17 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:48739 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbfLOVIQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 16:08:16 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id bc6e72f2;
        Sun, 15 Dec 2019 20:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=7ExIoK5Bh005bUCG0kwZNDsQp
        /g=; b=az54vq8Aj98bZjO8Sy2RewF720mrZEVHKhI2Tmiq8YLeTVxxXJnKru677
        nVrN03JSd4g+gjKC7r4sft8k1SFKl3WhusjIp8aO3dzjxGeEM1vk9ZUQHIYrwIAa
        PsLBYOf8iNueDor1yuoGD5pmNRfp9Mk7f8N//EgJhHJwPaMxQtP5bWnAYRlhix9n
        7ANyg/oQoxwPDNeyAvi1pUvtx2E6S4Ia2E0Yg7nxYbmFd9plnK9h8msNhIKASO2b
        m+b/kpcgdo6FE/MNv0ZPK9d5vUDWUeQFL5bQfhnCF314K3J0x8fEkIFGQfML2tVP
        n70vZ3hA9ZjorEzntFCOJ8slZN8MA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 117a88ef (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Sun, 15 Dec 2019 20:11:58 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next 2/5] wireguard: Kconfig: select parent dependency for crypto
Date:   Sun, 15 Dec 2019 22:08:01 +0100
Message-Id: <20191215210804.143919-3-Jason@zx2c4.com>
In-Reply-To: <20191215210804.143919-1-Jason@zx2c4.com>
References: <20191215210804.143919-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes the crypto selection submenu depenencies. Otherwise, we'd
wind up issuing warnings in which certain dependencies we also select
couldn't be satisfied. This condition was triggered by the addition of
the test suite autobuilder in the previous commit.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index ffe8d4e2b206..01e2657e4c26 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -85,6 +85,8 @@ config WIREGUARD
 	select CRYPTO_POLY1305_X86_64 if X86 && 64BIT
 	select CRYPTO_BLAKE2S_X86 if X86 && 64BIT
 	select CRYPTO_CURVE25519_X86 if X86 && 64BIT
+	select ARM_CRYPTO if ARM
+	select ARM64_CRYPTO if ARM64
 	select CRYPTO_CHACHA20_NEON if (ARM || ARM64) && KERNEL_MODE_NEON
 	select CRYPTO_POLY1305_NEON if ARM64 && KERNEL_MODE_NEON
 	select CRYPTO_POLY1305_ARM if ARM
-- 
2.24.1

