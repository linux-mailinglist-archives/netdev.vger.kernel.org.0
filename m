Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFB947F4BD
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 00:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbhLYXmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Dec 2021 18:42:32 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:36664 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhLYXmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Dec 2021 18:42:31 -0500
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 2F7A772C8FC;
        Sun, 26 Dec 2021 02:42:30 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id 2071C7CC8C5; Sun, 26 Dec 2021 02:42:30 +0300 (MSK)
Date:   Sun, 26 Dec 2021 02:42:30 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH resend] uapi: fix linux/nfc.h userspace compilation errors
Message-ID: <20211225234229.GA5025@altlinux.org>
References: <20170220181613.GB11185@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170220181613.GB11185@altlinux.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace sa_family_t with __kernel_sa_family_t to fix the following
linux/nfc.h userspace compilation errors:

/usr/include/linux/nfc.h:266:2: error: unknown type name 'sa_family_t'
  sa_family_t sa_family;
/usr/include/linux/nfc.h:274:2: error: unknown type name 'sa_family_t'
  sa_family_t sa_family;

Link: https://lore.kernel.org/lkml/20170220181613.GB11185@altlinux.org/
Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
---
 The patch was submitted almost 5 years ago, and I was under impression
 that it was applied among others of this kind, but, apparently,
 it's still relevant.

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
