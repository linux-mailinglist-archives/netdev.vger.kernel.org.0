Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3214D42BC9B
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 12:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239283AbhJMKVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 06:21:08 -0400
Received: from mail-eopbgr140103.outbound.protection.outlook.com ([40.107.14.103]:31335
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239259AbhJMKVH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 06:21:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X2osbkvY64gD1fRxLqddqMmWEm7+XWwmazzXCdUzD61c/OFZ74cxSiNWXe96o8VYlJKkPm08+5hyJSq9So5pH7wLkltiryJ6HBJR2LYN1mHrjE0GWMo3ZuEXaqGdfJMWdjVoNPcpsnvDb0+ApDUAS+ipqg3q8w8M26+Ofm3OkQqfHQX0R5REl/aUiWNnBH6uZb7EsOI8Hc088uxJehLF8iV0+K/f2Ya22uKgNMQIDKmipS9B6W3f3s8kkTe7nZBm58o2mSM16Kur1wg6Y7Ts+GXll4nqoccnt7l6IASIArbjg+FN3eg67DzE1ZJCGy68KJoBr4JjaWjx4YfzKB/eVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5XGFW2nLsanjnc+9+vZnWo6nhvsufbtQSK+H9qwEGuc=;
 b=VrOcalohxKcduS4cqNrHLSEujiLrJw7VwB2mbIcfqtDSpfdqbFqrN0pP73A0Cdt5lYS0EvkJjMspTPIQThh70zvogjCt9gAZBIibt9/MzDhnUWt7/lyF7JQsnXAG3lkYqAFB3m9AOJ6dDBYatURe3aMZ/W5zqilVNHHl2nw8ocRJ/1bxqTsczYTMIvmoPGPQcaezlmIYvFlVuy9P0l/c3JWUO/EeAFLtvTE4E0vF/8JSNk3FKHFP3lboYADF3mEfI6NkvxHCooDclFUz58njSgQi3V38ZHJaYpEtqf3qPgfvEx65nyFsyBawVFsHiyYq40R0f38Y37DCKBXlJR8TWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5XGFW2nLsanjnc+9+vZnWo6nhvsufbtQSK+H9qwEGuc=;
 b=LnD36QQjnoVzCnyS174RyKDbYLp4JJ/p+twFNSSUfAdJvJnX5oyr2faOXJafsF3zblr7jpqB0J5jSY5QdfGzxcRkh2tB4xmHllemJTZPxKQzIiaNjmJq6i/PEB4U4orKOGkyQ0ctRmbJMZUSJEkIbnMcwqHdJJ6IIUXKPHpd96w=
Received: from VE1PR05MB7278.eurprd05.prod.outlook.com (2603:10a6:800:1a5::23)
 by VI1PR05MB4717.eurprd05.prod.outlook.com (2603:10a6:802:60::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Wed, 13 Oct
 2021 10:19:00 +0000
Received: from VE1PR05MB7278.eurprd05.prod.outlook.com
 ([fe80::2853:2c91:4f51:5bdf]) by VE1PR05MB7278.eurprd05.prod.outlook.com
 ([fe80::2853:2c91:4f51:5bdf%5]) with mapi id 15.20.4587.027; Wed, 13 Oct 2021
 10:18:59 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     "matthias.schiffer@ew.tq-group.com" 
        <matthias.schiffer@ew.tq-group.com>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH] net: phy: micrel: make *-skew-ps check more lenient
Thread-Topic: [PATCH] net: phy: micrel: make *-skew-ps check more lenient
Thread-Index: AQHXv1TGDKMf7QJb+0yUIu55DbbWE6vQmTIAgAAFuYCAABnjAA==
Date:   Wed, 13 Oct 2021 10:18:59 +0000
Message-ID: <bf2c71d5f73839bdc585c19490e40d08f26d644a.camel@toradex.com>
References: <20211012103402.21438-1-matthias.schiffer@ew.tq-group.com>
         <45137d2d365d5737f36fa398ee815695722b04e5.camel@toradex.com>
         <987224f4ca93f928c8ddb69710d3aa72b336b6dc.camel@ew.tq-group.com>
In-Reply-To: <987224f4ca93f928c8ddb69710d3aa72b336b6dc.camel@ew.tq-group.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 
authentication-results: ew.tq-group.com; dkim=none (message not signed)
 header.d=none;ew.tq-group.com; dmarc=none action=none
 header.from=toradex.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54b7822c-ab4f-4e6d-6b30-08d98e32df89
x-ms-traffictypediagnostic: VI1PR05MB4717:
x-microsoft-antispam-prvs: <VI1PR05MB4717922095F21D2E9C7CD74AF4B79@VI1PR05MB4717.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QlFckhob7cLyEv7E3FaEw4CkXjTEOF3/UXWze4DtMkYGWc19faX4zOOzwuIvNbAzEbJmPBUiX0TTBJ31TLw1oCIL+lWOC97tGvS6ijKpwLD76A6Apmh9ygx3NmDN3RlyGHCMpc77YMQ42O5EiIDT+Zigaqpl0nUHUZIQSfq7pDv/zWIlwiKSmElETCrEXhD+9582504Ht6ESgbOzeXOAo6YaiMHGYbXAbd0E2dN4vnrrMQFFfFWg5UJXIDQfaqsRphJ0jTwVq1ppfTm0GcM5DSmAJ5yI4SZzoASqtqAU+ZMSAve97/5q5+SXFqq4uuP2CniOqJrCgQAta8W9fATZVvOv2/VRcluxMaQEo7PM98TX/lIrqVWI3vQvgb+JdH5q0nCf4ElqKOaewsAw8lQWF6UMcP9NJMv2FpnC65VKMcKztbFfx4qYO9WGhFAuvYq6e7DngsuJrXHXqUJgxg6dour16b7BeGW7RZ0simrMa27DN9lSWUxyWJS2ggVRjOEI6HuVqrpKgou94kZkMC37yI7witXJx8WKS22JLmsdOKz//PvLz7wCSHXI7nAy2gnAPh0O+G4/FzOH+XDUdwwq6eduRkatqbRYLxCSO8+/MjvGsC8Mc4hF+9sNrJJdFhZ1tV0OBZ73oZ51TM+b245CAoRE7T740xWjPEaqyk5Qt7OzQkqnvNlK830FE4Cb/84DzSKTyw/AjJ+BXnmwFqSQXBVB28trqsdEjH3xHcymm+Ft55J+OWaMfVmCo4Gi2TZ6XZMgPsJwIVkRhSox5P3fifgrwdkpFm9+NDQE9qbDtCw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR05MB7278.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(39850400004)(396003)(346002)(2616005)(26005)(8676002)(6916009)(186003)(66556008)(66476007)(76116006)(91956017)(36756003)(4001150100001)(66446008)(64756008)(122000001)(6512007)(38070700005)(5660300002)(508600001)(66946007)(6486002)(83380400001)(54906003)(6506007)(8936002)(4326008)(966005)(38100700002)(71200400001)(44832011)(316002)(2906002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGFSVGlmWEo2NzJmOWVOQlJQT04xOWlGUkxqUzc5eE1CQmFFQXJJRERZaVNV?=
 =?utf-8?B?b3ZTTUQwZzFHWjdtSkNHMzJGcThIMXBDZ1M0OEF5dXE5TnlYdVd4WG0vbmNT?=
 =?utf-8?B?UGdTcVFMWk9pUTNaMHpLeXIvdUs3WkVubDdydkowcUpBK3l2ZU9SY1RySExY?=
 =?utf-8?B?MDNSdHBEUWNPQ294RmNLN2orblg0WmxRdWJvTitaVU9oQUp6dVgvc1VwaG1X?=
 =?utf-8?B?ZnRIWmxVYjlJaTNXbGFrMEdMUUs1S1lORTVDMWdYRjI4NHRMMGZjc3h2YUhk?=
 =?utf-8?B?dVp1TzFDc1haVXlJK2UvQ3c3Zjh5UmxwVmphemhpVllVRTA1czNQckdwcGhR?=
 =?utf-8?B?S0hGNTRwNWFobFRmRmxjSnJYRVZxdVB4M2xiSHpEQkYxSWJaM3Qzd1g3K09S?=
 =?utf-8?B?RisrUGJHRkFQOHprMXZIN29FR2ZYNWVqcklVV3dXLzNPN284Y0hUNEFSdFRQ?=
 =?utf-8?B?THhzL3FFdS93VVhIektOWTNwaU9TR0U1alZUWjd4V3VoMnptWXhLYlRPcVpD?=
 =?utf-8?B?REozcStaaytDVzZLUW1oT3FrU2dER0ZwemFVQnVMSTQyajhPVmpvc0R4RDc1?=
 =?utf-8?B?V0d4TUg2QUhBUjcrWGxzVkQ3WFBMNUROUzN4YkRhMDYvcUgvYUpRUnVkYVlQ?=
 =?utf-8?B?UFQ2Mzk0enFOaVZzN0VNQkZlQUNCSy9ZNE1KcWpQMjlMUklTa2c3RFkxaVZn?=
 =?utf-8?B?M0ViRGR5N2h4a0hPTm5zWDUxenRPaG8xUzI2a3ZGQ2J2cVlKazdNVmJpM1BR?=
 =?utf-8?B?bTBuR29VOEN0YXdJSmMxUEprNkl3VVJyZVBMYm44Yk1naE9Rdy9TQkx5OHo3?=
 =?utf-8?B?TjA1RTJDUis0cnluMmpQVjEzbnZ0VEhGWUEzRXRZNm1MSzloNDVJNzA2c0tE?=
 =?utf-8?B?c1E0aU5Yc2NHSnFRMTBOMTVWN2swZnJPN0ZIcFVCdHpTK29iL20yeGFqaXlk?=
 =?utf-8?B?MmNBKzlOMFBMMFI1K1FxUElNN0dBWXZUT291bVZ2RzZ5THJnZEZZMWpBU20x?=
 =?utf-8?B?dDN2eU1kN1pPSXQ5MzZVclF6T1Z0YXdiMllLeUtkeUJGVm9UdjBTN2RLbFI4?=
 =?utf-8?B?ZnUyTzF1eGRMNjlQYjlTNHRBOEE2cCtvUFNteHFLNjVQZFBpb2h6ZFpRbWJp?=
 =?utf-8?B?dXhtTUVkUC9WcWp2aiswVm1JMXA1UjJkS3FKZ2Fwd3NFNC9QY0JjaXExR2Yr?=
 =?utf-8?B?UmNNR01rVElRMTlrNFBnemltWDVWRFBXbzMwUzNJRG5ONVJUdjBySC9LdmFY?=
 =?utf-8?B?aCs5ZDN0elJMMUZSL1FmV3p4dFN4TnB2MlRLTmdNY3JNSzVzRjI0SFl2RDFY?=
 =?utf-8?B?QUNaMFBSc0Q4OWlpUUV5ZU8xQ1V0M0pZMHpQaEI5YlFiY09RbUk5b1RReVJh?=
 =?utf-8?B?T2dYdVcxVFRzYXNvdlB5YUcrT0VlRWQ1Nkx5WEpJWXZ2YVE4ekV6OHZPWHZG?=
 =?utf-8?B?amF0YzhrQy83aW9uR2JSKzZyLy9PS0wwa1R2ekdoS29PVGdldkpwOXg3ZTVm?=
 =?utf-8?B?QkZHQkR2K05pRm9qcExPSDE5aEszVElHWkhFYkl4R3dzOHhYcVFDYyt3Mjlk?=
 =?utf-8?B?LzdNZEMxbDVuTHFQNWdXaEVBaWs1aEQ0YmlXVUQ0ODZxSk5wYS9CbURJZnpB?=
 =?utf-8?B?cGRlOFRoUklMRGl3c25CMWhMSURKdXBMb0ZhRFRQL2J1SkNUQkw5RGdIbFhv?=
 =?utf-8?B?M0ZyaHdoVXRBTmxDc2ZBRGdSVVRWL1VkMkFBNDlETi8veXVNUy9YUWNTcEpu?=
 =?utf-8?Q?w9VJPURqabIdaTH1+3mnwV+xdyLwH8tDfTwsI/w?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C6A676246C36454CA6C77335BD0CB767@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR05MB7278.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54b7822c-ab4f-4e6d-6b30-08d98e32df89
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 10:18:59.8145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HrkzMTOY8sPb6M06k+KNqbMnL6NjwcaEBVfLOVuqHMD1xnF4UiigwEPOQdntDqNLO5EyIQv868AezL/psxAv7UlYcrPmbh7DXf45ROUPZBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4717
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTEwLTEzIGF0IDEwOjQ2ICswMjAwLCBNYXR0aGlhcyBTY2hpZmZlciB3cm90
ZToNCj4gT24gV2VkLCAyMDIxLTEwLTEzIGF0IDA4OjI1ICswMDAwLCBQaGlsaXBwZSBTY2hlbmtl
ciB3cm90ZToNCj4gPiBPbiBUdWUsIDIwMjEtMTAtMTIgYXQgMTI6MzQgKzAyMDAsIE1hdHRoaWFz
IFNjaGlmZmVyIHdyb3RlOg0KPiA+ID4gSXQgc2VlbXMgcmVhc29uYWJsZSB0byBmaW5lLXR1bmUg
b25seSBzb21lIG9mIHRoZSBza2V3IHZhbHVlcyB3aGVuDQo+ID4gPiB1c2luZw0KPiA+ID4gb25l
IG9mIHRoZSByZ21paS0qaWQgUEhZIG1vZGVzLCBhbmQgZXZlbiB3aGVuIGFsbCBza2V3IHZhbHVl
cyBhcmUNCj4gPiA+IHNwZWNpZmllZCwgdXNpbmcgdGhlIGNvcnJlY3QgSUQgUEhZIG1vZGUgbWFr
ZXMgc2Vuc2UgZm9yDQo+ID4gPiBkb2N1bWVudGF0aW9uDQo+ID4gPiBwdXJwb3Nlcy4gU3VjaCBh
IGNvbmZpZ3VyYXRpb24gYWxzbyBhcHBlYXJzIGluIHRoZSBiaW5kaW5nIGRvY3MgaW4NCj4gPiA+
IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWljcmVsLWtzejkweDEudHh0
LCBzbyB0aGUNCj4gPiA+IGRyaXZlcg0KPiA+ID4gc2hvdWxkIG5vdCB3YXJuIGFib3V0IGl0Lg0K
PiA+IA0KPiA+IEkgZG9uJ3QgdGhpbmsgeW91ciBjb21taXQgbWVzc2FnZSBpcyByaWdodC4gVGhl
IHJnbWlpLSppZCBQSFkgbW9kZXMNCj4gPiBhcmUNCj4gPiBubyBsb25nZXIganVzdCBmb3IgZG9j
dW1lbnRhdGlvbiBwdXJwb3NlcyBvbiBLU1o5MDMxIFBIWS4gVGhleSBhcmUNCj4gPiB1c2VkDQo+
ID4gdG8gc2V0IHRoZSBza2V3LXJlZ2lzdGVycyBhY2NvcmRpbmcgdG8gLg0KPiANCj4gWWVzLCB0
aGlzIHdhcyBpbXBsZW1lbnRlZCBpbiBbMV0uIFRoZSBjb21taXQgbWVzc2FnZSBleHBsaWNpdGx5
IHN0YXRlcw0KPiB0aGF0IGZpbmUtdHVuaW5nIGlzIHN0aWxsIHBvc3NpYmxlIHVzaW5nICotc2tl
dy1wcy4NCj4gDQo+ID4gDQo+ID4gVGhlIHdhcm5pbmcgaXMgdGhlcmUsIHRoYXQgaW4gY2FzZSB5
b3Ugb3ZlcnJpZGUgdGhlIHNrZXcgcmVnaXN0ZXJzDQo+ID4gb2YNCj4gPiBvbmUgb2YgdGhlIG1v
ZGVzIHJnbWlpLWlkLCByZ21paS10eGlkLCByZ21paS1yeGlkIHdpdGggKi1za2V3LXBzDQo+ID4g
c2V0dGluZ3MgaW4gRFQuDQo+IA0KPiBUaGUgInJnbWlpIiBtb2RlIHNob3VsZCBub3QgYmUgaGFu
ZGxlZCBkaWZmZXJlbnRseSBmcm9tICJyZ21paS0qaWQiIGluDQo+IG15IG9waW5pb24uIE90aGVy
d2lzZSBmb3IgYSBkZXZpY2UgdGhhdCBpcyBiYXNpY2FsbHkgInJnbWlpLWlkIiwgYnV0DQo+IHJl
cXVpcmVzIHNsaWdodCBmaW5lLXR1bmluZywgeW91IGhhdmUgdG8gc2V0IHRoZSBtb2RlIHRvIHRo
ZSBpbmNvcnJlY3QNCj4gdmFsdWUgInJnbWlpIiBpbiB0aGUgRFRTIHRvIGF2b2lkIHRoaXMgd2Fy
bmluZy4NCg0KTm93IEkgaGF2ZSB1bmRlcnN0b29kIHlvdXIgYXJndW1lbnQuIEJ1dCB0aGVuIEkg
c3VnZ2VzdCB0byBkZWxldGUgdGhlDQp3YXJuaW5nIGVudGlyZWx5IGFzIGl0IGNvbXBsZXRlbHkg
Y2hhbmdlcyBpdHMgbWVhbmluZyB3aXRoIHRoYXQgcGF0Y2guDQoNClBoaWxpcHBlDQoNCj4gDQo+
IA0KPiA+IA0KPiA+IFRoZXJlZm9yZSBJIGFsc28gdGhpbmsgdGhlIHdhcm5pbmcgaXMgdmFsdWFi
bGUgYW5kIHNob3VsZCBiZSBrZXB0Lg0KPiA+IFdlDQo+ID4gbWF5IHdhbnQgdG8gcmV3b3JkIGl0
IHRob3VnaC4NCj4gPiANCj4gPiBQaGlsaXBwZQ0KPiANCj4gWzFdDQo+IGh0dHBzOi8vZ2l0Lmtl
cm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC9jb21t
aXQvZHJpdmVycy9uZXQvcGh5L21pY3JlbC5jP2lkPWJjZjM0NDBjNmRkNzhiZmU1ODM2ZWMwOTkw
ZmUzNmQ3YjRiYjdkMjANCj4gDQo+IA0KPiA+IA0KPiA+ID4gDQo+ID4gPiBTaWduZWQtb2ZmLWJ5
OiBNYXR0aGlhcyBTY2hpZmZlcg0KPiA+ID4gPG1hdHRoaWFzLnNjaGlmZmVyQGV3LnRxLWdyb3Vw
LmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gwqBkcml2ZXJzL25ldC9waHkvbWljcmVsLmMgfCA0ICsr
LS0NCj4gPiA+IMKgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMo
LSkNCj4gPiA+IA0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3BoeS9taWNyZWwuYyBi
L2RyaXZlcnMvbmV0L3BoeS9taWNyZWwuYw0KPiA+ID4gaW5kZXggYzMzMGE1YTlmNjY1Li4wM2U1
OGViZjY4YWYgMTAwNjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC9waHkvbWljcmVsLmMNCj4g
PiA+ICsrKyBiL2RyaXZlcnMvbmV0L3BoeS9taWNyZWwuYw0KPiA+ID4gQEAgLTg2Myw5ICs4NjMs
OSBAQCBzdGF0aWMgaW50IGtzejkwMzFfY29uZmlnX2luaXQoc3RydWN0DQo+ID4gPiBwaHlfZGV2
aWNlDQo+ID4gPiAqcGh5ZGV2KQ0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgTUlJX0tTWjkwMzFSTl9UWF9EQVRBX1BB
RF9TS0VXLCA0LA0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdHhfZGF0YV9za2V3cywgNCwgJnVwZGF0ZSk7DQo+ID4g
PiDCoA0KPiA+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKHVwZGF0ZSAmJiBw
aHlkZXYtPmludGVyZmFjZSAhPQ0KPiA+ID4gUEhZX0lOVEVSRkFDRV9NT0RFX1JHTUlJKQ0KPiA+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKHVwZGF0ZSAmJiAhcGh5X2ludGVy
ZmFjZV9pc19yZ21paShwaHlkZXYpKQ0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBwaHlkZXZfd2FybihwaHlkZXYsDQo+ID4gPiAtwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgIiotc2tldy1wcyB2YWx1ZXMgc2hvdWxkIGJlDQo+ID4gPiB1c2VkDQo+ID4gPiBvbmx5IHdp
dGggcGh5LW1vZGUgPSBcInJnbWlpXCJcbiIpOw0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICIqLXNrZXct
cHMgdmFsdWVzIHNob3VsZCBiZQ0KPiA+ID4gdXNlZA0KPiA+ID4gb25seSB3aXRoIFJHTUlJIFBI
WSBtb2Rlc1xuIik7DQo+ID4gPiDCoA0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIC8qIFNpbGljb24gRXJyYXRhIFNoZWV0IChEUzgwMDAwNjkxRCBvcg0KPiA+ID4gRFM4MDAw
MDY5MkQpOg0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBXaGVuIHRo
ZSBkZXZpY2UgbGlua3MgaW4gdGhlIDEwMDBCQVNFLVQgc2xhdmUNCj4gPiA+IG1vZGUNCj4gPiA+
IG9ubHksDQo+ID4gDQo+ID4gDQo+IA0KDQo=
