Return-Path: <netdev+bounces-6159-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5E46714ECD
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 19:13:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 612C71C20A0E
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:13:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4D05C14B;
	Mon, 29 May 2023 17:13:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87E379F0
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 17:13:11 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2078.outbound.protection.outlook.com [40.107.93.78])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E9DBE
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 10:13:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i6hV5YpdV5DH3lRCm4DvtOJBKPOswHAQj8D2iuL3SAfLTNiqYYZ7cO5Svi8xJZkGhI0ykzAN1ad0V9Z96neI4/ofN987ZU6W5q/G3K8G5H+BjGRxS7lvU+HsBhhJnIATgUpfkp9907P7WGxxlQ+ERNHJYBJamCwJKf6TsnrBq+4Cnt2d+OTW0CRNE6ZHyDcyP5lAQ3EoQXmXyoNhQX7I2F8DyD8ABOVp3247NoM2VofmyxEzYrROg7lKSQsN7tz0Aqgx3k8MX5R/HggZ6XIvCoUHo2KkzKfIfgDbNv0K28kCEELlWaywMphnFrJf2jt2rbCFIyoRBBzhTTV7OwxMkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IW1JW3uNmN1Omkc3OGXQrpTbqwDEq26ycauNVhH41JY=;
 b=XimbQlT5Q7hBzFeoadXJy8cHLC8ArweOh56BU6AioeTVFOJJd6ZoLIaR1a+z9hyriLgz++paB1RF7FYAnSaXaAAeYDRR2okeJPCuKnOfiZP3baOsCZCnfG2a7aUmUSJGxkwBNLaVUYAyAp01wE1piFty/pmoKqrjnZqB/c3fPfZwg4nAEmzgjp0IyGR5xkpoYIseLDoZfBWpOx/T1AzEw78PUZiISNoTHg70roJRf3V629A41zHPCnVlMMWytYdtr9eT0ZrBY2T5XwyUOFZP9Xq3+JgEMt8G3GpauvXm1Gb6yRW/p8uhSF4n0nSrY7z/0i7ydBHKozRyVAU6qYZijA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IW1JW3uNmN1Omkc3OGXQrpTbqwDEq26ycauNVhH41JY=;
 b=OGp5TDyOo/xf4NG7xBFnb8hWgjECEeigo8k1lwV0T7ydRhZB+ezgf8mmGRC9ux1ZMxQp+raqazDjPIG8fNnrd5bwQm+mY3EyftXYf7eTJWGCbGBIHQWyCJdatBtVp+OTByv2z4TKUkYn/4JL16SfEiFJAZARNErwl01Q2OR9gHRkZiUrK4TFWOwjLLqowCX22xyNJ4PlCR8/eTzJ620LkJF6ox+66phLXoRJr8ieEdlK1NpmOCsxRZ60Infu6UTF+r5gOZ4m2Nqg0ZJ1lWxY9vRFsu2H9tNTB5e7HD61qOmjTukRGKCfCPlwCni513nnTm+8zgcA/yR4py1/BxX50A==
Received: from MW4PR04CA0285.namprd04.prod.outlook.com (2603:10b6:303:89::20)
 by DM4PR12MB8497.namprd12.prod.outlook.com (2603:10b6:8:180::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Mon, 29 May
 2023 17:13:05 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::3d) by MW4PR04CA0285.outlook.office365.com
 (2603:10b6:303:89::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23 via Frontend
 Transport; Mon, 29 May 2023 17:13:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.21 via Frontend Transport; Mon, 29 May 2023 17:13:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 29 May 2023
 10:12:55 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 29 May
 2023 10:12:54 -0700
References: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
 <20230510-dcb-rewr-v2-2-9f38e688117e@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From: Petr Machata <petrm@nvidia.com>
To: Daniel Machon <daniel.machon@microchip.com>
CC: <netdev@vger.kernel.org>, <dsahern@kernel.org>,
	<stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v2 2/8] dcb: app: modify dcb-app print
 functions for dcb-rewr reuse
Date: Mon, 29 May 2023 19:09:30 +0200
In-Reply-To: <20230510-dcb-rewr-v2-2-9f38e688117e@microchip.com>
Message-ID: <87leh75aek.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT046:EE_|DM4PR12MB8497:EE_
X-MS-Office365-Filtering-Correlation-Id: d0d3703e-f012-4c81-addc-08db6067f7ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lgSC8sejy64T63wSxZxhxYly7lSBJbWxnUo4DxivuxFWXaL1k8niQI+QHAInKb1UGXRNhOfPOhp3HoR1CWOatyg5rz2nZeJvaD7P6tjCkxAby5rX7meZDFhHSTePY4DlIIEEYnZt23xcISLIoU3Up54G3nHWpdxcGcTkEdHZM8QrAfd5BN7eFmqOFc6AsbIwck9V35msF8mNYjrrUnDFhi59q2lJ4hu9rHqq5SYw36JDfIOXQ9jVM22b0GKIDsVvkK/WhXN4PaTTLLbonQvk+O/zJbvw2Ym87ufwjiXSUuzE2zroOu6ZD+wvMMmM2KMx9gkoja+6GziaiHasKswscVGgNF50pLliSGdgli5ZB/XQVA52XK1jRxDN1ZdNWkScCk0YUamx2hWRSa9wH9tqOnq2rtRraFkNEBecMbIZq+FT6IdO/bQq87n/GYq3su2TMzgIKPCcVWdPw6ykLGAcwXwUA1mjXAGcpJjSTc16Zlb0ToCrV9icIegyXq3uy2XHrKaRgBVK+eYpkQF6XAjtjoAgT7nY5eqd4b0/uqesiuhogLjb4nj+Wt56M0iSqvjlFuWF+xTBOFpG3u+9B0D1JBdY2hSzSsrPw1ZvWwHS+rI9NUXpmBPnEUM4i1VOqObRKY2Czmyw1Ksn/6MHCnU8xZIjWCn2C+R/rbrdtmoy02gNoR2F+8A9MTApMNeoN3ByD7LiuoMKO6QA/ufScxgejrlxdwYLl00OqK32XepFXlg/Z5oO7exxoLrCVH34L/2F
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(136003)(376002)(451199021)(46966006)(40470700004)(36840700001)(36860700001)(40460700003)(47076005)(5660300002)(316002)(6666004)(70206006)(36756003)(70586007)(4326008)(6916009)(82310400005)(82740400003)(7636003)(356005)(41300700001)(8676002)(8936002)(86362001)(40480700001)(54906003)(2616005)(2906002)(4744005)(186003)(16526019)(336012)(426003)(478600001)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 17:13:05.6068
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d3703e-f012-4c81-addc-08db6067f7ba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8497
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Daniel Machon <daniel.machon@microchip.com> writes:

> Where dcb-app requires protocol to be the printed key, dcb-rewr requires
> it to be the priority. Adapt existing dcb-app print functions for this.
>
> dcb_app_print_filtered() has been modified, to take two callbacks; one
> for printing the entire string (pid and prio), and one for the pid type
> (dec, hex, dscp, pcp). This saves us for making one dedicated function
> for each pid type for both app and rewr.
>
> dcb_app_print_key_*() functions have been renamed to
> dcb_app_print_pid_*() to align with new situation. Also, none of them
> will print the colon anymore.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

There are about four patches included in this one patch: the %d->%u
change, the colon shenanigans, the renaming, and prototype change of
dcb_app_print_filtered().

I think the code is OK, but I would appreciate splitting into a patch
per feature.

