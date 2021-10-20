Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20DF2434779
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 10:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhJTJBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 05:01:24 -0400
Received: from mail-mw2nam12on2055.outbound.protection.outlook.com ([40.107.244.55]:51155
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229544AbhJTJBY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 05:01:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bgLqNWkJjx59Mdp17TfQGDHl+l2c/QUEKVX+BWtjg2O6DXUThiEN3LicgcPL6kysD058kysfGtYmvJAaCiy5RdPPe9ZrWpZsnROPkLFUl1IWSnF7hYb+YpqzefesIx64rB6zCuqSroPwMZMkespW0cU1YUF0A1mca6Wt11POrMQjOtmPznJ7xXB6KL3UevMm0QcNiAcAXAzjE5pQuYrnxSXoWR1Zuhw03gMf2BrWCfS4xRVjVpQPA3eXja/QEcYTAjd+s8qSNnSAi+eZ+U5YRiJ1EPTEMEuqEfC8Wtq7TgPmkQQg8WlDBgbX1VY9lI4V3oPGcbUYYu1FWHuEOa3A1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ysuqW6f4t512bjbIfonB/Ke4pYPdmVLTBNXh9KtISlc=;
 b=gcsZhaCu1f5fViS4DD86R98rusKXtlKA4Urk30tlAN5qGf1ngJ/6Vu8Ik9h78oTn2X9KZkos1MDkuNffPO/vZEhKiU//SaDEK6YTGJ6LsfUwSbrFJjRfJpENtco+0ZKoUp2d5mht7MUFw62IacFJ2HxezfGBC1pMJK06blQ3vpKBaGXa4kHISvcdVHVjChV1/IiOJbco9FogpGwg7ycYii7dAMsV3ab2kJ43B/SkiSVZIShU3u4mC/mIaSAOGE5tKA09XKXoLmAXSmyhAQbTzuWJd5yO7IFmhly/SUDVlOt5DtBlcJ/tFatrQzSela3WcXynqV0DboXJLB6X11wINw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ysuqW6f4t512bjbIfonB/Ke4pYPdmVLTBNXh9KtISlc=;
 b=l+tlAOPEbmqNFhk70r5wukjBT86M4Q/JIiEwaDK6GH4BSY3Sqd/MM5gjLPuP8zFaCQE57xQ8ZmsUl1Ef0H4zJ+y+mWlVRcSdcrk00ui07KtwBL1un98Qq5bwxI70l1h35nxbvaCbTqd/HyL9KuqdwSZXKLDBUJ0Xa73j6zNJKvZYCcIaIs0IT6upLgfscWvhpMzLgw0cHKbdVik0OBIufBtpjZ8d+IdfwKDMm+ruz/TOO0u7CubXLH7R8w5IxAet2/LiONCXVhymHeaVvcDkaYYHqTm47FTjyafKA98A94qvYkhWPkw0ovSUdvlKwPgEWLWFAFiSxpoGK2lXq9OTeA==
Received: from MW4PR03CA0313.namprd03.prod.outlook.com (2603:10b6:303:dd::18)
 by DM6PR12MB3131.namprd12.prod.outlook.com (2603:10b6:5:11d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 08:59:09 +0000
Received: from CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::cb) by MW4PR03CA0313.outlook.office365.com
 (2603:10b6:303:dd::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend
 Transport; Wed, 20 Oct 2021 08:59:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT037.mail.protection.outlook.com (10.13.174.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 08:59:08 +0000
Received: from [172.27.15.75] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 20 Oct
 2021 08:59:02 +0000
Subject: Re: [PATCH V2 mlx5-next 06/14] vdpa/mlx5: Use mlx5_vf_get_core_dev()
 to get PF device
To:     Max Gurtovoy <mgurtovoy@nvidia.com>, <alex.williamson@redhat.com>,
        <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <maorg@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
 <20211019105838.227569-7-yishaih@nvidia.com>
 <94e54e67-e578-3b25-0234-6ce072dc42cf@nvidia.com>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <bb228f63-26f6-b5f1-e9a0-eac2e27eedd8@nvidia.com>
Date:   Wed, 20 Oct 2021 11:58:57 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <94e54e67-e578-3b25-0234-6ce072dc42cf@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f29d13db-460b-4cd5-973b-08d993a7e0c3
X-MS-TrafficTypeDiagnostic: DM6PR12MB3131:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3131F0326E8CB1CA7B2952B2C3BE9@DM6PR12MB3131.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3XfiZmtckro19pBFJv6mJZdE1r3PWYhCmeG41UjObrqV+WNvyNsnTszqODJASIPu408M/EA1xP79xUKTs0UQmac3k4NzWeLRhkoIfwUfEdb3AzuwQnCEFiNfZjILtx43Ut4rF5s/8JFttRbtCzq6OL+c9WEOXStUDuSIUmFsN9GuGWs3ldPIPv1CiIfk1SeQx/I21z+hHBG5671cEdG6XVsFx9pvGSLnri6kIqnWCAJY6qUn1Il6t5hwX45YvOlSO+Ve1fvL46ufYllJxjzRf7Ve9CSngip4WhBBUEmTYZsXdt5NfyhvyuqF5Fc/10fiiNz56WVFiUDLknAQ2EL8XIPAp2SxFNnjpBtLFqGmevb8556gqszu9JpOUyHWCzYfAA2yR1m+XuOy0OLvMzIjrjF5HKTsuxmzatbqVQztJ06cL0i5vpvSMyyM12zjKXURSt9Dm+BbsXabS33ODSptPzT2teb+5c3/dn46cnHWEHLdY4Mhe7/y5i992O439FIdTFe/kfPH8y7M2GxzsVvVKUTyWJZ/eShLOb77PNRFIFgnZ5ghQ7AjThXNbpDTzMt6IZKx0gy1QP4U1an+DszPOwR8sF21hHGExWRGhpN8DmBz6jhxtZEULaUAq21RsHmR2fLgA97pbfgXSxDh+XZTjxR/ZgmXZZYkw5CgLO6XarhG1a5JYS/CPMfkP4cy2l9TiwqIEpBNulDPMPIAZMNRjNTmHS2v3jSIMjegDxFEHg0=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(54906003)(7636003)(70586007)(53546011)(70206006)(4326008)(110136005)(82310400003)(6666004)(36906005)(5660300002)(426003)(26005)(36756003)(508600001)(336012)(107886003)(8936002)(6636002)(31686004)(8676002)(86362001)(2616005)(186003)(356005)(31696002)(36860700001)(16526019)(2906002)(47076005)(83380400001)(316002)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 08:59:08.8212
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f29d13db-460b-4cd5-973b-08d993a7e0c3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3131
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/2021 2:16 PM, Max Gurtovoy wrote:
>
> On 10/19/2021 1:58 PM, Yishai Hadas wrote:
>> Use mlx5_vf_get_core_dev() to get PF device instead of accessing
>> directly the PF data structure from the VF one.
>>
>> The mlx5_vf_get_core_dev() API in its turn uses the generic PCI API
>> (i.e. pci_iov_get_pf_drvdata) to get it.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>> ---
>>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 27 +++++++++++++++++++++------
>>   1 file changed, 21 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c 
>> b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> index 5c7d2a953dbd..97b8917bc34d 100644
>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> @@ -1445,7 +1445,10 @@ static virtio_net_ctrl_ack 
>> handle_ctrl_mac(struct mlx5_vdpa_dev *mvdev, u8 cmd)
>>       size_t read;
>>       u8 mac[ETH_ALEN];
>>   -    pfmdev = pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
>> +    pfmdev = mlx5_vf_get_core_dev(mvdev->mdev->pdev);
>> +    if (!pfmdev)
>> +        return status;
>> +
>>       switch (cmd) {
>
> Yishai/Jason,
>
> I think this patch breaks VPDA over SF.
>
> Did you verify it ?
>

It seems that you are right, the SF use case requires some different 
handling/path compared to VF.

As this patch is orthogonal to what we try to achieve in this series, we 
may apparently drop it from V3 and let vdpa/mlx5 people come with a 
complete tested patch for both cases on top.

Thanks,
Yishai
