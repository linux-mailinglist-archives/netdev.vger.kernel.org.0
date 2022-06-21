Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E80552D20
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347880AbiFUIfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347097AbiFUIfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:35:50 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6351924F23
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 01:35:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJKHRdjq6kV3ZW1bRs2Ibkg8sZcR/bKx4hOk5FeFxd2a0P17hB9hDmV5vqHdPZsQHHGqt2eKTCYrtTUbka0fEnROfGM1YVy58DKdFxpWUg7MTKb47b4bMF0MQnxl+93JwxYfE2LITYm2VpuCG8z3MI6WjRMUKENTWt7AI2vVD9jMaIxe1Sv7GmHurVpPWrhAMEcRucW2kgRw5tPH8RIYIz2plP3cKuF4FC2tbtktkJDp5Zx562z0Bk43/91e80L2OjHgu+B5nKXF0JhToI5RX0ksesmc7me+967WsfwZOOFe5NvCYZDYzD8Glb6jndKAj371LdcvB3j1Guu+bMc9gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lb51XKbJI8jwk+dMx4yq6Y3SCJnUn4Wv9/dgTax4UNA=;
 b=IDP/BpgkvNbFiImT7IonPsLAq6HrWfos4lFRw6tmgTz25MTiS0Or6QLLOoEoyUppNJuYvSQujfvotyaC41TENCkBtYNF9VwbxeG2mbA6FooCJ3BegWJTbU6LOHp/bmh8lUm6doN1+/EF2UZ0O2ltxSIqgK7Echb8iFpa+Jsy/VBR/FTiQvpvHsT/zg2NcNCmDq1xy2TuNyjQVJadwhjlbl8X06F5R5yuTN3a1ac6CT8G5GPCNoqw++CC8kDNv+FXNd7wvIf+iemYmO+yQQXhnpB+36JR8FQCRWkyOPKouXw64lJnoR6ONbm5z6H5OlCWuqT8mY56YG643qkMdtTmTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lb51XKbJI8jwk+dMx4yq6Y3SCJnUn4Wv9/dgTax4UNA=;
 b=E/8nie8AOVAHeQES72VAgvZDSkRhwxcS1A6PB19+2XJxiodgUDI0u12L9EiDEXet2P2CuxHkc9cwP0o9PDbBcDeSl5fGrpflkAuRlqGPdsHom2kK9oLJsq4sKWWofk0eQNNd4Ob9oC/IKdhdaK3owrZaOiK1OG9+I8TyKBeB7Hjm/ivEj4BaM/Cjt4oBABWI6VbI/sx/8tHOVV4ooNNR2RCTfVuWjtCVith2Joh7gcp5exTmlojWnS6N/+8cuXmcLxYHzVpi6lgxZL50qVVMIldrCH78GwecQigkqJTTOHO8W4rSvfXlE+yyh80nAuY1FKIIwcbEx/kijdxKKI/3og==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3832.namprd12.prod.outlook.com (2603:10b6:610:24::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Tue, 21 Jun
 2022 08:35:47 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Tue, 21 Jun 2022
 08:35:47 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 11/13] mlxsw: spectrum_fid: Save 'fid_offset' as part of FID structure
Date:   Tue, 21 Jun 2022 11:33:43 +0300
Message-Id: <20220621083345.157664-12-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220621083345.157664-1-idosch@nvidia.com>
References: <20220621083345.157664-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0149.eurprd07.prod.outlook.com
 (2603:10a6:802:16::36) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39db4f9e-df9c-44f0-f4b2-08da53610a45
X-MS-TrafficTypeDiagnostic: CH2PR12MB3832:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB383233274B8C6DE869C683F5B2B39@CH2PR12MB3832.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HAIQyu857D/luhz5GwBcqHB4Jh4apFUCML4DEMciJnOkGe3QtwNoANBgesk6ziCzJEhad0sf0PuLxV1XrQp6FmnTBlyv14PW9xE2f5AhK3A5YiY/uwD2I5Z/9+7VikNLHnx7BiEN3WpBFkMAT47cwSWPq7bxfNUJd4RTV7nFEJTEOoXQOJoLrBthHcvHM4wD9Y50slIecmZ/ZLQRaZL2VkmKoSj6yqr2TaUdeehvqltGcKQsqzItEGgc2DOFu8FH/daMhrqdSJItptWNwLBkeESUoD24WJ0xouncHUPyqU07dDj00g7erOo1Ksfflpv48Ycurkw3FG4AMP5cxCKWQU8x52zoN2coWLgNT/UbBZHRgm3jNjSbZPPDbovzCvY5OeVwgzRQTpzCeKVnAPjZP66U86MlQhJydgI2eRgZdAm4UR4xk5JikrrWsKbjtuownFiBdrAcah0IqD9hr46BdaqmrY2eI/YSg5ri2k+7lFu7RdxTEkFr6i46OcDQoSJYsK4LlpFMJzyHGtRYbGbCCliYua+zaUlR88VzDgOnRmZN3sugHPfu4+UgYlu8K1J+aTti2j6qdDtWrtxjk32nOobGTYryzViH9HhKjXawSaohiE+d8JdC/GvOCey/6rQ8WgqMge8f0ASHrSeH2PdasQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(2616005)(1076003)(38100700002)(186003)(107886003)(41300700001)(36756003)(66946007)(316002)(8676002)(6916009)(66556008)(83380400001)(66476007)(4326008)(8936002)(478600001)(6512007)(86362001)(26005)(6506007)(6486002)(5660300002)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?42RdxL7xUjFjnBVnsxVwKNMgsneTjeporJWe1E9yCxPILfWgVDeYca06mpCp?=
 =?us-ascii?Q?o79qxzVyHCHk7ZpoBAPGaYOMUCKk8tziiKu/ROvPuqsX3Q7VapcIL14iApYo?=
 =?us-ascii?Q?hWo286QA0AxTtgyMbYdoN+SjINOURgXQO96MH2v6VoQeYycyRiLpy4OrixXp?=
 =?us-ascii?Q?JCNr6W+R190M3cNAnFJOVbPkoLciLg/T/cmrq/nWe/JFoy/aT0rh45K+kIG6?=
 =?us-ascii?Q?+/R6KwV5BXAmOX0T44O2fU+D1j5DmSK89Mj13OP8+RcKGZgdgxsofj9V4dJL?=
 =?us-ascii?Q?S593WKwVn7Neb6GPVG2HfAGXApfJeTL3gSRxpbj/i3LOx3hxWMEL0SG5BZHD?=
 =?us-ascii?Q?SoLToML9UlUA11VUOPOrQVSOe1q1jiLLeKip2BZYKjKi2YBbshRLo/71XfsJ?=
 =?us-ascii?Q?5U5POyxjpP2roMyVNlk6/u87FaABUMwzYndIGmaAjTabQo90NQcJShBaWIbW?=
 =?us-ascii?Q?P6ZhzDHMcEWBo8AWGj+diZDQOJXj8Cp3FGwi8eqwS7OVgsn8xVRnPqmnn/zo?=
 =?us-ascii?Q?NZdWDWWGlwzZSKZtbL0GJaxL0wqQabiKgpyUAWaWMdHdyvdDPa5J/MqIUmif?=
 =?us-ascii?Q?xoYZvuu3cmqr5eHB1y3CrYcbkZIGe2k82x7bKG5DsORpCrpLptHvsruuD1ES?=
 =?us-ascii?Q?UzLP2XCFqh0kJwW8Nf7eC7pOg4fp2qawuVE+oZ+Kwh0w/PkJIxXlmTKr37r0?=
 =?us-ascii?Q?zsmFxc7/Jphb70XjkwMB41badJauOZchthlkR5IuJGBOz7s/oRD3HZ7L4UG2?=
 =?us-ascii?Q?zIwcAt2hAs4yaf4GmI5LrNBFpBpE5tkUOhuxM+1Lc86I+YIhVitjFYRfth7w?=
 =?us-ascii?Q?ZT2nH9AtsdUj0af7gV4FYlddbGVT9jVoylk/wpD0NwDFbYfY7PU3FHY2JOYr?=
 =?us-ascii?Q?2BGKq9WHzi153zNzr0sBHiV6jcnoVx3CqHBZYxbYiid6EIzRXYa8TAaa8Kxa?=
 =?us-ascii?Q?RnCjWkGADXH8LQSozMyNeluFiq22UwN+akbFyusl6PLea5u7gU0n3lDd1yrW?=
 =?us-ascii?Q?ZI7Gln/nAY+tNspBWC60XEO+lRViU9sqIAp11+67obQJoQ1+5YdVQLSWMi+j?=
 =?us-ascii?Q?NEq5o+05JkpyaiyOaejvHY7JV4LPTq7hnoXEKIod53YlDPBhgWDPKAb7iz78?=
 =?us-ascii?Q?0RTaBAw/85Kkrs8oakeYrDOEZpMu0lN8Z4igbo1SbwPgDROszUTVN9b1Cimo?=
 =?us-ascii?Q?+Pdny3As8Xquc8jpXmCotDdmrGHPKwlgKzmc/vjHiU0LkPBSS+7y1qgOTyZP?=
 =?us-ascii?Q?LHmh1njP52PRdcvCb02mOjt2HtAK8A8ilQ+BDpFfDZ9vesEC2z9wnlfXlizE?=
 =?us-ascii?Q?GpKqwL69+D+v6EPZlLKxXsVvNIxwBu/ldY8Z6CYaD/EopxX4WnwCs0gAdLYl?=
 =?us-ascii?Q?QhVK2fgeO/hsTKLwE64Lt/ftvPHxwbS/4Dwg3lYm//FXeCTxaAVE2R79z3Ip?=
 =?us-ascii?Q?CtAJDM3SXLemPcogbBzBoRjsSjQoNQePdS5OJc9QSRnKAwXU4V7go8tvg2a7?=
 =?us-ascii?Q?tFwCJtM4CBD4Jbk7NN0Hsy18Gzr84MqKrv8Qdy0l6i5TxVjsmPv8SHsSBBfG?=
 =?us-ascii?Q?yq9QrvFpyrJboMzGCfKp9WJ0XOG2cLris6Q/pCvMfutlIVBJ+WL4n2CxHnw+?=
 =?us-ascii?Q?qCGfrvEgneasYzaGHJCAjJr7r8W0VkE/c4rz9wI7c0Gwh+IBSsoBTr6kXfC0?=
 =?us-ascii?Q?BlsfIdUs3NCTQiZYNsSD8klp4Lo+PfWprsHv7wRV8vVSvZgH+BTQKYb9VMMh?=
 =?us-ascii?Q?muzjbXvXng=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39db4f9e-df9c-44f0-f4b2-08da53610a45
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 08:35:47.6729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0e9o4/5mfSs016+nwgq/dspDjyhU6KYyBpdxYK88OuVo3OvmfMvjeJizV2Hb9TNf4hw9z+gLPKAlwgIwnzLa4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3832
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

SFMR register contains a 'fid_offset' field which is used when flooding
tables of type FID offset are used.

Currently, the driver sets this field to zero, as flooding tables of type
FID are used.

Using unified bridge model, the driver will use FID offset flooding
tables. As preparation, add 'fid_offset' to 'struct mlxsw_sp_fid'. Then,
use this field instead of passing zero to the function that configures
SFMR.

Set the new field as part of 'ops->setup()', for that, implement this
function for dummy FID and rFID.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 29 +++++++++++++++----
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 118dee89f18f..df096e2c3822 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -27,6 +27,7 @@ struct mlxsw_sp_fid {
 	struct mlxsw_sp_rif *rif;
 	refcount_t ref_count;
 	u16 fid_index;
+	u16 fid_offset;
 	struct mlxsw_sp_fid_family *fid_family;
 	struct rhash_head ht_node;
 
@@ -399,6 +400,7 @@ static void mlxsw_sp_fid_8021q_setup(struct mlxsw_sp_fid *fid, const void *arg)
 	u16 vid = *(u16 *) arg;
 
 	mlxsw_sp_fid_8021q_fid(fid)->vid = vid;
+	fid->fid_offset = 0;
 }
 
 static enum mlxsw_reg_sfmr_op mlxsw_sp_sfmr_op(bool valid)
@@ -453,20 +455,23 @@ static void mlxsw_sp_fid_8021d_setup(struct mlxsw_sp_fid *fid, const void *arg)
 	int br_ifindex = *(int *) arg;
 
 	mlxsw_sp_fid_8021d_fid(fid)->br_ifindex = br_ifindex;
+	fid->fid_offset = 0;
 }
 
 static int mlxsw_sp_fid_8021d_configure(struct mlxsw_sp_fid *fid)
 {
 	struct mlxsw_sp_fid_family *fid_family = fid->fid_family;
 
-	return mlxsw_sp_fid_op(fid_family->mlxsw_sp, fid->fid_index, 0, true);
+	return mlxsw_sp_fid_op(fid_family->mlxsw_sp, fid->fid_index,
+			       fid->fid_offset, true);
 }
 
 static void mlxsw_sp_fid_8021d_deconfigure(struct mlxsw_sp_fid *fid)
 {
 	if (fid->vni_valid)
 		mlxsw_sp_nve_fid_disable(fid->fid_family->mlxsw_sp, fid);
-	mlxsw_sp_fid_op(fid->fid_family->mlxsw_sp, fid->fid_index, 0, false);
+	mlxsw_sp_fid_op(fid->fid_family->mlxsw_sp, fid->fid_index,
+			fid->fid_offset, false);
 }
 
 static int mlxsw_sp_fid_8021d_index_alloc(struct mlxsw_sp_fid *fid,
@@ -743,6 +748,11 @@ static const struct mlxsw_sp_fid_family mlxsw_sp_fid_8021q_emu_family = {
 	.ops			= &mlxsw_sp_fid_8021q_emu_ops,
 };
 
+static void mlxsw_sp_fid_rfid_setup(struct mlxsw_sp_fid *fid, const void *arg)
+{
+	fid->fid_offset = 0;
+}
+
 static int mlxsw_sp_fid_rfid_configure(struct mlxsw_sp_fid *fid)
 {
 	/* rFIDs are allocated by the device during init */
@@ -808,6 +818,7 @@ mlxsw_sp_fid_rfid_port_vid_unmap(struct mlxsw_sp_fid *fid,
 }
 
 static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_rfid_ops = {
+	.setup			= mlxsw_sp_fid_rfid_setup,
 	.configure		= mlxsw_sp_fid_rfid_configure,
 	.deconfigure		= mlxsw_sp_fid_rfid_deconfigure,
 	.index_alloc		= mlxsw_sp_fid_rfid_index_alloc,
@@ -828,16 +839,22 @@ static const struct mlxsw_sp_fid_family mlxsw_sp_fid_rfid_family = {
 	.ops			= &mlxsw_sp_fid_rfid_ops,
 };
 
+static void mlxsw_sp_fid_dummy_setup(struct mlxsw_sp_fid *fid, const void *arg)
+{
+	fid->fid_offset = 0;
+}
+
 static int mlxsw_sp_fid_dummy_configure(struct mlxsw_sp_fid *fid)
 {
 	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 
-	return mlxsw_sp_fid_op(mlxsw_sp, fid->fid_index, 0, true);
+	return mlxsw_sp_fid_op(mlxsw_sp, fid->fid_index, fid->fid_offset, true);
 }
 
 static void mlxsw_sp_fid_dummy_deconfigure(struct mlxsw_sp_fid *fid)
 {
-	mlxsw_sp_fid_op(fid->fid_family->mlxsw_sp, fid->fid_index, 0, false);
+	mlxsw_sp_fid_op(fid->fid_family->mlxsw_sp, fid->fid_index,
+			fid->fid_offset, false);
 }
 
 static int mlxsw_sp_fid_dummy_index_alloc(struct mlxsw_sp_fid *fid,
@@ -855,6 +872,7 @@ static bool mlxsw_sp_fid_dummy_compare(const struct mlxsw_sp_fid *fid,
 }
 
 static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_dummy_ops = {
+	.setup			= mlxsw_sp_fid_dummy_setup,
 	.configure		= mlxsw_sp_fid_dummy_configure,
 	.deconfigure		= mlxsw_sp_fid_dummy_deconfigure,
 	.index_alloc		= mlxsw_sp_fid_dummy_index_alloc,
@@ -919,8 +937,7 @@ static struct mlxsw_sp_fid *mlxsw_sp_fid_get(struct mlxsw_sp *mlxsw_sp,
 	fid->fid_index = fid_index;
 	__set_bit(fid_index - fid_family->start_index, fid_family->fids_bitmap);
 
-	if (fid->fid_family->ops->setup)
-		fid->fid_family->ops->setup(fid, arg);
+	fid->fid_family->ops->setup(fid, arg);
 
 	err = fid->fid_family->ops->configure(fid);
 	if (err)
-- 
2.36.1

