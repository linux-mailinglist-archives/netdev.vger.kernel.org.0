Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF80E62D77
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 03:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfGIBfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 21:35:01 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:38179 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbfGIBfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 21:35:00 -0400
Received: by mail-io1-f68.google.com with SMTP id j6so39667484ioa.5
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 18:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=k5gtM+GjzBzhf6gLCQ9GHJxOvu7GTieWSMBNA0fvn4s=;
        b=dFRgsToTLvHs0NoF8fEwsadQbXjSu37v5PnSxA+VzbhY/zrPty5H72qlLwDx6faNP9
         QTGOpEwdix0Eb5HYls2o7+T3uVcRPpei+lWkXPwYgryIFnC/ir9B+mQ0xIyjb+3dHTKF
         vsBw6c40QTb4nSeAY8OnwintFTIIc5qPGDErPhWyF/yaKBKajuszdXDCzmktmz3Z4ddc
         +kTxxgtJBj9ANVd/u6U0KhrfjnKzJRXOCOPnOTj5Z1scrfAM/lBDMU11TQpkEddzAiMC
         cT/WIWotAhcwdXcOu682Xlh6VbfQo+byFWwLie6VfXNRJGe6Ut3dCh67XT+9bN3EnWhn
         lYBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=k5gtM+GjzBzhf6gLCQ9GHJxOvu7GTieWSMBNA0fvn4s=;
        b=sHXCTM7rL25phjwsFpTZbKuT1uz8x6s9jd5c1UV+bLYX1sttHZta2Dkm7I0IUovica
         MBUooZGR8evtaODVNZwmNYy/U8OmE9RfIhTK4bsjAkgjT81To648OHW/y0510FU+PKVt
         B01VSZ9qkiqID27nwylNrhrr0alAwAcuWHM8QUALXpZf3PcMekMu+j5gqexnuSrJoSa1
         FsnJwa591eDyauktChU0e/EMIThvtz+puNAZfxysY6/G/PC/CX+8Jr1S4qFh9RArO2fa
         +DsZ6/7AVbEArOkl0INCaTO092ZL2URJDdLAFPoeTzAU3j/lnSP3oPQW/oKiM+6d+jpi
         7MOA==
X-Gm-Message-State: APjAAAVwTrsc8pN44vUHw/fGpWXcRpbsENzLgDP3EDteRhz18VntSaCC
        GzHsMF4ejbkeh30PF25ZAbqvhw==
X-Google-Smtp-Source: APXvYqwQLNwZAsH1zJOuclhnwRxTtMldLFrwUYk0SLWKkEbk7kMXZihAKGrWGLDSnb1HLe8EXzERww==
X-Received: by 2002:a6b:5106:: with SMTP id f6mr20413108iob.15.1562636099210;
        Mon, 08 Jul 2019 18:34:59 -0700 (PDT)
Received: from mojatatu.com ([2607:f2c0:e4b2:adf:80be:fc0b:d6c4:7dbc])
        by smtp.gmail.com with ESMTPSA id n17sm17894248iog.63.2019.07.08.18.34.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 08 Jul 2019 18:34:58 -0700 (PDT)
From:   Lucas Bates <lucasb@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, mleitner@redhat.com, vladbu@mellanox.com,
        dcaratti@redhat.com, kernel@mojatatu.com,
        Lucas Bates <lucasb@mojatatu.com>
Subject: [PATCH net-next 2/2] tc-testing: introduce scapyPlugin for basic traffic
Date:   Mon,  8 Jul 2019 21:34:27 -0400
Message-Id: <1562636067-1338-3-git-send-email-lucasb@mojatatu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562636067-1338-1-git-send-email-lucasb@mojatatu.com>
References: <1562636067-1338-1-git-send-email-lucasb@mojatatu.com>
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
fail.

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

