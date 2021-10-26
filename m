Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8536643BA6D
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 21:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238561AbhJZTNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 15:13:53 -0400
Received: from mail-mw2nam08on2063.outbound.protection.outlook.com ([40.107.101.63]:20680
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238558AbhJZTNw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 15:13:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fjp4Dt12meZ81i2K6l37Ix2KxmxvFeM8gqJQL6QqIfcoKcMC7yGI4bWIDdXfxP2Zy8qhgney+7fXRWY+TQzeQ6Mcgnds8egzR901+LiyS1O00BPpENCwP1ZQdSTKQKQE+jskqvYMlrhvumIsiDDoDPtqQitnOOfOxfymWQ4QY9ivlCc5q8dUHZ8FOHXzot8vmJqo4Gfs4uACU5jdNQ/u0OyjhIzF3ETRZuWJJ0svqyIA1wI1KRbk0YcFxb4yuzdR1UycIo5hspPk7IJVjW0XJv53iJWqR/6OCRMyaT7HOHt/4hu8AnF4bZNSX5V4zbmz7x+UPFCx2UoWqcTeFFAUYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wi8vDReiNK2xoulcRB4btXwe5qA1Wt5UR7LxHKj6W9Y=;
 b=CGLUA+WLSgbZmTBOhpPTDSxxmSPWvccsWYzdhL4BEu427vzHAqj/BFjL/izd5fCfdWGlJPgdGrXsUMhyIxtd7yulEJ17DmR7he4+UoiVaQroeguYsxLCpIg4XZlhvcb2o0axFO+4b7VbkpbSf7DYwUbT/pNZ/awO9fRNef3Cxzwv7ZZxG+Y/YvP+in6q/aGkmaDOf38Pksp6v7pl8O/QJvOuTU75QuucPpwF5tvqSRvZOxDdmgtcbtmmz4zwJq6fjpqFREOOC5h+/Lcxo9AIWr8/rNGqcMApVocRLh5QPpnGAWFoIU7mpXmfeRT4dZxNiA9NisvU2C3cEwg/N36hTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wi8vDReiNK2xoulcRB4btXwe5qA1Wt5UR7LxHKj6W9Y=;
 b=b2DEwuKOO1L26+SGp7ZcvSfC1vpgEd6u8aYZAsCeiVz9HHY9nmR2K3nrEDBPV7d09FAePbehZfnczpluGgtkT0+KA8Nf/CfSKIi7zE5nRYSg4rus7hrffs0b+8pUL9kbygvIseXgzfA6TpeLF5U6QUjLF6AuEXfkYDpgE2J9xUa3hP2jLWo4SZjj1hPGpEnbENNUlQCYJtsRq9Fln12X3h8C8HKABFu8c9XBParoVuMwy1/TChaPceLtt1r2UMl9700Rlbs+gvizDMJ8SSY9VqBHxHYBHOS58vzBb8MOtqPnFvLGdEXKEN/mur9vptk035Jape47URwh4E5ddqd6NA==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB3924.namprd12.prod.outlook.com (2603:10b6:a03:1af::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Tue, 26 Oct
 2021 19:11:27 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%6]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 19:11:27 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5: remove the recent devlink params
Thread-Topic: [PATCH net-next] net/mlx5: remove the recent devlink params
Thread-Index: AQHXyn5MptTVTajE0k2HyW2VLp+r8avlbjKAgAAPNYCAACgmgA==
Date:   Tue, 26 Oct 2021 19:11:26 +0000
Message-ID: <882632aaeaa3bbc8b6e2aa2c76bce5a065a22625.camel@nvidia.com>
References: <20211026152939.3125950-1-kuba@kernel.org>
         <PH0PR12MB5481970AFEFD9C969B42BE20DC849@PH0PR12MB5481.namprd12.prod.outlook.com>
         <20211026094743.390224ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211026094743.390224ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8be36eed-fd4f-438c-9c30-08d998b468ea
x-ms-traffictypediagnostic: BY5PR12MB3924:
x-microsoft-antispam-prvs: <BY5PR12MB3924133F76A7EF1ABD700247B3849@BY5PR12MB3924.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oxzdwV5YcrRuzIO9RD/DpodlELE2Q/nQOTuX7i5PkSxoSj6m4V1dayLQXUC8ShtM1aIBN4syZSwYhUsiYKx/ZMchFmxitRmvhJPUw0GG07fVF5qz0t7cAPjEm+DEvapkXab49+YDp8V2QBd0/gNBnE3DmtG6yun3EoI1LQ/6REMf7vMGCilq0ff8ylzpyKN1OiqGKnALsAI+fDY8prmLP8h4GfV6YBRV53v24W0Kst6mfQFJPkiBoxuQoEZlYyjjxm2q377rczVWupDXj1Kq+aSh9sU+FwA1w2HQ7xz/C61T6YpNgaceDAMASEBheP3LmttSWlENyOjxpmh+Bcee2PJCc/1rqH8TMXIRTUZ8gv1TQW/hC34axHQKSWncZsNkMBEMieaCFi6MfiYmICwY1I6sgGr+PhmR2Vw8aaB0MEx9R0c0q7ztRM47gq/EIbR8rBqKCvnF5yrJ7ZrPWKi7c20TKVxBkBHkpw8CRjQ5kUv6ucXAhsGKj7rojzjiCeYk4QT1ytW8hIHxKNEpIvCu1yjzF0uLqlkZc5gKn9fSfyfeEbBeeqxK6zx9CWoTe/h6oVrGIoJ9dZdsqDaLaYDILJMovIqIyh5TySV4E4E2/AnYg/JR/UREIhjr75RiN6AL4lZUnpJ9+5va+ijdMPfTZ2LmfY87V2f5EzJrL4gO39PPXoxfheJ3YDxLtqRE6sSPmTjL3j69HhH8rzQYLC7QxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(110136005)(64756008)(66476007)(66946007)(38070700005)(66446008)(54906003)(316002)(45080400002)(186003)(76116006)(26005)(2616005)(38100700002)(122000001)(36756003)(71200400001)(86362001)(53546011)(6506007)(4001150100001)(508600001)(8936002)(5660300002)(2906002)(4326008)(6486002)(8676002)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MDNtWUg4UktWQ0dRU0FaQ2c5cEYxQUE0UmtKeUNtQUVVazZhQzdidFpTSjBY?=
 =?utf-8?B?dkZidXdYTjh1K0F2TkNrMWoyU2xQeFZBTk1aWlo3OTh2VEpqRm5mUlNXOERM?=
 =?utf-8?B?ZlRZZk1yS3QzbTJxbjI3OEc0c1ViTEZBeGRFcFdreVRtK0Y0VUNUSW44T2pl?=
 =?utf-8?B?VG9LY0dMRGN2MzhXUi9TajJzVkV5aHd5S2xJU2R6U2ZYZWNrUFhrdGtlQ2NP?=
 =?utf-8?B?aURCM0tDQURGM01pdVJUYW8xUndaZmJSTU1CeTY0MnpHeXkvaUF0YVJ0SDIx?=
 =?utf-8?B?L2orU3pVb1MyNDAxNXlLajZqQkJUdDIyMVVQU0k1d1hLamduQWpMeEswTGNx?=
 =?utf-8?B?MDVtWGZNYStRVjk3LzdzdVpBV3Q4Y2YrVnkvUHMvMjVVUy8vUnFDcWJjTGJ1?=
 =?utf-8?B?RlRHejRZNFVrQWJQUFA4Y0c5RHBYOTFuZUUwMk1kYkNEalZRakc4SFcyOWd6?=
 =?utf-8?B?T1VPNVBibnNPR29QY0U5dklVSStydmlZaW1tVFRVL1gra1NLMDBoVnQ2YnpP?=
 =?utf-8?B?b0gvRUpRYkpXWEhjOFNrWEJjTFNyL2NPZHBZaVh1L1Y0ZEFva1M5L1ZZMm5R?=
 =?utf-8?B?UmRVMjA4Tmk1Y29DZ3NBQVpyeVNhZzg3Q3h5NHlKZVREUHZuNnUxczhyS3dQ?=
 =?utf-8?B?YkQzRlRXa0pFdjhDNERPMzNHcndubFBTcDJRRFJXZXFURlQ2akRuTll3T2FX?=
 =?utf-8?B?WUgwNzBQU1k0dm0xWXFGZE5mRUZpSW9yKzlEcFkyZHlUbm5lSWhRODRvY3F6?=
 =?utf-8?B?dW1KdXh5T3NmVFFZeHo2UG50T2prYVBFeDRBMThVR2thRzQrVm9tWWhGb09R?=
 =?utf-8?B?clErekJsR2JEMFB3Z3JIYTRQb25WYlZFRFVDRG0vK2lLOVlEV1lraytSYURu?=
 =?utf-8?B?UEI3S0FiTXllSEpadFA5aURkRTVTTXh1RnBhMFR0aHkyQnJoVWRzZDF6b2kx?=
 =?utf-8?B?MDhmbi9RSGhBaXlsb2ZoUUlwK3FId2RXQ2xWUDlkTWZpb2ZZNUROWWJKbnRB?=
 =?utf-8?B?MjJzL2lzWStPSUYzaEpOaDhpT2ZnZG9KY0hkSDVNanh4a1VFeUIrL2x5dW8y?=
 =?utf-8?B?MGlRTURRckgwSGNUazIyY3lBRy92NllDa2xJdTZ2dEhyZVdNMkI0VjV0ZFZS?=
 =?utf-8?B?M2taN0lNd2FMRk5kOEx5b2R2SE85M3hHem9LcWxVdTBPUjRlS1I4QitZbGZP?=
 =?utf-8?B?elg3Qnoyb2dWSnVjNlpENWRrVHNKcmtmQ2V4b21KTnE5YlR3dm81UGRzc3F2?=
 =?utf-8?B?Zmo4OUEwdFVlS0s1V1hOaEtja0ZsN3VGbFNTbFU0MTJpVDRiQU80cTRhN3d1?=
 =?utf-8?B?UDhmS2o2clVpMG9VcUhjZ0hjVUp1OUZwamJmc2dnVDRQWnRlYVprUC82c3Iy?=
 =?utf-8?B?eDNJM2h3TTNnRlVDRU9telRDQnAyQXIwR2N2eHpQYTFSU1hjTWx4Nk5qVlNo?=
 =?utf-8?B?MXFkVnF6dXNvM3F3KzNiSmNybmdYb1Znd1JRL042WUhwNXc4UlVDQkxiQXlE?=
 =?utf-8?B?T2lVZmVqSHBBaXZzbjJrSmxFRUNtdmdIR0x1Vmk3dE5zSnZSYi8wT0o3NnBV?=
 =?utf-8?B?c0padlBYc3BoRHJyZ0NJRjdZQTlVcXZucjZFWW1wL1R2QnQrZXZRRU9SY1M1?=
 =?utf-8?B?S2xVVEdHUUNvK3djNGx0TGxUTXhXNzFQZVZEVjIrcWNvSDFaVkhVS0dQc2Mr?=
 =?utf-8?B?cy9CRzNVaXpsL2RZUUNOSW9yZzU2YUlSZSs3WEkzZ3k0dVNHUFpETVNXZGts?=
 =?utf-8?B?MWc2VWxmYUtxSDJxU0NoZVM3bHhtdnRYd2sxb2VrNzZ2L0xjQWtFY0FUR0Ja?=
 =?utf-8?B?VkZvSVhtWUtQaVZ0QU5MN29rZHE3dFdKSDZhNm9EREFybk95VlBhMVlGQW1Y?=
 =?utf-8?B?cUlFUXVCdjVGRjYxTEJDdEJGSnhXMlU2dTV4VWViTTB0dDcrcTJsOFNZZnhp?=
 =?utf-8?B?blluUlZ5ejd3QXVDMWZJVEdEajBNVVFGdVh3SCtIUEZ4eGZQem5nVnhkVDNH?=
 =?utf-8?B?Ym1qSVhnQ3p2cGtUWFFTK244VHhaRm1TanJaU3BaM25DalU3b0RnbmI4NTBm?=
 =?utf-8?B?RjZDaU1ac0lpbmg2Uk5yUXVDUU90R3F5aWlkczdoZFY2djR0ZkoweGMzNUlj?=
 =?utf-8?B?cG9XbDMwY1NORUdBRVczMDRCRjNia0pXTW92L2FOazJEc1Q0R0U3bmVkcWtu?=
 =?utf-8?Q?nQSARed82JSau/vgbtahrGBt6a9iVdA8rlXQqF4x/vUm?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B749EE6DCAAB8B408B86EE2C279509CF@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8be36eed-fd4f-438c-9c30-08d998b468ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2021 19:11:27.0291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WOtp0nKK2yUS85ioZe2nEQACOSODsy/bvGCzMV73xQGQpj7sfowsiFqbK7XZ7l57OsxzHovR2JE2A9OjTdtz8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3924
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTEwLTI2IGF0IDA5OjQ3IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCAyNiBPY3QgMjAyMSAxNTo1MzoxNyArMDAwMCBQYXJhdiBQYW5kaXQgd3JvdGU6
DQo+ID4gSGkgSmFrdWIsDQo+ID4gDQo+ID4gPiBGcm9tOiBKYWt1YiBLaWNpbnNraSA8a3ViYUBr
ZXJuZWwub3JnPg0KPiA+ID4gU2VudDogVHVlc2RheSwgT2N0b2JlciAyNiwgMjAyMSA5OjAwIFBN
DQo+ID4gPiBUbzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldA0KPiA+ID4gQ2M6IFNhZWVkIE1haGFtZWVk
IDxzYWVlZG1AbnZpZGlhLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+ID4gPiBMZW9u
DQo+ID4gPiBSb21hbm92c2t5IDxsZW9ucm9AbnZpZGlhLmNvbT47IEpha3ViIEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+DQo+ID4gPiBTdWJqZWN0OiBbUEFUQ0ggbmV0LW5leHRdIG5ldC9tbHg1
OiByZW1vdmUgdGhlIHJlY2VudCBkZXZsaW5rDQo+ID4gPiBwYXJhbXMNCj4gPiA+IA0KPiA+ID4g
cmV2ZXJ0IGNvbW1pdCA0NmFlNDBiOTRkODggKCJuZXQvbWx4NTogTGV0IHVzZXIgY29uZmlndXJl
DQo+ID4gPiBpb19lcV9zaXplDQo+ID4gPiBwYXJhbSIpIHJldmVydCBjb21taXQgYTZjYjA4ZGFh
M2I0ICgibmV0L21seDU6IExldCB1c2VyIGNvbmZpZ3VyZQ0KPiA+ID4gZXZlbnRfZXFfc2l6ZSBw
YXJhbSIpIHJldmVydCBjb21taXQgNTU0NjA0MDYxOTc5ICgibmV0L21seDU6IExldA0KPiA+ID4g
dXNlcg0KPiA+ID4gY29uZmlndXJlIG1heF9tYWNzIHBhcmFtIikNCj4gPiA+IA0KPiA+ID4gVGhl
IEVRRSBwYXJhbWV0ZXJzIGFyZSBhcHBsaWNhYmxlIHRvIG1vcmUgZHJpdmVycywgdGhleSBzaG91
bGQgYmUNCj4gPiA+IGNvbmZpZ3VyZWQNCj4gPiA+IHZpYSBzdGFuZGFyZCBBUEksIHByb2JhYmx5
IGV0aHRvb2wuIEV4YW1wbGUgb2YgYW5vdGhlciBkcml2ZXINCj4gPiA+IG5lZWRpbmcNCj4gPiA+
IHNvbWV0aGluZyBzaW1pbGFyOsKgIA0KPiA+IA0KPiA+IGV0aG9vbCBpcyBub3QgYSBnb29kIGNo
b2ljZSBmb3IgZm9sbG93aW5nIHJlYXNvbnMuDQo+ID4gDQo+ID4gMS4gRVFzIG9mIHRoZSBtbHg1
IGNvcmUgZGV2bGluayBpbnN0YW5jZSBpcyB1c2VkIGJ5IG11bHRpcGxlDQo+ID4gYXV4aWxpYXJ5
IGRldmljZXMsIG5hbWVseSBuZXQsIHJkbWEsIHZkcGEuDQo+ID4gMi4gQW5kIHNvbWV0aW1lIG5l
dGRldmljZSBkb2Vzbid0IGV2ZW4gZXhpc3RzIHRvIG9wZXJhdGUgdmlhDQo+ID4gZXRodG9vbCAo
YnV0IGRldmxpbmsgaW5zdGFuY2UgZXhpc3QgdG8gc2VydmUgb3RoZXIgZGV2aWNlcykuDQo+ID4g
My4gZXRodG9vbCBkb2Vzbid0IGhhdmUgbm90aW9uIHNldCB0aGUgY29uZmlnIGFuZCBhcHBseSAo
bGlrZQ0KPiA+IGRldmxpbmsgcmVsb2FkKQ0KPiA+IFN1Y2ggcmVsb2FkIG9wZXJhdGlvbiBpcyB1
c2VmdWwgd2hlbiB1c2VyIHdhbnRzIHRvIGNvbmZpZ3VyZSBtb3JlDQo+ID4gdGhhbiBvbmUgcGFy
YW1ldGVyIGFuZCBpbml0aWFsaXplIHRoZSBkZXZpY2Ugb25seSBvbmNlLg0KPiA+IE90aGVyd2lz
ZSBkeW5hbWljYWxseSBjaGFuZ2luZyBwYXJhbWV0ZXIgcmVzdWx0cyBpbiBtdWx0aXBsZSBkZXZp
Y2UNCj4gPiByZS1pbml0IHNlcXVlbmNlIHRoYXQgaW5jcmVhc2VzIGRldmljZSBzZXR1cCB0aW1l
Lg0KPiANCj4gU3VyZSB0aGVzZSBhcmUgZ29vZCBwb2ludHMuIE9UT0ggZGV2bGluayBkb2Vzbid0
IGhhdmUgYW55IG5vdGlvbiBvZg0KPiBxdWV1ZXMsIElSUSB2ZWN0b3JzIGV0YyB0b2RheSBzbyBp
dCBkb2Vzbid0IHJlYWxseSBmaXQgdGhlcmUsIGVpdGhlci4NCj4gDQoNClRoZSBwb2ludCBpcywg
bWx4NSBoYXMgZGlmZmVyZW50IGFyY2hpdGVjdHVyZSBjb21wYXJlZCB0byBvdGhlcg0KdmVuZG9y
cywgRVFzLCBJUlFzIGFyZSBjb25zaWRlcmVkIHNoYXJlZCByZXNvdXJjZXMgb2YgdXBwZXIgbGF5
ZXINCnByb3RvY29scy9pbnRlcmZhY2VzLg0KDQpldGh0b29sIGlzIG5ldGRldiBzcGVjaWZpYy7C
oA0KRVEgY29uY2VwdCBtaWdodCBub3QgYXBwbHkgdG8gYWxsIHZlbmRvcnMgZXZlbiB3aXRoIGxh
c3QgZ2VuIEhXLg0KDQpuZXRkZXYvZXRodG9vbCBzaG91bGRuJ3QgYmUgY29udHJvbGxpbmcgY29u
Y3JldGUvYXJjaCBzcGVjaWZpYw0KcmVzb3VyY2VzLiBiZXR0ZXIgaWYgd2Uga2VwdCBldGh0b29s
IGFic3RyYWN0IChxdWV1ZXMsIHJpbmdzLCBhbmQNCmV0aGVybmV0IHNwZWNpZmljIC4uKQ0KDQoN
Cj4gPiBTaG91bGQgd2UgZGVmaW5lIHRoZSBkZXZsaW5rIHJlc291cmNlcyBpbiB0aGUgZGV2bGlu
ayBsYXllciwNCj4gPiBpbnN0ZWFkIG9mIGRyaXZlcj8NCj4gDQo+IEknbSBub3Qgc3VyZSBob3cg
dGhlIEVRRSBmaXRzIGludG8gdGhlIGV4aXN0aW5nIGRldmxpbmsgb2JqZWN0cy4NCj4gcGFyYW1z
IGFyZSBub3QgbXVjaCBvZiBhbiBBUEksIGl0J3MgYSBnYXJiYWdlIGJhZy4NCj4gDQoNCmRldmxp
bmsgaXMgZ29vZCBwbGFjZSwgaXQgaXMgd2hhdCB3ZSBkZWNpZGUgaXQgc2hvdWxkIGJlLCBhIGdh
cmJhZ2UgYmFnDQpvciBhIHN0YW5kYXJkIHBsYWNlIGZvciBhbGwgZ2VuZXJpYyBuZXR3b3JraW5n
IGRldmljZSByZWxhdGVkIGtub2JzLg0KDQo+ID4gU28gdGhhdCBtdWx0aXBsZSBkcml2ZXJzIGNh
biBtYWtlIHVzZSBvZiB0aGVtIHdpdGhvdXQgcmVkZWZpbml0aW9uPw0KPiANCj4gWWVzLCBwbGVh
c2UuDQoNCmxldCdzIHNlbmQgYSBSRkMsIENDIEppcmkgb2YgY291cnNlIGFuZCBvdGhlciB2ZW5k
b3JzIHdobyBtaWdodCBiZQ0KaW50ZXJlc3RlZCBhY2NvcmRpbmcgdG8gSmFrdWIncyBncmVwICho
dWF3ZWkvaGluaWMsIGlibS9laGVhLA0KbWljcm9zb2Z0L21hbmEsIHFsb2dpYy9xZWQpIC4uIA0K
DQoNCg0K
