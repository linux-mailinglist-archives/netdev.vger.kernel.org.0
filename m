Return-Path: <netdev+bounces-282-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBBEE6F6D13
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 15:43:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F1BE280D40
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 13:43:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04A1AFC0C;
	Thu,  4 May 2023 13:43:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E797E
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 13:43:22 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F87E7A99
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 06:43:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VbtVdFpap5tkon2gp6/xk8mcfITtUQ4wwjCPCESCLInGTlES3PX4DO+MqqWmK1uqSGDMJU0t5bUEeG371uDsu45gE8GDM2MKnHyysdKbDpJjanNhre0vbmP/LgPATYrtxNgRBlWr7EYPULhYyOWSHwwpC+cJ4wxq3NKjhc/LzLVg27tubNZJ0Qz/Lx5/zSOf7JpD5LQ8FR4KwdEh0uYIje5iEu2qDx/PNg7f3lRL2Hseu5d4SPE1iSzstQnYu8qdQ1xVEh6CaXlkosiHuogxuUT9rz6hiM7/vb+s+Q2NT1RFniTEKGC9VEMGlMJHY0jBGcMWZGyJ2uvI/Z8AUK/jZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ENfDObhvumTr6YWu3HqRGgGVKA93kg6wG8cORED23pg=;
 b=fOPpGTxmzjIZgfN4hWZ1SLQxNFKdMOrXLccGiZOmYa905M+C/tEuYq4+EOir7nQ4gs5Oo0f5+0XikbQ+duPM+Nj9oNj3F1hD5Rqb3oDQJDcYsRgXECOKd4etbn0oWh+JY/3s7kyT7hFG2r+IrBsL4cYLJ1VnPHQdsEU4la1ccyQ8jgafVe41sKduvcm7UCRcrw0hVH4dE2CSS1xcvbmSGaPK37bSMaAuJOhavNpzFYv01uiL9UTTqlrGlNsubnKVh0CW0tsIu+dr4sK3BaJgvxGrJiIFL/r4aTx0ZXXYvmbYrQSCnTpNy2BQpq0STcaq9LnzGG8FcqESAUGg+AI8uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ENfDObhvumTr6YWu3HqRGgGVKA93kg6wG8cORED23pg=;
 b=DliqKnJypuYXufZmgZw+2ggLU2U5veSmE3lBKiSYnRTfO/CuJkgheJye2NR0M56kY1LUyhMg87sPBi5kfR80eSkhplPryhftnKZOumr0HwPlUL1U5y5ixnV2qg3Jb520cBtiIrWUnu5RBnW2fbuZvghVvQzhvhwL1IwXSRGJO9INSSvNNAYUSkrQtauvjXZFkmKv9a5RH6etHJWvkVGNO0ZQ5m9MHn6ZM2OId1ZT3QC5E5Gc7D2ebKQ+yNxU8Z4fBhQrFADZJtNAxCA6svs7SDphU3FTlbhUIa9p4t31jYxJKtk0FOW7YqLyTc0FfVum/HeQa1Mtq5NThlD/WJJqvQ==
Received: from MW3PR06CA0029.namprd06.prod.outlook.com (2603:10b6:303:2a::34)
 by MN2PR12MB4520.namprd12.prod.outlook.com (2603:10b6:208:26f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 4 May
 2023 13:43:18 +0000
Received: from CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::f4) by MW3PR06CA0029.outlook.office365.com
 (2603:10b6:303:2a::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26 via Frontend
 Transport; Thu, 4 May 2023 13:43:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT037.mail.protection.outlook.com (10.13.174.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.26 via Frontend Transport; Thu, 4 May 2023 13:43:17 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 4 May 2023
 06:43:03 -0700
Received: from fedora.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 4 May 2023
 06:42:59 -0700
References: <20230426121415.2149732-1-vladbu@nvidia.com>
 <20230426121415.2149732-3-vladbu@nvidia.com>
 <4a647080-cdf6-17e3-6e21-50250722e698@mojatatu.com>
 <87bkjasmtw.fsf@nvidia.com>
 <1bf81145-0996-e473-4053-09f410195984@redhat.com>
 <ZEtxvPaa/L3jHa2d@corigine.com>
 <bf6591ac-2526-6ca8-b60b-70536a31ae2a@redhat.com>
 <87354ks1ob.fsf@nvidia.com> <20230502194452.23e99a2c@kernel.org>
User-agent: mu4e 1.8.11; emacs 28.2
From: Vlad Buslov <vladbu@nvidia.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: Ivan Vecera <ivecera@redhat.com>, Simon Horman
	<simon.horman@corigine.com>, Pedro Tammela <pctammela@mojatatu.com>,
	<davem@davemloft.net>, <netdev@vger.kernel.org>, <jhs@mojatatu.com>,
	<xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <marcelo.leitner@gmail.com>,
	<paulb@nvidia.com>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net 2/2] net/sched: flower: fix error handler on replace
Date: Thu, 4 May 2023 16:40:21 +0300
In-Reply-To: <20230502194452.23e99a2c@kernel.org>
Message-ID: <87mt2kqkke.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT037:EE_|MN2PR12MB4520:EE_
X-MS-Office365-Filtering-Correlation-Id: 92bdb2ab-12a6-43a4-3b2e-08db4ca5842d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WUNhlvF8VYPO/GkdoXAeRbqaGIMc46YhjH7zrs14SSmI6e5ynJ6qCmpRHiPIvfFlC/HkLpC4H6K8Rk3Syk9L256ctj4jMVVwB5pgUK31JbjtIN5zE1By7lndPiSrTm/Z6Kre9i5o+rlJGVM3wRrSCCopyd2XU+qAIL4dcIQ3TvxAwDhQIggioTX2KG4GbhWscMf96nHCHA+/pwmezAKonNkxZg2GAAvQkOC9uG4NRIoJBr/nEmUnL5jWBcZLJx0Zj3uYpTaxfaXtquNTqd1AeAHA4ySIrs9x1onC5wvoMAzM7unkUE1Cqn1H6FM0Xqej1G4wR4s+gqvgiZgnpJKFwIT2E6WlN73K3Hgtmg9N3p8XoE320W0xyoe41Z6W4SU658nnx+8RTGyBJsAtGKcFHSmcZS9tO3e+g4maO+82Q9hg4nxUHHtIPGiw6L5Ro5Zjwk21mjTJJ/xS4tQcIqQDi+Ikm1/uXTk5oSSAFkJZVNwC2oKPIJoCah3CfhfClzodvt3ArC+TlGkVrH+4P5qdFysyL55FZ2PlYKWjPKtWXIYdKOIluqHuTm181GbLgldF99yLtANWb6C9X77t7NJcLf7uRH9zUMJMVTFdS1PRkiO7FCBI09VIr2SLynupPwKTod+qM42dEgT29XacEqGDLzN3IFeWV0Vi4Kfr3ITbCsBrAcRZaoZuYfOCI28AIw/kf+joro/W+SZcEZEbhW/L1g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(136003)(346002)(396003)(451199021)(36840700001)(46966006)(40470700004)(6666004)(41300700001)(82310400005)(7696005)(40480700001)(478600001)(36756003)(86362001)(70206006)(70586007)(40460700003)(4326008)(6916009)(316002)(7416002)(54906003)(5660300002)(2616005)(426003)(336012)(26005)(83380400001)(4744005)(36860700001)(2906002)(47076005)(16526019)(186003)(8676002)(8936002)(82740400003)(356005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 13:43:17.2523
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92bdb2ab-12a6-43a4-3b2e-08db4ca5842d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4520
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue 02 May 2023 at 19:44, Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri, 28 Apr 2023 14:03:19 +0300 Vlad Buslov wrote:
>> Note that with these changes (both accepted patch and preceding diff)
>> you are exposing filter to dapapath access (datapath looks up filter via
>> hash table, not idr) with its handle set to 0 initially and then resent
>> while already accessible. After taking a quick look at Paul's
>> miss-to-action code it seems that handle value used by datapath is taken
>> from struct tcf_exts_miss_cookie_node not from filter directly, so such
>> approach likely doesn't break anything existing, but I might have missed
>> something.
>
> Did we deadlock in this discussion, or the issue was otherwise fixed?

From my side I explained why in my opinion Ivan's fix doesn't cover all
cases and my approach is better overall. Don't know what else to discuss
since it seems that everyone agreed.


