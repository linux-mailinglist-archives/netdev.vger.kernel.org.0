Return-Path: <netdev+bounces-5042-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 64E9270F83B
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:06:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13F0F28135C
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AEEB18AF0;
	Wed, 24 May 2023 14:06:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AFA60841
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:06:47 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20625.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::625])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E815312E
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:06:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jUiDNw/+pAJBiuAW+FmFdT/xHYGztqwe5unFwHT2evp6XsAf29OgUXR7h17LRqWHRhlaKrZ3iUXiCfEmo8nSBmHoFyL7gOCFaIGjQgBXZGpBnWbo7eKbCrKkHXWq24dtD9jW0xr6gWsYxdrEmL0MFpp5OGXK7qph14I1GHoOWtKy13oCGVRIpScjCUnWnOfuIqyl+EO977HOZqawZQKjcOEjdN43TTN7irb9jtm8/hPmWt6fHYO8PpSlGosSrudhs60fsvMrwVdJzLRzTxlBQ4YNO01aPqrZWbeLHdNSK0go41UsJL8vDEPTSFtU4VlEZ8Y3DDZbHVYEx3azTifFXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=STpVRGUugXlbcF7jNrJ77RrtrZ56zFT6tlNWXmESyBQ=;
 b=C9gtXGF/h9FxCuVUetKDdLdUG+ZtazSLD1ZrsTYedNsA0R368EBgpmxExNfSQu3SxIQ8JGdXh/unGoaYAFYefQsQoMlilhmkch3cROAuGVHJhQHi2RF/lyGWXy//iX2DRjoUz+Nbpfpt4L0WqYmev29nuh0PZjbF9YCb2n3/VZkgBgJTZ45yUhKTVvCjhDkzZCiy68d0RYmNZtyWYS2OpKwd/Adx0JkADg9ZB/w3gKyQC/2y0vH2FYLrPicPZ9clJgV2v4blJrY9XWBGWVyq6QhpUfhhLrkbsFV+kIetws5NmQvbFRfvxHUGaG1n4FQXZdLfLK2KDLxlZ0JupZKjDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=STpVRGUugXlbcF7jNrJ77RrtrZ56zFT6tlNWXmESyBQ=;
 b=gp8pIDEjexlM75spakFWgLYm4+lgj7guC9vw3FvaAYmuNYwKtPi6W2LZ1yEEeAKBbSMdC+Kmhca27J4OeDSjlK+6jyq7srcrn2oICQ5SjJoyqwOY+ehYAzZ4XD/wbuV0NMz9wYdxH/raqVYxdyuMr3GTu1bEg/x2e/VQHG1/hrAR2mwvtpEvanPeYUo3QEF6lWW5WvusKDb9yiiQs2WpDd3jGydQ17w0QZXBs1aBI0iF0JwvH8GLx/PGLYXn8vZD4t+QMvZTrK8MCq96UhmLDSvmHEm9X57TC7pKJtY+vSLR/DoUSXqTCP678LMOORRqLBSGs/F/Ek/jJbl+DjVOwQ==
Received: from BN1PR13CA0026.namprd13.prod.outlook.com (2603:10b6:408:e2::31)
 by DM4PR12MB7551.namprd12.prod.outlook.com (2603:10b6:8:10d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Wed, 24 May
 2023 14:06:43 +0000
Received: from BN8NAM11FT106.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::4c) by BN1PR13CA0026.outlook.office365.com
 (2603:10b6:408:e2::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14 via Frontend
 Transport; Wed, 24 May 2023 14:06:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT106.mail.protection.outlook.com (10.13.177.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.16 via Frontend Transport; Wed, 24 May 2023 14:06:42 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 24 May 2023
 07:06:32 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 24 May
 2023 07:06:28 -0700
References: <20230524121836.2070879-1-jiri@resnulli.us>
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
Subject: Re: [patch net-next 00/15] devlink: move port ops into separate
 structure
Date: Wed, 24 May 2023 16:02:48 +0200
In-Reply-To: <20230524121836.2070879-1-jiri@resnulli.us>
Message-ID: <87a5xt4ye5.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT106:EE_|DM4PR12MB7551:EE_
X-MS-Office365-Filtering-Correlation-Id: eb0924c0-7390-4dd3-2b90-08db5c601a24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AGhcBZsRTX5vqvztjLdHTg7OKh0lAR1jy/sj4VYXLQvotO+PPsS9bqXeGQwcA66PYNVZu2/7AMOXOSXDeVMgCY7wYjyWUQyUYp1JII3K2GUdBLdVqz9KmuKXO0Eq44MjzLaOuz4lsjIJB21wUmR6USQJQpRQ7vedSTOXHE7vWlNsqeCvtVQCosn5z9NrjX+IPz+RwHeREKJqZ4WBoI3yvsx3tZdXr8VjhBLNqJLZHx7SazWYBu8DKAdHmnshyGYFh3xM3zqt6a7my9w0lAmseoYb3hNHHiDiqyRvoJx+iCmvlXo5OIWMb5G414YWZ1le9kY5MUycwDmRpkvFaR15EB+cIBoMaRYTyrX+Inkxqq7V0bYvb3DbbknOUT/mffVHm+8tHE2Ja94G/ILzOKHZcvr1ab3qFGNVxObUPdRqFBvScHLV9ux0QHEnDClH4divUuzEPr/e+f8bXyJUOsY/W3185hU8paTch7Sct+AD1hFfyePXZAgG35y4kkO3L1QY1NM2juQ+ffpjY5ZmoKQBrING+OER6DjkTTPl1Nys+euDlHlu9Q70GqvuKQKZQg4nc6xebvhg+AxvxE1/SDMokM2GTlApQH0EbvKnsPW4eptbeQQDRJWxpDGQ/uCdisr/0wBDvKQBjc62HO4Ti300YUNZ0FBFploJwNyPkiXIF3XQM8X4hS37aLBVovOatskbHzKziZltyGM6OdGgcS+qOrwjmtqXQrAHDwcMXKcyace9TzncnexTW67Vd6s0IOrc
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(396003)(376002)(451199021)(36840700001)(46966006)(40470700004)(7416002)(54906003)(478600001)(5660300002)(8676002)(8936002)(41300700001)(26005)(6666004)(6916009)(4326008)(316002)(70586007)(70206006)(186003)(16526019)(426003)(336012)(2616005)(47076005)(4744005)(2906002)(40460700003)(36860700001)(82740400003)(7636003)(356005)(40480700001)(86362001)(82310400005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 14:06:42.6376
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb0924c0-7390-4dd3-2b90-08db5c601a24
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT106.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7551
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Jiri Pirko <jiri@resnulli.us> writes:

> From: Jiri Pirko <jiri@nvidia.com>
>
> In devlink, some of the objects have separate ops registered alongside
> with the object itself. Port however have ops in devlink_ops structure.
> For drivers what register multiple kinds of ports with different ops
> this is not convenient.
>
> This patchset changes does following changes:
> 1) Introduces devlink_port_ops with functions that allow devlink port
>    to be registered passing a pointer to driver port ops. (patch #1)
> 2) Converts drivers to define port_ops and register ports passing the
>    ops pointer. (patches #2, #3, #4, #6, #8, and #9)
> 3) Moves ops from devlink_ops struct to devlink_port_ops.
>    (patches #5, #7, #10-15)
>
> No functional changes.

The mlxsw bits look good to me. Will take this for a spin in our
regression and report back tomorrow.

