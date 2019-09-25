Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2D0BE331
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 19:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442760AbfIYRPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 13:15:30 -0400
Received: from mail-eopbgr150085.outbound.protection.outlook.com ([40.107.15.85]:38531
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2438404AbfIYRP3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 13:15:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kCh5qYEfmuXq2vwa7d4DsjkOWu0gSfhS0dJ+XCHryYdOxGxLJn7a6mmI/E6S8j7dzFv9pTBRTTB3mQVXn5+Hip7xXFQIPcIoIl5mz0FMlhYITNjuZFKDFXZiSBFjSu+78sTCpjpn5Uu+iPIgWI3Ex3k9xQSfaww0eZyeMORBuHHvlQKIITDKnscQPFI/IaApz0mcbV8axdiyp1v7LjzSRvYsCYdAg3BYldhxvUtLhIYe90qu4VBMOBwDPNCWXuwB+1JuIF1YosNLzrqBlT7x7PaPRI63b752NKq0FsXd7nFU2AU9T9ZefvVZ/Mb6YE/EhsNTwABT1oUJvqgUsPH2kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCiUNd/PF5+G5Wxz99pDwH7O3KwlWZwySRSUL4UMNQg=;
 b=Eu8jBsYLex9RpZToEaJM+ota9ig4oNPmX7V7Q9+aHGd9ALqUhtDk+gzIeXtP7omjp2zqWriUtvB9AtOgAr7qAWgqgILNa0iz3n14sWosQN2chqDYYmV0tDk2tVXNZuQjo7G32x2Khr7UYfELp6JsfHMH4HTFVnzs6yi7aP+iF7+Lj4AtqHbrfDiXLmkDQKvWfMKWMYnDCXy6IGv0A84ZIqFEk7/Sp1cvMqyDz3J//ZQ8HY0oqrzoWvPpLx3IUviOsOuCTRv4v5sItH8GEeGFXhinwpNsstkFchf97VX8nLpmlv6WF8rb+vHb9V4pdEkPY9NndDSwMwAAgkwl2CnBrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCiUNd/PF5+G5Wxz99pDwH7O3KwlWZwySRSUL4UMNQg=;
 b=VIb3cLHzjzN6nIPda2EPjjPBUONppAg1xyKApfL7OKJJ8wlehV54npC0ctenJGztyl3bCJEfjQ+psndxJGqtHMlTnyEiC1yW+eoAh3YGejz4RcnSyVedHmujcjE7j2emfU+Pkwa+Womyd93AnTYoyGuq2BRg/8lQgZNm1lrDSD8=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5618.eurprd05.prod.outlook.com (20.178.112.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20; Wed, 25 Sep 2019 17:14:43 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::bc4c:7c4c:d3e2:8b28]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::bc4c:7c4c:d3e2:8b28%6]) with mapi id 15.20.2284.023; Wed, 25 Sep 2019
 17:14:43 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Eli Cohen <eli@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH] IB/mlx5: add checking for "vf" from do_setvfinfo()
Thread-Topic: [PATCH] IB/mlx5: add checking for "vf" from do_setvfinfo()
Thread-Index: AQHU8VksN1f2M+xP9E6fmGLbzmIE56Y49QlggAQIYACAAKwVoIAAzogAgADkXUCACIYWAIAAdFXQgAGe1YCAABG20IABZEwAgAENsBCA7xa6AIACFlAQ
Date:   Wed, 25 Sep 2019 17:14:43 +0000
Message-ID: <AM0PR05MB4866F268D9FB654EFBD1E8E4D1870@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190415094610.GO6095@kadam>
 <VI1PR0501MB22713CCB1141529CCB6934B1D12B0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190416082112.GA27670@kadam>
 <AM4PR0501MB22609E4C9D126A096DD7F614D1240@AM4PR0501MB2260.eurprd05.prod.outlook.com>
 <20190420095102.GA14798@kadam>
 <VI1PR0501MB22713B232B3CF42B849F959BD1220@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190423154943.GC14820@kadam>
 <AM4PR0501MB2260ADC1DA37E87D01979969D1230@AM4PR0501MB2260.eurprd05.prod.outlook.com>
 <20190424140820.GB14798@kadam>
 <AM4PR0501MB2260DF0BBBC528A147F07E0DD13D0@AM4PR0501MB2260.eurprd05.prod.outlook.com>
 <20190924091823.GM20699@kadam>
In-Reply-To: <20190924091823.GM20699@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02682ca8-ca63-4d09-6bed-08d741dbdb8e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR05MB5618;
x-ms-traffictypediagnostic: AM0PR05MB5618:|AM0PR05MB5618:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5618A3F23F6050822C5303EAD1870@AM0PR05MB5618.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(396003)(366004)(376002)(39860400002)(13464003)(189003)(199004)(4326008)(316002)(76176011)(8676002)(256004)(14444005)(6436002)(33656002)(6246003)(7696005)(14454004)(26005)(102836004)(478600001)(99286004)(55016002)(186003)(52536014)(9686003)(6916009)(66066001)(229853002)(3846002)(25786009)(8936002)(71190400001)(71200400001)(305945005)(66556008)(66446008)(64756008)(6506007)(76116006)(66946007)(476003)(486006)(7736002)(74316002)(66476007)(53546011)(6116002)(5660300002)(11346002)(446003)(2906002)(81156014)(81166006)(86362001)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5618;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GBUUho2mrDovu4HT7U4dmDNHKQNByBDzOBn6xQ3nFrLyB/nT+nVQIwxsG0Mu34qJMKOVvMrs1V1OBNmk/DX2GC8Y0himFeimuSizziXY/Wb5P0pAK7bX3T5BPysWkBnVV/Czdij2hPfu4rGc0C66r1RMuVanw7ARKbqFI+7oWJprxwpU/2x8TNaonKb5n8DkOI6Lrmu4fTlTXCExzoGjnL6rHy7rWQlkMsntqRhmvAvfB/zSdKe4M61QKkTnz7rGmZoctRR0YWAkTOOf1l1SOiRwiA1gNrHMFakMX8EodPYDXc2gVezD5hMnOgE5GXvJ5KA6E4F+rae8/0IrP2v8c2iMEZwmAqD8TnamfpSl/BsThY82g1Q3FdH0UYqjyXzcirk+Kx/js0sXKhOylZovvSxPIjEAFYRz0i2hwq/0zSw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02682ca8-ca63-4d09-6bed-08d741dbdb8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2019 17:14:43.2092
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T5vrSA6wYfobdiaGk7kqWDwNabi7zUezCvnlYpBeQWJ9tFXaA8gGUJadFnHjB1xmsm1GrtZcny0pNiPVFIwzMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5618
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

> -----Original Message-----
> From: Dan Carpenter <dan.carpenter@oracle.com>
> Sent: Tuesday, September 24, 2019 4:21 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: netdev@vger.kernel.org; Leon Romanovsky <leon@kernel.org>; Eli Cohen
> <eli@mellanox.com>; Doug Ledford <dledford@redhat.com>; Jason Gunthorpe
> <jgg@ziepe.ca>; linux-rdma@vger.kernel.org; kernel-janitors@vger.kernel.o=
rg
> Subject: Re: [PATCH] IB/mlx5: add checking for "vf" from do_setvfinfo()
>=20
> On Thu, Apr 25, 2019 at 06:15:13AM +0000, Parav Pandit wrote:
> >
> >
> > > -----Original Message-----
> > > From: Dan Carpenter <dan.carpenter@oracle.com>
> > > Sent: Wednesday, April 24, 2019 9:08 AM
> > > To: Parav Pandit <parav@mellanox.com>; netdev@vger.kernel.org
> > > Cc: Leon Romanovsky <leon@kernel.org>; Eli Cohen <eli@mellanox.com>;
> > > Doug Ledford <dledford@redhat.com>; Jason Gunthorpe <jgg@ziepe.ca>;
> > > linux-rdma@vger.kernel.org; kernel-janitors@vger.kernel.org
> > > Subject: Re: [PATCH] IB/mlx5: add checking for "vf" from
> > > do_setvfinfo()
> > >
> > > I think I'm just going to ask netdev for an opinion on this.  It
> > > could be that we're just reading the code wrong...
> > >
> > > I'm getting a lot of Smatch warning about buffer underflows.  The
> > > problem is that Smatch marks everything from nla_data() as unknown
> > > and untrusted user data.  In do_setvfinfo() we get the "->vf" values
> > > from nla_data().  It starts as u32, but all the function pointers in
> > > net_device_ops use it as a signed integer.  Most of the functions
> > > return -EINVAL if "vf" is negative but there are at least 48 which
> > > potentially use negative values as an offset into an array.
> > >
> > > To me making "vf" a u32 throughout seems like a good idea but it's
> > > an extensive patch and I'm not really able to test it at all.
> >
> > I will be try to get you patch early next week for core and in mlx5,
> > tested on mlx5 VFs, that possibly you can carry forward?
>=20
> Whatever happened with this?
>=20
I had internal few patches that Leon and Saeed reviewed, but it needs more =
rework at core and driver level.
I haven't had chance to finish it.

> regards,
> dan carpenter
