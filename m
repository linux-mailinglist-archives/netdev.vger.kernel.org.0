Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C51B2D57E5
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 11:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgLJKJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 05:09:09 -0500
Received: from mail-vi1eur05on2091.outbound.protection.outlook.com ([40.107.21.91]:55136
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728163AbgLJKIz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 05:08:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lkOWKKf8DJvC3hslhSExGvU2f66BKGNtl9Xaj+COVPpQFOVLiW5YSFcsJz70iSgcAZzuYqHbcP+vt9r+eO9CQNIwb8jsar5YbDut6CRJr1Sp6h05qb09OlzFcaFsu0WJW1a8sGKBiCJ0nIK2cx8y4zP/U0p1iIwforT0CAel0akO1rmq4bHAHdVG5Bgib2/9npHbjv/j5W0rh+3WBNeEJ6DE/7uQyRlep78k2mWjStABOHEnYWp5nmof69aFOauJa1kejRBAc2k3KA+3I7QSUeFSSOnmgYwqqW8BqVUXDn/lhJTC7GqIEhVf+qsgLCWs7pHVay3YAFyMD0RNn7SOXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PLp08ZPts7vm6AGZlIB1NvtGuWkugtpihanwgHZm0og=;
 b=S5a1tCqBgXDl+SXGcD3CbZ/fPZdXOIhXWO8pgXG2NWK+6FjiBrBmmZjZMCMkLXRdD8ogjuvZh+BzkBYraMff0nRi7Yt5pg9z1fY2+YmsRW3fhtqDEgvNXHgtMjnXX/9bLkzeWw+PrKeIVQD1YM//rv6jafUSCsA5f/nW3QnQJZfgVmCeCses0OZEXTjlcmZMHMb5/240oFKSd6vKKHoqme3/Agl2afy3Q0kyUnsu9kT6rnAtYSIihmH2WXhuHC4xdn8ry2XtLg+hHIJ+5R2GoU+iD4tdH0dtGn6oZf20ulqezqGQfi3+rlYolfTXiUmoeUPO1GKaNUlShBQVqYh+xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 131.228.2.8) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=nokia-sbell.com; dmarc=temperror action=none
 header.from=nokia-sbell.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PLp08ZPts7vm6AGZlIB1NvtGuWkugtpihanwgHZm0og=;
 b=mIth9PLgJluXcvUWWuNnc52dMsRTzI324xex8ZkDSPlkDTnVjO6b3vk6pwzSiom17jT18Y/6kAWmnceno83JSx2dgWhO/buqQemOdBsLwOn+8y8O/YEc3FoSd3874Nr8ZTBi2T/v+QYg9Tyiq2U6PaoJY3B3srgVYmz5IGqGXWI=
Received: from DU2PR04CA0042.eurprd04.prod.outlook.com (2603:10a6:10:234::17)
 by AS8PR07MB7111.eurprd07.prod.outlook.com (2603:10a6:20b:251::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.9; Thu, 10 Dec
 2020 10:08:07 +0000
Received: from DB5EUR03FT039.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:234:cafe::b1) by DU2PR04CA0042.outlook.office365.com
 (2603:10a6:10:234::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21 via Frontend
 Transport; Thu, 10 Dec 2020 10:08:07 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is 131.228.2.8)
 smtp.mailfrom=nokia-sbell.com; vger.kernel.org; dkim=none (message not
 signed) header.d=none;vger.kernel.org; dmarc=temperror action=none
 header.from=nokia-sbell.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of nokia-sbell.com: DNS Timeout)
Received: from fihe3nok0734.emea.nsn-net.net (131.228.2.8) by
 DB5EUR03FT039.mail.protection.outlook.com (10.152.21.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 10:08:06 +0000
Received: from hzling45.china.nsn-net.net (hzling45.china.nsn-net.net [10.159.218.88])
        by fihe3nok0734.emea.nsn-net.net (GMO) with ESMTP id 0BAA831M017399;
        Thu, 10 Dec 2020 10:08:03 GMT
Received: by hzling45.china.nsn-net.net (Postfix, from userid 61462992)
        id 63D4741238; Thu, 10 Dec 2020 18:08:01 +0800 (CST)
From:   Libing Zhou <libing.zhou@nokia-sbell.com>
To:     davem@davemloft.net, mingo@redhat.com
Cc:     libing.zhou@nokia-sbell.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/netconsole: Support VLAN for netconsole
Date:   Thu, 10 Dec 2020 18:07:42 +0800
Message-Id: <20201210100742.8874-1-libing.zhou@nokia-sbell.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06a8b39d-f069-4875-fecb-08d89cf37d58
X-MS-TrafficTypeDiagnostic: AS8PR07MB7111:
X-Microsoft-Antispam-PRVS: <AS8PR07MB7111B8EE6E380CD656A280E2AFCB0@AS8PR07MB7111.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hegRxe+F0jyTQCGUlKaS7FO4ubX5ofT2T5WaQrVsOZaVxqKwtHmiI1d/dw+CWXeGUmV5SGyMzsjp1c1IpfS4lBiIV7pj/uKozB6hFiP0qSSWnJs1oyrI7ZdWxGLMU0XhX5AZpgTS+NjwfNDR+Ri6JrcWd+gEcHdYgDhez2E/0508ky2fl2ac1/tRi+4gl9dsUk7lNg9vD1Egr7URvUEnI5S/LfCKpLKtYJDD+0hBvyzLOuRzxpeufdJ/1poOysh7vXCR7X+JbLpMjS0IKSl7F2EHBOTfDz3oN7Ii9xSNdgKzQanw/t8BaSuLzY/jglKa9n3jCGVsZtnajlFYqYAP2J4Q+ZBXd1+ItuKaRG9GrXh3jMr81zQvTzrGa6fM+FFVsJY2nN8BG5/PTcQNkXV5FYjMtsDG3k2h9XHjexwv5IQdhCmqlX2IlxBGtiAX5w6tYQxWyQC5D7q2LlxEb4qeIA==
X-Forefront-Antispam-Report: CIP:131.228.2.8;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fihe3nok0734.emea.nsn-net.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(136003)(396003)(46966005)(478600001)(8676002)(6666004)(4326008)(83380400001)(6266002)(5660300002)(1076003)(86362001)(42186006)(44832011)(47076004)(316002)(186003)(8936002)(81166007)(356005)(2616005)(63370400001)(336012)(2906002)(34070700002)(36756003)(70206006)(70586007)(26005)(82740400003)(82310400003)(63350400001)(47845001);DIR:OUT;SFP:1102;
X-OriginatorOrg: nokia-sbell.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 10:08:06.5922
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06a8b39d-f069-4875-fecb-08d89cf37d58
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.2.8];Helo=[fihe3nok0734.emea.nsn-net.net]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT039.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR07MB7111
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During kernel startup phase, current netconsole doesn’t support VLAN
since there is no VLAN interface setup already.

This patch provides VLAN ID and PCP as optional boot/module parameters
to support VLAN environment, thus kernel startup log can be retrieved
via VLAN.

Signed-off-by: Libing Zhou <libing.zhou@nokia-sbell.com>
---
 Documentation/networking/netconsole.rst | 10 ++++-
 drivers/net/netconsole.c                |  3 +-
 include/linux/netpoll.h                 |  3 ++
 net/core/netpoll.c                      | 58 ++++++++++++++++++++++++-
 4 files changed, 70 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/netconsole.rst b/Documentation/networking/netconsole.rst
index 1f5c4a04027c..a08387fcc3f0 100644
--- a/Documentation/networking/netconsole.rst
+++ b/Documentation/networking/netconsole.rst
@@ -13,6 +13,8 @@ IPv6 support by Cong Wang <xiyou.wangcong@gmail.com>, Jan 1 2013
 
 Extended console support by Tejun Heo <tj@kernel.org>, May 1 2015
 
+VLAN support by Libing Zhou <libing.zhou@nokia-sbell.com>, Dec 8 2020
+
 Please send bug reports to Matt Mackall <mpm@selenic.com>
 Satyam Sharma <satyam.sharma@gmail.com>, and Cong Wang <xiyou.wangcong@gmail.com>
 
@@ -34,7 +36,7 @@ Sender and receiver configuration:
 It takes a string configuration parameter "netconsole" in the
 following format::
 
- netconsole=[+][src-port]@[src-ip]/[<dev>],[tgt-port]@<tgt-ip>/[tgt-macaddr]
+ netconsole=[+][src-port]@[src-ip]/[<dev>],[tgt-port]@<tgt-ip>/[tgt-macaddr][-V<vid:pcp>]
 
    where
 	+             if present, enable extended console support
@@ -44,11 +46,17 @@ following format::
 	tgt-port      port for logging agent (6666)
 	tgt-ip        IP address for logging agent
 	tgt-macaddr   ethernet MAC address for logging agent (broadcast)
+	-V            if present, enable VLAN support
+	vid:pcp       VLAN identifier and priority code point
 
 Examples::
 
  linux netconsole=4444@10.0.0.1/eth1,9353@10.0.0.2/12:34:56:78:9a:bc
 
+or using VLAN::
+
+ linux netconsole=4444@10.0.0.1/eth1,9353@10.0.0.2/12:34:56:78:9a:bc-V100:1
+
 or::
 
  insmod netconsole netconsole=@/,@10.0.0.2/
diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 92001f7af380..f0690cd6a744 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -36,7 +36,6 @@
 #include <linux/inet.h>
 #include <linux/configfs.h>
 #include <linux/etherdevice.h>
-
 MODULE_AUTHOR("Maintainer: Matt Mackall <mpm@selenic.com>");
 MODULE_DESCRIPTION("Console driver for network interfaces");
 MODULE_LICENSE("GPL");
@@ -46,7 +45,7 @@ MODULE_LICENSE("GPL");
 
 static char config[MAX_PARAM_LENGTH];
 module_param_string(netconsole, config, MAX_PARAM_LENGTH, 0);
-MODULE_PARM_DESC(netconsole, " netconsole=[src-port]@[src-ip]/[dev],[tgt-port]@<tgt-ip>/[tgt-macaddr]");
+MODULE_PARM_DESC(netconsole, " netconsole=[src-port]@[src-ip]/[dev],[tgt-port]@<tgt-ip>/[tgt-macaddr][-V<vid:pcp>]");
 
 static bool oops_only = false;
 module_param(oops_only, bool, 0600);
diff --git a/include/linux/netpoll.h b/include/linux/netpoll.h
index e6a2d72e0dc7..8ab3f25cadae 100644
--- a/include/linux/netpoll.h
+++ b/include/linux/netpoll.h
@@ -31,6 +31,9 @@ struct netpoll {
 	bool ipv6;
 	u16 local_port, remote_port;
 	u8 remote_mac[ETH_ALEN];
+	bool vlan_present;
+	u16 vlan_id;
+	u8 pcp;
 };
 
 struct netpoll_info {
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 2338753e936b..077a7aec51ae 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -478,6 +478,14 @@ void netpoll_send_udp(struct netpoll *np, const char *msg, int len)
 
 	skb->dev = np->dev;
 
+	if (np->vlan_present) {
+		skb->vlan_proto = htons(ETH_P_8021Q);
+
+		/* htons for tci is done in __vlan_insert_inner_tag, not here */
+		skb->vlan_tci = (np->pcp << VLAN_PRIO_SHIFT) + (np->vlan_id & VLAN_VID_MASK);
+		skb->vlan_present = 1;
+	}
+
 	netpoll_send_skb(np, skb);
 }
 EXPORT_SYMBOL(netpoll_send_udp);
@@ -496,6 +504,11 @@ void netpoll_print_options(struct netpoll *np)
 	else
 		np_info(np, "remote IPv4 address %pI4\n", &np->remote_ip.ip);
 	np_info(np, "remote ethernet address %pM\n", np->remote_mac);
+
+	if (np->vlan_present) {
+		np_info(np, "vlan id %d\n", np->vlan_id);
+		np_info(np, "pcp %d\n", np->pcp);
+	}
 }
 EXPORT_SYMBOL(netpoll_print_options);
 
@@ -587,10 +600,46 @@ int netpoll_parse_options(struct netpoll *np, char *opt)
 
 	if (*cur != 0) {
 		/* MAC address */
-		if (!mac_pton(cur, np->remote_mac))
+		delim = strchr(cur, '-');
+		if (delim)
+			*delim = 0;
+		if (*cur != 0) {
+			if (!mac_pton(cur, np->remote_mac))
+				goto parse_failed;
+		}
+		if (!delim)
+			goto parse_done;
+	}
+
+	cur = delim + 1;
+	if (*cur == 'V') {
+		/* vlan id */
+		cur++;
+		delim = strchr(cur, ':');
+		if (!delim)
+			goto parse_failed;
+		np->vlan_present = 1;
+		*delim = 0;
+		if (kstrtou16(cur, 10, &np->vlan_id))
 			goto parse_failed;
+		if (np->vlan_id > 4094) {
+			np_info(np, "error: set vlan id: %d is illegal, allowed range 0-4094\n",
+				np->vlan_id);
+			return -1;
+		}
+		cur = delim + 1;
+
+		/* vlan pcp */
+		if (kstrtou8(cur, 10, &np->pcp))
+			goto parse_failed;
+		if (np->pcp > 7) {
+			np_info(np, "error: set pcp value: %d is illegal, allowed range 0-7\n",
+				np->pcp);
+			return -1;
+		}
 	}
 
+ parse_done:
 	netpoll_print_options(np);
 
 	return 0;
@@ -671,6 +720,13 @@ int netpoll_setup(struct netpoll *np)
 		err = -ENODEV;
 		goto unlock;
 	}
+	if (is_vlan_dev(ndev) && np->vlan_present) {
+		np_err(np, "%s is vlan interface already, can't support with extra vlan parameter\n",
+		       np->dev_name);
+		err = -ENODEV;
+		goto unlock;
+	}
+
 	dev_hold(ndev);
 
 	if (netdev_master_upper_dev_get(ndev)) {
-- 
2.25.1

