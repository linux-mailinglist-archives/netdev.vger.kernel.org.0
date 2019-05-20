Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD9B722ADE
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 06:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbfETEhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 00:37:31 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38623 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727539AbfETEhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 00:37:31 -0400
Received: by mail-pg1-f195.google.com with SMTP id j26so6131811pgl.5
        for <netdev@vger.kernel.org>; Sun, 19 May 2019 21:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9pOeOIy3YkaSIGXfkjjlrer+fRUJCX7NWldFsMmUAGk=;
        b=BaR69JMGMzXdqN4t28A5kalX03dSbd2cPFnMRz25IRxeyc+sGgRzPatrHTmeA5j7MQ
         Fk54Llsjtf+GdTKlCAPaVoWUhpNOD2/lBKjq+uzHMd3pNU5UzRbKMZC9uiuty/umPoRY
         WQ9DtD1V6RA5fUMxjKuz3JXeqeOcwQofd+eB3Uo14HSEgLKTwglExAsXCBXklQQEUMOg
         qWJLoHKCQ/4yUptbiiq+VC1ovNDyGdaclF1nNb3RrYhE8v/f4AQEfqUhlwV3JeAp453Y
         uNbEubcMkLeWTZlvDYH1EvkwvuINl6eC3meUAKBiaSUgip/qRVnMRBw3ewhaRAqgkLfz
         37Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9pOeOIy3YkaSIGXfkjjlrer+fRUJCX7NWldFsMmUAGk=;
        b=pzeXHZN6dInTLDhjYLFPCMKcAkmkxKOVG/nSN8xdd9X9N+19ikdBVvs5fflD/76esM
         mzU7txK/tXRHMqCcJXBMqnliPleHf0CM136lzd4YnLNpmGOJoGGpsO7UeZvFr3rgAABE
         LmFyfikO55ebeP3W3G0prXeiG/BLZ5Trac6fcXOIOimu6QLA4YecV0BzcfXr9PF4qMJT
         n/K90d2NkGIezWKWbJ7FFS8xiBnm7Owb7kXqNKUeWDDCf0g9poddIP8fHnFjpuyBlpcg
         B4+8SJ5hyd+QsANj65xbxUrtZk+nh6wIn+BQiYFvms3FM7BTcXAS/wya4zWGcMg24bNw
         3/4Q==
X-Gm-Message-State: APjAAAWgiquh5wUEn8EOi3E8pEHS9j5ncys+7zUZxjt1fTiCfUaIrSKb
        ZWlgXiQ7vUL2z8wSKzowikx/mg2G2Wo=
X-Google-Smtp-Source: APXvYqzjrCz/4WG85Q5pp/sSiJ1JSX3GXfR7BNxU3RZz1MfzCObZ0mUU/ONP3eULbJ/7rj1raodItg==
X-Received: by 2002:a62:ac01:: with SMTP id v1mr16323607pfe.110.1558327050549;
        Sun, 19 May 2019 21:37:30 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 85sm20933953pgb.52.2019.05.19.21.37.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 19 May 2019 21:37:30 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 1/2] selftests: fib_rule_tests: fix local IPv4 address typo
Date:   Mon, 20 May 2019 12:36:54 +0800
Message-Id: <20190520043655.13095-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190520043655.13095-1-liuhangbin@gmail.com>
References: <20190520043655.13095-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IPv4 testing address are all in 192.51.100.0 subnet. It doesn't make
sense to set a 198.51.100.1 local address. Should be a typo.

Fixes: 65b2b4939a64 ("selftests: net: initial fib rule tests")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/fib_rule_tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fib_rule_tests.sh b/tools/testing/selftests/net/fib_rule_tests.sh
index 4b7e107865bf..1ba069967fa2 100755
--- a/tools/testing/selftests/net/fib_rule_tests.sh
+++ b/tools/testing/selftests/net/fib_rule_tests.sh
@@ -55,7 +55,7 @@ setup()
 
 	$IP link add dummy0 type dummy
 	$IP link set dev dummy0 up
-	$IP address add 198.51.100.1/24 dev dummy0
+	$IP address add 192.51.100.1/24 dev dummy0
 	$IP -6 address add 2001:db8:1::1/64 dev dummy0
 
 	set +e
-- 
2.19.2

