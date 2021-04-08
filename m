Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED41357BF3
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 07:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhDHFpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 01:45:25 -0400
Received: from mail-eopbgr80087.outbound.protection.outlook.com ([40.107.8.87]:20818
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229649AbhDHFpY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 01:45:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDkgqxmF+LS18b09H7D63nzDdOcYaOXI4q6GEPoxyWPp9LKifhqLzyOruzReRm8z46kzDKjA3IUmGAjqBsttMDwSLi/DaJ67IzoDWIKPkfFtRtnFH9AQzyn28vl0df1yjy9M/tzW5m7gVX0B9k3gLq+Qahu9f/wPOpCst4EpZoqrHAm7ltPyuWrZ3vXM9E1KgDuHXsc4DBDcUC7IVLrCSmVYaU0JjJbaEWwygu1KinzyFUE7a6YjLKW6sa+8uM64CPa/0osm8QWdB2bxvYoqKwYYZDJU94ycGInum1IZLEKbwrAQVP/5rkpuTPTJ0daUUqsp8+u/CX6zpkewXIsI4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0mHcQrOToRiqAuKt1LCcKA1Pg5bq02odTaC+LsEB9M=;
 b=TOYMkkXkIOhSSZV0TRpmI9Pkwub5MLCHZL6NjlcQo0zOIDFBQHq2qb0IQ+v7rnA++zK1gLhug+NWBmM5VHg8DZlkNK28vRxflQSAuxZBAesO5XGmlA5MZTS1mT+2w9qwJE3asa+NKXSrWmFHm+67xVLAeJ7Ak2wBQvVgX/NeuP/aNAQFLkKB71YYbjbvS2VUUSEKb4v3iQ1MwYPvoQJO5nrvaGXuxfIQwdsKJGKG/8O9r65L56SoZ3jvfQ5OjY4C/uqUVtgbfwFtboSkVSpJTxOyBxJ+AJF6UfVZ+R3jQ7WHi1rqKcZcarc6NKtoCLwjbulO76ErLlhotaUwwxgUeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0mHcQrOToRiqAuKt1LCcKA1Pg5bq02odTaC+LsEB9M=;
 b=BMKcrt8uGg6NMnc7611nNxr9CMKfMNbblnmOJ/lbNaHg36mRd9Wlwx5vUQwfHeU963Ghcsif+yPZ1spaz9T3COZt7zy5DqTY47k1q4QqNSAZD5WsIY2S5kOmsgCdzGU1oHI5fGXy/6NUOKU4kJU6G6dycy5/zTRTepjWqAZxj04=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7480.eurprd04.prod.outlook.com (2603:10a6:10:1a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Thu, 8 Apr
 2021 05:45:11 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.4020.017; Thu, 8 Apr 2021
 05:45:11 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Fugang Duan <fugang.duan@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 2/3] net: fec: use mac-managed PHY PM
Thread-Topic: [PATCH net-next 2/3] net: fec: use mac-managed PHY PM
Thread-Index: AQHXK8Y/eghzBz30zU6atrIS44hsGqqqHHfA
Date:   Thu, 8 Apr 2021 05:45:11 +0000
Message-ID: <DB8PR04MB679540FF95A7B05931830A30E6749@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <9e695411-ab1d-34fe-8b90-3e8192ab84f6@gmail.com>
 <a34e3ad6-21a8-5151-7beb-5080f4ac102a@gmail.com>
In-Reply-To: <a34e3ad6-21a8-5151-7beb-5080f4ac102a@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9d1ca5d-5c5e-4505-6e2b-08d8fa5179bb
x-ms-traffictypediagnostic: DBAPR04MB7480:
x-microsoft-antispam-prvs: <DBAPR04MB748039359D1924A93FD5A7ECE6749@DBAPR04MB7480.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3W3bcefU2Ns3OVVGdTMIN2BK+bo+hClo6CfElFcM8EIEpLhJhn1jNzZJcF36AEemeMLXlyKDt413nlVuhkHn8BaEXm2cyrpq6gP3W/16YrVBbsG2vTYuaOw91YEnz4iuYHTb790tmGQ9WWbuP8pXEAjoZ5v/z/QyHwGUv06WrBSBSqGWgK7IgM6kOhC11/8xKc6fzMG6raV0tHfqE9m8Hi2aPbwfiyjvFeEqW4bAeBKIjGJhQts1g0CdDurazfiW0p4bLaJRyMaw/oQuhAgNhvpdZlmyqffz6a+sMXoWq9u8yq4Y4wdrDfmBX5wXMOZ+2HOwYLlwqnOQR2cF1Zdw9cQnCtGojhJK0tMOvz+QO8hmyJCrgfg3uk2Farh2tkxJli0XGJuPnYLOOiUIqrdgwd0C3jiVHHF1EBegPh9cVFscmkGX6+iGaIu9W2Cm2FJXF8cQxjAqB5I71jTX9SjWQw4+dZEJud3sYGpEfbPGpfy6tEByJ/UMynBh+pvSTTvYp9heYtkOymGY+yO6RAlLSqXlvrF3I+TDYFQ1JHrUyRzGjULUhwpvoJgI/bK2IoYDamRIvCjsiW5FkdH91JvSSKiuGUQL52hjp7S+ZjWzNZTa7FHvcjpLCULYVrolbMMu5GnwGxI85M5dNqfnyOzydFI/JsSn+Gc97p3KuYxVFc4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(478600001)(6636002)(26005)(9686003)(66446008)(64756008)(83380400001)(55016002)(110136005)(71200400001)(76116006)(7696005)(52536014)(33656002)(5660300002)(8676002)(316002)(6506007)(66556008)(66476007)(8936002)(53546011)(2906002)(86362001)(66946007)(38100700001)(4326008)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Ni9FeXZ2WEpPQUlKQUtUcFFGL1FHaWdzVUVkdFJzbVdUdXJKd0U0MExpM2Vj?=
 =?utf-8?B?cFA4VXhDVFlmOGZCWVE0RUdSQmtWelN0d2drZVA2ZGkzZ3JPVUp2cXd4U0I3?=
 =?utf-8?B?ZjFDdjYzZ3JocHVsVlFORlFmOVhqMlMyMXZKMktlOUZzZ2pkVnRsVzhkTnpK?=
 =?utf-8?B?bXplMGZLTjMydXIveWVyQ1RIT0p2V1RmTzlHY3ZCRVJ5eENQcTMrelU5NUtE?=
 =?utf-8?B?YnhXcm9sNW1vSjRkem9BRXBEVS81MVhPNnNHd0N2SVJaUldFUjEwd0c3RnIy?=
 =?utf-8?B?L0JuVi9lVVFxMzZ2SjJKeWExb3I1bk1GTktVRGxwRFRKWVVhaGF4RGU2bFM2?=
 =?utf-8?B?ekpMUkR6TUdTcS9sc2hhbnliOG0yeEpTSXdBVGVsSGQ1RklkY3hLZldDYXIz?=
 =?utf-8?B?UGRYTk1mWndKWnQ4SjNGTkp6UVNqdlBRazdYNGZhaTY4U0szbWcxTDRrR21h?=
 =?utf-8?B?Q0tJQzBVSnZYNURlemNVUVBhNk9WMmpva0hBNDJSYllTRXk4bE80dktqVXJm?=
 =?utf-8?B?eElHT3YvMXgya0ZMcFZJUDRzVDlWd0pMRS9KelNNNkpTeS9jVHk1dmVnTGI2?=
 =?utf-8?B?NHp0c0hVNXp1TkdBMW05M0k5aitUWFcyOXQzWHNLMzg4QjZ6ZzJBRGFsSG5T?=
 =?utf-8?B?ZXJoU2Yzc3RrRWhncVJacHNLdmZiUWQzWFhZbmNrTG1VejVsNDhrSGFuWW5P?=
 =?utf-8?B?VUVUUmVmRnZiQlZ0KzlDaXR2UHFHVXd4b0xDbnhCWjVzUnUxYzdNUlVzbk9s?=
 =?utf-8?B?MkFwaGNvbUxDUFBwWGJMRnY0d3h5TFhYamsrQmpqeDdUU2Z5U2dkWUJtUFJ4?=
 =?utf-8?B?Z0JFTm1sTzdmakhDSmltTmtJMVFSc0FlbGswWmJjUkxLZTJWZGphOGVIRmlQ?=
 =?utf-8?B?SDZySFJCTDVkSWR0ZmR0dkNlVmNFU0FTckFtUEc1VTR4eW0waGxtZjlnd0M2?=
 =?utf-8?B?K3g3UVZPMG5mN3hxWm5KVS9wOWxBbUZEU2FyRXZLdXVZZkVPNlN4L1ZadEpl?=
 =?utf-8?B?NFRCRFVUUy91ZGwxTDJDUmdRek1QUW5aT3FRSGxFMndRM3JnT0VJdGU4TllQ?=
 =?utf-8?B?RGxMSnRwY29BUG1aV2MwZUNFWW9BVEZocmNIK3JwMzd5bzNhNEtPZE9DbFlL?=
 =?utf-8?B?d3d1ZHoyNnhHdEZKTFNTd3FqMXhiWlBjdEJFQkhoamdXRUJqdHF0a3ZqOGFw?=
 =?utf-8?B?ZXZTMEROZndrdjI5QnczWHN6bk1nbXh4aDBhd1R2MDhRbGU0UTJiUjZudDNJ?=
 =?utf-8?B?RzhqUk5iYkZKWlNCSWozcTJDTDZqNjdCSUN6RWpEdTJXQWVkaEd6UExRcWNX?=
 =?utf-8?B?QklpOE5aOUhSNFRHaDNES3Fta0lkajRjUHBCVHJyd2w2REF2TUxmOXZwdTJX?=
 =?utf-8?B?a0x6aWVoQkxxU1lyeGdEQ3F2MGpNT05kNXlDeDQ4OER6MWRZTnQ5ZDRnMG9k?=
 =?utf-8?B?RVRURVhOMXNoZXNrcVF6K2RGNHJHOGxvdFVicWlTaWovQlY4bkJvSDRNOVlZ?=
 =?utf-8?B?MC9aNEIzQ1JScWFZS2lQbEgvMThRVTcwUjkxeTBUVXkzZVl0cmNFYVdRd2RL?=
 =?utf-8?B?ek1xcnQ5NkxrLzFidm1nZFd6NjlHZVNJMjY4NEJNWGRxekZUQ2JzdWpOOHZp?=
 =?utf-8?B?MU1qcEVLQlhkbTRySGhXNnF0eWRhK1ZlQmEyeXpyUW1aWkxLLzJhOElJNjV3?=
 =?utf-8?B?aVdaSktmdDZJQjNoWkV5WmFUb3pEciswRUYwR0dVRXdMOUhLRVJDek9KZmht?=
 =?utf-8?Q?nZSFLjaB/omF/UrgzT9xDjeXEXNdxKWytiSngNz?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9d1ca5d-5c5e-4505-6e2b-08d8fa5179bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2021 05:45:11.3959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XuzlE1D3bxKVCoYVKp39VA07en8cb4pfAzm4ydcE390mXReFSZG1YufbcZMelr++kHt38fY29pqr3aC0s/A+Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7480
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEhlaW5lciBLYWxsd2VpdCA8
aGthbGx3ZWl0MUBnbWFpbC5jb20+DQo+IFNlbnQ6IDIwMjHlubQ05pyIN+aXpSAyMzo1Mw0KPiBU
bzogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPjsgUnVzc2VsbCBLaW5nIC0gQVJNIExpbnV4
DQo+IDxsaW51eEBhcm1saW51eC5vcmcudWs+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwu
b3JnPjsgRGF2aWQgTWlsbGVyDQo+IDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgRnVnYW5nIER1YW4g
PGZ1Z2FuZy5kdWFuQG54cC5jb20+DQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBKb2Fr
aW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0ggbmV0
LW5leHQgMi8zXSBuZXQ6IGZlYzogdXNlIG1hYy1tYW5hZ2VkIFBIWSBQTQ0KPiANCj4gVXNlIHRo
ZSBuZXcgbWFjX21hbmFnZWRfcG0gZmxhZyB0byB3b3JrIGFyb3VuZCBhbiBpc3N1ZSB3aXRoIEtT
WjgwODENCj4gUEhZIHRoYXQgYmVjb21lcyB1bnN0YWJsZSB3aGVuIGEgc29mdCByZXNldCBpcyB0
cmlnZ2VyZWQgZHVyaW5nIGFuZWcuDQo+IA0KPiBSZXBvcnRlZC1ieTogSm9ha2ltIFpoYW5nIDxx
aWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gVGVzdGVkLWJ5OiBKb2FraW0gWmhhbmcgPHFpYW5n
cWluZy56aGFuZ0BueHAuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBIZWluZXIgS2FsbHdlaXQgPGhr
YWxsd2VpdDFAZ21haWwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVz
Y2FsZS9mZWNfbWFpbi5jIHwgMyArKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMo
KykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVj
X21haW4uYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jDQo+
IGluZGV4IDNkYjg4MjMyMi4uNzBhZWE5YzI3IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiBAQCAtMjA0OCw2ICsyMDQ4LDggQEAgc3RhdGljIGlu
dCBmZWNfZW5ldF9taWlfcHJvYmUoc3RydWN0IG5ldF9kZXZpY2UNCj4gKm5kZXYpDQo+ICAJZmVw
LT5saW5rID0gMDsNCj4gIAlmZXAtPmZ1bGxfZHVwbGV4ID0gMDsNCj4gDQo+ICsJcGh5X2Rldi0+
bWFjX21hbmFnZWRfcG0gPSAxOw0KPiArDQo+ICAJcGh5X2F0dGFjaGVkX2luZm8ocGh5X2Rldik7
DQo+IA0KPiAgCXJldHVybiAwOw0KPiBAQCAtMzg2NCw2ICszODY2LDcgQEAgc3RhdGljIGludCBf
X21heWJlX3VudXNlZCBmZWNfcmVzdW1lKHN0cnVjdA0KPiBkZXZpY2UgKmRldikNCj4gIAkJbmV0
aWZfZGV2aWNlX2F0dGFjaChuZGV2KTsNCj4gIAkJbmV0aWZfdHhfdW5sb2NrX2JoKG5kZXYpOw0K
PiAgCQluYXBpX2VuYWJsZSgmZmVwLT5uYXBpKTsNCj4gKwkJcGh5X2luaXRfaHcobmRldi0+cGh5
ZGV2KTsNCg0KDQpGb3Igbm93LCBJIHRoaW5rIHdlIGRvZXNuJ3QgbmVlZCB0byByZS1pbml0aWFs
aXplIFBIWSBhZnRlciBNQUMgcmVzdW1lIGJhY2ssIGl0IGFsc28gY2FuIGJlIGRvbmUgYnkgUEhZ
IGRyaXZlciBpZiBpdCBuZWVkZWQuDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiAg
CQlwaHlfc3RhcnQobmRldi0+cGh5ZGV2KTsNCj4gIAl9DQo+ICAJcnRubF91bmxvY2soKTsNCj4g
LS0NCj4gMi4zMS4xDQo+IA0KDQo=
