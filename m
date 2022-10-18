Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6808602B40
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiJRMHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiJRMHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:07:18 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2058.outbound.protection.outlook.com [40.107.243.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611452611E
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:07:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YKrzk4rSghYeSqkWqDt7z+NY5hAcrT+TJ5FePCO15QyF0AHxW9cpOY+d3TzpQBUwCQLEfck9Vd84Df04vxMPYD9gQFqlqjalbnp1kS4fPchTbbo8h5Z6xLpMWaL/AzbcubB77iHuoTnFvOQ3PSvzRcAvkKXPiTkb29vSSScxfKYgh+OXN1I3d5khy3SuMdeP/syXF6Nr8QG/cll5n+nkG1dtKhSK4cebcKeLG01dq7tAXjoQqXLG265XvGjTuiwDgYkbcgovOiaTTyfkmCOGsGjj/ja56P9UgHfzVVsN2FoqPovmsDbRVEl5h4zZ2oyHqWSZusFuuSAAsQSiXv7Dcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1QsM3xrlFg3Hwve88DhT1PMFVHcN/MuwcfAYpgxEF+g=;
 b=ebgepFbaixIfcRXTJr3wC6x0RhXXFffJ9nkZY7dqrW8mV3qmkyHi0vh0IiSVnv30xkih02lZRLrz/1HOX65tI5qgD4N/XF5fnqRVryJLEY5OUyWndsmOMRP8aoVj/MSGJh3KVQ5zBb0Vk32zJqZ+VLsTVD/qAf4XDpAGpvrjWp5cR6USQkwTEGpoCAz7n+ePtGg44byBO/LOfSTXGUDW9cWX152CM8nDGH6QnSNEI5rzRCpEOWBXEOI/ThvLCodvtGlklNHxz5Mz0UXnG1giERZxNZGS7tY5cTWD7/x2GhDgUwS8Slz3ghdw7keGSDA8OCD3dNi56yeddmV5enzgMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QsM3xrlFg3Hwve88DhT1PMFVHcN/MuwcfAYpgxEF+g=;
 b=SSQKoVAwJICUbYEzqnXBn6rVa05B1FYnNfzNI/7seeHHMhLvFCej14xvxWKFHD2ddj0xUWnyiKl+jrmNFOum0O6v+AVdvLs+WBY4MhoGmqiFpyoFBEqHe0Sc9lP3M2XyZdG6GnoypUk5xyYiHsQG4oerzNjR7QEmGJEwjnpvqSm8qBwE0ucuOfVGRMihFMTaszSgDK++5Bobz8oiCGs+hh4mLwW1Fms4fIwpxTqquJgo+oyHSZJTZlic2g6VjHm2WrBWjOPQc8Zm5bl5Otvn2//WQhfOlVUAdw5q2CibXdEOfpcH/HnirEMLFGA6jwn1R/G1F6RYQx+r0e62dakqcQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH0PR12MB5140.namprd12.prod.outlook.com (2603:10b6:610:bf::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Tue, 18 Oct
 2022 12:06:31 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 12:06:31 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 12/19] bridge: mcast: Add a centralized error path
Date:   Tue, 18 Oct 2022 15:04:13 +0300
Message-Id: <20221018120420.561846-13-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018120420.561846-1-idosch@nvidia.com>
References: <20221018120420.561846-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0016.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::26) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CH0PR12MB5140:EE_
X-MS-Office365-Filtering-Correlation-Id: ec3d0d42-df18-485e-43b0-08dab101317b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1rQ2OkweavUKmH8mqhqy+ZNx9e/YXRF7zycZ1pKypsHU9ihu1RWvrGHqtEENIoH2JO2OIRUel3pqi1t6IDn+HBP+p0bVsDDVNzsKjGEFquz1WUCjVl16ytsnSlrCqAk19mKTGaHfR/zOjL5W1HIsYGvQCqrtMaZtaqpiN62V1oJUwKkWHFfiEvIQxgGLqAnSoqua0Uol+tZ2ntFpNQsUCkY1mFSWRr907R/eI9Wcvb7qOCTKqQsa5ujCcMiBDNGzWk1wKiJ2A4y6Sa4WmnLHzT67bAmEBoUK0d21vVu4ddYyPgsVxMr1fOsU2bllUyrj7gA8zdhlSWH6Ulu6odWEw+pSCOP8TmtrwpPn840PTvJcZWLxt/d8dq4SPfAkedh39nEqvqwDfpkkR6QS2CyDB/7gQ/Qh00Y+0b8D6b9jP5yUt3zw3qeRBTw/K0uB260WRrep7DOcxIz3jtARpvrCx0aeareDEKFgHY27G56zwwgz4sdS4vRazGgMrXeght7m3yCuJQqtWINP0H4zFqh1/99IKrziPngdS6VfG7yCRusUgkgqn+jLsgSgcSMg6I+hpPkQa4YlL58mqJ8rcyIh5UdTtTkZAJeSYdfaVz1bEKiLHlzCaFeJRN/APl1xPiSNRXGQXN2EQnwizUg30+40YuOTNJQ0YQzFgk6+iU5rqoTjrKEXgRZqrME7GLaZKOzygMi7i+cjXJ/HpvZ7P53JFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(451199015)(5660300002)(66476007)(316002)(66556008)(66946007)(478600001)(4326008)(26005)(8676002)(41300700001)(2906002)(8936002)(6486002)(186003)(1076003)(2616005)(6506007)(6512007)(83380400001)(86362001)(36756003)(6666004)(38100700002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l7EfxrAp8/Zt+urdmhIIVL7GCTP5Mbh6Prh/iFUB0iXQs2nVpnMKSCLKLuF8?=
 =?us-ascii?Q?lY1IU9oJXpXMvej0gNoroTYQciUoLNjZo8oKSCbMMuP1LmAtjfHwOsZOw/OX?=
 =?us-ascii?Q?L2TCCETjrZ+wNa+5B2xLiTKaTlURiK2nTAvl8k3PTzEI6bZDWtV3IoGU2/h0?=
 =?us-ascii?Q?rIpTgsAILP50Hrhn0mQx8eiSt+VchqZyyR29MCJerCe6AyRyuBXkjdQdpyx9?=
 =?us-ascii?Q?aDAAqBaSn70hTEvSUcGrp4tneBi5HOG8MR5VxYSlVlp2u/gkUKi01TaDJkJa?=
 =?us-ascii?Q?wO4KShACUioo6AlRd+YfWSfw58pQlIaqo8oBzc48on1xUpD9MXuTnxy3EYkx?=
 =?us-ascii?Q?z6gu8nwFM/U74ErraXHKIIWHhMrLLJFtmEwdLwMhX//9NURz5AYiRAu9reoH?=
 =?us-ascii?Q?/jFNg6yaPMpxHCgGN/tm024kTxfR1IaT02TYeCPM76aDMo203dk12oVEHk9p?=
 =?us-ascii?Q?r3qLywjMAPQEMiJpLSrKLQVS7cmIpf+d3AwzOcBnJAit9mwqA3lPuyfMpJmu?=
 =?us-ascii?Q?1uxMnpqqLRGITGwNdOXcFdi1GyDCHC7nSO9Qdv49bHRyhpy4hXyBqgXqaQfp?=
 =?us-ascii?Q?y0o4vK4U/zgAelQY+ibAoB36xBGA3uXoGRRfr4vaBCgklMCF6mBLgRnH36sJ?=
 =?us-ascii?Q?58+LXLTLnbXQqLT1YYOiEwBSB4dkDS/G4XUVxTXdei7bs5nBwUAJGCUA8//I?=
 =?us-ascii?Q?5VjHi0Uu1I0vyzPMfjwV80pRar07AGnDK8OuLJYvoJpB1KVVKi+kOPvH6kL0?=
 =?us-ascii?Q?hDlUTAMNFbNdHtSYi9WWa2PdJqk8HCXqkSAPd3JnWcIIwoCvg7yAUv8DynQp?=
 =?us-ascii?Q?BQZybqjSYePYguBojYftUH1koirSv70Zm8V6Zeg6DWkuhdPUAGli6eg+bRTR?=
 =?us-ascii?Q?/d68r7mPvSSQufhMSJUfgI0YZBWMuIivQQoTj4p5Bo28pDPvIaLrIErcK5F2?=
 =?us-ascii?Q?h18t8YkWlZPtKEjypvLK1EgQC5YVxVJdl4vjS2mhzXoeGNyhtvz7cPcgoSdM?=
 =?us-ascii?Q?w2rwSZhj5uDsyAJd6wZRy3XQUsxpOB1a0OAUJAJGilQ6kQkFxs6hmyW7lv1E?=
 =?us-ascii?Q?oknJ742LzZ1BrP5ZEyhSoDXpEBeOuiU+zs7rUBZWqSxYYvfEaXlHlMCLHJW5?=
 =?us-ascii?Q?XENelUAdKr/I2wDETQP3N8bW0wEloTl1CtzF417vzu9GwM2CVk9lgyiHvs3m?=
 =?us-ascii?Q?W9O0Doa11aTqdI1A+b89YUCf3b/PAc7KQTPrSmh4nrGwNfWfly3K8mrg8O/C?=
 =?us-ascii?Q?HR+I5DZokd2rGk2Aa2jSf++SX5/spxYSgFRTEq+BQ1J/r69d9WbqEJwbHeRo?=
 =?us-ascii?Q?0GQs1kbnsCbSMffDAB2PR8/gAWHr0jnNqjIUv31KL/EpqgSLeBAdph2J6243?=
 =?us-ascii?Q?Sy1AobEi9tAw/PDFvN5+BDBfsMz3yFwcoeUi9TCVkyfVL6m0TwnUcs9UZfJO?=
 =?us-ascii?Q?HCy7O5abHp0Lk3d0OYrsc0ZPkI/8dAg7R4k5KNqJ7BucHz/dBNO8WkA144u8?=
 =?us-ascii?Q?i1sy495/suIxK/qiNIWonGkbogxs9mLzaNMmO4dN70zdxSAA7jHTvtju9ehD?=
 =?us-ascii?Q?mt3CJdj/i7n1E5dv4EwDkLgSkuJ/8Em5rQVdO4l/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec3d0d42-df18-485e-43b0-08dab101317b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 12:06:31.0373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YI2u0LKokU0LNl4Kao3K03v2hxQmKhjo/nXKLMIJg81IKvfM7SLMS4AGNHi/Ulm1pPMv/vogpXALluokHE+hfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5140
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subsequent patches will add memory allocations in br_mdb_config_init()
as the MDB configuration structure will include a linked list of source
entries. This memory will need to be freed regardless if br_mdb_add()
succeeded or failed.

As a preparation for this change, add a centralized error path where the
memory will be freed.

Note that br_mdb_del() already has one error path and therefore does not
require any changes.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 26740df62fd6..157ba4e765c1 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -1053,28 +1053,29 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err)
 		return err;
 
+	err = -EINVAL;
 	/* host join errors which can happen before creating the group */
 	if (!cfg.p && !br_group_is_l2(&cfg.group)) {
 		/* don't allow any flags for host-joined IP groups */
 		if (cfg.entry->state) {
 			NL_SET_ERR_MSG_MOD(extack, "Flags are not allowed for host groups");
-			return -EINVAL;
+			goto out;
 		}
 		if (!br_multicast_is_star_g(&cfg.group)) {
 			NL_SET_ERR_MSG_MOD(extack, "Groups with sources cannot be manually host joined");
-			return -EINVAL;
+			goto out;
 		}
 	}
 
 	if (br_group_is_l2(&cfg.group) && cfg.entry->state != MDB_PERMANENT) {
 		NL_SET_ERR_MSG_MOD(extack, "Only permanent L2 entries allowed");
-		return -EINVAL;
+		goto out;
 	}
 
 	if (cfg.p) {
 		if (cfg.p->state == BR_STATE_DISABLED && cfg.entry->state != MDB_PERMANENT) {
 			NL_SET_ERR_MSG_MOD(extack, "Port is in disabled state and entry is not permanent");
-			return -EINVAL;
+			goto out;
 		}
 		vg = nbp_vlan_group(cfg.p);
 	} else {
@@ -1096,6 +1097,7 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 		err = __br_mdb_add(&cfg, extack);
 	}
 
+out:
 	return err;
 }
 
-- 
2.37.3

