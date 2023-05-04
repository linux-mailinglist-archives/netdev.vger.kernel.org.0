Return-Path: <netdev+bounces-326-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 569B36F71C9
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:17:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78202280DBD
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 18:17:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 519C0BE65;
	Thu,  4 May 2023 18:17:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1929479
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 18:17:13 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2073.outbound.protection.outlook.com [40.107.101.73])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465AC65B4
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 11:17:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EF+VN/VjRmRVKNHQQKPKB8fzua9vlTML7BQcZiRXcQraheWEF73YXpYja5uImDcHCz5RK9AobnlLVT1d9GEKCUktgIZa6s6PC7PmudsHYxScjyJUffjzbx60zbjtM6ds8t2UxHlAl6TbvxXPoNXawdetI+C+7lV98pobngXn4qqm+3W71wRZLuMDH/ciGx3Q4s/1BEYxWY2jwMUuw/QoAWQQIrEGu4LIhMN2MspsOLt543SIcFj4GWrY7NcF8VHoM3yQgjQiUd0FqAOxWJwf6x0OsRYdJvyW75PmoKIH06GY5DelL9KRcs8PX8MaY4sy6cOOETy36PdekY6RGu8WJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iD3pITt4MhMivB84KYp5XDYM2RA2qWjiXN1CWKmEXRg=;
 b=SWgQY6lQ4LhEOyxFHO8MwNQU9c7gJeulG1enRwYiaFDh3QDwbz3ya7nbbXIy21Y/1kRro4hjC+MxZ+OcWTCt5WrBIhSCyceFuc45cUEa3J0UVi0+Et32MtA/T7DN43RLK6Frdm61HrCdb6YneJD9NSZ0lQNnUQK2PyHnTCUsb68iVEEH+WRoLCWyGFQ88cOSJmRzO5Va17s+vayyzzGsUYupnyXs369sniWEn5I8nnCvYhS5eMH9//DrYPCeI4jBkimNC7ml3/hkjrl7ZuPxwBTYvGv/cstiDo4DYu22v3wVt4kBYV3q8km7VXRFH0M3lZ8eyUapB9HwTXu3a9cU5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iD3pITt4MhMivB84KYp5XDYM2RA2qWjiXN1CWKmEXRg=;
 b=r72/X0vMjnAFuCFvtYQDuzONUq6s2sNZN+TBHfXTmGLtD87IplorC+UranTxszc3i20Mw/qMPzoPYW+kn0YI9a+5rC8m7sKF6BG/XdfefaeEPmtMY+vLAPql22rDzYVOLJrzLHw9XRwTDJkRQTMfpTOI3nE5b3CxrhwISBui3fyon4TJGOKWXz7yKow1+fHbnhbMiDkRxiRqPdrEY4HUbvs181iCqz0xTARBqZMg6fvTARgutnzUzHVL2TNajoFdlQuYHvo3jLUDYXUtP2YIREb8j8MHyIcUXC1lTy9SOM+hUO5G12zXkeeawz1f28JFP8XB7RK5vEKD2g1VvDqIvw==
Received: from MW4P221CA0028.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::33)
 by PH0PR12MB7791.namprd12.prod.outlook.com (2603:10b6:510:280::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 4 May
 2023 18:17:06 +0000
Received: from CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::9c) by MW4P221CA0028.outlook.office365.com
 (2603:10b6:303:8b::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26 via Frontend
 Transport; Thu, 4 May 2023 18:17:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT037.mail.protection.outlook.com (10.13.174.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.27 via Frontend Transport; Thu, 4 May 2023 18:17:05 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 4 May 2023
 11:16:55 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 4 May 2023
 11:16:54 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Thu, 4 May
 2023 11:16:51 -0700
From: Vlad Buslov <vladbu@nvidia.com>
To: <pabeni@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC: <netdev@vger.kernel.org>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
	<jiri@resnulli.us>, <marcelo.leitner@gmail.com>, <paulb@nvidia.com>,
	<simon.horman@corigine.com>, <ivecera@redhat.com>, <pctammela@mojatatu.com>,
	Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net v2 0/3] Fixes for miss to tc action series
Date: Thu, 4 May 2023 20:16:13 +0200
Message-ID: <20230504181616.2834983-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT037:EE_|PH0PR12MB7791:EE_
X-MS-Office365-Filtering-Correlation-Id: ea8540aa-0169-4b93-03e7-08db4ccbc42f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	c61stB5VVPNk+d+MFt55MGk6xSz9MwynkG3MW19oM0vZ+i5YlBKEOtQKX2EQXySbAGtdVjNa+pX8YoE27Wx5PSbjOA/hPSesGPizOhS6swhURqJh8LiguYeQNXT6KppYLs7U7UooGzOCg6njvQJH7loEt8q7ngsXXuHKNsaFD423tYmmJP1Xaar0ga4yXv7k2fUH+cjOEE5cuB7ZSo7fznPU7aph9lmm6pGZTGPHfI5jukhkt+Zri0paWzaIgS2DB/Fxd4zbG4VQ9WE4SFBbT6INnnVq1G0qqPCmjowhsRJ8OjnUop2OoPhiRP0F4oaBiMocfLe/aKLkJO6fkMljL5shkhG210wYfjnL0QlHpzi9toi1Dv2g7asNLi3rzLMdQg7h/s94wDOJrsWaF1xw70vWHckzCOkhtI0o5zShek0zkaP5Z30YC68K0Fpl0Ra3cNikcGyjp4o/b71CUVXMU/Vw6sMudqnZSLqncYAQxRoBC3q7sB+Ar6hzrC5OaiixfGfe54Kbo63atO8hSObGH8K5Z1epEu5mQ863ha0vOrFGILAVeOYW5ffhEucPTh98czyBDCQJRfZbiBuVzCFIUJPwm6WBEzgNnkTVgKK0dyvn7zZo6sBNbYYQj/9YukXZtz8C7j/JfMNT7oEQOjzfnNPQnRduDuc7YQ6Mn/HNNsoNPZd8p1eJZvr2drlCmWlSoVzV+HbPonjSTQk2NMuWuA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199021)(40470700004)(46966006)(36840700001)(40460700003)(478600001)(2616005)(7696005)(82310400005)(6666004)(86362001)(41300700001)(7416002)(47076005)(36860700001)(316002)(5660300002)(8676002)(8936002)(356005)(7636003)(82740400003)(107886003)(40480700001)(70586007)(70206006)(426003)(83380400001)(4326008)(36756003)(336012)(110136005)(4744005)(2906002)(186003)(54906003)(1076003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 18:17:05.5607
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea8540aa-0169-4b93-03e7-08db4ccbc42f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7791
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Changes V1 -> V2:

- Added new patch reverting Ivan's fix for the same issue.

Vlad Buslov (3):
  net/sched: flower: fix filter idr initialization
  Revert "net/sched: flower: Fix wrong handle assignment during filter
    change"
  net/sched: flower: fix error handler on replace

 net/sched/cls_flower.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

-- 
2.39.2


