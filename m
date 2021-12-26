Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6720247F6DD
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 14:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbhLZNB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 08:01:29 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:44210 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbhLZNB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 08:01:28 -0500
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 4102872C8FC;
        Sun, 26 Dec 2021 16:01:27 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id 33A5B7CCA16; Sun, 26 Dec 2021 16:01:27 +0300 (MSK)
Date:   Sun, 26 Dec 2021 16:01:27 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] uapi: fix linux/nfc.h userspace compilation errors
Message-ID: <20211226130126.GA13003@altlinux.org>
References: <20170220181613.GB11185@altlinux.org>
 <20211225234229.GA5025@altlinux.org>
 <3d0af5ae-0510-8610-dfc2-b8e5ff682959@canonical.com>
 <3a89b2cf-33e4-7938-08e3-348b655493d7@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a89b2cf-33e4-7938-08e3-348b655493d7@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace sa_family_t with __kernel_sa_family_t to fix the following
linux/nfc.h userspace compilation errors:

/usr/include/linux/nfc.h:266:2: error: unknown type name 'sa_family_t'
  sa_family_t sa_family;
/usr/include/linux/nfc.h:274:2: error: unknown type name 'sa_family_t'
  sa_family_t sa_family;

Fixes: 23b7869c0fd0 ("NFC: add the NFC socket raw protocol")
Fixes: d646960f7986 ("NFC: Initial LLCP support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
---
 v2: Removed Link tag, added Fixes and Cc tags.

 include/uapi/linux/nfc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/nfc.h b/include/uapi/linux/nfc.h
index f6e3c8c9c744..aadad43d943a 100644
--- a/include/uapi/linux/nfc.h
+++ b/include/uapi/linux/nfc.h
@@ -263,7 +263,7 @@ enum nfc_sdp_attr {
 #define NFC_SE_ENABLED  0x1
 
 struct sockaddr_nfc {
-	sa_family_t sa_family;
+	__kernel_sa_family_t sa_family;
 	__u32 dev_idx;
 	__u32 target_idx;
 	__u32 nfc_protocol;
@@ -271,7 +271,7 @@ struct sockaddr_nfc {
 
 #define NFC_LLCP_MAX_SERVICE_NAME 63
 struct sockaddr_nfc_llcp {
-	sa_family_t sa_family;
+	__kernel_sa_family_t sa_family;
 	__u32 dev_idx;
 	__u32 target_idx;
 	__u32 nfc_protocol;

-- 
ldv
