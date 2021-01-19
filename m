Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0514D2FAEFD
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 04:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389212AbhASDAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 22:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728406AbhASDA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 22:00:28 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92399C061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 18:59:48 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id s15so9686057plr.9
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 18:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zAKzKif+/uAmocR3T9193/p6+wZWI3rzljpH0XZ3nGY=;
        b=FKZijKz9g9fC1rwh2AXuGUrdB1HA/bxlcj6mwl6vyVc+HmZmBHhakQv0/FWHELooO3
         JPoZYRUjlvfqOkBJgg0/S1pbHhj5eR3x4hHomSY1avhV91nWdEn+G/Aj9200erm7aIej
         qqxMn9uThfnyZ65E3Jp/E4rpCBE9EDCfU2Ve16Toab4HBSbUtssUxbVT/npG6bTN9G5g
         GDzBxaQ4ywIjj0vFehedSdmlee6Vhc53QBhwy6ZWWl2rSzYqk9LkL62V54KFGfQIxKvA
         EQuBLSriT+FUHApLoBEhrcCEJ3RIt4qH49NIrlh1tAulDmzZ0+Z7TFlqiJWZes/a0Ja/
         d9Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zAKzKif+/uAmocR3T9193/p6+wZWI3rzljpH0XZ3nGY=;
        b=nHWODwrGIEWpZeviPKaC4EqLvGSbWZUU2lo4Pm785AvF6Hqs6zawKEeM7u03577vTN
         kVc9RAxI6m/CH9BIJHaDOq6vOLm3pfQcY0a765a/JpgqV7p0qY+vRvmipRBDmPewCMm8
         X7ET+IHWmqhFdPJPfC91dy5H1PZ4xdFLlz720AFcM9hHSUHDydtg+y80Ovg5l7fFAoBd
         IWrozoH7Mw9UcCGUmHFT448GUzucLisF5r5gkVqt9hlUPp7t0VDCKYKn38HS78tztWO1
         Byimuhpg9BMGwTFDVS0QGn2AnPu2mti9Dh8FbGkqLCNl6T2KniZobJYd24u1qisonUVW
         EFpQ==
X-Gm-Message-State: AOAM5332rEdPfN/xstCOEQWjhze4H8xqfvBAuFa1F48Odb2Gzvluc6I4
        bql3i9jwiqxzikCO5b6NdbqXSXrkvdyRSA==
X-Google-Smtp-Source: ABdhPJzx3MROHoJtTccpoxXmZeOwD18F2GxTtcely5k+c/mW4dgzV6oQYkdenRtbaVGXT3lnyMdI0w==
X-Received: by 2002:a17:90a:5b06:: with SMTP id o6mr2700293pji.49.1611025187925;
        Mon, 18 Jan 2021 18:59:47 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d8sm709602pjm.30.2021.01.18.18.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 18:59:47 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Antoine Tenart <atenart@redhat.com>
Subject: [PATCH net] selftests/net/fib_tests: remove duplicate log test
Date:   Tue, 19 Jan 2021 10:59:30 +0800
Message-Id: <20210119025930.2810532-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous test added an address with a specified metric and check if
correspond route was created. I somehow added two logs for the same
test. Remove the duplicated one.

Reported-by: Antoine Tenart <atenart@redhat.com>
Fixes: 0d29169a708b ("selftests/net/fib_tests: update addr_metric_test for peer route testing")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/fib_tests.sh | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 84205c3a55eb..2b5707738609 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -1055,7 +1055,6 @@ ipv6_addr_metric_test()
 
 	check_route6 "2001:db8:104::1 dev dummy2 proto kernel metric 260"
 	log_test $? 0 "Set metric with peer route on local side"
-	log_test $? 0 "User specified metric on local address"
 	check_route6 "2001:db8:104::2 dev dummy2 proto kernel metric 260"
 	log_test $? 0 "Set metric with peer route on peer side"
 
-- 
2.26.2

