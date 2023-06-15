Return-Path: <netdev+bounces-11233-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57C9373214C
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 23:05:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D224281485
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 21:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28838134CE;
	Thu, 15 Jun 2023 21:05:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A566EAFE
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 21:05:31 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C66184;
	Thu, 15 Jun 2023 14:05:29 -0700 (PDT)
Received: from lhrpeml500002.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Qhvrj2l33z6GDGy;
	Fri, 16 Jun 2023 05:03:01 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500002.china.huawei.com (7.191.160.78) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 22:05:26 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.023;
 Thu, 15 Jun 2023 22:05:26 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Brett Creeley <brett.creeley@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>
CC: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v10 vfio 3/7] vfio/pds: register with the pds_core PF
Thread-Topic: [PATCH v10 vfio 3/7] vfio/pds: register with the pds_core PF
Thread-Index: AQHZlZ4bRqh8n4WDQkKmbFuUylfIGq+MW5Zg
Date: Thu, 15 Jun 2023 21:05:26 +0000
Message-ID: <67192b9598d041568ece62ea282367d0@huawei.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-4-brett.creeley@amd.com>
In-Reply-To: <20230602220318.15323-4-brett.creeley@amd.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.126.169.47]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Brett Creeley [mailto:brett.creeley@amd.com]
> Sent: 02 June 2023 23:03
> To: kvm@vger.kernel.org; netdev@vger.kernel.org;
> alex.williamson@redhat.com; jgg@nvidia.com; yishaih@nvidia.com;
> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> kevin.tian@intel.com
> Cc: brett.creeley@amd.com; shannon.nelson@amd.com
> Subject: [PATCH v10 vfio 3/7] vfio/pds: register with the pds_core PF
>=20
> The pds_core driver will supply adminq services, so find the PF
> and register with the DSC services.
>=20
> Use the following commands to enable a VF:
> echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs
>=20
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/vfio/pci/pds/Makefile   |  1 +
>  drivers/vfio/pci/pds/cmds.c     | 43
> +++++++++++++++++++++++++++++++++
>  drivers/vfio/pci/pds/cmds.h     | 10 ++++++++
>  drivers/vfio/pci/pds/pci_drv.c  | 19 +++++++++++++++
>  drivers/vfio/pci/pds/pci_drv.h  |  9 +++++++
>  drivers/vfio/pci/pds/vfio_dev.c | 11 +++++++++
>  drivers/vfio/pci/pds/vfio_dev.h |  6 +++++
>  include/linux/pds/pds_common.h  |  2 ++
>  8 files changed, 101 insertions(+)
>  create mode 100644 drivers/vfio/pci/pds/cmds.c
>  create mode 100644 drivers/vfio/pci/pds/cmds.h
>  create mode 100644 drivers/vfio/pci/pds/pci_drv.h
>=20
> diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefil=
e
> index e1a55ae0f079..87581111fa17 100644
> --- a/drivers/vfio/pci/pds/Makefile
> +++ b/drivers/vfio/pci/pds/Makefile
> @@ -4,5 +4,6 @@
>  obj-$(CONFIG_PDS_VFIO_PCI) +=3D pds_vfio.o
>=20
>  pds_vfio-y :=3D \
> +	cmds.o		\
>  	pci_drv.o	\
>  	vfio_dev.o
> diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c
> new file mode 100644
> index 000000000000..ae01f5df2f5c
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/cmds.c
> @@ -0,0 +1,43 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> +
> +#include <linux/io.h>
> +#include <linux/types.h>
> +
> +#include <linux/pds/pds_common.h>
> +#include <linux/pds/pds_core_if.h>
> +#include <linux/pds/pds_adminq.h>
> +
> +#include "vfio_dev.h"
> +#include "cmds.h"
> +
> +int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	struct pci_dev *pdev =3D pds_vfio_to_pci_dev(pds_vfio);
> +	char devname[PDS_DEVNAME_LEN];
> +	int ci;
> +
> +	snprintf(devname, sizeof(devname), "%s.%d-%u", PDS_LM_DEV_NAME,
> +		 pci_domain_nr(pdev->bus), pds_vfio->pci_id);
> +
> +	ci =3D pds_client_register(pci_physfn(pdev), devname);
> +	if (ci <=3D 0)
> +		return ci;

So 0 is not a valid id I guess but we return 0 here. But below where
pds_vfio_register_client_cmd() is called, 0 return is treated as success.

Note: Also in drivers..../auxbus.c the comment says the function returns 0
on success!.

Please check.

Thanks,
Shameer
> +
> +	pds_vfio->client_id =3D ci;
> +
> +	return 0;
> +}
> +
> +void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio=
)
> +{
> +	struct pci_dev *pdev =3D pds_vfio_to_pci_dev(pds_vfio);
> +	int err;
> +
> +	err =3D pds_client_unregister(pci_physfn(pdev), pds_vfio->client_id);
> +	if (err)
> +		dev_err(&pdev->dev, "unregister from DSC failed: %pe\n",
> +			ERR_PTR(err));
> +
> +	pds_vfio->client_id =3D 0;
> +}
> diff --git a/drivers/vfio/pci/pds/cmds.h b/drivers/vfio/pci/pds/cmds.h
> new file mode 100644
> index 000000000000..4c592afccf89
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/cmds.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> +
> +#ifndef _CMDS_H_
> +#define _CMDS_H_
> +
> +int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio);
> +void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio=
);
> +
> +#endif /* _CMDS_H_ */
> diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_dr=
v.c
> index 0e84249069d4..a49420aa9736 100644
> --- a/drivers/vfio/pci/pds/pci_drv.c
> +++ b/drivers/vfio/pci/pds/pci_drv.c
> @@ -8,9 +8,13 @@
>  #include <linux/types.h>
>  #include <linux/vfio.h>
>=20
> +#include <linux/pds/pds_common.h>
>  #include <linux/pds/pds_core_if.h>
> +#include <linux/pds/pds_adminq.h>
>=20
>  #include "vfio_dev.h"
> +#include "pci_drv.h"
> +#include "cmds.h"
>=20
>  #define PDS_VFIO_DRV_DESCRIPTION	"AMD/Pensando VFIO Device
> Driver"
>  #define PCI_VENDOR_ID_PENSANDO		0x1dd8
> @@ -27,13 +31,27 @@ static int pds_vfio_pci_probe(struct pci_dev *pdev,
>  		return PTR_ERR(pds_vfio);
>=20
>  	dev_set_drvdata(&pdev->dev, &pds_vfio->vfio_coredev);
> +	pds_vfio->pdsc =3D pdsc_get_pf_struct(pdev);
> +	if (IS_ERR_OR_NULL(pds_vfio->pdsc)) {
> +		err =3D PTR_ERR(pds_vfio->pdsc) ?: -ENODEV;
> +		goto out_put_vdev;
> +	}
>=20
>  	err =3D vfio_pci_core_register_device(&pds_vfio->vfio_coredev);
>  	if (err)
>  		goto out_put_vdev;
>=20
> +	err =3D pds_vfio_register_client_cmd(pds_vfio);
> +	if (err) {
> +		dev_err(&pdev->dev, "failed to register as client: %pe\n",
> +			ERR_PTR(err));
> +		goto out_unregister_coredev;
> +	}
> +
>  	return 0;
>=20
> +out_unregister_coredev:
> +	vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
>  out_put_vdev:
>  	vfio_put_device(&pds_vfio->vfio_coredev.vdev);
>  	return err;
> @@ -43,6 +61,7 @@ static void pds_vfio_pci_remove(struct pci_dev *pdev)
>  {
>  	struct pds_vfio_pci_device *pds_vfio =3D pds_vfio_pci_drvdata(pdev);
>=20
> +	pds_vfio_unregister_client_cmd(pds_vfio);
>  	vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
>  	vfio_put_device(&pds_vfio->vfio_coredev.vdev);
>  }
> diff --git a/drivers/vfio/pci/pds/pci_drv.h b/drivers/vfio/pci/pds/pci_dr=
v.h
> new file mode 100644
> index 000000000000..e79bed12ed14
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/pci_drv.h
> @@ -0,0 +1,9 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> +
> +#ifndef _PCI_DRV_H
> +#define _PCI_DRV_H
> +
> +#include <linux/pci.h>
> +
> +#endif /* _PCI_DRV_H */
> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_=
dev.c
> index 4038dac90a97..39771265b78f 100644
> --- a/drivers/vfio/pci/pds/vfio_dev.c
> +++ b/drivers/vfio/pci/pds/vfio_dev.c
> @@ -6,6 +6,11 @@
>=20
>  #include "vfio_dev.h"
>=20
> +struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio=
)
> +{
> +	return pds_vfio->vfio_coredev.pdev;
> +}
> +
>  struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev)
>  {
>  	struct vfio_pci_core_device *core_device =3D
> dev_get_drvdata(&pdev->dev);
> @@ -29,6 +34,12 @@ static int pds_vfio_init_device(struct vfio_device
> *vdev)
>  	pds_vfio->vf_id =3D pci_iov_vf_id(pdev);
>  	pds_vfio->pci_id =3D PCI_DEVID(pdev->bus->number, pdev->devfn);
>=20
> +	dev_dbg(&pdev->dev,
> +		"%s: PF %#04x VF %#04x (%d) vf_id %d domain %d
> pds_vfio %p\n",
> +		__func__, pci_dev_id(pdev->physfn), pds_vfio->pci_id,
> +		pds_vfio->pci_id, pds_vfio->vf_id, pci_domain_nr(pdev->bus),
> +		pds_vfio);
> +
>  	return 0;
>  }
>=20
> diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_=
dev.h
> index 66cfcab5b5bf..92e8ff241ca8 100644
> --- a/drivers/vfio/pci/pds/vfio_dev.h
> +++ b/drivers/vfio/pci/pds/vfio_dev.h
> @@ -7,14 +7,20 @@
>  #include <linux/pci.h>
>  #include <linux/vfio_pci_core.h>
>=20
> +struct pdsc;
> +
>  struct pds_vfio_pci_device {
>  	struct vfio_pci_core_device vfio_coredev;
> +	struct pdsc *pdsc;
>=20
>  	int vf_id;
>  	int pci_id;
> +	u16 client_id;
>  };
>=20
>  const struct vfio_device_ops *pds_vfio_ops_info(void);
>  struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev);
>=20
> +struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio=
);
> +
>  #endif /* _VFIO_DEV_H_ */
> diff --git a/include/linux/pds/pds_common.h
> b/include/linux/pds/pds_common.h
> index 060331486d50..721453bdf975 100644
> --- a/include/linux/pds/pds_common.h
> +++ b/include/linux/pds/pds_common.h
> @@ -39,6 +39,8 @@ enum pds_core_vif_types {
>  #define PDS_DEV_TYPE_RDMA_STR	"RDMA"
>  #define PDS_DEV_TYPE_LM_STR	"LM"
>=20
> +#define PDS_LM_DEV_NAME		PDS_CORE_DRV_NAME "."
> PDS_DEV_TYPE_LM_STR
> +
>  #define PDS_CORE_IFNAMSIZ		16
>=20
>  /**
> --
> 2.17.1


