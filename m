Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3937B115A8
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 10:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfEBIo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 04:44:26 -0400
Received: from mail-eopbgr40083.outbound.protection.outlook.com ([40.107.4.83]:28494
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725951AbfEBIo0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 04:44:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P2yGAJcHu5IwfQKbKzjn1UcAXGjzsMooAqTNnDq8Zsg=;
 b=PNEvYgLRByPNkvuHeaTsuWoHRu0poaBiSUYK1MVI0UGzYMtH4VgHzB8Sy93F+8HQJZrRLj5ZbdNc15fr5a8472auxrpm29gp1SfhTNGIVY8k/0jdinC6oJmVQP2OCJzp1gcG6q396+BZyOruBFUMiiniymnuLINWulOEE07Z0gk=
Received: from AM0PR0502MB4068.eurprd05.prod.outlook.com (52.133.38.142) by
 AM0PR0502MB3827.eurprd05.prod.outlook.com (52.133.47.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Thu, 2 May 2019 08:44:22 +0000
Received: from AM0PR0502MB4068.eurprd05.prod.outlook.com
 ([fe80::c978:d8d3:5678:4488]) by AM0PR0502MB4068.eurprd05.prod.outlook.com
 ([fe80::c978:d8d3:5678:4488%3]) with mapi id 15.20.1835.018; Thu, 2 May 2019
 08:44:22 +0000
From:   Eran Ben Elisha <eranbe@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@mellanox.com>
Subject: Re: [Patch net-next v2] net: add a generic tracepoint for TX queue
 timeout
Thread-Topic: [Patch net-next v2] net: add a generic tracepoint for TX queue
 timeout
Thread-Index: AQHVAJK/vS0YpBROGE+0RuPjVoT/l6ZXhVIA
Date:   Thu, 2 May 2019 08:44:22 +0000
Message-ID: <a1d1c7d3-047b-ce63-8466-a1eba7c0f106@mellanox.com>
References: <20190502025659.30351-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20190502025659.30351-1-xiyou.wangcong@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR06CA0047.eurprd06.prod.outlook.com
 (2603:10a6:208:aa::24) To AM0PR0502MB4068.eurprd05.prod.outlook.com
 (2603:10a6:208:d::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=eranbe@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd8b59cc-782f-4ba8-ccfd-08d6ceda5f9c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM0PR0502MB3827;
x-ms-traffictypediagnostic: AM0PR0502MB3827:
x-microsoft-antispam-prvs: <AM0PR0502MB3827184E9CE3C32E5787B329BA340@AM0PR0502MB3827.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-forefront-prvs: 0025434D2D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(376002)(39860400002)(396003)(136003)(199004)(189003)(102836004)(53546011)(478600001)(446003)(66946007)(66556008)(486006)(66476007)(11346002)(2616005)(86362001)(4326008)(305945005)(8936002)(81166006)(3846002)(64756008)(476003)(186003)(81156014)(2501003)(25786009)(31686004)(2906002)(14454004)(66446008)(6506007)(26005)(256004)(386003)(73956011)(6246003)(110136005)(31696002)(6486002)(71190400001)(71200400001)(7736002)(36756003)(68736007)(6436002)(66066001)(6116002)(107886003)(99286004)(53936002)(6512007)(52116002)(316002)(8676002)(229853002)(5660300002)(4744005)(76176011)(41533002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0502MB3827;H:AM0PR0502MB4068.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kj01PDH80MOqxsMKArfRLMt6IMCsOkagU+V0wWZ7JNla2INZ/eIghd8OEj9IvJ4eKsQxzF/yXAZrFUo8g6c0R3c/bKUR+5MUUytlBlwm4/E/qrwpqv9mhjCd9xwaquclKgbngQi953uUCmn+efUByITaWM/SUqw0UDEe2iuh9TaXVEOALl0phEwBdLx1jHA7b92rxHbOj4pcI0n2jjq4EixPbEFxYbJab0i1r2qsDJkvX7IWBUnRjAZc+4OXT1KA1hmxhXPNlQONVCaSbzH9YmqYdGGraM/8V+73U2OdhQttygx404IlbZ1xbhqDXmG0zfP3Ey004c5c+PHDdkewxi80MaJB1/uL1xMkDn4E5FpsBVI5NUC/gtteF5KwRjIQt5hVeirgHpaeF3nE2rSa6REuPdxSuCWdP4GeB5Z7uBM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A913B88E4012094D849517C0DE278403@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd8b59cc-782f-4ba8-ccfd-08d6ceda5f9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2019 08:44:22.4569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3827
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMi8yMDE5IDU6NTYgQU0sIENvbmcgV2FuZyB3cm90ZToNCj4gQWx0aG91Z2ggZGV2
bGluayBoZWFsdGggcmVwb3J0IGRvZXMgYSBuaWNlIGpvYiBvbiByZXBvcnRpbmcgVFgNCj4gdGlt
ZW91dCBhbmQgb3RoZXIgTklDIGVycm9ycywgdW5mb3J0dW5hdGVseSBpdCByZXF1aXJlcyBkcml2
ZXJzDQo+IHRvIHN1cHBvcnQgaXQgYnV0IGN1cnJlbnRseSBvbmx5IG1seDUgaGFzIGltcGxlbWVu
dGVkIGl0Lg0KPiBCZWZvcmUgb3RoZXIgZHJpdmVycyBjb3VsZCBjYXRjaCB1cCwgaXQgaXMgdXNl
ZnVsIHRvIGhhdmUgYQ0KPiBnZW5lcmljIHRyYWNlcG9pbnQgdG8gbW9uaXRvciB0aGlzIGtpbmQg
b2YgVFggdGltZW91dC4gV2UgaGF2ZQ0KPiBiZWVuIHN1ZmZlcmluZyBUWCB0aW1lb3V0IHdpdGgg
ZGlmZmVyZW50IGRyaXZlcnMsIHdlIHBsYW4gdG8NCj4gc3RhcnQgdG8gbW9uaXRvciBpdCB3aXRo
IHJhc2RhZW1vbiB3aGljaCBqdXN0IG5lZWRzIGEgbmV3IHRyYWNlcG9pbnQuDQo+IA0KPiBTYW1w
bGUgb3V0cHV0Og0KPiANCj4gICAga3NvZnRpcnFkLzEtMTYgICAgWzAwMV0gLi5zMiAgIDE0NC4w
NDMxNzM6IG5ldF9kZXZfeG1pdF90aW1lb3V0OiBkZXY9ZW5zMyBkcml2ZXI9ZTEwMDAgcXVldWU9
MA0KPiANCj4gQ2M6IEVyYW4gQmVuIEVsaXNoYSA8ZXJhbmJlQG1lbGxhbm94LmNvbT4NCj4gQ2M6
IEppcmkgUGlya28gPGppcmlAbWVsbGFub3guY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBDb25nIFdh
bmcgPHhpeW91Lndhbmdjb25nQGdtYWlsLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IEVyYW4gQmVuIEVs
aXNoYSA8ZXJhbmJlQG1lbGxhbm94LmNvbT4NCg==
