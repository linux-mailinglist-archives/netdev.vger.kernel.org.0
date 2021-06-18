Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742B73AC5C7
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 10:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbhFRINN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 04:13:13 -0400
Received: from mail-eopbgr70070.outbound.protection.outlook.com ([40.107.7.70]:20113
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232163AbhFRINM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 04:13:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MUfG8xNz8aeEN5O3zkb6bNpD9MKXXvyreFlTDKjBnsGkbGTFaUU7HBhk0MaMusbo3Be6A59E3DGxKbCc9oqzvfQKSUJwty+1GdEccJs2QzBQ7+dG7ezLJ74G+Feeczv3i+r1tPr4MU3YMBtohVQrLA+dQysgWvhQwzGEQdQn523XqZbUIaeEhIQhtNTaPYUKoBNJv80L4HHT7cjEeioMaLc/hTAD/wyMB2Ph6l9cH7OzjbY2jSGq4UxtmeGcHI6GxzgXab+7udGO4Lt13hgDled4oGlpuwMx0Z9asXwXKBWdKy8AP3FpsyJIsbIIbRzM0DEakn13TZTbPqY7iroM8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJs5Yr1PcG60PFqvXrdBFUVBAQEtecCRQ5E8Hs6y7bo=;
 b=SDl+yvY/jiW1JLdkQWU9rO1AEYwyIZfhpGRrPP87pKe8HGX0TMedeVWTDNuiXb7XT2rVdf/FtIUZseeU1m0pl7oft20GFojnClSFpHGAywMDbujNcCHEvmSQ7ekwVl33fMg4awjUmEDRBXw7pzfORlMNAnjJSCRE40aal0iWY9apvbY9xNsKo1GGtGEmioC/n4ztJhc6oJL8qXV/MaXkB+2tFvDZ5JhDUcjxExhuuELI3jp7OQyTNIegn8BxthJvrxB6sgih51vM6gCpv/eIWBCMG3xoM1/J87z0Qmriz7qaF6t7pX2vYncmIw9bqTopn6HATyvmS4fNizjxdKE2GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJs5Yr1PcG60PFqvXrdBFUVBAQEtecCRQ5E8Hs6y7bo=;
 b=R6FdHxRlmOy31cGOL2EAvYLdQ8rlPLHLue4MbNu8E+2LWqS2HwYcrkpSWwx9Jn0jucYt+cG5lp7Xk156UZbtJTedzXsmp0ztCnOHkvFY6V6pC2vCXxO44pc5jqnwBxnVFBhozlLnrq4PUha9i6qLCwy3PlfSI+4Qlau/JUTSqQg=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6796.eurprd04.prod.outlook.com (2603:10a6:10:11e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Fri, 18 Jun
 2021 08:11:01 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::f5e8:4886:3923:e92e]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::f5e8:4886:3923:e92e%8]) with mapi id 15.20.4242.021; Fri, 18 Jun 2021
 08:11:01 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     David Miller <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "frieder.schrempf@kontron.de" <frieder.schrempf@kontron.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Thread-Topic: [PATCH V2 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Thread-Index: AQHXXqdJJp2Y2RcztU6Ho2b70gc0WqsPQnYAgAVNuXCAAHYrgIABTjKQgABO7oCAAXlFgIAAGIGAgAEnWPA=
Date:   Fri, 18 Jun 2021 08:11:00 +0000
Message-ID: <DB8PR04MB6795BFE5A111B1DDC0DDD143E60D9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210611095005.3909-1-qiangqing.zhang@nxp.com>
 <20210611.132514.1451796354248475314.davem@davemloft.net>
 <DB8PR04MB679518CF771FEBE118E395A3E6309@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YMicuzWwAKz5ffWB@lunn.ch>
 <DB8PR04MB6795A2A1D51D95E996B7B75FE60F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YMn3Sd65rzvKasEb@lunn.ch>
 <DB8PR04MB679584EA53A9842D10C33B1EE60E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YMtIUVSMxL0iMJLX@lunn.ch>
In-Reply-To: <YMtIUVSMxL0iMJLX@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 404a577e-49d2-4973-f41c-08d932309c3f
x-ms-traffictypediagnostic: DB8PR04MB6796:
x-microsoft-antispam-prvs: <DB8PR04MB6796226DC3D9B27056F594D6E60D9@DB8PR04MB6796.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D3a4aC6fYh1DPFkCBo1Yr1llD09IgKe0F4ZraHYrN1YEAYfPucIWIqTv3ZvA/FewZYmXvvumyMhAeQBRZ6chfLht86cFAUOXJaGIyG0ans8YQ9l+mCg1VenD156WBgA79VSvTfKQl6lUAWDwBZfY1ciKZ4jQp36S5QqHy90ecflWWq1m5xlCW6794UaCTCIDAkkGJA2UOZ41g4mIf45POrCo9h8ZUSR0u6IhhHlqGket41UXhT5RZgZ8BjABAVr68qbvrA+94UTSJ14flN8S9gga3vfr+1DoWiZpkU5syl/nGLlsYoil6z2aoUi1B/cm2/5eXzvPJV5GAL9/fvvUGmgL17DyH1dB6i8ppi13tvDCmaRK86VupetVh2Laf+TKsMloWAaqi+7BrS8RS8+R3mmFz5ZJ6mYFXwAfoiTNJgqD8KFbpyeduP+Gzpc1fr8sDastFkF1bLh1qok3U794+30NsGRFwkdtQ69qHneSz9mPidAz6i8p5QixXSU/jgD+A27xA09Q85Acp3gEXS4PeR5V2BM8mxY7vR3qR5aO2NFzLh8vyrjx8fIrY7jE901nQBN3FmUQoplhEw0uQA40ZL8WRXgn3co4kA7WhKvc1BSvNEFUoNAdTsULXrjTYG2TELcKCcPUOIYK4KdWZRvCf/iGe8EX6a8VL6IS3TSV78887zgIrcBgosiJ/sTKpmBToCpp5RY0hgrm2nJ6HXoUBw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(9686003)(86362001)(33656002)(122000001)(64756008)(66476007)(66446008)(966005)(66946007)(316002)(52536014)(45080400002)(54906003)(4326008)(38100700002)(76116006)(66556008)(5660300002)(8676002)(83380400001)(55016002)(6916009)(8936002)(478600001)(71200400001)(6506007)(26005)(2906002)(7696005)(53546011)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?TjlKWHMxZVJ1akY5NFB6Y014UWg1VlZUS2FURkpDQkE5K1A1bWxkOExvM09j?=
 =?gb2312?B?cVFWcTZTSWxBbTdCRS96WE9vaThlQUszd2hMRnJBSUxmRFpxVTdhM0pIczhB?=
 =?gb2312?B?S2MzRkJDRHhaYWpJYk5jdUJMUVFlMjV6VHRyOFJ1Q0VmcHJhT3gwSEUyUHRk?=
 =?gb2312?B?NnBQN0M4emNtLzZmUHY1YmErcmF3Y0x3TlpSN3I1WmFweXRoS1h0ZHozdEZL?=
 =?gb2312?B?TzQxUCtrZnpMb2Y0UDVHMnRpYjJKM21zTWw3TnlRWWhJamhBZGhHNDBwUEs4?=
 =?gb2312?B?aEs1TkgrWXBHQXk3Q0dMZTdWWStEckcrV2M5SmJ6NFBLZU81YVdFZ0hIbVM1?=
 =?gb2312?B?NmVDV1RGMWRHVlpLVng3UkI4NHNrKzJQUC9sYWlzZGZMNmE2TDMzT0J4Wkpt?=
 =?gb2312?B?UjF4QjE2YWRlNXhzTTBkOW02ZG5yVGhYakRFOWtSZHJENmdMeUlMNEdJS05y?=
 =?gb2312?B?S1BRTmlCTDZmY2lFUFYxU05XNXlJQ2Q5MytLZUdXSGM3UGtOMzh1bzBaWmpB?=
 =?gb2312?B?cWI3QmpmbUVYeDVTOFdndUVRRUVTeVNmT2hRZkJ4cU5XdTFNaTFWR28zcHpH?=
 =?gb2312?B?bXV4d2xEQk1CaWpaN0MxVDZwL1M4TFV5SkhnZktVby90dktPMU5lUUNFY3RU?=
 =?gb2312?B?cDRkek9yK2EzWnVXYk8rbW84Z2FnbnFpUWwvYmovNS9ybWhncHBOMFlMb29H?=
 =?gb2312?B?V2VxNFd6M283MlJBdXNLaXI4aStvdWJmREpYSTY0a1JJcnNSS1UwS2RwQUFM?=
 =?gb2312?B?QVVUT28zcloydEg1aTJTYzQxSUZ0TUZnQjhWUUdFRzNyOTVQakovRXZaYm1W?=
 =?gb2312?B?MXJuMGVNbUw0SDY5K05URE9TL0wzQXJoOEFCaWI4bmV4bndFTFVFd09uc25B?=
 =?gb2312?B?Y3ZmTmYyeS9lSys1a0JXaCt2LzJBeUkwek84OG95dWsrd1VLT0IrdHQ5d0tC?=
 =?gb2312?B?S3owTTc4eGRSZVFhZXJxWEwzd0wxRkNVQlBncFM0WlBqbHFqMUcyS0ltbVZL?=
 =?gb2312?B?WnBLRUhaQjFkWGRPQVd3YVgzS1ZIZHFRUFFkdHc3eFhENmNvZUNrUC9JUGV4?=
 =?gb2312?B?ZXF6UHhPTzZSc29ic01Db2hHc0hqTlBhaVV5ZDU0Y1RiVC8wSWxldG5haHcw?=
 =?gb2312?B?Z3VRMUprKzdLRmpmeE1zMWFKdXVlM3lzL1VreGV3YUxGRmlVODNWTlNYYWEw?=
 =?gb2312?B?RDlhWEFEdkxubDdSM3VvcEx1bm16WTR5R2t2TGFyeGlRNFRyNTN6bndOQ0pL?=
 =?gb2312?B?RHRjUDVXeFVGK3hDQmo0anAvWW9TOUVlM1ZyWFBmZ01tUXc0ZkdocnRsWXFI?=
 =?gb2312?B?cGRSS0FhZXBlcXo1aGFld2tlRXNVQWVucFlOdVBVbzVBbi8xeDY0d1owZjRL?=
 =?gb2312?B?dVoxcGtwVVp3Q2NWcnRmVGdlQUhqcEhYaUpxelVYZUNmTjRaanViMVk1MHU2?=
 =?gb2312?B?VWl6b2ZnMFhYcVVDMWFScEtwSCtDTVhic0FkWWo2RHhpLzNMSmxzQm5ybUJC?=
 =?gb2312?B?ZnlKVGczZnF4bmhkUlZYVlAxc29sWk1YZXpsWlg2SFQ4NENDRWQ0TlZZa3E0?=
 =?gb2312?B?K2xENDF3clZvUVhMNUxmQ2N4RlhkcHJnWVduaEs2bFI1ekduQkluK1U2QW9z?=
 =?gb2312?B?czZFZmhWdnRKdlF2YVdDTGFlUUhVaUU3MGhia25MeWRYWjhvYmZxU2NVWE9F?=
 =?gb2312?B?VHhWeU9rR1BFc3dyd3c3NjFGaFRySjNiQ0pGcDdIRGVzTjJpTnJKTS94anBw?=
 =?gb2312?Q?s43Puzrqm/3qmO98gU=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 404a577e-49d2-4973-f41c-08d932309c3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2021 08:11:01.0453
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W6LyRm4Kykt7aBWm7Tpjj7O5ivRAoVDgsYEDQBLXOHJSPwWi4yjFbFIXcjtHACSGFwnqlHbHLhMaJP1Eli1rxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6796
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBBbmRyZXcsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5k
cmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiBTZW50OiAyMDIxxOo21MIxN8jVIDIxOjA0DQo+
IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBDYzogRGF2aWQg
TWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pjsga3ViYUBrZXJuZWwub3JnOw0KPiBmcmllZGVy
LnNjaHJlbXBmQGtvbnRyb24uZGU7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBWMiBuZXQtbmV4dCAw
LzJdIG5ldDogZmVjOiBmaXggVFggYmFuZHdpZHRoIGZsdWN0dWF0aW9ucw0KPiANCj4gT24gVGh1
LCBKdW4gMTcsIDIwMjEgYXQgMTE6NDA6NThBTSArMDAwMCwgSm9ha2ltIFpoYW5nIHdyb3RlOg0K
PiA+DQo+ID4gSGkgQW5kcmV3LA0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0t
LQ0KPiA+ID4gRnJvbTogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiA+ID4gU2VudDog
MjAyMcTqNtTCMTbI1SAyMTowNg0KPiA+ID4gVG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpo
YW5nQG54cC5jb20+DQo+ID4gPiBDYzogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0
Pjsga3ViYUBrZXJuZWwub3JnOw0KPiA+ID4gZnJpZWRlci5zY2hyZW1wZkBrb250cm9uLmRlOyBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiA+ID4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
Zw0KPiA+ID4gU3ViamVjdDogUmU6IFtQQVRDSCBWMiBuZXQtbmV4dCAwLzJdIG5ldDogZmVjOiBm
aXggVFggYmFuZHdpZHRoDQo+ID4gPiBmbHVjdHVhdGlvbnMNCj4gPiA+DQo+ID4gPiA+IEkgdHJ5
IGJlbG93IGJ1aWxkIG9wdGlvbnMsIGFsc28gY2FuJ3QgcmVwcm9kdWNlIHRoaXMgaXNzdWUsIHNv
DQo+ID4gPiA+IHJlYWxseSBkb24ndCBrbm93DQo+ID4gPiBob3cgdG8gZml4IGl0Lg0KPiA+ID4g
Pg0KPiA+ID4gPiBtYWtlIEFSQ0g9YXJtNjQgZGlzdGNsZWFuDQo+ID4gPiA+IG1ha2UgQVJDSD1h
cm02NCBhbGxtb2Rjb25maWcNCj4gPiA+ID4gbWFrZSAtajggQVJDSD1hcm02NCBDUk9TU19DT01Q
SUxFPWFhcmNoNjQtbGludXgtZ251LSBXPTEgLyBtYWtlDQo+ID4gPiA+IC1qOA0KPiA+ID4gQVJD
SD1hcm02NCBDUk9TU19DT01QSUxFPWFhcmNoNjQtbGludXgtZ251LSBXPTIgLyBtYWtlIC1qOA0K
PiA+ID4gQVJDSD1hcm02NCBDUk9TU19DT01QSUxFPWFhcmNoNjQtbGludXgtZ251LSBXPTMNCj4g
PiA+ID4NCj4gPiA+ID4gSSBzYXcgbWFueSB1bnJlbGF0ZWQgd2FybmluZ3MuLi4NCj4gPiA+DQo+
ID4gPiBUaGVuIGl0IGNvdWxkIGJlIHNwYXJzZS4gSW5zdGFsbCBzcGFyc2UgYW5kIHVzZSBDPTEu
DQo+ID4NCj4gPiBBZnRlciBhcHBseWluZyB0aGUgcGF0Y2ggIzIsIEkgdHJpZWQgdG8gdXNlIEM9
MSB5ZXN0ZXJkYXksIEkgZG91YmxlIGNoZWNrIGl0DQo+IHRvZGF5LCBzdGlsbCBubyB3YXJuaW5n
cy4gQW55dGhpbmcgSSBtaXNzaW5nPw0KPiA+DQo+ID4gJCBtYWtlIC1qOCBBUkNIPWFybTY0IENS
T1NTX0NPTVBJTEU9YWFyY2g2NC1saW51eC1nbnUtIFc9MSxDPTENCj4gPiAgIENBTEwgICAgc2Ny
aXB0cy9hdG9taWMvY2hlY2stYXRvbWljcy5zaA0KPiA+ICAgQ0FMTCAgICBzY3JpcHRzL2NoZWNr
c3lzY2FsbHMuc2gNCj4gPiAgIENISyAgICAgaW5jbHVkZS9nZW5lcmF0ZWQvY29tcGlsZS5oDQo+
ID4gICBDSEsgICAgIGtlcm5lbC9raGVhZGVyc19kYXRhLnRhci54eg0KPiA+ICAgQ0MgW01dICBk
cml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4ubw0KPiA+ICAgTEQgW01dICBk
cml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjLm8NCj4gPiAgIE1PRFBPU1QgbW9kdWxl
cy1vbmx5LnN5bXZlcnMNCj4gPiAgIEdFTiAgICAgTW9kdWxlLnN5bXZlcnMNCj4gPiAgIENDIFtN
XSAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlYy5tb2Qubw0KPiA+ICAgTEQgW01d
ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjLmtvDQo+ID4NCj4gPiBCZXN0IFJl
Z2FyZHMsDQo+ID4gSm9ha2ltIFpoYW5nDQo+ID4gPiAgICAgIEFuZHJldw0KPiANCj4gDQo+IElm
IHlvdSBsb29rIGF0DQo+IGh0dHBzOi8vZXVyMDEuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9v
ay5jb20vP3VybD1odHRwcyUzQSUyRiUyRnBhdGNodw0KPiBvcmsuaG9wdG8ub3JnJTJGc3RhdGlj
JTJGbmlwYSUyRjQ5ODcyOSUyRjEyMzE1MjExJTJGYnVpbGRfMzJiaXQlMkZzdA0KPiBkb3V0JmFt
cDtkYXRhPTA0JTdDMDElN0NxaWFuZ3FpbmcuemhhbmclNDBueHAuY29tJTdDZTk2Njg4MmFmZjE1
DQo+IDQxZWQ1NGMxMDhkOTMxOTA2YWQyJTdDNjg2ZWExZDNiYzJiNGM2ZmE5MmNkOTljNWMzMDE2
MzUlN0MwJTdDMA0KPiAlN0M2Mzc1OTUzMTg2MTA0NTgzNzklN0NVbmtub3duJTdDVFdGcGJHWnNi
M2Q4ZXlKV0lqb2lNQzR3TGpBDQo+IHdNREFpTENKUUlqb2lWMmx1TXpJaUxDSkJUaUk2SWsxaGFX
d2lMQ0pYVkNJNk1uMCUzRCU3QzEwMDAmYW1wO3MNCj4gZGF0YT0wbzM0aTZwa3ZxQk4xaFBBcHo1
SmE4Q0hqdHFuOGl3UUI4d2h4ZzBwOFJ3JTNEJmFtcDtyZXNlcnZlZA0KPiA9MA0KPiANCj4geW91
IHNlZToNCj4gDQo+IEtlcm5lbDogYXJjaC94ODYvYm9vdC9iekltYWdlIGlzIHJlYWR5ICAoIzkz
OTYpDQo+IA0KPiBTbyBpdCBpcyBidWlsZGluZyBmb3IgMzIgYml0IHg4Ni4gU28gdHJ5DQo+IA0K
PiBtYWtlIC1qOCBBUkNIPWkzODYgVz0xIEM9MQ0KPiANCj4gQXNzdW1pbmcgeW91ciBob3N0IGlz
IGFuIHg4NiBtYWNoaW5lLg0KDQpNdWNoIHRoYW5rcy4NCg0KJCBnaXQgYW0gMDAwMi1uZXQtZmVj
LWFkZC1uZG9fc2VsZWN0X3F1ZXVlLXRvLWZpeC1UWC1iYW5kd2lkdGgtZmx1LnBhdGNoDQpBcHBs
eWluZzogbmV0OiBmZWM6IGFkZCBuZG9fc2VsZWN0X3F1ZXVlIHRvIGZpeCBUWCBiYW5kd2lkdGgg
Zmx1Y3R1YXRpb25zDQokIG1ha2UgLWo4IEFSQ0g9aTM4NiBXPTEsQz0xDQogIENBTEwgICAgc2Ny
aXB0cy9hdG9taWMvY2hlY2stYXRvbWljcy5zaA0KICBDQUxMICAgIHNjcmlwdHMvY2hlY2tzeXNj
YWxscy5zaA0KICBDSEsgICAgIGluY2x1ZGUvZ2VuZXJhdGVkL2NvbXBpbGUuaA0KICBDSEsgICAg
IGtlcm5lbC9raGVhZGVyc19kYXRhLnRhci54eg0KICBDQyBbTV0gIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5vDQogIExEIFtNXSAgZHJpdmVycy9uZXQvZXRoZXJuZXQv
ZnJlZXNjYWxlL2ZlYy5vDQogIE1PRFBPU1QgbW9kdWxlcy1vbmx5LnN5bXZlcnMNCktlcm5lbDog
YXJjaC94ODYvYm9vdC9iekltYWdlIGlzIHJlYWR5ICAoIzEpDQogIEdFTiAgICAgTW9kdWxlLnN5
bXZlcnMNCiAgQ0MgW01dICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjLm1vZC5v
DQogIExEIFtNXSAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlYy5rbw0KDQpVbmZv
cnR1bmF0ZWx5LCBJIHN0aWxsIGNhbid0IHNlZSB3YXJuaW5ncyBhZnRlciBjaGFuZ2luZyB0byBi
dWlsZCB4ODYgaW1hZ2UsIGEgc3RyYW5nZSBwaGVub21lbm9uLCAiVz0xIEM9MSIgc2VlbXMgbm90
IHdvcmssICJXPTEsQz0xIiBjYW4gd29yay4NCkkgYWxzbyBzYXZlIGFsbCBvZiB0aGUgYnVpbGQg
bG9ncyB0byBkb3VibGUgY2hlY2ssIHRoZXJlIGlzIG5vIGJ1aWxkIHdhcm5pbmdzIHJlbGF0ZWQg
dG8gRkVDIGRyaXZlci4gDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiAJIEFuZHJl
dw0K
