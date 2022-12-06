Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403BE6441C2
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 12:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbiLFLBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 06:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbiLFLAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 06:00:17 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDDC22B13
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 02:59:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3qFuLZC0BB/N7Azb99NzipDlXYP4+DeriT8nsz+0TY6VRdLxx00iaoPMXcKwLd8oD1MREh7gYiD9+c0H1FudDGfNn5mNkLbeGmav+TatVCJqSli3WPBZARGMRJZjwL5TU4LyFbbftA53ErTMpPP/y94vvJPbkwsoQ0QqN6qGLAFvCLWHHrJ4SGE3tiZg0AqeifbsMjCYCUSbR89sGGrhNT+D32x9VRtH7QFfJMK5qWMbYPioJMLDQxQhF2zQ9/jHirorc1fzQwWa4woWUjljLJ5yxGy7gLJPa+t8sJqpPCGaiEZq6VuufVFrMoo5f6llcaoziYvoR0KWB0AjZWjHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mXyHyrMzVsh1denck4pjX6bxuHTnUid3ejMf09nWG38=;
 b=QvsnsDzzCiFEH79YF9AeCfYWoS2kJuFPCRWP/y0ND0/6rpL5M7Sx2xBg22v8Yalp218xqim14NOpjse4coumyh5EFyFfoQKm2WEwYZL8L/HvHP+ukcDpx8JpQ2HiFqsW5ICJHeevaIoK6tdI1RQG+atlkXSAT/p8Hz/471i3wuG/Tx77bz9bofmovn77Vz2fC8CZYL3lr6G7CTE1jRMFubv9RONBwWoYf2c9I584i2EXMB0puyQhpgluRkXkusNBLLRu0JixheLr9EMsCqAXKAF2pViTrIXyi0Pubf1Gtk27rjUwIqttmaXaochqmLrXIA/1c+bheaw1USbXHwIFbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mXyHyrMzVsh1denck4pjX6bxuHTnUid3ejMf09nWG38=;
 b=K4LsxDdyCWdlPYIcKmKVo7mjkGScr7asZIiqSa6ZpaBrGYLje8ElYdIwSdQWEKU9xLSf/mLtq/PCUzxoxIuMMXwMLMTiro2aeMo4LG+cAVaEnuL5i4NQHLlCVQEmqFuNvjgQr0/splfPuSiKWCGDTtfWhnlSXOM1poOpjlZdJwv6Y/I0ZE+Kxw9ly3CTOCKZBYKiSuk0RP6mA27C7PUQLEIMFkxuwPQDpq0LKFYq0UrYgcSL26aiXv5apOCLlsxS+FZyf/IlY//j23IWxymRXzTVBzhHgwMW7WKIPBc7XcFrXPmurGnPjsN6PhCfzWTxaJL/1wU5oWVt5cF9NiTScw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN9PR12MB5131.namprd12.prod.outlook.com (2603:10b6:408:118::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 10:59:37 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 10:59:37 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 9/9] bridge: mcast: Constify 'group' argument in br_multicast_new_port_group()
Date:   Tue,  6 Dec 2022 12:58:09 +0200
Message-Id: <20221206105809.363767-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221206105809.363767-1-idosch@nvidia.com>
References: <20221206105809.363767-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0141.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::34) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BN9PR12MB5131:EE_
X-MS-Office365-Filtering-Correlation-Id: 15e05406-f033-430d-726a-08dad778f740
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 47f9D9ICJmKJdgDHDG4IreLkPiaqf0Du5zlfYUSATgwwT1/3eLYm9RN313XXbmI8KciUsbkjrHrgEzjQGTjFDjQ7Y2QWN+uzA3/3MCMBZuHCJUtHIwLdsLpFDOPScGbJyCFNEfvpf6gdYwa5WAuitNChWyKzryTkMxfcjGv02tlasMrv7OUcZX7ChhwtBSg6QICn91AsS3b8A33jmn69nwwb7qpDho2ThS5CKBn0X/Z9Pdc7l1NV71bzgPfg2yA2IkwScVJAzjjWb/LGimOw3Lnrx/dgeRBVGHIkBO/RJ93Rh+Bf+/SJibkixa7ljVpUn5OM4BYTUAL+PLzxKTshP028EXrKgHALbojd8N8Uhjcln4FA2E2twYyJTqy9J0qjjX1XooEsy/HPWljaghZVr9G9T0l8ZnBW7ksd2ourResijBDzvKLq6kyK5EVgO76XG7aQAl4PvAqFlroRkmTCDPXWADEvSh5JZo+fIfa39GKQbTWQ60Zq4SxdA+Pzfl46VCVT4mFkt514Bpds3Q+PfHd1oEhBDe4HdOp6f8khfuxy2qXrB+jU1wVciMa5E22nY0S/XHmsxI/RRlWpqPltg/4GKxb5NsWHVJcZ0mPcmybLIKSOMcW3wVdrTeCW2UXf4Lz2/eDp/bjNHyy4UQTBrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199015)(36756003)(86362001)(38100700002)(6486002)(478600001)(6506007)(6512007)(26005)(186003)(107886003)(8676002)(6666004)(5660300002)(4326008)(2906002)(316002)(66556008)(41300700001)(8936002)(66476007)(66946007)(1076003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WmD1qhxvkhJtHF7PCb1XHh2szeuIziwD7VnjMhYv5CUtmgSX14sLQEV5sAKv?=
 =?us-ascii?Q?IB2iK1a7ErZ0UDKlBqopP+7/mb62ldeGGxVZ2AKoiyNBuuAo6lxMyCms1ETC?=
 =?us-ascii?Q?x/qdv1u0zz/+q77/Md2ovsCQBDay8uw3v9Ge3QK+5/+OOVOHZt+TXkyM7Pr0?=
 =?us-ascii?Q?BN0/DmimLffKa1gZ4NhxZTzS00v9z2XGDcBo+EFNRgsBN/kDaNrVOlS0EsGz?=
 =?us-ascii?Q?kp8utJPtOhQD1+6Pi/YwQhWvXnZ3owR8zmpBPgdW/SQagsUdPoxJrpebt7C0?=
 =?us-ascii?Q?ArOGTFMUZmgDdJwTa4dsXDhrLBsn97/hP/ZqAEEMmZnl72tTM5k8PRISnnt6?=
 =?us-ascii?Q?bNTWIDfhWMLCTFHzk4JchlGRadxJSeAyBFwgOa8ivNhada4W6b6i/xiiNceG?=
 =?us-ascii?Q?gRsP+fqamJIzMOPqExc/D63ZM/3aH5VEGmx0NevEjBmUFgyq3D8UASsaPimu?=
 =?us-ascii?Q?hO7i78Z/z8EXlY9Rt99UubU6H518etie12V/NmD7PhX+6fq6QRaVr7euJl+x?=
 =?us-ascii?Q?KYm8UvJxrKkBbyayjLYMi8d7kzJcJd43zzDzraTH+1r5UJDSe/BHkCjah38f?=
 =?us-ascii?Q?4FMTv749KLuZUtLrxdklk0aIFk27gjz7y+LTxtYEus97wBVKQA7wYmOFOEPv?=
 =?us-ascii?Q?7rziGzzykzipAdcELPBhSOfI+SaENNtSQkLfpE3zyGtm8BYK2Q1Ez949P9js?=
 =?us-ascii?Q?Kp3MTLIjDLfeuw9zJTP1xFRLdxscJaBum9e85IebetHRBN32/+KeVunADoCl?=
 =?us-ascii?Q?8LQt+0/74b3Y1PJAWZUObpocXQBN07uTRuySd69opcO7n8uWePFK7AobB9qx?=
 =?us-ascii?Q?GE8x+RCv3ud6V0s9mYBXRjjMKyiQNjIJplk5cbsfcp6h5ZmwfEI6qTEUFE0k?=
 =?us-ascii?Q?CjzKDXCEqCA/8TkaKbGf/ljkDStOHlY1jZuHXuHM9Q06ddwv6ATKeonryc4h?=
 =?us-ascii?Q?WhjqoBNvU6jgWcxKEo/rOv9pP0Ex2UbEXy4X0SOjorTqEmvOUAMk6ytqwSrM?=
 =?us-ascii?Q?PFAiuFvR9hjRXo2SEufygL0w4XvD0zw+dM5AGgsrmd9apiNwRAsaD6uqxyMe?=
 =?us-ascii?Q?K7h/3NX3yovmGFHBYKTf3uydiH3ZTIhgtIO5yUZq7d/cO6l+ktsbtdeY3syE?=
 =?us-ascii?Q?dEhsFsSOgtfh1jHOiHF0hjBQsV7lWwhRTNXVdg+0twfKmnkfcw9rou6fSAZA?=
 =?us-ascii?Q?GgLJKZVDNftFhge2eeWYT7bGXOCShyF79m5xbTa83QI8foEImsznzrTM8ITT?=
 =?us-ascii?Q?IWV5h1jyLqxbzO1zWMyzlupAQjEjG15iL7A76Ho9h3UnpshPF5cCTomo3VbU?=
 =?us-ascii?Q?dlweSrRufDCHu47NEF0VJ2rfaz5xEmIl9iS5+I9m5EjvelbW9qwsCKTN6GJh?=
 =?us-ascii?Q?1yR9KHCSU7OdWK/7+IEjJ0GxA4q1iTjXTrS3Zw/BrmEdZu3tqdtweYJ6Hnh3?=
 =?us-ascii?Q?GRYSkkDDuaUnKl0EfnViooz5m/Od3roLtVmaKiDJi0cUPDOn6kMZXi6q1rdj?=
 =?us-ascii?Q?g4EMsyMLDI0mSV86/UjP7Gkq6lV8c0UHZOCIDO1UHW2nA7knj47bBvGDIqj1?=
 =?us-ascii?Q?rIun/WKDNi+2nY/i+unFK5fdg6O5eMiKPWYXOarI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15e05406-f033-430d-726a-08dad778f740
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 10:59:37.2777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KV26s3lEAysocFfl7tYoz9+RxND7yed9ChnV24ujdCjNdjXyNfDEpxbQDXescGKFeHIOVQRyJvKVr0xxTjOXQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5131
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'group' argument is not modified, so mark it as 'const'. It will
allow us to constify arguments of the callers of this function in future
patches.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    v2:
    * New patch.

 net/bridge/br_multicast.c | 2 +-
 net/bridge/br_private.h   | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 5e988f0ed2c0..db4c3900ae95 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1273,7 +1273,7 @@ br_multicast_new_group_src(struct net_bridge_port_group *pg, struct br_ip *src_i
 
 struct net_bridge_port_group *br_multicast_new_port_group(
 			struct net_bridge_port *port,
-			struct br_ip *group,
+			const struct br_ip *group,
 			struct net_bridge_port_group __rcu *next,
 			unsigned char flags,
 			const unsigned char *src,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 0a09f10966dc..3997e16c15fc 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -941,7 +941,8 @@ br_mdb_ip_get(struct net_bridge *br, struct br_ip *dst);
 struct net_bridge_mdb_entry *
 br_multicast_new_group(struct net_bridge *br, struct br_ip *group);
 struct net_bridge_port_group *
-br_multicast_new_port_group(struct net_bridge_port *port, struct br_ip *group,
+br_multicast_new_port_group(struct net_bridge_port *port,
+			    const struct br_ip *group,
 			    struct net_bridge_port_group __rcu *next,
 			    unsigned char flags, const unsigned char *src,
 			    u8 filter_mode, u8 rt_protocol);
-- 
2.37.3

