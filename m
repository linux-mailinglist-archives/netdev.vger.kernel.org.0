Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387A5561500
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 10:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbiF3IZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 04:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbiF3IYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 04:24:21 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9FA5F37
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:24:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kGuP8VB5ZiueSkH8+zX2nbnfnHBq0gt01e9jJSmJoUdQarsUkA7GtcZXV6DNQelJ3lhyWfLgevDapFlj6kNsl2SZFEKsQNwyR+j/6AwYRPoFfAckKgBUu2K0NzAvH9FwjxXcfn18CBqiHtZ1iA/uLEevpxQb2yRufx6ntjcWAKFqLRL8kuCUGtKcnIq6zbYZZXXK0hB4ajOndbW+jJiqUce80je6NM18J93e7DE+AkQQwZmKAg8EI/SemfQZfxesGKx6iUY+A1RBNVfcBoHR5hfD2L6s93GEZ234Bg1+jsjen8fEpgZv6IwVsYpO3f2j+JExOZNo2vWj2XMqXO0oGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOwXqJW0n7SsBSlxcvTlq7dEZim05zdhXGXd+9u47bc=;
 b=O2N6gCZbzPdNaeAfh+iNyV/IL2el1ZUqnnYfgzJ8TvlRXTnjNYDuTCIvzOXrYA4q23vhB2jXBGFspgLTELP5nPWzl79UL0sgyLXnaYiWYxSFlrc3n01AGT2MvJJewmt3adKYs8xRq1A9BLURQvGd3sdrN0Jtsw4X86KVQCnipqs1PiiUo5fz8iOCy7yrjX1HT/nfqtawRtz/5d72UD0qt+JVFmel8wPp+Lumfa9fI0X6OOveSP+X7ZKDZ4UKdjI+nAEuoHFD8M+50BkCqnQwIxmzqpQ7zGvTZPLDDGCEPhOnLrnr4dqrZaVLkXgny+CrZoRjgcnfvWv+1tp3zydV/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOwXqJW0n7SsBSlxcvTlq7dEZim05zdhXGXd+9u47bc=;
 b=QyLStdQx7xVHhWFf2x7BnjVFf9XvNnCRDRqE6LvljYySgKDE9YS5Kjy7X+EBf+q8mDGFr/irsaaU8LEtL2+YH6SwcM0nkY1UPqmhN99e0xaTn4d0FdBEpit/PwE1CgMhZH5NNupvdf9xAIkzhqw0AughnVM8j97/HG45RqhXM2OWRujGp63MxuZOtkKYuFWKKH7IZI1voZlk7aMhyv7G4mLJU3dQQC2nxirYtjViCdtvSw3D9ifQ8lGlji9WVOJgLIY1Tzu/68gwYlvoztycVse8PTViaCoPMbXo/cLwIQhM4ZJ1+ieJcA4qU36Pg84uXbrkkeoQ9Dt27ZlZzcWhcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB2880.namprd12.prod.outlook.com (2603:10b6:208:106::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Thu, 30 Jun
 2022 08:24:07 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 08:24:07 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/13] mlxsw: Add new FID families for unified bridge model
Date:   Thu, 30 Jun 2022 11:22:52 +0300
Message-Id: <20220630082257.903759-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630082257.903759-1-idosch@nvidia.com>
References: <20220630082257.903759-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0802CA0038.eurprd08.prod.outlook.com
 (2603:10a6:800:a9::24) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d14d44b-70ee-40d1-7ab4-08da5a71e6ab
X-MS-TrafficTypeDiagnostic: MN2PR12MB2880:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V848sG6QpnM2A1Xl49u7ePSDk6bbuFOB1vdFFtJKocxU2ppOJX2c5f0pH/kHia1/AW1YlmMfoz6WSCGXwCfZLRk0MQP5/4jn5G0CzrD55FDP/eUT+yyhBkpJmkJWE+r+X6dfBEwEt5zWK4odkpJNCwkUZXKpQforuLpA+Z9lXT8kXm1p7uSzDRn99mfkJ41Fc9ry7rZY/JPsnTralZXxECh54yMK2/T+F98DYg7i5fReEMfKujOUsphNqXHj8AQZu2CyG8kmNan3GOFwxpkzGrQVhIZGAHyQvAgz1EhViodH/19ZKPCX8CKDxrO1n5DvIfCWUernpGjus1nVfVHMq/YA3PADr10Qd5rI7WTiSETz3wnZ7JOyjYzlQhXjcNMzL++LOzG8Y1+fLVZ0NdWE6C+9OyFNWbC66gg8gXxUI/e5Svscxz0SLX8tr3GGFqf6xzAODo2SOD6dbu7XKSpoNhe04YTnOIt8iMT3oPIl411CBnrkwPM+b44RaXsGjPg98sI6oz8b764BZWMB0eN6NzoxzKnEBLQ1OSGtCgWNcmMAxGUUPwowLJEnECgcNRPTXY4Mu3yF3d/XJ0F1MrC5Ozcaw9rRsW6qYYQ+zhp3TWuVqQ3KfE5D4Q36duI+Vjp7zucAEmitzXO9RtzCNdcnv/WjFLHSOH9yoPpki2UOsyOEXJaHqzusu2/TNR2/FEh3A2/pBpcNdFCqmcz0gcvy3IbhXnMiohf8AOZR9NogEWGu+ks0Qjpc5rnncJCs8oO9xEddwal2XZrZG1gfn5pNEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(86362001)(6486002)(1076003)(36756003)(8676002)(66556008)(66946007)(478600001)(4326008)(66476007)(8936002)(6916009)(186003)(316002)(5660300002)(6666004)(30864003)(38100700002)(6506007)(2906002)(6512007)(2616005)(83380400001)(26005)(41300700001)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yTRwpFdiwP3m5ieoxzyigyeNXzyEO6v1K6+nA4mjqr3Q7ux33LD9s8Z6/FOb?=
 =?us-ascii?Q?Ll2ZLcgSKcUTLEseZSvLi2o5mJKVHsYl6bdVCTSVth1zWPrwr1+k+0zI+F91?=
 =?us-ascii?Q?Kq5wJtqgwHHjgRVUlUKVrQ9dwQU3maEm5DnaxB/hlvrNkDC1yvlh3hIDzBkQ?=
 =?us-ascii?Q?P3ACI+yf7uJcV5SOjGJszvL/V7gAPQMM9jgCW/KqZqhREFOk71LIEWGUvOlz?=
 =?us-ascii?Q?tuQMFZQGNIAB//x3GTS79EtHnUojxwE++m7xmf7fFG0EvLJAdEUMs7cjzfgY?=
 =?us-ascii?Q?eJklO3X3rStVkSjGy0HH3li72zSKYQkRnrucmQAJyhOmV/V2DoAdOTREUzvi?=
 =?us-ascii?Q?aOTchXU81jmJHc9ULKj0T0LI4o7l/VO1FBU059DpqyfhK0gTHA8dxXsknT64?=
 =?us-ascii?Q?9WrTNAkBdDsxUfN7T8AlzKX5A9ozawv9jTm6/AoXyIWzqCoDxhlFb3gFSsI3?=
 =?us-ascii?Q?lSmOJNP+ld9TZjEpgPeNFozEGcfJhG3f6BVNegYAy/zh9rLVUzqnY4lNnsxF?=
 =?us-ascii?Q?WgFY9MeMp3T8fmP0SSOdLAKFFYNxGuTN2sza/+CkI1o/xVFmQGYN5BuwSLrD?=
 =?us-ascii?Q?iSX7qjmYG9jyRdyengh8cZmEBjc12tDGtFLoMerqKpuIrLryoaXn9XfDU8Xt?=
 =?us-ascii?Q?J5XXi/LXxu8nJ2+Gjdh3rl/9WUcOTFNmMUnXnJCcgjtpsZKU0o2dczoshIgX?=
 =?us-ascii?Q?Ne+oxHT/V93MgrefGpLEeGe+GMRCfQcjoITEvxDslYclF/PaaY7i0bccTjK9?=
 =?us-ascii?Q?tgKDsbzLwhihfeo1BkVEEiBHLYpK4zTf3P+EP0k29YCxH6f0YzLVPLIsJQrs?=
 =?us-ascii?Q?tD2OzChLSapYAqqM4NyNcE5/wPhjADOqznUEMVG5IxdS9nBoHAgvyR0hkB/8?=
 =?us-ascii?Q?/MgCHnkKi+hTu0Zlb/yTtHs2M33rxU5qeHAziqkCzkqCFnrhInXCYBrlgwtA?=
 =?us-ascii?Q?spLPAdCmn/s2w/I3pBaGCj0a8fVG74teDsab4EOrQUmTiy0CKNp0MN11lonI?=
 =?us-ascii?Q?gsOuhovZjfE/we2IHrW2BcM2WEqh+6tYT7gdfGpJf/fM0ur/yGR3xIR4QQfQ?=
 =?us-ascii?Q?qc/qk3W2dRYAxLFh4MaFgRvFEJBf8JIUH9+zEm/vBO44ROHbP5Zhv6SwoTK2?=
 =?us-ascii?Q?GMkV8LK/aCFaf/Hxl2IuDZUX8EDri42cP6Nl3/XhLoLSqZ/s6rXDOq6GwqkV?=
 =?us-ascii?Q?D0YeTdQLTwELYlpemO1h0DiBayMgGMbasm0wodSF6OElqg6lCyHfdC1XzwyK?=
 =?us-ascii?Q?/5lJ/Wt7srhfm4No8tYLMNHZ9cQ9WMFf2EvGylceCf1p7IuicZpCRExLsZZB?=
 =?us-ascii?Q?Nje66L7ibEuif/vV21r5zPUauB0L+jAdbIgZmq1ckqtAeDMxUgapq0B03FF9?=
 =?us-ascii?Q?hKQHhBwTiaBC2ipgmLL9zBWjbrS2G+zD7NHnTOkJTnIKA4mZhACQPjttG2QL?=
 =?us-ascii?Q?GEO+zOcCNExCNH0ZtsZraoIJOfRhE8afBSHllEK/v9uAT1+iElyoPBbg8yRg?=
 =?us-ascii?Q?Oc9CdqPOVWAbwqSBVC0+kKWEFTYVt1GkessmtRay2ZmrWFxqUz0YMM+8eRxD?=
 =?us-ascii?Q?mh1W+suHozD+XKX7ycYbP4LgTqN0CxC3EPOUz6fe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d14d44b-70ee-40d1-7ab4-08da5a71e6ab
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 08:24:07.5866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C5xj39yHlpCFQkbd5SnFverZPgAplzSqp0zFbTsvvmR32FOtKHUR2FeV0dNDakit38Y7VnHO65ufCoIntziE1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2880
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

In the unified bridge model, mlxsw will no longer emulate 802.1Q FIDs
using 802.1D FIDs. The new FID table will look as follows:

     +---------------+
     | 802.1q FIDs   | 4K entries
     | [1..4094]     |
     +---------------+
     | 802.1d FIDs   | 1K entries
     | [4095..5118]  |
     +---------------+
     | Dummy FIDs    | 1 entry
     | [5119..5119]  |
     +---------------+
     | rFIDs         | 11K entries
     | [5120..16383] |
     +---------------+

In order to make the change easier to review, four new temporary FID
families will be added (e.g., MLXSW_SP_FID_TYPE_8021D_UB) and will not
be registered with the FID core until mlxsw is flipped to use the unified
bridge model.

Add .1d, rfid and dummy FID families for unified bridge, the next patch
will add .1q family separately as it requires more changes.

The following changes are required:
1. Add 'smpe_index_valid' field to 'struct mlxsw_sp_fid_family' and set
   SFMR.smpe accordingly. SMPE index is reserved for rFIDs, as their
   flooding is handled by firmware, and always reserved in Spectrum-1,
   as it is configured as part of PGT table.

2. Add 'ubridge' field to 'struct mlxsw_sp_fid_family'. This field will
   be removed later, use it in mlxsw_sp_fid_family_{register,unregister}()
   to skip the registration / unregistration of the new families when the
   legacy model is used.

3. Indexes - the start and end indexes of each FID family will need to be
   changed according to the above diagram.

4. Add flood tables for unified bridge model, use 'fid_offset' as table
   type, as in the new model the access to flood tables will be using
   'fid_offset' calculation.

5. FID family operation changes:
   a. rFID supposed to be created using SFMR, as it is not created by
      firmware using unified bridge model.
   b. port_vid_map() should perform SVFA for rFID, as the mapping is not
      created by firmware using unified bridge model.
   c. flood_index() is not aligned to the new model, as this function will
      be removed later.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   5 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   4 +
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 187 +++++++++++++++++-
 3 files changed, 189 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 520b990054eb..17ce28e65464 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -1969,7 +1969,8 @@ MLXSW_ITEM32(reg, sfmr, smpe, 0x28, 0, 16);
 static inline void mlxsw_reg_sfmr_pack(char *payload,
 				       enum mlxsw_reg_sfmr_op op, u16 fid,
 				       u16 fid_offset, bool flood_rsp,
-				       enum mlxsw_reg_bridge_type bridge_type)
+				       enum mlxsw_reg_bridge_type bridge_type,
+				       bool smpe_valid, u16 smpe)
 {
 	MLXSW_REG_ZERO(sfmr, payload);
 	mlxsw_reg_sfmr_op_set(payload, op);
@@ -1979,6 +1980,8 @@ static inline void mlxsw_reg_sfmr_pack(char *payload,
 	mlxsw_reg_sfmr_vv_set(payload, false);
 	mlxsw_reg_sfmr_flood_rsp_set(payload, flood_rsp);
 	mlxsw_reg_sfmr_flood_bridge_type_set(payload, bridge_type);
+	mlxsw_reg_sfmr_smpe_valid_set(payload, smpe_valid);
+	mlxsw_reg_sfmr_smpe_set(payload, smpe);
 }
 
 /* SPVMLR - Switch Port VLAN MAC Learning Register
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index c67bc562b13e..701aea8f3872 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -106,6 +106,10 @@ enum mlxsw_sp_fid_type {
 	MLXSW_SP_FID_TYPE_8021D,
 	MLXSW_SP_FID_TYPE_RFID,
 	MLXSW_SP_FID_TYPE_DUMMY,
+	MLXSW_SP_FID_TYPE_8021Q_UB,
+	MLXSW_SP_FID_TYPE_8021D_UB,
+	MLXSW_SP_FID_TYPE_RFID_UB,
+	MLXSW_SP_FID_TYPE_DUMMY_UB,
 	MLXSW_SP_FID_TYPE_MAX,
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index c6397f81c2d7..9dca74bbabb4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -111,6 +111,8 @@ struct mlxsw_sp_fid_family {
 	bool flood_rsp;
 	enum mlxsw_reg_bridge_type bridge_type;
 	u16 pgt_base;
+	bool smpe_index_valid;
+	bool ubridge;
 };
 
 static const int mlxsw_sp_sfgc_uc_packet_types[MLXSW_REG_SFGC_TYPE_MAX] = {
@@ -448,15 +450,20 @@ static int mlxsw_sp_fid_op(const struct mlxsw_sp_fid *fid, bool valid)
 	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	enum mlxsw_reg_bridge_type bridge_type = 0;
 	char sfmr_pl[MLXSW_REG_SFMR_LEN];
+	bool smpe_valid = false;
 	bool flood_rsp = false;
+	u16 smpe = 0;
 
 	if (mlxsw_sp->ubridge) {
 		flood_rsp = fid->fid_family->flood_rsp;
 		bridge_type = fid->fid_family->bridge_type;
+		smpe_valid = fid->fid_family->smpe_index_valid;
+		smpe = smpe_valid ? fid->fid_index : 0;
 	}
 
 	mlxsw_reg_sfmr_pack(sfmr_pl, mlxsw_sp_sfmr_op(valid), fid->fid_index,
-			    fid->fid_offset, flood_rsp, bridge_type);
+			    fid->fid_offset, flood_rsp, bridge_type, smpe_valid,
+			    smpe);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfmr), sfmr_pl);
 }
 
@@ -466,16 +473,20 @@ static int mlxsw_sp_fid_edit_op(const struct mlxsw_sp_fid *fid,
 	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	enum mlxsw_reg_bridge_type bridge_type = 0;
 	char sfmr_pl[MLXSW_REG_SFMR_LEN];
+	bool smpe_valid = false;
 	bool flood_rsp = false;
+	u16 smpe = 0;
 
 	if (mlxsw_sp->ubridge) {
 		flood_rsp = fid->fid_family->flood_rsp;
 		bridge_type = fid->fid_family->bridge_type;
+		smpe_valid = fid->fid_family->smpe_index_valid;
+		smpe = smpe_valid ? fid->fid_index : 0;
 	}
 
 	mlxsw_reg_sfmr_pack(sfmr_pl, MLXSW_REG_SFMR_OP_CREATE_FID,
 			    fid->fid_index, fid->fid_offset, flood_rsp,
-			    bridge_type);
+			    bridge_type, smpe_valid, smpe);
 	mlxsw_reg_sfmr_vv_set(sfmr_pl, fid->vni_valid);
 	mlxsw_reg_sfmr_vni_set(sfmr_pl, be32_to_cpu(fid->vni));
 	mlxsw_reg_sfmr_vtfp_set(sfmr_pl, fid->nve_flood_index_valid);
@@ -772,10 +783,15 @@ mlxsw_sp_fid_8021d_fid(const struct mlxsw_sp_fid *fid)
 
 static void mlxsw_sp_fid_8021d_setup(struct mlxsw_sp_fid *fid, const void *arg)
 {
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	int br_ifindex = *(int *) arg;
 
 	mlxsw_sp_fid_8021d_fid(fid)->br_ifindex = br_ifindex;
-	fid->fid_offset = 0;
+
+	if (mlxsw_sp->ubridge)
+		fid->fid_offset = fid->fid_index - fid->fid_family->start_index;
+	else
+		fid->fid_offset = 0;
 }
 
 static int mlxsw_sp_fid_8021d_configure(struct mlxsw_sp_fid *fid)
@@ -1079,6 +1095,7 @@ static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_8021d_ops = {
 };
 
 #define MLXSW_SP_FID_8021Q_MAX (VLAN_N_VID - 2)
+#define MLXSW_SP_FID_RFID_UB_MAX (11 * 1024)
 #define MLXSW_SP_FID_8021Q_PGT_BASE 0
 #define MLXSW_SP_FID_8021D_PGT_BASE (3 * MLXSW_SP_FID_8021Q_MAX)
 
@@ -1100,6 +1117,24 @@ static const struct mlxsw_sp_flood_table mlxsw_sp_fid_8021d_flood_tables[] = {
 	},
 };
 
+static const struct mlxsw_sp_flood_table mlxsw_sp_fid_8021d_ub_flood_tables[] = {
+	{
+		.packet_type	= MLXSW_SP_FLOOD_TYPE_UC,
+		.table_type	= MLXSW_REG_SFGC_TABLE_TYPE_FID_OFFSET,
+		.table_index	= 0,
+	},
+	{
+		.packet_type	= MLXSW_SP_FLOOD_TYPE_MC,
+		.table_type	= MLXSW_REG_SFGC_TABLE_TYPE_FID_OFFSET,
+		.table_index	= 1,
+	},
+	{
+		.packet_type	= MLXSW_SP_FLOOD_TYPE_BC,
+		.table_type	= MLXSW_REG_SFGC_TABLE_TYPE_FID_OFFSET,
+		.table_index	= 2,
+	},
+};
+
 /* Range and flood configuration must match mlxsw_config_profile */
 static const struct mlxsw_sp_fid_family mlxsw_sp_fid_8021d_family = {
 	.type			= MLXSW_SP_FID_TYPE_8021D,
@@ -1171,12 +1206,23 @@ static void mlxsw_sp_fid_rfid_setup(struct mlxsw_sp_fid *fid, const void *arg)
 
 static int mlxsw_sp_fid_rfid_configure(struct mlxsw_sp_fid *fid)
 {
-	/* rFIDs are allocated by the device during init */
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+
+	/* rFIDs are allocated by the device during init using legacy
+	 * bridge model.
+	 */
+	if (mlxsw_sp->ubridge)
+		return mlxsw_sp_fid_op(fid, true);
+
 	return 0;
 }
 
 static void mlxsw_sp_fid_rfid_deconfigure(struct mlxsw_sp_fid *fid)
 {
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+
+	if (mlxsw_sp->ubridge)
+		mlxsw_sp_fid_op(fid, false);
 }
 
 static int mlxsw_sp_fid_rfid_index_alloc(struct mlxsw_sp_fid *fid,
@@ -1210,9 +1256,27 @@ static int mlxsw_sp_fid_rfid_port_vid_map(struct mlxsw_sp_fid *fid,
 	if (err)
 		return err;
 
-	/* We only need to transition the port to virtual mode since
-	 * {Port, VID} => FID is done by the firmware upon RIF creation.
+	/* Using legacy bridge model, we only need to transition the port to
+	 * virtual mode since {Port, VID} => FID is done by the firmware upon
+	 * RIF creation. Using unified bridge model, we need to map
+	 * {Port, VID} => FID and map egress VID.
 	 */
+	if (mlxsw_sp->ubridge) {
+		err = __mlxsw_sp_fid_port_vid_map(fid,
+						  mlxsw_sp_port->local_port,
+						  vid, true);
+		if (err)
+			goto err_port_vid_map;
+
+		if (fid->rif) {
+			err = mlxsw_sp_fid_erif_eport_to_vid_map_one(fid,
+								     local_port,
+								     vid, true);
+			if (err)
+				goto err_erif_eport_to_vid_map_one;
+		}
+	}
+
 	if (mlxsw_sp->fid_core->port_fid_mappings[local_port]++ == 0) {
 		err = mlxsw_sp_port_vp_mode_trans(mlxsw_sp_port);
 		if (err)
@@ -1223,6 +1287,14 @@ static int mlxsw_sp_fid_rfid_port_vid_map(struct mlxsw_sp_fid *fid,
 
 err_port_vp_mode_trans:
 	mlxsw_sp->fid_core->port_fid_mappings[local_port]--;
+	if (mlxsw_sp->ubridge && fid->rif)
+		mlxsw_sp_fid_erif_eport_to_vid_map_one(fid, local_port, vid,
+						       false);
+err_erif_eport_to_vid_map_one:
+	if (mlxsw_sp->ubridge)
+		__mlxsw_sp_fid_port_vid_map(fid, mlxsw_sp_port->local_port, vid,
+					    false);
+err_port_vid_map:
 	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
 	return err;
 }
@@ -1237,6 +1309,15 @@ mlxsw_sp_fid_rfid_port_vid_unmap(struct mlxsw_sp_fid *fid,
 	if (mlxsw_sp->fid_core->port_fid_mappings[local_port] == 1)
 		mlxsw_sp_port_vlan_mode_trans(mlxsw_sp_port);
 	mlxsw_sp->fid_core->port_fid_mappings[local_port]--;
+
+	if (mlxsw_sp->ubridge) {
+		if (fid->rif)
+			mlxsw_sp_fid_erif_eport_to_vid_map_one(fid, local_port,
+							       vid, false);
+		__mlxsw_sp_fid_port_vid_map(fid, mlxsw_sp_port->local_port, vid,
+					    false);
+	}
+
 	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
 }
 
@@ -1356,11 +1437,95 @@ static const struct mlxsw_sp_fid_family mlxsw_sp_fid_dummy_family = {
 	.ops			= &mlxsw_sp_fid_dummy_ops,
 };
 
+/* There are 4K-2 802.1Q FIDs */
+#define MLXSW_SP_FID_8021Q_UB_START	1 /* FID 0 is reserved. */
+#define MLXSW_SP_FID_8021Q_UB_END	(MLXSW_SP_FID_8021Q_UB_START + \
+					 MLXSW_SP_FID_8021Q_MAX - 1)
+
+/* There are 1K 802.1D FIDs */
+#define MLXSW_SP_FID_8021D_UB_START	(MLXSW_SP_FID_8021Q_UB_END + 1)
+#define MLXSW_SP_FID_8021D_UB_END	(MLXSW_SP_FID_8021D_UB_START + \
+					 MLXSW_SP_FID_8021D_MAX - 1)
+
+/* There is one dummy FID */
+#define MLXSW_SP_FID_DUMMY_UB		(MLXSW_SP_FID_8021D_UB_END + 1)
+
+/* There are 11K rFIDs */
+#define MLXSW_SP_RFID_UB_START		(MLXSW_SP_FID_DUMMY_UB + 1)
+#define MLXSW_SP_RFID_UB_END		(MLXSW_SP_RFID_UB_START + \
+					 MLXSW_SP_FID_RFID_UB_MAX - 1)
+
+static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_8021d_ub_family = {
+	.type			= MLXSW_SP_FID_TYPE_8021D_UB,
+	.fid_size		= sizeof(struct mlxsw_sp_fid_8021d),
+	.start_index		= MLXSW_SP_FID_8021D_UB_START,
+	.end_index		= MLXSW_SP_FID_8021D_UB_END,
+	.flood_tables		= mlxsw_sp_fid_8021d_ub_flood_tables,
+	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_ub_flood_tables),
+	.rif_type		= MLXSW_SP_RIF_TYPE_FID,
+	.ops			= &mlxsw_sp_fid_8021d_ops,
+	.bridge_type            = MLXSW_REG_BRIDGE_TYPE_1,
+	.pgt_base		= MLXSW_SP_FID_8021D_PGT_BASE,
+	.smpe_index_valid       = false,
+	.ubridge		= true,
+};
+
+static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_dummy_ub_family = {
+	.type			= MLXSW_SP_FID_TYPE_DUMMY_UB,
+	.fid_size		= sizeof(struct mlxsw_sp_fid),
+	.start_index		= MLXSW_SP_FID_DUMMY_UB,
+	.end_index		= MLXSW_SP_FID_DUMMY_UB,
+	.ops			= &mlxsw_sp_fid_dummy_ops,
+	.smpe_index_valid       = false,
+	.ubridge		= true,
+};
+
+static const struct mlxsw_sp_fid_family mlxsw_sp_fid_rfid_ub_family = {
+	.type			= MLXSW_SP_FID_TYPE_RFID_UB,
+	.fid_size		= sizeof(struct mlxsw_sp_fid),
+	.start_index		= MLXSW_SP_RFID_UB_START,
+	.end_index		= MLXSW_SP_RFID_UB_END,
+	.rif_type		= MLXSW_SP_RIF_TYPE_SUBPORT,
+	.ops			= &mlxsw_sp_fid_rfid_ops,
+	.flood_rsp              = true,
+	.smpe_index_valid       = false,
+	.ubridge		= true,
+};
+
 const struct mlxsw_sp_fid_family *mlxsw_sp1_fid_family_arr[] = {
 	[MLXSW_SP_FID_TYPE_8021Q]	= &mlxsw_sp_fid_8021q_emu_family,
 	[MLXSW_SP_FID_TYPE_8021D]	= &mlxsw_sp_fid_8021d_family,
 	[MLXSW_SP_FID_TYPE_RFID]	= &mlxsw_sp_fid_rfid_family,
 	[MLXSW_SP_FID_TYPE_DUMMY]	= &mlxsw_sp_fid_dummy_family,
+
+	[MLXSW_SP_FID_TYPE_8021D_UB]	= &mlxsw_sp1_fid_8021d_ub_family,
+	[MLXSW_SP_FID_TYPE_DUMMY_UB]	= &mlxsw_sp1_fid_dummy_ub_family,
+	[MLXSW_SP_FID_TYPE_RFID_UB]	= &mlxsw_sp_fid_rfid_ub_family,
+};
+
+static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_8021d_ub_family = {
+	.type			= MLXSW_SP_FID_TYPE_8021D_UB,
+	.fid_size		= sizeof(struct mlxsw_sp_fid_8021d),
+	.start_index		= MLXSW_SP_FID_8021D_UB_START,
+	.end_index		= MLXSW_SP_FID_8021D_UB_END,
+	.flood_tables		= mlxsw_sp_fid_8021d_ub_flood_tables,
+	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_ub_flood_tables),
+	.rif_type		= MLXSW_SP_RIF_TYPE_FID,
+	.ops			= &mlxsw_sp_fid_8021d_ops,
+	.bridge_type            = MLXSW_REG_BRIDGE_TYPE_1,
+	.pgt_base		= MLXSW_SP_FID_8021D_PGT_BASE,
+	.smpe_index_valid       = true,
+	.ubridge		= true,
+};
+
+static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_dummy_ub_family = {
+	.type			= MLXSW_SP_FID_TYPE_DUMMY_UB,
+	.fid_size		= sizeof(struct mlxsw_sp_fid),
+	.start_index		= MLXSW_SP_FID_DUMMY_UB,
+	.end_index		= MLXSW_SP_FID_DUMMY_UB,
+	.ops			= &mlxsw_sp_fid_dummy_ops,
+	.smpe_index_valid       = false,
+	.ubridge		= true,
 };
 
 const struct mlxsw_sp_fid_family *mlxsw_sp2_fid_family_arr[] = {
@@ -1368,6 +1533,10 @@ const struct mlxsw_sp_fid_family *mlxsw_sp2_fid_family_arr[] = {
 	[MLXSW_SP_FID_TYPE_8021D]	= &mlxsw_sp_fid_8021d_family,
 	[MLXSW_SP_FID_TYPE_RFID]	= &mlxsw_sp_fid_rfid_family,
 	[MLXSW_SP_FID_TYPE_DUMMY]	= &mlxsw_sp_fid_dummy_family,
+
+	[MLXSW_SP_FID_TYPE_8021D_UB]	= &mlxsw_sp2_fid_8021d_ub_family,
+	[MLXSW_SP_FID_TYPE_DUMMY_UB]	= &mlxsw_sp2_fid_dummy_ub_family,
+	[MLXSW_SP_FID_TYPE_RFID_UB]	= &mlxsw_sp_fid_rfid_ub_family,
 };
 
 static struct mlxsw_sp_fid *mlxsw_sp_fid_lookup(struct mlxsw_sp *mlxsw_sp,
@@ -1676,6 +1845,9 @@ int mlxsw_sp_fids_init(struct mlxsw_sp *mlxsw_sp)
 	}
 
 	for (i = 0; i < MLXSW_SP_FID_TYPE_MAX; i++) {
+		if (mlxsw_sp->ubridge != mlxsw_sp->fid_family_arr[i]->ubridge)
+			continue;
+
 		err = mlxsw_sp_fid_family_register(mlxsw_sp,
 						   mlxsw_sp->fid_family_arr[i]);
 
@@ -1690,6 +1862,9 @@ int mlxsw_sp_fids_init(struct mlxsw_sp *mlxsw_sp)
 		struct mlxsw_sp_fid_family *fid_family;
 
 		fid_family = fid_core->fid_family_arr[i];
+		if (mlxsw_sp->ubridge != fid_family->ubridge)
+			continue;
+
 		mlxsw_sp_fid_family_unregister(mlxsw_sp, fid_family);
 	}
 	kfree(fid_core->port_fid_mappings);
-- 
2.36.1

