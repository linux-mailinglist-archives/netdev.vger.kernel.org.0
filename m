Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4123F5F0CA
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 02:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfGDAqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 20:46:02 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:35414 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727102AbfGDAqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 20:46:01 -0400
Received: by mail-io1-f65.google.com with SMTP id m24so9288268ioo.2
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 17:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WF+Cz7KLSMn8XUGDuGnkx5caNFaJT5HONH8aacQS2u0=;
        b=bWdnYakQumM1ify3A8qCzJXjTeaTJouBv2oOkNPE1dW4uTbK7JEfg1FEN6cTHZF2XH
         TN5lL6YwXc1LoPdDnMIKAOaj5vNxVbfuab6ydIjbjiT9ezmK1rHgTobY5J1Gvg8czROD
         J0GEehilZ4Tod63+USwQpJSNvEmOwu2BlA0/+0cuW/JAEXNzDcVh1QbPLgpYwhELc+Ou
         hV5QxL8YIOK81BGnJFyOQyO5I/4wJlSlhfQKqDmlqDEBBl9/R+BO7NxGG9bZAgkjhW2Y
         JlrmHA2VtsZYAUiKFU8/nbTXSkMJS5je6OnHheRCnSeoWrg+5UFlOPbl9ya3t4GmAoNO
         NL5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WF+Cz7KLSMn8XUGDuGnkx5caNFaJT5HONH8aacQS2u0=;
        b=DXP6CDUQKHge5Lg8YvwhSBkllI23vOBXsyEatb7dwFMOv/eMFdsokvvQW4wg9a9z11
         2QW1AvbiThoxRMeLZ330gRguPVBAXvFdgAcX42Rr+aR4HcbJkZSQ/8RLBbPHW77jfEES
         Ul1keKV960s55tpsC4izjW783Wm6X8bE5IJq/K6KGyIBeGY4tc2NW9khNvaV4Z9ubPzB
         b3uTnwwrNSSoULy2WRwEM1Hn6MTrwKY2Dw+vnEVdlHEWPXFnOhC3ZmnQ9cX7zvprBwgu
         9BNgKvw+eOI2Mr78WgVMyBbHwxE2fxLMd/3l4CNHbw77MKBvECycvKyEyUCDKD258epx
         +HUA==
X-Gm-Message-State: APjAAAUoXwJAvNSU0fEznGba6VbAObRjYNx1FG65uelPxOan3CHnkmvm
        SRZ6XHd72D6fnZxtyglrUwsCjw==
X-Google-Smtp-Source: APXvYqyvdjjAANqvAuViQ/RBAbu9NB5XTZ3gd12mXCpNRul8/IN5sMe+qck65YghmwrhzUOEsOxU6g==
X-Received: by 2002:a5e:a712:: with SMTP id b18mr41599226iod.220.1562201160201;
        Wed, 03 Jul 2019 17:46:00 -0700 (PDT)
Received: from mojatatu.com ([2607:f2c0:e4b2:adf:4494:a7b3:9aab:d513])
        by smtp.gmail.com with ESMTPSA id l5sm5619776ioq.83.2019.07.03.17.45.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 03 Jul 2019 17:45:59 -0700 (PDT)
From:   Lucas Bates <lucasb@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, mleitner@redhat.com, vladbu@mellanox.com,
        dcaratti@redhat.com, kernel@mojatatu.com,
        Lucas Bates <lucasb@mojatatu.com>
Subject: [PATCH v2 net-next 3/3] tc-testing: introduce scapyPlugin for basic traffic
Date:   Wed,  3 Jul 2019 20:45:02 -0400
Message-Id: <1562201102-4332-4-git-send-email-lucasb@mojatatu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562201102-4332-1-git-send-email-lucasb@mojatatu.com>
References: <1562201102-4332-1-git-send-email-lucasb@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The scapyPlugin allows for simple traffic generation in tdc to
test various tc features. It was tested with scapy v2.4.2, but
should work with any successive version.

In order to use the plugin's functionality, scapy must be
installed. This can be done with:
   pip3 install scapy

or to install 2.4.2:
   pip3 install scapy==2.4.2

If the plugin is unable to import the scapy module, it will
terminate the tdc run.

The plugin makes use of a new key in the test case data, 'scapy'.
This block contains three other elements: 'iface', 'count', and
'packet':

        "scapy": {
            "iface": "$DEV0",
            "count": 1,
            "packet": "Ether(type=0x800)/IP(src='16.61.16.61')/ICMP()"
        },

* iface is the name of the device on the host machine from which
  the packet(s) will be sent. Values contained within tdc_config.py's
  NAMES dict can be used here - this is useful if paired with
  nsPlugin
* count is the number of copies of this packet to be sent
* packet is a string detailing the different layers of the packet
  to be sent. If a property isn't explicitly set, scapy will set
  default values for you.

Layers in the packet info are separated by slashes. For info about
common TCP and IP properties, see:
https://blogs.sans.org/pen-testing/files/2016/04/ScapyCheatSheet_v0.2.pdf

Caution is advised when running tests using the scapy functionality,
since the plugin blindly sends the packet as defined in the test case
data.

See creating-testcases/scapy-example.json for sample test cases;
the first test is intended to pass while the second is intended to
fail. Consider using the matchJSON functionality for verification
when using scapy.

Signed-off-by: Lucas Bates <lucasb@mojatatu.com>
---
 .../creating-testcases/scapy-example.json          | 98 ++++++++++++++++++++++
 .../selftests/tc-testing/plugin-lib/scapyPlugin.py | 51 +++++++++++
 2 files changed, 149 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/creating-testcases/scapy-example.json
 create mode 100644 tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py

diff --git a/tools/testing/selftests/tc-testing/creating-testcases/scapy-example.json b/tools/testing/selftests/tc-testing/creating-testcases/scapy-example.json
new file mode 100644
index 0000000..5a9377b
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/creating-testcases/scapy-example.json
@@ -0,0 +1,98 @@
+[
+    {
+        "id": "b1e9",
+        "name": "Test matching of source IP",
+        "category": [
+            "actions",
+            "scapy"
+        ],
+        "plugins": {
+            "requires": [
+                "nsPlugin",
+                "scapyPlugin"
+            ]
+        },
+        "setup": [
+            [
+                "$TC qdisc del dev $DEV1 ingress",
+                0,
+                1,
+                2,
+                255
+            ],
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: prio 3 protocol ip flower src_ip 16.61.16.61 flowid 1:1 action ok",
+        "scapy": {
+            "iface": "$DEV0",
+            "count": 1,
+            "packet": "Ether(type=0x800)/IP(src='16.61.16.61')/ICMP()"
+        },
+        "expExitCode": "0",
+        "verifyCmd": "$TC -s -j filter ls dev $DEV1 ingress prio 3",
+        "matchJSON": [
+            {
+                "path": [
+                    1,
+                    "options",
+                    "actions",
+                    0,
+                    "stats",
+                    "packets"
+                ],
+                "value": 1
+            }
+        ],
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "e9c4",
+        "name": "Test matching of source IP with wrong count",
+        "category": [
+            "actions",
+            "scapy"
+        ],
+        "plugins": {
+            "requires": [
+                "nsPlugin",
+                "scapyPlugin"
+            ]
+        },
+        "setup": [
+            [
+                "$TC qdisc del dev $DEV1 ingress",
+                0,
+                1,
+                2,
+                255
+            ],
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: prio 3 protocol ip flower src_ip 16.61.16.61 flowid 1:1 action ok",
+        "scapy": {
+            "iface": "$DEV0",
+            "count": 3,
+            "packet": "Ether(type=0x800)/IP(src='16.61.16.61')/ICMP()"
+        },
+        "expExitCode": "0",
+        "verifyCmd": "$TC -s -j filter ls dev $DEV1 parent ffff:",
+        "matchJSON": [
+            {
+                "path": [
+                    1,
+                    "options",
+                    "actions",
+                    0,
+                    "stats",
+                    "packets"
+                ],
+                "value": 1
+            }
+        ],
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    }
+]
diff --git a/tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py b/tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py
new file mode 100644
index 0000000..db57916
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py
@@ -0,0 +1,51 @@
+#!/usr/bin/env python3
+
+import os
+import signal
+from string import Template
+import subprocess
+import time
+from TdcPlugin import TdcPlugin
+
+from tdc_config import *
+
+try:
+    from scapy.all import *
+except ImportError:
+    print("Unable to import the scapy python module.")
+    print("\nIf not already installed, you may do so with:")
+    print("\t\tpip3 install scapy==2.4.2")
+    exit(1)
+
+class SubPlugin(TdcPlugin):
+    def __init__(self):
+        self.sub_class = 'scapy/SubPlugin'
+        super().__init__()
+
+    def post_execute(self):
+        if 'scapy' not in self.args.caseinfo:
+            if self.args.verbose:
+                print('{}.post_execute: no scapy info in test case'.format(self.sub_class))
+            return
+
+        # Check for required fields
+        scapyinfo = self.args.caseinfo['scapy']
+        scapy_keys = ['iface', 'count', 'packet']
+        missing_keys = []
+        keyfail = False
+        for k in scapy_keys:
+            if k not in scapyinfo:
+                keyfail = True
+                missing_keys.add(k)
+        if keyfail:
+            print('{}: Scapy block present in the test, but is missing info:'
+                .format(self.sub_class))
+            print('{}'.format(missing_keys))
+
+        pkt = eval(scapyinfo['packet'])
+        if '$' in scapyinfo['iface']:
+            tpl = Template(scapyinfo['iface'])
+            scapyinfo['iface'] = tpl.safe_substitute(NAMES)
+        for count in range(scapyinfo['count']):
+            sendp(pkt, iface=scapyinfo['iface'])
+
-- 
2.7.4

