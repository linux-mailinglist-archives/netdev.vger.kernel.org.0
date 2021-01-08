Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89442EFAC5
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 22:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbhAHVs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 16:48:28 -0500
Received: from novek.ru ([213.148.174.62]:36750 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbhAHVs2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 16:48:28 -0500
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jan 2021 16:48:27 EST
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 11C51502A94;
        Sat,  9 Jan 2021 00:38:59 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 11C51502A94
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1610141941; bh=RlQmuQsTi5R3AGMkN3+sv/2/RdYTM1Rm8G2h2gXqIOk=;
        h=From:To:Cc:Subject:Date:From;
        b=o5ugjNsOYorUSchua16Eds7vAj1+aPcwjrdrbVlRefAF+4PXzFkNrhxURFNPzdVdv
         EraAlmX+sJwj2f/dxOB5NAK5jUwQ8CzJUGbfuMlXQ5bSMSgN02snaYqMzwnTt7OMf7
         KaFb0lwRKJWvHKBpOQEGsTELsWfyBLlp3qjLDoRQ=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org
Subject: [net] selftests/tls: fix selftests after adding ChaCha20-Poly1305
Date:   Sat,  9 Jan 2021 00:37:45 +0300
Message-Id: <1610141865-7142-1-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TLS selftests where broken because of wrong variable types used.
Fix it by changing u16 -> uint16_t

Fixes: 4f336e88a870 ("selftests/tls: add CHACHA20-POLY1305 to tls selftests")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 tools/testing/selftests/net/tls.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index cb0d189..e0088c2 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -103,8 +103,8 @@
 
 FIXTURE_VARIANT(tls)
 {
-	u16 tls_version;
-	u16 cipher_type;
+	uint16_t tls_version;
+	uint16_t cipher_type;
 };
 
 FIXTURE_VARIANT_ADD(tls, 12_gcm)
-- 
1.8.3.1

