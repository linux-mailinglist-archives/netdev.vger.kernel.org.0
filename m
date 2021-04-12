Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1666235C904
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 16:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242621AbhDLOkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 10:40:12 -0400
Received: from mail-dm6nam08on2130.outbound.protection.outlook.com ([40.107.102.130]:24033
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242424AbhDLOkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 10:40:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OoNWRlpDrzEzgTyscKfUSB2xIzN/gPKzyypXyeM+oF5or6MCUkDusjk5dNqxq4K93T+xVtapmyZqRqbVXwaklRLtkoWfHuNDRaJ1oiqX+emwEJuSDAxHtKE9NVxB+SYdaNFhKf1le1WANfrrUyIUX0F7GKP2laXZ6CmDpvT2gszEv+0qYg343lmCaB7Dp7pN7jqYBVAhWXj22CLhbID2orKiiSD5kaHGdPndLwejKMI8/CqWg+alnOVKSRnoGZOJxed4td1aOJe216l3zJDTlp87ThOsTDaSnRHGgqC5rzq6decMDMhADh2ewQQxW10y1r8vPXCdZhhmQj4YeP2Hrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7ToqAdUZWiL/BGzENI0Tdhi2/DeotWsMeVmCOxPVlA=;
 b=IXZZaBmw6++4/sipEE34lhU9jbe+jnO40kDBz7wnCoHaXQFDdJ3gIa7q2uZMywQKOIBPRIUA3suVrNzowrljlUdx0FEddO1xwS+wu/4PjjVzYaYcsCkc2rU5VXRJxGHk5VUBrtDozKAEBCEe+lEYqOGDdId4dXqvC4zJ8+Dd7mBUyMndk8dWP6rZZBfvOeys1v+YXQMKVXAMLLtqTeOIrhgJ7RD8NFBXqJRPa1vazkVEqABVqSf7QCuhB9A7MxtAj9TgBZleDO5nsspAtXIsTFNjPvPHq9d5lrZeD0sdFZaov0eFg1qfOA3B0WDHCqs687KJhJxh3QQutOJSB7x4zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7ToqAdUZWiL/BGzENI0Tdhi2/DeotWsMeVmCOxPVlA=;
 b=KZj4oPDLL9X4FcupLZb6/jMI0WNrEuGA01hVqNWZ9BHnONPhEXaTBa1i18MEaCBfLzzsBlkOAnhr8lxRlKtWsAU6/12AAbU1Ev35GqimLXEmq/vlOnXef8VNlpBbeVjCTfV1xNVj2KEklg3e0HdRorAgMNUI/8Gfvl/Z0Ohc/xc=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 (2603:10b6:207:30::18) by BL0PR2101MB1074.namprd21.prod.outlook.com
 (2603:10b6:207:37::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.4; Mon, 12 Apr
 2021 14:39:38 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::e015:f9cd:dece:f785]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::e015:f9cd:dece:f785%3]) with mapi id 15.20.4042.006; Mon, 12 Apr 2021
 14:39:38 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Andrew Lunn <andrew@lunn.ch>, Dexuan Cui <decui@microsoft.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v4 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH v4 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXL0SFh9wLy4oIlkiyQnUE9FecFaqw0SIAgAAha6A=
Date:   Mon, 12 Apr 2021 14:39:37 +0000
Message-ID: <BL0PR2101MB0930AC7E5299EF713821FC76CA709@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <20210412023455.45594-1-decui@microsoft.com>
 <YHQ9wBFbjpRIj45k@lunn.ch>
In-Reply-To: <YHQ9wBFbjpRIj45k@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f9c20ac4-18ce-4841-81fa-9dee29306b51;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-12T14:31:36Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fea249af-c47c-4361-06e6-08d8fdc0cc8b
x-ms-traffictypediagnostic: BL0PR2101MB1074:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB10740CD5A9937BACEF8C867CCA709@BL0PR2101MB1074.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DGlroXE0PWvdDvox6Ynddo98oMrSph+KmplGbVJdzIl+kk1UGF5nzj6Wu+4t3MPup4saR/2zCp5+YhIhI/hkcge6mZDAEsk/kTCRUILHkr99F0BAqTWt99k6vPlbnhLxiZmir6Qqa0ARIVSUoNz8XaaJk6b4ABQDvGu0ePLxp4CshK2uAIIGWuCgud2YJvkcNwPWOJ0hYXwqq3jMnfwrQif9KnwBQ/0KChIbFsHegLPy1TdRFkZ3nszX+O9kIaLtICGBNCsTMqAN54Ja2WWbckw8mLooGN0mv+YFFQcR1zftNJ4/fwSpOmaADBOejn/GY9YWanx6nuBqRBQn2OUH0c04/z/OKJHO57kQzv756r8LDl30ds2W4W67rSTt4myUzvLb/Eg4x5Uzu6fthR03Y3J/nXaFZcKGENyGq1uBaGsN3KUGtQmiQ+TpR7EVyXGgLByZIDuZAFERYZ631yZlyxBZNXLglmQpkKe2bhSY2P4MeogbegyjUVX2nYaKWkcNhSeumFa9dE5aZH4+wjfEGboQJsn8L3GNZ21OimGWSv9I02TXjVfmbENngozVNFTNXREBth7Nji0Id7Yb0w0lmfT5mrGwryoTHh4dx9+5Vwo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(396003)(39860400002)(136003)(47530400004)(9686003)(55016002)(8990500004)(33656002)(478600001)(38100700002)(8936002)(2906002)(64756008)(8676002)(4326008)(71200400001)(76116006)(83380400001)(52536014)(110136005)(5660300002)(316002)(54906003)(86362001)(82950400001)(53546011)(26005)(7416002)(66446008)(82960400001)(10290500003)(66476007)(186003)(66556008)(6636002)(7696005)(6506007)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?p1v0p4aVZysvLaXW6Q/Y5YEOKEahl011QcnD+mCpuanBhRchMMeSmzH5aKd1?=
 =?us-ascii?Q?78FIfHXvq8IkcG5i/7I5Logz0WVJICoQwO+06JM7g6rF2K0hIA2Cgb/JvtC4?=
 =?us-ascii?Q?/6SMa0sV007da9SGQNyD2Fim06/XBKX8aWz7+oSKj5jf9fIBeduY3Bo2HC80?=
 =?us-ascii?Q?ThyaS6OgrcGSGNqGjayAadGbBp4z0sl2X+Mg1+gpPDrlAWJf7i3T7rl5gGbq?=
 =?us-ascii?Q?nilKJK+4aWm/k0RoLGk9UTBfV3VDTmyF9p6TBMg0F4wcnjeqf+3M158i09xD?=
 =?us-ascii?Q?m/uqTKHTdNTWH0ZfwPbplIIlWHRrIZfYKw9H8wkB0lk5JVJoXBtxsjnPplYc?=
 =?us-ascii?Q?22+6wPX8/qQxchM3m/wGYaCRhTJU7LMFIPBursran3erXWmp+fwYrIocNXhq?=
 =?us-ascii?Q?IasDL36/18I5OPDzvN4aeFQpW3rptcmSVhEGdfJ6rLdpiYMJXcEFdI+sMLRs?=
 =?us-ascii?Q?arW7pr+94O2W0nYRvOAaVpfuKHXFKTh/mQAOXQUExsALGo9ESailFRDp/82f?=
 =?us-ascii?Q?L9lsJhGrZ2LYMh5+4+7lKu7aP5fesBRAgJchwMiOmW/6Lxi4rAG3twPN8/ie?=
 =?us-ascii?Q?abPu1Q9351TguQW4k8NtU6+BkLsarJL+GFPDNsF85gOajFb4YTM2EbXVKjaH?=
 =?us-ascii?Q?HDWmXyHDRP8QhW7JHUjsgg9eTZQTnTzIW/J9FqhYJxZDDGjR9GlSgwrDBSP+?=
 =?us-ascii?Q?kkgY74NuAZIYSWsJKFdFmUOBoRLkXfKCt5aOG6SxUq10vENL9gphWg0uOBuK?=
 =?us-ascii?Q?LFz4w7GMe37S1022M6bdLMsSOXKPcKYijzntsJcsZwXQZzZD6Yo512ff8V9O?=
 =?us-ascii?Q?MRxPhuocnae6NeCco+K9qE9mak3laDJKor3Nz9fbreeTFn+IcrXpjua5hxzj?=
 =?us-ascii?Q?pQ4jKUB1kWt21TqEPqjHWKcq37o8c4xLSNe4miKiTiM3iTiJ3kY1WAR20OYa?=
 =?us-ascii?Q?4EYWkuFFJTsPhmsSYBmj4GsNP3t9C5flUMf9OPXRKsHW8U1H5JMHXAlsE0+Q?=
 =?us-ascii?Q?bUevltl4WG+0Eyug23bm87o5OEJuvf7zNhcjrB/lW8cZIsRZCXSEM8yqejuk?=
 =?us-ascii?Q?pysfZbIBkT31cJUBW5sVbMD4ov6NIyLwN7Fc2yaoSLye6M/QVDuP0ITDl3vK?=
 =?us-ascii?Q?JkS50E+S0inqE/OpiwSkLcJGHjUGS6H6Dl9tkxA6hviwHsDlfBmRB1ll9FJN?=
 =?us-ascii?Q?RCc6DRbQbXyab3ct0YzeLQvbEbwSjdi9k7MW9m6IfuvOGsEDbqVBF5YL+7l7?=
 =?us-ascii?Q?8rsrJ1IGlTGitvuSkr/ryhR7B/ecXpDts0Yg9tIyYuR3AlHtlMjid7wiMQWa?=
 =?us-ascii?Q?3iCHR4WhQeQ1VsDTXjvLEMRi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fea249af-c47c-4361-06e6-08d8fdc0cc8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 14:39:37.7588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H0zK0DrakG61jMBktbRoNVvlCz4dVqH0Rue9oSMBtOmXLSJR5DgbOjJOtjTuiFvk5Jnq++wX8/Y/DiKIHoShIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1074
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Monday, April 12, 2021 8:32 AM
> To: Dexuan Cui <decui@microsoft.com>
> Cc: davem@davemloft.net; kuba@kernel.org; KY Srinivasan
> <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; wei.liu@kernel.org; Wei Liu
> <liuwe@microsoft.com>; netdev@vger.kernel.org; leon@kernel.org;
> bernd@petrovitsch.priv.at; rdunlap@infradead.org; Shachar Raindel
> <shacharr@microsoft.com>; linux-kernel@vger.kernel.org; linux-
> hyperv@vger.kernel.org
> Subject: Re: [PATCH v4 net-next] net: mana: Add a driver for Microsoft Az=
ure
> Network Adapter (MANA)
>=20
> > +static void mana_gd_deregiser_irq(struct gdma_queue *queue) {
> > +	struct gdma_dev *gd =3D queue->gdma_dev;
> > +	struct gdma_irq_context *gic;
> > +	struct gdma_context *gc;
> > +	struct gdma_resource *r;
> > +	unsigned int msix_index;
> > +	unsigned long flags;
> > +
> > +	/* At most num_online_cpus() + 1 interrupts are used. */
> > +	msix_index =3D queue->eq.msix_index;
> > +	if (WARN_ON(msix_index > num_online_cpus()))
> > +		return;
>=20
> Do you handle hot{un}plug of CPUs?
We don't have hot{un}plug of CPU feature yet.

>=20
> > +static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue
> *q_self,
> > +					struct gdma_event *event)
> > +{
> > +	struct hw_channel_context *hwc =3D ctx;
> > +	struct gdma_dev *gd =3D hwc->gdma_dev;
> > +	union hwc_init_type_data type_data;
> > +	union hwc_init_eq_id_db eq_db;
> > +	u32 type, val;
> > +
> > +	switch (event->type) {
> > +	case GDMA_EQE_HWC_INIT_EQ_ID_DB:
> > +		eq_db.as_uint32 =3D event->details[0];
> > +		hwc->cq->gdma_eq->id =3D eq_db.eq_id;
> > +		gd->doorbell =3D eq_db.doorbell;
> > +		break;
> > +
> > +	case GDMA_EQE_HWC_INIT_DATA:
> > +
> > +		type_data.as_uint32 =3D event->details[0];
> > +
> > +	case GDMA_EQE_HWC_INIT_DONE:
> > +		complete(&hwc->hwc_init_eqe_comp);
> > +		break;
>=20
> ...
>=20
> > +	default:
> > +		WARN_ON(1);
> > +		break;
> > +	}
>=20
> Are these events from the firmware? If you have newer firmware with an
> older driver, are you going to spam the kernel log with WARN_ON dumps?
For protocol version mismatch, the host and guest will either negotiate the=
=20
highest common version, or fail to probe. So this kind of warnings are not=
=20
expected.

>=20
> > +static int mana_move_wq_tail(struct gdma_queue *wq, u32 num_units) {
> > +	u32 used_space_old;
> > +	u32 used_space_new;
> > +
> > +	used_space_old =3D wq->head - wq->tail;
> > +	used_space_new =3D wq->head - (wq->tail + num_units);
> > +
> > +	if (used_space_new > used_space_old) {
> > +		WARN_ON(1);
> > +		return -ERANGE;
> > +	}
>=20
> You could replace the 1 by the condition. There are a couple of these.
Will do.

Thanks,
- Haiyang
