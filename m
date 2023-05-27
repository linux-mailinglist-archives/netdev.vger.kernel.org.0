Return-Path: <netdev+bounces-5938-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC720713708
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 00:34:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C77E1C209C5
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 22:34:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D1F419510;
	Sat, 27 May 2023 22:34:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876599461
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 22:34:52 +0000 (UTC)
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-pr2fra01on2112.outbound.protection.outlook.com [40.107.12.112])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04351AD;
	Sat, 27 May 2023 15:34:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NF+J+V2KtCEd9LvH1cHSpcSlNUpyY/VdalPuwUbrwdwMKC5FqrWSXKlyjYaR4zGpm6GGHJJCmZMTCoWwRSwOn3ALMcTy9qXEohBZ8KBNdoPKwRcOyTbV9FUR21ITPfiDMkQ6GxjbsEp/nUFoXko3hL9Uo1et1sdPhGfwbdumfexlUWyEh/KA2WPVO8bILqDe+nvI7RYvUAyBSjFgQAFL3/B0mMEIjF9OuplA1EdaTgBCKbHvC7AFhnXHERKsPa4VUi737B1CU8zqZv7wQyr/IFzKlD0Qi7+xjWZrcxMMr8vAFxbNhvATGasj7W30Kp5as+FHiLqpoCUWXYQUyiK0RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t+KayWd7+frViExUTaUyvlm+98YCyIHslSums7jvV/U=;
 b=KvyWWjaYDE2EdaFZ9u1bKc58k4nTNSPQjZc22HEOzACQXgqg34eUm0Ot3brNtrJDujWZoSG+NF5isOwDCLtfZW1u73eK1x/3i6vDUC0eC+tFLZlu+xe+xYbJAVMqgcFgqce+V3JpJGja+zElHoeIH7o7GMgdzE2nMR4Or09RmvgMH0x6abdRX0vpdmRKR+iXDsmefd3ai0wBlIoGjQsOZVBgXz41ROzus5r3ZsJRyd3lGsaYl6mqbjAK+QdmeftywEEuatvmPJiYlsO841/Dt8HqdOo6Ub9xCT9YyttjzbJ5HwVcq0ksUlVldcLkW5R0Bt06DTqQKHymt54r1PiWIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ekinops.com; dmarc=pass action=none header.from=ekinops.com;
 dkim=pass header.d=ekinops.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ekinops.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+KayWd7+frViExUTaUyvlm+98YCyIHslSums7jvV/U=;
 b=pPQF6SejQrZHWfxZU91CGmKfe1IdDWgE3LagBJCTeoX9s7f2K9om2CpZaU8nTyytbXyROX1WU0GLHt1AXEhhAXSVOrY6gD2f8xtD7PipyJ23tT3SOyDfGRJNKRu7qrrnird8it5jYZbwzm00xeo/ZwZOLvxbF64sGZCOWVSXz8o=
Received: from PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:141::6)
 by MR1P264MB2255.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:11::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.21; Sat, 27 May
 2023 22:34:46 +0000
Received: from PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM
 ([fe80::5442:2af6:2ce1:f8a]) by PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM
 ([fe80::5442:2af6:2ce1:f8a%4]) with mapi id 15.20.6433.020; Sat, 27 May 2023
 22:34:46 +0000
From: Ganesh Babu <ganesh.babu@ekinops.com>
To: Stephen Hemminger <stephen@networkplumber.org>, Jakub Kicinski
	<kuba@kernel.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ganesh Babu
	<ganesh.babu@ekinops.com>
Subject: RE: [PATCH] net: mroute6.h: change type of mif6c_pifi to __u32
Thread-Topic: [PATCH] net: mroute6.h: change type of mif6c_pifi to __u32
Thread-Index: AQHZYUP13XlrMpW17Ue8ZSjM0wOOK68RBfoAgCx+ieeACdaAAIAAIdAAgCd1/1A=
Date: Sat, 27 May 2023 22:34:46 +0000
Message-ID:
 <PAZP264MB4064D9406001EB75D768D0E7FC449@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
References:
 <PAZP264MB4064279CBAB0D7672726F4A1FC889@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
	<20230328191456.43d2222e@kernel.org>
	<PAZP264MB406414BA18689729DDE24F3DFC659@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
	<20230502085718.0551a86d@kernel.org> <20230502105820.2c27630d@hermes.local>
In-Reply-To: <20230502105820.2c27630d@hermes.local>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ekinops.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAZP264MB4064:EE_|MR1P264MB2255:EE_
x-ms-office365-filtering-correlation-id: 0074e422-ac4a-4aa3-17ea-08db5f0292e9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 IcXsoVjWGoMZwR9gUPym3HmXuYxDrs7TbX+iZ66owlkQbFc3QQ14t8DqqV4jH6Q3qCJJF1GFFIm5mESQPB98CeMlABt9+ovW1zEDg//WWwQlLNyFH25SaeKySXeVXPyaTjBcew/d2YboWgkOZDQWhHd0bblbaAd7z8u7g7AWgdYIyoXwWrMwBlsjQCCjAYeC/jRPCRcCipi7hp/3fWe4kjCN+b7rIi7nk3+t8Dx1NePeaUYQUnicvt/4QOn93TObAqwB3//0w3wkDXf6kLPn2+Iv1EwNYKpV7fG2OF2ot6S/0zys7fo1nVwx5GZ7PZnaJqwVq6/OxqOCkathUZnlWssO146xVirfw+a2o/alHrsaINSM0Lx9D+AQ27fEexIBP5ALuaZBAvPEWBy05Chbd7PNv9sPnROBrgmJ5vJaTV85LQmGqPHRISCJPvu58XFxa7oTrSMghDbHTRlmMbReKqxtp+NqsOHe80k4lECjp2Gg1+y6NjOZIssKuC9VgU0628DExmQbnlUa5LRccX/NNNf6fg3JiIZiJSUDVzKgYX3nUJSwe2HerZTjj+4iiexSLibVGpAVu5x+ahcqnb4U3cYFVFbEE3eLyMiT7scV48VE4B3qxltzDWr6a8duoTI/ma5TLIzyL0YFDXqdBC3zMw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(396003)(39840400004)(376002)(136003)(451199021)(55016003)(186003)(76116006)(66556008)(4326008)(83380400001)(66946007)(44832011)(41300700001)(38070700005)(5660300002)(86362001)(316002)(110136005)(54906003)(2906002)(9686003)(6506007)(107886003)(7696005)(66446008)(66476007)(64756008)(71200400001)(478600001)(55236004)(53546011)(33656002)(122000001)(8676002)(8936002)(26005)(52536014)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?yaW4ItbjiU+iHeBY9HR+eFySVbYw4BFvU8KDO3Dc/par8Mr3l6yIw/0EfYXT?=
 =?us-ascii?Q?cV8O5Ei0kQVyBQnnHWFDlJ0sboaNBKsTh/n0Oo1gcGFv9XN2q5pHIPEhuMq2?=
 =?us-ascii?Q?k59PgTM3gfj/WN5oERNkI3FnPUVJuU2VNZekpRvhpN5xNDjctHjQjO7NoizU?=
 =?us-ascii?Q?Ty1+VRzwoMAsUlLCMC1x19ggjKw7WUt59WlsRNoAdZ7v6Qhn2hRF7t+HbtEr?=
 =?us-ascii?Q?6m70netzbC3xbnNOMFoEGLWGyMBK090ratbGvWSSt1ewlausUpiHcX0xwL1a?=
 =?us-ascii?Q?9gbLFi2T0o87hBKY7TcgCkExAIJB/U1teWjPwAwGFfw4w5MKHY78H5T8NlK+?=
 =?us-ascii?Q?eqeM22wWpzteLNdAag7eTV2dG8RVsJNp6S1y0tgCOIk/cE9CSiy7o6SvmSbl?=
 =?us-ascii?Q?1q/M6s1NzH2sPy02ucaPh+pj1256EMC4WKgPltFMK+SxZR3QnXaHyf2W27z6?=
 =?us-ascii?Q?ArLtJSgRMIqiqTPe300tf4Co418PNWnof2ATaaqqG2c9l1BwJo2fxfxhwHez?=
 =?us-ascii?Q?e11078Q9XYlhLzfHQs3jg2NlxR249JwpmnklEW9PqA0fs7ShBBl7sxkAtPjq?=
 =?us-ascii?Q?1oNu1sq7vmxS+qI7SdRMK/+/mrbCkH3o4WfFOlZ4VGDW2QWhyQ9yWPxDtU7c?=
 =?us-ascii?Q?nMazGjtarjhW1LCxR+ZFkx2i9eIoP4Os1oHIndVLAXxgGmW+qC3EcwYxAodt?=
 =?us-ascii?Q?KauM0MVFW3gwm2x9TCTgJJCbupvVQWeAe1J9x3WS/O+/szzoXF9Uj3erY7hP?=
 =?us-ascii?Q?ytZC67Zlb4Tt9093vRsNzjpbANj08om4kwSVd/JsGWx34VuKJkB814W5wHqz?=
 =?us-ascii?Q?kesZV3hGt2qDmardjZ7A7iX9gTmunBPDtcAB3sGIrGCvTZ7Ylf4QnhboMoYI?=
 =?us-ascii?Q?TNt5bkd9QiO4bUmem/GFBJeNFb7RkQeuOeEOKCsyPTRH0PaA/nv3E/9LXgES?=
 =?us-ascii?Q?VHN8+4zEjOXvEAxAs2nyfgM5otmtRidTbloE8zROmm+NpYfsEgpTU4UHqQmu?=
 =?us-ascii?Q?1lE1sLJyYe+YOEckxCJnPAHrBro9X8RxBFRQnF8DQ47+h6EZRl2lJm1/zmq6?=
 =?us-ascii?Q?aZ5620Gg2ZrQRsjXlT1/JMsENtond8uFRXBrTjpUqhiyhrJpXl2nV5vSTnBS?=
 =?us-ascii?Q?+CDvgQ6rDfsl71Y1s4pXfabhWGTXCwC6k0iIZkj7Z0EqO5qkRVD5o8uHRfmO?=
 =?us-ascii?Q?T31C2NNBBvmQSCUdRAnp7cUlgi6kU0s39hNbEi2h67Z9DgZBf1kSYVvWXiQG?=
 =?us-ascii?Q?HiLS/s4yl2GAD/l/R7raP4EilT+XBiU7sG6wZQ7xF+C2HAL2tVrQcz4TkV0c?=
 =?us-ascii?Q?5llrj/LlfUTaCrdlJTQKzkTTwFi0O6eonrRoOKCPZxdrsF38xCRLX1bFWtYQ?=
 =?us-ascii?Q?AlR6wIxobbBq05RirbBMDtziw3WYgCwuYyvyXo0qQkZh76I5jPOYF6iuJtfc?=
 =?us-ascii?Q?o3adQ0YrtgD1ELyICw3jnvaNyjwvYut/d19sfNl6L76cyJcm6dLlqMQsiuOp?=
 =?us-ascii?Q?oa+S8Q6BGnyy0P0QmtFHBPVzbZFlzfnBxllXzs/g8JHcFBiEqu8R1xFNQ6ol?=
 =?us-ascii?Q?sCqkGyDOTNOtgXXmVNIsu50LcD5UmMG+yadCqpff?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0074e422-ac4a-4aa3-17ea-08db5f0292e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2023 22:34:46.2004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f57b78a6-c654-4771-a72f-837275f46179
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZFOjae0F65PN7CaxkwOx5aOFVWF1jZ/l9GvotezSVLu+hR6gjqn6+AJiY3RXpkOrxRJhTMn2ryyec5wYs/CpJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB2255
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


> -----Original Message-----
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: 02 May 2023 23:28
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: Ganesh Babu <ganesh.babu@ekinops.com>; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] net: mroute6.h: change type of mif6c_pifi to __u32
>=20
> On Tue, 2 May 2023 08:57:18 -0700
> Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> > On Tue, 2 May 2023 08:07:10 +0000 Ganesh Babu wrote:
> > > Thank you for your response. Regarding the proposed change to the
> > > mif6ctl structure in mroute6.h, I would like to clarify, that
> > > changing the datatype of mif6c_pifi from __u16 to __u32 will not
> > > change the offset of the structure members, which means that the
> > > size of the structure remains the same and the ABI remains
> > > compatible. Furthermore, ifindex is treated as an integer in all the
> > > subsystems of the kernel and not as a 16-bit value. Therefore,
> > > changing the datatype of mif6c_pifi from __u16 to __u32 is a natural
> > > and expected change that aligns with the existing practice in the
> > > kernel.
> > > I understand that the mif6ctl structure is part of the uAPI and
> > > changing its geometry is not allowed. However, in this case, we are
> > > not changing the geometry of the structure, as the size of the
> > > structure remains the same and the offset of the structure members
> > > will not change. Thus, the proposed change will not affect the ABI
> > > or the user API. Instead, it will allow the kernel to handle 32-bit
> > > ifindex values without any issues, which is essential for the smooth
> > > functioning of the PIM6 protocol. I hope this explanation clarifies
> > > any concerns you may have had. Let me know if you have any further
> > > questions or need any more details.
> >
> > Please don't top post on the list.
> >
> > How does the hole look on big endian? Does it occupy the low or the
> > high bytes?
> >

We don't need to be concerned about the byte arrangement, whether it
occupies the low or high bytes, in the big-endian machine. The reason
is that the mif6c_pifi variable is only used when calling the
dev_get_by_index() function to retrieve the device information of an
interface. This function expects the interface index to be passed as
an integer. Since both the mif6c_pifi variable and the expected
argument of the dev_get_by_index() function are of the same data type,
there is no possibility of data truncation.

It could have been problematic if mif6c_pifi were 32-bit and the
interface index values passed as arguments to the dev_get_by_index()
function were 16-bit, as this could result in unexpected behavior.
However, the proposed change avoids this issue and ensures
compatibility between the data types, eliminating any concerns about
the byte arrangement in the big-endian machine.

> > There's also the problem of old user space possibly not initializing
> > the hole, and passing in garbage.
>=20
> Looks like multicast routing is one of the last places with no netlink AP=
I, and
> only ioctl. There is no API to modify multicast routes in iproute2.

In open-source applications like FRR
(https://github.com/FRRouting/frr/blob/master/pimd/pim_mroute.c) and
pim6sd (https://github.com/troglobit/pim6sd.git), 32-bit interface
indices are sometimes assigned to 16-bit variables, potentially causing dat=
a
loss. This can result in inaccurate or invalid interface indices being used=
,
leading to incorrect network interface identification and improper multicas=
t
forwarding. For instance, in FRR's pim_mroute_add_vif function, assigning a
32-bit ifindex to a 16-bit vc_pifi variable truncates the value, risking da=
ta
loss. Similarly, in pim6sd's k_add_vif function, a 32-bit uv_ifindex=20
assigned to a 16-bit mc.mif6c_pifi variable, also risking data loss if the
value exceeds the 16-bit range.

However, even if the userspace application still maintains the mif6c_pifi
variable as 16-bit, the proposed patch ensures that no issues are created.
This is because the size of the mif6ctl structure remains unchanged, even
after converting the datatype of mif6c_pifi from _u16 to _u32. This guarant=
ees
that there is no risk of data truncation when copying the 16-bit mif6c_pifi
userspace value to the 32-bit mif6c_pifi kernel variable.

