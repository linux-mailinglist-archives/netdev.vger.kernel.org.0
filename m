Return-Path: <netdev+bounces-10281-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 641CF72D8CD
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 06:53:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 888E81C20C01
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 04:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0085361;
	Tue, 13 Jun 2023 04:53:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8CA210D
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 04:53:37 +0000 (UTC)
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2813195;
	Mon, 12 Jun 2023 21:53:32 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b3a3e34f4cso3517545ad.0;
        Mon, 12 Jun 2023 21:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686632012; x=1689224012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zyUj1AWdXsheW8reIvyb+3Dn5KTj/5V3D/xuksehCWw=;
        b=jX6qxTyWuNgndnObouyeNGDCWQaCjd3bQrcVvQ3tAjRozvTUaI1NeMXwPylcoEXRoy
         IVrmJN//ts2fMUGYTiupk8vhBN8YXH1075w7sTymwGSFK+2iYJ3X3k+CouqZm8NQ324F
         NZK5mjVWT7yGAWTw79uTF63P+1jX+0EA8gcB2yf0SWMwVoMDkB+hywywLNDYqSU21DdB
         TFLk1npI/ASopin68/DUGvCyUS5cnbRkJwNZghfXTZ4Bx+/zWJNBYrOYrcmoX20M4FDF
         qe3o28BtpcP+E35SYSnCpIQn2GKQ2c9OvBgSUIbS0AT2PP6La0UP2zo5qZgjaiYt9Jjl
         bmyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686632012; x=1689224012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zyUj1AWdXsheW8reIvyb+3Dn5KTj/5V3D/xuksehCWw=;
        b=NPzAQIeVo0WNmNcjU91qTqJ7+SbVdh1+XNW585yLpUJxLipWOxwadeSbRPPTzsMuKJ
         5NgzIOLelmAS0y+NTlnDMrdLDPOAiWEUmrT9ocDHMqOMiyX+FaiNo6Cgy/rVGjao7uq6
         7q1iPBz40IXRPcwwFCqEswwxGytYDaq3iRZKuzZbt184yGAt+sjgFzp5brpjnxqshrh6
         7Kde41v96sQxY+XWIWE6Nkf44CqzqH83wR41kmgtSUJ7sb/LAEJ0BmthwDOQQAQR7Mr3
         wqn7P2wi2wVlmtWjjTdN5FCJlQ7xCxcKUdMcfS43BnW2EzxoR3Nt50/ZUfRS2ubvXJWJ
         QQeQ==
X-Gm-Message-State: AC+VfDyDfEK1aoJxmxwQsbNJXV8Ta4u1ppzFOHCneu4e/laeM5U/Dyzn
	584KRJobiPTdCHKYPb7A7QfXdy0rrKJ1S/mW
X-Google-Smtp-Source: ACHHUZ4Brw/YnIsK7lHVPY4nXM/n7mQFsgtoJzewzO989X+La5Krohtu+ymDc6N/G/Yj074Xt9Vr9A==
X-Received: by 2002:a17:902:e748:b0:1a9:6467:aa8d with SMTP id p8-20020a170902e74800b001a96467aa8dmr12844223plf.1.1686632011828;
        Mon, 12 Jun 2023 21:53:31 -0700 (PDT)
Received: from ip-172-30-47-114.us-west-2.compute.internal (ec2-54-68-170-188.us-west-2.compute.amazonaws.com. [54.68.170.188])
        by smtp.gmail.com with ESMTPSA id c5-20020a170902c1c500b001b027221393sm9095249plc.43.2023.06.12.21.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 21:53:31 -0700 (PDT)
From: FUJITA Tomonori <fujita.tomonori@gmail.com>
To: netdev@vger.kernel.org
Cc: rust-for-linux@vger.kernel.org,
	aliceryhl@google.com,
	andrew@lunn.ch,
	miguel.ojeda.sandonis@gmail.com
Subject: [PATCH 1/5] rust: core abstractions for network device drivers
Date: Tue, 13 Jun 2023 13:53:22 +0900
Message-Id: <20230613045326.3938283-2-fujita.tomonori@gmail.com>
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

This patch adds very basic abstractions to implement network device
drivers, corresponds to the kernel's net_device and net_device_ops
structs with support for register_netdev/unregister_netdev functions.

allows the const_maybe_uninit_zeroed feature for
core::mem::MaybeUinit::<T>::zeroed() in const function.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
---
 rust/bindings/bindings_helper.h |   2 +
 rust/helpers.c                  |  16 ++
 rust/kernel/lib.rs              |   3 +
 rust/kernel/net.rs              |   5 +
 rust/kernel/net/dev.rs          | 344 ++++++++++++++++++++++++++++++++
 5 files changed, 370 insertions(+)
 create mode 100644 rust/kernel/net.rs
 create mode 100644 rust/kernel/net/dev.rs

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 3e601ce2548d..468bf606f174 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -7,6 +7,8 @@
  */
 
 #include <linux/errname.h>
+#include <linux/etherdevice.h>
+#include <linux/netdevice.h>
 #include <linux/slab.h>
 #include <linux/refcount.h>
 #include <linux/wait.h>
diff --git a/rust/helpers.c b/rust/helpers.c
index bb594da56137..70d50767ff4e 100644
--- a/rust/helpers.c
+++ b/rust/helpers.c
@@ -24,10 +24,26 @@
 #include <linux/errname.h>
 #include <linux/refcount.h>
 #include <linux/mutex.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
 #include <linux/spinlock.h>
 #include <linux/sched/signal.h>
 #include <linux/wait.h>
 
+#ifdef CONFIG_NET
+void *rust_helper_netdev_priv(const struct net_device *dev)
+{
+	return netdev_priv(dev);
+}
+EXPORT_SYMBOL_GPL(rust_helper_netdev_priv);
+
+void rust_helper_skb_tx_timestamp(struct sk_buff *skb)
+{
+	skb_tx_timestamp(skb);
+}
+EXPORT_SYMBOL_GPL(rust_helper_skb_tx_timestamp);
+#endif
+
 __noreturn void rust_helper_BUG(void)
 {
 	BUG();
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 85b261209977..fc7d048d359d 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -13,6 +13,7 @@
 
 #![no_std]
 #![feature(allocator_api)]
+#![feature(const_maybe_uninit_zeroed)]
 #![feature(coerce_unsized)]
 #![feature(dispatch_from_dyn)]
 #![feature(new_uninit)]
@@ -34,6 +35,8 @@
 pub mod error;
 pub mod init;
 pub mod ioctl;
+#[cfg(CONFIG_NET)]
+pub mod net;
 pub mod prelude;
 pub mod print;
 mod static_assert;
diff --git a/rust/kernel/net.rs b/rust/kernel/net.rs
new file mode 100644
index 000000000000..28fe8f398463
--- /dev/null
+++ b/rust/kernel/net.rs
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Networking core.
+
+pub mod dev;
diff --git a/rust/kernel/net/dev.rs b/rust/kernel/net/dev.rs
new file mode 100644
index 000000000000..d072c81f99ce
--- /dev/null
+++ b/rust/kernel/net/dev.rs
@@ -0,0 +1,344 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Network device.
+//!
+//! C headers: [`include/linux/etherdevice.h`](../../../../include/linux/etherdevice.h),
+//! [`include/linux/ethtool.h`](../../../../include/linux/ethtool.h),
+//! [`include/linux/netdevice.h`](../../../../include/linux/netdevice.h),
+//! [`include/linux/skbuff.h`](../../../../include/linux/skbuff.h),
+//! [`include/uapi/linux/if_link.h`](../../../../include/uapi/linux/if_link.h).
+
+use crate::{bindings, error::*, prelude::vtable, types::ForeignOwnable};
+use {core::ffi::c_void, core::marker::PhantomData};
+
+/// Corresponds to the kernel's `struct net_device`.
+///
+/// # Invariants
+///
+/// The pointer is valid.
+pub struct Device(*mut bindings::net_device);
+
+impl Device {
+    /// Creates a new [`Device`] instance.
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that `ptr` must be valid.
+    unsafe fn from_ptr(ptr: *mut bindings::net_device) -> Self {
+        // INVARIANT: The safety requirements ensure the invariant.
+        Self(ptr)
+    }
+
+    /// Gets a pointer to network device private data.
+    fn priv_data_ptr(&self) -> *const c_void {
+        // SAFETY: The type invariants guarantee that `self.0` is valid.
+        // During the initialization of `Registration` instance, the kernel allocates
+        // contiguous memory for `struct net_device` and a pointer to its private data.
+        // So it's safe to read an address from the returned address from `netdev_priv()`.
+        unsafe { core::ptr::read(bindings::netdev_priv(self.0) as *const *const c_void) }
+    }
+}
+
+// SAFETY: `Device` is just a wrapper for the kernel`s `struct net_device`, which can be used
+// from any thread. `struct net_device` stores a pointer to `DriverData::Data`, which is `Sync`
+// so it's safe to sharing its pointer.
+unsafe impl Send for Device {}
+// SAFETY: `Device` is just a wrapper for the kernel`s `struct net_device`, which can be used
+// from any thread. `struct net_device` stores a pointer to `DriverData::Data`, which is `Sync`,
+// can be used from any thread too.
+unsafe impl Sync for Device {}
+
+/// Trait for device driver specific information.
+///
+/// This data structure is passed to a driver with the operations for `struct net_device`
+/// like `struct net_device_ops`, `struct ethtool_ops`, `struct rtnl_link_ops`, etc.
+pub trait DriverData {
+    /// The object are stored in C object, `struct net_device`.
+    type Data: ForeignOwnable + Send + Sync;
+}
+
+/// Registration structure for a network device driver.
+///
+/// This allocates and owns a `struct net_device` object.
+/// Once the `net_device` object is registered via `register_netdev` function,
+/// the kernel calls various functions such as `struct net_device_ops` operations with
+/// the `net_device` object.
+///
+/// A driver must implement `struct net_device_ops` so the trait for it is tied.
+/// Other operations like `struct ethtool_ops` are optional.
+pub struct Registration<T: DeviceOperations<D>, D: DriverData> {
+    dev: Device,
+    is_registered: bool,
+    _p: PhantomData<(D, T)>,
+}
+
+impl<D: DriverData, T: DeviceOperations<D>> Drop for Registration<T, D> {
+    fn drop(&mut self) {
+        // SAFETY: The type invariants guarantee that `self.dev.0` is valid.
+        unsafe {
+            let _ = D::Data::from_foreign(self.dev.priv_data_ptr());
+            if self.is_registered {
+                bindings::unregister_netdev(self.dev.0);
+            }
+            bindings::free_netdev(self.dev.0);
+        }
+    }
+}
+
+impl<D: DriverData, T: DeviceOperations<D>> Registration<T, D> {
+    /// Creates a new [`Registration`] instance for ethernet device.
+    ///
+    /// A device driver can pass private data.
+    pub fn try_new_ether(tx_queue_size: u32, rx_queue_size: u32, data: D::Data) -> Result<Self> {
+        // SAFETY: FFI call.
+        let ptr = from_err_ptr(unsafe {
+            bindings::alloc_etherdev_mqs(
+                core::mem::size_of::<*const c_void>() as i32,
+                tx_queue_size,
+                rx_queue_size,
+            )
+        })?;
+
+        // SAFETY: `ptr` is valid and non-null since `alloc_etherdev_mqs()`
+        // returned a valid pointer which was null-checked.
+        let dev = unsafe { Device::from_ptr(ptr) };
+        // SAFETY: It's safe to write an address to the returned pointer
+        // from `netdev_priv()` because `alloc_etherdev_mqs()` allocates
+        // contiguous memory for `struct net_device` and a pointer.
+        unsafe {
+            let priv_ptr = bindings::netdev_priv(ptr) as *mut *const c_void;
+            core::ptr::write(priv_ptr, data.into_foreign());
+        }
+        Ok(Registration {
+            dev,
+            is_registered: false,
+            _p: PhantomData,
+        })
+    }
+
+    /// Returns a network device.
+    ///
+    /// A device driver normally configures the device before registration.
+    pub fn dev_get(&mut self) -> &mut Device {
+        &mut self.dev
+    }
+
+    /// Registers a network device.
+    pub fn register(&mut self) -> Result {
+        if self.is_registered {
+            return Err(code::EINVAL);
+        }
+        // SAFETY: The type invariants guarantee that `self.dev.0` is valid.
+        let ret = unsafe {
+            (*self.dev.0).netdev_ops = Self::build_device_ops();
+            bindings::register_netdev(self.dev.0)
+        };
+        if ret != 0 {
+            Err(Error::from_errno(ret))
+        } else {
+            self.is_registered = true;
+            Ok(())
+        }
+    }
+
+    const DEVICE_OPS: bindings::net_device_ops = bindings::net_device_ops {
+        ndo_init: if <T>::HAS_INIT {
+            Some(Self::init_callback)
+        } else {
+            None
+        },
+        ndo_uninit: if <T>::HAS_UNINIT {
+            Some(Self::uninit_callback)
+        } else {
+            None
+        },
+        ndo_open: if <T>::HAS_OPEN {
+            Some(Self::open_callback)
+        } else {
+            None
+        },
+        ndo_stop: if <T>::HAS_STOP {
+            Some(Self::stop_callback)
+        } else {
+            None
+        },
+        ndo_start_xmit: if <T>::HAS_START_XMIT {
+            Some(Self::start_xmit_callback)
+        } else {
+            None
+        },
+        // SAFETY: The rest is zeroed out to initialize `struct net_device_ops`,
+        // set `Option<&F>` to be `None`.
+        ..unsafe { core::mem::MaybeUninit::<bindings::net_device_ops>::zeroed().assume_init() }
+    };
+
+    const fn build_device_ops() -> &'static bindings::net_device_ops {
+        &Self::DEVICE_OPS
+    }
+
+    unsafe extern "C" fn init_callback(netdev: *mut bindings::net_device) -> core::ffi::c_int {
+        from_result(|| {
+            // SAFETY: The C API guarantees that `netdev` is valid while this function is running.
+            let mut dev = unsafe { Device::from_ptr(netdev) };
+            // SAFETY: The returned pointer was initialized by `D::Data::into_foreign` when
+            // `Registration` object was created.
+            // `D::Data::from_foreign` is only called by the object was released.
+            // So we know `data` is valid while this function is running.
+            let data = unsafe { D::Data::borrow(dev.priv_data_ptr()) };
+            T::init(&mut dev, data)?;
+            Ok(0)
+        })
+    }
+
+    unsafe extern "C" fn uninit_callback(netdev: *mut bindings::net_device) {
+        // SAFETY: The C API guarantees that `netdev` is valid while this function is running.
+        let mut dev = unsafe { Device::from_ptr(netdev) };
+        // SAFETY: The returned pointer was initialized by `D::Data::into_foreign` when
+        // `Registration` object was created.
+        // `D::Data::from_foreign` is only called by the object was released.
+        // So we know `data` is valid while this function is running.
+        let data = unsafe { D::Data::borrow(dev.priv_data_ptr()) };
+        T::uninit(&mut dev, data);
+    }
+
+    unsafe extern "C" fn open_callback(netdev: *mut bindings::net_device) -> core::ffi::c_int {
+        from_result(|| {
+            // SAFETY: The C API guarantees that `netdev` is valid while this function is running.
+            let mut dev = unsafe { Device::from_ptr(netdev) };
+            // SAFETY: The returned pointer was initialized by `D::Data::into_foreign` when
+            // `Registration` object was created.
+            // `D::Data::from_foreign` is only called by the object was released.
+            // So we know `data` is valid while this function is running.
+            let data = unsafe { D::Data::borrow(dev.priv_data_ptr()) };
+            T::open(&mut dev, data)?;
+            Ok(0)
+        })
+    }
+
+    unsafe extern "C" fn stop_callback(netdev: *mut bindings::net_device) -> core::ffi::c_int {
+        from_result(|| {
+            // SAFETY: The C API guarantees that `netdev` is valid while this function is running.
+            let mut dev = unsafe { Device::from_ptr(netdev) };
+            // SAFETY: The returned pointer was initialized by `D::Data::into_foreign` when
+            // `Registration` object was created.
+            // `D::Data::from_foreign` is only called by the object was released.
+            // So we know `data` is valid while this function is running.
+            let data = unsafe { D::Data::borrow(dev.priv_data_ptr()) };
+            T::stop(&mut dev, data)?;
+            Ok(0)
+        })
+    }
+
+    unsafe extern "C" fn start_xmit_callback(
+        skb: *mut bindings::sk_buff,
+        netdev: *mut bindings::net_device,
+    ) -> bindings::netdev_tx_t {
+        // SAFETY: The C API guarantees that `netdev` is valid while this function is running.
+        let mut dev = unsafe { Device::from_ptr(netdev) };
+        // SAFETY: The returned pointer was initialized by `D::Data::into_foreign` when
+        // `Registration` object was created.
+        // `D::Data::from_foreign` is only called by the object was released.
+        // So we know `data` is valid while this function is running.
+        let data = unsafe { D::Data::borrow(dev.priv_data_ptr()) };
+        // SAFETY: The C API guarantees that `skb` is valid while this function is running.
+        let skb = unsafe { SkBuff::from_ptr(skb) };
+        T::start_xmit(&mut dev, data, skb) as bindings::netdev_tx_t
+    }
+}
+
+// SAFETY: `Registration` exposes only `Device` object which can be used from
+// any thread.
+unsafe impl<D: DriverData, T: DeviceOperations<D>> Send for Registration<T, D> {}
+// SAFETY: `Registration` exposes only `Device` object which can be used from
+// any thread.
+unsafe impl<D: DriverData, T: DeviceOperations<D>> Sync for Registration<T, D> {}
+
+/// Corresponds to the kernel's `enum netdev_tx`.
+#[repr(i32)]
+pub enum TxCode {
+    /// Driver took care of packet.
+    Ok = bindings::netdev_tx_NETDEV_TX_OK,
+    /// Driver tx path was busy.
+    Busy = bindings::netdev_tx_NETDEV_TX_BUSY,
+}
+
+/// Corresponds to the kernel's `struct net_device_ops`.
+///
+/// A device driver must implement this. Only very basic operations are supported for now.
+#[vtable]
+pub trait DeviceOperations<D: DriverData> {
+    /// Corresponds to `ndo_init` in `struct net_device_ops`.
+    fn init(_dev: &mut Device, _data: <D::Data as ForeignOwnable>::Borrowed<'_>) -> Result {
+        Ok(())
+    }
+
+    /// Corresponds to `ndo_uninit` in `struct net_device_ops`.
+    fn uninit(_dev: &mut Device, _data: <D::Data as ForeignOwnable>::Borrowed<'_>) {}
+
+    /// Corresponds to `ndo_open` in `struct net_device_ops`.
+    fn open(_dev: &mut Device, _data: <D::Data as ForeignOwnable>::Borrowed<'_>) -> Result {
+        Ok(())
+    }
+
+    /// Corresponds to `ndo_stop` in `struct net_device_ops`.
+    fn stop(_dev: &mut Device, _data: <D::Data as ForeignOwnable>::Borrowed<'_>) -> Result {
+        Ok(())
+    }
+
+    /// Corresponds to `ndo_start_xmit` in `struct net_device_ops`.
+    fn start_xmit(
+        _dev: &mut Device,
+        _data: <D::Data as ForeignOwnable>::Borrowed<'_>,
+        _skb: SkBuff,
+    ) -> TxCode {
+        TxCode::Busy
+    }
+}
+
+/// Corresponds to the kernel's `struct sk_buff`.
+///
+/// A driver manages `struct sk_buff` in two ways. In both ways, the ownership is transferred
+/// between C and Rust. The allocation and release are done asymmetrically.
+///
+/// On the tx side (`ndo_start_xmit` operation in `struct net_device_ops`), the kernel allocates
+/// a `sk_buff' object and passes it to the driver. The driver is responsible for the release
+/// after transmission.
+/// On the rx side, the driver allocates a `sk_buff` object then passes it to the kernel
+/// after receiving data.
+///
+/// # Invariants
+///
+/// The pointer is valid.
+pub struct SkBuff(*mut bindings::sk_buff);
+
+impl SkBuff {
+    /// Creates a new [`SkBuff`] instance.
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that `ptr` must be valid.
+    unsafe fn from_ptr(ptr: *mut bindings::sk_buff) -> Self {
+        // INVARIANT: The safety requirements ensure the invariant.
+        Self(ptr)
+    }
+
+    /// Provides a time stamp.
+    pub fn tx_timestamp(&mut self) {
+        // SAFETY: The type invariants guarantee that `self.0` is valid.
+        unsafe {
+            bindings::skb_tx_timestamp(self.0);
+        }
+    }
+}
+
+impl Drop for SkBuff {
+    fn drop(&mut self) {
+        // SAFETY: The type invariants guarantee that `self.0` is valid.
+        unsafe {
+            bindings::kfree_skb_reason(
+                self.0,
+                bindings::skb_drop_reason_SKB_DROP_REASON_NOT_SPECIFIED,
+            )
+        }
+    }
+}
-- 
2.34.1


