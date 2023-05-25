Return-Path: <netdev+bounces-5313-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 91FD0710C33
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:38:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B6D71C20EBB
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 12:38:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C41F7E567;
	Thu, 25 May 2023 12:38:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB79D510
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 12:38:10 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3E39B
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 05:38:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MNyLCInxzjyj++2XGeTIXDLXVex2J4Q8ZR9Y8vLmSrAhBc9M8Z3n2Nn7KL0J6UtQ0MtpIp8XPVXnEF6e0kiVv2cfBGcCDmkhHnrAUftCODr0MchorhKlh5iQxCEUR6XpbxlpCkZQVUg9dhHDvtOm1Tr4GOGq+NzAX+QiJPeQR9Mfms2B05leyOJiiHtum22BSHnhNOpMhuyEzGcE6ZKf9yY/UyKeIF5Ht/uy/kAMM2vQDklHTEFuR9GdZd6bYNLALUyUR6phuOlYZ//YfMPdRBJsecdGzBq9ZsuheyLqsl46Ct5U787srtVxOKMVYxzl89hAmSCF49/VhceW5hFOxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=23uv6fdFnPFUlsIwtK4lsXpUyqcOfYtCbzleYCVTFvo=;
 b=fm8i6X2bwhi8HZ9qxyxaRcTa7/CzX/Duxb6heWwKFJylOzMIM8qrQC8CE/JMN/mwSwHPiTpU03LpoFgieRNGH4WEc1rA0XbIdR3LdZH5BW+evJelg5rQGkbxAPFeHm/OmxXs1K4mgHuDkNY6EgeIsrXXjF8UWVhFdoR4S3c3odCzlPgX0LsF5Q4FmFVS+IkkS1ApTbZfdBPEUg0WgtO4Ot4o9fbIYRHUZJGCX+qHwRO4PyxgEznBl2zVpA6H4NGWgkgeIGSERqq6CCjUkL2VEB+to2yTJ0vfh0laEl5XsZGIj/bqfsp0xhPFt+/bRj3ny6tXQllAjNSQD5rBS+mlaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=23uv6fdFnPFUlsIwtK4lsXpUyqcOfYtCbzleYCVTFvo=;
 b=ibFggnNfiW3/h62/k7QP8chPnnZ+anWVq2epWLQaDfNq1fjaKNpggqe2uVqM0jSzMBGK4ajwVVAoaTQJtNEJoZMse1jWXpw3NN+sq9KFbv2xkYH97Aop6CPRWi9Z5ul0Epk0dt+pvnpOyjy2lzZC5cKEq2331A2gdRdlex0U4w730I9+5WID9m0vadEr2KU1FXUSM/yqxIINn/y8opU/iXD2vGx3pBQUNg/eVnXMpxOhvcCOWSU+zjhcpIpPLW4DwX0KwjSXMuDDIjsoJAr3c1Ypfnk4rlGlrPqRCIb6l305olHnXAbYYf7/j4vbI31LvHUTcOAPKiXAs1OEo4zwUg==
Received: from DM6PR11CA0014.namprd11.prod.outlook.com (2603:10b6:5:190::27)
 by CH3PR12MB9218.namprd12.prod.outlook.com (2603:10b6:610:19f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Thu, 25 May
 2023 12:38:06 +0000
Received: from DM6NAM11FT113.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::31) by DM6PR11CA0014.outlook.office365.com
 (2603:10b6:5:190::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.16 via Frontend
 Transport; Thu, 25 May 2023 12:38:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT113.mail.protection.outlook.com (10.13.173.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.16 via Frontend Transport; Thu, 25 May 2023 12:38:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 25 May 2023
 05:37:56 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 25 May
 2023 05:37:52 -0700
References: <20230524121836.2070879-1-jiri@resnulli.us>
 <20230524121836.2070879-6-jiri@resnulli.us>
User-agent: mu4e 1.6.6; emacs 28.1
From: Petr Machata <petrm@nvidia.com>
To: Jiri Pirko <jiri@resnulli.us>
CC: <netdev@vger.kernel.org>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <leon@kernel.org>,
	<saeedm@nvidia.com>, <moshe@nvidia.com>, <jesse.brandeburg@intel.com>,
	<anthony.l.nguyen@intel.com>, <tariqt@nvidia.com>, <idosch@nvidia.com>,
	<petrm@nvidia.com>, <simon.horman@corigine.com>, <ecree.xilinx@gmail.com>,
	<habetsm.xilinx@gmail.com>, <michal.wilczynski@intel.com>,
	<jacob.e.keller@intel.com>
Subject: Re: [patch net-next 05/15] devlink: move port_split/unsplit() ops
 into devlink_port_ops
Date: Thu, 25 May 2023 14:37:24 +0200
In-Reply-To: <20230524121836.2070879-6-jiri@resnulli.us>
Message-ID: <87wn0w37tt.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT113:EE_|CH3PR12MB9218:EE_
X-MS-Office365-Filtering-Correlation-Id: b6f5386d-2d7c-4b30-1d66-08db5d1ce3ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7RhO+mAlhejY9irf1lBb3wgWnLKtRbIYEXGAzm0DsTcH6Mp5S+xLTR30McPwKij+ekpmegB9A1wbimSSCA/fvFM8YrIBSY3WMFSroJlcGoF/Oj74mDu4EjlzY1jljZC8Bcokflo7Hyl+K5Mmgx7cnA6vK2U0LtEG+5x3N9W/5lOJUpW9KPiJTE77fpF3b0KGo4QQ8ZM6YIMuCK4pOSiQS0NQ45muX3FkBwW+hfTNtju31Hix4obosyOVD+5sI65WJjrWcQQiZsFRzQCKyXmJmiKyTsCZ5yOP3pokRyOP1w5010ONotcxGjCFMcCCB9s3PU49pjOU0yT/gPez2Lfmb3vKD6AGrxxgKKIUSWjM2S9SZ8+AKEzLUVLKNZxTrj3f5YhSX7XqKAfapaxf5jtLQAHo5XfBXOXdMFW6PK2ahp4zh2mj324MPBkDxqPkji76ocH6QIzX7gefyXbaedTchMElfMvX6Y/ggYDsHVkgVs899/oIxiYVd5p9NjhuEGBfR6bCdNxHYbMTQkbEF6tZkZUc6vEPTibwqkaEz/b4Ezbhsyf4FpAk5PilXM2OZujIbhG/YjXEXe2i1MT6Zylb8bbOA2c+UAq+n1bclPbVnMCdVylw3UP17M7SccnHYv5mjRoU202fXblwOJgui7zQwGYNsE6bvSzPlK/8iQciaKLzaAv1/RSZYyzpqSsK6+ge0Y1yVqc3ktS0gXepU+TptFo4+ZSPSBhcZ8gBms3OIKmkvvC98stu1nzWo4cLlhVd
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39860400002)(376002)(136003)(451199021)(36840700001)(46966006)(40470700004)(7636003)(40460700003)(5660300002)(7416002)(8676002)(8936002)(4744005)(16526019)(186003)(2906002)(36860700001)(86362001)(2616005)(426003)(36756003)(336012)(47076005)(356005)(82740400003)(40480700001)(26005)(82310400005)(316002)(70206006)(6916009)(4326008)(54906003)(70586007)(478600001)(6666004)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 12:38:06.6020
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6f5386d-2d7c-4b30-1d66-08db5d1ce3ec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT113.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9218
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Jiri Pirko <jiri@resnulli.us> writes:

> From: Jiri Pirko <jiri@nvidia.com>
>
> Move port_split/unsplit() from devlink_ops into newly introduced
> devlink_port_ops.
>
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Petr Machata <petrm@nvidia.com> # for mlxsw
Tested-by: Petr Machata <petrm@nvidia.com> # for mlxsw

