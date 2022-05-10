Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78EF520FA5
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 10:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237989AbiEJI1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 04:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237962AbiEJI1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 04:27:09 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AB4291E48;
        Tue, 10 May 2022 01:23:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+2pc0fRkyvu4SHXL48w9Etk834q0uELjMNwhd6bz/X8Ufp+3kWnnhqGofErY8RGrkwbl1N8IOMekp2/94r9BTgdAYEuiyM7pQ9GWwJq+kivdw50nOrRKlKlUofdfw1tcgJ8rZHGfAEhx90UERVs18DmR+ElM2y7wQuAHVNwvchKnV7RG62csCbIf9t5DNmI3IpPgH08Od50lPZNUhZp7tdyVUxP6+r5LSWFiglk4WHRNfpOBRHECmUwxie6BYPZEpsm+YLvhPLjvakA8WhF+ROY5TJj7kGti/p8fPdh7QqnDjbnfw+4D28fOgjConlcSxY4bHgpsb005Vi+h/5HqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ww4/OX777lLbhp34CNlNatkUZDNTNZBdNR3MgRQjYnM=;
 b=ofvVpQbOHwDEsiOGG/ewpih0oKkdbNyMTkPhUO8Zzn/MiYH4da2CsoP5wqc8cU76sB8Slj1AbrVP2MSD7abb/Wd22IOakVwg0wQiKYMuFtr/sPmMSRKr9dHtK2lOzv5+6Uceipgi6loZYbsngQWOmIaxcj6u/kdrEP9WRy9fovxHwAipQCoS2OWlDJ3vy/ZntZKA2oSG5+VGNXgJ0gRAdgy+gDYkXRspiinHjH0D8PYL/17u3uxCHlFN1Fz6Gm+96uBJnwHUBbYD0/WiqwzDGSCgOjewXkVG57oTwRilHhJYgT9LQOhBd+n8ziiw+kvgTb3dHkc3EVwywTWxQzZ6CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ww4/OX777lLbhp34CNlNatkUZDNTNZBdNR3MgRQjYnM=;
 b=NhYM3Hx62rCMm5Uv6Sf7m4UYrKfmGlT4j/2cTgmXDnPb/izX+5SyawhkV4uHcevlJ8wIhPoioRLGHMN3AOy362VjFrQze1lhTRuj1hPiddBS1/BsbwVMdapQUPgCcn80/DtqONL45ZX8u8iCKUorNy1GSAECxsa8g5unGh0Eq4cj3gFJqkN5tyddUlBnSTy2WAzpissQIXrVxXEaj4z7peUJ3nVtgq+1usdPBlFg8FeANYz+zEkeVYsbNmzcKubD0QilDRwBe5QUZGsSdmctsJRH7SaAZ9n5ykinOkIR1MXHsh6Wtx/oHZbLyMAfMR4U8CPQJ1BU8t8FJjgvYTdHxA==
Received: from MW4PR03CA0266.namprd03.prod.outlook.com (2603:10b6:303:b4::31)
 by DM5PR12MB1818.namprd12.prod.outlook.com (2603:10b6:3:114::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Tue, 10 May
 2022 08:23:09 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b4:cafe::d7) by MW4PR03CA0266.outlook.office365.com
 (2603:10b6:303:b4::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20 via Frontend
 Transport; Tue, 10 May 2022 08:23:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Tue, 10 May 2022 08:23:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 10 May
 2022 08:23:08 +0000
Received: from [172.27.11.245] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 10 May
 2022 01:23:04 -0700
Message-ID: <6835d3cc-99ce-951a-ddde-46f7980d6e9a@nvidia.com>
Date:   Tue, 10 May 2022 11:23:02 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH V1 mlx5-next 2/4] vfio/mlx5: Manage the VF attach/detach
 callback from the PF
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <maorg@nvidia.com>, <cohuck@redhat.com>
References: <20220508131053.241347-1-yishaih@nvidia.com>
 <20220508131053.241347-3-yishaih@nvidia.com>
 <20220509112901.7ab66865.alex.williamson@redhat.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20220509112901.7ab66865.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8765a9c-2417-46ad-e3a7-08da325e50da
X-MS-TrafficTypeDiagnostic: DM5PR12MB1818:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1818BE949199C5E25F60200EC3C99@DM5PR12MB1818.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1ibVeKCrbPMhfa3ByPvE8IPMqTjZiycSjc42oBE24tOiqxgXbjkfrKgTPKiIX28FN3TJyaiRSc/OT8TssJHnnYYuZ0PyFWdfAg/ZOvc8ckuyqmpi0VS33PR0XA3XI8avO2v54gnd0G+k41P9w22gMdFGBEC+myGSYm6QMqEdgMJKcHg/AuqvajaYZe9qlnDEEtXoImw9h1zVBOp066+NfDORIcoC154TDyF34vRU91a4KT2mx3I1sVkRT65PEA43NNMRRCrCRJssytkTEcnM9Jf3cmwEr2UutmTJdAxdDVPr3B2rVoj7ILAfPZ6dZ+xs4ko1kLSbhgjcYQGxWIpZ/IYlA46fAPsj0A86TA/5+V/H9ojhVMzaNZH9NUKpPksGBs+Hmc62oKnOllXvVfbW0AqMEXW2tlAA5B5rz3cfA0wmdrcO03gZWJhg/AoUFlnTV3AzdSqYG4THfIy9syAoY1uwFHy4XmwgMO3MVuK/naSmyBB4HrqIq6h+WPTcqZh6wN7S38rTOaARCjnACKq5rwTRFDfSDo2AGiGHet3MMNIFTrLW+jgeWD4qzFIwInncL3UwyCLGdk0dYcIjUH+zluPhj/zrurOWKpJ3h6RZ8QphpDtuf4lFWEdKpzj0o+3yyhMKXSgsdVJR1DqL8pYzglezhALABS656cS9tYDoLgylM5SDpSBl05S0HK+WekGS2boTFsFd6JR41USHEyls24tEPI8ND8/Bxy9uYjyiX6gjOJe3L6l5P9jCBW0zA0e6
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(70206006)(336012)(426003)(8676002)(31686004)(356005)(40460700003)(2906002)(70586007)(47076005)(82310400005)(4326008)(2616005)(83380400001)(186003)(16526019)(26005)(31696002)(6916009)(86362001)(8936002)(54906003)(36860700001)(5660300002)(36756003)(508600001)(16576012)(81166007)(53546011)(316002)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 08:23:08.9777
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8765a9c-2417-46ad-e3a7-08da325e50da
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1818
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
> On Sun, 8 May 2022 16:10:51 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
>
>> Manage the VF attach/detach callback from the PF.
>>
>> This lets the driver to enable parallel VFs migration as will be
>> introduced in the next patch.
>>
>> As part of this, reorganize the VF is migratable code to be in a
>> separate function and rename it to be set_migratable() to match its
>> functionality.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>> ---
>>   drivers/vfio/pci/mlx5/cmd.c  | 63 ++++++++++++++++++++++++++++++++++++
>>   drivers/vfio/pci/mlx5/cmd.h  | 22 +++++++++++++
>>   drivers/vfio/pci/mlx5/main.c | 40 ++++-------------------
>>   3 files changed, 91 insertions(+), 34 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
>> index 5c9f9218cc1d..5031978ae63a 100644
>> --- a/drivers/vfio/pci/mlx5/cmd.c
>> +++ b/drivers/vfio/pci/mlx5/cmd.c
>> @@ -71,6 +71,69 @@ int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
>>   	return ret;
>>   }
>>   
>> +static int mlx5fv_vf_event(struct notifier_block *nb,
>> +			   unsigned long event, void *data)
>> +{
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
>> +void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev)
>> +{
>> +	struct pci_dev *pdev = mvdev->core_device.pdev;
>> +	int ret;
>> +
>> +	if (!pdev->is_virtfn)
>> +		return;
>> +
>> +	mvdev->mdev = mlx5_vf_get_core_dev(pdev);
>> +	if (!mvdev->mdev)
>> +		return;
>> +
>> +	if (!MLX5_CAP_GEN(mvdev->mdev, migration))
>> +		goto end;
>> +
>> +	mvdev->vf_id = pci_iov_vf_id(pdev);
>> +	if (mvdev->vf_id < 0)
>> +		goto end;
>> +
>> +	mutex_init(&mvdev->state_mutex);
>> +	spin_lock_init(&mvdev->reset_lock);
>> +	mvdev->nb.notifier_call = mlx5fv_vf_event;
>> +	ret = mlx5_sriov_blocking_notifier_register(mvdev->mdev, mvdev->vf_id,
>> +						    &mvdev->nb);
>> +	if (ret)
>> +		goto end;
>> +
>> +	mvdev->migrate_cap = 1;
>> +	mvdev->core_device.vdev.migration_flags =
>> +		VFIO_MIGRATION_STOP_COPY |
>> +		VFIO_MIGRATION_P2P;
>> +
>> +end:
>> +	mlx5_vf_put_core_dev(mvdev->mdev);
>> +}
>> +
>>   int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id)
>>   {
>>   	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
>> diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
>> index 1392a11a9cc0..340a06b98007 100644
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
>> @@ -24,13 +25,34 @@ struct mlx5_vf_migration_file {
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
>
> This should be packed with the other bit fields, there's plenty of
> space there.
>
Sure, will be part of V2.

>> +};
>> +
>>   int mlx5vf_cmd_suspend_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod);
>>   int mlx5vf_cmd_resume_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod);
>>   int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
>>   					  size_t *state_size);
>>   int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id);
>> +void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev);
>> +void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev);
>>   int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
>>   			       struct mlx5_vf_migration_file *migf);
>>   int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
>>   			       struct mlx5_vf_migration_file *migf);
>> +void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
>>   #endif /* MLX5_VFIO_CMD_H */
>> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
>> index bbec5d288fee..9716c87e31f9 100644
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
>> @@ -596,24 +581,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>>   	if (!mvdev)
>>   		return -ENOMEM;
>>   	vfio_pci_core_init_device(&mvdev->core_device, pdev, &mlx5vf_pci_ops);
>> -
>> -	if (pdev->is_virtfn) {
>> -		struct mlx5_core_dev *mdev =
>> -			mlx5_vf_get_core_dev(pdev);
>> -
>> -		if (mdev) {
>> -			if (MLX5_CAP_GEN(mdev, migration)) {
>> -				mvdev->migrate_cap = 1;
>> -				mvdev->core_device.vdev.migration_flags =
>> -					VFIO_MIGRATION_STOP_COPY |
>> -					VFIO_MIGRATION_P2P;
>> -				mutex_init(&mvdev->state_mutex);
>> -				spin_lock_init(&mvdev->reset_lock);
>> -			}
>> -			mlx5_vf_put_core_dev(mdev);
>> -		}
>> -	}
>> -
>> +	mlx5vf_cmd_set_migratable(mvdev);
>>   	ret = vfio_pci_core_register_device(&mvdev->core_device);
>>   	if (ret)
>>   		goto out_free;
>> @@ -622,6 +590,8 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>>   	return 0;
>>   
>>   out_free:
>> +	if (mvdev->migrate_cap)
>> +		mlx5vf_cmd_remove_migratable(mvdev);
>>   	vfio_pci_core_uninit_device(&mvdev->core_device);
>>   	kfree(mvdev);
>>   	return ret;
>> @@ -632,6 +602,8 @@ static void mlx5vf_pci_remove(struct pci_dev *pdev)
>>   	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
>>   
>>   	vfio_pci_core_unregister_device(&mvdev->core_device);
>> +	if (mvdev->migrate_cap)
>> +		mlx5vf_cmd_remove_migratable(mvdev);
>>   	vfio_pci_core_uninit_device(&mvdev->core_device);
>>   	kfree(mvdev);
>>   }
>
> Personally, I'd push the test into the function, ie.
>
> void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev)
> {
> 	if (!mvdev->migrate_cap)
> 		return;
>
> 	...
> }


Makes sense, this will keep the caller code symmetric/clean for both the 
set/remove calls.

Will be part of V2.

> But it's clearly functional this way as well.  Please do fix the bit
> field packing though.  Thanks,
>
> Alex
>

