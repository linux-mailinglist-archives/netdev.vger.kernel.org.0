Return-Path: <netdev+bounces-9974-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BE7A72B804
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:18:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 587861C20A40
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 06:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5133579E6;
	Mon, 12 Jun 2023 06:18:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3955D3D7C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 06:18:34 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2145170A
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 23:17:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J2y6M3wp2kdk044mOD7c+Y8D5suvGNJ9mljSh868p7OtLrvfB3PUPgELOTbhlSYSJyMU5Fv+bzZwe2K5VYGkRuaum//r2q5v0w6l7XZp7pstTt8MaheCzOxKNEhY1+dfQaXoEmm9qL1MapOCuExABcQJOrdFQtrJ9sD33HN875cJgzvAoRJZq6fMZ14eP2urqPT+6BSumNJRFDNvQMHYbGJqJfz355InU5XvlkROWWRGZwrEn5xV8occgO6PUrwvnoKtPt1Zm45PodQQvyAfCWPlU/MlFoPKM/TnxYpCQguZKG9k2fExVjJZORmxME9E+Bv5ZBbXGOvvbZxJLOJKIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f5Xm2Y9YEoD5oLUfX8K045AIBshNi+zGbyL6D++91ac=;
 b=MmS8+PYeWDVZ16ya/oW0ynEFFBkPLMS1qDUtZ1Crd3w2L5uRGCUdC93UfTrnIJbV1imtna/P1CFPgRkh/eRJ5gWod+MqXdlOacxDCqI8NIlvxBaYdXLv3jnk8MYruXLSJsUwOFVRNPgp4nQWzLVY6yZmBy1TewdaZiefrieVyc8KSyx/LDCXVU8IFnRX+C0iKgi1gqBPi2lo1TBPEOWe8R/vwc9wnVATBv7vqXdTcrLaDT+yUPhonX0bCF2TiCzDOJidieYCbyPzU/XC+Nt/F25CGIM+OU+LmZWzVQOPUNvnhgUb5GY/t/HLygusViGMSBhaAYU3YKsZTy216yJFnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=blackwall.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f5Xm2Y9YEoD5oLUfX8K045AIBshNi+zGbyL6D++91ac=;
 b=t6s4IRq+gir1wta25ApsaQe55bCkPPaxCEqxSEp+I9iK1f/hudQMkkYE5RLoMH4C7tEqZrQBsEuxpGes3dmP1OabvN1MIUh8spuyBZt3yDVAuc5fqUT2r3+tWDwdRqrRzwvTK9NvkyOkn71aGhj+3NIJCz38KiI6xoBbhHeMDZPXkiCNznCwjQGYsUP/GAUe4Kz7pdGSq73bw0pSdmJEYqf9jSRUzeEYk6E2Tz6j1Ny5TOiT2oSmmWb4WpG3IZossTjJi6bmBNBr3bsK6sLnl+9IUpfxPjnjPrb6T8IBp4dvnWdOGEI1XYgeonBsKThsVZoL7TTNBZyL6YvFM1OGbw==
Received: from SA1P222CA0067.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2c1::17)
 by SN7PR12MB8103.namprd12.prod.outlook.com (2603:10b6:806:355::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.36; Mon, 12 Jun
 2023 06:17:42 +0000
Received: from SN1PEPF0002529D.namprd05.prod.outlook.com
 (2603:10b6:806:2c1:cafe::59) by SA1P222CA0067.outlook.office365.com
 (2603:10b6:806:2c1::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 06:17:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002529D.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.21 via Frontend Transport; Mon, 12 Jun 2023 06:17:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sun, 11 Jun 2023
 23:17:34 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Sun, 11 Jun
 2023 23:17:30 -0700
References: <20230611112218.332298-1-idosch@nvidia.com>
User-agent: mu4e 1.6.6; emacs 28.2
From: Petr Machata <petrm@nvidia.com>
To: Ido Schimmel <idosch@nvidia.com>
CC: <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <edumazet@google.com>, <razor@blackwall.org>,
	<petrm@nvidia.com>
Subject: Re: [PATCH net-next] selftests: forwarding: Fix layer 2 miss test
 syntax
Date: Mon, 12 Jun 2023 08:15:00 +0200
In-Reply-To: <20230611112218.332298-1-idosch@nvidia.com>
Message-ID: <874jndcih4.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529D:EE_|SN7PR12MB8103:EE_
X-MS-Office365-Filtering-Correlation-Id: e3f8305b-49f9-45fe-97be-08db6b0cbab3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ybVGZ7QlM5j45TX3qM+knm0YLVlxOGYnHKT+oZyv+PyhNr0+XOvcmo7e+1wF7e8VYoF1Omslq0U9te0RfHLgCvCe8Mt+ukHIU6hGmt16BroJb0O0MDlj9KH7dBGg92ZmYiWi5Jglbs9OEgHjTTAhvK+Gz+jRg36atVnhylxZWqRMiFmUpMQm8Y1JKyYTgdrxZyF7GxByc/Gf4fV7dV2c+qnL5PMnOIWSA4ShSKT7B4626P0AqR0hfNdjQjyG2v0/2tKDgWEPIgiWfSnQ1XHUeO8R4tNmkG8XPc7MpThxVZTeh011Ocw94Qx+etDqQL27KSTWwloZ4VeKCREg+Ls6yiPhR1dxiOWOnJdt5PiEc2KZ84J9Hx3tkrE3SkMGc0pgkqs6BeJd1fgAAAE1BlXZw/UgDzB7l6aILW8+dnuyirNJH9Ecf7bmyUdHdVmiRmlE0eVlhEG2n11xVMcfFAAL/CvdTbn8E1lA49SDoT+VR9YKiFGvfh/yFBK6k/PYGx5QM8QwczOwDihlhUKdNiLRidsEvtU1rzpJKi3dWiVK/Cgqv0qK2lBKqVrstvXoHKNjoDP9MHIod3BnuDSl7Y+xvn49MpQnfrLAs6wbd7pqcYIJVgyuUP/UMogeh+9780PbX2o/b9eVACv4YsMPcyPYay2ACG+rFOSmX+HxeN+QL6zctAPQmk3jzASDMIURFMiw8ii0WCugkmXrFtX+Cdoasz7d7zwVj4LPO2vDJHj8a/f9zT0CMYjYfPfRxxA0dsqjrSVhSOvCLXjsPfmfa1jh55hpJh/H4siSbCuZ2rm1nl2TaK9rpX42uaPOVLkNefOTkg3zyhK0T4vY6Kxr8OyZ6w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(136003)(396003)(451199021)(40470700004)(36840700001)(46966006)(40460700003)(26005)(16526019)(40480700001)(186003)(107886003)(5660300002)(41300700001)(426003)(82310400005)(36756003)(47076005)(36860700001)(70586007)(4326008)(70206006)(6862004)(8936002)(6666004)(336012)(478600001)(8676002)(2616005)(966005)(37006003)(54906003)(2906002)(86362001)(4744005)(6636002)(356005)(316002)(82740400003)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 06:17:41.7762
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3f8305b-49f9-45fe-97be-08db6b0cbab3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8103
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Ido Schimmel <idosch@nvidia.com> writes:

> The test currently specifies "l2_miss" as "true" / "false", but the
> version that eventually landed in iproute2 uses "1" / "0" [1]. Align the
> test accordingly.
>
> [1] https://lore.kernel.org/netdev/20230607153550.3829340-1-idosch@nvidia.com/
>
> Fixes: 8c33266ae26a ("selftests: forwarding: Add layer 2 miss test cases")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>

Reviewed-by: Petr Machata <petrm@nvidia.com>

