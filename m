Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEFE1C613F
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729221AbgEETqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728233AbgEETqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 15:46:22 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E031C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 12:46:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x13so1241071ybg.23
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 12:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=pmDnSqIXNhAppY6M/8vBg5yHQCMauqGO5AmjUubdBXg=;
        b=v2SiJqHGMoZ6wJ8aCfQF+iHzu5sLOi0m/zzq5T/j8flZdEpzYjn5+Mh2pKIVpVXsdb
         4aTcD4ZE8RJAoaOdwlBtbn4vYeYO3GJ6hJ09WFpNwUkHD43gkjQbWFcq3z2LUpktNmrf
         dqtlxOatHX9eO25lzqIGW2qbyspqGL408kyacNs2XiezdJVqSNhefPoPYO1UmWcdL5uA
         V622e0Jzyx/FaZ/6jG6IqRjhhEVEpnH7J3JpyVw/72XlRVtJdjucaEvy1K9CUt3k0gBK
         3GI51aVQmVF+KzMcfTnOzxJkeNJPSJPOJY7/1CF1gi5Dmc0waAkkoVElOyIBsDCCEV/V
         Oo8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=pmDnSqIXNhAppY6M/8vBg5yHQCMauqGO5AmjUubdBXg=;
        b=J0h65lggpgC02qdrF4d34wWWGG8azLKhqvsMBNeFuRW5Fjiv6hnSHaeLXBzNpJGguj
         9R+0nlKb+URAJUZXeGk+6PE3mBoEK4e0CZ7dHZTKR0DxLUN2ZkR/V4XnA/6xyhm0czMi
         vC0FgZgOVdk/jbJq8G8v/p4svCZPndO7Co8EYu5vmb8JJBX/IlEfWR+lAWreDbhP8Ldr
         6Am8y2xiWXV9/Jhe2J59ixqhEDc0NRfA9XuspKfqgSe4TCrxqTQLMLBGNw0qh+L4dYru
         jifdaKEwVxw3ydgaT1kRD3nBoRLy0+dUm8zSsSPQaCFUwtcIwlX/QeCRCegQULC5Z75Z
         06Fw==
X-Gm-Message-State: AGi0PuaeBYFUIODEZjDjOsxF8GJ+s8z4S8mbGHE2dBBRuqzZTeljzZiC
        HNKwsGp7CL57HHOBqmOBBleIW/0wA2htNg==
X-Google-Smtp-Source: APiQypKv9vdiVb/y7ESNuTCteu2VdLIduYh4kRX8uPIJv7Xrq+mnf0N+Zo5qoe3Fa5RhwxF77uzZGuyOgPaAzw==
X-Received: by 2002:a25:d496:: with SMTP id m144mr6775715ybf.119.1588707981834;
 Tue, 05 May 2020 12:46:21 -0700 (PDT)
Date:   Tue,  5 May 2020 12:46:18 -0700
Message-Id: <20200505194618.18437-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH iproute2] utils: remove trailing zeros in print_time() and print_time64()
From:   Eric Dumazet <edumazet@google.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before :

tc qd sh dev eth1

... refill_delay 40.0ms timer_slack 10.000us horizon 10.000s

After :
... refill_delay 40ms timer_slack 10us horizon 10s

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 lib/utils.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/utils.c b/lib/utils.c
index c6f19ce1ac64f40848172adb1983ea60df046b3b..c98021d6ecad23e0f274770f8a53aaaadaa241ae 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1628,9 +1628,9 @@ static void print_time(char *buf, int len, __u32 time)
 	double tmp = time;
 
 	if (tmp >= TIME_UNITS_PER_SEC)
-		snprintf(buf, len, "%.1fs", tmp/TIME_UNITS_PER_SEC);
+		snprintf(buf, len, "%.3gs", tmp/TIME_UNITS_PER_SEC);
 	else if (tmp >= TIME_UNITS_PER_SEC/1000)
-		snprintf(buf, len, "%.1fms", tmp/(TIME_UNITS_PER_SEC/1000));
+		snprintf(buf, len, "%.3gms", tmp/(TIME_UNITS_PER_SEC/1000));
 	else
 		snprintf(buf, len, "%uus", time);
 }
@@ -1681,11 +1681,11 @@ static void print_time64(char *buf, int len, __s64 time)
 	double nsec = time;
 
 	if (time >= NSEC_PER_SEC)
-		snprintf(buf, len, "%.3fs", nsec/NSEC_PER_SEC);
+		snprintf(buf, len, "%.3gs", nsec/NSEC_PER_SEC);
 	else if (time >= NSEC_PER_MSEC)
-		snprintf(buf, len, "%.3fms", nsec/NSEC_PER_MSEC);
+		snprintf(buf, len, "%.3gms", nsec/NSEC_PER_MSEC);
 	else if (time >= NSEC_PER_USEC)
-		snprintf(buf, len, "%.3fus", nsec/NSEC_PER_USEC);
+		snprintf(buf, len, "%.3gus", nsec/NSEC_PER_USEC);
 	else
 		snprintf(buf, len, "%lldns", time);
 }
-- 
2.26.2.526.g744177e7f7-goog

