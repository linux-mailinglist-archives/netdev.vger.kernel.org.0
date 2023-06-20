Return-Path: <netdev+bounces-12249-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28F1E736E2F
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 16:00:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8F57281308
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63AF716437;
	Tue, 20 Jun 2023 13:57:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50ACA174EA
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:57:31 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2066.outbound.protection.outlook.com [40.107.102.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E119DA4;
	Tue, 20 Jun 2023 06:57:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBFmrsfIECsJDfM113wB7yzewUkRcHBxPrS1iqsPal+bjPTssqhhXz8MBolD1GSPod8hTFGS7QAlpgmJ34t4kx7bP9cyNr3hJoobCj264VBV1yUiM+cQsUQeQjxOL388kmylKnWiUM6MjC6n6kjb/CWgGcB7ro96OqJ5WGKd22i2U/YufwgGDNTdm5F5wRm25Sybrivm/6tUTAU7xb/W5cioSKXuuDstkVubib82kme/A37L7K+hys2v0WuUyNpSOiiz9ku6hss4y/1a6Kr3y4kCNA7uLwnCaELFvRPsWQRxQD+GoSXVlEbJW/EcOhX4dyLNqT/UJnqWUSBs+s0q7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PrLXOLIa21/7LSYoBEbpTQBTJbebgsyHlK5SWfURaiw=;
 b=A5wZrl/fqcmgXj4MfvdCxsAwKpOKgWEDUQ8nSJY8sYLTcNc6A/XsI1LqU9ljhooOBtHxM4Aqrcz8EVP9dWh0Ul3+/7CXNxEZvcnBmbCis5TzAymwTs9m5ZHvpHv06MUbq9akbioD3HrZ0H6IaclVqIs9DYh610HuPK+mBKc4I1n7GMFYRMrJtdk7+lG/i/Qj+2nG1xqL1GcFNEhDNILv3oe6G6139Q8OkBVOO2f9Kz9cgY1X2JYQU61kOHb4awLCnPcp/7QF+XyXQjPDPOy/1D7zKwENuOUnwtGBQqn2mOYVdwMDVXDa8ZNc1pIYlUjcvHGZ7EAP1R9EjozkTaqOMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PrLXOLIa21/7LSYoBEbpTQBTJbebgsyHlK5SWfURaiw=;
 b=pnF52Xwcvk7aCugw5u9WgCFtx+0OGS4z1THwAkd7HkZYVfr75KaU2KJ+ngr34du/17tFfEoM7UgBhK21IWsMALR8pyMEhYQJZmD/pCLM260emshcM7BhqAEbv52nx3ugJ4XqfDlW7KjjN5K01hmqbEcNxE/UwFmzMYt5DpTqvDMiQZRd1q1iVgoYRQS27CtukGlduGMeW2uBRK/sn3pP/6o+fhBHtK7tGh3RkF3Zw0uN9pIg2ETM6vBJ8YNMmmuX/0s2imgUOKLIt/eTPR1zAO7Gxxg/y11bGhJBaT6AOoEsZTtm+EgzImz2ojiF+XO7cZJ6ARuN8K6pPvmVXzR5VQ==
Received: from BN6PR17CA0059.namprd17.prod.outlook.com (2603:10b6:405:75::48)
 by SA1PR12MB8142.namprd12.prod.outlook.com (2603:10b6:806:334::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 13:57:26 +0000
Received: from BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::d7) by BN6PR17CA0059.outlook.office365.com
 (2603:10b6:405:75::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37 via Frontend
 Transport; Tue, 20 Jun 2023 13:57:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT014.mail.protection.outlook.com (10.13.177.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37 via Frontend Transport; Tue, 20 Jun 2023 13:57:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 20 Jun 2023
 06:57:14 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 20 Jun 2023 06:57:09 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
	<mlxsw@nvidia.com>
Subject: [PATCH net-next 12/16] selftests: mlxsw: qos_ets_strict: Disable IPv6 autogen on bridges
Date: Tue, 20 Jun 2023 15:55:58 +0200
Message-ID: <4d3ff23c988dbeb9c8eda27bcd71e776b35f2b16.1687265905.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT014:EE_|SA1PR12MB8142:EE_
X-MS-Office365-Filtering-Correlation-Id: f479c0b5-4dd1-4e99-6922-08db719647d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fscQVTOimRDDTkZMgCNMVKmKT37VsH87PBKIwNYPkqLlNWpVh9FyWz9q8b73zJ3TRq7/BWwZO1HrAFe9VrwNCGevYUdLJP7X6OJNBv7843oqdqG5nyLyx4+7kt+djOUkiaaGuMKgFZFlfjS6d9w7GsLvXWR4nvZcqDjkzhdgklQW55J0qi5VqS/BzWw6Yz08Q/ibr02Lmad4lJkgWqlrw7psCweulcsiLX9QFsrbVUFoALe41MIm/jH4tmmoJIbXIP81U+cmcm3H3x3QvibSpXCHMWRRhjAp46dJu/peDNTwPERRp2LnzWsxya3kWcEbk2aF/+1LArc50ftGzOA3j8HPBsy4xItoJAzSX3pxRhaGHhw7OtdosMP7HxN/+ampqJEwcuVV0k7zGAsWCkY5YQWFhZNJ3qs5rlXrOyDyx87R9JtGO02e0bx3NtNyeKmJg/DOr5C21h4kYHkx8AiiZrRAI03f7o8C6lD2z2qbaewG0r8le+DJitjP27uexnHw60W1ULzJ76hABA05TbXjSn+3cNY6ExifBvbzZSJriSAMXJdanIjmy9mNKo6UNAlt0nxB0bQSYVm/eYfDzeDY296ugQ6IH3JldaCzahVYiiKe3lS57lVLxzlzVUqORdi4yNVG77m0yZ4JVkDfNFyiUjl0yDaGco5vBM7uGFHcdnB8CXDyyRRY2SInRvOchDbLGIK3ugtmTB7XS5th+Hrn4E/BQEvtgjKyotUOKPXajIQ=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(346002)(376002)(451199021)(36840700001)(40470700004)(46966006)(82310400005)(36860700001)(36756003)(70206006)(356005)(40460700003)(5660300002)(8936002)(8676002)(41300700001)(86362001)(7636003)(4326008)(40480700001)(316002)(70586007)(82740400003)(107886003)(426003)(47076005)(66574015)(186003)(16526019)(2906002)(7696005)(478600001)(2616005)(26005)(83380400001)(336012)(54906003)(110136005)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 13:57:26.5489
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f479c0b5-4dd1-4e99-6922-08db719647d9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8142
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In a future patch, mlxsw will start adding RIFs to uppers of front panel
port netdevices, if they have an IP address.

At the time that the front panel port is enslaved to the bridge (this holds
for both bridges used here), the bridge MAC address does not have the same
prefix as other interfaces in the system. On Nvidia Spectrum-1 machines all
the RIFs have to have the same 38-bit MAC address prefix. Since the bridge
does not obey this limitation, the RIF cannot be created, and the
enslavement attempt is vetoed on the grounds of the configuration not being
offloadable.

The selftest itself however checks traffic prioritization and scheduling,
and the bridges serve for their L2 forwarding capabilities, and do not need
to participate in routing traffic. The IP addresses or the RIFs are
irrelevant.

Fix by disabling automatic IPv6 address generation for the HW-offloaded
bridges in this selftest, thus exempting them from mlxsw router attention.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
---
 .../testing/selftests/drivers/net/mlxsw/qos_ets_strict.sh | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_ets_strict.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_ets_strict.sh
index 690d8daa71b4..fee74f215cec 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_ets_strict.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_ets_strict.sh
@@ -138,11 +138,15 @@ switch_create()
 	vlan_create $swp3 111
 	vlan_create $swp3 222
 
-	ip link add name br111 up type bridge vlan_filtering 0
+	ip link add name br111 type bridge vlan_filtering 0
+	ip link set dev br111 addrgenmode none
+	ip link set dev br111 up
 	ip link set dev $swp1.111 master br111
 	ip link set dev $swp3.111 master br111
 
-	ip link add name br222 up type bridge vlan_filtering 0
+	ip link add name br222 type bridge vlan_filtering 0
+	ip link set dev br222 addrgenmode none
+	ip link set dev br222 up
 	ip link set dev $swp2.222 master br222
 	ip link set dev $swp3.222 master br222
 
-- 
2.40.1


