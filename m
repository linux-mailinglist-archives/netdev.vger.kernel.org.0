Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4B91EBA73
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 13:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgFBLc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 07:32:26 -0400
Received: from mail-vi1eur05on2085.outbound.protection.outlook.com ([40.107.21.85]:6161
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725966AbgFBLcV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 07:32:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTbWwh+c7EhHpyQSbBv2jh0gSzjCZdipaQ10oDRXEL9/Y13TtaHqqCUshBU1yjOgxfqIOb9iOwmKU1RPRoVPWeuAn5ZOnFbK+RPD0LFBmt7PySBlskAjcaY5OA1WNnO9UGPGsFtPhkVMBLSmznop+zVtp+Shgd6/PMrePxa3yp5GcVSnTHx4BpXRFznxzg0705cndrDBI19wmn/kHv5EfEryZTv4/zs7CHtJ5caYp94B14nZiO1otfj8dBxAQEXWwNOkhK+Jiivd8xpkcvE9CVNzH+1bzWbqrNIMV+sybHQM0AvuqYGK47CK4iPIpjqCyB47YVAS/vrCAtaAKIvnvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKTaYrzeVZBMWGSs3/baIf5DaIoaZ6qksQkw+KNvybU=;
 b=R0n5kpqDWVavSqE2YyXjCd+Qc2U1nqiSP5WZ9pAw2v1AgsdQW/w99A8AwVooGC6B9+njKu69CnafXS3yw2yng+wmMGmxlZ+xKFyIfC2x6qIlZBBj50c3xa4IqbT+Y9YxTgRnhoZlVeu9oE4IgHkAeDknaT8tgnSgeoQ2ST/jcTyZJYd+4SJGWW1iq6WwzQGuaGSqarRXcdRYyBunXhghryBKT9hWXyybkXO2ETzFSA95cgPQXmtCceVLUm3FMr7bywfGbmN/5kuSobbNQPvjwIUR4ogLdp9Ez02/OW5FLU++b6wL6YdE0qXiDeSdA6b3DEtguTnP8rgoU5pGA3LLqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKTaYrzeVZBMWGSs3/baIf5DaIoaZ6qksQkw+KNvybU=;
 b=AQtvtX0DbFBfzZ3QfvIh8dqLOg9fNcUqYuVIsDRmaa7RYcy9mt2dD5EnPQVMo8vvv+qPlRRYk1D1Pk3pvrEDAK7Gvnt/g7YS5AEDVYULBc/Pnoj8nfR2mPFTP//MEewL6W8+kx78rSdvQt/Hm/tVfnrr06uM1z3bIwxWClP+O78=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB6628.eurprd05.prod.outlook.com (2603:10a6:20b:15b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Tue, 2 Jun
 2020 11:32:07 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182%6]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 11:32:07 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, michael.chan@broadcom.com, kuba@kernel.org,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com, snelson@pensando.io,
        drivers@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, mlxsw@mellanox.com,
        Danielle Ratson <danieller@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [RFC PATCH net-next 8/8] selftests: net: Add port split test
Date:   Tue,  2 Jun 2020 14:31:19 +0300
Message-Id: <20200602113119.36665-9-danieller@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200602113119.36665-1-danieller@mellanox.com>
References: <20200602113119.36665-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::24) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM4P190CA0014.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21 via Frontend Transport; Tue, 2 Jun 2020 11:32:05 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e27ddfc2-8778-4931-430e-08d806e8949b
X-MS-TrafficTypeDiagnostic: AM0PR05MB6628:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB6628192E70658504D7CCF146D58B0@AM0PR05MB6628.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:660;
X-Forefront-PRVS: 0422860ED4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KGMfUjbYBQWUBOO0uuhPzFdnieCCMuEsaJSDCFThwc1nD5RnVG1dfmuew0yJg4E64GdaMUh/Rpg+JI2zpc+eI+fyHmRAYlZ0bjnwcXSx+WDARdJ9jjW2Caw3DXtf2hbrQF+L94oZnPDmHDq/VYqMJZe+CLKIF1D/TOwS11n8pWupiOkBGZ3xvcexxVTnRM/Sgy7SGifcoNGchLYN0paHh4L9HyZAI1Y9GG3HOJbvUfIcKaTIDB1h06YV5SHF74GlAlUtewr9AlFITxKjBNc+sQIqksKiWglarBWy7/drtxKwFBPEZiF0Iths2hkyfW3CcqnO24c1rTmK254Ppjq6Ew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(186003)(16526019)(26005)(83380400001)(6506007)(86362001)(36756003)(2616005)(54906003)(2906002)(52116002)(107886003)(6916009)(956004)(6486002)(8676002)(7416002)(66556008)(478600001)(6666004)(6512007)(66476007)(66946007)(5660300002)(316002)(4326008)(8936002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RYgYeyY2iVZpammOtRbUebB1KL41pyRkiLtX4woPXQqmmjlpwSmpCrbU6mhBA77wsPISGlDaDqDFObleHYbtYX3XtqWylQhlJf60LWjpyCOmERPIdIGPQjFmD/t9nl6kwXd0F/IoFcZayKdbr+Uepb13AgCanToVk/qR0TO3HlZ4Eo/Cj2K6RuV3WmRoIDQaTEvKhLZxWazmGxiQ4IyxmEemDwQJZLlJGLUgqSZLHCq1I9sgw/vCgt1PArJAYua+Vnl83ZEh6fMquvkQeVmJ2Tw+g+mvbsg2VVO5PEkyxEY1sqsbPpg895IOaEDyxhGcQ7b1xgs2Pi2fjeKGBf1/Nz6q/5JY1UnMcm7g9UeARZQZn/ulbDo2fDzThGPHu2YfubSou4aKw/6cDHWhwxxHD9UVHSVChDkdeg2SkiFzz2ncdwcY7vryxpisO/rP9RSg3V6y4dXQ6OLTn21W1b9Gv8VE2tu+9I5AdpudxfhByV2QUHCdFOsYi5H+nUbVOxze
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e27ddfc2-8778-4931-430e-08d806e8949b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2020 11:32:07.1096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: llbArnBmwsFLPUErIh6mqYP1pXQO8lFmCMmScb1ksPEB1ZibdBOdBktPuaBTqNqQI6si74Br2j+AcmdSO0tg8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6628
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test port split configuration using previously added number of port lanes
attribute.

Check that all the splittable ports are successfully split to their maximum
number of lanes and below, and that those which are not splittable fail to
be split.

Test output example:

TEST: swp4 is unsplittable                                         [ OK ]
TEST: split port swp53 into 4                                      [ OK ]
TEST: Unsplit port pci/0000:03:00.0/25                             [ OK ]
TEST: split port swp53 into 2                                      [ OK ]
TEST: Unsplit port pci/0000:03:00.0/25                             [ OK ]

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
---
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/devlink_port_split.py       | 259 ++++++++++++++++++
 2 files changed, 260 insertions(+)
 create mode 100755 tools/testing/selftests/net/devlink_port_split.py

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 895ec992b2f1..90fcf8ba9ed0 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -17,6 +17,7 @@ TEST_PROGS += route_localnet.sh
 TEST_PROGS += reuseaddr_ports_exhausted.sh
 TEST_PROGS += txtimestamp.sh
 TEST_PROGS += vrf-xfrm-tests.sh
+TEST_PROGS += devlink_port_split.py
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
diff --git a/tools/testing/selftests/net/devlink_port_split.py b/tools/testing/selftests/net/devlink_port_split.py
new file mode 100755
index 000000000000..738bee04e1eb
--- /dev/null
+++ b/tools/testing/selftests/net/devlink_port_split.py
@@ -0,0 +1,259 @@
+#!/usr/bin/python3
+# SPDX-License-Identifier: GPL-2.0
+
+from subprocess import PIPE, Popen
+import json
+import time
+import argparse
+import collections
+import sys
+
+#
+# Test port split configuration using devlink-port lanes attribute.
+# The test is skipped in case the attribute is not available.
+#
+# First, check that all the ports with 1 lane fail to split.
+# Second, check that all the ports with more than 1 lane can be split
+# to all valid configurations (e.g., split to 2, split to 4 etc.)
+#
+
+
+Port = collections.namedtuple('Port', 'bus_info name')
+
+
+def run_command(cmd, should_fail=False):
+    """
+    Run a command in subprocess.
+    Return: Tuple of (stdout, stderr).
+    """
+
+    p = Popen(cmd, stdout=PIPE, stderr=PIPE, shell=True)
+    stdout, stderr = p.communicate()
+    stdout, stderr = stdout.decode(), stderr.decode()
+
+    if stderr != "" and not should_fail:
+        print("Error sending command: %s" % cmd)
+        print(stdout)
+        print(stderr)
+    return stdout, stderr
+
+
+class devlink_ports(object):
+    """
+    Class that holds information on the devlink ports, required to the tests;
+    if_names: A list of interfaces in the devlink ports.
+    """
+
+    def get_if_names(dev):
+        """
+        Get a list of physical devlink ports.
+        Return: Array of tuples (bus_info/port, if_name).
+        """
+
+        arr = []
+
+        cmd = "devlink -j port show"
+        stdout, stderr = run_command(cmd)
+        assert stderr == ""
+        ports = json.loads(stdout)['port']
+
+        for port in ports:
+            if dev in port:
+                if ports[port]['flavour'] == 'physical':
+                    arr.append(Port(bus_info=port, name=ports[port]['netdev']))
+
+        return arr
+
+    def __init__(self, dev):
+        self.if_names = devlink_ports.get_if_names(dev)
+
+
+def get_max_lanes(port):
+    """
+    Get the $port's maximum number of lanes.
+    Return: number of lanes, e.g. 1, 2, 4 and 8.
+    """
+
+    cmd = "devlink -j port show %s" % port
+    stdout, stderr = run_command(cmd)
+    assert stderr == ""
+    values = list(json.loads(stdout)['port'].values())[0]
+
+    if 'lanes' in values:
+        lanes = values['lanes']
+    else:
+        lanes = 0
+    return lanes
+
+
+def split(k, port, should_fail=False):
+    """
+    Split $port into $k ports.
+    If should_fail == True, the split should fail. Otherwise, should pass.
+    Return: Array of sub ports after splitting.
+            If the $port wasn't split, the array will be empty.
+    """
+
+    cmd = "devlink port split %s count %s" % (port.bus_info, k)
+    stdout, stderr = run_command(cmd, should_fail=should_fail)
+
+    if should_fail:
+        if not test(stderr != "", "%s is unsplittable" % port.name):
+            print("split an unsplittable port %s" % port.name)
+            return create_split_group(port, k)
+    else:
+        if stderr == "":
+            return create_split_group(port, k)
+        print("didn't split a splittable port %s" % port.name)
+
+    return []
+
+
+def unsplit(port):
+    """
+    Unsplit $port.
+    """
+
+    cmd = "devlink port unsplit %s" % port
+    stdout, stderr = run_command(cmd)
+    test(stderr == "", "Unsplit port %s" % port)
+
+
+def exists(port, dev):
+    """
+    Check if $port exists in the devlink ports.
+    Return: True is so, False otherwise.
+    """
+
+    return any(dev_port.name == port
+               for dev_port in devlink_ports.get_if_names(dev))
+
+
+def exists_and_lanes(ports, lanes, dev):
+    """
+    Check if every port in the list $ports exists in the devlink ports and has
+    $lanes number of lanes after splitting.
+    Return: True if both are True, False otherwise.
+    """
+
+    for port in ports:
+        max_lanes = get_max_lanes(port)
+        if not exists(port, dev):
+            print("port %s doesn't exist in devlink ports" % port)
+            return False
+        if max_lanes != lanes:
+            print("port %s has %d lanes, but %s were expected"
+                  % (port, lanes, max_lanes))
+            return False
+    return True
+
+
+def test(cond, msg):
+    """
+    Check $cond and print a message accordingly.
+    Return: True is pass, False otherwise.
+    """
+
+    if cond:
+        print("TEST: %-60s [ OK ]" % msg)
+    else:
+        print("TEST: %-60s [FAIL]" % msg)
+
+    return cond
+
+
+def create_split_group(port, k):
+    """
+    Create the split group for $port.
+    Return: Array with $k elements, which are the split port group.
+    """
+
+    return list(port.name + "s" + str(i) for i in range(k))
+
+
+def split_unsplittable_port(port, k):
+    """
+    Test that splitting of unsplittable port fails.
+    """
+
+    # split to max
+    new_split_group = split(k, port, should_fail=True)
+
+    if new_split_group != []:
+        unsplit(port.bus_info)
+
+
+def split_splittable_port(port, k, lanes, dev):
+    """
+    Test that splitting of splittable port passes correctly.
+    """
+
+    new_split_group = split(k, port)
+
+    # Once the split command ends, it takes some time to the sub ifaces'
+    # to get their names. Use udevadm to continue only when all current udev
+    # events are handled.
+    cmd = "udevadm settle"
+    stdout, stderr = run_command(cmd)
+    assert stderr == ""
+
+    if new_split_group != []:
+        test(exists_and_lanes(new_split_group, lanes/k, dev),
+             "split port %s into %s" % (port.name, k))
+
+    unsplit(port.bus_info)
+
+
+def make_parser():
+    parser = argparse.ArgumentParser(description='A test for port splitting.')
+    parser.add_argument('--dev',
+                        help='The devlink handle of the device under test. ' +
+                             'The default is the first registered devlink ' +
+                             'handle.')
+
+    return parser
+
+
+def main(cmdline=None):
+    parser = make_parser()
+    args = parser.parse_args(cmdline)
+
+    dev = args.dev
+    if not dev:
+        cmd = "devlink -j dev show"
+        stdout, stderr = run_command(cmd)
+        assert stderr == ""
+
+        devs = json.loads(stdout)['dev']
+        dev = list(devs.keys())[0]
+
+    cmd = "devlink dev show %s" % dev
+    stdout, stderr = run_command(cmd)
+    if stderr != "":
+        print("devlink device %s can not be found" % dev)
+        sys.exit(1)
+
+    ports = devlink_ports(dev)
+
+    for port in ports.if_names:
+        max_lanes = get_max_lanes(port.name)
+
+        # If max lanes is 0, do not test port splitting at all
+        if max_lanes == 0:
+            continue
+
+        # If 1 lane, shouldn't be able to split
+        elif max_lanes == 1:
+            split_unsplittable_port(port, max_lanes)
+
+        # Else, splitting should pass and all the split ports should exist.
+        else:
+            lane = max_lanes
+            while lane > 1:
+                split_splittable_port(port, lane, max_lanes, dev)
+
+                lane //= 2
+
+
+if __name__ == "__main__":
+    main()
-- 
2.20.1

