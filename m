Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00872CCDC2
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 05:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgLCELq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 23:11:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:41078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726977AbgLCELq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 23:11:46 -0500
From:   David Ahern <dsahern@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     netdev@vger.kernel.org
Cc:     me@pmachata.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next] Only compile mnl_utils when HAVE_LIBMNL is defined
Date:   Wed,  2 Dec 2020 21:11:01 -0700
Message-Id: <20201203041101.11116-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

New lib/mnl_utils.c fails to compile if libmnl is not installed:

  mnl_utils.c:9:10: fatal error: libmnl/libmnl.h: No such file or directory
      9 | #include <libmnl/libmnl.h>

Make it dependent on HAVE_LIBMNL.

Fixes: 72858c7b77d0 ("lib: Extract from devlink/mnlg a helper, mnlu_socket_open()")
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 lib/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/Makefile b/lib/Makefile
index e37585c6..603ea83e 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -13,7 +13,10 @@ UTILOBJ += bpf_libbpf.o
 endif
 endif
 
-NLOBJ=libgenl.o libnetlink.o mnl_utils.o
+NLOBJ=libgenl.o libnetlink.o
+ifeq ($(HAVE_LIBMNL),y)
+NLOBJ += mnl_utils.o
+endif
 
 all: libnetlink.a libutil.a
 
-- 
2.27.0

