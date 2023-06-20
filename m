Return-Path: <netdev+bounces-12247-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21F75736E23
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 15:59:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5304B1C20C56
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:59:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2914D171AD;
	Tue, 20 Jun 2023 13:57:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB98174CF
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:57:22 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE32D3;
	Tue, 20 Jun 2023 06:57:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BI7RnhZ3ghYZCjrABTy/xXI+vsvH9oOJX+9MDjLEj3AXrgD/Z9YVNfpnumwDGgjhzpFQoCH7o8/s7EPc78sXZCdC60Ry4OCHpbHlIjZssdeBnB8VRt2/GtZq4LpXlHXph0Du6m8NbFMsw+AIS2zAq78KBf0NTKq6BnsyF9yqdU9058nyndEgygB/OwjjYjyjJj/sS/F7hCZaF5ARV4+slJofMD6sv+cIxR5HLvAuC7qcZjexx6Rvda+4Hsx8mFxQxQ8rdFj48/hF0AEIyrrdJeXL0TlBXBD+ojHv72k/H5SQZdQaU+wf2PwDlyj1ruiYYgPu7jws0H62zAXTHqAyzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oNKSLNR+laZ6F2+Kc3jaKGaBStDoRaJj5CTLMD951IA=;
 b=Zu6cOsZITzeGAjRzp6jUhLeMwxMeORGZea82p/EfVuVmFKADiXDfdZ+KQKJWLNbUVqcikF2T8RSdBL7mSdBxNoDswkClDOGR5nqy57O8Cn71iyHousuBBNv5DbtsQXYN3GP/64DLpwCrGw9gcHYgTPLto3P51zIFemjBBpgUPxaf2JxV7O/dypnvw8O5puPU2bPNt8fBpcdj9YQRj7jqIt+r1Lk2/a+PUf4eHmaIgxinLfy5hkCtJjPkWGg3VUT0iCebqQsdJWCsxRtb1ii6o72xuVGDdmNTa47+KV/BGOoAIQUJ92hudDA5LGYGcAi4isbQrlCVKgCRfbKH3gSfjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oNKSLNR+laZ6F2+Kc3jaKGaBStDoRaJj5CTLMD951IA=;
 b=iW+FUeLyf2Q1BUboIeFjOotSb5Mnp7lnck05djqsGTZaKxhfrlZLxcMHozT70mpLFnbpHsniqzHLLjw4SYNvUD4d0hWA4Exhm129Pdxc6pexuMEbb+z7nfSodL71jDpyN7xPEWfVnSdV8bJPkLes3yeeD/zckXqDjdyGJDnz0/KZaeOtUPcZisesk4rgDKfDzizFx+udWqIwfJD1Ypmc1ilHYImHkPdCjtVLhedpku6Ew9p+lUxFbUxuNLAFxTuuVJR3e2BaChgerGmYNK37yj6Zhm86wPsC+Y0NJqZV2j5uNcUKe9xO3ME2BilfG68zCxzmGKWjwd+8mzNEhhFTLA==
Received: from BN0PR08CA0003.namprd08.prod.outlook.com (2603:10b6:408:142::19)
 by MN0PR12MB6080.namprd12.prod.outlook.com (2603:10b6:208:3c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Tue, 20 Jun
 2023 13:57:17 +0000
Received: from BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::92) by BN0PR08CA0003.outlook.office365.com
 (2603:10b6:408:142::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37 via Frontend
 Transport; Tue, 20 Jun 2023 13:57:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT043.mail.protection.outlook.com (10.13.177.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37 via Frontend Transport; Tue, 20 Jun 2023 13:57:17 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 20 Jun 2023
 06:57:05 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 20 Jun 2023 06:57:01 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
	<mlxsw@nvidia.com>
Subject: [PATCH net-next 10/16] selftests: mlxsw: mirror_gre_scale: Disable IPv6 autogen on a bridge
Date: Tue, 20 Jun 2023 15:55:56 +0200
Message-ID: <37694704013f9640c27c3cb7d9296f4bd213473f.1687265905.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1687265905.git.petrm@nvidia.com>
References: <cover.1687265905.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT043:EE_|MN0PR12MB6080:EE_
X-MS-Office365-Filtering-Correlation-Id: 4316381b-3a04-4274-beaa-08db7196423e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	053UANxsOw+rYprq40yV/Fvta4vKCmBdB5sRSuDBm8cVplfvaqXyjPZBlJvEEsH0TzC+QFQnS2P4l8IsO2swqw8uMXFG1Xe1PhZDoWP0HpH0KT1xt+nZ57ALqsQVKye1vz2/gk6cK/T9gx7r8ZZU0dj7bSalHGpRgFgGRZd0ySjz0BKyLRBeBjZ6Nnlbq1zA+2fqxG70E41McNKIwZuoF8neoShN3j/72qZBroHQCb/tdg2WXjWy8wTSVessmxqx90IGJ6sPc32L0tJiSKt3+gKFXImnXbTveKJnEn8e3Bhq7DthMnnfv/dLtbXtSw4yJTZ3cm/Stpohvu99RyXZNEyxZhCr2IeiEYgKUKZEJGQPaNMN+DIEuH4PPeGY3PTcDcgaq5MZeMzE1RuZWfB3C/wsrmQQ8/uxQpVyumQzOjtyPYRcSMiV2JStRWf1gVCr45PF6jUXKYprdhe9OIBOjh1AwqJboUJs12tH5+5wDVwvKnrJ24p/v7n/b4KXQMoPyRajGp5dRJ2VeGyb4X/4v6I7CuPFky2t9kLyHVyBnJPRwqTJSNjlgUhwXvHUrnveYceRfLZmNdxQ+ZLLIA2yUn4IKgL+oUVjHCAm6W2M9lQNHcXJOkoDyjFNUVvUuWshCSwGbSVWtVFQGfxFMj7s6XPF0KBEYBhg9APEnKKLoYDCIkm2ZRTRykZJfQ8qfp9by91zgvNpB5haJ7npVPxo4KJoB4MMc+iQjyuL7RxXiL2fbHGxmiA6CofFJmQdqs2t
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(136003)(346002)(451199021)(36840700001)(46966006)(40470700004)(82310400005)(36860700001)(36756003)(40460700003)(70206006)(356005)(5660300002)(8936002)(8676002)(41300700001)(86362001)(4326008)(40480700001)(316002)(82740400003)(70586007)(7636003)(107886003)(426003)(47076005)(66574015)(26005)(186003)(16526019)(2906002)(2616005)(7696005)(478600001)(6666004)(83380400001)(336012)(54906003)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 13:57:17.1467
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4316381b-3a04-4274-beaa-08db7196423e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6080
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In a future patch, mlxsw will start adding RIFs to uppers of front panel
port netdevices, if they have an IP address.

At the time that the front panel port is enslaved to the bridge, the bridge
MAC address does not have the same prefix as other interfaces in the
system. On Nvidia Spectrum-1 machines all the RIFs have to have the same
38-bit MAC address prefix. Since the bridge does not obey this limitation,
the RIF cannot be created, and the enslavement attempt is vetoed on the
grounds of the configuration not being offloadable.

The selftest itself however checks how many mirroring sessions a machine is
capable of offloading. The IP address or the RIF are irrelevant.

Fix by disabling automatic IPv6 address generation for the HW-offloaded
bridge in this selftest, thus exempting it from mlxsw router attention.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
---
 tools/testing/selftests/drivers/net/mlxsw/mirror_gre_scale.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/mirror_gre_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/mirror_gre_scale.sh
index e00435753008..e5589e2fca85 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/mirror_gre_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/mirror_gre_scale.sh
@@ -165,6 +165,7 @@ mirror_gre_setup_prepare()
 	simple_if_init $h3
 
 	ip link add name br1 type bridge vlan_filtering 1
+	ip link set dev br1 addrgenmode none
 	ip link set dev br1 up
 
 	ip link set dev $swp1 master br1
-- 
2.40.1


