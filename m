Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC9235988F
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 11:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhDIJFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 05:05:16 -0400
Received: from mail-eopbgr150078.outbound.protection.outlook.com ([40.107.15.78]:34491
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231526AbhDIJFP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 05:05:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Svs/Rso4+IBQTK+aYE38aydbf3oFzvbyCQyFBC5dprjJfZxEdVC8kW8WQ6x8C81PWpkWNEPondR5JhMNdbHRx91vOdGeu2LvAuiYI6jwq3su4XV2E9LLl6bZ+8Z8lV3ZbCWJ+q7iYcJ9ZNCBaaDIh2IuRqGEX8QMCVhr6031s/t1X1NSQCmSusmpjWpsKzxiqgPj4preKTYnxVKBer2mkCw7RfhMhsCRAO0suur9sWxnMswnk2+WKES0Dz3SbfWv2J5Ww8CdVjmlrLJ2uZxVSqcldoprX2JlLqRvTHjLLY7WNRgPXcnzvlnxy5CPQyeMeOGikVTiBT34eHZhElD/Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=99JdHtDElAJb6Qg29CppCEdxZodFEswkMrh91HfNR/U=;
 b=LWIKvRkc7oHg9Ffyyz/vOxslu7XxEsh8mbzxzM6hUU1i9Olx3/o35SJxyG94i1D7Uzx/YuYsAeQfVn0aGlNr3NMs/wcT7X/JNXpzXDK4JAEcIFTS8L1ARNztzP27W/fzmBoCfTFZw5yyKWt37HDV9P8FrSTZ/4Y9SmfhSIIGY7d6Uwv+AQTt9ZJu3ygFCVyXULDcj8+Eh0UcUfGnPPgtC5YkEex3mQEmk9EqujyE29RIHxb+dIJQ5aARkDVB1v8Tmg1sGqyAWbwfNTWyNXKdl6GcqSHZBh5rcgyoV8BMgtLYzYZnWC2lhMgC3BUod+hs3JnIzvFdinI1T7FT1owGOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=99JdHtDElAJb6Qg29CppCEdxZodFEswkMrh91HfNR/U=;
 b=avnIrH96c+yLUamgXVLFafKYQrRE+/QcII48kGxhlkDdptY6FPzt82Ai/a7MY3OEt7Kf/MWvExaVZALKrzPGgQ+o5+/EhFr9twcxVZDDls8JCcK3inc215ln4ICY+hmLPHYFhnM9t9e40yQvtKMdDtNH9sP/EI+MnVAjLBT9riY=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB2968.eurprd04.prod.outlook.com (2603:10a6:6:b::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.29; Fri, 9 Apr 2021 09:05:00 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.4020.017; Fri, 9 Apr 2021
 09:05:00 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "frowand.list@gmail.com" <frowand.list@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 0/3] net: add new properties for
 of_get_mac_address from nvmem
Thread-Topic: [PATCH net-next 0/3] net: add new properties for
 of_get_mac_address from nvmem
Thread-Index: AQHXLRutRfAcbJsnrkmRBAAPt6prD6qr5EaQ
Date:   Fri, 9 Apr 2021 09:05:00 +0000
Message-ID: <DB8PR04MB679517CF79ADE585D55645A3E6739@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210409083751.27750-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210409083751.27750-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b21a396f-b804-40c0-5f5e-08d8fb368e24
x-ms-traffictypediagnostic: DB6PR04MB2968:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR04MB2968223AE465C8B279A77237E6739@DB6PR04MB2968.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7uRkScvPDdLhtoODxia8w73I29xnYqIB5+waH+8eXqFA73LsTgzM7Sxr3OTwYX+Kb4mGIS77hQ1MauTT311LQBO8gOybmBn4sDn1ziF3T8G/hSLqVGdhApSFOC9j2RWk3+dByd1sc9iiBiGy7y01k68oB+zLFLXfyv/ko7WIv+UjJ2bdT4H8rXKKlb4LjSp7EA4R2hDsee/rGfOKSIwe3Osu1Q8zMGIfnlT9KmWq1BIOiwV9f7IzlpIz5yJepTmu+gGxXpCjIVxdeE/nra9YYWk7U6N2PCpzqzl1ORGt/Rh4Iqpm79QD52xLDr9onJFqM5jS5I2lwXKbm3b6nKq6cUHJlZi81uq8WUTzVcqwN7V6yI/8JehwIB7hyLxkcXReoqk1+Mr9AIhwtrfOqkcuut0b/XR2vpgy9SHXczkGN65d6lgISjnxSFLnBiMJANPskC9A4fSg2OZ1W9OjNainJFTFbLj6tnzRwBhYKfb2OqyWGADic6qa5M6uzlUihA99THCOr+40FCKtpiepy9jesOjKw598T4whRoVH1IyVIMz00wIOIrBVFItABsrUkXQDKheO7GBHpIdxAWpsdpM8NcqugCtt0JFqntGC16dGwmW0JESpgNvUTnaUL/cun5XWvh5Jc37ZaGNg2lf8VKhXaeNo0C7mmPMO4Nk2HvRaIks=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(396003)(366004)(2906002)(186003)(66476007)(316002)(52536014)(86362001)(55016002)(6506007)(110136005)(8936002)(76116006)(53546011)(4326008)(5660300002)(66946007)(33656002)(38100700001)(54906003)(7416002)(66556008)(66446008)(64756008)(478600001)(7696005)(8676002)(9686003)(26005)(71200400001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?Q2w0WG9mYjZVbHovMnFxYitpeEJ0d2FJd3FzczhJR25SeGlqNEE3Y3Q4aFh5?=
 =?gb2312?B?ekY0T3FySVZkSGVEc1R4WFZ1ZzlWY2lkRGxQTnAvUENweGt5dDZzclA1QXlM?=
 =?gb2312?B?VHU3eGhpclgwb1R1YURkZWIxY0NTMk9zMXMwVWlSRVJRUi85SXBjU0ExVWRy?=
 =?gb2312?B?VE9pSS95alM0SHJPT29zc1JQZFNCWmNLNElub2VvVzdzN0VwcnNqRktJVGgw?=
 =?gb2312?B?WUlDSVdvM2hyN3lpVHVvTksySHVRTDdIUVE0UC9HQTR1ck1pTGZDRG41YXJM?=
 =?gb2312?B?VVdRTVEvRFFUZm0wS2o5V2dmbzVRWEY4TE5GMWVvWWVCMDhuVWFxZDAzdWZN?=
 =?gb2312?B?K3NJeE1mMlcra1lrM0RKdHBJdFdSSDVjWnRBeHlUY1AwK3NQemdPRm5rdEVC?=
 =?gb2312?B?Zi9WZmJ5U3lWb0tpcjJhQjc5TWE3TTErNXZhWEs2UGxPTHdQNXhISEc2ZnVE?=
 =?gb2312?B?SWVoSDh6NXM5anZXb2F0V0w2b2g3RFMwVGJzTkN1ZENIemt4OWpKb05lSG95?=
 =?gb2312?B?eVpUcThmSDZSbmUvY0Mzd0UwN2dGR0tNOEkxZEd1bTRPTXFuR2FZU1FSaDdM?=
 =?gb2312?B?MnVGelQxTnJTT3FlUmpyRVZoalAxbStxbTd3M2h5T0RHaEVSMFpuTGhtMCtI?=
 =?gb2312?B?QXFhR0EvOTdnWHMvNkpDNUZLd2d2dmlYWlpKMHVQZTJSNms4eW9RQVVzTmVp?=
 =?gb2312?B?QnVHNGhKSmJ1aEhsU05BRUlCNjJXd3FMbk1HVEZRV3ZBUUtYVEFramRIQisz?=
 =?gb2312?B?SUZtWDY4M3hXdE9ENndqempMTDVQcU9nSTExVUFheHVrUUxRZ2dzM1lkZjRu?=
 =?gb2312?B?aURpM2o0eG5BRmVHNWJYSnQ3RGdxSnRBUStpN1pJY3hHT3F6bHdJdjJQZGNJ?=
 =?gb2312?B?SzdPL25tQzdOYjExUHA3eExoQlNwTHM1Q1YxQk91WkZVSENXenR5ZHNsS2wr?=
 =?gb2312?B?M0EvRWxaZHNKZS90ak9GZ3RUTlBGendZUThZVjVWeGFKeXVoQlhnb3pvT3J6?=
 =?gb2312?B?NHFoREV5MkZueWpvU2Q5Z3dnZjRjUHhPRGc5S2N4dXlCdDV5Y2kvOEd5UU4x?=
 =?gb2312?B?ZVBDbVRDTGplSFBpL3hHZXpMYUprc2ltcWZBMnB5MHBoVUFPZFNiZnUyNDR5?=
 =?gb2312?B?UVB1SHRBZXJoR05OQlAyTWJSakFuSTIxZlg5ZFF0RS9RZUhYckR0U0FibnVl?=
 =?gb2312?B?ZHZmdVBzK1o1YzM0QzBKREFQS1hqUGo1Vm9sT2MxcUxUb1lhcjZVa3grK2FY?=
 =?gb2312?B?VlFmWXJ0cXZKeEVGdkRwWFNwb2x3eEg5TjN3NDNMR3RMeXBUUkYvL3NpaGI5?=
 =?gb2312?B?eHdPQ25USmpxYWY2Wm9lVWxpWnZSaVFkL1JYaGFHa1FQNlZocVh3TkRORXpN?=
 =?gb2312?B?ekJOQWVYbm9FL1F5UVNRNXhCUjYrMVlUWEFxeVp3TDl6dEVkdDlTcXpBMkJi?=
 =?gb2312?B?d05WTkN6cWZWMWpFOEtCLzBzbW8xdU9VdGpiUHBXeG4xV3gxSE9mclpkN0h5?=
 =?gb2312?B?NUN6RlBZa0NRQmtwRDR2UllEZEwyM1ZVNHJ3ZjFxNjBpZlNqaGhhdXcrVVVU?=
 =?gb2312?B?S2thTWlDMFhwWnU2ZnR2VnpBRXd2a3Y2elY2VUNpZmw5bTQ4ektGRHJkaTRN?=
 =?gb2312?B?aVJtdlM5R29LS0ZqYy9EU00vbUFlaVVnMGs4amhzNnJHdkZkQUlDSmlWZkxr?=
 =?gb2312?B?V2JKaTJzK3JDQUJzalNjUDIwNGtmOVJmazdLcXBESUMrWnJ1bldySkRYRGFx?=
 =?gb2312?Q?6O3NpIhnGZmTdkTiOo1hvXJEBvOiyIRzLyY3czO?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b21a396f-b804-40c0-5f5e-08d8fb368e24
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2021 09:05:00.3623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dcRdfnG80vqqworkjK9ddLpPfMk44JH9/bfwch6cySZSWSgwVhkyNWB4mulpTIFSiBJJv+Kn2NLyl2SCqCD4DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB2968
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSwNCg0KUGxlYXNlIGlnbm9yZSB0aGlzIHBhdGNoIHNldCB2ZXJzaW9uLCBJIHdpbGwgcmVz
ZW5kIGl0LCBzb3JyeS4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQoNCj4gLS0tLS1P
cmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9ha2ltIFpoYW5nIDxxaWFuZ3Fpbmcuemhh
bmdAbnhwLmNvbT4NCj4gU2VudDogMjAyMcTqNNTCOcjVIDE2OjM4DQo+IFRvOiBkYXZlbUBkYXZl
bWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IHJvYmgrZHRAa2VybmVsLm9yZzsNCj4gYW5kcmV3
QGx1bm4uY2g7IGhrYWxsd2VpdDFAZ21haWwuY29tOyBsaW51eEBhcm1saW51eC5vcmcudWs7DQo+
IGZyb3dhbmQubGlzdEBnbWFpbC5jb20NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRl
dmljZXRyZWVAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3Jn
DQo+IFN1YmplY3Q6IFtQQVRDSCBuZXQtbmV4dCAwLzNdIG5ldDogYWRkIG5ldyBwcm9wZXJ0aWVz
IGZvciBvZl9nZXRfbWFjX2FkZHJlc3MNCj4gZnJvbSBudm1lbQ0KPiANCj4gVGhpcyBwYXRjaCBz
ZXQgYWRkcyBuZXcgcHJvcGVydGllcyBmb3Igb2ZfZ2V0X21hY19hZGRyZXNzIGZyb20gbnZtZW0u
DQo+IA0KPiBGdWdhbmcgRHVhbiAoMyk6DQo+ICAgZHQtYmluZGluZ3M6IG5ldDogYWRkIG5ldyBw
cm9wZXJ0aWVzIGZvciBvZl9nZXRfbWFjX2FkZHJlc3MgZnJvbSBudm1lbQ0KPiAgIG5ldDogZXRo
ZXJuZXQ6IGFkZCBwcm9wZXJ0eSAibnZtZW1fbWFjYWRkcl9zd2FwIiB0byBzd2FwIG1hY2FkZHIN
Cj4gYnl0ZXMNCj4gICAgIG9yZGVyDQo+ICAgb2ZfbmV0OiBhZGQgcHJvcGVydHkgIm52bWVtLW1h
Yy1hZGRyZXNzIiBmb3Igb2ZfZ2V0X21hY19hZGRyKCkNCj4gDQo+ICAuLi4vYmluZGluZ3MvbmV0
L2V0aGVybmV0LWNvbnRyb2xsZXIueWFtbCAgICAgfCAxNCArKysrKysrKysrKw0KPiAgZHJpdmVy
cy9vZi9vZl9uZXQuYyAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDQgKysrDQo+ICBuZXQv
ZXRoZXJuZXQvZXRoLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAyNQ0KPiArKysrKysr
KysrKysrKystLS0tDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDM4IGluc2VydGlvbnMoKyksIDUgZGVs
ZXRpb25zKC0pDQo+IA0KPiAtLQ0KPiAyLjE3LjENCg0K
