Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEE552101F
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 10:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238290AbiEJJBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 05:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238291AbiEJJBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 05:01:05 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2072.outbound.protection.outlook.com [40.107.96.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF684488B3;
        Tue, 10 May 2022 01:57:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hq8JK37KjYhQx92MjVHAf5aC9FY7O1Tr+qFM8ueAqgUuJWznNW5llWJYGXxyR8u7h2vgDmC5Y5jgd9NJ8tP4fozFWBO4BO2bfu17UdnLoDoHDKfe2tvNxZtr0xUk+1LHjCAO5JmK+u3K3eFWwpe4k8E6gTBg5AvAUs6mzD1UpRfEI9GNKGG2JGfzubOHXOYTKjHNNeRZRmpCp31F6xsYc8c5j3e6uaSehJSDS1qQ3j5WHOqpcmF3DKrcDnqr8SAklhVLNbKZDvm7lWDAFx49bFeUJ/LMVgKDkx9kbGJ2T8FKiWcJYAyxQWpAYgSr6lZ5f09YNCo2KwQMAzgquSoHHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pWjno8yH/FCLjx5X7W7W12XufWaHJbrc7YNGzLSuNp0=;
 b=FdUYcSZm22RQbBGq6nMyV7q7KqfvA/VNR9q3Bd/HzjoqBMNGHqIpkAI/eZorXk0ALCgqNLy/xgL/XmGg1ALwewKlFAOkBFjaMzzBsD/MeOuGxAI2yqgcByK/v6rNiBdMu1CnkQ0Q7dQoZYYPOS9HPFzDIBEsWQRutRqD3HUs305h3SJxXqeEiB9h3yMlSYbmJ4on9UJ+L6GFpW9b91qmPefl2crM1SxH/UFL9akrJDD8se7/kLO3dTErb0HYWJUPm14H1nHNuUhdXslKLN59S+C5Ww7CZudqhMF88Ll6tZNdBh8idOhQUP30rZpFuFQpWT7duPjhgO90trG9kAkqsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWjno8yH/FCLjx5X7W7W12XufWaHJbrc7YNGzLSuNp0=;
 b=pmdt1z8SOtPji6iNV3stomq7Eq9vv7rQqZC86iOFT2+KcNsRi73exowmwn6jKKbqcsz2W2IAz2KjpbKnwi7cJH+uvri5XV6/X/SQw9hOGgxhjVmZEk9Mwaf4Kulj4FjhS2Jm0O6kyjLXLVz0hcgs47MaDRUy/XYDWTPwlpNTeydi/fFyeRpoO/m1Jz1TJ7aSZD9mXx/4SGAnRd5JyhtFh0ZOyGdfCiLDpg0Hpl4cY/1ZUDNkOdGgMCgM95rZfrmh0nTCKW2yYb8644+WKvdnpVnT5xh5NyCFshZFHijrqRlRECqWg46EUYLHFnMkZ0brFDH+vBQ9daslOySk1raCQg==
Received: from MW4PR04CA0076.namprd04.prod.outlook.com (2603:10b6:303:6b::21)
 by MN2PR12MB3920.namprd12.prod.outlook.com (2603:10b6:208:168::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Tue, 10 May
 2022 08:57:06 +0000
Received: from CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::25) by MW4PR04CA0076.outlook.office365.com
 (2603:10b6:303:6b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20 via Frontend
 Transport; Tue, 10 May 2022 08:57:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT005.mail.protection.outlook.com (10.13.174.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Tue, 10 May 2022 08:57:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 10 May
 2022 08:57:05 +0000
Received: from [172.27.11.245] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 10 May
 2022 01:57:00 -0700
Message-ID: <8d9dcc65-a754-ec6b-e1ed-1511efaf0b14@nvidia.com>
Date:   Tue, 10 May 2022 11:56:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH V1 mlx5-next 4/4] vfio/mlx5: Run the SAVE state command in
 an async mode
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <maorg@nvidia.com>, <cohuck@redhat.com>
References: <20220508131053.241347-1-yishaih@nvidia.com>
 <20220508131053.241347-5-yishaih@nvidia.com>
 <20220509112904.17e9b7d0.alex.williamson@redhat.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20220509112904.17e9b7d0.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6284c783-88ac-41f6-88b5-08da32630eba
X-MS-TrafficTypeDiagnostic: MN2PR12MB3920:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3920242DF52758346135E4F4C3C99@MN2PR12MB3920.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8REiFfZUF3Z+jvCB/slrBtEYlYy0RizZvchX0b5JF+z3UjZ7sJFdvgc0v3VQMvmmOkoGkiPgW5U123893DjCc/8IRI8FvXjC+j1Gtxwm6j6T7IU8b87BsX2L5CmpEHq1PMI6NhaF+etPj/7fGZEAqR+3CCaOFRG3idYWtDClwUOoDa06I3JxmZXAG5hGwhkSJHVc9DFmE5uwF5NfSAcXXnnZhCTZLuakQw4sikULd7UufYcBkRIRJgC2bfZxYYWGEFKSYCBhTRSHi4sUFblxWrx3EAYc/gXU0zulbJ3w/fyFgfM4LY4q4eZEnivmzjvDlzEZt4ukZYH9T4VrSSF9tKoQDggnIhyLe8PshiCoCYHz4KjI+0GyBH6icmTRBRXzth5+q+tuPpmjNX5wtNVmyIjXcnGe7X8/YAtW1Av+jzGoogyYnQwtdHIMX6N4GnYOijiBxhaXY5baJFF0+bBg79O+urcPf+ifiRGW7sFyp0moLS/WzAJc3L2xvEYDKBzVuC8b8CmH9pAFRIQIYAjvY40oJM6nKUrBcLlepSVwCRSCdTpJX31QExjVUHlIXGMRjDH8nXrUuf4AWAYzdDq8PcfJYwI2jrwS9zFmZEXNiMsoG4pwH0B6wJ482JCoCQHCfjdjjmxGjysvsZTHXZKOFj4cqiP9SlGErFwa5uULnB9G320FaGvvmIgVXAtGvb9R5pExXYeQrzmv95cjNwwlYNNOx9bYTKEzxwjLOdhePpY0dedL0300EZQEfR1MfXuG
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(36860700001)(336012)(508600001)(40460700003)(47076005)(426003)(26005)(16526019)(186003)(31696002)(2616005)(86362001)(5660300002)(2906002)(53546011)(356005)(36756003)(83380400001)(81166007)(82310400005)(70586007)(16576012)(54906003)(70206006)(4326008)(6916009)(8676002)(31686004)(8936002)(316002)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 08:57:05.5665
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6284c783-88ac-41f6-88b5-08da32630eba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3920
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/05/2022 20:29, Alex Williamson wrote:
> On Sun, 8 May 2022 16:10:53 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
>> diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
>> index 2a20b7435393..d053d314b745 100644
>> --- a/drivers/vfio/pci/mlx5/cmd.h
>> +++ b/drivers/vfio/pci/mlx5/cmd.h
>> @@ -10,10 +10,20 @@
>>   #include <linux/vfio_pci_core.h>
>>   #include <linux/mlx5/driver.h>
>>   
>> +struct mlx5vf_async_data {
>> +	struct mlx5_async_work cb_work;
>> +	struct work_struct work;
>> +	int status;
>> +	u32 pdn;
>> +	u32 mkey;
>> +	void *out;
>> +};
>> +
>>   struct mlx5_vf_migration_file {
>>   	struct file *filp;
>>   	struct mutex lock;
>>   	bool disabled;
>> +	u8 is_err:1;
> Convert @disabled to bit field as well to pack these?

OK

>
> ...
>> @@ -558,6 +592,13 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>>   		return -ENOMEM;
>>   	vfio_pci_core_init_device(&mvdev->core_device, pdev, &mlx5vf_pci_ops);
>>   	mlx5vf_cmd_set_migratable(mvdev);
>> +	if (mvdev->migrate_cap) {
>> +		mvdev->cb_wq = alloc_ordered_workqueue("mlx5vf_wq", 0);
>> +		if (!mvdev->cb_wq) {
>> +			ret = -ENOMEM;
>> +			goto out_free;
>> +		}
>> +	}
> Should this be rolled into mlx5vf_cmd_set_migratable(), updating the
> function to return -errno?

This can be done, however, I would still keep the function as void as 
you previously suggested.

In case the WQ somehow couldn't be created it just means that migratable 
functionality couldn't be activated and its cap won't be set.

>>   	ret = vfio_pci_core_register_device(&mvdev->core_device);
>>   	if (ret)
>>   		goto out_free;
>> @@ -566,8 +607,11 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>>   	return 0;
>>   
>>   out_free:
>> -	if (mvdev->migrate_cap)
>> +	if (mvdev->migrate_cap) {
>>   		mlx5vf_cmd_remove_migratable(mvdev);
>> +		if (mvdev->cb_wq)
>> +			destroy_workqueue(mvdev->cb_wq);
>> +	}
>>   	vfio_pci_core_uninit_device(&mvdev->core_device);
>>   	kfree(mvdev);
>>   	return ret;
>> @@ -578,8 +622,10 @@ static void mlx5vf_pci_remove(struct pci_dev *pdev)
>>   	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
>>   
>>   	vfio_pci_core_unregister_device(&mvdev->core_device);
>> -	if (mvdev->migrate_cap)
>> +	if (mvdev->migrate_cap) {
>>   		mlx5vf_cmd_remove_migratable(mvdev);
>> +		destroy_workqueue(mvdev->cb_wq);
>> +	}
>>   	vfio_pci_core_uninit_device(&mvdev->core_device);
>>   	kfree(mvdev);
>>   }
> This looks like more evidence for expanding remove_migratable(),
> rolling this in as well.  If this workqueue were setup in
> set_migratable() we'd not need the special condition to test if cb_wq
> is NULL while migrate_cap is set.  Thanks,
>
> Alex
>
Makes sense, will be part of V2.

Yishai

