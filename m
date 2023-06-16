Return-Path: <netdev+bounces-11360-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 37680732C7B
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 11:52:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 317181C20F22
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 09:52:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11DD3171BE;
	Fri, 16 Jun 2023 09:52:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D4B6117
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 09:52:49 +0000 (UTC)
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-pr2fra01on2119.outbound.protection.outlook.com [40.107.12.119])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D64297E;
	Fri, 16 Jun 2023 02:52:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M3/cKr1vf4GUm2Y/ijs0Ssv/4vKCr0VanCbgSndTYn4Np6zqXTBBU7Lp89Z6dA9WaytJe7OSpRUzA0UHcMDuWnH7y3jjC7S+xnA56S0b9e+9mPRwJPPImKxUMhuvlNOD8dRXag6SpAA8R6wtGspCg57GVxP7H1dK8G/+lB6Kh+RW+ERL14IevYxMExuGcdtxwR24AFAsks6pOKgiMa7wPrTSZPfPFzHaLPQ5p7ppUhTIISjVO/hYjENFt7KnwygFxMnbDiMEm4XcvrXkVs2wQar8bkWEGeZoPxuJk4cK5+63sMW76a0DVRvoMtA/vD9tejDdjWhigtC8Nie7V5lLtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6NZictfkCzkZk2/1Ews7fPFDRYlAEme8npOKIKEn0os=;
 b=T9L8rBaQceBWtypAhUu5IjEnZf3LPTqehLFZ3etnMRVIvXGFRgwGfUVwWojjDJlMM4NiKBi9F3HYmmvqlSKG2w0M73JPntppBsG1npQIhH3QSVJudN4RP+1I81d6DJTxNeBLRt2YYG2eIJh55NbOwzGT08S9VEiK0UxhiiI598r8CejhJkp76xExKKupqxS1JXUydqKiCQs4Tyskw2q8yxxh5hu7w8WUSL7EOnpE86zwXvlMcRZpl4lESp4EZbCYhjS4SVuJplx1rIyNU48ZmR1Nf+WtuxlXNAMMu0iIUK2PuA4kzssgzTK1Esa4mBBEm2w64FyTvFQgdUAXZgwtEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ekinops.com; dmarc=pass action=none header.from=ekinops.com;
 dkim=pass header.d=ekinops.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ekinops.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6NZictfkCzkZk2/1Ews7fPFDRYlAEme8npOKIKEn0os=;
 b=Axw8fqJu3Uh5voc0EWPtXOwE4oLMRIvwz+Cz1A0cagLHFOP3GDhmkmkYtz1AFRb3vywN/zc3hZ/CBNEfJo4jW0lGIFHhxULIppz56NJ7a9Ay54ZkMXTzkOOgPbGp1f9p9gNraj5bjKdsaaVAso8fcV4CWv6Se0VZvwZCZXwtk0s=
Received: from PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:141::6)
 by MR1P264MB3201.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:3a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.29; Fri, 16 Jun
 2023 09:52:44 +0000
Received: from PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM
 ([fe80::96af:7591:b425:3b17]) by PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM
 ([fe80::96af:7591:b425:3b17%5]) with mapi id 15.20.6500.025; Fri, 16 Jun 2023
 09:52:44 +0000
From: Ganesh Babu <ganesh.babu@ekinops.com>
To: Stephen Hemminger <stephen@networkplumber.org>, Jakub Kicinski
	<kuba@kernel.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: mroute6.h: change type of mif6c_pifi to __u32
Thread-Topic: [PATCH] net: mroute6.h: change type of mif6c_pifi to __u32
Thread-Index:
 AQHZYUP13XlrMpW17Ue8ZSjM0wOOK68RBfoAgCx+ieeACdaAAIAAIdAAgCd1/1CAHrh8AA==
Date: Fri, 16 Jun 2023 09:52:44 +0000
Message-ID:
 <PAZP264MB406423636D35E139C50BCD2BFC58A@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
References:
 <PAZP264MB4064279CBAB0D7672726F4A1FC889@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
	<20230328191456.43d2222e@kernel.org>
	<PAZP264MB406414BA18689729DDE24F3DFC659@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
	<20230502085718.0551a86d@kernel.org> <20230502105820.2c27630d@hermes.local>
 <PAZP264MB4064D9406001EB75D768D0E7FC449@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
In-Reply-To:
 <PAZP264MB4064D9406001EB75D768D0E7FC449@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ekinops.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAZP264MB4064:EE_|MR1P264MB3201:EE_
x-ms-office365-filtering-correlation-id: 324b0255-50a7-4345-0ad2-08db6e4f6edc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 oRHE2LopP4cl0wIOTwOt/Spv+3keFhKdQ3Z/WLskWxUzC3Gw8TR5sL5quBKw9ls4Qjo6aici3Dh0m8zCqp1dvh3ZY4Cp7BBqD07C039pWgh9HET4Bs4qeMH2XtnIi1h9bKzBcVHzxy3gxGGrxxB0h/BDGy9hw1Z6BIjB4Aa0Ow+MOI2TohfByWMyaxmDYMU5yM08BWDyRcnv/tt/7z4JNM8UBktlODTLs/bzrKP+sX4bEZmcy+vdlI3zWhPH2NSuV7EFgcLbBHHfQCjvHXyYLgVz5DIfNtGHR191/fcUQQfmeLPWYbx5VwFFbab8C/jm5AzKm1MVp7MWLRi89FX+K6SiGbCFtpxr180SHY1ydlUy4wG8ltWLG3+jxa2cnLb+k61gjdbWq5qIgLE2MclopZOmJecKTe9yp2SnwBf+VnF81fbImpLUjdfP8qdYUYFwLsC/ybKay+5XcrYTUKdbKYP6KPUW+M0OGuT/yKSoK/D3+4VHio+y/hdGFTuuAzPT5SXowhvlZAGL+6v/s/Y3QxAX66LvL6qMicRsP73nB8tQlGW/rAvprN50FdfTVlnb6xV2gBGaHqYdWyChiji3pzKUppxs5H/0hKh+vqT7IawYevQRT0o2jdhya1gsMAZrwjezaWrPYSQe8AIbleYcHg==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(346002)(39850400004)(396003)(136003)(451199021)(52536014)(5660300002)(8676002)(122000001)(86362001)(38100700002)(83380400001)(8936002)(316002)(38070700005)(44832011)(41300700001)(66476007)(4326008)(66946007)(66556008)(66446008)(76116006)(64756008)(54906003)(33656002)(110136005)(478600001)(186003)(9686003)(53546011)(55236004)(26005)(6506007)(7696005)(55016003)(2906002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?k1qUlHC9sdKmhuo0wugg0XngMQZGVspQeMWVytbrVqFfqU3lEA20AEKsBwc3?=
 =?us-ascii?Q?TxzE/DJwcyQGTIgkzkOFQc7GJ5HIzQWxVHfCSqogGnnc1P6YFdGk+BoC4k63?=
 =?us-ascii?Q?BhcR8blEVOS1DExX0hVcm6uQWkIifgR239l4F7YBEq/HoVhKrBQO/QTluevU?=
 =?us-ascii?Q?Eu/zNRwo2tRGGDjFMtKk8x24DDCldCi3O+e57VBkUykEskaHwmzCoO2Cz4un?=
 =?us-ascii?Q?XDkFnuAaf/INDtu0Eegea0pxofg1o49hTRu94I5ZFDIRioBaMDn3uKPXn/C2?=
 =?us-ascii?Q?wn4QqmtYf9hwg16oGrXNnwe8Ks0csdoTe25Yfv2dMxy1P0WIuzqbNVQUtH2m?=
 =?us-ascii?Q?ZPjiJPMgO+laNZ/J1l0raUFgo5RsP9ZK8JP7vz8/BHplQ0TaJPM3bHqomrqe?=
 =?us-ascii?Q?u2WQPQ7yOmaZKICEZMPP1ppHhf2BDUsJcBnE9BKJdjDN6uuJ7SwQAPP1bhk+?=
 =?us-ascii?Q?/qBDV4oAnkfKHtvn/7It6N/h4TfeT2rwhHeH1+5TLjvRwUoyTMmTXi3okMMU?=
 =?us-ascii?Q?Cx1/kBCBnrQs5caBilbPqfLyIV7zVCqsRCI4zzLrR1r46m5t9I3trJGlSxYX?=
 =?us-ascii?Q?VDWaDZLkVZo/cJHP6wS7rDfPGRcZdrIGVuKp5F7DSpv2GOA0+9KmClyNCTga?=
 =?us-ascii?Q?KxZpSt/BPalK1FhE0pdGCA+O+A602RdK4oJvbEgitffj2/VnMjVJlp4lx4D/?=
 =?us-ascii?Q?fJfpIMOMMkSIFgGMTSjKfvL9PbtTbSu72/e82YMbtWkihstFgFeew2IrtFNq?=
 =?us-ascii?Q?tjxcNTLB0+ivpsMEicbm04VF9oNL61IoGe8TF8goYyVbPimHNE9qYapUUE0J?=
 =?us-ascii?Q?LrxaTu4R9KkOg3ZcSgsWP/IjFbP69Z8Dhsf5J/Fwzeb86B0Ai9LrEElR51Fz?=
 =?us-ascii?Q?29q0lQGemFQ+OcgmCr19S4jfiMfwE4LBA2nhV9GPzJxbrmhLhkG1DX8u+nZ3?=
 =?us-ascii?Q?SeSlW3sxcKgmCC3JhQM1WRbyl0O51CEXgGS4QVU78wlOcl6ACvBFTAtU0Gn0?=
 =?us-ascii?Q?3IMp1wW3h6CDIPGu+9bM4o00/TpBTZZZtdbVAy+tF6HZlteMH0CdIjx4KcXO?=
 =?us-ascii?Q?YsaAn6J8Vux8AzErsDqr0MvhP10PyT/g0Ddp3yEAsEgcRUEJhmmx7MYuvAuf?=
 =?us-ascii?Q?SB3AzND69BaNWxvgoP00mN7w1rzmkRxKzpfhN3mM4DmU0ZwCKCFYVQT7f7VQ?=
 =?us-ascii?Q?PHxfllZ25O94jBiqBFqz4ZDm6nekGgRDXOKFlkozdeQSlI4ip4RteffAQR70?=
 =?us-ascii?Q?CVWE5tomOTzr93vHYotnvD2aqetn3ek/ySZE894Wo8PjPRBZ/s6TQ9GENxtN?=
 =?us-ascii?Q?zukKMTXTN+wleD2Gq6Q05IzcUm4XkGWuXrnjPPGKrC0qgYALpLEaLRqQ5ls/?=
 =?us-ascii?Q?RvBGI371ATSpVGIz3UT3HFMgJT3jnFFopjVPWEZm8YD+0JdUz80x3kjFZmZU?=
 =?us-ascii?Q?oq60tVskd7ONTxLkB0IAl+HkWe8tF+n1HzMyuLI7DNAjWUUPz2Kq9C+0MSX6?=
 =?us-ascii?Q?m9SRzg/ZsFrbNaihDyvcmx5QavrAme1sNM5coLBdrGw0X7+waiSvOSPgFlwB?=
 =?us-ascii?Q?X7FDO48wjHpgizmwdGNTdgnPAC48bZxrDoaDijiU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ekinops.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 324b0255-50a7-4345-0ad2-08db6e4f6edc
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 09:52:44.3917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f57b78a6-c654-4771-a72f-837275f46179
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nAfYWzgnWsFFANxWE67p31eDpxcGwZ9B6B5WeFaqIbpqStk/IMp4QrkJ56CwcGJHUwoKMqDjgZkhT/BFw999MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB3201
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Ganesh Babu
> Sent: Sunday, May 28, 2023 4:05 AM
> To: Stephen Hemminger <stephen@networkplumber.org>; Jakub Kicinski
> <kuba@kernel.org>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Ganesh Babu
> <ganesh.babu@ekinops.com>
> Subject: RE: [PATCH] net: mroute6.h: change type of mif6c_pifi to __u32
>=20
>=20
> > -----Original Message-----
> > From: Stephen Hemminger <stephen@networkplumber.org>
> > Sent: 02 May 2023 23:28
> > To: Jakub Kicinski <kuba@kernel.org>
> > Cc: Ganesh Babu <ganesh.babu@ekinops.com>; netdev@vger.kernel.org;
> > linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] net: mroute6.h: change type of mif6c_pifi to
> > __u32
> >
> > On Tue, 2 May 2023 08:57:18 -0700
> > Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > > On Tue, 2 May 2023 08:07:10 +0000 Ganesh Babu wrote:
> > > > Thank you for your response. Regarding the proposed change to the
> > > > mif6ctl structure in mroute6.h, I would like to clarify, that
> > > > changing the datatype of mif6c_pifi from __u16 to __u32 will not
> > > > change the offset of the structure members, which means that the
> > > > size of the structure remains the same and the ABI remains
> > > > compatible. Furthermore, ifindex is treated as an integer in all
> > > > the subsystems of the kernel and not as a 16-bit value. Therefore,
> > > > changing the datatype of mif6c_pifi from __u16 to __u32 is a
> > > > natural and expected change that aligns with the existing practice
> > > > in the kernel.
> > > > I understand that the mif6ctl structure is part of the uAPI and
> > > > changing its geometry is not allowed. However, in this case, we
> > > > are not changing the geometry of the structure, as the size of the
> > > > structure remains the same and the offset of the structure members
> > > > will not change. Thus, the proposed change will not affect the ABI
> > > > or the user API. Instead, it will allow the kernel to handle
> > > > 32-bit ifindex values without any issues, which is essential for
> > > > the smooth functioning of the PIM6 protocol. I hope this
> > > > explanation clarifies any concerns you may have had. Let me know
> > > > if you have any further questions or need any more details.
> > >
> > > Please don't top post on the list.
> > >
> > > How does the hole look on big endian? Does it occupy the low or the
> > > high bytes?
> > >
>=20
> We don't need to be concerned about the byte arrangement, whether it
> occupies the low or high bytes, in the big-endian machine. The reason is =
that
> the mif6c_pifi variable is only used when calling the
> dev_get_by_index() function to retrieve the device information of an
> interface. This function expects the interface index to be passed as an
> integer. Since both the mif6c_pifi variable and the expected argument of =
the
> dev_get_by_index() function are of the same data type, there is no
> possibility of data truncation.
>=20
> It could have been problematic if mif6c_pifi were 32-bit and the interfac=
e
> index values passed as arguments to the dev_get_by_index() function were
> 16-bit, as this could result in unexpected behavior.
> However, the proposed change avoids this issue and ensures compatibility
> between the data types, eliminating any concerns about the byte
> arrangement in the big-endian machine.
>=20
> > > There's also the problem of old user space possibly not initializing
> > > the hole, and passing in garbage.
> >
> > Looks like multicast routing is one of the last places with no netlink
> > API, and only ioctl. There is no API to modify multicast routes in ipro=
ute2.
>=20
> In open-source applications like FRR
> (https://github.com/FRRouting/frr/blob/master/pimd/pim_mroute.c) and
> pim6sd (https://github.com/troglobit/pim6sd.git), 32-bit interface indice=
s are
> sometimes assigned to 16-bit variables, potentially causing data loss. Th=
is can
> result in inaccurate or invalid interface indices being used, leading to =
incorrect
> network interface identification and improper multicast forwarding. For
> instance, in FRR's pim_mroute_add_vif function, assigning a 32-bit ifinde=
x to
> a 16-bit vc_pifi variable truncates the value, risking data loss. Similar=
ly, in
> pim6sd's k_add_vif function, a 32-bit uv_ifindex assigned to a 16-bit
> mc.mif6c_pifi variable, also risking data loss if the value exceeds the 1=
6-bit
> range.
>=20
> However, even if the userspace application still maintains the mif6c_pifi
> variable as 16-bit, the proposed patch ensures that no issues are created=
.
> This is because the size of the mif6ctl structure remains unchanged, even
> after converting the datatype of mif6c_pifi from _u16 to _u32. This
> guarantees that there is no risk of data truncation when copying the 16-b=
it
> mif6c_pifi userspace value to the 32-bit mif6c_pifi kernel variable.

I would appreciate any feedback or updates on the status of patch.
Thank you for your attention, and I look forward to hearing from you soon.
=20


