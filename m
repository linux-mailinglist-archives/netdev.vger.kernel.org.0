Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C291FEDC7
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 10:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgFRIhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 04:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728731AbgFRIhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 04:37:36 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695AAC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 01:37:36 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k1so2162190pls.2
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 01:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6yWNMsNVNQUfzEh8JLitD73fcG9pyyOuyfUMr1PA9FE=;
        b=juCsrLoVXJ8+8b2bwn/apsA6AS7zl7uk3GkO1jYZnjsSFgRNsXxjuvZIAWSjz+OntR
         fihL13aMAlJsj1hO4MUCLciGDYwFvRUNwieULuXfg1AzdgzZt3uQDyNa0iH+tYupEVt6
         IUEOu2b9K2EOfKBBid7h08yDsnoVpKMFES1QUnfyQ4YTWSPxeK4FtCkvTKV6RQ9uc7Hu
         Is0iJb1JwpjDhnmW5uIOsIgyWqYeAiUFmRi4FoWL79y4vT5OKyes89QgQzXr3lQCSIUk
         HAFEHnsRgiilr9YLA2igHSneHyTen0tzdd/DCCGL8eL8T53RuXJXgf2/jQnw1Z6y0VO9
         LdoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6yWNMsNVNQUfzEh8JLitD73fcG9pyyOuyfUMr1PA9FE=;
        b=VtX+8L7q39+ZApINz9vti0TetaElFm1CYfwtkW54cd6R+aiB4Y+IElm3pj3o4aw3Yp
         sxYkP8df0UxBddr36dhCm3m9d8R3mu9JMV2XUmJjtAjvcfHHkQD4KoQgH3mdnh1K/1PQ
         i9uAmfWorAHeuRG/o6VUR5ITV9Ut51hunPQDpU7TZKWMyx2kPKvomQJr1VojXlde/nVY
         kmzMFKv3MUtjKVawnyO+JyiDX4LPRWdhx0yit3Ho9czXkyrx9l7hfMXMNF6nhibywUaD
         1ihVjEsX7v9NvGwDqHuzNDGTSIoU8zOBXTmJ0aiwkoRum4gRHyRvx9aiH6fljym5kP/N
         7Gcw==
X-Gm-Message-State: AOAM533i4OPWZr9orf1fy2j1K0a91J9r5pFLuAmh2zk+SMVbxWsreZoz
        aDKNo2NYSdBWMfPYH5HSXDGQIyv97kU=
X-Google-Smtp-Source: ABdhPJzfRN/VJQHacDa0ByqF1mBYK+tr6hb95fA0Oa0i9UTRvI5rg9hwA6QSJL+Y45KnXrN8hbhWDg==
X-Received: by 2002:a17:902:ed49:: with SMTP id y9mr2805037plb.284.1592469455627;
        Thu, 18 Jun 2020 01:37:35 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v66sm2202248pfb.63.2020.06.18.01.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 01:37:35 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>,
        Lucas Bates <lucasb@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        David Miller <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] tc-testing: fix geneve options match in tunnel_key unit tests
Date:   Thu, 18 Jun 2020 16:37:05 +0800
Message-Id: <20200618083705.449619-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tc action print "geneve_opts" instead of "geneve_opt".
Fix the typo, or we will unable to match correct action output.

Fixes: cba54f9cf4ec ("tc-testing: add geneve options in tunnel_key unit tests")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../tc-testing/tc-tests/actions/tunnel_key.json    | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json b/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
index fbeb9197697d..f451915626eb 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
@@ -629,7 +629,7 @@
         "cmdUnderTest": "$TC actions add action tunnel_key set src_ip 1.1.1.1 dst_ip 2.2.2.2 id 42 dst_port 6081 geneve_opts 0102:80:00880022 index 1",
         "expExitCode": "0",
         "verifyCmd": "$TC actions get action tunnel_key index 1",
-        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opt 0102:80:00880022.*index 1",
+        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opts 0102:80:00880022.*index 1",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action tunnel_key"
@@ -653,7 +653,7 @@
         "cmdUnderTest": "$TC actions add action tunnel_key set src_ip 1.1.1.1 dst_ip 2.2.2.2 id 42 dst_port 6081 geneve_opts 0102:80:00880022,0408:42:0040007611223344,0111:02:1020304011223344 index 1",
         "expExitCode": "0",
         "verifyCmd": "$TC actions get action tunnel_key index 1",
-        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opt 0102:80:00880022,0408:42:0040007611223344,0111:02:1020304011223344.*index 1",
+        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opts 0102:80:00880022,0408:42:0040007611223344,0111:02:1020304011223344.*index 1",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action tunnel_key"
@@ -677,7 +677,7 @@
         "cmdUnderTest": "$TC actions add action tunnel_key set src_ip 1.1.1.1 dst_ip 2.2.2.2 id 42 dst_port 6081 geneve_opts 824212:80:00880022 index 1",
         "expExitCode": "255",
         "verifyCmd": "$TC actions get action tunnel_key index 1",
-        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opt 824212:80:00880022.*index 1",
+        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opts 824212:80:00880022.*index 1",
         "matchCount": "0",
         "teardown": [
             "$TC actions flush action tunnel_key"
@@ -701,7 +701,7 @@
         "cmdUnderTest": "$TC actions add action tunnel_key set src_ip 1.1.1.1 dst_ip 2.2.2.2 id 42 dst_port 6081 geneve_opts 0102:4224:00880022 index 1",
         "expExitCode": "255",
         "verifyCmd": "$TC actions get action tunnel_key index 1",
-        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opt 0102:4224:00880022.*index 1",
+        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opts 0102:4224:00880022.*index 1",
         "matchCount": "0",
         "teardown": [
             "$TC actions flush action tunnel_key"
@@ -725,7 +725,7 @@
         "cmdUnderTest": "$TC actions add action tunnel_key set src_ip 1.1.1.1 dst_ip 2.2.2.2 id 42 dst_port 6081 geneve_opts 0102:80:4288 index 1",
         "expExitCode": "255",
         "verifyCmd": "$TC actions get action tunnel_key index 1",
-        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opt 0102:80:4288.*index 1",
+        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opts 0102:80:4288.*index 1",
         "matchCount": "0",
         "teardown": [
             "$TC actions flush action tunnel_key"
@@ -749,7 +749,7 @@
         "cmdUnderTest": "$TC actions add action tunnel_key set src_ip 1.1.1.1 dst_ip 2.2.2.2 id 42 dst_port 6081 geneve_opts 0102:80:4288428822 index 1",
         "expExitCode": "255",
         "verifyCmd": "$TC actions get action tunnel_key index 1",
-        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opt 0102:80:4288428822.*index 1",
+        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opts 0102:80:4288428822.*index 1",
         "matchCount": "0",
         "teardown": [
             "$TC actions flush action tunnel_key"
@@ -773,7 +773,7 @@
         "cmdUnderTest": "$TC actions add action tunnel_key set src_ip 1.1.1.1 dst_ip 2.2.2.2 id 42 dst_port 6081 geneve_opts 0102:80:00880022,0408:42: index 1",
         "expExitCode": "255",
         "verifyCmd": "$TC actions get action tunnel_key index 1",
-        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opt 0102:80:00880022,0408:42:.*index 1",
+        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opts 0102:80:00880022,0408:42:.*index 1",
         "matchCount": "0",
         "teardown": [
             "$TC actions flush action tunnel_key"
-- 
2.25.4

