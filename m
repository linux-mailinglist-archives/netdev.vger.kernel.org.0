Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17B21C1824
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbgEAOpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:45:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729185AbgEAOpG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:06 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF5962173E;
        Fri,  1 May 2020 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344305;
        bh=BbJSuVHr+5IYyFuJdvZiLliVMl8TXc8u3OKr+XoJgqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ek4Fs5EnMWY9KkNiiDgeipm6HTU2HAI16If947ALxxpfJXokfVVs7rV7eRn0tRPdf
         oQ4R6M18YVWCsPxSda4EXXZSJFR6Tykdmv1+vIwTThnplL9eCCZfL2SzSyYLhFZv5x
         WXAiSuegzPKkTKwT9vLXtoV6mEnoULa82hIa/jMQ=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuT-00FCcx-D7; Fri, 01 May 2020 16:45:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 07/37] docs: networking: convert xfrm_device.txt to ReST
Date:   Fri,  1 May 2020 16:44:29 +0200
Message-Id: <0977c0a0683059dabe314ceb543d3e8f0abbc506.1588344146.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588344146.git.mchehab+huawei@kernel.org>
References: <cover.1588344146.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- mark code blocks and literals as such;
- mark tables as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |  1 +
 .../{xfrm_device.txt => xfrm_device.rst}      | 33 ++++++++++++-------
 2 files changed, 23 insertions(+), 11 deletions(-)
 rename Documentation/networking/{xfrm_device.txt => xfrm_device.rst} (92%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 75521e6c473b..e31f6cb564b4 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -117,6 +117,7 @@ Contents:
    vxlan
    x25-iface
    x25
+   xfrm_device
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/xfrm_device.txt b/Documentation/networking/xfrm_device.rst
similarity index 92%
rename from Documentation/networking/xfrm_device.txt
rename to Documentation/networking/xfrm_device.rst
index a1c904dc70dc..da1073acda96 100644
--- a/Documentation/networking/xfrm_device.txt
+++ b/Documentation/networking/xfrm_device.rst
@@ -1,7 +1,9 @@
+.. SPDX-License-Identifier: GPL-2.0
 
 ===============================================
 XFRM device - offloading the IPsec computations
 ===============================================
+
 Shannon Nelson <shannon.nelson@oracle.com>
 
 
@@ -19,7 +21,7 @@ hardware offload.
 Userland access to the offload is typically through a system such as
 libreswan or KAME/raccoon, but the iproute2 'ip xfrm' command set can
 be handy when experimenting.  An example command might look something
-like this:
+like this::
 
   ip x s add proto esp dst 14.0.0.70 src 14.0.0.52 spi 0x07 mode transport \
      reqid 0x07 replay-window 32 \
@@ -34,15 +36,17 @@ Yes, that's ugly, but that's what shell scripts and/or libreswan are for.
 Callbacks to implement
 ======================
 
-/* from include/linux/netdevice.h */
-struct xfrmdev_ops {
+::
+
+  /* from include/linux/netdevice.h */
+  struct xfrmdev_ops {
 	int	(*xdo_dev_state_add) (struct xfrm_state *x);
 	void	(*xdo_dev_state_delete) (struct xfrm_state *x);
 	void	(*xdo_dev_state_free) (struct xfrm_state *x);
 	bool	(*xdo_dev_offload_ok) (struct sk_buff *skb,
 				       struct xfrm_state *x);
 	void    (*xdo_dev_state_advance_esn) (struct xfrm_state *x);
-};
+  };
 
 The NIC driver offering ipsec offload will need to implement these
 callbacks to make the offload available to the network stack's
@@ -58,6 +62,8 @@ At probe time and before the call to register_netdev(), the driver should
 set up local data structures and XFRM callbacks, and set the feature bits.
 The XFRM code's listener will finish the setup on NETDEV_REGISTER.
 
+::
+
 		adapter->netdev->xfrmdev_ops = &ixgbe_xfrmdev_ops;
 		adapter->netdev->features |= NETIF_F_HW_ESP;
 		adapter->netdev->hw_enc_features |= NETIF_F_HW_ESP;
@@ -65,16 +71,20 @@ The XFRM code's listener will finish the setup on NETDEV_REGISTER.
 When new SAs are set up with a request for "offload" feature, the
 driver's xdo_dev_state_add() will be given the new SA to be offloaded
 and an indication of whether it is for Rx or Tx.  The driver should
+
 	- verify the algorithm is supported for offloads
 	- store the SA information (key, salt, target-ip, protocol, etc)
 	- enable the HW offload of the SA
 	- return status value:
+
+		===========   ===================================
 		0             success
 		-EOPNETSUPP   offload not supported, try SW IPsec
 		other         fail the request
+		===========   ===================================
 
 The driver can also set an offload_handle in the SA, an opaque void pointer
-that can be used to convey context into the fast-path offload requests.
+that can be used to convey context into the fast-path offload requests::
 
 		xs->xso.offload_handle = context;
 
@@ -88,7 +98,7 @@ return true of false to signify its support.
 
 When ready to send, the driver needs to inspect the Tx packet for the
 offload information, including the opaque context, and set up the packet
-send accordingly.
+send accordingly::
 
 		xs = xfrm_input_state(skb);
 		context = xs->xso.offload_handle;
@@ -105,18 +115,21 @@ the packet's skb.  At this point the data should be decrypted but the
 IPsec headers are still in the packet data; they are removed later up
 the stack in xfrm_input().
 
-	find and hold the SA that was used to the Rx skb
+	find and hold the SA that was used to the Rx skb::
+
 		get spi, protocol, and destination IP from packet headers
 		xs = find xs from (spi, protocol, dest_IP)
 		xfrm_state_hold(xs);
 
-	store the state information into the skb
+	store the state information into the skb::
+
 		sp = secpath_set(skb);
 		if (!sp) return;
 		sp->xvec[sp->len++] = xs;
 		sp->olen++;
 
-	indicate the success and/or error status of the offload
+	indicate the success and/or error status of the offload::
+
 		xo = xfrm_offload(skb);
 		xo->flags = CRYPTO_DONE;
 		xo->status = crypto_status;
@@ -136,5 +149,3 @@ hardware needs.
 As a netdev is set to DOWN the XFRM stack's netdev listener will call
 xdo_dev_state_delete() and xdo_dev_state_free() on any remaining offloaded
 states.
-
-
-- 
2.25.4

