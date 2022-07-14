Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8297A5742F5
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 06:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235779AbiGNE23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 00:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235184AbiGNE1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 00:27:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9DC92CDE0;
        Wed, 13 Jul 2022 21:24:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57CC961E51;
        Thu, 14 Jul 2022 04:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5688C34114;
        Thu, 14 Jul 2022 04:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772662;
        bh=e1/bMm+v6dgLCeNOtMgPs9Ff3aMrUsI4Skj8whhOI10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxXdQ3yVhHof+wqAOtAbhWHn3U1iTI7+WmFKNIfz9/3RHSxgaBIYedkgqVOz839ah
         CAYvRlMfKe/sCdj+c83922CUarGjodTK4SnrR0NJcuVf9rz0Y33/2mF71y2T2xq5n/
         lCATvQBmqufaLLC2QcuWXYB57igE1bsvJTPyXeoWcAb33O2Lqnn42I04eXkP5xrGkV
         YMhSNCk+0NYoqzFjmqm3omWvhPXP/qJofd/iOSBtiUQ1CZ3/1Tnlu8VUrv9VXCjN1O
         Ia1DpFwIjbd7hY3+Z6QYLp0vQ41YxuqE4vX7ruW4r0u00oGa6CKTnVFCYTlFF+Zk4x
         tfzHK+xMLO0PQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 39/41] wireguard: selftests: use virt machine on m68k
Date:   Thu, 14 Jul 2022 00:22:19 -0400
Message-Id: <20220714042221.281187-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042221.281187-1-sashal@kernel.org>
References: <20220714042221.281187-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 1f2f341a62639c7066ee4c76b7d9ebe867e0a1d5 ]

This should be a bit more stable hopefully.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/wireguard/qemu/Makefile         | 5 +++--
 tools/testing/selftests/wireguard/qemu/arch/m68k.config | 9 +++------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/wireguard/qemu/Makefile b/tools/testing/selftests/wireguard/qemu/Makefile
index bca07b93eeb0..e8a82e495d2e 100644
--- a/tools/testing/selftests/wireguard/qemu/Makefile
+++ b/tools/testing/selftests/wireguard/qemu/Makefile
@@ -210,10 +210,11 @@ QEMU_ARCH := m68k
 KERNEL_ARCH := m68k
 KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/vmlinux
 KERNEL_CMDLINE := $(shell sed -n 's/CONFIG_CMDLINE=\(.*\)/\1/p' arch/m68k.config)
+QEMU_VPORT_RESULT := virtio-serial-device
 ifeq ($(HOST_ARCH),$(ARCH))
-QEMU_MACHINE := -cpu host,accel=kvm -machine q800 -append $(KERNEL_CMDLINE)
+QEMU_MACHINE := -cpu host,accel=kvm -machine virt -append $(KERNEL_CMDLINE)
 else
-QEMU_MACHINE := -machine q800 -smp 1 -append $(KERNEL_CMDLINE)
+QEMU_MACHINE := -machine virt -smp 1 -append $(KERNEL_CMDLINE)
 endif
 else ifeq ($(ARCH),riscv64)
 CHOST := riscv64-linux-musl
diff --git a/tools/testing/selftests/wireguard/qemu/arch/m68k.config b/tools/testing/selftests/wireguard/qemu/arch/m68k.config
index 9639bfe06074..39c48cba56b7 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/m68k.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/m68k.config
@@ -1,10 +1,7 @@
 CONFIG_MMU=y
+CONFIG_VIRT=y
 CONFIG_M68KCLASSIC=y
-CONFIG_M68040=y
-CONFIG_MAC=y
-CONFIG_SERIAL_PMACZILOG=y
-CONFIG_SERIAL_PMACZILOG_TTYS=y
-CONFIG_SERIAL_PMACZILOG_CONSOLE=y
+CONFIG_VIRTIO_CONSOLE=y
 CONFIG_COMPAT_32BIT_TIME=y
-CONFIG_CMDLINE="console=ttyS0 wg.success=ttyS1 panic_on_warn=1"
+CONFIG_CMDLINE="console=ttyGF0 wg.success=vport0p1 panic_on_warn=1"
 CONFIG_FRAME_WARN=1024
-- 
2.35.1

