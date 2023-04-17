Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2796E3F6E
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 08:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjDQGMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 02:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbjDQGMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 02:12:43 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11537E7D
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 23:12:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1bP58qxcynMOr56vGZIDotPbpLQ3lMVIDCwuFkTwCSdCqF9vyr1lJZCBWHrVegNY/R0C76e/O4TkyjciVJw9JSNQRjZWOj/panQrzEqWcMLB/ELqJBDiTUKfrwfvympASoVBsIylVeBIcl/2/5KtedvAUglprcjczKw8uLNjsIbkEkAjj4M9bN/E+/NVvbV+pT1zqu0alWHbrItWEBt747y8FWHehwz2qS85pfJ1sQpNwsWMK2cTXlCrSF3IU+Nr/qbPqs1fPSRSwpf7ulVLsebZFo751U4lOTVNDhKCjG8fJtMoNyZHdK2vGu6DVLuNzZcf79Kq3te4wohgzuh2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=32WtKY6/r2BxDw9MuywAgkZ7KUcEsU7txv7erqz27c4=;
 b=e7NHMAk46wSvx4730MjzhE6JG84at9e8ORQjE/qJPUkGUl3OTAPrOnCKiFSUWQgqoYS4mdJecWQRDabNFvMckGQXV9KneEg2sr0oLg9gh4jMFRBVxzJ/dkrmLvWNMdwKXEM+jNVzRLKTWgG7Paf+y2BdZT8KV6pAds8yohw3DBEj7AQg1tB04UBQ579HT9Pj4efzbZ250mMQx/VE+PoDzOpRwrLKsbWOPvwpHdwmCM6ZLfAm+d3yiUKS4l9yyLsDBT4Hg8oBsj3KyosAX1iWnFxTvqn58bBtwlKAEZcgkvJEpDdF6pjfBhSgGI7w89q2ELdT78I/4Bs+vt6UbjF3Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32WtKY6/r2BxDw9MuywAgkZ7KUcEsU7txv7erqz27c4=;
 b=FIrRcGkabc77JX04SZb1nYXemXOxOTQM2WsBXr6syZ6n9vHHQjEHVOOvY5ti4YhEo2OMt+/3RXKQyS4JYyTtsS6aRgfiFMkjtyyc2UiMBnJT05qU8n7xJeN4OcXP0lXfizJ+WI3ZDmKwaYWzWtuV1NDhyi7wVnqGFl0NbZAs2ZEIkdplTUMzoJc+t8XTOTNSk3O+oXRPabYOWNfVeNrcejPMED5Zwu4RhKmXgMAUceL07g6CVhAENYYBWMs90GKvBMy1Tx4Cj3lXwrx2HuNdcZzs8VlC++gDC2885m2xA83zvRBkmGVwZKXP0/Njq6gFmba5ql2Y2KcvVxLKnzIxMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5456.namprd12.prod.outlook.com (2603:10b6:a03:3ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 06:12:38 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%5]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 06:12:38 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, j.vosburgh@gmail.com, andy@greyhouse.net,
        monis@Voltaire.COM, razor@blackwall.org,
        mirsad.todorovac@alu.unizg.hr, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] bonding: Fix memory leak when changing bond type to Ethernet
Date:   Mon, 17 Apr 2023 09:12:16 +0300
Message-Id: <20230417061216.2398529-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0287.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:38f::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SJ0PR12MB5456:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e754650-6890-4652-5240-08db3f0abe66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dnn7yjJO99uLAVas4UecgrYCMRQDWL11aVzN9U8B6sguxTHXOank4VcifMvPCQilfPwIfKIfDUDGAu3C9LzX+cZyXMubvP1l+cNjSZwtck122BIHk5GFO0wPc7fd1LUBovfSiMAiZAMnqn1+ehqy4jHQjsbdIxRFznAAHSwAhpHCYTJ7+8E1ZZ5bVhNC3KoMoysI3OCaDdYwomHYU5KIPEeAd3xhfSKjyJaXDyfHhjBITSGT6rBduEh8lwSRTNUOmB5IZAxhDWHK081NYEFYtRRxmNCt4u45TsW97C5NyDLG2HfcS9U+Nn/Um2JMWmnfxfnbVcAT1eC8YAKu0oK4DJLPqZbB6ArKGOU1pDWbZQQeWdHZ8l6hcWJ7+6cG6S4uN2W6cST/n0xEuCqlZ9eF9eN9ZUhQQzpEsz6aFCu+ZMBHhT9IkuEzDn8TpvQMfLkY1gbTEqDy3/HBlzeLcbu7ZqSo0s6MSAfMxvzHeOGuVqJh2X719DpqVaRQLjdK7JjpADyTivxPzRWEm2WnRsbRTruZeSJrLlMjBdeqnuMuE3uhLYPKBhP/3j4slyqD4up+/+1GGDa0N0Ylf3yxGGlbTtS+so9qlkNQEpO9exmWgXFktXzII5V4NE8Tshu16bkKwuqYjOemVwuWrcj0sCWD8IUqPYVBcn5sWOdArnj7ibw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(451199021)(38100700002)(8676002)(8936002)(5660300002)(2906002)(36756003)(86362001)(478600001)(6486002)(6666004)(107886003)(186003)(2616005)(966005)(26005)(6506007)(6512007)(1076003)(66476007)(66946007)(83380400001)(41300700001)(316002)(4326008)(6916009)(66556008)(505234007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0q7jnEmCCh8VFtHyYHYL8Yp8MskHHd+b8DZTv3GB+YtuBkK/C5IMyQgqeGFR?=
 =?us-ascii?Q?8LVdjJbpQMMS66szmQPt3WLSfw8RN3FFXhj6r+2HYYhavWYcQn7o0HArKCC4?=
 =?us-ascii?Q?Mv3Sol87XEGrW/ZeOi0TzGLCkX3UYdwNR65W3bM+UeeqnY9byjtceWiMImYN?=
 =?us-ascii?Q?NuUx487Qq5TB0Voet14gxLSEeIzGoYpv7jsTfUdLwrZp51WrjMt+4pC908BR?=
 =?us-ascii?Q?zqU35EhIm8he7KFWe/86ZGjyoc5IyITcPUpl+qx3CX+Fnb68DUxsNPECP9pN?=
 =?us-ascii?Q?U0W1K4VhH/zrd9OhgiBdzC8cb259fr2y0KSKCckozfd9XYJbYt1HO4cgje/S?=
 =?us-ascii?Q?YwLpVPqYvebIznoqLA7auIB7GMIR1Zf+HlBRLP864uWFT1tmQAn4wSxYA8oP?=
 =?us-ascii?Q?HWtwSLVgd7hdmrY77gCj+NSDH/h6mgYPSshWZNJ4AHd8A55B0d4uKCHam+eS?=
 =?us-ascii?Q?6Hufcud6fmBi5ixh6b7MQpm9qh7GBiGNWDFW/RMhWbFmFZCGUrAD50YYDReU?=
 =?us-ascii?Q?xtxvoUWFPyPv9qBCFGHn1AbZPw0FgsiH5jvFns6z6kl6746ZgSm9tB5PWXat?=
 =?us-ascii?Q?j0x9Tq5ywxq/cZa+baxJdzAE/spa4BavhKwzf0Y5kYK0OshMpkbS7ryW9k2C?=
 =?us-ascii?Q?1Z1gBuEzYjxQToLvjQGXK9+pjO9evmT6OAOiHePNlY5Qtg8gvqWGhjKPTxvI?=
 =?us-ascii?Q?zUpysKU/QcBF0eH0L1cTPC9BQdh8QB9DK2WI/U842XABS05itXvz83gnHzOV?=
 =?us-ascii?Q?aMOvKlrQ0eRJ05WrrDSWtL00BRrofp+W4GYNB4b0RRH20KCsWyaIgoc0PFwY?=
 =?us-ascii?Q?dX5QxUMySCd1ldmJyg7oWUIv47LTcrb4HTzIhYcN09rV7A+y4GYeMxm3jZ48?=
 =?us-ascii?Q?lQDrl3/pqer+WuF8vmOMsoEr5YrXtP/J7qipp1uy09idfQYP1W4YeEtePYvW?=
 =?us-ascii?Q?jJI0Ec91b7jVTNcEpJD5g5Nw/DtzYYRoMXWQ0MUk+9AT4Ze05y0FhPi35AW0?=
 =?us-ascii?Q?C+nEBhJ+73S9r2pNA1xXF+pCK4LLfj84bNWjip6S9J9bTbHXX35v/7CR9J4q?=
 =?us-ascii?Q?tibLXx4vDkRkZ7zSuARUA7a5RLBjL6EjzKV74VJQXdcfzz476XzmFefIEcon?=
 =?us-ascii?Q?jHvjA92GQeOKqNX/S6NfylEfQOx/awRoXzCODEaSlo4q+U0BoRC7u3cfUE0D?=
 =?us-ascii?Q?t0XkpzlndBiJEWSHGu8Kb6/YySpITSTFyLwaI8BlK7jlVza7Y+rGVwItDZRi?=
 =?us-ascii?Q?pEy6jYhv854nzJL4Acp3wIAR1LM58fusCQFdFeDDU3yANnP/HbQ2kCBd73Jf?=
 =?us-ascii?Q?dV9KUApJgEI/eW2WxNbWd63aiIjZVJcqooDsz3k4MeOD+JcfB65ScScx3U6L?=
 =?us-ascii?Q?w6P3chw2UyH8Lxyc4UM3DP101wz208h99QPuprX+cZohisWh5XgMGhpzmX5S?=
 =?us-ascii?Q?H9Iahv5jNnRo1tIScV3itoSOqdFomUt9BW4YsXDWTZ+KwdVUgli+3TDKsQKd?=
 =?us-ascii?Q?sVmhVJAP1pD/jx19xcTBqIQ7Bla7adsxhuFXdteNehcpmqJ3zD+VMZEHjoEr?=
 =?us-ascii?Q?VG8EAe5lyg9rQeNDoVyJvoHV3uP2U/61g1Wq3RPO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e754650-6890-4652-5240-08db3f0abe66
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 06:12:38.1842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D5tf1ytwqeJtpQx7IicXHyTULsU1Pz+8DBsxPgToa4dTnWWVGDMslAK8uXWgaOmuBOA9dRu/I1paxi/9f9G5oQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5456
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a net device is put administratively up, its 'IFF_UP' flag is set
(if not set already) and a 'NETDEV_UP' notification is emitted, which
causes the 8021q driver to add VLAN ID 0 on the device. The reverse
happens when a net device is put administratively down.

When changing the type of a bond to Ethernet, its 'IFF_UP' flag is
incorrectly cleared, resulting in the kernel skipping the above process
and VLAN ID 0 being leaked [1].

Fix by restoring the flag when changing the type to Ethernet, in a
similar fashion to the restoration of the 'IFF_SLAVE' flag.

The issue can be reproduced using the script in [2], with example out
before and after the fix in [3].

[1]
unreferenced object 0xffff888103479900 (size 256):
  comm "ip", pid 329, jiffies 4294775225 (age 28.561s)
  hex dump (first 32 bytes):
    00 a0 0c 15 81 88 ff ff 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81a6051a>] kmalloc_trace+0x2a/0xe0
    [<ffffffff8406426c>] vlan_vid_add+0x30c/0x790
    [<ffffffff84068e21>] vlan_device_event+0x1491/0x21a0
    [<ffffffff81440c8e>] notifier_call_chain+0xbe/0x1f0
    [<ffffffff8372383a>] call_netdevice_notifiers_info+0xba/0x150
    [<ffffffff837590f2>] __dev_notify_flags+0x132/0x2e0
    [<ffffffff8375ad9f>] dev_change_flags+0x11f/0x180
    [<ffffffff8379af36>] do_setlink+0xb96/0x4060
    [<ffffffff837adf6a>] __rtnl_newlink+0xc0a/0x18a0
    [<ffffffff837aec6c>] rtnl_newlink+0x6c/0xa0
    [<ffffffff837ac64e>] rtnetlink_rcv_msg+0x43e/0xe00
    [<ffffffff839a99e0>] netlink_rcv_skb+0x170/0x440
    [<ffffffff839a738f>] netlink_unicast+0x53f/0x810
    [<ffffffff839a7fcb>] netlink_sendmsg+0x96b/0xe90
    [<ffffffff8369d12f>] ____sys_sendmsg+0x30f/0xa70
    [<ffffffff836a6d7a>] ___sys_sendmsg+0x13a/0x1e0
unreferenced object 0xffff88810f6a83e0 (size 32):
  comm "ip", pid 329, jiffies 4294775225 (age 28.561s)
  hex dump (first 32 bytes):
    a0 99 47 03 81 88 ff ff a0 99 47 03 81 88 ff ff  ..G.......G.....
    81 00 00 00 01 00 00 00 cc cc cc cc cc cc cc cc  ................
  backtrace:
    [<ffffffff81a6051a>] kmalloc_trace+0x2a/0xe0
    [<ffffffff84064369>] vlan_vid_add+0x409/0x790
    [<ffffffff84068e21>] vlan_device_event+0x1491/0x21a0
    [<ffffffff81440c8e>] notifier_call_chain+0xbe/0x1f0
    [<ffffffff8372383a>] call_netdevice_notifiers_info+0xba/0x150
    [<ffffffff837590f2>] __dev_notify_flags+0x132/0x2e0
    [<ffffffff8375ad9f>] dev_change_flags+0x11f/0x180
    [<ffffffff8379af36>] do_setlink+0xb96/0x4060
    [<ffffffff837adf6a>] __rtnl_newlink+0xc0a/0x18a0
    [<ffffffff837aec6c>] rtnl_newlink+0x6c/0xa0
    [<ffffffff837ac64e>] rtnetlink_rcv_msg+0x43e/0xe00
    [<ffffffff839a99e0>] netlink_rcv_skb+0x170/0x440
    [<ffffffff839a738f>] netlink_unicast+0x53f/0x810
    [<ffffffff839a7fcb>] netlink_sendmsg+0x96b/0xe90
    [<ffffffff8369d12f>] ____sys_sendmsg+0x30f/0xa70
    [<ffffffff836a6d7a>] ___sys_sendmsg+0x13a/0x1e0

[2]
ip link add name t-nlmon type nlmon
ip link add name t-dummy type dummy
ip link add name t-bond type bond mode active-backup

ip link set dev t-bond up
ip link set dev t-nlmon master t-bond
ip link set dev t-nlmon nomaster
ip link show dev t-bond
ip link set dev t-dummy master t-bond
ip link show dev t-bond

ip link del dev t-bond
ip link del dev t-dummy
ip link del dev t-nlmon

[3]
Before:

12: t-bond: <NO-CARRIER,BROADCAST,MULTICAST,MASTER,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
    link/netlink
12: t-bond: <BROADCAST,MULTICAST,MASTER,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 46:57:39:a4:46:a2 brd ff:ff:ff:ff:ff:ff

After:

12: t-bond: <NO-CARRIER,BROADCAST,MULTICAST,MASTER,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
    link/netlink
12: t-bond: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 66:48:7b:74:b6:8a brd ff:ff:ff:ff:ff:ff

Fixes: e36b9d16c6a6 ("bonding: clean muticast addresses when device changes type")
Fixes: 75c78500ddad ("bonding: remap muticast addresses without using dev_close() and dev_open()")
Fixes: 9ec7eb60dcbc ("bonding: restore IFF_MASTER/SLAVE flags on bond enslave ether type change")
Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Link: https://lore.kernel.org/netdev/78a8a03b-6070-3e6b-5042-f848dab16fb8@alu.unizg.hr/
Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/bonding/bond_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 8cc9a74789b7..7a7d584f378a 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1777,14 +1777,15 @@ void bond_lower_state_changed(struct slave *slave)
 
 /* The bonding driver uses ether_setup() to convert a master bond device
  * to ARPHRD_ETHER, that resets the target netdevice's flags so we always
- * have to restore the IFF_MASTER flag, and only restore IFF_SLAVE if it was set
+ * have to restore the IFF_MASTER flag, and only restore IFF_SLAVE and IFF_UP
+ * if they were set
  */
 static void bond_ether_setup(struct net_device *bond_dev)
 {
-	unsigned int slave_flag = bond_dev->flags & IFF_SLAVE;
+	unsigned int flags = bond_dev->flags & (IFF_SLAVE | IFF_UP);
 
 	ether_setup(bond_dev);
-	bond_dev->flags |= IFF_MASTER | slave_flag;
+	bond_dev->flags |= IFF_MASTER | flags;
 	bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 }
 
-- 
2.37.3

