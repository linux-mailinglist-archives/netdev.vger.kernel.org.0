Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4224248A4C6
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243396AbiAKBLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:11:05 -0500
Received: from mail-eopbgr80092.outbound.protection.outlook.com ([40.107.8.92]:55886
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243263AbiAKBLE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 20:11:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bita77RfKKENIFf1J/xV5dXT49jyUXIGi26hb+EcgFnG0Ld5IlkUAebmRdPdcQoRpK/hmTXx59GwDj5CrPVIqV5Ua17kSEfgsOHI0qRjHBfK4E5YQX+2m1Y8GO+IA0feiyVxeA5vjOQeyHO+NJcJ9ZaJQMb8QM7ZaIjecg4XA8gahQKOhU/XgcQ5gebl+ryFCxlLuvkfocrFweYfUZGufncopFhiEX4jUMKM7jPnJxhgEbi+q1kFOGZ6JO3pE0mxCIWqXY1yNwJ2RZZta2Ry63NS4kISx9JS0j/BhpisXlTabvxPqZkLj+p2nXNCtwa9k0Xw6RhJbEUu9Yklt2z1vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/sx2yEo4D4wqqfSVIZJpCokQkv0oCt1vAOGHErdZ71E=;
 b=M+lJ2r5vImVq3/0LaEstn3BWIgYk/+HLRMmYfjR1zwoIPXqYkiSMiJKYAH9VuvQ7wcCFlVDM+WP7Lk9x2mww7DTcv224WsClFRzYwnlQ7oZmD88KkUX/h3bc/5TDyHFwefThzPNc3uljYewLeIx/Hb8K40i11G+eJauI6r8C3OU6PRsasEF31WQGMWdJK+K5ljNQjKk+jTaMKZHv8B6rPV2cL71o7HzXKR1Itz6Mo0+33wQJMqEgMBOt0itCGZl+Efn437Uoi+UWvnPzQV1ggBXDB1rUr3L1/e5+FC0UG83nlErIH0E1kDoLu4PhB0uNwo2ak6wxFyE88X1/PCbqqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sx2yEo4D4wqqfSVIZJpCokQkv0oCt1vAOGHErdZ71E=;
 b=r+OlMJNP5Vid5YpguX+/sET+8YkdqCsBv8xA6aMyZ4UfBdOXn19Tf1A90bKNZPOT64RSfn0+EOlExM7mGlQzSRwRzFMfS1435/58td5qPPX7kH3nYvEb65v9JI/sTenhAm72Su+LQAqzfn0+fI+FCMUM6Q20xj86ERoX8qmQ0uY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM0P190MB0753.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:195::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 11 Jan
 2022 01:11:02 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%8]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 01:11:02 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch,
        idosch@idosch.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: marvell: prestera: Refactor router functions
Date:   Tue, 11 Jan 2022 03:10:51 +0200
Message-Id: <20220111011051.4941-1-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0051.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::12) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5182fdb-b4ae-4d1c-39ea-08d9d49f3bff
X-MS-TrafficTypeDiagnostic: AM0P190MB0753:EE_
X-Microsoft-Antispam-PRVS: <AM0P190MB0753AA2EAAE7D9BEA34621BB93519@AM0P190MB0753.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3OoFwv5yAiSMJC5kuYVSySTGb4w6I2GeVwncRbphcJhPLS6Syj5REz7cf0pFuI5E4sv3hmcVs6ZSsW5x3xGTZZt/+dScinHQr5aW3j7RSptwJx3/SN+SiOCmxYWGRmOrQH1N6Z1vxH2/lgt+WbhXfkwuigLE84WM37Dvyxs9Vk8IxIMRkLNbJXCmH0jgUlED8gETvHY4tXJ/0Hmsn7JnFNsCJddLF5Gwgxpf3xyumkEKsirEs2A2XTWRB/Gwefe9FHYYiSUHh+N3hh0jU9YCPqeKMGvinDb5KMC2qZ/RlyLDfEeNEAJ7dUAnB8EKZl8SPQoDJ+tMxmI+D7TMjq6EVk6CvXBzlXayjRQsX+TxF0pu5XvsgQjPO1AOy2iQrDZRkiuv0UjBEA5QfAqNI86qZFLD2WAym5+FkhquOwsHyvjuxkRlu9GtDRly945YwKz8KE74ePvOuJDE5ggOLd9bd8fekHc5p6zwd1zYLfIlEGgoJFKO4FYnlSDLF4rJAJTidrbOWZvk2yv87Ga+9regf0XQ43iQ26ZnQ3fX6tYZC3g0cIK+eftT61up+qHd9ao8iUp7sTi5ihXr3f2ZYp2RCQ6sUXsrPqcc2zAIHDiI99tz22FNnt3VX2MJlxcqXOa93IPQ5qMLXFn9xUYF7Z3e3brsmAGoM3PfGx7+KOxRuETJ/B5U04WAedN7v3oqK1x8V87P01vnkRUREU8FoHpm4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(136003)(376002)(39830400003)(1076003)(83380400001)(6486002)(54906003)(66574015)(36756003)(52116002)(66946007)(8676002)(86362001)(316002)(8936002)(6506007)(66476007)(66556008)(6666004)(6512007)(4326008)(2616005)(38100700002)(5660300002)(2906002)(38350700002)(26005)(508600001)(44832011)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d6PT0N2x+RLhD5hxAnsGQpFAn0eRf+NXjt7QUso+7fcrsogv+K7PXNr24S4R?=
 =?us-ascii?Q?AEXK9RPEP2n0bjKxBsutPl+QJkUMA8fWGglpylh1u2+mumcl2cMEDuUoLR0Z?=
 =?us-ascii?Q?4jCIPL0XX/zdhHyTdLnvOn/A/fXEOnDZb/FkNL9Qg8H92/CZChYGjge/5nff?=
 =?us-ascii?Q?w1LrdoKQjvAko/HHZzPCan0lGS0RnGLNGluKlrxfar5Q4FMEkz8lpfEvbWJa?=
 =?us-ascii?Q?cFeLX9bAk3gkLt5aZM2xvqMgzeKE33h+6F7bvMdOp8Ku+1t3GoWs+9KKwXaj?=
 =?us-ascii?Q?Ls83v4hzfiM/XZKI8chORqBMQ9iPFAV/i7typfzwzqKRany066fyHPbOscqj?=
 =?us-ascii?Q?2aOgjZStECe/bE87hsqAWdUY/4S4JAXU3kjFYhhiTvn7d+0VfoITDpLnsmjM?=
 =?us-ascii?Q?PZLb600LxvZov+ZIXbYGMPit6X0+jFaL6/CWEtiJEOPxPtvVGtcYsyEzUrrx?=
 =?us-ascii?Q?jGvzbCO26c65+37h8Qj/d9wkjNibPIjxukRHL2ap2y7hAqIGcXkUl3OJ4rtZ?=
 =?us-ascii?Q?BlPZ7giKifjx9DMARY60sQ1r6HMoYdNVpT5LatvbUhG+VDyn931BbtHm6FlI?=
 =?us-ascii?Q?LBNzOBYRhAEqz38W/9Nxcf4OXPJE0Jx8ZVth+JrJKkiJcEIZBvrsCI8pUuPn?=
 =?us-ascii?Q?yu0g/m+gq4ANM9UHSYl8xcdGA6DpqS5UdsOva6yM3dXkB7/GBKAjtgNQQpGy?=
 =?us-ascii?Q?xG5xoHhN7noOyMZyUw+qErdGmX1RELjBvMQipM6QtAGcSg4PtCjL+wtYLLdD?=
 =?us-ascii?Q?E6H5A7cBZQO2M7qSJdMBc7jYNDbUYhjQNJGCRTMWkkVEhK3+2BPfnXmPLwmT?=
 =?us-ascii?Q?xu7fG1n9U+HUQklvqW7nCXwF9odbIefvb12s3nKNxQjKHHu/7upHTddzYfUE?=
 =?us-ascii?Q?AzcWA5BHgx3D2ii7K9D5bXI22Pb/S50/904DS3MR3FfRzYS2I94ds3mRkPPi?=
 =?us-ascii?Q?ctcOCs4YfADMKt3PFM9PxcVRd7Mj9RnBAo3lcAKK16pjDxgGqn2PwC6+QXbu?=
 =?us-ascii?Q?myzMIhAl3BeyIGtz1P8+VpfhSsS7IkbNfzo2FXLcCUz5J68SQZJT1hJotHow?=
 =?us-ascii?Q?ep9gdVkINJq0KcQ8ZG9frIzepBE/aReuiNFQxfjUz1UEAxVPmoZ23x6nCsLw?=
 =?us-ascii?Q?rMwXG7h9aS+zRClZi1OPEEgjH9uOpXE0HPxHKqjCyVmrEq+is/BCW77Aen5B?=
 =?us-ascii?Q?21XM+JlMAEMDwHyLpzpCPGjhcVwVKJm0nQp3+saxUr2yvPfVFJ3sT3ccXtDX?=
 =?us-ascii?Q?4Zt15ojSsAdUJ7IzAGmxs2odi0ezBQOTVe8W5kxoylM1wjGCscnESARpEVGZ?=
 =?us-ascii?Q?MzD1EpnTS06X/u6A3vZSp5XmSmSmQFYEBsNyeNTeS/+nPkXLXzB0ZYVdNvnY?=
 =?us-ascii?Q?bp+KcKRjb2q/1ZqOT4TNF0bbcJfFyZAjt1SdUd2IkkqLvskOUBvaUCw3LGod?=
 =?us-ascii?Q?wyZr0+JOgzSJ/vpKk0Fgjo7dbLD7ZXeNBdPX7OKS/UEc/Qr5g025YjpZFG2S?=
 =?us-ascii?Q?2kmMqq2/uHz5buzjnF/eqyKbL5X8ysG4WvNIbKAZm1tLLXX72njLWOAgfelw?=
 =?us-ascii?Q?77G51xYVrBR3mfjIim11WwEvsi6PQlg4mqn6alB0hiqiUKXX0AiDtS8tmJWU?=
 =?us-ascii?Q?f2Jdo9kRUwXR7K4AAFv6SoZF/Oq3p7Km740DGjio3QHCtw6xLm2MKA4GJBXX?=
 =?us-ascii?Q?y8aHhQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: f5182fdb-b4ae-4d1c-39ea-08d9d49f3bff
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 01:11:02.2200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xCodLYW0X/fKZnPbkGLaG+dKlMa3qWyH9Va1iY7/PEQMlAez4CHt5u+E0rROOReHfeqp9bCsozzu+rrBc2qc6yJSCOQ6E6rUYMcySkMFnVE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0753
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Reverse xmas tree variables order
* User friendly messages on error paths
* Refactor __prestera_inetaddr_event to use early return

Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../ethernet/marvell/prestera/prestera_hw.c   |  4 ++--
 .../marvell/prestera/prestera_router.c        | 20 ++++++++++---------
 .../marvell/prestera/prestera_router_hw.c     |  2 +-
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 51fc841b1e7a..e6bfadc874c5 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -1831,8 +1831,8 @@ static int prestera_iface_to_msg(struct prestera_iface *iface,
 int prestera_hw_rif_create(struct prestera_switch *sw,
 			   struct prestera_iface *iif, u8 *mac, u16 *rif_id)
 {
-	struct prestera_msg_rif_req req;
 	struct prestera_msg_rif_resp resp;
+	struct prestera_msg_rif_req req;
 	int err;
 
 	memcpy(req.mac, mac, ETH_ALEN);
@@ -1868,9 +1868,9 @@ int prestera_hw_rif_delete(struct prestera_switch *sw, u16 rif_id,
 
 int prestera_hw_vr_create(struct prestera_switch *sw, u16 *vr_id)
 {
-	int err;
 	struct prestera_msg_vr_resp resp;
 	struct prestera_msg_vr_req req;
+	int err;
 
 	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_ROUTER_VR_CREATE,
 			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 8a3b7b664358..607b88bfa451 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -25,10 +25,10 @@ static int __prestera_inetaddr_port_event(struct net_device *port_dev,
 					  struct netlink_ext_ack *extack)
 {
 	struct prestera_port *port = netdev_priv(port_dev);
-	int err;
-	struct prestera_rif_entry *re;
 	struct prestera_rif_entry_key re_key = {};
+	struct prestera_rif_entry *re;
 	u32 kern_tb_id;
+	int err;
 
 	err = prestera_is_valid_mac_addr(port, port_dev->dev_addr);
 	if (err) {
@@ -45,21 +45,21 @@ static int __prestera_inetaddr_port_event(struct net_device *port_dev,
 	switch (event) {
 	case NETDEV_UP:
 		if (re) {
-			NL_SET_ERR_MSG_MOD(extack, "rif_entry already exist");
+			NL_SET_ERR_MSG_MOD(extack, "RIF already exist");
 			return -EEXIST;
 		}
 		re = prestera_rif_entry_create(port->sw, &re_key,
 					       prestera_fix_tb_id(kern_tb_id),
 					       port_dev->dev_addr);
 		if (!re) {
-			NL_SET_ERR_MSG_MOD(extack, "Can't create rif_entry");
+			NL_SET_ERR_MSG_MOD(extack, "Can't create RIF");
 			return -EINVAL;
 		}
 		dev_hold(port_dev);
 		break;
 	case NETDEV_DOWN:
 		if (!re) {
-			NL_SET_ERR_MSG_MOD(extack, "rif_entry not exist");
+			NL_SET_ERR_MSG_MOD(extack, "Can't find RIF");
 			return -EEXIST;
 		}
 		prestera_rif_entry_destroy(port->sw, re);
@@ -75,11 +75,11 @@ static int __prestera_inetaddr_event(struct prestera_switch *sw,
 				     unsigned long event,
 				     struct netlink_ext_ack *extack)
 {
-	if (prestera_netdev_check(dev) && !netif_is_bridge_port(dev) &&
-	    !netif_is_lag_port(dev) && !netif_is_ovs_port(dev))
-		return __prestera_inetaddr_port_event(dev, event, extack);
+	if (!prestera_netdev_check(dev) || netif_is_bridge_port(dev) ||
+	    netif_is_lag_port(dev) || netif_is_ovs_port(dev))
+		return 0;
 
-	return 0;
+	return __prestera_inetaddr_port_event(dev, event, extack);
 }
 
 static int __prestera_inetaddr_cb(struct notifier_block *nb,
@@ -126,6 +126,8 @@ static int __prestera_inetaddr_valid_cb(struct notifier_block *nb,
 		goto out;
 
 	if (ipv4_is_multicast(ivi->ivi_addr)) {
+		NL_SET_ERR_MSG_MOD(ivi->extack,
+				   "Multicast addr on RIF is not supported");
 		err = -EINVAL;
 		goto out;
 	}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
index d5befd1d1440..490e9b61fd8d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
@@ -123,7 +123,7 @@ __prestera_rif_entry_key_copy(const struct prestera_rif_entry_key *in,
 		out->iface.vlan_id = in->iface.vlan_id;
 		break;
 	default:
-		pr_err("Unsupported iface type");
+		WARN(1, "Unsupported iface type");
 		return -EINVAL;
 	}
 
-- 
2.17.1

