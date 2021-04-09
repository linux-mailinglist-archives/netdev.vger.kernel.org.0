Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBCF359EB5
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 14:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbhDIMbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 08:31:35 -0400
Received: from mail-mw2nam10on2087.outbound.protection.outlook.com ([40.107.94.87]:48864
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232395AbhDIMbe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 08:31:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTHdPZWQlKXB/sEQmoNeQassjP04YmL1hWKcksiJqJdviKFzClQTMu8CsPEMGgMkU74aQB7xaqjDcxFt3Cem7aOtW/VHbwtHVeo6e1H/AfVsWHGcu3012JgeKw1BqxapGe78FjLcbdXzuKrB3G6fEdHzYFxS6ZcATDDDmuvF1i6CDLdgcEaOs/WTzhqw5mA4mvR3cDMCW3ObweYzkW4avu8YVYKYlcVRzVfk+nwLrbHIs6yBKy5AFAVHBWjdjF9MP7hRUuYx7XDaute6mp6TwZ1+dQ+wE1CNHNc3ZqNwb+GRWvdpFeaGUz/0Bydf704ZXC73ljv0tNT9Kmi4HaMsMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=md7cRVzfg0w7/L0NV8wICTgcfG94qd+CbBkpIUrMVyE=;
 b=Hn69rITgNUsIdSr49p/l6bqIWkw58ZAFLILfbvJn6UTY+aMWxPfDCUL4Zf3/FiEAm9DRwsM2GYNHeKYmsJycyJIe7PROr2giz12gaNpJduJvB3d5Hd/EK1z/tYixrZO03sSRA3kRfYBs6xcj86L8Bah5uuQE0fLVppjLR2Cs9NURRn/9jyD4K7JmQDW55UavsQnyMkWsIo06oN6Gg5e+RcgZAskRoNzc+MjDFMBqnsc4oHsqjEyFFSUyLJYcZIWvrs2iIg5BdoySRTFAc9cnVg8ZvvwyATD+6xJAFR4FfzJ67QhPziKCrNvz5AYQP1hD+7nC1UpqxUn8pv/vIQccbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=md7cRVzfg0w7/L0NV8wICTgcfG94qd+CbBkpIUrMVyE=;
 b=hY+ApfIs6vYwDa2Hs4ujc5bgltN6VY8ZjOIfKcHQTbUAwhitQuKj16z8f4XixOXtRHeaSWIy0G61IdRmiX6cY6RTChndE7B2WUfzh1mcSIMqg0Wjiy7y0pHUUByvrh1FeNVO1jyjSkDc3DH4WDoeBYFlLKY7qv+gVQ5zFhgjIp0zBbme7QysXhA2AKtnF5209c3MrFN0v+0hL/rXHRbpkPl/EwXTPkdDWkZeakPNSapsPJttqJmBP30RnMgJtazzG2Ier3kueRWsvKvoJ5yEKyxhavCla8ghEWnWf1NxbJYKcpHxW6cIEEbq6ZHbuNrWDD454hrskHjAuTD9r/J8BA==
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4081.namprd12.prod.outlook.com (2603:10b6:a03:20e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Fri, 9 Apr
 2021 12:31:20 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::7cec:a7fa:db2e:3073]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::7cec:a7fa:db2e:3073%9]) with mapi id 15.20.4020.019; Fri, 9 Apr 2021
 12:31:19 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: RE: [PATCH rdma-next 4/8] IB/core: Skip device which doesn't have
 necessary capabilities
Thread-Topic: [PATCH rdma-next 4/8] IB/core: Skip device which doesn't have
 necessary capabilities
Thread-Index: AQHXKd+XJ6WIY5+vZk6+h+s0LuIetKqnpFkAgAGBvmCAAAdugIAABvxwgAFZoICAAZZSAA==
Date:   Fri, 9 Apr 2021 12:31:19 +0000
Message-ID: <BY5PR12MB43227C478E381EAFADD3FB44DC739@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210405055000.215792-1-leon@kernel.org>
 <20210405055000.215792-5-leon@kernel.org> <20210406154646.GW7405@nvidia.com>
 <BY5PR12MB4322E477DA2334233EAD5173DC759@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20210407151359.GI7405@nvidia.com>
 <BY5PR12MB4322B39A132397E661680A4BDC759@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20210408121601.GR7405@nvidia.com>
In-Reply-To: <20210408121601.GR7405@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [136.185.184.152]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4071f901-d4b2-4a88-5b10-08d8fb5360db
x-ms-traffictypediagnostic: BY5PR12MB4081:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4081ED0B8B8DABB13ACDCAF2DC739@BY5PR12MB4081.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1051;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VA7FU0BbaXfKzMrTiz/5O6K0F83SCNzdOkklCtwVV7tyur9o5+t8tCFt0vABLrjezUW2xYF87IKyJcAm58CYsTdT3VEeohj6pkR/z9YztMb0NiOVhkCPTkM7lftgwaRxWvdNiHOOO93+NLsyhkk8nkscqx2AEQsMgZ7SGTsYuuWthgI3cHyWN862A5zaiJaMKbaPLuSdjcEvBhC2vDoLRRKSgDAukkN4yhTv30CblZ7fH/irEHaF7S5h9ImcIf8faGJc9V0yW+AtjYQeWzVzcHV/gmjwptcCT1mRQKDUm+hbH1ciHZuYK6dEPgeXlS1rvGF4Vf9lrmwA5DHPpLgcqwJnqVcYo3yeNjt41ck3zOdnucfxaQcfWmi9UXD/LJhs5DLa0f+uYU3eulSHe9yg4ti4e3tx0bKFe68QYE4gbvWNlrSxPQfCP01bttpUM/NJMSjqrTVWAhW9EwXu5L2QW1vPEYK7BpIcKWaaAA0ePE0y5YpvyAAoHfA9cUT1quoAPH5DWtKFaDdeVZJpZM14jhPTsXCrCCmoHtPjvYcq7cXyBTgXh59g5lApSAWvm/UmsH1KlEhgNj/dE7TURbAhyE2Y2J+/bYgepDoBPP/11/ECgsJayG+/n7FH3biYd95lLfWKWPj8rBYcircegssZd8DXDxYWP+RODYYLHsSsycs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(4326008)(7416002)(8676002)(6862004)(6506007)(7696005)(71200400001)(64756008)(38100700001)(54906003)(8936002)(186003)(5660300002)(66556008)(26005)(66476007)(66946007)(66446008)(76116006)(86362001)(6636002)(478600001)(316002)(2906002)(52536014)(9686003)(55016002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?eciJqHI1d1b+KIvsms6EtOaZySVVO4CpIY6RrOP4YtR6Kq8mfCL9wi8YXAEo?=
 =?us-ascii?Q?eN/embWRlyOPQ6de5q2rM58ZCkbZSUb82goUz/GOtgpHLqRSY4V0XO2J59SZ?=
 =?us-ascii?Q?VVFgwMcFH/IYJ6FpugSzAOVdZPV34xNg1dlTcB4P09/reVOocduw4JvBDjX6?=
 =?us-ascii?Q?4aBxWluHrVOPW8pKca3LEkfET8lLQ1PxHIPvXQty2wVIN5MhdPzjDnY1ykrr?=
 =?us-ascii?Q?T2XBW92+Orzlfix6HkNk8rifR5nxPpBJN5vSmisCRfYePfWOlUR+/3ZPtQPU?=
 =?us-ascii?Q?J15wb0cv4R7QfmUtanEcmW4kenpZKTys6gz5hA65FWu/BI4CRrFBNrMZhlzw?=
 =?us-ascii?Q?njEfxl3p/YrOCPsO9PyQIqwX/E2RKyGTwj4fD4j4NRPnnHzuzlG5KcrDGvV3?=
 =?us-ascii?Q?iTE6GFxf4SdomW0RcKX3wW+An0gfrZH7SHqDQWz1wdIe8BjoDM7+8i+g+1Aw?=
 =?us-ascii?Q?yWxnoWoQ+tli8OJye1pjbstVH6+UtjB0t5PXYXsd3SqA1YJ/lCJiPfM5ByzQ?=
 =?us-ascii?Q?ZR8n4o9i5QTR/14grhyc3FXscAiGZw0dH5U9Bfm4N5lQWZ58o6S4c89tQvTp?=
 =?us-ascii?Q?J7h9S6snHhDQynIJ80DBrCYNQLWnhA0uxheH9dmOO1/mlBUPhwqzn8lFlozv?=
 =?us-ascii?Q?Vsa/fg+fvlDYjIskMUAB7nhgeHrVysw7LXoujCT158ItuuvUggOj4trAt7he?=
 =?us-ascii?Q?Ba/Hf3nHflfe5A/mCEN6ShZ/WLJDFp8LcO5/FZoG1C0eCELgF03xvus+zRQP?=
 =?us-ascii?Q?wn5m+d6sNb630CDpc6IgCngE0EjH2cq0pdVtMQ+/NwGyz9k6gb7EUDyf2gQj?=
 =?us-ascii?Q?nmpaMK1HX9eHCD1hgOCg724tpexMQ2xieP2vCn8UQ5o8zlqav21ac0kd01M3?=
 =?us-ascii?Q?z1ttOMH7mvX/PgMlmefwx8cWkaExi+dcNt/2oNZXR/gfF0CS6ebGkcuw9BzU?=
 =?us-ascii?Q?HmY0Nniampb5q+1aYwMkkaXCx/1U9BcMjAiXlgDC9nVz01YI9r1N5BOcRhH0?=
 =?us-ascii?Q?M8blzfa4fGmr8LBNk1mrVHCjc/hGGXZGuBscm/krC4y0NJK10UE/vi/ESJjG?=
 =?us-ascii?Q?xMiS3z4gknf33kcOLnr6ZIECbCx8nK2QDJ7bTRIMOFjDXZLiyI8OUFB7ivb+?=
 =?us-ascii?Q?rVtRU0cEksIcFdhoztGohhC/GyQ2/YAHNpgCbTlVdYRblv/gwKi+e10mEA8S?=
 =?us-ascii?Q?LW8vDZwBYHgY+3EFNdYGfoFelJBPY05a4lomts91l6ADa7sZGYDyOpebxFoc?=
 =?us-ascii?Q?+KOtSKKsbuDzKMbfvm+FDwztYr1XHHiCm/bBNYgEsosRL3PysZFiHPb9nu2Y?=
 =?us-ascii?Q?uCDoi6Xq4oy2Yn6Cj/E4QioM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4071f901-d4b2-4a88-5b10-08d8fb5360db
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2021 12:31:19.6222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CWm8dj+N9hpAN0IwRER78TQNIfn88AC830gzdm5RbQ6qnuPPTXBCmwApmGUcJjrYl07/nZlp8VlTESAiDC1kFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, April 8, 2021 5:46 PM
> On Wed, Apr 07, 2021 at 03:44:35PM +0000, Parav Pandit wrote:
>=20
> > > If it returns EOPNOTUPP then the remove is never called so if it
> > > allocated memory and left it allocated then it is leaking memory.
> > >
> > I probably confused you. There is no leak today because add_one
> > allocates memory, and later on when SA/CM etc per port cap is not
> > present, it is unused left there which is freed on remove_one().
> > Returning EOPNOTUPP is fine at start of add_one() before allocation.
>=20
> Most of ULPs are OK, eg umad does:
>=20
> 	umad_dev =3D kzalloc(struct_size(umad_dev, ports, e - s + 1),
> GFP_KERNEL);
> 	if (!umad_dev)
> 		return -ENOMEM;
> 	for (i =3D s; i <=3D e; ++i) {
> 		if (!rdma_cap_ib_mad(device, i))
> 			continue;
>=20
> 	if (!count) {
> 		ret =3D -EOPNOTSUPP;
> 		goto free;
> free:
> 	/* balances kref_init */
> 	ib_umad_dev_put(umad_dev);
>=20
> It looks like only cm.c and cma.c need fixing, just fix those two.
Only cma.c needs a fixing. cm.c also reports EOPNOTSUPP.
I will send the simplified fix through Leon.
