Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED6833D4F89
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 20:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhGYR5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 13:57:18 -0400
Received: from mail-bn8nam08on2061.outbound.protection.outlook.com ([40.107.100.61]:44896
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230217AbhGYR5R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 13:57:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXhTdrLsm2DRrIhGc3twF3/R1yscZuAevrtpSl00qbAgBC6Uq1cMFBHO9ecg1JV+dG1JIAEYQLV1JXm78EEaSvXAwuCkFJ2aMNKngfOducK98i1dEeT1i7H89koE+R/AScUOu6rHl5rbxQd9xylDuDvCzK3UW5zE2WYZTydjz8aHMSafAnE4jEATfuSgiDlhVQkf+0KQnnvgFN8LC+xWWAgt/+4eEMSUZFvaCpj4buj+PjbfNWW2RgytqgW80Al0jsvat9Ibok04GU9XySWZfBxlJI0ol40gjwunmC86w7mqxg13lV4Etq28+Q8p1aFFtkfTNqQNOug6PXnYvEETyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sDpmiN2IBkJdk0Gf223kJbEO7bPEXu1RRubLx46LSNI=;
 b=GsRbu7T4EKIUn10b3JFSF4O4s6UPUosLvTsrJCZepNHJ7v0cYcA0HBDWAwgX6hQnnXTErLIA/re9N9IWV1WKV2QpjoNuJRYVwU1z9bKAECVuq8RW1GjB54VcDi+TI0dzyKhOOo1D5QORw34qeNylfU+MoTGYqLgDe8lE19gjcN4naQ+4ws95VczA6iC1CWn32UpGYEnXkEdkRcM4vLthwCFJ3zDz1fYecpDuUoEJW4jf6Zbh44THvG2CwlZFfl0VZxpJF9XfboXApYQkwpmvHWxaW4NElUzuuIwN3ghkCLizZV303u7tsfdy9jKwhqziI3/oxndVXPMSx059iub6Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sDpmiN2IBkJdk0Gf223kJbEO7bPEXu1RRubLx46LSNI=;
 b=kzT3AzcmoPwB+mFcmxcR/Q2uK12hUL1+jqZmhqRRabE7HosvkCjW7Zv2q5KD6hzmsfBpMVyS8Pj8mwB5DbpjYUx65CW1JGlzCSmcZVREpe3TbM8EcPZeE7U5KGE0GrTlpxrmNwUCArmYSz2u9yz1jmW9Kks872aKd3HNkpqEuIvVeHhnYpz9weESjhHt+Z1Z9BM90vAq+HPzzEtVmjjRtiu8Gv1JIYwGwqQWoNOxFvMumpo9Hi49P9N4cNYA+gSI4Wj4tZBmrYmKsRuXw/6DaCZ+1leA6ri2e6hx5lhRM/BB1ZFRbqq3FsNWyfJWbRW3c9vSa2wgseNGwgLG9XhbMg==
Received: from DS7PR03CA0075.namprd03.prod.outlook.com (2603:10b6:5:3bb::20)
 by CY4PR12MB1269.namprd12.prod.outlook.com (2603:10b6:903:40::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Sun, 25 Jul
 2021 18:37:44 +0000
Received: from DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3bb:cafe::43) by DS7PR03CA0075.outlook.office365.com
 (2603:10b6:5:3bb::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend
 Transport; Sun, 25 Jul 2021 18:37:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT034.mail.protection.outlook.com (10.13.173.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Sun, 25 Jul 2021 18:37:43 +0000
Received: from localhost (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 25 Jul
 2021 18:37:42 +0000
Date:   Sun, 25 Jul 2021 21:37:39 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] devlink: Remove duplicated registration check
Message-ID: <YP2vc4CDrxVzKc4d@unreal>
References: <ed7bbb1e4c51dd58e6035a058e93d16f883b09ce.1627215829.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ed7bbb1e4c51dd58e6035a058e93d16f883b09ce.1627215829.git.leonro@nvidia.com>
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5131c1e8-0a78-42c4-9bc5-08d94f9b4a8a
X-MS-TrafficTypeDiagnostic: CY4PR12MB1269:
X-Microsoft-Antispam-PRVS: <CY4PR12MB12698B9E710DB5CD97472B0EBDE79@CY4PR12MB1269.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hQc6WZgZzaBk6AcIuRJGOcOcAFNa0evKMVtN5DGo1xi1lHLNpmsvB3fq3TCElke+4S+3DtUhD3XFO8tT5o3OMUBcGbnIBGKkmwRgLwMiAzMVTFB+6rcmS1VMZxQBY/5Rou0JpoDWSZ9PZrCy74hcOK0dOQdgc/d6GbLMy6ma+hUolvpz2WN4lhlVNx9xKpCrLlrqPswCp4F+Pte5yMcdizjssfAYIwZfPccBNSDO4QI5h0/eislJwDtTFNE70wPEFgZCHfR936hTBgtfqTaehEAZERcQ7XnQTk/yoi7iSJLLXuJbylwvOHogWr/9WL3kQc/OpBeSjo8rFon2mHeY4leAruaeOrJXAcBtzOmidb9dMO2SkkPqoZE558AsjswSrkxgz5kbfzW4hHSzD1bK3Y/q+k+GIwE+DyTkWPsCeLZP7TTVk/A7bAes2wM+lvBZ0Az35D1ahI87EN8g6MELh+pUw5ies3AI+s0T1xDJsbjio7VuzeHGvxkDqrZeHSvB3K6mH15yPf8sX780pdZIY/ZaqL6d177Gv9IagT4elrwTXQhuooLHy5k75KKUl+EXYxmxBlcqQ9f0uWZUtZeoQfLr2s25G00YwhH7RjamYo3QvlGNwAQ0z6WUJ4wXjxuCivNZfzzHFk2ZQCrhle3aF7akH86fy8Pb7QoTU54BPhmMpIYUy7SoJDLD3O+RK5PkRlZNCYcw9cxWcy0n0DHmcA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(7916004)(4636009)(396003)(39860400002)(136003)(376002)(346002)(36840700001)(46966006)(83380400001)(82310400003)(82740400003)(2906002)(8936002)(4744005)(8676002)(6666004)(6636002)(186003)(36906005)(336012)(426003)(70206006)(70586007)(4326008)(86362001)(16526019)(9686003)(54906003)(316002)(5660300002)(7636003)(478600001)(33716001)(356005)(110136005)(26005)(47076005)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2021 18:37:43.7739
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5131c1e8-0a78-42c4-9bc5-08d94f9b4a8a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1269
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 25, 2021 at 03:24:41PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Both registered flag and devlink pointer are set at the same time
> and indicate the same thing - devlink/devlink_port are ready. Instead
> of checking ->registered use devlink pointer as an indication.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  include/net/devlink.h |  4 +---
>  net/core/devlink.c    | 19 ++++++++++---------
>  2 files changed, 11 insertions(+), 12 deletions(-)

Sorry, please drop this patch for now, I'll need to resubmit it after will
fix completely bogus 6a5689ba0259 ("net/mlx5e: Fix possible non-initialized struct usage").

Thanks
