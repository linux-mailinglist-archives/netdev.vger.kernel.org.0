Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C973B7F02
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 10:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbhF3Ic3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 04:32:29 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:64730
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233085AbhF3Ic2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 04:32:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tpu8rnXc3ZzjYKfwlsduzdSUoueo9X+PE+52lZ+Gu7qjGUGZ0n1EqOeBEGfLH9KA919QaLdTfAhGX/s12z80ywR/7UV0A0ezGS1lPtoQ5bYtjiTUJ/hoiZy7QTdasF5OcEwogN3L9Th9G90Nr6BwEuqJK9BevKpJi4kVDlY+I0yZsJuglJXCid/phqvBXwjPwrTSrqeIHdMO64Y0k16O05rvHwA8Yz08zC+gR5+p8cBr8PvGF+lijS2MAmm8amN0MIpOVZhJb44xiXws5OsIKa0Vo/rgqvKuV/apbiLSwqpjmHqJykhYjMGtP0cWCwxcD6eFS2l/1o+Cuw6hL53I5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8JiDZOe9dEBHrs+Xht0Qn1KmbIYIm4CBUrLEmFx7ugU=;
 b=nQiLNGsjdz9zZYNBixvgE1uiRxsq/AFCEiMClUZCNUjCYFCfK32AcJ+D3iR+gF4SHvWOx4BoHrpDdxw/SymWN4Yk3CM/TbQTUyXbIuCkniA9jVLvhoQlayMYTLiQroB8a3u6ZFNu5i6Kqub9BvefFm9SMX9BbMQZ405yZn2jhA4U/1wn0x5JspOm01Ekh+Bl3on7RjJ277aA2mmHYHacayBYGFMfoa5ynoEcO6xbL+misTx363dYQ7uhnTnu9YUWT9FNOAKM9mAxo7FgDHaXp3CTEyjdTqKMHBWy6T2MD3p6p81sYkfe0rf5GObS3fL93UlchSv7cJtjn8Fl6PEiDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8JiDZOe9dEBHrs+Xht0Qn1KmbIYIm4CBUrLEmFx7ugU=;
 b=Dte8QPu57wu1bkVUYpAZuldc9wlF0WEAQSGpgdxZtkXTM+eDqdMiehfx6coDlyuXe4EwXmKL7UufmtcdCv1nJJBuZsx92sb6mT8Jb6/MEUWWB3WJ0wHxHRhgI1tIwjLhBfZFGkagWlEAiIRUHGRsl3yEXjmkFCTwu1y0SdUoMCw=
Received: from AM6PR04MB5016.eurprd04.prod.outlook.com (2603:10a6:20b:11::22)
 by AM6PR04MB4886.eurprd04.prod.outlook.com (2603:10a6:20b:6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.23; Wed, 30 Jun
 2021 08:29:57 +0000
Received: from AM6PR04MB5016.eurprd04.prod.outlook.com
 ([fe80::4be:7cee:fd21:7b7]) by AM6PR04MB5016.eurprd04.prod.outlook.com
 ([fe80::4be:7cee:fd21:7b7%4]) with mapi id 15.20.4264.026; Wed, 30 Jun 2021
 08:29:57 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mptcp@lists.linux.dev" <mptcp@lists.linux.dev>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: RE: [net-next, v4, 08/11] net: sock: extend SO_TIMESTAMPING for PHC
 binding
Thread-Topic: [net-next, v4, 08/11] net: sock: extend SO_TIMESTAMPING for PHC
 binding
Thread-Index: AQHXaaPwF6oJGwtH/k2fhCNfnLubMqslecKAgAbGBFA=
Date:   Wed, 30 Jun 2021 08:29:56 +0000
Message-ID: <AM6PR04MB50160B2B6FB6ADA46EAF76E1F8019@AM6PR04MB5016.eurprd04.prod.outlook.com>
References: <20210625093513.38524-1-yangbo.lu@nxp.com>
 <20210625093513.38524-9-yangbo.lu@nxp.com>
 <8e78961d-238f-fd22-42b-999c3647a328@linux.intel.com>
In-Reply-To: <8e78961d-238f-fd22-42b-999c3647a328@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e6638ac-7582-4c77-0cc3-08d93ba13e56
x-ms-traffictypediagnostic: AM6PR04MB4886:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB4886624516E03CF5D8853128F8019@AM6PR04MB4886.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4wq10q21W403JQoFA8+Je+xJsyro4swYgvVOiv0TucDxgyHHZJMelPNQCqwZAM9/OQx4nZLMhBJIyiNt+yAytkTYWEyu9nLB87JZKpYgmHYXHeCNeOjQV4d/elmZAeJYiHwZMPGyh2T18/cf/7NxaZreQ1nniQZ44+Pe3fa9zKwWbP5lQesLFFIbcSG5lq3ftdwTrjTvB+Ia3rdDYn+aUVSB6w1IUB+MoTf1nr81cVS12s4mwLjsYuAvti7h6rGi2SS8uleHsEZtAd0mw19Yf4q0suJMD93/gXWEenRvlHM7Vk5CXZMH/B2KpzVjayKjpFLSgcOEl77JXg9XehFcax1ZVCn6VGLB5RWQcD3wn/29hcIap1JdkB+6X8e5Mkrh01Dn1kjvP+OdQe6mSjGVXVBVAqvA4Gq90KA3zxmw8vMjZD7AxdSgBqfgNyvgKRkV+CVglhcd5j8CGDjILYK6Vqq52JSAduZ8ZAdBKhJWZgFGdM/0r7eYxDfvpLV1FAJSID/VXOcD5xrnSwsWN270IgSV/Raj6ahIVwyeEzV6/m8dSmVwNTORB5nzjk29IorBSDnGfh4nu6asqIKSopbBfOzf6aWl+ljft17lr+l5/3RbejGTwlahilLtZkQR/VfweBaPj8GC+09D2AbXcSNZUg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5016.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(136003)(346002)(39860400002)(66556008)(9686003)(66476007)(64756008)(83380400001)(66446008)(54906003)(8936002)(76116006)(5660300002)(33656002)(478600001)(26005)(122000001)(55016002)(186003)(7696005)(52536014)(6916009)(86362001)(38100700002)(316002)(7416002)(6506007)(8676002)(53546011)(66946007)(71200400001)(2906002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?Q0NJVnlkaDBRbExQTXY1YTJNSmFnN3lNUU1ybEtGNlE0SVhPbVoyaU52VWhp?=
 =?gb2312?B?Nk1FNzV0VGZkZVdDbEZBUkFDM0NxMG41REZycnN5VHJxWXkyeHdQOVBFb0J4?=
 =?gb2312?B?UlljcTh6djloUUZBM3l2VVMrSVpWV2lwN1hiZHc0UFNVci8zNExnZHRxY2ZM?=
 =?gb2312?B?RXdYLzZVN2lJRElNbEliSnlDOGErWGJaODJNMjllTFJ3R2ptbkl2OEZNT3pD?=
 =?gb2312?B?cVM1Y0tzMDJSbDUvMmkxZnhJUTBRYW85dEtpRkVJc0gzKzVuOTMrS0pKbC9k?=
 =?gb2312?B?dUxrc0kxbHlaMUJMTVVOK1J2a2lZdWVyNEdiUFFXTzNBTGVxWXlqN1dlV3I2?=
 =?gb2312?B?S3J2cEVnckk4UllGWVFMRUlrWVZmdnY1cnk3WmxxTi9WMGlUYzZTQnVGZFMv?=
 =?gb2312?B?MktKQk9YNThpMHZ0UWVHdTdST1JOcVZhV0JrQXlYYVZCK0o5N1dNTEV5aDda?=
 =?gb2312?B?VCsvdWJGSTFJWG9EbnIvdy9YWEp6b0NsdzNCbjU0N0d0RmtncFpmQmJNV0xB?=
 =?gb2312?B?NlNhL0VDRThkQVYrMWtuTndZSDM3N1d3NVJTelFldGIxVkdqRXdzTk1UVjZp?=
 =?gb2312?B?dmxSQ0dEbU5QL28xV3JGL283Ni9VM3oveURjZXppREtNU25OcVRiYnpWTlFH?=
 =?gb2312?B?NzVKdmE3ZEhJSUE3SXBvWDBhc3FQSXQ2L2lZaG0ySlNZWlUwQ2s0c0hpWi9n?=
 =?gb2312?B?Y2loZ1lneW9XR2lKSHdIeHdad3VreGt4b1RIaW8vTUJnTTdXeHB3WTgvbndk?=
 =?gb2312?B?c2U2cWJuNjlndUZjS1NFV2RLTTl4OXhXYmlFVEJ0dDZYVHpxdGFJN1RuSG11?=
 =?gb2312?B?NlFZRG1WZ094aHFpTXVaNFVIcFBqYW5jZEVTMGEvZHB3aE1aTFZYM2wwcWg0?=
 =?gb2312?B?ZmFQVnU4b1Zxay9yUC93bklzMmhpOXJTc0pTc29CSWxaZlo1MmJqeXdmazZW?=
 =?gb2312?B?dXIrdUNoaGJlQzNpSmxYTUZNUHJYdk12UDEwT1U5b0NsYkxLa2VhMGVhZ2pm?=
 =?gb2312?B?NWpmYnRMTkVwNEs1bGdkWjBWMFJFcEpQdlpMU01idmpUTDZPaU12SUxpSDVQ?=
 =?gb2312?B?TlhKbVRKdXVMNm9qczBtTU9xY3cyRzg4cDZLa3BtaUJvRG54dnRnTEdsbUNZ?=
 =?gb2312?B?Q3N0a0dFQWNZWjN4TkU5L2lmS3FqVUJCaUdEZTJKVWFNWjJVV3luYk9ubzl0?=
 =?gb2312?B?QUMwTHIxMUx0Q2w3ampadjNjbWtJcHpObWlPQ3NOdytLa1FuWlpESGxNSzd4?=
 =?gb2312?B?SjBMVkdlYjlGbDNhdlVCTE02cW16NElNZFdLbkdlQmxaMG9NY2Frb3JEQ3ZZ?=
 =?gb2312?B?WXF6SkNyS1hyeVFmUmJ2bTJqYXM2aVZQRTdrY1M1N0hSYWFUanlTS1N1V2RH?=
 =?gb2312?B?N0tDNTFZZWdja3BaUHl0ektZWVp6Tldkd2hzbUYxazRldy85QWRkL2ErbDJh?=
 =?gb2312?B?QVFZZTkza083eHYrRjF4UGVTeW42MHJ1NUZ2Wk9KQlBpQlRDbllHbHVDMzBh?=
 =?gb2312?B?cUhYdytpaEl3b0ZtL3BycTJxbnhIR2d5bkt5T3MxcER1NHRJYUZDQlpoMUxr?=
 =?gb2312?B?Z3V6SE1NN082R2hKSXIzNGgvUkFyVXhFOFpuc3FOT3dVeUZoYllNR3hYN2ZJ?=
 =?gb2312?B?SUJ0SGJqS3FsNVp1cHZiTlZxK1ZHdEJwOU5GbE5oSXpwTHNMVkRISW40SDA4?=
 =?gb2312?B?RTdHd1JFbVlCQTA0YWhrOHQ2RlFDejJHNVN1dHNLWmVYUHJhODhLdlBmWmc4?=
 =?gb2312?Q?GLAi9Gnltg5ypsDtBT8bPWtg2a0uVpzBOdmANU1?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5016.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e6638ac-7582-4c77-0cc3-08d93ba13e56
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2021 08:29:57.0366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zGK8lAvjmS9TpJHQdpQH5oVHNU+Wv7jb72q1rSFHvxKfc4CsDLAxMKU/aXrfvzB6U71Bhv5awRaGBqiVQ72Tvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4886
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWF0LA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hdCBNYXJ0
aW5lYXUgPG1hdGhldy5qLm1hcnRpbmVhdUBsaW51eC5pbnRlbC5jb20+DQo+IFNlbnQ6IDIwMjHE
6jbUwjI2yNUgOTowMA0KPiBUbzogWS5iLiBMdSA8eWFuZ2JvLmx1QG54cC5jb20+DQo+IENjOiBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBs
aW51eC1rc2VsZnRlc3RAdmdlci5rZXJuZWwub3JnOyBtcHRjcEBsaXN0cy5saW51eC5kZXY7IFJp
Y2hhcmQgQ29jaHJhbg0KPiA8cmljaGFyZGNvY2hyYW5AZ21haWwuY29tPjsgRGF2aWQgUyAuIE1p
bGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47DQo+IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5l
bC5vcmc+OyBNYXR0aGlldSBCYWVydHMNCj4gPG1hdHRoaWV1LmJhZXJ0c0B0ZXNzYXJlcy5uZXQ+
OyBTaHVhaCBLaGFuIDxzaHVhaEBrZXJuZWwub3JnPjsgTWljaGFsDQo+IEt1YmVjZWsgPG1rdWJl
Y2VrQHN1c2UuY3o+OyBGbG9yaWFuIEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdtYWlsLmNvbT47DQo+
IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IFJ1aSBTb3VzYSA8cnVpLnNvdXNhQG54cC5j
b20+OyBTZWJhc3RpZW4NCj4gTGF2ZXplIDxzZWJhc3RpZW4ubGF2ZXplQG54cC5jb20+DQo+IFN1
YmplY3Q6IFJlOiBbbmV0LW5leHQsIHY0LCAwOC8xMV0gbmV0OiBzb2NrOiBleHRlbmQgU09fVElN
RVNUQU1QSU5HIGZvcg0KPiBQSEMgYmluZGluZw0KPiANCj4gT24gRnJpLCAyNSBKdW4gMjAyMSwg
WWFuZ2JvIEx1IHdyb3RlOg0KPiANClsuLi5dDQo+ID4gZGlmZiAtLWdpdCBhL25ldC9tcHRjcC9z
b2Nrb3B0LmMgYi9uZXQvbXB0Y3Avc29ja29wdC5jDQo+ID4gaW5kZXggZWEzOGNiY2QyYWQ0Li5l
MjBhZWZjMjBkNzUgMTAwNjQ0DQo+ID4gLS0tIGEvbmV0L21wdGNwL3NvY2tvcHQuYw0KPiA+ICsr
KyBiL25ldC9tcHRjcC9zb2Nrb3B0LmMNCj4gPiBAQCAtMjA3LDE0ICsyMDcsMjYgQEAgc3RhdGlj
IGludA0KPiBtcHRjcF9zZXRzb2Nrb3B0X3NvbF9zb2NrZXRfdGltZXN0YW1waW5nKHN0cnVjdCBt
cHRjcF9zb2NrICptc2ssDQo+ID4gew0KPiA+IAlzdHJ1Y3QgbXB0Y3Bfc3ViZmxvd19jb250ZXh0
ICpzdWJmbG93Ow0KPiA+IAlzdHJ1Y3Qgc29jayAqc2sgPSAoc3RydWN0IHNvY2sgKiltc2s7DQo+
ID4gKwlzdHJ1Y3Qgc29fdGltZXN0YW1waW5nIHRpbWVzdGFtcGluZzsNCj4gPiAJaW50IHZhbCwg
cmV0Ow0KPiA+DQo+ID4gLQlyZXQgPSBtcHRjcF9nZXRfaW50X29wdGlvbihtc2ssIG9wdHZhbCwg
b3B0bGVuLCAmdmFsKTsNCj4gPiAtCWlmIChyZXQpDQo+ID4gLQkJcmV0dXJuIHJldDsNCj4gPiAr
CWlmIChvcHRsZW4gPT0gc2l6ZW9mKHRpbWVzdGFtcGluZykpIHsNCj4gPiArCQlpZiAoY29weV9m
cm9tX3NvY2twdHIoJnRpbWVzdGFtcGluZywgb3B0dmFsLA0KPiA+ICsJCQkJICAgICAgc2l6ZW9m
KHRpbWVzdGFtcGluZykpKQ0KPiA+ICsJCQlyZXR1cm4gLUVGQVVMVDsNCj4gPiArCX0gZWxzZSBp
ZiAob3B0bGVuID09IHNpemVvZihpbnQpKSB7DQo+ID4gKwkJaWYgKGNvcHlfZnJvbV9zb2NrcHRy
KHZhbCwgb3B0dmFsLCBzaXplb2YoKnZhbCkpKQ0KPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBeXl4NCj4gDQo+IEFzIHRoZSBrYnVpbGQgYm90IG5vdGVkLCB0aGlzIG5l
ZWRzIHRvIGJlIGEgcG9pbnRlci4gWW91IGNvdWxkIHBhc3MgaW4NCj4gJnRpbWVzdGFtcGluZy5m
bGFncyBhbmQgeW91IHdvdWxkbid0IG5lZWQgdGhlICd2YWwnIHZhcmlhYmxlIGF0IGFsbC4NCj4g
DQo+IA0KDQpPaywgSSBzZW50IHY1IHRvIGZpeC4NClNvcnJ5IGZvciB0aGUgdHJvdWJsZS4gSXQg
c2VlbWVkIG15IHRlc3QgY29uZmlnIG1pc3NlZCB0byBlbmFibGUgTVBUQ1AuDQoNClRoYW5rcy4N
Cg0KPiAtTWF0DQo+IA0KPiANCj4gPiArCQkJcmV0dXJuIC1FRkFVTFQ7DQo+ID4gKw0KPiA+ICsJ
CW1lbXNldCgmdGltZXN0YW1waW5nLCAwLCBzaXplb2YodGltZXN0YW1waW5nKSk7DQo+ID4gKwkJ
dGltZXN0YW1waW5nLmZsYWdzID0gdmFsOw0KPiA+ICsJfSBlbHNlIHsNCj4gPiArCQlyZXR1cm4g
LUVJTlZBTDsNCj4gPiArCX0NCj4gPg0KPiA+IAlyZXQgPSBzb2NrX3NldHNvY2tvcHQoc2stPnNr
X3NvY2tldCwgU09MX1NPQ0tFVCwgb3B0bmFtZSwNCj4gPiAtCQkJICAgICAgS0VSTkVMX1NPQ0tQ
VFIoJnZhbCksIHNpemVvZih2YWwpKTsNCj4gPiArCQkJICAgICAgS0VSTkVMX1NPQ0tQVFIoJnRp
bWVzdGFtcGluZyksDQo+ID4gKwkJCSAgICAgIHNpemVvZih0aW1lc3RhbXBpbmcpKTsNCj4gPiAJ
aWYgKHJldCkNCj4gPiAJCXJldHVybiByZXQ7DQo+ID4NCj4gPiBAQCAtMjI0LDcgKzIzNiw3IEBA
IHN0YXRpYyBpbnQNCj4gbXB0Y3Bfc2V0c29ja29wdF9zb2xfc29ja2V0X3RpbWVzdGFtcGluZyhz
dHJ1Y3QgbXB0Y3Bfc29jayAqbXNrLA0KPiA+IAkJc3RydWN0IHNvY2sgKnNzayA9IG1wdGNwX3N1
YmZsb3dfdGNwX3NvY2soc3ViZmxvdyk7DQo+ID4gCQlib29sIHNsb3cgPSBsb2NrX3NvY2tfZmFz
dChzc2spOw0KPiA+DQo+ID4gLQkJc29ja19zZXRfdGltZXN0YW1waW5nKHNrLCBvcHRuYW1lLCB2
YWwpOw0KPiA+ICsJCXNvY2tfc2V0X3RpbWVzdGFtcGluZyhzaywgb3B0bmFtZSwgdGltZXN0YW1w
aW5nKTsNCj4gPiAJCXVubG9ja19zb2NrX2Zhc3Qoc3NrLCBzbG93KTsNCj4gPiAJfQ0KPiA+DQo+
ID4gLS0NCj4gPiAyLjI1LjENCj4gPg0KPiA+DQo+IA0KPiAtLQ0KPiBNYXQgTWFydGluZWF1DQo+
IEludGVsDQo=
