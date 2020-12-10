Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8292D6C0F
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 01:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389829AbgLJXEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387629AbgLJXDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 18:03:35 -0500
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70812C0613D3
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 15:02:55 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4CsTwD4qNbzQlRW;
        Fri, 11 Dec 2020 00:02:52 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1607641370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JkmcRogEabTAQuOpuLh/0/HsdNUpEU38y2Grsx3zszQ=;
        b=uhk12XLgqFPeXl4GjSIhm6nMi67dyHESg1G2DxWT2I0LQzyI0S8ATxcVqitzE3cgczKuyt
        8VQJfruktIdiiyTGtl8j+iZxPNabLbrwworD7HnGcGNJdtuCaE4k5WCLFJmKSMV661J5sZ
        KACbc/hYX9dKGJ97ISovO8D9u7UbPz+i+vNheExdbk3t5NCpWnOvnIZ9GdHZ/ueAhqRyoe
        xyqFOmDA/7fjWxJ/k1vqFaj0Y2Gihji04b7WnE9ldTjXXYBjzx/UKja8SGcoc2T2m5LU17
        dhkkshC+dfhJQk++VVg1MUtYcy7Rz72r9isbOpA1iKsx5thjVhUZdWgDsiSkxw==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id 6j7NUm0zzVOd; Fri, 11 Dec 2020 00:02:49 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 02/10] dcb: ets: Fix help display for "show" subcommand
Date:   Fri, 11 Dec 2020 00:02:16 +0100
Message-Id: <4d11ae89fca4f3881ba9022ac80f08d172d86163.1607640819.git.me@pmachata.org>
In-Reply-To: <cover.1607640819.git.me@pmachata.org>
References: <cover.1607640819.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.56 / 15.00 / 15.00
X-Rspamd-Queue-Id: A2A0A108B
X-Rspamd-UID: 0caf3a
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"dcb ets show dev X help" currently shows full "ets" help instead of just
help for the show command. Fix it.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 dcb/dcb_ets.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/dcb/dcb_ets.c b/dcb/dcb_ets.c
index 1735885aa8ed..94c6019e8095 100644
--- a/dcb/dcb_ets.c
+++ b/dcb/dcb_ets.c
@@ -370,7 +370,7 @@ static int dcb_cmd_ets_show(struct dcb *dcb, const char *dev, int argc, char **a
 
 	do {
 		if (matches(*argv, "help") == 0) {
-			dcb_ets_help();
+			dcb_ets_help_show();
 			return 0;
 		} else if (matches(*argv, "willing") == 0) {
 			dcb_ets_print_willing(&ets);
@@ -404,7 +404,7 @@ static int dcb_cmd_ets_show(struct dcb *dcb, const char *dev, int argc, char **a
 			print_nl();
 		} else {
 			fprintf(stderr, "What is \"%s\"?\n", *argv);
-			dcb_ets_help();
+			dcb_ets_help_show();
 			return -EINVAL;
 		}
 
-- 
2.25.1

