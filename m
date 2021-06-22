Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5723B0832
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 17:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhFVPHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 11:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhFVPHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 11:07:30 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839BBC061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 08:05:14 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id i68so40334618qke.3
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 08:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9fDL54lwCB9RTh6TzPKvCE7egP/3LnL3gPQhZIXYHX4=;
        b=Dx7JDfUCgW89nUboN0SLChwcEc2ctvJDRkV1xCv4nfOB3uJfzp2Kkat/oBv79Z1jBC
         nhLMg/2wXMYVreODtjEZ2e8XDSXumdIWtsm44nFgi/KxDatf8sTaZZROXpyOgiU2TQhl
         Uk77bb8L+i/RzjrnIWUvLK+JYunqshQ6IqzG+nBRLzq1VJV7HnyeUP4d0/dvpcypz8CD
         BCRyLvuWAhWuGeTKVEMchauJtbO3jttGz8HXAxTa9uPTbO2Uuot8AvMfxYy5K0Qpvh+W
         oUBhfIjyUw9uSLBImArO34S/yaF5blMSqDnZPUj0YgsDJDvSUz/O2a6Jxy5CR5lISxE4
         RNhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9fDL54lwCB9RTh6TzPKvCE7egP/3LnL3gPQhZIXYHX4=;
        b=caVngjLcWmNcbYjLLWmu6ErDTJAaK4ggWlZHed+5/hIErdwIv2ZYjfSxBDaepcUmEl
         IQhVV0B+AmIc8LNJ9YR5hB0AJPQv/VF1Dt7Yg2vzqA8iUJNYKD6/CUQrBXrYrA6xRnRf
         gLzeWPsoaCJNkOBh8As61/jOS6rhEeeKuimGAIXD70Q3+BlpEXG7AsdTqke4WBpsEtsh
         1SZQzEJMruaaOGVkYcbKSfNgf/wfpdwFh5UaMiDfqoose1MTbdFzTLlSYvzv3nPDjIXh
         Xz/i6Bc6iHwhPsU2rK+yoet2EwD+gSXJIDmUYe9Mdb9wBd0XVr0nGQ3xsvbHUQ6H6IgI
         Isdw==
X-Gm-Message-State: AOAM531SwVb4TQPF4tAz8upTwc1uMEQHHvLW3qLK93Oec0GL86xAlSty
        rTcAfeEPSb1BwW+XOJ1fxKg=
X-Google-Smtp-Source: ABdhPJxLj2Q5eElkykH3ZuwCgN2XjpN+63JMcknXsH3wZApHK+aJtChzPpZs/PJ6UW2LSCMZvTQSRw==
X-Received: by 2002:a37:aec2:: with SMTP id x185mr4759767qke.294.1624374313727;
        Tue, 22 Jun 2021 08:05:13 -0700 (PDT)
Received: from horizon.localdomain ([177.220.172.71])
        by smtp.gmail.com with ESMTPSA id e24sm1729021qtp.97.2021.06.22.08.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 08:05:13 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id DF797C13E2; Tue, 22 Jun 2021 12:05:10 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dcaratti@redhat.com, Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net-next 2/3] tc-testing: add support for sending various scapy packets
Date:   Tue, 22 Jun 2021 12:05:01 -0300
Message-Id: <cfec7c2cc6538ee45c34f07beae3973b2425d113.1624373870.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1624373870.git.marcelo.leitner@gmail.com>
References: <cover.1624373870.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It can be worth sending different scapy packets on a given test, as in the
last patch of this series. For that, lets listify the scapy attribute and
simply iterate over it.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 .../tc-testing/plugin-lib/scapyPlugin.py      | 42 ++++++++++---------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py b/tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py
index a7b21658af9b463cef8c9b3d4023f222426f239b..254136e3da5ac401adb5bf91b92b3a6ae3cda042 100644
--- a/tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py
+++ b/tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py
@@ -29,22 +29,26 @@ class SubPlugin(TdcPlugin):
             return
 
         # Check for required fields
-        scapyinfo = self.args.caseinfo['scapy']
-        scapy_keys = ['iface', 'count', 'packet']
-        missing_keys = []
-        keyfail = False
-        for k in scapy_keys:
-            if k not in scapyinfo:
-                keyfail = True
-                missing_keys.append(k)
-        if keyfail:
-            print('{}: Scapy block present in the test, but is missing info:'
-                .format(self.sub_class))
-            print('{}'.format(missing_keys))
-
-        pkt = eval(scapyinfo['packet'])
-        if '$' in scapyinfo['iface']:
-            tpl = Template(scapyinfo['iface'])
-            scapyinfo['iface'] = tpl.safe_substitute(NAMES)
-        for count in range(scapyinfo['count']):
-            sendp(pkt, iface=scapyinfo['iface'])
+        lscapyinfo = self.args.caseinfo['scapy']
+        if type(lscapyinfo) != list:
+            lscapyinfo = [ lscapyinfo, ]
+
+        for scapyinfo in lscapyinfo:
+            scapy_keys = ['iface', 'count', 'packet']
+            missing_keys = []
+            keyfail = False
+            for k in scapy_keys:
+                if k not in scapyinfo:
+                    keyfail = True
+                    missing_keys.append(k)
+            if keyfail:
+                print('{}: Scapy block present in the test, but is missing info:'
+                    .format(self.sub_class))
+                print('{}'.format(missing_keys))
+
+            pkt = eval(scapyinfo['packet'])
+            if '$' in scapyinfo['iface']:
+                tpl = Template(scapyinfo['iface'])
+                scapyinfo['iface'] = tpl.safe_substitute(NAMES)
+            for count in range(scapyinfo['count']):
+                sendp(pkt, iface=scapyinfo['iface'])
-- 
2.31.1

