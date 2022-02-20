Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890834BCF0B
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 15:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243999AbiBTO1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 09:27:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbiBTO1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 09:27:50 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FA440E6C
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 06:27:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ww8L634Zu+RUh7KCDujpQAPRMRTzUPyDKKfhDXTKI1UdxDXugESmlkVQK5FOR7OftCq+/hAJXlFbCgJpdQLM44KiYinyFMVJiE355JnLjeSaK7guKWbxA8a9qkrBKWumIu9kWab3ZjPrHilWCbLaUrFIV9vrtJrHvhaANDXWij/9ILqGRK0Ob3XaFIwIQt6HnHBGDhJ/gz3XjJCUBPts1NelwSIXjVEgRxc98gaJfY7DWXdddRMBAbgchI7+75WXFhgzwT2+jZJdtVqNlTFmCeSZb/FUf5IthR21zbanuYUrvnXQdSLgnxSIqrUiwVjxhLEhpT2qRE+6mIrVmNd/Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6rz/nCW+cAyFNIK58aFLMEpTk7/90jSKJarTLXU0Bsk=;
 b=NRCSalnhr5cWmNciC/lE1bVCUSghszQqYdxO7Q3AuyIH61S8NqANCcupDM2yKYJKB4U53mtlrrErPuPqeLKLDlOWxLfwyy7rmr98PzDfZsHIgEgs2DfkFc1H73iS02Blo1tIUdrsPlWohKmURbnYb9wj5VtvTX6k+t0Rlxg3AV7EugEe0CXvBCNeUcAltftyHrUyXsOk6/+elAEhg7wk0Pb0BoLCsCivPBQyJS1/RjjLRynuR9ozAKEgn/fz342sUA8gzCMlTStm5gR5vCVKNiFECxVyP4DXfaf8TeoXR+f+t7jzE9LhHBx/p5dkv17tKLXRR1YWXl2T4f6fueY2dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6rz/nCW+cAyFNIK58aFLMEpTk7/90jSKJarTLXU0Bsk=;
 b=WN9mPCoao7C4+t+mshyx8+YF8i8HUPpeFzCUV3VeBF5xaxQROtB4nQ/iWJ6Ovrsv83rKSFcQVEMErh+YiMru+pRunMehVOGXF4nOJnmfNTbHR4rtHe8OQgR6z4DR97473YGUoQ1M8V1NTR7Xx0z7HoMd2+JfV2zneu18DIvX86cnOrauQ+GzbwMY3Db35mHYRZVZB0m/i/mKG16Um97eWZQ+dvKAL2zUXMTV3WATYEm9CONpfztjzazj0Oqq2kmoNg7yfq/GAhClv25y7KRRojxT0k65tQ1an+OxEFMwLypkI++iuv3gcFBw4IfboeY1STGkVgeloHHro7y+RBgmUA==
Received: from MWHPR19CA0012.namprd19.prod.outlook.com (2603:10b6:300:d4::22)
 by BN8PR12MB2915.namprd12.prod.outlook.com (2603:10b6:408:9d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Sun, 20 Feb
 2022 14:27:25 +0000
Received: from CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:d4:cafe::fb) by MWHPR19CA0012.outlook.office365.com
 (2603:10b6:300:d4::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.26 via Frontend
 Transport; Sun, 20 Feb 2022 14:27:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT048.mail.protection.outlook.com (10.13.175.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 14:27:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 14:27:23 +0000
Received: from [10.2.163.174] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 06:27:22 -0800
Subject: Re: [PATCH net-next 12/12] drivers: vxlan: vnifilter: add support for
 stats dumping
To:     Nikolay Aleksandrov <nikolay@nvidia.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>
References: <20220220140405.1646839-1-roopa@nvidia.com>
 <20220220140405.1646839-13-roopa@nvidia.com>
 <60a36c9a-a989-1e6a-c2fe-d996b1e8b3ae@nvidia.com>
From:   Roopa Prabhu <roopa@nvidia.com>
Message-ID: <af2e5895-ec23-ee39-66bc-ee74d90e8415@nvidia.com>
Date:   Sun, 20 Feb 2022 06:27:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <60a36c9a-a989-1e6a-c2fe-d996b1e8b3ae@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c8da884-2f09-4034-12ab-08d9f47d1d46
X-MS-TrafficTypeDiagnostic: BN8PR12MB2915:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB29153AFAEFD14C0DCCF51097CB399@BN8PR12MB2915.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qcxgnlJlBPdbJR7dqOEpA6gvJCtUOqJVDfmruCGrSJ9OrRiHk2BUoEjyxdvXGvXseoqXVx0BKg/YmQ/llTBA5cQ9LNJTs71CQ6Y5GqJlyLFoH7PiBLTE5J6XLDEDzs1BBuZsAb5XHEEfycCEIjwq5vxLEV2T6eY2MglJ6PH0uTSLi7bGwyTWhYN4X0yJ/mNSdngdRApSqkM+tZaBLm8/VLQo3sKJhyoiPd/++MVCTn+59wnfrPk6yxd4F+J24sm4nbGgrVxrgjZM95SGGrjlPwRxW3/VqW7pyFcRMe3Ytczb0b4WWvBDQg5fNopoMg79wJXbLw774t5kT4WytIicflV59r+ZR3N6u3v5kp+ROU+GoJyz2vvDNqpygeozQGvlCASpTjUxGbI2NotR9b7KbDmn+AsM7jkH0y60uIMdBASIO+IEbcfpYfY4A9RoJGx/K2QLzF3wGuSUljPLLaLe33x/QOyX+oYi0O9B/FCt9ADOK7XYXb+W8YaBfpW8X7bQAmtAAizGnSmVUQ7c0h1klpQSOqR9yUp9Vo2deHR6MOoQ0cRQKcnk8gKgASYTcz3k1tO37N7dAWJzxSx0wxTR24NfdQwOY1Ru47fYD9UQDK6gnCqd4v/a0r84V2gMCpVsayi0zE/b3+VrSPy/3xWpMlRFXhZlZ6SrKC3Y2Ans3Mf5kW4y20cGKez9QIfNhPx0tk9U0bE3y+1M58jZKij0/uzg6YTrLiSZrzwI+I4ZJsPZtDI75u/irjdNctgNG0dx
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(53546011)(36756003)(2616005)(16526019)(186003)(26005)(336012)(426003)(2906002)(4744005)(31686004)(508600001)(47076005)(36860700001)(31696002)(70206006)(82310400004)(40460700003)(8936002)(4326008)(5660300002)(54906003)(110136005)(356005)(86362001)(83380400001)(316002)(16576012)(81166007)(8676002)(70586007)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 14:27:24.7606
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c8da884-2f09-4034-12ab-08d9f47d1d46
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2915
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/20/22 6:12 AM, Nikolay Aleksandrov wrote:
> On 20/02/2022 16:04, Roopa Prabhu wrote:
>> From: Nikolay Aleksandrov <nikolay@nvidia.com>
>>
>> Add support for VXLAN vni filter entries' stats dumping.
>>
>> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
>> ---
>>   drivers/net/vxlan/vxlan_vnifilter.c | 55 ++++++++++++++++++++++++++---
>>   include/uapi/linux/if_link.h        | 30 +++++++++++++++-
>>   2 files changed, 79 insertions(+), 6 deletions(-)
>>
> [snip]
>> +/* Embedded inside LINK_XSTATS_TYPE_VXLAN */
>> +enum {
>> +	VXLAN_XSTATS_UNSPEC,
>> +	VXLAN_XSTATS_VNIFILTER,
>> +	__VXLAN_XSTATS_MAX
>> +};
>> +#define VXLAN_XSTATS_MAX (__VXLAN_XSTATS_MAX - 1)
>> +
>>   /* VXLAN section */
>>   enum {
>>   	IFLA_VXLAN_UNSPEC,
> xstats leftover should be removed


ah, ack, looks like i only removed the stale reference. will include 
when i spin v2.


