Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D2930E44D
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 21:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbhBCUxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 15:53:36 -0500
Received: from novek.ru ([213.148.174.62]:40822 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232784AbhBCUxK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 15:53:10 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 04B2B5033A1;
        Wed,  3 Feb 2021 23:52:21 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 04B2B5033A1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1612385543; bh=uXKFXjvX9r3qzdapAHZfHg2GnpzDiM1kwQ6y/3b08z8=;
        h=From:To:Cc:Subject:Date:From;
        b=T68YVtrK3a3SmIJBMi20/G21IpDKT4xCcARFSeUa44eUAy+OsoyNawti2SubrCAQJ
         taXIXzVvw0lxGW78i0nJSePwm7BDAt2IPMGSxTcoDS2cwW7WsoRzcmkr5nEg524E/E
         ybWdXy1mgV/euYkiHADQVDPLdaa5nmotsW5uvHrs=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>, Jian Yang <jianyang@google.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org
Subject: [net] selftests: txtimestamp: fix compilation issue
Date:   Wed,  3 Feb 2021 23:52:17 +0300
Message-Id: <1612385537-9076-1-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PACKET_TX_TIMESTAMP is defined in if_packet.h but it is not included in
test. But we cannot include it because we have definitions of struct and
including leads to redefinition error. So define PACKET_TX_TIMESTAMP too.

Fixes: 5ef5c90e3cb3 (selftests: move timestamping selftests to net folder)
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 tools/testing/selftests/net/txtimestamp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/txtimestamp.c b/tools/testing/selftests/net/txtimestamp.c
index 490a8cc..2010f47 100644
--- a/tools/testing/selftests/net/txtimestamp.c
+++ b/tools/testing/selftests/net/txtimestamp.c
@@ -53,6 +53,7 @@
 #define NSEC_PER_USEC	1000L
 #define USEC_PER_SEC	1000000L
 #define NSEC_PER_SEC	1000000000LL
+#define PACKET_TX_TIMESTAMP		16
 
 /* command line parameters */
 static int cfg_proto = SOCK_STREAM;
-- 
1.8.3.1

