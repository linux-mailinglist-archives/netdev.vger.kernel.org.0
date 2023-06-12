Return-Path: <netdev+bounces-10171-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B681C72CA38
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:34:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E79EF1C20A2B
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:33:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4E5C200D0;
	Mon, 12 Jun 2023 15:32:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81671DDC6
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:32:04 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16419E62
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:32:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mpu6Ja3omL3WgqDZdqNg2zOW23XBXGLUuVYTONmUdjUefioklS7wkybI+I6SemCKTY9F2xXC7Twj8ZOXGXvQ9K8TqDAEMexbI76/ZWFjTmDGxLx/VwFKIWZjnJJjYQ/GMaHsjeDkz82ztM1LVXvZbZ75quiAVGifqx41ZtvPw3fz99QDoKZ1T8LFO0jx1s7rsqEkkadykoGw74o+emqCCttVIAI8/AaRUK95oC7QON3KmVned7/HHtURWQN+8t97diQ8R1ZU9FJQSS0R0AoJeNO3QHPJ6GlTYs661dN4gfgbVtPx9zWH36h37D/eDXH1FLThpGxRn+2DEyerzX02jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i9ORrg/AkFTMt1pXuRdCQJqAqa+CYEDf4YK+iCmTfOA=;
 b=ZmSBf2PdrVO+f6p+AFN/nU1P3jXtTKOcT2cXe8kNGxLIjgvF5AQt/tHeGUSTJCtlndPt8pEicC8z8Ah5gdzI8ebsstQIWwmX20vJJJvAs6Xig8mtqBpubuPzuiydIe2DBIBM3obXDM8bm4hkF6NT4KRDMzp/ZAbhqOXmyjROsahbkv5dmWaq9o5M5DLEj3XbamL3PWpnnOzjYJ5/0fsYKtzSgHyQyp+hz3kx2wv+Vik+X06iV0bm05Sv1ov1B5i1Hj2O8xPoNbeuXCwPwPcuS5Q+aTeg8BUiiuBVjyNd7vzPQRnfcRpKBJtAXL1qE2fDR1TAzPT8pxErCtyJNaY7ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i9ORrg/AkFTMt1pXuRdCQJqAqa+CYEDf4YK+iCmTfOA=;
 b=qb6RuSBLDri36Pzy4Z4oOwCI/ZfadQhx173PGcDWhjBVhprX4yqT2qRasUM4U5zg7euiTOzWUCSsXnJ7am4vgrHQviM12rXKvMlPd0BF9AN92NPKDqHErXxmHVxh4ihrmqoIwxlAZMQf1KiIcJR0qPC2+aQS5m6Zw6GcLkZl2BcLqWsOggtgUZINHliYWTA5i1mdyhAkPbpU6YDAORn7UDQm2Zmu+dev2bG1zz5q0NzQH5JFbLVxJbL2zHwHwqX99j3CPN8mJM1wZDjhZT6mXLaInvzGUsQRz+xNcgNNlobfRVO3dk9r9ecimewsFvMfCkoQ+TWGzxNy6eamk5bXjw==
Received: from BN9PR03CA0095.namprd03.prod.outlook.com (2603:10b6:408:fd::10)
 by CH3PR12MB8459.namprd12.prod.outlook.com (2603:10b6:610:139::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 12 Jun
 2023 15:32:01 +0000
Received: from BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::a7) by BN9PR03CA0095.outlook.office365.com
 (2603:10b6:408:fd::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 15:32:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT075.mail.protection.outlook.com (10.13.176.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.29 via Frontend Transport; Mon, 12 Jun 2023 15:32:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 12 Jun 2023
 08:31:43 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 12 Jun 2023 08:31:41 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 08/10] mlxsw: spectrum_router: Add a helper to check if netdev has addresses
Date: Mon, 12 Jun 2023 17:31:07 +0200
Message-ID: <2be643ecf516f3d29722cf88f8df930cb48bbc15.1686581444.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1686581444.git.petrm@nvidia.com>
References: <cover.1686581444.git.petrm@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT075:EE_|CH3PR12MB8459:EE_
X-MS-Office365-Filtering-Correlation-Id: e7aef02c-f7c5-45b2-c918-08db6b5a2ac8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	PNBj3YuxUSJgFHsxFw/pGP2eOYwbwJrByxNuObwrsjoGdmN1I2jpmxO6j/crHmLNO7/nZvacY+o8d182xZ5eZBUz8+ag0UEFlteOMcl//jPo/3firIn0sMCaBw7yUJRfFxbGC0Mz1gW7376uirTohGY4rB9GifvcWh4sfxu5vEF58wnv2ep7kQO5KfgdoAEav0QQ+jmZgMljJ53Wz4b+SUfDn2A+5SR+05J0wP6gmuD8VRAekQ/cavrE5lxFosDF62izycyxAkMfb/a8EzFO49QXqhMQX4kp1Z1IHuVJkqLcUiN2/st/DceoD10Zao5BKnzNztbCLa2jLATtjb+wGjoxpOLDUZtHuTXaOnsCU/l4G0C/1zBSJwZLtm8J/vhsJ7qq84valGUTjF65fvgPzBHpa0IciAcnli+L+cA6noajWmOuIs3SlqTqkFa8L8x/LlI0E065tb7ne0+crIbKGiCZv5RtBZOrP9vxDYnTguRyxIwHkwwaJv8WVZPC+BNjnct6Nm3DGw00f/WvmI54HkEXU4WGMCK5D9DLbaeAy786KrANUPcHXaCEHK0mySIOM53/oFbMPQxzrb0OqrQ/c7Dulm/JcKqo1fqP4pbWn+dN+j/af7EhPLWwsFevRcIvugVhNv+GjHU2+m0Cx7Gh4ZDjm73MmkMY0Cyfe5jQG2n1PGcMUC3wXO1ylo1zbtaBzy50PZcp1mmFx5XqiFs4cU260I+QCT32H8u7dKUf4KQ=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(376002)(39860400002)(451199021)(36840700001)(46966006)(40470700004)(41300700001)(8676002)(4326008)(8936002)(70206006)(70586007)(5660300002)(40480700001)(110136005)(316002)(54906003)(2906002)(40460700003)(82740400003)(356005)(26005)(186003)(86362001)(16526019)(107886003)(36756003)(7636003)(7696005)(478600001)(36860700001)(2616005)(426003)(47076005)(6666004)(83380400001)(82310400005)(336012)(66574015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 15:32:01.0056
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7aef02c-f7c5-45b2-c918-08db6b5a2ac8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8459
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This function will be useful later as the driver will need to retroactively
create RIFs for new uppers with addresses.

Add another helper that assumes RCU lock, and restructure the code to
skip the IPv6 branch not through conditioning on the addr_list_empty
variable, but by directly returning the result value. This makes the skip
more obvious than it previously was.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 44 +++++++++++++------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 1e05ecd29c8d..25dbddabd91e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -7794,28 +7794,44 @@ static void mlxsw_sp_router_rif_gone_sync(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_neigh_rif_gone_sync(mlxsw_sp, rif);
 }
 
-static bool
-mlxsw_sp_rif_should_config(struct mlxsw_sp_rif *rif, struct net_device *dev,
-			   unsigned long event)
+static bool __mlxsw_sp_dev_addr_list_empty(const struct net_device *dev)
 {
 	struct inet6_dev *inet6_dev;
-	bool addr_list_empty = true;
 	struct in_device *idev;
 
+	idev = __in_dev_get_rcu(dev);
+	if (idev && idev->ifa_list)
+		return false;
+
+	inet6_dev = __in6_dev_get(dev);
+	if (inet6_dev && !list_empty(&inet6_dev->addr_list))
+		return false;
+
+	return true;
+}
+
+static bool mlxsw_sp_dev_addr_list_empty(const struct net_device *dev)
+{
+	bool addr_list_empty;
+
+	rcu_read_lock();
+	addr_list_empty = __mlxsw_sp_dev_addr_list_empty(dev);
+	rcu_read_unlock();
+
+	return addr_list_empty;
+}
+
+static bool
+mlxsw_sp_rif_should_config(struct mlxsw_sp_rif *rif, struct net_device *dev,
+			   unsigned long event)
+{
+	bool addr_list_empty;
+
 	switch (event) {
 	case NETDEV_UP:
 		return rif == NULL;
 	case NETDEV_DOWN:
-		rcu_read_lock();
-		idev = __in_dev_get_rcu(dev);
-		if (idev && idev->ifa_list)
-			addr_list_empty = false;
-
-		inet6_dev = __in6_dev_get(dev);
-		if (addr_list_empty && inet6_dev &&
-		    !list_empty(&inet6_dev->addr_list))
-			addr_list_empty = false;
-		rcu_read_unlock();
+		addr_list_empty = mlxsw_sp_dev_addr_list_empty(dev);
 
 		/* macvlans do not have a RIF, but rather piggy back on the
 		 * RIF of their lower device.
-- 
2.40.1


