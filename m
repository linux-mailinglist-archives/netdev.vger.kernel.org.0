Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937E443B781
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 18:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236433AbhJZQrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 12:47:47 -0400
Received: from mail-dm6nam11on2077.outbound.protection.outlook.com ([40.107.223.77]:50016
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236424AbhJZQrq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 12:47:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DBFZrpu5RwXhciqT7U6O6cWe2T9pjB37SzdpltKzfhcD/yKW2NvncLZlQREo64//uzjIT0OxxRqRewMZd9GzjOuEOcyR5EoitfiFs6VTxwvVuj0NOzSlyLGyxYUjNa/8SYSk6rjAugHSMXWbj6h6etyesRf3Pii7MZXc6CjBknJGRQobECRCWNhhiZFnXYU1Wlpwt45AMS8iAtDLZqG/FGAlmM40BplJeAMfaDx907NI+nd2cWzeOaDd5qLjheKT/EEFU9VSVDUnxJtaZJ56RmEJrfd6v0D7vckj3XEWQ85CuXEQVO7np24H7+F0L4YZ2Bxq8+gtTOL3C9Eix5ra0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WOkFw00SW+pvKxJisDx3llktnIOEI+GrepxAnHY3O+k=;
 b=W1NqtLhTTWmidR4pi7otDRohIHpKYXzgUCTuk8+hX3ZW5iDQTgEpABuklx4oAjm2v5oiwtJUbggX9H9x8TYXT9ee8VEh246VOjoAZPsr0/2zJunLmcijw6KNRwdjy25pZtC8sWxuwa6RZdjEXFUASpR2AWQa2AJaYWPMDXf6g7fztXTGls/pmIXHER+ZS6pZUiX/0LhJA3S+N1r5beeC+LEX6/fGqfrXxjIuh2UkIDEET60e5cRZj5wfspvj4xnTykZ48KMiI1RXVXZTjB3rY0RHpomN87Xb452mqpMsedMHeWErHGGcyFPeAnkhMIA2bOS83r09HkNfiHcoB6/UdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOkFw00SW+pvKxJisDx3llktnIOEI+GrepxAnHY3O+k=;
 b=YahQ4sKezBASxk0ixdo1KSfrRLQo1u28BPuJmvcjj2fjSRX3N3t8EiKJjb3Z5JZCrJ2Y/KRxj4Br4AR9drP5Y8QYF7pMRPEzzCcONTSvCqwNggLcyCbZ2YfJOr397wmuJpfZW2oyA3ExUq7dVlX9azJn0ShEmfAPmloo6v+cw+4E2W9NfjhRoRjZdD6ADzMzjxc4VmPAKLmvtNs4h14Ek6HBXJebRxvfo5PXBblpgWW2PaQEBlpWeduhbG+WXR+bAC/Z59nIOPzqbm8/LOb2FGRQv9fiHg6RtI8c6X+AlcFtP4uP8jYwu5qt65fbJjZREvUmmGnid8SxnmjPRMWP3g==
Received: from BN9P220CA0023.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::28)
 by BY5PR12MB4901.namprd12.prod.outlook.com (2603:10b6:a03:1c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Tue, 26 Oct
 2021 16:45:19 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::4f) by BN9P220CA0023.outlook.office365.com
 (2603:10b6:408:13e::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20 via Frontend
 Transport; Tue, 26 Oct 2021 16:45:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 16:45:18 +0000
Received: from localhost (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 16:45:14 +0000
Date:   Tue, 26 Oct 2021 19:45:10 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <saeedm@nvidia.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5: remove the recent devlink params
Message-ID: <YXgwlsyGtK8qZfHj@unreal>
References: <20211026152939.3125950-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211026152939.3125950-1-kuba@kernel.org>
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d97f696b-f267-414c-c1e4-08d9989ffe97
X-MS-TrafficTypeDiagnostic: BY5PR12MB4901:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4901E4FC6262E52308D9E7B9BD849@BY5PR12MB4901.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P2R6yogdcvUZ47m+OfVGC+wjStlDoFTUgLoERTuT3qFdIRNHGjbxAhgC0eW5pMhze9dl2irbTQdFSviWZIImfbpR0qIzRXLyDiZdGvmMXufwazwhA5nLpaOP10tCTjHJhMgWuww6IRo6KtFNe54UEI0vV0X+4Tv3C1jG5zPTcD1ctwIqnviBGe6vOOfpUs6IuYsuMJc25g7GBTMMOtzFUITwml8hilbMSxNlGmzU5dWQy2FCVoaw+mFrqHXKEKEDO3a+AnDHa4j0OPLQ7r+ZXgXJ9XFjjj0rjkFuwPKRus9jPuclQZ17mZNx3d1pO/IhN2SIuyzMLGWkO41DmTnxGriI2j03JDYgQeS07tyOGB4JIliozWxzE3+jGLE3CZTYt7eggSWOuWlDbK17NeTmc8MoKGm0qw9l96GcApSfaIqhPJgOr/oFtm5aQHq/kLGG8M5srxZO08LJ4quiitiVsJrd2t5sZW1DWaiO7uAU7HA3ze8ZUL0dne68wjB2uhL0a2VrVGtA5YdFRX73ua6TA1jYM81dQUILlb66lMUU6HRJdi8OsM0Gs0UuypPggLrHbHepDRCMkvFbWdNq3/Tx5mMRzFgO1APVjqhigyGrl1HqxQJDaWoh0RjkvmJnaSXpbMD9FFN5J9qJfRjKhynfXH8OS7f5DL8P/nvltsT+EQP57Dce6B4ATsljUxS3ocRLYF4uxjuj+7o3EQcPBhdJsZnpnmrW8EF0pApPO5swTfq/a5guIl+r9sv9PaZvWY8zuk06J4lqsyPKEC7kiZIwnvEx1IwEmE9l96LScZlgpzw=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(7916004)(4636009)(46966006)(36840700001)(36860700001)(186003)(36906005)(54906003)(6916009)(356005)(508600001)(7636003)(8936002)(426003)(86362001)(4326008)(966005)(33716001)(316002)(9686003)(336012)(16526019)(5660300002)(2906002)(26005)(8676002)(4744005)(6666004)(47076005)(70586007)(70206006)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 16:45:18.6287
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d97f696b-f267-414c-c1e4-08d9989ffe97
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4901
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 08:29:39AM -0700, Jakub Kicinski wrote:
> revert commit 46ae40b94d88 ("net/mlx5: Let user configure io_eq_size param")
> revert commit a6cb08daa3b4 ("net/mlx5: Let user configure event_eq_size param")
> revert commit 554604061979 ("net/mlx5: Let user configure max_macs param")
> 
> The EQE parameters are applicable to more drivers, they should
> be configured via standard API, probably ethtool. Example of
> another driver needing something similar:
> 
> https://lore.kernel.org/all/1633454136-14679-3-git-send-email-sbhatta@marvell.com/
> 
> The last param for "max_macs" is probably fine but the documentation
> is severely lacking. The meaning and implications for changing the
> param need to be stated.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> LocalWords:  EQE param

Your emacs config sneaked out.

Thanks
