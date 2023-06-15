Return-Path: <netdev+bounces-10975-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 421E5730E30
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 06:36:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7122E1C20E28
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 04:36:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB736385;
	Thu, 15 Jun 2023 04:36:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE1B360
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 04:36:37 +0000 (UTC)
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021019.outbound.protection.outlook.com [52.101.57.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9162426B6;
	Wed, 14 Jun 2023 21:36:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6I6gZ45m/p1Smi865jugSJZDMtekZeDIslDY5Tw+HjoEByb5huZzCBYNjCs6+NHgMI9dwGipMkFRsp60B07ciukPoamWMmF2lp26NmeZu25CUakvpH8hm7ao6yGsbMJ97ULiigVTFzLc50YU3qNNmoONiDYlIB1c7orNW3HzsZ8MKQTe+0foUVtlwW/q2lc3BY5Etvt0hzOsdCPI8GS4RzczEHjpEjXrSSZnBYxEassAdjkwfpK9x6Z5eMten8CVf5+6RGmwR9cJw+pOYlBwQ3PIoHBMooAhZGY5YXer3rIeKfKyJDrg8JbWK/pfQXvqoocHEwix6dKq9jawHOLIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2eanK7Wf0CK8eoyY8WM5b2eUUNfpjwk1i0P3WtWCU80=;
 b=IUIWtW9fqdDZLeqIlWzbcTjaB6awbHtK/OZPc9rw9fGvNRkEn7Ll97pfwO2AxSmcEECoC4ppyxRcHt7UgTBAHd/oPJBIlF+HkLMkjvb1MIgDoyWuZkinh6CB5tOOXmtR3No6USmjHYNFmBdOSq4W+MbxQEIzmJFfFvKusq+7kpxplMyrrotC7jYAdaCPz4TyivTaqXkVMFIwKizx+Eu8I9VkNB0xZ5Ja2QQU85+d9r3BGGzkl684O8Zz1c+rmNWTHnvKS2yvet6S4L92XYSHPdULYAkT0kbkDRsML6tE0/LkJWpR7JUnMEbROmNp3nSbZrtp8+Oxi5JrbTKsR3ZXMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2eanK7Wf0CK8eoyY8WM5b2eUUNfpjwk1i0P3WtWCU80=;
 b=HG/Y7LJw+uDXIjoBWfQQhh2JR4ygJhamDGYwMoQqWnF+fMZj8P2rj5/i6eYR0SYwcjbN8EE0H/7SQJOFSyMfwn8//bieW+vLSMTheeuuzbeCK9CAlIkd1/saXOpHYy0dmHMFzG37LHJhCFBVpYwVfcPPxdzBv3jW2mSIF+6MO6Y=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by LV2PR21MB3350.namprd21.prod.outlook.com (2603:10b6:408:14e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.0; Thu, 15 Jun
 2023 04:36:30 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::bb03:96fc:3397:6022]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::bb03:96fc:3397:6022%4]) with mapi id 15.20.6521.009; Thu, 15 Jun 2023
 04:36:30 +0000
From: Dexuan Cui <decui@microsoft.com>
To: Lorenzo Pieralisi <lpieralisi@kernel.org>
CC: "bhelgaas@google.com" <bhelgaas@google.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>, Haiyang
 Zhang <haiyangz@microsoft.com>, Jake Oshins <jakeo@microsoft.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "kw@linux.com" <kw@linux.com>, KY
 Srinivasan <kys@microsoft.com>, "leon@kernel.org" <leon@kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Michael Kelley
 (LINUX)" <mikelley@microsoft.com>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"robh@kernel.org" <robh@kernel.org>, "saeedm@nvidia.com" <saeedm@nvidia.com>,
	"wei.liu@kernel.org" <wei.liu@kernel.org>, Long Li <longli@microsoft.com>,
	"boqun.feng@gmail.com" <boqun.feng@gmail.com>, Saurabh Singh Sengar
	<ssengar@microsoft.com>, "helgaas@kernel.org" <helgaas@kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, Jose Teuttli Carranco
	<josete@microsoft.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3 3/6] PCI: hv: Remove the useless hv_pcichild_state from
 struct hv_pci_dev
Thread-Topic: [PATCH v3 3/6] PCI: hv: Remove the useless hv_pcichild_state
 from struct hv_pci_dev
Thread-Index: AQHZjuExmOcP6ZcsbkWQid36Iu/cKa+LZczg
Date: Thu, 15 Jun 2023 04:36:30 +0000
Message-ID:
 <SA1PR21MB1335811A25BCAC75510AC045BF5BA@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20230420024037.5921-1-decui@microsoft.com>
 <20230420024037.5921-4-decui@microsoft.com> <ZG8ZQ1U4kmGBVe4/@lpieralisi>
In-Reply-To: <ZG8ZQ1U4kmGBVe4/@lpieralisi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=eac0cd0a-74c1-4f9b-bd9f-c4c19fda1d0e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-06-15T04:28:04Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|LV2PR21MB3350:EE_
x-ms-office365-filtering-correlation-id: 13c00a3f-3747-4e40-03d0-08db6d5a1703
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 4HZq4VLkPs/5HYjj4PKOtGkIYRm44ZEeF1xGjNYK/pjCJI8HAIjNgam7L7qq/5PUDYa7QKhSQyQzBk7ip1GXdUvoPHbXLAM+Q1xFcJJhNkyEuZqIo1lvULlqbmsocm+h0ZEspbLwrdaCKVLf8giU5TPWmo9d1rZdCHtgp5mP4+UUmCLEbj+0ye4N0ydHWBywuoduHDtvLmZ0BcNPns/OmT1L778+oA4MkiR4FfbJLLRt+6m8PZqpRHp//xQFiVO4m9YtGQrUwH+moB2iTZlhgh0GXkZAwZM69y+5E28ACAvvTSkZmHDdZLVCOzYo4NkyBMDKuhEc61BJ3ydGQxyM0NGCGn1fP0Ltx5Eai6f/S/AFhmU0ApCRC31ErNICGR0AWqcTvMcYLa5LmEmf9V2ck+6ksSU6E9KlpiOKYWABDTKZGBikTl+PXHCfbc6UeKq2758o9vd96T9HyAzr+/dVuPPZNC944Glplfr6qsY4k8XZrgcFD0oFgbbszzrJRvvsFGQc74UQqdDZVAl/AVgBv5BcAHHbpdgwx309wHyya8WOkW10Sh1VBQDdRwBs6P4ejezFgkroYnAJcLR9GUTZMPAQIIkKvV1xNh2VoENsTeeKdBc29GloU1ZXYwpSA4rpssk/3WHRCmwKTkGPcoXq00bpDq7ZPVldqw/H7QKkOEQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(451199021)(54906003)(5660300002)(4326008)(66556008)(6916009)(316002)(7416002)(66946007)(8676002)(8936002)(52536014)(4744005)(186003)(41300700001)(2906002)(66446008)(71200400001)(8990500004)(10290500003)(478600001)(64756008)(76116006)(66476007)(7696005)(9686003)(53546011)(33656002)(6506007)(122000001)(55016003)(86362001)(82950400001)(38070700005)(82960400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?zBh9fDvRCsgTB/S1+RnfBaXkxrgMC+y5n1h8U33QyheufYGISwQjmqrzM63f?=
 =?us-ascii?Q?kdUbNCBV5OVAhU3dFqQIFG2LPh9vCKaVdKWxev89z2kxN9pkKhSuvhBx//EY?=
 =?us-ascii?Q?GsW5NM07hB4fHvbyUjwg3q+vzGi9zL+M9iE9xVAGxx8U4G6iskTq++kCAPSG?=
 =?us-ascii?Q?v5xF4CwPpPnASjC+GeszabIzaWx4VerucE8ctAh37R6BfpobMOe/w+liodom?=
 =?us-ascii?Q?NdgoVyv3nviae5s2JE5pj+Cv7O06vU1xvk0GapDhQjMOn5CTyW/wyDovnHic?=
 =?us-ascii?Q?t8xZVDYuC7iZvHEqTL5aF1ZlIDL6hblRRlZKr/oWygM4WK7jz27efqlc6Wlu?=
 =?us-ascii?Q?6EvToPAuhiI2XPLMIbYOJN8LDobLYGI6xGTRmjbPOxiUcP15HLHU3oMYtTGP?=
 =?us-ascii?Q?gGH4ZY32LEwCGpLhRhaPNFPWrpvQvsRYVpd7XQD43nnovblHnHopuDp0O7LT?=
 =?us-ascii?Q?acE9+R5W3TR4pywFQ7bomy+EkcxttnB/7mjtZSVKErUsU6XhkI/DSxB8x7mW?=
 =?us-ascii?Q?wpDswYMRwS60R46SpUVwcHSXf0TDh1uAXD9wcO9jdwpFxJsf/teXDQYpoZqJ?=
 =?us-ascii?Q?Ivn9/rWlUMsXjkGFwR8zMmBqKdS4S43mKhHqzNl3H+KKCN2dF3orU9N4DKIj?=
 =?us-ascii?Q?OI8obTiiYbhcmRRDwZggW8BVTrRd2TwAVbg1CGYItT2XWWS2395rmw5kgluG?=
 =?us-ascii?Q?i8oj0RQrPJ2jE5UNX/EampKEHmVmlWjTc2Kgo1IBhhNuInyu2LB8iNbx0S6A?=
 =?us-ascii?Q?mP8NwhTRzbWoON5Gqt18R6hYcNqH/TseS9rVXOk1TXGEbvHBiN1JF2ejPm18?=
 =?us-ascii?Q?SDXrCLlSSJ4WbU56wYXddPZLG0y9dWNc0FKL2BWAF+28EZhEj6asYcZcivQd?=
 =?us-ascii?Q?q7Tj3yAWqg2rho0DBVe/FattfdhMcMsbD+3w1ujhLYmRewyTZ6JfNd3RAI9X?=
 =?us-ascii?Q?njy1oKivAmAloDyATQDhr4nwgbBkg6fUiEEmzur6xqdcYworJx5Q9/Mxl71v?=
 =?us-ascii?Q?NkJFYwzh99xlMAfdxWS/5QnsrBtk/DJgTwwqw90jjzFDPuztDdfHBiSnuoDi?=
 =?us-ascii?Q?jVPIcaUDtbn7s0bKKwgXW3yqAcTNTVCZ4QgAXZzC+BShTkCxtT1p1i2U8Ts1?=
 =?us-ascii?Q?l8QkD8nDh5kPNGLlPQLZnm9N+Z9cWII9lQNZee0Z9xBvqJhqfk3yp0eKRRQn?=
 =?us-ascii?Q?BnFztGXwfe15cvIAQF/3Szu2HoHiJUHhGgq0XuYDzlpuXdjIzQnRraltFsU8?=
 =?us-ascii?Q?NgljNgM9iPN7giPkWbUuKx/j5xuozy0LG8NEqNvQO1mqQCPZ/L8AhxASJVZ/?=
 =?us-ascii?Q?5+s5g8oa0JIMrBcqjnmN5wWWxotB38yhtdRigtDmaNFtxQZ4uGKQLqxQ93j7?=
 =?us-ascii?Q?RKqjPQ/OGwAwuVElBl8Z0ztyBkQVnBUOF8H8GeczIm85PfwJlYQq9ToWkZWH?=
 =?us-ascii?Q?cWdV7MrCSZ5tFk57WfYNfFnrTiRKCnEHOO1ktTk12f3O57jMWbr0iNDMohUr?=
 =?us-ascii?Q?Q2pw9C0BY+NsCAxVNHUyYegD6b0j2Shbnn0bcj1RBj9Y0YKFa8HQWnoZggQF?=
 =?us-ascii?Q?v5sP6OoEr5DEPpekuvWwP95PNkSupN9uVOKW/ngwRCmbF2x95GTla9DjO9sU?=
 =?us-ascii?Q?c2eTQLIaM5lQUILSHtbgDPA=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13c00a3f-3747-4e40-03d0-08db6d5a1703
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 04:36:30.2998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IGqU7e7O8yFlSMb7vDOKsMt2jSxyJSyB9BWA8ZzCVKciQUkf/c4etTDu8TvZhgxPpMHvoxQdCvtMjFyyZUJvTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB3350
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> From: Lorenzo Pieralisi <lpieralisi@kernel.org>
> Sent: Thursday, May 25, 2023 1:16 AM
> To: Dexuan Cui <decui@microsoft.com>
>=20
> Is this patch _required_ for subsequent fixes ?
It's not required. IMO it's good to have this patch with patch 2 since
patch 2 also touches hv_pcichild_ejecting. I'm OK if people think
it's better to merge this patch through the "next" branch rather than
the "fixes" branch.

> It is not a fix itself so I am asking.

> Acked-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Thanks!

