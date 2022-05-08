Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B66251ED98
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 15:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbiEHNIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 09:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiEHNIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 09:08:40 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEF365DD;
        Sun,  8 May 2022 06:04:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z2+cw9jKZgCS11Iq7ByN4VWN35WP66vAqd8VNA/kv8SsajdvSpJQyeGaX3bG4oSLmmntEZLxVN/OINQwgsOAzk4Bf69yV2mH5x41cTI7YCE5pvy9WbgzWZzIFTE9575PXrLwMZQs4in+wNg4X01qEFI6Bz2pLhYnTQYNk7Cbz83YkjdjHKLLeflMEKUPV+W+br3o6cvXgd+wRGnkc2UzlGMnvkAfDcgKQGI8Darag/qhEW7FIrUme60iIjZF+AR0x+q74sbaWG33N1vEklrnPAQgqSmqnsS4oiFZZyr0TraSV30Cq0jGcXVF7NU7QdDWf0xICXBPn8epHwjdkLcF0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N0406fERZMUUwwIeWNr5Fi/YY3FdrdM+LGx1V1WV4gc=;
 b=d1QwD0JEAmSXeQCCqaSjc7Li7ZcRHhJjAJWf34p1Sk6ZrQF3LoV/lKnU/Wg65Gtpokf2H6EW7/GI/+ZfHX+QUaIS7R2n3U+ZVakcUIWolFsEQXeo/EUDiro3nEUSQFiPdy1C/OJWppjgzjWzF6Qy+BZwr4ZD6p9SSWzFZ94GMPTz2ntkU6vADN0wYWBhV6q3JbwOA6gyp2SDhgY3WvRk+dRK6wQdsE40l8/5I6nUkePs+VQ7pdlvHuwLA7y85/seWPL5nFEuUEYR1GQLdt+hr2XyIgR6O2LjQERs4XvxNTV2EmA8pHj+6AVHSbCUan6Zvw8uSlRThqQj2C7zz8ZleQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0406fERZMUUwwIeWNr5Fi/YY3FdrdM+LGx1V1WV4gc=;
 b=fGGGuNkRYn8/OtX7ShcmqcK8CtuYDZtvDVQhGvLUJgDLqBH9aQCeKMbqLhhg0lyKb0NZZ+F7vg2MUcQU79M8gyHtH4AVEKiUQTyrzD0fDYE/88AFnCUd4JmnhFcNxQFmOuDZn7X3DLG0lHI/8EY5adnAK9kzBPSJ4hEca7ZGWfCv98QV0AROggf8pyJTVYPc9ZREdMoWNfdgh2GLl/O/oqOX2lQn127qatVMN3NLqFD3+h/n9apVwQIWObiZ+tY/TYvlURRW6TFirql010YDAf6FDSw+vtdQOl1lL7IFE/4HG40YSLyYa2Jh+AvFLPLw8mlGPPDCDLIdgkfPaR9spA==
Received: from MW4PR03CA0301.namprd03.prod.outlook.com (2603:10b6:303:dd::6)
 by BL0PR12MB5521.namprd12.prod.outlook.com (2603:10b6:208:1c7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Sun, 8 May
 2022 13:04:46 +0000
Received: from CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::66) by MW4PR03CA0301.outlook.office365.com
 (2603:10b6:303:dd::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20 via Frontend
 Transport; Sun, 8 May 2022 13:04:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT007.mail.protection.outlook.com (10.13.174.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 13:04:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 8 May
 2022 13:04:45 +0000
Received: from [172.27.15.27] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 8 May 2022
 06:04:42 -0700
Message-ID: <fa42f92c-67c6-a448-d51f-8a2e4652918c@nvidia.com>
Date:   Sun, 8 May 2022 16:04:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH mlx5-next 3/5] vfio/mlx5: Manage the VF attach/detach
 callback from the PF
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <maorg@nvidia.com>, <cohuck@redhat.com>
References: <20220427093120.161402-1-yishaih@nvidia.com>
 <20220427093120.161402-4-yishaih@nvidia.com>
 <20220504143431.2fdd4ea5.alex.williamson@redhat.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20220504143431.2fdd4ea5.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e9248ae-b67b-4788-de2e-08da30f35399
X-MS-TrafficTypeDiagnostic: BL0PR12MB5521:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB552182537A90D4A0A22E15C5C3C79@BL0PR12MB5521.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ef1TXeC/Y0MF5C9T4Tz02xjmNTbGjPXuXTK6+XL9E2PvOjqzyYBTGrp0R//IzOSSu8m4a/IAenf3zC7409VnsrkSvUwSWFN5dcUfilOg0LAL33D4IydsH3NqDq/rGpgrtyIfHEhtMYDlSud4/VXDOxVcCHyo4Ss6Fgr8l5AIUDiJ28R9gGetjVcwZEy7iUfQbBD1qmaFQ0IT3itExryRfEBzHJh6iyawye2HhaC0ALjcJ7o6uL7YlSVG9euFwR6i8ceY7U7CYaX5qmKSzit6lFdc8xxTwXgF0DeaMOzIUqxC5DUIXUsTgt5yKsjj+08c4KLgZoF3WFkhNyRUgA45XpIk6ztWx2GZoeLSvVGEoIc6G1exgL1XmxVOwDVOn1VuzgYn0AvePWV/gg/72WxONMFo9c0Xy9eFEIcakyawJGsNMeLkXSeEmxojFbXwxFpo0oebBVnDAzYpEOQb7CWBTZTm41uG8Bjn/BO9+Qla0yIxY3cN2nJ4nNO20bhCe2FBuzMFg68FWh8WhEtlM+8i5S5bwRbiYc98I66P6H4Wj7r20kexHjUbmRQzuCCOPSNr1v9jsK8RdDeq4SlSWPHt/4zmlwf9v4wgspZeG25nVwe6sK2SLfHyxRhcJ9MvtBIl9YK9xp71zDlyuNvSbk7w42PmMZnGV36N72p8QGfaKNkzjE9XMwp0s2yQjGMRCXLYoOWfhJm2zC1vmDWaTM2uSIsyg2WGZCIkVHH2VpTKGogvpLm0RdxSxx9PrSf0zJPJ
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(40460700003)(81166007)(36756003)(31686004)(2906002)(2616005)(54906003)(186003)(36860700001)(336012)(86362001)(356005)(316002)(16576012)(16526019)(26005)(82310400005)(31696002)(6916009)(4326008)(8676002)(47076005)(426003)(508600001)(53546011)(70586007)(83380400001)(5660300002)(70206006)(8936002)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 13:04:46.2719
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e9248ae-b67b-4788-de2e-08da30f35399
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5521
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/05/2022 23:34, Alex Williamson wrote:
> On Wed, 27 Apr 2022 12:31:18 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
>
>> Manage the VF attach/detach callback from the PF.
>>
>> This lets the driver to enable parallel VFs migration as will be
>> introduced in the next patch.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>> ---
>>   drivers/vfio/pci/mlx5/cmd.c  | 59 +++++++++++++++++++++++++++++++++---
>>   drivers/vfio/pci/mlx5/cmd.h  | 23 +++++++++++++-
>>   drivers/vfio/pci/mlx5/main.c | 25 ++++-----------
>>   3 files changed, 82 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
>> index d608b8167f58..1f84d7b9b9e5 100644
>> --- a/drivers/vfio/pci/mlx5/cmd.c
>> +++ b/drivers/vfio/pci/mlx5/cmd.c
>> @@ -71,21 +71,70 @@ int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
>>   	return ret;
>>   }
>>   
>> -bool mlx5vf_cmd_is_migratable(struct pci_dev *pdev)
>> +static int mlx5fv_vf_event(struct notifier_block *nb,
>> +			   unsigned long event, void *data)
>>   {
>> -	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
>> +	struct mlx5vf_pci_core_device *mvdev =
>> +		container_of(nb, struct mlx5vf_pci_core_device, nb);
>> +
>> +	mutex_lock(&mvdev->state_mutex);
>> +	switch (event) {
>> +	case MLX5_PF_NOTIFY_ENABLE_VF:
>> +		mvdev->mdev_detach = false;
>> +		break;
>> +	case MLX5_PF_NOTIFY_DISABLE_VF:
>> +		mvdev->mdev_detach = true;
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +	mlx5vf_state_mutex_unlock(mvdev);
>> +	return 0;
>> +}
>> +
>> +void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev)
>> +{
>> +	mlx5_sriov_blocking_notifier_unregister(mvdev->mdev, mvdev->vf_id,
>> +						&mvdev->nb);
>> +}
>> +
>> +bool mlx5vf_cmd_is_migratable(struct mlx5vf_pci_core_device *mvdev)
> Why did the original implementation take a pdev knowing we're going to
> gut it in the next patch to use an mvdev?  The diff would be easier to
> read.


Agree, in V1 I just combined this patch with the changes from patch #1.


>
> There's also quite a lot of setup here now, it's no longer a simple
> test whether the device supports migration which makes the name
> misleading.  This looks like a "setup migration" function that should
> return 0/-errno.


Thanks, makes sense.

>> +{
>> +	struct pci_dev *pdev = mvdev->core_device.pdev;
>>   	bool migratable = false;
>> +	int ret;
>>   
>> -	if (!mdev)
>> +	mvdev->mdev = mlx5_vf_get_core_dev(pdev);
>> +	if (!mvdev->mdev)
>>   		return false;
>> +	if (!MLX5_CAP_GEN(mvdev->mdev, migration))
>> +		goto end;
>> +	mvdev->vf_id = pci_iov_vf_id(pdev);
>> +	if (mvdev->vf_id < 0)
>> +		goto end;
>>   
>> -	if (!MLX5_CAP_GEN(mdev, migration))
>> +	mutex_init(&mvdev->state_mutex);
>> +	spin_lock_init(&mvdev->reset_lock);
>> +	mvdev->nb.notifier_call = mlx5fv_vf_event;
>> +	ret = mlx5_sriov_blocking_notifier_register(mvdev->mdev, mvdev->vf_id,
>> +						    &mvdev->nb);
>> +	if (ret)
>>   		goto end;
>>   
>> +	mutex_lock(&mvdev->state_mutex);
>> +	if (mvdev->mdev_detach)
>> +		goto unreg;
>> +
>> +	mlx5vf_state_mutex_unlock(mvdev);
>>   	migratable = true;
>> +	goto end;
>>   
>> +unreg:
>> +	mlx5vf_state_mutex_unlock(mvdev);
>> +	mlx5_sriov_blocking_notifier_unregister(mvdev->mdev, mvdev->vf_id,
>> +						&mvdev->nb);
>>   end:
>> -	mlx5_vf_put_core_dev(mdev);
>> +	mlx5_vf_put_core_dev(mvdev->mdev);
>>   	return migratable;
>>   }
>>   
>> diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
>> index 2da6a1c0ec5c..f47174eab4b8 100644
>> --- a/drivers/vfio/pci/mlx5/cmd.h
>> +++ b/drivers/vfio/pci/mlx5/cmd.h
>> @@ -7,6 +7,7 @@
>>   #define MLX5_VFIO_CMD_H
>>   
>>   #include <linux/kernel.h>
>> +#include <linux/vfio_pci_core.h>
>>   #include <linux/mlx5/driver.h>
>>   
>>   struct mlx5_vf_migration_file {
>> @@ -24,14 +25,34 @@ struct mlx5_vf_migration_file {
>>   	unsigned long last_offset;
>>   };
>>   
>> +struct mlx5vf_pci_core_device {
>> +	struct vfio_pci_core_device core_device;
>> +	int vf_id;
>> +	u16 vhca_id;
>> +	u8 migrate_cap:1;
>> +	u8 deferred_reset:1;
>> +	/* protect migration state */
>> +	struct mutex state_mutex;
>> +	enum vfio_device_mig_state mig_state;
>> +	/* protect the reset_done flow */
>> +	spinlock_t reset_lock;
>> +	struct mlx5_vf_migration_file *resuming_migf;
>> +	struct mlx5_vf_migration_file *saving_migf;
>> +	struct notifier_block nb;
>> +	struct mlx5_core_dev *mdev;
>> +	u8 mdev_detach:1;
>> +};
>> +
>>   int mlx5vf_cmd_suspend_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod);
>>   int mlx5vf_cmd_resume_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod);
>>   int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
>>   					  size_t *state_size);
>>   int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id);
>> -bool mlx5vf_cmd_is_migratable(struct pci_dev *pdev);
>> +bool mlx5vf_cmd_is_migratable(struct mlx5vf_pci_core_device *mvdev);
>> +void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev);
>>   int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
>>   			       struct mlx5_vf_migration_file *migf);
>>   int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
>>   			       struct mlx5_vf_migration_file *migf);
>> +void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
>>   #endif /* MLX5_VFIO_CMD_H */
>> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
>> index 2578f61eaeae..445c516d38d9 100644
>> --- a/drivers/vfio/pci/mlx5/main.c
>> +++ b/drivers/vfio/pci/mlx5/main.c
>> @@ -17,7 +17,6 @@
>>   #include <linux/uaccess.h>
>>   #include <linux/vfio.h>
>>   #include <linux/sched/mm.h>
>> -#include <linux/vfio_pci_core.h>
>>   #include <linux/anon_inodes.h>
>>   
>>   #include "cmd.h"
>> @@ -25,20 +24,6 @@
>>   /* Arbitrary to prevent userspace from consuming endless memory */
>>   #define MAX_MIGRATION_SIZE (512*1024*1024)
>>   
>> -struct mlx5vf_pci_core_device {
>> -	struct vfio_pci_core_device core_device;
>> -	u16 vhca_id;
>> -	u8 migrate_cap:1;
>> -	u8 deferred_reset:1;
>> -	/* protect migration state */
>> -	struct mutex state_mutex;
>> -	enum vfio_device_mig_state mig_state;
>> -	/* protect the reset_done flow */
>> -	spinlock_t reset_lock;
>> -	struct mlx5_vf_migration_file *resuming_migf;
>> -	struct mlx5_vf_migration_file *saving_migf;
>> -};
>> -
>>   static struct page *
>>   mlx5vf_get_migration_page(struct mlx5_vf_migration_file *migf,
>>   			  unsigned long offset)
>> @@ -444,7 +429,7 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
>>    * This function is called in all state_mutex unlock cases to
>>    * handle a 'deferred_reset' if exists.
>>    */
>> -static void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev)
>> +void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev)
>>   {
>>   again:
>>   	spin_lock(&mvdev->reset_lock);
>> @@ -597,13 +582,11 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>>   		return -ENOMEM;
>>   	vfio_pci_core_init_device(&mvdev->core_device, pdev, &mlx5vf_pci_ops);
>>   
>> -	if (pdev->is_virtfn && mlx5vf_cmd_is_migratable(pdev)) {
>> +	if (pdev->is_virtfn && mlx5vf_cmd_is_migratable(mvdev)) {
>>   		mvdev->migrate_cap = 1;
>>   		mvdev->core_device.vdev.migration_flags =
>>   			VFIO_MIGRATION_STOP_COPY |
>>   			VFIO_MIGRATION_P2P;
> Why do these aspects of setting up migration remain here?  Do we even
> need this new function to have a return value?  It looks like all of
> this and testing whether the pdev->is_virtfn could be pushed into the
> new function, which could then return void.  Thanks,


Makes sense, will be part of V1, thanks.


> Alex
>
>> -		mutex_init(&mvdev->state_mutex);
>> -		spin_lock_init(&mvdev->reset_lock);
>>   	}
>>   
>>   	ret = vfio_pci_core_register_device(&mvdev->core_device);
>> @@ -614,6 +597,8 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>>   	return 0;
>>   
>>   out_free:
>> +	if (mvdev->migrate_cap)
>> +		mlx5vf_cmd_remove_migratable(mvdev);
>>   	vfio_pci_core_uninit_device(&mvdev->core_device);
>>   	kfree(mvdev);
>>   	return ret;
>> @@ -624,6 +609,8 @@ static void mlx5vf_pci_remove(struct pci_dev *pdev)
>>   	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
>>   
>>   	vfio_pci_core_unregister_device(&mvdev->core_device);
>> +	if (mvdev->migrate_cap)
>> +		mlx5vf_cmd_remove_migratable(mvdev);
>>   	vfio_pci_core_uninit_device(&mvdev->core_device);
>>   	kfree(mvdev);
>>   }


