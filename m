Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528E442A5CE
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236971AbhJLNiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:38:12 -0400
Received: from mail-eopbgr1400102.outbound.protection.outlook.com ([40.107.140.102]:11776
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236936AbhJLNiC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 09:38:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KYQjRwp1cwkjYKjDVqTDLHQ9wOOrHN3J6ZeuW+bcSJ91IfnkPcLLyI8AOxkSkAEAmlWbeDi9E8B3DG+qUUCECE5NAWuf6eDOCaL3cDNEPwMlZXIc8NWFx3HPKYKV86+R5Sj8uRDIovosftldSRWXRIPIe1AeYsTJzCfZMlG5Igmatob65kVat+qiHKNgZ6nuPXot+XrZvoZzfk689isBJbsTcqZqjY0zSwdC0lPrpTWeDeWALmo+xddPBF6pwLxfIEofIvcc587+R27gRX6YLRErBQPAhrKzdYUhHwdQY01rWrLaZCJGTC9NxiADeE1zq6fk3wgqqhBOQPD4+zP3XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NEmAKxsimeovvbySOh7UPrKBnMuNqdR5KGlHv7sqmoA=;
 b=kfLmUVyGIHlEsEzvzEUYKsIcBYZQM1jc8j7MP04IvTWSinWw4HfMsvGY74lYmfYWCyAojwf/EDMdG1Fh8N2P3CeEwXhhaBuS4A0X6mWo0LDGYWCsbVKBkuZi7EUufLVXFpZ7aOQinSw6p4i1qbPHcaF+pflug4ATat3SlbQ56W1jnYHtgx7uyu0V7zB7phywedKObZfMlU4BFGTNdvNoI6VruBAJEbRz3Kx9SKxZlVsairvAMMR5wiSUG0yEBzvplP2ChQ4ZgXoLn8T/N/L+XnA3NeXWyEstqgbyYCQscBeHyf+r/pf8kTWWx/H5lOnNTZ1gNl/ZBbupNZdtzbsG7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEmAKxsimeovvbySOh7UPrKBnMuNqdR5KGlHv7sqmoA=;
 b=ApfBaI8upSrb8Utwmq5ZfaTH9s2YdBT5IYSnPvzPS1LYQpuw5/Cb4PN+V7ZsHS/SC04HSYT+QXlbGg2DbVRrqKLKsf9Q1/DqCYGC0uM5iGprknnArf6mfokPPLJSdiPstNScS3CIxnezC7qTSu6DBiWD2fvI4WTNCdDd2soNBmA=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSZPR01MB6890.jpnprd01.prod.outlook.com (2603:1096:604:133::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Tue, 12 Oct
 2021 13:35:58 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 13:35:58 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        David Miller <davem@davemloft.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "aford173@gmail.com" <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "biju.das@bp.renesas.com" <biju.das@bp.renesas.com>
Subject: RE: [PATCH 00/14] Add functional support for Gigabit Ethernet driver
Thread-Topic: [PATCH 00/14] Add functional support for Gigabit Ethernet driver
Thread-Index: AQHXvUEBHULAomfYXUWxvR6NssmBBqvLDP4AgADtlQCAAATPgIAB9nIAgAFrmyA=
Date:   Tue, 12 Oct 2021 13:35:58 +0000
Message-ID: <OS0PR01MB5922C51643294BE12DB5B3C786B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211009190802.18585-1-biju.das.jz@bp.renesas.com>
 <ccdd66e0-5d67-905d-a2ff-65ca95d2680a@omp.ru>
 <20211010.103812.371946148270616666.davem@davemloft.net>
 <5b3893d9-a233-5d22-0873-f9da87b3180e@omp.ru>
 <c9bc0d3d-dc38-3e98-7d18-57d3f366a8b3@omp.ru>
In-Reply-To: <c9bc0d3d-dc38-3e98-7d18-57d3f366a8b3@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41329ccd-c27d-4192-0880-08d98d85399c
x-ms-traffictypediagnostic: OSZPR01MB6890:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSZPR01MB689066DBC7A9DA43C10837CB86B69@OSZPR01MB6890.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l7pqxuaEyv80Tl7O/INigxC5zvejMMZHHd7UzbiEGv6Qu2nKuaSdjqjNeCuhVD3x0aVEExJl/cJCZnZrUkrOfyCsgVHLiQ+g5FqCQAwo6iqvAiJl1lRGbQh9kbgH9wKWfDbhq0FeqxxOgiikBbcsBDEiXJw1SSjbSSwyfSXdZPB/z89NC6bKR2RuCxfKC5EH4Tsdlm2CKQAZbrGW9gyRmVr+V0zKkau1ooyqSws6zHeoxug988K55hJYAfyVnhNMAZnAyZbvRMpe/buCh8OW60Q7BiNqAd+Lk22/PnKVRDRIWT3PXpFAWkj9ThVNxDDPD9go4Vcj7X0FDeAzf7gknyAnaA+XJdpoi05A0f46ORA0DcCNC+AV9SBUXdNKk9lQPcqBj9ASKKDwnJGmIHekZvw1NMN5p6h3eotPKlp6fqjjyN0wFkVt4K3CEyLaNe1gYQRPJTk70Vgr1voSykV2zvFGNBBsnkPeIYx4UGzhMR6Yl/MfWDbgqIQyiINsRI5JW5P5AUEtNIHH26YPIvQil0A/I5QYYoAqidQQTi3D2em4LVgV9qSj0R7FJ344WzUZQvH8pQRCzrwqrUYZtbETp6yat/hiapzl/BwO11QGrQJD6okiOYDYIc+4/iXCD3JJ33+XmrbnRKhvtIFQMLHCRbyotiUSqRB44BkLQdpv7j4jiHnj26jsu+VeVMJfvV7lfn6HZI9Qofri2Os9MHKczQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(38100700002)(86362001)(316002)(110136005)(54906003)(55016002)(508600001)(52536014)(122000001)(5660300002)(33656002)(26005)(4326008)(7696005)(38070700005)(6506007)(53546011)(2906002)(83380400001)(66446008)(64756008)(8936002)(66476007)(66946007)(66556008)(186003)(71200400001)(4744005)(107886003)(8676002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eDBldlllOHRCYm15NWpVTlJ3bG5YSVkxU2VKeUQ5c09rZmR4OGJUc2YzRG5Q?=
 =?utf-8?B?R2FwYWM5am1LZzJkS0NLdDA4bEFwcTlvWExXSkZsY01waGF2UHlOVDNZR0I4?=
 =?utf-8?B?UXpicFlmYjAwS3hqeEpkZGs3R0J4Qll1bnc1ZjA3NDA4bnFqNS9ibXJVU25N?=
 =?utf-8?B?ay9YL25jSTFwL3gxb2Zzc2pZRnBTcFJpelRlZjJHRVBaN1pQOTRYZXZGb2lF?=
 =?utf-8?B?aFBOcjlCenNkKys3UXFNaEVMYTl1eDZiMS90VW9PYWhpaDJ6aFMxSzBkcGlq?=
 =?utf-8?B?azBNVVFxekxyYVhNNmpkTVhjUWQzOFBGNllzcnhOMDN3cFFRdHFSeVgzRzVM?=
 =?utf-8?B?czFaMGNiUWVydk90SXI2UGpVbDh5S0RFWGhQNUdQcDF5MlFmUzRCTXhLY2Nj?=
 =?utf-8?B?RVdlYzl3WXREY2ZzVGp3ZkxvZ3dJMHluTUcrVDkrejcyNm5FeXc0Y2NjVHZt?=
 =?utf-8?B?SURtNlkvT1locGJmV0pmc0laWEFIcTNmc0pQYk5JaDRmQWZyZ0hiS04vZlFO?=
 =?utf-8?B?U1NzTkdLTGZEU1g1bGZscTBSYTZjQWpiYUV5OWhENS9VcDNxWGV2Y1VjUGtZ?=
 =?utf-8?B?bTBYdkYrVGV5MzM2VDlnNnNmeUhvaC9zSndOUjhsL21VRHdCd3dyYlFrZmpR?=
 =?utf-8?B?TnBQd1FEa0ZCZEV6N2xxa1Y1TXJ1K2V3YXlPa3BMV2NORmw3enBtSWZuNE9J?=
 =?utf-8?B?ZFNLYUwxUHFZbFVRb1YvSXN5NjVtVk1JZTV3dEhPeC80blROY29Xam5HNUd2?=
 =?utf-8?B?NE9uUjFybFNFUHFvbDB5cE1sa0dwRkVyRDFxVnljSG5OZ2Vpa04ybFNuSTNJ?=
 =?utf-8?B?T2JBUlQxRW1nbFY2WUVFVVJ5OE5xbER4OW4rbEUvdk5ha1dLMkJYTEhIbGlF?=
 =?utf-8?B?Ym1XQUhsajZTNkR2MUs0ZjcyMWVUWXBUdmQzdU1paVlYNFlQd3oyc3hZOXFJ?=
 =?utf-8?B?SHE1aHRaZVNzcmVWQWNBWVdPS29mditGQ0s0eDgraWU4SWpwb0FUdjRod3Vi?=
 =?utf-8?B?UFppMzJPM2pDeDVNSUJtVTJlRFRhR2RtaEpoNVJkSlhWNkh3Q3R6K2p2cjht?=
 =?utf-8?B?S2pkNUdwOU9tUHdWaWhxRWhTRnQwQVNLczVrcDZaNzlDWnFob09qaVdYdEhZ?=
 =?utf-8?B?cisyNDlUSGZqYUF2bk83SjRrczVTVUdmUlBkY3BnMFpyZEYwMGdmZ1FVL201?=
 =?utf-8?B?NEM1R0xMM0JFdFFvT205bVRxMDhKQkg1OHo1Vm9oUjFOZXY1Ui9MaHM0c3c0?=
 =?utf-8?B?SVl2T0s1QkNGUWZXdUd3NWN4TGtVSFgxMDRZaGpNUkpJb3JaWm5JTjljUTVT?=
 =?utf-8?B?VEdsaUxZaEI2Q0drOUJUUVdLUW01ZEVqQmZUVjJtYXd1K043czNCOUpKYTlV?=
 =?utf-8?B?dHFzWmVZZnVBcmUxVVQ2VHl4MVp0MjdCMjFMMTdUNnZOczU0cm41Qmt2aXlh?=
 =?utf-8?B?dlg0UnJ3VDIrWXpXckxSV3pQMlJyTFM4NE5tSVhrQmJlUVRjc3VySFZUQXRU?=
 =?utf-8?B?dzFEZ3NwR3IvdEtnbUJOdHdQYUhzbUdDU3d5THcwZngzL05ZYUV2S09hSEw4?=
 =?utf-8?B?c3JZeVBtakFVWUZ1dmVvbHl1eXJRUlVwZmF2UUZMUlo0UmFNVjdlTXpPeG84?=
 =?utf-8?B?NkFJcDc0b3BBYUtMY2xLWkFZbHpldHY1c2FZLzIwT3dRRWdHN0F6SHJTamFT?=
 =?utf-8?B?ZDBnNXdYVnlTZnNXd242VnRzQllJcW1pTndCWVZJM0VRcEUxNFlXMm1jd1Nn?=
 =?utf-8?Q?wbt/b3KNyiyUZZ5m7E=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41329ccd-c27d-4192-0880-08d98d85399c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2021 13:35:58.4139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4hgkUebE7vZY/NCf3Oe1nc+DtuDOir5F+qcRGLUylBKXRfDZB5uMbeuIhBwcAX7WBO8UXCR5xhuS2NDCKsf17zBw3izElHRbFjL5+wBos4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB6890
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQpUaGFua3MgZm9yIHRoZSByZXZpZXcuDQoNCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCAwMC8xNF0gQWRkIGZ1bmN0aW9uYWwgc3VwcG9ydCBmb3IgR2lnYWJpdCBFdGhlcm5ldA0K
PiBkcml2ZXINCj4gDQo+IE9uIDEwLzEwLzIxIDEyOjU1IFBNLCBTZXJnZXkgU2h0eWx5b3Ygd3Jv
dGU6DQo+IA0KPiA+IFsuLi5dDQo+ID4+PiDCoMKgwqAgRGF2ZU0sIEknbSBnb2luZyB0byByZXZp
ZXcgdGhpcyBwYXRjaCBzZXJpZXMgKHN0YXJ0aW5nIG9uIE1vbmRheSkuDQo+IElzIHRoYXQgYWNj
ZXB0YWJsZSBmb3Jld2FybmluZz8gOi0pDQo+ID4+DQo+ID4+IFllcywgdGhhbmsgeW91Lg0KPiA+
DQo+ID4gwqDCoCBBbmQgSSBoYXZlIHN0YXJ0ZWQgcmV2aWV3aW5nIHRoZSBuZXh0IHZlcnNpb24g
YWxyZWFkeS4NCj4gDQo+ICAgIEkgdGhpbmsgSSd2ZSBmaW5pc2hlZCByZXZpZXdpbmcgdGhlIHNl
cmllcyBub3cuIFRoZSBvbmx5IGlzc3VlIHdhcyBpbg0KPiB0aGUgcGF0Y2ggIzEzLiA6LSkNCg0K
V2lsbCBzZW5kIHYzLCBhZGRyZXNzaW5nIHRoZSBpc3N1ZSB5b3UgcG9pbnRlZCBvdXQuDQoNClJl
Z2FyZHMsDQpCaWp1DQoNCj4gDQo+IE1CUiwgU2VyZ2V5DQo=
