Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF453590DE
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 02:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbhDIAZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 20:25:06 -0400
Received: from mail-dm6nam10on2117.outbound.protection.outlook.com ([40.107.93.117]:16352
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232488AbhDIAZF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 20:25:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SfwPQyhuwCSs+wM6N2o6eXL+OOWz7IHKEgIEiC9B9w56SThLNqW0bHIeVjlgiUlYtrchulJXmBHeKLCiItmIzhLz5iJ8lES9bnnLjfIHefOxs+hYxN4dpbL+v4EgwjkDZHS0SGKHewHLCmnDdT2XDiDzVvRxBNy7qpRDN0Cp+ebIPzh9eBrMZ+H60uL6L00o4A2XS55YWJPlmdm/4mwptZT0rNxToOiQK7xd38teCGQ0etI5tIhbVX1BFWgCgAzV24i8qxlFAzRjWj3/8sy86XNj6u/YNY757NTv2uYWfFb92WgqKYmjHgtwBxkZlCHd2YNC47pDaRSfvTz6Hs5aYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ljLVMJNrflCvoAXOQXdrvt+7pSdVvtF/V0+eK7Te95U=;
 b=cuZAl2YQLQv96nVpPnHZiMPIfHfIKLhFKdZb6qI2jBe7LfNpSKt005398VmhAec5jWIBgN+BjCnDMiIOPpDAycYHZKdGfvTKWBqqdb3FH9VEL8Nhnue85iKtPLQOhxgNASqVYf4BTf78npyaGjUoHq1kMDZ4A4+SAXGosiMwPgk3uohcVIXXwsSdlpoM4Km+jPXKWqvlLSXFXlnvsJRWvOguy3Z1dW0SUyNbJa1qOSkUC4G6Osmcp/NXttg9YOysRm0eVa2XqRqUeTeHktp+p22CLy59S2NN7b2yz3QubREItiLJie4evRLfve2XkTo7sU6uYA+R7NPqfMZLSjhsZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ljLVMJNrflCvoAXOQXdrvt+7pSdVvtF/V0+eK7Te95U=;
 b=dNdDXfO/hZdCqofwhCMyLFbYjlJifSWyVOlBiOsXmkY8jH8LP81Y4tKOAQRZurqrnyu5mujgdM9JtpWf74HTYrkJF5shmglqfmUdn+0uM8AQkiw+qKcYB50Jc4yz3t6vAojMLHcId+HffMYj4Y5Ey6B1YrlqoaKRgpQHWlD/b/o=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MW4PR21MB1905.namprd21.prod.outlook.com
 (2603:10b6:303:7e::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.3; Fri, 9 Apr
 2021 00:24:51 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%6]) with mapi id 15.20.4042.006; Fri, 9 Apr 2021
 00:24:51 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     David Miller <davem@davemloft.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v3 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH v3 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXLNFkZWy01RJh1EWXtFcKc+4EuqqrT01Q
Date:   Fri, 9 Apr 2021 00:24:51 +0000
Message-ID: <MW2PR2101MB0892B82CBCF2450D4A82DD50BF739@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <20210408225840.26304-1-decui@microsoft.com>
 <20210408.164618.597563844564989065.davem@davemloft.net>
In-Reply-To: <20210408.164618.597563844564989065.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=718988b0-567a-42ca-a84e-a5989b14df65;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-09T00:08:29Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:adc1:3ae7:8580:9c8a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2728f939-a2b1-49bf-edd3-08d8faede45a
x-ms-traffictypediagnostic: MW4PR21MB1905:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW4PR21MB1905523F5FC5873B492F4F71BF739@MW4PR21MB1905.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xoFYWoTdo6lAy33lLml/sWVD12/z75n/c8j2Rf5wFF/qADD+aht+xENQ+HLe53GqOons1uLHCUhfzHKUXqaWY5C+SdO0PXqqJHLfwb/HutNY0oE0nffPLfTkV+uDWpgLabHGRWuuxPFuVosuo5e/SlrQSPPcpEtLhNRupd3pLcaYpqgvjSBYm8wyGoCsdBFj9owBckDDZBRFu+fb2YK6DheApc2q1XXtixfzLcljkRcx70n9DFcAYLLAvgaIEhQs47EJQ8idnq0HwYIJSFKCN7L9L572wGyXzy+gmqfuehv3SHQhwBD/86gA1GqNSUcWovFgkrh8JrOR6KTOLxqlfoDwZ8HgVxCl36QkCkwFV5I2ftT2dSdtPteyfhX11V4rVIMZCbLFnuhac0t0BJT1whkw7wtljxsWJR+DO9MM16hqaLAPcoDGGo6+z9GAojzmnSjpHDax0F/CJnzjGwGXndYUYFZoiUDiFoFjlzh97NBNMsRJG3UKAx97uKqJ/hs61OvSbOYG3vDz8/RbonQ4We2lwvfaQs8ycX0CQdAMjAtH2tSU9ZQ4z5370YfZDza0QNQw6yphl1Uy/RcHO4PHbUIqkltv43ZO0MuTffYsRlxlzGJNVMybYqiXnXDZLe9PArlN/dXYCvNMo+cLbbAkVTg3OTgVrs8iLNy+rzYhyPX/fr7PmX6kXQL5lQFj0Sza
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(47530400004)(186003)(83380400001)(7416002)(66556008)(66946007)(64756008)(66446008)(8936002)(7696005)(66476007)(82960400001)(316002)(8990500004)(54906003)(478600001)(6506007)(86362001)(10290500003)(4326008)(38100700001)(5660300002)(71200400001)(76116006)(2906002)(55016002)(8676002)(33656002)(9686003)(52536014)(82950400001)(6916009)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?pW1KYNboJZ6YrPezYUvZkoMA/cgM9VUbEVTC3lnKl3BpxLxCOM41+3vaNEAE?=
 =?us-ascii?Q?du/rQsW0qD5CAtRRKhm+DM6k7MjGCoQqHNpdm16HJPsXKnrjL82baRuNc2jM?=
 =?us-ascii?Q?mitfsxQH+zRlj727y8UkNEXDvZCVsaCicJa+EkVGqu8aq0A6Zdbu8ucYft8U?=
 =?us-ascii?Q?pJE2PcI9d44iCGgnY1qddwgAWdd6Hcm771mh5zSCOTKNfK/GNmkdKuE8y/1z?=
 =?us-ascii?Q?gr0FmDwDdLKl0XKstoWtbbgQZkWeu74fKowr54Si4EPC+U+67xwaCXxHXjVC?=
 =?us-ascii?Q?Y1PW7DsAkLCXhjvwvRNBlaWDMPrZv2LJujwAl/pusZMo4zGhnLVpHozTeKU+?=
 =?us-ascii?Q?cNaKDHuS3EPb83U1d0TzlLKpZ1rah+ySnxisuanwrMJUievDF1CxsVhVgZhh?=
 =?us-ascii?Q?j82TJOrLxYaP4iNufpH+c8/+musxUlwkDePW84KGheSd7j9Yxff5Hqa7IGND?=
 =?us-ascii?Q?MFqGSN0SY7nc9Bm72HnUWJg4pKP5xaJDUwXib53JjOyJH2nHVrwvmYUFyjco?=
 =?us-ascii?Q?tSM4VbHluIRr1vxlSJgXGRQJR8uh9X0W0nCXsqXHYGEREn6yCX/b7BP6+APV?=
 =?us-ascii?Q?A6sb0cUdoeGFiIpkZ5hsqUAwOhwTeA9QTnXV5Cadcz9CzeK4mue4TrJJI0a5?=
 =?us-ascii?Q?a5xXpn6Q4PdzYnDm3CIhHa4PfXFA92rCcwo5H9FhzcjLBNA+CkPRYp4p5i1y?=
 =?us-ascii?Q?onMlg0pPOFcC36FKo9mSQNZVlwXd6m8+/LwOIBGmLxJc1SPDnuIZmRHq4m75?=
 =?us-ascii?Q?4k9NUf03vxgzlm2vJw4+MT8m4vElMWTwfJCLD4k+41LeeLlxF5KvrENgAQZp?=
 =?us-ascii?Q?RpQAx4kXaxzzXQgHEWfL6tGmeIyMDiDNeSG6LAbRQVUYQ0WYOqmdRVwD277X?=
 =?us-ascii?Q?6johcAZ/4CcjhQsz4Y5DxmqBfTBhXI4uEBISl1Z+hSP7LKZ8c/J386XpqLbC?=
 =?us-ascii?Q?CEc05ekIwrYeurZ0XhTCdV//7OK2SnNEYhDx8VipLRuh5MNbka2huiWdSqgn?=
 =?us-ascii?Q?OofPREoksc3YOL1StlVsq0yRe4YXwqbHEZnlb4H6VORBkOPyG9j35c2B1tTX?=
 =?us-ascii?Q?LcuDSpUE1K+CXJwPCpxFasAUUgcU0OByXRjhlZni1qlyltd6lGWq6/B7A938?=
 =?us-ascii?Q?k/WWVeYYKCNHdukB3qnf+7ntdZT56TV9JGQqqSZYViwyLx9wJDwIFboQevRT?=
 =?us-ascii?Q?zs10Bg/UNUlm+P9wuRxFlTt+Wy1xWw2kPwW4WNiCY6UKr8422mlCwb3hpkoF?=
 =?us-ascii?Q?smzIvcjGWFlur35ITYLe1nQ5BmqRD9ZjafPkSDMlc74IcYom+CNC4wkZ9I+B?=
 =?us-ascii?Q?sfoM7fMWoIRx6QOri0VZ2hv+s/WTK0ncBsAsj+no0KKDhpun7/mHsPM8KbLI?=
 =?us-ascii?Q?X57c3x1nP9VtiBXV+KKuTA3PRETJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2728f939-a2b1-49bf-edd3-08d8faede45a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2021 00:24:51.7483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gyWzFEyPpjkvyGaVikXKjK+hQRqBzRji+NvMHaup4BudVDIYj7rHwMF/ukU2xUqhiPu4z+8A/9Jicsgswsb3Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1905
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: David Miller <davem@davemloft.net>
> Sent: Thursday, April 8, 2021 4:46 PM
> ...
> > +struct gdma_msg_hdr {
> > +	u32 hdr_type;
> > +	u32 msg_type;
> > +	u16 msg_version;
> > +	u16 hwc_msg_id;
> > +	u32 msg_size;
> > +} __packed;
> > +
> > +struct gdma_dev_id {
> > +	union {
> > +		struct {
> > +			u16 type;
> > +			u16 instance;
> > +		};
> > +
> > +		u32 as_uint32;
> > +	};
> > +} __packed;
>=20
> Please don't  use __packed unless absolutely necessary.  It generates
> suboptimal code (byte at a time
> accesses etc.) and for many of these you don't even need it.

In the driver code, all the structs/unions marked by __packed are used to
talk with the hardware, so I think __packed is necessary here?

Do you think if it's better if we remove all the __packed, and add
static_assert(sizeof(struct XXX) =3D=3D YYY) instead? e.g.

@@ -105,7 +105,8 @@ struct gdma_msg_hdr {
        u16 msg_version;
        u16 hwc_msg_id;
        u32 msg_size;
-} __packed;
+};
+static_assert(sizeof(struct gdma_msg_hdr) =3D=3D 16);

 struct gdma_dev_id {
        union {

Now I'm trying to figure out how other NIC drivers define structs/unions.

Thanks,
Dexuan
