Return-Path: <netdev+bounces-9959-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15DFA72B6B1
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 06:44:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 077A81C20A5C
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 04:44:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0592B17E1;
	Mon, 12 Jun 2023 04:44:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9E715B7
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 04:44:53 +0000 (UTC)
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2098.outbound.protection.outlook.com [40.107.117.98])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33E1171F;
	Sun, 11 Jun 2023 21:44:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ao1zz4RP1rkuzIiMvzC/Dfl7eEm5hCNZrZnDtqZihYXsNn5tSj8ihv74O8gn3W5LSlHd9imXpSQVaNfLDedg8sk6V6ilA87lQwgeGDhWcJjHQ6Qrf2H38LE682Gf3RP2gV6DAN81m5Jgt/7xJDb9+pX0VO04WUg8+ffKgtNLmWB123jPE/pXpoyTRkxhhjr5RwU2P3ln84l5oHItYSYKN4g9kRj6GRDbOhVvjOILAfX1uyTEzDaFxAuWCl8tvzp1ciP4qFpuMxwHO6HkHWhTB9tyarPwDgojVFKwNkv7Uzzzh0LJmuAVUKXXb5zE0e0CegoWGO3/4Jylwf5Lv148FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YHjwTgLFcNJj0wyrZHVMKfHWyCiJPiJ2euEEU90+NB0=;
 b=IJMnexhSeZ/BneZKW0mfny+0ibb2QWYQQ5+ZBw8jb8HeuF5ekloDyw5q1Jc+B1NvA94OzOAW6vwaVUF1r80hIS+gJ3+a0TrkHn5GXoOIpu1T9hI8Xo6++wMLcmru+aMCHABm4rCmojXc7o+mBZnXin7WS7XCRfYlGqhvmiT9pw+7hYKpMlbM8sMWnPLCQxl0xmyqFHhzo+Wml1gPSs920LJgePvR2jJogLxASmjLKor+hIzOHKjY5/QCE7FuECj5/E4hfaiT/XXssTcvnsmkHpucaQrdDVUzDg/3jC4F3DgxH4MycknU3k0Zno9gAA/F9c7MtjNCpSiEwYCbBvHa1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHjwTgLFcNJj0wyrZHVMKfHWyCiJPiJ2euEEU90+NB0=;
 b=fFbBQo2NcYGzrcUKLwDb0kPYYQ1WzZqZ8AHxSRLM04qCo8O6LvNsPBLZRffBXfdlUPWlOABXKNrl9vAuzXJtdIe0lp1ALR09js/Oq2Y0liQ1WvXMaSPwFKiLJ0LHJjJRqSZVCZqRi0Q3lN6vRWEDRBQKuxdQaE043cGLMHG2z6c=
Received: from SI2P153MB0441.APCP153.PROD.OUTLOOK.COM (2603:1096:4:fc::7) by
 TYZP153MB0628.APCP153.PROD.OUTLOOK.COM (2603:1096:400:25e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6521.3; Mon, 12 Jun 2023 04:44:44 +0000
Received: from SI2P153MB0441.APCP153.PROD.OUTLOOK.COM
 ([fe80::7d79:7433:e57b:55b5]) by SI2P153MB0441.APCP153.PROD.OUTLOOK.COM
 ([fe80::7d79:7433:e57b:55b5%4]) with mapi id 15.20.6521.002; Mon, 12 Jun 2023
 04:44:44 +0000
From: Wei Hu <weh@microsoft.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Long Li
	<longli@microsoft.com>, Ajay Sharma <sharmaajay@microsoft.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>, KY
 Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
	"wei.liu@kernel.org" <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "ssengar@linux.microsoft.com"
	<ssengar@linux.microsoft.com>, "shradhagupta@linux.microsoft.com"
	<shradhagupta@linux.microsoft.com>
Subject: RE: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to mana ib
 driver.
Thread-Topic: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to mana ib
 driver.
Thread-Index: AQHZmIoyK0/pJvWPX0+gdBo6594smK+AVTiAgAZKrxA=
Date: Mon, 12 Jun 2023 04:44:44 +0000
Message-ID:
 <SI2P153MB0441DAC4E756A1991A03520FBB54A@SI2P153MB0441.APCP153.PROD.OUTLOOK.COM>
References: <20230606151747.1649305-1-weh@microsoft.com>
 <20230607213903.470f71ae@kernel.org>
In-Reply-To: <20230607213903.470f71ae@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=286edcf7-c4c8-4100-bc0e-54eb0eca02c6;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-06-12T04:43:54Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2P153MB0441:EE_|TYZP153MB0628:EE_
x-ms-office365-filtering-correlation-id: ad805535-b1ef-4aa9-f41e-08db6affbe21
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 hmZWzL7I0dTSui7wNVmU2pf8DeDGfP+R/x2FTk0Z7tCeQ0GmvlopBle41y8AuC0r+tRMvKfe/4dGlU7jPVlFipCu8+t5mPNVfU556yiXs0vs/wownV1ltM9FQulm+BGhcKwNnvIP2okpKH5VfdFAHIob5pLEyUUY7zQFfJrgw3W/CFjJEU/eG5Bcg2tkMUVa0dU+XP9xnLd+lXMMUhMfC+r8thmTieJ2RsCY9WcFGfmtFJvRyxSeSULH3ehFBddp8TYPyAvGKk61RH5uw0BQLs8szPw55O6fekMRXYc0bQHDyNMDwVLShEEcUum3AwUD/dcvwjRim0Na2rIFVztSTwvqKWY4s+1K7TwM9rYa7A53gfpWEAdk+g956PSsq+tI5qsf7lAM6360Upi+jioVRIe469wGnVEtyeDUcxf32O5+cvS+LqEn8ibYdy6dy8COW2yfzCABDwHg7v6lSJd1QoDnynztinaGtp8fAKvG9HNCm8xVaS9CmpXcE/QBHbiyRN5ac/TIdEe25CObklFYRY+yVxL0pTMCTL6zrJ3Xd70sS7HFPo8CGBlYUJ7gj9iI6LPzlITRSweO+qewvvQ1Terr6prIAwdT2vAZlqxUOD7+3bk8Idhm+rRfqQ8mgyjU65Uc4iSKkbf1mCcDH0klPQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2P153MB0441.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(396003)(346002)(376002)(366004)(451199021)(966005)(7696005)(316002)(41300700001)(83380400001)(86362001)(8990500004)(38070700005)(9686003)(6506007)(53546011)(186003)(26005)(107886003)(7416002)(2906002)(33656002)(122000001)(82950400001)(82960400001)(38100700002)(55016003)(52536014)(5660300002)(8936002)(8676002)(10290500003)(66946007)(66446008)(64756008)(66476007)(66556008)(54906003)(76116006)(4326008)(478600001)(71200400001)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?HMxftERMGmJnb8/eTZ2/2CwfcHp8hs+tfpTT/TlBYvhBTMxZBgaAOpCdiuFZ?=
 =?us-ascii?Q?7ozqFyX33sXekSx33JL96g6jaRNgpPe7ghA+KojP936rhzaZD5DdApsjquUN?=
 =?us-ascii?Q?NibwA1VjwQJPWMXietk3P0MQvtVjFvtzSAf+QQyO8Yzo6z3EVOnpJI6pU53v?=
 =?us-ascii?Q?YlAi98hQZMRcER0XG8CquHZ2uHpYpIcG2sSBkZ+FJ6YbTQMTotxhJJxXvET2?=
 =?us-ascii?Q?/wO8Qt2pX20vSVY8JVUCoMxGkqdTjGEQFNfGAYdgWaX7kbo/J+g7wnMX5j9G?=
 =?us-ascii?Q?E8WObYnratrS/bd4g2HmmkKbD/T6DkmN2w8qOKWk7HJyNdLY7i5tPSi+RjGe?=
 =?us-ascii?Q?hIY6DSLJitfcqeTGuCRvBBvbiBYEnewOngbXHaY3v9aR0A0MF9Crm8H8Ha2w?=
 =?us-ascii?Q?mAZ78hr7n3d9VgdCxu3dEZKf/3EWoV+Ugg9JHbAiFR+1lEMTVikmS8lLGa8v?=
 =?us-ascii?Q?nRpnuNGmHY0xxAEWLFzbUkP46Uy106rqgFXeUuZ5gBqcyez3LvjWZVGS3JRc?=
 =?us-ascii?Q?sFqo/qExcffsmcGzwHoFM/hEPlrsEWuE12t55mu2Lpp2HrqCrDXqmae7P72Y?=
 =?us-ascii?Q?g0bsfwtREHvAPXquIbKOLeVg+kr5teEz6Stb6AQk4xw5eE5Wl/avxknFqIjK?=
 =?us-ascii?Q?Dr3bA0f5766iaLTEhA/7EJ1wPcC2UvAiT06LUpP8Y96IGURBxxRxsAS8TRch?=
 =?us-ascii?Q?ln15PMuRBsygJetIKV215dg3MOq4MZrzDNa5VinYT9lzv44eLawKFz+aHnDB?=
 =?us-ascii?Q?DqzV41fy6sk52JB6vISzvSMjz41YL+smJGLmdKO0ZQ+U+3aqwAn8RzajFENN?=
 =?us-ascii?Q?VqoirlQuuRPxMp01ReZTvWNmcoi6EngQGFY3uhwrnLz8+2LjxAvZ6yE8CJx2?=
 =?us-ascii?Q?ser5ZK7/OrBDmdRHaLd3+UbBmLjPne5N5id6c665G/g8V6ACLEh6NhM3Icr0?=
 =?us-ascii?Q?QS4RXB7oWjGOWL7eSzdj0TqDuaTWiMOdDDQUZ+9NjWANZu+owhbGDtwvAbDs?=
 =?us-ascii?Q?p+w3Of2sEds9doSKFfBxXS1l+ScjurQ5WtbnDfBTMI0DZho3kHJrE6srj8Wj?=
 =?us-ascii?Q?IwEh2ba1GnpXMtmbdNILZgQwNb4jzk3Zs8mZ28OcP63QLmfkLMLTCX9QJ8RG?=
 =?us-ascii?Q?lrSafm6dzUIpCPw5iGG0cXs0GXNnbcti1sfEeyiuGhePKJdMCUC5BZPOGjFq?=
 =?us-ascii?Q?asqvmctenZODz3Nzm1z1WTKcEHv7nz74vAo1PNRIDjOTgm63ghMKmFceXYcj?=
 =?us-ascii?Q?wHxkbQG/bIPp/38X63HMf4n6y2pHd8dOfXNREEQb6nj5Y0omr9HlXTpbU1PP?=
 =?us-ascii?Q?FEUtlqEFuefV4Evr/IuilaM70xqC4Frh+uamZ/sIQHgK2NsqEtlI7gE5dKq6?=
 =?us-ascii?Q?ng/I786/Bss90ydlaztZ7aNwU9wyPZ6jUnW7uTMdAG/VwEwI0urgK96/2ju6?=
 =?us-ascii?Q?pWIzBqWvgYDLcNgA/W30eNEsXkAQoMUVA9U+YOprHxuLeh0xgKd3qjFPpvyj?=
 =?us-ascii?Q?zQTApyM+BiJ1gA/oPq6nzAx9lZ9Qs/jvhHe7ocqrg1+/XRfEzFsUl4y292H+?=
 =?us-ascii?Q?nIg9epbrRbhCZkyQgpg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2P153MB0441.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: ad805535-b1ef-4aa9-f41e-08db6affbe21
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 04:44:44.1905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VmTsVxCoKPlN4QnIFTBSPuGC8W7dyMtHac7luPB13kGFEXb4tfDH+SSY3m46mI1dJY2df+EtgC4GkO8ybcAhgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZP153MB0628
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, June 8, 2023 12:39 PM
> To: Wei Hu <weh@microsoft.com>
> Cc: netdev@vger.kernel.org; linux-hyperv@vger.kernel.org; linux-
> rdma@vger.kernel.org; Long Li <longli@microsoft.com>; Ajay Sharma
> <sharmaajay@microsoft.com>; jgg@ziepe.ca; leon@kernel.org; KY
> Srinivasan <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>;
> wei.liu@kernel.org; Dexuan Cui <decui@microsoft.com>;
> davem@davemloft.net; edumazet@google.com; pabeni@redhat.com;
> vkuznets@redhat.com; ssengar@linux.microsoft.com;
> shradhagupta@linux.microsoft.com
> Subject: Re: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to
> mana ib driver.
>=20
> On Tue,  6 Jun 2023 15:17:47 +0000 Wei Hu wrote:
> >  drivers/infiniband/hw/mana/cq.c               |  32 ++++-
> >  drivers/infiniband/hw/mana/main.c             |  87 ++++++++++++
> >  drivers/infiniband/hw/mana/mana_ib.h          |   4 +
> >  drivers/infiniband/hw/mana/qp.c               |  90 +++++++++++-
> >  .../net/ethernet/microsoft/mana/gdma_main.c   | 131 ++++++++++--------
> >  drivers/net/ethernet/microsoft/mana/mana_en.c |   1 +
> >  include/net/mana/gdma.h                       |   9 +-
>=20
> IB and netdev are different subsystem, can you put it on a branch and sen=
d a
> PR as the cover letter so that both subsystems can pull?
>=20
> Examples:
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.
> kernel.org%2Fall%2F20230607210410.88209-1-
> saeed%40kernel.org%2F&data=3D05%7C01%7Cweh%40microsoft.com%7Cb672
> 4a9f672f47d433ef08db67da4ada%7C72f988bf86f141af91ab2d7cd011db47%7C
> 1%7C0%7C638217959538674174%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiM
> C4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000
> %7C%7C%7C&sdata=3DamO0W8QsR2I5INNNzCNOKEjrsYbzuZ92KXhNdfwSCHA
> %3D&reserved=3D0
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.
> kernel.org%2Fall%2F20230602171302.745492-1-
> anthony.l.nguyen%40intel.com%2F&data=3D05%7C01%7Cweh%40microsoft.co
> m%7Cb6724a9f672f47d433ef08db67da4ada%7C72f988bf86f141af91ab2d7cd0
> 11db47%7C1%7C0%7C638217959538674174%7CUnknown%7CTWFpbGZsb3d8
> eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3
> D%7C3000%7C%7C%7C&sdata=3DA%2BjjtSx%2FvY2T%2BNIEPGuftk%2BCr%2Fv
> Yt2Xc1q8B6h2tb6g%3D&reserved=3D0

Thanks for you comment. I am  new to the process. I have a few questions re=
garding to this and hope you can help. First of all, the patch is mostly fo=
r IB. Is it possible for the patch to just go through the RDMA branch, sinc=
e most of the changes are in RDMA?=20

If the patch also needs to go through the NETDEV branch, does it mean two s=
ubsystems will pull its own part? A few follow-up questions about generatin=
g a PR, since I have never done such before.

1. Which repo should I clone and create the branch from?

2. From the example you provided, I see these people has their own branches=
 on kernel.org, for example something like:
git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-upd=
ates-2023-06-06.=20
I am not Linux maintainer. I just have repo on Github. How do I create or f=
ork on kernel.org? Do I need an account to do so? Or I can use my own repo =
on Github?

3.  How to create PR in this case? Should I follow this link: https://docs.=
kernel.org/maintainer/pull-requests.html?

Thanks,
Wei

