Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CC6433389
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235232AbhJSKdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 06:33:32 -0400
Received: from mail-mw2nam10on2088.outbound.protection.outlook.com ([40.107.94.88]:61568
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235207AbhJSKdb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 06:33:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GTDu55GlgVNb+jJx6F5KhKlrpV1NnVX8DNRjXT8JBl1r5rk1vxddO7Zo5bYlWfzPeAo99N5gviRtNnN0AmDnN9YiZZmzPxGAIY+rNfevmMxmRf0yaesqO4B3AvQor2rFX4RBJ5EOUTO03Q7oAyFJEuqPXlkfCaafyZFBylPZaaVibtO5lqQMKe/mi5So8RpjJ8Y562FoqWHqHGUQHCMbeuCbI8leobEmaVvpL1ZHorZsmku0H0eUlnFqp3hmZbBC1n+Z/oWH4lC8lHy6L+RwWRYvnnmfb7MTFCv6nbfL8a936IuVVOXSud+3Bb6qfjOVYAHlCtQ1C+65isY4UsT0aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+TL43oMaOVnXyUk9k7UECaccXiUb/Tub9NthoynxD4=;
 b=Ut0tkPPCRztQLoQPCKeVBXTMTUIpu9D4sooFBa7XsQn4jPtwDCBZ3znwj9hnJq7A7fNaQY9xqjMDrAtmeOqmcMgkg3koHESzq5rVNggYHNckQn0N8YYSN0Lp6gRyrvWO0g5mad+g3UnPFdwriXFr5W7K9hZmc4gr9BZ75GmF2+mT4Jmcc8yJmwSlt4zrd0T2Bcq/7vtBjUKbjKpqFbYKPx4oWPxgEfXVaKxwGxoAnjR8o/0+2WLLbiOT7MUCyoDALuUpKnYVbvPMDtie/dH7AB7h4Erpe9igzFVIG097D7SiLc1ACmHNAmJAXDcRFElBzQ7HOFBUKgum4d1EPuoqzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+TL43oMaOVnXyUk9k7UECaccXiUb/Tub9NthoynxD4=;
 b=tw4hAnewD7QotNIYbgPeke8B/qZIQdHbEb0QXwHKU+AakCCxeJ0LSptBGz6jgc6mXtiqNPT7zIvUxLPbctRfmvKd5OrNwdy7jgA7f7/nYpVJL/cCBSrevI0/244i7SHaKacP1L7omwvtSPJ0s1ZGEzGCzTMD/XdzStOu9MjEVC6l3kOgfG7VnUe5c84FrQFxtrXVYuGvOlNi6GQubJKh4CtP7Yt4pBszXV+zi4CbMkgbrcn71NmIIIll7iB13tQ8bnYKLG+nQQsA+APybhelchE4fjXLbRNaJNGcQpStHHx+bUGq45oXZlinJQwo8o1TgoJcxNzQp6N9EYXHcVaMfw==
Received: from MW4PR03CA0291.namprd03.prod.outlook.com (2603:10b6:303:b5::26)
 by MW2PR12MB2363.namprd12.prod.outlook.com (2603:10b6:907:f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Tue, 19 Oct
 2021 10:31:16 +0000
Received: from CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::fc) by MW4PR03CA0291.outlook.office365.com
 (2603:10b6:303:b5::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend
 Transport; Tue, 19 Oct 2021 10:31:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT037.mail.protection.outlook.com (10.13.174.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 10:31:15 +0000
Received: from [172.27.15.75] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 10:30:10 +0000
Subject: Re: [PATCH V1 mlx5-next 11/13] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
 <20211013094707.163054-12-yishaih@nvidia.com>
 <ed08f3350c594a63982856434d19d728@huawei.com>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <7e7880fe-bb1e-82db-8edb-271832d18827@nvidia.com>
Date:   Tue, 19 Oct 2021 13:30:07 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <ed08f3350c594a63982856434d19d728@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26a3912d-b8bc-41d6-3200-08d992eb94f3
X-MS-TrafficTypeDiagnostic: MW2PR12MB2363:
X-Microsoft-Antispam-PRVS: <MW2PR12MB236327E35C60FE49BC706774C3BD9@MW2PR12MB2363.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nEFzQCDPcAX0N29BErI1PPHVDtSsH6tyZSO8kbiBj5q2OdlbJYsT9AlVM8YpvjcSLEakFT9wwHaXMJsFzDRkg6X0Gp4tmQU//5s6OYDR9m8rOMwkESkZJvrHQm/lrxwd/T2RH8Ma972/se8CpNuQRHvAUs8AWeBNolZAKGqIJj2hr9fUa6ekJI/6SYYAcCj/3Mf+jpsJ2M0O6xIRRJCiTl6oYt70PB9Rl0oroD8TbyDAj6WFoclWeZ1VUUUl5krcpxqpDqbj8K5lHTjVUYXAf6B6iatjQ7e6a/xzZe1inTqmq9n8MyGpr+Oe/4ka2hXet7rpascljKE+1NDj6PRcGwjvE8Njo0tt4S3Zc8qFKCSElfWfb7euzgTd1ZQiRDXSfmRzGutMVsefYhEaS1q4X9hBK5Y7heVSLEu3mSM0WockOpxxcbKZavdHaTq614hjPDafw5a7lqMHuuA9qlmUtqZueoDrlc+bT9+i/LV3TdN0eX8UNRJ9YgY+AKvlkM46QhBUD977oUiulUyoFjJ3VRYAC0WC5OpNhMityw+qS/Ff3jSY4jNVLfkc1uuJ23YydlVpmJlRsBZECVZ2KA4zTb6ByuccTM9T4jrIZf+106IK6x0NY7oqpdo47hzvy+HB9exv1JqwUNGbvbYsxtEyvr/GLG6OWHF3atqLgqhBCzWzR6bUvsDLuU4q3tGEOsF81eO6O6YQIbvV2uVYN2QNSUklo7RzB467wS2WWzhY9TTTGu5K+Mfne3v2TYqi6jXVGVMtcur7hOnPB8UGfgjKXQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(26005)(70586007)(16526019)(36860700001)(4326008)(508600001)(70206006)(2616005)(8676002)(36756003)(5660300002)(2906002)(7636003)(6636002)(16576012)(316002)(107886003)(336012)(31686004)(186003)(54906003)(6666004)(47076005)(86362001)(110136005)(426003)(8936002)(53546011)(31696002)(83380400001)(356005)(82310400003)(30864003)(21314003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 10:31:15.9004
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26a3912d-b8bc-41d6-3200-08d992eb94f3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2363
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/2021 12:59 PM, Shameerali Kolothum Thodi wrote:
>
>> -----Original Message-----
>> From: Yishai Hadas [mailto:yishaih@nvidia.com]
>> Sent: 13 October 2021 10:47
>> To: alex.williamson@redhat.com; bhelgaas@google.com; jgg@nvidia.com;
>> saeedm@nvidia.com
>> Cc: linux-pci@vger.kernel.org; kvm@vger.kernel.org; netdev@vger.kernel.org;
>> kuba@kernel.org; leonro@nvidia.com; kwankhede@nvidia.com;
>> mgurtovoy@nvidia.com; yishaih@nvidia.com; maorg@nvidia.com
>> Subject: [PATCH V1 mlx5-next 11/13] vfio/mlx5: Implement vfio_pci driver for
>> mlx5 devices
>>
>> This patch adds support for vfio_pci driver for mlx5 devices.
>>
>> It uses vfio_pci_core to register to the VFIO subsystem and then
>> implements the mlx5 specific logic in the migration area.
>>
>> The migration implementation follows the definition from uapi/vfio.h and
>> uses the mlx5 VF->PF command channel to achieve it.
>>
>> This patch implements the suspend/resume flows.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>> ---
>>   MAINTAINERS                    |   6 +
>>   drivers/vfio/pci/Kconfig       |   3 +
>>   drivers/vfio/pci/Makefile      |   2 +
>>   drivers/vfio/pci/mlx5/Kconfig  |  11 +
>>   drivers/vfio/pci/mlx5/Makefile |   4 +
>>   drivers/vfio/pci/mlx5/main.c   | 692 +++++++++++++++++++++++++++++++++
>>   6 files changed, 718 insertions(+)
>>   create mode 100644 drivers/vfio/pci/mlx5/Kconfig
>>   create mode 100644 drivers/vfio/pci/mlx5/Makefile
>>   create mode 100644 drivers/vfio/pci/mlx5/main.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index abdcbcfef73d..e824bfab4a01 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -19699,6 +19699,12 @@ L:	kvm@vger.kernel.org
>>   S:	Maintained
>>   F:	drivers/vfio/platform/
>>
>> +VFIO MLX5 PCI DRIVER
>> +M:	Yishai Hadas <yishaih@nvidia.com>
>> +L:	kvm@vger.kernel.org
>> +S:	Maintained
>> +F:	drivers/vfio/pci/mlx5/
>> +
>>   VGA_SWITCHEROO
>>   R:	Lukas Wunner <lukas@wunner.de>
>>   S:	Maintained
>> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
>> index 860424ccda1b..187b9c259944 100644
>> --- a/drivers/vfio/pci/Kconfig
>> +++ b/drivers/vfio/pci/Kconfig
>> @@ -43,4 +43,7 @@ config VFIO_PCI_IGD
>>
>>   	  To enable Intel IGD assignment through vfio-pci, say Y.
>>   endif
>> +
>> +source "drivers/vfio/pci/mlx5/Kconfig"
>> +
>>   endif
>> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
>> index 349d68d242b4..ed9d6f2e0555 100644
>> --- a/drivers/vfio/pci/Makefile
>> +++ b/drivers/vfio/pci/Makefile
>> @@ -7,3 +7,5 @@ obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
>>   vfio-pci-y := vfio_pci.o
>>   vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
>>   obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
>> +
>> +obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
>> diff --git a/drivers/vfio/pci/mlx5/Kconfig b/drivers/vfio/pci/mlx5/Kconfig
>> new file mode 100644
>> index 000000000000..a3ce00add4fe
>> --- /dev/null
>> +++ b/drivers/vfio/pci/mlx5/Kconfig
>> @@ -0,0 +1,11 @@
>> +# SPDX-License-Identifier: GPL-2.0-only
>> +config MLX5_VFIO_PCI
>> +	tristate "VFIO support for MLX5 PCI devices"
>> +	depends on MLX5_CORE
>> +	select VFIO_PCI_CORE
>> +	help
>> +	  This provides a PCI support for MLX5 devices using the VFIO
>> +	  framework. The device specific driver supports suspend/resume
>> +	  of the MLX5 device.
>> +
>> +	  If you don't know what to do here, say N.
>> diff --git a/drivers/vfio/pci/mlx5/Makefile b/drivers/vfio/pci/mlx5/Makefile
>> new file mode 100644
>> index 000000000000..689627da7ff5
>> --- /dev/null
>> +++ b/drivers/vfio/pci/mlx5/Makefile
>> @@ -0,0 +1,4 @@
>> +# SPDX-License-Identifier: GPL-2.0-only
>> +obj-$(CONFIG_MLX5_VFIO_PCI) += mlx5-vfio-pci.o
>> +mlx5-vfio-pci-y := main.o cmd.o
>> +
>> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
>> new file mode 100644
>> index 000000000000..e36302b444a6
>> --- /dev/null
>> +++ b/drivers/vfio/pci/mlx5/main.c
>> @@ -0,0 +1,692 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved
>> + */
>> +
>> +#include <linux/device.h>
>> +#include <linux/eventfd.h>
>> +#include <linux/file.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/iommu.h>
>> +#include <linux/module.h>
>> +#include <linux/mutex.h>
>> +#include <linux/notifier.h>
>> +#include <linux/pci.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/types.h>
>> +#include <linux/uaccess.h>
>> +#include <linux/vfio.h>
>> +#include <linux/sched/mm.h>
>> +#include <linux/vfio_pci_core.h>
>> +
>> +#include "cmd.h"
>> +
>> +enum {
>> +	MLX5VF_PCI_FREEZED = 1 << 0,
>> +};
>> +
>> +enum {
>> +	MLX5VF_REGION_PENDING_BYTES = 1 << 0,
>> +	MLX5VF_REGION_DATA_SIZE = 1 << 1,
>> +};
>> +
>> +#define MLX5VF_MIG_REGION_DATA_SIZE SZ_128K
>> +/* Data section offset from migration region */
>> +#define MLX5VF_MIG_REGION_DATA_OFFSET
>> \
>> +	(sizeof(struct vfio_device_migration_info))
>> +
>> +#define VFIO_DEVICE_MIGRATION_OFFSET(x)
>> \
>> +	(offsetof(struct vfio_device_migration_info, x))
>> +
>> +struct mlx5vf_pci_migration_info {
>> +	u32 vfio_dev_state; /* VFIO_DEVICE_STATE_XXX */
>> +	u32 dev_state; /* device migration state */
>> +	u32 region_state; /* Use MLX5VF_REGION_XXX */
>> +	u16 vhca_id;
>> +	struct mlx5_vhca_state_data vhca_state_data;
>> +};
>> +
>> +struct mlx5vf_pci_core_device {
>> +	struct vfio_pci_core_device core_device;
>> +	u8 migrate_cap:1;
>> +	/* protect migartion state */
>> +	struct mutex state_mutex;
>> +	struct mlx5vf_pci_migration_info vmig;
>> +};
>> +
>> +static int mlx5vf_pci_unquiesce_device(struct mlx5vf_pci_core_device
>> *mvdev)
>> +{
>> +	return mlx5vf_cmd_resume_vhca(mvdev->core_device.pdev,
>> +				      mvdev->vmig.vhca_id,
>> +
>> MLX5_RESUME_VHCA_IN_OP_MOD_RESUME_MASTER);
>> +}
>> +
>> +static int mlx5vf_pci_quiesce_device(struct mlx5vf_pci_core_device *mvdev)
>> +{
>> +	return mlx5vf_cmd_suspend_vhca(
>> +		mvdev->core_device.pdev, mvdev->vmig.vhca_id,
>> +		MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_MASTER);
>> +}
>> +
>> +static int mlx5vf_pci_unfreeze_device(struct mlx5vf_pci_core_device
>> *mvdev)
>> +{
>> +	int ret;
>> +
>> +	ret = mlx5vf_cmd_resume_vhca(mvdev->core_device.pdev,
>> +				     mvdev->vmig.vhca_id,
>> +
>> MLX5_RESUME_VHCA_IN_OP_MOD_RESUME_SLAVE);
>> +	if (ret)
>> +		return ret;
>> +
>> +	mvdev->vmig.dev_state &= ~MLX5VF_PCI_FREEZED;
>> +	return 0;
>> +}
>> +
>> +static int mlx5vf_pci_freeze_device(struct mlx5vf_pci_core_device *mvdev)
>> +{
>> +	int ret;
>> +
>> +	ret = mlx5vf_cmd_suspend_vhca(
>> +		mvdev->core_device.pdev, mvdev->vmig.vhca_id,
>> +		MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_SLAVE);
>> +	if (ret)
>> +		return ret;
>> +
>> +	mvdev->vmig.dev_state |= MLX5VF_PCI_FREEZED;
>> +	return 0;
>> +}
>> +
>> +static int mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device
>> *mvdev)
>> +{
>> +	u32 state_size = 0;
>> +	int ret;
>> +
>> +	if (!(mvdev->vmig.dev_state & MLX5VF_PCI_FREEZED))
>> +		return -EFAULT;
>> +
>> +	/* If we already read state no reason to re-read */
>> +	if (mvdev->vmig.vhca_state_data.state_size)
>> +		return 0;
>> +
>> +	ret = mlx5vf_cmd_query_vhca_migration_state(
>> +		mvdev->core_device.pdev, mvdev->vmig.vhca_id, &state_size);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return mlx5vf_cmd_save_vhca_state(mvdev->core_device.pdev,
>> +					  mvdev->vmig.vhca_id, state_size,
>> +					  &mvdev->vmig.vhca_state_data);
>> +}
>> +
>> +static int mlx5vf_pci_new_write_window(struct mlx5vf_pci_core_device
>> *mvdev)
>> +{
>> +	struct mlx5_vhca_state_data *state_data =
>> &mvdev->vmig.vhca_state_data;
>> +	u32 num_pages_needed;
>> +	u64 allocated_ready;
>> +	u32 bytes_needed;
>> +
>> +	/* Check how many bytes are available from previous flows */
>> +	WARN_ON(state_data->num_pages * PAGE_SIZE <
>> +		state_data->win_start_offset);
>> +	allocated_ready = (state_data->num_pages * PAGE_SIZE) -
>> +			  state_data->win_start_offset;
>> +	WARN_ON(allocated_ready > MLX5VF_MIG_REGION_DATA_SIZE);
>> +
>> +	bytes_needed = MLX5VF_MIG_REGION_DATA_SIZE - allocated_ready;
>> +	if (!bytes_needed)
>> +		return 0;
>> +
>> +	num_pages_needed = DIV_ROUND_UP_ULL(bytes_needed, PAGE_SIZE);
>> +	return mlx5vf_add_migration_pages(state_data, num_pages_needed);
>> +}
>> +
>> +static ssize_t
>> +mlx5vf_pci_handle_migration_data_size(struct mlx5vf_pci_core_device
>> *mvdev,
>> +				      char __user *buf, bool iswrite)
>> +{
>> +	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
>> +	u64 data_size;
>> +	int ret;
>> +
>> +	if (iswrite) {
>> +		/* data_size is writable only during resuming state */
>> +		if (vmig->vfio_dev_state != VFIO_DEVICE_STATE_RESUMING)
>> +			return -EINVAL;
>> +
>> +		ret = copy_from_user(&data_size, buf, sizeof(data_size));
>> +		if (ret)
>> +			return -EFAULT;
>> +
>> +		vmig->vhca_state_data.state_size += data_size;
>> +		vmig->vhca_state_data.win_start_offset += data_size;
>> +		ret = mlx5vf_pci_new_write_window(mvdev);
>> +		if (ret)
>> +			return ret;
>> +
>> +	} else {
>> +		if (vmig->vfio_dev_state != VFIO_DEVICE_STATE_SAVING)
>> +			return -EINVAL;
>> +
>> +		data_size = min_t(u64, MLX5VF_MIG_REGION_DATA_SIZE,
>> +				  vmig->vhca_state_data.state_size -
>> +				  vmig->vhca_state_data.win_start_offset);
>> +		ret = copy_to_user(buf, &data_size, sizeof(data_size));
>> +		if (ret)
>> +			return -EFAULT;
>> +	}
>> +
>> +	vmig->region_state |= MLX5VF_REGION_DATA_SIZE;
>> +	return sizeof(data_size);
>> +}
>> +
>> +static ssize_t
>> +mlx5vf_pci_handle_migration_data_offset(struct mlx5vf_pci_core_device
>> *mvdev,
>> +					char __user *buf, bool iswrite)
>> +{
>> +	static const u64 data_offset = MLX5VF_MIG_REGION_DATA_OFFSET;
>> +	int ret;
>> +
>> +	/* RO field */
>> +	if (iswrite)
>> +		return -EFAULT;
>> +
>> +	ret = copy_to_user(buf, &data_offset, sizeof(data_offset));
>> +	if (ret)
>> +		return -EFAULT;
>> +
>> +	return sizeof(data_offset);
>> +}
>> +
>> +static ssize_t
>> +mlx5vf_pci_handle_migration_pending_bytes(struct mlx5vf_pci_core_device
>> *mvdev,
>> +					  char __user *buf, bool iswrite)
>> +{
>> +	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
>> +	u64 pending_bytes;
>> +	int ret;
>> +
>> +	/* RO field */
>> +	if (iswrite)
>> +		return -EFAULT;
>> +
>> +	if (vmig->vfio_dev_state == (VFIO_DEVICE_STATE_SAVING |
>> +				     VFIO_DEVICE_STATE_RUNNING)) {
>> +		/* In pre-copy state we have no data to return for now,
>> +		 * return 0 pending bytes
>> +		 */
>> +		pending_bytes = 0;
>> +	} else {
>> +		if (!vmig->vhca_state_data.state_size)
>> +			return 0;
>> +		pending_bytes = vmig->vhca_state_data.state_size -
>> +				vmig->vhca_state_data.win_start_offset;
>> +	}
>> +
>> +	ret = copy_to_user(buf, &pending_bytes, sizeof(pending_bytes));
>> +	if (ret)
>> +		return -EFAULT;
>> +
>> +	/* Window moves forward once data from previous iteration was read */
>> +	if (vmig->region_state & MLX5VF_REGION_DATA_SIZE)
>> +		vmig->vhca_state_data.win_start_offset +=
>> +			min_t(u64, MLX5VF_MIG_REGION_DATA_SIZE, pending_bytes);
>> +
>> +	WARN_ON(vmig->vhca_state_data.win_start_offset >
>> +		vmig->vhca_state_data.state_size);
>> +
>> +	/* New iteration started */
>> +	vmig->region_state = MLX5VF_REGION_PENDING_BYTES;
>> +	return sizeof(pending_bytes);
>> +}
>> +
>> +static int mlx5vf_load_state(struct mlx5vf_pci_core_device *mvdev)
>> +{
>> +	if (!mvdev->vmig.vhca_state_data.state_size)
>> +		return 0;
>> +
>> +	return mlx5vf_cmd_load_vhca_state(mvdev->core_device.pdev,
>> +					  mvdev->vmig.vhca_id,
>> +					  &mvdev->vmig.vhca_state_data);
>> +}
>> +
>> +static void mlx5vf_reset_mig_state(struct mlx5vf_pci_core_device *mvdev)
>> +{
>> +	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
>> +
>> +	vmig->region_state = 0;
>> +	mlx5vf_reset_vhca_state(&vmig->vhca_state_data);
>> +}
>> +
>> +static int mlx5vf_pci_set_device_state(struct mlx5vf_pci_core_device
>> *mvdev,
>> +				       u32 state)
>> +{
>> +	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
>> +	u32 old_state = vmig->vfio_dev_state;
>> +	int ret = 0;
>> +
>> +	if (vfio_is_state_invalid(state) || vfio_is_state_invalid(old_state))
>> +		return -EINVAL;
>> +
>> +	/* Running switches off */
>> +	if ((old_state & VFIO_DEVICE_STATE_RUNNING) !=
>> +	    (state & VFIO_DEVICE_STATE_RUNNING) &&
>> +	    (old_state & VFIO_DEVICE_STATE_RUNNING)) {
>> +		ret = mlx5vf_pci_quiesce_device(mvdev);
>> +		if (ret)
>> +			return ret;
>> +		ret = mlx5vf_pci_freeze_device(mvdev);
>> +		if (ret) {
>> +			vmig->vfio_dev_state = VFIO_DEVICE_STATE_INVALID;
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	/* Resuming switches off */
>> +	if ((old_state & VFIO_DEVICE_STATE_RESUMING) !=
>> +	    (state & VFIO_DEVICE_STATE_RESUMING) &&
>> +	    (old_state & VFIO_DEVICE_STATE_RESUMING)) {
>> +		/* deserialize state into the device */
>> +		ret = mlx5vf_load_state(mvdev);
>> +		if (ret) {
>> +			vmig->vfio_dev_state = VFIO_DEVICE_STATE_INVALID;
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	/* Resuming switches on */
>> +	if ((old_state & VFIO_DEVICE_STATE_RESUMING) !=
>> +	    (state & VFIO_DEVICE_STATE_RESUMING) &&
>> +	    (state & VFIO_DEVICE_STATE_RESUMING)) {
>> +		mlx5vf_reset_mig_state(mvdev);
>> +		ret = mlx5vf_pci_new_write_window(mvdev);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +
>> +	/* Saving switches on */
>> +	if ((old_state & VFIO_DEVICE_STATE_SAVING) !=
>> +	    (state & VFIO_DEVICE_STATE_SAVING) &&
>> +	    (state & VFIO_DEVICE_STATE_SAVING)) {
>> +		if (!(state & VFIO_DEVICE_STATE_RUNNING)) {
>> +			/* serialize post copy */
>> +			ret = mlx5vf_pci_save_device_data(mvdev);
> Does it actually get into post-copy here? The pre-copy state(old_state)
> has the _SAVING bit set already and post-copy state( new state) also
> has _SAVING set. It looks like we need to handle the post copy in the above
> "Running switches off" and check for (state & _SAVING).
>
> Or Am I missing something?
>

The above checks for a change in the SAVING bit, if it was turned on and 
we are not RUNNING it means post copy.

Turning on SAVING when we are RUNNING will end-up with returning zero 
bytes upon pending bytes as we don't support for now dirty pages.

see mlx5vf_pci_handle_migration_pending_bytes().

Yishai

