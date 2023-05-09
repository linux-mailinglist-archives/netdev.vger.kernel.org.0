Return-Path: <netdev+bounces-1245-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09B9D6FCE47
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 21:08:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 268191C20C4E
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 19:08:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE25F14A98;
	Tue,  9 May 2023 19:08:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F8914A84
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 19:08:41 +0000 (UTC)
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020017.outbound.protection.outlook.com [52.101.61.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF86E40CE;
	Tue,  9 May 2023 12:08:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ff9ZOg79tKROXERwJCN0W0T6Ee/KAJ7SUYIEM9rDAASaG9qTf/BuhiTiwnZXKhCEg+9SCq6pfRYror9hFNwDXZDZJUvYZ+mVhjw6vY+rRzj3Qv3beltp5424pjJdDDIJ7fyrqTaWjAkxfa86F9VXkRMOol/nb0HF4VXLOhJk6MjZMM5GgRlIMfLslMxxO+YAQJvrgVoDd+3ZR9YBPA0HPDIaJoHaXLaMAclxD0pzG9nMgKQrZmwicIHVE9S2WJb96gmzc5tc5nSd5PmRo+FLw1EtbeA2gYL5RU+e2FWjNo7D9FvidbtAXdVOA0bFSO1hewSF6b+4+Fhm8lLKdoQj0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=flRVuabfbAhmZC20DeirPgHcazgTcfG+K2Ww2dcToPs=;
 b=cxCFKnkcMFEIqtFN7ae3N+HVdaEntsyGkyMtAOQZVptvZxQn6b5HXMmT3XBotzW1JdjXcVGca/lR7NJughm8k8svvII66krZjw3X6/XB9bHn2xrUIEIOij9mxxQKs6vuWazgPoescQLEDr03vqgFmaoYtv4H06v4zvGKsfWXE8aBYm90ew1hyqBhcywT4NGb4fkM/URGPq0V79zKMK25PmzNx6JNUuxfVThdVrl5cJHV5ryNoXozasiottVoUSmBE6a9KTS0kEbxynoCWs3wVm9o4PjbrJfGSn+LEU8AMDXq/EJREjIEa3X5wZNyVHUclMitTeIpZlYKk/vlwOkz+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=flRVuabfbAhmZC20DeirPgHcazgTcfG+K2Ww2dcToPs=;
 b=eeXV7ohJ7uR29bxGk9ZYUf2HmhGZoI1u709hF+15ArdrRRo5oXgBk4i+DX19rNyjAUO8a7F8FOh0Uywoz/GRx8Shxcw4P1yQA+HQLoHowLWnRmqN1yxWNh6YTXTm9K9Mh+wW3Nxvd+S4zlwf2pk9LlEiMewiXgZhgaYQK0nBiUA=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by CH2PR21MB1447.namprd21.prod.outlook.com (2603:10b6:610:8c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.4; Tue, 9 May
 2023 19:08:37 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::e121:ed06:5da7:db88]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::e121:ed06:5da7:db88%6]) with mapi id 15.20.6411.003; Tue, 9 May 2023
 19:08:36 +0000
From: Long Li <longli@microsoft.com>
To: Leon Romanovsky <leon@kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Ajay Sharma <sharmaajay@microsoft.com>,
	Dexuan Cui <decui@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Wei Liu
	<wei.liu@kernel.org>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to
 enable RX coalescing
Thread-Topic: [PATCH] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to
 enable RX coalescing
Thread-Index:
 AQHZf4Kx516JgSVbG0yUd0QoJdn9v69Od9yAgADh6oCAAI6LAIAAkDIAgAEYvwCAAMAoMA==
Date: Tue, 9 May 2023 19:08:36 +0000
Message-ID:
 <PH7PR21MB326324A880890867496A60C5CE769@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1683312708-24872-1-git-send-email-longli@linuxonhyperv.com>
 <20230507081053.GD525452@unreal>
 <PH7PR21MB31168035C903BD666253BF70CA709@PH7PR21MB3116.namprd21.prod.outlook.com>
 <20230508060938.GA6195@unreal>
 <PH7PR21MB3116031E5E1B5B9B97AE71BCCA719@PH7PR21MB3116.namprd21.prod.outlook.com>
 <20230509073034.GA38143@unreal>
In-Reply-To: <20230509073034.GA38143@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=0ddd3a51-c9ab-4d08-a298-46bcd11d5f29;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-05-09T18:58:18Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|CH2PR21MB1447:EE_
x-ms-office365-filtering-correlation-id: 106ddf87-8bdf-4dd1-3f3a-08db50c0ca63
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 jv4Quams8Dbx+Yqw/vPGjq6z7eoj6Bfu1NXTRmZ1GmnfyeiSM/xBbQfDtyhHr7goBHWSaAQ8daHczxZCrDiEUuEEmECtZCfz06u0X5ijDddDG3UyiMZbAk5p3nNKh3EiBP51rIs+HMTAV6gfsmQeITKZwSG9rK2/mtX8l/GKnI1uoy/so6RuZiNbdJ5SqYI3faeE/K8ubSE2IK3JoeS75wtjFp5XDpPXOMnKpUogbhN9x7p9QpRMd3l4MQwtgfh5qsD7OCdFrWjoCfJDPbxfFPp006l6kQ3mqrANeQM8ZWvojr17eBh/9H/Y0EK3Qpxu4zb1p2iC23tNPs96XfDGni7Fc1dct55rNA89PXbmreA15PeEU2dZosq3qwBWesRKgX+kMb02uJmNW3Ovqzb0L5eXVEH7qiyQUathy2v4ZXUOvDQjIKuHCnAVesGGkCzXj42TnKaHZXXaEHe2qV/0hJ/HRw4lKi3Pft8tMxmfdeITGG7lKuu8Y15cz+g3oIhT7hWehNTKq/lBx3X8QllhGeC6fJjw/IT+EiRvWkDSkQSx4dedGoDziyuR9hQdH1JQdQ4NsAX0P9NLHm6ocf9l/cChMIQvZ1vn9Qg/zzkZAqU2pyXoQU7FiHXgX8FQ01qtkowKaTvw8jCpNYZpaDW20ZP8rufFCVFEDtzgV+FN634=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39860400002)(376002)(366004)(136003)(451199021)(9686003)(53546011)(55016003)(26005)(6506007)(186003)(10290500003)(33656002)(478600001)(66446008)(110136005)(54906003)(7696005)(5660300002)(8936002)(71200400001)(52536014)(8676002)(86362001)(8990500004)(7416002)(6636002)(38070700005)(4326008)(2906002)(76116006)(64756008)(66556008)(38100700002)(786003)(316002)(82960400001)(82950400001)(41300700001)(122000001)(66476007)(66946007)(83380400001)(66899021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?hxCYD2b7Ja8q8bRSdQxIZAj6OvY0s1S8bqezmzPJfZ+jFV00ZokPhIZJNytQ?=
 =?us-ascii?Q?gWOYvEXL8/mo/hVsE5LZD6P+ufHdoRJCLcKAo/j+tArYERVvVLR8i+T0agyi?=
 =?us-ascii?Q?S4xyCbMAyfTqVVT0evXfb8+MufjlF8wVHbhSYcCO2f4sAgDYpNC6peRPOUZG?=
 =?us-ascii?Q?p6j3D8vPf4OLsnnIccZX/POOmU6CDM/Z0romYF/tL5HHpB+t2K03/whZw+ud?=
 =?us-ascii?Q?2DpLbiGCtOH1KpCAvhu5U4FlyXDd/wPCl2CY/s3HjItKmel+SHlYzGY6yayH?=
 =?us-ascii?Q?q3ct1hOs8dGGsq3CeFw8XtXPHDBrO8kVbhLUi1O27fsO+QO07S9SaAU0Wg5C?=
 =?us-ascii?Q?0W6BTCA6y4cTyMvbZyrFbRzs5+47z9ldOthjAIRRVVIcLCLond0FsOLzi+pc?=
 =?us-ascii?Q?rCfqzHKg/ev8QO4bVLdHhDWgLyF9tNrGDfC+RpsajOH2ZopdXtLFhTHWqSI/?=
 =?us-ascii?Q?AWCFKDPtbeHqel3FDbqylV9LXBBNdWs0KY0evh+XYTqiLspNoUO8dJS7grd3?=
 =?us-ascii?Q?plaH4yilt66r7jE+SDdpF/NhngIRzKbKR7p7K7ATRo4+PczAKFS8aWWkduUl?=
 =?us-ascii?Q?PHPjh/x31kbDUn+wP58pPnzLaiFM0Zyf8H/pFAk883GNuCE+2w3iPy4nCWZU?=
 =?us-ascii?Q?uaKP2D8H9EBgxZTLo0geIWntp72lKAuBvfclTZ0nNqpDTolBAjDFFCNVDiyL?=
 =?us-ascii?Q?+37nK67F3fHg/q8IRxHBueMbppsH1F/MJ+F+So9vQ/pOs9024cDyNWRny3hm?=
 =?us-ascii?Q?8krSdSwsm0bEtBYAYpRt0L9tvKYMAJhri1Yr0sEE8MK0qxcopSIVUh+Z1cNJ?=
 =?us-ascii?Q?BH4ROAimFt3YKUriZC9SmNl3hhc4e1PF90ulrr0mT5wr3h0fT0qJwM+Qm9s9?=
 =?us-ascii?Q?iiY8EqhIsxvO3qRPEoRISIij2FrZFMqrlJNlPMdvZCznUlz75P4srtcgYRMz?=
 =?us-ascii?Q?S8I/Cr2VIyGcWr9wPT69dKcFjFlEyKTE6o78P6qaKpaeHp2cGiVKvqs0UYFZ?=
 =?us-ascii?Q?Y49yeZIioiF3ADBepxqjq6W4xh9VTnC9588UNBTWzFOk6dS2IseO+izVIXai?=
 =?us-ascii?Q?a3Eqsz/K+2Y5i4BZ9FUZLKGxL35ZMw5lvHNvaihRSY83b6oPCYq1y9se5D6y?=
 =?us-ascii?Q?Z1CtQGfW0D7IUKyvDDa/fdui2QNPUYixsJTqPcZD2g9LtMEao/ckMxScNS31?=
 =?us-ascii?Q?P/AkM5dZbaeb5HZbgT4X4uRGRH81Kl46gO9zbI2T6zQjYMd8jm1ToZJCWsK3?=
 =?us-ascii?Q?/ekXyEYGPj5EQs6PWe0D00bC/lRg//Wzrmujzv3zhQ/0mvRDOCBt3xrX9iOv?=
 =?us-ascii?Q?muTCzoqLuHLzIpPPFQuTckkkf0stWd052FlJWn6nn7KvBofGk9LVdo5eZR8d?=
 =?us-ascii?Q?W6G9Q1ZmreZPuI7IBQeqEBVK/sKeycbG9Fr9uaBhpgL/x0LwHoetxLXx7a3T?=
 =?us-ascii?Q?QoV/o+845atmV/h3813d41AGBxggQtAIN9rbwQk3Mo0YUfj3tPrtVutSimoN?=
 =?us-ascii?Q?9dcCFI5S9Kc4sMCud1ukCJ/N4+MTEH8NCHfXszP2VM++ebZGPqPl2zXnI+xJ?=
 =?us-ascii?Q?1zqsDG+UxXR/2Mla+SE=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 106ddf87-8bdf-4dd1-3f3a-08db50c0ca63
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2023 19:08:36.2031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NApaSC5nm0wRE/YTSZw8Ru5E+gha6+fUu1vOSazBZomkcsvZHUZ3uuRBu8rGw8sbJ49UsgvVr7kjL5/fm3heCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR21MB1447
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Subject: Re: [PATCH] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to
> enable RX coalescing
>=20
> On Mon, May 08, 2023 at 02:45:44PM +0000, Haiyang Zhang wrote:
> >
> >
> > > -----Original Message-----
> > > From: Leon Romanovsky <leon@kernel.org>
> > > Sent: Monday, May 8, 2023 2:10 AM
> > > To: Haiyang Zhang <haiyangz@microsoft.com>
> > > Cc: Long Li <longli@microsoft.com>; Jason Gunthorpe <jgg@ziepe.ca>;
> > > Ajay Sharma <sharmaajay@microsoft.com>; Dexuan Cui
> > > <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Wei Liu
> <wei.liu@kernel.org>; David S.
> > > Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>;
> > > Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> > > linux- rdma@vger.kernel.org; linux-hyperv@vger.kernel.org;
> > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH] RDMA/mana_ib: Use v2 version of
> > > cfg_rx_steer_req to enable RX coalescing
> > >
> > > On Sun, May 07, 2023 at 09:39:27PM +0000, Haiyang Zhang wrote:
> > > >
> > > >
> > > > > -----Original Message-----
> > > > > From: Leon Romanovsky <leon@kernel.org>
> > > > > Sent: Sunday, May 7, 2023 4:11 AM
> > > > > To: Long Li <longli@microsoft.com>
> > > > > Cc: Jason Gunthorpe <jgg@ziepe.ca>; Ajay Sharma
> > > > > <sharmaajay@microsoft.com>; Dexuan Cui <decui@microsoft.com>; KY
> > > > > Srinivasan <kys@microsoft.com>; Haiyang Zhang
> > > <haiyangz@microsoft.com>;
> > > > > Wei Liu <wei.liu@kernel.org>; David S. Miller
> > > > > <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>;
> Jakub
> > > > > Kicinski <kuba@kernel.org>;
> > > Paolo
> > > > > Abeni <pabeni@redhat.com>; linux-rdma@vger.kernel.org; linux-
> > > > > hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> > > > > kernel@vger.kernel.org
> > > > > Subject: Re: [PATCH] RDMA/mana_ib: Use v2 version of
> > > > > cfg_rx_steer_req
> > > to
> > > > > enable RX coalescing
> > > > >
> > > > > On Fri, May 05, 2023 at 11:51:48AM -0700,
> > > > > longli@linuxonhyperv.com
> > > > > wrote:
> > > > > > From: Long Li <longli@microsoft.com>
> > > > > >
> > > > > > With RX coalescing, one CQE entry can be used to indicate
> > > > > > multiple
> > > packets
> > > > > > on the receive queue. This saves processing time and PCI
> > > > > > bandwidth over the CQ.
> > > > > >
> > > > > > Signed-off-by: Long Li <longli@microsoft.com>
> > > > > > ---
> > > > > >  drivers/infiniband/hw/mana/qp.c |  5 ++++-
> > > > > >  include/net/mana/mana.h         | 17 +++++++++++++++++
> > > > > >  2 files changed, 21 insertions(+), 1 deletion(-)
> > > > >
> > > > > Why didn't you change mana_cfg_vport_steering() too?
> > > >
> > > > The mana_cfg_vport_steering() is for mana_en (Enthernet) driver,
> > > > not the mana_ib driver.
> > > >
> > > > The changes for mana_en will be done in a separate patch together
> > > > with changes for mana_en RX code patch to support multiple packets =
/
> CQE.
> > >
> > > I'm aware of the difference between mana_en and mana_ib.
> > >
> > > The change you proposed doesn't depend on "support multiple packets
> > > / CQE."
> > > and works perfectly with one packet/CQE also, does it?
> >
> > No.
> > If we add the following setting to the mana_en /
> > mana_cfg_vport_steering(), the NIC may put multiple packets in one
> > CQE, so we need to have the changes for mana_en RX code path to support
> multiple packets / CQE.
> > +	req->cqe_coalescing_enable =3D true;
>=20
> You can leave "cqe_coalescing_enable =3D false" for ETH and still reuse y=
our new
> v2 struct.

I think your proposal will work for both Ethernet and IB.

The idea is that we want this patch to change the behavior of the IB driver=
. We plan to make another patch for the Ethernet driver. This makes it easi=
er to track all changes for a driver.

>=20
> H>
> > So we plan to set this cqe_coalescing_enable, and the changes for
> > mana_en RX code path to support multiple packets / CQE in another patch=
.
>=20
> And how does it work with IB without changing anything except this propos=
ed
> patch?

The RX CQE Coalescing is implemented in the user-mode. This feature is alwa=
ys turned on from cluster. The user-mode code is written in a way that can =
deal with both CQE Coalescing and CQE non-coalescing, so it doesn't depend =
on kernel version for the correct behavior.
Thanks,
Long

