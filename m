Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30E6519764
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344952AbiEDGeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344975AbiEDGeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:34:00 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A9D1B6
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:30:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0Mioq9k/JQTJzfGO4QMAzjzilXfKt7qYQrMt/7nMlawW75eW8NaxA0mMs6RgtXMDRARtpEHZJybNS1L0l6w5Px9nSYy0bU/iZ+dyufpmXsVV4In1nMy0NnMah/RYIK8r0v1/xohjc2R/RRymDBIXyX5YLQYEh0Ex12Vm4tZbN+5KQWYO9GE5mEfr4SwALAXv/w/5clOEAW1Wt2ID7SLmJAUlzUbXobqFHeHoUelcugo0Ab4TCfWU0dzVabi78RQNTdEmCRHg45kpJs2bKqthyUSrxGACKsjuQ6M1tT0uD7eqgE5HgJxFE2kXAX00XDHJcxhBs9Ii3kgpq0RWwc82A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P4EfA2shM+taHdmEI9uUaMttLdvF571vdJnuEF4zuog=;
 b=eQZcChXgRKMXIXTLQ9ur+I/BPJkeijwtFmPMlsvijOxY6kPpHXn/obejt/hAPcTttjuuTvfmfziCEeC6ThaBfptjYqVYxjb5X699U0shBp1n/dQ/7da6dzk3wkzkqhK2piiSFUHBx0tWnEwHxPoE2fEqUychDiMFuzxPURJyj5pj8MvRTvVaRRgo6iXJPWaWswuwKeg4FUgAMPri7oMuTiWlAmE9pR4C3sO0N97yvBu0u1ClvUIm6jtUoniPmGvA+hreROaE2sFU14p/XgVa+s74LEBPbXg86P1fW0uuyzdvlqMS5DPIqZa1DkHkZIzJxT4S2F8DkE6EcTb30xn6DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4EfA2shM+taHdmEI9uUaMttLdvF571vdJnuEF4zuog=;
 b=JufxKsE0UlA4Ei039N42454RPfqrTvMHfLTiSYhzAgfYfQ0Il4NM8lGcBlGv38u9Mab1FFDLmYItBH1JjMbvLlcOHrBNSjXBsFBKz9fuw5tKL0V5/GMkzJJZcooCcpNOk8dZ5r3t2es3NfTyzupkIJ0RBrCMDx2pwIJnUyO3LAbLWl1sxY38XtqCP6duE8gIBWy1kKHCPnRESaolWPJRQbKcw0wcK9ifrJDT/oq2ONws1rJHos6QCfD46Q3CCvpFtZ72VQj+B8AjR5bIKmgnk64ebLjXHNOm7+Fjrg/ktH0t7flq28oC7/z3WWeOpm2LI/ddE/U/kYgcxJUofLLRoQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM6PR12MB4745.namprd12.prod.outlook.com (2603:10b6:5:7b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 4 May
 2022 06:30:22 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:30:22 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/8] mlxsw: spectrum_acl: Do not report activity for multicast routes
Date:   Wed,  4 May 2022 09:29:07 +0300
Message-Id: <20220504062909.536194-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504062909.536194-1-idosch@nvidia.com>
References: <20220504062909.536194-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0054.eurprd04.prod.outlook.com
 (2603:10a6:802:2::25) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bee2ae7-42d9-4445-67a8-08da2d979130
X-MS-TrafficTypeDiagnostic: DM6PR12MB4745:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB47457F7813CE2C7DD1A0D433B2C39@DM6PR12MB4745.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M3LQetH/c6UKac/ybibNhg7kOzZO1xPZ8+Hn1LVNabQYzI9Ia+GiMQb+yny4d6uWdzwixjvNQXuvUmCQVBJCbm/gWuSh2n6Ss9a2L0bqfzoujJHtMqddBn2nE7t6ExvDJDN4ccuo1OgWKI7GroPjZCocqvxYqJYLucIJj/b646TD41GYvIdNlxTR/E/Ra9gnRlvC7Gjn1tTcFDB4vU1lh3hlvWssH+GYiyJe1aOjeyzGjTSZ0GP+gMbImjiUSXDbjZCw092K+HItcLzxyEsslBBTXgz6Bc8Jp7tU4Lb1LsDBZZM4ntOdoI7TLDE8FWV2y9+0TlyuHU7bmneKu2VaQ6Bn+Y5xfxMjOZaqw8EeD79+CbFJ/rOv2Jt/xtj9g5vd+55B7ZjxzVvc9z30wyxDXObC95WZuEjNylpxHwnHkUdOQ9GNtkegEw/gev+4sRsCTaE+/jLKdgicOcAwNjuKkut1s8XzOUXldcyBmNuJh1AztDycyX9d+qeUAPazVX8+meXHq5eYhJDPFmo68i92bLvP73fAw6TClG0g2IBa7W2x2mD1KstXuABFEucwKbgO+jxn/DNMe38EeIScYb+qsNu4qUiciSSlgTPjEC/1jYbIaVT7gdwkFhohX/UEkyw8ecNOHBwvYmnks3lwOKe1gQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(6486002)(316002)(66556008)(8676002)(66476007)(4326008)(5660300002)(6506007)(6916009)(508600001)(86362001)(36756003)(38100700002)(1076003)(186003)(6666004)(26005)(6512007)(8936002)(107886003)(2616005)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H2laC/copm2oKyTW6me56w0U2xa2okBA4QJ2UAqdcULxAeXJiwfbq/OY0rlE?=
 =?us-ascii?Q?sDdbFWZPxsWRdPFFWr24SJo9QIz/XPuZF0BM+r6R1UmrGuGaXld9uTZjFSuw?=
 =?us-ascii?Q?tJU6KUfBBPtwkxGPmJWHpr8bbkJSSLEHXjREYS5bVpbmmkrrCCQZHleUCL5T?=
 =?us-ascii?Q?5Pv+LlR2jAEvgkPYZ0wthQ/L4F4+QqNMYvuCEueq03VUCLvkiwrR92UzRAKB?=
 =?us-ascii?Q?FyFvK4D5elYWQSi0jOOlGSPP1AahqO0Y9dFNKinSOjUx3EIfcxCjecSPAxG5?=
 =?us-ascii?Q?qK8WjX0zIya0EdR0JhTHKWJUcHlRalhz6ioPJ7BtDCAZhG7TSaAShg6vmuG5?=
 =?us-ascii?Q?HgbxWQ394NE8M1nPUX8YgB/0om5TcSLSEXu45bn8pbENHRuKCu6nvWNaD/nC?=
 =?us-ascii?Q?esQItK/nAlA9dvGpsL262ubZ2GEvsp4aPROaNvZl51jMrDF/GwAx5HIr8Bws?=
 =?us-ascii?Q?zQ5CeTKrcsgGspgDoq8sur27GddxncSliwd0e5HfUPBkRX8WBw1XNs5haT1C?=
 =?us-ascii?Q?fMPMiVn4sfE00Az/9iU8osSCJhweIJGQGTPtDwC9bwTzr7D3ZoqlqlDDZSpJ?=
 =?us-ascii?Q?fCRsqBB8SAvswy4Whv2q8DbPnw8jy72+cR7o9o365zKhN7f9YNX3k2FrMxtt?=
 =?us-ascii?Q?ZhufeVu84iY4sZJwBj8Mf7YZ9kUtrYhBR8XC4H0DzC22jHbGYGOx7XD7FfDc?=
 =?us-ascii?Q?tSCmHv/m4ls7B2Y2m4S78INSSsRqY+gv80VKjcDV1n6jxmi5eSyO+S31Hrkn?=
 =?us-ascii?Q?wd/V8B8M7o3JuZ/3+6FK5AMuL9g47XpHCI2L6AgJmCT2yVEzO0Gc0iXiPXNy?=
 =?us-ascii?Q?Sbv+ZD8KM4WoJe7UJo7lxYjWG93Cj+mO5tVP1GHZTqezOvDN4dqMEl3cBdDO?=
 =?us-ascii?Q?Qle2VOfyK0/RjMhFQB7hdrpk82ioSrQVjOcwAEUmxLrUeeeUYn6Gi+sBRATV?=
 =?us-ascii?Q?ItQHNBVDWJMVGbBcAO56cBllD/styeBY1D8py2ujIdJKJV1hnBYUwJyTgpif?=
 =?us-ascii?Q?+3h1buyw/5ZHAihuzpGM9tls0KvXJWYb2lB9Yt9kMUK9DsoPLC01opZ7cbMz?=
 =?us-ascii?Q?FiPpI8iMuNL+e8shcSar0IozxeBKp/bxG4kXpRmkosBCqMLT3zz2itEhn5Nf?=
 =?us-ascii?Q?Q7MuhJNglu53XUn8qT6L1rXixjr9OMjxL+cY6k35LNNIRGFLYJQfk0sp62oS?=
 =?us-ascii?Q?JMbscKxPFx0yoApaAmf5H9PUELIzZlUJEDWvKhkDBhCcnRSsYqKJNr31AGDT?=
 =?us-ascii?Q?AfpS4spGqVYh8ysFu/ahlL+2BQPeAq5bJnKyPmVR/k6S4Xfw0xtD3Xe7RzSW?=
 =?us-ascii?Q?vjYSK0qKOsStmtUn1lb+y4ntZ0BleXBXOBd3G5ttB0iAD2d2Viu/DUBumrOK?=
 =?us-ascii?Q?nBb4qCTGrBPfPpPwfJrCDBghHSunD+Wq9XFcRN4C6HsKn3JLG7E9UtplPpYT?=
 =?us-ascii?Q?Myvj8D1AA5x97KcO7coxX71XNDUFY4TydlTBiPWMmmQ8O6aLpvWOrctioDTt?=
 =?us-ascii?Q?97LPtVC7gSh8Fsueg2S2y4r7r/BwPsBvJtUMUC7R0ruAgMIh7TyVEezP4uc9?=
 =?us-ascii?Q?PxgevXr/I8UKd+z4TGbNdYebdvuaf3rnSGNFEdv/5O4pVO+LYBstxq/BtzOg?=
 =?us-ascii?Q?ngDlkvZ/k2n7zkMbIXq0XrqbhylBM1T6hZcy5pU1+i+hz0/+HNCD1+7+zRR7?=
 =?us-ascii?Q?MjwFyrCzmTxNuHJJ+QId9le2pOcQnfR0ZvhcUndiLN+eWvfxI5Hfig+L440K?=
 =?us-ascii?Q?pNPjzHUIAw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bee2ae7-42d9-4445-67a8-08da2d979130
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:30:22.6464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jgcs25fyiYXppc25DXB0rZAKImWMHWN7gLIMDfup79aVCsvAPqfHZz1qrv/BSsKCuEKxwLIem39CKyvUoyXMPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4745
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver periodically queries the device for activity of ACL rules in
order to report it to tc upon 'FLOW_CLS_STATS'.

In Spectrum-2 and later ASICs, multicast routes are programmed as ACL
rules, but unlike rules installed by tc, their activity is of no
interest.

Avoid unnecessary activity query for such rules by always reporting them
as inactive.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index 31f7f4c3acc3..3b9ba8fa247a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -1827,10 +1827,9 @@ static int
 mlxsw_sp_acl_tcam_mr_rule_activity_get(struct mlxsw_sp *mlxsw_sp,
 				       void *rule_priv, bool *activity)
 {
-	struct mlxsw_sp_acl_tcam_mr_rule *rule = rule_priv;
+	*activity = false;
 
-	return mlxsw_sp_acl_tcam_ventry_activity_get(mlxsw_sp, &rule->ventry,
-						     activity);
+	return 0;
 }
 
 static const struct mlxsw_sp_acl_profile_ops mlxsw_sp_acl_tcam_mr_ops = {
-- 
2.35.1

