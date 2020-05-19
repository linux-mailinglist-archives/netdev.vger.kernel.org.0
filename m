Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DB21D9808
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbgESNlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:41:20 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:51279 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729065AbgESNlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:41:17 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 0DA7C581898;
        Tue, 19 May 2020 09:41:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 19 May 2020 09:41:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=5upsxQk2XKbFjulpofwFMfAsawZI4MEtV2fO812HZEo=; b=SyApaBxJ
        /cwmg0ssJPd+2XyyudKjVbmbW5NB+w6dugkA/CdVJB2W5zjyAjrmwQ5OWFFEjbmW
        ztVKQdCxRiVfU3HovEeS6OCXhlZ9CSsN/LVY2u3dU0gh1BDAgI2Rqu2WWwwCBI3A
        NA0NKXBwXCA6X+59oCmWN+mKc4qFQRY80S81Nxkjn5QnhJiUiaGPZXJeoVcCyPFa
        QHiw2MkqivjXXgc9QJ3pyZ+Zf89LRWQm79NOZrM6ChJZjsmkdM7Kyq4JEJGDV5WI
        ttNQ5CX01VtERSkSehVeBMmYNP+XDHAnBYLOAMs/xMl+HR2mxfuOrj1TuYBWJuwO
        Pdb57y59e79GSg==
X-ME-Sender: <xms:-uHDXn9s8cGsha9S47BwEITHSC4YZ0d62GfKWp7Tdl-s7mPKS1OBBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddtjedgieejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:-uHDXjtoT-rLoUuF4mqpFv7JAtBvRR6wtD-AalDTGzMheThWZKqnxQ>
    <xmx:-uHDXlC7OFNMiTA4WEGd0B4obEl9G6ausRvwLXIPghTKOaJ88gijPw>
    <xmx:-uHDXjcNFbo1DtAR2pqtYSl8_RbiwY2-MERQSVyRSqWDP9rWctbBHA>
    <xmx:--HDXllyXTczrf9NLI3vUW579xuxnMQ37COiJ4t1To3ywIsVUXnqPg>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4C0F63280066;
        Tue, 19 May 2020 09:41:12 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        michael.chan@broadcom.com, jeffrey.t.kirsher@intel.com,
        saeedm@mellanox.com, leon@kernel.org, snelson@pensando.io,
        drivers@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/3] selftests: net: Add port split test
Date:   Tue, 19 May 2020 16:40:32 +0300
Message-Id: <20200519134032.1006765-4-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200519134032.1006765-1-idosch@idosch.org>
References: <20200519134032.1006765-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

Test port split configuration using previously added port's width
attribute.

Check that all the splittable ports are successfully split to their
width and below, and that those which are not splittable fail to be
split.

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
index 000000000000..e5ce331df233
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
+# Test port split configuration using devlink-port width attribute.
+# The test is skipped in case the attribute is not available.
+#
+# First, check that all the ports with a width of 1 fail to split.
+# Second, check that all the ports with a width larger than 1 can be split
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
+def get_width(port):
+    """
+    Get the width of $port.
+    Return: width, e.g. 1, 2, 4 and 8.
+    """
+
+    cmd = "devlink -j port show %s" % port
+    stdout, stderr = run_command(cmd)
+    assert stderr == ""
+    values = list(json.loads(stdout)['port'].values())[0]
+
+    if 'width' in values:
+        width = values['width']
+    else:
+        width = 0
+    return width
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
+def exists_and_width(ports, lanes, dev):
+    """
+    Check if every port in the list $ports exists in the devlink ports and has
+    $lanes number of lanes after splitting.
+    Return: True if both are True, False otherwise.
+    """
+
+    for port in ports:
+        width = get_width(port)
+        if not exists(port, dev):
+            print("port %s doesn't exist in devlink ports" % port)
+            return False
+        if width != lanes:
+            print("port %s has %d lanes, but %s were expected"
+                  % (port, lanes, width))
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
+def split_splittable_port(port, k, width, dev):
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
+        test(exists_and_width(new_split_group, width/k, dev),
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
+        width = get_width(port.name)
+
+        # If width is 0, do not test port splitting at all
+        if width == 0:
+            continue
+
+        # If 1 lane, shouldn't be able to split
+        elif width == 1:
+            split_unsplittable_port(port, width)
+
+        # Else, splitting should pass and all the split ports should exist.
+        else:
+            lane = width
+            while lane > 1:
+                split_splittable_port(port, lane, width, dev)
+
+                lane //= 2
+
+
+if __name__ == "__main__":
+    main()
-- 
2.26.2

