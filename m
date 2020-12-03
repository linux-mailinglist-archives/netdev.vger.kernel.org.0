Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41452CDF42
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 21:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgLCUCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 15:02:08 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31730 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726915AbgLCUCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 15:02:07 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B3K0v2r022501;
        Thu, 3 Dec 2020 12:01:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=1Nq5X+7nh3mtbdmXDyNuth3TtxVNXdckatSBE/32WBs=;
 b=ct+vrEw+STs+yF1+pChqMZupZ3GfLVPZQbyPiYuSFfW+WG7yIve9C7bbajgF6y1eKUp3
 gf5qS5kCyKSLl+7lZu9eE5rCfiTc+VOUYwdRwHcx3Fa1nECoYI6uulGsmengrqSOdyLC
 PhlyQOcx6dVTfeRSrKbi7asJHJe75ag5aXUZbKn6wtmJIt9g+q5Stw7zarMvWdCxetoy
 MD6/fKBrYys6nTTzJmwZD7Bj0AWFCWJXizA3mDN0nmtCZJrIVfPBy5hrTQH3hMDATe/x
 KBlM4u9nh0pdmwGcuPjUvHCMQP6A+ISC8O6CHGQ6PGtc3t00+ZybSm3aFFDPJ07p8+HB Bg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 355w50f3rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 12:01:18 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Dec
 2020 12:01:15 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 3 Dec 2020 12:01:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F50sbPhINlnHN7KB5ILE9sQuw0ELdWRoi6RHeOPSkSNZ/vP6Q+IWr3bCRIjTU2+h3O1Z8bNr6puudHuThxxvyAm/Ac1ZNdw/2Lnk7a0BDXXjFZmKW1x8mSIdC9DEijo+c1x4jakyWm/G1UYRCClAd9bcKpxQO55Q3BT3irRJQjzKCvDkf1YCSxDz5oUY4E8zi/uuY52L/HnaAUSkV/gDIbDn5Fgm6DYlBEWLnR6L5wBTkHh3HHGrmnVVIOMvDiD7SV78ot+s7a1WlSY6TDciBtugc4AFHgIgaf2uPtvhUxXSN0Tbp/ZTew1E9G0FvKVaXe/B/wrj4qi3O3ZYwqnbPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Nq5X+7nh3mtbdmXDyNuth3TtxVNXdckatSBE/32WBs=;
 b=jwCIrnu8+H5hTuTlA6TPM5VyB3Qm1oWtXtj+mt0RN1CoE/9jswqG+bl4i/Gn81J1K+GANHuVX1CYs+O5QMiJQdyVrz1kP/CmzWI1CnE2yDvT3BpgZEk4RYaKEIgBBE/W5mXP1eePK+ETclr0C3eD+DNihkm0H6ynpIWApD0BmxFJ5x8x2MHDL2gKv96WWEGGJmTwmvYckWAI5aMJU9TizOOKgXh3Ad+c+1WfVd79NUZPZswjbm7tHc4u1Bd11LPCrYZSJRLeybWoMQ/cD+sxWDxSHGP9XsQUDb34ph2bXcYuqJPme/hCBgbFYpY2bz19r7km7XgeRCPxmhxUlC+ibw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Nq5X+7nh3mtbdmXDyNuth3TtxVNXdckatSBE/32WBs=;
 b=Be9g9nBxFsbMX5xNbDKca//AkJXfwKgx5ZpSr+k/yxxGQsn7aTcKvgFo2n3k4URqxSDCyVYDW0mvXKU7jxL6/XM9PSp1gKLg81m2ZipWxfNDwnncG0sk3/4NFOdDFXbwjmFB/nARN5J8/Dzi4/8rMQJl9yfRV9WoErDt91mfYO8=
Received: from MWHPR18MB1598.namprd18.prod.outlook.com (2603:10b6:300:ce::21)
 by CO6PR18MB3955.namprd18.prod.outlook.com (2603:10b6:5:34e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Thu, 3 Dec
 2020 20:01:12 +0000
Received: from MWHPR18MB1598.namprd18.prod.outlook.com
 ([fe80::102b:6c9e:1bb4:7295]) by MWHPR18MB1598.namprd18.prod.outlook.com
 ([fe80::102b:6c9e:1bb4:7295%11]) with mapi id 15.20.3611.025; Thu, 3 Dec 2020
 20:01:12 +0000
From:   Mickey Rachamim <mickeyr@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>
Subject: RE: [EXT] Re: [PATCH] MAINTAINERS: Add entry for Marvell Prestera
 Ethernet Switch driver
Thread-Topic: [EXT] Re: [PATCH] MAINTAINERS: Add entry for Marvell Prestera
 Ethernet Switch driver
Thread-Index: AQHWyVwX9p+TCf2pwEWbloXbKFzXAKnlcGAAgAAPsCCAAATWgIAAJFYAgAAbmdA=
Date:   Thu, 3 Dec 2020 20:01:12 +0000
Message-ID: <MWHPR18MB1598B59FD5795EABEAF94D74BAF20@MWHPR18MB1598.namprd18.prod.outlook.com>
References: <20201203100436.25630-1-mickeyr@marvell.com>
        <20201203143530.GH2333853@lunn.ch>
        <MWHPR18MB15980930483CA2F0BB657E95BAF20@MWHPR18MB1598.namprd18.prod.outlook.com>
        <20201203154857.GQ2324545@lunn.ch>
 <20201203095900.1ae8b745@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201203095900.1ae8b745@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [93.173.69.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e10218e-afd5-41de-5ab7-08d897c62f4f
x-ms-traffictypediagnostic: CO6PR18MB3955:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB39552589BEC1C04B2F76ACB4BAF20@CO6PR18MB3955.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9IyNTPefnvipZA1teaTE8cnXkXxGlyy2yGdM83/cJuzqpuoqmoPcNynNoTEEuCNzqJFotPFyZtGjvn06nvrm7k/JMzBzNKLJbRLLKt00i4ez6ok9xRewKJF8pHYBpRPv+CkS5fCg0i/AL2MWTaIcQlm7Hz1wl3k0FMWRDTCaNeXKsAUHNoiuPjt+JmTm5IgL9y85DRJxznnSJ5tRejabtjeo2+rJ8haF/Hf5CWK2ayeLn/xKZa98ovW6Ex6vhFNTSsEtiR8omxSLISm20lEWOfO6VEklVt+/nOnvjuTb73nJdWc8Snjf3FyB3pvEiY/keTnkXt4OfSrkw34BtWHx+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR18MB1598.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(33656002)(478600001)(71200400001)(52536014)(9686003)(55016002)(4326008)(86362001)(54906003)(2906002)(316002)(107886003)(8676002)(8936002)(83380400001)(66946007)(186003)(5660300002)(110136005)(66446008)(26005)(66476007)(66556008)(64756008)(76116006)(6506007)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?1K7KMbK+1huufrFKntiq2DA1AyDP7/5Kc6WWhnNnyr+Gj7Mwuj7ZiU/Sl5WD?=
 =?us-ascii?Q?/ClT873uWg2WCzhUFvzDVWxDox3+jCVLbKmAx2n3jPk5sMXb+DN6h3KVnRGh?=
 =?us-ascii?Q?rfwqi0hcDjYYiwnSRhBof787ncOzMBL9bQn8gfJr/t9eVNB105IkFO4vwSsC?=
 =?us-ascii?Q?Tfmg+B0HUEbQD9eUXU7IshDFUirI2v8l4/qzZco8Ru7yuyFn+61x35HPsZwE?=
 =?us-ascii?Q?7ZQBo100lXgRRSFtnRgWbqgNR4Uwg7SqWN7HhRwJZvxtniQaCQXPNwuq69yp?=
 =?us-ascii?Q?jTmnYFNmO+p7yDTyTGI/JtyGJH9STIoWp2lPVYdFlHHFWqd0bsBW/SsLMIkv?=
 =?us-ascii?Q?ACLpLmuvo3/Fyj1zeV+cAD8tsLvCZ/RcUQC0K4PwJ3ATs/K2GoxeW//zSk7P?=
 =?us-ascii?Q?tkYiEEXkJyT/X60eee5zYbp7rqzowbSMQ0yAFQ8a2TxEmYh0pWjTQ6rGkLxA?=
 =?us-ascii?Q?x69foLy6T4U+huJcGsnFTqSFykrgg9MgST24C9EGatz387LUjUyiAqIUnzea?=
 =?us-ascii?Q?Pk9+05CoQroSosrpLQzPDSwUPvSYRJZdgkZGp0D3+TYQz08mfLd9ZPuPJZT5?=
 =?us-ascii?Q?BTeiA5/7H1ZeDdN1MAlVg6fMwsM3BsRJY10SrxvHxPJ8iXERhK68KaKanayP?=
 =?us-ascii?Q?YSZ8zlWgwY1FUI6GqvzEhRUqEYcnHzNqSLmS72xn9cB7b7Km4l5V15UN3dDj?=
 =?us-ascii?Q?oQmWvWvmXe4286TLEOvByeHDVclE4ykFOrfo4O+wHiSUXR0zmOuER2Grpje4?=
 =?us-ascii?Q?Es37hOT7HpcS+ECtCamSnDiFWVUWMMehAM1JxujRCpDwULlt/fGrUw3/Hogj?=
 =?us-ascii?Q?tQLKyOhDh0LitmHQ9vzif9jamO8XSH+08RlfN1VVnIEWG2thDhDVCkNdm+9M?=
 =?us-ascii?Q?Agg3VeU/Z8woitKEdba+r9rF7q0ph5E3iikzTF+MKZxpBEIk1/hL8H+qO00K?=
 =?us-ascii?Q?wWKGq0GhEF26HCSrn5c03/uJTzPwQ5rsxneyWCfCfOg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR18MB1598.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e10218e-afd5-41de-5ab7-08d897c62f4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 20:01:12.4724
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XhplT+xU4+RS6aJYRfJbJwc1qgquGRR/TBVPyFFgPzZhkaCwfGEtKy4yyQPYsOlhoATAdhvVeC4Vn5KRmN6Cbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3955
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_11:2020-12-03,2020-12-03 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, 3 Dec 2020 16:48:57 +0100 Andrew Lunn wrote:
> > On Thu, Dec 03, 2020 at 03:44:22PM +0000, Mickey Rachamim wrote:
> > > On Thu, Dec 03, 2020 at 04:36:00PM +0200, Andrew Lunn wrote: =20
> > > >> Add maintainers info for new Marvell Prestera Ethernet switch driv=
er.
> > > >>=20
> > > >> Signed-off-by: Mickey Rachamim <mickeyr@marvell.com>
> > > >> ---
> > > >>  MAINTAINERS | 9 +++++++++
> > > >>  1 file changed, 9 insertions(+)
> > >  =20
> > > > Hi Mickey
> > > >=20
> > > > All the commits came from
> > > >=20
> > > > Vadym Kochan <vadym.kochan@plvision.eu>
> > > >=20
> > > > Has Marvell purchased PL Vision?
> > > >=20
> > > >     Andrew
> > >=20
> > > Hi Andrew,
> > >=20
> > > No, Marvell didn't purchase PLVision and I can understand the reason =
for thinking it.
> > > PLVision and Marvell teams are keep working together as partners on s=
upporting this program.
> > > Vadym Kochan is and will remain an important contributor on this prog=
ram. =20
> >=20
> > So Vadym Kochan is still at PLVision? Please use PLVision email=20
> > addresses for people at PLVision, and Marvell email addresses for=20
> > people at Marvell. We don't want Marketing in the MAINTAINER file.
>=20
> 100%.=20
>=20
> And Vadym is the only person that should be listed there as far as I'm co=
ncerned. I'm intending to purge MAINTAINERS from all people who haven't rev=
iewed patches in the last 3 or so years, so let's save ourselves the back a=
nd forth.
>=20
> I'd suggest you create your own mailing list and add it under the L: entr=
y, that way all managers and people within company who want to keep an eye =
on upstream can subscribe.
>=20
> IMO MAINTAINERS is for listing code reviewers.
>=20
Hi Jakub,

Vadym will remain the main contributor but the new upcoming support will in=
clude additional engineers.
The intention is that all the three M will review the code but we OK also w=
ith two.
Additional features will be uploaded soon and will require more than one M.
We'll update the patch accordingly.

Regards, Mickey.

