Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915A5309393
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhA3JmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:42:07 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31624 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231535AbhA3Jlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 04:41:40 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10U9Ulbb009215;
        Sat, 30 Jan 2021 01:40:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=7GVYtryZZbnHuIc0EzNVao41Cl0qVV2o+wdwwL2LeSE=;
 b=LVQYndrg8gHbCEhUrNk4SB3hB7Ks5W2i4WNm4r+bVj4jaPM5ejq4jGv01ohVfZ//oStl
 Cil4ENcM8czMG2jW9JeG/RXUpwPPkicFXSlkCh9G6toYeo1xI/YRzfBvbCG2JzjGvuvw
 T7y98sgPH1THLjvioLBNiG1jh+RlC9QwykpWxtFu2+Xv22azwnChQGPn+S5tr8tyVZdo
 3e+RdyB7KxoRWpxtgvvKCGKfPB/j8Q6nvUE7NaG6qxf6/bVlR5y8W+V0CNp5asdXE+El
 AknRANdRzCEyjQMPlf8+7YCYgFCyjnvLtDslVPecpDUEFNHzlMEIUJpa0PTXBtQ/DRCp dA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36d0kd8bdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 30 Jan 2021 01:40:48 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 30 Jan
 2021 01:40:46 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 30 Jan
 2021 01:40:45 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 30 Jan 2021 01:40:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WAMeNIy9muU2hwcjR+iZzN03BseuKm++yWD9CdUV/ROBwCWrJ5vjNJFBrKwcbdTS7iO7K/6Gw9l0GczHwr3c9MBntQfKdszaENr7IOoaoTGlH003+a1pKfIMXj/U3dz+U90YHLVGh01crTWNfnwFs/W7jXzB9nTQOLZh9kyu0gFENLBsA1OsEeSWJqk1kC/v6nPSm7SdbK1DWM9IU4ywaT0NzV4BpiYPmOrVbiQePcHIrVBCy/gg1jy/oOseHZ962D8lwj9PfUaA2pnX2+xpasewbbFr5ofrgPD5hSMzeTRNeX2IpJsrr0g7DitBpOCbIpc+xHnKMoLuTYAbVfyG1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7GVYtryZZbnHuIc0EzNVao41Cl0qVV2o+wdwwL2LeSE=;
 b=DYgX2pJ7lz+yqWLTyph7sPqDPNEq3V6+vmgSuh9sv7x7KaP5KGm9K9QnM60wM8JEJMBXQB3F8w3uSErs0fJQAFuhD5KxQJGUekoSNI0OM4t+T5oA1xejr0nZE5++MspZy95qotfUOyRJO3ALyheK/9IHJARCV6mLVP9qZ4V5FitETh26xSxnBxpsjYSctI5NsERXIhC9+h4QjH0zMqOMPZgSthqGDfE/fAxTHUt/xRxsuNjFhSIKbmzwwMlHEWDCGkbcSf/S/6DEtJskTdsVbemr/O5przv7egUNjkA1rrLth3Fn50SauOkmn5vBsI2cnLbT693TA1OHJir2suVG0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7GVYtryZZbnHuIc0EzNVao41Cl0qVV2o+wdwwL2LeSE=;
 b=qM6AWnX7inXMY7qpyjLiSFn+7cKgE9zxa1VBnRi1GmN/M8DKGRKtf8RG0Vp7RixxqK3J4rUhVPcgBw7/PrBucVMCh+fMSv3qgPVm4e2/Thh5/uxsqyptHAH6RG5G6jJtp33PwCli549bjIvtu19AumDONikp26f+wweLTmKc+BM=
Received: from MWHPR18MB1421.namprd18.prod.outlook.com (2603:10b6:320:2a::23)
 by MW3PR18MB3481.namprd18.prod.outlook.com (2603:10b6:303:2d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Sat, 30 Jan
 2021 09:40:44 +0000
Received: from MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d]) by MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d%4]) with mapi id 15.20.3805.022; Sat, 30 Jan 2021
 09:40:44 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "Jerin Jacob Kollanukkaran" <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Christina Jacob <cjacob@marvell.com>
Subject: Re: [Patch v2 net-next 6/7] octeontx2-pf: ethtool physical link
 status
Thread-Topic: [Patch v2 net-next 6/7] octeontx2-pf: ethtool physical link
 status
Thread-Index: Adb269l7LjbI8P6xQz2Bvje8CMQYyg==
Date:   Sat, 30 Jan 2021 09:40:43 +0000
Message-ID: <MWHPR18MB1421B53E6EEAC6102D70083FDEB89@MWHPR18MB1421.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [117.201.216.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b16bbca0-ed5a-48df-cf55-08d8c5031d4c
x-ms-traffictypediagnostic: MW3PR18MB3481:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR18MB3481F0EE8BF8A7D2FC8BC82DDEB89@MW3PR18MB3481.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rEKYpnMixl6C6PlQOyeTKwOntkhf1V49MMDV977M4qypXHl8uXdvhZ5VwF/NpAntrCKepbDzcmB6eqsLR2ejI7rRa6ivFmZ5XUpuFfdogBTKgQE0eOHHK/2hLy1H8x0BHwiPNJKC8QFAoMCYa/qkszr4tYrGhTcc40eo0m2eBCqmx5qpwD4Hjtou5lkduRNg3vkArvQy5d0wvQpuQsylef9+t6G3vkpasoJqKTTMvQKnn90oAuPlB4Y97eWqk6AhH2qkYBpmhIGQDifCnLr61tByQAF0DHFj+kGmR3D02Qihwr140LLTHaxxAlgA9eXWb2ekPF8aG0zBvuI6UGbJazg8ZPIdK5GxV7ETt8gQKrxrxnbMurgwrl2Q+wqx+x44nfuRpM0wVI0umjqC4Lt+wFv0J2E+VNkw6GyK2Yedf4aFsgLeDiXajdvpCUvon2s4lbv212bjg01e024BXSiWk7ncwJ8Ju/MOUbcQ1KnO+NYCcfltels38g78eETpNnit0RTXVlm6bW2MdlCjb2+uDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR18MB1421.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(366004)(376002)(136003)(33656002)(52536014)(26005)(71200400001)(8936002)(86362001)(478600001)(6916009)(53546011)(6506007)(5660300002)(66476007)(66556008)(4326008)(55016002)(9686003)(66446008)(64756008)(54906003)(76116006)(66946007)(2906002)(316002)(186003)(83380400001)(55236004)(8676002)(107886003)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?dQgGThgnRtenBzmucPnllmNcePsOH1OAiePAawCJwulHykiWkuiYvxTpv3wZ?=
 =?us-ascii?Q?EYOnxkaWyVmFlnKrXlCpqGk9E0DGyC07bWdo4c+BRC1lct9pskAdEmYe68X5?=
 =?us-ascii?Q?G2lkeApc4MhrOqPnEypTNvE6rNOnkZQG+4YLImc6vZkL6ti51njFO5ldvfSz?=
 =?us-ascii?Q?zyzTojTWwJyAbzDbGi3VnshHbGEDO53VoYLoh7yrizdogQHQwofAYheyIc9p?=
 =?us-ascii?Q?TUuc1TpcaeSIyxgwX4xt4oGNi7sUnA/7SiK7ff0tFE46g2eqD3Ze9VD+mfHI?=
 =?us-ascii?Q?HteK+0XtC+fZC0Plphj5b/cbVO3V9OEdUpAvrxcd+CB5a/fxkim1MfEnZ+ah?=
 =?us-ascii?Q?RgGN1ZBa3WUkn4qFm9XHKDD75r+dfIRpuEASfTXmyvIhP0WYCgUmnW2m5YL4?=
 =?us-ascii?Q?7nhqI256bmESQY1olS+9H570kXZSLfWGX2A7W0tPkSzWvNmPNgbI9l2hgW4H?=
 =?us-ascii?Q?WWoSr8pmrYqFpGiNX1n8556f44Weqch4w11vdLxZZ6ZbTRQc1Kn+oT4678Yn?=
 =?us-ascii?Q?R+xSfJQPuq6yblwOdfcTi/QBvBR/uN4KyRQWC5RTK+TPOacnUdgk5GJejOcq?=
 =?us-ascii?Q?nK0L1L02hrjDQRdzPQ42vIWtQcQThA+aDj5/kc4vSDL+RGrw4t4uqS+rfAGt?=
 =?us-ascii?Q?e1/LneoY3SywtUL+IObpf6j6AspJ1gqIKS1vyV9xe22U1eov48IQF4SCU10F?=
 =?us-ascii?Q?I6cIkfrsLRO619J6nXSASG1hSu3Hr5+CerKHziph8ArRnbtHwMGJzI/+sCNZ?=
 =?us-ascii?Q?KQ9weQw6hv2HfQHM8E4wFhFmmwL8hv0nxnJOLn3sUYliDpYxX36VmXyXulpZ?=
 =?us-ascii?Q?3KGcQAoQqP6Aoz4SGlbwlswcDjJQi2GObg5IUDNu+Tyv9bKexrzLBCRZXNaD?=
 =?us-ascii?Q?CCr7DgzBaQq9rDZ/vgNkIdWYelyJcY5ki6WPVw4knULEQuXlGTIUmE/pgiMq?=
 =?us-ascii?Q?UvVQ9/a7CXc+GcuQna1s2ZoY9wUdCRwigU+qYP0q2NE2gafT3fNFSzGtsNoo?=
 =?us-ascii?Q?LqLg5xsP1Z/gwj7BMjEa6THs18WqSEvSAXKdlABwX3fwlpX0qBRxQMxI6jtu?=
 =?us-ascii?Q?uB8dXRId?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR18MB1421.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b16bbca0-ed5a-48df-cf55-08d8c5031d4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2021 09:40:43.7763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +5Bx/ww/Us3oDrMc07AdHgu0w07pUpk4GGm+RIczH4RLy4YdqVpB9z1h5TlmMxXUuIZ4sp32gMh42ZOTS59wyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3481
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-30_06:2021-01-29,2021-01-30 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew Lunn,


> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Wednesday, January 27, 2021 7:22 PM
> To: Hariprasad Kelam <hkelam@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> davem@davemloft.net; kuba@kernel.org; Sunil Kovvuri Goutham
> <sgoutham@marvell.com>; Linu Cherian <lcherian@marvell.com>;
> Geethasowjanya Akula <gakula@marvell.com>; Jerin Jacob Kollanukkaran
> <jerinj@marvell.com>; Subbaraya Sundeep Bhatta <sbhatta@marvell.com>;
> Christina Jacob <cjacob@marvell.com>
> Subject: [EXT] Re: [Patch v2 net-next 6/7] octeontx2-pf: ethtool physical=
 link
> status
>=20
> > +static void otx2_get_link_mode_info(u64 index, int mode,
> > +				    struct ethtool_link_ksettings
> > +				    *link_ksettings)
> > +{
> > +	u64 ethtool_link_mode =3D 0;
> > +	int bit_position =3D 0;
> > +	u64 link_modes =3D 0;
> > +
> > +	/* CGX link modes to Ethtool link mode mapping */
> > +	const int cgx_link_mode[29] =3D {0, /* SGMII  Mode */
> > +		ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
> > +		ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
> > +		ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
> > +		ETHTOOL_LINK_MODE_10000baseLR_Full_BIT,
> > +		ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
> > +		OTX2_RESERVED_ETHTOOL_LINK_MODE,
> > +		ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
> > +		OTX2_RESERVED_ETHTOOL_LINK_MODE,
> > +		OTX2_RESERVED_ETHTOOL_LINK_MODE,
> > +		ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
> > +		ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
> > +		ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
> > +		ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
> > +		ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
> > +		ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
> > +		OTX2_RESERVED_ETHTOOL_LINK_MODE,
> > +		ETHTOOL_LINK_MODE_50000baseSR_Full_BIT,
> > +		OTX2_RESERVED_ETHTOOL_LINK_MODE,
> > +		ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
> > +		ETHTOOL_LINK_MODE_50000baseCR_Full_BIT,
> > +		ETHTOOL_LINK_MODE_50000baseKR_Full_BIT,
> > +		OTX2_RESERVED_ETHTOOL_LINK_MODE,
> > +		ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
> > +		ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT,
> > +		ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
> > +		ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT
> > +	};
> > +
> > +	link_modes =3D index & OTX2_ETHTOOL_SUPPORTED_MODES;
> > +
> > +	for (bit_position =3D 0; link_modes; bit_position++, link_modes >>=3D=
 1) {
> > +		if (!(link_modes & 1))
> > +			continue;
> > +
> > +		if (bit_position =3D=3D  0)
> > +			ethtool_link_mode =3D 0x3F;
> > +
> > +		if (cgx_link_mode[bit_position])
> > +			ethtool_link_mode |=3D 1ULL <<
> cgx_link_mode[bit_position];
> > +
> > +		if (mode)
> > +			*link_ksettings->link_modes.advertising |=3D
> > +							ethtool_link_mode;
> > +		else
> > +			*link_ksettings->link_modes.supported |=3D
> > +							ethtool_link_mode;
>=20
> You should not be derefererncing these bitmask like this. Use the helpers=
,
> ethtool_link_ksettings_add_link_mode(). You cannot assume these a ULL,
> they are not.
>=20
> Please review all the patches. There are too many levels of obfustication=
 for
> me to easily follow the code, bit it looks like you have other bitwise
> operations which might be operating on kernel bitmaps, and you are not
> using the helpers.
>

I will fix this in next version.
=20
>=20
> > +	}
> > +}
> > +
> > +static int otx2_get_link_ksettings(struct net_device *netdev,
> > +				   struct ethtool_link_ksettings *cmd) {
> > +	struct otx2_nic *pfvf =3D netdev_priv(netdev);
> > +	struct cgx_fw_data *rsp =3D NULL;
> > +	u32 supported =3D 0;
> > +
> > +	cmd->base.duplex  =3D pfvf->linfo.full_duplex;
> > +	cmd->base.speed   =3D pfvf->linfo.speed;
> > +	cmd->base.autoneg =3D pfvf->linfo.an;
> > +
> > +	rsp =3D otx2_get_fwdata(pfvf);
> > +	if (IS_ERR(rsp))
> > +		return PTR_ERR(rsp);
> > +
> > +	if (rsp->fwdata.supported_an)
> > +		supported |=3D SUPPORTED_Autoneg;
> > +	ethtool_convert_legacy_u32_to_link_mode(cmd-
> >link_modes.supported,
> > +						supported);
>=20
> Why use the legacy stuff when you can directly set the bit using the help=
ers.
> Don't the word legacy actually suggest you should not be using it in new
> code?
>=20
> 	Andrew

Agreed.  Will fix this in next version.

Thanks,
Hariprasad k
