Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566425603BB
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 17:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbiF2PBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 11:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbiF2PBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 11:01:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2372A22B0A;
        Wed, 29 Jun 2022 08:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Q2BfGExYn9U8rc83KVNyv5vSdkzYMQ0Jg4fv+0NUVZA=; b=k1aAftu1e5qJZGp5/rD6jUOdy1
        2UKY1XQrv+O1S9wqYrvGaYjIu7bYi1b5W7yfPwAw1xvKnICMv4iHchcpYaTWSDZCzlU1D/Xa3RcPt
        T85IPso5YuHFVnAoGyzyZ/nrmu52lHlCzYtHp6b2VsLrMf0Tmx43svgYfc6MZuf2rz1BUadEeMQNp
        6X9uT5FCKr5OL9VtmYeGImuEmDBJauas0susmshk1SywkiFo0Co542trG8zi5slYZHlxTfF2RgC5l
        FGQiv46GQ/jgUHfF6fxpkxjGleTaKETXgtqMCY59OnQIpRTX2Ep2hYPpxG2hDXQu7L+epiJ4shk9e
        LZboSPxA==;
Received: from [2001:4bb8:199:3788:eb09:6317:6452:5395] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6ZBk-00CcgS-BX; Wed, 29 Jun 2022 15:01:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Hridya Valsaraju <hridya@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        rcu@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH] remove CONFIG_ANDROID
Date:   Wed, 29 Jun 2022 17:01:02 +0200
Message-Id: <20220629150102.1582425-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220629150102.1582425-1-hch@lst.de>
References: <20220629150102.1582425-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ANDROID config symbol is only used to guard the binder config
symbol and to inject completely random config changes.  Remove it
as it is obviously a bad idea.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/Makefile                                    | 2 +-
 drivers/android/Kconfig                             | 9 ---------
 drivers/char/random.c                               | 3 +--
 drivers/net/wireguard/device.c                      | 2 +-
 kernel/configs/android-base.config                  | 1 -
 kernel/rcu/Kconfig.debug                            | 3 +--
 tools/testing/selftests/filesystems/binderfs/config | 1 -
 tools/testing/selftests/sync/config                 | 1 -
 8 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index 9a30842b22c54..123dce2867583 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -176,7 +176,7 @@ obj-$(CONFIG_USB4)		+= thunderbolt/
 obj-$(CONFIG_CORESIGHT)		+= hwtracing/coresight/
 obj-y				+= hwtracing/intel_th/
 obj-$(CONFIG_STM)		+= hwtracing/stm/
-obj-$(CONFIG_ANDROID)		+= android/
+obj-y				+= android/
 obj-$(CONFIG_NVMEM)		+= nvmem/
 obj-$(CONFIG_FPGA)		+= fpga/
 obj-$(CONFIG_FSI)		+= fsi/
diff --git a/drivers/android/Kconfig b/drivers/android/Kconfig
index 53b22e26266c3..07aa8ae0a058c 100644
--- a/drivers/android/Kconfig
+++ b/drivers/android/Kconfig
@@ -1,13 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 menu "Android"
 
-config ANDROID
-	bool "Android Drivers"
-	help
-	  Enable support for various drivers needed on the Android platform
-
-if ANDROID
-
 config ANDROID_BINDER_IPC
 	bool "Android Binder IPC Driver"
 	depends on MMU
@@ -54,6 +47,4 @@ config ANDROID_BINDER_IPC_SELFTEST
 	  exhaustively with combinations of various buffer sizes and
 	  alignments.
 
-endif # if ANDROID
-
 endmenu
diff --git a/drivers/char/random.c b/drivers/char/random.c
index e3dd1dd3dd226..f35ad1a9dff3e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -755,8 +755,7 @@ static int random_pm_notification(struct notifier_block *nb, unsigned long actio
 	spin_unlock_irqrestore(&input_pool.lock, flags);
 
 	if (crng_ready() && (action == PM_RESTORE_PREPARE ||
-	    (action == PM_POST_SUSPEND &&
-	     !IS_ENABLED(CONFIG_PM_AUTOSLEEP) && !IS_ENABLED(CONFIG_ANDROID)))) {
+	    (action == PM_POST_SUSPEND && !IS_ENABLED(CONFIG_PM_AUTOSLEEP)))) {
 		crng_reseed();
 		pr_notice("crng reseeded on system resumption\n");
 	}
diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index aa9a7a5970fda..de1cc03f7ee86 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -69,7 +69,7 @@ static int wg_pm_notification(struct notifier_block *nb, unsigned long action, v
 	 * its normal operation rather than as a somewhat rare event, then we
 	 * don't actually want to clear keys.
 	 */
-	if (IS_ENABLED(CONFIG_PM_AUTOSLEEP) || IS_ENABLED(CONFIG_ANDROID))
+	if (IS_ENABLED(CONFIG_PM_AUTOSLEEP))
 		return 0;
 
 	if (action != PM_HIBERNATION_PREPARE && action != PM_SUSPEND_PREPARE)
diff --git a/kernel/configs/android-base.config b/kernel/configs/android-base.config
index eb701b2ac72ff..44b0f0146a3fc 100644
--- a/kernel/configs/android-base.config
+++ b/kernel/configs/android-base.config
@@ -7,7 +7,6 @@
 # CONFIG_OABI_COMPAT is not set
 # CONFIG_SYSVIPC is not set
 # CONFIG_USELIB is not set
-CONFIG_ANDROID=y
 CONFIG_ANDROID_BINDER_IPC=y
 CONFIG_ANDROID_BINDER_DEVICES=binder,hwbinder,vndbinder
 CONFIG_ANDROID_LOW_MEMORY_KILLER=y
diff --git a/kernel/rcu/Kconfig.debug b/kernel/rcu/Kconfig.debug
index 9b64e55d4f615..e875f4f889656 100644
--- a/kernel/rcu/Kconfig.debug
+++ b/kernel/rcu/Kconfig.debug
@@ -86,8 +86,7 @@ config RCU_EXP_CPU_STALL_TIMEOUT
 	int "Expedited RCU CPU stall timeout in milliseconds"
 	depends on RCU_STALL_COMMON
 	range 0 21000
-	default 20 if ANDROID
-	default 0 if !ANDROID
+	default 0
 	help
 	  If a given expedited RCU grace period extends more than the
 	  specified number of milliseconds, a CPU stall warning is printed.
diff --git a/tools/testing/selftests/filesystems/binderfs/config b/tools/testing/selftests/filesystems/binderfs/config
index 02dd6cc9cf992..7b4fc6ee62057 100644
--- a/tools/testing/selftests/filesystems/binderfs/config
+++ b/tools/testing/selftests/filesystems/binderfs/config
@@ -1,3 +1,2 @@
-CONFIG_ANDROID=y
 CONFIG_ANDROID_BINDERFS=y
 CONFIG_ANDROID_BINDER_IPC=y
diff --git a/tools/testing/selftests/sync/config b/tools/testing/selftests/sync/config
index 47ff5afc37271..64c60f38b4464 100644
--- a/tools/testing/selftests/sync/config
+++ b/tools/testing/selftests/sync/config
@@ -1,3 +1,2 @@
 CONFIG_STAGING=y
-CONFIG_ANDROID=y
 CONFIG_SW_SYNC=y
-- 
2.30.2

