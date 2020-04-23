Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B1B1B5585
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 09:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgDWHVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 03:21:19 -0400
Received: from mail-eopbgr30089.outbound.protection.outlook.com ([40.107.3.89]:52866
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725562AbgDWHVT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 03:21:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dd5l2owf/7kbmkabgrmsRtINdx7PlkG/hFOPhapM53kZl3I/2M1sHcHh0gz1H2XuGxcM05HT6bbGn3HsqVYAJEojMLgSkqriEpAybQ1xkE7h0vf9qr88NBkkq3fTlh7aGuWGnB4//3kNPxIe1zx3/O8Yp0rJz+90iNOFFJyThMDfdvipcs1mvrEG02E20Yva4KQ8+7H9XzZV32fp8d3StWlDgpwG1K9k9pkcsFsGSFuwgS00P7oRYovnSNptazPNomClREW1IZ+qdsau+GNHk1SM+VLzqRaUitjV/0wKVt8bc/R1BuE+uaAO5gb3lXPDbbJHqTRdFxXiI8Hfwjzc6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Aj8TSJ8pPbH6BE4l5TtstG8qBhpd9a33wg13yMDtQA=;
 b=GhJqpBRisvYyFwBdR/z/2EIJhOKrrJbrHvOYnKTiFUpldtKgISQBtDlpFqIHZYCk9XCkxubKYwc2uyP4clhJ24ypA5OV0jqQEA5Nh23ovDflD7am0MvV9kKRJVfn/Ch0rpqSpY67sCc4lrnBav47VIAIgkgTcJZs94eRYR8jURq44OL0+LtymX0gQqKdLKruMxp7uK6gAZ3Sbl9NCid+ERXVsuUNfTAApsFQ0syKCSUord6B1T4lM6BuL36I52GzXaOD6cE/osN9cweZrf40BSr7CUq1mO9Z+py8JUvIawKNuc2nSEew1cV/q/j7Yi9WP5PcyfQ0/CT89SGpcxeIkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Aj8TSJ8pPbH6BE4l5TtstG8qBhpd9a33wg13yMDtQA=;
 b=GLtjM2yB6usysXCYw1oeFrJfqAX0dixKDLtCxbee3NDi2dcKSNFYdl5ZoWRyOpHTVLneJKiRl0t67j+c/aK7e+12Yd2nPm2Q3SYKjmH7ELinm10qY59QEq1JteQwbps8rigQa6vzsYvyfeQppDfHrIdPqRnRVovjzyGT6h/mOiQ=
Received: from AM0PR05MB5250.eurprd05.prod.outlook.com (2603:10a6:208:f0::15)
 by AM0PR05MB5169.eurprd05.prod.outlook.com (2603:10a6:208:eb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Thu, 23 Apr
 2020 07:21:14 +0000
Received: from AM0PR05MB5250.eurprd05.prod.outlook.com
 ([fe80::a8ee:2db5:9156:59ee]) by AM0PR05MB5250.eurprd05.prod.outlook.com
 ([fe80::a8ee:2db5:9156:59ee%6]) with mapi id 15.20.2921.033; Thu, 23 Apr 2020
 07:21:14 +0000
From:   Raed Salem <raeds@mellanox.com>
To:     Colin Ian King <colin.king@canonical.com>
CC:     Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: net/mlx5: IPsec, Refactor SA handle creation and destruction
Thread-Topic: net/mlx5: IPsec, Refactor SA handle creation and destruction
Thread-Index: AQHWF+UmkNGV/mersUq2oN08s1UegqiGT4fA
Date:   Thu, 23 Apr 2020 07:21:14 +0000
Message-ID: <AM0PR05MB525070A499F8A4E0E94D4EF3C4D30@AM0PR05MB5250.eurprd05.prod.outlook.com>
References: <ffb0bca8-003f-bb7a-51ac-171b1f4e4a75@canonical.com>
In-Reply-To: <ffb0bca8-003f-bb7a-51ac-171b1f4e4a75@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=raeds@mellanox.com; 
x-originating-ip: [93.172.75.92]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 992031a9-59ae-4c68-2e66-08d7e756e876
x-ms-traffictypediagnostic: AM0PR05MB5169:|AM0PR05MB5169:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB516913E4762071BF6DB9693DC4D30@AM0PR05MB5169.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 03827AF76E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5250.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(26005)(76116006)(54906003)(2906002)(64756008)(316002)(6506007)(53546011)(71200400001)(478600001)(33656002)(6916009)(66946007)(9686003)(4326008)(81156014)(66446008)(8676002)(5660300002)(186003)(66556008)(86362001)(66476007)(55016002)(7696005)(52536014)(8936002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9f2EHDt6Sq/SBpKenEMu6RSZ1yoxbteMvYlD6a4SE4iy5le6tW2R9AI7SxTDIL+ddS+sCvoPEmbSnuCkYG1vA53sHkSM89SfXCrxLNcn2jTIaTU1zIEp8VUewXRS8sZ3rsF01Be7K/y1Fy6Inkmrmgp6twQm2hkSXzxedgQ3b+9ZcF5CaUOrDrodmm3Tkl2+vwCgEVhqoT1RIKNB6Fi6h54HiVgBg+GNTq6jt1CDu1RvIxJ8fLknATHYGKymMFyejpSGKfI9hUYg5GcGja9O+so+C0g1Q0BVhCWVkFu1ZTeD7uYbHSoaNL/GzkRHhZYXSH4tXyBr6NFu6CjTQwuW1UZHbTLI2U+W27ssGHQDPhvbL04EP26N5XFkvVYYCMSs8/APsYTv+Rtztpx0dxCCfed9S2ND+M27YoyK5nQYTfGT8DNW3ThyBYzCuHdJ44nb
x-ms-exchange-antispam-messagedata: ia2MtG5yaLIL2n8elB2OYVpG+0vnTxjuII/kPRPuaOpVOw8jHeHHijxXtCmMyl2tFnJF7ZOsoXgHyyNVHnNqzY3PNUFYLQyXpFgasbOgbaHEX1LRigcG+gJZGe461M4lVV4lZT5rlOSMUDNexpEHFQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 992031a9-59ae-4c68-2e66-08d7e756e876
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2020 07:21:14.8428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cwHiffVhwjwf8vk5K0Gsmu+JKAqjGmRzOnm4DxpxluQB9jThZSAfRVuQY43qEkFnBV6Sxz+E+KMMhl0jMAgKMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5169
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBDb2xpbiBJYW4gS2luZyBbbWFp
bHRvOmNvbGluLmtpbmdAY2Fub25pY2FsLmNvbV0NCj4gU2VudDogVHVlc2RheSwgQXByaWwgMjEs
IDIwMjAgNTowMCBQTQ0KPiBUbzogUmFlZCBTYWxlbSA8cmFlZHNAbWVsbGFub3guY29tPg0KPiBD
YzogQm9yaXMgUGlzbWVubnkgPGJvcmlzcEBtZWxsYW5veC5jb20+OyBTYWVlZCBNYWhhbWVlZA0K
PiA8c2FlZWRtQG1lbGxhbm94LmNvbT47IExlb24gUm9tYW5vdnNreSA8bGVvbkBrZXJuZWwub3Jn
PjsgVGFyaXENCj4gVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPjsgbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZzsgbGludXgtDQo+IHJkbWFAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IHJlOiBuZXQvbWx4NTogSVBzZWMsIFJlZmFjdG9yIFNB
IGhhbmRsZSBjcmVhdGlvbiBhbmQgZGVzdHJ1Y3Rpb24NCj4gDQo+IEhpLA0KPiANCj4gU3RhdGlj
IGFuYWx5c2lzIHdpdGggQ292ZXJpdHkgaGFzIGRldGVjdGVkIGEgcG90ZW50aWFsIGlzc3VlIHdp
dGggdGhlIGZvbGxvd2luZw0KPiBjb21taXQ6DQo+IA0KPiBjb21taXQgN2RmZWU0YjFkNzllMTgw
MDgxOGFiY2ZiNDc3NDdiMTYyYzlhMmQzMQ0KPiBBdXRob3I6IFJhZWQgU2FsZW0gPHJhZWRzQG1l
bGxhbm94LmNvbT4NCj4gRGF0ZTogICBXZWQgT2N0IDIzIDE3OjA0OjEzIDIwMTkgKzAzMDANCj4g
DQo+ICAgICBuZXQvbWx4NTogSVBzZWMsIFJlZmFjdG9yIFNBIGhhbmRsZSBjcmVhdGlvbiBhbmQg
ZGVzdHJ1Y3Rpb24NCj4gDQo+IFRoZSBpc3N1ZSBpcyBpbiBtbHg1X2ZwZ2FfaXNfaXBzZWNfZGV2
aWNlKCkgaW4NCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2ZwZ2Ev
aXBzZWMuYyBhcyBmb2xsb3dzOg0KPiANCj4gDQo+IDcxMCAgQml0d2lzZS1hbmQgd2l0aCB6ZXJv
DQo+ICAgICAgYml0X2FuZF93aXRoX3plcm86IGFjY2VsX3hmcm0tPmF0dHJzLmFjdGlvbiAmDQo+
IE1MWDVfQUNDRUxfRVNQX0FDVElPTl9ERUNSWVBUIGlzIGFsd2F5cyAwLiAgVGhpcyBvY2N1cnMg
YXMgdGhlIGxvZ2ljYWwNCj4gb3BlcmFuZCBvZiBpZi4NCj4gDQo+IDcxMSAgICAgICAgaWYgKGFj
Y2VsX3hmcm0tPmF0dHJzLmFjdGlvbiAmIE1MWDVfQUNDRUxfRVNQX0FDVElPTl9ERUNSWVBUKSB7
DQo+IExvZ2ljYWxseSBkZWFkIGNvZGUgKERFQURDT0RFKQ0KPiANCj4gNzEyICAgICAgICAgICAg
ICAgIGVyciA9IGlkYV9zaW1wbGVfZ2V0KCZmaXBzZWMtPmhhbGxvYywgMSwgMCwgR0ZQX0tFUk5F
TCk7DQo+IDcxMyAgICAgICAgICAgICAgICBpZiAoZXJyIDwgMCkgew0KPiA3MTQgICAgICAgICAg
ICAgICAgICAgICAgICBjb250ZXh0ID0gRVJSX1BUUihlcnIpOw0KPiA3MTUgICAgICAgICAgICAg
ICAgICAgICAgICBnb3RvIGV4aXN0czsNCj4gNzE2ICAgICAgICAgICAgICAgIH0NCj4gNzE3DQo+
IDcxOCAgICAgICAgICAgICAgICBzYV9jdHgtPnNhX2hhbmRsZSA9IGVycjsNCj4gNzE5ICAgICAg
ICAgICAgICAgIGlmIChzYV9oYW5kbGUpDQo+IDcyMCAgICAgICAgICAgICAgICAgICAgICAgICpz
YV9oYW5kbGUgPSBzYV9jdHgtPnNhX2hhbmRsZTsNCj4gNzIxICAgICAgICB9DQo+IA0KPiBpbiBp
bmNsdWRlL2xpbnV4L21seDUvYWNjZWwuaCBNTFg1X0FDQ0VMX0VTUF9BQ1RJT05fREVDUllQVCBp
cyBkZWZpbmVkDQo+IGFzIHplcm86DQo+IA0KPiA1MCBlbnVtIG1seDVfYWNjZWxfZXNwX2FjdGlv
biB7DQo+IDUxICAgICAgICBNTFg1X0FDQ0VMX0VTUF9BQ1RJT05fREVDUllQVCwNCj4gNTIgICAg
ICAgIE1MWDVfQUNDRUxfRVNQX0FDVElPTl9FTkNSWVBULA0KPiA1MyB9Ow0KPiANCj4gDQo+IEkg
YmVsaWV2ZSB0aGVyZSBhcmUgc29tZSBvdGhlciBpbnN0YW5jZXMgb2YgdGhpcyBiaXQtd2lzZSBh
bmQtaW5nIHdpdGggemVybywNCj4gZS5nLiBpbiBtbHg1X2ZwZ2FfaXBzZWNfcmVsZWFzZV9zYV9j
dHgoKSB3ZSBoYXZlOg0KPiANCj4gODU1ICAgICBpZiAoc2FfY3R4LT5mcGdhX3hmcm0tPmFjY2Vs
X3hmcm0uYXR0cnMuYWN0aW9uICYNCj4gODU2ICAgICAgICAgTUxYNV9BQ0NFTF9FU1BfQUNUSU9O
X0RFQ1JZUFQpDQo+IA0KPiBDb2xpbg0KDQpUaGFua3MgZm9yIHRoZSBjYXRjaCAuLi4gd2lsbCBQ
b3N0IGEgZml4DQo=
