Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B6A3033A3
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730349AbhAZFBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:01:20 -0500
Received: from mail-eopbgr80138.outbound.protection.outlook.com ([40.107.8.138]:10821
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728207AbhAYMm2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 07:42:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fy3hCEY08+MtQGs/n2aUt2QL/c/qAwA/VGNzDs7nL0JM9dgkCGztQclzP3nGV40KlZ40eP3yrPFYPuftGbYkvp9ov5ZQtIoLLC/M/nGj+VdJqUapxvHOQTnvu4fL58yex5bvfLtUT8iG1xLC5Fz/R61H8U4wApD3BJX2mffKD2ozFIoKXFQr34qaoRor2KWLOXnfjyrawsa+qFGlXlwaNqQStYJ88GGAjrzfqd6BQWqxN3chfjBD0mqTyE62u+W/1racHfEYRhsQI74/lh2XV5zFV+DwrKbH4HEqM+9slrfpCK8QYalcw9FhTFuTDmKHikcvPqgTl13YTFXHP/Ykwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFJAkv4cdjgzcihB8Rk4OrK14GfiTos28tz+arCdJNo=;
 b=MEf7LlyjXGCz3hfVoZc0qR+sN1jZea5iloIw0aKlspLpuj8DkRsjJ8e26sxlsiQFfIjpU7b78iIJptekUT/N2s7tOFfRlqnCK/iv6N/nlzhODOHGwoHaA69rwwQBEJKiKKKDOwProdP8jtgrnyUHbaV5kdNhpxfN7dq5RqtrSv1DH2rvWc098d1/fskZ42lQ98xtNILwmQDWeYuW1mQTBpjuijMmhPNPQBLfbOgV3mLNeOZO/PXi+I0+ovbs+0fLRwMd1jI9J8FuN07n8S1I9xxn4Ks/Za3xiAbHLxsLC/UcDNNAHlPTfDqWKvX6w6cEhsgF/56LkY4gjmN0zcAIBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFJAkv4cdjgzcihB8Rk4OrK14GfiTos28tz+arCdJNo=;
 b=XYsvPVxHBeLQ281d0TtkPgo8BJZOqWe7x8L7Jt4Sv/mtXXK5IOkHXUE56gJljImQBJYIun5HUhxQ+XgqRfOQD63OgMIaIII04r79xkYAH4EWXW8ch0wu0yJHvCP5rRtR7UlhxGoyC5qWHwjLJVWn7WLPPDBjy3QyGSb5b1IoiIo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM4PR1001MB1346.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:200:99::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Mon, 25 Jan
 2021 12:41:25 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a%3]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 12:41:25 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH v2 net] net: switchdev: don't set port_obj_info->handled true when -EOPNOTSUPP
Date:   Mon, 25 Jan 2021 13:41:16 +0100
Message-Id: <20210125124116.102928-1-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6P192CA0008.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:83::21) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6P192CA0008.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:83::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Mon, 25 Jan 2021 12:41:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0d27b86-d116-4bf5-a5d4-08d8c12e86f8
X-MS-TrafficTypeDiagnostic: AM4PR1001MB1346:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR1001MB13463749E8C84A606E43658C93BD0@AM4PR1001MB1346.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MmB3+Wy38bBomGnj9+PRjK1rr9AcQEcgIyJkstSYbfrjXO4oSCicyiXgB/c5Ot+Zinno3WrmCNGVxHhNBPowwaURst8/2eTBLMgEJW2dodYg3ET60VTAq1mY5iJKdVHvm2LHqdrWB5PBuC+wE2ZNXxQhlcaIJTHlG5E8KTuctjK77HW9xTf22OvHmCsEF2WtGG7S0FjxhElkHOfZf6KGgfeaoB6QSkYQ1rXawkg/heEUAZTWAeVLgV+/1kP7n0Mv7Vzjyihz/S8/IB2O5wJWDeryQkxiS2Pkl/88qxwIMlcMroR3OE+rITFqir72btcpcFKrhUC6USFvIkGxDbpRFo/mGc8/BkThu68JPk6fulQRHpPMeEwTvICSDZQ8Jw/s4LeYLV0H/kZzYXCUPb6hrfus/QSautFDLpiJSzTL2+sLnl+DjMV8u29CpoMn5TJ6d04l6fiS2Ygb8FZmIIZgAkK38dQK51g4ZGJWKov7XtfvZ9WtJZOSrHVWoun9Py6vR5oqGSHsXqjVzK6oOIzM0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(396003)(39850400004)(346002)(366004)(136003)(1076003)(6506007)(26005)(66556008)(66946007)(8676002)(66476007)(6512007)(6666004)(83380400001)(86362001)(6916009)(6486002)(5660300002)(8976002)(2616005)(8936002)(44832011)(956004)(54906003)(2906002)(478600001)(316002)(186003)(16526019)(7416002)(36756003)(52116002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?b+Kvafw6BNLQny9mFleAAUHZc1gSFEPYn0dBa/CXmRiVoZFHTDFDWnlxuFI3?=
 =?us-ascii?Q?hSWKeMKw6Onyjrf+r5JdgWAkY/pjs4khwETGlIVnQLrf4FZc5KS8y42WuqAW?=
 =?us-ascii?Q?tLH9ahMhQfsrKC7ybrB11xr1EyFH5YueB+kEiapi/gWAzIzLUJduoIoQiqTT?=
 =?us-ascii?Q?b2kW/K9TNF8JTOBBMhmSAIJs0WTrbxKT325WT8YL4Th4AEFQWq8sH0y/F//U?=
 =?us-ascii?Q?A6QLGxpDxvDzjgpkDZNcX8T1ppN6FDWe3prE4DeJAZRymWVpC0AoUzI+/NgP?=
 =?us-ascii?Q?QJK3wTt8K7wycvEObd6ft+4/TTZY7ij2B8O+DyzGoTN0YBOW7nH3AJs/jU3S?=
 =?us-ascii?Q?8LH3szS+hSrm2NiyOZ6tPuLLgY+O2ol1qGE7Dh08g+G48EPRL8xJWzqspHdH?=
 =?us-ascii?Q?aLQq28zvXvxxdF30xhZr2EdJxDaSnoWayQ9s5VS2SjzsgQzRq4r0iMusxjo1?=
 =?us-ascii?Q?aEOqYBLbuMO0XfXuDXXZw088wad0/10GslGMtiN5iDAjoFJUK4UF2GdzXmvs?=
 =?us-ascii?Q?WJXQ+klPQeOziwe7AS5742vEOd9LjwRyE2utmFgu4Bag9qYG2MGO9R1cP+Xb?=
 =?us-ascii?Q?40D09DzV4dDnW85Jgreq7HCrQAJNOtMstHilKpibEDWkXFsis/ZSaq4imykB?=
 =?us-ascii?Q?r9TrCpDcrzAVeLAaPAEcz0rnrlBUt5Kz0HVhrdOuNtP+w2/sMmuZgM9SjzOj?=
 =?us-ascii?Q?n+M20UVHEHrwVupd4xcf4cN3tChEoKj0IrPcj5fsKuClA6qc/33EK0VS/jzg?=
 =?us-ascii?Q?vGUs0lUmJbMNmTnSxlkrEoNGQCvju+Z3hitkrjFZpW9wBmDWLCDWgGE+3iSv?=
 =?us-ascii?Q?X0uFEfjzFj09WBlfYNvWJVXxdVOphyYPIu8/g6XWRXwe+z9Kc5NUzz/x+jCX?=
 =?us-ascii?Q?sWK+TKJpoR+Yq/90ffhRX1W9ikuNYTp+B/kQfjyHxUkaJc0Kg/5Nr56eqVIW?=
 =?us-ascii?Q?sbytD5k1BddO6NOWEWWacrjnkqF8ZimrWucoHv4yX4rL2P5dmeikGAQC1SeD?=
 =?us-ascii?Q?cdOQ?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d27b86-d116-4bf5-a5d4-08d8c12e86f8
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2021 12:41:25.3801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s97goQsCXE4aWVIQroyA2FLo3DG1pIIGOEU50e3f+RrhLTJGArV2y009qEVXENXSDijtWXvzINZw+oDsq50AHPDETAhrLyhCVzW9ond4oNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR1001MB1346
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's not true that switchdev_port_obj_notify() only inspects the
->handled field of "struct switchdev_notifier_port_obj_info" if
call_switchdev_blocking_notifiers() returns 0 - there's a WARN_ON()
triggering for a non-zero return combined with ->handled not being
true. But the real problem here is that -EOPNOTSUPP is not being
properly handled.

The wrapper functions switchdev_handle_port_obj_add() et al change a
return value of -EOPNOTSUPP to 0, and the treatment of ->handled in
switchdev_port_obj_notify() seems to be designed to change that back
to -EOPNOTSUPP in case nobody actually acted on the notifier (i.e.,
everybody returned -EOPNOTSUPP).

Currently, as soon as some device down the stack passes the check_cb()
check, ->handled gets set to true, which means that
switchdev_port_obj_notify() cannot actually ever return -EOPNOTSUPP.

This, for example, means that the detection of hardware offload
support in the MRP code is broken: switchdev_port_obj_add() used by
br_mrp_switchdev_send_ring_test() always returns 0, so since the MRP
code thinks the generation of MRP test frames has been offloaded, no
such frames are actually put on the wire. Similarly,
br_mrp_switchdev_set_ring_role() also always returns 0, causing
mrp->ring_role_offloaded to be set to 1.

To fix this, continue to set ->handled true if any callback returns
success or any error distinct from -EOPNOTSUPP. But if all the
callbacks return -EOPNOTSUPP, make sure that ->handled stays false, so
the logic in switchdev_port_obj_notify() can propagate that
information.

Fixes: f30f0601eb93 ("switchdev: Add helpers to aid traversal through lower devices")
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
v2: reword commit message to make it more accurate; include Petr's R-b.

 net/switchdev/switchdev.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 23d868545362..2c1ffc9ba2eb 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -460,10 +460,11 @@ static int __switchdev_handle_port_obj_add(struct net_device *dev,
 	extack = switchdev_notifier_info_to_extack(&port_obj_info->info);
 
 	if (check_cb(dev)) {
-		/* This flag is only checked if the return value is success. */
-		port_obj_info->handled = true;
-		return add_cb(dev, port_obj_info->obj, port_obj_info->trans,
-			      extack);
+		err = add_cb(dev, port_obj_info->obj, port_obj_info->trans,
+			     extack);
+		if (err != -EOPNOTSUPP)
+			port_obj_info->handled = true;
+		return err;
 	}
 
 	/* Switch ports might be stacked under e.g. a LAG. Ignore the
@@ -515,9 +516,10 @@ static int __switchdev_handle_port_obj_del(struct net_device *dev,
 	int err = -EOPNOTSUPP;
 
 	if (check_cb(dev)) {
-		/* This flag is only checked if the return value is success. */
-		port_obj_info->handled = true;
-		return del_cb(dev, port_obj_info->obj);
+		err = del_cb(dev, port_obj_info->obj);
+		if (err != -EOPNOTSUPP)
+			port_obj_info->handled = true;
+		return err;
 	}
 
 	/* Switch ports might be stacked under e.g. a LAG. Ignore the
@@ -568,9 +570,10 @@ static int __switchdev_handle_port_attr_set(struct net_device *dev,
 	int err = -EOPNOTSUPP;
 
 	if (check_cb(dev)) {
-		port_attr_info->handled = true;
-		return set_cb(dev, port_attr_info->attr,
-			      port_attr_info->trans);
+		err = set_cb(dev, port_attr_info->attr, port_attr_info->trans);
+		if (err != -EOPNOTSUPP)
+			port_attr_info->handled = true;
+		return err;
 	}
 
 	/* Switch ports might be stacked under e.g. a LAG. Ignore the
-- 
2.23.0

