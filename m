Return-Path: <netdev+bounces-10282-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50C2772D8D0
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 06:54:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B9DB1C20C0F
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 04:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FA0B23CD;
	Tue, 13 Jun 2023 04:53:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7A323C4
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 04:53:38 +0000 (UTC)
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A1210DF;
	Mon, 12 Jun 2023 21:53:36 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b3ecb17721so385215ad.0;
        Mon, 12 Jun 2023 21:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686632016; x=1689224016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7D7KD+4/hvSzq7CFXPABTFsWyQuluvzVlksOwlgt0j4=;
        b=lBt7XkrWoWv4WtbnZEMyO+/Ha6V5eGYfdnP3Kzg2oJj0twC7C6ccryxk9+LyDemmPj
         JOS3LdIiVUSdcl9LKXAuCvb79EjI/NbjqSpo6YoFZgCwBWxl6u1qT7Y/sT1SS+a7dO62
         qQGkjvP+rtq3AMxWSEcfjbK5sRX0S5dgI9h8T9rQiOqQKUErPP52p4/ODLxz9p6wVUiy
         9BOt2qp/F3F7ho3ecmxxZJbp965EtG0HIvR/zQ9s26bg+UCM45EMrDNJ5KBg33ObDA+3
         mzpi4hwf/DNXWQlFWpwcE96dd2Y7LtYyFbILBul+sXmGNnXT9ixxFk/EmW2XS8Uq01Qk
         Zufg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686632016; x=1689224016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7D7KD+4/hvSzq7CFXPABTFsWyQuluvzVlksOwlgt0j4=;
        b=CqjZi3UcjNpDXEgH7pNdcN+w1Btn7fvtJJug3opMGaMxHz7f8GTFBU7WbjHng1GY6S
         aekJqCnFxn4k7MtvUCN3aQblmYnTvCJ8kEc5tlvCze3eyTfb2LeiGSlHYFZ6BG+9sW3s
         5sr5L3pbYDs18MFYwVqp7lbszsAxKsevFKsaJoq01SbvOAWH/kW6N7X3oj+d2QhbG4s0
         +5kSjYTE+P2Mq2HEFPNEEbh9/Z35fo9oyhJtPJG3Gcy6gv1NhMj5oIKIo4nvWICcmUa2
         ynKwW1PQa6rdtoPHHubJhCIjiZxnu1Bz+WuXizwbqPi85gG33YUJdg+EV8hPMcxcm5g2
         rN1g==
X-Gm-Message-State: AC+VfDz8c3J+OXUtIZVl5rS70NL52iziQjB3o4Z7tEpP2DR7lxLOpSIy
	h4MjWl0Yqhbjhbo1iJLVbXcyTt37NDO+bMZA
X-Google-Smtp-Source: ACHHUZ44OEkRfiOJ41O+zs4PNyrhQqZG9RkIftnA1tvpJkvTqJBrVSk69FN0hR8Bu+rTPCzNesUPbg==
X-Received: by 2002:a17:902:e844:b0:1b3:ebda:654e with SMTP id t4-20020a170902e84400b001b3ebda654emr1013355plg.5.1686632015580;
        Mon, 12 Jun 2023 21:53:35 -0700 (PDT)
Received: from ip-172-30-47-114.us-west-2.compute.internal (ec2-54-68-170-188.us-west-2.compute.amazonaws.com. [54.68.170.188])
        by smtp.gmail.com with ESMTPSA id c5-20020a170902c1c500b001b027221393sm9095249plc.43.2023.06.12.21.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 21:53:34 -0700 (PDT)
From: FUJITA Tomonori <fujita.tomonori@gmail.com>
To: netdev@vger.kernel.org
Cc: rust-for-linux@vger.kernel.org,
	aliceryhl@google.com,
	andrew@lunn.ch,
	miguel.ojeda.sandonis@gmail.com
Subject: [PATCH 5/5] samples: rust: add dummy network driver
Date: Tue, 13 Jun 2023 13:53:26 +0900
Message-Id: <20230613045326.3938283-6-fujita.tomonori@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230613045326.3938283-1-fujita.tomonori@gmail.com>
References: <20230613045326.3938283-1-fujita.tomonori@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is a simpler version of drivers/net/dummy.c.

This demonstrates the usage of abstractions for network device drivers.

Allows allocator_api feature for Box::try_new();

Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
---
 samples/rust/Kconfig           | 12 +++++
 samples/rust/Makefile          |  1 +
 samples/rust/rust_net_dummy.rs | 81 ++++++++++++++++++++++++++++++++++
 scripts/Makefile.build         |  2 +-
 4 files changed, 95 insertions(+), 1 deletion(-)
 create mode 100644 samples/rust/rust_net_dummy.rs

diff --git a/samples/rust/Kconfig b/samples/rust/Kconfig
index b0f74a81c8f9..8b52ba620ae3 100644
--- a/samples/rust/Kconfig
+++ b/samples/rust/Kconfig
@@ -30,6 +30,18 @@ config SAMPLE_RUST_PRINT
 
 	  If unsure, say N.
 
+config SAMPLE_RUST_NET_DUMMY
+	tristate "Dummy network driver"
+	depends on NET
+	help
+	  This is the simpler version of drivers/net/dummy.c. No intention to replace it.
+	  This provides educational information for Rust abstractions for network drivers.
+
+	  To compile this as a module, choose M here:
+	  the module will be called rust_minimal.
+
+	  If unsure, say N.
+
 config SAMPLE_RUST_HOSTPROGS
 	bool "Host programs"
 	help
diff --git a/samples/rust/Makefile b/samples/rust/Makefile
index 03086dabbea4..440dee2971ba 100644
--- a/samples/rust/Makefile
+++ b/samples/rust/Makefile
@@ -2,5 +2,6 @@
 
 obj-$(CONFIG_SAMPLE_RUST_MINIMAL)		+= rust_minimal.o
 obj-$(CONFIG_SAMPLE_RUST_PRINT)			+= rust_print.o
+obj-$(CONFIG_SAMPLE_RUST_NET_DUMMY)		+= rust_net_dummy.o
 
 subdir-$(CONFIG_SAMPLE_RUST_HOSTPROGS)		+= hostprogs
diff --git a/samples/rust/rust_net_dummy.rs b/samples/rust/rust_net_dummy.rs
new file mode 100644
index 000000000000..6c49a7ba7ba2
--- /dev/null
+++ b/samples/rust/rust_net_dummy.rs
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+//! Rust dummy netdev.
+
+use kernel::{
+    c_str,
+    net::dev::{
+        ethtool_op_get_ts_info, flags, priv_flags, Device, DeviceOperations, DriverData,
+        EtherOperations, EthtoolTsInfo, Registration, RtnlLinkStats64, SkBuff, TxCode,
+    },
+    prelude::*,
+};
+
+module! {
+    type: DummyNetdev,
+    name: "rust_net_dummy",
+    author: "Rust for Linux Contributors",
+    description: "Rust dummy netdev",
+    license: "GPL v2",
+}
+
+struct DevOps {}
+
+#[vtable]
+impl<D: DriverData<Data = Box<Stats>>> DeviceOperations<D> for DevOps {
+    fn init(_dev: &mut Device, _data: &Stats) -> Result {
+        Ok(())
+    }
+
+    fn start_xmit(_dev: &mut Device, _data: &Stats, mut skb: SkBuff) -> TxCode {
+        skb.tx_timestamp();
+        TxCode::Ok
+    }
+
+    fn get_stats64(_dev: &mut Device, _data: &Stats, _stats: &mut RtnlLinkStats64) {}
+}
+
+/// For device driver specific information.
+struct Stats {}
+
+impl DriverData for Stats {
+    type Data = Box<Stats>;
+}
+
+struct DummyNetdev {
+    _r: Registration<DevOps, Stats>,
+}
+
+struct EtherOps {}
+
+#[vtable]
+impl<D: DriverData<Data = Box<Stats>>> EtherOperations<D> for EtherOps {
+    fn get_ts_info(dev: &mut Device, _data: &Stats, info: &mut EthtoolTsInfo) -> Result {
+        ethtool_op_get_ts_info(dev, info)
+    }
+}
+
+impl kernel::Module for DummyNetdev {
+    fn init(_module: &'static ThisModule) -> Result<Self> {
+        let data = Box::try_new(Stats {})?;
+        let mut r = Registration::<DevOps, Stats>::try_new_ether(1, 1, data)?;
+        r.set_ether_operations::<EtherOps>()?;
+
+        let netdev = r.dev_get();
+        netdev.set_name(c_str!("dummy%d"))?;
+
+        netdev.set_flags(netdev.get_flags() | flags::IFF_NOARP & !flags::IFF_MULTICAST);
+        netdev.set_priv_flags(
+            netdev.get_priv_flags() | priv_flags::IFF_LIVE_ADDR_CHANGE | priv_flags::IFF_NO_QUEUE,
+        );
+        netdev.set_random_eth_hw_addr();
+        netdev.set_min_mtu(0);
+        netdev.set_max_mtu(0);
+
+        r.register()?;
+
+        // TODO: Replaces pr_info with the wrapper of netdev_info().
+        pr_info!("Hello Rust dummy netdev!");
+        Ok(DummyNetdev { _r: r })
+    }
+}
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 78175231c969..1404967e908e 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -277,7 +277,7 @@ $(obj)/%.lst: $(src)/%.c FORCE
 # Compile Rust sources (.rs)
 # ---------------------------------------------------------------------------
 
-rust_allowed_features := new_uninit
+rust_allowed_features := allocator_api,new_uninit
 
 rust_common_cmd = \
 	RUST_MODFILE=$(modfile) $(RUSTC_OR_CLIPPY) $(rust_flags) \
-- 
2.34.1


