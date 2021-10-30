Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C744C440A10
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 17:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhJ3P5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 11:57:32 -0400
Received: from mail-cusazon11021021.outbound.protection.outlook.com ([52.101.62.21]:29440
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231830AbhJ3P5b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 11:57:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJsMkJL86qkcP1rpQ8aQ4s1jvtn7w6jDY4GDP6Nf6wbX4guAwfR1JxA58565At+I0//oAKdasEnrGenZsD5aBWik3N0LKvmVYUFGA3gSVyQcKXNqGpBVhbJlcZeo9RKJiKm2twA9cSIAnZOhS0vboSiJfSA3hqUWJs69XvdVOyfcb9A7u+Do8FjKbTTmep5pOpOgcfZa1RLUxOtQmi6GilEHTi8FxtrFZ+VYlvgnfqA+HIHiOdDaFQBQPGmmgy486A2Yb+NPNtYCZEFjLCWpqTvfPUkiL8vd5vDs9Qe/ncDbFRfy4849LIhRrcjHQgapjcYnvJiRvlYtPAVBCzw4Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rzRNI1jQeDxllXjEF+3CrWUdbiGBezzaj1XMJnKOL10=;
 b=ZzOh6pXQKd/KeNoS9vd5AJ1uAdqq7LnVErXkQtfzr3avukFe9xG0nf1P6f9ddDvOy6+T5Zsnoa83cPEgCFWaxGAc2hP23wd+OqYyT002PhB75uNQgOHlYwLl7liKQ8i1DEvFgf1N0uVk/GrHglNVK8NLwwnpLFbZ/d18N3UoQnxGbLP9yEQ0Dh2PxKudDXbG7f5s1qlcdfowFsQH3/uZAQytjdD3kG/vlC1xugpef/1eMYx07DjPmIWJfIfaQU0F3AlfIuvBUprrPT5BmDz/oIBo2TbAVrKDg/ykSXLf2KLzV323zQnukqpfWN+VEMHyIdWNEDt8n8Nzi6iF0KZE5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rzRNI1jQeDxllXjEF+3CrWUdbiGBezzaj1XMJnKOL10=;
 b=drrvR88M1admRzinsBx0DJpb8cY6UsmsYdc0me6ASedCgMCfL+G6erJprANiSjd4StWFAnB2KF3vdzHxIt3xI82c9NAooIR4bdB4dhDtxm8sV27DR5Aznyezpfxa5sbAAC3vFCHKpPH1IEW+5PbxLV3mTa9IVvmXMhx91OPkiIc=
Received: from BN8PR21MB1284.namprd21.prod.outlook.com (2603:10b6:408:a2::22)
 by BN8PR21MB1153.namprd21.prod.outlook.com (2603:10b6:408:72::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.6; Sat, 30 Oct
 2021 15:54:55 +0000
Received: from BN8PR21MB1284.namprd21.prod.outlook.com
 ([fe80::5962:fbb9:f607:8018]) by BN8PR21MB1284.namprd21.prod.outlook.com
 ([fe80::5962:fbb9:f607:8018%7]) with mapi id 15.20.4669.004; Sat, 30 Oct 2021
 15:54:55 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>
Subject: RE: [PATCH net-next 4/4] net: mana: Support hibernation and kexec
Thread-Topic: [PATCH net-next 4/4] net: mana: Support hibernation and kexec
Thread-Index: AQHXzSi5FL+xs47DTkemjnXcBfjf5qvrr5YA
Date:   Sat, 30 Oct 2021 15:54:55 +0000
Message-ID: <BN8PR21MB1284785C320EFE09C75286B6CA889@BN8PR21MB1284.namprd21.prod.outlook.com>
References: <20211030005408.13932-1-decui@microsoft.com>
 <20211030005408.13932-5-decui@microsoft.com>
In-Reply-To: <20211030005408.13932-5-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=38d1b54a-de51-47ac-a27e-8db573cfb9ed;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-30T15:43:58Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47838998-307f-4ecb-bcb3-08d99bbd9e74
x-ms-traffictypediagnostic: BN8PR21MB1153:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BN8PR21MB11535F635B6A98AAD77F3C56CA889@BN8PR21MB1153.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZC5Z/F3F+2knMQ5xELmyVXDE0hnlUShib9BsgqlTtffHnVB2ec3RXbfD0pK0iTwO6IRlgM26L+DestZNCzh68OMtujfwEf56626vahpkPGWh/QBWcUjQhG40/cBX/gJh9nj5Y8nDcDdK2mEuEf0mYmMr+w4ArD96oFEdrYrUXVJkzrs16gM4cMQpIWeV8wZbkaembZi8Q/8bv45gycTBGxdO3eK/IyK07NYSBVLvPxPzabEuQGEqJm2V639WFrHJHoMgVQ88DnSCymZKaG6nCCpyGvTomwn6YpJuowMPiwrTWVHbT8KhPtsXMrv7AUCqhOF2N8AiOJ7edVe0yqxsQWsSIVpSBwdBATL0bTwZ/S6iXi9LYdR2KCF7K60FkeEubSK/vbisjZgT8A6nH95Fvbf8dbj9Ef4x0UM3N0J2cMEjTIA7T51y3B3XAJmg60bsbJ+hBnLrSLuI+OTbWcfW302lv2Fq3z4rgx7YQpto+wCqblLQUEqhWRCftr//kaahuJtLNsvwsuiaOsE0WNt2+9NDz6Xml0OoHk1IqbSSqmWYjbUWzizUrlHjVSGD3rW3zX5F9JBXU0nVfjB3yhRlxBJYuopKhSr+nDk9Z/C3v9Foj5gkXlwsWEC4h8iqQLQXf6GsomG8buWMPqnwB5tEunE9CqFG+hap2SRFnXYokMkil3ZwijQYkjF79nUtZpLAfttP0tSV3Kp+aLhMDTfQKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1284.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(82950400001)(55016002)(54906003)(5660300002)(86362001)(52536014)(8990500004)(8676002)(508600001)(316002)(38070700005)(7416002)(82960400001)(71200400001)(8936002)(186003)(26005)(66446008)(66946007)(64756008)(66556008)(38100700002)(83380400001)(66476007)(110136005)(76116006)(6506007)(10290500003)(4326008)(53546011)(9686003)(33656002)(2906002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ERK3UFp8S+LmaWEXw+CbM+Y/Q3KCX0crYB0Y9G/WlnnTcN6NsmBvVx0RgAvD?=
 =?us-ascii?Q?HfCWxUDUMxrwHuXEi9EROKtGE6GvLdUDJQ80zgNTtJi9rYSFmNv2BYTB/4ai?=
 =?us-ascii?Q?Vib3kFcuT8chHHq9mh5qGg7T474mlTeqxGinfQu2DtgoQXq5Oc/agd9NHUnV?=
 =?us-ascii?Q?ZjIBaedxmW9HK95KaCNh5erWxBWENtgg91JphUlffLnrL+6cfQIjH2prpp/1?=
 =?us-ascii?Q?AezYpuPY7npbKJkiRr22w4UvURiLfP+I4Kmd2nXR8zAGcYHvmew9KLTlAfVz?=
 =?us-ascii?Q?2NA0NFrqnGhE7ppw4HQLG3xrt9KcHj4WNsAiGw2SU/0whb2r2zE3Jyz934Yg?=
 =?us-ascii?Q?HB6KBh9NELuy5Lvp67OqpomhiIzwgiwbsCj5b1IN+rv1NoEMbrAaS5L3h+5h?=
 =?us-ascii?Q?qinyMuUWY5RCyteEKaiwDVgcPrYI1Qbu6TeSu4O9ZbXZLPRX1+LQ0LPW1TVL?=
 =?us-ascii?Q?RLBV1o0WWtydrqqAiZzAIRUYLFBdQ+OlzLI3g/zSWWzNXzS+CatUUX2lDgzd?=
 =?us-ascii?Q?KT6XRI4BYyFSzpBZESVi2VrgyPlHmVRE7At5AdTfPlkNFiQxsDNml0/VAJbq?=
 =?us-ascii?Q?2huxj60fSCLEr35ofwX+71BAHKs9eBTe5HZYnPZ0Fl9jieu7A0+eqoKsSJWz?=
 =?us-ascii?Q?4muq5QVx/EXcMuCvRlKamAQH3jGok8jeph5lYS89nVdj1ft5ZsK1XVyCi3gC?=
 =?us-ascii?Q?2nf17kj46SJEs5q/UQELaf1PXAvx9qEfGEu3dwT9iiCig40DB+7qSzvlCXy1?=
 =?us-ascii?Q?LRKxswXz2kOyFZhzt71P3QcEnslpluQlgr0FIAmWKzzEM5wLijc/wSIn7xS4?=
 =?us-ascii?Q?7XUxGSo/moMMSAR3Bo0dCgSOqhXwDGm+GuE3w0DFuDdwHVJrj5bkZ+UHRwJr?=
 =?us-ascii?Q?EaqZrRjxhJlouqoab8vXJ7zmYHwf4lY8aB+Z02102kP/dF99TjESVhrx4OPf?=
 =?us-ascii?Q?Ct4VN0sNUzV2bOnT1GeHR+MUYeeijnLGTHT2fkfwLpNKd7U7k0bOa99Drjs4?=
 =?us-ascii?Q?sC8gOlVC1ENVMqCKMdttZ5XebkKDev3xNUUGulc1yk/47YldeHHRTbQNsf0I?=
 =?us-ascii?Q?I2u9fvi7sbwPtwsGV9YRW+grYRrgHhbKt+Uxbss7oQl6ZVoWSvYbolg/NdUv?=
 =?us-ascii?Q?XLxsmlqkEJS1lZOs2ZVvyKirnajB7ctVGaZqR+Q0kegfnFYQv+oxcJ3ogtdu?=
 =?us-ascii?Q?YZaQHsiUg3NJB4o/Z2uKFCNQoaRJF9av9f9x2Igr3tIyDHa2ptkf8W4zSJyN?=
 =?us-ascii?Q?bjzHpbNSB5iQtDfinuk9nQHYEUpTeSQt6f9fSGAovrdo/zAjvn7lvk14yoKA?=
 =?us-ascii?Q?zaH5so7WM6vvq8+90oqju/F4J/gJPe8DzhbTrNlCyCWGjzGK2LhQgMGM7hUa?=
 =?us-ascii?Q?f8lRHBWppkFKXutoMHjxlvCI5IVyExKREh4H3OLVp8GEckU+yeCJHY1TYeoS?=
 =?us-ascii?Q?TiFs3ht5EcdBYz8wNytoWmtJiTTlNMhgH1g/QZIxPC1miiTxBlbbEUjCaoIm?=
 =?us-ascii?Q?rabFMH51ya0MkKVWI+IiyUkG+mEljZ1xnuD+YmTBAZqMmYo3Jjd5XHP2VQvu?=
 =?us-ascii?Q?NAfdZ5I/lx2T0DjzTxbYRheLy5Z2zpSLPYa4jeyIpAkC4z260Vxpz6FZD3l5?=
 =?us-ascii?Q?KQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR21MB1284.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47838998-307f-4ecb-bcb3-08d99bbd9e74
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2021 15:54:55.7721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zv9L6CDDIEYqY6KK4FLL8YvxzbrF5Nk9K2IL3OPUCuMYH/z1zxCGk1DYuFGj/7pGUXFPH4YyWDRrpoESMrm52Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1153
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui <decui@microsoft.com>
> Sent: Friday, October 29, 2021 8:54 PM
> To: davem@davemloft.net; kuba@kernel.org; gustavoars@kernel.org; Haiyang
> Zhang <haiyangz@microsoft.com>; netdev@vger.kernel.org
> Cc: KY Srinivasan <kys@microsoft.com>; stephen@networkplumber.org;
> wei.liu@kernel.org; linux-kernel@vger.kernel.org; linux-
> hyperv@vger.kernel.org; Shachar Raindel <shacharr@microsoft.com>; Paul
> Rosswurm <paulros@microsoft.com>; olaf@aepfle.de; vkuznets
> <vkuznets@redhat.com>; Dexuan Cui <decui@microsoft.com>
> Subject: [PATCH net-next 4/4] net: mana: Support hibernation and kexec
>=20
> Implement the suspend/resume/shutdown callbacks for hibernation/kexec.
>=20
> Add mana_gd_setup() and mana_gd_cleanup() for some common code, and
> use them in the mand_gd_* callbacks.
>=20
> Reuse mana_probe/remove() for the hibernation path.
>=20
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  .../net/ethernet/microsoft/mana/gdma_main.c   | 140 +++++++++++++-----
>  drivers/net/ethernet/microsoft/mana/mana.h    |   4 +-
>  drivers/net/ethernet/microsoft/mana/mana_en.c |  72 +++++++--
>  3 files changed, 164 insertions(+), 52 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index 599dfd5e6090..c96ac81212f7 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -1258,6 +1258,52 @@ static void mana_gd_remove_irqs(struct pci_dev
> *pdev)
>  	gc->irq_contexts =3D NULL;
>  }
>=20
> +static int mana_gd_setup(struct pci_dev *pdev)
> +{
> +	struct gdma_context *gc =3D pci_get_drvdata(pdev);
> +	int err;
> +
> +	mana_gd_init_registers(pdev);
> +	mana_smc_init(&gc->shm_channel, gc->dev, gc->shm_base);
> +
> +	err =3D mana_gd_setup_irqs(pdev);
> +	if (err)
> +		return err;
> +
> +	err =3D mana_hwc_create_channel(gc);
> +	if (err)
> +		goto remove_irq;
> +
> +	err =3D mana_gd_verify_vf_version(pdev);
> +	if (err)
> +		goto destroy_hwc;
> +
> +	err =3D mana_gd_query_max_resources(pdev);
> +	if (err)
> +		goto destroy_hwc;
> +
> +	err =3D mana_gd_detect_devices(pdev);
> +	if (err)
> +		goto destroy_hwc;
> +
> +	return 0;
> +
> +destroy_hwc:
> +	mana_hwc_destroy_channel(gc);
> +remove_irq:
> +	mana_gd_remove_irqs(pdev);
> +	return err;
> +}
> +
> +static void mana_gd_cleanup(struct pci_dev *pdev)
> +{
> +	struct gdma_context *gc =3D pci_get_drvdata(pdev);
> +
> +	mana_hwc_destroy_channel(gc);
> +
> +	mana_gd_remove_irqs(pdev);
> +}
> +
>  static int mana_gd_probe(struct pci_dev *pdev, const struct
> pci_device_id *ent)
>  {
>  	struct gdma_context *gc;
> @@ -1287,6 +1333,9 @@ static int mana_gd_probe(struct pci_dev *pdev,
> const struct pci_device_id *ent)
>  	if (!gc)
>  		goto release_region;
>=20
> +	mutex_init(&gc->eq_test_event_mutex);
> +	pci_set_drvdata(pdev, gc);
> +
>  	bar0_va =3D pci_iomap(pdev, bar, 0);
>  	if (!bar0_va)
>  		goto free_gc;
> @@ -1294,47 +1343,23 @@ static int mana_gd_probe(struct pci_dev *pdev,
> const struct pci_device_id *ent)
>  	gc->bar0_va =3D bar0_va;
>  	gc->dev =3D &pdev->dev;
>=20
> -	pci_set_drvdata(pdev, gc);
> -
> -	mana_gd_init_registers(pdev);
>=20
> -	mana_smc_init(&gc->shm_channel, gc->dev, gc->shm_base);
> -
> -	err =3D mana_gd_setup_irqs(pdev);
> +	err =3D mana_gd_setup(pdev);
>  	if (err)
>  		goto unmap_bar;
>=20
> -	mutex_init(&gc->eq_test_event_mutex);
> -
> -	err =3D mana_hwc_create_channel(gc);
> +	err =3D mana_probe(&gc->mana, false);
>  	if (err)
> -		goto remove_irq;
> -
> -	err =3D mana_gd_verify_vf_version(pdev);
> -	if (err)
> -		goto remove_irq;
> -
> -	err =3D mana_gd_query_max_resources(pdev);
> -	if (err)
> -		goto remove_irq;
> -
> -	err =3D mana_gd_detect_devices(pdev);
> -	if (err)
> -		goto remove_irq;
> -
> -	err =3D mana_probe(&gc->mana);
> -	if (err)
> -		goto clean_up_gdma;
> +		goto cleanup_gd;
>=20
>  	return 0;
>=20
> -clean_up_gdma:
> -	mana_hwc_destroy_channel(gc);
> -remove_irq:
> -	mana_gd_remove_irqs(pdev);
> +cleanup_gd:
> +	mana_gd_cleanup(pdev);
>  unmap_bar:
>  	pci_iounmap(pdev, bar0_va);
>  free_gc:
> +	pci_set_drvdata(pdev, NULL);
>  	vfree(gc);
>  release_region:
>  	pci_release_regions(pdev);
> @@ -1349,11 +1374,9 @@ static void mana_gd_remove(struct pci_dev *pdev)
>  {
>  	struct gdma_context *gc =3D pci_get_drvdata(pdev);
>=20
> -	mana_remove(&gc->mana);
> +	mana_remove(&gc->mana, false);
>=20
> -	mana_hwc_destroy_channel(gc);
> -
> -	mana_gd_remove_irqs(pdev);
> +	mana_gd_cleanup(pdev);
>=20
>  	pci_iounmap(pdev, gc->bar0_va);
>=20
> @@ -1364,6 +1387,52 @@ static void mana_gd_remove(struct pci_dev *pdev)
>  	pci_disable_device(pdev);
>  }
>=20
> +/* The 'state' parameter is not used. */
> +static int mana_gd_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	struct gdma_context *gc =3D pci_get_drvdata(pdev);
> +
> +	mana_remove(&gc->mana, true);
> +
> +	mana_gd_cleanup(pdev);
> +
> +	return 0;
> +}
> +
> +/* In case the NIC hardware stops working, the suspend and resume
> callbacks will
> + * fail -- if this happens, it's safer to just report an error than try
> to undo
> + * what has been done.
> + */
> +static int mana_gd_resume(struct pci_dev *pdev)
> +{
> +	struct gdma_context *gc =3D pci_get_drvdata(pdev);
> +	int err;
> +
> +	err =3D mana_gd_setup(pdev);
> +	if (err)
> +		return err;
> +
> +	err =3D mana_probe(&gc->mana, true);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +
> +/* Quiesce the device for kexec. This is also called upon
> reboot/shutdown. */
> +static void mana_gd_shutdown(struct pci_dev *pdev)
> +{
> +	struct gdma_context *gc =3D pci_get_drvdata(pdev);
> +
> +	dev_info(&pdev->dev, "Shutdown was calledd\n");
> +
> +	mana_remove(&gc->mana, true);
> +
> +	mana_gd_cleanup(pdev);
> +
> +	pci_disable_device(pdev);
> +}
> +
>  #ifndef PCI_VENDOR_ID_MICROSOFT
>  #define PCI_VENDOR_ID_MICROSOFT 0x1414
>  #endif
> @@ -1378,6 +1447,9 @@ static struct pci_driver mana_driver =3D {
>  	.id_table	=3D mana_id_table,
>  	.probe		=3D mana_gd_probe,
>  	.remove		=3D mana_gd_remove,
> +	.suspend	=3D mana_gd_suspend,
> +	.resume		=3D mana_gd_resume,
> +	.shutdown	=3D mana_gd_shutdown,
>  };
>=20
>  module_pci_driver(mana_driver);
> diff --git a/drivers/net/ethernet/microsoft/mana/mana.h
> b/drivers/net/ethernet/microsoft/mana/mana.h
> index fc98a5ba5ed0..d047ee876f12 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana.h
> +++ b/drivers/net/ethernet/microsoft/mana/mana.h
> @@ -374,8 +374,8 @@ int mana_alloc_queues(struct net_device *ndev);
>  int mana_attach(struct net_device *ndev);
>  int mana_detach(struct net_device *ndev, bool from_close);
>=20
> -int mana_probe(struct gdma_dev *gd);
> -void mana_remove(struct gdma_dev *gd);
> +int mana_probe(struct gdma_dev *gd, bool resuming);
> +void mana_remove(struct gdma_dev *gd, bool suspending);
>=20
>  extern const struct ethtool_ops mana_ethtool_ops;
>=20
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c
> b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 4ff5a1fc506f..820585d45a61 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -1828,11 +1828,12 @@ static int mana_probe_port(struct mana_context
> *ac, int port_idx,
>  	return err;
>  }
>=20
> -int mana_probe(struct gdma_dev *gd)
> +int mana_probe(struct gdma_dev *gd, bool resuming)
>  {
>  	struct gdma_context *gc =3D gd->gdma_context;
> +	struct mana_context *ac =3D gd->driver_data;
>  	struct device *dev =3D gc->dev;
> -	struct mana_context *ac;
> +	u16 num_ports =3D 0;
>  	int err;
>  	int i;
>=20
> @@ -1844,44 +1845,70 @@ int mana_probe(struct gdma_dev *gd)
>  	if (err)
>  		return err;
>=20
> -	ac =3D kzalloc(sizeof(*ac), GFP_KERNEL);
> -	if (!ac)
> -		return -ENOMEM;
> +	if (!resuming) {
> +		ac =3D kzalloc(sizeof(*ac), GFP_KERNEL);
> +		if (!ac)
> +			return -ENOMEM;
>=20
> -	ac->gdma_dev =3D gd;
> -	ac->num_ports =3D 1;
> -	gd->driver_data =3D ac;
> +		ac->gdma_dev =3D gd;
> +		gd->driver_data =3D ac;
> +	}
>=20
>  	err =3D mana_create_eq(ac);
>  	if (err)
>  		goto out;
>=20
>  	err =3D mana_query_device_cfg(ac, MANA_MAJOR_VERSION,
> MANA_MINOR_VERSION,
> -				    MANA_MICRO_VERSION, &ac->num_ports);
> +				    MANA_MICRO_VERSION, &num_ports);
>  	if (err)
>  		goto out;
>=20
> +	if (!resuming) {
> +		ac->num_ports =3D num_ports;
> +	} else {
> +		if (ac->num_ports !=3D num_ports) {
> +			dev_err(dev, "The number of vPorts changed: %d->%d\n",
> +				ac->num_ports, num_ports);
> +			err =3D -EPROTO;
> +			goto out;
> +		}
> +	}
> +
> +	if (ac->num_ports =3D=3D 0)
> +		dev_err(dev, "Failed to detect any vPort\n");
> +
>  	if (ac->num_ports > MAX_PORTS_IN_MANA_DEV)
>  		ac->num_ports =3D MAX_PORTS_IN_MANA_DEV;
>=20
> -	for (i =3D 0; i < ac->num_ports; i++) {
> -		err =3D mana_probe_port(ac, i, &ac->ports[i]);
> -		if (err)
> -			break;
> +	if (!resuming) {
> +		for (i =3D 0; i < ac->num_ports; i++) {
> +			err =3D mana_probe_port(ac, i, &ac->ports[i]);
> +			if (err)
> +				break;
> +		}
> +	} else {
> +		for (i =3D 0; i < ac->num_ports; i++) {
> +			rtnl_lock();
> +			err =3D mana_attach(ac->ports[i]);
> +			rtnl_unlock();
> +			if (err)
> +				break;
> +		}
>  	}
>  out:
>  	if (err)
> -		mana_remove(gd);
> +		mana_remove(gd, false);

The "goto out" can happen in both resuming true/false cases,
should the error handling path deal with the two cases
differently?


Other parts look good.

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>


>=20
>  	return err;
>  }
>=20
> -void mana_remove(struct gdma_dev *gd)
> +void mana_remove(struct gdma_dev *gd, bool suspending)
>  {
>  	struct gdma_context *gc =3D gd->gdma_context;
>  	struct mana_context *ac =3D gd->driver_data;
>  	struct device *dev =3D gc->dev;
>  	struct net_device *ndev;
> +	int err;
>  	int i;
>=20
>  	for (i =3D 0; i < ac->num_ports; i++) {
> @@ -1897,7 +1924,16 @@ void mana_remove(struct gdma_dev *gd)
>  		 */
>  		rtnl_lock();
>=20
> -		mana_detach(ndev, false);
> +		err =3D mana_detach(ndev, false);
> +		if (err)
> +			netdev_err(ndev, "Failed to detach vPort %d: %d\n",
> +				   i, err);
> +
> +		if (suspending) {
> +			/* No need to unregister the ndev. */
> +			rtnl_unlock();
> +			continue;
> +		}
>=20
>  		unregister_netdevice(ndev);
>=20
> @@ -1910,6 +1946,10 @@ void mana_remove(struct gdma_dev *gd)
>=20
>  out:
>  	mana_gd_deregister_device(gd);
> +
> +	if (suspending)
> +		return;
> +
>  	gd->driver_data =3D NULL;
>  	gd->gdma_context =3D NULL;
>  	kfree(ac);
> --
> 2.17.1

