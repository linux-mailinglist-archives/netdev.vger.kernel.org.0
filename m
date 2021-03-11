Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDEF337AA0
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 18:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhCKRSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 12:18:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhCKRSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 12:18:38 -0500
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (mail-co1nam04on060e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe4d::60e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD24C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 09:18:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MyeAnLXodmvhd1KuwpwhnOJAtZEUVMK/aOagL86y/GDR9Aoxc9hurwdwBDs+i61SfTvA0yteCCDills4LI/QsmDX9jlwCz5Hjh8/6uK/44VVN7W23ngyEHZA/1YhjPfmuykTa33ukL/p15kpAdfzIQvHPFpSxF7z8/1H0vckmc2Atgswso1Ld5bYPDVnoYyhUFabfu0ej5QQ+L1Sr6Ocw2wXNQWthwgVPOYaVh5O445mfQRbvRVReeZ+yG/+s3kMeug9XHKNeu1F8rqXaiJCcQ5HfuWNqb/5yfBHACAjHvCkaKc3I57mssqrKyuElXAJN292q9bPCvOTfux++LLlGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9SFTn7e5+RI7kl0Up4yCRlueDym9B5tQeIsKiH3puQ=;
 b=nL69udLHyxduOHmbOsQp+z0P7cU4S0ycxCdYqHwLRd3FXcx1CtiQwbYCmauZXcJMVgRoBwKAPbo6JpgJSLuAkBtzvnQ9kYANEjIhJRm8Reyc6utsNCFqdfH8z+6jkd2SC7OmDSA1aSi+pffMAwioVsnM1AE+ixtXfUKgR+Jxa0xv9VYiqnIavXS0jUnjJimEHqq8SY/+mFFVmGB9GlhZmdYWXS9OudY+fOihOLqfLuzogGczqqSTnjF8mHMPsa+S1Y9TNNHJRbjJ1Ei/zPrMSzCcj7ODyDQ4RuWMfsJz64aiNj5yLDVeNfe/usiMH/O4rChq3J0w0RZl7gPUHEmlKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9SFTn7e5+RI7kl0Up4yCRlueDym9B5tQeIsKiH3puQ=;
 b=pW7f5l6ZphxOTVzczl9ibv+nTUitQ+ZrX7SE69ZeIVxlHxDXiZXoaK0gzv4AKcjS600GAGYrvweaaYqAVgtm4CF+BfWOH3ToTbYvA2rgAva5pZeTr82Tn3pV2wD1fMs+sLXTxSN32/oWkPdmsJjdhDXP6jJq5rETlxsgVBkpD3c/a99Lb5bD/m2StZuY4RtjbtrEmt6vMLRnrtttAme/OC1cg3deGC0WqSahGPRtFMyQpBbKzvMQj1JXq8SnJdwiUsI/AtaZejYYST//WDpjdm4cWUeqS6SSsEg5q+XG07DUNhNkk4Ujle9goMGekVzRKtJj8oghVWVMzXjLElz84w==
Received: from BN6PR13CA0036.namprd13.prod.outlook.com (2603:10b6:404:13e::22)
 by DM5PR12MB1612.namprd12.prod.outlook.com (2603:10b6:4:a::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.17; Thu, 11 Mar 2021 17:18:37 +0000
Received: from BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13e:cafe::51) by BN6PR13CA0036.outlook.office365.com
 (2603:10b6:404:13e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.10 via Frontend
 Transport; Thu, 11 Mar 2021 17:18:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT014.mail.protection.outlook.com (10.13.177.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 17:18:36 +0000
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar 2021 17:18:33
 +0000
References: <cover.1615387786.git.petrm@nvidia.com>
 <a9f40a79-4ec2-69ae-1663-20c261084dbf@gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     David Ahern <dsahern@gmail.com>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 00/14] nexthop: Resilient next-hop groups
In-Reply-To: <a9f40a79-4ec2-69ae-1663-20c261084dbf@gmail.com>
Date:   Thu, 11 Mar 2021 18:18:29 +0100
Message-ID: <877dmdip7e.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd56dbae-ea07-4f7a-2497-08d8e4b1b4dd
X-MS-TrafficTypeDiagnostic: DM5PR12MB1612:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1612099D7AB6A84C0E3C04FFD6909@DM5PR12MB1612.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GlfR+Zsau5nNpbQcIYJakryyynbylKM8kEH9FaPE+xByTWtN4ditYjUBXAkkkv7J5Fgwa/NSnefHN6r01ErqwGugZYiLaLSneaI1+uNJhkjlpwU0NpcRFZgnYRqrZluOkOUPVAdJvTs6nd2tz/QlKgl85X+yP0yDpcHaD8h2DTXzPOOc0yLVkRVad7QkQZJVJ8fHr1MKP3qcTo84UpPYLJpkw9n/kvLbdkYBLeElFH22nmwvaSMF+D2WWeDS1DQU6oX4C6LZ0VF6flLS73XiScbJjPKX4KWUq/QmQ2zaS8IzHoeaCudI5JKr2VoTNs+La1C6ZrK1s/LYmwS7G6o29YWOL9nj9ARiKh65xcVtNjONps+n0PcPZzjMrBZzFSevfdUlCh/UbgLXWehCuqZqzhnF3UVpbilCeFOXlXhse9jI7sXUfKXeXiGVt8SNnfdwAsmPNxKBRLP8YJkanJ7WreIoZQa3AA7UZtwobipbGG34C1OH6V4n1jHXIJJJ21SvFvc48XpPgejFbHF5yKVUXoFImiziLWFjT/3pTJql+rThZY8Qn68sTiFAF5RDBY1ZCG/Af3s10xsuk5GyZ7mcpY3ISuWqbACE+ZXpupHk5XNNKpkpr5P+DvWdmg9zJzPIAR0UbaB++daQgjqlyISw6V+jio7wE/TY9nPL66yVlKvZ/ern5/RRhvkBBJjIEO1m
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39860400002)(346002)(46966006)(36840700001)(70586007)(2906002)(6916009)(478600001)(70206006)(558084003)(54906003)(34020700004)(36906005)(16526019)(316002)(186003)(36756003)(7636003)(356005)(6666004)(82310400003)(336012)(426003)(47076005)(82740400003)(5660300002)(86362001)(36860700001)(2616005)(8676002)(8936002)(26005)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 17:18:36.4912
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd56dbae-ea07-4f7a-2497-08d8e4b1b4dd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1612
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Ahern <dsahern@gmail.com> writes:

> When you get to the end of the sets, it would be good to submit
> documentation for resilient multipath under Documentation/networking

All right.
