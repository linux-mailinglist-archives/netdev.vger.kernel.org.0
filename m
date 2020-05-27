Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436681E3AB7
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 09:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbgE0Hgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 03:36:45 -0400
Received: from mail-eopbgr1320107.outbound.protection.outlook.com ([40.107.132.107]:19736
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728888AbgE0Hgo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 03:36:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPgL7Tuasm/8D0249D2D0DYQ1kBAB3RI+WeUrxPEZ63oVTSt/5TOaE/z2Qnzo8RgKOCXL3ofRpDbseJv/X7h93Px+U1ORAvUoL7qZnHj6lj/PNJo+Q5i2MRRwVrWXH5y/KIbuuLe4E1fAkaiz998jk+K+KjxI/FLjJP7XFa1MyXyD/hdKmtuJN8eIhTaJKJ2KJTPdvHjdoIRfD8MpzJnAluD5rMNU7ZyRJVQJ4ml8+Z43zUj+8AdDq9XpufPGyQrkmkam1qPGALqRSr6fD5X/1EDJSwdp3pPofNljgNJlX4YQpgKbiKCPXsQcwn5RQSiRf/90WETOWghoaBvFEGo2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mvYMmb3S49axYVUkZnXGtxEVS7p+qSD3mCyZpN1Gjxg=;
 b=SooRjHoKgFbLLNsY5hIE7jRulQR3sJR9dUmwwRrQqfAr5RAlBznO1KtWx0y0dY2jVlZzxirCs+HexsrcWnleLE/D6rgiyict1Tc7cJYdGhSUg4w2NbuegCLvWO6tUFwKb6Pws46y9Fi7IHY05qJTNXHsZSCXe3VpA5edBpyuzTfoudT70qyULzB9vi7/L+CH6zeArYPbkwAGizWIALTzcRTKVfOUGgTxj/6CTxtIvfpFlZRC5aGe8vyRSF1hkfDCzhCAalM/Bf/7DNnw1fYyAcaURf8aXs1ny6H4LhQfXVrY77Ppgm9B6gsL6Pio6yBHEF6/iEiwFf/imevXgHKTgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mvYMmb3S49axYVUkZnXGtxEVS7p+qSD3mCyZpN1Gjxg=;
 b=JH7hRT7elvC8M2fhMR7EL8dUOTK5KwFnyedFEtCAxg4njyAgHNPWIvf8GqphjmWdEunLbBSLJuomEYhregcC135qCA+gLb4lDq3myWhc1pyhBNefGVRGJ+mSTPDY0mfMJ9N6a+eb96uV3ugOjftSFxNhXjZAkrF6oU3aQ6ALTBk=
Received: from HK0P153MB0113.APCP153.PROD.OUTLOOK.COM (2603:1096:203:19::14)
 by HK0P153MB0162.APCP153.PROD.OUTLOOK.COM (2603:1096:203:1a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.3; Wed, 27 May
 2020 07:36:40 +0000
Received: from HK0P153MB0113.APCP153.PROD.OUTLOOK.COM
 ([fe80::c196:a6cb:9d5:c814]) by HK0P153MB0113.APCP153.PROD.OUTLOOK.COM
 ([fe80::c196:a6cb:9d5:c814%6]) with mapi id 15.20.3066.005; Wed, 27 May 2020
 07:36:40 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: RE: [net-next 12/16] net/mlx5: Add basic suspend/resume support
Thread-Topic: [net-next 12/16] net/mlx5: Add basic suspend/resume support
Thread-Index: AQHWM8k0A8TPUi0hPEqoBNdYwshccai7ffNg
Date:   Wed, 27 May 2020 07:36:39 +0000
Message-ID: <HK0P153MB011343BFB6F88FD5AC34F6B9BFB10@HK0P153MB0113.APCP153.PROD.OUTLOOK.COM>
References: <20200527014924.278327-1-saeedm@mellanox.com>
 <20200527014924.278327-13-saeedm@mellanox.com>
In-Reply-To: <20200527014924.278327-13-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-05-27T07:36:38Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4db8ad74-6bfc-4c4f-9c46-d26d4859baaa;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2601:600:a280:7f70:7d03:fb34:57ae:dcea]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9773cb0b-0c50-42ae-28ef-08d80210b21d
x-ms-traffictypediagnostic: HK0P153MB0162:
x-microsoft-antispam-prvs: <HK0P153MB0162FEA343C9CB4699C8F722BFB10@HK0P153MB0162.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04163EF38A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7rrYvNPT7ZKY1evlkhGexUW2C+KVXWhsigwA3ZATArVXMcd9tpbSkm+n71wm0x0aXm+IP1y56kWVriMElRyFaLDvjK4Umv8Vn2J74ak4e9ImMm+LexMX4brB797cLlb+3yamBJTNIGgAkHWwZOyC2LZsjCkoelcuHOOKlYZ9QjO2zksWk4TyIYIgP/YdVUtpzjvqZAtdNt2fE7wjNEOW9Ggze2c2cez6LLOqIjE9TDWNjJV0NUqLQ9I+BX6cO64D9VVe1LTwLlY5QmkoWHXmk6+fby2DSBe4Ax4jqp4xTRWUTH2rVoeG2tp5aTtRoS7a
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0P153MB0113.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(186003)(55016002)(86362001)(33656002)(5660300002)(82950400001)(82960400001)(6506007)(7696005)(83380400001)(8936002)(9686003)(15650500001)(8990500004)(2906002)(8676002)(53546011)(110136005)(66476007)(64756008)(76116006)(66446008)(66556008)(52536014)(4326008)(71200400001)(54906003)(316002)(66946007)(478600001)(10290500003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 7PwuQDsNL77M7zhNcQ66f0DLVg+N63aaabFdHswJ5kQApcEPumSekUdP7uYAz4m2SOtmgAIah0K2TJIqnuVToCIEhqrm4iabdFbv5n3+5mZjGDKSRSqngOFlnT1RJCgdm6sLIOQLhaMeO7S6U9VMuiZghPA60DOmnTo6efNSsFiLhCKD9zuqXYMC7Wa8dhabIx2xdRH0IYf4V+z2eLwVUs27i+RJurO8gx2HkV+uoI5eARjTmEuo43u+xq0yMX7CcMhCNFSiTKk4Ulmui+7cZpgjvQN81MBXuHKq+d06JczJv8BfhDYGSQeiBqLUbWXwDTa2xT3P4kXnLeZbRhLJjmwwrtwC4KgV3oaO9+APd2zjp+JDgXnAcSkQ+QhtevQMjkv5CILIy5yiHCxE8q6cbe4e4kaeW1E5iXdqTl6dLxtnweANeS9zoyCMr+F5TXXgKcl0BQBG+xs+0tlKcTtEKVSsX1CHcHBgSWwpuU+EWKI9AZhS3McimsQt8Q7J32ubaigAliYHC5elCw5kRYtfGxrnSYombJdQ0mHNjdYRCpOiLSa/5stJPxV35yLVL8nK
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9773cb0b-0c50-42ae-28ef-08d80210b21d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2020 07:36:39.9705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SawF2o2x47cj+wcMh14QRQ4yBC8NbvMaFVzzGU3bqgBwoBw72JzhzksIuc/tjV0B38bvsMkIEKfz7t+QlDJ1FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0P153MB0162
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Saeed Mahameed <saeedm@mellanox.com>
> Sent: Tuesday, May 26, 2020 6:49 PM
> To: David S. Miller <davem@davemloft.net>; kuba@kernel.org
> Cc: netdev@vger.kernel.org; Mark Bloch <markb@mellanox.com>; Dexuan Cui
> <decui@microsoft.com>; Moshe Shemesh <moshe@mellanox.com>; Saeed
> Mahameed <saeedm@mellanox.com>
> Subject: [net-next 12/16] net/mlx5: Add basic suspend/resume support
>=20
> From: Mark Bloch <markb@mellanox.com>
>=20
> Add callbacks so the NIC could be suspended and resumed.
>=20
> Tested-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Mark Bloch <markb@mellanox.com>
> Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/main.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index 30de3bf35c6d..408ee64aa33b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -1539,6 +1539,22 @@ static void shutdown(struct pci_dev *pdev)
>  	mlx5_pci_disable_device(dev);
>  }
>=20
> +static int mlx5_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	struct mlx5_core_dev *dev =3D pci_get_drvdata(pdev);
> +
> +	mlx5_unload_one(dev, false);
> +
> +	return 0;
> +}
> +
> +static int mlx5_resume(struct pci_dev *pdev)
> +{
> +	struct mlx5_core_dev *dev =3D pci_get_drvdata(pdev);
> +
> +	return mlx5_load_one(dev, false);
> +}
> +
>  static const struct pci_device_id mlx5_core_pci_table[] =3D {
>  	{ PCI_VDEVICE(MELLANOX, PCI_DEVICE_ID_MELLANOX_CONNECTIB) },
>  	{ PCI_VDEVICE(MELLANOX, 0x1012), MLX5_PCI_DEV_IS_VF},	/*
> Connect-IB VF */
> @@ -1582,6 +1598,8 @@ static struct pci_driver mlx5_core_driver =3D {
>  	.id_table       =3D mlx5_core_pci_table,
>  	.probe          =3D init_one,
>  	.remove         =3D remove_one,
> +	.suspend        =3D mlx5_suspend,
> +	.resume         =3D mlx5_resume,
>  	.shutdown	=3D shutdown,
>  	.err_handler	=3D &mlx5_err_handler,
>  	.sriov_configure   =3D mlx5_core_sriov_configure,
> --
> 2.26.2

Hi David,
Can you please consider this patch for v5.7 and the stable tree v5.6.y?

I understand it's already v5.7-rc7 now, but IHMO applying this patch
to v5.7 and v5.6.y can bring an immediate benefit and can not break
anything existing: currently a Linux system with the mlx5 NIC always=20
crashes upon hibernation. With this patch, hibernation works fine with
the NIC in my tests.=20

Some users who are trying to hiberante their VMs (which run on Hyper-V
and Azure) have reported the crash to me for several months, so IMHO
it would be really great if the patch can land in v5.7 and v5.6.y rather=20
than land in v5.8 in ~2 months and is backported to v5.6.y and v5.7.y.

Thanks,
-- Dexuan
