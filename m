Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431B11B213A
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 10:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbgDUIPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 04:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728162AbgDUIPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 04:15:47 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F9BC061A0F;
        Tue, 21 Apr 2020 01:15:46 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w65so6265760pfc.12;
        Tue, 21 Apr 2020 01:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0RAH1OBC5pqOSxBIiNHotyddqZCxrjXPXpxfj0PqJxs=;
        b=RyGy93pAfm0LPIk3gi4Uupp1/Ge89nDaAHZ/2W+nP1IScyhYcbUO3a5S7taVJiUPx6
         2/26OokrfAeuaOvZg0v+7UyeA5fnz24P3unlM9dRBKzrxsMgSB2DejgS4j+UJip7lIDe
         u5xI+SyPR6eoKkUE69C3+OGpq3geJbVsCC2GofUMNH3YJ+3/ecIkKtfictQIWTwxDdm1
         vQQWk6hpbw57aXuwX3FmafNMYxrqMhoqYo/mwdZCFgXYEFCgHOpFHBqCRssIfPK11P3v
         PjB3q7000WODgpu5sWG+odVYW5XX9v5MyKx4E/Fud1bR491YY8uvvY0F2VQpKdpacJVQ
         bSYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0RAH1OBC5pqOSxBIiNHotyddqZCxrjXPXpxfj0PqJxs=;
        b=I8D8HJikrQYZFg0yi0oUj3SSj7gov6ruJOECkVJbhz/x7WwO1cfcP5kvi4WP/UX+R5
         5lkHB6cx8bkabglXDVTkRVeJnVnh/pE2rnTVBZOEkNuwfRgxq2PS1vQHvx967TmD3/gq
         rP2M3ZgPQw5FS2M2lGao+LbwlgsY0ZHu5cg/NqTaWiBHvAFBt+X59JqvVJYkrD+cir1q
         +gIiWZAC/P0Tr+WzFbAXbkxq1EEc0Zt1hvFw/Gk/UgPOvBuegIPvitqHqRr/B6t3kaoh
         MFdlNirlsZJIz7+IAJ1jPJQjlSvQgukmQxWzmr5SyapqDhe6TOCq+4s7+OT5SN4SeOGM
         qEkg==
X-Gm-Message-State: AGi0PubbqSi08eVug1oIx5/I5uFP7/7pMfSg5dQZGSPJ9pIXiUcJGDKa
        8t8YZu/2xYRbajcJWrA/loughDqrzRU=
X-Google-Smtp-Source: APiQypL7eKRqDffDGsmFnirox9xycxzwButq+CAOpchNojdC5vN3nnKGloQV7r4QUolm1rXu3iQAag==
X-Received: by 2002:a63:111a:: with SMTP id g26mr13825477pgl.245.1587456946371;
        Tue, 21 Apr 2020 01:15:46 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id j134sm1494768pgc.7.2020.04.21.01.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 01:15:45 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH] iptables: flush stdout after every verbose log.
Date:   Tue, 21 Apr 2020 01:15:42 -0700
Message-Id: <20200421081542.108296-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Ensures that each logged line is flushed to stdout after it's
written, and not held in any buffer.

Places to modify found via:
  git grep -C5 'fputs[(]buffer, stdout[)];'

On Android iptables-restore -v is run as netd daemon's child process
and fed actions via pipe.  '#PING' is used to verify the child
is still responsive, and thus needs to be unbuffered.

Luckily if you're running iptables-restore in verbose mode you
probably either don't care about performance or - like Android
- actually need this.

Test: builds, required on Android for ip6?tables-restore netd
  subprocess health monitoring.
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 iptables/iptables-restore.c | 4 +++-
 iptables/xtables-restore.c  | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index b0a51d49..fea04842 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -178,8 +178,10 @@ ip46tables_restore_main(const struct iptables_restore_cb *cb,
 		if (buffer[0] == '\n')
 			continue;
 		else if (buffer[0] == '#') {
-			if (verbose)
+			if (verbose) {
 				fputs(buffer, stdout);
+				fflush(stdout);
+			}
 			continue;
 		} else if ((strcmp(buffer, "COMMIT\n") == 0) && (in_table)) {
 			if (!testing) {
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index c472ac9b..8c25e5b2 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -85,8 +85,10 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 	if (buffer[0] == '\n')
 		return;
 	else if (buffer[0] == '#') {
-		if (verbose)
+		if (verbose) {
 			fputs(buffer, stdout);
+			fflush(stdout);
+		}
 		return;
 	} else if (state->in_table &&
 		   (strncmp(buffer, "COMMIT", 6) == 0) &&
-- 
2.26.1.301.g55bc3eb7cb9-goog

