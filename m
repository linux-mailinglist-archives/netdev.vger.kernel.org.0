Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0AC27B5DA
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 21:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgI1T7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 15:59:18 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:54676 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbgI1T7M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 15:59:12 -0400
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f72408c0000>; Tue, 29 Sep 2020 03:59:08 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 28 Sep
 2020 19:59:08 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 28 Sep 2020 19:59:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LcGERVB7iszaH816gVOs5259kxW3Fsfvv8LDllE82GZYd2iXcYncb45D6jvTaEaxYrx8sCQxeMOEdo14ljPaCga5mEWAqNJqKOLFD9p/00b9H9lMM7bw5Kcyy/lJBQvC3ladTsNaBwiZjMO/9QHFEowyMZMozBfhW4Tq2FEw9+qAmuDrIAZlFAdutMG/1Pu/mxJ9R+9OuzPbnB/jqKYfQpEonNd93bRynlOr2Rc6Y0DOkgH8c5zbWr5Wbc6c4qj58TCzvceFpeNqaCtRfME2X/AYg8hCoxlxPvn6R1QAX3yKIv85+dQ86VaWcvqzwsQUH4rvIi827cYiD9ttaxcGqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7MIKi6vFWXhDlj//KnKNM4FHrf1vRgp9WTI3VTWfNog=;
 b=NKNzCs7oqKQJCXozRjgi/CjmBGGvpdgbReHYV4EiKPn8x/KVsvsKJW413gM89sDa3QiJiZf3UhiQfi4akJt2YgjuWAY/zcCCVt8Wx3DypDjfqMzZsirF4xO0I/aaYIbsYadT6NCBOz5U4oB7owKmG1nWbh9o/oBILrndjGc9lbOMt+PhiuM1pwVD/wOzDt8C9Yxt9kJymwIZbUE5TWZGj11Qb6eGaPL0a+Xp0wR8vFZu+m6/fId5cfvMGnDmDDbWN7K7tDNdWn65Ps6xx+Y93YXoXM2rEuNJRiQEoGRRXxrMG4BOHX1j8NG5tzqU2a5GmGQoYvoqWQ5z5jGuqcjltQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB4234.namprd12.prod.outlook.com (2603:10b6:5:213::18)
 by DM6PR12MB4863.namprd12.prod.outlook.com (2603:10b6:5:1b9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Mon, 28 Sep
 2020 19:58:59 +0000
Received: from DM6PR12MB4234.namprd12.prod.outlook.com
 ([fe80::b0e4:b63e:8b6a:5ce4]) by DM6PR12MB4234.namprd12.prod.outlook.com
 ([fe80::b0e4:b63e:8b6a:5ce4%8]) with mapi id 15.20.3412.029; Mon, 28 Sep 2020
 19:58:59 +0000
From:   Yevgeny Kliteynik <kliteyn@nvidia.com>
To:     David Miller <davem@davemloft.net>,
        "saeed@kernel.org" <saeed@kernel.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Erez Shitrit <erezsh@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [net-next 01/15] net/mlx5: DR, Add buddy allocator utilities
Thread-Topic: [net-next 01/15] net/mlx5: DR, Add buddy allocator utilities
Thread-Index: AQHWk3N7jrwJ3acn30aBccASFkUzC6l7fjsAgAL7BSA=
Date:   Mon, 28 Sep 2020 19:58:59 +0000
Message-ID: <DM6PR12MB423444C484839CF7FB7AA6B3C0350@DM6PR12MB4234.namprd12.prod.outlook.com>
References: <20200925193809.463047-1-saeed@kernel.org>
        <20200925193809.463047-2-saeed@kernel.org>
 <20200926.151540.1383303857229218158.davem@davemloft.net>
In-Reply-To: <20200926.151540.1383303857229218158.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [37.142.1.142]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b3f70972-a2b2-4a7a-17e7-08d863e8f0a1
x-ms-traffictypediagnostic: DM6PR12MB4863:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB4863D9D89F2A6083A695D74AC0350@DM6PR12MB4863.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AUeKHrOy0aVgDAeSj7k/sZev2Kg9gFdA4S/bJHUfOESiG+6QxZn1ky9dNRia9hgbO+eaZGCsUhJMyQCP8c9yYylv16s5P9K0TvYs8tlhtUlU2A+GyLcz0bsgFfUhtbO9Wv0jCMWdpYkniXKT7VRkL70ROAX6DLM0lzIo+u78iyCJ99nrAlGP1ndKOyA6gWA7x57g4EBxB5kwRZlAo685g471/qm703HS3kLayQoXbN25sn5vAsMGn4cnd8/jZtSROF+ckG+Y3VbHMMhdVyQ+U2RZaNrw8NTQw/lyvPIC86HzS7oamUOre6VedVJJE98dKtSJy0IjImlrSxmCENwmbZ1b+urvlm8SyZoBbBypf8Z0d5EUg56g2GQQ3DDQpnkU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4234.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(4326008)(5660300002)(107886003)(53546011)(64756008)(66446008)(66476007)(66556008)(26005)(6506007)(71200400001)(8676002)(55016002)(52536014)(2906002)(66946007)(54906003)(110136005)(316002)(76116006)(186003)(478600001)(7696005)(8936002)(9686003)(83380400001)(86362001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: FDYdDHHxwTUWaRfwkuwW4A/YFFkuK8PewPSvpMSDLbueZF8bYTqMIykhFyhZ9WdzhWz4x1sSGPZo1wX/rBEqTjbpoZaNN6aWTNvz9f+x548yCJVrDHu+KNHzdod7zyY+szMONlCEPzFRUbBj93CQyfxqxQn5L0Z0RRsRCfoYGHOY+GdOT+k5W0e6qW1p7auXkinGeggFivPg504hisQN6RgKRCu0eLr4NlvrPDHOMO/vN8n7mBbKBsuA20JnFqkHHY5lWC6v5GQ0mkBF25o36krfbiRGWaGSIs/luGXumkBJergCj5r/PW8Aiu6O6DVT8HOv436S7B465GeoZm73dHyoxAHXLlinM0UJ/pj2K9ZFgonmTq7O9NRuTsj1mi0yoilQSUSQLEABw/tzWDnPhr/3ceEuaedbEOaO2BMECHthzUSdux8yOVxXknnfJ+4EdTGVAHBNRcwFci/Now9cy700CyX3FBzliDDMKlfWduSMLXIJR37uQkPS+2WjqUO8GrGkK7ZSjT1dL2WyUASMJDcegFyKjxGve2Wqg7An5Nlx+FJK3XBP/K9ChZXDoNJj62i9xCvM7dCt1WKBHyDTMLK4Reuo4KQzogppeDMe8yj9/psJSet68KQqbUX2wU0QrPYdzjavw+7qYou+KeQi5g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4234.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3f70972-a2b2-4a7a-17e7-08d863e8f0a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2020 19:58:59.2362
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sffhqV7xsWHGzXA3CuHbNso9JwcGJosTcsd08fOcQf6rSQ88ocAcFKWJhkfxzHGbTuib3JULecZuFqr7yXddSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4863
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601323148; bh=7MIKi6vFWXhDlj//KnKNM4FHrf1vRgp9WTI3VTWfNog=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=f5PrEfXN4p3vbMSOsZXtdq9VobX7epfMXwrQIz8PO1TIrZ7xFH3xCkJ/kfvuAp0Gg
         Y898PCtWpjhAivyDWnpiLrh0PzqNKdVuLVIyC96eaedtLzdLAqds5mFBch8gF+CPtb
         wz8iomuPC1Sq/dlzF+YcJBJK/rO27sOQtyAOJg32FcU7aw+JYeTz+85UsF9Hfo92Ve
         K2SRUeya3Te24Bjs0iJAt+2tfotqY4aRnIG8sD/M91lrdQcRfjt9yxG8PtYwPDy8x8
         uhVazBkxSIerCln8BTN9AQ4P59S+obHy+n+3w0ekP/m9HJJNu67pHda2QEzHfEef8r
         P8zMbbiwcsTOQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: David Miller <davem@davemloft.net>
> Sent: Sunday, September 27, 2020 01:16
> To: saeed@kernel.org
> Cc: kuba@kernel.org; netdev@vger.kernel.org; Yevgeny Kliteynik
> <kliteyn@nvidia.com>; Erez Shitrit <erezsh@nvidia.com>; Mark Bloch
> <mbloch@nvidia.com>; Saeed Mahameed <saeedm@nvidia.com>
> Subject: Re: [net-next 01/15] net/mlx5: DR, Add buddy allocator utilities
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> From: saeed@kernel.org
> Date: Fri, 25 Sep 2020 12:37:55 -0700
>=20
> > From: Yevgeny Kliteynik <kliteyn@nvidia.com>
> >
> > Add implementation of SW Steering variation of buddy allocator.
> >
> > The buddy system for ICM memory uses 2 main data structures:
> >   - Bitmap per order, that keeps the current state of allocated
> >     blocks for this order
> >   - Indicator for the number of available blocks per each order
> >
> > In addition, there is one more hierarchy of searching in the bitmaps
> > in order to accelerate the search of the next free block which done
> > via find-first function:
> > The buddy system spends lots of its time in searching the next free
> > space using function find_first_bit, which scans a big array of long
> > values in order to find the first bit. We added one more array of
> > longs, where each bit indicates a long value in the original array,
> > that way there is a need for much less searches for the next free area.
> >
> > For example, for the following bits array of 128 bits where all bits
> > are zero except for the last bit  :  0000........00001 the
> > corresponding bits-per-long array is:  0001
> >
> > The search will be done over the bits-per-long array first, and after
> > the first bit is found, we will use it as a start pointer in the
> > bigger array (bits array).
> >
> > Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
> > Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> > Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>=20
> Instead of a bits-per-long array, it seems so much simpler and more cache
> friendly to maintain instead just a "lowest set bit" value.
>=20
> In the initial state it is zero for all values, remember this is just a h=
int.
>=20
> When you allocate, if num_free is non-zero of course, you start the bit s=
can
> from the "lowest set bit" value.  When the set bit is found, update the "=
lowest
> set bit" cache to the set bit plus one (or zero if the new value exceeds =
the bitmap
> size).

This will work when you allocate everything and freeing "in order".
In our vase the system is more dynamic - we allocate, and then some chunks
are freed all over, creating free spots in the bit array in a rather random=
 manner.
By replacing the bits-per-long array with a single counter we loose this ab=
ility
to jump faster to the free spot.
It is still an improvement to start from a certain place and not from the b=
eginning,
but bits-per-long array saves more time.
Also, in terms of memory, it's not a big hit - it's bit per 32 chunks (or b=
yte per 256 chunks).

-- YK

> Then on free you update "lowest set bit" to the bit being set if it is sm=
aller than
> the current "lowest set bit" value for that order.
>=20
> No double scanning of bitmap arrays, just a single bitmap search with a v=
ariable
> start point.
