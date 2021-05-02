Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646AB370ABC
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 09:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhEBHef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 03:34:35 -0400
Received: from mail-dm6nam12on2045.outbound.protection.outlook.com ([40.107.243.45]:48932
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229545AbhEBHee (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 May 2021 03:34:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZeEIQebbvMDHxBTsqqxczYzsZ8AIzmPLcU3jl4lqhT6kR9F34PWhk0N8agJllt41Fh3bRd46C8iUFst1NVEaafJpvwNOg3xgYqpSSddtMbunCr0GvHtnS6LWsTrjYRvlYaQTcCAPClWdq9GQur92YyYKLnTTTxoYEBb9dMX2vd9nEg4SW3/qhOZQZo1GiiObEdnnArXxTLRh6vFGW5S+Sz0k8EuASZu22I6HFwTGbwj1jNL/XeoHCGc4rDcsnMFiuSxEMTVskPs6csoQ7bGpsCmukAIPEXpb/M+V4Uq1FTJ8Crjzu8LPe2hbzzen6b2i8CDA62shBlwQZTl3ZMDvfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BYivyJcCyWq4x+yfoqb74zcve5q/laU0IfCW+P9BXM0=;
 b=XPbLQT+aps1elVtr42HnZbRJrAj+JNK5cGUAC/S3YObM3BuUYaOcvV8y1JTHnmJny92uOhT/fJWOIv2/FGK1jafk/HMjX14yQgVYOXH0FN+wXLB+GYHg0HjETmkEKm7RkTwhpccaEfja+TitdReNLlJTOoyWukxkFUnXe4uSFBigd2rRG6gv1+Ndadl/k+OmrNH1+uW/ucJ6U1063WDo8+CS/LX5U1WKgGxfnkd+1Zuegs2u+VkQnI4ClZMU9tY27xPfBsVLhnXKWwXYdhInUTSQGuaY8d0Qzp23VeudhpYNowhIAfez13R9nd+ud3eppt5sXLKvCBqS+tbWh01tUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=stateless.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BYivyJcCyWq4x+yfoqb74zcve5q/laU0IfCW+P9BXM0=;
 b=qaTa/1m4Y07Uk1c3S13kvlAX4b+gvkRHvLWsTfZdfdy+xR9tth7HtVrsCKTTWfjRDkqaGaSLgTZq8nQxeumnThLU6B6Au7blrhcD7X2YlKTYgtHqxK3bsvbqLXQHYqlhX13u5+bX3CV8kKTOglkQem7nxIcRqkG0Wii00USdBl5n81LW44r0jSWma/2iIfL2jQEZfmCLkQy4jPWZuC+7WTH2xqu2Sho2RmqNzwno+S2XaRQyys4V6KFUdqG39hrBxm7zD7SzTMnkj4ScrvDOzcYY/tnkMAWHOEi7PvVDvxnWL5X705S+O1ummQikNyjN0AZyD3VVBz9pMPyALbPuLQ==
Received: from BN6PR12CA0044.namprd12.prod.outlook.com (2603:10b6:405:70::30)
 by MWHPR12MB1725.namprd12.prod.outlook.com (2603:10b6:300:106::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Sun, 2 May
 2021 07:33:40 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:70:cafe::53) by BN6PR12CA0044.outlook.office365.com
 (2603:10b6:405:70::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend
 Transport; Sun, 2 May 2021 07:33:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; stateless.net; dkim=none (message not signed)
 header.d=none;stateless.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4087.27 via Frontend Transport; Sun, 2 May 2021 07:33:40 +0000
Received: from [172.27.13.169] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 2 May
 2021 07:33:37 +0000
Subject: Re: PROBLEM: mlx5_core driver crashes when a VRF device with a route
 is added with mlx5 devices in switchdev mode
To:     Leon Romanovsky <leonro@nvidia.com>,
        Dennis Afanasev <dennis.afanasev@stateless.net>,
        Vlad Buslov <vladbu@nvidia.com>,
        "Dmytro Linkin" <dlinkin@nvidia.com>
CC:     <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>
References: <CACJMemXjp6F0KzzAfR8yR4s5BU8zJBpsXmF0LWu3ubmF8Kke3Q@mail.gmail.com>
 <YI5E9mgNDzPMXTRh@unreal>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <1469adf5-7192-147f-837e-133d3d034732@nvidia.com>
Date:   Sun, 2 May 2021 10:33:35 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YI5E9mgNDzPMXTRh@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5104079-d9ea-463f-0a07-08d90d3c9b3d
X-MS-TrafficTypeDiagnostic: MWHPR12MB1725:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1725CFF6D71DFC505D17CB36B85C9@MWHPR12MB1725.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hyn64xlBWIhHnkh56J0iMjvijDI0dWHzqU8oiASNx+k7UfROLr4libKJ6KTBbcNa5RzIcBNd54eADC43xukkbC0f7spVf2qZY1kSEkdYGt8z7b3pgDbr+5izSaV0MqFlRbjoz2nVKM7jEC6dddME4zRdxdb0HEqiY/lca3SYYbezJNjXZJAXceBFVhqqcOoi5yB68e1Nc2xMTS7ybzaz+ecvFa2eAvELfNQDIkcYa47/XNCc6u6m/Qa1NH2zVElzfiDUSNPlW25GIpf1gygf7zF9L2NpySmdYQ+/bc+at0iFvVeXNrEgcXqqeWvNJ8UHlWjX2I8bhpzM4fwOvgp1CB2Yw/PCqk7KJk5bBs5+fM0qBSWBZIudoz8U5gCmfu/OVpnGg5qA/qNYV2UKKtBRtLghcyPzjfkCdEB1TMvty3YAfRvsSqRVf0Oa1qqyhOApP/AHdRA8LxvA09Zhzk842VHErD0wmsmcRTf1aV0zLO45GHJ9pxS3PkYsZTvEnblm/CZL/GRjMZSF5hOQoZHpKj3Wj9RHQnpNuCV8iAYUBLXrfdNuv+5UY4uPgS9I8ibIADJX1JojvK9gntEK+Qt9uAAJniog8CiTw9msNBdq3zng/DJlMsA7MO8w50MXr19mtQlO0MAY93X2dUZrr7LKWElJwxM0T3eD/sWnLCjUScZfveRvo0VXnd/2Keh+KZTm
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(39860400002)(46966006)(36840700001)(31696002)(31686004)(83380400001)(2616005)(36756003)(86362001)(82740400003)(336012)(4326008)(356005)(7636003)(47076005)(53546011)(2906002)(54906003)(5660300002)(4744005)(110136005)(186003)(36906005)(16576012)(8936002)(6636002)(316002)(26005)(82310400003)(16526019)(478600001)(70206006)(70586007)(8676002)(36860700001)(426003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2021 07:33:40.1464
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5104079-d9ea-463f-0a07-08d90d3c9b3d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1725
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-05-02 9:21 AM, Leon Romanovsky wrote:
> Thanks for the report.
> 
> + more people.
> 
> On Fri, Apr 30, 2021 at 04:56:17PM -0400, Dennis Afanasev wrote:
>> Dear Saeed and Leo,
>> I am reporting a bug in the mlx5_core driver discovered by our team at
>> Stateless while setting up SRIOV devices in eswitch mode. Below are the
>> details and relevant files that relate to the bug. Please reach out to me
>> if I can provide any further information.


thanks. reproduced and added fix for review.
also added internal test with unreachable route to catch this if
happens again.

Thanks,
Roi
