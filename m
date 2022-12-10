Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0148F648F4A
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 15:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiLJO5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 09:57:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiLJO5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 09:57:48 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CCA6178
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 06:57:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gCSBRt3MyRng0ooEvRlloWVNtJ7i+FvT2/Gsy1vESia1JGNHbr/Amba+4dwz+fOKUFpIsZeIbfYXUUjcz9W2EVq3ale/lDwZ9hLTGfD+v4alahp+sduBkneEuyu4Ax2OtOdDfYNBI5nTzkvyUXVa6rJ/jtIRcrgc7O+yKXooNYExHW4lNAaWjF+TlvQK5XNeHqgD7bUhTZXiquf83MlX0JxzAL7AU2xZSkMqHGQxIQBuZ1JAQMMTZUQFJGfcBItyKNXqNjlVk82UkvDq0IKtf0G5C4aU5LcZX1RnAOTXAsrN3sapx6p+arY4oj8ycA9P7T9VLBs6wzEQ6oyf//4cuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xY24savDE2tVnazL+AV43iwdxH6QPiA3//wQh4CZfWQ=;
 b=N9KocA2ZxBloDcUuV/iP+2WpRt/e9okAIlYGPmtgs4saWGlGJ3PVjeisak2VKWHtxkAW5kTXsS0W/O720AeLs9lH10xVBi0XtMbhVxwY1GblwPL7rsmMm8+M+A8GU+SPp+CPkkDsDU8xIHjwrrRo7A2O6mLlP+4veo5phr0wtpdcIiRRFXmBtxrgZEU1eecYJ91nhJqvGGQ7m4ZS9M16UKdRsWRfVbYI4kfWnCiacXQoHxINlw9ov8Z11KwEC/A9cJEOxoBgFWPp+i7knGaaCQYKPZY2hfK5DbNrcABIh5SgPxtPT3+MpDQA0Cy9aa9PggDNvH+CzPxlxiTrYCb8SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xY24savDE2tVnazL+AV43iwdxH6QPiA3//wQh4CZfWQ=;
 b=mAmG0zlj0y06MbOwfs5sOWAi071Rk6pBLnQnGXVtVx+oRrxS3qmyTQ7H/i8BxZ0bbe+azlS6cUB90z6an+UfjCDSZuWlCZD4MRPudMdHGwzebZsv78E6tCJNvHwgO0vcZAjmrxZgmntlcX8li58EeEnr/r6QIfjGDwXPuchdaXTU8dBONvgRpwXe79lThJIhGHIYyorHeGocAqbhBQ7hcGTEASVSEsJetjVC0opF3OntcI9UQQraBPCh1r0kBwLcryLKOVlgkwTlwMrwnTOkaOqBjtca7JIxrjKQ8KF7D0Mjoqq30MXcId5aaXcG1ivKB302lhl24sdP7c3LckgPkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH0PR12MB8128.namprd12.prod.outlook.com (2603:10b6:510:294::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sat, 10 Dec
 2022 14:57:44 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 14:57:44 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 04/14] bridge: mcast: Add a centralized error path
Date:   Sat, 10 Dec 2022 16:56:23 +0200
Message-Id: <20221210145633.1328511-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221210145633.1328511-1-idosch@nvidia.com>
References: <20221210145633.1328511-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0258.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::31) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH0PR12MB8128:EE_
X-MS-Office365-Filtering-Correlation-Id: dbc92cd5-0dee-4124-e2b3-08dadabee4a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lz2olgnjkLacH++av71Ql8baXPYgANEnwxXoQsiOOASnkjNeQEKTiGY8X3xGZe4UCCJ0DcAudSmTMJ0QcmLm5LkE6eUF+LexIyF1hbXp1CTU3NhK70WyQA8X+Augh0rSixX/DoE/JF4I36UjirOL7X58yxsIeX6wZpGzl9LIjHa6pIcvwlE9peO/frNpEqShjNx4eiPemr7LiyrNdYZV5zgLnDBAM12E3njxWfw54hwARIQqVuaYwx6l+9O4SfWWb6y9m9WJRKAmtBHEMRDHJfzFPc4ORPaX3KlgyL1oyn/nB8HYc3dSPX25GDTGm/a6EFsoEBqnaSREGqbPtdTt70uglCm0f9dnZtuf6dKR5SKTaQiO2g0b2RbO1NmijV+xwajDJsscqOZYv1eoZ5k7szu5diIsSt56fo0BNDwwKxem7EfTbBaLGc3/spQyYfB3+zZEVy1Ch2StpdxaWOZdAFs/YDlJUdb2ZP6d9SNKxetb9X6vU8J7d0lku+6BmMAk14wp0JTpoWBahg67qJK5CXeOI2kTxji+0H8I/PW+SucA2dCjqVVlAMxmHdfdogiACiDLsH1+2+z3qrwsF6rN+/tzxvnCeOxU5NTkmP14FJ2Bo8BFFY6Y8Ih4sYWLMdeaIq5NPSH8tivX2xPT44HO7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(451199015)(6512007)(186003)(26005)(478600001)(2616005)(1076003)(6486002)(6506007)(107886003)(6666004)(38100700002)(83380400001)(66946007)(66556008)(66476007)(8676002)(4326008)(41300700001)(316002)(2906002)(5660300002)(8936002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IUBtov83EzEI3OF9Jq7KcjzE/g1cJ/1HOMKkHsSmTADzrShMLek6IAMlxpUU?=
 =?us-ascii?Q?vHTNeVrHwl84buDktiMRPvg+x185SDNIjrmRESAYuIezmX0/AjvW8lJByGXE?=
 =?us-ascii?Q?Z5FHqpzMuiINcPG717LSRMwQcdVGmW6XzwFwC99b1fDk4Y10oX6MKXji0UE9?=
 =?us-ascii?Q?tJe3d9tX1BcGyy1wmDEyZb5OZ+FOO6ZO6yeQP0F+sqaLcgJfZ0qrf/JpHNnW?=
 =?us-ascii?Q?tVGk97o5almcUP9fiT+RaI0Mtdoqe9WcKwL7lXZaqbCKAgpfh2XACJTsc0Wi?=
 =?us-ascii?Q?sbTaxTQ1UFLZHuGbi8Jukjo68ceXX3sxL8fl1DQbYLzQyK38PUx3ZUTmYVGY?=
 =?us-ascii?Q?NAOeC1vPdhuT0BQnaA38CMx8qJKaru3EEwxZE2SfokTyl5etekJHu4CDTVz2?=
 =?us-ascii?Q?RobqrzW1+Z/1kxh4NpecpLXve5bII10loDJ31pJdvIXhPFApNsaiXH3SkHjH?=
 =?us-ascii?Q?8UEOGpru0QWz5lxibpq/YjIoqBvtQpIw1kP2T73X81TTfec2DzukrBxRUA6t?=
 =?us-ascii?Q?O/Y52uoGLdW+j5Jfcn53RUEIw9E+rcggVBEudDvuC/K0v6tf8eZpfS6AvIqI?=
 =?us-ascii?Q?af2ZRniNoMD5zmcNrpkE3nGqQ61z8oJqxCqX+IHnul5J4+xz6F94/JNztUpY?=
 =?us-ascii?Q?u957AdE3OqNahVdLExSXV3ZrQrEE/9XLxOeZqJJAJxdRm2BGztwsJQR684GX?=
 =?us-ascii?Q?LpBfa48Z/+lCZY1vIKhDq51f517VzhrrIs0AubjHnTGgNCL+U1YjqdKHQTeF?=
 =?us-ascii?Q?2Et3kSX3ET9nQmIIKGT/4jBCYFxsyRvsnQ4J3u3Pw9iGN8QgR02/WQdwVS9X?=
 =?us-ascii?Q?lq/7P0Tg0StBIxPi5OST04ZBv4lAk325gqfPwxUKR26bG21G5z6DQzUu5eav?=
 =?us-ascii?Q?VVsCq8mN9fztAdO/eZUrAUtmvhcnAQnB/t4A8adLATj0Zep+nVH67OWrLeBF?=
 =?us-ascii?Q?6hJ1qy6+BN4o6BgTNYJMjCSUDqyGqepXfIpraf7t4c+QE+oFqGxji91BDPWW?=
 =?us-ascii?Q?CPryqlPtl3tUIcV98MYpMKbgM4tSc5dUg/lm9urPUFd9NyzaiOr1U7H0P34M?=
 =?us-ascii?Q?rkwlS55v+56CbYZq4IfmNiapRal+aZFafBrVZXe02dG0MX6pVFePBVAMogCZ?=
 =?us-ascii?Q?gLB0Bfy7K7IMZYCHTwl7TllO0jOOYIWvR/pFm/t2UNCUHKtbSe/4+BXZPMIw?=
 =?us-ascii?Q?Cc7yOasFfuKpOE3FQYIUm9ZDOP9GiYWdHq7TXA5NYv7uiRbaBy4Nvgn1RNvK?=
 =?us-ascii?Q?tv6FZOTwZkTxJuRCtpJ13s/MBaaDLuj2QIRDNANmMUyh2uQbk4AIV9ivppIX?=
 =?us-ascii?Q?Z4i2485iaQoHnNWBgIuo/EPjR+cDqXYRgwGQUwenGH4o4IsH4oFzz6uOn4BK?=
 =?us-ascii?Q?PuZ7u0mOolB1K70S21qL8g+vRK85GWK+VRN5FzqrFQECa77/91+7ayi9Rm1U?=
 =?us-ascii?Q?XEF3asbpbf6bhv2S8EnJHGWo3j4Sa0sF9Spjfy96tU3powCSLRCtcl4xJLaA?=
 =?us-ascii?Q?u1WwHJ9qDKU4unJTIACoCi3cacGAX7vQbyg8YGbM3+si2ee7AIXeXqYcfu30?=
 =?us-ascii?Q?TY8j0jHO71SkqHU9Sqkd3hK8D3CcvvUIX6pZbu/d?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc92cd5-0dee-4124-e2b3-08dadabee4a7
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 14:57:44.2133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5AmBpA+nI33hrQpi309a0vYUEIlxj/R/Ew65Jrg+2JBLRDKTd6ZFiBVutmiozznXhAL8iQNyjXnkZGZnRdMZag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8128
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 net/bridge/br_mdb.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index fcdd464cf997..95780652cdbf 100644
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

