Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B05437154
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 07:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhJVFaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 01:30:13 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44186 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229484AbhJVFaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 01:30:12 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19M5LTFc016910;
        Thu, 21 Oct 2021 22:27:52 -0700
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bueuysvqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 22:27:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hbqlQBC5oXYUbALoEWoQuQL92zVlGXK4C44ZNwU6LFQFgUbmzGA209+cZqS2jfLa4/KkvzdnhfC7/fIWOP5nqOLGMVkYNpsm9gzakT1Akm4//JRCy8e1vlwzv8HsPTo/Y3X+m4rmYdnRAprp1WixYH3//hDWWC1lyAp8OoY14KTFM9ZrAP5fjQBgO/JTCL8EkJOMDCfvNcY3RVXjwCqz3vTEowsA00ZYdTtMofp3k1x0TO4u9NbWR3GMaphjj8ALRs3jXhzqogNdzxjc864D5ssRizYr+yyC/A3VMcbnFaSKs8EmX9jMT7kBscQ8QJBVT6RJzBEHI2x/T7/wMrgDSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=funDtaK36RsuZUtn+4/koe5X5/ppDEcWwecAGz0iwsM=;
 b=ayJcnnDMCfezbLagrzautZjd2jOwdK2r+1nK8qIQB7MoC8lhakJnJV5X25qjrzcnCJ9kP9izuflVgW/KmzKNNBPdfVfLgsr8vEiygWMukaMeVu2vqjm6vp9OJ7mueUQkvdW5sulEVozZR57i73MvX8RixPtP3dhM8D4/+ne31Y3KIHX+Lg9TIb4RDM46z55MKKc1XwEhQoY0gKVh1DKLBq2JXhhVx3jXr2xFAO8Ngm90qy8a+kzKcISYk/DKrvK0Ir/avYpDV09vvGhdjxLF9WLDkxzhtLbi+11mrUF+gNdWaNemA4yLgHW3y8VkRsqtp74r5sBCEBuqZ2hNVZU3gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=funDtaK36RsuZUtn+4/koe5X5/ppDEcWwecAGz0iwsM=;
 b=Bx+O+2dNHYEl2pe2JGaEwcU19ctCxNqLFTVrFiFkyjsctk6K1MJNqYz8kis8vPA7K/zCijLX/ufeG1mBdbFAT+QUpowBdT5v9yzssPI8fHZq2nV5++jKVVXJoJ6SKPP2jaKuYcxmO2lM81WmP8TW4e6QkzPfqiH88QkiqMLV37w=
Received: from DM5PR1801MB2057.namprd18.prod.outlook.com (2603:10b6:4:63::16)
 by DM6PR18MB3289.namprd18.prod.outlook.com (2603:10b6:5:1cf::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 05:27:50 +0000
Received: from DM5PR1801MB2057.namprd18.prod.outlook.com
 ([fe80::a8de:65b:4fe0:32e3]) by DM5PR1801MB2057.namprd18.prod.outlook.com
 ([fe80::a8de:65b:4fe0:32e3%4]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 05:27:49 +0000
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     =?iso-8859-7?Q?J=E5an_Sacren?= <sakiwit@gmail.com>,
        Ariel Elior <aelior@marvell.com>
CC:     GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [PATCH net-next v2 1/2] net: qed_ptp: fix redundant check
 of rc and against -EINVAL
Thread-Topic: [EXT] [PATCH net-next v2 1/2] net: qed_ptp: fix redundant check
 of rc and against -EINVAL
Thread-Index: AQHXxvY/ZGHCNidYkEencLg11uh8W6vedzVA
Date:   Fri, 22 Oct 2021 05:27:49 +0000
Message-ID: <DM5PR1801MB205755F94145D5FE11091C25B2809@DM5PR1801MB2057.namprd18.prod.outlook.com>
References: <cover.1634847661.git.sakiwit@gmail.com>
 <927234fe6f6d9d50b9803e57bb370f97342ae2f0.1634847661.git.sakiwit@gmail.com>
In-Reply-To: <927234fe6f6d9d50b9803e57bb370f97342ae2f0.1634847661.git.sakiwit@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d71c25a0-0a90-4354-7274-08d9951cb048
x-ms-traffictypediagnostic: DM6PR18MB3289:
x-microsoft-antispam-prvs: <DM6PR18MB3289655FA5754AD41DF2962BB2809@DM6PR18MB3289.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QOQbpIuaGPR8yyQmcT3j2xOFj9E7sVObMvnsjr5wNMy+k7+ulV/FVXjKgMZsmrWZ+Qx0pN7jyjHtvf5bEmx8dyDs+baawKDZ2c/7HJ3i1pLObweD3yD36nnzUXsLZHfbXYjC5n9OaaV17vZk1JJ+sIuf3aKHKef+SCrfb0Cb+PSqIjaMYSmlRk0J2s3lT4MKfSuYPJmfeB7u/txKCNlW/tG1chn1ZX3/a3I8NPGHHC47aU9Wz/r+NGj9667vgaAnkegmpbYqxyY4tTkv7tY+qASFPjHPUeNssPAj9m78Us9jOpz6aO92bRUl8byWfiBLuZYmQ34CBE2tVrQc95wvyNgSCTL7p7ishH5apC1i7SXaRLldjVMvLNiajtllTnngkUMJd2S4nXcGrescTQl+Gm05vYz94PfsCD3qcgrWwr+9HK7WX2uUbNyFyzt23xQ/2KhmYgdOwSXBvJNLOyRT9fDRCtklXfbfxnCSB4B5oqFYeN5YisA2wc4jRP6XbjfK0rD6f+WFXdnhVHlUoN/+3OE2JvXoVvU08wD3kmh8/dCt62gnljvVVm/XEdfUPhHPaVV5nfy5xAp+t4AO6gCKP5lhIAw4paL2PDLtbU8jsrLEKl1DsIZWJN431EVS2poSp5ICVOFV7zZTGHUxBAKWbUh4neraU4iqHLGNUEFzvJv4kRo+8jxFV5yfjCL3tX6O8z6fNfT6EC9yxxNknbYxeA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1801MB2057.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(316002)(66946007)(8936002)(122000001)(7696005)(33656002)(110136005)(52536014)(54906003)(66476007)(508600001)(6636002)(38100700002)(86362001)(8676002)(66446008)(66556008)(64756008)(4744005)(2906002)(186003)(53546011)(38070700005)(6506007)(4326008)(26005)(83380400001)(9686003)(55016002)(71200400001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-7?Q?nhm1Q6yJRsLar7XpU5FdGn0cz8b4f0lbwAo0kpTwEufhOXmknx30RB03+3?=
 =?iso-8859-7?Q?Go5Js414SALto+H34nofwXqvgjQ3Ux5MeyDF7qmWCKB+NxBkGEs0i/1TlY?=
 =?iso-8859-7?Q?nNhDIbSS+5eJBNF3+kVGWu96tg5CqpniRQCWDtVZNybfMyc+F4kq+9Jipy?=
 =?iso-8859-7?Q?oJ7yV8XoXdheL6EIb8ezfjjqXJO6EA0c8M9tghkdudso9o51qQsyU56G7N?=
 =?iso-8859-7?Q?lJjJ3QBGbL4GdGdIT8iv1mEtfmVI7hJqbRzDXaKYSCwRagwpniR+l8vQ2y?=
 =?iso-8859-7?Q?YQNucTElq0OAGRnTFqWzIgS1rcZibR/rjT8Fiui02mp8faHNTUvo+BT2z7?=
 =?iso-8859-7?Q?zaU7R/nedEWvSr/F3bynXb5WfHDVSY0NzV4PjFWh2rQQzrjukV4NL/Egpu?=
 =?iso-8859-7?Q?S7Wj0dFW6VQaJY/WWT/8jJr/OqwEL3fGQphRsJv3XZRYMW8Ea8NeH7fbf0?=
 =?iso-8859-7?Q?WrMNt/RvlUtavoALGyrIWMXaUuAREVciDZp5k0rPkwYfZ3xb1a5KNWs6SM?=
 =?iso-8859-7?Q?ZD5qSJBH9GuIysIcU1IwmjZvUC9y+fKvGt4D6sIORcZNDBP0+XbBxSQ+vC?=
 =?iso-8859-7?Q?OXKWv4K88IXwJeUqkT+iB6S83mGGpi050Wl30LvrYsZrg6m3rzoPg9vU1X?=
 =?iso-8859-7?Q?jfCTdypN9GLjpBhMOW6NifKTNvfNZ0tDFFhhALNFCo0OGLkviNLoei6G2I?=
 =?iso-8859-7?Q?aYB9DnX03SnfgCgouKifabAN6EogcUMv5S0SZYvjCuAlJVrtwUrrqQUdCr?=
 =?iso-8859-7?Q?vlJRt7/BkAv8XXys/XwHfuZ3b+jLPttCyrDoAe/NhkQLtBJOQ6z7CCxKal?=
 =?iso-8859-7?Q?CQGcshEiqosvGFo2rDBMg1qwi+kVFFBWpAfk6mZvnDowOfPtB4YXbRGmwV?=
 =?iso-8859-7?Q?/0c09Na/fwq+34cKe+xDwQLJ9EzvuNXJYwe+gkdF7x+kz+rCDcFeTxLtVX?=
 =?iso-8859-7?Q?ap5/JAcZyJKd8sBhtA8RDvabLc2VLzZ+Szl1EwmoavmWu4qkPJdTf72XP7?=
 =?iso-8859-7?Q?7Rz2AFEvsM2XjvoU9CHAc5UYd7yZsltwWZTMhqYcWjRnv4VoRuTU2Om8Ow?=
 =?iso-8859-7?Q?LLFaNXeX8xSUEwz7HMGrYo37R9EJ2VByJ2FyzLfeOy8E1Hu3Fb9UeeZAoF?=
 =?iso-8859-7?Q?q+PVVlITk4veWeqNb+ygctT8On2FvGn56HyS7DlVDRq/pOskZt3raRq+gc?=
 =?iso-8859-7?Q?Y6qp2bVs/+RpKMjDWe9FZ47bEVJJru9bEtmu1Vtjkim/ycBKziO3IHjCEq?=
 =?iso-8859-7?Q?n9CYgSZgZbDBpetcJT/6yJOYoKYxYFWsi3EiY0DMpzNo8pnmKLPKYPPe6Z?=
 =?iso-8859-7?Q?ZVaAdyEsIEJwU7xpN+f3/zszI162h2JD48q51XCtz/FegbSVvPNznSxSxJ?=
 =?iso-8859-7?Q?cCwumPDjll1KBQPIAi1BJgoLkvyMpYR2BAuw+pr0S9II0EBLX62mrr0Wqh?=
 =?iso-8859-7?Q?W+pfh0jNKAKqui7GSe3EPv15I/Zz750Lffetgjczr0LKurmpb5R7ecqxOP?=
 =?iso-8859-7?Q?U=3D?=
Content-Type: text/plain; charset="iso-8859-7"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1801MB2057.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d71c25a0-0a90-4354-7274-08d9951cb048
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2021 05:27:49.6697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pkushwaha@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3289
X-Proofpoint-ORIG-GUID: Huy5SDgpr5QmRVECHVjUgC-ioizPo0oi
X-Proofpoint-GUID: Huy5SDgpr5QmRVECHVjUgC-ioizPo0oi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_01,2021-10-21_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: J=E5an Sacren <sakiwit@gmail.com>
> Sent: Friday, October 22, 2021 9:08 AM
> To: Ariel Elior <aelior@marvell.com>
> Cc: GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>;
> davem@davemloft.net; kuba@kernel.org; netdev@vger.kernel.org
> Subject: [EXT] [PATCH net-next v2 1/2] net: qed_ptp: fix redundant check =
of rc
> and against -EINVAL
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> From: Jean Sacren <sakiwit@gmail.com>
>=20
> We should first check rc alone and then check it against -EINVAL to
> avoid repeating the same operation.
>=20
> We should also remove the check of !rc in (!rc && !params.b_granted)
> since it is always true.
>=20
> With this change, we could also use constant 0 for return.
>=20
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> Reviewed-by: Simon Horman <horms@kernel.org>
> ---

Acked-by: Prabhakar Kushwaha <pkushwaha@marvell.com>

