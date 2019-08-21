Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF114987DC
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731474AbfHUX3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:29:01 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:35598
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729076AbfHUX3A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 19:29:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GvbriucDgwEfmKANDEA/xjghsy9uT7joDwf+tO6kdFYi7O4/Bhk7VH/PFXCcfgGRjblb3QmjJceG5izHBqnh1JNyDx0p7TnS7cPAEDEBkfeTHU+XmFwj1Qcv13kLiG1FsrX6UC0QylNi6Vir/yBGjH+VrchM4ZtNQguFvtVTdknYFV7cHE/5/T1+wN0SjyISl6yZ6tIS0OPOiypoNeEcFCK9jtIojq6hth71XxzwhL9UWYOEDWB51jj/4nUFq/iOnYq/Q4Ilw6muOwmF6J19USbnC1ZztudlboX6VlbNnS6b85euJgWFxa8DSTYB8LXb3ZZTxcbjiQzSANraRuspSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dj6zE1ugtBQKDB9IkcN3fg9aQHKddFu4PDlTmpaXi/o=;
 b=b33ZqcxkGEbc5E0tItS0qQu3AEJP7d3cqtXcan7C5ei5PVyktSjf4qtIn9LDXiZNF8xREbGCVaaDekRBIiLdqCR2TnjS57XVPnIsRCHe0BLjtojgDwoGnnAezlTfcJ/+PnrihIZl/AjLWn/6tC2UWcmesZdzlEhAZilz3korBZRVy9Jzv8aDlGHAFlK6K11PmsI8IAmgOqjYGKiuXqQBURmZIdZ/uFMX6TMY0kXXop8eoMoFospqMmql0kqanAmywAHImiLLYlfd5l/LxJANdrkntkItxkwZIQuIboVbaeK+YpMqixRKpz6dvAKJu5q7YpVi/JcXiDVqkP6SpyFxCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dj6zE1ugtBQKDB9IkcN3fg9aQHKddFu4PDlTmpaXi/o=;
 b=JqA21hUAF1EFxKVkyUOVNPuwbgS6nAy9tHr05a6RimkmYriklan5El00cAJJFaXKx0pP4ymg6n0g8X3GLmBkDeiBIOE79I1u3LC42NeYBRCbs4jts0NgaJaazws66S4zY9cy41BLR4jqesA3X07CBiYjZNNQ6ZKbUaYmnZqra9k=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2674.eurprd05.prod.outlook.com (10.172.221.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 23:28:50 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 23:28:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmytro Linkin <dmitrolin@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/11] net/mlx5e: Add tc flower tracepoints
Thread-Topic: [net-next 09/11] net/mlx5e: Add tc flower tracepoints
Thread-Index: AQHVWHgvUW9l+recx06KQVJTZ5OyKQ==
Date:   Wed, 21 Aug 2019 23:28:49 +0000
Message-ID: <20190821232806.21847-10-saeedm@mellanox.com>
References: <20190821232806.21847-1-saeedm@mellanox.com>
In-Reply-To: <20190821232806.21847-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0032.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::45) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2925cbf1-8dec-4ffe-eabf-08d7268f5238
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2674;
x-ms-traffictypediagnostic: AM4PR0501MB2674:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2674022871007468CF07CDBEBEAA0@AM4PR0501MB2674.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(50226002)(5660300002)(6512007)(86362001)(3846002)(6116002)(305945005)(14444005)(66946007)(66556008)(7736002)(66476007)(256004)(66446008)(64756008)(66066001)(1076003)(71200400001)(71190400001)(4326008)(478600001)(6916009)(8936002)(6486002)(107886003)(2906002)(2616005)(81156014)(81166006)(8676002)(476003)(6506007)(386003)(99286004)(52116002)(26005)(486006)(53936002)(76176011)(316002)(36756003)(25786009)(186003)(54906003)(14454004)(102836004)(446003)(6436002)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2674;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9CeJXt/f1krj5MaDlJWcKepWlkaHE/7/Vw2SB4xR9Gl9u0mQ5eB3k/8PiKMLRo8ncXSPKMlDU3Ouj7AZaWFYdAl3cC87wNWFX5f9G7OEwCKAMUXt8+0aN1gD5QBljLuDrbiP5rfrFJAiCOVh02dcdgy4+wL/RUz8fZas3r9MaZ6GggwL2cW3DU9td934qzW2TfCVT/69+R+wW1yKLZaYM+2R2caKSqzNkLU9IlAY1BlPs+ylDHzt9CvIX4OtqmmROv79rJmB15cNCDo65on5UVZkf/GFGO7hEGoPQZfjDwAERnqdNZkYe6RWGLrX6ZAEq+GCmFG2oMDTU2VLno0B+LMaehbdr/tzuzjZv9/UzSkEZu/pBQbS2OQ0SZoegr5wTqhgrf1n4PFk7J1OpnJ3XLSpWEieF+wYKcd+gdAmH+4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2925cbf1-8dec-4ffe-eabf-08d7268f5238
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 23:28:49.9614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L6VJOfwgv5FQYdc1oFGFu2+uyKzPT0RN8LkChZ+UjmG132IsmlEVFCTJWHMU7r3zVjihda18mT65jY2J/TqX2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2674
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

Implemented following tracepoints:
1. Configure flower (mlx5e_configure_flower)
2. Delete flower (mlx5e_delete_flower)
3. Stats flower (mlx5e_stats_flower)

Usage example:
 ># cd /sys/kernel/debug/tracing
 ># echo mlx5:mlx5e_configure_flower >> set_event
 ># cat trace
    ...
    tc-6535  [019] ...1  2672.404466: mlx5e_configure_flower: cookie=3D0000=
000067874a55 actions=3D REDIRECT

Added corresponding documentation in
    Documentation/networking/device-driver/mellanox/mlx5.rst

Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../device_drivers/mellanox/mlx5.rst          | 32 +++++++
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 .../mlx5/core/diag/en_tc_tracepoint.c         | 58 +++++++++++++
 .../mlx5/core/diag/en_tc_tracepoint.h         | 83 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  4 +
 include/net/flow_offload.h                    |  1 +
 6 files changed, 179 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/en_tc_trac=
epoint.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/en_tc_trac=
epoint.h

diff --git a/Documentation/networking/device_drivers/mellanox/mlx5.rst b/Do=
cumentation/networking/device_drivers/mellanox/mlx5.rst
index cfda464e52de..1339dbf52431 100644
--- a/Documentation/networking/device_drivers/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/mellanox/mlx5.rst
@@ -12,6 +12,7 @@ Contents
 - `Enabling the driver and kconfig options`_
 - `Devlink info`_
 - `Devlink health reporters`_
+- `mlx5 tracepoints`_
=20
 Enabling the driver and kconfig options
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
@@ -219,3 +220,34 @@ User commands examples:
     $ devlink health dump show pci/0000:82:00.1 reporter fw_fatal
=20
 NOTE: This command can run only on PF.
+
+mlx5 tracepoints
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+mlx5 driver provides internal trace points for tracking and debugging usin=
g
+kernel tracepoints interfaces (refer to Documentation/trace/ftrase.rst).
+
+For the list of support mlx5 events check /sys/kernel/debug/tracing/events=
/mlx5/
+
+tc and eswitch offloads tracepoints:
+
+- mlx5e_configure_flower: trace flower filter actions and cookies offloade=
d to mlx5::
+
+    $ echo mlx5:mlx5e_configure_flower >> /sys/kernel/debug/tracing/set_ev=
ent
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    tc-6535  [019] ...1  2672.404466: mlx5e_configure_flower: cookie=3D000=
0000067874a55 actions=3D REDIRECT
+
+- mlx5e_delete_flower: trace flower filter actions and cookies deleted fro=
m mlx5::
+
+    $ echo mlx5:mlx5e_delete_flower >> /sys/kernel/debug/tracing/set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    tc-6569  [010] .N.1  2686.379075: mlx5e_delete_flower: cookie=3D000000=
0067874a55 actions=3D NULL
+
+- mlx5e_stats_flower: trace flower stats request::
+
+    $ echo mlx5:mlx5e_stats_flower >> /sys/kernel/debug/tracing/set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    tc-6546  [010] ...1  2679.704889: mlx5e_stats_flower: cookie=3D0000000=
060eb3d6a bytes=3D0 packets=3D0 lastused=3D4295560217
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index a3b9659649a8..bcf36552f069 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -35,7 +35,7 @@ mlx5_core-$(CONFIG_MLX5_EN_RXNFC)    +=3D en_fs_ethtool.o
 mlx5_core-$(CONFIG_MLX5_CORE_EN_DCB) +=3D en_dcbnl.o en/port_buffer.o
 mlx5_core-$(CONFIG_MLX5_ESWITCH)     +=3D en_rep.o en_tc.o en/tc_tun.o lib=
/port_tun.o lag_mp.o \
 					lib/geneve.o en/tc_tun_vxlan.o en/tc_tun_gre.o \
-					en/tc_tun_geneve.o
+					en/tc_tun_geneve.o diag/en_tc_tracepoint.o
=20
 #
 # Core extra
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/en_tc_tracepoint.=
c b/drivers/net/ethernet/mellanox/mlx5/core/diag/en_tc_tracepoint.c
new file mode 100644
index 000000000000..c5dc6c50fa87
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/en_tc_tracepoint.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#define CREATE_TRACE_POINTS
+#include "en_tc_tracepoint.h"
+
+void put_ids_to_array(int *ids,
+		      const struct flow_action_entry *entries,
+		      unsigned int num)
+{
+	unsigned int i;
+
+	for (i =3D 0; i < num; i++)
+		ids[i] =3D entries[i].id;
+}
+
+#define NAME_SIZE 16
+
+static const char FLOWACT2STR[NUM_FLOW_ACTIONS][NAME_SIZE] =3D {
+	[FLOW_ACTION_ACCEPT]	=3D "ACCEPT",
+	[FLOW_ACTION_DROP]	=3D "DROP",
+	[FLOW_ACTION_TRAP]	=3D "TRAP",
+	[FLOW_ACTION_GOTO]	=3D "GOTO",
+	[FLOW_ACTION_REDIRECT]	=3D "REDIRECT",
+	[FLOW_ACTION_MIRRED]	=3D "MIRRED",
+	[FLOW_ACTION_VLAN_PUSH]	=3D "VLAN_PUSH",
+	[FLOW_ACTION_VLAN_POP]	=3D "VLAN_POP",
+	[FLOW_ACTION_VLAN_MANGLE]	=3D "VLAN_MANGLE",
+	[FLOW_ACTION_TUNNEL_ENCAP]	=3D "TUNNEL_ENCAP",
+	[FLOW_ACTION_TUNNEL_DECAP]	=3D "TUNNEL_DECAP",
+	[FLOW_ACTION_MANGLE]	=3D "MANGLE",
+	[FLOW_ACTION_ADD]	=3D "ADD",
+	[FLOW_ACTION_CSUM]	=3D "CSUM",
+	[FLOW_ACTION_MARK]	=3D "MARK",
+	[FLOW_ACTION_WAKE]	=3D "WAKE",
+	[FLOW_ACTION_QUEUE]	=3D "QUEUE",
+	[FLOW_ACTION_SAMPLE]	=3D "SAMPLE",
+	[FLOW_ACTION_POLICE]	=3D "POLICE",
+	[FLOW_ACTION_CT]	=3D "CT",
+};
+
+const char *parse_action(struct trace_seq *p,
+			 int *ids,
+			 unsigned int num)
+{
+	const char *ret =3D trace_seq_buffer_ptr(p);
+	unsigned int i;
+
+	for (i =3D 0; i < num; i++) {
+		if (ids[i] < NUM_FLOW_ACTIONS)
+			trace_seq_printf(p, "%s ", FLOWACT2STR[ids[i]]);
+		else
+			trace_seq_printf(p, "UNKNOWN ");
+	}
+
+	trace_seq_putc(p, 0);
+	return ret;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/en_tc_tracepoint.=
h b/drivers/net/ethernet/mellanox/mlx5/core/diag/en_tc_tracepoint.h
new file mode 100644
index 000000000000..a362100fe6d3
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/en_tc_tracepoint.h
@@ -0,0 +1,83 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mlx5
+
+#if !defined(_MLX5_TC_TP_) || defined(TRACE_HEADER_MULTI_READ)
+#define _MLX5_TC_TP_
+
+#include <linux/tracepoint.h>
+#include <linux/trace_seq.h>
+#include <net/flow_offload.h>
+
+#define __parse_action(ids, num) parse_action(p, ids, num)
+
+void put_ids_to_array(int *ids,
+		      const struct flow_action_entry *entries,
+		      unsigned int num);
+
+const char *parse_action(struct trace_seq *p,
+			 int *ids,
+			 unsigned int num);
+
+DECLARE_EVENT_CLASS(mlx5e_flower_template,
+		    TP_PROTO(const struct flow_cls_offload *f),
+		    TP_ARGS(f),
+		    TP_STRUCT__entry(__field(void *, cookie)
+				     __field(unsigned int, num)
+				     __dynamic_array(int, ids, f->rule ?
+					     f->rule->action.num_entries : 0)
+				     ),
+		    TP_fast_assign(__entry->cookie =3D (void *)f->cookie;
+			__entry->num =3D (f->rule ?
+				f->rule->action.num_entries : 0);
+			if (__entry->num)
+				put_ids_to_array(__get_dynamic_array(ids),
+						 f->rule->action.entries,
+						 f->rule->action.num_entries);
+			),
+		    TP_printk("cookie=3D%p actions=3D %s\n",
+			      __entry->cookie, __entry->num ?
+				      __parse_action(__get_dynamic_array(ids),
+						     __entry->num) : "NULL"
+			      )
+);
+
+DEFINE_EVENT(mlx5e_flower_template, mlx5e_configure_flower,
+	     TP_PROTO(const struct flow_cls_offload *f),
+	     TP_ARGS(f)
+	     );
+
+DEFINE_EVENT(mlx5e_flower_template, mlx5e_delete_flower,
+	     TP_PROTO(const struct flow_cls_offload *f),
+	     TP_ARGS(f)
+	     );
+
+TRACE_EVENT(mlx5e_stats_flower,
+	    TP_PROTO(const struct flow_cls_offload *f),
+	    TP_ARGS(f),
+	    TP_STRUCT__entry(__field(void *, cookie)
+			     __field(u64, bytes)
+			     __field(u64, packets)
+			     __field(u64, lastused)
+			     ),
+	    TP_fast_assign(__entry->cookie =3D (void *)f->cookie;
+		__entry->bytes =3D f->stats.bytes;
+		__entry->packets =3D f->stats.pkts;
+		__entry->lastused =3D f->stats.lastused;
+		),
+	    TP_printk("cookie=3D%p bytes=3D%llu packets=3D%llu lastused=3D%llu\n"=
,
+		      __entry->cookie, __entry->bytes,
+		      __entry->packets, __entry->lastused
+		      )
+);
+
+#endif /* _MLX5_TC_TP_ */
+
+/* This part must be outside protection */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH ./diag
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE en_tc_tracepoint
+#include <trace/define_trace.h>
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 5d4ce3d58832..c40cca08c8cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -56,6 +56,7 @@
 #include "en/tc_tun.h"
 #include "lib/devcom.h"
 #include "lib/geneve.h"
+#include "diag/en_tc_tracepoint.h"
=20
 struct mlx5_nic_flow_attr {
 	u32 action;
@@ -3769,6 +3770,7 @@ int mlx5e_configure_flower(struct net_device *dev, st=
ruct mlx5e_priv *priv,
 		goto out;
 	}
=20
+	trace_mlx5e_configure_flower(f);
 	err =3D mlx5e_tc_add_flow(priv, f, flags, dev, &flow);
 	if (err)
 		goto out;
@@ -3818,6 +3820,7 @@ int mlx5e_delete_flower(struct net_device *dev, struc=
t mlx5e_priv *priv,
 	rhashtable_remove_fast(tc_ht, &flow->node, tc_ht_params);
 	rcu_read_unlock();
=20
+	trace_mlx5e_delete_flower(f);
 	mlx5e_flow_put(priv, flow);
=20
 	return 0;
@@ -3887,6 +3890,7 @@ int mlx5e_stats_flower(struct net_device *dev, struct=
 mlx5e_priv *priv,
 	mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 out:
 	flow_stats_update(&f->stats, bytes, packets, lastuse);
+	trace_mlx5e_stats_flower(f);
 errout:
 	mlx5e_flow_put(priv, flow);
 	return err;
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index e8069b6c474c..757fa84de654 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -138,6 +138,7 @@ enum flow_action_id {
 	FLOW_ACTION_MPLS_PUSH,
 	FLOW_ACTION_MPLS_POP,
 	FLOW_ACTION_MPLS_MANGLE,
+	NUM_FLOW_ACTIONS,
 };
=20
 /* This is mirroring enum pedit_header_type definition for easy mapping be=
tween
--=20
2.21.0

