Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1937B103AB0
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730063AbfKTNFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:05:33 -0500
Received: from mail-eopbgr130051.outbound.protection.outlook.com ([40.107.13.51]:19220
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730040AbfKTNFa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 08:05:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BLFqS2c0U2xb114F9ViW2DX6J0wmK1cqlYkRufn17mZjrS8PM0hL1mdM7YUErIttykVqH6VjrqDG6QxIfXG3XohVCcxkuhquVkAExF/FNCuSOSXA9DJ6QTwJC5NHKV69MpEKlBfT+/2/lVbx+EOcP6hZYBkL+XHxp8z3Blds3lJcKuE3COjF0GDZONBwJGOT9zILJq5kruzO8fBGath/0T2zSieZI6jAB6wIrvulPJggss8Ypp2LxPG3zb2SaHvpp3LWjWmd6d716n6p3n5Jj8EgFMUS8qefEFTwyR75Gcjc8kK95MdwF2Yi/xZJ9Qj/HmQxbBQCXGjfT17hY8YHWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cu1w/N+G2ZBCVtN2b6b7QMlPCYITWF5XN6y07YNtJA4=;
 b=hxoCKuh5qX1Ke3v/ao61/Y9WXhTz0avVJR0F9Py/XVWojuTHIULMlnUnv9OciIq61uiL+Pu/HvxDwFcpdWsT6I/osaQsdi51e6HaXyYgx+vAilaIG0lp86GaFXDjVjq3gDIwHY+h4N4Yg0g5eaXK4tHCrv/Jryl0N6LX71npEAgiKLF6MYbI35j3t17XMEVnAQDUXEAHHjcBked656UvX1bf+ByGZEEGBmQJSVX6TQHxjLN9UgSabEpKlOs7/lxWdVonyaonIrUB79gd2qUI1vhKHpB1/LdThyZikl2X3v8jHHX8Qp8VVxdA0Nbj1t2ekogE1OwyQZBSu6hv+gyV+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cu1w/N+G2ZBCVtN2b6b7QMlPCYITWF5XN6y07YNtJA4=;
 b=qrGMzgx8zOtdyzuN8zVYj68JDwcTHbESNZF/HDhbWWkykfu4Iv6vCO9/s78MxWAaOIUHkFBkfDyFGpqCqlSRRvuP8DhbFcIm/znKHChl6gmP+kjRIAHtziQe2TVmhz1Lynui30rocJOFehR/qA/8fe6nPaMYEsfP6kpySRWiFSI=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB2982.eurprd05.prod.outlook.com (10.172.246.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.29; Wed, 20 Nov 2019 13:05:18 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521%7]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 13:05:18 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [RFC PATCH 09/10] selftests: forwarding: sch_ets: Add test coverage
 for ETS Qdisc
Thread-Topic: [RFC PATCH 09/10] selftests: forwarding: sch_ets: Add test
 coverage for ETS Qdisc
Thread-Index: AQHVn6Mo1BYtqicqA0SUxPk1jzAULg==
Date:   Wed, 20 Nov 2019 13:05:18 +0000
Message-ID: <177821ae247071f72ea74b42d8036afebc73293e.1574253236.git.petrm@mellanox.com>
References: <cover.1574253236.git.petrm@mellanox.com>
In-Reply-To: <cover.1574253236.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: LO2P265CA0375.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::27) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a0b52071-af1f-4313-bc23-08d76dba4a95
x-ms-traffictypediagnostic: DB6PR0502MB2982:|DB6PR0502MB2982:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB2982DF4D7D37514E335F3166DB4F0@DB6PR0502MB2982.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1201;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(52314003)(189003)(199004)(102836004)(1730700003)(6436002)(2616005)(446003)(50226002)(81156014)(81166006)(478600001)(66556008)(8936002)(66476007)(66946007)(14454004)(5640700003)(6506007)(2906002)(386003)(36756003)(66446008)(66066001)(8676002)(6486002)(26005)(186003)(54906003)(7736002)(316002)(6512007)(305945005)(76176011)(71190400001)(71200400001)(2351001)(256004)(64756008)(30864003)(2501003)(52116002)(86362001)(14444005)(486006)(6116002)(11346002)(3846002)(5660300002)(25786009)(99286004)(476003)(6916009)(4326008)(118296001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB2982;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GzuYgKWgoz7AToABRM/WKzG8+tmkPMlZIv1LNPQewPbNUnaARQPkRdH1LEULu8r2HOYtasgLqOyI0T8jKZ3AWL61lGx0DqZGDhNxUk7jAzeQKZb/5Sg9tbsXYnlV/tTJGmAlQW8KKzdVpQjtwJMopvC+qqKTjuhCGJqeUZPoKjdpGgH/Oz8nR8nt0yLdjzvZ8rqEkkB1iKM6rGlsoq8P3smVrhHZXFoLhyLNE2FBJzBvozjykOjbOWTTko3SRDF+iL6kq6IOu5CiOYpTah+ijjvN5rAo2SVy9En0y8Nbf7M964L4nAIiHsn1w2vnelC0THaULRk7fmPGIocxzkjHcAsFZYdig/IQmQ3JuvnKHgWmp0FRvdC+6BysRbFtbGgYlAdhL3kEO54lkn4MAMC+THNOit+nLJwA+8dx3cRtfPg2qbcsf6g71UXyRHL4YSn5
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0b52071-af1f-4313-bc23-08d76dba4a95
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 13:05:18.1565
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FPo96+jzrSFBEqTSS3ryr5ZYZl54oVlY4lG6LgNpyZikjGpUXFsjhwngL16R2L3/Sv+3wWKH+YspiyF7HyhGTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB2982
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This tests the newly-added ETS Qdisc. It runs two to three streams of
traffic, each with a different priority. ETS Qdisc is supposed to allocate
bandwidth according to the DRR algorithm and given weights. After running
the traffic for a while, counters are compared for each stream to check
that the expected ratio is in fact observed.

In order for the DRR process to kick in, a traffic bottleneck must exist in
the first place. In slow path, such bottleneck can be implemented by
wrapping the ETS Qdisc inside a TBF or other shaper. This might however
make the configuration unoffloadable. Instead, on HW datapath, the
bottleneck would be set up by lowering port speed and configuring shared
buffer suitably.

Therefore the test is structured as a core component that implements the
testing, with two wrapper scripts that implement the details of slow path
resp. fast path configuration.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 .../selftests/drivers/net/mlxsw/qos_lib.sh    |  28 +++
 .../selftests/drivers/net/mlxsw/sch_ets.sh    |  54 ++++
 .../selftests/net/forwarding/sch_ets.sh       |  30 +++
 .../selftests/net/forwarding/sch_ets_core.sh  | 229 +++++++++++++++++
 .../selftests/net/forwarding/sch_ets_tests.sh | 230 ++++++++++++++++++
 5 files changed, 571 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh
 create mode 100755 tools/testing/selftests/net/forwarding/sch_ets.sh
 create mode 100644 tools/testing/selftests/net/forwarding/sch_ets_core.sh
 create mode 100644 tools/testing/selftests/net/forwarding/sch_ets_tests.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh b/tools/t=
esting/selftests/drivers/net/mlxsw/qos_lib.sh
index 75a3fb3b5663..a5937069ac16 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh
@@ -78,3 +78,31 @@ measure_rate()
 	echo $ir $er
 	return $ret
 }
+
+bail_on_lldpad()
+{
+	if systemctl is-active --quiet lldpad; then
+
+		cat >/dev/stderr <<-EOF
+		WARNING: lldpad is running
+
+			lldpad will likely configure DCB, and this test will
+			configure Qdiscs. mlxsw does not support both at the
+			same time, one of them is arbitrarily going to overwrite
+			the other. That will cause spurious failures (or,
+			unlikely, passes) of this test.
+		EOF
+
+		if [[ -z $ALLOW_LLDPAD ]]; then
+			cat >/dev/stderr <<-EOF
+
+				If you want to run the test anyway, please set
+				an environment variable ALLOW_LLDPAD to a
+				non-empty string.
+			EOF
+			exit 1
+		else
+			return
+		fi
+	fi
+}
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh b/tools/t=
esting/selftests/drivers/net/mlxsw/sch_ets.sh
new file mode 100755
index 000000000000..1d70d89d2b1a
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh
@@ -0,0 +1,54 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# A driver for the ETS selftest that implements testing in offloaded datap=
ath.
+lib_dir=3D$(dirname $0)/../../../net/forwarding
+source $lib_dir/sch_ets_core.sh
+source $lib_dir/devlink_lib.sh
+source qos_lib.sh
+
+switch_create()
+{
+	ets_switch_create
+
+	# Create a bottleneck so that the DWRR process can kick in.
+	ethtool -s $h2 speed 1000 autoneg off
+	ethtool -s $swp2 speed 1000 autoneg off
+
+	# Set the ingress quota high and use the three egress TCs to limit the
+	# amount of traffic that is admitted to the shared buffers. This makes
+	# sure that there is always enough traffic of all types to select from
+	# for the DWRR process.
+
+	devlink_port_pool_th_set $swp1 0 12
+	devlink_tc_bind_pool_th_set $swp1 0 ingress 0 12
+	devlink_port_pool_th_set $swp2 4 12
+	devlink_tc_bind_pool_th_set $swp2 7 egress 4 5
+	devlink_tc_bind_pool_th_set $swp2 6 egress 4 5
+	devlink_tc_bind_pool_th_set $swp2 5 egress 4 5
+}
+
+switch_destroy()
+{
+	devlink_tc_bind_pool_th_restore $swp2 5 egress
+	devlink_tc_bind_pool_th_restore $swp2 6 egress
+	devlink_tc_bind_pool_th_restore $swp2 7 egress
+	devlink_port_pool_th_restore $swp2 4
+	devlink_tc_bind_pool_th_restore $swp1 0 ingress
+	devlink_port_pool_th_restore $swp1 0
+
+	ethtool -s $swp2 autoneg on
+	ethtool -s $h2 autoneg on
+
+	ets_switch_destroy
+}
+
+get_stats()
+{
+	local band=3D$1; shift
+
+	ethtool_stats_get "$h2" rx_octets_prio_$band
+}
+
+bail_on_lldpad
+ets_run
diff --git a/tools/testing/selftests/net/forwarding/sch_ets.sh b/tools/test=
ing/selftests/net/forwarding/sch_ets.sh
new file mode 100755
index 000000000000..25844854571e
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/sch_ets.sh
@@ -0,0 +1,30 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# A driver for the ETS selftest that implements testing in slowpath.
+lib_dir=3D.
+source sch_ets_core.sh
+
+switch_create()
+{
+	ets_switch_create
+
+	# Create a bottleneck so that the DWRR process can kick in.
+	tc qdisc add dev $swp2 root handle 1: tbf \
+	   rate 1Gbit burst 1Mbit latency 100ms
+	PARENT=3D"parent 1:"
+}
+
+switch_destroy()
+{
+	ets_switch_destroy
+}
+
+get_stats()
+{
+	local stream=3D$1; shift
+
+	link_stats_get $h2.1$stream rx bytes
+}
+
+ets_run
diff --git a/tools/testing/selftests/net/forwarding/sch_ets_core.sh b/tools=
/testing/selftests/net/forwarding/sch_ets_core.sh
new file mode 100644
index 000000000000..a99dab5131bd
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/sch_ets_core.sh
@@ -0,0 +1,229 @@
+# SPDX-License-Identifier: GPL-2.0
+
+# This is a template for ETS Qdisc test.
+#
+# This test sends from H1 several traffic streams with 802.1p-tagged packe=
ts.
+# The tags are used at $swp1 to prioritize the traffic. Each stream is the=
n
+# queued at a different ETS band according to the assigned priority. After
+# runnig for a while, counters at H2 are consulted to determine whether th=
e
+# traffic scheduling was according to the ETS configuration.
+#
+# This template is supposed to be embedded by a test driver, which impleme=
nts
+# statistics collection, any HW-specific stuff, and prominently configures=
 the
+# system to assure that there is overcommitment at $swp2. That is necessar=
y so
+# that the ETS traffic selection algorithm kicks in and has to schedule so=
me
+# traffic at the expense of other.
+#
+# A driver for veth-based testing is in sch_ets.sh, an example of a driver=
 for
+# an offloaded data path is in selftests/drivers/net/mlxsw/sch_ets.sh.
+#
+# +---------------------------------------------------------------------+
+# | H1                                                                  |
+# |     + $h1.10              + $h1.11              + $h1.12            |
+# |     | 192.0.2.1/28        | 192.0.2.17/28       | 192.0.2.33/28     |
+# |     | egress-qos-map      | egress-qos-map      | egress-qos-map    |
+# |     |  0:0                |  0:1                |  0:2              |
+# |     \____________________ | ____________________/                   |
+# |                          \|/                                        |
+# |                           + $h1                                     |
+# +---------------------------|-----------------------------------------+
+#                             |
+# +---------------------------|-----------------------------------------+
+# | SW                        + $swp1                                   |
+# |                           | >1Gbps                                  |
+# |      ____________________/|\____________________                    |
+# |     /                     |                     \                   |
+# |  +--|----------------+ +--|----------------+ +--|----------------+  |
+# |  |  + $swp1.10       | |  + $swp1.11       | |  + $swp1.12       |  |
+# |  |    ingress-qos-map| |    ingress-qos-map| |    ingress-qos-map|  |
+# |  |     0:0 1:1 2:2   | |     0:0 1:1 2:2   | |     0:0 1:1 2:2   |  |
+# |  |                   | |                   | |                   |  |
+# |  |    BR10           | |    BR11           | |    BR12           |  |
+# |  |                   | |                   | |                   |  |
+# |  |  + $swp2.10       | |  + $swp2.11       | |  + $swp2.12       |  |
+# |  +--|----------------+ +--|----------------+ +--|----------------+  |
+# |     \____________________ | ____________________/                   |
+# |                          \|/                                        |
+# |                           + $swp2                                   |
+# |                           | 1Gbps (ethtool or HTB qdisc)            |
+# |                           | qdisc ets quanta $W0 $W1 $W2            |
+# |                           |           priomap 0 1 2                 |
+# +---------------------------|-----------------------------------------+
+#                             |
+# +---------------------------|-----------------------------------------+
+# | H2                        + $h2                                     |
+# |      ____________________/|\____________________                    |
+# |     /                     |                     \                   |
+# |     + $h2.10              + $h2.11              + $h2.12            |
+# |       192.0.2.2/28          192.0.2.18/28         192.0.2.34/28     |
+# +---------------------------------------------------------------------+
+
+NUM_NETIFS=3D4
+CHECK_TC=3D"yes"
+source $lib_dir/lib.sh
+source $lib_dir/sch_ets_tests.sh
+
+ALL_TESTS=3D"
+	ping_ipv4
+	$ALL_TESTS_STRICT
+	$ALL_TESTS_MIXED
+	$ALL_TESTS_DWRR
+"
+
+PARENT=3Droot
+
+sip()
+{
+	echo 192.0.2.$((16 * $1 + 1))
+}
+
+dip()
+{
+	echo 192.0.2.$((16 * $1 + 2))
+}
+
+ets_start_traffic()
+{
+	local dst_mac=3D$(mac_get $h2)
+	local i=3D$1; shift
+
+	start_traffic $h1.1$i $(sip $i) $(dip $i) $dst_mac
+}
+
+h1_create()
+{
+	local i;
+
+	simple_if_init $h1
+	mtu_set $h1 9900
+	for i in {0..2}; do
+		vlan_create $h1 1$i v$h1 $(sip $i)/28
+		ip link set dev $h1.1$i type vlan egress 0:$i
+	done
+}
+
+h1_destroy()
+{
+	local i
+
+	for i in {0..2}; do
+		vlan_destroy $h1 1$i
+	done
+	mtu_restore $h1
+	simple_if_fini $h1
+}
+
+h2_create()
+{
+	local i
+
+	simple_if_init $h2
+	mtu_set $h2 9900
+	for i in {0..2}; do
+		vlan_create $h2 1$i v$h2 $(dip $i)/28
+	done
+}
+
+h2_destroy()
+{
+	local i
+
+	for i in {0..2}; do
+		vlan_destroy $h2 1$i
+	done
+	mtu_restore $h2
+	simple_if_fini $h2
+}
+
+ets_switch_create()
+{
+	local i
+
+	ip link set dev $swp1 up
+	mtu_set $swp1 9900
+
+	ip link set dev $swp2 up
+	mtu_set $swp2 9900
+
+	for i in {0..2}; do
+		vlan_create $swp1 1$i
+		ip link set dev $swp1.1$i type vlan ingress 0:0 1:1 2:2
+
+		vlan_create $swp2 1$i
+
+		ip link add dev br1$i type bridge
+		ip link set dev $swp1.1$i master br1$i
+		ip link set dev $swp2.1$i master br1$i
+
+		ip link set dev br1$i up
+		ip link set dev $swp1.1$i up
+		ip link set dev $swp2.1$i up
+	done
+}
+
+ets_switch_destroy()
+{
+	local i
+
+	tc qdisc del dev $swp2 root
+
+	for i in {0..2}; do
+		ip link del dev br1$i
+		vlan_destroy $swp2 1$i
+		vlan_destroy $swp1 1$i
+	done
+
+	mtu_restore $swp2
+	ip link set dev $swp2 down
+
+	mtu_restore $swp1
+	ip link set dev $swp1 down
+}
+
+setup_prepare()
+{
+	h1=3D${NETIFS[p1]}
+	swp1=3D${NETIFS[p2]}
+
+	swp2=3D${NETIFS[p3]}
+	h2=3D${NETIFS[p4]}
+
+	put=3D$swp2
+	hut=3D$h2
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+	switch_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+ping_ipv4()
+{
+	ping_test $h1.10 $(dip 0) " vlan 10"
+	ping_test $h1.11 $(dip 1) " vlan 11"
+	ping_test $h1.12 $(dip 2) " vlan 12"
+}
+
+ets_run()
+{
+	trap cleanup EXIT
+
+	setup_prepare
+	setup_wait
+
+	tests_run
+
+	exit $EXIT_STATUS
+}
diff --git a/tools/testing/selftests/net/forwarding/sch_ets_tests.sh b/tool=
s/testing/selftests/net/forwarding/sch_ets_tests.sh
new file mode 100644
index 000000000000..4d666d4e1721
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/sch_ets_tests.sh
@@ -0,0 +1,230 @@
+# SPDX-License-Identifier: GPL-2.0
+
+# Global interface:
+#  $put -- port under test (e.g. $swp2)
+#  get_stats($band) -- A function to collect stats for band
+#  ets_start_traffic($band) -- Start traffic for this band
+
+ALL_TESTS_STRICT=3D"
+	ets_set_strict
+	ets_dwrr_test_01
+	ets_dwrr_test_12
+"
+
+ALL_TESTS_MIXED=3D"
+	ets_set_mixed
+	ets_dwrr_test_01
+	ets_dwrr_test_12
+"
+
+ALL_TESTS_DWRR=3D"
+	ets_set_dwrr_uniform
+	ets_dwrr_test_012
+	ets_set_dwrr_varying
+	ets_dwrr_test_012
+	ets_change_quantum
+	ets_dwrr_test_012
+	ets_set_dwrr_two_bands
+	ets_dwrr_test_01
+"
+
+QDISC_DEV=3D
+
+# WS describes the Qdisc configuration. It has one value per band (so the
+# number of array elements indicates the number of bands). If the value is
+# 0, it is a strict band, otherwise the it's a DRR band and the value is
+# that band's quantum.
+declare -a WS
+
+qdisc_describe()
+{
+	local nbands=3D${#WS[@]}
+	local nstrict=3D0
+	local i
+
+	for ((i =3D 0; i < nbands; i++)); do
+		if ((!${WS[$i]})); then
+			: $((nstrict++))
+		fi
+	done
+
+	echo -n "ets bands $nbands"
+	if ((nstrict)); then
+		echo -n " strict $nstrict"
+	fi
+	if ((nstrict < nbands)); then
+		echo -n " quanta"
+		for ((i =3D nstrict; i < nbands; i++)); do
+			echo -n " ${WS[$i]}"
+		done
+	fi
+}
+
+__strict_eval()
+{
+	local desc=3D$1; shift
+	local d=3D$1; shift
+	local total=3D$1; shift
+	local above=3D$1; shift
+
+	RET=3D0
+
+	if ((! total)); then
+		check_err 1 "No traffic observed"
+		log_test "$desc"
+		return
+	fi
+
+	local ratio=3D$(echo "scale=3D2; 100 * $d / $total" | bc -l)
+	if ((above)); then
+		test $(echo "$ratio > 95.0" | bc -l) -eq 1
+		check_err $? "Not enough traffic"
+		log_test "$desc"
+		log_info "Expected ratio >95% Measured ratio $ratio"
+	else
+		test $(echo "$ratio < 5" | bc -l) -eq 1
+		check_err $? "Too much traffic"
+		log_test "$desc"
+		log_info "Expected ratio <5% Measured ratio $ratio"
+	fi
+}
+
+strict_eval()
+{
+	__strict_eval "$@" 1
+}
+
+notraf_eval()
+{
+	__strict_eval "$@" 0
+}
+
+__ets_dwrr_test()
+{
+	local -a streams=3D("$@")
+
+	local low_stream=3D${streams[0]}
+	local seen_strict=3D0
+	local -a t0 t1 d
+	local stream
+	local total
+	local i
+
+	echo "Testing $(qdisc_describe), streams ${streams[@]}"
+
+	for stream in ${streams[@]}; do
+		ets_start_traffic $stream
+	done
+
+	sleep 10
+
+	t0=3D($(for stream in ${streams[@]}; do
+		  get_stats $stream
+	      done))
+
+	sleep 10
+
+	t1=3D($(for stream in ${streams[@]}; do
+		  get_stats $stream
+	      done))
+	d=3D($(for ((i =3D 0; i < ${#streams[@]}; i++)); do
+		 echo $((${t1[$i]} - ${t0[$i]}))
+	     done))
+	total=3D$(echo ${d[@]} | sed 's/ /+/g' | bc)
+
+	for ((i =3D 0; i < ${#streams[@]}; i++)); do
+		local stream=3D${streams[$i]}
+		if ((seen_strict)); then
+			notraf_eval "band $stream" ${d[$i]} $total
+		elif ((${WS[$stream]} =3D=3D 0)); then
+			strict_eval "band $stream" ${d[$i]} $total
+			seen_strict=3D1
+		elif ((stream =3D=3D low_stream)); then
+			# Low stream is used as DWRR evaluation reference.
+			continue
+		else
+			multipath_eval "bands $low_stream:$stream" \
+				       ${WS[$low_stream]} ${WS[$stream]} \
+				       ${d[0]} ${d[$i]}
+		fi
+	done
+
+	for stream in ${streams[@]}; do
+		stop_traffic
+	done
+}
+
+ets_dwrr_test_012()
+{
+	__ets_dwrr_test 0 1 2
+}
+
+ets_dwrr_test_01()
+{
+	__ets_dwrr_test 0 1
+}
+
+ets_dwrr_test_12()
+{
+	__ets_dwrr_test 1 2
+}
+
+ets_qdisc_setup()
+{
+	local dev=3D$1; shift
+	local nstrict=3D$1; shift
+	local -a quanta=3D("$@")
+
+	local op=3D$(if [[ -n $QDISC_DEV ]]; then echo change; else echo add; fi)
+	local ndwrr=3D${#quanta[@]}
+	local nbands=3D$((nstrict + ndwrr))
+	local nstreams=3D$(if ((nbands > 3)); then echo 3; else echo $nbands; fi)
+	local priomap=3D$(seq 0 $((nstreams - 1)))
+	local i
+
+	WS=3D($(
+		for ((i =3D 0; i < nstrict; i++)); do
+			echo 0
+		done
+		for ((i =3D 0; i < ndwrr; i++)); do
+			echo ${quanta[$i]}
+		done
+	))
+
+	tc qdisc $op dev $dev $PARENT handle 10: ets			       \
+		$(if ((nstrict)); then echo strict $nstrict; fi)	       \
+		$(if ((${#quanta[@]})); then echo quanta ${quanta[@]}; fi)     \
+		priomap $priomap
+	QDISC_DEV=3D$dev
+}
+
+ets_set_dwrr_uniform()
+{
+	ets_qdisc_setup $put 0 3300 3300 3300
+}
+
+ets_set_dwrr_varying()
+{
+	ets_qdisc_setup $put 0 5000 3500 1500
+}
+
+ets_set_strict()
+{
+	ets_qdisc_setup $put 3
+}
+
+ets_set_mixed()
+{
+	ets_qdisc_setup $put 1 5000 2500 1500
+}
+
+ets_change_quantum()
+{
+	tc class change dev $put classid 10:2 ets quantum 8000
+	WS[1]=3D8000
+}
+
+ets_set_dwrr_two_bands()
+{
+	ets_qdisc_setup $put 0 5000 2500
+}
--=20
2.20.1

