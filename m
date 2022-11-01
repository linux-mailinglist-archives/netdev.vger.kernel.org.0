Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9B16151D4
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 19:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiKAS6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 14:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiKAS6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 14:58:40 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC681C933
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 11:58:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YnGSFyZYLc8mIJ15AEiOlfL0UDCwmssfGLq3epTY8iqBBepqkeG0eGjbw6MRUdZ3dVBmg0w0ZFCsaJYbbjouMXtAPhCM+JUjcwH6C5D6e+waHHmslzWqNygs1dtxdcjrFZZf+00PAngDpM0hQbtnx9n1B3vW7KF0McCR+9rQotDcpRY6g2UgE5C7X65TdlDcRSNsVUEu8wsmteyyAHEe8zcILuwifDYGZ1YV1EDHkEJogC200aFE1vESXQXKOSHGQ0Vl7hHIvB+NXwfRy5Ndgiz0zrai8e187ZdsFNRCl1IiWSo47GfkpRjcxExBqJpVeaxC0EkA8DmRem2MQTXLaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b+fpNdg86H63LzNAjDIC2UDssoWhJLvg0rPjknYqB1s=;
 b=aDdokb3G91RumsUnp7URvqXAsB5YwEDCJEpR71kl+eU/WwW6jzb7iS3jL+thNUencJAZsbxx0ajJHWoo6GPkSSkiBwYJ/jWhNzpuw6kpsBrChCbAicQGg8MjG3ax1HbLZK2Cd1d31NRoWYT5twVQsjDSjst/qc1AAWyQqOLB3fY5ccMkgttTZ82jslK3F7tlUrIsDJx+wYf7UWxp+RCAfQfJ9prxp4MILe5ZZNp6+Qd4JDY94HpVFKr12u9rU0W6gUYIrCdnXQ8BiTq/804+Qcj/nqylrJzrTOBMadfzTOxiH89A6C4ONvgfJo/DH66kxUSzUUY82iae/bhc35ZlQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+fpNdg86H63LzNAjDIC2UDssoWhJLvg0rPjknYqB1s=;
 b=NtRQzL3WnTBCI15XPjP44SyAoBw5o6GPrAfVqTqAyGuTNIe3qLe2IVIm+N8Vfy8BXtOjvB6lH7tQBYCqudrWy3L8IqG0XRNSZr7bg61Udp2/SLV9pTt20Jl2Sbp/ElgkCcCb0J4FONf4+lSIf+0KtGMPSJd1M1XvVFl8yrFMnEtfyhj6mTIGfAxl9D0DpxAvWIm3vofRrkHstv+PvVh88of+esiPhExFucgEqNzBa3Shvt8/0NhmuFFqRapjmscGc12NBSMhK4ER2OxGm6Z8j5tUHlJp7DTRbYfdJRZ7F1h+szAwtZsUGP14v8MvyrF1y61hvAdudReXFnxp5Sx6Pw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SA0PR12MB4480.namprd12.prod.outlook.com (2603:10b6:806:99::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Tue, 1 Nov
 2022 18:58:37 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5769.019; Tue, 1 Nov 2022
 18:58:37 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] bridge: Fix flushing of dynamic FDB entries
Date:   Tue,  1 Nov 2022 20:57:53 +0200
Message-Id: <20221101185753.2120691-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0014.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:800:d0::24) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SA0PR12MB4480:EE_
X-MS-Office365-Filtering-Correlation-Id: 89140d65-58f5-4165-e38f-08dabc3b1508
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BeIwaCcqQhl8X8J3Q5DuwKUqovY9GAOlvAZdQwVgKf0eaPTAFJbtw9cvbsn8KINuOMTbFtSCMRysnke0462obNJtvQCBrMr3GCUNICq9W3i24WwSYVpuDBRSjsINrJJ3mGO2FB7bTCMTr04sjZ6g0EYKeTU0PCYZn2Iufo/cfbsoHdt+R6/UIN75zirPY3ZXOG8ago7ZqAs0mBhgo9Q1tFAo+DpyLGcSIldgbea+NGGbUaurkXpJMHzeL6/GE5bBA8H/cg0nhk23Wykeq7UifF1YdotalObDA0Z9AHO7EgjOlALfRnrO1qRncZBDY+0semAxrXwF5oFiNFhKw9YQ4K3RlKzef4bq1v+/pM6Ez/anjTwC5SIde3oLz5D0zhWMUwbK1HGrP7xS07TwumE6MHZhvhwL49GieZ37l3MUjvfARZL4B55Wg75vFAxwczPeOEucYbNMBR1Ko1PWDaL8E/dPVzNEco1o35f4han4q+YeRX2yda9lT7nuxJ//fYqFnqYk3UsqHlAtWUnsHTUBtLeBXNhySyXyv5UDmsLn5miwOZ/5Q5ZLRaAzUXFYjqOkPKGR1sajgKR2uibFrZ07AKbdvtfDcL+fpvwT+yHeUq3RhXRfT8gOCqO+Ac6BZ8ZWSxqp2mwH8feu278PYztLFVMprs3GAGq+6p10Gy1SSEMDjEShZAKtD4Eo3ifyl+y18pg4W4srtw8w8/DYaR6BDutNW432qCnFYVB3n3kGtbqRI9iNBXtFldLpgb16fQW/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(39860400002)(366004)(346002)(451199015)(6486002)(107886003)(478600001)(66556008)(316002)(6666004)(86362001)(66946007)(6506007)(4326008)(8676002)(66476007)(26005)(2906002)(38100700002)(41300700001)(6512007)(1076003)(186003)(2616005)(83380400001)(36756003)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d5/+8eo2H3kXlpDtGXiIPPGMOrQbCsN77Md1uBzWltJ0OMLwirYpeMulutZF?=
 =?us-ascii?Q?QQ/3i8WveMdbOif3bEyaRkoFkPNpezE3GwlTEY4L3V+kaElzZbEym6e6we+R?=
 =?us-ascii?Q?uHrB1N/9FYPRvf1gkcFLK5MZMM5GIyy0ViUxy1mJV2H4XsZgUV4MAw6FIC9X?=
 =?us-ascii?Q?q+XZ2zT4Wp93bvnTuvjmahabyPB7sKuSkzLb+RTKnScSy2dDuJFJWQ6k1EM6?=
 =?us-ascii?Q?RTQ5We7P/jQOlSnGDvD+U1fbS43HqMSDWT5/uArDWkYVIDlYLZodskjB2MEu?=
 =?us-ascii?Q?3eG1S9rEVR1JaUAyaJ7ohOcRhMUMKHNCF5nNjZ6nrfYocMLFTZfdgo7P2BSg?=
 =?us-ascii?Q?8wo3ddVgpSiYEya7CA983a3sBxpkb3g/JIybXiZkZQW4b8++RhIjRQHpGCJ1?=
 =?us-ascii?Q?2Tevd98hs9jtqOw7RzS21+9gB/gfs/JXGpu/K9gtulr1qeaGAK5Vu4pQJFDb?=
 =?us-ascii?Q?SRsBsuhxLi8cCdX17QQiHzAj/krKAZdsoqyZMJKj+xBxZrwLGVAenQp6V8/E?=
 =?us-ascii?Q?TSpXBQyx9ZyiN6oBSNqrvkqi8+HbYV/C1UgxtofsyhxxMqxDkgeKmv7syTpw?=
 =?us-ascii?Q?K1INxPfjf4yrE2eG2jJJx4UAAOurvMsFW7ySO7Zz9CFrM8dWvM7RS0NTYYMC?=
 =?us-ascii?Q?kGu+sxB1Xtw3fj0nehR8XtWLs7qpr3kLfe2QIkQVrmMosUg9AGYgcy4WmIzI?=
 =?us-ascii?Q?+mGnglwwhOuBXuTc7Xihnsp0RDCpbimFSuGF22zbSg5Zu9xpZMw5z+A0i21L?=
 =?us-ascii?Q?WibVIQwbHA0zMNJBe5ukSRkb3r6PXkPbiX4MUmH6XQvF8IXaVmHXpzMwP/Sv?=
 =?us-ascii?Q?nZ9ACOop12xOMq5KIBVqsjZ6lx7OXlv0XFjQmM74vWd/s18EMghF8/kpBbi6?=
 =?us-ascii?Q?4yLKHf3dDKPd3b096J3eS4YpjsdDrIBDknuaAkCV3uVfAWaWerFbCJz0YGrR?=
 =?us-ascii?Q?YqcAlmKHKrfRj6a70+pEw/IdHrWqppf+9wLbNQv4fNgnATxSY9jvDnh/cMHS?=
 =?us-ascii?Q?7idoKWPJSWswZSesKoeTu95EqzBzbiT/ipmijJEZiVJF8p6m8Lp2HzGgDKyF?=
 =?us-ascii?Q?xQe+h4XYU/f18ESMMJ+REHcHAK36IsXAbRCnS7X5pkqOwRSI3bYMZN0RNX0W?=
 =?us-ascii?Q?18vS3ASCfzttfhifS/pMaKpxhOAl+g/Q8WJ7bnWaaDvo5Vr1zl/lKMz9NxhT?=
 =?us-ascii?Q?UX6/Igk2tEwOI5YDnC1woPsI4GzLTSpIP1blrCPHyF6d7oDlLHab3IfPBMTd?=
 =?us-ascii?Q?AHCgvFi3+l8W+sq/Gm5CwvhU5DRNHfg90olH6wg+l4mum1IYdou7JYxIPidB?=
 =?us-ascii?Q?z3L55cAg/ER9KmHrh2y3Fp9AHENWWSQyx7P2/Up7CrcLrZN6oc+Fgzqu9bUv?=
 =?us-ascii?Q?pR4m1XfGmhqcK/fIbjkKLFho0SO2idu0/T/ur9JEKbVDgXCMn4mHKaRnuLMG?=
 =?us-ascii?Q?OwXqvs94iFzrrOQzzbn4oCqWZxQqS8yarpuxECNL57DZwN/ylEMBMgwpztUA?=
 =?us-ascii?Q?NaSWQKWEDqRBL6ni1NRxNCzIbY9wg6UTj7tqZxt/cYGoaQxh3woRzyVFZF0/?=
 =?us-ascii?Q?aQHPH8Mooq2hIXBTczb8a/GRT8Ee7STRZizoAPve?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89140d65-58f5-4165-e38f-08dabc3b1508
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 18:58:36.9592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QRpVCMmrFtNMeaO/yuhn5+pQrgHY3pMaIfy9P0PYynjEDgj/8kFcj+GXr968LoYEmmGFt2pH7FebsIGGRdz7AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4480
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following commands should result in all the dynamic FDB entries
being flushed, but instead all the non-local (non-permanent) entries are
flushed:

 # bridge fdb add 00:aa:bb:cc:dd:ee dev dummy1 master static
 # bridge fdb add 00:11:22:33:44:55 dev dummy1 master dynamic
 # ip link set dev br0 type bridge fdb_flush
 # bridge fdb show brport dummy1
 00:00:00:00:00:01 master br0 permanent
 33:33:00:00:00:01 self permanent
 01:00:5e:00:00:01 self permanent

This is because br_fdb_flush() works with FDB flags and not the
corresponding enumerator values. Fix by passing the FDB flag instead.

After the fix:

 # bridge fdb add 00:aa:bb:cc:dd:ee dev dummy1 master static
 # bridge fdb add 00:11:22:33:44:55 dev dummy1 master dynamic
 # ip link set dev br0 type bridge fdb_flush
 # bridge fdb show brport dummy1
 00:aa:bb:cc:dd:ee master br0 static
 00:00:00:00:00:01 master br0 permanent
 33:33:00:00:00:01 self permanent
 01:00:5e:00:00:01 self permanent

Fixes: 1f78ee14eeac ("net: bridge: fdb: add support for fine-grained flushing")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_netlink.c  | 2 +-
 net/bridge/br_sysfs_br.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 5aeb3646e74c..d087fd4c784a 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1332,7 +1332,7 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 
 	if (data[IFLA_BR_FDB_FLUSH]) {
 		struct net_bridge_fdb_flush_desc desc = {
-			.flags_mask = BR_FDB_STATIC
+			.flags_mask = BIT(BR_FDB_STATIC)
 		};
 
 		br_fdb_flush(br, &desc);
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 612e367fff20..ea733542244c 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -345,7 +345,7 @@ static int set_flush(struct net_bridge *br, unsigned long val,
 		     struct netlink_ext_ack *extack)
 {
 	struct net_bridge_fdb_flush_desc desc = {
-		.flags_mask = BR_FDB_STATIC
+		.flags_mask = BIT(BR_FDB_STATIC)
 	};
 
 	br_fdb_flush(br, &desc);
-- 
2.37.3

