Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E8630F679
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 16:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237427AbhBDPgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 10:36:33 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18550 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237359AbhBDPer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 10:34:47 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 114FV6D4026925;
        Thu, 4 Feb 2021 07:33:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=uYz/SPBtPTWcFzDu5z5uLY6in5uf6BMoEHihrlsvd88=;
 b=aAxa380i9yxrymvq3Ma1kG9sD8joGYhWDR2bMEDDKRkvRclwdDDpPySWzgwXiXWUknCf
 eFB9qa/XWFL4+hJQzFxHC2mV03IARra3uheTw0vlXCk8onAe3dzMIroxKuHKGWafJIdG
 eFG3t3mz8TkxQkopYGR8FVnIdeRlvBaILMsQivpaYBodB0kJw9viCv3IAVKgv83t9hkK
 SgWFH5F/VJMzpOIWT4htWtB74je5mi1lm/mIauHFEvQZQd0fsQ5Wr8IzF2thA4wBTwXA
 jjjDBk/7MKHtxjsWdkFUafxkN3F+qvZnV17S544X0ZFTqSb/+pqvd/kqO1508ZSYaQvl 9Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36gg1t0sc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 04 Feb 2021 07:33:53 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 4 Feb
 2021 07:33:52 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 4 Feb
 2021 07:33:51 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 4 Feb 2021 07:33:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f7qknfbP3TJxxa/N3Rw/2o2S2pgWWrJTuYUwSzPn2wHzFwTwebwOXIYJcBB4Ba1evX5rVKeEo0zzlqH7GIdf8RgdGxqHeYduvGKb8l44neA36BvNZaYpkv59gvR7iajdMKMP2UZQvg+NRrHIXRXb2fbBJkdLMMPoKNtoOx8j5besVzvmoZvIIzRJWOLFySnCdYAyGpHwoX3JAkbNifk8s6MBWVBy3RV9YI+5aBBWua4V9etUVe8AdD634Adn9oj7m4l6qPyQIcpspRP5n3tM+4wd8Fr/PoaKDe1qhYsrwIp0jwRNNyPti5XwxLRBme4U48uDkgkJuEPPmRVMAfHn8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uYz/SPBtPTWcFzDu5z5uLY6in5uf6BMoEHihrlsvd88=;
 b=aA8pB0s9ASfkiVBd9KJA8APqvmbHoz4GBM2vNGdIeoDwGjXfTcR9YkTGoXCEXwdtLwPnxoYK38todNRMzaz3Q+7pF4IkDKB+mB6/mVx1s0QMICDlxvokPQ2vaaYSmGM/KSJ9YQ7pAy2P3cSolipOwHxEMQO9AC6u8s+fDBJBgD57WfT9th3hnehxRQ7kxfOl+W7Sa4WMB1gp+DNPYyKEB4Zm6CQ5qVFO/SdgOti7swTPOLqMH/zQrHkPuaJqLPxvDZLk28sJDRSIUHk0ta7tUgxG4VDl+GkufZugCKJ6FYlsMq3w4nkR25IZMD4vh3QFp0wDEOdiaaYvvmJW62hE2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uYz/SPBtPTWcFzDu5z5uLY6in5uf6BMoEHihrlsvd88=;
 b=IAac2M6IA1FK21uBWY+YxgyNCTBelvsAcJYHFACgGaHuHhynkiZvmxx1ikgUpJ7KRBGuD+5mpztRC6bmTt2j/TEYv6ngrv0pVcXz/wmDs69lhYIh4sSt4D78NSdxBFqLdhmMBs0bILLlqi/WrJpfG6v0hHhPWioswLwwS6+QS1o=
Received: from MWHPR18MB1421.namprd18.prod.outlook.com (2603:10b6:320:2a::23)
 by MWHPR18MB0926.namprd18.prod.outlook.com (2603:10b6:300:9b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.23; Thu, 4 Feb
 2021 15:33:48 +0000
Received: from MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d]) by MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d%4]) with mapi id 15.20.3825.020; Thu, 4 Feb 2021
 15:33:48 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        "Geethasowjanya Akula" <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [Patch v3 net-next 3/7] octeontx2-pf: ethtool fec mode support
Thread-Topic: [Patch v3 net-next 3/7] octeontx2-pf: ethtool fec mode support
Thread-Index: Adb6+wOmcyYaYYOEQTO7EJhiRx3HZg==
Date:   Thu, 4 Feb 2021 15:33:48 +0000
Message-ID: <MWHPR18MB14214E66C51B1B25725BBF0DDEB39@MWHPR18MB1421.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [117.206.234.190]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac3841b6-48d9-429e-c157-08d8c9224478
x-ms-traffictypediagnostic: MWHPR18MB0926:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB0926726B902721FDD57B6175DEB39@MWHPR18MB0926.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yuhVWPqaxcuPOzS6aMuvZ0MklieC421tHHJNYIauQcm1Hw/hjFkdUoZesTOFiRBCBAX20IR+7WtEv206A8mt+DsdjlBjyDQ1/vlLdn2y2/A8oN/2WilHPzuVV3lEMB8ET2uGgzsZTf8yytuH9oOSmaWGibBJyL9mIiQmox5ii/UvozWvrHf/78d6UGXykU1kGK4dQZVRQy1oZLXt+YIwkL2zNhD07NySzhAo2ZdAtJu087nHFqpVtoCphMLiJbQXsdTkfzTQFqzfdzddggbHGy/MypKUCtRzbwW28a/MB0wgAkHucyJIl+/d1HMDPVbfZAvEF94FaMYCrai7bCnSjZSQ9vd1f00PXEkR+BwD4dCdHHSZ7iZmKwXJ5BXTw5iwV6N1YcyV6TcLfZc15oNJgeU3IjY8XyaIm/Zu8HBxeuQkpTJEKDJYQhsQiHC+DgjoIozD73RwA2twhGI2fKcpSMMQuQDTMm5i7GIo0bGXJ/RoBu4xU+pIfiYgQ7drhec8Zrtv2682fGMkx5M3nKLouA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR18MB1421.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(33656002)(2906002)(107886003)(71200400001)(26005)(186003)(478600001)(76116006)(8676002)(66556008)(8936002)(66476007)(66946007)(66446008)(64756008)(52536014)(53546011)(6506007)(9686003)(7696005)(5660300002)(6916009)(55016002)(83380400001)(316002)(86362001)(4326008)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?EW7HveP+wsqSeafDNSD7CcZR5MNSM2tp4tjmYI7KV/iYIOsSTDiFIXftSubO?=
 =?us-ascii?Q?pcn+jvI9b7jYrc4k6ueJPQykfVDd2kBNlTwTJMdjb8I+ePGcrAHTcDOA/3LW?=
 =?us-ascii?Q?qn/UGMiUDH9OKoD1bpFu8dr83Dnbk7kuU+1ycszGAYfyJAeTTZYI7ttQEyq8?=
 =?us-ascii?Q?9i2I2+2HcP+TVcpEFJQ4ye/G/r897361JdDe+MXxeCRK716Ra5URpbA/v3DZ?=
 =?us-ascii?Q?3UcPhyylic/8RDScPd5DADGNQm6w1kJ1/jXptN1A+liM27csgtsqlOc5fPKq?=
 =?us-ascii?Q?J2r40k+Y++bBq7rzenPaf8gwsZfoUppS+xXLbNrH4AV2xoinhWi1spbpFkJd?=
 =?us-ascii?Q?JgOJkMq5Qc8oG9OCecwMAKxCoHeO8VJwD01Wpj8QoK7gBww7RW9XxhDReuaJ?=
 =?us-ascii?Q?EecfbGUT7seTlWy6gui5VVSI1npsMDTudofWfS8eLp5NRDIX9uzz7jcniGwy?=
 =?us-ascii?Q?Ar7NUdJ8EDPgpxG9WNSE5df/ZiFgWhJeXNCDHbvdTrbVRkOQzG0+UvMW2Dhj?=
 =?us-ascii?Q?UUPB4pVBx7Xyjazex6yB5keIqbqTTpmNFx4DEGuMpo2ZD8+hDA+MTdxEUY/4?=
 =?us-ascii?Q?qbSuAwoBZ01hbMLYyxtPdMsTGJuuwDkCMOvcw39WDI8EVmi6ECJ0M1FhZOqw?=
 =?us-ascii?Q?BMkh/34TIhqB5j1Dw2jHP+D6S4Y6gxpxnfME0PU+exJbBMXiHsJfJ4QKZQT4?=
 =?us-ascii?Q?or/zxy7/sSUo5OcZOHLGg9Vs5mw+7rmMmIMEa2/ooxU0H90+7kiht4M1v8ei?=
 =?us-ascii?Q?F7/ot2P3TfErRq8MpE5q/Ve1fHViRweBwqzlc4WyiNsnYOOF8/kHH4PcO10+?=
 =?us-ascii?Q?Laa9+yMJsRPAiumc+WbPLVZPTe+rxckEqjNHrFGer2NBGbrHjvHdUqOps+fL?=
 =?us-ascii?Q?Hkh2qAdMZk12XwZPkW6PD4+6FSw8Fe/kvOHt4ycFhbPmjEIsnVOblueDunC/?=
 =?us-ascii?Q?2Vaq41zy8qelZg2JSRSPePUy1/5WID8PtWG2ws/oBHF99lF0Iv5EcETcD+0k?=
 =?us-ascii?Q?NKsC6vdK9cP8KPXLIx6nn6/qwRo4cb9FxqNL4zf+vc0QSfUUXpRduW2iIbcG?=
 =?us-ascii?Q?gBOn1SYXTL7JK2Z04hjYZaLpJ7xoVMovRDD8ycTyJju1vHYatOu/3Fae1t7N?=
 =?us-ascii?Q?O5wrMbP1eqf2az73nZZGyxW+eh0X8juptm36Cd9qEju9Hrnkh1ILBk2uwWEq?=
 =?us-ascii?Q?snsgAM1JAHgWIpu/tVTO1ywb4+xilYhTdFhHz3RDp/fiN6H06UC2kZSN+sR7?=
 =?us-ascii?Q?DufYdDj4sw1zNvVfyw0WUi9NKBCoZN6Z/73mw7rP3y+luup/FipWYJSPKvTD?=
 =?us-ascii?Q?DHjLE3QuTd745IOH/GIZsQGp?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR18MB1421.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac3841b6-48d9-429e-c157-08d8c9224478
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 15:33:48.5451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w6/5BrrX6EEnFooTWR7KOhYC0sfml4Z6tWUOFUN/taNPOwouvuBv2NnO/yIKjDFoNgmp4SLfHYT22VepsIlSHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB0926
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-04_08:2021-02-04,2021-02-04 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, February 3, 2021 6:42 AM
> To: Hariprasad Kelam <hkelam@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> davem@davemloft.net; willemdebruijn.kernel@gmail.com;
> andrew@lunn.ch; Sunil Kovvuri Goutham <sgoutham@marvell.com>; Linu
> Cherian <lcherian@marvell.com>; Geethasowjanya Akula
> <gakula@marvell.com>; Jerin Jacob Kollanukkaran <jerinj@marvell.com>;
> Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
> Subject: [EXT] Re: [Patch v3 net-next 3/7] octeontx2-pf: ethtool fec mode
> support
>=20
> On Mon, 1 Feb 2021 10:54:40 +0530 Hariprasad Kelam wrote:
> > From: Christina Jacob <cjacob@marvell.com>
> >
> > Add ethtool support to configure fec modes baser/rs and support to
> > fecth FEC stats from CGX as well PHY.
> >
> > Configure fec mode
> > 	- ethtool --set-fec eth0 encoding rs/baser/off/auto Query fec mode
> > 	- ethtool --show-fec eth0
>=20
> > +	if (pfvf->linfo.fec) {
> > +		sprintf(data, "Fec Corrected Errors: ");
> > +		data +=3D ETH_GSTRING_LEN;
> > +		sprintf(data, "Fec Uncorrected Errors: ");
> > +		data +=3D ETH_GSTRING_LEN;
>=20
> Once again, you can't dynamically hide stats. ethtool makes 3 separate
> system calls - to get the number of stats, get the names, and get the val=
ues. If
> someone changes the FEC config in between those user space dumping stats
> will get confused.
>=20
Agreed. Will fix this in next version.
> > +	}
> >  }
>=20
> > +static int otx2_get_fecparam(struct net_device *netdev,
> > +			     struct ethtool_fecparam *fecparam) {
> > +	struct otx2_nic *pfvf =3D netdev_priv(netdev);
> > +	struct cgx_fw_data *rsp;
> > +	const int fec[] =3D {
> > +		ETHTOOL_FEC_OFF,
> > +		ETHTOOL_FEC_BASER,
> > +		ETHTOOL_FEC_RS,
> > +		ETHTOOL_FEC_BASER | ETHTOOL_FEC_RS}; #define
> FEC_MAX_INDEX 3
> > +	if (pfvf->linfo.fec < FEC_MAX_INDEX)
>=20
> This should be <
Agreed . Current code miss the "ETHTOOL_FEC_BASER | ETHTOOL_FEC_RS" conditi=
on,  will fix this in next version.
>=20
> > +		fecparam->active_fec =3D fec[pfvf->linfo.fec];
>=20
>=20
> > +	rsp =3D otx2_get_fwdata(pfvf);
> > +	if (IS_ERR(rsp))
> > +		return PTR_ERR(rsp);
> > +
> > +	if (rsp->fwdata.supported_fec <=3D FEC_MAX_INDEX) {
> > +		if (!rsp->fwdata.supported_fec)
> > +			fecparam->fec =3D ETHTOOL_FEC_NONE;
> > +		else
> > +			fecparam->fec =3D fec[rsp->fwdata.supported_fec];
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int otx2_set_fecparam(struct net_device *netdev,
> > +			     struct ethtool_fecparam *fecparam) {
> > +	struct otx2_nic *pfvf =3D netdev_priv(netdev);
> > +	struct mbox *mbox =3D &pfvf->mbox;
> > +	struct fec_mode *req, *rsp;
> > +	int err =3D 0, fec =3D 0;
> > +
> > +	switch (fecparam->fec) {
> > +	/* Firmware does not support AUTO mode consider it as FEC_NONE
> */
> > +	case ETHTOOL_FEC_OFF:
> > +	case ETHTOOL_FEC_AUTO:
> > +	case ETHTOOL_FEC_NONE:
>=20
> I _think_ NONE is for drivers to report that they don't support FEC setti=
ngs.
> It's an output only parameter. On input OFF should be used.
>=20
Thanks for pointing this.  Cross checked code also  _NONE is output is only=
 parameter.
Will fix in next version.

> > +		fec =3D OTX2_FEC_NONE;
> > +		break;
> > +	case ETHTOOL_FEC_RS:
> > +		fec =3D OTX2_FEC_RS;
> > +		break;
> > +	case ETHTOOL_FEC_BASER:
> > +		fec =3D OTX2_FEC_BASER;
> > +		break;
> > +	default:
> > +		netdev_warn(pfvf->netdev, "Unsupported FEC mode: %d",
> > +			    fecparam->fec);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (fec =3D=3D pfvf->linfo.fec)
> > +		return 0;
> > +
> > +	mutex_lock(&mbox->lock);
> > +	req =3D otx2_mbox_alloc_msg_cgx_set_fec_param(&pfvf->mbox);
> > +	if (!req) {
> > +		err =3D -ENOMEM;
> > +		goto end;
> > +	}
> > +	req->fec =3D fec;
> > +	err =3D otx2_sync_mbox_msg(&pfvf->mbox);
> > +	if (err)
> > +		goto end;
> > +
> > +	rsp =3D (struct fec_mode *)otx2_mbox_get_rsp(&pfvf->mbox.mbox,
> > +						   0, &req->hdr);
> > +	if (rsp->fec >=3D 0) {
> > +		pfvf->linfo.fec =3D rsp->fec;
> > +		/* clear stale counters */
> > +		pfvf->hw.cgx_fec_corr_blks =3D 0;
> > +		pfvf->hw.cgx_fec_uncorr_blks =3D 0;
>=20
> Stats are supposed to be cumulative. Don't reset the stats just because
> someone changed the FEC mode. You can miss errors this way.
>
Thanks for pointing this. Will fix in next version.

Thanks,
Hariprasad k=20
> > +	} else {
> > +		err =3D rsp->fec;
> > +	}
