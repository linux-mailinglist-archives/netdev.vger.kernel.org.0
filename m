Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F79135937A
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 05:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbhDID6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 23:58:32 -0400
Received: from mail-dm6nam10on2098.outbound.protection.outlook.com ([40.107.93.98]:4032
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232941AbhDID6b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 23:58:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIAPULx9F6z2J2/Ak6kxNhZszAvo+Zg9yN5TZLLF/AZt6uTgrlSos7Joa+qSGwzWN0jCkm5aVks1vgcNkPgPCIPIzInHNLIs0TDm9/IM/AH1KWEzfVvj2HJYy7aJCOmB5W72LA4lyyZP8DwOt1nr/AzBealrZyxCI5fjbkzydrMsmbVlZAR2/wKZMXZbNJ6toyY+5dDu1AwjUWHpTMCh72PQPza/5TrWJ/pvubvuKulkGIQcYmnRZvcvRiPse6O1v8Rzd45CVM5vToD3W9z01cA+kDpy8FNdJv6UPUj7GN5UxAPMMCb+mjkG6LDuZj4QagqK+e4YLrzHReCJj1+BDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a1CJLTivzUJdg5y0pAZKF6H0VJPzmOyk1dAxlnwqqvk=;
 b=NK5aUg9g9I1iljra8yMYME6qW8WJlc2eLPI9fYrqqpOBiRcXWLM5K2sFli5+9EvrfKFmVKFg7YAQtzJDGb6m6xkVUpSx3r+bMplsbgUf1Wfv9af5PXoJAQ5cBKHUDlNheUzj0JF5jWVHs+3tHxmRx9Wbts+m2+CA3g2MasQikALVTGZUY40boq2YVPJ1fCywtzktyfXGIqbB9y+sivjoEWL4TntbLFj/jY5+B0FgaqSH1qiTgrB9bCsmIVcCRpDkSmCo0w7DIam6ToMfIwGDu5tlD48zZW9zngG6UUpbYstWw4laPd9XuTnVwfrD/CpRZfT28vB2GAgFc9nl5CQSnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a1CJLTivzUJdg5y0pAZKF6H0VJPzmOyk1dAxlnwqqvk=;
 b=HSGwRMP3KlXP7sKMo3C7GmJU/gP6p4fX9PPdPKuVKD7FmZ2tSyJ+WUi7Vv1StSoiMj3E5soNs6AcJcKuJmoAcw/xFGLL7BGin8ni8hf+yj12bSXBUwgQ6tnN4HRrpzwIZqQofrvmkb75gD51HUwm4fbYRmBLh7t+b2xrkL8zMZg=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com (52.132.20.146) by
 BL0PR2101MB1332.namprd21.prod.outlook.com (20.177.244.146) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.4; Fri, 9 Apr 2021 03:58:17 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::e015:f9cd:dece:f785]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::e015:f9cd:dece:f785%3]) with mapi id 15.20.4042.006; Fri, 9 Apr 2021
 03:58:17 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     David Miller <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
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
Thread-Index: AQHXLMrI7wVTXonSwkuA82YgYLN/76qrSScAgAAKxoCAAASdAIAANLMw
Date:   Fri, 9 Apr 2021 03:58:17 +0000
Message-ID: <BL0PR2101MB0930523DB18C6F1C1CA00A89CA739@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <20210408225840.26304-1-decui@microsoft.com>
        <20210408.164618.597563844564989065.davem@davemloft.net>
        <MW2PR2101MB0892B82CBCF2450D4A82DD50BF739@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <20210408.174122.1793350393067698495.davem@davemloft.net>
In-Reply-To: <20210408.174122.1793350393067698495.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b3876ea6-8413-47d3-a6a4-0fb00574380d;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-09T03:49:59Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4263779f-dc6d-43ed-32ce-08d8fb0bb4eb
x-ms-traffictypediagnostic: BL0PR2101MB1332:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB13328C6772CCEDCF99F0BF5CCA739@BL0PR2101MB1332.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VY3wUsnYcraOMwRosLXAtP+FVTPpRI9ASy9iej4wBCSIqL5U/boygSnB5Wbp5B3MQ8+DrH8POjPzz2D2WBBqJYKLaV3M5TO5/b0R7lcjcAnaXKOfPUU3yygW4QBAfpFXyb1+2xO8Ah36bNmxdpTMrM8UJ9E8akg/9xEIIk5a8WtO2vdwC/Y9Uq9LDPKpyTe++9/1JmRjPOfiY6pSwsGnG1/fSseHHZgzXmepd1d3D0zqd0UWyapCY8iOqhxVpdUa6/y+O6sR0ZaVulGnmveb7XGGOz7PE6HUuVmMfaVhFCxs8JEiEKL6oc0SZN7bumQxJmMho/8KOqNXnYU3uVVcrUvzAe+1yZGxQ6Zj+al/Pjvdx3DB8hUHdPb5br6zmiba729WTIX0QlMIlHUUXwZmbrFi7y7KuNV2MuDK9Akun2jNVp8UN0lYilkpNjmndHSxvdmbr6nnfhUoJlNpyuzemM2w4yd9THMj93e/1UcX6uPwOIAYKMBqVWI4fDfn/wiLGbMXQXG5UrEHrKjFjt3BnAGXmQ4csviXUR0WVGbeIIV9n9DJpMxhQ5kw4pxBBsaPSfW5TPqbekuBLVJsCRLOZhwDaIX2OhDvHM54XCWOUdmquRiyrybBzovjE8hVa8Q3ppgBr0cIisz7gm5tXa+aNrtO1hBx1mFMNBLqZIdwYZDQcqyM1HOPoPKC71D+7IKN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(346002)(39860400002)(366004)(47530400004)(54906003)(53546011)(110136005)(186003)(7696005)(26005)(6506007)(2906002)(38100700001)(316002)(86362001)(8990500004)(82950400001)(82960400001)(52536014)(478600001)(83380400001)(64756008)(66946007)(66446008)(66556008)(66476007)(5660300002)(76116006)(4326008)(55016002)(8936002)(8676002)(71200400001)(6636002)(7416002)(9686003)(33656002)(10290500003)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?WqCjmg7wUeX4v/0BaFVobp4PsVih+BczbNPp8//Mm4J6LtawYOZxGk+R0XPk?=
 =?us-ascii?Q?Kg0P48/ZmpsB1hWyzbKOacRJ99gW9iL9kCzxmSC4E7lRdARRT05fPnI+iH6v?=
 =?us-ascii?Q?W4gAkpf+74ks/IxbDnk7gRjwGi4VuC7mzXlgYDcFVg9XnH7hrtCEZp8Vn5aq?=
 =?us-ascii?Q?n/uHnUw5ReL89vlGmfF0/GZG3dG057kM/RrOBuY/HvDYSHV/dlyd6DPYjyvc?=
 =?us-ascii?Q?pXAwyiPxwhidwXwGaji4Karz3845lptO2JBJoqT7P7iPkdxOalOFIpRoiJc3?=
 =?us-ascii?Q?cnR1wbDXXy4yba9EFEdq1kTZ5FwzVM9vYhdYcj5mfLGObJ9UtJrtCPO0Miaj?=
 =?us-ascii?Q?tuB3IHpOprGBpJC9aFQLJ/Tyjoz8MR0/PSCjjSS0osT1jX7TxlRqmakGCsg5?=
 =?us-ascii?Q?+ms6Xv6HQvDe05jJN4KuCCArzkESA7VGXeQidiHb+Nao56lt25OBkSzVF0Lf?=
 =?us-ascii?Q?y3RKcfKKLqqMkQH+s5+PeoH8BX05BaiDybTU+BG0Orwy4q3GlsAoTgxUuJOl?=
 =?us-ascii?Q?HJAa988QdPydmEaZo0Am2aQwAv4j3vrWqIv4RA9WYnWCzPEQ6aGtcrfoq1JW?=
 =?us-ascii?Q?PNTj+e5qAZKAg8/+prnfXpVf8dcl+xlJgaWHmpy3HfnMam3wE8QyrcDJRUfh?=
 =?us-ascii?Q?E9WW+f4eaFhT7bteNi0+BoefI1XPvij85QiWNX2H4TscnZdKrnS9X9BFfMUe?=
 =?us-ascii?Q?sjfcYayLt3EQTKxwE0mGZOARG8uSJDXwx6a6/4gy3c0qzo2NXLkydq70tUHN?=
 =?us-ascii?Q?Nj8xb5zLhdOdETxiRm4rqgVpvJpE8T5gno++EgvI3E5CK06fUeGH+oFCHsAX?=
 =?us-ascii?Q?j6jCSE1g4my1X5l4ZWiybXjd0A9qlahb7STXqBRBYXD3io8mPRIJ4tcch1hM?=
 =?us-ascii?Q?g572nQt9ahd+Pm+KfB4cklnNjzuVBKA9+BXMiNiADgKgJ0nzRmc6Itv7U4Uw?=
 =?us-ascii?Q?z9TeJW4SjExTXf94DaPuHOCO0vnPf0kMlnYrJz3+92u4C0nmAl/9dFaIKSN0?=
 =?us-ascii?Q?qzy1Mn5VLCTL4Olwj8T9UDAzdAwxid0W8PdIswzkNKG6Dob17zPTsDbnzZk8?=
 =?us-ascii?Q?Y1tXgiDymjnCDQj0uHSilnATIsp+X91cRAlpv2k+5gbAYj+0xctPmsch/l3L?=
 =?us-ascii?Q?hQOPIXTRR3PA4CzvnQl/L9L9BOOlrsb8CBY8WevpAeLx/k9XrRPbEB4Lx9vw?=
 =?us-ascii?Q?Gbe7Ms2ntgwOL7aMdt6Rr8ZUoiM3nkUb5iLBHHHGs/3Wcp+BHmcmbpfaPxo3?=
 =?us-ascii?Q?Rpfg94L4j53v6nXtOVZ20WIsKutuV4BE2vRq3xt7BEKeOShqI/e0cPs8e9Wn?=
 =?us-ascii?Q?J1FkTR/MgSjk+WhkO3yLL44V?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4263779f-dc6d-43ed-32ce-08d8fb0bb4eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2021 03:58:17.0540
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7SE9lAOyaLoIfNjFe1ffS2VU4OKqAJK7sTe/eTOMn+kbwWF9wqKLWt7UIAvg2WnFPMVNl3IBlovImpHeLiriLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1332
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Thursday, April 8, 2021 8:41 PM
> To: Dexuan Cui <decui@microsoft.com>
> Cc: kuba@kernel.org; KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; wei.liu@kernel.org; Wei Liu
> <liuwe@microsoft.com>; netdev@vger.kernel.org; leon@kernel.org;
> andrew@lunn.ch; bernd@petrovitsch.priv.at; rdunlap@infradead.org; linux-
> kernel@vger.kernel.org; linux-hyperv@vger.kernel.org
> Subject: Re: [PATCH v3 net-next] net: mana: Add a driver for Microsoft Az=
ure
> Network Adapter (MANA)
>=20
> From: Dexuan Cui <decui@microsoft.com>
> Date: Fri, 9 Apr 2021 00:24:51 +0000
>=20
> >> From: David Miller <davem@davemloft.net>
> >> Sent: Thursday, April 8, 2021 4:46 PM
> >> ...
> >> > +struct gdma_msg_hdr {
> >> > +	u32 hdr_type;
> >> > +	u32 msg_type;
> >> > +	u16 msg_version;
> >> > +	u16 hwc_msg_id;
> >> > +	u32 msg_size;
> >> > +} __packed;
> >> > +
> >> > +struct gdma_dev_id {
> >> > +	union {
> >> > +		struct {
> >> > +			u16 type;
> >> > +			u16 instance;
> >> > +		};
> >> > +
> >> > +		u32 as_uint32;
> >> > +	};
> >> > +} __packed;
> >>
> >> Please don't  use __packed unless absolutely necessary.  It generates
> >> suboptimal code (byte at a time
> >> accesses etc.) and for many of these you don't even need it.
> >
> > In the driver code, all the structs/unions marked by __packed are used =
to
> > talk with the hardware, so I think __packed is necessary here?
>=20
> It actually isan't in many cases, check with and without the __packed
> directive
> and see if anything chasnges.
>=20
> > Do you think if it's better if we remove all the __packed, and add
> > static_assert(sizeof(struct XXX) =3D=3D YYY) instead? e.g.
> >
> > @@ -105,7 +105,8 @@ struct gdma_msg_hdr {
> >         u16 msg_version;
> >         u16 hwc_msg_id;
> >         u32 msg_size;
> > -} __packed;
> > +};
> > +static_assert(sizeof(struct gdma_msg_hdr) =3D=3D 16);
>=20
> This won't make sure the structure member offsets are what you expect.
>=20
> I think you'll have to go through the structures one-by-one by hand to
> figure out which ones really require the __packed attribute and which do =
not.

For the structs containing variables with the same sizes, or already size a=
ligned=20
variables, we knew the __packed has no effect. And for these structs, it do=
esn't=20
cause performance impact either, correct?=20

But in the future, if different sized variables are added, the __packed may=
=20
become necessary again. To prevent anyone accidently forget to add __packed=
=20
when adding new variables to these structs, can we keep the __packed for al=
l=20
messages going through the "wire"?

Thanks,
- Haiyang


