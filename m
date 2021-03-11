Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF75933780B
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbhCKPjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:39:46 -0500
Received: from mail-bn8nam12on2073.outbound.protection.outlook.com ([40.107.237.73]:21153
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234208AbhCKPjX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 10:39:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=krudstgYvLMz2LYsUdTMrhi6Ixt6LV+ePwHZ7Wp3COPMTWtv99k4xLwZNA5Vx0Ee7ewBNgYtagYlV9SSVEfZsKA6dAju4PNI1jatRKybdlmJ5kXJFUqeNdAuRMJ9BXeC6ZiZ75PVCR5fNuGjYXe20zsGq69b4/GW2uvP3AOVHbOaLZ2Axx+DvkH2K/CqJWTxaeNXbdfMMQ2E0ZjgaX+CSQOpRQ0iQKQ/GVLsey/Vtz790HPlUvkjNmjSMQGfeSk7QdGu/qbU/CC3CEMp901g39hfoTMHND8WlTdg7jsdKIfjiXe8bzVwtafxDmmSEIejU5ignCUvPSZo3aj0kN7bfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IoGkhdssjWGEila/WQ5y/XVHWdLdaAOpZqG/eFdQzzs=;
 b=bV5j6bhiL9uTD5d0bT1yDrC6N4C3cTIbiNBYC9iZqsTJfWqaVJD+uoKkJ+zWSGuj5HgNrNNBjaIuKXq/MGFNTUbhEtg9pKkCbBCTWYBe/4Ab31S4eQJcyOayx8+/LjmXrLAlb8enFlsuPzdOs24XpdhyECkpvfImZxn/Jx6SLo4S/m1tGsn1CVPMOBCvqUorFeqNWOJfg8E/s4U9PGXS3Us8dbSJ6zqYLBOpUje2a3Lm8DzR3wyMTJYxMvj7+U5pKXAqrn7T5W3wxDnJfjjO+ekPtOR1rvynLfrOg9Hbj0ydXcfkInUJ0bXy1U5X4LH+wLhjpABqoP7FFtseo0rrfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IoGkhdssjWGEila/WQ5y/XVHWdLdaAOpZqG/eFdQzzs=;
 b=Vjn4zCwthCcVsUQu9nLvPxW/2X/fOzJ6uHa7ZYDAhRTgtIGmEnVqdXkr8kHtn4enILfAB5MvHVYW6rTILvjjbWQsbassmvyAx65JiU4ameT34wPYeSvGHTV0NHfpW5qPb8yWfbJzajgoiFTWiLNahcFTGMDcCKSpNRCCRqlXFWL4PzjayozYtV9zhO0YX105b2B7+rRZqeX5MRwzwYktsS4WJ4u7AUSp5lEl3yClvfY3avKUGYgyqqE1htE7OFYh0cZMJxrxVMOE9r4MCrzg09jG/nbO83Hk8ocBwk2ga9W+TI3yXcZXiBsckVpOtxErtkmTVFKKSL7itZ1EgAQ7WA==
Received: from BN6PR13CA0004.namprd13.prod.outlook.com (2603:10b6:404:10a::14)
 by DM6PR12MB3531.namprd12.prod.outlook.com (2603:10b6:5:18b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.29; Thu, 11 Mar
 2021 15:39:21 +0000
Received: from BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:10a:cafe::2e) by BN6PR13CA0004.outlook.office365.com
 (2603:10b6:404:10a::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend
 Transport; Thu, 11 Mar 2021 15:39:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT004.mail.protection.outlook.com (10.13.176.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 15:39:20 +0000
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar 2021 15:39:17
 +0000
References: <cover.1615387786.git.petrm@nvidia.com>
 <99559c7574a7081b26a8ff466b8abb49e22789c7.1615387786.git.petrm@nvidia.com>
 <5cc5ef4d-2d33-eb62-08cb-4b36357a5fd3@gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     David Ahern <dsahern@gmail.com>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 03/14] nexthop: Add a dedicated flag for
 multipath next-hop groups
In-Reply-To: <5cc5ef4d-2d33-eb62-08cb-4b36357a5fd3@gmail.com>
Message-ID: <87k0qditsu.fsf@nvidia.com>
Date:   Thu, 11 Mar 2021 16:39:13 +0100
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e37a9a7-0642-4283-28e5-08d8e4a3d703
X-MS-TrafficTypeDiagnostic: DM6PR12MB3531:
X-Microsoft-Antispam-PRVS: <DM6PR12MB353147FFAC615BE490A5DA02D6909@DM6PR12MB3531.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GbQVTihSLNMvnxh6xSDW6IgPvewC7/JjlopXzMQ5m2sCqZRtqkWYpOLxjcYrQSsDLP/1CEMq/4GS5VLe6fA5XX6LYqsXYGXc0lvx1V5D0NgMBduwX6TNG0Va8Qk2vvPPilGMZ5zHvrpC0VeYii0h2KqfT8Po6k3NcIU83vQXjWzI92+EnDuQZ2jvWOm4u7TWVbMMakq/pGU+StI/KKmNPBkjxO0G6RYozoXCZNGSEvl2zVI72gVLyh6U42M/GYCi99SRBzAXe+c3C78Arb14u1DrgveVKucpBlhLbL6bDRgDggWBtY8UWaIhFkHRPJODuvzKL4kk9r0i4BlsE2rwBAH1hDAp06bgR0tgE050DhIKQiOXcNtNYj/QeikCE4OoCp0YN/U2kvIpu62m8VFUWRE67uXlIVliS0zQ2lNuu733iPpwhZ+3IDBBxQKVlmNHV8iaPhpqVcFrdE1OpSQ6ymeQR4vA7rRPSwlNgLJwLCs23oGbPlDfMiLKX80wpRDgyvqhMwxJp0fcIgFl1s9aX8R1+W0Ubn49ctbWGpg2Hg4GJ6Fgb9tNxbHfxuknutjFgUMNiC5MmMFULVP51symo95rPQpw9AUSeZx/ncwwtuvUNG42oGKvH5yUcGAaGoJJb9t4nwDs4RWd4sZUsZU8cTrRxaNSCdnt3lDbmpexf2SWhBe/zaZePWdRyeGwy1e+
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(376002)(346002)(36840700001)(46966006)(356005)(26005)(6666004)(7636003)(83380400001)(2906002)(186003)(2616005)(5660300002)(54906003)(8936002)(82740400003)(34070700002)(36906005)(316002)(8676002)(426003)(4744005)(36860700001)(336012)(4326008)(16526019)(36756003)(70586007)(478600001)(6916009)(86362001)(47076005)(70206006)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 15:39:20.9516
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e37a9a7-0642-4283-28e5-08d8e4a3d703
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3531
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Ahern <dsahern@gmail.com> writes:

>> diff --git a/include/net/nexthop.h b/include/net/nexthop.h
>> index 7bc057aee40b..5062c2c08e2b 100644
>> --- a/include/net/nexthop.h
>> +++ b/include/net/nexthop.h
>> @@ -80,6 +80,7 @@ struct nh_grp_entry {
>>  struct nh_group {
>>  	struct nh_group		*spare; /* spare group for removals */
>>  	u16			num_nh;
>> +	bool			is_multipath;
>>  	bool			mpath;
>
>
> It would be good to rename the existing type 'mpath' to something else.
> You have 'resilient' as a group type later, so maybe rename this one to
> hash or hash_threshold.

All right, I'll send a follow-up with that.
