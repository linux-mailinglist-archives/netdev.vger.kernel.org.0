Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8499A50D7DC
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 05:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240818AbiDYDuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 23:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236822AbiDYDty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 23:49:54 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF42DE99
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 20:46:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aj8clBY1B/5Ahz5TdBx7AdtSrqV1KTmc5ydkBJbz1ewaLIbDAKGKZL0dOEKyuSUH1FJP+mdKhreVSnnBsWqXQU2y7O7mfHAP+07pnYJZQiWUWbiWrFu9Wa3LN7QvFGrHrc6QfFDgTt6NIOdI6zoxn04WgxYFByXzDr42p8laix0C4L6gTpnpnUj2T9csC2gf82/sOJ0brso1PA3em19WRLgu6W+Y2pN6twZYWSaPBzD68HhLx44U5dxmthyhhIFaEbcI3qgSDakn/dSSW0TWkOgXiNXdzA3RKz1U+nf5AZiN6o/Dr6p2n+APeT+WlU6rn1AgAQvJbDg/HVEWbsG4lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+4NoXsvHXpmEfxxC7ZIWqQpNjM7Ypxv8++LjHaLWJI0=;
 b=eYyl6CpdZrHPkj2m4QLZKpBZmuzY1zLqiMPn5JkrLzl8lfZuOGbjYCDj37cFIWdtq1Z0CrwRsueLl0SuCtYwbEFZP2LHGTVehP1bhCOUeiZZVXuNV+NSkLu5AMAMUAPHTlfpF2kKeG6NktrbUW07rF0UyNKGIIY+8cIIeG4nomlvQWFx1YhlaKTXTF4GzMQPM4ReYSXO60U9ZEpcUCnUN0mwCNF2OMk2ZHlTCViqp+3Te7vf2rN3X+TX9uNyv5gI5mYSTqm/PArk0flzeOq9bVyTD4oUCKMuxpPFxYSPmIDioSA/ZnDAv9iAxXJ/LbtK0lBfO6h2n/GSE7pnJ5Shpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+4NoXsvHXpmEfxxC7ZIWqQpNjM7Ypxv8++LjHaLWJI0=;
 b=tXR9qurDxkuTBMRiyOz7eCDfmRLt2sjwbhAx1im0dquOHl4+OABd95q6ao1U/TpGj5/lJDMSlfJ/Fup+Y0EcBhQ3NJA+6VTtZQ8rL/xvxqtwjy37HbFVRd0casAviHhvg+oifQLRNriWN/ipa1DpPTgk1KLH3Auc4bSOTRcCmoUNmdWAGYr3jcHUN1qY7McO7eD/S9b/3j7lOrLRiCiKVxByhpUdlLf+gUunYFF78wrQj9/OAIL5ZOVKrxNabAwEaGrqywvspDVJl5ysZBt3+kyVTq68ldhnoOQtVnFy2+8/7J3H8fgvR6jfBeJHYHSWEqWAZt4OUGK27KNALAImMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MW3PR12MB4521.namprd12.prod.outlook.com (2603:10b6:303:53::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Mon, 25 Apr
 2022 03:46:08 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%6]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 03:46:08 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/11] mlxsw: core_linecards: Expose HW revision and INI version
Date:   Mon, 25 Apr 2022 06:44:27 +0300
Message-Id: <20220425034431.3161260-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220425034431.3161260-1-idosch@nvidia.com>
References: <20220425034431.3161260-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0026.eurprd03.prod.outlook.com
 (2603:10a6:803:118::15) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 212829dd-ba35-41ba-87e7-08da266e2193
X-MS-TrafficTypeDiagnostic: MW3PR12MB4521:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB4521290076EEF6C3C04E74B7B2F89@MW3PR12MB4521.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jUhlPJYzuxXvE9KfbbYju+0sCzEOmLJRfmzRleOHJAUJEzsiebmqgMn2fKK0OQ2GPkki5RcdT4Er9W4gmeIOnAutx3XNQQWH5DPGsyPzeSbQdo6l88NhVMt07a5D1BC5bQhIJq3kGAVx9aQGuO7mrZW10zxIswivaagYSJOoUEWDYD/m1m2T+kyWFjbHdiYNX7hRCCcwegXd5FwYjCc54FtR3OYuaudtOuKbFVdJZtCCVuT2ISvqKuZSQVR2XqgfIeQlF8v4hkZ9rOO6kJR7bQjRoxJXuzbuA7OQyiw0jy7YZghhswBXpW4iUxaa2yKmM16dPjCyEr/SVuaDzkWSI+XieERlregS1aSE54MjsVyOwCJT6vGYW9uJ4yuTMk8SoG8LuPw5sXnIhL5afUmSnjxB27vWoD5qI3JOJ9cgNeSFZa1lQSORrNzJwz9HMH1J1SNtRmDtjJStusLsJ+nFFNo2BAsnuKLijgJ0jaeaLqe5JOuZrNBs59p5D+WwyU6EOn32rmxGxuxPO7SBR9DZkZ4vwejLPm3ifckbjWchCSlHZb4SmQTT2am6+CdacFtCMeH9X22sgSm0swPb8Ol9cUwHeUX8+CJQibBuPcg3fIRwQxHaIf6/bWZOifNZrQvBJ0ZdsxbiuScKqwGxg9tccg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(4326008)(66556008)(6666004)(2616005)(66946007)(6512007)(5660300002)(107886003)(8936002)(86362001)(2906002)(1076003)(38100700002)(508600001)(6486002)(316002)(66476007)(8676002)(83380400001)(6916009)(186003)(6506007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TLzBFlAxEZ/YnciBEOE7lKa8spjh+wP2v8dUuzjSzNJ4D9ElkVgGvGH03iI2?=
 =?us-ascii?Q?RAu07BFk9GU4x5cEb/3y9gu9+w940HKQQK3UqAZt8ujfnhK3Q0ksgoBw+zWS?=
 =?us-ascii?Q?ResYpAcLLsV1zCw6m2HpunWDh70P6UyS1GocTAtbGCqfEgmMQZ3xxC+ZVPe9?=
 =?us-ascii?Q?IfeaLVMOQPlZ76GxYB28PYDCv9fyFHY2Mocw/qLzaA6Wg/CpfLLM2EO28Eaj?=
 =?us-ascii?Q?or8R0x6vZtZLUBfzwAV+1tWh+DqEcs0NAsm/gnCaTsvuEz+7QcV4g9FXEWIU?=
 =?us-ascii?Q?verwj3XSOHyZuKMOIfxbFPCLbHZJy805qV3T2/2vawsDGU1MpS7eOYjz7q75?=
 =?us-ascii?Q?BCmdo0yvi7owtcgRDo93mvKHPd/P0O+tLJKr0Un9l97/DAGe0K/IbNAKTgfN?=
 =?us-ascii?Q?aFQ9Kl/8LmZ1Roo4cCCyjhMO0R9JBs38TnEbJLNF4vt15uOqSZ7F/KW7wuvD?=
 =?us-ascii?Q?1kZTKiOafjwWsDstEWD2A6/a2pbOcVRKFBlE0a7qBXl1/uABJi7CkcPZotda?=
 =?us-ascii?Q?6DfuxYxIbCWTesObBLJRaSrVBVdyR0yYrXEBLYgX5HtjwIovFMFDc/lnaOCa?=
 =?us-ascii?Q?FWnYRrUe+hlSQP4fzpvnZ46dUXVaqtlJxRsTrpD6tsut9PYJVYV7YEsUwbU/?=
 =?us-ascii?Q?IMsf2TkNXru4/DfHoVucb4/+PEWv3zAqq6DaTTyF2ezz+ibS9SG6YGvUrtbd?=
 =?us-ascii?Q?4Tc2AYRFthvDCV+es+8MtPdubcfoxcShD43gheilszJ+nrgpY2psJzgVpSzg?=
 =?us-ascii?Q?SCwSa2x9Bf2YjkuzyTyEMMBbIBGBuvKK4AmQw/0vgOUpIC/ER55kGGZ72AF6?=
 =?us-ascii?Q?Tq/DmmDH1n8GJybzatVr8iESUK38hAgRYa/sDnBxuNJG9+T0zFhYe1MBNLWq?=
 =?us-ascii?Q?9QOKMz6rGeuE6x9OTLrCs4DEVOrTRHzJyqM6mGGFoSaPr6kKgmvKqdg246/N?=
 =?us-ascii?Q?go8cBkE8vTyGjlOwxkqRsNATuO8ArITlrjvVFbiM3B/20YVVvdJ9FGkRhTPf?=
 =?us-ascii?Q?g1jaSPM+JVHdmEU1P1ZvTJ5gTcaXuwmEUBFW7f8zmXdjil0xFiOBjtWXAaCf?=
 =?us-ascii?Q?TTV7xgB3+fDtGwZRpg+e+3HgDu0z2C+7HHz6axez8dRHVgULQq6ZidVTQx9E?=
 =?us-ascii?Q?rMqkNINabLemypVIGoEaOK1///4kn03QKVxKZMAhPeeLshjEBLkQfwyVHwDa?=
 =?us-ascii?Q?D4uHT/q4lXuHfM0ed5VCbjqFs/IoIujXZKr+/axR1Lz5RRIqe8fsQ1Q/E0Ve?=
 =?us-ascii?Q?7DHUBf9UfmxKau3LdrIOnIY3yc5y08RBgKaqfGuHchDcwQXvtA3SUyMzXIeI?=
 =?us-ascii?Q?B/98PmZ6ywFme5T4K2mVpEK5ozb8y2Tsqmb+XhF1FJZUXIbn9/fdcWTi633o?=
 =?us-ascii?Q?jpf9OGTE+HrsS9yAQR4wlMkww2/gPCSh6LQCzeVCQD2SRUInnpPm4B8EcopS?=
 =?us-ascii?Q?MMBWk0R3bOfvweqaAO6Qw1BANwyEZPgNwFZrTT9YKtRyQRXp/ISNTEp028fA?=
 =?us-ascii?Q?AqpMuQL+vXQHzR2RIAssfOhUqH2kEh2jxYSDchgctlgBr70TnXkSijpCUew/?=
 =?us-ascii?Q?ftsTaZeAxv9259DJlFjnCYha0Efnk03ToPvu+s8G7jDw98zDCR4iS5HdLcHX?=
 =?us-ascii?Q?PxK80UP7YWX/S3PMCCOc1pSaXbZWk/khR1ufmEH6cp8+okWKCaz07fEGmGsG?=
 =?us-ascii?Q?ASd1GgWFl36cV2jVAtFwKm+9oSR1+Y1e8kZI2sNcribLG3fZ90iMySYJe0Xd?=
 =?us-ascii?Q?wxOrhlPrAg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 212829dd-ba35-41ba-87e7-08da266e2193
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 03:46:07.9327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dp7C6RDe0G4eGwTnIpEYe79hzVr3SydxxPZvqB9KfqVKmlEbkywYqaOt5akm3SeyQGfIlAIMLQn+08voSeKF2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4521
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Implement info_get() to expose HW revision of a linecard and loaded INI
version.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/devlink/mlxsw.rst    | 18 +++++++++++
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 31 +++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/Documentation/networking/devlink/mlxsw.rst b/Documentation/networking/devlink/mlxsw.rst
index cf857cb4ba8f..da1fbb265a11 100644
--- a/Documentation/networking/devlink/mlxsw.rst
+++ b/Documentation/networking/devlink/mlxsw.rst
@@ -58,6 +58,24 @@ The ``mlxsw`` driver reports the following versions
      - running
      - Three digit firmware version
 
+Line card info versions
+=======================
+
+The ``mlxsw`` driver reports the following versions for line cards
+
+.. list-table:: devlink line card info versions implemented
+   :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+   * - ``hw.revision``
+     - fixed
+     - The hardware revision for this line card
+   * - ``ini.version``
+     - running
+     - Version of line card INI loaded
+
 Driver-specific Traps
 =====================
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index 9dd8a56add4a..b5f5b31bd31e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -834,12 +834,43 @@ static void mlxsw_linecard_types_get(struct devlink_linecard *devlink_linecard,
 	*type_priv = ini_file;
 }
 
+static int
+mlxsw_linecard_info_get(struct devlink_linecard *devlink_linecard, void *priv,
+			struct devlink_info_req *req,
+			struct netlink_ext_ack *extack)
+{
+	struct mlxsw_linecard *linecard = priv;
+	char buf[32];
+	int err;
+
+	mutex_lock(&linecard->lock);
+	if (!linecard->provisioned) {
+		err = 0;
+		goto unlock;
+	}
+
+	sprintf(buf, "%d", linecard->hw_revision);
+	err = devlink_info_version_fixed_put(req, "hw.revision", buf);
+	if (err)
+		goto unlock;
+
+	sprintf(buf, "%d", linecard->ini_version);
+	err = devlink_info_version_running_put(req, "ini.version", buf);
+	if (err)
+		goto unlock;
+
+unlock:
+	mutex_unlock(&linecard->lock);
+	return err;
+}
+
 static const struct devlink_linecard_ops mlxsw_linecard_ops = {
 	.provision = mlxsw_linecard_provision,
 	.unprovision = mlxsw_linecard_unprovision,
 	.same_provision = mlxsw_linecard_same_provision,
 	.types_count = mlxsw_linecard_types_count,
 	.types_get = mlxsw_linecard_types_get,
+	.info_get = mlxsw_linecard_info_get,
 };
 
 struct mlxsw_linecard_status_event {
-- 
2.33.1

