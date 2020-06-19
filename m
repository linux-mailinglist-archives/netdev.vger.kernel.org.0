Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8600A2000B7
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbgFSDZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgFSDZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 23:25:05 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA9DC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 20:25:05 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id r18so3865040pgk.11
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 20:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4fBYxsAXdQWOMwDXHgsr6KI5rX8fWL9QlyCWhUIhZRM=;
        b=R7j5SEylT5vOH4IeuNC+VIqLnz8sUaVMZahuYPJs6xqMDuBB4AdeNqNnfGb9Em92FE
         c9mX+tKli5neQMC6zP8qNMezlwoeOETSRf0wv5IiahWAGEnDUAErs/9wi7QyHpvknoL1
         e/iip56gtnB/RvzUOp0CFVhMlnzcOG0YZ2G1h/TgN1JO82RaWCIefPsVuiWa9+6GlEnv
         7PhyDJbd/rh1xy157Umjn0pkF+YAarZ/UV9//FwgkvVC5CX4mTMWSHt/LBXSIOHbb11P
         3/wMIcmtoB1PnzC6WwaEBEwNxN36Ns/EhNpvV2g6R0mzj8hw8S+k49AmB3btnFYsbPGX
         J4Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4fBYxsAXdQWOMwDXHgsr6KI5rX8fWL9QlyCWhUIhZRM=;
        b=c4guXwW+S2zUvAnMkrQ03uz7SVL1eW6ojRBEaj+qdXkU1BKmLNh/8v8oaPUV1C/iT3
         Wq5K0w4JDCE+G9wdvTfrgTLfdgXsptw5zJZJqH+ooO9VawQk62BOAZa+O+V8V+e260MX
         nCa7V5GzU+x8bcDbPEMIoBt21+0ozKJEBbKca0u28y7NBZod/Wy0v0bSXHIAj4o9TdEa
         3rFFsqcdkJL2qxwm7cW2jlMLtToNKNWlAoiwNqqVqJD1iuOtc7oszWIjo6CyBQiN0c5B
         9qJqB98Xkn+m2U3RbJdKLbArckkGNOWSw+ttZzw4gdxbGhdW0rbzsD8isyKHjdeSY5jl
         ngJA==
X-Gm-Message-State: AOAM533mhj18ccPpc5e3d8XcRdKY8+x/YawO/SYTfMkS0eIGaLY/IWbL
        qV0VmMvD+FTUXlbgIzaNwPR2/4opEwk=
X-Google-Smtp-Source: ABdhPJxNlHANaDvquvhoEpdocaAppFKSAkLTIaAZiim9Q8fKn6YL/uGKvV+dtGV3S83icc7GMwfqtw==
X-Received: by 2002:a65:43cb:: with SMTP id n11mr1368113pgp.160.1592537104954;
        Thu, 18 Jun 2020 20:25:04 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w15sm3662075pjb.44.2020.06.18.20.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 20:25:04 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lucas Bates <lucasb@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        David Miller <davem@davemloft.net>,
        Davide Caratti <dcaratti@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net] tc-testing: update geneve options match in tunnel_key unit tests
Date:   Fri, 19 Jun 2020 11:24:45 +0800
Message-Id: <20200619032445.664868-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200618083705.449619-1-liuhangbin@gmail.com>
References: <20200618083705.449619-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since iproute2 commit f72c3ad00f3b ("tc: m_tunnel_key: add options
support for vxlan"), the geneve opt output use key word "geneve_opts"
instead of "geneve_opt". To make compatibility for both old and new
iproute2, let's accept both "geneve_opt" and "geneve_opts".

Suggested-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../tc-testing/tc-tests/actions/tunnel_key.json    | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json b/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
index fbeb9197697d..7357c58fa2dc 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
@@ -629,7 +629,7 @@
         "cmdUnderTest": "$TC actions add action tunnel_key set src_ip 1.1.1.1 dst_ip 2.2.2.2 id 42 dst_port 6081 geneve_opts 0102:80:00880022 index 1",
         "expExitCode": "0",
         "verifyCmd": "$TC actions get action tunnel_key index 1",
-        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opt 0102:80:00880022.*index 1",
+        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opt[s]? 0102:80:00880022.*index 1",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action tunnel_key"
@@ -653,7 +653,7 @@
         "cmdUnderTest": "$TC actions add action tunnel_key set src_ip 1.1.1.1 dst_ip 2.2.2.2 id 42 dst_port 6081 geneve_opts 0102:80:00880022,0408:42:0040007611223344,0111:02:1020304011223344 index 1",
         "expExitCode": "0",
         "verifyCmd": "$TC actions get action tunnel_key index 1",
-        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opt 0102:80:00880022,0408:42:0040007611223344,0111:02:1020304011223344.*index 1",
+        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opt[s]? 0102:80:00880022,0408:42:0040007611223344,0111:02:1020304011223344.*index 1",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action tunnel_key"
@@ -677,7 +677,7 @@
         "cmdUnderTest": "$TC actions add action tunnel_key set src_ip 1.1.1.1 dst_ip 2.2.2.2 id 42 dst_port 6081 geneve_opts 824212:80:00880022 index 1",
         "expExitCode": "255",
         "verifyCmd": "$TC actions get action tunnel_key index 1",
-        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opt 824212:80:00880022.*index 1",
+        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opt[s]? 824212:80:00880022.*index 1",
         "matchCount": "0",
         "teardown": [
             "$TC actions flush action tunnel_key"
@@ -701,7 +701,7 @@
         "cmdUnderTest": "$TC actions add action tunnel_key set src_ip 1.1.1.1 dst_ip 2.2.2.2 id 42 dst_port 6081 geneve_opts 0102:4224:00880022 index 1",
         "expExitCode": "255",
         "verifyCmd": "$TC actions get action tunnel_key index 1",
-        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opt 0102:4224:00880022.*index 1",
+        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opt[s]? 0102:4224:00880022.*index 1",
         "matchCount": "0",
         "teardown": [
             "$TC actions flush action tunnel_key"
@@ -725,7 +725,7 @@
         "cmdUnderTest": "$TC actions add action tunnel_key set src_ip 1.1.1.1 dst_ip 2.2.2.2 id 42 dst_port 6081 geneve_opts 0102:80:4288 index 1",
         "expExitCode": "255",
         "verifyCmd": "$TC actions get action tunnel_key index 1",
-        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opt 0102:80:4288.*index 1",
+        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opt[s]? 0102:80:4288.*index 1",
         "matchCount": "0",
         "teardown": [
             "$TC actions flush action tunnel_key"
@@ -749,7 +749,7 @@
         "cmdUnderTest": "$TC actions add action tunnel_key set src_ip 1.1.1.1 dst_ip 2.2.2.2 id 42 dst_port 6081 geneve_opts 0102:80:4288428822 index 1",
         "expExitCode": "255",
         "verifyCmd": "$TC actions get action tunnel_key index 1",
-        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opt 0102:80:4288428822.*index 1",
+        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opt[s]? 0102:80:4288428822.*index 1",
         "matchCount": "0",
         "teardown": [
             "$TC actions flush action tunnel_key"
@@ -773,7 +773,7 @@
         "cmdUnderTest": "$TC actions add action tunnel_key set src_ip 1.1.1.1 dst_ip 2.2.2.2 id 42 dst_port 6081 geneve_opts 0102:80:00880022,0408:42: index 1",
         "expExitCode": "255",
         "verifyCmd": "$TC actions get action tunnel_key index 1",
-        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opt 0102:80:00880022,0408:42:.*index 1",
+        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*key_id 42.*dst_port 6081.*geneve_opt[s]? 0102:80:00880022,0408:42:.*index 1",
         "matchCount": "0",
         "teardown": [
             "$TC actions flush action tunnel_key"
-- 
2.25.4

