Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D7E42D5DA
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 11:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbhJNJUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 05:20:43 -0400
Received: from mail-co1nam11on2066.outbound.protection.outlook.com ([40.107.220.66]:59104
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229513AbhJNJUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 05:20:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SMG/i2vUk+hSunL07sa6b2TJCP2mEzQtHirfknzCeQNHzJDhVEsVyPhDkKeSrW+oVnfsEwW2pYOvcQvgBhZS+KCD1vQP9Q4GVnSPB2qhIyxzRHTWncxtFPmfYwE3h2UEW+BCeEa4R1CCz1JG8sq8vJqR81hziMfjQuHcGQ2DFFTQk9HK+ZB2tMaM1+L7ZBnGNfU530qBkY5tzW5EC34gyv7P3qKn56CxMag4XTZOCJt19qvkE4pU6YOPqNAENNWkJetlq3qfQI4XAZzf64VdHAZaothyLyQUzq+3BH8nOFQlG/uUcT4jXslBIJEGYfxvIYNGJD4Q88i8xaZQk1BiyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ce6dAZvFeDgkZb4Bj6LTAp0hWGRH3VG9IPH68j+hKo=;
 b=mDXYrXauVlFijFn3f8JYvvNAE0yHOY+aLKJ2/hP/453hIE0IhBQh7qNjRqXBgg3FPaOXbUZ+8Bkbbr1Mf3z2xCQ2XKCXSNPhoWma5/8+8UwQ0ZvO7nPcuSfU93l1OdTeYpBLzc2wZYwKEPEUl3iSmbEsf/NG+JGDvN/D82kZrxauk6Ck2HYSF7s6oHhN3m5+xdtVjcy5XDHx46i/ZfFpUlvcB6fZz1/oDS+ssU5pEK980I4FgfiLGdF8LA30UcICO8AQ4KSkjFtmg/qBUlbl6gtTvvWoc06XMdTG/JaWZ508FyzdFTungx5Sr0LK3m/BcvHmVtdwo6967NUYebsVCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ce6dAZvFeDgkZb4Bj6LTAp0hWGRH3VG9IPH68j+hKo=;
 b=B4nVEGyutyZD5P/jxr/IVsVo5tufML14QWxGGWADNxb5pjcjmyNoajk5C7gXtcpEE6AjgaHBuOsb8mOvmO69R9N6RxupEepimILFkatBj3k7dXMydRRtrVyYElgcmDBqH4+7RbsNyBOO2lkapD7g8yEmTGlkFM/YjGlC8EcPd7+tT0wiH7FHyw6stuWBmYq8uaDZGS4gluFAY2eFYP7YM5KHzIVbOFMNpvFBFhEVE0qRUD4ANuXLVuhqrVRQvX9shcuXrlYC2W/I/owCRizmh9Bko1ujJ1xenO8FbQ9kHjYV+zvqKDogA4y75VlS0guyMq2mkF70G/xTckFGmZefZA==
Received: from DS7PR03CA0002.namprd03.prod.outlook.com (2603:10b6:5:3b8::7) by
 DM5PR12MB2584.namprd12.prod.outlook.com (2603:10b6:4:b0::37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.16; Thu, 14 Oct 2021 09:18:36 +0000
Received: from DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::a5) by DS7PR03CA0002.outlook.office365.com
 (2603:10b6:5:3b8::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend
 Transport; Thu, 14 Oct 2021 09:18:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT046.mail.protection.outlook.com (10.13.172.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 09:18:36 +0000
Received: from [172.27.11.74] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 14 Oct
 2021 09:18:32 +0000
Subject: Re: [PATCH V1 mlx5-next 13/13] vfio/mlx5: Trap device RESET and
 update state accordingly
To:     Jason Gunthorpe <jgg@nvidia.com>, <alex.williamson@redhat.com>
CC:     <bhelgaas@google.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
 <20211013094707.163054-14-yishaih@nvidia.com>
 <20211013180651.GM2744544@nvidia.com>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <cae3309e-4175-b134-c1f6-5ec02f352078@nvidia.com>
Date:   Thu, 14 Oct 2021 12:18:30 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211013180651.GM2744544@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bdff10c9-ad98-4822-79ec-08d98ef39a0f
X-MS-TrafficTypeDiagnostic: DM5PR12MB2584:
X-Microsoft-Antispam-PRVS: <DM5PR12MB25847D12B9844EBC0E078414C3B89@DM5PR12MB2584.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QXiHWdJ+5XSdhoyRTIhOL1PkfdIBdBqp2V5Br4XZkGOCkZwBXZgLO3bfbgg3dM6ZtfeQulwhsbkLNiOKrM2R1YiGAzx+ulBVV3w+44vhr7nqWZ9RXJSoNFjEzmNdHGiWdSWY7H/Xx6AnpX0zGQtHKsc04KUw9FPssfEKAxyr5rqNr69Cf96lRETQ/kHsMFuf+qPG2snhJ3ecBaRFy5A6rI9/pTa9+PrxacjM8ScyN5QvHKN1EekU1HVTBFAigOGinK8CGqYhV6NYPDz1QJLq1AWiFzhvJOEoaRM7DrCAKMzGDZkHw5zpHzeOO78Qhj4nUVFR6D2bd3a2Iwr06/YYMr46DcfmCAH/wBwZgs4BvrQDxFIzmzxKpjjgw6yefaSp2TYJkmMBCuRg09MlkMZ4mjD/H6NWjJO5jjjP1MnqV6zSz3I+hYQKOCZFHMz7dD/h4bDKlLToMMk/qir+8rLzQfoxYf1Nku2o8T3gvRN73yx6BymDveZ7o69G7ZhVabhg8x1VyA7dthaIg61DOZEtM6LsEucutVVUpRUcrrsYM9EYzhmZ/uomGoVcY6QhR2Wzpcmg3vgIr8u6O/B9PxMj/xt5YKRHSCwyPm0kGyirv5M0QvGmbZQt9AhlCtDv2zdoqqbGQTPzJCZr3bCFF3OoA5yKipPNr0gHrW7lr+9BJtXYXsp6HRJgYO8lb/Qf5zBkeEW2l4SB9RjSOLGkEWmZgomaCoe9afBJa1T4ERlvPY4=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2616005)(47076005)(36860700001)(426003)(15650500001)(8676002)(2906002)(107886003)(83380400001)(31696002)(7636003)(36756003)(31686004)(4326008)(86362001)(5660300002)(508600001)(186003)(110136005)(336012)(53546011)(8936002)(26005)(70206006)(70586007)(16576012)(16526019)(54906003)(316002)(82310400003)(356005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 09:18:36.0629
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bdff10c9-ad98-4822-79ec-08d98ef39a0f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2584
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/2021 9:06 PM, Jason Gunthorpe wrote:
> On Wed, Oct 13, 2021 at 12:47:07PM +0300, Yishai Hadas wrote:
>> Trap device RESET and update state accordingly, it's done by registering
>> the matching callbacks.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>>   drivers/vfio/pci/mlx5/main.c | 17 ++++++++++++++++-
>>   1 file changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
>> index e36302b444a6..8fe44ed13552 100644
>> +++ b/drivers/vfio/pci/mlx5/main.c
>> @@ -613,6 +613,19 @@ static const struct vfio_device_ops mlx5vf_pci_ops = {
>>   	.match = vfio_pci_core_match,
>>   };
>>   
>> +static void mlx5vf_reset_done(struct vfio_pci_core_device *core_vdev)
>> +{
>> +	struct mlx5vf_pci_core_device *mvdev = container_of(
>> +			core_vdev, struct mlx5vf_pci_core_device,
>> +			core_device);
>> +
>> +	mvdev->vmig.vfio_dev_state = VFIO_DEVICE_STATE_RUNNING;
> This should hold the state mutex too
>
Thanks Jason, I'll add as part of V2.

Alex,

Any feedback from your side before that we'll send V2 ?

We already got ACK for the PCI patches, there are some minor changes to 
be done so far.

Thanks,

Yishai

