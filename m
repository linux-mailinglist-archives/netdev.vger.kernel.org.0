Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D404959FE1D
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 17:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238155AbiHXPTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 11:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbiHXPTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 11:19:40 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2053.outbound.protection.outlook.com [40.107.96.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FD89834C
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 08:19:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fKPEzVHjYxC5cUGfRo92d9BtnZNlIoo64zlqWkJswSIrz1SVHyDohl13HhTrI1+m3YMmVeacCjejZI9V0b+pnClM/jOfWia3uN7I5H/mKTuuWQak9781H5CFvcl7s6ctbLmrzl9KvPD10cTslCqzVnYBp6XaGoUsckebjvZO5MRkiyx+4oJ6QPwsatFBARQybiaMtW63g5110t/hgrIFORBug7a/Okp2BPpRHasDnIW2ruqKXdIcD6Mpn9+ww+uh/OreXm9GZYegk6JUlIgu84z3wfxivqmZr1P8F3N78ReKzwH1Wc/XxxcyzR19OUT2dydTQ1LqkRZheiuENfG2Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CYk5GkeyD9ws6P3yjQD8Kw+zkRSg9+oa3vrBIFDl5xc=;
 b=Kr/qV7GUyrhKlSYxjeFS9gsqj6IdkIEj99XDUtT0ZZbvIXVKx0uj4WxRRR6wnhlPQg/Gp0L+E/eEzne7GxmK98be6ZienOBfJB//13UncfI5rFiwygng34mwKmIEMaQPrKCpWvJqjaY9MEvpnSI6JzRUlVUafK1HLtljFqQ5am6PM1VPr8G/3Yu1P21KB/ICuF5lzdQ+o1BkGKntPdTSjaFhe3MvSHmGK8OXo02lIpEAFkXF0cFQKUm513IbiEeQEQixk2TJ9aQhp+z2HRVMRBAsaz4SwuBi64HSPvWLzSJ0yS4p/VrtPt3HCpP90PsCwvt8ZH4ECS+i72n3ySiusA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYk5GkeyD9ws6P3yjQD8Kw+zkRSg9+oa3vrBIFDl5xc=;
 b=WSx3MT87QysCWj81h/ASsGy1tQ8liU/kVpmAcA3c3Yfe99Tosm9tBSXL+g2u1Sm8hk6SULWoFdtSXR/5+wR3Okokkf9uMm/UFtTqJGFprs/pRpBIHFv46f444K98u7J6m8H8CjbcjQZc/symtHZIdzXRZ52wQNyV00xA/18G8/qYz9xgHgfrgleeewnseX6t/JEjcBoQk+YOgxEEPbESj2lZHWlEdWTWGnpalLYEN9xf2QY8g1yn9E0GHrE6nljzipqigDFYFuQTPkfm7pO4EK9nJeap2VYbfxKPA21/mPOBm1ybyNoVeXFF5HMb8mmJjlwasBb4h0Oo13UAUV5i6A==
Received: from MW4PR03CA0230.namprd03.prod.outlook.com (2603:10b6:303:b9::25)
 by PH7PR12MB6667.namprd12.prod.outlook.com (2603:10b6:510:1a9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.23; Wed, 24 Aug
 2022 15:19:37 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::e0) by MW4PR03CA0230.outlook.office365.com
 (2603:10b6:303:b9::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21 via Frontend
 Transport; Wed, 24 Aug 2022 15:19:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Wed, 24 Aug 2022 15:19:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 24 Aug
 2022 15:19:33 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 24 Aug
 2022 08:19:31 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 0/3] mlxsw: Remove some unused code
Date:   Wed, 24 Aug 2022 17:18:48 +0200
Message-ID: <cover.1661350629.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1887b30d-cc5b-4c31-88c7-08da85e40d3e
X-MS-TrafficTypeDiagnostic: PH7PR12MB6667:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZHARYGCIsyxsxee773JIGGD5/nq8DWnFy/iOU0Fe4mxkX2Nuq6fb/+bpfQZZKtKnler75uiabkDnzs4Snx0Th1zJmJr7/MhB9dIglGlloBtFrlAdYDwXmZ7YnX6QUdqErphMMt/8SZSffI8DDt2tHZyxiAhsfMkWmlI1HZsvHXlqryPjkUhxGFw3Mo//TQmnVFc8XMgZ0UrYYABw0ctbGYbkjJ1bXpf8nvBN97LsLeqrBTfOU4NxpITVUvHRkKLQkd+3YArEYXcecTlpRMp6BQGmNj0KeQp4CkOW7cSMX6GIBUzDTYmSXjRAe1NxN2XvDfAhu+8sDKW6zuaSSb3SIFnWFbr1eq/Y25drNSMNPXMqDZBvz4hkDw5Z79XdrGVlvBA9w9HEocGZQYI8pLEveebhUo6iX7EtBzcpX7evv4JURH+eniuidiu1gq7lLhnIeGbaXgZDcwUEDYLRrIn3EFHUd22dmZwB+j1GceJR4A1WSQR+uk+RoDwR8R6d1ZsYyY+9u+JmweseM7fmAo0poNd9ed1avlJDBjzFUmz/3Cmrr7uMWPfe2fbKyDCWZ0Y2H1UoDpj5RayQFS507lo0TyOXVbZCga8JR0iUOEzOAPwOR5l33znfaRrOh8zWWLjHBafg2ecx9QRby/CwhCzN/PEYldbNuF8LuWXQ8qWOJeL+RgMPhPu1zd+dnivvixWlTrHZcJwu8/2HbyRPyKCkTjCKlS/3KgBVMW3sFqcCmg3h2OIOCcV8lkoGBun3QFfPeylkUAcpR4XKaz1mxV/SlHKBH6QCn4NXoUIGDw5T67I0bwmOuFh8Sk4oLaT0Az8t
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(396003)(39860400002)(36840700001)(40470700004)(46966006)(54906003)(4326008)(110136005)(40460700003)(82310400005)(40480700001)(70586007)(70206006)(316002)(5660300002)(4744005)(36860700001)(8936002)(82740400003)(8676002)(86362001)(6666004)(356005)(2906002)(81166007)(36756003)(107886003)(186003)(2616005)(426003)(336012)(478600001)(16526019)(26005)(83380400001)(47076005)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 15:19:34.6961
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1887b30d-cc5b-4c31-88c7-08da85e40d3e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6667
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset removes code that is not used anymore after the following two
commits removed all users:

- commit b0d80c013b04 ("mlxsw: Remove Mellanox SwitchX-2 ASIC support")
- commit 9b43fbb8ce24 ("mlxsw: Remove Mellanox SwitchIB ASIC support")

Jiri Pirko (3):
  mlxsw: Remove unused IB stuff
  mlxsw: Remove unused port_type_set devlink op
  mlxsw: Remove unused mlxsw_core_port_type_get()

 drivers/net/ethernet/mellanox/mlxsw/core.c | 40 ----------
 drivers/net/ethernet/mellanox/mlxsw/core.h |  6 --
 drivers/net/ethernet/mellanox/mlxsw/reg.h  | 92 ----------------------
 3 files changed, 138 deletions(-)

-- 
2.35.3

