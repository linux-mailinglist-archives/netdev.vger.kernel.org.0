Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1636318BFA
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 14:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhBKN0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 08:26:00 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31014 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231263AbhBKNXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 08:23:41 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11BDL1mv024341;
        Thu, 11 Feb 2021 05:22:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=2HyTsUGCmFfltqOPVq8tEFJxc+3vZDtCgoq9k+A1q5Y=;
 b=ATsnasUSO1QFqwVU1hPQZvmXGD0dpTJwm0lKoh9+XGXNjc9ZtBqRrJLKDEkHp5e/YhN8
 CEV32UpqizFkyHGlTU6av1DckDBJ21w3a5dOyNiql2URxv5bTYNjDIqqhr9ZSS2KVuzj
 ZtF1fAXUGxTFNdLI20l6sRjpmWW0osQBE1PwfrYQ5DbjgxMKTiouHpgfE0TZMXJCIG9M
 0UHrcd7njsEI+Ik7wmZQYmYIU103WJyZGKPm1f0EAqiAacAP7OJ15NrF4Cx/miYztsxm
 YjqXlKsYJlFP18Rnf4YgbsjCn6pZ5jjiLT6tNovZ7HDmO+oRf/mGBEIiKK+VlbRXGL5a jw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrq3aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 05:22:39 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 05:22:37 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 11 Feb 2021 05:22:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=glc6mZS7FAuICk2B4HuvwQDGG/g6WA916FAxsHuNJrDIuw8N45O3dmIOluBZEGWuO+jDAf7fBaNlAqYBzL4YSuNJBSb7cqk38F/YUxQSVCbrVXqlhjdb7khZwFN7UAMDWTug+J7/vFubUauhYV2bhsRYpJWObolUmNudLfwDLRNHxSlbkix7fv62yJLGpAH0wJZoLG5GQ9ZtBNjG7x1+bIAwPasOBpspdqDqfEsrud3eutopV/O+827m8OHH+nTMTetNJduCZ/p7znZrjSrIOfIyQE09nggdTYtQCE7nHwKnY8O1rlyRynUi15L8+y+Em44CiHzehaIMUM65GuU3/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2HyTsUGCmFfltqOPVq8tEFJxc+3vZDtCgoq9k+A1q5Y=;
 b=mJ9W8AiHp76iMA6er4tO+lM6r0OO7tvrGPk3HZX+1ibVM+bE7ncV9H5t83rA8MAxng948NX0q3K5E/4qMkNGodkYeEaDVlmZkGWySC8GLJu204K8t4JuCqu3/R/WF6s2jmog4S/TaXZGfHOne5C9N8Jpp1XHp10ZuwYJ+FqQ0xVwaLfM+UXMNEKK42Q/qv5uihvboAyizWZVxsz76kASCjx4GxLiGg4vR/XYyNfMpgI8eCHd6iw03a5c5SZTDU5jwm4gOWNPWJtdVvzrl8DbH3pPy1iB+miXIXfcD9NJEwLMFDrAsDQlCx5aFgsqfVwH1UMxcnk53RmBUwjgVc4z6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2HyTsUGCmFfltqOPVq8tEFJxc+3vZDtCgoq9k+A1q5Y=;
 b=n5zaaMcdmBbhrlRpiNADyrKyib4NbPSCHiHHAbUvaMpkjqmfZ0unu19LJXZR1hQCAT/O5QvjMJ6bUortgKYwQUX5IeQYlmScb/dEAxQ+h2nWzLSP1odI2MzHMpMrOtctbAo5Tw1/Bjihq+O/FENjevtJPe9OHU3Xq7PBLjJhg4E=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MW2PR18MB2188.namprd18.prod.outlook.com (2603:10b6:907:d::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Thu, 11 Feb
 2021 13:22:35 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3846.025; Thu, 11 Feb 2021
 13:22:35 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [EXT] Re: [PATCH v13 net-next 08/15] net: mvpp2: add FCA RXQ non
 occupied descriptor threshold
Thread-Topic: [EXT] Re: [PATCH v13 net-next 08/15] net: mvpp2: add FCA RXQ non
 occupied descriptor threshold
Thread-Index: AQHXAGQGVCHIIa4Rvk6qmqO01DA+oapS6BOAgAAGwfA=
Date:   Thu, 11 Feb 2021 13:22:35 +0000
Message-ID: <CO6PR18MB387356072132F306EBB1C9C2B08C9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
 <1613040542-16500-9-git-send-email-stefanc@marvell.com>
 <20210211125009.GF1463@shell.armlinux.org.uk>
In-Reply-To: <20210211125009.GF1463@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.25.16]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b67e9eaf-9371-4743-dda7-08d8ce901857
x-ms-traffictypediagnostic: MW2PR18MB2188:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB218897E21460A11F1482247BB08C9@MW2PR18MB2188.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hV45z+H7t+Lsw+gDskAH1iymAj4a/zGYmBF94f8SH9tlD3tZex7pSafwdyAfzurEEog7Qh6kK6EFVentNQUtTqaDsWoqjHf4PBbsCbYJLSeNG65VkdcRCAhwMW6OQvgbZC5AXGVINQM46g5kmh+rBW4wl/dRqhQFbfhO/aG+4Sitia/CCrGpxUICF9yxRRqobUBJl6yJEG03T1Wv93oi44iPiCWpyglbWK69ecYuDFwRHGef+vY+axLAepV6RNKd2aWCyjc5Qk2XBBGpzfMxLK62QFxK2WpMh1BpEd/jYspZjVHFKEW30y3sZczyFww3jFDBctzDILn8CiE7fHf6lvFk/KY4XMNQkgdZyZan9cg4LhcR6OstsEmLcqGaSBims2oB9E9msKQyrrYfaWTgWRn1dULtCOrHSRguxcH6KZfccQw0o0IYs1Bw4QCt/FyrPoskKDpaYwBpfFzARpxYac1Im5443myEDuclGZkzp4+JH4g93lKSQFnbG77CtQOErm+6Pi89FBc+/BfgSMF3jA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(86362001)(478600001)(26005)(5660300002)(7696005)(76116006)(186003)(9686003)(4744005)(8936002)(66946007)(6916009)(55016002)(316002)(4326008)(52536014)(71200400001)(8676002)(2906002)(6506007)(7416002)(64756008)(66476007)(66556008)(54906003)(33656002)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?NN6b0OdIDr/R6XHXGK12svWgm4FUsiTBGNBwBuZAoQc6NoTxISkEn8N8abwL?=
 =?us-ascii?Q?m2VaaOQRZHlUD3bxQxFbEw+HtdlS/b5G5Thl4yDef4RS2sjBFDZr9uc7SMAl?=
 =?us-ascii?Q?zBjQaleTXVHi62kvmYELg+iyYDVpKXNBqqS0306jXZt6nZ+JvaaotniCWlsW?=
 =?us-ascii?Q?JTH4ImQiV915ThPXbTJjGP2vufAAcwRnQcQxaCMbs22PhNh6aJylIjeEb4m9?=
 =?us-ascii?Q?dg4W8aeVhdDlHEvahl0JXKCrf/181jWrHjT/AnpvsyesmHSBhgtsgkT/Kwqt?=
 =?us-ascii?Q?GJUl8k2E0RY82WgKavStFax/rbjOs1H8r/B94zYZ43e22L3VjKoS086lwfSD?=
 =?us-ascii?Q?ZegS9FKhWvLwePQqWKvSJ71Mcr5aMAO62XFP+s5iWtYjviON4jr0Pwd3gnGK?=
 =?us-ascii?Q?EIlYJPNE8JHntLq/wwkGXPt7bWOgvHNvRDK3lfhmr+kg/QNpEXta1iq3ODDA?=
 =?us-ascii?Q?AGjy0qJuXp5nIZ91FfESgP/JHm2aaE+rRIDOgqq49TNhBHKOT2GjJe4IVQNO?=
 =?us-ascii?Q?JuriHsRCfC8AfP2L2h2OgzG3jvxYH0ByoCe846XVOIvpQUPt9H3CImFLtrSw?=
 =?us-ascii?Q?juSBXgWM3yh+kjkx72KH0fJzxX4oqljWbJGufPhFKMKPrt5AT27rumX6fJOM?=
 =?us-ascii?Q?GfK8xBJInh6N/xMRKv77PeXPOFhu3VO37B+gP6O1nMbVn3QR5aVTx4S5sWp7?=
 =?us-ascii?Q?101asDLfkyc+nO6vF/YztvS+6XA5bDwLbdkr8rqZN6PCd2TyWR0CyK+5lbXn?=
 =?us-ascii?Q?VVdZ8Jpua6zsqSg7AaIyX48jnV/kRE2Kh2pUIaCPsU/tlsCTQnIjci8Yh+qy?=
 =?us-ascii?Q?B/Gyz6aqk0q1sG28b/ASpy0djOMYsOPsZF9gotq4yRjlGwPCp/I5S4zz1yCF?=
 =?us-ascii?Q?TsrAWNCC/K0UxPXEZj2NGgH45ePtS623bTLFq5JNl+IeQ6NGLgtUXA+gHKnv?=
 =?us-ascii?Q?4HQg3MR2kJ4KSQnMdI/f7i2rRcQ45MFpkHbnBjso5SuMgiAwakcRkfT6fy7v?=
 =?us-ascii?Q?HAbHKHpN7CTzZNbjN5JMjuUGBfcv0/G6vhZnKiL6Tqj05vAmeS6pzuoaGDzs?=
 =?us-ascii?Q?rvqlmR3QBrIMaS93HoKMTQ8nHcJoAt23fvJ/em0NcGoF2e3FsroGAuQ3j5BX?=
 =?us-ascii?Q?tz0/bvjdh5zCrEMt1QHtiIoTC/IVDoFYGCRWKXAw7JLYifNR37VT2Ej90BRK?=
 =?us-ascii?Q?Mnsiealx+QCDrVpTGmkOKQIptRuVEA834A3LcRCxTCmF6ELuZ32Lvz0G5nVM?=
 =?us-ascii?Q?RcOancrX9/jCq0dFQcmppPPfhlDNTUpbiM+pyBaw/6JCo1qgzlVsc4WzPHLi?=
 =?us-ascii?Q?C9o=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b67e9eaf-9371-4743-dda7-08d8ce901857
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2021 13:22:35.0296
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tU4huem5sVdG4qLgBx0Z/UxGXeU9Oe7TRVKYVbxbAU1U1Nj/Qhi5n2yZJXshlJFQY94GTZdQcvUD2P1mS3nDHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2188
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_06:2021-02-10,2021-02-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Ditto.
>=20
> I don't think these need to be fixed in the net tree, but it would still =
be nice
> to fix the problem. Please do so, as an initial patch in your series - so=
 we can
> then backport if it turns out to eventually be necessary.
>=20
> Thanks.

My series already has 15 patches and patchwork not happy about series with =
over 15 patches.
Maybe I can send this as separate patch to net-next(or net) first and base =
this series on this net-next tree with this patch?

Regards,
Stefan.
