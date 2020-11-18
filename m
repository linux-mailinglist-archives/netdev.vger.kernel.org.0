Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C922B84DF
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 20:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgKRTWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 14:22:30 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:17876 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgKRTWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 14:22:30 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb574800000>; Wed, 18 Nov 2020 11:22:40 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 18 Nov
 2020 19:22:29 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 18 Nov 2020 19:22:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3gO++zNQEJhNdTL8gzCosd7o8LrePTiP0LrU1dNbq/PtFeb1jY3Q8FRptF5vNVMjyY4Afc/DWPPEKQJqFVunJw4AR+FCfSR/8Y6f7UiNFeGsfrTMY+Gl/wQbQcs3Ev2fqkCM1SnCaBryq3CkdCemqgfMr9Masr7fCiKtHVEXbV7yNY9mCu5LX67pC7ne6m+xcKZq74gS7fOb6Qh/2lEM869xXQR5sbPa4pUr0r2irOgXQEV+WM0boLwgfuIx9I5CXjs9CeBAsSNxy+7zxUNbea99cO3y5pczTaWoIKMBQfG/YxER+7c7sr/QieL6PtaJR5LdQqmJC9Tpmpl0cMQRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wecLphUpw1gJFvVhID2jMjH5Wf1pTsvQWPZIYQ8HG3U=;
 b=g0sGbcUDUWVPwb8LugibIqbMRnraCAQfBjYkg2nY/DzB82SAPePYRavTTSXg+e1dnpX6s0UrMvSbblUikJ+qkcjqCKEgRHBF2ujdmzPQnGDEsj3S48j5etuUZVPE4Jn/+wfGqmR8pHez9CHymOw/rTYCySuqcx6uzny23v2w9SCAY/Gtq8i3PkVc88B9JMAG7OloZCUdVf7wshdf81tZgDHJZYHAFK2LIU8nZ8NQ1pM5t3u0SpB9oI0ySwY243V1/uu6vyxRFsexSdRBE/v06RRxJj2uqMfagnLb9EulIoTE0pVCyBGpMB/2oOeL7Zt1EIVAfU2xoGH/BT+OH2cDqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3270.namprd12.prod.outlook.com (2603:10b6:a03:137::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Wed, 18 Nov
 2020 19:22:28 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::9493:cfdd:5a45:df53]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::9493:cfdd:5a45:df53%7]) with mapi id 15.20.3564.028; Wed, 18 Nov 2020
 19:22:28 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Jiri Pirko <jiri@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vu Pham <vuhuong@nvidia.com>
Subject: RE: [PATCH net-next 03/13] devlink: Support add and delete devlink
 port
Thread-Topic: [PATCH net-next 03/13] devlink: Support add and delete devlink
 port
Thread-Index: AQHWuSmOH7LCCBYTi0yxfqvbYXKqLqnOG2YAgAAG43CAABWaAIAAFAmQ
Date:   Wed, 18 Nov 2020 19:22:28 +0000
Message-ID: <BY5PR12MB4322863EA236F30C9E542F00DCE10@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112192424.2742-1-parav@nvidia.com>
 <20201112192424.2742-4-parav@nvidia.com>
 <e7b2b21f-b7d0-edd5-1af0-a52e2fc542ce@gmail.com>
 <BY5PR12MB43222AB94ED279AF9B710FF1DCE10@BY5PR12MB4322.namprd12.prod.outlook.com>
 <b34d8427-51c0-0bbd-471e-1af30375c702@gmail.com>
In-Reply-To: <b34d8427-51c0-0bbd-471e-1af30375c702@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.222.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0455a8b8-b30f-427b-7c17-08d88bf749c0
x-ms-traffictypediagnostic: BYAPR12MB3270:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB32703D6668295298821B96CDDCE10@BYAPR12MB3270.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6AeACw1xA2hglwKaQZr6hlKSc0oLVhKxdKpK8UgbN/J+pCYMGIUeOozkz7v5ROwXvmQCdDUznQMEkmyx5FpNHhOJHzLG4y7OxN01jRjAfu/pJwUu5p9af1QfuV61MC5rOmyWOiTLUb/cZveSYPhpqxbHoo+MDQhQrLsTWiz5DdobxKbpuIgk851kPKcLY6LmOHgK9S1I2Fl+96qXoaXUqFHnBtvgXiiOcMig8kBFKv82svHDVd1p0Lu2nD2b5Tmdo6/l5y5FMo8BKYOOb4lVF6jD6qkjQk7sf/AYsDW3dX/T3/J5uSPWPU5NQuXS8x+bCEfYX0H7JxKmcfs/EB0wHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(86362001)(71200400001)(478600001)(26005)(4744005)(55236004)(186003)(76116006)(66946007)(107886003)(5660300002)(6506007)(52536014)(83380400001)(316002)(4326008)(9686003)(66556008)(55016002)(2906002)(8936002)(66446008)(64756008)(33656002)(54906003)(66476007)(7696005)(8676002)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ifZPcpYjOOClG4/PjAL47vogC3GtAG2PeOnXew63QYZBCb3olP/RfMf7lTp9N6nFuB2uIqP6QGt2TvcLY0KNGEhPhK4CQ+o5hIxGINrU9+SdaYLqv1V++tCl6LwjB5kRfyhUaSx+YjfY/KCDQfUie8rUt0DRkewQyJSIN6opYI4/8C8KKx9Tq44fpL1aLN1hYksnxCMqCsH/szjXfERbXe5jk7aSIVEa3A3qeofOUfyvtLnJhIWe9Tx4pPUvdvW6cgQfRh+Df3uX3RWZKOhfLCCCQi0kynsM2cRcauYtcR/8qMZKjXsR95KYdz36TdJr8GDlSJzgi6JmZ9D4U+uXiJOOz04vQPGusuo6ehgA9W1JOXvxebWADx3DvB+VklmP3QE3tCvy1jvtMxrQ1aIZodED4kRqQowKD8d94v+hm5q4N/eywCKO01ToXiAYuCcTS+H+cMfclS+dTPlDlATruuKbvB77AsBmVQf89dsQ8gvfoCSlapuxdYV92kVwodpqaJF1dJgDxoBSI7k3CgBpMiFUdfqWYVLd6nI62ktcJvnVZ9aMzK149C3Hny28VQG+5cEDyan098B1Nmiojr6EwxgT0HZVfnHTybEuJI330/NbChA4Gmvd5H6uKXlCAnYKv+UK0SwUKNGjt471VIlUYg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0455a8b8-b30f-427b-7c17-08d88bf749c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2020 19:22:28.1836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bQwBT8oRS5npgCLxtjNCoKJAhe2+YPhnsgtPa1x6nH6nTVELKwl85M6Wih6AvZyU9I7sSJqYJi/S1kMTD363eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3270
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605727360; bh=wecLphUpw1gJFvVhID2jMjH5Wf1pTsvQWPZIYQ8HG3U=;
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
        b=YZTdzMLr7dKeCaG92ubR85Ufob/pM/Xv7KXT3J72THSkWN85VXITSUpx6TvgIqJdi
         yRUPHv0bI1qtgchg5XzveI4JBAHQMdfuELefPrg+F8V+SDFiPwvzQnNKptnELg9Q3a
         7l0LFK98a8El2oBdC5gFWJV1l4PUfsTHC3Hy9tzDyxOuY3EgsLJs0I/KStu98EX6P4
         cawAc6L40ZMrZg7mqAKkY2bu8e41LoIgkkDYsNe9Rrmz4Rni2mKE/nTd4glUPixc0O
         oHS1SD5Qj50N4LZ0Q2hisfU3Ig/01qwY50eejvdLqcTzPPHuPZNOFQrv1UVz3nDMd9
         NdVk4Q+jwSS4w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBTZW50OiBXZWRu
ZXNkYXksIE5vdmVtYmVyIDE4LCAyMDIwIDExOjMzIFBNDQo+IA0KPiANCj4gV2l0aCBDb25uZWN0
eC00IEx4IGZvciBleGFtcGxlIHRoZSBuZXRkZXYgY2FuIGhhdmUgYXQgbW9zdCA2MyBxdWV1ZXMN
Cj4gbGVhdmluZyA5NiBjcHUgc2VydmVycyBhIGJpdCBzaG9ydCAtIGFzIGFuIGV4YW1wbGUgb2Yg
dGhlIGxpbWl0ZWQgbnVtYmVyIG9mDQo+IHF1ZXVlcyB0aGF0IGEgbmljIGNhbiBoYW5kbGUgKG9y
IGN1cnJlbnRseSBleHBvc2VzIHRvIHRoZSBPUyBub3Qgc3VyZSB3aGljaCkuDQo+IElmIEkgY3Jl
YXRlIGEgc3ViZnVuY3Rpb24gZm9yIGV0aGVybmV0IHRyYWZmaWMsIGhvdyBtYW55IHF1ZXVlcyBh
cmUgYWxsb2NhdGVkDQo+IHRvIGl0IGJ5IGRlZmF1bHQsIGlzIGl0IG1hbmFnZWQgdmlhIGV0aHRv
b2wgbGlrZSB0aGUgcGYgYW5kIGlzIHRoZXJlIGFuIGltcGFjdCB0bw0KPiB0aGUgcmVzb3VyY2Vz
IHVzZWQgYnkgLyBhdmFpbGFibGUgdG8gdGhlIHByaW1hcnkgZGV2aWNlPw0KDQpKYXNvbiBhbHJl
YWR5IGFuc3dlcmVkIGl0IHdpdGggZGV0YWlscy4NClRoYW5rcyBhIGxvdCBKYXNvbi4NCg0KU2hv
cnQgYW5zd2VyIHRvIGV0aHRvb2wgcXVlc3Rpb24sIHllcywgZXRodG9vbCBjYW4gY2hhbmdlIG51
bSBxdWV1ZXMgZm9yIHN1YmZ1bmN0aW9uIGxpa2UgUEYuDQpEZWZhdWx0IGlzIHNhbWUgbnVtYmVy
IG9mIHF1ZXVlcyBmb3Igc3ViZnVuY3Rpb24gYXMgdGhhdCBvZiBQRiBpbiB0aGlzIHBhdGNoc2V0
Lg0K
