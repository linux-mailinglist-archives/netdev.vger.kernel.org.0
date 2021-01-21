Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3102FF906
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 00:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725829AbhAUXoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 18:44:18 -0500
Received: from mail-eopbgr140128.outbound.protection.outlook.com ([40.107.14.128]:42933
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725271AbhAUXoP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 18:44:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZCMev1AE9q/pRcRP5rvE6A0UNWXe89/TF++Cn9xqsj5/2BnQHAltJGXb3d1t/clVkE1TQrc0s1sc8yGXbIdV3+Rs8h+agwzuBEEBKtMtkAey9BpB9Izpa5ccw1RdZ3VBf8NFUhTWJreD2oVHOYn7o6J07E8D1Geyr7Aki8KOyl80qhX1NIuqvSYXAZkTbcIiZEYOxRC5StGDKk/xeIL2KgPyH1iKwkLufTFnxCTQNkWASxy8SbVT2sBBfNGGGAZB5V51QFbvEU711N0mS00ro2j1v6+Go00GkpS6NZ94tFITlWT9u+HDMZuoVjH+ADY6ditTnLvbu+DGAJwJpYDYSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJC9H+QSZpZ7xTo8m1Z90eLUydF6YpVq5BcA4HJnEGU=;
 b=JTtcZi0XVmsFHWfpWG1aC6rwUO/lw8mh40wJZ5ld8hRpHqs5lrTkthVE7ls800yy5nu0czaljKwbqDziNGV8oiDuKvByfL9VorErBId3YEayIsHdFez5ciOd5gcAczfXF72yRONvhUOn/PeYL9grtra0YAlGwGoel/2Z9DjpbTBeitqcnpbvI1lO8F4y6hILHrOiOzxM14GRlurzPPWs/Ty+hbKc/w6x2BrL6prRtNkDM5Sjqm0FRCtliO7LbH8pWOnvg31NpFRH+WFIGb8+oPAXJhFbnBKEoS3eTlkT6D8doB9pkxakj+nkceYLg92XVq3BamCu+WISQhl63SVEGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJC9H+QSZpZ7xTo8m1Z90eLUydF6YpVq5BcA4HJnEGU=;
 b=jZiv+H1PufI4S3VRUj3HF5r4/qfru/kqSBCenZiMwlPyUPn+JlNtyw5bCMmReS4Dux9rMWBVRQKgN39NfUmNFCN6HtxylPhEEgO7a20NOWPNbfVu6eJRnWuMPy7XkiKkvEs8SxhG3cdtZ/bwdylfMGGFvirPJj555vMUbVgFZ+c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3601.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:158::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Thu, 21 Jan
 2021 23:43:26 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Thu, 21 Jan 2021
 23:43:26 +0000
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
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH resend net] net: switchdev: don't set port_obj_info->handled true when -EOPNOTSUPP
Date:   Fri, 22 Jan 2021 00:43:17 +0100
Message-Id: <20210121234317.65936-1-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR10CA0032.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:89::45) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR10CA0032.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:89::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Thu, 21 Jan 2021 23:43:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44f56a26-7aab-4303-debf-08d8be6658c9
X-MS-TrafficTypeDiagnostic: AM0PR10MB3601:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB3601FCE276F5667DE7030B8E93A10@AM0PR10MB3601.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZW8YaqaThr3PU2x0xRHcwRVxYA7F/lfhWbnlFXR7R5LfkuQ8MBmFV+u+HjY6WgT7/Gcee9ss6t+9rWyyLAa0yRJ2jzU/0yq0N+PBS6ryIzJB0bTvXo7ugaqnWtyzSF/IIuyTxpndYPU/NgX0KzjrzbNawCOPTdppwymtiI8rsbcYzs+5ABKmQo1gVO27EISJhKmb9//WaArI2W7vWZwx4nuxx0xYUMKof1bjT7VeaXSNBI3EKkLSol2n+8r3FsLl3Uxr4kZJZ3vQxiDjIKyldxPI+ju/iCFXUim86PyL4FyIM2l57FipA4JLVCqg1P5tt7j6jstF0MoSpAEWEF1G4alUQ42vB3nKFoowRGXcEllLxfhmvr9qc3JHwR1WQ7DBxfx6UGcl8zZtDMWf9lf4Uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(396003)(39840400004)(136003)(376002)(366004)(6506007)(1076003)(6486002)(8936002)(8976002)(186003)(16526019)(83380400001)(5660300002)(26005)(6916009)(36756003)(66476007)(66556008)(86362001)(2906002)(66946007)(478600001)(316002)(44832011)(956004)(52116002)(6512007)(4326008)(6666004)(8676002)(2616005)(107886003)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GCtgFnbr9MNo5g3zQskaI13Y2xei4InWgSHcDri9qNrF9XWcISGvYrM5VpgN?=
 =?us-ascii?Q?Z3jPyL1VXrUIrN6yh2SPYdZz3cpYPwxmpbUV8jBw8bNVBZ9tjfzigcVRTPgf?=
 =?us-ascii?Q?EZS812fuEcBhb8lAcVqCDyQZZ7WvnIqik05FPlYmT5Wq6OkrA5PrkkavVzAg?=
 =?us-ascii?Q?prs141ueFI/k544b5XixgLQt0sJSToS6E8IHv+88BZIVDwtc6OKGMLKVesUE?=
 =?us-ascii?Q?firCLMmYooq7raOL5rlMkJkWp2S1CLEd1uPV72UNSZuJcjwBaD478ZqmEg0S?=
 =?us-ascii?Q?mpwkXFXtHjaEv124IxaSXA+TrVTU37q1EYMhsit1VD/9Tx3uQVN8vPOdjfXi?=
 =?us-ascii?Q?KjUnjE5C+LIAwLGRrWYHsEA0wa22t1nPhSNRw1mkIsx2Ec9D41F6xkbvPWPB?=
 =?us-ascii?Q?RWE9JfAewfTU/t7ws4VpTo9r/9AuTX6yUDQ8Y2QwO0gvaiWNf7KPFSaGxklQ?=
 =?us-ascii?Q?/H5AwWAwtLACvAZ7bQSTxPZPTBpScwxJzEpCQw38s+90Qv/ZxYzNnRL5gL+o?=
 =?us-ascii?Q?hqYZ/sOYapcNzLwJjrBWQhvlkDUBcABE4A5F3KI5VcRd9hllurzckWGKcl+T?=
 =?us-ascii?Q?DFJbbN41683otgSszxaqF6jfJEy0frQs0+ER5KWc9g3msQRroOdq/IEdzL8n?=
 =?us-ascii?Q?X+J85V/bj9J+6x15lxJJTTKRUVuqmQ2wDJfbltxyYDKkvEWUGEVAhTpMwIbD?=
 =?us-ascii?Q?cTZ1J2RPe7NVjhFHvo9cSIovXVoqu+ZM2lL/Z5prptN9uRN1J6UxupPxdfsS?=
 =?us-ascii?Q?HtxYtNMozSnIjch/UOmNeViMU80S0nSw3wfaMJ2IL3g3wpVY/QIQV1+mS3Ub?=
 =?us-ascii?Q?dYoDLF+n8HtSZaxRJt6akiXRVJWncDoDoddCEZ/ze/2J1nkQ0fYUlmXpINLX?=
 =?us-ascii?Q?//Zv94RJbIIgLcmVOPzikXciPeCvcDfrWkyxJWu28Yrfvm04roEskgZW578+?=
 =?us-ascii?Q?2zoSKV9Hcgic1LHGw6KegYrPUOXOGaNiE7R/0LFe6n1nk3kGDtoNNquRc7bP?=
 =?us-ascii?Q?Mlmb?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 44f56a26-7aab-4303-debf-08d8be6658c9
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 23:43:26.0000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QyqQQY2nP1byjVj/4gPBDADBU58Z+6BYNp8fjJOzZDTyKJ9bkKI+1h3kzjB2bou0XtezsnhSwmUILKse78mvdgBICTF5GtS2MT02Hzy/qWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3601
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
support in the MRP code is broken - br_mrp_set_ring_role() always ends
up setting mrp->ring_role_offloaded to 1, despite not a single
mainline driver implementing any of the SWITCHDEV_OBJ_ID*_MRP. So
since the MRP code thinks the generation of MRP test frames has been
offloaded, no such frames are actually put on the wire.

So, continue to set ->handled true if any callback returns success or
any error distinct from -EOPNOTSUPP. But if all the callbacks return
-EOPNOTSUPP, make sure that ->handled stays false, so the logic in
switchdev_port_obj_notify() can propagate that information.

Fixes: f30f0601eb93 ("switchdev: Add helpers to aid traversal through lower devices")
Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
Resending with more folks on cc and a tentative fixes tag.

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

