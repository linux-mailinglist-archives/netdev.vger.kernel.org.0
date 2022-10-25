Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8629E60C978
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiJYKJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiJYKIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:08:19 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6009B3C153
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:01:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PALKbzLC5cWTGojXyZr4QwPYgFUWWkXONI8akGPDY4kKnFvgIyxvIpgj+0OnOV4wsWMBs+Hnj0rxIeIUjPS+dK10HjJWo2BT9JYszv4daksAF4kNa1Kr9apiki3pb7xQXv951nSYCra/c3kYW9TnKz4ZbLtykGCOd1R0Ph5JMdfYN+ogsllxz1NCWL126HDs4nkk34u87xvBmN/O2cmCk7184VdIKBbn1YvB1NXXph9wydFIUfxdOPbBxoTETQz+HV3pM0RJn4cFkGS/tjfiZtIF3Qp1KaoUQQD8wspM4alHiIBMcs27FHjUvaX36TgVg6GPdA7lsiCRyN/S/nDAbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PsV18BrJn9vQpbGDxMjhLUxMsklefycCVDYIiYRc1X8=;
 b=Isd7OUPjw2euyNOvxdxgTAe8SyzjRXgBUuA35wu4PXwEnJRa3YQY3fJqkIwd2XWZ50lwZOUf5MC3ul56PqqMyi42IVe0/3bTqbWC2YPfEj+eAAF+wQnUuTIcnHFWn1cY26QNUSgfkVsutjk5lFjTmi1W+Qn8BIkSLmAw/+IIIy7gCt3Zo63f1EKuGmYzguImBG0NTmbHYsNF6FQJswgsoRK79ueXYF5JG/fifwiXxqI0bCSP25dkTExMl6mssNAxrKrvToJtHzerHZxMrfPy5LXFLNHU8XcWpPLL2jXSlwKIqWQwVu8tZsc82reiOhRuME2zsj0G9t7knXyPoMNlfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PsV18BrJn9vQpbGDxMjhLUxMsklefycCVDYIiYRc1X8=;
 b=kop5zsxRD5QomdgzipbqsZsU4d+AgI1h/xkYLA+lmljnmg7fSRprwux/WNL73csWBcj9om+CwuXHMMydeVlyk4wye/axd4Xq7snkgPa8UuoZEiYbWgPwA/I3GF0n3B3I0lx0vYkOApZQ5eDCPg5/mE3m0x9xdWN4tDClkvB7C7lIijX52+unBJRfOrSrm3TSR/QQ5A4hDHxOpJgXG4hRafP96xSIIeJ8eAQFEUJfF0yUO04TXvNj2ct5+A1VW4EUiENVhmiKm7fO4rDwmamZsZCfEiJVG0+y9LtuaIXEmOl7FXs0Q9PKezheGKFALmVBoiGVuQl9qWrJlsCZ59B86g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 10:01:43 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 10:01:43 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, petrm@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 08/16] mlxsw: spectrum: Add an API to configure security checks
Date:   Tue, 25 Oct 2022 13:00:16 +0300
Message-Id: <20221025100024.1287157-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025100024.1287157-1-idosch@nvidia.com>
References: <20221025100024.1287157-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0206.eurprd08.prod.outlook.com
 (2603:10a6:802:15::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MN2PR12MB4270:EE_
X-MS-Office365-Filtering-Correlation-Id: 89422db3-79ff-4bf7-58f1-08dab66feb27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MJQ3IHY8YHmjRDU335kZxamjlkQWQ651pFoZ+hRDreacNgMX6TRQVz79+mSqW3lsaJJX9NR3+c1YIzEZya5zEhPTSBf+sceiuuJXY1ZQGh57ZVachZcOH1ChCNNjt/cJ7FPfZ/5GOvjhqlHXUHzYwoW4vqXtZWe2xb/ACM+kVRD0lulbaq8eFQFwxkBG2mjcrLgveHMvkErshRNr/9QGbORb8tmbt3tmZqGRjiRDdLRwkE9ydNB6C1G3qnFxWbwhOhgxY6ZyPMHADeFhHjQNg78yGwQBW7Glvtv+fPvnNDO04+a+f+BlfNwdRzKLI/FlNkyhjZDhTAP568ST/nx1YTM02lipkqV6LgTxJvTWWgkHYtH+JUsamo0vfwhOhmcYXvSWhdcQPNiwUUG1ISo7WaCF6UvDGVz4inkd5x2ORv0dxuQGv3sAgkR7UW9Ls+ju45q6ReSSsBOLY+1xzJM6tQJY930cm0h4wRYhc+mc4KuR1J7sLPP038qbk8c29cm5ec+kypBc/AM4rP/9EJqo5PNrJ5sZF62/u9mSvDuNv1ppJs9mABiibx9xzoqbib9tLoq/3xwwgykGSt7+SJK4b4x9z2895N4s8sjUNWJUHjcUy3/WJnldKYOvzEA7htVbJ/UzB3TByJZkdZ2oFYss76ZhXBAWzfT/w5mfzDkAShoq7ec1qmo8ZBsU8yhzmbMa6S9/ChB2Al2eNasm9P8KIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(451199015)(36756003)(5660300002)(66476007)(66556008)(66946007)(7416002)(38100700002)(8936002)(83380400001)(86362001)(316002)(186003)(2616005)(1076003)(26005)(6512007)(6486002)(478600001)(2906002)(8676002)(41300700001)(4326008)(6506007)(6666004)(107886003)(15650500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1L3LYYV52gF6x0wIjn9Qqitebs8AEU6gtIdU/6rdtMoA33r4E0EzmIax71RC?=
 =?us-ascii?Q?ISuvV2Dp62iYYVmfcp/soCJnM8RyKIc+p7tOXtVUL0px0DonCiU7Crf2+Lq0?=
 =?us-ascii?Q?GxrIaZ+AK9DDPMCVRvD8QbbDdVTU+FtUt20bIJb/S+1JFoiUgb1PVPT3nPJc?=
 =?us-ascii?Q?wATyR9ZMyj4hj0moh/zsYumMmWwiaSsdsUeqvncmEHvqoeYzPM8RsxSpkwHy?=
 =?us-ascii?Q?497nstRq8clQ9m3slfyWibrHaqlCRZBGiRXzkBdvHEd8MmRdhxT6omgk0W8s?=
 =?us-ascii?Q?1DESZcyYNhb4XTXN9eQ17BlBeAVVpocIfPPsnYiP1DuOQrUykmjaYUdBga8K?=
 =?us-ascii?Q?WUusb2r34ex8PTUGOcbDdmBiYzAC2XYuAJWYywY1q91jx1ElhHUvvw9ylbGI?=
 =?us-ascii?Q?e5AFM0sPywfJmVWaUUMPSa+5pCxfocG/JTqeH5lJKDZ13pQAVkTXzW3m0V7s?=
 =?us-ascii?Q?hPefr/ekGusuq6n2/E4mASTQnSQTZn/lb4K+2hu4YmHRHWaUWmQ8gGzqG+/F?=
 =?us-ascii?Q?Z83sZgc/56SNbBWnGO+JJRcl7rZ/tNhZyiXUxglwlhul4koUeeNXtrrRwL1a?=
 =?us-ascii?Q?znd1Vd2/aVfsdQXSpyR+EcEniCwKQeDKQL+hC7my7NVv3AAbt7j9FunWQFE6?=
 =?us-ascii?Q?LqKkrvc7UkxhaN0sZSv/xOWwM+EO6/toYlE8qbEXxELzI+TWg99e8c5pAtyH?=
 =?us-ascii?Q?cHK6gVHc9NN7PCCmc5RjiVxIMUtWiJfiOO6KpXLxtccCYTpvHNWVBAH4Q4Nh?=
 =?us-ascii?Q?mjgtEQRoGpF3xwSyMPUwkCKX7BXtOkPltdzcelmp+S6KN/UZypY27g9y1I5M?=
 =?us-ascii?Q?jZqK4/ma8dlYqffWmj8SkpKpyNWR1ruOU8w2K4HttqqcjXQSAfH1K7O57lbl?=
 =?us-ascii?Q?sHC4pM8TjtCBEKhMYFLuGFWI0O87FSrwonaMgrhu6OWvqAiyqmTyREhrnSwA?=
 =?us-ascii?Q?/mmzjpe0tReuLmtcO7Bmo2GL+peeV8JqNrt8QpPKfdazuHoPHCE7Lw8pzR4Q?=
 =?us-ascii?Q?6bZ4qlOdOTHCFKvbEqVPghzWmRs8YHvpJwhIio51FQP6DgDEKdTWrvvO20WY?=
 =?us-ascii?Q?x+idipEHV0G7Hqo6WaPLbjo3L08zLc8vI11GuTILjeGreQJyFSPNK62zuk4u?=
 =?us-ascii?Q?Kyte6RvYPdJ/26pwwX6O1VOpnSnG8fe2cAvTw43bo9VjoAuztjqZ4LgR80Ra?=
 =?us-ascii?Q?Xxqtbcg19IfSBvMOE41NIET0tl3T5KkKk9tooSLpxmDtxkfOPLaZNhdKz0OB?=
 =?us-ascii?Q?X7CH/sQ2Sdu0DLPcOPujB7r0uxg4J9D5yNwsnpW+p7gaT1cZ6J60pn480Q35?=
 =?us-ascii?Q?rHVFi1XSKvMlaPFd3ZE0Ya/qKRLg/8bImWuJlEvEFN1OQi0FsjS5NAqOcNIk?=
 =?us-ascii?Q?S9oamob3GK5zdTKMg6XHkxcRw8c2ot135YMfOcf6gMIlj7sRZwaixqO7eq8n?=
 =?us-ascii?Q?kNEansxl6s9ve8j1fw0hXwflnDBLBaP/EeijDpIY2EvbqfPr9j8XV5zwrYPZ?=
 =?us-ascii?Q?rqq2jkAzcIxQMy8hQ7Gh2tkjHfq6wMy0JIqYhjCYMJt+ey2rqoKfNKBignKo?=
 =?us-ascii?Q?fjkyi7ZiPVOqBV/bpBiIirwh0JJhO8nXHX+k+tSy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89422db3-79ff-4bf7-58f1-08dab66feb27
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 10:01:43.0445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QUF5u2WKS7BAQFVJFoFYRiBHcvsxL+skScMogooZEcjTmFYv7ZN2RfUKqLpgZHdwVaaRrKEuQOUJdzR7W7F1EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4270
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an API to enable or disable security checks on a local port. It will
be used by subsequent patches when the 'BR_PORT_LOCKED' flag is toggled.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 18 ++++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h |  5 ++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 5bcf5bceff71..10f438bc83dd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -466,6 +466,24 @@ int mlxsw_sp_port_vid_learning_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid,
 	return err;
 }
 
+int mlxsw_sp_port_security_set(struct mlxsw_sp_port *mlxsw_sp_port, bool enable)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	char spfsr_pl[MLXSW_REG_SPFSR_LEN];
+	int err;
+
+	if (mlxsw_sp_port->security == enable)
+		return 0;
+
+	mlxsw_reg_spfsr_pack(spfsr_pl, mlxsw_sp_port->local_port, enable);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(spfsr), spfsr_pl);
+	if (err)
+		return err;
+
+	mlxsw_sp_port->security = enable;
+	return 0;
+}
+
 int mlxsw_sp_ethtype_to_sver_type(u16 ethtype, u8 *p_sver_type)
 {
 	switch (ethtype) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index c8ff2a6d7e90..bbc73324451d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -321,7 +321,8 @@ struct mlxsw_sp_port {
 	struct mlxsw_sp *mlxsw_sp;
 	u16 local_port;
 	u8 lagged:1,
-	   split:1;
+	   split:1,
+	   security:1;
 	u16 pvid;
 	u16 lag_id;
 	struct {
@@ -687,6 +688,8 @@ int mlxsw_sp_port_vid_stp_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid,
 int mlxsw_sp_port_vp_mode_set(struct mlxsw_sp_port *mlxsw_sp_port, bool enable);
 int mlxsw_sp_port_vid_learning_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid,
 				   bool learn_enable);
+int mlxsw_sp_port_security_set(struct mlxsw_sp_port *mlxsw_sp_port,
+			       bool enable);
 int mlxsw_sp_ethtype_to_sver_type(u16 ethtype, u8 *p_sver_type);
 int mlxsw_sp_port_egress_ethtype_set(struct mlxsw_sp_port *mlxsw_sp_port,
 				     u16 ethtype);
-- 
2.37.3

