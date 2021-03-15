Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C5033B13F
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 12:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhCOLic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 07:38:32 -0400
Received: from mail-bn8nam12on2047.outbound.protection.outlook.com ([40.107.237.47]:13312
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229634AbhCOLiY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 07:38:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Erhc/gmKzdmluNDukgzDo3KR0/g7C/77QzF1FcBVob43b+rO24+SG+FmBbYTp9opjPvcMVNXSL4eRv8nxOeyZima+beaAi6VJA/Tqor/cX6sjQcXdhH7QYm+f8kPmU7/gKw57YS3Qf0SELu3dy3icMcER9kXtuq5d88/Aoy2VNpGupdtVIoUO9flANTp9E/xCEa1jgIs/57iFCQ4ELASocia0cx1K8RjcGxys1XQZNt7kXhAq9im2HUP1nYEcbXIb0kl6cid3T7YsWsrdeSPdJa3aHEpYr9Y2s4nLWgtE/2HvzbqLi4xLoGL058Zqnmc09vbFPzgfr46Jr/wK6PbOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRtUPYBQsZtvV7s8hnPXI9wXv+WUGdJ+8GcNDVfF4Bs=;
 b=EGFYIuYBzNdS7mBJllzEDadJVMyccEQCz9sK6LcUAyY5oj8NTT0Xye4FOwggm1DRAYI4eaLOE9v94MpsthxcBsmkdptIQneKvPMNFildWLHaRspKKJHSoeeNhQPQ7myp+rsoYmMWXpGHZxWjqYqcaZ4rENt3xn/V4moTjM+2AFR/zOpdO4+ab7+gzPCOZL8scnEV1H/zYqikUQUF38szVlzD66ZI49XfVz3msQIxvowQjcPvhHE90QN0uxNJRJUIPu4CPw/XkbRamYnUsCeKFhiKefWNygTbck5BqOkJPJXSjMtZ8E8PFt3qGTDsNuClwAmqFrsu9W5HMclU1vK2Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRtUPYBQsZtvV7s8hnPXI9wXv+WUGdJ+8GcNDVfF4Bs=;
 b=VoB9okiRtVdzcP36c7GpXl8NKynCVgnlq+A057ZOWFFm5SJz4PUvkyLej8SMlzLPX2HR7aRCeMUsqJcDJ8uFZZSpY0Bt+dDl7lZNVQ+FL7Xz/jvUmQg+UOy9vvAyXZ8ymXhWTyBtM+JmVSDVJXtIJ3UeGkXuMTJsONMamJ6BfaJcLa3JXNRUJglmk5XZnuXJ43hd3ZI0MQTBT15eCWhIZqquF3UU8muhTgKT4AJwRvoYBpr2dwj8Ur3iHMJ73xgWhTH8oz7aJ0ECizGUu44QyGDOnPv1gkwCPG1e6jkn0AtnXZBjpa6xRsuQuq/2lZBcG7Id3jOb8hhJvBMBWi3JsA==
Received: from MW2PR16CA0024.namprd16.prod.outlook.com (2603:10b6:907::37) by
 BL0PR12MB2465.namprd12.prod.outlook.com (2603:10b6:207:45::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Mon, 15 Mar 2021 11:38:21 +0000
Received: from CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::d9) by MW2PR16CA0024.outlook.office365.com
 (2603:10b6:907::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend
 Transport; Mon, 15 Mar 2021 11:38:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT005.mail.protection.outlook.com (10.13.174.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 11:38:21 +0000
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar 2021 11:38:18
 +0000
References: <cover.1615568866.git.petrm@nvidia.com>
 <b614d787896a33481e09487deec42b482fdc8643.1615568866.git.petrm@nvidia.com>
 <5397a5b8-da46-7290-9395-5fcd46121f42@gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     David Ahern <dsahern@gmail.com>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        <stephen@networkplumber.org>, Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <me@pmachata.org>
Subject: Re: [PATCH iproute2-next 4/6] nexthop: Add ability to specify group
 type
In-Reply-To: <5397a5b8-da46-7290-9395-5fcd46121f42@gmail.com>
Message-ID: <87zgz4hck9.fsf@nvidia.com>
Date:   Mon, 15 Mar 2021 12:38:15 +0100
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c34b269-7498-4986-3ecd-08d8e7a6d630
X-MS-TrafficTypeDiagnostic: BL0PR12MB2465:
X-Microsoft-Antispam-PRVS: <BL0PR12MB2465ADCB30503688BD5B4257D66C9@BL0PR12MB2465.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DwBYgiXyVt8jIZCJsM76SetSKc9rIl4lSBnLd5Xw+TLjzUH7gX0PL9Mfa2MAQC/L3lnhV6q031s8KbLmgfR0J0clYjDOhTs9RaqGXbQqWwbLZGaTXQeUTrklAGKUGsnnYftmYefpfSkAYRiol1i4fyAOANCv7u5et7T8DK2VxmyEg+gnspBCf2O64JJ4eX8BI2HgkyQv2uPtbiLMCnUwVx1PTMzf1nDH7fF86jwPjpFgjskFltIL8kNlU/yli3oZInRJPVEnYyI1Spj7nGtAObPBe4hWds5XK3mukj+cuQDJ0MYcvmg7N/SsejEjJHJhZcbulUAQdZl53w0WTPiiTjMJnH7OsomCe8P3epJCzGvAdk/4vVwtxuTh+04CQvL5SlH4GRICwEDo21WNQlB/OR8fOK+1ahVJwBkAeGksHKYcSLQCzO3BFLxFF3e21Hf0W2h0rwT1T37vYX9dhk7FuJ9U9JSrfwPidJuLzQXsBJZ1fRuJVIOaymhq3bGATPMLQuEEMrLswAoBuDemtUxKA9WznWlTVkW1wBIZ/2kX+sauzkBCWXxq8bqlJUKF9XuNM344XF2uU1eJF/1A6WvTSXfUYsYcD0mDeWPe9br2IdowO5jEk1kFCTkhYaKb/yhvX+Q60t5qVQZn70vPV7GrzEBntwEekNOeQicd3P5kUo0P51ENsl90FEaxLXfWZfQu
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(46966006)(36840700001)(82740400003)(47076005)(82310400003)(8936002)(53546011)(36860700001)(4744005)(2616005)(86362001)(426003)(356005)(34020700004)(186003)(336012)(316002)(36906005)(26005)(6916009)(36756003)(70586007)(2906002)(4326008)(70206006)(8676002)(16526019)(6666004)(5660300002)(478600001)(7636003)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 11:38:21.5889
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c34b269-7498-4986-3ecd-08d8e7a6d630
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2465
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Ahern <dsahern@gmail.com> writes:

> On 3/12/21 10:23 AM, Petr Machata wrote:
>> From: Petr Machata <me@pmachata.org>
>> 
>> From: Ido Schimmel <idosch@nvidia.com>
>
> All of the patches have the above. If Ido is the author and you are
> sending, AIUI you add your Signed-off-by below his.

Sorry about that, that's a leftover from when I was sending the DCB
patches. I'll resend with the correct headers.

>> +.sp
>> +.I TYPE
>> +is a string specifying the nexthop group type. Namely:
>> +
>> +.in +8
>> +.BI mpath
>> +- multipath nexthop group
>> +
>
> Add a comment that this is the default group type and refers to the
> legacy hash-bashed multipath group.

OK.
