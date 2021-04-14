Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4A435F03B
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 11:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350205AbhDNJBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 05:01:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56326 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350246AbhDNJAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 05:00:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618390729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jlnZwcw+mxLXWda0HYhbEoeQ7agY7cub5GyZAaXsC1s=;
        b=Crz5isC1KK+YJ2aKwv0viJR7JAs26IFYjUtYdmV5BlHgxgsf+UToOdbigR2OCwGHq0OfIb
        WgQrsA6tkkml6xXXC6AZnzuVu9QbAi7plRBcLjAkhyKLBAcCo1LwLZamIjeaPnupBJugHn
        6qkEUYytE9K1L2alghY/R6ff7s3O+2Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-BinsS_SQNfC2qh-O4LuB6g-1; Wed, 14 Apr 2021 04:58:47 -0400
X-MC-Unique: BinsS_SQNfC2qh-O4LuB6g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A07680A19E;
        Wed, 14 Apr 2021 08:58:45 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-67.rdu2.redhat.com [10.10.112.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 634395D76F;
        Wed, 14 Apr 2021 08:58:43 +0000 (UTC)
From:   Nico Pache <npache@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     brendanhiggins@google.com, gregkh@linuxfoundation.org,
        linux-ext4@vger.kernel.org, netdev@vger.kernel.org,
        rafael@kernel.org, npache@redhat.com,
        linux-m68k@lists.linux-m68k.org, geert@linux-m68k.org,
        tytso@mit.edu, mathew.j.martineau@linux.intel.com,
        davem@davemloft.net, broonie@kernel.org, davidgow@google.com,
        skhan@linuxfoundation.org, mptcp@lists.linux.dev
Subject: [PATCH v2 4/6] kunit: lib: adhear to KUNIT formatting standard
Date:   Wed, 14 Apr 2021 04:58:07 -0400
Message-Id: <f427ed5cbc08da83086c504fbb3ad1bab50340cd.1618388989.git.npache@redhat.com>
In-Reply-To: <cover.1618388989.git.npache@redhat.com>
References: <cover.1618388989.git.npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change config names inorder to adhear to the KUNIT *KUNIT_TEST config
name format.

Add 'if !KUNIT_ALL_TESTS' to the KUNIT config tristates inorder to
adhear to the KUNIT standard.

add 'default KUNIT_ALL_TESTS' to the KUNIT config options inorder
to adhear to the KUNIT standard.

Fixes: 6d511020e13d (lib/test_bits.c: add tests of GENMASK)
Fixes: d2585f5164c2 (lib: kunit: add bitfield test conversion to KUnit)
Fixes: 33d599f05299 (lib/test_linear_ranges: add a test for the 'linear_ranges')
Signed-off-by: Nico Pache <npache@redhat.com>
---
 lib/Kconfig.debug | 21 +++++++++++++--------
 lib/Makefile      |  6 +++---
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 417c3d3e521b..e7a5f4cc6de1 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2279,9 +2279,10 @@ config TEST_SYSCTL
 
 	  If unsure, say N.
 
-config BITFIELD_KUNIT
-	tristate "KUnit test bitfield functions at runtime"
+config BITFIELD_KUNIT_TEST
+	tristate "KUnit test bitfield functions at runtime" if !KUNIT_ALL_TESTS
 	depends on KUNIT
+	default KUNIT_ALL_TESTS
 	help
 	  Enable this option to test the bitfield functions at boot.
 
@@ -2296,8 +2297,9 @@ config BITFIELD_KUNIT
 	  If unsure, say N.
 
 config RESOURCE_KUNIT_TEST
-	tristate "KUnit test for resource API"
+	tristate "KUnit test for resource API" if !KUNIT_ALL_TESTS
 	depends on KUNIT
+	default KUNIT_ALL_TESTS
 	help
 	  This builds the resource API unit test.
 	  Tests the logic of API provided by resource.c and ioport.h.
@@ -2337,9 +2339,10 @@ config LIST_KUNIT_TEST
 
 	  If unsure, say N.
 
-config LINEAR_RANGES_TEST
-	tristate "KUnit test for linear_ranges"
+config LINEAR_RANGES_KUNIT_TEST
+	tristate "KUnit test for linear_ranges" if !KUNIT_ALL_TESTS
 	depends on KUNIT
+	default KUNIT_ALL_TESTS
 	select LINEAR_RANGES
 	help
 	  This builds the linear_ranges unit test, which runs on boot.
@@ -2350,8 +2353,9 @@ config LINEAR_RANGES_TEST
 	  If unsure, say N.
 
 config CMDLINE_KUNIT_TEST
-	tristate "KUnit test for cmdline API"
+	tristate "KUnit test for cmdline API" if !KUNIT_ALL_TESTS
 	depends on KUNIT
+	default KUNIT_ALL_TESTS
 	help
 	  This builds the cmdline API unit test.
 	  Tests the logic of API provided by cmdline.c.
@@ -2360,9 +2364,10 @@ config CMDLINE_KUNIT_TEST
 
 	  If unsure, say N.
 
-config BITS_TEST
-	tristate "KUnit test for bits.h"
+config BITS_KUNIT_TEST
+	tristate "KUnit test for bits.h" if !KUNIT_ALL_TESTS
 	depends on KUNIT
+	default KUNIT_ALL_TESTS
 	help
 	  This builds the bits unit test.
 	  Tests the logic of macros defined in bits.h.
diff --git a/lib/Makefile b/lib/Makefile
index b5307d3eec1a..ffa749c3b6e4 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -347,10 +347,10 @@ obj-$(CONFIG_OBJAGG) += objagg.o
 obj-$(CONFIG_PLDMFW) += pldmfw/
 
 # KUnit tests
-obj-$(CONFIG_BITFIELD_KUNIT) += bitfield_kunit.o
+obj-$(CONFIG_BITFIELD_KUNIT_TEST) += bitfield_kunit.o
 obj-$(CONFIG_LIST_KUNIT_TEST) += list-test.o
-obj-$(CONFIG_LINEAR_RANGES_TEST) += test_linear_ranges.o
-obj-$(CONFIG_BITS_TEST) += test_bits.o
+obj-$(CONFIG_LINEAR_RANGES_KUNIT_TEST) += test_linear_ranges.o
+obj-$(CONFIG_BITS_KUNIT_TEST) += test_bits.o
 obj-$(CONFIG_CMDLINE_KUNIT_TEST) += cmdline_kunit.o
 
 obj-$(CONFIG_GENERIC_LIB_DEVMEM_IS_ALLOWED) += devmem_is_allowed.o
-- 
2.30.2

