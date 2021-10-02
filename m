Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9725A41F95E
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 04:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbhJBC24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 22:28:56 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:33956 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbhJBC2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 22:28:55 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id EEBBE20166; Sat,  2 Oct 2021 10:27:05 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Brendan Higgins <brendanhiggins@google.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 1/2] mctp: test: disallow MCTP_TEST when building as a module
Date:   Sat,  2 Oct 2021 10:26:55 +0800
Message-Id: <20211002022656.1681956-1-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current kunit infrastructure defines its own module_init() when
built as a module, which conflicts with the mctp core's own.

So, only allow MCTP_TEST when both MCTP and KUNIT are built-in.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mctp/Kconfig b/net/mctp/Kconfig
index 15267a5043d9..868c92272cbd 100644
--- a/net/mctp/Kconfig
+++ b/net/mctp/Kconfig
@@ -13,6 +13,6 @@ menuconfig MCTP
 	  channel.
 
 config MCTP_TEST
-        tristate "MCTP core tests" if !KUNIT_ALL_TESTS
-        depends on MCTP && KUNIT
+        bool "MCTP core tests" if !KUNIT_ALL_TESTS
+        depends on MCTP=y && KUNIT=y
         default KUNIT_ALL_TESTS
-- 
2.30.2

