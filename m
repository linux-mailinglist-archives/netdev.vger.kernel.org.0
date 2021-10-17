Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAFE43099E
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 16:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237952AbhJQOKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 10:10:07 -0400
Received: from mail-mw2nam10on2041.outbound.protection.outlook.com ([40.107.94.41]:52832
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236660AbhJQOKH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Oct 2021 10:10:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUnPYJ7l7ufpD3Z6X9RvUEdS6JF1zpuyrVIoNeoXP2yin5nWDwW9IKJtTqqf+AiKA72N0iZvr/6stgmPt+YZxFZchOTzRBNJUoOXyXVxN/Zs2cDGw6YmQrhdqaepcCs/8jlitTSio0RDEQgF6wxt72o0y8t1+ilx6zyZ2ChXhOh1EjZPFkXoHpYsRTRYDlj0OJtfRHdIp/yzQ8j8jAL+znqmj4S7bwM+lPEyhuL+7eDQA2DbrQuTVouIMQqp7Z1Jb2doKWjzhPlKjUNf5TF51EUAuvzibVqzMbPovRWsRKO2bQopZOjmYFeos7CNjei93IhkFM/0dimEpFcCRhlGuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VF9Z4VqW7E7nhS60voZKrQb4pgK0bIP+Rax5G+gyOvs=;
 b=bG7/8wpt+pMmIcBOEg5FCPowXPUnVO6MkzuphkEwnIeqXu2H6lWPIkk2YD8Ym4E+t3oQRwxHVjfOG91oQOZ47gi8BvDHwSmU5Z9U17ONvNl5gsp0K8OMM1m5kQ34DtTcvNZFNuy9uBKpCeeMfKZ4FE0fxdd679Ezako0yCaJk8CVA3cjUlzwwa23qiyeb2QxpIM42hPO+JUd4OJGIIY+wT9cwLrZT3jM8dbhBW5CLRys0TlWjpGe3szOrF/d5CkGo00n0eQlWmAvz078aEOQhaDntz4idpEEpGt9zLPQ4uVwIENym4QqU24GXrtFn4ZHnNtpjYqq0ihJ1Z0AMmIcLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VF9Z4VqW7E7nhS60voZKrQb4pgK0bIP+Rax5G+gyOvs=;
 b=qxKpg31pZ7Ez0ZVHaN0mrKiob42IpoD76k5oZcp/WWXPM7ZoqVBYVdBoqai7mV2O1lRbCG1MPes6txIJdCHGpFBgSIm+aNF7BaIg1OTRp/wqBhRTzM66IdB3Vhsr+4/fHqejhL/IgfSuN/dmH1BqaQ0H6Rmb6N8L+dXZHvIdpziRsOiORNV7YRKtmxHNuMJv/utmqrsWgN0hkVz/+Z3m7YgGV5gqehFINysq40+fYNc9UKZqWU0egF8bCDvqdizoQfMeaHWpYhxetYaNCjqUj2bbfo4x2FafMU/UbBDa9O5xu+nWVvd8Raeuxv+0sgNWuioanKATCoJfBdph0PiSng==
Received: from DM5PR1101CA0014.namprd11.prod.outlook.com (2603:10b6:4:4c::24)
 by BY5PR12MB4115.namprd12.prod.outlook.com (2603:10b6:a03:20f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Sun, 17 Oct
 2021 14:07:54 +0000
Received: from DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4c:cafe::50) by DM5PR1101CA0014.outlook.office365.com
 (2603:10b6:4:4c::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend
 Transport; Sun, 17 Oct 2021 14:07:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT051.mail.protection.outlook.com (10.13.172.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Sun, 17 Oct 2021 14:07:54 +0000
Received: from [172.27.13.186] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 17 Oct
 2021 14:07:50 +0000
Subject: Re: [PATCH V1 mlx5-next 07/13] vfio: Add 'invalid' state definitions
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
 <20211013094707.163054-8-yishaih@nvidia.com>
 <20211015103815.4b165d43.alex.williamson@redhat.com>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <243d2ff4-0142-a359-135a-879b81d0b32a@nvidia.com>
Date:   Sun, 17 Oct 2021 17:07:45 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211015103815.4b165d43.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8348bded-fd7b-4182-1e5d-08d99177837d
X-MS-TrafficTypeDiagnostic: BY5PR12MB4115:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4115CA121CF038248B5F8223C3BB9@BY5PR12MB4115.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NiUSyTvTdrh4sTLQq2tzag8udKR1wiINZV6kgnxV/qW8Zlq+lSSCgBeslAaYDqjHvRJpO0VjJ2v4bNQizn56yVMdlF2zhab8puqJm8MylqO4JWDMkp/XrJ+iAJAN3b1Gi56tJMRqMtLTNh97EF0JFkUDH2MYQJYv5pQSEHrKdkSY30kYQxBXAq4/rDKYw5xWEqxPCudFdHIiLuie7MDiVtbUVb4za2uXf9eRy09L+VXtkmOw9Q+dJvYfNlYLRbUyx2ZIqcp0sqAkodCljzcM45yNzYNKH4ZtwiDpqLbFEqJd0zrg8hGPeIJ4+DBVq8clns21VFtCk9KwzDhwk9KR1O5rl0voIJ/sFzvnvroXtLORVaHJ+JGw7/iqjdzzxegzicfu7jEMxHecxq95Yv77rTWh0lz/OkwA82seK+pGwzuQXw7aPs0i8WKLxxDJ3tYOpLai2J7DnAqX3LLtirbfI5YOkRoZnDKa2jvI7sSlVGpzi1HjEV0ZVFHEsmluqURWHVo4P9xy5Tdi6YdY0D9iMVsEWk8AAvDsuKdWN+eWm0/QSw9EhSHwZ81PAL5UnuSTW4jFor/0X2LuPuecIpytZZOQ4DrH5Qjh1E4S0idhmC4Wivi6OVJ8NYN+JoaFoGbLbo8ebsD1wNCnRN9m8yodHOoQswPT2jgB415m/3dxgkrUwGC/z9wkSDnF5GYwM5LL2YGUpCW+o4sNDShtmlwTe3+xvqhAYF2qnK+Oi9PVmIc=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(186003)(107886003)(508600001)(70206006)(6666004)(70586007)(26005)(336012)(5660300002)(2616005)(36860700001)(16526019)(8936002)(16576012)(7636003)(356005)(83380400001)(426003)(36756003)(31696002)(2906002)(31686004)(6916009)(53546011)(4326008)(316002)(47076005)(82310400003)(86362001)(36906005)(8676002)(54906003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 14:07:54.1717
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8348bded-fd7b-4182-1e5d-08d99177837d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4115
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/2021 7:38 PM, Alex Williamson wrote:
> On Wed, 13 Oct 2021 12:47:01 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
>
>> Add 'invalid' state definition to be used by drivers to set/check
>> invalid state.
>>
>> In addition dropped the non complied macro VFIO_DEVICE_STATE_SET_ERROR
>> (i.e SATE instead of STATE) which seems unusable.
> s/non complied/non-compiled/
>
> We can certainly assume it's unused based on the typo, but removing it
> or fixing it should be a separate patch.


OK, will come with a separate patch to fix the typo and leave it for now.

>> Fixes: a8a24f3f6e38 ("vfio: UAPI for migration interface for device state")
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>> ---
>>   include/linux/vfio.h      | 5 +++++
>>   include/uapi/linux/vfio.h | 4 +---
>>   2 files changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
>> index b53a9557884a..6a8cf6637333 100644
>> --- a/include/linux/vfio.h
>> +++ b/include/linux/vfio.h
>> @@ -252,4 +252,9 @@ extern int vfio_virqfd_enable(void *opaque,
>>   			      void *data, struct virqfd **pvirqfd, int fd);
>>   extern void vfio_virqfd_disable(struct virqfd **pvirqfd);
>>   
>> +static inline bool vfio_is_state_invalid(u32 state)
>> +{
>> +	return state >= VFIO_DEVICE_STATE_INVALID;
>> +}
>
> Redundant, we already have !VFIO_DEVICE_STATE_VALID(state)
>
>

OK, may drop this part.

Yishai


