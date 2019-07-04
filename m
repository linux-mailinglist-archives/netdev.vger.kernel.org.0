Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5C75F80C
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfGDMZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:25:09 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58917 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727843AbfGDMZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 08:25:08 -0400
Received: from [5.158.153.52] (helo=kurt.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1hj0nP-00025J-29; Thu, 04 Jul 2019 14:25:03 +0200
From:   Kurt Kanzenbach <kurt@linutronix.de>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH iproute2 1/1] utils: Fix get_s64() function
Date:   Thu,  4 Jul 2019 14:24:27 +0200
Message-Id: <20190704122427.22256-2-kurt@linutronix.de>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190704122427.22256-1-kurt@linutronix.de>
References: <20190704122427.22256-1-kurt@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

get_s64() uses internally strtoll() to parse the value out of a given
string. strtoll() returns a long long. However, the intermediate variable is
long only which might be 32 bit on some systems. So, fix it.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 lib/utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/utils.c b/lib/utils.c
index be0f11b00280..9c3702fd4a04 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -390,7 +390,7 @@ int get_u8(__u8 *val, const char *arg, int base)
 
 int get_s64(__s64 *val, const char *arg, int base)
 {
-	long res;
+	long long res;
 	char *ptr;
 
 	errno = 0;
-- 
2.11.0

