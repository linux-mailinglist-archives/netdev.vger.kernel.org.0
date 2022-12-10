Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D964648F48
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 15:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiLJO5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 09:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiLJO5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 09:57:41 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2078.outbound.protection.outlook.com [40.107.212.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E2C63A3
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 06:57:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dK7y02O43OufkCUEKn/spO4QaJ54OchlwvG2E3DHRM6GblRGO0gdS3aZvDFku3RIPXH/GOaCzRTGuhPZlelYQ6uizEQNCB3Nh1uoDOK+Is50LVjJ8dvXO+AP7JSEtoA5kp0ABX7gmX/t4JkPBc4sBqqRt0+WafRkVe6JeiFkFSKfyTx6VlcldvykWx6LO6H9JBjUbj/pd0ktVQTA8Z8XicJR6yMp5MsdWiw+LL6RynArVmTLf7GsixUUKaQLkSMgFfFA9UXCrF9IQ4vrj9CWLAw7lV1TadHjVhEEMd3EQc2+5t1UYjOnq029lDM5nOq3POlCua4ARmLiOrnuuvc/TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=guuAiKTMq1cHWylnX+TBumTs3dPvMOVIRHAI4ZB3SJE=;
 b=LEpvQfwg7QOK14v2qGMYxvSV4gjgykTr2zZRqiPVA5USdpY1IqWrgf11ty0h0pBnqkuiOSPIXBYhaseNG/Xm9I8QrRpJTppvt2Ajqtu5S/LoKIW9A5bmsErNZD6tbaum2NQflS79SKl9lcGgFmD2Pv21JULmaTTwJ0emQ1SNipmGCBHi6i4wntrIJgVRSwWooWKlqgdIQZJt/sR2b5Zu1si+5ahhRuK31YgXV0eo2IzRN2sevt9kbADG95pu73V4pDbKJX4KBY3awwnYAB8Azg6wuMjr/bmXX4VR4JZGv1zNs0Md/10y/9aIG87tcZfo+ShxEcBpUug5zNn+oYJZXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=guuAiKTMq1cHWylnX+TBumTs3dPvMOVIRHAI4ZB3SJE=;
 b=PQC1QCUoVqroTSCHF/lOvuWW6cLfcjVkC/rvoqW+x3mbnp8xbbq9vJ1xiYza0JSYR0wXX3pL1UZNrZ+mXLTyyFRZNEL1jtukkZaMXu1kc6eNHBSu+RFh4Vd4EgdO0QngsOttt07G2GIa4YvLkMb5cKeQwktNGLePIMVw4SplypGwOjSXoTtaK7DJgaORju310BFsG1Vmw/ygBSdg3cSDv9/ilqTiROm7uDh4ti0FQI36eubTa2pzWWvn/Z9gSppqaomyuBYL/jIjCm8AEbUeW0e/KLDqYHfqIeLOdBD2BAtDdslu7aTXiuyWtElNypwjnMHbWqYcH9WKLShaeGwOog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH0PR12MB8128.namprd12.prod.outlook.com (2603:10b6:510:294::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sat, 10 Dec
 2022 14:57:37 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 14:57:37 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 03/14] bridge: mcast: Place netlink policy before validation functions
Date:   Sat, 10 Dec 2022 16:56:22 +0200
Message-Id: <20221210145633.1328511-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221210145633.1328511-1-idosch@nvidia.com>
References: <20221210145633.1328511-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0037.eurprd05.prod.outlook.com
 (2603:10a6:800:60::23) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH0PR12MB8128:EE_
X-MS-Office365-Filtering-Correlation-Id: 00dced73-d650-4e11-21d8-08dadabee0cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: as1NIEoD/yAtFa9tggEunRWky+l9FsvZM7c0fylPpWGCZ/fhvj6qd1LcaFIF/hftUW2fvDpfkucJruHe/wqgu6iEnX15MvTfZ5nInVMiuFXy7Kp2tzOH/PWGgKDHIdTQi2/quSBPzOlW6qL93sGjaIeq2v1z9vDXCzJKMSSb3cB6a+lpCq4tvrB1d13b9GN5qb+z4zkr69FXoqe9Td6FbUKY1KvnEENny01lVQ08twhzh9MW4uxTnwu8lETi9Ff4/EUDx0tc6rsTVF9iVe2q04YLqw15PVt4NU0oDjJK/RqVdh3wgRioTONEyZv+Zw2afJdFpArP1NWjVOwMZWzqBh7Yg5OFZu9wv7hn0AN4Hp5dH0peJNnTW2Kthkvo8r8fqA2Xl0Bu+OgZ8vFdaD+Bdt0RrNBnykgs9ioEwz2MkS6wieIWq1RvUgwK51Yq5DfW/OYR2w04Bye5aKlxSUXijDp9neTF7bhO4+Sj7I0sEHtugclwS86bCULAAsh33C0nLko6adfaXsLX6ZECpcLug8DqEYsUKht4PaPmckxEPVuvLBK5twSnF/yLIX/Wm4al2vcsIMppZV0/s3y8h9T7Xdwa4jWG1kZrQEzyZwFDofkQB9BkJHkI63hxaCmNaRR99TrCbIZD/K4z8CzrbSpsJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(451199015)(6512007)(186003)(26005)(478600001)(2616005)(1076003)(6486002)(6506007)(107886003)(6666004)(38100700002)(83380400001)(66946007)(66556008)(66476007)(8676002)(4326008)(41300700001)(316002)(2906002)(5660300002)(8936002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oDb+v5daQkPQU105+oNiXZia6oTNBhaJT6L7eQERY4rnboau4EAhku+gD5r2?=
 =?us-ascii?Q?0YHLV7+dhM9C14cl39EEyd79qKQnMRnpPx5/H4ISI7zGLwFwSkFzP6XcwQ0n?=
 =?us-ascii?Q?MGvZSXsTmeKwJy01Ot2FOJnDeTsQBoliM4EJSrFjRucpBH7ubSiFOqWb/lTc?=
 =?us-ascii?Q?gTgTGgWllGJedEALg0pUvcq3/qjk2/1rAfMC/QHoIwpkuQK8rZnxtCS4D2IK?=
 =?us-ascii?Q?/ucM2mZGxm2JAmASCHft7bwGC98mYumK7wutNJbz+pOgPn9bsaQt8WvQPD+a?=
 =?us-ascii?Q?3WLeFJB0toz4McHd7eJRYXlFtu8Ote37OjzLR1hpB6BOGvDWYDiW0TlJ5WZK?=
 =?us-ascii?Q?Cp4W+gvLCtnGESQSLVRHjS9Go8TtnriQzAWb7mjk9nf5ppV8eYvF5ZuFlquP?=
 =?us-ascii?Q?Eih1qts3pYWgDWvR+Z6wzhrZPr32nPlPAGd0v3wuVuUUoyvwdHP3UTsOyCsU?=
 =?us-ascii?Q?I4usIKqgiqRP95TE6r7wV//q21fyS5pG0i7al16Lm6l4WhAbTGVRIXeRkxKF?=
 =?us-ascii?Q?J7U1Gmjm+LxL3XCHJoAsnVvRskjQjsQy+JnAcJs56MYeVQ47IIukEgOTWXLY?=
 =?us-ascii?Q?umXnqrmXG+BvBjWB2OQRjXkgoHUZZCxdK6bM5lWtqCz8OjdQBBhSFFBnZ+RT?=
 =?us-ascii?Q?XMuElsEZ5vz0Jcoje6IymTndpZRdoKKaPuyNHm7KpoR3DjgI9V13dRw2H5x6?=
 =?us-ascii?Q?j4YqfDIKkcnC2SmcBlqKTf1DIEuS8vTvSg6nPiBdma/Kn2T9oB4XtP0veR+J?=
 =?us-ascii?Q?IG+ycgv2Y/k9J17SOp9mvTHaYNnTha9kiTrAolF9Y3OAAg5zijCOI87gHicq?=
 =?us-ascii?Q?6953qR1+zDx1LEdLuOaG356JBysvMFCKQt7UeZMnEaG7YPyOOrPaGTCheaME?=
 =?us-ascii?Q?ypcgmFp3+9+5oMnAZQsZUMQSIlLReh9DMd/Wl3KOKwQxOxpdKdur6p3E7kHr?=
 =?us-ascii?Q?FgO5LApUgZDxeRcqP7fxO2wRLS/q65E2m5Wj+Ie5c91SA5OrsDfyfJzitFg/?=
 =?us-ascii?Q?bpHWDtzaS+o0scTFsqHUq8DEyt7cbR5hj5m4P9Dm5A464MdtBtibsPNmzoge?=
 =?us-ascii?Q?kP/h6nUzY7FyJsrf+Uqa3BmlocbrhqJQNTjOWYOSogO2dXMun9nZbpvP7bM0?=
 =?us-ascii?Q?h2Nr4THDfbUovOG1P8tpFWqApoSgyOkuxm7UvGKmOk0qqQNG398BasPwFCVx?=
 =?us-ascii?Q?S/aiSsFZBI66rKwZuIuGZp8zQ+wAXyoqSbCSQTWlYZT3fmBU/LnyfOFfApPj?=
 =?us-ascii?Q?5oSgIQpvl78+Fu7M9rDu4l/fD2c09iRmlgVmgTyoDAwjse1bxpUfL0cQKEqQ?=
 =?us-ascii?Q?LI11OxwmDHqlCyZuFubE0nrYwIHnztphLOmKWm0vDkRKSB4E9l/BPu88rDAy?=
 =?us-ascii?Q?s0+Yg+tSGnKoJWC7ctMBlxERupm8J0E2Py79nR1iIbFkK7wknVTjiTxwMiEu?=
 =?us-ascii?Q?363MU6ZuqiHgT/Sf5uyJLgXqAxJcEGmv1kAWb4kWNEeqd/OpHmdAeOav0GQs?=
 =?us-ascii?Q?+f+L2MbMmm2YqvpK2dZYybFakRdrKRx+YwVO/LGAvr8PYs4qJtVGywz/XmyY?=
 =?us-ascii?Q?tAqhh7L8wNYmp2t8WWlBvCxZ/E9qHpX1g4E9Q/Hc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00dced73-d650-4e11-21d8-08dadabee0cf
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 14:57:37.7752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ReVCGvGeINe0TffPLfahIVXK0da1FyXq62/beROcAp1drpZuwUUAyyBAH4lUjlbi6hW1gfzImlGAphtWD/FaNA==
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

Subsequent patches are going to add additional validation functions and
netlink policies. Some of these functions will need to perform parsing
using nla_parse_nested() and the new policies.

In order to keep all the policies next to each other, move the current
policy to before the validation functions.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 net/bridge/br_mdb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index e3bd2122d559..fcdd464cf997 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -663,6 +663,12 @@ void br_rtr_notify(struct net_device *dev, struct net_bridge_mcast_port *pmctx,
 	rtnl_set_sk_err(net, RTNLGRP_MDB, err);
 }
 
+static const struct nla_policy br_mdbe_attrs_pol[MDBE_ATTR_MAX + 1] = {
+	[MDBE_ATTR_SOURCE] = NLA_POLICY_RANGE(NLA_BINARY,
+					      sizeof(struct in_addr),
+					      sizeof(struct in6_addr)),
+};
+
 static bool is_valid_mdb_entry(struct br_mdb_entry *entry,
 			       struct netlink_ext_ack *extack)
 {
@@ -748,12 +754,6 @@ static bool is_valid_mdb_source(struct nlattr *attr, __be16 proto,
 	return true;
 }
 
-static const struct nla_policy br_mdbe_attrs_pol[MDBE_ATTR_MAX + 1] = {
-	[MDBE_ATTR_SOURCE] = NLA_POLICY_RANGE(NLA_BINARY,
-					      sizeof(struct in_addr),
-					      sizeof(struct in6_addr)),
-};
-
 static struct net_bridge_mcast *
 __br_mdb_choose_context(struct net_bridge *br,
 			const struct br_mdb_entry *entry,
-- 
2.37.3

