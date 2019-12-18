Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37569124A76
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfLROzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:55:50 -0500
Received: from mail-eopbgr20040.outbound.protection.outlook.com ([40.107.2.40]:9171
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727420AbfLROzt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 09:55:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=niKZEKQtuAU1Bqe7xBogh1gZ4S/zq0ASHK/r2ccmkiv7Z6IiSX1MUKU+vkc5kWxpFHy+S+GBK3e7VBU4hlPKTT+elIBwBmKOgNMJA/QDPeF2oW3dTWvF22cxxomGaSmJBoWBZmbapmccMiYvG0g7JYoIh7G6eCDpq3HKH8NspnHN0XxP/nlor5b3It0ZfuSIOFzoQCmWxy6x3STIASta6K4Th5K8zW6xUmvnTFLT1FCQ6aT3/GsDNF+X9a1Wtw7SAArTdU5Rx9LZF1cUSn0d9pnN82Id2MIlDZtu4bCJpQTbLtpINiYpVvqx5dsPVAiczYLxFfoyr+6q8ELbo/IPKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kYuI/xfClcLUftw9BVxj8g1aoSsQKWkOEePRw3gf4ms=;
 b=m/wyfY705xGPDs6HV93+iYL/WZSUrwBuNFJ3GC3RNSKl+GqrgQ9Pn4vACblTHLBDlLgQgY7n46qWMu9btIMnv6F7TdQoaNOsoGpa4mU8qzzfDN/M6o05YPLwKUznx1GH7T/Linali71jbKYfpuhchtgTRfSGcSe0q/L1iDzCIy0VnB9g73QuJIGQvGvhyDVNfFZ2CgOD/x/o+DHAp+V7oP2b3sc6gJ7dc3cY2ga/T6VQz59HOXV7TsGpri0cynFSTQD3kFgUXj8a/5Xz2aVXrcXyZOyD3kXaEEfghek7+ZGNrH/w1YV98wmhpAsa577DBzETcVrL/7jS780AWJvRmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kYuI/xfClcLUftw9BVxj8g1aoSsQKWkOEePRw3gf4ms=;
 b=rNcxhg2J2zwlS2ywUHBcrJm2Tq4EeGW9txhqKU+2ie3Bb8G8V11bhACuzpQhQuKNIqD5yk06JK5ZKdigOlQohn46Fkf7a7i5h6niuJm/KoAjOdkRmj5azo07ahkrzUbsqgh/WLz/LiNBsqbxqfESm0vfra8l0/BE0Lq9ZCqB8Tc=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB3048.eurprd05.prod.outlook.com (10.172.250.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Wed, 18 Dec 2019 14:55:23 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1%7]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 14:55:23 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next mlxsw v2 09/10] selftests: forwarding: sch_ets: Add
 test coverage for ETS Qdisc
Thread-Topic: [PATCH net-next mlxsw v2 09/10] selftests: forwarding: sch_ets:
 Add test coverage for ETS Qdisc
Thread-Index: AQHVtbMsd+DbZOHV4EeehBIco08RWw==
Date:   Wed, 18 Dec 2019 14:55:22 +0000
Message-ID: <f5626823d0fc799498998db4f60851876ac3d329.1576679651.git.petrm@mellanox.com>
References: <cover.1576679650.git.petrm@mellanox.com>
In-Reply-To: <cover.1576679650.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: PR2P264CA0031.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::19) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c2c64ded-5c9c-4558-4ee0-08d783ca4ee8
x-ms-traffictypediagnostic: DB6PR0502MB3048:|DB6PR0502MB3048:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB3048AE5CC10EB2C1E62D7338DB530@DB6PR0502MB3048.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(52314003)(189003)(199004)(2906002)(478600001)(6512007)(8936002)(81166006)(4326008)(316002)(107886003)(8676002)(71200400001)(26005)(186003)(81156014)(86362001)(2616005)(6916009)(66946007)(66446008)(64756008)(66556008)(66476007)(30864003)(36756003)(6486002)(5660300002)(54906003)(52116002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB3048;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wmHeloql0GJBgphcf0sQfUjJOCZzCJSQnBmjL1a6myk5YiRNA4pVsS+6zWbBW9p0QDrl59yB4NObk5XyfP+kiP6Jh67xMyG/itPzhoON5o+CLG4ftxBnkUjgVPQNS338Nui4NnYTF6SX3dxIxwNCQ5iGMJFv2FFvEn1fhqacHleUT4IthpsaNjjqlUk6lGXPxSlpv+qgJrwBbhBbvGGsPB1vPDK/CjIupVZeD9sAJgUdQCrMjC2EIXws0Nkbl8w5g/8yAf44MOxFFL3J+in6Bblkp8wVx31ofhuGZVlDjELt946I2kF1XqLXPyWGqgrPTftoUM0jAcO+5YdMH/8hxt3ADCmq8oVEiap9O5ZG62kyYjVOr+zCSauuAczLn6QOX9QXSV+tLzEKuuwcBT68ibd23wEiufK7EKbPmOLqoNFH9UzmbsF7jBH8wzJRlyyKxHLvrKWSBKTE0YBx0qWGUQOn9rPymDVC2Q4TZf/nAlVXYTqyh2dBfjPI3t/T4AWi
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2c64ded-5c9c-4558-4ee0-08d783ca4ee8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 14:55:23.1642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W8XYq5MNDsIAnfCA6mhpulRnUF2w1FNK0Y7HhkVB0RIfPLA+PNR/b3a/IJXrtPYaJh2wGhXSjkmzuqddV1MPXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB3048
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
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---

Notes:
    v1 (internal):
    - mlxsw/sch_ets.sh: Add a comment explaining packet prioritization.
    - Adjust the whole suite to allow testing of traffic classifiers
      in addition to testing priomap.

 .../selftests/drivers/net/mlxsw/qos_lib.sh    |  28 ++
 .../selftests/drivers/net/mlxsw/sch_ets.sh    |  67 ++++
 .../selftests/net/forwarding/sch_ets.sh       |  44 +++
 .../selftests/net/forwarding/sch_ets_core.sh  | 300 ++++++++++++++++++
 .../selftests/net/forwarding/sch_ets_tests.sh | 227 +++++++++++++
 5 files changed, 666 insertions(+)
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
index 000000000000..c9fc4d4885c1
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh
@@ -0,0 +1,67 @@
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
+ALL_TESTS=3D"
+	ping_ipv4
+	priomap_mode
+	ets_test_strict
+	ets_test_mixed
+	ets_test_dwrr
+"
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
+	devlink_port_pool_th_set $swp1 0 12
+	devlink_tc_bind_pool_th_set $swp1 0 ingress 0 12
+	devlink_port_pool_th_set $swp2 4 12
+	devlink_tc_bind_pool_th_set $swp2 7 egress 4 5
+	devlink_tc_bind_pool_th_set $swp2 6 egress 4 5
+	devlink_tc_bind_pool_th_set $swp2 5 egress 4 5
+
+	# Note: sch_ets_core.sh uses VLAN ingress-qos-map to assign packet
+	# priorities at $swp1 based on their 802.1p headers. ingress-qos-map is
+	# not offloaded by mlxsw as of this writing, but the mapping used is
+	# 1:1, which is the mapping currently hard-coded by the driver.
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
+# Callback from sch_ets_tests.sh
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
index 000000000000..40e0ad1bc4f2
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/sch_ets.sh
@@ -0,0 +1,44 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# A driver for the ETS selftest that implements testing in slowpath.
+lib_dir=3D.
+source sch_ets_core.sh
+
+ALL_TESTS=3D"
+	ping_ipv4
+	priomap_mode
+	ets_test_strict
+	ets_test_mixed
+	ets_test_dwrr
+	classifier_mode
+	ets_test_strict
+	ets_test_mixed
+	ets_test_dwrr
+"
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
+	tc qdisc del dev $swp2 root
+}
+
+# Callback from sch_ets_tests.sh
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
index 000000000000..f906fcc66572
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/sch_ets_core.sh
@@ -0,0 +1,300 @@
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
+CHECK_TC=3Dyes
+source $lib_dir/lib.sh
+source $lib_dir/sch_ets_tests.sh
+
+PARENT=3Droot
+QDISC_DEV=3D
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
+# Callback from sch_ets_tests.sh
+ets_start_traffic()
+{
+	local dst_mac=3D$(mac_get $h2)
+	local i=3D$1; shift
+
+	start_traffic $h1.1$i $(sip $i) $(dip $i) $dst_mac
+}
+
+ETS_CHANGE_QDISC=3D
+
+priomap_mode()
+{
+	echo "Running in priomap mode"
+	ets_delete_qdisc
+	ETS_CHANGE_QDISC=3Dets_change_qdisc_priomap
+}
+
+classifier_mode()
+{
+	echo "Running in classifier mode"
+	ets_delete_qdisc
+	ETS_CHANGE_QDISC=3Dets_change_qdisc_classifier
+}
+
+ets_change_qdisc_priomap()
+{
+	local dev=3D$1; shift
+	local nstrict=3D$1; shift
+	local priomap=3D$1; shift
+	local quanta=3D("${@}")
+
+	local op=3D$(if [[ -n $QDISC_DEV ]]; then echo change; else echo add; fi)
+
+	tc qdisc $op dev $dev $PARENT handle 10: ets			       \
+		$(if ((nstrict)); then echo strict $nstrict; fi)	       \
+		$(if ((${#quanta[@]})); then echo quanta ${quanta[@]}; fi)     \
+		priomap $priomap
+	QDISC_DEV=3D$dev
+}
+
+ets_change_qdisc_classifier()
+{
+	local dev=3D$1; shift
+	local nstrict=3D$1; shift
+	local priomap=3D$1; shift
+	local quanta=3D("${@}")
+
+	local op=3D$(if [[ -n $QDISC_DEV ]]; then echo change; else echo add; fi)
+
+	tc qdisc $op dev $dev $PARENT handle 10: ets			       \
+		$(if ((nstrict)); then echo strict $nstrict; fi)	       \
+		$(if ((${#quanta[@]})); then echo quanta ${quanta[@]}; fi)
+
+	if [[ $op =3D=3D add ]]; then
+		local prio=3D0
+		local band
+
+		for band in $priomap; do
+			tc filter add dev $dev parent 10: basic \
+				match "meta(priority eq $prio)" \
+				flowid 10:$((band + 1))
+			((prio++))
+		done
+	fi
+	QDISC_DEV=3D$dev
+}
+
+# Callback from sch_ets_tests.sh
+ets_change_qdisc()
+{
+	if [[ -z "$ETS_CHANGE_QDISC" ]]; then
+		exit 1
+	fi
+	$ETS_CHANGE_QDISC "$@"
+}
+
+ets_delete_qdisc()
+{
+	if [[ -n $QDISC_DEV ]]; then
+		tc qdisc del dev $QDISC_DEV $PARENT
+		QDISC_DEV=3D
+	fi
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
+	ets_delete_qdisc
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
index 000000000000..3c3b204d47e8
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/sch_ets_tests.sh
@@ -0,0 +1,227 @@
+# SPDX-License-Identifier: GPL-2.0
+
+# Global interface:
+#  $put -- port under test (e.g. $swp2)
+#  get_stats($band) -- A function to collect stats for band
+#  ets_start_traffic($band) -- Start traffic for this band
+#  ets_change_qdisc($op, $dev, $nstrict, $quanta...) -- Add or change qdis=
c
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
+	ets_change_qdisc $dev $nstrict "$priomap" ${quanta[@]}
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
+
+ets_test_strict()
+{
+	ets_set_strict
+	ets_dwrr_test_01
+	ets_dwrr_test_12
+}
+
+ets_test_mixed()
+{
+	ets_set_mixed
+	ets_dwrr_test_01
+	ets_dwrr_test_12
+}
+
+ets_test_dwrr()
+{
+	ets_set_dwrr_uniform
+	ets_dwrr_test_012
+	ets_set_dwrr_varying
+	ets_dwrr_test_012
+	ets_change_quantum
+	ets_dwrr_test_012
+	ets_set_dwrr_two_bands
+	ets_dwrr_test_01
+}
--=20
2.20.1

