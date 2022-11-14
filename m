Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0586277FE
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 09:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236059AbiKNIpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 03:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236594AbiKNIph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 03:45:37 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4AC1C12C
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 00:45:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fl2gr6rfGQDrGW2JSf73zxybp8DBvViH4wa3OyRNxCkTi+uU0F5M3BIQgQlPhDSzk6skNWLvNFhlovnBhPD565HPsoWnG3A7RN14X1IGlLKwj6mbV6VO4C8lmfJP5VI1QjIYF1XRz9OXVra1l9c/ump13G3e7+7oLB9IUKyOtf0lzCYPLqTtDKCfwjWh46Uv656uWnvtHHNWQ7YG7ZgvY+9p2ssDWZd0FvbXU5oZZjG1ZTKWAOHsKQ+qZB9qxk3rpEJ9E8Utayv6lxtixzfCYWg06PYihhyEThzI/WxApcr5Hn6p6T+PxhzyM98hK5jUXJwHy+RyWmSjtx7xQL3NHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y2UmMOGhFjxGSly7YCf/9D1jxv9DqmRzC9XzlwyOmyM=;
 b=Cfdzt+SeFmqkITITA5a+7A1KdnplqJ2HvJaEiqSZ2c9IM3oePWmXbHLp1RkIiNYX3hXwhOXyUIoI65bHtAGRghz6ZuXk4QSk5Ogo/HVPhXSe4FY6VX/QUj/GwXY8J17LzeNXFLk1RsKugdXVZMLSQxMotbIlJ+OFiEiFsR/h2WdDXOVeFvphVFG0jkA3zwC+BGIuiBl+M5LGEOChNO+/8ns0wqv2yD3CeBkKTIhuCqhBf5FbN3Du+D0IVbeo3BcP1mKIJG6O4GEGh6aJ/TuycTcmGwiik4gh00n4pNpj5F8vkaxX9MKr5gvMQaXpZQpnb5mRlmoilfJ1WCj/wpt6Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2UmMOGhFjxGSly7YCf/9D1jxv9DqmRzC9XzlwyOmyM=;
 b=fV12Q9Bhq1yftL6k1rKGituz0KL2ou1YzDRHoC0CKf6hZQ79oO70QED40yY+jbZQxm5TS6I184+0jlzIfLsOI267O+X7agt8vAX/C7JI541x787rK5aN9N3igmu6bQpthcmn+izNFoMgGPj3lcKrwqzo76lA64MljwWhVy+bWbU9iEI7RfoGnKZ8SMeBDxsdIFG7I29fP6Sa7CXK/lcgov6gUpslqAYOP0V1TYfozPBshnJL5mxBKx94NsZbFCmLR3FxEmoXq8VsrAhAMagHnj761/tzJFgO3xoTvGi/Pp2QaBnyC0mb+3q/J/cLTB1tXyyLYvPOToHT48FOY2kXdw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SN7PR12MB6958.namprd12.prod.outlook.com (2603:10b6:806:262::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Mon, 14 Nov
 2022 08:45:32 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9373:5894:9cef:ada6]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9373:5894:9cef:ada6%3]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 08:45:32 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, vladbu@nvidia.com,
        roopa@nvidia.com, razor@blackwall.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] bridge: switchdev: Fix memory leaks when changing VLAN protocol
Date:   Mon, 14 Nov 2022 10:45:09 +0200
Message-Id: <20221114084509.860831-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0244.eurprd07.prod.outlook.com
 (2603:10a6:802:58::47) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SN7PR12MB6958:EE_
X-MS-Office365-Filtering-Correlation-Id: a5ca94fe-3f0c-4714-1560-08dac61c96ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 52FGziXkGcKQNFXqIJi4d5MqJdsFo5rwAHaXcFkl+5euUfkbRBYNqiBJXg9NOzE8jSOPQJGASNqF/QmWMJWvXZqHHPETZOok1XSPlir8bRRWPV0pbupOv1cVJB9CTCtPBJZqx4nk5ZYZryWregHYTo06V4KieW/vo2NuKGH54BZNPzBFmce5HeoT9EoqspVavOxDMXfFJnBEda1VuFUEPFvo1q72ufniXnbQID0X+NbtMLlBWcuuYbBggLJY0OQEpT5R7sZN2Na3wAPTNsivV1vs3tjI4YOzZcs5RN+IrJ8+IB7pVV31KjFVYkW8m+uhzmKl9YHxxJpWOpRsqBJXFgVY1cKLRRbdA2k3V+4dE/0yA/K2BCLeHVcQI8+Dh0GfjDIfQZuyI6CMdlHBEAGudvDdbfIWSF+6yQwOAYelKMKkJC/0wMm3hIRskQFO1kQZDu8nfT4FM/l5pzINfhUyDSzRN2Sdx+7ucwyDzIkmQCZL+5IGcWkQgsNj6NkoMRsuxEpjugFu30F1F5S7yphdkRL/S4KkY2TvW7pSkazoLd92r9S+LPm2WMLyZpobpGiRYrtpzk2JX6xIM39M6sukC9uP5fj8a1XLj157QkjImDSaUfeEhXZOQIUyhAvSqnXZOv9G0R99Xdv6cLoOvKj0jcJZK3uFZWbpkT2z/0yly7WDyLY6njgdcW0zWOCQ6DIz3kl4FM5lLhT1zYc7XW2ERka0+B1+ZU0LcGytJg06V0iGWCO0Jqf3wJ78EFWyDYUA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(346002)(136003)(396003)(451199015)(83380400001)(86362001)(316002)(41300700001)(2906002)(4326008)(5660300002)(8936002)(66556008)(6666004)(66476007)(107886003)(26005)(6512007)(186003)(66946007)(1076003)(8676002)(6506007)(6486002)(478600001)(2616005)(38100700002)(36756003)(505234007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pAXY0MA3SwDlnKRw2UEXzV3Co4hC0FefV+GsArfo2OiMg7SB+xhIa49bFJ76?=
 =?us-ascii?Q?j6xeHhkzo0T5r7bdNrNjGdOodRSB6ST+ccBW+fMvTWmgo/4GfCvkpfrnapya?=
 =?us-ascii?Q?nJifiLrtFlI4ImgrG+G1asX0QajkAuz6vVMbM0oSbx/1/t6SlDa78iDdUAOs?=
 =?us-ascii?Q?XnL51wiiPR8ZT3xn3ySzvjg4GuFPDLdWPGQV9cgWv8ZeZ/49nUr7hORLiH8d?=
 =?us-ascii?Q?QOyk5GGeYl70OcYXeUAUlDUml6/vb3R8B1fj9qmOxO4DWyJxTOT27bmi6sK2?=
 =?us-ascii?Q?fVD3jVZ1nyjkHN0xWanIR7aYvFgPlf0ZbL+eCO3o851sJPIyh83SBWtDimb8?=
 =?us-ascii?Q?+ZUy+rlqi4UZ5Yp6B6dcFKHImYm0jQ3JN8FBzTEILatj9/KuBhhdWaqX/pi8?=
 =?us-ascii?Q?hQ4ucRXNgclFTZjedcK9b++z3qN2QhShSo2hIW7k1SyfTNXZtSPe7njdHqVf?=
 =?us-ascii?Q?4hzih4SZwLjDlTVCvh8HhEO5ZTkEm9vY9OYhmxmfmtFdUZHqnoqfHkEyKmzF?=
 =?us-ascii?Q?EYxaiWl5pP/zB3zOHNou+I2kDco49UXgz4nrfdbf5GSMbZJnYBjmJ17t/BnE?=
 =?us-ascii?Q?7W+pf5UiiAMvpBXbzH6xRZPhMnWX5/fR+mmUugtp3AjrdNbC5S48pzfCpZ9B?=
 =?us-ascii?Q?3Xl5G5ui6XxeYLlhK7FGmiRSw6LCyH/moHrITf+Tz52PZacshRlcUlHdsfII?=
 =?us-ascii?Q?BnXu8r+Wde/DhNyPq4LuuJrS+ueBXNokW0vqxfyC3euXnco8NJ7K/MSzAEgV?=
 =?us-ascii?Q?IxIwPrThIC8AfcblhDyAA6bOni1yrSYXtZOfsmFyDmBP2lHeXKRE5hoJsmq8?=
 =?us-ascii?Q?KUn7AQva6aHENexE2YDHjfhEHCLP5+9Md+yjyMuYw3GKq4T9qJdmzYcoUTly?=
 =?us-ascii?Q?2pgPtRPZohhRl8bqQ86qsTrI+TN2mWg+4Zt2MkXFNnAlRlmhNiaMXsfLwWYY?=
 =?us-ascii?Q?d5ZlIRr0k/OL2ltuwo6MYJt28OREqen1eV6uKrzaV/BAT3WL6l9IPar4V17R?=
 =?us-ascii?Q?UC9qhRfsJ3rmFPkiL+COL1gi1TFXIbCiCQ2TFGNORC+3bCFNGNa/xejwKxD7?=
 =?us-ascii?Q?3SVn1m8Js7JXXidSugnNM8cD3MwaMlje6P/esRtdOkYlZY8n80V5WDg7RtUN?=
 =?us-ascii?Q?vuNJgUcAN5eRuNQHxNlmc+F2rp+P+1Wp5hjoitcq3NQYGDo0dm1i3XWuI2PQ?=
 =?us-ascii?Q?NVKs4imvuD3cucS2KfgcdVewcu8LNdfxfiVekZ8eaAmJa2f0zmiMeOi7QP0L?=
 =?us-ascii?Q?bZHGlAB5fXFBSDXjGIxTlElvPCQYHIcL1sIW8Hs+B0foHyUh87wwgnpl3eFj?=
 =?us-ascii?Q?mGZ6fqInv1bs8CqSn7XO+7wVGBOyZ8qAgmGwKy5hB2GKOBvPJ3d60nvq1jbX?=
 =?us-ascii?Q?bJQVV8jYD9owXJRt9nmfOcXsObvJm58W6nK7NGlP020zEuPpYaHFaGB9mUjc?=
 =?us-ascii?Q?CgtWY7TSRyDQqCJTgzMJLcBp6PZ9l22ay9auFLXWq4uYyjhKWMw8iYHGZ3OG?=
 =?us-ascii?Q?HHUuKSM/ug7wYu67gY9DOWEPwgSYEKHtXD5b2M06QQObnX+fNnclpkAqKySB?=
 =?us-ascii?Q?lCuj/ZQtc7QzlIpyM6w9SpSgHFcaxgDT21HfWK4E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5ca94fe-3f0c-4714-1560-08dac61c96ff
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 08:45:32.2748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DQWNMQSqPxe0Fi3fYzmezA5N/0KCSWd+Z6ao+dd9qEKBoucWIMJdQu5UL65uzU0htJ4b116JfipL6baJYCQm0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6958
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bridge driver can offload VLANs to the underlying hardware either
via switchdev or the 8021q driver. When the former is used, the VLAN is
marked in the bridge driver with the 'BR_VLFLAG_ADDED_BY_SWITCHDEV'
private flag.

To avoid the memory leaks mentioned in the cited commit, the bridge
driver will try to delete a VLAN via the 8021q driver if the VLAN is not
marked with the previously mentioned flag.

When the VLAN protocol of the bridge changes, switchdev drivers are
notified via the 'SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL' attribute, but
the 8021q driver is also called to add the existing VLANs with the new
protocol and delete them with the old protocol.

In case the VLANs were offloaded via switchdev, the above behavior is
both redundant and buggy. Redundant because the VLANs are already
programmed in hardware and drivers that support VLAN protocol change
(currently only mlx5) change the protocol upon the switchdev attribute
notification. Buggy because the 8021q driver is called despite these
VLANs being marked with 'BR_VLFLAG_ADDED_BY_SWITCHDEV'. This leads to
memory leaks [1] when the VLANs are deleted.

Fix by not calling the 8021q driver for VLANs that were already
programmed via switchdev.

[1]
unreferenced object 0xffff8881f6771200 (size 256):
  comm "ip", pid 446855, jiffies 4298238841 (age 55.240s)
  hex dump (first 32 bytes):
    00 00 7f 0e 83 88 ff ff 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000012819ac>] vlan_vid_add+0x437/0x750
    [<00000000f2281fad>] __br_vlan_set_proto+0x289/0x920
    [<000000000632b56f>] br_changelink+0x3d6/0x13f0
    [<0000000089d25f04>] __rtnl_newlink+0x8ae/0x14c0
    [<00000000f6276baf>] rtnl_newlink+0x5f/0x90
    [<00000000746dc902>] rtnetlink_rcv_msg+0x336/0xa00
    [<000000001c2241c0>] netlink_rcv_skb+0x11d/0x340
    [<0000000010588814>] netlink_unicast+0x438/0x710
    [<00000000e1a4cd5c>] netlink_sendmsg+0x788/0xc40
    [<00000000e8992d4e>] sock_sendmsg+0xb0/0xe0
    [<00000000621b8f91>] ____sys_sendmsg+0x4ff/0x6d0
    [<000000000ea26996>] ___sys_sendmsg+0x12e/0x1b0
    [<00000000684f7e25>] __sys_sendmsg+0xab/0x130
    [<000000004538b104>] do_syscall_64+0x3d/0x90
    [<0000000091ed9678>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: 279737939a81 ("net: bridge: Fix VLANs memory leak")
Reported-by: Vlad Buslov <vladbu@nvidia.com>
Tested-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_vlan.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 6e53dc991409..9ffd40b8270c 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -959,6 +959,8 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto,
 	list_for_each_entry(p, &br->port_list, list) {
 		vg = nbp_vlan_group(p);
 		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
+			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
+				continue;
 			err = vlan_vid_add(p->dev, proto, vlan->vid);
 			if (err)
 				goto err_filt;
@@ -973,8 +975,11 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto,
 	/* Delete VLANs for the old proto from the device filter. */
 	list_for_each_entry(p, &br->port_list, list) {
 		vg = nbp_vlan_group(p);
-		list_for_each_entry(vlan, &vg->vlan_list, vlist)
+		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
+			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
+				continue;
 			vlan_vid_del(p->dev, oldproto, vlan->vid);
+		}
 	}
 
 	return 0;
@@ -983,13 +988,19 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto,
 	attr.u.vlan_protocol = ntohs(oldproto);
 	switchdev_port_attr_set(br->dev, &attr, NULL);
 
-	list_for_each_entry_continue_reverse(vlan, &vg->vlan_list, vlist)
+	list_for_each_entry_continue_reverse(vlan, &vg->vlan_list, vlist) {
+		if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
+			continue;
 		vlan_vid_del(p->dev, proto, vlan->vid);
+	}
 
 	list_for_each_entry_continue_reverse(p, &br->port_list, list) {
 		vg = nbp_vlan_group(p);
-		list_for_each_entry(vlan, &vg->vlan_list, vlist)
+		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
+			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
+				continue;
 			vlan_vid_del(p->dev, proto, vlan->vid);
+		}
 	}
 
 	return err;
-- 
2.37.3

