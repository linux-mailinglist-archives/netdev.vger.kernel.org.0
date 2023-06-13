Return-Path: <netdev+bounces-10285-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A70C72D8D4
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 06:54:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 443A328110C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 04:54:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 128793C22;
	Tue, 13 Jun 2023 04:53:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17272598
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 04:53:41 +0000 (UTC)
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEB710D7;
	Mon, 12 Jun 2023 21:53:34 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6584553892cso1211700b3a.0;
        Mon, 12 Jun 2023 21:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686632013; x=1689224013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=10EEaoF+OSn0OiVxHg3Z7Dn0kpK8O8AdByu3lBZtS3o=;
        b=ntBQbooEhd9TlMNmSPCfYSz5hhDeiKng1YR7x310F9RvNNYP+NfIuaIi+sSU5u/MEu
         a3FMDrRvTUUC3si3QTlu1VJlsN7hrpZfXary+2p8ANg8PE7xGXiVtklaPZNHHwacV/t2
         +ZjEsOmcL6fElDaltv1p8Vrmb0dVhWyu2oLFplo8Obx6fUjIv4WngiZmCSqlwgGwhejK
         MTtjiC7Gee4w15dTazT2UBzoRwOVWjo4Gl2tAuAS0LqZOZHqPz8yI7/CmgLFCddwxtGZ
         Z6Jmoa4qeOHiVjXrmBixo8Ac+ESYPfBtZWfpVFsgo1CSMzzSLy3BQko6Fy4/KKuAYm1V
         hUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686632013; x=1689224013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=10EEaoF+OSn0OiVxHg3Z7Dn0kpK8O8AdByu3lBZtS3o=;
        b=itm3oNFUKHsaaLQc6cu7bf/e7i5elqL3Ex90vLvqRslu8lRHvKSSgM1cRcauQjRdXt
         888kKZ8KPP6SjIEnnAuMYyOmVhDpDG/szFDftPId79HWiW5TDatR4pWJLTeojfG4Mntx
         B6YCnD/plW+eIIF3MnfGfa7iEphes+1yucraFzURBGA/crv2E9xeW1mwfs69anbW8Gr7
         siKwLqOm4JaeoKyZ3aLyP+blvHgLHLh8ODM+/b6jJh6dGuntj10UhcBAM3n4ceR75XfK
         KvKYORkRnHgwb92tpGrRtWs80aq0J13b6haUb5ZNysdRL7w+wobajEvU8HuSlzllnIgM
         Gt4w==
X-Gm-Message-State: AC+VfDz6W/5rH6nM4t0s/asokdaqzVroN0Q8uns+syzL2xFEtSiNSJqQ
	EDiYAIknJNZzs9AOCMuVl7bkv0yKMMowkxaN
X-Google-Smtp-Source: ACHHUZ7i06fQildyFTnV6Lw6q6EoVIn4gsHpWBa4aGcvRc1jFj/ooTczaxiXFunidI5O17h6bKb3bw==
X-Received: by 2002:a17:902:e80e:b0:1b3:ec39:f42c with SMTP id u14-20020a170902e80e00b001b3ec39f42cmr924182plg.5.1686632013542;
        Mon, 12 Jun 2023 21:53:33 -0700 (PDT)
Received: from ip-172-30-47-114.us-west-2.compute.internal (ec2-54-68-170-188.us-west-2.compute.amazonaws.com. [54.68.170.188])
        by smtp.gmail.com with ESMTPSA id c5-20020a170902c1c500b001b027221393sm9095249plc.43.2023.06.12.21.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 21:53:32 -0700 (PDT)
From: FUJITA Tomonori <fujita.tomonori@gmail.com>
To: netdev@vger.kernel.org
Cc: rust-for-linux@vger.kernel.org,
	aliceryhl@google.com,
	andrew@lunn.ch,
	miguel.ojeda.sandonis@gmail.com
Subject: [PATCH 3/5] rust: add support for get_stats64 in struct net_device_ops
Date: Tue, 13 Jun 2023 13:53:24 +0900
Message-Id: <20230613045326.3938283-4-fujita.tomonori@gmail.com>
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

get_stats64() is used to return the stats for user-space like the
number of packets, which network device drivers are supposed to
support.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
---
 rust/kernel/net/dev.rs | 64 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 63 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/net/dev.rs b/rust/kernel/net/dev.rs
index d6012b2eea33..452944cf9fb8 100644
--- a/rust/kernel/net/dev.rs
+++ b/rust/kernel/net/dev.rs
@@ -8,7 +8,12 @@
 //! [`include/linux/skbuff.h`](../../../../include/linux/skbuff.h),
 //! [`include/uapi/linux/if_link.h`](../../../../include/uapi/linux/if_link.h).
 
-use crate::{bindings, error::*, prelude::vtable, types::ForeignOwnable};
+use crate::{
+    bindings,
+    error::*,
+    prelude::vtable,
+    types::{ForeignOwnable, Opaque},
+};
 use {core::ffi::c_void, core::marker::PhantomData};
 
 /// Corresponds to the kernel's `struct net_device`.
@@ -179,6 +184,11 @@ pub fn set_ether_operations<U>(&mut self) -> Result
         } else {
             None
         },
+        ndo_get_stats64: if <T>::HAS_GET_STATS64 {
+            Some(Self::get_stats64_callback)
+        } else {
+            None
+        },
         // SAFETY: The rest is zeroed out to initialize `struct net_device_ops`,
         // set `Option<&F>` to be `None`.
         ..unsafe { core::mem::MaybeUninit::<bindings::net_device_ops>::zeroed().assume_init() }
@@ -256,6 +266,22 @@ const fn build_device_ops() -> &'static bindings::net_device_ops {
         let skb = unsafe { SkBuff::from_ptr(skb) };
         T::start_xmit(&mut dev, data, skb) as bindings::netdev_tx_t
     }
+
+    unsafe extern "C" fn get_stats64_callback(
+        netdev: *mut bindings::net_device,
+        stats: *mut bindings::rtnl_link_stats64,
+    ) {
+        // SAFETY: The C API guarantees that `netdev` is valid while this function is running.
+        let mut dev = unsafe { Device::from_ptr(netdev) };
+        // SAFETY: The returned pointer was initialized by `D::Data::into_foreign` when
+        // `Registration` object was created.
+        // `D::Data::from_foreign` is only called by the object was released.
+        // So we know `data` is valid while this function is running.
+        let data = unsafe { D::Data::borrow(dev.priv_data_ptr()) };
+        // SAFETY: for writing and nobody else will read or write to it.
+        let stats = unsafe { RtnlLinkStats64::from_ptr(stats) };
+        T::get_stats64(&mut dev, data, stats);
+    }
 }
 
 // SAFETY: `Registration` exposes only `Device` object which can be used from
@@ -305,6 +331,14 @@ fn start_xmit(
     ) -> TxCode {
         TxCode::Busy
     }
+
+    /// Corresponds to `ndo_get_stats64` in `struct net_device_ops`.
+    fn get_stats64(
+        _dev: &mut Device,
+        _data: <D::Data as ForeignOwnable>::Borrowed<'_>,
+        _stats: &mut RtnlLinkStats64,
+    ) {
+    }
 }
 
 /// Corresponds to the kernel's `struct sk_buff`.
@@ -355,6 +389,34 @@ fn drop(&mut self) {
     }
 }
 
+/// Corresponds to the kernel's `struct rtnl_link_stats64`.
+#[repr(transparent)]
+pub struct RtnlLinkStats64(Opaque<bindings::rtnl_link_stats64>);
+
+impl RtnlLinkStats64 {
+    /// Creates a new [`RtnlLinkStats64`] instance.
+    ///
+    /// # Safety
+    ///
+    /// For the duration of the lifetime 'a, the pointer must be valid for writing and nobody else
+    /// may read or write to the `rtnl_link_stats64` object.
+    unsafe fn from_ptr<'a>(ptr: *mut bindings::rtnl_link_stats64) -> &'a mut Self {
+        unsafe { &mut *(ptr as *mut Self) }
+    }
+
+    /// Updates TX stats.
+    pub fn set_tx_stats(&mut self, packets: u64, bytes: u64, errors: u64, dropped: u64) {
+        // SAFETY: We have exclusive access to the `rtnl_link_stats64`, so writing to it is okay.
+        unsafe {
+            let inner = Opaque::get(&self.0);
+            (*inner).tx_packets = packets;
+            (*inner).tx_bytes = bytes;
+            (*inner).tx_errors = errors;
+            (*inner).tx_dropped = dropped;
+        }
+    }
+}
+
 /// Builds the kernel's `struct ethtool_ops`.
 struct EtherOperationsAdapter<D, T> {
     _p: PhantomData<(D, T)>,
-- 
2.34.1


