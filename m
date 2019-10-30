Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDD9EA3D0
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 20:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfJ3TIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 15:08:54 -0400
Received: from mail-qt1-f176.google.com ([209.85.160.176]:34551 "EHLO
        mail-qt1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfJ3TIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 15:08:53 -0400
Received: by mail-qt1-f176.google.com with SMTP id e14so4806735qto.1
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 12:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=BqBZHdnmyBObohF4iAiMWuB1xYWINfz1uil2qvrw3N8=;
        b=ZIgnda8qP2Verd1MuRYzLIW+c4RWWAuICLbu11SrbaY8D/DinogYz+1mAoU7uIji8o
         8Q+PtQXbsodFe3SgNOS97nZO16lzLvW1g8qAaxGFJlWioLOAux1I3LaZHg2rveRSwAHT
         RlKAR7OtpkwCFYmcJ01v0VmlxLFJMaGKrQ7WjlZRi4/bNMEJPz5u7VwPWgpsWIdaBr52
         /H4B3ywpp+nZbJ/GjFRqHkiv3ZHisRv/tGwO95eSIuW5WA/5b6LftvFmj3sjrWKSeC8H
         vSwxhcKxgWd8yjDKRCFQgHrZgYXib+/74VttXjAhuXZ77OFdQ8VkN1FhRIrNaAVXiPaf
         AMUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BqBZHdnmyBObohF4iAiMWuB1xYWINfz1uil2qvrw3N8=;
        b=rA8gBfx3pbPOrTa+9cm4Uy8BB5fMPnXcWYya+WaTHETFxtvrTWpkb/f6sJVbD87cwW
         04XBrgAdhw64wdklM+LDZvuYlI8+iS0xVkVXbd1EH8xqb7HV3WBhticIMYVklnZVHaLU
         1jdFGe9aHmCSsp0xj2l7S+GZgkGZoT6JZoOSOSp1li1HjQTI+VYvUwERN+m1Gm6hPtDq
         EJ+nAGDIHGF7Qrr6v+VDzd1Qu16Hq+cQWVN5mE5VM/8i9lbecpH7Yu0i1UsgikgVqtB0
         5q63m+SVknX7ADb5czoIjFIreKsVTBxSI3U5ZuU+j2XGFJq/dmNrwdeFWzdBwtCtveUs
         sfig==
X-Gm-Message-State: APjAAAX9LTfk5YwJJmVNg7KnqC9oo1XvH3il9A90v+DdlPFlDrpUB5oA
        jHSMrjfa186/57MWtaVWQlejkVuwquk=
X-Google-Smtp-Source: APXvYqxw/6t2aH39c478O7ir9ofafeAUtMyiz2yhllJjrrH8cRiXy9bn9+vydQ9ueYdSt6k476hECQ==
X-Received: by 2002:ac8:6957:: with SMTP id n23mr1724093qtr.305.1572462531105;
        Wed, 30 Oct 2019 12:08:51 -0700 (PDT)
Received: from mojatatu.com (69-196-152-194.dsl.teksavvy.com. [69.196.152.194])
        by smtp.gmail.com with ESMTPSA id t132sm542458qke.51.2019.10.30.12.08.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 30 Oct 2019 12:08:50 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/1] tc-testing: fixed two failing pedit tests
Date:   Wed, 30 Oct 2019 15:08:43 -0400
Message-Id: <1572462523-18279-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two pedit tests were failing due to incorrect operation
value in matchPattern, should be 'add' not 'val', so fix it.

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json b/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json
index 7871073e3576..6035956a1a73 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json
@@ -915,7 +915,7 @@
         "cmdUnderTest": "$TC actions add action pedit ex munge ip tos add 0x1 pass",
         "expExitCode": "0",
         "verifyCmd": "$TC actions list action pedit",
-        "matchPattern": "action order [0-9]+:  pedit action pass keys 1.*key #0  at ipv4\\+0: val 00010000 mask ff00ffff",
+        "matchPattern": "action order [0-9]+:  pedit action pass keys 1.*key #0  at ipv4\\+0: add 00010000 mask ff00ffff",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action pedit"
@@ -940,7 +940,7 @@
         "cmdUnderTest": "$TC actions add action pedit ex munge ip precedence add 0x1 pipe",
         "expExitCode": "0",
         "verifyCmd": "$TC actions list action pedit",
-        "matchPattern": "action order [0-9]+:  pedit action pipe keys 1.*key #0  at ipv4\\+0: val 00010000 mask ff00ffff",
+        "matchPattern": "action order [0-9]+:  pedit action pipe keys 1.*key #0  at ipv4\\+0: add 00010000 mask ff00ffff",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action pedit"
-- 
2.7.4

