Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E334210DCF
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 16:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731572AbgGAOds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 10:33:48 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:58933 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730852AbgGAOds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 10:33:48 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id C9A3B5801C9;
        Wed,  1 Jul 2020 10:33:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 01 Jul 2020 10:33:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=tF8ID95sHNGuWvwbl8lC69GFVu/uidTRz8z3jU2/1H4=; b=Z52giuKR
        M3S4DWYR88ZCexi23a+ggTPwhvnVMN1cHHbU/XcVb0WpETOqTl1cI23nPrQNi8UI
        KQQQ3soyBlKE1EM36iXdvGpO48X1YgaXyGJLm0FW9zSnnynhup8401gsMnJSZYbE
        Pj3nuTH6dgNorgdvsIt1q9LB/3fncqR2kT83j/+R1GrjND7UAEL+9BULKFmcs2vR
        Dk+MBaljOSp2FcbUC2lp8vAz7tbKrfBCQpW25KNUrQD1pD0UsFDbannV7pPBnmRb
        INsG2pu8KrP0TKBLnljDb3LH2wlNQOk1dj16uX0Ywj7uEM9j5OHdzmeBYW7LLGLp
        dEr8RsYkHX1Zng==
X-ME-Sender: <xms:yZ78XuWd4ir0PUyttN-9DRNs9s_0tWkVfalDd8MTGhhUt6tvEiy3bQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrtddvgdejlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepudelfedrgeejrdduieehrddvhedu
    necuvehluhhsthgvrhfuihiivgepjeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:yZ78XqkUa0k4oiosZnsHmHK4a1O7m9ikhxNRxLPSz8_y1ZvWo2D8KA>
    <xmx:yZ78Xib6Uwg3MPK5p6DeaTPc9W2bYIub90O-0qLor7T042eK0l1Pvg>
    <xmx:yZ78XlUSa9LbkJbPqDpdj9V3OoZl1Gm8IZXDc8FQnvgROl4_BLMkoA>
    <xmx:yZ78Xhe3xpr0z07qTSOX2aH-5yrx-lO18DcFNkrfgbqQX4dusy1ofQ>
Received: from shredder.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3EF9A3280059;
        Wed,  1 Jul 2020 10:33:42 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, michael.chan@broadcom.com,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, snelson@pensando.io, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 9/9] selftests: net: Add port split test
Date:   Wed,  1 Jul 2020 17:32:51 +0300
Message-Id: <20200701143251.456693-10-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701143251.456693-1-idosch@idosch.org>
References: <20200701143251.456693-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

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
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/devlink_port_split.py       | 259 ++++++++++++++++++
 2 files changed, 260 insertions(+)
 create mode 100755 tools/testing/selftests/net/devlink_port_split.py

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index bfacb960450f..9491bbaa0831 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -18,6 +18,7 @@ TEST_PROGS += reuseaddr_ports_exhausted.sh
 TEST_PROGS += txtimestamp.sh
 TEST_PROGS += vrf-xfrm-tests.sh
 TEST_PROGS += rxtimestamp.sh
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
2.26.2

