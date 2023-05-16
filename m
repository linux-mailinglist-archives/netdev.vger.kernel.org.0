Return-Path: <netdev+bounces-3055-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61BA27054B5
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:09:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23BAF280F90
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 17:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C14B101C9;
	Tue, 16 May 2023 17:09:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E14934CD7
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 17:09:01 +0000 (UTC)
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6C43A99;
	Tue, 16 May 2023 10:08:59 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-559f1819c5dso209238577b3.0;
        Tue, 16 May 2023 10:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684256938; x=1686848938;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IoZfVLATXsKVHHcpu7CsyMOzTw/I5V1LB+e9jNjQDEs=;
        b=VgPL0KLbiVS1VMFwI/dFRr08PMpKPAm6+wBWT6vyBjzgKvYsmSh1ByxYiHJR4pH9A2
         xAAH++r59FVdWOvzXiKSqKis5H7rRd1/tm+x7GSqVui0Zt205p7T31mUvFDcR0DBkwud
         G+wg+sarj9RJu3Q0ty+Rrq1IR+YUfMtu/vsxP8stctpS08q0+TRFEhPWzXVVMD8jp6xV
         u3XWEQ6NFGLWEc7nDVErn12GWGVEIm6AiELQuk+c609d0Ko46gN36Zb6D4N5gO3eDzTC
         V3SxGh9E5G8pDebJNms/Sc7jeI3uyAJ2NU9yNl2yI3b7yMQ8viOeJYYWlDYgJvqiG7+/
         xutQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684256938; x=1686848938;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IoZfVLATXsKVHHcpu7CsyMOzTw/I5V1LB+e9jNjQDEs=;
        b=fOSAUL7wLXx3Ape4hY4MVZI75UeVc/K8xTbuMOAa7oIVLf5u+yYa4kr/r1R55zb4A0
         cO7LRG6aB8OAJYp0N1mHNnxQdqWpCJBk8ejyf/6TIrZwsJaCmTGmwKq/NJFjn+veWa34
         N6ckdn7HdPmAQu0ZuWQTIJkRSEBx2NsB31b1/1PZpjxhVbDFx7JfA0IrKkD0Oa6JqFaP
         CxEU9lRS+VnwIODhq703rNTEsAcI61Pus8nrxkPXCGAFO0EZRXuKoe2uK5zQi82TsElB
         HwrI/fmqnMIWZ/VkZnPBgOhjkhtdep6p8bQi5uMcaiEw1mIpCPIr4YaM70VJQ+XJRCgZ
         mE9Q==
X-Gm-Message-State: AC+VfDwRZUzpNnPdZntDoRFfDjLxjUFUkAHM42jIa6JiCa3HavqJqDBT
	Zv5apiNrghUPKgeq5LoSSGRQWQVrVwZGsZUM1Vg=
X-Google-Smtp-Source: ACHHUZ7B0Mro9qr/cbLq12TPKgf0LmWyhGW0MAwVaP1i2Ljqood6CeQnJWO3EE7TAxGHdJh4qqHKaN/eR4d//RZqOa8=
X-Received: by 2002:a81:a511:0:b0:556:c778:9d60 with SMTP id
 u17-20020a81a511000000b00556c7789d60mr34897031ywg.43.1684256938346; Tue, 16
 May 2023 10:08:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230515043353.2324288-1-tomo@exabit.dev> <010101881db03866-754b644c-682c-44be-8d8e-8376d34c77b3-000000@us-west-2.amazonses.com>
In-Reply-To: <010101881db03866-754b644c-682c-44be-8d8e-8376d34c77b3-000000@us-west-2.amazonses.com>
From: Wedson Almeida Filho <wedsonaf@gmail.com>
Date: Tue, 16 May 2023 14:08:47 -0300
Message-ID: <CANeycqohNOf38MDw4mybzBib2Apu=7b_6qn_1oykm70zMVvKrw@mail.gmail.com>
Subject: Re: [PATCH 2/2] rust: add socket support
To: FUJITA Tomonori <tomo@exabit.dev>
Cc: rust-for-linux@vger.kernel.org, netdev@vger.kernel.org, 
	linux-crypto@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 15 May 2023 at 02:45, FUJITA Tomonori <tomo@exabit.dev> wrote:
>
> From: FUJITA Tomonori <fujita.tomonori@gmail.com>
>
> minimum abstraction for networking.
>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
> ---
>  rust/bindings/bindings_helper.h |   3 +
>  rust/kernel/lib.rs              |   2 +
>  rust/kernel/net.rs              | 174 ++++++++++++++++++++++++++++++++
>  3 files changed, 179 insertions(+)
>  create mode 100644 rust/kernel/net.rs

Fujita, thanks for this.

We have basic networking support in the `rust` branch. In fact, we
also have support for async networking in there as well. For example,
the 9p server uses it.

At the moment we're prioritizing upstreaming the pieces for which we
have projects waiting. Do you have an _actual_ user in mind for this?

In any case, let's please start with that instead of a brand-new
reimplementation.

Cheers,
-Wedson

> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
> index 65683b9aa45d..7cbb5dd96bf6 100644
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
> @@ -7,8 +7,11 @@
>   */
>
>  #include <crypto/hash.h>
> +#include <linux/net.h>
>  #include <linux/slab.h>
>  #include <linux/refcount.h>
> +#include <linux/socket.h>
> +#include <linux/tcp.h>
>  #include <linux/wait.h>
>  #include <linux/sched.h>
>
> diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> index 753fd62b84f1..42dbef3d9e88 100644
> --- a/rust/kernel/lib.rs
> +++ b/rust/kernel/lib.rs
> @@ -40,6 +40,8 @@ pub mod crypto;
>  pub mod error;
>  pub mod init;
>  pub mod ioctl;
> +#[cfg(CONFIG_NET)]
> +pub mod net;
>  pub mod prelude;
>  pub mod print;
>  mod static_assert;
> diff --git a/rust/kernel/net.rs b/rust/kernel/net.rs
> new file mode 100644
> index 000000000000..204b5222abdc
> --- /dev/null
> +++ b/rust/kernel/net.rs
> @@ -0,0 +1,174 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +//! Networking.
> +//!
> +//! C headers: [`include/linux/net.h`](../../../../include/linux/net.h),
> +//! [`include/linux/socket.h`](../../../../include/linux/socket.h),
> +
> +use crate::{
> +    bindings,
> +    error::{to_result, Result},
> +};
> +use alloc::vec::Vec;
> +
> +/// Represents `struct socket *`.
> +///
> +/// # Invariants
> +///
> +/// The pointer is valid.
> +pub struct Socket {
> +    pub(crate) sock: *mut bindings::socket,
> +}
> +
> +impl Drop for Socket {
> +    fn drop(&mut self) {
> +        // SAFETY: The type invariant guarantees that the pointer is valid.
> +        unsafe { bindings::sock_release(self.sock) }
> +    }
> +}
> +
> +/// Address families. Defines AF_* here.
> +pub enum Family {
> +    /// Internet IP Protocol.
> +    Ip = bindings::AF_INET as isize,
> +}
> +
> +/// Communication type.
> +pub enum SocketType {
> +    /// Stream (connection).
> +    Stream = bindings::sock_type_SOCK_STREAM as isize,
> +}
> +
> +/// Protocols.
> +pub enum Protocol {
> +    /// Transmission Control Protocol.
> +    Tcp = bindings::IPPROTO_TCP as isize,
> +}
> +
> +impl Socket {
> +    /// Creates a [`Socket`] object.
> +    pub fn new(family: Family, sf: SocketType, proto: Protocol) -> Result<Self> {
> +        let mut sock = core::ptr::null_mut();
> +
> +        // SAFETY: FFI call.
> +        to_result(unsafe {
> +            bindings::sock_create_kern(
> +                &mut bindings::init_net,
> +                family as _,
> +                sf as _,
> +                proto as _,
> +                &mut sock,
> +            )
> +        })
> +        .map(|_| Socket { sock })
> +    }
> +
> +    /// Moves a socket to listening state.
> +    pub fn listen(&mut self, backlog: i32) -> Result {
> +        // SAFETY: The type invariant guarantees that the pointer is valid.
> +        to_result(unsafe { bindings::kernel_listen(self.sock, backlog) })
> +    }
> +
> +    /// Binds an address to a socket.
> +    pub fn bind(&mut self, addr: &SocketAddr) -> Result {
> +        let (addr, addrlen) = match addr {
> +            SocketAddr::V4(addr) => (
> +                addr as *const _ as _,
> +                core::mem::size_of::<bindings::sockaddr>() as i32,
> +            ),
> +        };
> +        // SAFETY: The type invariant guarantees that the pointer is valid.
> +        to_result(unsafe { bindings::kernel_bind(self.sock, addr, addrlen) })
> +    }
> +
> +    /// Accepts a connection
> +    pub fn accept(&mut self) -> Result<Self> {
> +        let mut client = core::ptr::null_mut();
> +        // SAFETY: The type invariant guarantees that the pointer is valid.
> +        to_result(unsafe { bindings::kernel_accept(self.sock, &mut client, 0) })
> +            .map(|_| Socket { sock: client })
> +    }
> +
> +    /// Receives a message from a socket.
> +    pub fn recvmsg(&mut self, bufs: &mut [&mut [u8]], flags: i32) -> Result<usize> {
> +        let mut msg = bindings::msghdr::default();
> +        let mut kvec = Vec::try_with_capacity(bufs.len())?;
> +        let mut len = 0;
> +        for i in 0..bufs.len() {
> +            len += bufs[i].len();
> +            kvec.try_push(bindings::kvec {
> +                iov_base: bufs[i].as_mut_ptr().cast(),
> +                iov_len: bufs[i].len(),
> +            })?;
> +        }
> +        // SAFETY: The type invariant guarantees that the pointer is valid.
> +        let r = unsafe {
> +            bindings::kernel_recvmsg(
> +                self.sock,
> +                &mut msg,
> +                kvec.as_mut_ptr(),
> +                bufs.len(),
> +                len,
> +                flags,
> +            )
> +        };
> +        to_result(r).map(|_| r as usize)
> +    }
> +
> +    /// Sends a message through a socket.
> +    pub fn sendmsg(&mut self, bufs: &[&[u8]]) -> Result<usize> {
> +        let mut msg = bindings::msghdr::default();
> +        let mut kvec = Vec::try_with_capacity(bufs.len())?;
> +        let mut len = 0;
> +        for i in 0..bufs.len() {
> +            len += bufs[i].len();
> +            kvec.try_push(bindings::kvec {
> +                iov_base: bufs[i].as_ptr() as *mut u8 as _,
> +                iov_len: bufs[i].len(),
> +            })?;
> +        }
> +        // SAFETY: The type invariant guarantees that the pointer is valid.
> +        let r = unsafe {
> +            bindings::kernel_sendmsg(self.sock, &mut msg, kvec.as_mut_ptr(), bufs.len(), len)
> +        };
> +        to_result(r).map(|_| r as usize)
> +    }
> +}
> +
> +/// A socket address.
> +pub enum SocketAddr {
> +    /// An IPv4 socket address.
> +    V4(SocketAddrV4),
> +}
> +
> +/// Represents `struct in_addr`.
> +#[repr(transparent)]
> +pub struct Ipv4Addr(bindings::in_addr);
> +
> +impl Ipv4Addr {
> +    /// Creates a new IPv4 address from four eight-bit octets.
> +    pub const fn new(a: u8, b: u8, c: u8, d: u8) -> Self {
> +        Self(bindings::in_addr {
> +            s_addr: u32::from_be_bytes([a, b, c, d]).to_be(),
> +        })
> +    }
> +}
> +
> +/// Prepresents `struct sockaddr_in`.
> +#[repr(transparent)]
> +pub struct SocketAddrV4(bindings::sockaddr_in);
> +
> +impl SocketAddrV4 {
> +    /// Creates a new IPv4 socket address.
> +    pub const fn new(addr: Ipv4Addr, port: u16) -> Self {
> +        Self(bindings::sockaddr_in {
> +            sin_family: Family::Ip as _,
> +            sin_port: port.to_be(),
> +            sin_addr: addr.0,
> +            __pad: [0; 8],
> +        })
> +    }
> +}
> +
> +/// Waits for a full request
> +pub const MSG_WAITALL: i32 = bindings::MSG_WAITALL as i32;
> --
> 2.34.1
>

