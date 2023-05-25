Return-Path: <netdev+bounces-5312-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB933710C32
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:37:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49E681C20E84
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 12:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D766D510;
	Thu, 25 May 2023 12:37:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EC833F1
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 12:37:12 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2063.outbound.protection.outlook.com [40.107.96.63])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F289B
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 05:37:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FD7ZOljwMiHF1ppno3ovsk2pyuffrIl49Inldosknj0hBjhhVNqfpVA0/I83GvfP6upWtwsQGFiUurgK8uZ5niMiAzJqa9Wx0rCde7xYJmTpbnqAcxZ/6ifbtqc7cZheObkUfz1r7DqLOlMnF5WOzAndEGOGiRQufL/W17xobBr5scScl2wNg7UpedVd3DP7wLHnOCBgUM4jlicfHPCoL2Z8iT+uXrM5TJJmkf7Pgml2pi7OxrRdt6F3AvYNohKvRy2mfsySYE23++2oCjYQAQxD9rDwQUvnoAM8tBwHKJRGd9xcjnNIZdnQ/tj6oDIDkG1qldtOc4uHjO7iF5rCwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YMXHByxRLDe9j4KxhMMVUFHUQDxSdsDqAdvpiJzzdFg=;
 b=O4cMmH6RHPn6HWo52bOecMQ+MykHltzO9s/PL3o2sMFarpnTVc+OblaEK7pdp1sLBawfcoz5UdXkPXIM3bAmQL+0nhAxp0nLjBDwpTtiZut8GfAuSFFWfJX42y+W8z6q5hsEUTeRPXdUIed2mtWUVxWaIL147hd5672pe84SQxoiMj0ROtC8zJ9PV5RY4n1LXXMPg/WjJtQR/C4S++L3Ifmx6Fw/shD0ryLGkUVzy8uEXMX9ruSj8AT0sot3b9wAcCuab0xmR6ID3+GmNHomZcFdzKMtdA5RH7+gAl6+ap/YoBLN+3REC1ApfD/Skqy2L2WXUwAX2+TZEjodn3ENSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YMXHByxRLDe9j4KxhMMVUFHUQDxSdsDqAdvpiJzzdFg=;
 b=kTJsjjN44uXQ+we+w52owcwBOp9WoHISBLFzkqNfa2H6Tv6s9eiMjXspzSZLTAqj+J30jlpI50MNpzvMn4je+CA+rwIBn/xNxqfYW5ACIkwkt//RRrARsEru8jgmBKPHtez9RKcotEsxs7bZKnmVZZs2qh2U2kuIqDPpAySEN3gZDlC735se+e1bM3HrUsqy4fffzT0PgAVOFpGbI4O2jXA2bSAAtFU8NjSIoSNYBl4J+5V8U2v4WTzwC0Ja2t0GbHuXwztzwkmKRYeESg4GoGUm56i4TrcQdYU05HNDAPJ6pLDpjdBziU//QMuc5pPnaoY3wxyD5tv2Z7A813IiNQ==
Received: from DM6PR05CA0062.namprd05.prod.outlook.com (2603:10b6:5:335::31)
 by MN0PR12MB6198.namprd12.prod.outlook.com (2603:10b6:208:3c5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Thu, 25 May
 2023 12:37:06 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::ec) by DM6PR05CA0062.outlook.office365.com
 (2603:10b6:5:335::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17 via Frontend
 Transport; Thu, 25 May 2023 12:37:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.17 via Frontend Transport; Thu, 25 May 2023 12:37:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 25 May 2023
 05:36:49 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 25 May
 2023 05:36:45 -0700
References: <20230524121836.2070879-1-jiri@resnulli.us>
 <20230524121836.2070879-4-jiri@resnulli.us>
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
Subject: Re: [patch net-next 03/15] mlxsw_core: register devlink port with ops
Date: Thu, 25 May 2023 14:36:24 +0200
In-Reply-To: <20230524121836.2070879-4-jiri@resnulli.us>
Message-ID: <871qj44mg4.fsf@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT040:EE_|MN0PR12MB6198:EE_
X-MS-Office365-Filtering-Correlation-Id: 54c18ce2-b0ad-4653-dd08-08db5d1cbf40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GmI0IUq/LzlptQKvWp09+Vf/R1Sn9iUvL/0iCgVM1f4sTCSwv9+TYwkuqRhIejh5Xoy8XJCVTTB5r9RWvBk1JWP06dHoyO7LFGZUcLTdaExEwZGpjgcxoW7rlsUjzpTtqINIA60vY2/UOoxhK58I+NSWRyaf2YnPD32o1NxVGCufymXUeT35k219e1ZWGcFPyE36BRsDUo2/Bwlg0WXLuAOfXaP/nfxmi2Jl1Nku8jq+nLnmhoacCPYek6XJB0NrshDGCwh92jvJlYpLYYaSu9UtqScNdaJgx++CyPBl6a7o5laA//beWoBnHkIMAbUG31fElKKh9YpmFghNSz8YGeuD7KMztEy2RgUorsuH1yhQDQXcYSpWok5nUN18NtVjyikMwlxJSQZeM7y5/slRfCOm5Q2h3rxJxJU8loh9PA0gkfYuJ60an5NG/CsoO7oAHgv32gq10Sn2AbIzbN1q0BrwOpwSAGwM+EtgU1nZ6gdX8lxlVIV5LBPdVOlA6644E+iy+n1lTCUxSUvRxSXP+mnM98RMNkvJZQ8DpaApg/6qPxoPMtZA4nrkSprDfGoWr6OqUFwpYFu1v1me4ltgWYVXMvVKRgYNweL4dIDUvjlbCAoLV3lWQQg6X1GXUirGKYuFEcKhsg9j8HLtcLQuIm4n4LE6QuEhpuKojpl2tMlGVHCkfGABXgz5VFKhlXQ6TZW7XUKeq7BA0vkQpI2nAM0minHtu+Zl5y2qBXvILIs/xFMnvnJXyRmvYLZaZuH9
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199021)(46966006)(40470700004)(36840700001)(82740400003)(40460700003)(7636003)(26005)(356005)(186003)(16526019)(7416002)(4744005)(2616005)(36860700001)(47076005)(36756003)(426003)(2906002)(336012)(40480700001)(6916009)(316002)(6666004)(54906003)(41300700001)(82310400005)(478600001)(70586007)(70206006)(4326008)(86362001)(8676002)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 12:37:05.0817
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54c18ce2-b0ad-4653-dd08-08db5d1cbf40
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6198
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
> Use newly introduce devlink port registration function variant and
> register devlink port passing ops.
>
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Petr Machata <petrm@nvidia.com>
Tested-by: Petr Machata <petrm@nvidia.com>

