Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E179A8DC9
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730378AbfIDRkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 13:40:31 -0400
Received: from mail-eopbgr720057.outbound.protection.outlook.com ([40.107.72.57]:16274
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726495AbfIDRkb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 13:40:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N3UK//YL2ExX2hOrYq3NYBmWEdNxB2QdKmDVfA4yTYAVOnd4nKAXyxhC1ao5kA/yxKtNHenJqVNTGlnMoYgnK89/1s22iT4kSEN5efMnjU4fbc4K63eYrHBwAEKqOnorZgdw+/Sl3glcsCK8XHWQSC25KucD/An/TeWtQXT1RQf+We7sWgESCNtNVvKETpXtHKrmUx+WTJa+OJmiNBSq4EiG72XjbIGP6oanGYiFJiRc6g78q3L54FEuHaRZmf3Qc5aPZXbGX7c409mIdQuIxFT5jxHieEbx/KJxroKg04ecIq5Ijel3Yae5UQkKWva5YkeQLuM8mTFGO6dJ3xUyEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i85fFXAnBchhgznVyV+0eqB+CiVIJURFYrpMfiXnFhg=;
 b=JPCrBH9m25AvY1JW9CKg6QvOXHVhN7lL02B5GG8ceBTPxPfpTnydYfVTXGHYKMSaCrXYhvY4djdtvM8WfhMK1Y/la3eAFJzXGWTKHNhnu4wbZmjzIwHemE4e4RtDy4/peiVbCZAFm1D1rVJJOiIpctd4Gnz1H9lqBVB7MZpUiq23yUUJadSM1fzEWhMA59CXrCi+qccr8swdpPpbYZ2fX/ecCiryRk/Yw4jkGBjmUHr3gFPW9YxAjmjn6L+K37XJ/dw3fgs7sUfxn6Pga87YqFwZH3Zl5GHtXP6De3I/qumpowT/JbKdgot06JgbVExw+H3HIhJ+xbWUsajppt8FuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i85fFXAnBchhgznVyV+0eqB+CiVIJURFYrpMfiXnFhg=;
 b=Mq3nb+BNGLv7qGYmA6R+g3/AsK5KnE1PePKJkU4Wvv2ZT4cPOI+FJTSq4swyaaLfqT8eTjTSsn+hyS5D5T7zyuTnT+1GrsaZeKYA07zp+jzd9GAYBIPFHNpNN9IN4espWU44HOZN+HEIk4FklFvSFg48RDW+EZ0EaeFwUbQMZNE=
Received: from BN7PR02MB5124.namprd02.prod.outlook.com (20.176.27.215) by
 BN7PR02MB5204.namprd02.prod.outlook.com (20.176.176.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Wed, 4 Sep 2019 17:40:22 +0000
Received: from BN7PR02MB5124.namprd02.prod.outlook.com
 ([fe80::edff:8393:fe66:4a2d]) by BN7PR02MB5124.namprd02.prod.outlook.com
 ([fe80::edff:8393:fe66:4a2d%5]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 17:40:22 +0000
From:   Kalyani Akula <kalyania@xilinx.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pombredanne@nexb.com" <pombredanne@nexb.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sarat Chand Savitala <saratcha@xilinx.com>
Subject: RE: [PATCH V2 4/4] crypto: Add Xilinx AES driver
Thread-Topic: [PATCH V2 4/4] crypto: Add Xilinx AES driver
Thread-Index: AQHVYMzo8cSxnfDOFUGD/EQcibOxKqcX9ioAgAPJVCA=
Date:   Wed, 4 Sep 2019 17:40:22 +0000
Message-ID: <BN7PR02MB512445C31936CED70F02D15AAFB80@BN7PR02MB5124.namprd02.prod.outlook.com>
References: <1567346098-27927-1-git-send-email-kalyani.akula@xilinx.com>
 <1567346098-27927-5-git-send-email-kalyani.akula@xilinx.com>
 <20190902065854.GA28750@Red>
In-Reply-To: <20190902065854.GA28750@Red>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kalyania@xilinx.com; 
x-originating-ip: [183.83.134.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27d6cf81-d953-420c-0fa1-08d7315ef634
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BN7PR02MB5204;
x-ms-traffictypediagnostic: BN7PR02MB5204:|BN7PR02MB5204:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR02MB5204E2FC44CDAB5305C83A9EAFB80@BN7PR02MB5204.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(136003)(346002)(376002)(13464003)(51914003)(189003)(199004)(256004)(486006)(14454004)(229853002)(11346002)(476003)(6436002)(52536014)(478600001)(6916009)(446003)(5660300002)(66066001)(81166006)(81156014)(33656002)(7696005)(76176011)(74316002)(53936002)(26005)(8676002)(186003)(8936002)(3846002)(6116002)(102836004)(6506007)(53546011)(86362001)(25786009)(4326008)(2906002)(54906003)(107886003)(316002)(66446008)(64756008)(66556008)(71200400001)(66946007)(6246003)(66476007)(55016002)(9686003)(305945005)(76116006)(7736002)(71190400001)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR02MB5204;H:BN7PR02MB5124.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ueNiC358Wy8/t1+QbSNzcZ9fqEERGS5W+ppLzKx2eY1+vpwcEu5VDyidHjpgdAbJlnL2r9f8QTPq5glpNbAoOKeCydSndEfa8ZUiKYR4E9oLwsiVJ8391K8Lu/XYYjfmmWJlLT7/f2Q2U6z3f3dWbPqRmK2+uL3+23JWFv1+KofWtw9ZonKZXxjVW5KF8qYCxl0tgsmDcijRfYUsmaxdmHE4dxo7Zlk8zwzzhAQAcBcRjxOLZg2OZC71wOS81+jzLPmjR+EKvkQsqlW4D8iTz4xtIEgrz8R8XVN5azLimgF+h4K4tRVhVWecN37LIIJfyl/XVAy4ty3j6LXSD8dRRvppzgs3EYNoIjyk75wZjuShXdJ0JSF+pNUope7HixZub4vU9DO86+IbtCmFd3nplx3qx8Yex24KrufznW/G5Dg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27d6cf81-d953-420c-0fa1-08d7315ef634
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 17:40:22.1819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KtjHD5DYDtLKJep/E+FXgQMR/LzenhS8zCrwztOP4sL5RJK41lGvfXYfa1S92Oy1jE1BF/8T3eav/IMm09szow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB5204
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Corentin,

Thanks for the review comments.
Please find my response/queries inline.

> -----Original Message-----
> From: Corentin Labbe <clabbe.montjoie@gmail.com>
> Sent: Monday, September 2, 2019 12:29 PM
> To: Kalyani Akula <kalyania@xilinx.com>
> Cc: herbert@gondor.apana.org.au; kstewart@linuxfoundation.org;
> gregkh@linuxfoundation.org; tglx@linutronix.de; pombredanne@nexb.com;
> linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org;
> netdev@vger.kernel.org; Kalyani Akula <kalyania@xilinx.com>
> Subject: Re: [PATCH V2 4/4] crypto: Add Xilinx AES driver
>=20
> On Sun, Sep 01, 2019 at 07:24:58PM +0530, Kalyani Akula wrote:
> > This patch adds AES driver support for the Xilinx ZynqMP SoC.
> >
> > Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
> > ---
>=20
> Hello
>=20
> I have some comment below
>=20
> >  drivers/crypto/Kconfig          |  11 ++
> >  drivers/crypto/Makefile         |   1 +
> >  drivers/crypto/zynqmp-aes-gcm.c | 297
> > ++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 309 insertions(+)
> >  create mode 100644 drivers/crypto/zynqmp-aes-gcm.c
> >
> > diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig index
> > 603413f..a0d058a 100644
> > --- a/drivers/crypto/Kconfig
> > +++ b/drivers/crypto/Kconfig
> > @@ -677,6 +677,17 @@ config CRYPTO_DEV_ROCKCHIP
> >  	  This driver interfaces with the hardware crypto accelerator.
> >  	  Supporting cbc/ecb chainmode, and aes/des/des3_ede cipher mode.
> >
> > +config CRYPTO_DEV_ZYNQMP_AES
> > +	tristate "Support for Xilinx ZynqMP AES hw accelerator"
> > +	depends on ARCH_ZYNQMP || COMPILE_TEST
> > +	select CRYPTO_AES
> > +	select CRYPTO_SKCIPHER
> > +	help
> > +	  Xilinx ZynqMP has AES-GCM engine used for symmetric key
> > +	  encryption and decryption. This driver interfaces with AES hw
> > +	  accelerator. Select this if you want to use the ZynqMP module
> > +	  for AES algorithms.
> > +
> >  config CRYPTO_DEV_MEDIATEK
> >  	tristate "MediaTek's EIP97 Cryptographic Engine driver"
> >  	depends on (ARM && ARCH_MEDIATEK) || COMPILE_TEST diff --git
> > a/drivers/crypto/Makefile b/drivers/crypto/Makefile index
> > afc4753..c99663a 100644
> > --- a/drivers/crypto/Makefile
> > +++ b/drivers/crypto/Makefile
> > @@ -48,3 +48,4 @@ obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) +=3D bcm/
> >  obj-$(CONFIG_CRYPTO_DEV_SAFEXCEL) +=3D inside-secure/
> >  obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) +=3D axis/  obj-y +=3D hisilicon/
> > +obj-$(CONFIG_CRYPTO_DEV_ZYNQMP_AES) +=3D zynqmp-aes-gcm.o
> > diff --git a/drivers/crypto/zynqmp-aes-gcm.c
> > b/drivers/crypto/zynqmp-aes-gcm.c new file mode 100644 index
> > 0000000..d65f038
> > --- /dev/null
> > +++ b/drivers/crypto/zynqmp-aes-gcm.c
> > @@ -0,0 +1,297 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Xilinx ZynqMP AES Driver.
> > + * Copyright (c) 2019 Xilinx Inc.
> > + */
> > +
> > +#include <crypto/aes.h>
> > +#include <crypto/scatterwalk.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/of_device.h>
> > +#include <linux/scatterlist.h>
> > +#include <linux/firmware/xlnx-zynqmp.h>
> > +
> > +#define ZYNQMP_AES_IV_SIZE			12
> > +#define ZYNQMP_AES_GCM_SIZE			16
> > +#define ZYNQMP_AES_KEY_SIZE			32
> > +
> > +#define ZYNQMP_AES_DECRYPT			0
> > +#define ZYNQMP_AES_ENCRYPT			1
> > +
> > +#define ZYNQMP_AES_KUP_KEY			0
> > +#define ZYNQMP_AES_DEVICE_KEY			1
> > +#define ZYNQMP_AES_PUF_KEY			2
> > +
> > +#define ZYNQMP_AES_GCM_TAG_MISMATCH_ERR		0x01
> > +#define ZYNQMP_AES_SIZE_ERR			0x06
> > +#define ZYNQMP_AES_WRONG_KEY_SRC_ERR		0x13
> > +#define ZYNQMP_AES_PUF_NOT_PROGRAMMED		0xE300
> > +
> > +#define ZYNQMP_AES_BLOCKSIZE			0x04
> > +
> > +static const struct zynqmp_eemi_ops *eemi_ops; struct zynqmp_aes_dev
> > +*aes_dd;
>=20
> I still think that using a global variable for storing device driver data=
 is bad.

I think storing the list of dd's would solve up the issue with global varia=
ble, but there is only one AES instance here.
Please suggest

>=20
> > +
> > +struct zynqmp_aes_dev {
> > +	struct device *dev;
> > +};
> > +
> > +struct zynqmp_aes_op {
> > +	struct zynqmp_aes_dev *dd;
> > +	void *src;
> > +	void *dst;
> > +	int len;
> > +	u8 key[ZYNQMP_AES_KEY_SIZE];
> > +	u8 *iv;
> > +	u32 keylen;
> > +	u32 keytype;
> > +};
> > +
> > +struct zynqmp_aes_data {
> > +	u64 src;
> > +	u64 iv;
> > +	u64 key;
> > +	u64 dst;
> > +	u64 size;
> > +	u64 optype;
> > +	u64 keysrc;
> > +};
> > +
> > +static int zynqmp_setkey_blk(struct crypto_tfm *tfm, const u8 *key,
> > +			     unsigned int len)
> > +{
> > +	struct zynqmp_aes_op *op =3D crypto_tfm_ctx(tfm);
> > +
> > +	if (((len !=3D 1) && (len !=3D  ZYNQMP_AES_KEY_SIZE)) || (!key))
>=20
> typo, two space

Will fix in the next version

>=20
> > +		return -EINVAL;
> > +
> > +	if (len =3D=3D 1) {
> > +		op->keytype =3D *key;
> > +
> > +		if ((op->keytype < ZYNQMP_AES_KUP_KEY) ||
> > +			(op->keytype > ZYNQMP_AES_PUF_KEY))
> > +			return -EINVAL;
> > +
> > +	} else if (len =3D=3D ZYNQMP_AES_KEY_SIZE) {
> > +		op->keytype =3D ZYNQMP_AES_KUP_KEY;
> > +		op->keylen =3D len;
> > +		memcpy(op->key, key, len);
> > +	}
> > +
> > +	return 0;
> > +}
>=20
> It seems your driver does not support AES keysize of 128/196, you need to
> fallback in that case.

[Kalyani] In case of 128/196 keysize, returning the error would suffice ?
Or still algorithm need to work ?
If error is enough, it is taken care by this condition=20
if (((len !=3D 1) && (len !=3D  ZYNQMP_AES_KEY_SIZE)) || (!key))


> You need to comment the keylen=3D1 usecase and use a define for this valu=
e.
>=20

Will fix in next version

> > +
> > +static int zynqmp_aes_xcrypt(struct blkcipher_desc *desc,
> > +			     struct scatterlist *dst,
> > +			     struct scatterlist *src,
> > +			     unsigned int nbytes,
> > +			     unsigned int flags)
> > +{
> > +	struct zynqmp_aes_op *op =3D crypto_blkcipher_ctx(desc->tfm);
> > +	struct zynqmp_aes_dev *dd =3D aes_dd;
> > +	int err, ret, copy_bytes, src_data =3D 0, dst_data =3D 0;
> > +	dma_addr_t dma_addr, dma_addr_buf;
> > +	struct zynqmp_aes_data *abuf;
> > +	struct blkcipher_walk walk;
> > +	unsigned int data_size;
> > +	size_t dma_size;
> > +	char *kbuf;
> > +
> > +	if (!eemi_ops->aes)
> > +		return -ENOTSUPP;
> > +
> > +	if (op->keytype =3D=3D ZYNQMP_AES_KUP_KEY)
> > +		dma_size =3D nbytes + ZYNQMP_AES_KEY_SIZE
> > +			+ ZYNQMP_AES_IV_SIZE;
> > +	else
> > +		dma_size =3D nbytes + ZYNQMP_AES_IV_SIZE;
> > +
> > +	kbuf =3D dma_alloc_coherent(dd->dev, dma_size, &dma_addr,
> GFP_KERNEL);
> > +	if (!kbuf)
> > +		return -ENOMEM;
> > +
> > +	abuf =3D dma_alloc_coherent(dd->dev, sizeof(struct zynqmp_aes_data),
> > +				  &dma_addr_buf, GFP_KERNEL);
> > +	if (!abuf) {
> > +		dma_free_coherent(dd->dev, dma_size, kbuf, dma_addr);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	data_size =3D nbytes;
> > +	blkcipher_walk_init(&walk, dst, src, data_size);
> > +	err =3D blkcipher_walk_virt(desc, &walk);
> > +	op->iv =3D walk.iv;
> > +
> > +	while ((nbytes =3D walk.nbytes)) {
> > +		op->src =3D walk.src.virt.addr;
> > +		memcpy(kbuf + src_data, op->src, nbytes);
> > +		src_data =3D src_data + nbytes;
> > +		nbytes &=3D (ZYNQMP_AES_BLOCKSIZE - 1);
> > +		err =3D blkcipher_walk_done(desc, &walk, nbytes);
> > +	}
> > +	memcpy(kbuf + data_size, op->iv, ZYNQMP_AES_IV_SIZE);
> > +	abuf->src =3D dma_addr;
> > +	abuf->dst =3D dma_addr;
> > +	abuf->iv =3D abuf->src + data_size;
> > +	abuf->size =3D data_size - ZYNQMP_AES_GCM_SIZE;
> > +	abuf->optype =3D flags;
> > +	abuf->keysrc =3D op->keytype;
> > +
> > +	if (op->keytype =3D=3D ZYNQMP_AES_KUP_KEY) {
> > +		memcpy(kbuf + data_size + ZYNQMP_AES_IV_SIZE,
> > +		       op->key, ZYNQMP_AES_KEY_SIZE);
> > +
> > +		abuf->key =3D abuf->src + data_size + ZYNQMP_AES_IV_SIZE;
> > +	} else {
> > +		abuf->key =3D 0;
> > +	}
> > +	eemi_ops->aes(dma_addr_buf, &ret);
> > +
> > +	if (ret !=3D 0) {
> > +		switch (ret) {
> > +		case ZYNQMP_AES_GCM_TAG_MISMATCH_ERR:
> > +			dev_err(dd->dev, "ERROR: Gcm Tag mismatch\n\r");
> > +			break;
> > +		case ZYNQMP_AES_SIZE_ERR:
> > +			dev_err(dd->dev, "ERROR : Non word aligned
> data\n\r");
> > +			break;
> > +		case ZYNQMP_AES_WRONG_KEY_SRC_ERR:
> > +			dev_err(dd->dev, "ERROR: Wrong KeySrc, enable secure
> mode\n\r");
> > +			break;
> > +		case ZYNQMP_AES_PUF_NOT_PROGRAMMED:
> > +			dev_err(dd->dev, "ERROR: PUF is not registered\r\n");
> > +			break;
> > +		default:
> > +			dev_err(dd->dev, "ERROR: Invalid");
> > +			break;
> > +		}
> > +		goto END;
> > +	}
> > +	if (flags)
> > +		copy_bytes =3D data_size;
> > +	else
> > +		copy_bytes =3D data_size - ZYNQMP_AES_GCM_SIZE;
> > +
> > +	blkcipher_walk_init(&walk, dst, src, copy_bytes);
> > +	err =3D blkcipher_walk_virt(desc, &walk);
> > +
> > +	while ((nbytes =3D walk.nbytes)) {
> > +		memcpy(walk.dst.virt.addr, kbuf + dst_data, nbytes);
> > +		dst_data =3D dst_data + nbytes;
> > +		nbytes &=3D (ZYNQMP_AES_BLOCKSIZE - 1);
> > +		err =3D blkcipher_walk_done(desc, &walk, nbytes);
> > +	}
> > +END:
> > +	memset(kbuf, 0, dma_size);
> > +	memset(abuf, 0, sizeof(struct zynqmp_aes_data));
> > +	dma_free_coherent(dd->dev, dma_size, kbuf, dma_addr);
> > +	dma_free_coherent(dd->dev, sizeof(struct zynqmp_aes_data),
> > +			  abuf, dma_addr_buf);
> > +	return err;
> > +}
> > +
> > +static int zynqmp_aes_decrypt(struct blkcipher_desc *desc,
> > +			      struct scatterlist *dst,
> > +			      struct scatterlist *src,
> > +			      unsigned int nbytes)
> > +{
> > +	return zynqmp_aes_xcrypt(desc, dst, src, nbytes,
> > +ZYNQMP_AES_DECRYPT); }
> > +
> > +static int zynqmp_aes_encrypt(struct blkcipher_desc *desc,
> > +			      struct scatterlist *dst,
> > +			      struct scatterlist *src,
> > +			      unsigned int nbytes)
> > +{
> > +	return zynqmp_aes_xcrypt(desc, dst, src, nbytes,
> > +ZYNQMP_AES_ENCRYPT); }
> > +
> > +static struct crypto_alg zynqmp_alg =3D {
> > +	.cra_name		=3D	"xilinx-zynqmp-aes",
> > +	.cra_driver_name	=3D	"zynqmp-aes-gcm",
> > +	.cra_priority		=3D	400,
> > +	.cra_flags		=3D	CRYPTO_ALG_TYPE_BLKCIPHER |
> > +					CRYPTO_ALG_KERN_DRIVER_ONLY,
> > +	.cra_blocksize		=3D	ZYNQMP_AES_BLOCKSIZE,
> > +	.cra_ctxsize		=3D	sizeof(struct zynqmp_aes_op),
> > +	.cra_alignmask		=3D	15,
> > +	.cra_type		=3D	&crypto_blkcipher_type,
> > +	.cra_module		=3D	THIS_MODULE,
> > +	.cra_u			=3D	{
> > +	.blkcipher	=3D	{
> > +			.min_keysize	=3D	0,
>=20
> Are you sure to accept this a keysize of 0 ?
>=20

Will correct in next version=20

Regards
kalyani
> Regards
