Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D27B35978B
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 10:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhDIITs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 04:19:48 -0400
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:4806
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230181AbhDIITr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 04:19:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DseAjKbVujHYggxVPhFYpVNBV/bLL6P/k9odGUb1ANzADiFbqX12+4A22nKFRZAj/9M0DcBGrepRBev5B/U4aWRj24PrHiDc5K2XaM/T4TYw3Noe45aXugA4gWFfb6CczT7aoctHN5fE5v+dDUg1rPfti2XO+VE5I7f3t+46+6Y+vDI9BMiUHgniiS9nwW6pULQnk7oxUjhQplPe4rP1IgUV0HRnYEeVQwkBhoE2RLVjZhlKCpd5/Yu2ZPgpwkyZuOwVYpYkSd24tpE1PiIt6/8N6pv6gJmK0xeTTH7CWJVtohaRcIhgN5F0dDaLNAOpgIAFezreIvtooSYJj30JjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFSsMljwHzy4OWCZFamJtVqunvDspPIwCA+w/TZL+u4=;
 b=Z8UAdYJB0tHjyt8hmfAdp1UIKwghU6rQpO4hr/SLrSAt2SWESo+lSNzPnrT0O1K2UOYcVM+nmy2gdE4DfcohrgNhinExxoZW/aFAWg9RnF+yn7zzDuw/PxUtZ+AAtzwTnJ7fceuSeRRPN7YYZ54R6VWC7kGhxT+jaTH9DWL3rX1iCL/1QYtA4NEqbu1hkfX6a/fDCxwTjBDI/Al0I7D38wr0OGHYLL8CITzqHb8Xfkkv6I2Es7LCXSQxB2dNr9vV1UJHMhNX9LTtzDyGOnKYUYQJ4r4oQu5xDkHdR9xP4d6eoZvEmvwMvPp66kcuZwfnreoEtzvcEyAAlQD7qTAIDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFSsMljwHzy4OWCZFamJtVqunvDspPIwCA+w/TZL+u4=;
 b=fRepQIBE+9JzM5QHjHv547P8Hzv3jamdxPxZ0DOXqSzdJFhZJbe3D+QubNgFGJuIkXT9SEXnRWYvVPtFF7qYgKrd55GyS0RCJvYSelngmSEfoUxBaawm0x8iU5obvGxXlLyLd/9ZeNe4EpPoWG3qojQljVWXdwVsSiApo+TUvWI=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7333.eurprd04.prod.outlook.com (2603:10a6:10:1b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Fri, 9 Apr
 2021 08:19:34 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.4020.017; Fri, 9 Apr 2021
 08:19:33 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "Jisheng.Zhang@synaptics.com" <Jisheng.Zhang@synaptics.com>
Subject: RE: [PATCH net] net: stmmac: fix MAC WoL unwork if PHY doesn't
 support WoL
Thread-Topic: [PATCH net] net: stmmac: fix MAC WoL unwork if PHY doesn't
 support WoL
Thread-Index: AQHXK5r342LvIrfbAkSJPhETuakoCaqo/bkAgALbskA=
Date:   Fri, 9 Apr 2021 08:19:33 +0000
Message-ID: <DB8PR04MB6795B8393BD4ACB99D8F3F15E6739@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210407104404.5781-1-qiangqing.zhang@nxp.com>
 <YG2nBgdbc4fVQ0tF@lunn.ch>
In-Reply-To: <YG2nBgdbc4fVQ0tF@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c20018a8-10a3-4f06-280c-08d8fb30350d
x-ms-traffictypediagnostic: DBAPR04MB7333:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBAPR04MB73333333CCE02CA5505367C3E6739@DBAPR04MB7333.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ENWMDDQo5D04buOYSfovTl0PSve7f7TWX4Ur0sAWExfp3p7D0rMfeUp2FbQ+bwcw30O/H2yDjUQ+gtLPMD9G1jz+rChFB3c34WO6qXXSslt9B9rW8YUXOx+xnVkymyWED6Dm5IMTqoPTwcBfgAWKeF3aKSux5q0ANrsX0R4nz+GuBlhW+TclUn0aE5+UOSB7Ee8CXZbuWl2vEhAaR4nLX3/S0UtDQKsTDeCOtLhy28Bi8mlA3W+ZK0av9aaE812El5fliufR4R9gLRQ0SUPVqkdp3/yrvj3pC2wJfkEqacG/8MpXdzJ/UbUA2PN3CjuLBs0Hy+vcCpEIPhQCidJABfxGNMrD3xv5uZ/n5yGQShpY4C84v3t0VMMgMAbuZmTmcQhuFwIOEc9Vu8PNmE0GQlcMz69DjRdtYhd60NvGb0HJKUfJ83tz6WCyO+XI41KRk5+K6VWvss35DYX+89m4F7HA9Mbrqc7w0M/SmG50NAg8sjmXkeFEOK9p8bWGC5jCS663dU5LKTmZ3MV+s495nnpskGQk0RLD5hy17RZP/kXSzQocn+VEYjpcVPj8AptRepMPEc5E380MqxQrXtDRHAUCuU5LjLT1hufhmGNzMB0Nq5IGHWaC78OEX31ZOYeyZxQhIQoZgQtyHpqS/bZUKAgXz7KRP9BKmv1Rau7OUdmUjzNdbYLWDdkdfVN3UE6r
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(136003)(376002)(366004)(66946007)(86362001)(66556008)(6506007)(2906002)(64756008)(66476007)(66446008)(52536014)(8936002)(76116006)(83380400001)(7696005)(8676002)(53546011)(33656002)(55016002)(316002)(9686003)(5660300002)(38100700001)(4326008)(71200400001)(54906003)(26005)(478600001)(186003)(6916009)(309714004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?ZTZsa0pkeTJJanY5UUYzU2RRUXE0SmwyR2NQVEJLZUU3ZlFpRDVSRXNsdVpW?=
 =?gb2312?B?TE9BN0RiR3NwMTN4dzlJZ25ZVzBGRHA5YlpiQUc4bWJFWGo4c0ZQUVJTckw0?=
 =?gb2312?B?SWhrRDd5N2RsMHF2OCtvR0gyQ3JFbFdpcjFncU9XakszTmJ3ODV6cXFYRnho?=
 =?gb2312?B?dHZvQTNlcFZwVXRDOUZESDJtSjlSdUpkZm1iZU45TnkvZFFuc2tkQ3lYbTM1?=
 =?gb2312?B?dDJWTk81RFpZeFc5Sko0NExXWG45aG8rZUxHa3FoSTl5NU5adHJ6d29YYUxV?=
 =?gb2312?B?Q3FBNnJoRDhWVkUrMjUvayt6RU55Njd0ZFRBcFdockJ1eDROdlVXQ2NKekVr?=
 =?gb2312?B?THB2eWhUK1BjNXdvUVRWRHh2R0c1dlBhSm1wYmNWbEg3R3ZVbFVBUVJpK01U?=
 =?gb2312?B?YklrNk14L3JPTmdXV1RxRjJLQWNZVUpoUmZHeE0xL2kzbHVyOUg3eVF5akRM?=
 =?gb2312?B?TWFTalUydWVrN2NmTG1nUkNCeHlaSlNacjhDTWhJZ29SOHlud2ZMOWc2TG1o?=
 =?gb2312?B?d2hWdm9DWC9HTFUrT3BBV2lXVkNlNDBBdmN3b1VzNHl1SWszRjhOTEhMaFFx?=
 =?gb2312?B?YmNNUXc3QThOK25pTUprOWU2Vlp4QWhBMENHckFqSmYrRlFsb3BMUGMrV1c5?=
 =?gb2312?B?aHViOHNoQjJQMVZwRDc4TGYwbjEyQWJvYlE2STNBNWV2QUo1ZTNETEdxVkdk?=
 =?gb2312?B?Y2R4aXMxTGN1NmVvcEp3REtyU2lHYXpaeXpBbGN4NHVzY21EOEJBcGx4NHBU?=
 =?gb2312?B?RWtoRkZCM1N3S3JpWVZLMGVuc2xidG5WN0NVVjV3MzhRZzdtaWpzUDVlb0hQ?=
 =?gb2312?B?Q2VKWGxVV3NZeHA0R3NuMkxSNFNDYWxtWGQ1Skx2a0MzZVdMczdzYm1rb0R0?=
 =?gb2312?B?czA2eUtCL05ZWkJHVlVmb05laE5RMU5yZ25SODFnUzZKdGNqcVRuZFJQTVVB?=
 =?gb2312?B?VXRxN2JPQzFMY3NUY0ZrMnVrTmlhQmwrbVVhclUrei9VZzFlODROTGFkRCtB?=
 =?gb2312?B?eXZMdFBSOXVkc2RVaVBYeklFKzV0Z1hxN2ZSMjE0TWpnc3NTdmJkK0FsOTM5?=
 =?gb2312?B?MUNnK0V6bUh5WUFmTTRsWUdhUUx0Zm82cjA3ZC9tekFuc3VYSDFkeHN4K2d1?=
 =?gb2312?B?VGhkQU1HZStWUS9BS242UnlsK0FKbzROdXNkK3FSVzRPZHFobWZvc0RzTkMy?=
 =?gb2312?B?V0lPREZ0eVNzeWF1OWR6SVRPTnFHbklCdVpYc0IxaEhSY0c4VnpSZHd3R1Nl?=
 =?gb2312?B?TjhyOGFzYW9qM0g4eXZoWGZUNjVBalhRdWJZRVBRNVJYdXZ4aHBLcm9nYTB3?=
 =?gb2312?B?enZaam5hQysrME9lU0EreXJnSStZbEFqSE9HOWVhcmNnbDN1QjMxR2Rndnhj?=
 =?gb2312?B?MzNFVlZ2aFltZExRcmZTMWJwTC90Z3o3aytIaUg0K2ltdUtsa2ZTV3pyMGF1?=
 =?gb2312?B?aXloYzJ1Z3dwSk1jTGRIYlJCNEpGRkxrdzBGS2VLd2pXU2l5cXhOcUlLNXFH?=
 =?gb2312?B?NWd3SCthQTJ6K21PVjFyUk9QUXB2ZHBHVUR5MUVRSkNsN2dDZW9pbjhVa1ZN?=
 =?gb2312?B?ajZXZkJyNXFDc2UzdXRaRUJOZ1huVjBMdnVrSlMwbVc5cWJaZEVBekRMamlT?=
 =?gb2312?B?V3k1MEdCaUM0VlcxSEJvY0ZHRDNmQWhqUTJxK25heFVvcDIrUFZ5ZWpCU1Fi?=
 =?gb2312?B?VFgzZHNSY1NLMWp2NTdiU2w4UE5tbnpnMVNKQWZaSHdrMGNieVJxU25nSElw?=
 =?gb2312?Q?k10vvXo7OsKLDILuE61UootffSdB663M5OaG/h4?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c20018a8-10a3-4f06-280c-08d8fb30350d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2021 08:19:33.8090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9W4BsGRWl3PsLxvHUXeA3xQPTYGrCO26/lSZmmOBHHgVvvfUqFzMfgY9OreNiIbWmQ0Unc0moUgVAG1ju56JPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7333
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBBbmRyZXcsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5k
cmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiBTZW50OiAyMDIxxOo01MI3yNUgMjA6MzUNCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IENjOiBwZXBwZS5j
YXZhbGxhcm9Ac3QuY29tOyBhbGV4YW5kcmUudG9yZ3VlQHN0LmNvbTsNCj4gam9hYnJldUBzeW5v
cHN5cy5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsNCj4gZi5mYWlu
ZWxsaUBnbWFpbC5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRsLWxpbnV4LWlteA0KPiA8
bGludXgtaW14QG54cC5jb20+OyBKaXNoZW5nLlpoYW5nQHN5bmFwdGljcy5jb20NCj4gU3ViamVj
dDogUmU6IFtQQVRDSCBuZXRdIG5ldDogc3RtbWFjOiBmaXggTUFDIFdvTCB1bndvcmsgaWYgUEhZ
IGRvZXNuJ3QNCj4gc3VwcG9ydCBXb0wNCj4gDQo+IE9uIFdlZCwgQXByIDA3LCAyMDIxIGF0IDA2
OjQ0OjA0UE0gKzA4MDAsIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPiBCb3RoIGdldCBhbmQgc2V0
IFdvTCB3aWxsIGNoZWNrIGRldmljZV9jYW5fd2FrZXVwKCksIGlmIE1BQyBzdXBwb3J0cw0KPiA+
IFBNVCwgaXQgd2lsbCBzZXQgZGV2aWNlIHdha2V1cCBjYXBhYmlsaXR5LiBBZnRlciBjb21taXQg
MWQ4ZTViMGYzZjJjICgibmV0Og0KPiA+IHN0bW1hYzogU3VwcG9ydCBXT0wgd2l0aCBwaHkiKSwg
ZGV2aWNlIHdha2V1cCBjYXBhYmlsaXR5IHdpbGwgYmUNCj4gPiBvdmVyd3JpdGUgaW4gc3RtbWFj
X2luaXRfcGh5KCkgYWNjb3JkaW5nIHRvIHBoeSdzIFdvbCBmZWF0dXJlLiBJZiBwaHkNCj4gPiBk
b2Vzbid0IHN1cHBvcnQgV29MLCB0aGVuIE1BQyB3aWxsIGxvc2Ugd2FrZXVwIGNhcGFiaWxpdHku
IFRvIGZpeCB0aGlzDQo+ID4gaXNzdWUsIG9ubHkgb3ZlcndyaXRlIGRldmljZSB3YWtldXAgY2Fw
YWJpbGl0eSB3aGVuIE1BQyBkb2Vzbid0DQo+ID4gc3VwcG9ydCBQTVQuDQo+ID4NCj4gPiBGaXhl
czogY29tbWl0IDFkOGU1YjBmM2YyYyAoIm5ldDogc3RtbWFjOiBTdXBwb3J0IFdPTCB3aXRoIHBo
eSIpDQo+ID4gU2lnbmVkLW9mZi1ieTogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhw
LmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMv
c3RtbWFjX21haW4uYyB8IDQgKysrLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9uKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYw0KPiA+IGluZGV4IDIwOGNhZTM0NGZm
YS4uZjQ2ZDljNjkxNjhmIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0
bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jDQo+ID4gQEAgLTExMDMsNyArMTEwMyw5IEBA
IHN0YXRpYyBpbnQgc3RtbWFjX2luaXRfcGh5KHN0cnVjdCBuZXRfZGV2aWNlDQo+ICpkZXYpDQo+
ID4gIAl9DQo+ID4NCj4gPiAgCXBoeWxpbmtfZXRodG9vbF9nZXRfd29sKHByaXYtPnBoeWxpbmss
ICZ3b2wpOw0KPiA+IC0JZGV2aWNlX3NldF93YWtldXBfY2FwYWJsZShwcml2LT5kZXZpY2UsICEh
d29sLnN1cHBvcnRlZCk7DQo+ID4gKw0KPiA+ICsJaWYgKCFwcml2LT5wbGF0LT5wbXQpDQo+ID4g
KwkJZGV2aWNlX3NldF93YWtldXBfY2FwYWJsZShwcml2LT5kZXZpY2UsICEhd29sLnN1cHBvcnRl
ZCk7DQo+IA0KPiBJdCBzZWVtcyBsaWtlIGEgYmV0dGVyIGZpeCB3b3VsZCBiZSB0byBjYWxsIHN0
bW1hY19nZXRfd29sKCksIFRoYXQgc2hvdWxkIHNldA0KPiB3b2wgdGFraW5nIGludG8gYWNjb3Vu
dCBib3RoIHBtdCBhbmQgcGh5LiAgQnV0IGkgd291bGQgYWxzbyBzYXkNCj4gc3RtbWFjX2dldF93
b2woKSBhbmQgc3RtbWFjX3NldF93b2woKSBhcmUgYnJva2VuLiBUaGV5IHNob3VsZCBjb21iaW5l
DQo+IGNhcGFiaWxpdGllcywgbm90IGJlIGVpdGhlciBwbXQgb3IgcGh5Lg0KDQpZZXMsIHRoZXkg
c2hvdWxkIGNvbWJpbmUgTUFDIGFuZCBQSFkgV29MIGNhcGFiaWxpdGllcywgcmF0aGVyIHRoYW4g
Y2hlY2sgcG10IG9yIHBoeS4gSSB3aWxsIGltcHJvdmUgYW5kIHJlcG9zdCBpdC4NCg0KQmVzdCBS
ZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+ICAgICAgICBBbmRyZXcNCg==
