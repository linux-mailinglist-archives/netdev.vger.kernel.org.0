Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B552304B6
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 09:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgG1Hxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 03:53:37 -0400
Received: from mail-eopbgr30086.outbound.protection.outlook.com ([40.107.3.86]:56037
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727858AbgG1Hxg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 03:53:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J7LvXOGN6ALNzPpG2/tBOXf0Xg1YhO9E4GkDo+30zI6/pk+ZoB6auBcdoB/UpUSa8aR5Qw2WHTRzF7YHHlS33CIuVNSYf1ugIZcte1pjl9ZlOTTy47WreuDUdghDOO28AsjBazYKd6Yv0TTINVCbqLbPOFqoq7//b+57VTKX8Z9T46EV2RYL8ArXCftqWgTLZAgUxoWaeWYWOl1Jvs24tlAYmlaWK8zmilKFkY4DjQdlBM+p2iQRYTAGpdr/sxkeBxsuTlQh6J15IQvU9uEiI0n9SW4wvKnNdcRa+p15mEnU4QwiHn80svjqRu0LGoub0x4K18aOXwdJkUTNrqiXgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NZnERtvbhPuGyKvX92J4vnyIZUqfqAc0yFtRYOPiuDE=;
 b=VheSx2Gms7q1J8INVpjXcv3vpFU4mUrqGov66TdGLH/FvaTjkplH5rNw8DbY9bNpRS/7zL76//BTTeiPkPk9pwiWczGPAFDVqnR6KaFONu75Euv/vwx2STJiQb7agXWIhecWsPoLWpGN8PuJ6gEWyJeffsGv9ohEnBSY+FPwRFjZAmZP6xL5KL/Z6ree5cXqHdsh6SLNBs5/qQbp7XnttMgnX+lusnLi+pabgacKX51OKV0IfNBNWwjiVep1kchLyDOxfVO2jG4icfGFdoaT4wEv+Iozvg1Ps8mOJ/EihfjtIG0chgNMyJbRGwIZxGZjjD1ndF6KA6fUhiKAF+jjlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NZnERtvbhPuGyKvX92J4vnyIZUqfqAc0yFtRYOPiuDE=;
 b=lrgSwa4pRWFR4IMIOdzZj63IEypR1OTzgfalRZURlZ2KYN2fMMr6hYvzSLbaOmuwJw6oOJ5j+ARYzuqnRXmGamv95n7SFskLVkc4pSARigw1cDz6W4QK4KpPYCAqhcLRmA3iWB27VRKsr8ggTis9KmyAnwYUJZ7DwB4QynxZb0I=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (2603:10a6:20b:9::29)
 by AM6PR05MB4199.eurprd05.prod.outlook.com (2603:10a6:209:42::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.30; Tue, 28 Jul
 2020 07:53:33 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d803:a59d:9a85:975f]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d803:a59d:9a85:975f%7]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 07:53:33 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Boris Pismenny <borisp@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>
Subject: Re: [PATCH][next] net/mlx5: Use fallthrough pseudo-keyword
Thread-Topic: [PATCH][next] net/mlx5: Use fallthrough pseudo-keyword
Thread-Index: AQHWZD98Saxv498NzUW3VV4RuPmQmakb31QAgADAjIA=
Date:   Tue, 28 Jul 2020 07:53:32 +0000
Message-ID: <8d821a65b4cf4b65f229d6b06463f05d2e367557.camel@mellanox.com>
References: <20200727180356.GA26612@embeddedor>
         <20200727.132422.1547209251691848168.davem@davemloft.net>
In-Reply-To: <20200727.132422.1547209251691848168.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 27bfcaea-700c-494b-f68e-08d832cb5359
x-ms-traffictypediagnostic: AM6PR05MB4199:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB41995040EA0EAFCE07B362F4BE730@AM6PR05MB4199.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rciYivnzVE0MrEZbq3Iba516+OVDUs95g1VHpBw8id98d/eQrG0dZ06re2DOykiYgvfx/hm1y9IV9bmICLE4Gz7om/mdrvlDJtdlVr5GPkJSex8Z8qbhNKbq79hPqztXTRM9dfV+tS+nwkS7aRJljwyBEQ6RQS3YuZpBo1JOCsLVZjP40pi6BU5wcXU2uwOEbOxVIAmr7Lu5Yt61qDU0jn1okfWH85iFP7Y+uJ2KUxqOI3KuhOgxwn2uyEzwURXLM4RiYid3neCS20UIhOK7E3b1te1IOfhDxqjOz8F1LZnUekLBpJNOB0uc/e76uiRAbhmmxq0eCe2grvCD2iXB0E1V3ToFJTMAmxrJS2q/e6RAHPJ+cHsLbEjChABn7TkYt1fjjJhWfkjBY7WRG1e2Eg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5094.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(36756003)(71200400001)(76116006)(6486002)(64756008)(7416002)(66476007)(66556008)(186003)(66446008)(86362001)(2906002)(66946007)(91956017)(26005)(4326008)(5660300002)(2616005)(6512007)(8676002)(6506007)(4744005)(8936002)(54906003)(110136005)(478600001)(316002)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: xrsi/Mo2FdpKboR9vFc9w0SA58qaBzpPVDzqHt/PVOyyDhezLvCSGqMDwRnnLSlGLS8DGz2X/Qz3tFnU9eLD4P7BCCw4QjVySYcx9hSGVUEoOmrD9p1bEBOTaQS+KbX0o/Vome6Y+wFHR8Rg2bkQLoUFo1Gz8BzzuaczxSd2Ua8xlzbmgYxWV9QOG9ZX3nCNmeu/RIX43Vq5x94zUhu4JpnFEioAYGIZdWptEhJybr6HLsb/MqJpTWBLXn+EsiCrKkwDkD4JfGGT3Xax0kzXD/7kdPqbCwa3HIEDch4Bp5eNRLIKKlwi0cvXPjJpez6bhO2W+ADmRYFV/eP4HKSm4Y+rkJw20yddcjJlzryMz+hBaAEagfQfT1P2dj+Boc/Qt4z8J9IwY+tYJXo/VKLIjuXxbEMfWQDi8WzFEbMLX9h9n6BfosJs2O5OV9fol+ymSLEwD8D+2joLrX6oaVQhnT3MPGmS2srk7egnMTVrEKg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <209E9E0FF9538A42B2BBAA692256E382@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5094.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27bfcaea-700c-494b-f68e-08d832cb5359
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2020 07:53:32.9870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iKMy32SDHygJUF8tOq07eFKRo3NJ6D2WB8Zk5ieRfXMeHIKtEx1rI37J+OnsVpNyElLILMBkpX5Sqwbny1L4+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4199
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTA3LTI3IGF0IDEzOjI0IC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206ICJHdXN0YXZvIEEuIFIuIFNpbHZhIiA8Z3VzdGF2b2Fyc0BrZXJuZWwub3JnPg0KPiBE
YXRlOiBNb24sIDI3IEp1bCAyMDIwIDEzOjAzOjU2IC0wNTAwDQo+IA0KPiA+IFJlcGxhY2UgdGhl
IGV4aXN0aW5nIC8qIGZhbGwgdGhyb3VnaCAqLyBjb21tZW50cyBhbmQgaXRzIHZhcmlhbnRzDQo+
IHdpdGgNCj4gPiB0aGUgbmV3IHBzZXVkby1rZXl3b3JkIG1hY3JvIGZhbGx0aHJvdWdoWzFdLiBB
bHNvLCByZW1vdmUNCj4gdW5uZWNlc3NhcnkNCj4gPiBmYWxsLXRocm91Z2ggbWFya2luZ3Mgd2hl
biBpdCBpcyB0aGUgY2FzZS4NCj4gPiANCj4gPiBbMV0gDQo+IGh0dHBzOi8vd3d3Lmtlcm5lbC5v
cmcvZG9jL2h0bWwvdjUuNy9wcm9jZXNzL2RlcHJlY2F0ZWQuaHRtbD9oaWdobGlnaHQ9ZmFsbHRo
cm91Z2gjaW1wbGljaXQtc3dpdGNoLWNhc2UtZmFsbC10aHJvdWdoDQo+ID4gDQo+ID4gU2lnbmVk
LW9mZi1ieTogR3VzdGF2byBBLiBSLiBTaWx2YSA8Z3VzdGF2b2Fyc0BrZXJuZWwub3JnPg0KPiAN
Cj4gU2FlZWQsIHBsZWFzZSBwaWNrIHRoaXMgdXAuDQo+IA0KPiBUaGFuayB5b3UuDQoNCkFwcGxp
ZWQgdG8gbmV0LW5leHQtbWx4NS4NCg0KVGhhbmtzLg0KDQo=
