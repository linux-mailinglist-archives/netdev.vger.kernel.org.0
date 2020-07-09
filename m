Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B95C21A0AD
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgGINTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:19:51 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:48133 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726947AbgGINTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 09:19:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7A0915804D1;
        Thu,  9 Jul 2020 09:19:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 09 Jul 2020 09:19:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=vWbqJe3KAW8zP2+4B2dPehOrHYa0VCDKnuPwLsEenOs=; b=WeW2tWsK
        3FZDwIHhtPdimICJ3wLX/taW2D8R//1bY8w4AldsSwqR4EaIoQ4uvomIIGWaX2x1
        iCeYZx+y9GCLGBFiySfjvuAYdBtgftiEKVpmiTaEiNoGO+XiUqo3Nx0u2yacx7Q/
        BitnDjsWV0R2dIB/QGiNqZOoF+d7hJ/RzoUIbkDYIzE5YNB9PbOFvFHT/0do1gW4
        h7vQchlGwbwsMYkrju7FZJfswCjQB8q10sqHtdv9sJ8Gd7uxn7fu5j8fyOqTkic1
        esxDrN1ebyLPcUlcJXGBYdKoY0nsNmwefXELyCH1axROdkcDjTFriORys/uGWQDc
        UIWWka8/a80xMQ==
X-ME-Sender: <xms:YxkHX0QsAQ-pnZAeWIXT9iet38y1ua__Ew-9E_rCB6PF7QV_aqVYyQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudelgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:YxkHXxwN63__1__gmDY1z_wlM4A5Cv5YtfHk-Cfq4SMDlIrs_QH8-A>
    <xmx:YxkHXx0VDPpAEAGXrKRk4TJGTdoEMB2CSw3DxYQEtjKUa72bqA9GEw>
    <xmx:YxkHX4B3vDPNuEZ_oM-HgsbgvMHfObtRhVVd7GQn3WXnLanvecaidw>
    <xmx:YxkHXyZeW25TBhidEWPj698nxh1M-JPfSQ6sqwAzJkU7JFQvV7nhvw>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2899C328005A;
        Thu,  9 Jul 2020 09:19:27 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, michael.chan@broadcom.com,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, snelson@pensando.io, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 9/9] selftests: net: Add port split test
Date:   Thu,  9 Jul 2020 16:18:22 +0300
Message-Id: <20200709131822.542252-10-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200709131822.542252-1-idosch@idosch.org>
References: <20200709131822.542252-1-idosch@idosch.org>
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
 .../selftests/net/devlink_port_split.py       | 277 ++++++++++++++++++
 2 files changed, 278 insertions(+)
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
index 000000000000..58bb7e9b88ce
--- /dev/null
+++ b/tools/testing/selftests/net/devlink_port_split.py
@@ -0,0 +1,277 @@
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
+def get_split_ability(port):
+    """
+    Get the $port split ability.
+    Return: split ability, true or false.
+    """
+
+    cmd = "devlink -j port show %s" % port.name
+    stdout, stderr = run_command(cmd)
+    assert stderr == ""
+    values = list(json.loads(stdout)['port'].values())[0]
+
+    return values['splittable']
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
+            test(not get_split_ability(port),
+                 "%s should not be able to split" % port.name)
+            split_unsplittable_port(port, max_lanes)
+
+        # Else, splitting should pass and all the split ports should exist.
+        else:
+            lane = max_lanes
+            test(get_split_ability(port),
+                 "%s should be able to split" % port.name)
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

