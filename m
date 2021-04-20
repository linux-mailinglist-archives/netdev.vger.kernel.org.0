Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21997365E34
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 19:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbhDTRIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 13:08:30 -0400
Received: from mail-dm6nam11on2046.outbound.protection.outlook.com ([40.107.223.46]:19521
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232879AbhDTRI3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 13:08:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bGmwsayIuT2//v1No2A4IAtlHc+Cz9+RX/b6pZzhGjjpg6e+bbpf5qOsLCEnKbbBiJndiylMIPPj4FnxHGmEIYuCuhQvaJA0NfqtLmopSFv8P7pnbvQk4XKgPzxN68sAkOWiygDbgqBYj3KyYYEGnS3QwuDWYRQ/4THVT+9RieEdgrTTH9t/QjMWibm6IxNM9UJ0e3vyiHtZJGjLVXwEZ1YzniLajjWoQVPYCRe09Qt3riEbe8pANZbgTx2wHHfvy1t+EzUk4VS6Uji12FvqiIM2qiFavRJwbFkh0/x9X+zNfHTX8hS+kP2mPK/s1MwA14liTzGrYCr7gJvlKU3cGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XiMQBUy0HRuglAL/lPs39/XvmrcF1ei87iMGDm1Fk/4=;
 b=Q6pE2YwfoMDEOQnGQJjdAYQ+39pY7x2OHAHssVFxm455i2v8rtlCYadecRO+Iw+p4z1qnXZHUvQ6gx1mHPkcuJoFBdIGbU6Cr3tIGl1e95SxAo08Jkl/yTKh4QjyJ88bK71YpOzvI57jywfoQCOtfUG00o3vkdW2D9acKOeBsRLuJL55w6VXwsDHF+LDczmd5pvX5j9jqCfEHbdrfSqMG5GUkU/UHS567HN2cD1LOU9pBxK4NN6AE6RmFXRCrqh41OmUU5mguNJ9+vIealJffHIAcAVLjVCUCdHdWURYWSwmuNHZBL8jBJYG1lyh2OkACgJg1p+sDjgJZvJ/05IUoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XiMQBUy0HRuglAL/lPs39/XvmrcF1ei87iMGDm1Fk/4=;
 b=E0BG+yFb7AgkEGgeDnkgW6SUBaxqHVjFH2DGMVpFRjXM2nSpmUC7EfYfZ43CAf6bzn7G3JjW4wxUmIE8XpJ/ToRzvWSuhzy4/fNq1o0st7aGLxJg0c1reJ0OV1w6+XW2glCnQ5p+T94MmSk3z9WRSLKQe5IAbAp792Y9kEQZsG8ZzQRvE5hkzg7Z3Gxpccgme0/FEi2Sr4H1111ONv/i9l8SNPrtLO48N2Q7RzdABhIM24Px1my4WGPlMePT3c8nnEmRVbJPWP2HJOeiCYNJL6oFo+pGPsOVetzcPIYOqlT8eAW97zTH4tonYPMIU7wzlXUGUg/ckbtd9awEx3yp+Q==
Received: from CO2PR04CA0142.namprd04.prod.outlook.com (2603:10b6:104::20) by
 MN2PR12MB3792.namprd12.prod.outlook.com (2603:10b6:208:16e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Tue, 20 Apr
 2021 17:07:56 +0000
Received: from CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:0:cafe::57) by CO2PR04CA0142.outlook.office365.com
 (2603:10b6:104::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend
 Transport; Tue, 20 Apr 2021 17:07:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT067.mail.protection.outlook.com (10.13.174.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Tue, 20 Apr 2021 17:07:55 +0000
Received: from [172.27.15.78] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 17:07:53 +0000
Subject: Re: [net-next 07/15] net/mlx5: mlx5_ifc updates for flex parser
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20210420032018.58639-1-saeed@kernel.org>
 <20210420032018.58639-8-saeed@kernel.org>
 <f21f0500-2150-9975-cfee-1629766634b8@intel.com>
From:   Yevgeny Kliteynik <kliteyn@nvidia.com>
Message-ID: <de33839f-0bcc-f999-7348-6ffb54a10e35@nvidia.com>
Date:   Tue, 20 Apr 2021 20:07:16 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <f21f0500-2150-9975-cfee-1629766634b8@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c17d2e0-24f7-413e-60c8-08d9041ed77d
X-MS-TrafficTypeDiagnostic: MN2PR12MB3792:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3792A26F5317AC061BC61B34C0489@MN2PR12MB3792.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ga9FDzNkVD541IYTSakTRiHx6kISjWsaRxbk3KMWd5aG6MuWjJOOcBUQJFOm5HCIrlJU5rDvpM6sbxwui2031BtJBL5GvuukcCHZA2NrqLynTRA5dQXAk/VhKMu0KwX55qrIS3DmVy2+/kwpGlwZO+bT008GFSx+Rki/d3rP2rlay/kTunu0HQdZLdDKU7eekc0zJa6DPPYA+qwIgWghj7wDyW8cDF95fo/F2Z+/kdQ4BmJR0tWIbdsgnOQnGAUuFErFLELa33k63fXrJVFTJnCYdJmtMiGt6/zK+43TBG52exh7vZoaFirS6ijo1OAhSbVcDuNfCmunKSKIVrPLQ0j9u9O88tXw+IGKzCa+Cf8Q0MAGLAF7G1S0UZEKT7srMONUH1Q9ePa5SAui7Nn04M50D6K6R0p4gy363hVWfbmklglye6tJFw2v431NWQdbXU62wWUWP96ehU/kBV7JLFGwN3CogHfMO4ua4voBJWv2KmiXk+V5hGyb7p+E2nOaa5gTIz2M9H2UXaCIYEJRp3MTaf142FtZJeym98K83kWkUQcpIjDDsyNiqYc4SXaFfU/niiXuZGsCMRpaq4Bid9azBMeMkV9/MmhdwOhJ8ni1Is03v+GS2DqZuNAhiN8/o5hSBCihMC8wNv55VSEyKV/ehx4KmNJavHcLx8KfcTMYpNWSLTYf95Hd8bwgpecG
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(396003)(376002)(46966006)(36840700001)(8936002)(2616005)(336012)(478600001)(16526019)(107886003)(86362001)(5660300002)(82310400003)(426003)(4326008)(6666004)(70586007)(31686004)(36860700001)(70206006)(186003)(2906002)(26005)(47076005)(83380400001)(356005)(110136005)(7636003)(82740400003)(16576012)(8676002)(36906005)(316002)(31696002)(53546011)(36756003)(54906003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 17:07:55.9424
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c17d2e0-24f7-413e-60c8-08d9041ed77d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3792
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 20-Apr-21 07:54, Samudrala, Sridhar wrote:
> External email: Use caution opening links or attachments
> 
> 
> On 4/19/2021 8:20 PM, Saeed Mahameed wrote:
>> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
>>
>> Added the required definitions for supporting more protocols by flex 
>> parsers
>> (GTP-U, Geneve TLV options), and for using the right flex parser that was
>> configured for this protocol.
> Are you planning to support adding flow rules to match on these protocol
> specific fields?
> If so,  are you planning to extend tc flower OR use other interfaces?

Some of these are already supported through tc on DMFS.
This patch series adds support for SMFS: Geneve options and MPLS
both through tc and through rdma-core on root table,
and GTP-U is supported only through rdma-core on root table.

-- YK

>> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
>> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>> ---
>>   include/linux/mlx5/mlx5_ifc.h | 32 ++++++++++++++++++++++++++++----
>>   1 file changed, 28 insertions(+), 4 deletions(-)
>>
