Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD541B225A
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 11:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgDUJIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 05:08:19 -0400
Received: from mail-db8eur05on2063.outbound.protection.outlook.com ([40.107.20.63]:34178
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726095AbgDUJIS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 05:08:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LuBSRcPAXQ8LjukmphsUeidEnVPmvx8aQxTY1Xw6Wzrk4SGHXMnq7NfinII+YIGXyCkLxnstt4jZS210qlxc/K0f3Kd4HWYMBRedyeglWHmWnxWhWsmUvSEAMkSIpOXO5Wx+SzWLyzRb2k8kP/adyKZQhupuHM4sqk1GWUWP7l10Ky0p8LBVg346DLCjS2/VkXzyk27p14KrOehpn0CVBljgOVDGvy2dyc1c4QM+HIAL226/7lygfKlDHH4otVRVMzsnw5F+YCu/W/M4qA7lK7rjtD68yMj4oJCVSVrWvxtTZqN39cDtM6K1k31OXqGq2WhsNVANZFXRyZgQwe47Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=POTbGldR/61eY5c6fYT68EGROUZtJMV1ggKhwBFVK1A=;
 b=G21oyz7NduLXk/ZLtknW+CfnPmKLl2UhHrRsr4+4dZgk/u+BhODgAcdGtJ5IuVe+chVh37h4hRQaMbByFofVeV9EUY49YIQhlH5QnAkkrmM4KkofFyppmFAzGfC0k0ilmKCyk52SELIi1MAXWIRx84Y4Be/3cCJQCRJ67VBWdAY6tDf2QNuEASND8BmXjxm6EWEWVR7RafFrS1rbTSarf47TS2B1BqEFm64IkLBCMAA6YDpjQjhHL3+LaXnsUS6m694qEu9vCozDWFBYktti8eVBy7cUPCej6eoFZ5Br88r129i7WSmV2LIu4ZduAkSAPgqvf85MbP3E+pwvne0agA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=POTbGldR/61eY5c6fYT68EGROUZtJMV1ggKhwBFVK1A=;
 b=jl9AOn92JIXR62o1kQn2p0JVXJy/bfS3ZW+8HYazFjWblYLd0bHEr9c4U+Y/ry3SghodbGL1n3jKRSklzRSxaJELW9K3F8Vox/+xOUwrW6GLAocdg+UXLY3nremSHne8JA1UJAs3jv9r6bSUeWtXh/aN3x10GxDMSuQFIpZNPE4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (2603:10a6:20b:b8::23)
 by AM6PR05MB5032.eurprd05.prod.outlook.com (2603:10a6:20b:11::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Tue, 21 Apr
 2020 09:08:14 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301%4]) with mapi id 15.20.2921.030; Tue, 21 Apr 2020
 09:08:14 +0000
Date:   Tue, 21 Apr 2020 12:08:11 +0300
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jgg@ziepe.ca, parav@mellanox.com,
        galpress@amazon.com, selvin.xavier@broadcom.com,
        sriharsha.basavapatna@broadcom.com, benve@cisco.com,
        bharat@chelsio.com, xavier.huwei@huawei.com, yishaih@mellanox.com,
        mkalderon@marvell.com, aditr@vmware.com,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com,
        Kiran Patil <kiran.patil@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next v2 1/9] Implementation of Virtual Bus
Message-ID: <20200421090811.GK121146@unreal>
References: <20200421080235.6515-1-jeffrey.t.kirsher@intel.com>
 <20200421080235.6515-2-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421080235.6515-2-jeffrey.t.kirsher@intel.com>
X-ClientProxiedBy: AM0PR10CA0036.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::16) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a00:a040:183:2d::a43) by AM0PR10CA0036.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Tue, 21 Apr 2020 09:08:13 +0000
X-Originating-IP: [2a00:a040:183:2d::a43]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 17ee102f-66fe-47af-bc28-08d7e5d38578
X-MS-TrafficTypeDiagnostic: AM6PR05MB5032:|AM6PR05MB5032:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB503271D234715685382876B7B0D50@AM6PR05MB5032.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 038002787A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB6408.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(7916004)(4636009)(136003)(366004)(396003)(376002)(346002)(39860400002)(9686003)(5660300002)(7416002)(66556008)(66476007)(66946007)(6486002)(86362001)(54906003)(33656002)(186003)(16526019)(2906002)(33716001)(478600001)(1076003)(52116002)(81156014)(8676002)(8936002)(316002)(4326008)(6496006)(6916009);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +aRdQvAn3xuzkNH+bjhBWPIypRStXLVBXzX1On90Fgkv8FNIdwnNzmreAH/fP6H+t3Cwu+js1nOUUW/aN84iYXla0nUxd88unir9MhGpKinGboDjtOLF5Fvp2TYw0RBZj24KGxafEJYvDiDuTRE8AsJW6hZ2gu+GnhXI0CDCMXzUGZzrN2rXq31HoSnkE16Ex5NDpor+dKkQtSKDVPBiW3+nHTDAunqXcKuVKtMobNh7kEg9r1/dAtGWoUaaQiiPuZn5UIppz/bDjHa5aFSEcy1pK2ucgS46I0Z9/qZqXZcheBDdCbpL0/RX1vqxI3Ljw1L16EcdtHrU8f9UGJahlP/82ZdOICC4Oh5oDjIpyoqF52Ssy8PXwJiPmj+vzgffYJkyPdosrz+al1DJkdEkX4omrT3Ka0m3mfwOkmJNBWPe0geSw7CtqX/zvIlyF1H0
X-MS-Exchange-AntiSpam-MessageData: M3OjIvHKSxHK1T69ndngZXFB1uUNfXF6PNTkzKylD6p9lTtQ1QNLWR4U99MFi63J5eA137MtiC0lq+uGxdcnBynIgUwknyLiJO+sPXRoiEcbwWnQuqVYSDmi/FaEQyCaTrF/po6G+A01JhT5aQL5xlYst8Kw0F+j+47JpGPCmd4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17ee102f-66fe-47af-bc28-08d7e5d38578
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2020 09:08:13.9195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: joSruqIvfgs64QnFWDylrHPJ/2dBnq18a/vLUTlGGfoj50kJCG3Pvk/YrUrF6ZVL/ukGpDFdZd2k5Qh8BctZ4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5032
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 01:02:27AM -0700, Jeff Kirsher wrote:
> From: Dave Ertman <david.m.ertman@intel.com>
>
> This is the initial implementation of the Virtual Bus,
> virtbus_device and virtbus_driver.  The virtual bus is
> a software based bus intended to support registering
> virtbus_devices and virtbus_drivers and provide matching
> between them and probing of the registered drivers.
>
> The bus will support probe/remove shutdown and
> suspend/resume callbacks.
>
> Kconfig and Makefile alterations are included
>
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>  Documentation/driver-api/virtual_bus.rst |  62 +++++
>  drivers/bus/Kconfig                      |  10 +
>  drivers/bus/Makefile                     |   2 +
>  drivers/bus/virtual_bus.c                | 279 +++++++++++++++++++++++
>  include/linux/mod_devicetable.h          |   8 +
>  include/linux/virtual_bus.h              |  53 +++++
>  scripts/mod/devicetable-offsets.c        |   3 +
>  scripts/mod/file2alias.c                 |   7 +
>  8 files changed, 424 insertions(+)
>  create mode 100644 Documentation/driver-api/virtual_bus.rst
>  create mode 100644 drivers/bus/virtual_bus.c
>  create mode 100644 include/linux/virtual_bus.h
>
> diff --git a/Documentation/driver-api/virtual_bus.rst b/Documentation/driver-api/virtual_bus.rst
> new file mode 100644
> index 000000000000..a79db0e9231e
> --- /dev/null
> +++ b/Documentation/driver-api/virtual_bus.rst
> @@ -0,0 +1,62 @@
> +===============================
> +Virtual Bus Devices and Drivers
> +===============================
> +
> +See <linux/virtual_bus.h> for the models for virtbus_device and virtbus_driver.
> +This bus is meant to be a lightweight software based bus to attach generic
> +devices and drivers to so that a chunk of data can be passed between them.
> +
> +One use case example is an RDMA driver needing to connect with several
> +different types of PCI LAN devices to be able to request resources from
> +them (queue sets).  Each LAN driver that supports RDMA will register a
> +virtbus_device on the virtual bus for each physical function.  The RDMA
> +driver will register as a virtbus_driver on the virtual bus to be
> +matched up with multiple virtbus_devices and receive a pointer to a
> +struct containing the callbacks that the PCI LAN drivers support for
> +registering with them.
> +
> +Sections in this document:
> +        Virtbus devices
> +        Virtbus drivers
> +        Device Enumeration
> +        Device naming and driver binding
> +        Virtual Bus API entry points
> +
> +Virtbus devices
> +~~~~~~~~~~~~~~~
> +Virtbus_devices support the minimal device functionality.  Devices will
> +accept a name, and then, when added to the virtual bus, an automatically
> +generated index is concatenated onto it for the virtbus_device->name.
> +
> +Virtbus drivers
> +~~~~~~~~~~~~~~~
> +Virtbus drivers register with the virtual bus to be matched with virtbus
> +devices.  They expect to be registered with a probe and remove callback,
> +and also support shutdown, suspend, and resume callbacks.  They otherwise
> +follow the standard driver behavior of having discovery and enumeration
> +handled in the bus infrastructure.
> +
> +Virtbus drivers register themselves with the API entry point
> +virtbus_register_driver and unregister with virtbus_unregister_driver.
> +
> +Device Enumeration
> +~~~~~~~~~~~~~~~~~~
> +Enumeration is handled automatically by the bus infrastructure via the
> +ida_simple methods.
> +
> +Device naming and driver binding
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +The virtbus_device.dev.name is the canonical name for the device. It is
> +built from two other parts:
> +
> +        - virtbus_device.name (also used for matching).
> +        - virtbus_device.id (generated automatically from ida_simple calls)
> +
> +Virtbus device IDs are always in "<name>.<instance>" format.  Instances are
> +automatically selected through an ida_simple_get so are positive integers.
> +Name is taken from the device name field.
> +
> +Driver IDs are simple <name>.
> +
> +Need to extract the name from the Virtual Device compare to name of the
> +driver.
> diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
> index 6d4e4497b59b..00553c78510c 100644
> --- a/drivers/bus/Kconfig
> +++ b/drivers/bus/Kconfig
> @@ -203,4 +203,14 @@ config DA8XX_MSTPRI
>  source "drivers/bus/fsl-mc/Kconfig"
>  source "drivers/bus/mhi/Kconfig"
>
> +config VIRTUAL_BUS
> +       tristate "Software based Virtual Bus"
> +       help
> +         Provides a software bus for virtbus_devices to be added to it
> +         and virtbus_drivers to be registered on it.  It matches driver
> +         and device based on id and calls the driver's probe routine.
> +         One example is the irdma driver needing to connect with various
> +         PCI LAN drivers to request resources (queues) to be able to perform
> +         its function.
> +
>  endmenu
> diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
> index 05f32cd694a4..d30828a4768c 100644
> --- a/drivers/bus/Makefile
> +++ b/drivers/bus/Makefile
> @@ -37,3 +37,5 @@ obj-$(CONFIG_DA8XX_MSTPRI)	+= da8xx-mstpri.o
>
>  # MHI
>  obj-$(CONFIG_MHI_BUS)		+= mhi/
> +
> +obj-$(CONFIG_VIRTUAL_BUS)	+= virtual_bus.o
> diff --git a/drivers/bus/virtual_bus.c b/drivers/bus/virtual_bus.c
> new file mode 100644
> index 000000000000..f5e66d110385
> --- /dev/null
> +++ b/drivers/bus/virtual_bus.c
> @@ -0,0 +1,279 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * virtual_bus.c - lightweight software based bus for virtual devices
> + *
> + * Copyright (c) 2019-2020 Intel Corporation
> + *
> + * Please see Documentation/driver-api/virtual_bus.rst for
> + * more information
> + */
> +
> +#include <linux/string.h>
> +#include <linux/virtual_bus.h>
> +#include <linux/of_irq.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/pm_domain.h>
> +#include <linux/acpi.h>
> +#include <linux/device.h>
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("Virtual Bus");
> +MODULE_AUTHOR("David Ertman <david.m.ertman@intel.com>");
> +MODULE_AUTHOR("Kiran Patil <kiran.patil@intel.com>");
> +
> +static DEFINE_IDA(virtbus_dev_ida);
> +
> +static const
> +struct virtbus_dev_id *virtbus_match_id(const struct virtbus_dev_id *id,
> +					struct virtbus_device *vdev)
> +{
> +	while (id->name[0]) {
> +		if (!strcmp(vdev->name, id->name))
> +			return id;
> +		id++;
> +	}
> +	return NULL;
> +}
> +
> +static int virtbus_match(struct device *dev, struct device_driver *drv)
> +{
> +	struct virtbus_driver *vdrv = to_virtbus_drv(drv);
> +	struct virtbus_device *vdev = to_virtbus_dev(dev);
> +
> +	return virtbus_match_id(vdrv->id_table, vdev) != NULL;
> +}
> +
> +static int virtbus_probe(struct device *dev)
> +{
> +	return dev->driver->probe(dev);
> +}
> +
> +static int virtbus_remove(struct device *dev)
> +{
> +	return dev->driver->remove(dev);
> +}
> +
> +static void virtbus_shutdown(struct device *dev)
> +{
> +	dev->driver->shutdown(dev);
> +}
> +
> +static int virtbus_suspend(struct device *dev, pm_message_t state)
> +{
> +	if (dev->driver->suspend)
> +		return dev->driver->suspend(dev, state);
> +
> +	return 0;
> +}
> +
> +static int virtbus_resume(struct device *dev)
> +{
> +	if (dev->driver->resume)
> +		return dev->driver->resume(dev);
> +
> +	return 0;

The common practice is to write it differently.
static int virtbus_resume(struct device *dev)
{
	if (!dev->driver->resume)
		return 0;

	return dev->driver->resume(dev);
}

and you are not consistent in this patch, sometimes you write
these functions in your format, sometimes in my format.

Thanks
