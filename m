Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D855742FF
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 06:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbiGNE2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 00:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235488AbiGNE1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 00:27:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB90C28728;
        Wed, 13 Jul 2022 21:24:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5148161E97;
        Thu, 14 Jul 2022 04:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03A6C34114;
        Thu, 14 Jul 2022 04:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772665;
        bh=rOZ/mh+hD1fgTml8JMj+k6WIev0FFuSsCiRhCRWGv2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oIRKnGuazmHIVvEX/ADa2/AejTlvMN52BJ2yD4F0uOsW8e2oGdRie9mdhiC5MZRay
         +RTNVkwWUodj6J5BM3S16XgTi4BoRVqER1jB6cTMQb/H8GoPHdpooXLbhnsXr7W1e+
         jtWpX2mL55ryGgY18fyGCI1XChlfuq4nZq4ZLGKJswYae8uLdC5KrvZ+eeJFHb5DDX
         xYg+uOGbODlPet7VrKqRLcJhZF37HarpZ+tXWFf68nsy1CvzTPHMMU7qjUWbA1fo+f
         +yUalb+d1Pw/Yok0Ni30cnZ4GnMVXKydYHP/GwDbZZ7x/MW9ebMJ1UIrN8ffni0gT7
         9NebhjdbeOrNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 40/41] wireguard: selftests: always call kernel makefile
Date:   Thu, 14 Jul 2022 00:22:20 -0400
Message-Id: <20220714042221.281187-40-sashal@kernel.org>
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

[ Upstream commit 1a087eec257154e26a81a7a0a15380d7a2431765 ]

These selftests are used for much more extensive changes than just the
wireguard source files. So always call the kernel's build file, which
will do something or nothing after checking the whole tree, per usual.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/wireguard/qemu/Makefile | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/wireguard/qemu/Makefile b/tools/testing/selftests/wireguard/qemu/Makefile
index e8a82e495d2e..fcc3f668b807 100644
--- a/tools/testing/selftests/wireguard/qemu/Makefile
+++ b/tools/testing/selftests/wireguard/qemu/Makefile
@@ -19,8 +19,6 @@ endif
 MIRROR := https://download.wireguard.com/qemu-test/distfiles/
 
 KERNEL_BUILD_PATH := $(BUILD_PATH)/kernel$(if $(findstring yes,$(DEBUG_KERNEL)),-debug)
-rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))
-WIREGUARD_SOURCES := $(call rwildcard,$(KERNEL_PATH)/drivers/net/wireguard/,*)
 
 default: qemu
 
@@ -325,8 +323,9 @@ $(KERNEL_BUILD_PATH)/.config: $(TOOLCHAIN_PATH)/.installed kernel.config arch/$(
 	cd $(KERNEL_BUILD_PATH) && ARCH=$(KERNEL_ARCH) $(KERNEL_PATH)/scripts/kconfig/merge_config.sh -n $(KERNEL_BUILD_PATH)/.config $(KERNEL_BUILD_PATH)/minimal.config
 	$(if $(findstring yes,$(DEBUG_KERNEL)),cp debug.config $(KERNEL_BUILD_PATH) && cd $(KERNEL_BUILD_PATH) && ARCH=$(KERNEL_ARCH) $(KERNEL_PATH)/scripts/kconfig/merge_config.sh -n $(KERNEL_BUILD_PATH)/.config debug.config,)
 
-$(KERNEL_BZIMAGE): $(TOOLCHAIN_PATH)/.installed $(KERNEL_BUILD_PATH)/.config $(BUILD_PATH)/init-cpio-spec.txt $(IPERF_PATH)/src/iperf3 $(IPUTILS_PATH)/ping $(BASH_PATH)/bash $(IPROUTE2_PATH)/misc/ss $(IPROUTE2_PATH)/ip/ip $(IPTABLES_PATH)/iptables/xtables-legacy-multi $(NMAP_PATH)/ncat/ncat $(WIREGUARD_TOOLS_PATH)/src/wg $(BUILD_PATH)/init ../netns.sh $(WIREGUARD_SOURCES)
+$(KERNEL_BZIMAGE): $(TOOLCHAIN_PATH)/.installed $(KERNEL_BUILD_PATH)/.config $(BUILD_PATH)/init-cpio-spec.txt $(IPERF_PATH)/src/iperf3 $(IPUTILS_PATH)/ping $(BASH_PATH)/bash $(IPROUTE2_PATH)/misc/ss $(IPROUTE2_PATH)/ip/ip $(IPTABLES_PATH)/iptables/xtables-legacy-multi $(NMAP_PATH)/ncat/ncat $(WIREGUARD_TOOLS_PATH)/src/wg $(BUILD_PATH)/init
 	$(MAKE) -C $(KERNEL_PATH) O=$(KERNEL_BUILD_PATH) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(CROSS_COMPILE)
+.PHONY: $(KERNEL_BZIMAGE)
 
 $(TOOLCHAIN_PATH)/$(CHOST)/include/linux/.installed: | $(KERNEL_BUILD_PATH)/.config $(TOOLCHAIN_PATH)/.installed
 	rm -rf $(TOOLCHAIN_PATH)/$(CHOST)/include/linux
-- 
2.35.1

